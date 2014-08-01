class SynchronizeIssueWorker
  include Sidekiq::Worker

  def perform(url, state, number, title, assignee, body, creator, comment_count, issue_created_at, issue_updated_at, closed_at, user_id)
  	# milestone_data = JSON.parse milestone_data
  	issue = Issue.find_or_create_by(url: url, user_id: user_id) do |issue|
	  issue.url = url
	  issue.state = state
	  issue.number = number
	  issue.title = title
	  issue.body = body
	  issue.assignee = assignee
	  # issue.labels = labels_data
	  issue.creator = creator
	  issue.comment_count = comment_count
	  issue.issue_created_at = issue_created_at.to_datetime
	  issue.issue_updated_at = issue_updated_at.to_datetime
	  issue.locally_sorted = false
	  issue.local_sort_order = nil
	  issue.user_id = user_id

	  # TODO - Add method to auto-add client ID based on repo

	 #  unless milestone_data.nil?
	 #  	issue.milestone_name = milestone_data["title"]
	 #  	issue.milestone_state = milestone_data["state"]
	 #  	issue.milestone_due_on = milestone_data["due_on"]

	 #  	unless milestone_data["due_on"].nil?
		#   	issue.milestone_due_on = milestone_data["due_on"].to_date
		# end
	 #  end

	  issue.closed = false
	  if state == "closed"
	  	issue.closed_at = closed_at.to_datetime
	  	issue.closed = true
	  end
	end
  end
end