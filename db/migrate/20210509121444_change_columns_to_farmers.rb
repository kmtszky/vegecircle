class ChangeColumnsToFarmers < ActiveRecord::Migration[5.2]
  def change
    change_column :farmers, :name,            :string, null: false
    change_column :farmers, :farmer_image_id, :string
    change_column :farmers, :image_1_id,      :string
  end
end
