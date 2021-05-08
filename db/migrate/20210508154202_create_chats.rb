class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|

      t.references :customer, foreign_key: true
      t.references :farmer,   foreign_key: true
      t.integer :chat,        null: false
      t.timestamps
    end
  end
end
