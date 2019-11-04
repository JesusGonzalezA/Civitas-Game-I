module Civitas
  module Gestiones_inmobiliarias
    
    VENDER              =:vender
    HIPOTECAR           =:hipotecar
    CANCELAR_HIPOTECA   =:cancelar_hipoteca
    CONSTRUIR_CASA      =:construir_casa
    CONSTRUIR_HOTEL     =:construir_hotel
    TERMINAR            =:terminar
  end  
end

## Uso de la lista como una variable global

#   $lista_gestiones_inmobiliarias = [
#                                     Civitas::Gestiones_inmobiliarias::VENDER,
#                                     Civitas::Gestiones_inmobiliarias::HIPOTECAR,
#                                     Civitas::Gestiones_inmobiliarias::CANCELAR_HIPOTECA,
#                                     Civitas::Gestiones_inmobiliarias::CONSTRUIR_CASA,
#                                     Civitas::Gestiones_inmobiliarias::CONSTRUIR_HOTEL,
#                                     Civitas::Gestiones_inmobiliarias::TERMINAR
#                                    ]