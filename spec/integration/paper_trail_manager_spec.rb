# frozen_string_literal: true

require 'spec_helper'

describe PaperTrailManager, versioning: true do
  context 'without changes' do
    context 'when fetching the index' do
      it 'has no changes by default' do
        get '/changes'

        expect(response.body).to include('No changes found')
      end
    end
  end

  context 'with changes' do
    let(:reimu) { FactoryBot.create(:entity, name: 'Miko Hakurei Reimu', status: 'Highly Responsive to Prayers') }
    let(:flanchan) { FactoryBot.create(:entity, name: 'Flandre Scarlet', status: 'The Embodiment of Scarlet Devil') }
    let(:sakuya) { FactoryBot.create(:entity, name: 'Sakuya Izayoi', status: 'Flowering Night') }
    let(:kyuu_hachi) { FactoryBot.create(:platform, name: 'PC-9801', status: 'SUGOI!!1!') }
    let!(:uinodouzu) { FactoryBot.create(:platform, name: 'Mikorusofto Uinodouzu', status: 'o-O') }

    let!(:flanchan_id) { flanchan.id }

    before do
      sakuya
      reimu.update(name: 'Hakurei Reimu', status: 'Phantasmagoria of Dimensional Dream')
      reimu.update(status: 'Perfect Cherry Blossom')
      flanchan.destroy
      kyuu_hachi.update(status: 'Kimochi warui.')
      kyuu_hachi.destroy
      uinodouzu
    end

    describe 'index' do
      context 'when getting all changes' do
        context 'with authorization' do
          context 'when getting default index' do
            before { get changes_path }

            it 'has all changes' do
              expect(response.body).to have_tag('.change_row', count: 10)
            end

            it 'has changes for all changed item types' do
              expect(response.body).to have_tag('.change_item', text: /Entity/)
              expect(response.body).to have_tag('.change_item', text: /Platform/)
            end

            it 'orders changes with newest and highest id at the top' do
              ids = response.body.scan(/Change #(\d+)/).flatten.map(&:to_i)
              expect(ids).to eq ids.sort.reverse
            end
          end
        end

        # TODO
        # context "when not authorized" do
        #   it "should display an error if user is not allowed to list changes"
        # end
      end

      context 'when getting changes for a specific type' do
        context 'when changes exist' do
          before { get changes_path(type: 'Entity') }

          it 'shows a subset of the changes' do
            expect(response.body).to have_tag('.change_row', count: 6)
          end

          it 'has changes only for that type' do
            expect(response.body).to have_tag('.change_item', text: /Entity/)
            expect(response.body).not_to have_tag('.change_item', text: /Platform/)
          end
        end

        # TODO
        # context "that doesn't exist" do
        #   it "should display ana error that the type doesn't exist"
        # end
      end

      context 'when getting changes for a specific record' do
        context 'when changes exist' do
          before { get changes_path(type: 'Entity', id: reimu.id) }

          it 'shows a subset of the changes' do
            expect(response.body).to have_tag('.change_row', count: 3)
          end

          it 'has changes only for that type' do
            expect(response.body).to have_tag('.change_item', text: /Entity/)
            expect(response.body).not_to have_tag('.change_item', text: /Platform/)
          end

          it 'has changes only for that record' do
            expect(response.body.scan(%r{/entities/(#{reimu.id})}).flatten.uniq).to eq [reimu.id.to_s]
          end
        end

        # TODO
        # context "that doesn't exist" do
        #   it "should display an error that the record doesn't exist"
        # end
      end
    end

    describe 'showing a change' do
      context 'when the change exists' do
        context 'when authorized' do
          let(:version) { reimu.versions.last }

          before do
            get change_path(version)
          end

          it 'shows the requested change' do
            expect(response.body).to have_tag('.change_id', text: "Change ##{version.id}")
          end

          it 'shows a change with the right event' do
            expect(response.body).to have_tag('.change_event_update')
          end

          it 'is associated with the expected record' do
            expect(response.body).to have_tag('.change_item', text: "Entity #{reimu.id}")
          end
        end

        # TODO
        # context "when not authorized" do
        #   it "should display an error if user is not allowed to show the change"
        # end
      end

      # TODO
      # context "that doesn't exist" do
      #   it "should display an error that the change doesn't exist"
      # end
    end

    describe 'rolling back changes' do
      context 'when changes exist' do
        context 'when authorized' do
          it 'rollbacks a newly-created record by deleting it' do
            expect(Entity).to exist(reimu.id)

            put change_path(reimu.versions.first)

            expect(Entity).not_to exist(reimu.id)
          end

          it 'rollbacks an edit by reverting to the previous state' do
            reimu.reload
            expect(reimu.status).to eq 'Perfect Cherry Blossom'

            put change_path(reimu.versions.last)

            reimu.reload
            expect(reimu.status).to eq 'Phantasmagoria of Dimensional Dream'
          end

          it 'rollbacks a delete by restoring the record' do
            expect(Entity.exists?(flanchan_id)).to be_falsey

            put change_path(PaperTrail::Version.where(item_id: flanchan_id, item_type: 'Entity').last)

            found = Entity.find(flanchan_id)
            expect(found.status).to eq 'The Embodiment of Scarlet Devil'
          end
        end

        # TODO
        # context "when not authorized" do
        #   it "should display an error if user is not allowed to revert that change"
        # end
      end

      # TODO
      # context "that don't exist" do
      #   it "should display an error that the change doesn't exist"
      # end
    end
  end
end
