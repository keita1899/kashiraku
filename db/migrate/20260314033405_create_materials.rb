class CreateMaterials < ActiveRecord::Migration[8.0]
  def change
    create_table :materials do |t|
      t.string :name, null: false
      t.string :display_name
      t.decimal :purchase_price, precision: 10, scale: 2, null: false
      t.decimal :purchase_quantity, precision: 10, scale: 2, null: false
      t.string :unit, null: false
      t.decimal :unit_price, precision: 10, scale: 4, null: false
      t.boolean :additive, null: false, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
