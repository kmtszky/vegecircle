class ChangeScheduleToNullFalse < ActiveRecord::Migration[5.2]
  def change
    change_column :reservations, :schedule_id, :integer, null: false
    remove_column :reservations, :event_id, :integer
  end
end
