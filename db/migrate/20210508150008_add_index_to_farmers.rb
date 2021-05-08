class AddIndexToFarmers < ActiveRecord::Migration[5.2]
  def change
    add_index :farmers, :name
  end
end
