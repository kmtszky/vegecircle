class ChangeScheduleToNullFalse < ActiveRecord::Migration[5.2]
  def up
    change_column :reservations, :schedule_id, :integer, null: false
    remove_column :reservations, :event_id, :integer
  end

  def down
    change_column :reservations, :schedule_id, :integer, null: true
  end
end
