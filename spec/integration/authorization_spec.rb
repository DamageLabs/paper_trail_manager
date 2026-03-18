# frozen_string_literal: true

require 'spec_helper'

describe PaperTrailManager, 'authorization integration', versioning: true do
  let(:entity) { FactoryBot.create(:entity, name: 'Test Entity', status: 'Active') }

  before do
    entity
    entity.update(status: 'Updated')
  end

  after do
    default = proc { true }
    PaperTrailManager.allow_index_block = default
    PaperTrailManager.allow_show_block = default
    PaperTrailManager.allow_revert_block = default
  end

  describe 'index' do
    context 'when not authorized' do
      before do
        PaperTrailManager.allow_index_when { |_controller| false }
      end

      it 'redirects with an error flash' do
        get changes_path
        expect(response).to have_http_status(:redirect)
        expect(flash[:error]).to eq('You do not have permission to list changes.')
      end
    end
  end

  describe 'show' do
    context 'when not authorized' do
      before do
        PaperTrailManager.allow_show_when { |_controller, _version| false }
      end

      it 'redirects with an error flash' do
        get change_path(entity.versions.last)
        expect(response).to have_http_status(:redirect)
        expect(flash[:error]).to eq('You do not have permission to show that change.')
      end
    end

    context 'when change does not exist' do
      it 'redirects with an error flash' do
        get change_path(id: 999999)
        expect(response).to have_http_status(:redirect)
        expect(flash[:error]).to eq('No such version.')
      end
    end
  end

  describe 'revert' do
    context 'when not authorized' do
      before do
        PaperTrailManager.allow_revert_when { |_controller, _version| false }
      end

      it 'redirects with an error flash' do
        put change_path(entity.versions.last)
        expect(response).to have_http_status(:redirect)
        expect(flash[:error]).to eq('You do not have permission to revert this change.')
      end
    end

    context 'when change does not exist' do
      it 'redirects with an error flash' do
        put change_path(id: 999999)
        expect(response).to have_http_status(:redirect)
        expect(flash[:error]).to eq('No such version.')
      end
    end
  end

  describe 'filtering by non-existent type' do
    it 'returns an empty changes list' do
      get changes_path(type: 'NonExistentModel')
      expect(response.body).to include('No changes found')
    end
  end
end
