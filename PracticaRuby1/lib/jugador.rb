# encoding:utf-8

require_relative 'titulo_propiedad'
require_relative 'sorpresa'
require_relative 'diario'

module Civitas
  class Jugador
    #---------------------------------------------------------
    #Atributos de clase
    @@CasasMax = 4
    @@CasasPorHotel = 4
    @@HotelesMax = 4
    @@PasoPorSalida = 1000
    @@PrecioLibertad = 200
    @@SaldoInicial = 7500
    
    #---------------------------------------------------------
    #Constructor
    def initialize (nombre, otro)
      
      if (otro == nil)    #Contructor vacio con nombre
        
        #Atributos de referencia
        @salvoconducto = nil
        @propiedades = []

        #Atributos de instancia
        @encarcelado = false
        @nombre = nombre
        @numCasillaActual = 0
        @puedeComprar = false
        @saldo = @@SaldoInicial
      
      else                #Constructor de copia
        
        #Atributos de referencia
        @salvoconducto = otro.salvoconducto
        @propiedades = otro.propiedades

        #Atributos de instancia
        @encarcelado = otro.is_encarcelado
        @nombre = otro.nombre
        @numCasillaActual = otro.numCasillaActual
        @puedeComprar = otro.puedeComprar
        @saldo = otro.saldo
      end
       
    end
    
    def self .new_jugador(nombre)
      j = new(nombre,nil)
    end
    
    def self .new_copia (otro)
      j = new("",otro)
    end
    
    private_class_method :new
    
    #---------------------------------------------------------
    #Consultores basicos
    
    attr_reader :CasasMax,:CasasPorHotel,:HotelesMax,:nombre,:numCasillaActual, :salvoconducto
    attr_reader :PrecioLibertad, :PasoPorSalida,:propiedades,:puedeComprar,:saldo
    
    #---------------------------------------------------------
   
    def cancelar_hipoteca(ip)
      resultado = false
      
      if (!@encarcelado && existe_la_propiedad(ip))
        #Obtener precio de cancelacion
        propiedad = @propiedades.at(ip)
        cantidad = propiedad.get_importe_cancelar_hipoteca
        puedo_gastar = puedo_gastar(cantidad)
        
        if (puedo_gastar)
          resultado = propiedad.cancelar_hipoteca(self)
        end
        
        if (resultado)
          evento = "El jugador #{@nombre} cancela la hipoteca de la propiedad"
          evento += " #{ip}"
          Diario.instance.ocurre_evento(evento)
        end
      end
      
      return resultado
    end
    
    def cantidad_casas_hoteles
      contador = 0
      for i in @propiedades
        contador+=i.cantidad_casas_hoteles
      end
      
      return contador
    end
    
    def <=> (otro)
      return @saldo <=> otro.saldo
    end
    
    def comprar(titulo)
      resultado = false
      
      if (!@encarcelado && @puedeComprar)
        precio = titulo.precioCompra
        if (puedo_gastar(precio))
          #Hace pagar y actualiza el propietario
          resultado = titulo.comprar(self)
          
          #Añado a propiedades y aviso al diario
          if (resultado)
            @propiedades<<titulo
            evento = "El jugador #{@nombre} compra la propiedad #{titulo.nombre}"
            Diario.instance.ocurre_evento(evento)
          end
        end
        
        @puedeComprar = false
      end
      
      return resultado
    end
    
    def construir_casa(ip)
      resultado = false
      puedo_edificar_casa = false
      propiedad = @propiedades.at(ip)
      
      if (!@encarcelado && existe_la_propiedad(ip))
        puedo_edificar_casa = puedo_edificar_casa(propiedad)
        precio = propiedad.precioEdificar
        
        if (puedo_edificar_casa)
          resultado = propiedad.construir_casa(self)
        end
        
      end
      
      if (resultado)
        evento = "El jugador #{@nombre} construye casa en la propiedad #{ip}, #{propiedad.nombre}"
        Diario.instance.ocurre_evento(evento)
      end
      
      return resultado
    end
    
    def construir_hotel(ip)
      resultado = false
      
      if (!@encarcelado && existe_la_propiedad(ip))
        
        #obtengo el titulo y veo si puedo edificar
        propiedad = @propiedades.at(ip)
        puedo = puedo_edificar_hotel(propiedad)
        precio = propiedad.precioEdificar
        
        if (puedo)
          #Construir
          resultado = propiedad.construir_hotel(self)
          #Reiniciar casa
          propiedad.derruir_casas(@@CasasPorHotel,self)
          #Diario
          evento = "El jugador #{@nombre} construye hotel en la propiedad #{ip}, #{propiedad.nombre}"
          Diario.instance.ocurre_evento(evento)
        end
      end
      
      return resultado
    end
     
    def debe_ser_encarcelado
      debe = false
      
      if(!@encarcelado)
        if(!tiene_salvoconducto())
          debe = true
        
        else
          Diario.instance.ocurre_evento("El jugador #{@nombre} se libra de la cárcel")
          perder_salvoconducto
        end
      end
      
      return debe
    end
    
    def en_bancarrota
      return @saldo<0
    end
    
    def encarcelar (num_casilla_carcel)
      a_carcel = false
      
      if (debe_ser_encarcelado)
        @numCasillaActual = num_casilla_carcel
        a_carcel = true
        @encarcelado = true
        Diario.instance.ocurre_evento("El jugador #{nombre} va a la cárcel")
      end
      
      return a_carcel
    end
    
   
    def existe_la_propiedad(ip)
      return (@propiedades.size>ip && ip<=0)
    end
    
    def hipotecar(ip)
      resultado = false
      
      if (!@encarcelado && existe_la_propiedad(ip))
        propiedad = @propiedades.at(ip)
        resultado = propiedad.hipotecar(self)
      end
      
      if (resultado)
        evento = "El jugador #{@nombre} hipoteca la propiedad #{ip}"
        Diario.instance.ocurre_evento(evento)
      end
      
      return resultado
      
    end
    
    def is_encarcelado
      return @encarcelado
    end
    
    def modificar_saldo(cantidad)
      @saldo +=cantidad
      
      if (cantidad<0)
        cantidad= -cantidad
        Diario.instance.ocurre_evento("El saldo del jugador #{@nombre} disminuye #{cantidad}")
      else
        Diario.instance.ocurre_evento("El saldo del jugador #{@nombre} aumenta #{cantidad}")
      end
      
      return true
    end
    
    def mover_a_casilla(num_casilla)
      movida = false
      
      if (!is_encarcelado)
        @numCasillaActual = num_casilla
        @puedeComprar = false
        Diario.instance.ocurre_evento("El jugador #{@nombre} avanza a la casilla #{num_casilla}")
        movida = true
      end
      
      return movida
    end
    
    def obtener_salvoconducto(sorpresa)
      obtenido = false
      
      if (!is_encarcelado)
        @salvoconducto = sorpresa
        obtenido = true
      end
      
      return obtenido
    end
    
    def paga (cantidad)
      return modificar_saldo(-cantidad)
    end
    
    def paga_alquiler(cantidad)
      pagado = false
      
      if (!is_encarcelado)
        pagado = paga(cantidad)
      end
      
      return pagado
    end
    
    def paga_impuesto(cantidad)
      pagado = false
      
      if (!is_encarcelado)
        pagado = paga(cantidad)
      end
      
      return pagado
    end
    
    def pasa_por_salida
      Diario.instance.ocurre_evento("El jugador #{@nombre} pasa por la casilla de salida")
      modificar_saldo(@@PasoPorSalida)
      return true
    end
    
    def perder_salvoconducto
      @salvoconducto.usada
      @salvoconducto = nil
    end
    
    def puede_comprar_casilla
      @puedeComprar = !is_encarcelado
      return @puedeComprar
    end
    
    def puede_salir_carcel_pagando
      return @saldo>=@@PrecioLibertad
    end
    
    def puedo_edificar_casa(propiedad)
      i = @propiedades.index(propiedad)
      
      puedo = (i!=nil) && puedo_gastar(propiedad.precioEdificar) && (propiedad.numCasas < @@CasasMax)
    end
    
    def puedo_edificar_hotel(propiedad)
      i = @propiedades.index(propiedad)
      
      condicion1 = (i!=nil) && puedo_gastar(propiedad.precioEdificar) 
      condicion2 = (propiedad.numCasas >= @@CasasPorHotel)
      condicion3 = (propiedad.numHoteles<@@HotelesMax)
      
      puedo = condicion1 && condicion2 && condicion3
      
      return puedo
      
    end
    
    def puedo_gastar(precio)
      puedo = false
      
      if (!is_encarcelado)
        puedo = (@saldo>=precio)
      end
      
      return puedo
    end
    
    def recibe(cantidad)
      recibido = false
      
      if (!is_encarcelado)
        recibido = modificar_saldo(cantidad)
      end
      
      return recibido
    end
    
    def salir_carcel_pagando
      sale = false
      
      if (is_encarcelado() && puede_salir_carcel_pagando())
        paga(@@PrecioLibertad)
        @encarcelado = false
        sale = true
        Diario.instance.ocurre_evento("El jugador #{@nombre} sale de la cárcel pagando")
      end
      
      return sale
    end
    
    def salir_carcel_tirando
      sale = false
      
      if (Dado.instance.salgo_de_la_carcel)
        @encarcelado = false
        sale = true
        Diario.instance.ocurre_evento("El jugador #{@nombre} sale de la cárcel tirando")
      end
      
      return sale
    end
    
    def tiene_algo_que_gestionar
      return !(@propiedades.empty?)
    end
    
    def tiene_salvoconducto
      return @salvoconducto != nil
    end
    
    def to_string
      
      rep_propiedades = ""
      if(!tiene_algo_que_gestionar)
        rep_propiedades = "no tiene propiedades"
      
      else
        for i in @propiedades do
          rep_propiedades+="#{i.nombre}, "
        end
      end
      
      representacion = "Jugador: 
        - Nombre = #{@nombre}
        - Saldo = #{@saldo}
        - Casilla actual =  #{@numCasillaActual}
        - Puede comprar = #{@puedeComprar}
        - Encarcelado = #{@encarcelado}
        - Salvoconducto = #{tiene_salvoconducto()}
        - Propiedades = #{rep_propiedades}
        - Máximo de casas = #{@@CasasMax}
        - Máximo de hoteles = #{@@HotelesMax}
        - Casas por hotel = #{@@CasasPorHotel}
        - Paso por salida = #{@@PasoPorSalida}
        - Precio de libertad = #{@@PrecioLibertad}
        - Saldo inicial = #{@@SaldoInicial}"
     
    
      return representacion
    end
    
    def vender(ip)
      completado = false
      
      if (!@encarcelado && existe_la_propiedad(ip))
        propiedad = (@propiedades[ip])
        completado = propiedad.vender(self)
      end
      
      if (completado)
        evento = "La propiedad #{@propiedades[ip].nombre} ha sido vendida"
        evento += " por el jugador #{@nombre}"
        Diario.instance.ocurre_evento(evento)
        
        propiedades.delete_at(ip)
      end
      
      return completado
    end
    
    #---------------------------------------------------------
    #Métodos privados
    private :debe_ser_encarcelado,:existe_la_propiedad,:perder_salvoconducto
    private :puede_salir_carcel_pagando, :puedo_edificar_casa,:puedo_edificar_hotel
    private :puedo_gastar
    #---------------------------------------------------------
  end
end