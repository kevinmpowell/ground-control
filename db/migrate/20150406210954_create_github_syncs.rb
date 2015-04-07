class CreateGithubSyncs < ActiveRecord::Migration
  def change
    create_table :github_syncs do |t|
      t.boolean :complete, default: false
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
