class CreateProductMaterials < ActiveRecord::Migration[8.0]
  def change
    create_table :product_materials do |t|
      t.references :product, null: false, foreign_key: true
      t.references :material, null: false, foreign_key: true
      t.decimal :quantity, precision: 10, scale: 2, null: false

      t.timestamps
    end

    add_index :product_materials, [ :product_id, :material_id ], unique: true
  end
end
