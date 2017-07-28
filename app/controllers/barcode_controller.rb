class BarcodeController < ApplicationController
	 skip_before_filter :authenticate_cuentum!


	def index    
    	@usuario = nil
  		$usuarioBarcode = nil
 	end

 	def get_barcode		
		ci = params[:cedula][:ci]
		@usuario = Usuario.find_by(ci: ci)		  	
		if @usuario == nil	  		
		  	flash[:error] = "Usuario no valido, por favor comuniquese con el Administrador!"
		  	redirect_to :action => "index"
		else	
			compras = Compra.where(fecha: Time.now.to_date)
			franjaActual = Franja.last			
		    compras.each do |c|
			    if @usuario.cuenta_id == c.cuentum_id
			        flash[:error] = "Ya has realizado un compra hoy, no puedes repetir!!"
			        redirect_to :action => "index"
			    end		    
		    end
		    if franjaActual == nil		    	
		    	flash[:error] = "No se reunen las condiciones para realizar una compra! Por favor, comuniquese con el administrador. (error: franjas)"
		        redirect_to :action => "index"
		    end
		end
	    $usuarioBarcode = @usuario	
  	end

  	def new
  		if $usuarioBarcode == nil
  			get_barcode
  		end
	    @barcode = Compra.new
	    @bebidas = Bebida.all
	    
	    @tipos = Tipo.all
	    @menus = Menu.all
	    @menus.each do |menu|
	      if menu.fecha.to_date == Time.now.to_date
	        @productos = menu.productos.all
	      end  
	    end 
 	end

 	def create
	    @bebidas = Bebida.all   
	    @menus = Menu.all
	    @menus.each do |menu|
	      if menu.fecha.to_date == Time.now.to_date
	        @productos = menu.productos.all
	      end  
	    end 	    
	    cuenta = Cuentum.find_by(id: $usuarioBarcode.cuenta_id)
	    @compra = cuenta.compras.new(compra_params)
	    @compra.fecha =Time.now
	    @compra.productos = params[:productos]
	    @compra.bebidas = params[:bebidas]
	    if params[:productos] == nil
      		flash[:error] = "Debe seleccionar al menos 1 producto!"
            redirect_to :action => "new"      
   		else
      		# @compra.valor_final_ticket = sumarPrecioBebidas(params[:bebidas]) + valorTicket
	    	if @compra.save	    	
	      		redirect_to :action => "show"  
	    	end
	    end 
  	end

  	def show
  		@message = ">>>	La Compra se realizo exitosamente!!"
  		@usuario = nil
  		$usuarioBarcode = nil
  	end

  	def id_params
      params.require(:cedula).permit(:ci)
    end

  	def compra_params
      params.require(:compra).permit(:fecha, :productos, :bebidas)
    end
end
