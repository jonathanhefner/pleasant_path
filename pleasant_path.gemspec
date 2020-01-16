require_relative "lib/pleasant_path/version"

Gem::Specification.new do |spec|
  spec.name          = "pleasant_path"
  spec.version       = PleasantPath::VERSION
  spec.authors       = ["Jonathan Hefner"]
  spec.email         = ["jonathan@hefner.pro"]

  spec.summary       = %q{A fluent API for pleasant file IO.}
  spec.homepage      = "https://github.com/jonathanhefner/pleasant_path"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.metadata["source_code_uri"] + "/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
