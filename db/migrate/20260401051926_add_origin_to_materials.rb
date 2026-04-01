class AddOriginToMaterials < ActiveRecord::Migration[8.0]
  def change
    add_column :materials, :origin, :string
  end
end
