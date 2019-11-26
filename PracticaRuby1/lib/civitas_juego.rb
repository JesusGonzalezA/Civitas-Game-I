# encoding:utf-8

require_relative 'dado'
require_relative 'jugador'
require_relative 'titulo_propiedad'
require_relative 'sorpresa'
require_relative 'estados_juego'
require_relative 'gestor_estados'
require_relative 'operaciones_juego'
require_relative 'mazo_sorpresas'
require_relative 'tablero'
require_relative 'casilla'
require_relative 'casilla_calle'
require_relative 'casilla_impuesto'
require_relative 'casilla_juez'
require_relative 'casilla_sorpresa'


module Civitas
  class CivitasJuego
    
    #--------------------------------------------------------------
    def initialize (nombres)
      
      #Inicializo jugadores
      @jugadores = []
      for i in nombres
        @jugadores << Jugador.new_jugador(i)
      end
      
      #Creo el gestor de estados y fijo el actual
      @gestorEstados = GestorEstados.new()
      @estado = @gestorEstados.estado_inicial
      
      #jugador actual es quien empieza
      @indiceJugadorActual = Dado.instance.quien_empieza(@jugadores.size)
        
      #Creo mazo e inicializo tablero (que tambien lo crea) y mazo
      @mazo = MazoSorpresas.new_mazo_sorpresas_debug(true)
      inicializa_tablero(@mazo)
      inicializa_mazo_sorpresas(@tablero)
     
    end
    
    #--------------------------------------------------------------
    def actualizar_info
      
      salida =""
      
      #Muestra la informacion del jugador actual
      salida = "El jugador actual es el jugador #{@indiceJugadorActual}
        #{@jugadores.at(@indiceJugadorActual).to_string}"
      
      #Muestra la informacion cuando un jugador cae en bancarrota
      rank = ranking
      num_jugadores = rank.size
      i = 0
      pos = 1
      empatados = 1
      
      if (final_del_juego)
        salida += "\nEl juego ha finalizado, ranking: \n"
        
        while (i<num_jugadores)

            salida += "\t #{pos}- #{rank.at(i).nombre}, saldo: #{rank.at(i).saldo}\n"  

          if ((i+1)<num_jugadores)
              if (rank.at(i).saldo != rank.at(i+1).saldo)
                pos+=empatados
                empatados = 1
              else
                empatados+=1
              end
          end

          i+=1
        end
      end
        
      return salida
    end
    
    def avanza_jugador
      #Obtener jugador y su casilla
      jugador_actual = get_jugador_actual
      posicion_actual = jugador_actual.numCasillaActual
      
      #Calcular tirada
      tirada = Dado.instance.tirar
      posicion_nueva = @tablero.nueva_posicion(posicion_actual, tirada)
      
      #Obtener casilla actual
      casilla = @tablero.get_casilla(posicion_nueva)
      
      #Pre -- Contabilizar pasos por salida
      contabilizar_pasos_por_salida(jugador_actual)
      
      #Mover a casilla
      jugador_actual.mover_a_casilla(posicion_nueva)
      casilla.recibe_jugador(@indiceJugadorActual, @jugadores)
      
      #Post -- Contabilizar pasos por salida
      contabilizar_pasos_por_salida(jugador_actual)
      
    end
    
    def cancelar_hipoteca(ip)
      return @jugadores.at(@indiceJugadorActual).cancelar_hipoteca(ip)
    end
    
    def comprar
      jugador_actual = get_jugador_actual
      casilla = get_casilla_actual
      titulo = casilla.tituloPropiedad
      
      res = jugador_actual.comprar(titulo)
    end
    
    def construir_casa(ip)
      return @jugadores.at(@indiceJugadorActual).construir_casa(ip)
    end
    
    def construir_hotel(ip)
      return @jugadores.at(@indiceJugadorActual).construir_hotel(ip)
    end
    
    def contabilizar_pasos_por_salida(jugador_actual)
      
      #Cobro las veces que pasa por salida el jugador actual
      while(@tablero.get_por_salida >0)
        jugador_actual.pasa_por_salida
      end
    end
    
    def final_del_juego
      fin = false
      
      for i in @jugadores
        if (i.en_bancarrota)
          fin = true
        end
      end
      
      return fin
    end
    
    def get_casilla_actual
      return @tablero.get_casilla(get_jugador_actual.numCasillaActual)
    end
    
    def get_jugador_actual
      return @jugadores.at(@indiceJugadorActual)
    end
 
    def hipotecar(ip)
      return get_jugador_actual.hipotecar(ip)
    end
    
    def inicializa_mazo_sorpresas(tablero)
      posPaseoPrado = -1
      i=0
      encontrada = false
      casilla_actual = tablero.get_casilla(i)
      
      while(casilla_actual != nil && !encontrada)
        if ( (casilla_actual.nombre <=> "Paseo del Prado") == 0)
          encontrada = true
          posPaseoPrado = i
        end
        
        i+=1
        casilla_actual = tablero.get_casilla(i)
      end
      
      @mazo.al_mazo(Sorpresa.new_sorpresa_liberar(@mazo))
      @mazo.al_mazo(Sorpresa.new_sorpresa_ir_a(posPaseoPrado, "Ve a Paseo del Prado",tablero))
      @mazo.al_mazo(Sorpresa.new_sorpresa_encarcelar(tablero))
      @mazo.al_mazo(Sorpresa.new_sorpresa(Tipo_sorpresa::PORCASAHOTEL,tablero,-50,"Paga por propiedades"))
      @mazo.al_mazo(Sorpresa.new_sorpresa(Tipo_sorpresa::PAGARCOBRAR,tablero,-50,"Paga"))
      @mazo.al_mazo(Sorpresa.new_sorpresa(Tipo_sorpresa::PORJUGADOR,tablero,50,"Recibe 50 de cada jugador"))
     
    end
    
    def inicializa_tablero(mazo)
      
      indice_carcel = 1
      
      #Creo el tablero
      @tablero = Tablero.new(indice_carcel)
      
      #Añade casillas
      @tablero.añade_casilla(Casilla_sorpresa.new("Caja de comunidad",mazo))
      @tablero.añade_casilla(Casilla.new("Descanso"))
      @tablero.añade_casilla(Casilla_calle.new(TituloPropiedad.new("Murcia",25,50,1000,2000,500)))
      @tablero.añade_casilla(Casilla_impuesto.new("Impuesto por ser tan guapo",1500))
      @tablero.añade_casilla(Casilla_calle.new(TituloPropiedad.new("Paseo del Prado",50,100,2000,4000,1000)))
      @tablero.añade_juez
      
    end
    
    def pasar_turno
      numJugadores = @jugadores.size
      
      @indiceJugadorActual = (@indiceJugadorActual+1)%numJugadores
    end
    
    def ranking
      rank = []
      for i in @jugadores
        rank << i
      end
      
      #Ordeno el rank (mayor a menor) sin alterar jugadores
      rank.sort!{|a,b| b<=>a}
      
      return rank
    end
    
    def salir_carcel_pagando
      return get_jugador_actual.salir_carcel_pagando
    end
    
    def salir_carcel_tirando
      return get_jugador_actual.salir_carcel_tirando
    end
    
    def siguiente_paso
      jugador_actual = get_jugador_actual
      operacion = @gestorEstados.operaciones_permitidas(jugador_actual, @estado)
    
      if (operacion == Operaciones_juego::PASAR_TURNO)
        pasar_turno
        siguiente_paso_completado(operacion)
        
      else if(operacion == Operaciones_juego::AVANZAR)
        avanza_jugador
        siguiente_paso_completado(operacion)
      end
      end
      
      return operacion
    end
    
    def siguiente_paso_completado(operacion)
      @estado = @gestorEstados.siguiente_estado(get_jugador_actual, @estado, operacion)
    end
    
    def vender(ip)
      return get_jugador_actual.vender(ip)
    end
    
    #--------------------------------------------------------------
    private :inicializa_mazo_sorpresas, :inicializa_tablero
    private :contabilizar_pasos_por_salida
    private :pasar_turno, :ranking,:avanza_jugador
    
    #--------------------------------------------------------------
  end
end
