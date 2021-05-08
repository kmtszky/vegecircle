class CreateNews < ActiveRecord::Migration[5.2]
  def change
    create_table :news do |t|

      t.references  :farmer,        null: false, foreign_key: true
      t.text        :news,          null: false
      t.string      :news_image_id
      t.timestamps
    end
  end
end
