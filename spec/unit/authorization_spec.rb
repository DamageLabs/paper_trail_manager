begin
  require 'kaminari/core'
rescue LoadError
  require 'will_paginate'
end
require 'paper_trail_manager'

RSpec.describe PaperTrailManager, 'authorization' do
  let(:controller) { double('controller') }
  let(:version) { double('version') }

  after do
    # Reset blocks to defaults
    default = proc { true }
    PaperTrailManager.allow_index_block = default
    PaperTrailManager.allow_show_block = default
  end

  describe '.allow_show?' do
    it 'uses allow_show_block, not allow_index_block' do
      PaperTrailManager.allow_index_when { |_controller| false }
      PaperTrailManager.allow_show_when { |_controller, _version| true }

      expect(PaperTrailManager.allow_show?(controller, version)).to be true
    end

    it 'does not fall through to allow_index_block' do
      PaperTrailManager.allow_index_when { |_controller| true }
      PaperTrailManager.allow_show_when { |_controller, _version| false }

      expect(PaperTrailManager.allow_show?(controller, version)).to be false
    end
  end

  describe '.allow_index?' do
    it 'uses allow_index_block' do
      PaperTrailManager.allow_index_when { |_controller| true }

      expect(PaperTrailManager.allow_index?(controller)).to be true
    end
  end
end
