class CreateNotices < ActiveRecord::Migration[5.2]
  def change
    create_table :notices do |t|
      t.references :farmer, foreign_key: true
      t.references :customer, foreign_key: true
      t.references :event, foreign_key: true
      t.integer :action, null: false
      t.boolean :checked, default: false

      t.timestamps
    end
  end
end
