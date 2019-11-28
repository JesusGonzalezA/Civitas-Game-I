# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'jugador_especulador'
require_relative 'sorpresa'

module Civitas
  class SorpresaConvertir < Sorpresa
    
    #-------------------------------------------------------------
    def initialize(fianza)
      super("Convertir a jugador especulador")
      @fianza = fianza
    end
    
    #-------------------------------------------------------------
    public_class_method :new
    #-------------------------------------------------------------
    
    def aplicar_a_jugador(actual,todos)
      if (jugador_correcto(actual,todos))
        super
        jact = todos.at(actual)
        todos[actual] = JugadorEspeculador.new(jact,@fianza)
      end
    end     
    #-------------------------------------------------------------
  end
end
