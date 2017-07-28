class ComprasController < ApplicationController
  before_action :set_compra, only: [:show, :edit, :update, :destroy]
  
  # GET /compras
  # GET /compras.json
  def index
    @compras = current_cuentum.compras.order('fecha DESC')

  end

  # GET /compras/1
  # GET /compras/1.json
  def show
    @bebidas = Bebida.all
    @productos = Producto.all
    @productos_en_compra = Array.new
    @bebidas_en_compra = Array.new
    compra_prod_bd = CompraProducto.where(compra_id: @compra.id)
    compra_beb_bd = CompraBebida.where(compra_id: @compra.id)
     compra_prod_bd.each do |prod|
        @productos.each do |p|
          if prod.producto_id == p.id
            @productos_en_compra.push(p)
          end
        end         
      end
      compra_beb_bd.each do |beb|
        @bebidas.each do |b|
          if beb.bebida_id == b.id
            @bebidas_en_compra.push(b)
          end
        end         
      end

    @tipos =Tipo.all
  end

  # GET /compras/new
  def new
    menu = Menu.find_by(fecha: Time.now.to_date)
    franjaActual = Franja.last
    if menu == nil
      @div_compra = false
      @div_msg_menu = true
    elsif franjaActual == nil
      @div_compra = false
      @div_msg_franja = true
    else
      @div_compra = true
      @div_msg = false
      compras = Compra.where(fecha: Time.now.to_date)
      compras.each do |c|
        if current_cuentum.id == c.cuentum_id
          flash[:error] = "Ya has realizado un compra hoy, no puedes repetir!!"
          redirect_to :action => "index"
        end
      end
        @compra = Compra.new
        @bebidas = Bebida.all    
        @tipos = Tipo.all
        @menus = Menu.all
        @menus.each do |menu|
          if menu.fecha.to_date == Time.now.to_date
            @productos = menu.productos.all
          end  
        end 
    end
  end

  # GET /compras/1/edit
  def edit
    @tipos =Tipo.all
    @menus = Menu.all
    @bebidas =Bebida.all
    @menus.each do |menu|
      if menu.fecha.to_date == Time.now.to_date
        @productos = menu.productos.all
      end  
    end 
  end

  # POST /compras
  # POST /compras.json
  def create
    usuarios = Usuario.all
    @bebidas = Bebida.all   
    @menus = Menu.all
    @menus.each do |menu|
      if menu.fecha.to_date == Time.now.to_date
        @productos = menu.productos.all
      end  
    end 
    

    @compra = current_cuentum.compras.new(compra_params)
    @compra.fecha =Time.now
    @compra.productos = params[:productos]
    @compra.bebidas = params[:bebidas]  

    if params[:productos] == nil
      flash[:error] = "Debe seleccionar al menos 1 producto!"
            redirect_to :action => "new"
      
    else
      @compra.valor_final_ticket = sumarPrecioBebidas(params[:bebidas]) + valorTicket

      # @compra.subscribe(PedidoController.new)

      # @compra.on(:compra_create_succesfull) { redirect_to compras_path }
      # @compra.on(:compra_create_failed) { render :action => :new }
      # @compra.commit

      respond_to do |format|
        if @compra.save
          # @compra.on(:compra_creation_successful)
          format.html { redirect_to @compra, notice: 'La Compra fue creada correctamente.' }
          format.json { render :show, status: :created, location: @compra }
        else
          # @compra.on(:compra_creation_failed)
          format.html { render :new }
          format.json { render json: @compra.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /compras/1
  # PATCH/PUT /compras/1.json
  def update
    @tipos =Tipo.all
    @menus = Menu.all
    @bebidas =Bebida.all
    @menus.each do |menu|
      if menu.fecha.to_date == Time.now.to_date
        @productos = menu.productos.all
      end  
    end 
    respond_to do |format|
      if @compra.update(compra_params)
        format.html { redirect_to @compra, notice: 'Compra actualizada correctamente.' }
        format.json { render :show, status: :ok, location: @compra }
      else
        format.html { render :edit }
        format.json { render json: @compra.errors, status: :unprocessable_entity }
      end
    end

    # @compra.subscribe(Notifier.new)
    # @compra.on(:compra_update_successful) { redirect_to compras_path }
    # @compra.on(:compra_update_failed) { render :action => :edit }
    # @compra.commit(params[:compra])
  end

  # DELETE /compras/1
  # DELETE /compras/1.json
  def destroy
    @bebidas = @compra.bebidas.all
    
    @compra.destroy
    respond_to do |format|
      format.html { redirect_to compras_url, notice: 'La Compra fue eliminada correctamente.' }
      format.json { head :no_content }
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
    usuario = Usuario.find_by(cuenta_id: current_cuentum.id)
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

  private


    # Use callbacks to share common setup or constraints between actions.
    def set_compra
      @compra = Compra.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def compra_params
      params.require(:compra).permit(:fecha, :productos, :bebidas)
    end

  

end
