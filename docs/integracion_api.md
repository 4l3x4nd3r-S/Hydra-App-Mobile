# HYDRA — Estado de Integración API

## Endpoints implementados en el Frontend (Desarrollador B)

| Endpoint | Método | Cuándo se llama | Archivo |
|---|---|---|---|
| `/auth/login` | POST | Al hacer login con DNI y contraseña | `login_screen.dart` |
| `/auth/me` | GET | Validar token al arrancar la app — si responde 401 limpia sesión y manda al Login | `app.dart` |
| `/ots/assigned` | GET | Al abrir la bandeja de OTs y al presionar el botón 🔄 refresh | `inbox_screen.dart` |
| `/ots/{id}/start` | POST | Al tocar una OT para abrirla | `inbox_screen.dart` |
| `/ots/{id}/verify-pressure` | GET | Al presionar "Validar Presión de Red" | `execution_screen.dart` |
| `/ots/{id}/close` | POST (multipart) | Al finalizar reparación — fotos + firma + datos | `sync_service.dart` |
| `/analytics/kpis` | GET | Al abrir pestaña "Mi Rendimiento" | `inbox_screen.dart` |
| `/analytics/catastro` | GET | Al abrir la vista de mapa | `inbox_screen.dart` |

---

## Endpoints implementados — Pantalla Supervisor

| Endpoint | Método | Cuándo se llama | Archivo |
|---|---|---|---|
| `/supervisor/tecnicos` | GET | Al abrir pestaña "Técnicos" y al refrescar | `supervisor_screen.dart` |
| `/supervisor/alertas` | GET | Al abrir pestaña "Alertas" y al refrescar | `supervisor_screen.dart` |
| `/supervisor/ots` | POST | Al confirmar "Crear OT" en el formulario | `supervisor_screen.dart` |
| `/supervisor/ots` | GET | Al abrir pestaña "Historial" | `supervisor_screen.dart` |

**Flujo del Supervisor:**
1. Pestaña **Técnicos** — lista de técnicos activos con DNI e ID
2. Pestaña **Crear OT** — formulario para asignar OT a un técnico (sensor, punto, prioridad, tipo)
3. Pestaña **Alertas** — alertas del sistema; botón "Crear OT desde esta alerta" auto-rellena el formulario
4. Pestaña **Mapa** — mapa con OTs por prioridad (rojo/naranja/verde) y técnicos (azul)
5. Pestaña **Historial** — todas las OTs con estado, prioridad y fechas de creación/cierre

---

## Endpoints pendientes de implementar en el Frontend

| Endpoint | Método | Para qué sirve |
|---|---|---|
| `/sensores/upload-lecturas` | POST | Subir archivos CSV del data logger al backend |

---

## Tareas pendientes del Backend

### 1. Arreglar error 500 en Railway
`POST /api/v1/sensores` y `POST /api/v1/supervisor/ots` devuelven **500 Internal Server Error**.
La base de datos en Railway está vacía pero las inserciones fallan.
**Acción:** Correr migraciones en producción (`alembic upgrade head` o equivalente).

### 2. Completar `GET /analytics/kpis`
El endpoint existe pero el schema está vacío `{}`.
La app espera los siguientes campos:
```json
{
  "mttr_minutos": 52.0,
  "eficiencia_porcentaje": 94.0,
  "reparaciones_pvc": 18,
  "reparaciones_asbesto": 12,
  "reparaciones_hdpe": 5
}
```

### 3. Cargar catastro en `GET /analytics/catastro`
El endpoint existe pero devuelve vacío.
Los archivos fuente están disponibles en el dataset del Datathon:
- `CATASTRO REDES DE AGUA PUERTO MALDONADO.dwg`
- `CATASTRO DE REDES DE AGUA - EL TRIUNFO.dwg`

**Acción:** Convertir los `.dwg` a GeoJSON (con QGIS u otra herramienta) y cargarlos al endpoint.
La app los renderiza automáticamente como polilíneas sobre el mapa de Google Maps.

### 4. Crear datos de prueba
Una vez arreglado el error 500, crear:
- Al menos 3 sensores (`POST /sensores`)
- Al menos 3 OTs asignadas al técnico ID=2 (`POST /supervisor/ots`)

Así el `GET /ots/assigned` devuelve datos reales y el flujo completo puede ser probado end-to-end.

---

## Expiración del Token JWT

El token JWT generado por el backend tiene una duración de **8 horas** desde el momento del login.

**¿Por qué 8 horas?**
Es el tiempo estándar de un turno de trabajo de campo. Un técnico que inicia sesión a las 7:00am tendrá acceso hasta las 3:00pm sin necesidad de volver a autenticarse.

**¿Qué pasa cuando expira?**
La app llama a `GET /auth/me` al arrancar. Si el servidor responde **401 Unauthorized** (token expirado), el frontend limpia automáticamente la sesión local y redirige al técnico a la pantalla de Login. Si el error es por falta de señal (timeout de red), la sesión se mantiene para no bloquear al técnico en campo sin cobertura.

**Verificado con:** token del técnico `00000002` emitido el 01/06/2026 a las 15:35:47 UTC, expiración a las 23:35:47 UTC (diferencia exacta de 8 horas, campo `exp` del JWT decodificado).

---

## Notas de implementación offline-first

El frontend implementa un mecanismo de **fallback automático**:
- Si `GET /ots/assigned` falla o devuelve vacío → muestra 3 OTs mock con coordenadas reales de sensores EMAPAT 2024
- Si `GET /analytics/kpis` falla → muestra métricas estáticas de ejemplo
- Si `GET /analytics/catastro` falla o devuelve vacío → muestra polilíneas de demo sobre Puerto Maldonado real
- Si `POST /ots/{id}/close` falla por falta de señal → guarda en SQLite local y reintenta cuando vuelve la conexión
