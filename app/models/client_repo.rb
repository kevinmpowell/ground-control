class ClientRepo < ActiveRecord::Base
   validates :client_name, presence: true
   validates :repo_name, presence: true
end
