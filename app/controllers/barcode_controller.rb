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
	    @compra.estado = "PENDIENTE"
	    @compra.productos = params[:productos]
	    @compra.bebidas = params[:bebidas]
	    if params[:productos] == nil
      		flash[:error] = "Debe seleccionar al menos 1 producto!"
            redirect_to :action => "new"      
   		else
      		@compra.valor_final_ticket = sumarPrecioBebidas(params[:bebidas]) + valorTicket
	    	if @compra.save	    	
	      		redirect_to :action => "show"  
	    	end
	    end 
  	end


  	# Retorna la suma los precios de las bebidas seleccionadas
	  def sumarPrecioBebidas(valor)
	    lasBebidas = valor
	    suma = 0
	    if lasBebidas != nil      
	      lasBebidas.each do |b|
	        bebAux = Bebida.find(b.to_i)
	        suma = suma + bebAux.precio
	      end
	      return suma
	    end
	    return suma
	  end

	  # Retorna el precio final del ticket segun el sueldo del usuario y las franjas definidas
	  def valorTicket    
	    usuario = $usuarioBarcode
	    menu = Menu.find_by(fecha: Time.now)
	    # byebug
	    franjaActual = Franja.last
	    if menu == nil
	      return 0
	    end
	    if usuario != nil && franjaActual != nil

	      if usuario.salario <= franjaActual.primera_hasta
	        return franjaActual.primera_precio
	      elsif usuario.salario >= franjaActual.primera_hasta && usuario.salario <= franjaActual.segunda_hasta
	        return franjaActual.segunda_precio
	      else
	        return franjaActual.tercera_precio
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
