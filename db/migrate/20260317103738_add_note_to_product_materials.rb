class AddNoteToProductMaterials < ActiveRecord::Migration[8.0]
  def change
    add_column :product_materials, :note, :string
  end
end
