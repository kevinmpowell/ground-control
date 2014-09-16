require 'rails_helper'

RSpec.describe "client_repos/new", :type => :view do
  before(:each) do
    assign(:client_repo, ClientRepo.new(
      :client_name => "MyString",
      :repo_name => "MyString"
    ))
  end

  it "renders new client_repo form" do
    render

    assert_select "form[action=?][method=?]", client_repos_path, "post" do

      assert_select "input#client_repo_client_name[name=?]", "client_repo[client_name]"

      assert_select "input#client_repo_repo_name[name=?]", "client_repo[repo_name]"
    end
  end
end
