json.array!(@client_repos) do |client_repo|
  json.extract! client_repo, :id, :client_name, :repo_name
  json.url client_repo_url(client_repo, format: :json)
end
