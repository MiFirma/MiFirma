# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{paperclip}
  s.version = "3.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Jon Yurek}]
  s.date = %q{2012-10-31}
  s.description = %q{Easy upload management for ActiveRecord}
  s.email = [%q{jyurek@thoughtbot.com}]
  s.homepage = %q{https://github.com/thoughtbot/paperclip}
  s.post_install_message = %q{##################################################
#  NOTE FOR UPGRADING FROM PRE-3.0 VERSION       #
##################################################

Paperclip 3.0 introduces a non-backward compatible change in your attachment
path. This will help to prevent attachment name clashes when you have
multiple attachments with the same name. If you didn't alter your
attachment's path and are using Paperclip's default, you'll have to add
`:path` and `:url` to your `has_attached_file` definition. For example:

    has_attached_file :avatar,
      :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
      :url => "/system/:attachment/:id/:style/:filename"

}
  s.require_paths = [%q{lib}]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.requirements = [%q{ImageMagick}]
  s.rubyforge_project = %q{paperclip}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{File attachments as attributes for ActiveRecord}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 3.0.0"])
      s.add_runtime_dependency(%q<activemodel>, [">= 3.0.0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_runtime_dependency(%q<cocaine>, ["~> 0.4.0"])
      s.add_runtime_dependency(%q<mime-types>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<appraisal>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<aws-sdk>, [">= 0"])
      s.add_development_dependency(%q<bourne>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, ["~> 1.3.4"])
      s.add_development_dependency(%q<cucumber>, ["~> 1.2.1"])
      s.add_development_dependency(%q<aruba>, [">= 0"])
      s.add_development_dependency(%q<nokogiri>, [">= 0"])
      s.add_development_dependency(%q<capybara>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<cocaine>, ["~> 0.2"])
      s.add_development_dependency(%q<fog>, ["< 1.7.0", ">= 1.4.0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<launchy>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<fakeweb>, [">= 0"])
      s.add_development_dependency(%q<railties>, [">= 0"])
      s.add_development_dependency(%q<actionmailer>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, [">= 3.0.0"])
      s.add_dependency(%q<activemodel>, [">= 3.0.0"])
      s.add_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_dependency(%q<cocaine>, ["~> 0.4.0"])
      s.add_dependency(%q<mime-types>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<appraisal>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<aws-sdk>, [">= 0"])
      s.add_dependency(%q<bourne>, [">= 0"])
      s.add_dependency(%q<sqlite3>, ["~> 1.3.4"])
      s.add_dependency(%q<cucumber>, ["~> 1.2.1"])
      s.add_dependency(%q<aruba>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<capybara>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<cocaine>, ["~> 0.2"])
      s.add_dependency(%q<fog>, ["< 1.7.0", ">= 1.4.0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<launchy>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<fakeweb>, [">= 0"])
      s.add_dependency(%q<railties>, [">= 0"])
      s.add_dependency(%q<actionmailer>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 3.0.0"])
    s.add_dependency(%q<activemodel>, [">= 3.0.0"])
    s.add_dependency(%q<activesupport>, [">= 3.0.0"])
    s.add_dependency(%q<cocaine>, ["~> 0.4.0"])
    s.add_dependency(%q<mime-types>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<appraisal>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<aws-sdk>, [">= 0"])
    s.add_dependency(%q<bourne>, [">= 0"])
    s.add_dependency(%q<sqlite3>, ["~> 1.3.4"])
    s.add_dependency(%q<cucumber>, ["~> 1.2.1"])
    s.add_dependency(%q<aruba>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<capybara>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<cocaine>, ["~> 0.2"])
    s.add_dependency(%q<fog>, ["< 1.7.0", ">= 1.4.0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<launchy>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<fakeweb>, [">= 0"])
    s.add_dependency(%q<railties>, [">= 0"])
    s.add_dependency(%q<actionmailer>, [">= 0"])
  end
end
