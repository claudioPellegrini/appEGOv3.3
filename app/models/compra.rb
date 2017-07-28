# require 'observer'
class Compra < ApplicationRecord
	belongs_to :cuentum
	after_create :save_comprados
	after_update :edit_comprados
	has_many :compra_productos
	has_many :productos, through: :compra_productos
	has_many :compra_bebidas
	has_many :bebidas, through: :compra_bebidas
	after_create :actualizo_stock
	before_destroy :actualizo_stock_destroy
	has_one :calificacion
	
	# after_create :envio_aviso
	# after_update :envio_aviso
	# after_destroy :envio_aviso

	include Wisper::Publisher
	# after_commit :publish_creation_successful, on: :create
	# after_validation :publish_creation_failed, on: :create

	# def commit (_attrs = nil)
	# 	assign_attributes(_attrs) if _attrs.present?
	# 	result = save
	# 	if result
	# 		broadcast(:compra_create_successful, self)
	# 	else
	# 		broadcast(:compra_create_failed, self)
	# 	end
	# 	result

	# end


	# after_create do
	# 	#broadcast(:after_create, self)
	# 	#byebug

	# end

	# def call(compra_id)
	# 	compra = Compra.find_by_id(compra_id)

	# 	if compra.comprado
	# end

	
	# include Observable

	def productos=(value)

		@productos = value
	end
	def bebidas=(value)
		@bebidas = value
	end

	def save_comprados
		# byebug
		if @productos != nil
			@productos.each do |producto_id|
				CompraProducto.create(producto_id: producto_id, compra_id: self.id)
			end
		end
		if @bebidas != nil
			@bebidas.each do |bebida_id|
				CompraBebida.create(bebida_id: bebida_id, compra_id: self.id)

			end
		end
	end
	def actualizo_stock
		if @bebidas != nil
			@bebidas.each do |bebida_id|
				
				mi_bebida = Stock.where(bebida_id: bebida_id)
				saldo = mi_bebida.last.cant - 1
				mi_bebida.update(cant: saldo )
				
			end
		end
		# changed
		# notify_observers()
		# add_observer(Notifier.new)
	end

	def envio_aviso
		PedidoController.actualizo
		# byebug
	end

	def edit_comprados
		
		CompraProducto.where(compra_id: self.id).destroy_all
		if @productos != nil
			@productos.each do |producto_id|
			
			CompraProducto.create(producto_id: producto_id, compra_id: self.id)
			
			end
		end
		
		CompraBebida.where(compra_id: self.id).destroy_all
		if @bebidas != nil
			@bebidas.each do |bebida_id|
			
			CompraBebida.create(bebida_id: bebida_id, compra_id: self.id)
			
			end
		end
		# notify_observers(self, @productos)
	end

	def destroy_comprados
		CompraProducto.where(compra_id:self.id).destroy_all
		CompraBebida.where(compra_id:self.id).destroy_all
		# notify_observers(self, @productos)
	end

	def actualizo_stock_destroy
		
		if self.bebidas != nil
			
			self.bebidas.each do |bebida_id|
				
				mi_bebida = Stock.where(bebida_id: bebida_id)
				saldo = mi_bebida.last.cant + 1
				mi_bebida.update(cant: saldo )
				
			end
		end
		destroy_comprados
	end

	private

	def publish_creation_successful
		broadcast(:compra_creation_successful, self)
	end

	def publish_creation_failed
		broadcast(:compra_creation_failed, self) if errors.any?
	end
end
