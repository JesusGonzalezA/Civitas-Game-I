# encoding:utf-8

# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.


require_relative 'civitas_juego'

require_relative 'salidas_carcel'


module TestP1

  class TestP1
    def initialize
      #Constantes
        #Casilla
        @NOMBRECASILLA1 = "Sanchez Pijuan"
        
        #Tablero
        @NUMCASILLAS = 10
        @NUMCASILLACARCEL = 2
        @ORIGEN = 0
        @DESTINO = 9
        @ACTUAL = 7
        @TIRADA = 8
        
        #Dado
        @NUMJUGADORES = 4;  
        @empieza = [0,0,0,0]
        @frecuencia_abs = [0,0,0,0,0,0]
        @TIRADAS = 100
        @veces_salgo = 0      
        
        #Diario
        @NUMEVENTOS = 13
        @EVENTO = "Champions League"
        
        #MazoSorpresas
        @NSORPRESA1 = "hola"
        @NSORPRESA2 = "adios"
        @MODODEBUG = true
        
    end

    def prueba1
      
      #--------------------------------------------------------------------
      #Declaracion de variables
        #Casilla
        casilla = Civitas::Casilla.new_casilla_descanso(@NOMBRECASILLA1)
      
        #Tablero
      tablero = Civitas::Tablero.new(@NUMCASILLACARCEL)
      
        #Dado
        #Diario
        #MazoSorpresas
        mazo = Civitas::MazoSorpresas.new_mazo_sorpresas_default
        sorpresa1 = Civitas::Sorpresa.new_sorpresa_encarcelar(tablero)
        sorpresa2 = Civitas::Sorpresa.new_sorpresa_liberar(mazo)

      #--------------------------------------------------------------------
      #Pruebo clase Casilla
      puts "*Probando la clase casilla..........."
      
      puts "\tEl nombre de la casilla es : " + casilla.nombre
      
      #--------------------------------------------------------------------
      #Pruebo la clase Tablero
      puts "*Probando la clase tablero..........."
      puts "\t-La carcel esta en la posicion #{tablero.numCasillaCarcel}"
      
        #Añado casillas
      puts "\n\t-Añado #{@NUMCASILLAS} y juez..."
      for i in (0..@NUMCASILLAS)
       tablero.añade_casilla(casilla)
      end
      
        #añade juez
      tablero.añade_juez
      
      
      
        #get casilla
      i =0
      
      puts "\t-Muestro casillas..."
      
      while (tablero.get_casilla(i)!= nil) do
       puts "\t\t #{((tablero.get_casilla(i))).nombre}"
       i+=1
      end
      
        #calcular tiradas y posicion
      puts "\t-Mostrando funcionalidad con calculo tiradas y posicion..."
      puts "\t[En un tablero de #{tablero.casillas.size} casillas]"
      puts "\t\t-Si estoy en casilla #{@ACTUAL} y hago una tirada de #{@TIRADA}
                 me encontrare en la posicion #{tablero.nueva_posicion(@ACTUAL, 
            @TIRADA)}"
            
            #restauro por salida
            #Podria haber hecho un metodo que lo ponga a 0 pero no concuerda
            #con la guia de practicas
      por_salida = tablero.get_por_salida
      for i in (0..por_salida) do
        tablero.get_por_salida
      end
      
      puts "\t\t-Si estaba en #{@ORIGEN} y estoy en #{@DESTINO} he lanzado 
                 un #{tablero.calcular_tirada(@ORIGEN, @DESTINO)}"
      
      puts tablero.inspect
      #--------------------------------------------------------------------
      #Pruebo la clase diario
      puts "*Probando la clase diario.........."
        #Añado eventos
      Civitas::Dado.instance.set_debug(true)
      
      for j in (1..@NUMEVENTOS) do
        Civitas::Diario.instance.ocurre_evento("#{@EVENTO} #{j} ")
        i +=1
      end
      
        #Mostrar eventos
      if (Civitas::Diario.instance.eventos_pendientes == true ) 
        puts "\t-Mostrando los eventos pendientes:"
        while Civitas::Diario.instance.eventos_pendientes do
          puts "\t  #{Civitas::Diario.instance.leer_evento}"
        end
      
      else 
        puts "\tNo hay eventos pendientes"
      end
      
      #--------------------------------------------------------------------
      #Pruebo la clase Dado
      puts "\n*Probando la clase dado.........."
      
        #Pruebo modo tirar
      puts "\n\t-Desactivo el modo debug y tiro"
      Civitas::Dado.instance.set_debug(false)
      
      for i in (1..@TIRADAS)
        @frecuencia_abs[Civitas::Dado.instance.tirar-1] += 1
      end
      
      for i in(1..6)
        puts "\t-#{i} --> #{@frecuencia_abs[i-1]} veces"
      end
      
        #Pruebo salgo de la carcel
      puts "\n\t-Pruebo salgo de la carcel"
      
      for i in (1..@TIRADAS)
        if Civitas::Dado.instance.salgo_de_la_carcel
          @veces_salgo +=1
        end
      end
      
      puts "\n\tHe salido #{@veces_salgo} de #{@TIRADAS} veces"
      
      
           #Pruebo tras modo debug
      puts "\n\t-Activo el modo debug y tiro"
      Civitas::Dado.instance.set_debug(true)
      
      for i in(1..6)
        @frecuencia_abs[i-1]=0
      end
      
      for i in (1..@TIRADAS)
        @frecuencia_abs[Civitas::Dado.instance.tirar-1] += 1
      end
      
      for i in(1..6)
        puts "\t-#{i} --> #{@frecuencia_abs[i-1]} veces"
      end
      
        #Pruebo salgo de la carcel
      puts "\n\t-Pruebo salgo de la carcel"
      @veces_salgo = 0
      
      for i in (1..@TIRADAS)
        if Civitas::Dado.instance.salgo_de_la_carcel
          @veces_salgo +=1
        end
      end
      
      puts "\n\tHe salido #{@veces_salgo} de #{@TIRADAS} veces"
      
      
        #Pruebo quien empieza
      puts "\n\t-Pruebo quien empieza"
      
      for i in (1..@TIRADAS)
        @empieza[Civitas::Dado.instance.quien_empieza(@NUMJUGADORES) -1] +=1
      end
      
      for i in (0...@NUMJUGADORES)
        puts "\t\t-#{i+1} empieza #{@empieza[i]} veces"
      end
      
      #--------------------------------------------------------------------
      #Pruebo MazoSorpresas
      puts "\n*Probando MazoSorpresas......."
      mazo = Civitas::MazoSorpresas.new_mazo_sorpresas_debug(@MODODEBUG)
    
      if (@MODODEBUG)
        puts "\t-Mostrando los eventos del diario..."
        while (Civitas::Diario.instance.eventos_pendientes )
          puts "\t   -#{Civitas::Diario.instance.leer_evento()}"
        end
      end
      
        #Probando al mazo
        mazo.al_mazo(sorpresa1)
        mazo.al_mazo(sorpresa2)

        #Probando siguiente
        puts "\n\t-He añadadido 2 sorpresas al mazo: #{@NSORPRESA1} y #{@NSORPRESA2}..."
        puts "\t voy a emplear el método siguiente 4 veces...."
        puts "\t\t-#{(mazo.siguiente()).texto}"
        puts "\t\t-#{mazo.siguiente().texto}"
        puts "\t\t-#{mazo.siguiente().texto}"
        puts "\t\t-#{mazo.siguiente().texto}"
        
        #Probando (in)habilitar
        mazo.inhabilitar_carta_especial(sorpresa2)
        puts "\n\t-Probando inhabilitar....."
      
        puts "\t\t-Diario: #{Civitas::Diario.instance.leer_evento()}"

        puts "\n\t-Probando habilitar....."
        mazo.habilitar_carta_especial(sorpresa2)
        puts "\t\t-Diario: #{Civitas::Diario.instance.leer_evento()}"
        
      puts mazo.inspect
    end
      
    #--------------------------------------------------------------------
    #Probar Titulo de Propiedad
    def probar_titulo

      #Construir objeto
      jugador = Civitas::Jugador.new_jugador("Jesus")
      jugador2 = Civitas::Jugador.new_jugador("Nuria")
      titulo1 = Civitas::TituloPropiedad.new("Paseo del Prado",
                50.0,100.0,2000.0,4000.0,1000.0)
      puts (titulo1.to_string)
      
      #Probando métodos get
      puts ("*Probando métodos get....")
      puts ("\t- Importe cancelar hipoteca: #{titulo1.get_importe_cancelar_hipoteca}")
      
      #Probando resto de métodos
      puts ("\n*Probando resto de métodos.....")
      puts ("\t-Cantidad de casas y hoteles: #{titulo1.cantidad_casas_hoteles}")
      #titulo1.actualiza_propietario_por_conversion(jugador)
     
      puts titulo1.to_string
      
      puts("\t-Cancelar hipoteca: #{titulo1.cancelar_hipoteca(jugador)}")
      puts ("\t-Comprar: #{titulo1.comprar(jugador)}")
      puts ("\t-Construir casa: #{titulo1.construir_casa(jugador)}")
      puts ("\t-Construir hotel: #{titulo1.construir_hotel(jugador)}")
      puts ("\t-Cantidad de casas y hoteles: #{titulo1.cantidad_casas_hoteles}")
      puts("\t-Derruir casas: #{titulo1.derruir_casas(02, jugador)}")
      puts("\t-Hipotecar: #{titulo1.hipotecar(jugador)}")
      puts ("\t-Tiene propietario: #{titulo1.tiene_propietario}")
      
      titulo1.tramitar_alquiler(jugador2)
      
      puts ("\t-Vender: #{titulo1.vender(jugador2)}")
      

      #Probando resto de métodos ( relacionados con jugador)
      puts ("\n*Probando resto de métodos (relacionados con jugador)....")
      
      #Leer el diario
      while (Civitas::Diario.instance.eventos_pendientes == true)
        puts "\t\t-Diario: #{Civitas::Diario.instance.leer_evento()}"
      end
      
      puts titulo1.inspect
    end
    #--------------------------------------------------------------------
    #Probar Jugador
    def probar_jugador

      #Construir objeto
      titulo1 = Civitas::TituloPropiedad.new("Paseo del Prado",
                50.0,100.0,2000.0,4000.0,1000.0)
      j1 = Civitas::Jugador.new_jugador("Jesus")
      j2 = Civitas::Jugador.new_copia(j1)
      mazo = Civitas::MazoSorpresas.new_mazo_sorpresas_default
      sorpresa = Civitas::Sorpresa.new_sorpresa_liberar(mazo)
      mazo.al_mazo(sorpresa)
      
      
      #Probando métodos get
      puts ("*Probando métodos get y constructor....")
      puts (j1.to_string)
     
      #Probando resto de métodos
      
      puts ("*Probando resto de métodos....")
      
        #añadir un titulo con casas y hoteles
      puts ("-Cantidad casas y hoteles: #{j1.cantidad_casas_hoteles()}")
      
        
        #poner saldo 0 y menor que 0
      puts ("-En bancarrota: #{j1.en_bancarrota}")
        
        #También prueba debe_ser_encarcelado
        #Probar dandole salvoconducto y encarcelandolo 2 veces
      puts ("-Encarcelar: #{j1.encarcelar(1)}")
        
      puts ("-¿Encarcelado? #{j1.is_encarcelado}")
      
      j1.modificar_saldo(100000)
      
      j1.salir_carcel_pagando
      
      #Probar comprar y vender
      j1.puede_comprar_casilla
      puts "-Comprada #{j1.comprar(titulo1)}"
      puts "-Hipotecar #{j1.hipotecar(0)}"
      j1.construir_casa(0)
      j1.construir_casa(0)
      j1.construir_casa(0)
      j1.construir_casa(0)
      j1.construir_hotel(0)
      j1.construir_casa(0)
      j1.construir_casa(0)
      puts titulo1.to_string
      
      puts "-Cancelar hipoteca #{j1.cancelar_hipoteca(0)}"
      puts "-Vender #{j1.vender(0)}"
      puts titulo1.to_string
      
      
        #Probar sin estar encarcelado
      puts ("-Mover a casilla : #{j1.mover_a_casilla(3)}")
      
      j1.obtener_salvoconducto(sorpresa)

      j1.paga(101)
      
        #Solo si no esta encarcelado
      j1.paga_alquiler(102)
      j1.paga_impuesto(103)
      
      j1.pasa_por_salida
      
        #Depende de encarcelado
      puts ("-Puede comprar casilla: #{j1.puede_comprar_casilla}")
      
        #Depende de encarcelado
      puts("-Recibe: #{j1.recibe(104)}")
      
        #Depende de encarcelado y saldo
      puts ("-Sale carcel pagando: #{j1.salir_carcel_pagando}")
      
        #Depende del dado
      puts ("-Sale carcel tirando: #{j1.salir_carcel_tirando}")
      
        #Depende de propiedades
      puts("-Algo que gestionar: #{j1.tiene_algo_que_gestionar}")
      
      puts("-Tiene salvoconducto: #{j1.tiene_salvoconducto}")
      
      
      
       while (Civitas::Diario.instance.eventos_pendientes)
        puts "\t\t-Diario: #{Civitas::Diario.instance.leer_evento()}"
      end
      
      puts j1.inspect
      
     
    end
    #--------------------------------------------------------------------
    #Probar Sorpresa
    def probar_sorpresa

      #Construir objeto
          #Creo casilla
      titulo1 = Civitas::TituloPropiedad.new("Paseo del Prado",
                50.0,100.0,2000.0,4000.0,1000.0)
      
      paseo_del_prado = Civitas::Casilla.new_casilla_calle(titulo1)
      
          #Creo tablero
      tablero = Civitas::Tablero.new(1)
      tablero.añade_casilla(paseo_del_prado)
      tablero.añade_juez
      
          #Creo Mazo
      mazo1 = Civitas::MazoSorpresas.new_mazo_sorpresas_default
      
          #Creo sorpresas
      libre_carcel = Civitas::Sorpresa.new_sorpresa_liberar(mazo1)
      ir_a_paseo_del_prado = Civitas::Sorpresa.new_sorpresa_ir_a(1,"Ir a Paseo del Prado")
      ve_carcel = Civitas::Sorpresa.new_sorpresa_encarcelar(tablero)
      impuesto_propiedades = Civitas::Sorpresa.new_sorpresa(Civitas::Tipo_sorpresa::PORCASAHOTEL,tablero,50,"Paga por propiedades")
      paga = Civitas::Sorpresa.new_sorpresa(Civitas::Tipo_sorpresa::PAGARCOBRAR,tablero,-50,"Paga")
      paga_todos = Civitas::Sorpresa.new_sorpresa(Civitas::Tipo_sorpresa::PORJUGADOR,tablero,50,"Paga a todos/Cobra 1")
      
      mazo1.al_mazo(libre_carcel)
      
      #Probando métodos get
      puts ("*Probando to_string....")
      puts ("\t1- #{libre_carcel.to_string}")
      puts ("\t2- #{ir_a_paseo_del_prado.to_string}")
      puts ("\t3- #{ve_carcel.to_string}")
      puts ("\t4- #{impuesto_propiedades.to_string}")
      puts ("\t5- #{paga.to_string}")
      puts ("\t6- #{paga_todos.to_string}")

      #Probando resto de métodos
      puts ("*Probando resto de métodos....")
      
        #Probando usada
      puts ("- Probando usada...")
      libre_carcel.usada
      ir_a_paseo_del_prado.usada
      ve_carcel.usada
      impuesto_propiedades.usada
      paga.usada
      paga_todos.usada
      
      while(Civitas::Diario.instance.eventos_pendientes)
        puts ("\t\t-Diario: #{Civitas::Diario.instance.leer_evento}")
      end
      
          #Probando salir del mazo
        puts ("- Probando salir del mazo....")
        libre_carcel.salir_del_mazo
        ir_a_paseo_del_prado.salir_del_mazo
        ve_carcel.salir_del_mazo
        impuesto_propiedades.salir_del_mazo
        paga.salir_del_mazo
        paga_todos.salir_del_mazo
        
        while(Civitas::Diario.instance.eventos_pendientes)
          puts ("\t\t-Diario: #{Civitas::Diario.instance.leer_evento}")
        end
        
          #Probando aplicar a jugador
        j1 = Civitas::Jugador.new_jugador("Jesus")
        j2 = Civitas::Jugador.new_jugador("Nuria")
        j3 = Civitas::Jugador.new_jugador("Jose")
        j4 = Civitas::Jugador.new_jugador("Julio")
        
        todos = []
        todos << j1
        todos << j2
        todos << j3
        todos << j4
        
        puts ("- Probando aplicar a jugador...")
        libre_carcel.aplicar_a_jugador(0,todos);
