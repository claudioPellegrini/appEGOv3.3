
class Menu < ApplicationRecord
	has_many :tiene_productos
	has_many :productos, through: :tiene_productos
	# has_many :venta, dependent: :destroy
	after_create :save_productos
	after_update :edit_productos
	before_destroy :destroy_productos

	validates :fecha, uniqueness: {message: "^Ya existe menu para esa fecha"}
	validates :save_productos, presence: {message: "^Debe ingresar al menos 1 producto"}

	


	def productos=(value)
		@productos = value
	end

	def save_productos
		if @productos != nil
			@productos.each do |producto_id|
				TieneProducto.create(producto_id: producto_id, menu_id: self.id)
			end
		end
		
	end

	def edit_productos
		
		TieneProducto.where(menu_id: self.id).destroy_all
		
		@productos.each do |producto_id|
		
		TieneProducto.create(producto_id: producto_id, menu_id: self.id)
		
		end
		
	end

	def destroy_productos
		TieneProducto.where(menu_id:self.id).destroy_all
		
	end
end
