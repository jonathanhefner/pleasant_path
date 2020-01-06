# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pleasant_path/version'

Gem::Specification.new do |spec|
  spec.name          = "pleasant_path"
  spec.version       = PleasantPath::VERSION
  spec.authors       = ["Jonathan Hefner"]
  spec.email         = ["jonathan@hefner.pro"]

  spec.summary       = %q{A fluent API for pleasant file IO.}
  spec.homepage      = "https://github.com/jonathanhefner/pleasant_path"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
