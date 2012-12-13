# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{annotate}
  s.version = "2.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Cuong Tran}, %q{Alex Chaffee}, %q{Marcos Piccinini}, %q{Turadg Aleahmad}]
  s.date = %q{2012-07-28}
  s.description = %q{Annotates Rails/ActiveRecord Models, routes, fixtures, and others based on the database schema.}
  s.email = [%q{alex@stinky.com}, %q{ctran@pragmaquest.com}, %q{x@nofxx.com}, %q{turadg@aleahmad.net}]
  s.executables = [%q{annotate}]
  s.extra_rdoc_files = [%q{README.rdoc}]
  s.files = [%q{bin/annotate}, %q{README.rdoc}]
  s.homepage = %q{http://github.com/ctran/annotate_models}
  s.rdoc_options = [%q{--charset=UTF-8}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{annotate}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Annotates Rails Models, routes, fixtures, and others based on the database schema.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
