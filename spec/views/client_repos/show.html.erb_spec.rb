require 'rails_helper'

RSpec.describe "client_repos/show", :type => :view do
  before(:each) do
    @client_repo = assign(:client_repo, ClientRepo.create!(
      :client_name => "Client Name",
      :repo_name => "Repo Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Client Name/)
    expect(rendered).to match(/Repo Name/)
  end
end
