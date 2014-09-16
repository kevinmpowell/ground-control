class ClientReposController < ApplicationController
  before_action :set_client_repo, only: [:show, :edit, :update, :destroy]
  before_action :set_github_repositories, only: [:new, :create, :edit, :update]

  # GET /client_repos
  # GET /client_repos.json
  def index
    @client_repos = ClientRepo.all
  end

  # GET /client_repos/1
  # GET /client_repos/1.json
  def show
  end

  # GET /client_repos/new
  def new
    @client_repo = ClientRepo.new
  end

  # GET /client_repos/1/edit
  def edit
  end

  # POST /client_repos
  # POST /client_repos.json
  def create
    @client_repo = ClientRepo.new(client_repo_params)

    respond_to do |format|
      if @client_repo.save
        format.html { redirect_to @client_repo, notice: 'Client repo was successfully created.' }
        format.json { render action: 'show', status: :created, location: @client_repo }
      else
        format.html { render action: 'new' }
        format.json { render json: @client_repo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /client_repos/1
  # PATCH/PUT /client_repos/1.json
  def update
    respond_to do |format|
      if @client_repo.update(client_repo_params)
        format.html { redirect_to @client_repo, notice: 'Client repo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @client_repo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /client_repos/1
  # DELETE /client_repos/1.json
  def destroy
    @client_repo.destroy
    respond_to do |format|
      format.html { redirect_to client_repos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client_repo
      @client_repo = ClientRepo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_repo_params
      params.require(:client_repo).permit(:client_name, :repo_name)
    end

    def set_github_repositories
      github = Github.new oauth_token: current_user.auth_token
      github_organizations = ENV['GITHUB_REPO_ORGANIZATIONS'].split(",")
      repos = []
      github_organizations.each do |org|
        repos.concat github.repos.list org: org, sort: 'updated', per_page: 100
      end
      @github_repositories = repos
      @github_repositories_select_options = @github_repositories.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map do |repo| 
        if repo.owner.login.downcase == "eightshapes"
          repo_name = repo.name
        else
          repo_name = "#{repo.owner.login} - #{repo.name}"
        end
        [repo_name, repo.full_name] 
      end
    end
end
