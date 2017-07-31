class StocksController < ApplicationController
  before_action :set_stock, only: [:show, :edit, :update, :destroy]

  # GET /stocks
  # GET /stocks.json
  def index
    control_usuario
    @stocks = Stock.order('created_at DESC').all
    @bebidas = Bebida.all
  end

  # GET /stocks/1
  # GET /stocks/1.json
  def show
    control_usuario
  end

  # GET /stocks/new
  def new
    control_usuario
    @stock = Stock.new
  end

  # GET /stocks/1/edit
  def edit
    control_usuario
  end

  # POST /stocks
  # POST /stocks.json
  def create
    control_usuario
    @stock = Stock.new(stock_params)   
    if @stock.cant == nil || @stock.bebida_id == nil || @stock.factura_compra == nil 
      #
    else
      valor = @stock.cant
      mi_bebida = Stock.where(bebida_id: @stock.bebida_id)
      saldoAnterior = mi_bebida.last.cant    
      saldo = saldoAnterior + valor 
      @stock.cant = saldo
    end
    respond_to do |format|
      if @stock.save
        format.html { redirect_to @stock, notice: 'Stock creado correctamente.' }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocks/1
  # PATCH/PUT /stocks/1.json
  def update
    control_usuario
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to @stock, notice: 'Stock actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
    control_usuario
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_url, notice: 'Stock eliminado correctamente.' }
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
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_params
      params.require(:stock).permit(:bebida_id, :cant, :factura_compra)
    end
end
