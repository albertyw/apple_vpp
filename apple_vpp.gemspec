# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apple_vpp/version'

Gem::Specification.new do |spec|
  spec.name          = "apple_vpp"
  spec.version       = AppleVPP::VERSION
  spec.authors       = ["Taylor Boyko"]
  spec.email         = ["taylorboyko@gmail.com"]
  spec.description   = %q{Ruby bindings for the Apple VPP App Assignment API}
  spec.summary       = %q{Ruby bindings for the Apple VPP App Assignment API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rest-client', '~> 1.7.3'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
