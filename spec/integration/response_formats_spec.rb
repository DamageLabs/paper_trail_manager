# frozen_string_literal: true

require 'spec_helper'

describe PaperTrailManager, 'response formats', versioning: true do
  let(:entity) { FactoryBot.create(:entity, name: 'Format Test', status: 'Active') }

  before do
    entity
    entity.update(status: 'Updated')
  end

  describe 'JSON format' do
    context 'index' do
      it 'returns valid JSON with version data' do
        get changes_path(format: :json)
        expect(response.content_type).to include('application/json')
        json = JSON.parse(response.body)
        expect(json).to be_an(Array)
        expect(json.length).to be >= 2
      end

      it 'respects type filter' do
        get changes_path(format: :json, type: 'Entity')
        json = JSON.parse(response.body)
        json.each do |version|
          expect(version['item_type']).to eq('Entity')
        end
      end

      it 'respects id filter' do
        get changes_path(format: :json, type: 'Entity', id: entity.id)
        json = JSON.parse(response.body)
        json.each do |version|
          expect(version['item_id']).to eq(entity.id)
        end
      end
    end

    context 'show' do
      it 'returns valid JSON for a single version' do
        version = entity.versions.last
        get change_path(version, format: :json)
        expect(response.content_type).to include('application/json')
        json = JSON.parse(response.body)
        expect(json['id']).to eq(version.id)
        expect(json['item_type']).to eq('Entity')
      end
    end
  end

  describe 'Atom format' do
    context 'index' do
      it 'returns valid XML' do
        get changes_path(format: :atom)
        expect(response.content_type).to include('application/atom+xml')
        expect(response.body).to include('<feed')
        expect(response.body).to include('<entry>')
      end

      it 'includes version entries' do
        get changes_path(format: :atom)
        expect(response.body).to include('Entity')
      end

      it 'respects type filter' do
        get changes_path(format: :atom, type: 'Entity')
        expect(response.body).to include('Entity')
        expect(response.body).not_to include('Platform')
      end
    end
  end
end
