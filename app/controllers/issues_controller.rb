class IssuesController < ApplicationController
  # before_action :set_client_repo, only: [:show, :edit, :update, :destroy]
  # before_action :set_github_repositories, only: [:new, :create, :edit, :update]

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
end
