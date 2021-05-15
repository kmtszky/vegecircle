class ChangeColumnsOfEvents < ActiveRecord::Migration[5.2]
  def change
    remove_columns :events, :date, :start_time, :end_time
    add_column :events, :start_date, :date
    add_column :events, :end_date, :date
  end
end
