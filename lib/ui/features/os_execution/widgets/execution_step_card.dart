import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// A numbered task section. Color always accompanies a written status.
class ExecutionStepCard extends StatefulWidget {
  const ExecutionStepCard({
    super.key,
    required this.number,
    required this.title,
    required this.completed,
    required this.active,
    required this.available,
    required this.child,
    this.confirmed = false,
    this.hasError = false,
    this.collapseOnConfirm = true,
    this.errorMessage,
  });

  final int number;
  final String title;

  /// El paso ya tiene los datos que pide.
  final bool completed;

  /// El técnico ya confirmó el paso.
  final bool confirmed;

  final bool active;
  final bool available;
  final bool hasError;

  /// Al confirmar, la tarjeta se pliega para dejar ver el siguiente paso.
  final bool collapseOnConfirm;

  final String? errorMessage;
  final Widget child;

  @override
  State<ExecutionStepCard> createState() => _ExecutionStepCardState();
}

class _ExecutionStepCardState extends State<ExecutionStepCard> {
  /// Una tarjeta arranca abierta salvo que el paso ya esté confirmado.
  late bool _expanded = !widget.confirmed;

  @override
  void didUpdateWidget(ExecutionStepCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasError && !oldWidget.hasError) _expanded = true;
    if (widget.active && !oldWidget.active) _expanded = true;
    // La tarjeta NO se pliega al tener datos: el técnico sigue viendo el
    // bloque y su botón de confirmación. Solo se pliega cuando confirma.
    if (widget.confirmed && !oldWidget.confirmed && widget.collapseOnConfirm) {
      _expanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final success = dark ? const Color(0xFF86EFAC) : const Color(0xFF166534);
    final error = dark ? const Color(0xFFFCA5A5) : const Color(0xFFB91C1C);
    final accent = widget.hasError
        ? error
        : !widget.available
            ? c.onSurfaceVariant
            : widget.confirmed
                ? success
                : widget.active || widget.completed
                    ? c.primary
                    : c.onSurfaceVariant;
    final status = !widget.available
        ? 'Pendiente'
        : widget.hasError
            ? 'Requiere atención'
            : widget.confirmed
                ? 'Confirmado'
                : widget.completed
                    ? 'Por confirmar'
                    : widget.active
                        ? 'Completar ahora'
                        : 'Pendiente';
    final canToggle = widget.available && !widget.active;
    final showBody = widget.available && (_expanded || widget.active);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.hasError || widget.active
              ? accent
              : c.border.withValues(alpha: 0.6),
          width: widget.hasError || widget.active ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: widget.active || widget.hasError
                ? accent.withValues(alpha: dark ? 0.10 : 0.04)
                : Colors.transparent,
            child: Semantics(
              button: canToggle,
              expanded: canToggle ? showBody : null,
              child: InkWell(
                onTap: canToggle
                    ? () => setState(() => _expanded = !_expanded)
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: widget.confirmed
                            ? Icon(Icons.check_rounded, color: accent, size: 22)
                            : Text('${widget.number}',
                                style: TextStyle(
                                    color: accent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.title,
                                style: TextStyle(
                                    color: c.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(status,
                                style: TextStyle(
                                    color: accent,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      if (canToggle) ...[
                        const SizedBox(width: 8),
                        Icon(
                            showBody
                                ? Icons.expand_less_rounded
                                : Icons.expand_more_rounded,
                            color: c.onSurfaceVariant),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (showBody)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  widget.child,
                  if (widget.hasError && widget.errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(widget.errorMessage!,
                        style: TextStyle(color: error, fontSize: 14)),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
