# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/samsung_account/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-samsung-account"
  spec.version       = OmniAuth::SamsungAccount::VERSION
  spec.authors       = ["Hsiu-Fan Wang"]
  spec.email         = ["hfwang@porkbuns.net"]

  spec.summary       = %q{OmniAuth strategy for Samsung Smart Home Cloud API}
  spec.description   = %q{OmniAuth 1.x strategy for Samsung Smart Home Cloud API}
  spec.homepage      = "https://github.com/hfwang/omniauth-samsung-shca"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'omniauth', '~> 1.0'
  spec.add_dependency 'omniauth-oauth2', '~> 1.1'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
