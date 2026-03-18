# frozen_string_literal: true

require 'spec_helper'

describe PaperTrailManager, 'date range filtering', versioning: true do
  let(:entity) { FactoryBot.create(:entity, name: 'Test Entity', status: 'Active') }

  before do
    entity
    entity.update(status: 'Updated')
  end

  describe 'index with date filters' do
    context 'with from parameter' do
      it 'shows changes on or after the date' do
        get changes_path(from: Date.today.to_s)
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_tag('.change_row')
      end

      it 'returns no changes for future date' do
        get changes_path(from: (Date.today + 1).to_s)
        expect(response.body).to include('No changes found')
      end
    end

    context 'with to parameter' do
      it 'shows changes on or before the date' do
        get changes_path(to: Date.today.to_s)
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_tag('.change_row')
      end

      it 'returns no changes for past date' do
        get changes_path(to: (Date.today - 1).to_s)
        expect(response.body).to include('No changes found')
      end
    end

    context 'with from and to combined' do
      it 'shows changes within the range' do
        get changes_path(from: Date.today.to_s, to: Date.today.to_s)
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_tag('.change_row')
      end
    end

    context 'combined with type filter' do
      it 'respects both date and type filters' do
        get changes_path(from: Date.today.to_s, type: 'Entity')
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_tag('.change_item', text: /Entity/)
      end
    end

    context 'with invalid date' do
      it 'ignores invalid from date gracefully' do
        get changes_path(from: 'not-a-date')
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_tag('.change_row')
      end

      it 'ignores invalid to date gracefully' do
        get changes_path(to: 'garbage')
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_tag('.change_row')
      end
    end

    context 'date filter form' do
      it 'renders date inputs' do
        get changes_path
        expect(response.body).to have_tag('input[type="date"][name="from"]')
        expect(response.body).to have_tag('input[type="date"][name="to"]')
      end

      it 'preserves date values in form' do
        get changes_path(from: '2026-01-01', to: '2026-12-31')
        expect(response.body).to have_tag('input[name="from"][value="2026-01-01"]')
        expect(response.body).to have_tag('input[name="to"][value="2026-12-31"]')
      end
    end
  end
end
