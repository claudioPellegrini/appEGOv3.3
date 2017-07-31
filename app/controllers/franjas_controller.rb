class FranjasController < ApplicationController
  before_action :set_franja, only: [:show, :edit, :update, :destroy]

  # GET /franjas
  # GET /franjas.json
  def index
    control_usuario
    @franjas = Franja.all
  end

  # GET /franjas/1
  # GET /franjas/1.json
  def show
    control_usuario
  end

  # GET /franjas/new
  def new
    control_usuario
    @franja = Franja.new
  end

  # GET /franjas/1/edit
  def edit
    control_usuario
  end

  # POST /franjas
  # POST /franjas.json
  def create
    control_usuario
    @franja = Franja.new(franja_params)
    @franja.fecha = Time.now
    if @franja.primera_hasta==nil  
        @franja.primera_hasta=0
    end
    if @franja.primera_precio==nil 
      @franja.primera_precio=0
    end
    if @franja.segunda_hasta==nil
      @franja.segunda_hasta=0
    end
    if @franja.segunda_precio==nil
      @franja.segunda_precio=0
    end
    if @franja.tercera_precio==nil
      @franja.tercera_precio=0
    end
    respond_to do |format|
      if @franja.save
        format.html { redirect_to @franja, notice: 'La Franja se ha creado correctamente.' }
        format.json { render :show, status: :created, location: @franja }
      else
        format.html { render :new }
        format.json { render json: @franja.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /franjas/1
  # PATCH/PUT /franjas/1.json
  def update
    control_usuario
    respond_to do |format|
      if @franja.update(franja_params)
        format.html { redirect_to @franja, notice: 'La Franja se ha editado correctamente.' }
        format.json { render :show, status: :ok, location: @franja }
      else
        format.html { render :edit }
        format.json { render json: @franja.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /franjas/1
  # DELETE /franjas/1.json
  def destroy
    control_usuario
    @franja.destroy
    respond_to do |format|
      format.html { redirect_to franjas_url, notice: 'La Franja se elimino correctamente.' }
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
    def set_franja
      @franja = Franja.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def franja_params
      params.require(:franja).permit(:fecha, :primera_hasta, :primera_precio, :segunda_hasta, :segunda_precio, :tercera_precio)
    end
end
