//
//  ejercicioOnBoarding.swift
//  Persistencia-Navegacion-IOS
//
//  Created by Equipo 9 on 6/2/26.
//

import Observation
import SwiftUI

struct Usuario: Codable, Equatable {
    let nombreUsusario: String
    let password: String  // no usar en una app real
}

struct Item: Identifiable, Codable {
    var id = UUID()
    let titulo: String
    var fechaAnadido = Date()
}

// gestionara el estado de toda la app
// MARK: Obs.- AppManager
// -----------------------------------------
@Observable
class AppManager {

    // la app estará en 3 estados posibles. solo dentro de la clase
    // en funcion del estado muestra o no una u otra vista
    enum EstadoApp {
        case onBoarding
        case auth  // alta o login
        case principal  // pantalla principal
    }

    // estado de la app 4 variables :

    var items: [Item] = []
    var usuarioActual: Usuario?
    var haVistoOnboarding: Bool = false

    // propiedad computada que lleva una pequeña funcionallidad
    // var identifica del tipo enum definido anteriromente
    var pabtallaActual: EstadoApp {
        if !haVistoOnboarding { return .onBoarding }
        if usuarioActual == nil { return .auth }
        return .principal
    }

    // definimos constates de clave par auserDefault
    private let claveOnboarding = "ha_Visto_Onboarding"
    private let claveUsuario = "usuario_actual"
    private let claveItems = "items_guardados"

    // al iniciar cargamos los datos de la persistencia
    init() {
        cargarDatos()
    }

    private func cargarDatos() {
        haVistoOnboarding = UserDefaults.standard.bool(forKey: claveOnboarding)

        // cargamos usuario si esta un doble let
        if let data = UserDefaults.standard.data(forKey: claveUsuario),
            let usuario = try? JSONDecoder().decode(Usuario.self, from: data)
        {
            self.usuarioActual = usuario
        }

        // cargar los tiems
        if let data = UserDefaults.standard.data(forKey: claveItems),
            let itemGuardados = try? JSONDecoder().decode(
                [Item].self,
                from: data
            )
        {
            items = itemGuardados
        }
    }

    // metodo de finalizacion del onboarding
    func terminarOnboarding() {
        haVistoOnboarding = true
        UserDefaults.standard.set(haVistoOnboarding, forKey: claveOnboarding)

    }

    //
    func registraOIniciaSesion(nombreUsuario: String, pass: String) {
        let nuevoUario = Usuario(nombreUsusario: nombreUsuario, password: pass)
        usuarioActual = nuevoUario

        // codificacion de los datos
        // si hay usuario lo sobreescribe esto no es real ni se esta haciendo comprobaciones
        if let data = try? JSONEncoder().encode(nuevoUario) {
            UserDefaults.standard.set(data, forKey: claveUsuario)
        }   

    }

    //Para cerrar sesión
    // en un entorno de producción borramos el token
    // y eliminamos el token del dispositivo
    func cerrarSesion() {
        usuarioActual = nil
        UserDefaults.standard.removeObject(forKey: claveUsuario)
    }
    
    // birrar la cuenta
    func borrarCuenta() {
        borrarItem()
        UserDefaults.standard.removeObject(forKey: claveItems)
        cerrarSesion()
    }

    // para añadir item
    func anadirItem(titulo: String) {
        let nuevoItem = Item(titulo: titulo)
        items.append(nuevoItem)

        // llamaos a la funcioonn para la presistencia
        persistirItems()
    }

    // para borrar totos los items
    func borrarItem() {
        items.removeAll()
        persistirItems()
    }

    private func persistirItems() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: claveItems)
        }
    }
    // fin añadir/borrar item y su persistencia

}

// esto es lo que sirve en produccion e instalacion
// MARK: Main
// -----------------------------------------
@main
struct AppOnBoarding: App {
    @State private var manager = AppManager()
    var body: some Scene {
        WindowGroup {
            SelectorDeVista()
                .environment(manager)
        }
    }
}

// MARK: SelectorDeVista
// -----------------------------------------
struct SelectorDeVista: View {
    @Environment(AppManager.self) var manager

    var body: some View {
        // como comdin para poder agrupar y poder usar cosas que de otra
        // no nos dejarara usar
        Group {
            switch manager.pabtallaActual {
            case .onBoarding:
                VistaOnboarding()
            case .auth:
                VistaAuth()
            case .principal:
                VistaPrincipal()
            }
        }
        .animation(.easeInOut, value: manager.pabtallaActual)
    }
}

// MARK: VistaPrincipal
// -----------------------------------------
private struct VistaPrincipal: View {

    @Environment(AppManager.self) var manager
    @State private var nuevoItemText = ""

