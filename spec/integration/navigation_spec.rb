# frozen_string_literal: true

require 'spec_helper'

describe 'Navigation' do
  it 'is a valid app' do
    expect(::Rails.application).to be_a_kind_of(Rails::Application)
  end
end
