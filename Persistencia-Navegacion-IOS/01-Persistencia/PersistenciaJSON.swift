//
//  PersistenciaJSON.swift
//  Persistencia-Navegacion-IOS
//
//  Created by Equipo 9 on 5/2/26.
//

import SwiftUI

struct Mascota: Identifiable, Codable {
    // Codable .- uso para los JSON

    var id: UUID = UUID()
    var nombre: String
    var edad: Int
    var tipo: String  // perro, gato etc...

}

struct PersistenciaJSON: View {
    
    @State private var nombreInput = ""
    @State private var edadInput = 1
    
    @State private var mascotaGuardada: Mascota? = nil
    
    // la cavle para Storage en la, persistencia de datos
    let claveStorage: String = "mi_mascota"
    
    var body: some View {
        VStack(spacing: 20) {
            // para crear grupos de datos
            GroupBox("Crear mascota") {
                TextField("Nombre mascota", text: $nombreInput)
                Stepper("Edad \(edadInput)", value: $edadInput)
                
                Button("Guardar dfatos") {
                    guardadMascota()
                }.buttonStyle(.borderedProminent)
                    .disabled(nombreInput.isEmpty)
            }
            .padding(20)
            
            Divider()
            
            if let mascota = mascotaGuardada {
                VStack(spacing: 20) {
                    Text("Nombre: \(mascota.nombre)").font(.largeTitle)
                    Text("Edad: \(mascota.edad)").bold()
                    Text("Tipp: \(mascota.tipo)")
                }
                .padding(20)
                .background(.green.opacity(0.1))
                .cornerRadius(20)
                
            } else {
                Text("no hay mascota guardada")
                    .foregroundStyle(.secondary)
            }
            
            Button("Borrar Datos") {
                borrarDatos()
            }.tint(.red)
                .buttonStyle(.borderedProminent)
                .disabled((mascotaGuardada != nil) ? false : true)
        }
        
        .onAppear {
            cargarMascota()
        }
    }
    
    func guardadMascota() {
        // como guardamos un JSON en la memoria física del dispositivo
        // para la persistencia de los datos
        let nuevaMascota = Mascota(
            nombre: nombreInput,
            edad: edadInput,
            tipo: ["perro", "gato", "pajaro"].randomElement()!
        )
        
        do {
            // Codificación al formato JSON
            let encoder = JSONEncoder()
            let data = try encoder.encode(nuevaMascota)
            
            // lo preapramos para la persistencia
            UserDefaults.standard.set(data, forKey: claveStorage)
            
            //
            print("datos guardados \(data)")
            
            //
            self.mascotaGuardada = nuevaMascota
            
        } catch {
            // retorno del error
            print("Error al codificar: \(error)   ")
            
        }
        
    }
    
    func cargarMascota() {
        guard let data = UserDefaults.standard.data(forKey: claveStorage) else {
            return
        }
        
        do {
            
            let decoder = JSONDecoder()
            let mascota = try decoder.decode(Mascota.self, from: data)
            
            self.mascotaGuardada = mascota
            
            
        } catch {
            // retorno del error
            print("Error al decodificar: \(error)   ")
        }
    }
    
    func borrarDatos() {
        
        UserDefaults.standard.removeObject(forKey: claveStorage)
        mascotaGuardada = nil
        nombreInput = ""
        edadInput = 0
    }
}

#Preview {
    PersistenciaJSON()
}
