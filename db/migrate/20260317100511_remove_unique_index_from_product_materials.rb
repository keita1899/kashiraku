class RemoveUniqueIndexFromProductMaterials < ActiveRecord::Migration[8.0]
  def change
    remove_index :product_materials, [ :product_id, :material_id ], unique: true
  end
end
