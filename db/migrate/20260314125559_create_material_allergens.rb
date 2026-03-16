class CreateMaterialAllergens < ActiveRecord::Migration[8.0]
  def change
    create_table :material_allergens do |t|
      t.references :material, null: false, foreign_key: true
      t.references :allergen, null: false, foreign_key: true

      t.timestamps
    end

    add_index :material_allergens, %i[material_id allergen_id], unique: true
  end
end
