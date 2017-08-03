class ComprasController < ApplicationController
  before_action :set_compra, only: [:show, :edit, :update, :destroy]
  
  # GET /compras
  # GET /compras.json
  def index
    usuarios = Usuario.all
    $i = 0
    usuarios.each do |u|
      if cuentum_signed_in? && current_cuentum.id == u.cuenta_id
        if current_cuentum.email == "admin@admin.com" || u.rol == "ADMINISTRADOR" || u.rol == "OPERARIO"
          @div_pedido = true
          @div_usuario = false
          @div_tiempo_pedidos = true    
          @compras = Compra.where("estado = 'PENDIENTE'")  
        else
          @div_pedido = false
          @div_usuario = true
          @div_tiempo_pedidos = false
          @compras = current_cuentum.compras.order('fecha DESC')
        end
      end
    end
    
  end


  # GET /compras/1
  # GET /compras/1.json
  def show    
    # control_usuario
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
    control_usuario
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
    control_pedidos 
     @div_tiempo_pedidos = false   
    # @tipos =Tipo.all
    # @menus = Menu.all
    # @bebidas =Bebida.all
    # @menus.each do |menu|
    #   if menu.fecha.to_date == Time.now.to_date
    #     @productos = menu.productos.all
    #   end  
    # end 
    @usuario = Usuario.find_by(cuenta_id: @compra.cuentum.id)
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
    # @compra.estado = "FINALIZADO"
    # @compra.save
  end

  # POST /compras
  # POST /compras.json
  def create
    control_usuario
    @cantidad = params[:cantidad]
    
    byebug
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
    @compra.estado = "PENDIENTE"
    @compra.productos = params[:productos]
    @compra.bebidas = params[:bebidas]  
    @compra.defino_cantidad(@cantidad)
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
          # @compra.defino_cantidad(:cant)
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
    @compra.update(compra_params)
    redirect_to compras_path
    # control_usuario
    # @tipos =Tipo.all
    # @menus = Menu.all
    # @bebidas =Bebida.all
    # @menus.each do |menu|
    #   if menu.fecha.to_date == Time.now.to_date
    #     @productos = menu.productos.all
    #   end  
    # end 
    # respond_to do |format|
    #   if @compra.update(compra_params)
    #     format.html { redirect_to @compra, notice: 'Compra actualizada correctamente.' }
    #     format.json { render :show, status: :ok, location: @compra }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @compra.errors, status: :unprocessable_entity }
    #   end
    # end

    # @compra.subscribe(Notifier.new)
    # @compra.on(:compra_update_successful) { redirect_to compras_path }
    # @compra.on(:compra_update_failed) { render :action => :edit }
    # @compra.commit(params[:compra])
  end

  # DELETE /compras/1
  # DELETE /compras/1.json
  def destroy
    control_usuario
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

  # control de tipo de usuario logueado
  def control_usuario
    if current_cuentum.email == "admin@admin.com"
      redirect_back(fallback_location: 'welcome/index')
      return
    end
    usuarios = Usuario.all
    usuarios.each do |u|
      if cuentum_signed_in? && current_cuentum.id == u.cuenta_id
        if u.rol == "ADMINISTRADOR" || u.rol == "OPERARIO"
              redirect_to "welcome/index"         
        end
      end
    end
  end

  def pedido
    byebug
    @compra.estado = "FINALIZADO"
  end


  def control_pedidos   
    usuarios = Usuario.all
    usuarios.each do |u|
      if cuentum_signed_in? && current_cuentum.id == u.cuenta_id
        if u.rol == "USUARIO" 
              redirect_to "welcome/index"         
        end
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
      params.require(:compra).permit(:fecha, :productos, :bebidas, :valor, :estado, :cantidad)
    end

#    <% if @bebidas.present? %>
#     <p><label>Seleccione su Bebida </label></p>
#      <%= select_tag "miBebida", options_for_select(Bebida.find_by_sql("SELECT b.nombre, b.tipo, b.tamanio, s.cant
#   FROM bebidas as b join stocks as s on b.id = s.bebida_id and cant >0 group by b.nombre, b.tipo, b.tamanio, s.cant").collect{ |u| [ u.nombre+" - "+ u.tipo+ " - "+ u.tamanio,  u.id]}) %>  
# <b>    Cantidad: </b><input id="cantidad1" name="cantidad1" min="1"   step= "1" type="number" />
#   <%end%>

end
