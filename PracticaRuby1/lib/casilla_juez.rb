# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'casilla'

module Civitas
  class Casilla_juez < Casilla
    
    #----------------------------------------------
    def initialize(nombre,carcel)
      super(nombre)
      @@Carcel = carcel
    end
    
    #----------------------------------------------
    def recibe_jugador (actual,todos)
      if(jugador_correcto(actual,todos))
        super
        #encarcela al jugador
        todos.at(actual).encarcelar(@@Carcel)
      end
    end
    #----------------------------------------------
  
  end
end
