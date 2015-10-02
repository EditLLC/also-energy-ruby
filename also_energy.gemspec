# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'also_energy/version'

Gem::Specification.new do |spec|
  spec.name          = "also_energy"
  spec.version       = AlsoEnergy::VERSION
  spec.authors       = ["Tyler Whitsett", "Darin Haener"]
  spec.email         = ["whitsett.tyler@gmail.com", "dphaener@gmail.com"]

  spec.summary       = %q{A Ruby wrapper for the AlsoEnergy API}
  spec.description   = %q{A Ruby wrapper for the AlsoEnergy API}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

  spec.add_dependency "savon", "~> 2.10.0"
end
