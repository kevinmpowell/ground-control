class SynchronizeIssueWorker
  include Sidekiq::Worker

  def perform(github_issue_url, user_id)
  	user = User.find(user_id)
  	auth_token = user.auth_token
  	issue_data = GithubService.get_issue_data_via_url(github_issue_url, auth_token)

  	issue = Issue.find_or_initialize_by(url: issue_data["url"], user_id: user_id)
	issue.url = issue_data["url"]
	issue.state = issue_data["state"]
	issue.number = issue_data["number"]
	issue.title = issue_data["title"]
	issue.body = issue_data["body"]
	issue.assignee = issue_data["assignee"]["login"]
	issue.labels = issue_data["labels"].to_json
	issue.creator = issue_data["creator"]
	issue.comment_count = issue_data["comments"]
	issue.issue_created_at = issue_data["created_at"].to_datetime
	issue.issue_updated_at = issue_data["updated_at"].to_datetime
	issue.locally_sorted = false
	issue.local_sort_order = nil
	issue.user_id = user_id

	#  # TODO - Add method to auto-add client ID based on repo

	unless issue_data["milestone"].nil?
		issue.milestone_name = issue_data["milestone"]["title"]
		issue.milestone_state = issue_data["milestone"]["state"]
		issue.milestone_due_on = issue_data["milestone"]["due_on"]

		unless issue_data["milestone"]["due_on"].nil?
		  	issue.milestone_due_on = issue_data["milestone"]["due_on"].to_date
		end
	end

	issue.closed = false
	if issue.state == "closed"
		issue.closed_at = issue_data["closed_at"].to_datetime
		issue.closed = true
	end

	issue.save
  end
end