import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/use_cases/validate_session_use_case.dart';
import '../../../core/theme/app_colors.dart';
import '../view_models/session_view_model.dart';
import 'login_view.dart';
import '../../os_inbox/views/os_inbox_view.dart';
import '../../supervisor/views/supervisor_view.dart';

class SessionGateView extends StatelessWidget {
  const SessionGateView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SessionViewModel(
        validateSessionUseCase:
            context.read<ValidateSessionUseCase>(),
      )..validate(),
      child: Consumer<SessionViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            final c = Theme.of(context).extension<AppColors>()!;
            return Scaffold(
              backgroundColor: c.background,
              body: Center(
                child: CircularProgressIndicator(color: c.primary),
              ),
            );
          }

          final session = vm.session;
          if (session == null) {
            return const LoginView();
          }

          if (session.rol != 'GASFITERO') {
            return const SupervisorView();
          }
          return const OsInboxView();
        },
      ),
    );
  }
}
