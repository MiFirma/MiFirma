# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{render_inheritable}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Pascal Zumkehr}]
  s.date = %q{2010-08-31}
  s.description = %q{With this gem, a template is searched in the current controller's view folder (as usual). 
If it is not found there, the template with the same name in the view folder of the 
superclass controller is used. Finally, also views and partials remain DRY!
}
  s.email = %q{spam@codez.ch}
  s.extra_rdoc_files = [%q{MIT-LICENSE}, %q{README.rdoc}, %q{VERSION}]
  s.files = [%q{MIT-LICENSE}, %q{README.rdoc}, %q{VERSION}]
  s.homepage = %q{http://codez.ch/render_inheritable}
  s.rdoc_options = [%q{--title}, %q{Render Inheritable}, %q{--main}, %q{README.rdoc}, %q{--line-numbers}, %q{--inline-source}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{A Rails 3 plugin that allows one to inherit or override single templates for controller hierarchies.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 3.0"])
    else
      s.add_dependency(%q<rails>, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 3.0"])
  end
end
