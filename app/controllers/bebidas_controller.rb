class BebidasController < ApplicationController
  before_action :set_bebida, only: [:show, :edit, :update, :destroy]

  # GET /bebidas
  # GET /bebidas.json
  def index
    control_usuario
    @bebidas = Bebida.all
  end

  # GET /bebidas/1
  # GET /bebidas/1.json
  def show    
    control_usuario
  end

  # GET /bebidas/new
  def new
    control_usuario
    @bebida = Bebida.new
  end

  # GET /bebidas/1/edit
  def edit
    control_usuario
  end

  # POST /bebidas
  # POST /bebidas.json
  def create
    control_usuario
    @bebida = Bebida.new(bebida_params)
    @bebida.nombre =  @bebida.nombre.upcase
    respond_to do |format|
      if @bebida.save
        format.html { redirect_to @bebida, notice: 'La Bebida se ha creado correctamente.' }
        format.json { render :show, status: :created, location: @bebida }
      else
        format.html { render :new }
        format.json { render json: @bebida.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bebidas/1
  # PATCH/PUT /bebidas/1.json
  def update
    control_usuario
    respond_to do |format|
      if @bebida.update(bebida_params)
        format.html { redirect_to @bebida, notice: 'La Bebida se ha editado correctamente.' }
        format.json { render :show, status: :ok, location: @bebida }
      else
        format.html { render :edit }
        format.json { render json: @bebida.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bebidas/1
  # DELETE /bebidas/1.json
  def destroy
    control_usuario
    @bebidas_compradas = CompraBebida.where(bebida_id: @bebida.id)
    stockActual = Stock.where(bebida_id: @bebida.id).order('created_at DESC').take
    
    @cantidad = stockActual.cant
    
    
    if @bebidas_compradas.blank? && @cantidad == 0
      
      @bebida.destroy
      respond_to do |format|
        format.html { redirect_to bebidas_url, notice: 'La Bebida se ha eliminado correctamente.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html {redirect_to bebidas_url, notice: 'No puede eliminarse la Bebida, ya que fue comprada en un Menu o su Stock es distinto de cero'}
      end
    end
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
    def set_bebida
      @bebida = Bebida.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bebida_params
      params.require(:bebida).permit(:nombre, :tipo, :tamanio, :precio, :cantidad)
    end
end
