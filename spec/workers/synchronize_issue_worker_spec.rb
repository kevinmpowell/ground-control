require 'spec_helper'

describe SynchronizeIssueWorker do
	before do
		@new_issue = {
			"url" => "https =>//api.github.com/repos/eightshapes/yahoo-backyard-uitech/@new_issues/1347",
			"state" => "open",
			"number" => 1347,
			"title" => "Found a bug",
			"assignee" => {
				"login" => "jonqdoe"
			},
			"body" => "I'm having a problem with this.",
			# "labels" => '[{"url": "https://api.github.com/repos/eightshapes/yahoo-backyard-uitech/labels/bug","name": "bug","color": "f29513"}]',
			"user" => {
				"login" => "detzi"
			},
			# "milestone" => '{"url": "https://api.github.com/repos/eightshapes/yahoo-backyard-uitech/milestones/1","number": 1,"state": "open","title": "Package 17","description": "","creator": {"login": "eightshapes","id": 1,"avatar_url": "https://github.com/images/error/eightshapes_happy.gif","gravatar_id": "somehexcode","url": "https://api.github.com/users/eightshapes","html_url": "https://github.com/eightshapes","followers_url": "https://api.github.com/users/eightshapes/followers","following_url": "https://api.github.com/users/eightshapes/following{/other_user}","gists_url": "https://api.github.com/users/eightshapes/gists{/gist_id}","starred_url": "https://api.github.com/users/eightshapes/starred{/owner}{/repo}","subscriptions_url": "https://api.github.com/users/eightshapes/subscriptions","organizations_url": "https://api.github.com/users/eightshapes/orgs","repos_url": "https://api.github.com/users/eightshapes/repos","events_url": "https://api.github.com/users/eightshapes/events{/privacy}","received_events_url": "https://api.github.com/users/eightshapes/received_events","type": "User","site_admin": false},"open_@new_issues": 4,"closed_@new_issues": 8,"created_at": "2011-04-10T20:09:31Z","updated_at": "2014-03-03T18:58:10Z","due_on": null}',
			"comments" => 0,
			"created_at" => "2011-04-22T13 =>33 =>48Z",
			"updated_at" => "2011-04-22T13 =>33 =>48Z",
			"closed_at" => 'null'
		}
	end

	it "should create a new local @new_issue record when one doesn't already exist based on the latest information from Github" do
		expect{
			SynchronizeIssueWorker.perform_async(@new_issue["url"], @new_issue["state"], @new_issue["number"], @new_issue["title"], @new_issue["assignee"]["login"], @new_issue["body"], @new_issue["user"]["login"], @new_issue["comments"], @new_issue["created_at"], @new_issue["updated_at"], @new_issue["closed_at"], 1)
		}.to change(Issue, :count).by(1)
	end
end