#p3        irAPaseoDelPrado.aplicarAJugador(0,todos);
        ve_carcel.aplicar_a_jugador(0,todos);
        impuesto_propiedades.aplicar_a_jugador(0,todos);
        paga.aplicar_a_jugador(0,todos);
        paga_todos.aplicar_a_jugador(0,todos);
        
        while(Civitas::Diario.instance.eventos_pendientes)
          puts ("\t\t-Diario: #{Civitas::Diario.instance.leer_evento}")
        end
        
        puts libre_carcel.inspect 
        
    end
    #--------------------------------------------------------------------
    #Probar casilla
    def probar_casilla

      #Construir objeto
      titulo1 = Civitas::TituloPropiedad.new("Paseo del Prado",
                50.0,100.0,2000.0,4000.0,1000.0)
      mazo1 = Civitas::MazoSorpresas.new_mazo_sorpresas_default
      
      descanso = Civitas::Casilla.new_casilla_descanso("Descanso")
      calle= Civitas::Casilla.new_casilla_calle(titulo1)
      impuesto= Civitas::Casilla.new_casilla_impuesto("Impuesto por ser tan guapo", 1500)
      juez= Civitas::Casilla.new_casilla_juez("Juzgados", 3)
      sorpresa= Civitas::Casilla.new_casilla_sorpresa(mazo1, "Quedas libre de la cárcel")
      
      
      #Probando métodos get
      puts ("\n*Probando métodos get....")
        puts ("\t*Descanso")
          puts("\t\tNombre: #{descanso.nombre}")
          puts("\t\tTitulo de propiedad: #{descanso.tituloPropiedad}")
        puts ("\t*Calle")
          puts("\t\tNombre: #{calle.nombre}")
          puts("\t\tTitulo de propiedad: #{calle.tituloPropiedad.to_string}")
        puts ("\t*Impuesto")
          puts("\t\tNombre: #{impuesto.nombre}")
          puts("\t\tTitulo de propiedad: #{impuesto.tituloPropiedad}")
        puts ("\t*Juez")
          puts("\t\tNombre: #{juez.nombre}")
          puts("\t\tTitulo de propiedad: #{juez.tituloPropiedad}")
        puts ("\t*Sorpresa")
          puts("\t\tNombre: #{sorpresa.nombre}")
          puts("\t\tTitulo de propiedad: #{sorpresa.tituloPropiedad}")
      
      puts ("\n*Probando métodos toString....")
        puts ("\t*Descanso #{descanso.to_string}")
        puts ("\t*Calle #{calle.to_string}")
        puts ("\t*Impuesto #{impuesto.to_string}")
        puts ("\t*Juez #{juez.to_string}")
        puts ("\t*Sorpresa #{sorpresa.to_string}")
        
      #Probando resto de métodos
      j1 = Civitas::Jugador.new_jugador("Jesus")
      j2 = Civitas::Jugador.new_jugador("Nuria")
      j3 = Civitas::Jugador.new_jugador("Jose")
      j4 = Civitas::Jugador.new_jugador("Julio")

      todos = []
      todos << j1
      todos << j2
      todos << j3
      todos << j4
      
      
        #Métodos recibe+jugador correcto+informe
      puts ("*Probando métodos recibe")
      descanso.recibe_jugador(0, todos)
      calle.recibe_jugador(0, todos)
      impuesto.recibe_jugador(0, todos)
      juez.recibe_jugador(0, todos)
