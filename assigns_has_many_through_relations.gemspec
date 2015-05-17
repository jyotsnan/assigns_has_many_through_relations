# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'assigns_has_many_through_relations/version'

Gem::Specification.new do |spec|
  spec.name          = "assigns_has_many_through_relations"
  spec.version       = AssignsHasManyThroughRelations::VERSION
  spec.authors       = ["Diego Salazar"]
  spec.email         = ["diego@greyrobot.com"]
  spec.summary       = %q{Rails Engine that provides a management UI to assign models to each other}
  spec.description   = %q{Rails Engine that provides a management UI to assign models to each other}
  spec.homepage      = "https://github.com/DiegoSalazar/assigns_has_many_through_relations"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails', '>= 3'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
