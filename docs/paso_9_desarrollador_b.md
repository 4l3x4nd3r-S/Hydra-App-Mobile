# INSTRUCCIONES - DESARROLLADOR B: COLA DE SINCRONIZACIÓN Y HISTORIAL DE REPORTES EN UI (paso_9)

Esta especificación técnica detalla cómo implementar una nueva vista o pestaña en la bandeja de entrada para mostrar al técnico el historial de órdenes resueltas y el listado de reportes encolados en SQLite pendientes de sincronizar con el servidor.

---

## 🎯 Objetivo de Tarea
Añadir transparencia operativa a la aplicación **HYDRA** mediante el desarrollo de una pestaña o menú deslizable de **"Mis Reparaciones"** en `InboxScreen`. Esta sección debe permitir al técnico visualizar:
1. Las órdenes que ya completó físicamente pero siguen guardadas localmente en SQLite esperando cobertura de red celular (etiquetadas como *"Pendiente de Sincronización ⏳"*).
2. Las órdenes ya transmitidas con éxito al servidor (historial completado).
3. Habilitar un botón manual de **"Forzar Sincronización"** para forzar el vaciado de la cola de SQLite de forma manual cuando el técnico lo requiera.

---

## 📂 Archivos a Crear / Modificar
*   `lib/features/ot_inbox/presentation/inbox_screen.dart` (Modificar para añadir pestaña de Historial/Cola local y control de sincronización)

---

## 📋 Directrices de Programación y Flujo de Trabajo

### 1. Consultar la Cola Local en SQLite
*   En `InboxScreen`, añade un método asíncrono `_cargarColaLocal()` para leer directamente de SQLite todas las órdenes que residen en `offline_sync_queue` usando `DatabaseHelper.database`:
    ```dart
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> res = await db.query('offline_sync_queue');
    ```
*   Mapea los registros y muéstralos en una lista interactiva de tarjetas con colores Slate-Dark.

### 2. Estructura de Pestañas (TabBar en InboxScreen)
*   Modifica el diseño del `Scaffold` en `inbox_screen.dart` para soportar un `DefaultTabController` con dos pestañas de navegación superiores elegantes:
    *   **Pestaña 1: "Órdenes Activas"** (Lista/Mapa de OTs pendientes en el sector actual - Código desarrollado en Paso 5).
    *   **Pestaña 2: "Mis Cierres"** (Historial de trabajos completados y cola local de sincronización).

### 3. Botón de Sincronización Manual
*   En la barra superior (AppBar) o en la cabecera de la pestaña "Mis Cierres", implementa un botón circular destacado con el icono `Icons.sync` y texto *"Forzar Envío"*.
*   Al presionarlo:
    *   Muestra un spinner de carga (`CircularProgressIndicator`) o un Banner dinámico.
    *   Invoca de manera explícita a: `widget.syncService.triggerSyncProcess()`.
    *   Una vez terminada la sincronización en segundo plano, vuelve a invocar `_cargarColaLocal()` para actualizar de forma inmediata la lista de la pantalla (los elementos que pasaron a código 200 OK del servidor desaparecerán de la cola SQLite).

### 4. Tarjetas Premium de Historial
*   Diseña tarjetas con esquinas redondeadas (`BorderRadius.circular(16)`) y fondos Slate-800 (`#1E293B`) con los siguientes elementos:
    *   *ID de OT*: "OT #104 - Cierre Técnico".
    *   *Detalle*: "Hallazgo: ROTURA - PVC 4\"".
    *   *Estado*:
        *   Si el registro proviene de `offline_sync_queue` (pendiente de red): Chip de advertencia amarillo con texto *"Esperando Cobertura de Red ⏳"*.
        *   Si ya fue sincronizada: Chip verde con texto *"Transmitida al Catastro Web de EMAPAT S.A. ✔"*.

---

## 🎨 Código Base de Apoyo para Consultar la Cola Local

Integra este método y estructura de carga dinámica dentro del State en `inbox_screen.dart`:

```dart
  List<Map<String, dynamic>> _colaLocal = [];
  bool _sincronizandoManual = false;

  @override
  void initState() {
    super.initState();
    _ots = List.from(_baseMockOts);
    _initGeolocation();
    _cargarColaLocal(); // Cargar cola en el arranque
  }

  Future<void> _cargarColaLocal() async {
    try {
      final db = await DatabaseHelper.database;
      final List<Map<String, dynamic>> result = await db.query('offline_sync_queue');
      setState(() {
        _colaLocal = result;
      });
    } catch (e) {
      print("Error al cargar cola local SQLite: $e");
    }
  }

  Future<void> _sincronizarManualmente() async {
    setState(() => _sincronizandoManual = true);
    
    // Lanzar proceso del motor offline-first
    await widget.syncService.triggerSyncProcess();
    
    // Recargar datos locales
    await _cargarColaLocal();
    
    setState(() => _sincronizandoManual = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Proceso de sincronización finalizado.'),
          backgroundColor: Color(0xFF34D399),
        ),
      );
    }
  }
```

*Actualiza la interfaz de `InboxScreen` para integrar el TabBar superior de forma que los técnicos puedan alternar fluidamente y ver su cola de sincronización en tiempo real.*
