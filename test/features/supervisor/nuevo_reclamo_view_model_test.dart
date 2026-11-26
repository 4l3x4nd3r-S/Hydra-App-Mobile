import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/data/repositories/supervisor_repository.dart';
import 'package:hydra/domain/use_cases/crear_reclamo_use_case.dart';
import 'package:hydra/ui/features/supervisor/view_models/nuevo_reclamo_view_model.dart';
import '../../helpers/fake_catalog_repository.dart';

class _FakeSupervisorRepository implements SupervisorRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late NuevoReclamoViewModel viewModel;

  void completarCamposValidos() {
    viewModel.codigoController.text = '12345';
    viewModel.numeroSuministroController.text = '1234567';
    viewModel.descripcionController.text = 'Fuga visible';
    viewModel.nombreController.text = 'Usuario Prueba';
    viewModel.direccionController.text = 'Avenida Principal';
    viewModel.telefonoController.text = '987654321';
    viewModel.emailController.text = 'usuario@prueba.com';
  }

  setUp(() async {
    viewModel = NuevoReclamoViewModel(
      crearReclamoUseCase: CrearReclamoUseCase(
        repository: _FakeSupervisorRepository(),
      ),
      catalogRepository: FakeCatalogRepository(),
    );
    await Future<void>.delayed(Duration.zero);
  });

  tearDown(() => viewModel.dispose());

  test('Anexo 6 conserva exclusivamente los tipos OP', () {
    expect(viewModel.formato, 'Anexo 6');
    expect(viewModel.tipoProblema, 'OP-1');
    expect(
      viewModel.tiposProblema,
      ['OP-1'],
    );
    expect(viewModel.tiposProblema, isNot(contains('B1')));
  });

  test('Formato 1 muestra el catálogo operacional solicitado', () {
    viewModel.setFormato('Formato 1');

    expect(viewModel.tipoProblema, 'B6');
    expect(viewModel.tiposProblema, ['B6']);
    expect(viewModel.tiposProblema, isNot(contains('OP-1')));
    expect(viewModel.descripcionesProblema['B6'], contains('Alcantarillado'));
  });

  test('al cambiar de formato reinicia un tipo que dejó de ser válido', () {
    viewModel.setFormato('Formato 1');
    viewModel.setTipoProblema('B6');
    expect(viewModel.tipoProblema, 'B6');

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

  test('número de suministro rechaza menos de cuatro dígitos', () async {
    completarCamposValidos();
    viewModel.numeroSuministroController.text = '123';

    expect(await viewModel.submit(), isFalse);
    expect(
      viewModel.fieldErrors['numero_suministro'],
      'Debe tener entre 4 y 8 dígitos',
    );
  });

  test('número de suministro rechaza más de ocho dígitos', () async {
    completarCamposValidos();
    viewModel.numeroSuministroController.text = '123456789';

    expect(await viewModel.submit(), isFalse);
    expect(
      viewModel.fieldErrors['numero_suministro'],
      'Debe tener entre 4 y 8 dígitos',
    );
  });

  for (final valido in ['1234', '12345', '004444', '1041998', '12345678']) {
    test('número de suministro acepta $valido', () async {
      completarCamposValidos();
      viewModel.numeroSuministroController.text = valido;

      await viewModel.submit();
      expect(viewModel.fieldErrors['numero_suministro'], isNull);
    });
  }

  for (final ceros in ['0000', '000000', '0000000', '00000000']) {
    test('número de suministro rechaza $ceros', () async {
      completarCamposValidos();
      viewModel.numeroSuministroController.text = ceros;

      expect(await viewModel.submit(), isFalse);
      expect(
        viewModel.fieldErrors['numero_suministro'],
        'No puede ser todo ceros',
      );
    });
  }
}
