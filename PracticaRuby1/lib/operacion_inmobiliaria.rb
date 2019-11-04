# encoding:utf-8

require_relative 'gestiones_inmobiliarias'

module Civitas
  class OperacionInmobiliaria
    
    def initialize(gest,ip)
      @numPropiedad = ip
      @gestion = gest
    end
    
    attr_reader :ip,:gest
  end
end
