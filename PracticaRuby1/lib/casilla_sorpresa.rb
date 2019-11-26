# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Casilla_sorpresa < Casilla
    
    #---------------------------------------------------
    def initialize(nombre,mazo)
      super(nombre)
      @mazo = mazo 
    end
    
    #---------------------------------------------------
    def recibe_jugador(actual,todos)
      if(jugador_correcto(actual,todos))
        #1
        sorpresa = @mazo.siguiente
        #2
        super
        #3
        sorpresa.aplicar_a_jugador(actual, todos)
      end
    end
    #---------------------------------------------------
    def to_string
      representacion = super
      if (@sorpresa != nil)
        representacion += "\n\t- Sorpresa = #{@sorpresa.to_string}"
      end
      return representacion
    end
    #---------------------------------------------------
  end
end
