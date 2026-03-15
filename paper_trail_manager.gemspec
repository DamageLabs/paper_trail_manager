# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'paper_trail_manager'
  spec.version       = '0.8.0'
  spec.authors       = ['Igal Koshevoy', 'Reid Beels']
  spec.authors       = ['mail@reidbeels.com']
  spec.summary       = 'A user interface for `paper_trail` versioning data in Rails applications.'
  spec.description   = 'Browse, subscribe, view and revert changes to records when using Rails and the `paper_trail` gem.'
  spec.homepage      = 'https://github.com/DamageLabs/paper_trail_manager'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.1'
  spec.add_dependency 'paper_trail', ['>= 12.0']
  spec.add_dependency 'rails', ['>= 6.1', '< 8.0']
  spec.add_dependency 'nokogiri', ['>= 1.18.3']
  spec.add_dependency 'rails-html-sanitizer', ['>= 1.6.1']
  spec.add_development_dependency 'appraisal', '~> 2.0'
  spec.add_development_dependency 'factory_bot_rails', '~> 6.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec-activemodel-mocks', '~> 1.0'
  spec.add_development_dependency 'rspec-html-matchers', '~> 0.10'
  spec.add_development_dependency 'rspec-its', '~> 1.0'
  spec.add_development_dependency 'rspec-rails', '~> 6.0'
  spec.add_development_dependency 'sqlite3', '~> 1.7'
end
