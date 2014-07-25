require 'spec_helper'

describe User do
	it {should validate_presence_of(:github_username)} # User accounts have to be whitelisted by being created with a github_username
	it {should validate_uniqueness_of(:github_username)} # Only one user per github account

	context "with saved records" do
		before do
		    @user = User.create({email:'test@example.com', password:'blahblah', github_username:'test', name:'Zenith at the end', auth_token:'fake-token-here'})
		    @user2 = User.create({email:'a@example.com', password:'blahblah', github_username:'alpha', name:'Alphabetically First', auth_token:'fake-token-here'})
		end

		it "should have a default sort order by name" do
	      expect(User.first).to eq(@user2)
	      expect(User.last).to eq(@user)
	    end
	end
end