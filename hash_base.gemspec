require_relative 'lib/hash_base/version'

Gem::Specification.new do |spec|

  spec.name                          = "hash_base"
  spec.version                       = HashBase::VERSION
  spec.authors                       = ["Stephan Wenzel"]
  spec.email                         = ["stephan.wenzel@drwpatent.de"]
  spec.license                       = 'GPL-2.0-only'
  
  spec.summary                       = %q{utilities for ruby hashes and arrays}
  spec.description                   = %q{adds utilities to ruby Hashes and ruby Arrays}
  spec.homepage                      = "https://github.com/HugoHasenbein/hash_base"
  spec.required_ruby_version         = Gem::Requirement.new(">= 2.3.0")
  
  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  
  spec.metadata["homepage_uri"]      = spec.homepage
  spec.metadata["source_code_uri"]   = "https://github.com/HugoHasenbein/hash_base"
  spec.metadata["changelog_uri"]     = "https://github.com/HugoHasenbein/hash_base/Changelog.md"
  
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  
  spec.bindir                        = "exe"
  spec.executables                   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths                 = ["lib"]
  
  spec.add_runtime_dependency 'rubyzip', "~> 2"
  
end
