require 'rails_helper'

RSpec.describe "client_repos/index", :type => :view do
  before(:each) do
    assign(:client_repos, [
      ClientRepo.create!(
        :client_name => "Client Name",
        :repo_name => "Repo Name"
      ),
      ClientRepo.create!(
        :client_name => "Client Name",
        :repo_name => "Repo Name"
      )
    ])
  end

  it "renders a list of client_repos" do
    render
    assert_select "tr>td", :text => "Client Name".to_s, :count => 2
    assert_select "tr>td", :text => "Repo Name".to_s, :count => 2
  end
end
