# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "traipse/version"

Gem::Specification.new do |s|
  s.name        = "traipse"
  s.version     = Traipse::VERSION
  s.authors     = ["Pawel Szymczykowski"]
  s.email       = ["makenai@gmail.com"]
  s.homepage    = "https://github.com/makenai/traipse"
  s.summary     = %q{Traverse data structures with a dot notated string.}
  s.description = %q{Traipse is a library that allows you to address a data structure of Hashes & Arrays using a dot notated string & wildcards. ex: 'categories.*.name'. Like X-Path but dumber.}

  s.rubyforge_project = "traipse"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
