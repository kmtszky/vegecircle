class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|

      t.references :customer, foreign_key: true
      t.references :farmer,   foreign_key: true
      t.text :chat,           null: false
      t.string :chat_image_id
      t.timestamps
    end
  end
end
