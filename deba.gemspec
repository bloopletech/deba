# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'deba'

Gem::Specification.new do |spec|
  spec.name          = "deba"
  spec.version       = Deba::VERSION
  spec.authors       = ["Brenton \"B-Train\" Fletcher"]
  spec.email         = ["i@bloople.net"]

  spec.summary       = %q{Fillet HTML using this Deba knife to extract the juicy text content}
  spec.description   = %q{Deba takes a HTML document or fragment and extracts the text content into a plaintext format that is a strict subset of markdown.}
  spec.homepage      = "http://example.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "nokogiri"
end
