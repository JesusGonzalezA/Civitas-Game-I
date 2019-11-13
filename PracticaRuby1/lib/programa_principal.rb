#encoding:utf-8

require_relative 'civitas_juego'
require_relative 'vista_textual'
require_relative 'controlador'
require_relative 'dado'

module Civitas
class ProgramaPrincipal
  def self .main
    
    #Creo jugadores
    nombres_jugadores = []
    nombres_jugadores << "Jesus"
    nombres_jugadores << "Nuria"
    
    #Creo juego en modo debug
    juego = CivitasJuego.new(nombres_jugadores)
    Dado.instance.set_debug(true)
    
    #Jugar
    interfaz = Vista_textual.new
    controlador = Controlador.new(juego, interfaz)
    controlador.juega
  end
end

ProgramaPrincipal.main

end