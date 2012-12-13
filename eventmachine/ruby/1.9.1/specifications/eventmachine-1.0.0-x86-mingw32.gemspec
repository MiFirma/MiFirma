# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{eventmachine}
  s.version = "1.0.0"
  s.platform = %q{x86-mingw32}

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Francis Cianfrocca}, %q{Aman Gupta}]
  s.date = %q{2012-09-08}
  s.description = %q{EventMachine implements a fast, single-threaded engine for arbitrary network
communications. It's extremely easy to use in Ruby. EventMachine wraps all
interactions with IP sockets, allowing programs to concentrate on the
implementation of network protocols. It can be used to create both network
servers and clients. To create a server or client, a Ruby program only needs
to specify the IP address and port, and provide a Module that implements the
communications protocol. Implementations of several standard network protocols
are provided with the package, primarily to serve as examples. The real goal
of EventMachine is to enable programs to easily interface with other programs
using TCP/IP, especially if custom protocols are required.}
  s.email = [%q{garbagecat10@gmail.com}, %q{aman@tmm1.net}]
  s.extra_rdoc_files = [%q{README.md}, %q{docs/DocumentationGuidesIndex.md}, %q{docs/GettingStarted.md}, %q{docs/old/ChangeLog}, %q{docs/old/DEFERRABLES}, %q{docs/old/EPOLL}, %q{docs/old/INSTALL}, %q{docs/old/KEYBOARD}, %q{docs/old/LEGAL}, %q{docs/old/LIGHTWEIGHT_CONCURRENCY}, %q{docs/old/PURE_RUBY}, %q{docs/old/RELEASE_NOTES}, %q{docs/old/SMTP}, %q{docs/old/SPAWNED_PROCESSES}, %q{docs/old/TODO}]
  s.files = [%q{README.md}, %q{docs/DocumentationGuidesIndex.md}, %q{docs/GettingStarted.md}, %q{docs/old/ChangeLog}, %q{docs/old/DEFERRABLES}, %q{docs/old/EPOLL}, %q{docs/old/INSTALL}, %q{docs/old/KEYBOARD}, %q{docs/old/LEGAL}, %q{docs/old/LIGHTWEIGHT_CONCURRENCY}, %q{docs/old/PURE_RUBY}, %q{docs/old/RELEASE_NOTES}, %q{docs/old/SMTP}, %q{docs/old/SPAWNED_PROCESSES}, %q{docs/old/TODO}]
  s.homepage = %q{http://rubyeventmachine.com}
  s.rdoc_options = [%q{--title}, %q{EventMachine}, %q{--main}, %q{README.md}, %q{-x}, %q{lib/em/version}, %q{-x}, %q{lib/jeventmachine}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{eventmachine}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Ruby/EventMachine library}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake-compiler>, ["~> 0.8.1"])
      s.add_development_dependency(%q<yard>, [">= 0.7.2"])
      s.add_development_dependency(%q<bluecloth>, [">= 0"])
    else
      s.add_dependency(%q<rake-compiler>, ["~> 0.8.1"])
      s.add_dependency(%q<yard>, [">= 0.7.2"])
      s.add_dependency(%q<bluecloth>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake-compiler>, ["~> 0.8.1"])
    s.add_dependency(%q<yard>, [">= 0.7.2"])
    s.add_dependency(%q<bluecloth>, [">= 0"])
  end
end
