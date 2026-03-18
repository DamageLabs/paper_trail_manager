# frozen_string_literal: true

require 'rails/generators'

class PaperTrailManager
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)
    desc 'Install PaperTrailManager: add route and create initializer'

    def add_route
      route_string = "resources :changes, controller: 'paper_trail_manager/changes'"
      routes_file = File.join(destination_root, 'config/routes.rb')

      if File.exist?(routes_file) && File.read(routes_file).include?(route_string)
        say_status :skip, 'Route already exists', :yellow
      else
        route route_string
      end
    end

    def create_initializer
      template 'initializer.rb', 'config/initializers/paper_trail_manager.rb'
    end

    def show_post_install
      say ''
      say '✅ PaperTrailManager installed!', :green
      say ''
      say 'Next steps:'
      say '  1. Restart your Rails server'
      say '  2. Visit /changes to browse your PaperTrail version history'
      say '  3. Edit config/initializers/paper_trail_manager.rb to customize authorization'
      say ''
    end
  end
end
