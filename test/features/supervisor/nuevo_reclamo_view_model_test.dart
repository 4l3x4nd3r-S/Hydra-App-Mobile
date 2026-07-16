import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/data/repositories/supervisor_repository.dart';
import 'package:hydra/domain/use_cases/crear_reclamo_use_case.dart';
import 'package:hydra/ui/features/supervisor/view_models/nuevo_reclamo_view_model.dart';

class _FakeSupervisorRepository implements SupervisorRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late NuevoReclamoViewModel viewModel;

  void completarCamposValidos() {
    viewModel.codigoController.text = '12345';
    viewModel.numeroMedidorController.text = '1234567';
    viewModel.descripcionController.text = 'Fuga visible';
    viewModel.nombreController.text = 'Usuario Prueba';
    viewModel.direccionController.text = 'Avenida Principal';
    viewModel.telefonoController.text = '987654321';
    viewModel.emailController.text = 'usuario@prueba.com';
  }

  setUp(() {
    viewModel = NuevoReclamoViewModel(
      crearReclamoUseCase: CrearReclamoUseCase(
        repository: _FakeSupervisorRepository(),
      ),
    );
  });

  tearDown(() => viewModel.dispose());

  test('Anexo 6 conserva exclusivamente los tipos OP', () {
    expect(viewModel.formato, 'Anexo 6');
    expect(viewModel.tipoProblema, 'OP-1');
    expect(
      viewModel.tiposProblema,
      ['OP-1', 'OP-2', 'OP-3', 'OP-4', 'OP-5', 'OP-6', 'OP-7'],
    );
    expect(viewModel.tiposProblema, isNot(contains('B1')));
  });

  test('Formato 1 muestra el catálogo operacional solicitado', () {
    viewModel.setFormato('Formato 1');

    expect(viewModel.tipoProblema, 'B1');
    expect(viewModel.tiposProblema, hasLength(24));
    expect(
      viewModel.tiposProblema,
      containsAll([
        'B1',
        'B14',
        'FALTA DE PRESIÓN DE AGUA',
        'B6',
        'B12',
        'REPOSICIÓN DE TUBERIA DE CONCRETO A PVC - DESAGÜE',
        'A1',
        'TRABAJOS COLATERAS',
        'OTROS',
      ]),
    );
    expect(viewModel.tiposProblema, isNot(contains('OP-1')));
    expect(viewModel.descripcionesProblema['B1'], contains('Agua potable'));
    expect(viewModel.descripcionesProblema['B6'], contains('Desagüe'));
    expect(viewModel.descripcionesProblema['A1'], contains('Otros'));
  });

  test('al cambiar de formato reinicia un tipo que dejó de ser válido', () {
    viewModel.setFormato('Formato 1');
    viewModel.setTipoProblema('B12');
    expect(viewModel.tipoProblema, 'B12');

    viewModel.setFormato('Anexo 6');
    expect(viewModel.tipoProblema, 'OP-1');

    viewModel.setTipoProblema('B1');
    expect(viewModel.tipoProblema, 'OP-1');
  });

  test('código de solicitud requiere exactamente cinco dígitos', () async {
    completarCamposValidos();
    viewModel.codigoController.text = '1234';

    expect(await viewModel.submit(), isFalse);
    expect(
      viewModel.fieldErrors['codigo_solicitud'],
      'Debe tener exactamente 5 dígitos',
    );
  });

  test('código de solicitud rechaza 00000', () async {
    completarCamposValidos();
    viewModel.codigoController.text = '00000';

    expect(await viewModel.submit(), isFalse);
    expect(viewModel.fieldErrors['codigo_solicitud'], 'No puede ser 00000');
  });

  test('número de medidor requiere exactamente siete dígitos', () async {
    completarCamposValidos();
    viewModel.numeroMedidorController.text = '123456';

    expect(await viewModel.submit(), isFalse);
    expect(
      viewModel.fieldErrors['numero_medidor'],
      'Debe tener exactamente 7 dígitos',
    );
  });

  test('número de medidor rechaza 0000000', () async {
    completarCamposValidos();
    viewModel.numeroMedidorController.text = '0000000';

    expect(await viewModel.submit(), isFalse);
    expect(viewModel.fieldErrors['numero_medidor'], 'No puede ser 0000000');
  });
}
