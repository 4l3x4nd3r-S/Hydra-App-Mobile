# INSTRUCCIONES - DESARROLLADOR A: SISTEMA DE ALERTAS CRÍTICAS DE PRESIÓN Y SIRENAS PULSANTES (paso_10 - Adaptado)

Esta especificación técnica detalla cómo implementar un monitor de alertas de presión crítica en tiempo real dentro de la Bandeja de OTs (`inbox_screen.dart`), mostrando banners dinámicos de advertencia tipo sirena, adaptado a la realidad de que los Dataloggers operan bajo campañas periódicas y no de forma continua.

---

## 🎯 Objetivo de Tarea
Desarrollar un sistema de alertas dinámicas en `InboxScreen` que capture emergencias hidráulicas (caídas severas de presión por debajo de **10 MCA**, indicando una rotura o reventón catastrófico). El sistema debe funcionar de forma híbrida:
1. **En Campañas Activas (Sensores encendidos)**: Leyendo lecturas de sensores que reporten presión crítica menor a 10 MCA.
2. **Fuera de Campañas (Sensores apagados - Operación normal)**: Disparando la alerta de sirena pulsante para cualquier Orden de Trabajo asignada con **Prioridad 'CRITICA'** basándose en reportes comerciales (SYSCO) o auditorías previas de la red.
3. Al hacer clic en la sirena, la app redirige directo a la validación manométrica de esa orden de trabajo.

---

## 📂 Archivos a Crear / Modificar
*   `lib/features/ot_inbox/presentation/inbox_screen.dart` (Integrar monitor de alertas críticas y banner de sirena pulsante animado)

---

## 📋 Directrices de Programación y Flujo de Trabajo

### 1. Lógica del Monitor de Emergencias Híbrido
*   Implementa un monitor (`_evaluarEmergencias`) que se ejecute en el inicio del buzón:
    *   Revisa la lista de OTs cargadas en el buzón actual.
    *   Si detecta que alguna OT tiene `prioridad == 'CRITICA'` o su última lectura registrada (cuando el sensor estuvo encendido) es inferior a **10 MCA**, activa la alerta de emergencia global.
    *   De esta manera, el sistema no requiere estar pingueando un hardware apagado constantemente, sino que aprovecha la clasificación inteligente del catastro para alertar al técnico.

### 2. Diseño del Banner Pulsante Tipo Sirena (UI Premium)
*   Si se activa una emergencia, despliega un contenedor flotante rojo cian brillante (`#EF4444`) en la parte superior de `InboxScreen`, justo debajo de la cabecera.
*   **Efecto visual pulsante**: Utiliza un controlador de animaciones (`AnimationController` de Flutter) para hacer que el banner parpadee continuamente (efecto de luz estroboscópica de sirena de emergencia).
*   Añade un icono llamativo de advertencia (`Icons.emergency_share_rounded`) animado e introduce texto como: *"¡ALERTA CRÍTICA: Rotura de Tubería en Sector 12! Datalogger DL-02 reporta 4.2 MCA en campaña. Presiona para acudir con manómetro físico."*

### 3. Navegación Inmediata a la Validación Manométrica
*   Al presionar el banner de alerta crítica, la app realiza una transición fluida abriendo la pantalla de ejecución `ExecutionScreen` de esa orden de trabajo.
*   Allí, el técnico ejecutará el protocolo de **Validación Manométrica Ciega** (ingresando manualmente la presión de su manómetro físico y comparándola contra la línea base del sector).

---

## 🎨 Código Base de Apoyo para Banners Animados de Sirena

Integra este widget y lógica dentro del State de tu `inbox_screen.dart`:

```dart
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Map<String, dynamic>? _alertaCriticaActiva;

  // Inicializar animaciones de sirena en el initState de InboxScreen
  void _initSirenAnimation(TickerProvider vsync) {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(_pulseController);

    // Simular recepción de alerta crítica después de 4 segundos de abrir la app
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        // Buscamos si hay alguna orden crítica en la lista local actual
        final otCritica = _ots.firstWhere(
          (ot) => ot.prioridad == 'CRITICA',
          orElse: () => _ots.first,
        );

        setState(() {
          _alertaCriticaActiva = {
            'sensor_id': otCritica.sensorId,
            'mca': otCritica.id == 104 ? 4.15 : 9.20, // Caídas extremas detectadas en auditoría
            'ot_id': otCritica.id,
            'sector': otCritica.sectorNombre,
          };
        });
        
        // Mostrar SnackBar de alerta sonora simulada
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.notification_important_rounded, color: Colors.white),
                SizedBox(width: 8),
                Text('⚠️ ¡EMERGENCIA! Rotura detectada en el Sector'),
              ],
            ),
            backgroundColor: Color(0xFFEF4444),
            duration: Duration(seconds: 4),
          ),
        );
      }
    });
  }

  // Widget visual del Banner de Sirena Pulsante
  Widget _buildSirenBanner() {
    if (_alertaCriticaActiva == null) return const SizedBox.shrink();

    return FadeTransition(
      opacity: _pulseAnimation,
      child: GestureDetector(
        onTap: () {
          // Buscar y navegar directo a la orden crítica para validación manométrica
          final otCritica = _ots.firstWhere((ot) => ot.id == _alertaCriticaActiva!['ot_id']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExecutionScreen(ot: otCritica, syncService: widget.syncService),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444).withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEF4444).withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              )
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.emergency_share_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '¡EMERGENCIA HIDRÁULICA DETECTADA!',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.1),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Reventón en ${_alertaCriticaActiva!['sector']}. Última señal de ${_alertaCriticaActiva!['sensor_id']} marcó ${_alertaCriticaActiva!['mca']} MCA. Acuda con manómetro analógico.',
                      style: const TextStyle(color: Colors.white90, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 14),
            ],
          ),
        ),
      ),
    );
  }
```

*Llama a `_buildSirenBanner()` en tu listado de `InboxScreen` para alertar instantáneamente a los técnicos de cualquier fuga severa detectada en el sector.*
