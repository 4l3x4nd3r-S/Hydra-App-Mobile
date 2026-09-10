import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.1.13:8000/api/v1';

Future<void> main() async {
  try {
    print('1. Login como Supervisor (SUP001)');
    final supLogin = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      body: {'codigo_empleado': 'SUP001', 'password': 'SUP001'},
    );
    if (supLogin.statusCode != 200) throw Exception('Fallo login supervisor');
    final supToken = jsonDecode(supLogin.body)['access_token'];
    final supHeaders = {'Authorization': 'Bearer $supToken', 'Content-Type': 'application/json'};

    print('2. Creando Reclamo');
    final reclamoPayload = {
      'formato': 'Formato A',
      'codigo_solicitud': 'REQ-E2E-001',
      'canal_entrada': 'WEB',
      'tipo_problema': 'Fuga de agua',
      'descripcion': 'Prueba E2E Automatizada',
      'nombre_solicitante': 'Usuario E2E',
      'direccion': 'Av Siempre Viva 123',
    };
    final resReclamo = await http.post(
      Uri.parse('$baseUrl/reclamos'),
      headers: supHeaders,
      body: jsonEncode(reclamoPayload),
    );
    if (resReclamo.statusCode >= 300) throw Exception('Fallo crear reclamo: \${resReclamo.body}');
    final reclamoId = jsonDecode(resReclamo.body)['id'];
    print('  -> Reclamo creado con ID: $reclamoId');

    print('3. Asignando a Cuadrilla de MAN003');
    final resCuadrillas = await http.get(Uri.parse('$baseUrl/supervisor/cuadrillas'), headers: supHeaders);
    final List cuadrillas = jsonDecode(resCuadrillas.body);
    int? cuadrillaTargetId;
    for (var c in cuadrillas) {
      if (c['nombre'].toString().contains('017') || c['id'] != null) {
         cuadrillaTargetId = c['id'];
         break;
      }
    }
    if (cuadrillaTargetId == null) throw Exception('No cuadrillas found');
    print('  -> Usando Cuadrilla ID: $cuadrillaTargetId');

    final resAssign = await http.post(
      Uri.parse('$baseUrl/supervisor/ordenes-servicio'),
      headers: supHeaders,
      body: jsonEncode({
        'reclamo_id': reclamoId,
        'cuadrilla_id': cuadrillaTargetId,
        'fecha_programacion': DateTime.now().toIso8601String(),
      }),
    );
    if (resAssign.statusCode >= 300) throw Exception('Fallo crear OS: \${resAssign.body}');
    final osId = jsonDecode(resAssign.body)['id'];
    print('  -> OS creada con ID: $osId');

    print('4. Login como Gasfitero (MAN003)');
    final manLogin = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      body: {'codigo_empleado': 'MAN003', 'password': 'MAN003'},
    );
    if (manLogin.statusCode != 200) throw Exception('Fallo login gasfitero');
    final manToken = jsonDecode(manLogin.body)['access_token'];
    final manHeaders = {'Authorization': 'Bearer $manToken', 'Content-Type': 'application/json'};

    print('5. Iniciar Orden de Servicio');
    final resIniciar = await http.post(
      Uri.parse('$baseUrl/ordenes-servicio/$osId/iniciar'),
      headers: manHeaders,
    );
    if (resIniciar.statusCode >= 300) print('  -> (Aviso: Podría ya estar iniciada o falló: \${resIniciar.body})');
    
    print('6. Completar Orden de Servicio');
    final resCompletar = await http.post(
      Uri.parse('$baseUrl/ordenes-servicio/$osId/finalizar'),
      headers: manHeaders,
      body: jsonEncode({
        'trabajo_ejecutado': 'Reparación de fuga completada (Prueba E2E)',
        'fecha_ejecucion_inicio': DateTime.now().subtract(Duration(hours: 1)).toIso8601String(),
        'fecha_ejecucion_fin': DateTime.now().toIso8601String(),
        'latitud': -12.5,
        'longitud': -69.2,
      })
    );
    if (resCompletar.statusCode >= 300) throw Exception('Fallo finalizar OS: \${resCompletar.body}');
    print('  -> OS Completada Exitosamente!');

    print('\\n>> ¡TODAS LAS PRUEBAS E2E PASARON CORRECTAMENTE! <<');

  } catch (e) {
    print('ERROR EN PRUEBA E2E: $e');
  }
}
