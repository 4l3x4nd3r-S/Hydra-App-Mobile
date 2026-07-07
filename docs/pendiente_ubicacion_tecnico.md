# PENDIENTE — Ubicación en Tiempo Real del Técnico

## Contexto
Para que el mapa del Supervisor muestre la posición real de cada técnico en campo,
se necesitan 2 cambios: uno en el Backend y uno en el Frontend.

---

## Tarea del Backend

### Endpoint 1 — Actualizar ubicación del técnico
```
PATCH /api/v1/usuarios/me/location
```
**Body:**
```json
{
  "lat": -12.5934,
  "lon": -69.1923
}
```
**Respuesta:** 200 OK

Guardar lat/lon en la tabla de usuarios junto con `ultima_actualizacion` (timestamp).

---

### Endpoint 2 — Exponer ubicación en lista de técnicos
Modificar `GET /api/v1/supervisor/tecnicos` para incluir:
```json
{
  "id": 2,
  "nombre": "Técnico de Campo",
  "dni": "00000002",
  "lat": -12.5934,
  "lon": -69.1923,
  "ultima_actualizacion": "2026-06-01T15:30:00"
}
```

---

## Tarea del Frontend (pendiente de implementar)

- Envío automático de GPS cada 30 segundos desde `InboxScreen` del técnico
- El mapa del Supervisor recarga posiciones cada 30 segundos
- Mostrar `ultima_actualizacion` en el tooltip del marcador del técnico

---

## Nota
El paquete `geolocator` ya está instalado en el proyecto.
Solo falta el endpoint del backend para activar esta funcionalidad.
