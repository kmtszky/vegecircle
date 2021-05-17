class AddCommentToEvaluations < ActiveRecord::Migration[5.2]
  def change
    add_column :evaluations, :comment, :text
    add_column :evaluations, :evaluation_image_id, :string
    remove_column :chats, :chat_image_id, :string
  end
end
