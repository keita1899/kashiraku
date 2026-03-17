class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.integer :sales_price, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
