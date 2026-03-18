# frozen_string_literal: true

gem 'paper_trail_manager', path: __FILE__ + '/../../../'

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
