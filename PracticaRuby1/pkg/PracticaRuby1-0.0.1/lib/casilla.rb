# encoding:utf-8

require_relative 'tipo_casilla'
require_relative 'titulo_propiedad'
require_relative 'sorpresa'
require_relative 'mazo_sorpresas'

module Civitas
  class Casilla
  
    #Atributos de clase
    @@Carcel = -1 
    
    def initialize (tipo,*args)
      
      init
      @tipo = tipo
      
      case @tipo
      
      when Tipo_casilla::DESCANSO
        @nombre = args.at(0)
      when Tipo_casilla::CALLE
        @tituloPropiedad = args[0]
        @nombre = @tituloPropiedad.nombre
      when Tipo_casilla::IMPUESTO
        @nombre = args[0]
        @importe = args[1]
      when Tipo_casilla::JUEZ
        @nombre = args[0]
        @@Carcel = args[1]
      when Tipo_casilla::SORPRESA
        @nombre = args[1]
        @mazo = args[0]
      end
      
      
    end
    
    def self .new_casilla_descanso (nombre)
      c = new(Tipo_casilla::DESCANSO,nombre)
      c
    end
    
    def self .new_casilla_calle (titulo)
      c = new(Tipo_casilla::CALLE,titulo)
      c
    end
    
    def self .new_casilla_impuesto(nombre,importe)
      c = new(Tipo_casilla::IMPUESTO,nombre,importe)
      c
    end
    
    def self .new_casilla_juez (nombre,numCasillaCarcel)
      c = new(Tipo_casilla::JUEZ,nombre,numCasillaCarcel)
      c
    end
    
    def self .new_casilla_sorpresa(mazo,nombre)
      c = new(Tipo_casilla::SORPRESA,mazo,nombre)
      c
    end
    
    def init
      #Atributos de referencia
      @tipo = nil
      @tituloPropiedad = nil
      @sorpresa = nil
      @mazo = nil
      
      #Atributos de instancia
      @nombre = ""
      @importe =0
      
      #Atributos de clase
      @@Carcel = -1
    end
  
    #---------------------------------------------------------------
    private_class_method :new
    
    #---------------------------------------------------------------
    attr_reader :nombre,:tituloPropiedad

    #---------------------------------------------------------------
    
    def informe (actual,todos)
      
      evento = "El jugador #{todos.at(actual).nombre} ha caido en la casilla #{@nombre}"
      
      #Informo a diario
      Diario.instance.ocurre_evento(evento)
      
      evento
    end
    
    def jugador_correcto(actual, todos)
      num_jugadores = todos.size
      return (num_jugadores > actual && actual>=0)
    end

    def recibe_jugador_impuesto (actual,todos)
      if(jugador_correcto(actual,todos))
        informe(actual,todos)
        
        #Jugador paga el impuesto
        todos.at(actual).paga_impuesto(@importe)
      end
    end
    
    def recibe_jugador_juez (actual,todos)
      if(jugador_correcto(actual,todos))
        informe(actual,todos)
        
        #encarcela al jugador
        todos.at(actual).encarcelar(@@Carcel)
      end
    end
    
    def to_string
      
      representacion = "Casilla:
         - Nombre = #{@nombre}"
      
      if (@tituloPropiedad != nil)
        representacion += "\n\t - Titulo de propiedad = #{@tituloPropiedad.to_string}"
      end
      
      if (@sorpresa != nil)
        representacion += "\n\t- Sorpresa = #{@sorpresa.to_string}"
      end
      
      return representacion
    end
    
    
    
    #---------------------------------------------------------------
    private :init, :informe, :recibe_jugador_impuesto, :recibe_jugador_juez
    #---------------------------------------------------------------
    
    
  end
end