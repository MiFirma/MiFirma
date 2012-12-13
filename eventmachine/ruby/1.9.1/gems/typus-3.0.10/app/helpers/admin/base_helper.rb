module Admin
  module BaseHelper

    def title(page_title)
      content_for(:title) { page_title }
    end

    def header
      render "admin/helpers/base/header"
    end

    def has_root_path?
      Rails.application.routes.routes.map(&:name).include?("root")
    end

    def apps
      render "admin/helpers/base/apps"
    end

    def login_info
      unless admin_user.is_a?(FakeUser)
        render "admin/helpers/base/login_info"
      end
    end

    def admin_sign_out_path
      case Typus.authentication
      when :devise
        send("destroy_#{Typus.user_class_name.underscore}_session")
      else
        destroy_admin_session_path
      end
    end

    def display_flash_message(message = flash)
      if message.compact.any?
        render "admin/helpers/base/flash_message",
               :flash_type => message.keys.first,
               :message => message
      end
    end

  end
end
