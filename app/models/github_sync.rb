class GithubSync < ActiveRecord::Base
   validates :user_id, presence: true
end
