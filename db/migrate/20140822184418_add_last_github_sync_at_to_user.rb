class AddLastGithubSyncAtToUser < ActiveRecord::Migration
  def change
	add_column :users, :last_github_sync_at, :datetime
  end
end
