require 'singleton'
module Civitas

  class Dado
    
    #----------------------------------------------------------------
    #Atributos de clase
    @@SALIDA_CARCEL = 5
    
    #----------------------------------------------------------------
    #Inicializador
    def initialize
      @random = Random.new
      @ultimoResultado = 0
      @debug = false
    end
    
    ##########################################
    #Hago patron singleton
    @instance = new
    
    private_class_method :new
    
    def self .instance
      @instance
    end
    
    ##########################################
    
    #----------------------------------------------------------------
    #Métodos de instancia
    def tirar
      @ultimoResultado = 1
      
      if (@debug == false)
        @ultimoResultado = @random.rand(1..6)
      end
      
      return @ultimoResultado
    end
    

   
    def salgo_de_la_carcel
      
      return (tirar()>= @@SALIDA_CARCEL)
      
    end
    
    def quien_empieza (n)
      return @random.rand(n)
    end
    
    def set_debug (d)
      @debug = d
      Diario.instance.ocurre_evento("Se modifica modo debug de dado a #{d}")
    end
    
    def get_ultimo_resultado 
      @ultimoResultado
    end
    #----------------------------------------------------------------
    
  end
  
end