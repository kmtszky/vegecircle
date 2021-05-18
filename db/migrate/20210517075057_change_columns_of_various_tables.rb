class ChangeColumnsOfVariousTables < ActiveRecord::Migration[5.2]
  def change
    add_column :evaluations, :comment, :text
    add_column :evaluations, :evaluation_image_id, :string
    add_column :farmers, :prefecture, :string
    add_column :reservations, :people, :integer
    add_column :schedules, :people, :integer
    remove_column :chats, :chat_image_id, :string
    add_index :farmers, :prefecture
  end
end
