//
//  PersistenciaJSONAvanzado.swift
//  Persistencia-Navegacion-IOS
//
//  Created by Equipo 9 on 5/2/26.
//

import SwiftUI

struct Persona: Codable {
    let nombre: String
    let edad: Int
    let email: String
}


// otro ejemplo con una estructura más compleja
struct libro: Codable {
    let titulo: String
    // nos retornara nill en el caso que no este ionfromado el campo del JSON
    // es opcional al poner ? en el tipo del dato
    let publicacion: Int?
}

struct Autor: Codable {
    let nombre: String
    let nacionalidad: String
    let libros: [libro]
}

let jsonAutor = """
{
    "nombre": "Stephen King",
    "nacionalidad": "USA",
    "libros": [
        {
            "titulo": "Misery",
            "publicacion": 1982
        },
        {
            "titulo": "It" 
        }
    ]
}
"""

// creamos una constate para las pruebas en formato de Json """ para la multilinea """
// Ojo los Json cada linea debe de tener la coma y la ultima linea sin coma
let jsonString = """
    {
        "nombre" : "Pepe",
        "edad": 23,
        "email": "demo@dominio.com"
    }
    """

let jsonArray = """
    [
        {
            "nombre" : "Fernando",
            "edad": 23,
            "email": "demo@dominio.com"
        },
        {
            "nombre" : "Maria",
            "edad": 32,
            "email": "info@dominio2.com"
        }
    ]
    """

struct PersistenciaJSONAvanzado: View {
    var body: some View {
        Text("hola")
            // al cargar la vista justo antes que la vista aparezca
            .onAppear {
                pruebasJSON()
            }
    }

    func pruebasJSON() {

        // doficamos el string en una JSON
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let persona = try JSONDecoder().decode(
                    Persona.self,
                    from: jsonData
                )
                print(persona)
            } catch {
                print("error decoding \(error)")
            }
        }

        // pruebas del Array con nodos y noveles de profuncidad

        if let jsonArray = jsonArray.data(using: .utf8) {

            do {

                let personas: [Persona] = try JSONDecoder().decode([Persona].self, from: jsonArray)
                print(personas)
                
            } catch {
                print("Error decoding Array \(error)")

            }
        }
        
        // probamos con los libros
        
        if let jsonAutorData = jsonAutor.data(using: .utf8) {
            do {
                let autor: Autor = try JSONDecoder().decode(Autor.self, from: jsonAutorData)
                print(" ---------------------------------- ")
                print(autor)
            } catch {
                print(" ---------------------------------- ")
                print("Error decoding Autor \(error)")
            }
        }

    }
}

#Preview {
    PersistenciaJSONAvanzado()
}
