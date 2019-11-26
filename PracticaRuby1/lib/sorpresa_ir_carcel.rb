# encoding:utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class SorpresaIrCarcel < Sorpresa
    
    def initialize(tablero)
      super("Ve a la Cárcel")
      @tablero = tablero
      @valor = @tablero.numCasillaCarcel
    end
    #-------------------------------------------------------------
    public_class_method :new
    #-------------------------------------------------------------
    #---------------------------------------------------
    def aplicar_a_jugador_ir_a_carcel(actual,todos)
      if (jugador_correcto(actual,todos))
        super
        todos.at(actual).encarcelar(@tablero.numCasillaCarcel)
      end
    end
    #--------------------------------------------------
  end
end
