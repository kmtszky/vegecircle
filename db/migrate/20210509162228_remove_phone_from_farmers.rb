class RemovePhoneFromFarmers < ActiveRecord::Migration[5.2]
  def change
    remove_column :farmers, :phone, :integer
  end
end
