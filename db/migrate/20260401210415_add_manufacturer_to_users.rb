class AddManufacturerToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :manufacturer_name, :string
    add_column :users, :manufacturer_address, :string
  end
end
