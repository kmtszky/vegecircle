class AddRemoveColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :schedules, :is_deleted, :boolean, default: false
    add_reference :reservations, :schedule, foreign_key: true
    remove_column :events, :is_deleted, :boolean, default: false
    remove_column :reservations, :event, foreign_key: true

    remove_index :reservations, :event_id
  end
end
