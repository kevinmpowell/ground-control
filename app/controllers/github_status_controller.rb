class GithubStatusController < WebsocketRails::BaseController
  def initialize_session
    # perform application setup here
    # controller_store[:message_count] = 0
  end

  def send_a_test_reply
  	send_message :github_status, "You are connected to github"
  end
end