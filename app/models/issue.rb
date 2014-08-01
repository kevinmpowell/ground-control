class Issue < ActiveRecord::Base
   validates :url, presence: true, uniqueness: true
   validates :user_id, presence: true
   validates :number, presence: true
   validates :issue_created_at, presence: true

   belongs_to :user
end