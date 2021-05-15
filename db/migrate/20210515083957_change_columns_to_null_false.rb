class ChangeColumnsToNullFalse < ActiveRecord::Migration[5.2]
  def up
    change_column :events, :start_date, :date, null: false
    change_column :events, :end_date,   :date, null: false
  end

  def down
    change_column :events, :start_date, :date, null: true
    change_column :events, :end_date,   :date, null: true
  end
end
