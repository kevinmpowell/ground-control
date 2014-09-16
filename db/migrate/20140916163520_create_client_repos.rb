class CreateClientRepos < ActiveRecord::Migration
  def change
    create_table :client_repos do |t|
      t.string :client_name
      t.string :repo_name

      t.timestamps
    end
  end
end
