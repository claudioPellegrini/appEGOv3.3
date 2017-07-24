class BiController < ApplicationController

	# graficas usando gema googlecharts
    def compras_por_dia
    	fechas = Array.new
    	data_array_1 = Array.new#[1, 4, 3, 5, 9] 
    	#data_array_2 = [ 0, 0, 0, 0, 0] 
    	consultaPorDia = Compra.find_by_sql("SELECT   COUNT (*) AS contador, fecha FROM compras, compra_productos WHERE compras.id = compra_productos.compra_id GROUP BY fecha ORDER BY fecha ASC;")
    	consultaPorDia.each do |cpd|
    		data_array_1.push(cpd.contador)
    		fechas.push(cpd.fecha.strftime("%d/%m") )
    	end
    	@barv = Gchart.bar( 
            :size => '600x400',
            :bar_colors => ['0022FF'],
            :title => "	 Total de compras por dia",
            :bg => 'd5ebf2',
            :grouped => true,
            :legend => ['Consumos'],
            :data => [data_array_1],#, data_array_2],            
            :legend_position => 'top',
            :axis_with_labels => [['x'], ['y']], 
            :max_value => 100,
            :min_value => 0,
            :axis_labels => [fechas],
            ) 		

    end       

    

    def productos_mas_consumidos
    	nombres = Array.new
		cantidades = Array.new
		consulta = Producto.find_by_sql("select Productos.nombre, count(Compra_productos.producto_id)as consumos from Productos, Compra_productos where Productos.id = Compra_productos.producto_id  group by Productos.nombre ")
		consulta.each do |c|
			nombres.push(c.nombre)
			cantidades.push(c.consumos)
		end
        @pastel=Gchart.pie( 
            :size   => '600x400',
            :title  => "Historico de Productos mas consumidos",
            :legend => nombres,#['firefox', 'chrome', 'IE', 'Safari', 'Opera'],
            :labels => cantidades,
            :custom => "chco=FE2E64,9AFE2E",
            :data   => cantidades#[120, 45, 25, 55, 20, 90]
            )
    end



    def consumos_por_mes
    	meses = Array.new
    	data_array_1 = Array.new#[1, 4, 3, 5, 9] 
    	#data_array_2 = [ 0, 0, 0, 0, 0] 
    	consultaPorMes = Compra.find_by_sql("SELECT COUNT (*) AS contador, date_part('month',fecha) as mes FROM compras, compra_productos WHERE compras.id = compra_productos.compra_id GROUP BY date_part('month',fecha) ORDER BY date_part('month',fecha) ASC;")
    	consultaPorMes.each do |cpm|
    		data_array_1.push(cpm.contador)
    		meses.push(mesTexto(cpm.mes))
    	end
    	@line = Gchart.line( 
            :size => '600x400',
            :bar_colors => ['0022FF'],
            :title => "	 Evolucion de los consumos",
            :bg => 'd5ebf2',
            :grouped => true,
            :legend => ['Consumos'],
            :data => [data_array_1],#, data_array_2],            
            :legend_position => 'top',
            :axis_with_labels => [['x'], ['y']], 
            :max_value => 100,
            :min_value => 0,
            :axis_labels => [meses],
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

end
