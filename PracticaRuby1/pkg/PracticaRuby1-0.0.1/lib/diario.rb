require 'singleton'
module Civitas
  class Diario
    #include Singleton

    def initialize
      @eventos = []
    end

    ##########################################
    #Hago patron singleton
    @instance = Diario.new
    
    private_class_method :new
    
    def self .instance
      @instance
    end
    
    ##########################################
    def ocurre_evento(e)
      @eventos << e
    end

    def eventos_pendientes
      return (@eventos.length > 0)
    end

    def leer_evento
      e = @eventos.shift
      return e
    end

  end
end
