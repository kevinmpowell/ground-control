class UserSerializer < ActiveModel::Serializer
  attributes :id, :last_github_sync_at, :email
end