class CreateAllergens < ActiveRecord::Migration[8.0]
  def change
    create_table :allergens do |t|
      t.string :name, null: false
      t.string :label_name, null: false
      t.boolean :required, null: false, default: false

      t.timestamps
    end

    add_index :allergens, :name, unique: true
  end
end
