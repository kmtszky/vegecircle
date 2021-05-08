class AddIndexToRecipeTags < ActiveRecord::Migration[5.2]
  def change
    add_index :recipe_tags, [:recipe_id,:tag_id], unique: true
  end
end
