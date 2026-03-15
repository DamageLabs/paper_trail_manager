# frozen_string_literal: true

{
  '6.1' => %w[12.0],
  '7.0' => %w[12.0 15.0],
  '7.1' => %w[15.0]
}.each do |rails_version, paper_trail_versions|
  paper_trail_versions.each do |paper_trail_version|
    appraise "rails-#{rails_version}-paper_trail-#{paper_trail_version}-will-paginate" do
      gem 'rails', "~> #{rails_version}.0"
      gem 'sqlite3', '~> 1.7'
      gem 'paper_trail', "~> #{paper_trail_version}"
      gem 'will_paginate', '~> 4.0'
    end

    appraise "rails-#{rails_version}-paper_trail-#{paper_trail_version}-kaminari" do
      gem 'rails', "~> #{rails_version}.0"
      gem 'sqlite3', '~> 1.7'
      gem 'paper_trail', "~> #{paper_trail_version}"
      gem 'kaminari', '>= 1.0'
    end
  end
end
