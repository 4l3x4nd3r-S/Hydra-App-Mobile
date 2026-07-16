import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../domain/use_cases/crear_reclamo_use_case.dart';
import '../../../core/theme/app_colors.dart';
import '../view_models/nuevo_reclamo_view_model.dart';

class NuevoReclamoView extends StatelessWidget {
  const NuevoReclamoView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NuevoReclamoViewModel(
        crearReclamoUseCase: context.read<CrearReclamoUseCase>(),
      ),
      child: const _NuevoReclamoBody(),
    );
  }
}

class _NuevoReclamoBody extends StatefulWidget {
  const _NuevoReclamoBody();

  @override
  State<_NuevoReclamoBody> createState() => _NuevoReclamoBodyState();
}

class _NuevoReclamoBodyState extends State<_NuevoReclamoBody> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final vm = context.watch<NuevoReclamoViewModel>();

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: c.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Nuevo Reclamo',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: c.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader(
                  c, Icons.person_rounded, 'DATOS DEL RECLAMANTE'),
              const SizedBox(height: 16),
              _buildTextField(
                c: c,
                controller: vm.nombreController,
                label: 'Nombres y Apellidos',
                hint: 'Ingrese nombres completos',
                error: vm.fieldErrors['nombre_solicitante'],
                onChanged: (_) => vm.clearFieldError('nombre_solicitante'),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                c: c,
                controller: vm.numeroMedidorController,
                label: 'N\u00b0 de Medidor',
                hint: 'Ej: 1041998',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(7),
                ],
                maxLength: 7,
                error: vm.fieldErrors['numero_medidor'],
                onChanged: (_) => vm.clearFieldError('numero_medidor'),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                c: c,
                controller: vm.telefonoController,
                label: 'Celular',
                hint: '9 d\u00edgitos',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 9,
                error: vm.fieldErrors['telefono'],
                onChanged: (_) => vm.clearFieldError('telefono'),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                c: c,
                controller: vm.emailController,
                label: 'Correo Electr\u00f3nico',
                hint: 'ejemplo@correo.com',
                keyboardType: TextInputType.emailAddress,
                error: vm.fieldErrors['email'],
                onChanged: (_) => vm.clearFieldError('email'),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                c: c,
                controller: vm.direccionController,
                label: 'Direcci\u00f3n',
                hint: 'Av. Principal 123',
                error: vm.fieldErrors['direccion'],
                onChanged: (_) => vm.clearFieldError('direccion'),
              ),
              const SizedBox(height: 32),
              _buildSectionHeader(c, Icons.report_problem_rounded,
                  'INFORMACI\u00d3N DEL RECLAMO'),
              const SizedBox(height: 16),
              _buildDateTimeField(
                context,
                c: c,
                label: 'Fecha y Hora de Registro',
                value: vm.fechaRegistro,
                onChanged: vm.setFechaRegistro,
              ),
              const SizedBox(height: 16),
              _buildPickerField(
                c: c,
                label: 'Formato',
                value: vm.formato,
                options: NuevoReclamoViewModel.formatos,
                onChanged: vm.setFormato,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                c: c,
                controller: vm.codigoController,
                label: 'C\u00f3digo de Solicitud',
                hint: 'Ej: 12345',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(5),
                ],
                maxLength: 5,
                error: vm.fieldErrors['codigo_solicitud'],
                onChanged: (_) => vm.clearFieldError('codigo_solicitud'),
              ),
              const SizedBox(height: 16),
              _buildPickerField(
                c: c,
                label: 'Canal de Entrada',
                value: vm.canalEntrada,
                options: NuevoReclamoViewModel.canales,
                onChanged: vm.setCanalEntrada,
              ),
              const SizedBox(height: 16),
              _buildPickerField(
                c: c,
                label: 'Tipo de Problema',
                value: vm.tipoProblema,
                options: vm.tiposProblema,
                subtitles: vm.descripcionesProblema,
                onChanged: vm.setTipoProblema,
              ),
              const SizedBox(height: 16),
              _buildTextArea(
                c: c,
                controller: vm.descripcionController,
                label: 'Descripci\u00f3n',
                hint: 'Detalle completo del problema...',
                error: vm.fieldErrors['descripcion'],
                onChanged: (_) => vm.clearFieldError('descripcion'),
              ),
              if (vm.errorMsg != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: Color(0xFFDC2626), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(vm.errorMsg!,
                            style: const TextStyle(
                                color: Color(0xFFDC2626), fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: c.border),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed:
                          vm.submitting ? null : () => Navigator.pop(context),
                      child: Text('Cancelar',
                          style: TextStyle(
                              color: c.onSurface,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: c.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: vm.submitting
                          ? null
                          : () async {
                              final ok = await vm.submit();
                              if (ok && mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Reclamo creado exitosamente'),
                                  backgroundColor: Color(0xFF22C55E),
                                ));
                                Navigator.pop(context, true);
                              } else if (!ok &&
                                  mounted &&
                                  vm.fieldErrors.isNotEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Por favor, corrija los errores marcados en rojo'),
                                  backgroundColor: Color(0xFFDC2626),
                                  behavior: SnackBarBehavior.floating,
                                ));
                                _scrollController.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOut,
                                );
                              }
                            },
                      child: vm.submitting
                          ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  color: c.onPrimary, strokeWidth: 2.5),
                            )
                          : Text('Guardar',
                              style: TextStyle(
                                  color: c.onPrimary,
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(AppColors c, IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: c.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: c.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(title,
            style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: c.primary,
                letterSpacing: 1)),
      ],
    );
  }

  Widget _buildTextField({
    required AppColors c,
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    int? maxLength,
    String? error,
    ValueChanged<String>? onChanged,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: c.onSurface, fontSize: 15),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: c.onSurfaceVariant, fontSize: 14),
        hintStyle: TextStyle(
            color: c.onSurfaceVariant.withValues(alpha: 0.5), fontSize: 13),
        errorText: error,
        errorStyle: const TextStyle(color: Color(0xFFDC2626), fontSize: 12),
        filled: true,
        fillColor: c.surface,
        counterText: '',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: c.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: c.primary)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDC2626))),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDC2626))),
      ),
    );
  }

  Widget _buildTextArea({
    required AppColors c,
    required TextEditingController controller,
    required String label,
    String? hint,
    String? error,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: c.onSurface, fontSize: 15),
      maxLines: 5,
      maxLength: 500,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: true,
        labelStyle: TextStyle(color: c.onSurfaceVariant, fontSize: 14),
        hintStyle: TextStyle(
            color: c.onSurfaceVariant.withValues(alpha: 0.5), fontSize: 13),
        errorText: error,
        errorStyle: const TextStyle(color: Color(0xFFDC2626), fontSize: 12),
        filled: true,
        fillColor: c.surface,
        counterStyle: TextStyle(color: c.onSurfaceVariant, fontSize: 11),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: c.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: c.primary)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDC2626))),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDC2626))),
      ),
    );
  }

  Widget _buildPickerField({
    required AppColors c,
    required String label,
    required String value,
    required List<String> options,
    Map<String, String>? subtitles,
    required ValueChanged<String> onChanged,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: c.surface,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (ctx) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: c.onSurfaceVariant.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: c.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ),
                  const Divider(),
                  Flexible(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        children: options.map((opt) {
                          final selected = opt == value;
                          final subtitle = subtitles?[opt];
                          return InkWell(
                            onTap: () {
                              onChanged(opt);
                              Navigator.pop(ctx);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                              child: Row(
                                crossAxisAlignment: subtitle != null
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: subtitle != null ? 2.0 : 0.0),
                                    child: Icon(
                                      selected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      color: selected
                                          ? c.primary
                                          : c.onSurfaceVariant
                                              .withValues(alpha: 0.5),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          opt,
                                          style: TextStyle(
                                            color: selected
                                                ? c.primary
                                                : c.onSurface,
                                            fontSize: 16,
                                            fontWeight: selected
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                          ),
                                        ),
                                        if (subtitle != null) ...[
                                          const SizedBox(height: 6),
                                          Text(
                                            subtitle,
                                            style: TextStyle(
                                              color: c.onSurfaceVariant,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: c.onSurfaceVariant, fontSize: 14),
          filled: true,
          fillColor: c.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: c.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: c.border)),
          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded,
              color: c.onSurfaceVariant, size: 20),
        ),
        child: Text(value,
            style: TextStyle(
                color: c.onSurface, fontSize: 15, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildDateTimeField(
    BuildContext context, {
    required AppColors c,
    required String label,
    required DateTime value,
    required ValueChanged<DateTime> onChanged,
  }) {
    String formatDateTime(DateTime dt) {
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }

    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (date != null && context.mounted) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(value),
          );
          if (time != null) {
            onChanged(DateTime(
                date.year, date.month, date.day, time.hour, time.minute));
          }
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: c.onSurfaceVariant, fontSize: 14),
          filled: true,
          fillColor: c.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: c.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: c.border)),
          suffixIcon: Icon(Icons.calendar_today_rounded,
              color: c.onSurfaceVariant, size: 20),
        ),
        child: Text(
          formatDateTime(value),
          style: TextStyle(
              color: c.onSurface, fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
