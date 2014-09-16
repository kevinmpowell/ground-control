require "rails_helper"

RSpec.describe ClientReposController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/client_repos").to route_to("client_repos#index")
    end

    it "routes to #new" do
      expect(:get => "/client_repos/new").to route_to("client_repos#new")
    end

    it "routes to #show" do
      expect(:get => "/client_repos/1").to route_to("client_repos#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/client_repos/1/edit").to route_to("client_repos#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/client_repos").to route_to("client_repos#create")
    end

    it "routes to #update" do
      expect(:put => "/client_repos/1").to route_to("client_repos#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/client_repos/1").to route_to("client_repos#destroy", :id => "1")
    end

  end
end
