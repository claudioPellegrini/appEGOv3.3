class CalificacionsController < ApplicationController
  before_action :set_calificacion, only: [:show, :edit, :update, :destroy]


  # GET /calificacions
  # GET /calificacions.json
  def index
    control_usuario
    @calificacions = Calificacion.find_by_sql("SELECT Calificacions.id, CALIFICACIONS.compra_id, CALIFICACIONS.VALOR FROM public.CALIFICACIONs JOIN COMPRAS ON CALIFICACIONs.compra_id=COMPRAS.id join Cuenta on COMPRAS.cuentum_id=CUENTA.id WHERE CUENTA.ID="+current_cuentum.id.to_s)
    
  end

  # GET /calificacions/1
  # GET /calificacions/1.json
  def show
    control_usuario
  end

  # GET /calificacions/new
  def new
    control_usuario
    @calificacion = Calificacion.new
  end

  # GET /calificacions/1/edit
  def edit
    control_usuario
  end

  # POST /calificacions
  # POST /calificacions.json
  def create
    control_usuario
    @calificacion = Calificacion.new(calificacion_params)

    respond_to do |format|
      if @calificacion.save
        format.html { redirect_to @calificacion, notice: 'La calificacion se ha realizado correctamente.' }
        format.json { render :show, status: :created, location: @calificacion }
      else
        format.html { render :new }
        format.json { render json: @calificacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calificacions/1
  # PATCH/PUT /calificacions/1.json
  def update
    control_usuario
    respond_to do |format|
      if @calificacion.update(calificacion_params)
        format.html { redirect_to @calificacion, notice: 'La calificacion se ha editado correctamente.' }
        format.json { render :show, status: :ok, location: @calificacion }
      else
        format.html { render :edit }
        format.json { render json: @calificacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calificacions/1
  # DELETE /calificacions/1.json
  def destroy
    control_usuario
    @calificacion.destroy
    respond_to do |format|
      format.html { redirect_to calificacions_url, notice: 'La calificacion se ha eliminado correctamente.' }
      format.json { head :no_content }
    end

  end
  def calificando
    byebug
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calificacion
      @calificacion = Calificacion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calificacion_params
      params.require(:calificacion).permit(:compra_id, :valor)
    end
end
