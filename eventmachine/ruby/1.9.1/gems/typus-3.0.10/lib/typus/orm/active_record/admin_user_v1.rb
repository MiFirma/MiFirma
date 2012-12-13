require 'typus/orm/active_record/user/instance_methods'

module Typus
  module Orm
    module ActiveRecord
      module AdminUserV1

        module ClassMethods

          def enable_as_typus_user

            attr_accessor :password
            attr_protected :status

            validates :email,
                      :presence => true,
                      :uniqueness => true,
                      :format => { :with => Typus::Regex::Email }

            validates :password,
                      :confirmation => { :if => :password_required? },
                      :presence => { :if => :password_required? }

            validates_length_of :password, :within => 6..40, :if => :password_required?

            validates :role, :presence => true

            before_save :initialize_salt, :encrypt_password, :initialize_token

            serialize :preferences

            def authenticate(email, password)
              user = find_by_email_and_status(email, true)
              user && user.authenticated?(password) ? user : nil
            end

            def generate(*args)
              options = args.extract_options!
              options[:password] ||= ActiveSupport::SecureRandom.hex(4)
              options[:role] ||= Typus.master_role
              new :email => options[:email], :password => options[:password], :role => options[:role]
            end

            include InstanceMethods
            include Typus::Orm::ActiveRecord::User::InstanceMethods

          end

        end

        module InstanceMethods

          def authenticated?(password)
            crypted_password == encrypt(password)
          end

          protected

          def generate_hash(string)
            Digest::SHA1.hexdigest(string)
          end

          def encrypt_password
            return if password.blank?
            self.crypted_password = encrypt(password)
          end

          def encrypt(string)
            generate_hash("--#{salt}--#{string}--")
          end

          def initialize_salt
            self.salt = generate_hash("--#{Time.zone.now.to_s(:number)}--#{email}--") if new_record?
          end

          def initialize_token
            generate_token if new_record?
          end

          def generate_token
            self.token = encrypt("--#{Time.zone.now.to_s(:number)}--#{password}--").first(12)
          end

          def password_required?
            crypted_password.blank? || !password.blank?
          end

        end

      end
    end
  end
end