    var body: some View {
        NavigationStack {

            List {
                Section("Añadir") {
                    HStack {

                        TextField("Nuevo Articulo", text: $nuevoItemText)

                        Button {
                            // si el texto esta vacios o no
                            guard !nuevoItemText.isEmpty else { return }
                            manager.anadirItem(titulo: nuevoItemText)
                            nuevoItemText = ""
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }
                Section("Mis articulos") {
                    if manager.items.isEmpty {
                        Text("No hay Items guardados")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(manager.items) { item in
                            HStack {
                                Text(item.titulo)
                                Spacer()
                                Text(item.fechaAnadido, style: .time)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
            }

            .navigationTitle("Hola \(manager.usuarioActual?.nombreUsusario ?? "Anónimo")")
            // desde aqui llamaremos a ajustes
            .toolbar {
                // solo uno de configuracion para hacer varias cosas
                // ver tutorial
                // borrar articuloes
                // cerrar sesion
                // borrar su cuenta
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: VistaSeting()) {
                        Image(systemName: "gearshape")
                    }
                }
            }

        }
    }
}

// MARK: VistaOnboarding
// -----------------------------------------
private struct VistaOnboarding: View {

    @Environment(AppManager.self) var manager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        TabView {

            // Text("pagina 1")
            creaPagina(
                color: .red,
                titulo: "Bienvenido/a",
                descripcion: "es la página 1"
            )
            // Text("pagina 2")
            creaPagina(
                color: .green,
                titulo: "uso de la app",
                descripcion: "es la página 2"
            )
            //Text("pagina 3")
            creaPagina(
                color: .blue,
                titulo: "gracias",
                descripcion: "página final del ponBoarding",
                esUltima: true
            )
        }
        .tabViewStyle(.page)
        // nos saca los puntos estilo carrusel
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        // ignoramos las areas se Safe
        .ignoresSafeArea()

    }

    func creaPagina(
        color: Color,
        titulo: String,
        descripcion: String,
        esUltima: Bool = false
    ) -> some View {
        ZStack {
            color
            VStack(spacing: 20) {
                Text(titulo)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)

                Text(descripcion)
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.8))

                if esUltima {
                    Button("entendido") {
                        withAnimation {
                            manager.terminarOnboarding()
                            dismiss()
                        }
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                    .padding(.top, 50)
                }
            }
            .padding()
        }

    }
}

// MARK: VistaAuth
// -----------------------------------------
private struct VistaAuth: View {

    @Environment(AppManager.self) var manager

    @State private var nombreUsuario = ""
    @State private var password = ""
    @State private var mostrarError = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Iniciar sesión / registro ")
                .font(.title)
                .bold()

            TextField("Nombre de usuario", text: $nombreUsuario)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .border(Color.gray)
                .textInputAutocapitalization(.never)

            SecureField("Contraseña", text: $password)
                .textFieldStyle(.roundedBorder)
                .border(Color.gray)

            if mostrarError {
                Text("Rellena los dos campos")
                    .foregroundStyle(.red)
            }

            Button("Iniciar Sesión") {

                if nombreUsuario.isEmpty || password.isEmpty {
                    mostrarError = true
                } else {
                    // llamamos a un metodo del manager para que proceda
                    mostrarError = false
                    manager.registraOIniciaSesion(
                        nombreUsuario: nombreUsuario,
                        pass: password
                    )
                }

            }
            .padding()
            .foregroundColor(.white)
            .background(
                nombreUsuario.isEmpty || password.isEmpty ? .gray : .blue
            )
            .cornerRadius(10)
            .padding(.top, 50)
            .disabled(nombreUsuario.isEmpty || password.isEmpty ? true : false)

        }
        .padding()
    }
}

// MARK: VistaSeting
// -----------------------------------------
struct VistaSeting: View {

    @Environment(AppManager.self) var manager

    @State private var mostrarOnboarding = false

    var body: some View {
        Form {
            Section("General") {
                Button("Ver onbording de nuevo") {
                    mostrarOnboarding = true
                }
            }
            Section("Gestión") {
                Button("borrar todos los artículos", role: .destructive) {
                    manager.borrarItem()
                }
                .disabled(manager.items.isEmpty)

                Button("Cerrar sesión") {
                    manager.cerrarSesion()
                }

                Button("Eliminar cuenta") {
                    manager.borrarCuenta()
                }

                
            }
        }
        .navigationTitle(Text("Configuración"))
        .sheet(isPresented: $mostrarOnboarding) {
            ZStack(alignment: .topTrailing) {
                VistaOnboarding()
                Button {
                    mostrarOnboarding = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding()
                }
            }
        }
    }
}

// -----------------------------------------
// MARK: Previews
// -----------------------------------------
// truco de pruebas para saltar pasos
// solo a nivel de pruebas de xcode no debe de ir al dispositivo
// jamas en producción es solo para el canvas
#Preview("1. Onboarding") {
    let manager = AppManager()
    manager.haVistoOnboarding = false
    manager.usuarioActual = nil

    return SelectorDeVista()
        .environment(manager)
}

// creamos otra preview
#Preview("2. Login") {
    let manager = AppManager()
    manager.haVistoOnboarding = true
    manager.usuarioActual = nil

    return SelectorDeVista()
        .environment(manager)
}

// ya entrando en la app

#Preview("3. En la app PAGINA PRINCIPAL") {
    let manager = AppManager()
    manager.haVistoOnboarding = true
    manager.usuarioActual = Usuario(
        nombreUsusario: "peptide",
        password: "sdfsdfsdf"
    )
    // Podemos provar en el canvas con datos
    //    manager.items = [
    //        Item(titulo: "producto 01"),
    //        Item(titulo: "producto 02"),
    //
    //    ]

    return VistaPrincipal()
        .environment(manager)
}

#Preview("4. Configuración") {
    let manager = AppManager()
    manager.usuarioActual = Usuario(
        nombreUsusario: "usuarioCong",
        password: "sdsd"
    )

    return NavigationStack {
        VistaSeting()
            .environment(manager)
    }

}
