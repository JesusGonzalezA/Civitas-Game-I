# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.


require_relative 'casilla'

module Civitas
  class Casilla_calle < Casilla
    
    #----------------------------------------------
    def initialize(titulo)
      super(titulo.nombre)
      @tituloPropiedad = titulo
    end
    
    #----------------------------------------------
    attr_reader :tituloPropiedad
    #----------------------------------------------
    
    def recibe_jugador(actual,todos)
      if (jugador_correcto(actual,todos))
        #Informe
        super
        
        if (!@tituloPropiedad.tiene_propietario)
          todos.at(actual).puede_comprar_casilla
        else
          @tituloPropiedad.tramitar_alquiler(todos.at(actual))
        end
      end
    end
    #----------------------------------------------
    def to_string
      representacion = super
      
      if (@tituloPropiedad != nil)
        representacion += "\n\t - Titulo de propiedad = #{@tituloPropiedad.to_string}"
      end
      
      return representacion
    end
    #----------------------------------------------

  end
end
