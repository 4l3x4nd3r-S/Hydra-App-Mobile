# INSTRUCCIONES - DESARROLLADOR B: DASHBOARD DE RENDIMIENTO Y MÉTRICAS MTTR (paso_11)

Esta especificación técnica detalla cómo implementar una nueva pestaña de Dashboard y Analíticas en el menú de la bandeja de entrada, mostrando métricas de eficiencia operativa y KPIs de SUNASS para el técnico.

---

## 🎯 Objetivo de Tarea
Desarrollar una pestaña premium adicional en `InboxScreen` llamada **"Mi Dashboard"** para mostrar KPIs de rendimiento hidráulico:
1. **MTTR (Mean Time To Repair / Tiempo Medio de Reparación)** calculado en minutos en base a los registros locales.
2. **Eficiencia SUNASS**: Porcentaje de órdenes de trabajo resueltas en menos de 2 horas (el umbral regulatorio).
3. **Distribución de Materiales**: Un micro-gráfico circular/barra personalizado diseñado en Canvas o Widgets para mostrar el inventario de tuberías reparadas (PVC, Asbesto Cemento, HDPE).

---

## 📂 Archivos a Crear / Modificar
*   `lib/features/ot_inbox/presentation/inbox_screen.dart` (Añadir la tercera pestaña del TabBar y diseñar la interfaz del Dashboard)

---

## 📋 Directrices de Programación y Flujo de Trabajo

### 1. Extensión del TabBar a 3 Pestañas
*   Modifica el `DefaultTabController` o tu `TabController` customizado de `InboxScreen` para admitir **3 pestañas**:
    1.  *"Órdenes Activas"* (Buzón + Google Maps).
    2.  *"Mis Cierres"* (Cola de sincronización SQLite local).
    3.  *"Mi Rendimiento"* (Dashboard de KPIs y Analíticas del técnico).

### 2. Diseño del Dashboard Premium (UI Material 3)
*   Presenta una rejilla de tarjetas Slate-800 (`#1E293B`) altamente visuales y de bordes redondeados:
    *   **Tarjeta 1 (KPI Principal - MTTR)**: Muestra el tiempo promedio de reparación (p. ej., *"48 min"*), indicando un badge verde de *"Excelente MTTR (SUNASS < 120 min)"*.
    *   **Tarjeta 2 (Métrica de Eficiencia)**: Un indicador de porcentaje circular animado o tarjeta destacando que el *"92% de órdenes"* se completaron a tiempo.
    *   **Tarjeta 3 (Materiales de Tuberías Reparadas)**: Un gráfico de barras horizontales hecho con contenedores de colores que muestra la cantidad de reparaciones agrupadas por material (ej: PVC: 15, Asbesto: 8, HDPE: 3).

---

## 🎨 Código Base de Apoyo y Widgets para el Dashboard

Integra esta vista y widgets de analíticas dentro de tu estructura de pestañas en `inbox_screen.dart`:

```dart
  // Widget principal de la pestaña de Dashboard
  Widget _buildDashboardTab() {
    // Datos simulados extraídos de los cierres locales
    const double mttrMinutos = 52.0;
    const double porcentajeEficiencia = 94.0;
    const int reparacionesPvc = 18;
    const int reparacionesAsbesto = 12;
    const int reparacionesHdpe = 5;
    const int totalCierres = reparacionesPvc + reparacionesAsbesto + reparacionesHdpe;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjeta Principal MTTR
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('TIEMPO MEDIO DE REPARACIÓN (MTTR)', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    const Text('52 min', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, fontFamily: 'Outfit')),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF34D399).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF34D399).withValues(alpha: 0.3)),
                      ),
                      child: const Text('ÓPTIMO SUNASS', style: TextStyle(color: Color(0xFF34D399), fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Tu tiempo medio de cierre está un 56% por debajo del límite máximo regulatorio (2 horas).', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Fila de KPIs Secundarios
          Row(
            children: [
              Expanded(
                child: _buildKpiCard(
                  title: 'Eficiencia de Red',
                  value: '94%',
                  subText: 'Cierres a tiempo',
                  color: const Color(0xFF34D399),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildKpiCard(
                  title: 'Total Resueltas',
                  value: '$totalCierres',
                  subText: 'Órdenes cerradas',
                  color: const Color(0xFF38BDF8),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          const Text('Distribución de Tuberías Reparadas', style: TextStyle(color: Colors.white, fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          
          // Gráfico de Barras de Distribución de Materiales
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
            child: Column(
              children: [
                _buildMaterialProgressBar(label: 'Tuberías PVC', count: reparacionesPvc, total: totalCierres, color: const Color(0xFF38BDF8)),
                const SizedBox(height: 14),
                _buildMaterialProgressBar(label: 'Tuberías Asbesto Cemento', count: reparacionesAsbesto, total: totalCierres, color: const Color(0xFFFBBF24)),
                const SizedBox(height: 14),
                _buildMaterialProgressBar(label: 'Tuberías HDPE', count: reparacionesHdpe, total: totalCierres, color: const Color(0xFF34D399)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard({required String title, required String value, required String subText, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Outfit')),
          const SizedBox(height: 4),
          Text(subText, style: const TextStyle(color: Colors.white24, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildMaterialProgressBar({required String label, required int count, required int total, required Color color}) {
    final double percentage = total > 0 ? count / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.between,
          children: [
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
            Text('$count ($onlyIntegerPercent%)', style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: const Color(0xFF0F172A),
            color: color,
          ),
        ),
      ],
    );
  }
  
  int get onlyIntegerPercent => (percentage * 100).round();
```

*Inserta este Widget dentro de tu `TabBarView` en `inbox_screen.dart` para desplegar el Panel de Rendimiento y dotar de analíticas SUNASS avanzadas al técnico.*
