class EmpresasController < ApplicationController
  before_action :set_empresa, only: [:show, :edit, :update, :destroy]

  # GET /empresas
  # GET /empresas.json
  def index
    control_usuario
    @empresas = Empresa.all
  end

  # GET /empresas/1
  # GET /empresas/1.json
  def show
    control_usuario
  end

  # GET /empresas/new
  def new
    control_usuario
    @empresa = Empresa.new
  end

  # GET /empresas/1/edit
  def edit
    control_usuario
  end

  # POST /empresas
  # POST /empresas.json
  def create
    control_usuario
    @empresa = Empresa.new(empresa_params)
    @empresa.nombre =  @empresa.nombre.upcase
    respond_to do |format|
      if @empresa.save
        format.html { redirect_to @empresa, notice: 'La Empresa se ha creado correctamente.' }
        format.json { render :show, status: :created, location: @empresa }
      else
        format.html { render :new }
        format.json { render json: @empresa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /empresas/1
  # PATCH/PUT /empresas/1.json
  def update
    control_usuario
    respond_to do |format|
      if @empresa.update(empresa_params)
        format.html { redirect_to @empresa, notice: 'La Empresa se ha editado correctamente.' }
        format.json { render :show, status: :ok, location: @empresa }
      else
        format.html { render :edit }
        format.json { render json: @empresa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /empresas/1
  # DELETE /empresas/1.json
  def destroy
    control_usuario
    @empresa.destroy
    respond_to do |format|
      format.html { redirect_to empresas_url, notice: 'La Empresa se ha eliminado correctamente.' }
      format.json { head :no_content }
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
    def set_empresa
      @empresa = Empresa.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def empresa_params
      params.require(:empresa).permit(:rut, :nombre, :razon_social, :telefono, :direccion, :email)
    end
end
