# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'sorpresa'

module Civitas
  class SorpresaPagarCobrar < Sorpresa
    
    def initialize (texto,valor)
      super(texto)
      @valor = valor
    end
    #-------------------------------------------------------------
    public_class_method :new
    #-------------------------------------------------------------
    #--------------------------------------------
    def aplicar_a_jugador(actual,todos)
      if (jugador_correcto(actual,todos))
        super
        todos.at(actual).modificar_saldo(@valor)
      end
    end
    
    #--------------------------------------------
  end
end
