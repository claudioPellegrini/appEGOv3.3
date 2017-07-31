class PedidoController < ApplicationController
	after_action :index
	
	def index
		if current_cuentum.email == "admin@admin.com"
        	@div_pedido = true
        	@div_usuario = false
    	end 
	  	@compras = Compra.where("estado = 'PENDIENTE'")
	  	
	end


	def after_created(compra)
		byebug
	end

	def self.actualizo
	  	# byebug
	  	@compras = Compra.all.order('fecha DESC')
	  	render :action => "index"

	  	# redirect_to pruebo
	  	# respond_to do |format|
	   #    format.html 
	   #    format.json 
	   #  end
	end

	
  



end
