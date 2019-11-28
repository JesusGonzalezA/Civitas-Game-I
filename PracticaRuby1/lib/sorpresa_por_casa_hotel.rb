# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'sorpresa'

require_relative 'jugador'

module Civitas
  class SorpresaPorCasaHotel < Sorpresa
    
    def initialize(texto,valor)
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
        #Modifico el saldo en funcion del numero de edificaciones
        j = Civitas::Jugador.new_copia(todos.at(actual))
        j.modificar_saldo(@valor * j.cantidad_casas_hoteles)
      end
    end
    #--------------------------------------------
  end
end
