class AddEstadoToCompras < ActiveRecord::Migration[5.0]
  def change
  	add_column :compras, :estado, :string
  end
end
