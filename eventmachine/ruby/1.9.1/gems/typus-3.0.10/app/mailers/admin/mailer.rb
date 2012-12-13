class Admin::Mailer < ActionMailer::Base

  default :from => Typus.mailer_sender

  def reset_password_link(user, url)
    @user = user
    @url = url

    mail :to => user.email,
         :subject => "[#{Typus.admin_title}] #{Typus::I18n.t("Reset password")}"
  end

end
