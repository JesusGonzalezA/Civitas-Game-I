# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Casilla_impuesto < Casilla
    
    #-----------------------------------------------------
    def initialize(nombre,importe)
      super(nombre)
      @importe = importe
    end
    
    #-----------------------------------------------------
    def recibe_jugador (actual,todos)
      if(jugador_correcto(actual,todos))
        super
        #Jugador paga el impuesto
        todos.at(actual).paga_impuesto(@importe)
      end
    end
    #-----------------------------------------------------
  end
end
