# frozen_string_literal: true

require 'spec_helper'

describe PaperTrailManager::ChangesHelper, versioning: true do
  # Use a view context to get access to content_tag, h, etc.
  let(:helper) { ApplicationController.new.view_context }

  describe '#text_or_nil' do
    it 'returns styled nil for nil values' do
      result = helper.text_or_nil(nil)
      expect(result).to include('em')
      expect(result).to include('nil')
    end

    it 'returns escaped text for non-nil values' do
      result = helper.text_or_nil('hello')
      expect(result).to eq('hello')
    end

    it 'escapes HTML in values' do
      result = helper.text_or_nil('<script>alert("xss")</script>')
      expect(result).not_to include('<script>')
    end
  end

  describe '#changes_for' do
    let(:entity) { FactoryBot.create(:entity, name: 'Test', status: 'Active') }

    context 'for a create event' do
      it 'returns a hash' do
        version = entity.versions.first
        changes = helper.changes_for(version)
        expect(changes).to be_a(Hash)
      end
    end

    context 'for an update event' do
      before { entity.update(status: 'Updated') }

      it 'returns a hash' do
        version = entity.versions.last
        changes = helper.changes_for(version)
        expect(changes).to be_a(Hash)
      end
    end

    context 'for a destroy event' do
      before { entity.destroy }

      it 'returns changes with previous values' do
        version = PaperTrail::Version.where(item_type: 'Entity', event: 'destroy').last
        changes = helper.changes_for(version)
        expect(changes).to be_a(Hash)
      end
    end
  end

  describe '#change_item_types' do
    it 'returns a sorted array of versioned model names' do
      # Ensure models are loaded
      Entity.new
      types = helper.change_item_types
      expect(types).to be_an(Array)
      expect(types).to include('Entity')
      expect(types).to eq(types.sort)
    end
  end

  describe '#version_reify' do
    let(:entity) { FactoryBot.create(:entity, name: 'Test', status: 'Active') }

    it 'returns the reified record for an update' do
      entity.update(status: 'Updated')
      version = entity.versions.last
      record = helper.version_reify(version)
      expect(record).to be_a(Entity)
      expect(record.status).to eq('Active')
    end
  end
end
