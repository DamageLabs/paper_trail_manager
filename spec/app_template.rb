# frozen_string_literal: true

gem 'paper_trail_manager', path: __FILE__ + '/../../../'

# Remove auto-generated request specs from dummy app
remove_file 'spec/requests/entities_spec.rb' if File.exist?('spec/requests/entities_spec.rb')
remove_file 'spec/requests/platforms_spec.rb' if File.exist?('spec/requests/platforms_spec.rb')

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
route "root to: 'paper_trail_manager/changes#index'"

# Allow YAML deserialization of ActiveSupport::TimeWithZone (Ruby 3.1+ Psych 4)
initializer 'permitted_classes.rb', <<~RUBY
  Rails.application.config.active_record.yaml_column_permitted_classes = [
    ActiveSupport::TimeWithZone,
    ActiveSupport::TimeZone,
    Time
  ]
RUBY

rake 'db:migrate db:test:prepare'
