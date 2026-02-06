//
//  VistaEjercicio.swift
//  Persistencia-Navegacion-IOS
//
//  Created by Equipo 9 on 5/2/26.
//

import SwiftUI

enum DestinoCompra: Hashable {
    case carrito
    case pago(metodo: String)
    case confirmacion(id: Int, total: Double)  // Etiquetas añadidas
    case error(mensaje: String)  // Valor asociado añadido
}

@Observable
class RouterCompra {
    var path = NavigationPath()
    
    // ... tus otras funciones (navigate, pop, etc)
    
    func navigate(to destinoCompra: DestinoCompra) {
        path.append(destinoCompra)
    }
    
    func popRoute() {
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    func procesarPago() {
        let exito = Bool.random()
        if exito {
            navigate(to: DestinoCompra.confirmacion(id: 1, total: 0.3))
        } else {
            navigate(to: DestinoCompra.error(mensaje: "Error en el pago"))
        }
        
    }
}

struct VistaEjercicio: View {
    
    @Environment(RouterCompra.self) private var router
    
    var body: some View {
        
        @Bindable var bindingRouter = router

        NavigationStack(path: $bindingRouter.path) {
            
            VStack (spacing: 20) {
                Button("Ir al carrito ") {
                    router.navigate(to: .carrito)
                }
                
            }
            .navigationDestination(for: DestinoCompra.self) { destinoCompra in
                switch destinoCompra {
                    case .carrito:
                        VistaCarrito()
                    case .pago(let metodo):
                        VistaPago(metodoSeleccionado: metodo)
                    case .confirmacion(let id, let total):
                        VistaConfirmacion(id: id, total: total)
                    case .error(let msg):
                        VistaError(mensaje: msg)
                }
            }
        }
        
    }
}


struct VistaCarrito: View {
    @Environment(RouterCompra.self) private var router

    var body: some View {
        VStack {
            Text("Tu Carrito")
            Button("Ir a pagar") {
                // PISTA: Usa el router para ir a .pago
                router.navigate(to: .pago(metodo: "tarjeta"))
            }
            
            
        }
    }
}

struct VistaPago: View {
    @Environment(RouterCompra.self) private var router
    let metodoSeleccionado: String

    var body: some View {
        VStack {
            Text("Pagando con \(metodoSeleccionado)")
            Button("Finalizar Compra") {
                // PISTA: Llama a la función del router que decide si hay éxito o error
                router.procesarPago()
            }
        }
    }
}

struct VistaConfirmacion: View {
    @Environment(RouterCompra.self) private var router
    var id: Int
    var total: Double
    var body: some View {
        Text("Estamos en la confirmación del pago")
        Button("Reintentar") {
            router.popToRoot()
        }
    }
}

struct VistaError: View {
    @Environment(RouterCompra.self) private var router
    var mensaje: String
    var body: some View {
        Text("Error")
            .foregroundColor(.red)
        Button("Reintentar") {
            router.popToRoot()
        }
    }
}

#Preview {
    VistaEjercicio()
        .environment(RouterCompra())
}
