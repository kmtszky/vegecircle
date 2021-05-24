class AddIsFullToSchedule < ActiveRecord::Migration[5.2]
  def change
    add_column :schedules, :is_full, :boolean, default: false
  end
end
