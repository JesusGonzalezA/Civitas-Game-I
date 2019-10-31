# encoding:utf-8
require_relative 'casilla'

module Civitas
  class Tablero


    ############################################################################
    #Declaro los atributos de instancia en el initialize
    def initialize (miCasillaCarcel)

      #Si el arg >=1 será el valor numCasillaCarcel, sino será 1
      if miCasillaCarcel>0
        @numCasillaCarcel = miCasillaCarcel
      else
        @numCasillaCarcel = 1
      end

      #creo array vacio y añado Salida
      @casillas = []
      @casillas << Casilla.new_casilla_descanso("Salida")
      

      @porSalida = 0
      @tieneJuez = false

    end  #initialize

    ############################################################################
    #Metodos de instancia privados
    def correcto()
      return @casillas.size > @numCasillaCarcel
    end

    def casilla_correcta(numCasilla)
      return correcto() && (@casillas.size() > numCasilla)
    end

    private :correcto
    private :casilla_correcta

    ############################################################################
    #Resto de Métodos

    #--------------------------------------
    #Consultores basicos
    #--------------------------------------
    attr_reader :numCasillaCarcel, :casillas

    #--------------------------------------
    #Resto de consultores
    #--------------------------------------

    def get_por_salida()

      veces_por_salida = @porSalida

      @porSalida-=1 if veces_por_salida >0

      return veces_por_salida
    end

    def get_casilla (num_casilla)
      c = nil
      if (casilla_correcta(num_casilla))
        c = @casillas.at(num_casilla)
      end
      return c
    end

    #--------------------------------------
    #Métodos para añadir
    #--------------------------------------

    def añade_casilla (casilla)
      if @casillas.size == @numCasillaCarcel
        @casillas.push(Casilla.new_casilla_descanso("Carcel")) 
      end

      @casillas.push(casilla)

      if @casillas.size == @numCasillaCarcel
        @casillas.push(Casilla.new_casilla_descanso("Carcel"))    
      end
    end
    
    def añade_juez 
      if @tieneJuez==false
        añade_casilla(Casilla.new_casilla_juez("Juez", @numCasillaCarcel))
      end
      
    end

    #--------------------------------------
    #Métodos relacionados con el dado
    #--------------------------------------
    def nueva_posicion (actual,tirada) 
      pos_final = -1

      if correcto()
        pos_final = ( actual + tirada ) % @casillas.size()
        veces_por_salida = ( actual + tirada ) / @casillas.size()
        @porSalida += veces_por_salida
      end

      return pos_final
    end

    def calcular_tirada (origen,destino) 
      tirada = 0
      tirada = (destino-origen) + @porSalida*@casillas.size()
      return tirada;
    end

  end
end