class IssuesController < ApplicationController
  before_action :issue, only: [:update]
  # before_action :set_github_repositories, only: [:new, :create, :edit, :update]

  # GET /issues.json
  def index
    @issues = Issue.where({assignee: current_user.github_username})

    render json: @issues
  end  

  # GET /issues.json
  def show
    @issue = issue

    render json: @issue, root: "issue"
  end

  # PUT /update_issue_sort_order.json
  def update_issue_sort_order
    sorted_issue_ids = params[:sorted_issue_ids]
    sorted_issue_ids.each_with_index do |issue_id, index|
      issue = Issue.find(issue_id)
      issue.local_sort_order = index
      issue.locally_sorted = true
      issue.save
    end

    render nothing: true
  end  

  # PATCH/PUT /issues/1.json
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.json { head :no_content }
      else
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def issue
    @issue = Issue.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def issue_params
    params.require(:issue).permit(:archived)
  end
end
