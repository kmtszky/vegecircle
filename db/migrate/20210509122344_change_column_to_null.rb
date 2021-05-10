class ChangeColumnToNull < ActiveRecord::Migration[5.2]
  def up
    change_column :farmers, :farmer_image_id, :string, null: true
    change_column :farmers, :image_1_id,      :string, null: true
    change_column :farmers, :introduction,    :text,   null: true
  end

  def down
    change_column :farmers, :farmer_image_id, :string, null: false
    change_column :farmers, :image_1_id,      :string, null: false
    change_column :farmers, :introduction,    :text,   null: false
  end
end
