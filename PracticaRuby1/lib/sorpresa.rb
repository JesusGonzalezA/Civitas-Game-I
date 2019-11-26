# encoding:utf-8

require_relative 'diario'

module Civitas
  class Sorpresa
    
    #consultor
    attr_reader :texto
      
   # Constructores 
    def initialize (texto)
      @texto = texto
    end
    
    #-----------------------------------------
    private_class_method :new
    #------------------------------------------
    
    def aplicar_a_jugador(actual,todos)
      if (jugador_correcto(actual,todos))
        informe(actual,todos)
      end
    end     
    
    #------------------------------------------
    def informe(actual,todos)
      evento = "Se esta aplicando la sorpresa [#{to_string}] al jugador #{todos.at(actual).nombre}"
      Diario.instance.ocurre_evento(evento)
    end
    
    def jugador_correcto(actual,todos)
      num_jugadores = todos.size
      return (num_jugadores > actual && actual>=0)
    end
    
    def to_string
      return @texto
    end
    #------------------------------------------
    private :informe
    #------------------------------------------

  end
end