require 'spec_helper'

describe GithubService do
	before do
	    @user = User.create({email:'test@example.com', password:'blahblah', github_username:'jonqdoe', name:'Zenith at the end', auth_token:'fake-token-here'})
	end

	it "synchronize github issues for a given user" do
		expect(SynchronizeIssueWorker).to receive(:perform_async).exactly(2).times
		GithubService.synchronize_issues_for_user(@user.id)
	end

	it "should retrieve a github issue when passed an issue url and an auth token" do
		issue = GithubService.get_issue_data_via_url('https://api.github.com/repos/marriottdigital/Foundations/issues/1347', 'fake-token-here')
		expect(issue["body"]).to eq("I'm having a problem with this.")
	end
end