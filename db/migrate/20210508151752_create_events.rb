class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|

      t.references :farmer,     null: false, foreign_key: true
      t.string :title,	        null: false
      t.string :plan_image_id,  null: false
      t.text :body,	            null: false
      t.integer :fee,	          null: false
      t.text :cancel_change,	  null: false
      t.date :date,             null: false
      t.time :start_time,       null: false
      t.time :end_time,         null: false
      t.string :location,       null: false
      t.text :access,           null: false
      t.integer :parking,       null: false, default: 0
      t.text :etc
      t.timestamps
    end

    add_index :events, :location, unique: true
  end
end
