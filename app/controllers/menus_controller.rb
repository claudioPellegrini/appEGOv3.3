class MenusController < ApplicationController
  before_action :set_menu, only: [:show, :edit, :update, :destroy]

  # GET /menus
  # GET /menus.json
  def index
    control_usuario
    @menus = Menu.order('fecha DESC').all
    @productos = Producto.all
    @tiene_productos = TieneProducto.all
    @tipos = Tipo.all
    @menus.each do |m|
      if Time.now.to_date <= m.fecha.to_date
         @menu = m
       end
     end
    respond_to do |format|
      format.html
      format.json
      format.pdf{render template: 'menus/menudeldia.pdf.erb', pdf: 'menudeldia'} #, :save_to_file => Rails.root.join('public', "Menudeldia.pdf"),
       #:save_only    => true, type: 'application/pdf' }
       
    end
  end

  # GET /menus/1
  # GET /menus/1.json
  def show
    control_usuario
    @tipos = Tipo.all
  end


  # GET /menus/new
  def new
    control_usuario
    @menu = Menu.new
    @productos = Producto.all
    @tipos = Tipo.all
  end

  # GET /menus/1/edit
  def edit
    control_usuario
    @productos = Producto.all
    @tipos = Tipo.all    
  end

  # POST /menus
  # POST /menus.json
  def create
    control_usuario
    @tipos = Tipo.all
    @productos = Producto.all
    @menu = Menu.new(menu_params)
    @menu.productos = params[:productos]
    if @menu.productos == nil
      format.html { render :new, notice: 'Debe seleccionar al menos 1 producto.' }
    else
      respond_to do |format|
        if @menu.save
          crear_pdfs_menu          
          format.html { redirect_to @menu, notice: 'El Menu se ha creado correctamente .' }
          format.json { render :show, status: :created, location: @menu }
        else
          format.html { render :new }
          format.json { render json: @menu.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /menus/1
  # PATCH/PUT /menus/1.json
  def update
    control_usuario
    @tipos = Tipo.all
    @productos = Producto.all
    respond_to do |format|
      @menu.productos = params[:productos]
      if @menu.update(menu_params)
          crear_pdfs_menu
        format.html { redirect_to @menu, notice: 'El Menu se ha editado correctamente.' }
        format.json { render :show, status: :ok, location: @menu }
      else
        format.html { render :edit }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /menus/1
  # DELETE /menus/1.json
  def destroy
    control_usuario
    @menu.destroy
    respond_to do |format|
      format.html { redirect_to menus_url, notice: 'El Menu se ha eliminado correctamente.' }
      format.json { head :no_content }
    end
  end


  # CREAR PDF MENUS
  def crear_pdfs_menu
    @menus = Menu.all
    @menus.each do |m|
      if Time.now.to_date <= m.fecha.to_date
         @menu = m
       end
     end
    pdf = WickedPdf.new.pdf_from_string( 
      render_to_string( :template => 'menus/menudeldia.pdf.erb' ))
    save_path = Rails.root.join('public','Menudeldia.pdf')
      File.open(save_path, 'wb') do |file|
        file << pdf
      end
      #descomentar para q mande los correos
    # enviar_correos
  end



  # ENVIAR CORREOS A LISTA DE USUARIOS
   def enviar_correos 
    @cuentas = Cuentum.all
    @coma = "; "
    @destinatarios = "ladeclaudio@gmail.com; mauge58@gmail.com; "
    @cuentas.each do |c|         
          @correos = c.email + @coma
          @destinatarios << @correos
    end
    
    CuentaMailer.mailing(@destinatarios, @menu).deliver_now
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
    def set_menu
      @menu = Menu.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def menu_params
      params.require(:menu).permit(:fecha, :productos, :producto_id)
    end
  end

  def chequeada(valor)    
    @productos.each do |prod|
        @menu.productos.each do |p|
          if p.id == valor 
            return true          
        end
      end
      return false    
   end

 
end
