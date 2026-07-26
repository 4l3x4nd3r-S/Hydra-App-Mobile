import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class OsDetailSection extends StatelessWidget {
  final String title;
  final List<MapEntry<String, String>> fields;
  final List<Widget>? extraActions;
  final AppColors c;

  const OsDetailSection({
    super.key,
    required this.title,
    required this.fields,
    this.extraActions,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: c.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: c.border.withValues(alpha: 0.8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            Divider(height: 1, color: c.border.withValues(alpha: 0.7)),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) => _buildGrid(constraints),
            ),
            if (extraActions != null && extraActions!.isNotEmpty) ...[
              const SizedBox(height: 14),
              ...extraActions!,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: c.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(_sectionIcon(), color: c.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _normalizedTitle(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: c.primary,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _sectionSubtitle(),
                style: TextStyle(color: c.onSurfaceVariant, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(BoxConstraints constraints) {
    const spacing = 10.0;
    final useCompactGrid = constraints.maxWidth >= 230;
    final availableGridWidth = constraints.maxWidth - spacing;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: fields.map((field) {
        final span = _fieldSpan(field.key);
        final width = !useCompactGrid || span == 12
            ? constraints.maxWidth
            : availableGridWidth / 2;
        return SizedBox(
          width: width,
          child: _buildFieldTile(field),
        );
      }).toList(),
    );
  }

  Widget _buildFieldTile(MapEntry<String, String> field) {
    final value =
        field.value.trim().isEmpty ? 'Sin información' : field.value.trim();
    final isDate = _isDateField(field.key);
    final isLongText = _isLongTextField(field.key);

    return Container(
      constraints: BoxConstraints(minHeight: isLongText ? 0 : 82),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: isLongText
            ? c.primary.withValues(alpha: 0.10)
            : c.primary.withValues(alpha: 0.065),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isLongText
              ? c.primary.withValues(alpha: 0.30)
              : c.primary.withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 28,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child:
                      Icon(_fieldIcon(field.key), color: c.primary, size: 15),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    _normalizedLabel(field.key).toUpperCase(),
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 9.5,
                      height: 1.25,
                      fontWeight: FontWeight.bold,
                      color: c.onSurfaceVariant,
                      letterSpacing: 0.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          if (isDate)
            _buildDateTimeValue(value)
          else if (_isEmailField(field.key))
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  value,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                    color: c.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            Text(
              value,
              style: TextStyle(
                color: c.onSurface,
                fontSize: isLongText ? 13.5 : 13,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateTimeValue(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) {
      return Text(
        value,
        style: TextStyle(
          color: c.onSurface,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    const weekdays = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minutes = date.minute.toString().padLeft(2, '0');
    final period = date.hour < 12 ? 'a. m.' : 'p. m.';

    return Row(
      children: [
        Expanded(
          child: Text(
            '${weekdays[date.weekday - 1]}, ${date.day} de ${months[date.month - 1]} de ${date.year}',
            style: TextStyle(
              color: c.onSurface,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: c.primary.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule_rounded, color: c.primary, size: 16),
              const SizedBox(width: 6),
              Text(
                '$hour:$minutes $period',
                style: TextStyle(
                  color: c.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  int _fieldSpan(String label) {
    final key = label.toLowerCase();
    const halfWidthFields = {
      'n° de o.s.',
      'cód. solicitud',
      'código de solicitud',
      'formato',
      'telefono',
      'teléfono',
      'suministro',
    };
    if (halfWidthFields.contains(key)) return 6;
    return 12;
  }

  bool _isDateField(String label) =>
      label.toLowerCase().contains('fecha') ||
      label.toLowerCase().contains('hora');

  bool _isEmailField(String label) =>
      label.toLowerCase().contains('email') ||
      label.toLowerCase().contains('correo');

  bool _isLongTextField(String label) {
    final key = label.toLowerCase();
    return key == 'tipo' ||
        key.contains('descripcion') ||
        key.contains('descripción') ||
        key.contains('direccion') ||
        key.contains('dirección') ||
        key.contains('trabajo') ||
        key.contains('problema') ||
        key.contains('solucion') ||
        key.contains('solución') ||
        key.contains('comentario') ||
        key.contains('observacion') ||
        key.contains('observación');
  }

  String _normalizedTitle() {
    final key = title.toLowerCase();
    if (key.contains('reclamo')) return 'INFORMACIÓN DEL RECLAMO';
    return title.toUpperCase();
  }

  String _normalizedLabel(String label) {
    const labels = {
      'N° de O.S.': 'N.° de O.S.',
      'Descripcion': 'Descripción',
      'Direccion': 'Dirección',
      'Telefono': 'Teléfono',
      'Fecha registro': 'Fecha de registro',
      'Fecha Hora Inicio': 'Fecha y hora de inicio',
      'Fecha Hora Fin': 'Fecha y hora de finalización',
    };
    return labels[label] ?? label;
  }

  String _sectionSubtitle() {
    final key = title.toLowerCase();
    if (key.contains('reclamo')) return 'Datos asociados a la solicitud';
    if (key.contains('cuadrilla')) return 'Equipo asignado a la orden';
    if (key.contains('responsable')) return 'Personal encargado del trabajo';
    if (key.contains('fecha') || key.contains('hora')) {
      return 'Registro temporal de la atención';
    }
    if (key.contains('foto')) return 'Evidencia registrada en campo';
    return 'Información registrada en la orden';
  }

  IconData _sectionIcon() {
    final key = title.toLowerCase();
    if (key.contains('reclamo')) return Icons.assignment_outlined;
    if (key.contains('cuadrilla')) return Icons.groups_outlined;
    if (key.contains('responsable')) return Icons.engineering_outlined;
    if (key.contains('fecha') || key.contains('hora')) {
      return Icons.event_outlined;
    }
    if (key.contains('trabajo')) return Icons.handyman_outlined;
    if (key.contains('problema')) return Icons.rule_outlined;
    if (key.contains('comentario')) return Icons.chat_bubble_outline_rounded;
    if (key.contains('observacion')) return Icons.visibility_outlined;
    return Icons.info_outline_rounded;
  }

  IconData _fieldIcon(String label) {
    final key = label.toLowerCase();
    if (key.contains('o.s.')) return Icons.tag_rounded;
    if (key.contains('código de solicitud')) return Icons.tag_rounded;
    if (key.contains('solicitante')) return Icons.person_outline_rounded;
    if (key == 'tipo') return Icons.build_outlined;
    if (key.contains('formato')) return Icons.description_outlined;
    if (key.contains('descripcion')) return Icons.notes_rounded;
    if (key.contains('direccion')) return Icons.location_on_outlined;
    if (key.contains('telefono')) return Icons.phone_outlined;
    if (key.contains('email')) return Icons.mail_outline_rounded;
    if (key.contains('suministro')) return Icons.speed_rounded;
    if (_isDateField(label)) return Icons.calendar_today_outlined;
    if (key.contains('cuadrilla')) return Icons.groups_outlined;
    if (key.contains('líder')) return Icons.star_outline_rounded;
    if (key.contains('apoyo')) return Icons.person_outline_rounded;
    if (key.contains('chofer')) return Icons.local_shipping_outlined;
    if (key.contains('trabajo')) return Icons.handyman_outlined;
    if (key.contains('problema')) return Icons.warning_amber_rounded;
    if (key.contains('solucion')) return Icons.check_circle_outline_rounded;
    if (key.contains('comentario')) return Icons.chat_bubble_outline_rounded;
    if (key.contains('observacion')) return Icons.visibility_outlined;
    return Icons.info_outline_rounded;
  }
}
