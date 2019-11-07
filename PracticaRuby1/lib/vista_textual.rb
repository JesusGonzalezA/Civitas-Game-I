#encoding:utf-8

require_relative 'operaciones_juego'
require_relative 'gestiones_inmobiliarias'
require_relative 'salidas_carcel'
require_relative 'respuestas'
require_relative 'civitas_juego'
require 'io/console'

module Civitas

  class Vista_textual

    @@MAX = 100
    @@separador = "======================="
    @@lista_Respuestas = [Respuestas::NO,Respuestas::SI]
    @@lista_Salidas_carcel = [Salidas_carcel::PAGANDO,Salidas_carcel::TIRANDO]
    @@lista_Operaciones_inmobiliarias = [
                                    Gestiones_inmobiliarias::VENDER,
                                    Gestiones_inmobiliarias::HIPOTECAR,
                                    Gestiones_inmobiliarias::CANCELAR_HIPOTECA,
                                    Gestiones_inmobiliarias::CONSTRUIR_CASA,
                                    Gestiones_inmobiliarias::CONSTRUIR_HOTEL,
                                    Gestiones_inmobiliarias::TERMINAR
                                   ]
        
    def initialize 
      @iGestion = -1
      @iPropiedad = -1
      @juegoModel = nil
    end
    
    def mostrar_estado(estado)
      puts estado
    end

    
    def pausa
      mostrar_estado ("Pulsa una tecla ")
      STDIN.getch
      mostrar_estado( "\n" )
    end

    def lee_entero(max,msg1,msg2)
      ok = false
      begin
        print msg1
        cadena = gets.chomp
        begin
          if (cadena =~ /\A\d+\Z/)
            numero = cadena.to_i
            ok = true
          else
            raise IOError
          end
        rescue IOError
          mostrar_estado( msg2 )
        end
        if (ok)
          if (numero >= max)
            ok = false
          end
        end
      end while (!ok)

      return numero
    end



    def menu(titulo,lista)
      tab = "  "
      mostrar_estado( titulo )
      index = 0
      lista.each { |l|
        mostrar_estado( "#{tab}#{index.to_s}-#{l}")
        index += 1
      }

      opcion = lee_entero(lista.length,
                          "\n#{tab}Elige una opción: ",
                          "#{tab}Valor erróneo")
      return opcion
    end

    def salir_carcel
      opcion = menu("Elige la forma para intentar salir de la cárcel",
                    @@lista_Salidas_carcel)
                  
      return @@lista_Salidas_carcel[opcion]
    end
    
    def comprar
      opcion = menu("¿Desea comprar la calle?", @@lista_Respuestas)
      return @@lista_Respuestas[opcion]
    end

    def gestionar
      
      #Creo menu de gestion inmobiliaria
      opcion = menu("¿Qué gestión desea proceder?", @@lista_Operaciones_inmobiliarias)
      
      #Si es terminar no actúo sobre ninguna propiedad
      @iPropiedad = -1
      @iGestion = opcion
      
      #Si no es terminar hago menú para actuar sobre una propiedad
      #y actualizo iPropiedad
      indice_terminar = @@lista_Operaciones_inmobiliarias.index(Gestiones_inmobiliarias::TERMINAR)
      if (opcion != indice_terminar)
        msg1 = "\n\tIntroduce el índice de la propiedad:\t"
        msg2 = "\tEl índice es erróneo"
        @iPropiedad = lee_entero(@@MAX,msg1,msg2)
      end
      
    end

    attr_reader :iPropiedad,:iGestion
    
    def mostrarSiguienteOperacion(operacion)
      salida = "La siguiente operacion es #{operacion}"
      mostrar_estado(salida)
    end

    def mostrarEventos
      mostrar_estado("\n--> Mostrando eventos pendientes del diario...")
      
      if (!Diario.instance.eventos_pendientes)
        mostrar_estado("[DIARIO] No hay eventos para mostrar")
      else
        continuar = true
        while(continuar)
          mostrar_estado("[DIARIO] #{Diario.instance.leer_evento}")
          if (!Diario.instance.eventos_pendientes)
            continuar = false
          end
        end
      end
      
    end

    def setCivitasJuego(civitas)
         @juegoModel=civitas
         #self.actualizarVista
    end

    def actualizarVista
      jugador_actual = @juegoModel.get_jugador_actual
      titulo = "VISTA ESTADO ACTUAL JUEGO"
      separador = "\n----------------------------------------------\n"
      info_jugador = separador
      info_casilla = separador+@juegoModel.get_casilla_actual.to_string
      
      #Muestro jugador
      info_jugador += @juegoModel.actualizar_info
      salida = "\n#{separador}#{titulo}#{info_jugador}#{info_casilla}#{separador}"
      
      mostrar_estado(salida)
      
    end

    
  end
  
end