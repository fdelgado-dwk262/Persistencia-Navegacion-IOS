//
//  VistaPrincipal.swift
//  Persistencia-Navegacion-IOS
//
//  Created by Equipo 9 on 5/2/26.
//

import SwiftUI

// enum para ser mas vertail en la llamada a otras vistas
enum Destino: Hashable {
    case detalle(String)
    case numero(Int)
    case ajustes
}

// Enrutador observable
@Observable
class Router {

    // nos crea un ruta vacia
    var path = NavigationPath()

    // la idea del path es en que punto esta la app , en que sitio esta ubicada
    // pasamos de String a Destino el Enum
    func navigate(to destino: Destino) {
        path.append(destino)
    }

    // para volver atras
    func popRoute() {
        path.removeLast()
    }

    // volver a la raiz es decir a la vista principal
    func popToRoot() {
        path = NavigationPath()
    }

}

struct VistaPrincipal: View {

    @Environment(Router.self) private var router

    var body: some View {
        @Bindable var bindingRouter = router

        NavigationStack(path: $bindingRouter.path) {

            VStack(spacing: 20) {
                Button("Ir a vista detalle 1") {
                    router.navigate(to: .detalle("Detalle_1"))
                }
                //                Button("Ir a vista detalle 2") {
                //                    router.navigate(to: "detalle_2")
                //                }
                
                Button("ir a vista numero - aleatorio -") {
                    let numero = Int.random(in: 1...100)
                    router.navigate(to: .numero(numero))
                }
                Button("Ir a Ajustes") {
                    router.navigate(to: .ajustes)
                }
                .buttonStyle(.borderedProminent)
            }
            //un único navigationsDestination que controla todos los destinos
            // for antes tenia string.selft
            .navigationDestination(for: Destino.self) { destino in
                // VistaDetalle(id: destino) es modificado por :
                switch destino {
                case .detalle(let id):
                    VistaDetalle(id: id)
                case .numero(let numero):
                     VistaNumero(numero: numero)
                    Text("")
                case .ajustes:
                    VistaAjustes()
                }
            }

        }
        .onAppear {
            print(" ------------------------------- ")
            print(router.path)
        }

    }
}

// vistas detalle para hacer las navegación y ver lo que nos retorna

struct VistaDetalle: View {

    @Environment(Router.self) var router

    let id: String

    var body: some View {
        VStack(spacing: 20) {
            Text("ID de la vista: \(id)")

            Button("Ve a la vista detalle \(router.path.count + 1)") {
                // router.navigate(to: "\(router.path.count + 1)")
                router.navigate(
                    to: .detalle("Detalle_\(router.path.count + 1)")
                )
            }

            Button("volver un nivel") {
                router.popRoute()
            }

            Button("volver al inicio") {
                router.popToRoot()
            }
            .onAppear {
                print((" ----------------------- "))
                print("soy la vista \(id) \n \(router.path)")
            }
        }
    }
}

struct VistaNumero: View {
    @Environment(Router.self) var router
    let numero : Int
    var body: some View {
        VStack {
            Text("Vista Numero \(numero)")
                .font(.largeTitle)
                .foregroundStyle(.blue.opacity(0.5))
            
            Button("volver") {
                router.popRoute()
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Vista nunmero \(numero)")

    }
}

struct VistaAjustes: View {
    @Environment(Router.self) var router
    
    var body: some View {
        VStack {
            
            Toggle("Notificaciones", isOn: .constant(true))
            
            Button("guardar y cerrar") {
                
                
                
                router.popRoute()
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle(Text("Vista de Ajustes"))
    }
}

#Preview {
    VistaPrincipal()
        .environment(Router())
}
