class AddCustomerImageIdToCustomers < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :customer_image_id, :string
  end
end
