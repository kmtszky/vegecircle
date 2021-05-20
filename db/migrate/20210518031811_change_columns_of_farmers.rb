class ChangeColumnsOfFarmers < ActiveRecord::Migration[5.2]
  def up
    add_column :farmers, :store_latitude, :float
    add_column :farmers, :store_longitude, :float
    add_column :events, :latitude, :float
    add_column :events, :longitude, :float
    add_reference :chats, :event, foreign_key: true
    remove_column :farmers, :prefecture
    change_column :reservations, :people, :integer, null: false
    change_column :schedules, :people, :integer, null: false
  end

  def down
    change_column :reservations, :people, :integer, null: true
    change_column :schedules, :people, :integer, null: true
  end
end