#      sorpresa.recibe_jugador(0, todos)

        #Leer diario 
      while (Civitas::Diario.instance.eventos_pendientes)
        puts ("\t\t-Diario: #{Civitas::Diario.instance.leer_evento}")
      end
      
      
      puts descanso.inspect

    end
    #--------------------------------------------------------------------
    
    def probar_civitas_juego
      
      #Construir objeto
      nombres = []
      nombres << "Jesus"
      nombres << "Nuria"
      nombres << "Jose"
      nombres << "Julio"
      nombres << "Javilonguis"
      
      juego = Civitas::CivitasJuego.new(nombres)
      
      #Probando getJugadorActual
      puts ("*El jugador actual es: #{juego.get_jugador_actual.nombre}")
      
      #Probando casilla actual
      puts ("*Casilla actual: #{juego.get_casilla_actual.nombre}")
      
      #Probando siguiente paso completado
      puts ("*Probando siguiente paso completado....")
      juego.siguiente_paso_completado(Civitas::Operaciones_juego::AVANZAR)
      while(Civitas::Diario.instance.eventos_pendientes)
        puts Civitas::Diario.instance.leer_evento
      end
        
      
    end
    #--------------------------------------------------------------------
  end


  Test = TestP1.new
  
  Test.prueba1
  
  puts ("*************************************************************")
  puts("PROBANDO TITULO DE PROPIEDAD")
  puts ("*************************************************************")
  Test.probar_titulo
  
  puts ("\n*************************************************************")
  puts("PROBANDO JUGADOR")
  puts ("*************************************************************")
  Test.probar_jugador
  
  puts ("\n*************************************************************")
  puts("PROBANDO SORPRESA")
  puts ("*************************************************************")
  Test.probar_sorpresa
  
  puts ("\n*************************************************************")
  puts("PROBANDO CASILLA")
  puts ("*************************************************************")
  Test.probar_casilla
  
  puts ("\n*************************************************************")
  puts("PROBANDO CIVITASJUEGO")
  puts ("*************************************************************")
  Test.probar_civitas_juego
  
end