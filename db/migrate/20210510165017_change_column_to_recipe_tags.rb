class ChangeColumnToRecipeTags < ActiveRecord::Migration[5.2]

  def up
    change_column :recipe_tags, :recipe_id, :bigint
    change_column :recipe_tags, :tag_id, :bigint
  end

  def down
    change_column :recipe_tags, :recipe_id, :integer
    change_column :recipe_tags, :tag_id, :integer
  end
end
