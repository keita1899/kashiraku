class AddNutritionToMaterials < ActiveRecord::Migration[8.0]
  def change
    add_column :materials, :energy, :decimal, precision: 10, scale: 2
    add_column :materials, :protein, :decimal, precision: 10, scale: 2
    add_column :materials, :fat, :decimal, precision: 10, scale: 2
    add_column :materials, :carbohydrate, :decimal, precision: 10, scale: 2
    add_column :materials, :salt, :decimal, precision: 10, scale: 2
  end
end
