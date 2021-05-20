class ChangeColumnsToNullFalse2 < ActiveRecord::Migration[5.2]
  def up
    change_column :farmers, :store_latitude, :float, null: false
    change_column :farmers, :store_longitude, :float, null: false
    change_column :events, :latitude, :float, null: false
    change_column :events, :longitude, :float, null: false
    change_column :chats, :event_id, :integer, null: false
  end

  def down
    change_column :farmers, :store_latitude, :float, null: true
    change_column :farmers, :store_longitude, :float, null: true
    change_column :events, :latitude, :float, null: true
    change_column :events, :longitude, :float, null: true
    change_column :chats, :event_id, :integer, null: true
  end
end
