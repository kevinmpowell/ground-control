class AddColumnsToIssue < ActiveRecord::Migration
  def change
	add_column :issues, :repo_name, :string
	add_column :issues, :client_name, :string
  end
end
