# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'sorpresa'
require_relative 'diario'


module Civitas
  class MazoSorpresas
 
    def initialize (d)
      @debug = d
     
      if (@debug==true)
        Diario.instance.ocurre_evento("Se activa el modo debug del mazo")
      end
    end
 
    #--------------------------------------------------------
    #"Constructores"
 
    def self .new_mazo_sorpresas_debug (d)
      m = new (d)
      m.init
      m
    end
    
    def self .new_mazo_sorpresas_default()
      m= new (false)
      m.init 
      m
    end
    
    def init 
      @sorpresas = []
      @cartas_especiales = []
      @usadas = 0
      @barajada = false
      @ultima_sorpresa = ""
    end
    
    private_class_method :new
    
    #--------------------------------------------------------
    #Resto de metodos
    def al_mazo(s)
      if (@barajada == false)
        @sorpresas << s
      end
    end
    
    def siguiente
      if ((@barajada==false  ||  @usadas==(@sorpresas.size + @cartas_especiales.size)) && @debug==false)
        @usadas =0
        @barajada=true
        @sorpresas.shuffle!
      end
      
      @usadas +=1
      @ultima_sorpresa = @sorpresas.shift
      @sorpresas << @ultima_sorpresa
      
      return @ultima_sorpresa
    end
    
    def inhabilitar_carta_especial(sorpresa)
      i = @sorpresas.index(sorpresa)
      
      if ( i != nil)
          @sorpresas.delete_at(i)
          @cartas_especiales<<sorpresa
          Diario.instance.ocurre_evento("La sorpresa #{sorpresa.texto} queda inhabilitada")
      end
      
    end
    
    def habilitar_carta_especial(sorpresa)
      i = @cartas_especiales.index(sorpresa)
      if ( i != nil)
          @cartas_especiales.delete_at(i)
          @sorpresas<<sorpresa
          Diario.instance.ocurre_evento("La sorpresa #{sorpresa.texto} queda habilitada")
      end
     
    end
    
    #--------------------------------------------------------
  end
end
