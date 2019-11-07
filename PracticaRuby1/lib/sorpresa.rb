# encoding:utf-8

require_relative 'tablero'
require_relative 'mazo_sorpresas'
require_relative 'tipo_sorpresa'

module Civitas
  class Sorpresa

    #------------------------------------------
    #Atributos de clase
    @@VALORNULO = 0
    
    #------------------------------------------
    
    #consultor
    attr_reader :texto
      
   # Constructores 
    
    def init ()
      @valor = @@VALORNULO
      @mazo = nil
      @tablero = nil
      @texto = ""
    end
    
    def initialize (tipo, *args)
      init
      @tipo = tipo
      
      case @tipo 
      when Tipo_sorpresa::IRCARCEL
        @tablero = args[0]
        @valor = @tablero.numCasillaCarcel
        @texto = "Ve a la Cárcel"
      when Tipo_sorpresa::IRCASILLA
        @valor = args[0]
        @texto = args[1]
        @tablero = args[2]
      when Tipo_sorpresa::SALIRCARCEL
        @mazo = args[0]
        @texto = "Quedas libre de la Cárcel"
      else
        @tablero = args[0]
        @valor =  args[1]
        @texto = args[2]
      end
      
    end
    
    
    def self .new_sorpresa_encarcelar(tablero)
      tipo = Tipo_sorpresa::IRCARCEL
      s = new(tipo,tablero)
      s
    end

    def self .new_sorpresa(tipo,tablero,valor,texto)
      s = new(tipo,tablero,valor,texto)
      s
    end
    
    def self .new_sorpresa_ir_a(valor,texto,tablero)
      tipo = Tipo_sorpresa::IRCASILLA
      s = new(tipo,valor,texto,tablero)
      s
    end
    
    def self .new_sorpresa_liberar(mazo)
      tipo = Tipo_sorpresa::SALIRCARCEL
      s = new(tipo,mazo)
      s
    end
    
    
    
    #-----------------------------------------
    private_class_method :new
    #------------------------------------------
    
    def aplicar_a_jugador(actual,todos)
      case @tipo
      when Tipo_sorpresa::IRCASILLA
        aplicar_a_jugador_ir_a_casilla(actual,todos)
        
      when Tipo_sorpresa::IRCARCEL
        aplicar_a_jugador_ir_a_carcel(actual,todos)
        
      when Tipo_sorpresa::PAGARCOBRAR
        aplicar_a_jugador_pagar_cobrar(actual,todos)
        
      when Tipo_sorpresa::PORCASAHOTEL
        aplicar_a_jugador_por_casa_hotel(actual,todos)
        
      when Tipo_sorpresa::PORJUGADOR
        aplicar_a_jugador_por_jugador(actual,todos)
        
      when Tipo_sorpresa::SALIRCARCEL
        aplicar_a_jugador_salir_carcel(actual,todos)
      end
    end
  
    def aplicar_a_jugador_ir_a_casilla(actual,todos)
     
      if (jugador_correcto(actual,todos))
        informe(actual,todos)
        
        #Ir a casilla
          
          #Calcular la posicion en el tablero para reflejar posible paso por salida
          casilla_actual = todos.at(actual).numCasillaActual
          tirada = @tablero.calcular_tirada(casilla_actual, @valor)
          casilla_actual = @tablero.nueva_posicion(casilla_actual, tirada)
          
          #Mover a la nueva posicion
          todos.at(actual).mover_a_casilla(casilla_actual)
          
          #La casilla recibe al jugador
          @tablero.get_casilla(casilla_actual).recibe_jugador(actual,todos)
          
      end
    end
      
    def aplicar_a_jugador_ir_a_carcel(actual,todos)
      
      if (jugador_correcto(actual,todos))
        informe(actual,todos)
        todos.at(actual).encarcelar(@tablero.numCasillaCarcel)
      end
      
    end
    
    def aplicar_a_jugador_pagar_cobrar(actual,todos)
      
      if (jugador_correcto(actual,todos))
        informe(actual,todos)
        
        todos.at(actual).modificar_saldo(@valor)
      end
    end
    
    def aplicar_a_jugador_por_casa_hotel(actual,todos)
      
      if (jugador_correcto(actual,todos))
        informe(actual,todos)
        
        #Modifico el saldo en funcion del numero de edificaciones
        j = Civitas::Jugador.new_copia(todos.at(actual))
        j.modificar_saldo(@valor * j.cantidad_casas_hoteles)
        
      end
    end
    
    def aplicar_a_jugador_por_jugador(actual,todos)
      
      if (jugador_correcto(actual,todos))
        informe(actual,todos)
        
        #Todos los jugadores pagan al jugador actual
        texto_pagar = "Pagas #{@valor} al jugador #{todos.at(actual).nombre}"
        texto_cobrar = "Recibes #{@valor} de cada jugador"
        num_jugadores = todos.size
        a_cobrar = (num_jugadores-1) * @valor
        pagar = Sorpresa.new_sorpresa(Tipo_sorpresa::PAGARCOBRAR,@tablero,0-@valor,texto_pagar)
        cobrar = Sorpresa.new_sorpresa(Tipo_sorpresa::PAGARCOBRAR,@tablero,a_cobrar,texto_cobrar)
        
          #Aplico pagos
        contador = 0
        for i in todos
          if contador != actual
            pagar.aplicar_a_jugador(contador,todos)
          end
          contador+=1
        end
        
          #Aplico cobro
        cobrar.aplicar_a_jugador(actual,todos)
        
      end
    end
    
    def aplicar_a_jugador_salir_carcel(actual,todos)
      
      if (jugador_correcto(actual,todos))
        informe(actual,todos)
        #Pregunto por el salvoconducto
        alguien_tiene_sv = false
        
        for i in todos
          if (i.tiene_salvoconducto)
            alguien_tiene_sv = true
          end
        end
        
        #Si nadie lo tiene lo obtiene el actual y se sale del mazo
        if (!alguien_tiene_sv)
          todos.at(actual).obtener_salvoconducto(self)
          salir_del_mazo
        end
        
      end
    end
    
    #------------------------------------------
    def informe(actual,todos)
      evento = "Se esta aplicando la sorpresa #{to_string} al jugador #{todos.at(actual).nombre}"
      Diario.instance.ocurre_evento(evento)
    end
    
    def jugador_correcto(actual,todos)
      num_jugadores = todos.size
      return (num_jugadores > actual && actual>=0)
    end
    
    def salir_del_mazo()
      if (@tipo == Tipo_sorpresa::SALIRCARCEL)
        @mazo.inhabilitar_carta_especial(self)
      end
    end
    
    def to_string
      return @texto
    end
    
    def usada 
      if (@tipo == Tipo_sorpresa::SALIRCARCEL)
        @mazo.habilitar_carta_especial(self)
      end
    end
    
    #------------------------------------------
    private :aplicar_a_jugador_ir_a_casilla,:aplicar_a_jugador_ir_a_carcel
    private :aplicar_a_jugador_pagar_cobrar, :aplicar_a_jugador_por_casa_hotel
    private :aplicar_a_jugador_por_jugador, :aplicar_a_jugador_salir_carcel
    private :informe
    #------------------------------------------

  end
end