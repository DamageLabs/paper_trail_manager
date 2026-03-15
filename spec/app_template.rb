# frozen_string_literal: true

gem 'paper_trail_manager', path: __FILE__ + '/../../../'

# Create manifest for sprockets if needed (Rails < 7.0)
unless File.exist?('app/assets/config/manifest.js')
  create_file 'app/assets/config/manifest.js'
  append_to_file 'app/assets/config/manifest.js', "//= link application.css\n"
  append_to_file 'app/assets/config/manifest.js', "//= link application.js\n"
end

generate 'paper_trail:install'
generate 'resource', 'entity name:string status:string --no-controller-specs --no-helper-specs'
generate 'resource', 'platform name:string status:string --no-controller-specs --no-helper-specs'

# Remove auto-generated spec files that conflict with our factories
remove_file 'spec/models/entity_spec.rb' if File.exist?('spec/models/entity_spec.rb')
remove_file 'spec/models/platform_spec.rb' if File.exist?('spec/models/platform_spec.rb')

model_body = <<-MODEL
  has_paper_trail

  validates :name, presence: true
  validates :status, presence: true
MODEL

inject_into_class 'app/models/entity.rb', 'Entity', model_body
inject_into_class 'app/models/platform.rb', 'Platform', model_body

route "resources :changes, controller: 'paper_trail_manager/changes'"

rake 'db:migrate db:test:prepare'
