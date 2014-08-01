require 'spec_helper'

describe Issue do
	it {should validate_presence_of(:user_id)} 
	it {should validate_presence_of(:url)} 
	it {should validate_presence_of(:number)} 
	it {should validate_presence_of(:issue_created_at)} 
	it {should validate_uniqueness_of(:url)}

	context "with saved records" do
		# before do
		#     @user = User.create({email:'test@example.com', password:'blahblah', github_username:'test', name:'Zenith at the end', auth_token:'fake-token-here'})
		#     @user2 = User.create({email:'a@example.com', password:'blahblah', github_username:'alpha', name:'Alphabetically First', auth_token:'fake-token-here'})
		# end

		# it "should have a default sort order by name" do
	 #      expect(User.first).to eq(@user2)
	 #      expect(User.last).to eq(@user)
	 #    end
	end
end