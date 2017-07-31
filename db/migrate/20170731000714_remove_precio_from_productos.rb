class RemovePrecioFromProductos < ActiveRecord::Migration[5.0]
  def change
    remove_column :productos, :precio, :decimal
  end
end
