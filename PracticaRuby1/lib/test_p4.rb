# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'sorpresa_convertir'
require_relative 'diario'
require_relative 'jugador_especulador'
require_relative 'jugador'
require_relative 'titulo_propiedad'

module Civitas
  class TestP4
    
    def self .prueba
      
      #Declaro variables
      j1 = Jugador.new_jugador("Jesus")
      murcia = TituloPropiedad.new("Murcia",25.0,50.0,1000.0,2000.0,500.0)
      
      #Compro la casilla
      j1.puede_comprar_casilla
      j1.comprar(murcia)
      murcia.actualiza_propietario_por_conversion(j1)
      
      #Mostrar que la transacción ha sido un éxito
      puts j1.to_string
      puts murcia.to_string
      
      j1.paga_impuesto(200)
      
      #Cambiar a jugador especulador
      convertir = SorpresaConvertir.new(50)
      todos = []
      todos << j1
      convertir.aplicar_a_jugador(0, todos)
      
      #Muestro el propietario
      puts murcia.propietario.to_string
      
      todos.at(0).paga_impuesto(200)
      todos.at(0).encarcelar(0)
      
      puts "\n\n\n"
      #Leer diario
      while(Diario.instance.eventos_pendientes)
        puts "\t[DIARIO]- #{Diario.instance.leer_evento}"
      end
    end
  end
  
  TestP4.prueba
end
