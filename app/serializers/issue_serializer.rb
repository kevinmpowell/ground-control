class IssueSerializer < ActiveModel::Serializer
  attributes :id, :title, :url, :html_url, :state, :number, :client_name, :repo_name, :closed

  # url :issue
end
