require 'rails_helper'

RSpec.describe "ClientRepos", :type => :request do
  describe "GET /client_repos" do
    it "works! (now write some real specs)" do
      get client_repos_path
      expect(response).to have_http_status(200)
    end
  end
end
