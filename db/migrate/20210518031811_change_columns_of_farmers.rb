class ChangeColumnsOfFarmers < ActiveRecord::Migration[5.2]
  def up
    remove_column :farmers, :prefecture
    change_column :reservations, :people, :integer, null: false
    change_column :schedules, :people, :integer, null: false

  end

  def down
    change_column :reservations, :people, :integer, null: true
    change_column :schedules, :people, :integer, null: true
  end
end
