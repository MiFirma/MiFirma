class TypusController < ApplicationController

  skip_filter filter_chain

  unloadable

  layout :select_layout

  include Typus::Authentication
  include Typus::QuickEdit
  include Typus::Preferences
  include Typus::Reloader

  if Typus::Configuration.options[:ssl]
    include SslRequirement
    ssl_required :sign_in, :sign_out, 
                 :dashboard, 
                 :recover_password, :reset_password
  end

  filter_parameter_logging :password

  before_filter :verify_typus_users_table_schema

  before_filter :reload_config_et_roles
  before_filter :require_login, 
                :except => [ :sign_up, :sign_in, :sign_out, 
                             :recover_password, :reset_password, 
                             :quick_edit ]

  before_filter :check_if_user_can_perform_action_on_resource_without_model, 
                :except => [ :sign_up, :sign_in, :sign_out, 
                             :dashboard, 
                             :recover_password, :reset_password, 
                             :quick_edit ]

  before_filter :recover_password_disabled?, 
                :only => [ :recover_password, :reset_password ]

  def dashboard
    begin
      I18n.locale = @current_user.preferences[:locale]
      flash[:notice] = _("There are not defined applications in config/typus/*.yml.") if Typus.applications.empty?
    rescue
      @current_user.update_attributes :preferences => { :locale => Typus::Configuration.options[:default_locale] }
      retry
    end
  end

  def sign_in

    redirect_to admin_sign_up_path and return if Typus.user_class.count.zero?

    if request.post?
      if user = Typus.user_class.authenticate(params[:typus_user][:email], params[:typus_user][:password])
        session[:typus_user_id] = user.id
        redirect_to params[:back_to] || admin_dashboard_path
      else
        flash[:error] = _("The email and/or password you entered is invalid.")
        redirect_to admin_sign_in_path
      end
    end

  end

  def sign_out
    session[:typus_user_id] = nil
    redirect_to admin_sign_in_path
  end

  def recover_password
    if request.post?
      if user = Typus.user_class.find_by_email(params[:typus_user][:email])
        url = admin_reset_password_url(:token => user.token)
        TypusMailer.deliver_reset_password_link(user, url)
        flash[:success] = _("Password recovery link sent to your email.")
        redirect_to admin_sign_in_path
      else
        redirect_to admin_recover_password_path
      end
    end
  end

  ##
  # Available if Typus::Configuration.options[:email] is set.
  #
  def reset_password
    @typus_user = Typus.user_class.find_by_token!(params[:token])
    if request.post?
      @typus_user.password = params[:typus_user][:password]
      @typus_user.password_confirmation = params[:typus_user][:password_confirmation]
      if !params[:typus_user][:password].blank? && @typus_user.save
        session[:typus_user_id] = @typus_user.id
        redirect_to admin_dashboard_path
      else
        render :action => 'reset_password'
      end
    end
  end

  def sign_up

    redirect_to admin_sign_in_path and return unless Typus.user_class.count.zero?

    if request.post?

      password = 'columbia'

      user = Typus.user_class.generate(:email => params[:typus_user][:email], 
                                       :password => password, 
                                       :role => Typus::Configuration.options[:root])
      user.status = true

      if user.save
        session[:typus_user_id] = user.id
        flash[:notice] = _("Password set to \"{{password}}\".", :password => password)
        redirect_to admin_dashboard_path
      else
        flash[:error] = _("That doesn't seem like a valid email address.")
      end

    else

      flash[:notice] = _("Enter your email below to create the first user.")

    end

  end

private

  # TODO: Try to move schema verification to Typus.boot!
  def verify_typus_users_table_schema

    attributes = Typus.user_class.model_fields.keys

    generator = if !attributes.include?(:role) then 'typus_update_schema_to_01'
                elsif !attributes.include?(:preferences) then 'typus_update_schema_to_02'
                end

    if generator
      raise "Run `script/generate #{generator} -f && rake db:migrate` to update database schema."
    end

  end

  def recover_password_disabled?
    redirect_to admin_sign_in_path unless Typus::Configuration.options[:email]
  end

  def select_layout
    %w( sign_up sign_in sign_out recover_password reset_password ).include?(action_name) ? 'typus' : 'admin'
  end

end