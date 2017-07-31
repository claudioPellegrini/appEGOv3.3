class TiposController < ApplicationController
  before_action :set_tipo, only: [:show, :edit, :update, :destroy]

  # GET /tipos
  # GET /tipos.json
  def index
    control_usuario
    @tipos = Tipo.all
  end

  # GET /tipos/1
  # GET /tipos/1.json
  def show
    control_usuario
  end

  # GET /tipos/new
  def new
    control_usuario
    @tipo = Tipo.new
  end

  # GET /tipos/1/edit
  def edit
    control_usuario
  end

  # POST /tipos
  # POST /tipos.json
  def create
    control_usuario
    @tipo = Tipo.new(tipo_params)
    @tipo.nombre =  @tipo.nombre.upcase
    respond_to do |format|
      if @tipo.save
        format.html { redirect_to @tipo, notice: 'El Tipo de producto se ha creado correctamente.' }
        format.json { render :show, status: :created, location: @tipo }
      else
        format.html { render :new }
        format.json { render json: @tipo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipos/1
  # PATCH/PUT /tipos/1.json
  def update
    control_usuario
    respond_to do |format|
      if @tipo.update(tipo_params)
        format.html { redirect_to @tipo, notice: 'El Tipo de producto se ha editado correctamente.' }
        format.json { render :show, status: :ok, location: @tipo }
      else
        format.html { render :edit }
        format.json { render json: @tipo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipos/1
  # DELETE /tipos/1.json
  def destroy
    control_usuario
    @tipo_elegido = Producto.where(tipo_id: @tipo.id)
    if @tipo_elegido.blank?
      @tipo.destroy
      respond_to do |format|
        format.html { redirect_to tipos_url, notice: 'El Tipo de producto se ha eliminado correctamente.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html {redirect_to tipos_url, notice: 'No puede eliminarse el Tipo, ya que se ha creado un Producto de este Tipo'}
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
    def set_tipo
      @tipo = Tipo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipo_params
      params.require(:tipo).permit(:nombre, :descripcion)
    end
end
