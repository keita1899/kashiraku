class CreateFoodLabels < ActiveRecord::Migration[8.0]
  def change
    create_table :food_labels do |t|
      t.references :product, null: false, foreign_key: true, index: { unique: true }
      t.string :product_name, null: false
      t.string :content_quantity, null: false
      t.string :expiration_date, null: false
      t.string :storage_method, null: false
      t.string :manufacturer_name, null: false
      t.string :manufacturer_address, null: false

      t.timestamps
    end
  end
end
