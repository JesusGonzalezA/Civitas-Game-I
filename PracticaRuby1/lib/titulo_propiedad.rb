# encoding:utf-8
require_relative 'jugador'

module Civitas
  class TituloPropiedad
    
    #---------------------------------------------------------
    #Atributos de clase
    @@FactorInteresesHipoteca = 1.1
    #---------------------------------------------------------
    #Constructor
    def initialize (nom,ab,fr,hb,pc,pe)
      
      #Atributos de referencia
      @propietario = nil
      
      #Atributos de instancia
      @alquilerBase = ab
      @factorRevalorizacion = fr
      @hipotecaBase = hb
      @hipotecado = false
      @nombre = nom
      @numCasas = 0
      @numHoteles = 0
      @precioCompra = pc
      @precioEdificar = pe
    end
    
   
      
    #---------------------------------------------------------
  
    def actualiza_propietario_por_conversion(jugador)
      @propietario = jugador
    end
    
    def cancelar_hipoteca(jugador)
      cancelada = false
      
      if (@hipotecado && es_este_el_propietario(jugador))
        jugador.paga(get_importe_cancelar_hipoteca())
        @hipotecado = false
        cancelada = true
      end
      
      return cancelada
    end
    
    def cantidad_casas_hoteles()
      return (@numCasas + @numHoteles)
    end
    
    def comprar(jugador)
      operacion = false
      
      if (!tiene_propietario())
        jugador.paga(@precioCompra)
        @propietario = jugador
        operacion = true
      end
      
      return operacion
    end
    
    def construir_casa(jugador)
      construida = false
      
      if (es_este_el_propietario(jugador))
        jugador.paga(@precioEdificar)
        @numCasas+=1
        construida = true
      end
      
      return construida
    end
    
    def construir_hotel(jugador)
      construido = false
      
      if (es_este_el_propietario(jugador))
        jugador.paga(@precioEdificar)
        @numHoteles+=1
        construido = true
      end
      
      return construido
    end
    
    def derruir_casas(n,jugador)
      operacion_completada = false
      
      if (es_este_el_propietario(jugador) && @numCasas>=n)
        @numCasas-=n
        operacion_completada = true
      end
      
      return operacion_completada
    end
    
    def es_este_el_propietario(jugador)
      return propietario == jugador
    end
    
    #---------------------------------------------------------
    #Consultores
      #Basicos
    attr_reader :hipotecado,:nombre,:numCasas,:numHoteles,:precioCompra,:precioEdificar,:propietario
      
    #---------------------------------------------------------
      #Resto
    
    def get_importe_hipoteca
      return @hipotecaBase*((@numCasas*0.5)+1+(2.5*@numHoteles))
    end
    
    def get_importe_cancelar_hipoteca
      return @hipotecaBase*@@FactorInteresesHipoteca
    end
    
    
    def get_precio_alquiler
      return @alquilerBase*(1+(@numCasas*0.5)+(@numHoteles*2.5))
    end
    
   
    def get_precio_venta
      precio_venta = @precioCompra + (@numCasas+5*@numHoteles)* @precioEdificar * @factorRevalorizacion
      return precio_venta
    end
    
    #---------------------------------------------------------
    
    def hipotecar (jugador)
      operacion_completada = false
      
      if (!@hipotecado && es_este_el_propietario(jugador))
        jugador.recibe(get_importe_hipoteca())
        @hipotecado = true
        operacion_completada = true
      end
      
      return operacion_completada
    end
    
    
    def propietario_encarcelado
      encarcelado = false
      
      if (tiene_propietario())
        if (@propietario.is_encarcelado)
          encarcelado = true
        end
      end
      
      return encarcelado
    end
    
   
    def tiene_propietario
      return @propietario != nil
    end
    
    def to_string
      representacion = "Titulo Propiedad: 
        - Nombre = #{@nombre}
        - Alquiler base = #{@alquilerBase}
        - Factor de revalorización =  #{@factorRevalorizacion}
        - Hipoteca base = #{@hipotecaBase}
        - Precio de compra = #{@precioCompra}
        - Precio de edificar = #{@precioEdificar}
        - Número de casas = #{@numCasas}
        - Número de hoteles = #{@numHoteles}"
                        
      if (!tiene_propietario)
        representacion += "\n\t- Propietario = sin propietario\n"
      else
         representacion+= "\n\t- Propietario = #{@propietario.nombre}"
      end
    
      return representacion
    end
    
    def tramitar_alquiler(jugador)
      if(tiene_propietario && !es_este_el_propietario(jugador))
        alquiler = get_precio_alquiler
        jugador.paga_alquiler(alquiler)
        @propietario.recibe(alquiler)
      end
    end
    
    def vender(jugador)
      operacion_completada = false
      
      if (!@hipotecado && es_este_el_propietario(jugador))
        
        #Recibe la venta
        @propietario.recibe(get_precio_venta)
        
        #Desvinculo la propiedad del jugador
        @propietario = nil
        
        #Reinicio el titulo
        @numCasas = 0
        @numHoteles = 0
        operacion_completada = true
      end
      
      return operacion_completada
    end
    #---------------------------------------------------------
    #---------------------------------------------------------
    #---------------------------------------------------------
  
    
    #---------------------------------------------------------
    #---------------------------------------------------------
    #Métodos privados
    private :es_este_el_propietario, :get_importe_hipoteca, :get_precio_alquiler
    private :get_precio_venta, :propietario_encarcelado
    
    #---------------------------------------------------------

  end
end
