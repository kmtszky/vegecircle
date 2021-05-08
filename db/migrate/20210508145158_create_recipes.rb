class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|

      t.references  :farmer,      null: false, foreign_key: true
      t.string  :title,           null: false
      t.string  :recipe_image_id, null: false
      t.integer :duration,        null: false
      t.integer :amount,          null: false
      t.text  :ingredient,        null: false
      t.text  :recipe,            null: false
      t.timestamps
    end

    add_index :recipes, :title
  end
end
