require 'rails_helper'

RSpec.describe "Frontends", type: :request do
  describe 'index' do
    before do
        get frontends_path
    end
        
    it { expect(response).to be_successful }
  end
end
