# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'sorpresa'

module Civitas
  class SorpresaPorJugador < Sorpresa
    
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
        
        #Todos los jugadores pagan al jugador actual
        texto_pagar = "Pagas #{@valor} al jugador #{todos.at(actual).nombre}"
        texto_cobrar = "Recibes #{@valor} de cada jugador"
        num_jugadores = todos.size
        a_cobrar = (num_jugadores-1) * @valor
        pagar = SorpresaPagarCobrar.new(texto_pagar,0-@valor)
        cobrar = SorpresaPagarCobrar.new(texto_cobrar,a_cobrar)
        
          #Aplico pagos
        contador = 0
        for i in todos
          if contador != actual
            pagar.aplicar_a_jugador(contador,todos)
          end
          contador+=1
        end
        
          #Aplico cobro
        cobrar.aplicar_a_jugador(actual,todos)
      end
    end
    #--------------------------------------------
  end
end
