class GithubService
  def self.synchronize_issues_for_user user_id
      user = User.find(user_id)
      github = Github.new oauth_token: user.auth_token
      #Todo make these orgs part of the user profile and iterate over them to collect the issues
      @eightshapes_issues = github.issues.list org: 'eightshapes', sort: 'updated', per_page: 100
      @marriott_issues = github.issues.list org: 'marriottdigital', sort: 'updated', per_page: 100

      @github_issues = @eightshapes_issues.to_a.concat(@marriott_issues.to_a)

      @github_issues.each do |issue|
        puts "QUEUED ISSUE"
        SynchronizeIssueWorker.perform_async(issue["url"], issue["state"], issue["number"], issue["title"], issue["assignee"]["login"], issue["body"], issue["user"]["login"], issue["comments"], issue["created_at"], issue["updated_at"], issue["closed_at"], user_id)
      end
  end
end