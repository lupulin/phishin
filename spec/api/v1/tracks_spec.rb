# frozen_string_literal: true
require 'rails_helper'

describe Api::V1::TracksController do
  include Rack::Test::Methods

  let(:json) { JSON[subject.body].deep_symbolize_keys }
  let(:json_data) { json[:data] }

  describe 'index' do
    let!(:tracks) { create_list(:track, 3, :with_likes, :with_tags) }

    context 'without params' do
      subject { get('/api/v1/tracks') }

      it 'responds with expected data' do
        expect(json_data).to match_array(tracks.map(&:as_json_api))
      end
    end

    context 'when providing tag param' do
      let(:tag) { create(:tag) }
      subject { get("/api/v1/tracks?tag=#{tag.name}") }

      before { tracks.first.tags << tag }

      # TODO: This one is flaky
      it 'responds with expected data' do
        expect(json_data).to eq([tracks.first.as_json_api])
      end
    end
  end

  describe 'show' do
    let(:track) { create(:track) }

    context 'with valid id param' do
      subject { get("/api/v1/tracks/#{track.id}") }

      it 'responds with expected data' do
        expect(json_data).to eq(track.as_json_api)
      end
    end

    context 'with invalid id param' do
      subject { get('/api/v1/tracks/nonexistent-track') }

      include_examples 'responds with 404'
    end
  end
end
