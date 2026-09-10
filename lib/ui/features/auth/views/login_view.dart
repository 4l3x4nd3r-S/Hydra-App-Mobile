import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/use_cases/login_use_case.dart';
import '../../../core/theme/app_colors.dart';
import '../../theme_view_model.dart';
import '../view_models/login_view_model.dart';
import '../../os_inbox/views/os_inbox_view.dart';
import '../../supervisor/views/supervisor_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(
        loginUseCase: context.read<LoginUseCase>(),
      ),
      child: const _LoginBody(),
    );
  }
}

class _LoginBody extends StatefulWidget {
  const _LoginBody();

  @override
  State<_LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<_LoginBody> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _handleLogin() async {
    final vm = context.read<LoginViewModel>();
    if (vm.loading) return;
    if (!_formKey.currentState!.validate()) return;

    vm.clearError();
    final session = await vm.login();
    if (session != null && mounted) {
      final destino = session.rol != 'GASFITERO'
          ? const SupervisorView()
          : const OsInboxView();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => destino),
      );
    } else if (mounted && vm.errorMsg != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMsg!),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final themeVm = context.watch<ThemeViewModel>();
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: c.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: c.onSurface.withValues(alpha: 0.15),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.water_drop_rounded,
                          color: c.onSurface,
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'HYDRA',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: c.onSurface,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Sistema de Gestión de Órdenes de Servicio',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: c.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: c.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'EMAPAT S.A.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: c.onPrimary,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: vm.codigoController,
                        style: TextStyle(color: c.onSurface),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Código de Empleado',
                          labelStyle: TextStyle(color: c.onSurfaceVariant),
                          prefixIcon: Icon(Icons.badge_outlined,
                              color: c.onSurfaceVariant),
                          filled: true,
                          fillColor: c.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: c.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: c.primary, width: 1),
                          ),
                        ),
                        validator: (val) => (val == null || val.isEmpty)
                            ? 'Ingrese su codigo de empleado'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: vm.passController,
                        obscureText: vm.obscurePassword,
                        style: TextStyle(color: c.onSurface),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleLogin(),
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: TextStyle(color: c.onSurfaceVariant),
                          prefixIcon: Icon(Icons.lock_outline_rounded,
                              color: c.onSurfaceVariant),
                          suffixIcon: IconButton(
                            icon: Icon(
                              vm.obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: c.onSurfaceVariant,
                            ),
                            onPressed: () => vm.togglePasswordVisibility(),
                          ),
                          filled: true,
                          fillColor: c.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: c.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: c.primary, width: 1),
                          ),
                        ),
                        validator: (val) => (val == null || val.isEmpty)
                            ? 'Ingrese su contrasena'
                            : null,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: c.primary,
                            disabledBackgroundColor:
                                c.primary.withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: vm.loading ? null : _handleLogin,
                          child: vm.loading
                              ? SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: c.onPrimary,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  'INGRESAR AL SISTEMA',
                                  style: TextStyle(
                                    color: c.onPrimary,
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
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  themeVm.isLight
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  color: c.onSurfaceVariant,
                ),
                onPressed: () => themeVm.toggle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
