//
//  ContentView.swift
//  Persistencia-Navegacion-IOS
//
//  Created by Equipo 9 on 4/2/26.
//

import SwiftUI

struct ContentView: View {
    
    // definimos una persistencia
    // si exiten los datos los ignora a no ser,
    // que se genere una función para tal efecto
    @AppStorage("usuario") private var nombreUsuario = "Invitado"
    @AppStorage("musica activa") private var musicaActiva: Bool = false
    // Guardamos el nombre del color como String para que AppStorage lo acepte
        @AppStorage("color app") private var colorSeleccionado: String = "White"
        
        // Mapeo simple de String a Color
        var colorApp: Color {
            switch colorSeleccionado {
            case "Red": return .red
            case "Blue": return .blue
            case "Green": return .green
            default: return .white
            }
        }
    // se puede implementar un array
    // pero lo idela es simplicar para pdoer acceder de forma fmás fácil
    
    // para otro tipo de persistencias se usa otra cosa más adelante
    // con otras estructuras persistentes en el dispositivo
    // swift data core
    // ORM etc...
    
    // https://developer.apple.com/documentation/swiftdata
    
    // datos de app online / cache de ddatos temporales ...
    // https://developer.apple.com/documentation/coredata
    
    var body: some View {
        Form {
            Section("Datos de usuario - persistentes en el dispositivo -") {
                TextField("Tu nopmbre", text: $nombreUsuario)
                Toggle("Musica activada", isOn: $musicaActiva)
                // Usamos un Picker sencillo o puedes mantener el ColorPicker
                                // si conviertes el color a RawData (pero es más complejo).
                                Picker("Color del fondo", selection: $colorSeleccionado) {
                                    Text("Blanco").tag("White")
                                    Text("Rojo").tag("Red")
                                    Text("Azul").tag("Blue")
                                    Text("Verde").tag("Green")
                                }
            }
            
        }
        .scrollContentBackground(.hidden)
        .background(colorApp)
    }
}

#Preview {
    ContentView()
}
