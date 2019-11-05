# encoding:utf-8

require_relative 'civitas_juego'
require_relative 'operaciones_juego'
require_relative 'respuestas'
require_relative 'operacion_inmobiliaria'
require_relative 'gestiones_inmobiliarias'
require_relative 'salidas_carcel'

module Civitas
  class Controlador
    
    @@lista_Operaciones_inmobiliarias = [
                                    Gestiones_inmobiliarias::VENDER,
                                    Gestiones_inmobiliarias::HIPOTECAR,
                                    Gestiones_inmobiliarias::CANCELAR_HIPOTECA,
                                    Gestiones_inmobiliarias::CONSTRUIR_CASA,
                                    Gestiones_inmobiliarias::CONSTRUIR_HOTEL,
                                    Gestiones_inmobiliarias::TERMINAR
                                   ]
    def initialize (j,v)
      @juego = j
      @vista = v
    end
    
    def juega
      
      #Mostrar el estado del juego actualizado
      @vista.setCivitasJuego(@juego)
      continuar = !@juego.final_del_juegol
      
      while (continuar)
        
        #Muestro el estado actual del juego
        @vista.actualizarVista
        @vista.pausa
        
        #Mostrar la siguiente operacion y diario
        operacion = @juego.siguiente_paso
        @vista.mostrarSiguienteOperacion(operacion)
        
        if (operacion != Operaciones_juego::PASAR_TURNO)
          @vista.mostrarEventos
        end
        
        #Veo si es el final del juego
        continuar = !@juego.final_del_juego
        resp = nil
        
        if (continuar)
          case operacion
            
          #COMPRAR
          when Operaciones_juego::COMPRAR
            resp = @vista.comprar
            if (resp == Respuestas::SI)
              @juego.comprar
            end
            @juego.siguiente_paso_completado(operacion)
            
          #GESTIONAR 
          when Operaciones_juego::GESTIONAR
            @vista.gestionar
            
            #Obtengo la gestion inmobiliaria
            igestion = @vista.iGestion
            ipropiedad = @vista.iPropiedad
            
            gestion = @@lista_Operaciones_inmobiliarias[igestion]
            
            #Si la gestion es terminar se completa
            case gestion
            when Gestiones_inmobiliarias::VENDER
              @juego.vender(ipropiedad)
            when Gestiones_inmobiliarias::HIPOTECAR
              @juego.hipotecar(ipropiedad)
            when Gestiones_inmobiliarias::CANCELAR_HIPOTECA
              @juego.cancelar_hipoteca(ipropiedad)
            when Gestiones_inmobiliarias::CONSTRUIR_CASA
              @juego.construir_casa(ipropiedad)
            when Gestiones_inmobiliarias::CONSTRUIR_HOTEL
              @juego.construir_hotel(ipropiedad)
            when Gestiones_inmobiliarias::TERMINAR
              @juego.siguiente_paso_completado(operacion)
            end
            
          #SALIR_CARCEL
          when Operaciones_juego::SALIR_CARCEL
            tipo_salida = @vista.salir_carcel
            
            if (tipo_salida == Civitas::Salidas_carcel::PAGANDO)
              @juego.salir_carcel_pagando
            else
              @juego.salir_carcel_tirando
            end
            
            @juego.siguiente_paso_completado(operacion)
          end
        end #if continuar
        
      end #while jugar
      
    end #juega
    
  end
end
