# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cocaine}
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Jon Yurek}]
  s.date = %q{2012-10-19}
  s.description = %q{A small library for doing (command) lines}
  s.email = %q{jyurek@thoughtbot.com}
  s.homepage = %q{http://github.com/thoughtbot/cocaine}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{A small library for doing (command) lines}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<bourne>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<posix-spawn>, [">= 0"])
      s.add_development_dependency(%q<active_support>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<bourne>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<posix-spawn>, [">= 0"])
      s.add_dependency(%q<active_support>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<bourne>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<posix-spawn>, [">= 0"])
    s.add_dependency(%q<active_support>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
  end
end
