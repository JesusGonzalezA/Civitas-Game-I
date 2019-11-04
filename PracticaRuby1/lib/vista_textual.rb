#encoding:utf-8
require_relative 'operaciones_juego'
require 'io/console'

module Civitas

  class Vista_textual

    def mostrar_estado(estado)
      puts estado
    end

    
    def pausa
      print "Pulsa una tecla "
      STDIN.getch
      print "\n"
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
        mostrar_estado( tab+index.to_s+"-"+l)
        index += 1
      }

      opcion = lee_entero(lista.length,
                          "\n"+tab+"Elige una opción: ",
                          tab+"Valor erróneo")
      return opcion
    end

    
    def comprar
    end

    def gestionar
    end

    def getGestion
    end

    def getPropiedad
    end

    def mostrarSiguienteOperacion(operacion)
    end

    def mostrarEventos
    end

    def setCivitasJuego(civitas)
         @juegoModel=civitas
         self.actualizarVista
    end

    def actualizarVista
    end

    
  end

end