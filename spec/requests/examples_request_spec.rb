require 'rails_helper'

RSpec.describe 'Examples', type: :request do
  describe 'index' do
    before do
      get examples_path
    end

    let(:actual) { JSON.parse(response.body) }
      
    it { expect(response).to be_successful }
    it { expect(actual.size).to be > 1 }
    it { expect(actual.first.keys).to contain_exactly('name', 'favorite_restaurant', 'favorite_movie', 'favorite_band') }
  end
end
