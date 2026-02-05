//
//  ContentView.swift
//  Persistencia-Navegacion-IOS
//
//  Created by Equipo 9 on 4/2/26.
//

import SwiftUI

// como buena practica usar este sistema para los forkey ciando lo tenemos
// que usar en varios sitios y asi evitamso errores
// forKey: ClaveStore.ultimoLogin
// al final queda como un pequeño diccionario de forkey's
enum ClaveStore {
    static let ultimoLogin = "último acceso"
}

// otras forma de control y unificacion del forkey
// para llmaarla sería  .ultimoLogin
// forKey: .ultimoLogin
extension String {
    static let ultimoLogin = "último acceso"
}

struct PersistirDatosSimples: View {

    // definimos una persistencia
    // si exiten los datos los ignora a no ser,
    // que se genere una función para tal efecto
    @AppStorage("usuario") private var nombreUsuario = "Invitado"
    @AppStorage("musica activa") private var musicaActiva: Bool = false

    @State private var ultimaFechaLogin: String = "nunca"

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
            Section("Datos de usuario \n -persistencia en dispositivo-") {
                TextField("Tu nopmbre", text: $nombreUsuario).foregroundStyle(.black)
                Toggle("Musica activada", isOn: $musicaActiva).foregroundStyle(.black)
                
                // Usamos un Picker sencillo o puedes mantener el ColorPicker
                // si conviertes el color a RawData (pero es más complejo).
                Picker("Color del fondo", selection: $colorSeleccionado) {
                    Text("Blanco").tag("White")
                    Text("Rojo").tag("Red")
                    Text("Azul").tag("Blue")
                    Text("Verde").tag("Green")
                }.foregroundStyle(.black)
            }
            .foregroundStyle(colorSeleccionado != "White" ? .white : .black)
            
            Section("Hora de acceso/registro") {
                Text("Último acceso: \(ultimaFechaLogin)").foregroundStyle(.black)

                Button("Guardado fecha de login") {
                    guardadoFechaLogin()
                }.foregroundStyle(.black)
                Button("Borrado fecha de login") {
                    borradoFechaLogin()
                }.foregroundStyle(.black)

            } .foregroundStyle(colorSeleccionado != "White" ? .white : .black)
            
            
            // Ejemplo de poder poner botones a la derecha del titulo
            Section {
                // Contenido de tu sección
                Text("demo")
            } header: {
                HStack {
                    Text("Datos de usuario")
                        .font(.headline)
                    
                    Spacer() // Empuja los botones a la derecha
                    
                    HStack(spacing: 15) {
                        Button(action: { print("Botón 1") }) {
                            Image(systemName: "gear")
                        }
                        .foregroundStyle(colorSeleccionado != "White" ? .white : .black)
                        
                        Button(action: { print("Botón 2") }) {
                            Image(systemName: "plus")
                        }.foregroundStyle(colorSeleccionado != "White" ? .white : .black)
                    }.foregroundStyle(.black)
                    .textCase(nil) // Evita que los botones se pongan en mayúsculas automáticamente
                }
            } .foregroundStyle(colorSeleccionado != "White" ? .white : .black)

        }
        .scrollContentBackground(.hidden)
        .background(colorApp)

        // recuperamos un dato antes que la vusta aparezca
        .onAppear {
            cargarFechaLogin()
        }
    }
    // definimos la función .-
    func guardadoFechaLogin() {
        let fechaFormateada = Date().formatted(
            date: .abbreviated,
            time: .standard
        )
        // guardamos de forma manual en Userdafault
        UserDefaults.standard.set(fechaFormateada, forKey: ClaveStore.ultimoLogin)

        ultimaFechaLogin = fechaFormateada
    }

    func cargarFechaLogin() {
        // cuando entramos por primera vez no esta definido el valor
        // usaremos :

        if let fechaLogin = UserDefaults.standard.string(
            forKey: ClaveStore.ultimoLogin
        ) {
            ultimaFechaLogin = fechaLogin
        }
    }
    
    func borradoFechaLogin(){
        UserDefaults.standard.removeObject(forKey: ClaveStore.ultimoLogin)
        ultimaFechaLogin = "No hay fecha guardada"
    }

}

#Preview {
    PersistirDatosSimples()
}
