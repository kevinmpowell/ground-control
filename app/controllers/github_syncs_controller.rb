class GithubSyncsController < ApplicationController
  # before_action :set_github_sync, only: [:show, :edit, :update, :destroy]

  # # GET /github_syncs
  # def index
  #   @github_syncs = GithubSync.all
  # end

  # # GET /github_syncs/1
  # def show
  # end

  # # GET /github_syncs/new
  # def new
  #   @github_sync = GithubSync.new
  # end

  # # GET /github_syncs/1/edit
  # def edit
  # end

  def last_github_sync_for_user
    @sync = GithubSync.where({user_id: params[:user_id], complete: true}).order('updated_at desc').first
    render json: @sync
  end

  def complete_github_sync_for_user
    @sync = GithubSync.where({user_id: params[:user_id], complete: false}).order('updated_at desc').first
    @sync.complete = true
    @sync.save

    render json: @sync
  end

  # # POST /github_syncs
  # def create
  #   @github_sync = GithubSync.new(github_sync_params)

  #   if @github_sync.save
  #     redirect_to @github_sync, notice: 'Github sync was successfully created.'
  #   else
  #     render :new
  #   end
  # end

  # # PATCH/PUT /github_syncs/1
  # def update
  #   if @github_sync.update(github_sync_params)
  #     redirect_to @github_sync, notice: 'Github sync was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end

  # # DELETE /github_syncs/1
  # def destroy
  #   @github_sync.destroy
  #   redirect_to github_syncs_url, notice: 'Github sync was successfully destroyed.'
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_github_sync
  #     @github_sync = GithubSync.find(params[:id])
  #   end

  #   # Only allow a trusted parameter "white list" through.
  #   def github_sync_params
  #     params.require(:github_sync).permit(:complete)
  #   end
end
