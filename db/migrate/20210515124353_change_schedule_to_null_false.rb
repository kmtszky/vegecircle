class ChangeScheduleToNullFalse < ActiveRecord::Migration[5.2]
  def up
    change_column :reservations, :schedule_id, :integer, null: false
  end

  def down
    change_column :reservations, :schedule_id, :integer, null: true
  end
end
