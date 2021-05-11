class AddIsDeletedToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :is_deleted, :boolean, default: false
  end
end
