# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

#En Ruby, el constructor
#solo inicializará la fianza, y se hará uso de un método de clase (nuevoEspeculador(jugador,fianza))
#que creará un nuevo jugadorEspeculador, llamará al método copia de la clase Jugador, para crear el
#resto de atributos del JugadorEspeculador mediante copia del Jugador, actualizará las propiedades
#por conversión (ver párrafo siguiente) y devolverá el jugadorEspeculador creado. Recordar que en
#Ruby el método copia(otroJugador) de la clase jugador es el constructor por copia.

require_relative 'diario'
require_relative 'jugador'

module Civitas
  class JugadorEspeculador < Jugador
    
    @FactorEspeculador = 2
    @CasasMax = Jugador.CasasMax * @FactorEspeculador
    @HotelesMax = Jugador.HotelesMax * @FactorEspeculador
    
    def initialize(otro,fianza)
      super("",otro)
      @fianza = fianza
    end
    
    #-----------------------------------
    public_class_method :new
    #------------------------------------
    def self .FactorEspeculador
      @FactorEspeculador
    end
    
    def paga_impuesto(cantidad)
      super(cantidad/self.class.FactorEspeculador)
    end
    #------------------------------------
    def to_string
      representacion = super + "\n\t- JUGADOR ESPECULADOR\n"
    end
    #------------------------------------
    def debe_ser_encarcelado
      debe = super
      
      if (debe)
        if (@fianza <= @saldo)
          debe = false
          modificar_saldo(-@fianza)
          
          #Informar a diario
          evento = "El jugador #{@nombre} se libra de la carcel mediante fianza"
          Diario.instance.ocurre_evento(evento)
        end
      end
      
      return debe
    end
    #------------------------------------
    
  end
end

