class ChangeLocationToNoUnique < ActiveRecord::Migration[5.2]
  def change
    remove_index :events, :location
    add_index :events, :location
  end
end
