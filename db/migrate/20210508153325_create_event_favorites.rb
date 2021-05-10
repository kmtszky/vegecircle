class CreateEventFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :event_favorites do |t|

      t.references :customer, null: false, foreign_key: true
      t.references :event,    null: false, foreign_key: true
      t.timestamps
    end
  end
end
