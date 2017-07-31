class AddCantidadToCompraBebidas < ActiveRecord::Migration[5.0]
  def change
    add_column :compra_bebidas, :cantidad, :integer
  end
end
