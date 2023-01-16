# **Pokedex-iOS**

# Arquitectura MVVM+Router
El concepto enrutador(router) de aplicaciones se usó para manejar la lógica de navegación de los controladores de vista, las transiciones manejadas a través de un coordinador de la aplicación.
TransitionDelegate se uso para consolidar la lógica del módulo perteneciente a un flujo de trabajo particular, haciendo que el código sea modular y desacoplado, además de adherirse al principio SOLID de responsabilidad única, MVVM se usó para abstraer el código del modelo del controlador de vista en un objeto separado que a su vez facilita las pruebas(UITest y UniTest).

# Descripción
* Este proyecto es 100% swift.
* Uso de Combine para llamados al backend.
* Cache de imagen.
* URLSession para el manejo de api rest.
* Persistencia de datos con Realtime Database de Firebase.
* Clean Code.
* Soporte para modo landscape y portrait.
* Soporte para modo claro y oscuro.

# Intrucciones
1. Clone o descargue este repositorio.
2. Navegar a la ruta donde clono o descargo el repo
3. Abrir Pokedex-iOS.xcodeproj
4. Esperar a que descarguen los SPM
5. Ya esta listo el proyecto para ejecutarse.

**Usuarios de prueba facebook**
Debido a que en la consola de facebook el proeyecto aun se encuentra en desarrollo dejo usuarios de pruebas.
Para todos los correos la contraseña es: **Test-1234**

- eeezboqdqq_1673825782@tfbnw.net
- ivmgrrobgm_1673825782@tfbnw.net
- slhsdfxlnn_1673825782@tfbnw.net
- hybmzpqtmd_1673825782@tfbnw.net

**Nota:**
Para poder abrir el proyecto es nesesario una version de Xcode 14.0.1 o superior.

# Funcionalidades agregadas
* Lista de regiones
* Lista de pokedexes que pertenecen a una region
* Lista de pokemones que pertenecen a una region
* Crear y guardar equipos de 3 a 6 pokemones
* Guardar los equipos en la nube
* Menu lateral para navegar entre modulos.

# SPMs

* Firebase
* GoogleSignIn
* CodableFirebase
* FacebookLogin

# Tecnologias
* Xcode 14.0.1
* Swift 5
* iOS 16.0+
