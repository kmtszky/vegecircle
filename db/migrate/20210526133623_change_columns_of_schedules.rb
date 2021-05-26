class ChangeColumnsOfSchedules < ActiveRecord::Migration[5.2]
  def up
    change_column :schedules, :start_time, :datetime
    change_column :schedules, :end_time, :datetime
  end

  def down
    change_column :schedules, :start_time, :time
    change_column :schedules, :end_time, :time
  end
end
