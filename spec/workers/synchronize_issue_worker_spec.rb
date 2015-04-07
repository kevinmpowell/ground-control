require 'spec_helper'

describe SynchronizeIssueWorker do
	before do
		@issue_url = 'https://api.github.com/repos/marriottdigital/Foundations/issues/1347'
		@existing_issue_url = 'https://api.github.com/repos/marriottdigital/Foundations/issues/13478'
		@archived_issue_url = 'https://api.github.com/repos/archived/project/issues/1234'

		@existing_issue = Issue.create({
			url: @existing_issue_url,
			user_id: @current_user.id,
			title: "Found a bug",
			body: "I'm having a problem with this.",
			state: "open",
			number: 13478,
			assignee: "kevinmpowell",
			labels: "[]",
			creator: "jamesmelzer",
			milestone_name: "August Batch",
			milestone_due_on: nil,
			milestone_state: "open",
			comment_count: 5,
			issue_created_at: "2011-04-22T13:33:48Z",
			issue_updated_at: "2011-04-22T13:33:48Z",
			closed: false,
			closed_at: nil,
			locally_sorted: true,
			local_sort_order: 5
		})

		@archived_issue = Issue.create({
			url: @archived_issue_url,
			user_id: @current_user.id,
			title: "Found a bug",
			body: "I'm having a problem with this.",
			state: "closed",
			number: 1234,
			assignee: "kevinmpowell",
			labels: "[]",
			creator: "jamesmelzer",
			milestone_name: "August Batch",
			milestone_due_on: nil,
			milestone_state: "open",
			comment_count: 5,
			issue_created_at: "2011-04-22T13:33:48Z",
			issue_updated_at: "2011-04-22T13:33:48Z",
			closed: true,
			closed_at: "2011-05-22T13:33:48Z",
			locally_sorted: true,
			local_sort_order: 5,
			archived: true
		})
	end

	it "should create a new local Issue record when one doesn't already exist based on the latest information from Github" do
		expect{
			SynchronizeIssueWorker.perform_async(@issue_url, @current_user.id)
		}.to change(Issue, :count).by(1)
	end

	it "should update an existing Issue record when an issue already exists" do
		expect{
			SynchronizeIssueWorker.perform_async(@existing_issue_url, @current_user.id)
		}.to change(Issue, :count).by(0)
		@existing_issue.reload
		expect(@existing_issue.state).to eq("closed")
		expect(@existing_issue.assignee).to eq("jonqdoe")
		expect(@existing_issue.comment_count).to eq(10)
	end

	it "should 'unarchive' an archived issue if that issue is reopened" do
		expect{
			SynchronizeIssueWorker.perform_async(@archived_issue_url, @current_user.id)
		}.to change(Issue, :count).by(0)
		@archived_issue.reload
		expect(@archived_issue.state).to eq("open")
		expect(@archived_issue.archived).to eq(false)
	end

	it "should create a GithubSync record and set it to false" do
		expect{
			SynchronizeIssueWorker.perform_async(@issue_url, @current_user.id)
		}.to change(GithubSync, :count).by(1)
	end

	it "should not create a GithubSync record if an incomplete GithubSync record already exists for this user" do
		GithubSync.create({complete: false, user_id: @current_user.id})

		expect{
			SynchronizeIssueWorker.perform_async(@issue_url, @current_user.id)
		}.to change(GithubSync, :count).by(0)
	end
end