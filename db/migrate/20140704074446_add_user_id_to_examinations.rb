class AddUserIdToExaminations < ActiveRecord::Migration
  def change
    add_column :examinations, :user_id, :integer
  end
end
