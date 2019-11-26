# encoding:utf-8

require_relative 'diario'

module Civitas
  class Casilla
  
    def initialize (nombre)
      @nombre = nombre 
    end
  
    #---------------------------------------------------------------
    attr_reader :nombre
    #---------------------------------------------------------------
    
    def informe (actual,todos)
      evento = "El jugador #{todos.at(actual).nombre} ha caido en la casilla #{@nombre}"
      #Informo a diario
      Diario.instance.ocurre_evento(evento)
      evento
    end
    
    def jugador_correcto(actual, todos)
      num_jugadores = todos.size
      return (num_jugadores > actual && actual>=0)
    end
    
    def recibe_jugador (actual,todos)
      if (jugador_correcto(actual,todos))
        informe(actual,todos)
      end
    end
    
    def to_string
      representacion = "Casilla:
         - Nombre = #{@nombre}"
      
      return representacion
    end
    
    #---------------------------------------------------------------
    private :informe
    #---------------------------------------------------------------
    
    
  end
end