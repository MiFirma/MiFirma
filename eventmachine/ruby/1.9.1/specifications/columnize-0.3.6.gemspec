# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{columnize}
  s.version = "0.3.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{R. Bernstein}]
  s.date = %q{2011-12-17}
  s.description = %q{
In showing a long lists, sometimes one would prefer to see the value
arranged aligned in columns. Some examples include listing methods
of an object or debugger commands. 
See Examples in the rdoc documentation for examples.
}
  s.email = %q{rockyb@rubyforge.net}
  s.extra_rdoc_files = [%q{README.md}, %q{lib/columnize.rb}, %q{COPYING}]
  s.files = [%q{README.md}, %q{lib/columnize.rb}, %q{COPYING}]
  s.homepage = %q{https://github.com/rocky/columnize}
  s.licenses = [%q{Ruby}, %q{GPL2}]
  s.rdoc_options = [%q{--main}, %q{README}, %q{--title}, %q{Columnize 0.3.6 Documentation}]
  s.require_paths = [%q{lib}]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.2")
  s.rubyforge_project = %q{columnize}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Module to format an Array as an Array of String aligned in columns}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
