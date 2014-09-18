class ClientRepo < ActiveRecord::Base
   validates :client_name, presence: true
   validates :repo_name, presence: true, uniqueness: true

	default_scope { order('repo_name ASC') }
end