class AddRemoveColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :schedules, :is_deleted, :boolean, default: false
    add_reference :reservations, :schedule
    remove_column :events, :is_deleted, :boolean, default: false
    remove_column :reservations, :event_id, foreign_key: true
  end
end
