class CreateIssue < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :url
      t.string :title
      t.text :body
      t.string :state
      t.integer :number
      t.string :assignee
      t.string :labels
      t.string :creator
      t.string :milestone_name
      t.date :milestone_due_on
      t.string :milestone_state
      t.integer :comment_count
      t.datetime :issue_created_at
      t.datetime :issue_updated_at
      t.boolean :closed
      t.datetime :closed_at
      t.boolean :locally_sorted
      t.integer :local_sort_order
      t.integer :client_id
      t.integer :user_id
    end
  end
end
