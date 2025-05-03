# PokeAppPrueba

**PokeAppPrueba** es una aplicación móvil sencilla que consume datos de la **PokeAPI** para mostrar información sobre Pokémon. Esta app fue desarrollado usando **Swift** y **SwiftUI**.

## Caracteristicas

- **Busqueda de Pokémon (Filtrado): Se puede realizar busquedas por nombres, numero de ID y tipos de pokemon.
- **Diseño: Utiliza la interfaz limpia con **SwiftUI** para facilitar la experiencia de usuario.
- **Consumo de API: La aplicación interactua con la pokeApi (https://pokeapi.co/) para obtener un listado de pokémon.
- **Utilización de Background Fetch: La aplicación actualiza la lista de pokemons al estar en segundo plano 
- **Almacenamiento de Pokemon: Se utiliza CoreData para almacenar el listado de pokémons.
- **Envio de notificaciones: Se envia notificacion al usuario cuando se actualiza la lista en segundo plano.

## Requisitos

- **iOS 16.0** o superior
- **Xcode 15** o superior
- **Swift 5.7** o superior  

## Instalación

**Clona el repositorio**
 ```bash
git clone https://github.com/NahumMartinez01/PokeAppPrueba.git
 ```
- En caso de usar un dispositivo físico para realizar las pruebas(Recomendado para probar background Fetch)
- Es posible que salte el siguiente error:
 ```bash
    The request to open "NahumMartinez.PokeDexApp" failed.
    
    Verify that the Developer App certificate for your account is trusted on your device.
    Open Settings on the device and navigate to General -> VPN & Device Management, 
    then select your Developer App certificate to trust it.
 ```
 - Solo se deben seguir los pasos para dar acceso y instalar la aplicación:
  ```bash
    1. Abre Configuración en el dispositivo.
    2. Ir a opción General.
    3. Ir a opción VPN y gestión de dispositivos.
    luego selecciona tu certificado de Aplicación de Desarrollador para confiar en él.
 ```
 
## Notas Importantes 
Para probar correctamente las tareas en segundo plano (**Background Fetch**), se recomienda realizar las pruebas en un dispositivo físico. El simulador de Xcode tiene limitaciones que pueden afectar la ejecución de tareas en segundo plano, como la simulación del ciclo de vida de la aplicación y la gestión de recursos, lo que podría generar comportamientos inesperados.

Debido a que el sistema operativo iOS se encarga de gestionar las tareas en segundo plano, puede demorarse mucho en ejecutarse la peticion esto hasta que el SO lo vea conveniente.

Para realizar las pruebas se dejan los siguientes pasos para simular una acción en segundo plano:

- **Ejecutar la aplicación
- **Ir al menu debug
- **Seleccionar pause
- **Se activara la consola de Xcode
- **Pegamos el siguiente codigo  y damos enter
    ```
    e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.example.PokeApiApp.refreshData"]
    ```
- **Una vez ejecutada la operación le damos reanudar a la app y se simulara el background fetch


