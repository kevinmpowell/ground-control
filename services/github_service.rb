class GithubService
  def self.synchronize_issues_for_user user_id
      user = User.find(user_id)
      github = Github.new oauth_token: user.auth_token
      #Todo make these orgs part of the user profile and iterate over them to collect the issues
      user_orgs = ['eightshapes', 'marriottdigital']
      issues = Issue.where({user_id: user_id, archived: false}).all

      user_orgs.each do |org_name|
        args = {org: org_name, sort: 'updated', per_page: 100}
        args[:since] = user.last_github_sync_at.utc.iso8601 unless user.last_github_sync_at.nil?

        org_issues = github.issues.list args
        issues = issues.to_a.concat(org_issues.to_a)
      end

      issues.uniq! {|i| i["url"]}

      PusherService.trigger_event_on_user_channel(user, 'github_issue_sync_count', {
        total_issues: issues.count
      })

      issues.each do |issue|
        SynchronizeIssueWorker.perform_async(issue["url"], user_id)
      end

      user.update_attributes({last_github_sync_at: Time.now})
  end

  def self.get_issue_data github_org, repo, number, auth_token
    github = Github.new oauth_token: auth_token
    github.issues.get(github_org, repo, number).to_hash
  end

  def self.get_issue_data_via_url url, auth_token
    url_data = url.sub('https://api.github.com/', '').split('/')
    self.get_issue_data(url_data[1], url_data[2], url_data[4], auth_token)
  end
end