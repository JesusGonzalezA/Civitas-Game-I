# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class SorpresaIrCasilla < Sorpresa
    
    #--------------------------------------------
    def initialize(valor,texto,tablero)
      super(texto)
      @valor = valor
      @tablero = tablero
    end
    #-------------------------------------------------------------
    public_class_method :new
    #-------------------------------------------------------------
    #--------------------------------------------
    def aplicar_a_jugador(actual,todos)
      if (jugador_correcto(actual,todos))
        super
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
    
    #--------------------------------------------
    
  end
end