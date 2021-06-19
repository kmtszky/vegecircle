class AddColumnToNotices < ActiveRecord::Migration[5.2]
  def change
    add_reference :notices, :reservation, foreign_key: true
  end
end
