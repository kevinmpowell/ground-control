class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!

  def home
  end

  private
	def admin_user?
    unless current_user.admin?
      redirect_to root_path, notice: "You must be an admin to access that area."
    end
  end

  def set_github_repositories
    github = Github.new oauth_token: current_user.auth_token
    @github_repositories = github.repos.list org: ENV['GITHUB_ORGANIZATION_NAME'], sort: 'updated', per_page: 100
    @github_repositories_select_options = @github_repositories.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|repo| [repo.name, repo.ssh_url]}
    @github_repositories_ssh_url_to_full_name_map = Hash[@github_repositories.map { |repo| [repo.ssh_url, repo.full_name] }]
  end
end
