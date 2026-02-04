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
    @AppStorage("musica aCtiva") private var musicaActiva: Bool = false
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
            }
        }
    }
}

#Preview {
    ContentView()
}
