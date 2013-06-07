# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fluent/plugin/resolv/version'

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-resolv"
  spec.version       = Fluent::Plugin::Resolv::VERSION
  spec.authors       = ["Kohei MATSUSHITA"]
  spec.email         = ["ma2shita+git@ma2shita.jp"]
  spec.description   = %q{Fluent plugin, IP address resolv and rewrite.}
  spec.summary       = %q{Fluent plugin, IP address resolv and rewrite.}
  spec.homepage      = "https://github/ma2shita/fluent-plugin-resolv"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "fluentd"
  spec.add_runtime_dependency "fluentd"
end
