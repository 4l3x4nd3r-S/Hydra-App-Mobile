# INSTRUCCIONES - DESARROLLADOR A: AUTENTICACIÓN JWT Y FLUJO DE LOGIN SEGURO (paso_4)

Esta especificación técnica detalla la implementación de la pantalla de Login (`login_screen.dart`), el almacenamiento persistente del token JWT de sesión y la configuración del interceptor automático de seguridad para todas las peticiones a la API del backend.

---

## 🎯 Objetivo de Tarea
Desarrollar la pantalla de inicio de sesión de **HYDRA** (`lib/features/auth/presentation/login_screen.dart`), crear un manejador de sesión persistente local (usando la base de datos SQLite ya inicializada para evitar dependencias extras) e inyectar el token JWT en el interceptor de `DioClient` de forma que todas las peticiones HTTPS salgan autenticadas.

---

## 📂 Archivos a Crear / Modificar
*   `lib/core/database/database_helper.dart` (Modificar para crear la tabla de variables de sesión)
*   `lib/core/utils/session_manager.dart` [NEW] (Manejador de tokens y sesión persistente)
*   `lib/core/network/dio_client.dart` (Modificar interceptor para inyectar token automáticamente)
*   `lib/features/auth/presentation/login_screen.dart` (Modificar UI y lógica de login)
*   `lib/app.dart` (Modificar redirección de arranque de la aplicación)

---

## 📋 Directrices de Programación y Flujo de Trabajo

### 1. Modificación de Base de Datos (`database_helper.dart`)
*   Para evitar instalar dependencias de almacenamiento adicionales de manera innecesaria, utilizaremos **SQLite** para persistir el token de sesión.
*   En `DatabaseHelper._createDB`, añade la tabla `session_store` para guardar el token de autenticación:
    ```sql
    CREATE TABLE session_store (
      key TEXT PRIMARY KEY,
      value TEXT NOT NULL
    )
    ```

### 2. Creación del Gestor de Sesión (`session_manager.dart`)
*   Crea el archivo `lib/core/utils/session_manager.dart` para encapsular las operaciones de lectura, escritura y eliminación del token JWT en SQLite:
    *   `saveToken(String token)`: Guarda el JWT en `session_store` bajo la clave `jwt_token`.
    *   `getToken()`: Lee y retorna el token.
    *   `clearSession()`: Elimina el token para hacer Logout.
    *   `hasSession()`: Devuelve verdadero si existe un token guardado.

### 3. Activación del Interceptor de Seguridad (`dio_client.dart`)
*   Descomenta e integra la lógica del interceptor `onRequest` en `DioClient`:
    *   Importa `SessionManager` y antes de enviar cada petición, recupera el token.
    *   Si el token existe, inyéctalo en las cabeceras como: `options.headers["Authorization"] = "Bearer $token";`.

### 4. Pantalla de Login Premium (`login_screen.dart`)
*   Implementa una interfaz UI sofisticada en color Slate-Dark con Outfit typography:
    *   Título de bienvenida "HYDRA" con logo/icono corporativo de gota de agua en cian (`#38BDF8`).
    *   Cajas de texto (`TextField`) personalizadas para usuario y contraseña con validaciones visuales.
    *   Botón de envío con animación de carga (`CircularProgressIndicator`) durante el login.
*   **Lógica de login**:
    *   Al presionar el botón, realiza una petición `POST` al endpoint `/auth/login` (usando `ApiEndpoints.login`) con el payload `{"username": username, "password": password}`.
    *   Si la petición tiene éxito (`statusCode == 200`), extrae el JWT de la respuesta (`response.data["access_token"]`), guárdalo con `SessionManager` y navega a `InboxScreen` reemplazando la ruta actual.
    *   Si falla, muestra un `SnackBar` rojo con el mensaje de error de credenciales.

### 5. Redirección Inteligente en el Arranque (`app.dart` / `main.dart`)
*   Modifica la inicialización de la app para que, al abrir la aplicación, se verifique automáticamente si el usuario ya cuenta con una sesión activa (`SessionManager.hasSession()`).
*   Si tiene sesión activa, ingresa directamente a `InboxScreen`. En caso contrario, muéstrale la pantalla de `LoginScreen`.

---

## 🎨 Código Base y Plantillas de Implementación

### 1. Gestor de Sesión (`lib/core/utils/session_manager.dart`)
```dart
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';

class SessionManager {
  static const String _tokenKey = 'jwt_token';

  static Future<void> saveToken(String token) async {
    final db = await DatabaseHelper.database;
    await db.insert(
      'session_store',
      {'key': _tokenKey, 'value': token},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<String?> getToken() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'session_store',
      where: 'key = ?',
      whereArgs: [_tokenKey],
    );
    if (maps.isEmpty) return null;
    return maps.first['value'] as String;
  }

  static Future<void> clearSession() async {
    final db = await DatabaseHelper.database;
    await db.delete(
      'session_store',
      where: 'key = ?',
      whereArgs: [_tokenKey],
    );
  }

  static Future<bool> hasSession() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
```

### 2. Actualización de Interceptor (`lib/core/network/dio_client.dart`)
```dart
import 'package:dio/dio.dart';
import 'api_endpoints.dart';
import '../utils/session_manager.dart';

class DioClient {
  final Dio _dio;

  DioClient() : _dio = Dio(BaseOptions(
    baseUrl: ApiEndpoints.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await SessionManager.getToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
      onError: (e, handler) {
        return handler.next(e);
      }
    ));
  }

  Dio get dio => _dio;
}
```

### 3. Pantalla de Login Completa (`lib/features/auth/presentation/login_screen.dart`)
```dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/database/sync_service.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/utils/session_manager.dart';
import '../../ot_inbox/presentation/inbox_screen.dart';

class LoginScreen extends StatefulWidget {
  final SyncService syncService;

  const LoginScreen({super.key, required this.syncService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final dio = DioClient().dio;
      final response = await dio.post(
        ApiEndpoints.login,
        data: {
          'username': _userController.text.trim(),
          'password': _passController.text,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final String token = response.data['access_token'];
        await SessionManager.saveToken(token);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => InboxScreen(syncService: widget.syncService),
            ),
          );
        }
      }
    } on DioException catch (e) {
      String errMsg = 'Error de conexión. Intente nuevamente.';
      if (e.response?.statusCode == 401) {
        errMsg = 'Usuario o contraseña incorrectos.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errMsg), backgroundColor: const Color(0xFFF87171)),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icono / Logo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.2)),
                  ),
                  child: const Icon(
                    Icons.water_drop_rounded,
                    color: Color(0xFF38BDF8),
                    size: 60,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'HYDRA',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const Text(
                  'Sistema de Control de Presión y Fugas',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 40),

                // Caja de Usuario
                TextFormField(
                  controller: _userController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Usuario / Código Técnico',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF38BDF8)),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  validator: (val) => (val == null || val.isEmpty) ? 'Ingrese su usuario' : null,
                ),
                const SizedBox(height: 16),

                // Caja de Contraseña
                TextFormField(
                  controller: _passController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF38BDF8)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: const Color(0xFF94A3B8),
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  validator: (val) => (val == null || val.isEmpty) ? 'Ingrese su contraseña' : null,
                ),
                const SizedBox(height: 32),

                // Botón Iniciar Sesión
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38BDF8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _loading ? null : _handleLogin,
                    child: _loading
                        ? const CircularProgressIndicator(color: Color(0xFF0F172A))
                        : const Text(
                            'INGRESAR AL SISTEMA',
                            style: TextStyle(
                              color: Color(0xFF0F172A),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Outfit',
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```
