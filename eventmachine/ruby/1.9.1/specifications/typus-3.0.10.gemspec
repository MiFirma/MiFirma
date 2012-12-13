# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{typus}
  s.version = "3.0.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Francesc Esplugas}]
  s.date = %q{2011-03-16}
  s.description = %q{Ruby on Rails Admin Panel (Engine) to allow trusted users edit structured content.}
  s.email = [%q{core@typuscms.com}]
  s.homepage = %q{http://core.typuscms.com/}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{typus}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Effortless backend interface for Ruby on Rails applications. (Admin scaffold generator)}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bcrypt-ruby>, [">= 0"])
      s.add_runtime_dependency(%q<fastercsv>, ["~> 1.5"])
      s.add_runtime_dependency(%q<render_inheritable>, [">= 0"])
      s.add_runtime_dependency(%q<will_paginate>, ["~> 3.0.pre2"])
    else
      s.add_dependency(%q<bcrypt-ruby>, [">= 0"])
      s.add_dependency(%q<fastercsv>, ["~> 1.5"])
      s.add_dependency(%q<render_inheritable>, [">= 0"])
      s.add_dependency(%q<will_paginate>, ["~> 3.0.pre2"])
    end
  else
    s.add_dependency(%q<bcrypt-ruby>, [">= 0"])
    s.add_dependency(%q<fastercsv>, ["~> 1.5"])
    s.add_dependency(%q<render_inheritable>, [">= 0"])
    s.add_dependency(%q<will_paginate>, ["~> 3.0.pre2"])
  end
end
