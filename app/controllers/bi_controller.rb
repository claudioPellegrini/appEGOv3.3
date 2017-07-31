class BiController < ApplicationController
    def index
        control_usuario
    end

	# graficas usando gema googlecharts
    def compras_por_dia
        control_usuario
    	max = 0
    	fechas = Array.new
    	data_array_1 = Array.new#[1, 4, 3, 5, 9] 
    	#data_array_2 = [ 0, 0, 0, 0, 0] 
    	consultaPorDia = Compra.find_by_sql("SELECT   COUNT (*) AS contador, fecha FROM compras, compra_productos WHERE compras.id = compra_productos.compra_id GROUP BY fecha ORDER BY fecha ASC;")
    	consultaPorDia.each do |cpd|
    		data_array_1.push(cpd.contador)
    		fechas.push(cpd.fecha.strftime("%d/%m") )
    		max = maximo(max,cpd.contador)
    	end
    	@barv = Gchart.bar( 
            :size => '600x400',
            :bar_colors => ['0022FF'],
            :title => "	 ",
            :bg => 'd5ebf2',
            :grouped => true,
            :legend => ['Consumos'],
            :data => [data_array_1],#, data_array_2],            
            :legend_position => 'top',
            :axis_with_labels => [['x'], ['y'], ['t']], 
            :axis_range => [nil, [0,max,10]],
            :max_value => max,
            :min_value => 0,
            :axis_labels => [fechas, [], data_array_1],
            ) 		

    end       

    

    def productos_mas_consumidos
        control_usuario
    	nombres = Array.new
		cantidades = Array.new
		consulta = Producto.find_by_sql("select Productos.nombre, count(Compra_productos.producto_id)as consumos from Productos, Compra_productos where Productos.id = Compra_productos.producto_id  group by Productos.nombre ")
		consulta.each do |c|
			nombres.push(c.nombre)
			cantidades.push(c.consumos)
		end
        @pastel=Gchart.pie( 
            :size   => '600x400',
            :title  => " ",
            :legend => nombres,#['firefox', 'chrome', 'IE', 'Safari', 'Opera'],
            :labels => cantidades,
            :custom => "chco=FE2E64,9AFE2E",
            :data   => cantidades#[120, 45, 25, 55, 20, 90]
            )
    end



    def consumos_por_mes
        control_usuario
    	max = 0
    	meses = Array.new
    	data_array_1 = Array.new#[1, 4, 3, 5, 9] 
    	#data_array_2 = [ 0, 0, 0, 0, 0] 
    	consultaPorMes = Compra.find_by_sql("SELECT COUNT (*) AS contador, date_part('month',fecha) as mes FROM compras, compra_productos WHERE compras.id = compra_productos.compra_id GROUP BY date_part('month',fecha) ORDER BY date_part('month',fecha) ASC;")
    	consultaPorMes.each do |cpm|
    		data_array_1.push(cpm.contador)
    		meses.push(mesTexto(cpm.mes))
    		max = maximo(max,cpm.contador)
    	end
    	@line = Gchart.line( 
            :size => '600x400',
            :bar_colors => ['0022FF'],
            :title => "	 ",
            :bg => 'd5ebf2',
            :grouped => true,
            :legend => ['Consumos'],
            :data => [data_array_1],#, data_array_2],            
            :legend_position => 'top',
            :axis_with_labels => [['x'], ['y'], ['t']],             
            :axis_range => [nil, [0,max,100]],
            :max_value => max,
            :min_value => 0,           
            :axis_labels => [meses, [], data_array_1],
            ) 		

    end    

    def recaudo_por_dia
        control_usuario
    	max = 0
        fechas = Array.new
        array2 = Array.new
        recaudo_por_dia = Compra.find_by_sql("SELECT SUM (COMPRAS.VALOR_FINAL_TICKET) as suma, FECHA FROM compras GROUP BY FECHA ORDER BY fecha ASC;")
        recaudo_por_dia.each do |rpd|
            array2.push(rpd.suma)
            fechas.push(rpd.fecha.strftime("%d/%m") )
            max = maximo(max,rpd.suma)
        end
        @barra = Gchart.bar( 
            :size => '600x400',
            :bar_colors => ['0022FF'],
            :title => " ",
            :bg => 'd5ebf2',
            :grouped => true,
            :legend => ['Recaudación'],
            :data => [array2],            
            :legend_position => 'top',
            :axis_with_labels => [['x'], ['y'], ['t']], 
            :axis_range => [nil, [0,max,50]],
            :max_value => max,
            :min_value => 0,
            :axis_labels => [fechas, [], array2],
            )   

    end

    def bebidas_mas_consumidas
        control_usuario
    	nombres = Array.new
		cantidades = Array.new
		consulta = Bebida.find_by_sql("select Bebidas.nombre, Bebidas.tipo, Bebidas.tamanio,  count(Compra_bebidas.bebida_id)as consumos from Bebidas, Compra_bebidas where Bebidas.id = Compra_bebidas.bebida_id  group by Bebidas.nombre, Bebidas.tipo, Bebidas.tamanio  ")
		consulta.each do |c|
			nombres.push(c.nombre + " - " + c.tipo + " - " + c.tamanio)
			cantidades.push(c.consumos)
		end
        @bebidasPie=Gchart.pie( 
            :size   => '600x400',
            :title  => " ",
            :legend => nombres,#['firefox', 'chrome', 'IE', 'Safari', 'Opera'],
            :labels => cantidades,
            :custom => "chco=FE2E64,9AFE2E",
            :data   => cantidades#[120, 45, 25, 55, 20, 90]
            )
    end

    def mesTexto(valor)
    	if valor != nil
	    	if valor == 1
	    		return "Enero"
	    	elsif valor == 2
	    		return "Febrero"
	    	elsif valor == 3
	    		return "Marzo"
	    	elsif valor == 4
	    		return "Abril"
	    	elsif valor == 5
	    		return "Mayo"
	    	elsif valor == 6
	    		return "Junio"
	    	elsif valor == 7
	    		return "Julio"
	    	elsif valor == 8
	    		return "Agosto"
	    	elsif valor == 9
	    		return "Setiembre"
	    	elsif valor == 10
	    		return "Octubre"
	    	elsif valor == 11
	    		return "Noviembre"
	    	else
	    		return "Diciembre"
	    	end
	    else
	    	return ""
	    end
    end   

    def maximo(valorOld, valorNew)
    	if valorOld != nil && valorNew != nil
    		if valorOld < valorNew
    			return valorNew
    		else
    			return valorOld
    		end
    	else
    		return 0
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



end
