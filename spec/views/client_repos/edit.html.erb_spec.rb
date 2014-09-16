require 'rails_helper'

RSpec.describe "client_repos/edit", :type => :view do
  before(:each) do
    @client_repo = assign(:client_repo, ClientRepo.create!(
      :client_name => "MyString",
      :repo_name => "MyString"
    ))
  end

  it "renders the edit client_repo form" do
    render

    assert_select "form[action=?][method=?]", client_repo_path(@client_repo), "post" do

      assert_select "input#client_repo_client_name[name=?]", "client_repo[client_name]"

      assert_select "input#client_repo_repo_name[name=?]", "client_repo[repo_name]"
    end
  end
end
