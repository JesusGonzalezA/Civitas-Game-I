# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'sorpresa'

module Civitas
  class SorpresaSalirCarcel < Sorpresa
    
    def initialize(mazo)
      super("Quedas libre de la carcel")
      @mazo = mazo
    end
    
    #-------------------------------------------------------------
    public_class_method :new
    #-------------------------------------------------------------
    #--------------------------------------------
    def aplicar_a_jugador(actual,todos)
      
      if (jugador_correcto(actual,todos))
        super
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
    
    #--------------------------------------------
    def usada 
      @mazo.habilitar_carta_especial(self)
    end
    
    def salir_del_mazo()
      @mazo.inhabilitar_carta_especial(self)
    end
    #--------------------------------------------
  end
end
