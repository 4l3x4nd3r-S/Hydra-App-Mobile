import 'package:flutter/material.dart';
import '../../../../domain/models/reclamo.dart';

class ReclamoTileData {
  final int id;
  final String? estado;
  final String? fechaRegistro;
  final String? nombreSolicitante;
  final String? direccion;
  final String? tipoProblema;
  final String? tipoProblemaDescripcion;
  final String? formato;
  final String? codigoSolicitud;
  final String? descripcion;
  final String? numeroSuministro;
  final VoidCallback? onTap;

  const ReclamoTileData({
    required this.id,
    this.estado,
    this.fechaRegistro,
    this.nombreSolicitante,
    this.direccion,
    this.tipoProblema,
    this.tipoProblemaDescripcion,
    this.formato,
    this.codigoSolicitud,
    this.descripcion,
    this.numeroSuministro,
    this.onTap,
  });

  factory ReclamoTileData.fromReclamo(
    Reclamo r, {
    String? tipoProblemaDescripcion,
    VoidCallback? onTap,
  }) {
    return ReclamoTileData(
      id: r.id,
      estado: r.estado,
      fechaRegistro: r.fechaRegistro,
      nombreSolicitante: r.nombreSolicitante,
      direccion: r.direccion,
      tipoProblema: r.tipoProblema,
      tipoProblemaDescripcion: tipoProblemaDescripcion,
      formato: r.formato,
      codigoSolicitud: r.codigoSolicitud,
      descripcion: r.descripcion,
      numeroSuministro: r.numeroSuministro,
      onTap: onTap,
    );
  }
}
