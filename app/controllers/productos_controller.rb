class ProductosController < ApplicationController
  before_action :set_producto, only: [:show, :edit, :update]

  # GET /productos
  # GET /productos.json
  def index
    control_usuario
    @productos = Producto.all
    @tipos = Tipo.all
  end


  # GET /productos/1
  # GET /productos/1.json
  def show    
    control_usuario
  end

  # GET /productos/new
  def new
    control_usuario
    @producto = Producto.new
  end

  # GET /productos/1/edit
  def edit
    control_usuario
  end

  # POST /productos
  # POST /productos.json
  def create
    control_usuario
    @producto = Producto.new(producto_params)
    @producto.nombre =  @producto.nombre.upcase
    respond_to do |format|
      if @producto.save
        format.html { redirect_to @producto, notice: 'El Producto se ha creado correctamente.' }
        format.json { render :show, status: :created, location: @producto }
      else
        format.html { render :new }
        format.json { render json: @producto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /productos/1
  # PATCH/PUT /productos/1.json
  def update
    control_usuario
    respond_to do |format|
      if @producto.update(producto_params)
        format.html { redirect_to @producto, notice: 'El Producto se ha editado correctamente.' }
        format.json { render :show, status: :ok, location: @producto }
      else
        format.html { render :edit }
        format.json { render json: @producto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /productos/1
  # DELETE /productos/1.json
  def destroy
    control_usuario
    # @producto.destroy
    # respond_to do |format|
    #   format.html { redirect_to productos_url, notice: 'Producto was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end


  # control de tipo de usuario logueado
  def control_usuario    
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
    def set_producto
      @producto = Producto.find(params[:id])
      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def producto_params
      params.require(:producto).permit(:nombre, :descripcion, :tipo_id)
    end
end
