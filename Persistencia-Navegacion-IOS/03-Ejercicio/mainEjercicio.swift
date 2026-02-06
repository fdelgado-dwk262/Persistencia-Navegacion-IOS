
/*
 
 Ejercicio que realixza una navegación entre vistas para el que se usa:
 
 * Enum .- con el destino de las vista con o sin parámetro
 * Obervable con una clase de "enrutado" con NavigationPath() y funciones necasarias
    - navegar a / ir al principio / ir un paso atras / enrutado con un rando para prpobar una bifurción
 * VI
 Vistas usadas
    - VistaEjercicio con el código
    - VistaCarrito
    - VistaPago
    - VistaConfirmacion
    - VistaError
 
 A teber en cuenta el bindeable / bindig / Environment
 
 En el render tener encuneta, el enviroment
 
 Simula la entrada a una vista navegación a una secundaria de aqui a un nivel mas profund
 y en base a un bool ramdon nos manda a una u otra vista ( de ok o de error ) pudiendo retornar al inicio
 
 
 */

import SwiftUI
import Observation

@main
struct MainEjercicio: App {
    var body: some Scene {
        WindowGroup {
          VistaEjercicio()
        }
    }
}
