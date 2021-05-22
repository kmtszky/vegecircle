class AddRemoveColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :reservations, :event, foreign_key: true

    remove_index :reservations, :event_id
  end
end
