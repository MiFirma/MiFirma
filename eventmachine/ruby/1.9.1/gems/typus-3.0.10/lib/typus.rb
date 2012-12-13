# -*- encoding: utf-8 -*-

require "support/active_record"
require "support/hash"
require "support/object"
require "support/string"

require "typus/engine"
require "typus/orm/base"
require "typus/orm/active_record"
require "typus/regex"
require "typus/version"

require "render_inheritable"
require "will_paginate"

autoload :FakeUser, "support/fake_user"

module Typus

  autoload :Configuration, "typus/configuration"
  autoload :I18n, "typus/i18n"
  autoload :Resources, "typus/resources"

  module Controller
    autoload :Actions, "typus/controller/actions"
    autoload :Associations, "typus/controller/associations"
    autoload :Autocomplete, "typus/controller/autocomplete"
    autoload :Filters, "typus/controller/filters"
    autoload :Format, "typus/controller/format"
  end

  module Authentication
    autoload :Base, "typus/authentication/base"
    autoload :None, "typus/authentication/none"
    autoload :HttpBasic, "typus/authentication/http_basic"
    autoload :Session, "typus/authentication/session"
  end

  mattr_accessor :autocomplete
  @@autocomplete = 100

  mattr_accessor :admin_title
  @@admin_title = "Typus"

  mattr_accessor :admin_sub_title
  @@admin_sub_title = <<-CODE
<a href="http://core.typuscms.com/">typus</a> by <a href="http://intraducibles.com">intraducibles.com</a>
  CODE

  ##
  # Available Authentication Mechanisms are:
  #
  # - none
  # - basic: Uses http authentication
  # - session
  #
  mattr_accessor :authentication
  @@authentication = :none

  mattr_accessor :config_folder
  @@config_folder = "config/typus"

  mattr_accessor :username
  @@username = "admin"

  ##
  # Pagination options
  #
  mattr_accessor :pagination
  @@pagination = { :previous_label => "&larr; " + Typus::I18n.t("Previous"),
                   :next_label => Typus::I18n.t("Next") + " &rarr;" }

  ##
  # Define a password.
  #
  # Used as default password for http and advanced authentication.
  #
  mattr_accessor :password
  @@password = "columbia"

  ##
  # Configure the e-mail address which will be shown in Admin::Mailer. If not
  # set `forgot_password` feature is disabled.
  #
  mattr_accessor :mailer_sender
  @@mailer_sender = nil

  ##
  # Define `paperclip` attachment styles.
  #

  mattr_accessor :file_preview
  @@file_preview = :medium

  mattr_accessor :file_thumbnail
  @@file_thumbnail = :thumb

  ##
  # Define `dragonfly` attachment styles.
  #

  mattr_accessor :image_preview_size
  @@image_preview_size = 'x450'

  mattr_accessor :image_thumb_size
  @@image_thumb_size = '150x150#'

  ##
  # Defines the default relationship table.
  #
  mattr_accessor :relationship
  @@relationship = "typus_users"

  mattr_accessor :master_role
  @@master_role = "admin"

  mattr_accessor :user_class_name
  @@user_class_name = "TypusUser"

  mattr_accessor :user_fk
  @@user_fk = "typus_user_id"

  class << self

    # Default way to setup typus. Run `rails generate typus` to create a fresh
    # initializer with all configuration values.
    def setup
      yield self
      reload!
    end

    def applications
      Typus::Configuration.config.map { |i| i.last["application"] }.compact.uniq.sort
    end

    # Lists modules of an application.
    def application(name)
      Typus::Configuration.config.map { |i| i.first if i.last["application"] == name }.compact.uniq.sort
    end

    # Lists models from the configuration file.
    def models
      if config = Typus::Configuration.config
        config.map { |i| i.first }.sort
      else
        []
      end
    end

    # Lists resources, which are tableless models.
    def resources
      if roles = Typus::Configuration.roles
        roles.keys.map do |key|
          Typus::Configuration.roles[key].keys
        end.flatten.sort.uniq.delete_if { |x| models.include?(x) }
      else
        []
      end
    end

    # Lists models under <tt>app/models</tt>.
    def detect_application_models
      model_dir = Rails.root.join("app/models")
      Dir.chdir(model_dir) { Dir["**/*.rb"] }
    end

    def locales
      { "Català" => "ca",
        "German" => "de",
        "Greek"  => "el",
        "English" => "en",
        "Español" => "es",
        "Français" => "fr",
        "Magyar" => "hu",
        "Italiano" => "It",
        "Portuguese" => "pt-BR",
        "Russian" => "ru",
        "中文" => "zh-CN" }
    end

    def application_models
      detect_application_models.map do |model|
        class_name = model.sub(/\.rb$/,"").camelize
        klass = class_name.split("::").inject(Object) { |klass,part| klass.const_get(part) }
        class_name if klass < ActiveRecord::Base && !klass.abstract_class?
      end.compact
    end

    def user_class
      user_class_name.typus_constantize
    end

    def reload!
      Typus::Configuration.roles!
      Typus::Configuration.config!
    end

  end

end
