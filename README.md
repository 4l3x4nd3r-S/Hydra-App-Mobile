# HYDRA - Frontend Móvil

Este es el proyecto móvil oficial de **HYDRA** (anteriormente GEOR-EMAPAT) para **EMAPAT S.A.** e **JASS El Triunfo**. Es una aplicación nativa multiplataforma desarrollada en **Flutter** enfocada en el control de transitorios, georreferenciación de fugas y gestión de órdenes de trabajo de campo.

## Características Clave
*   **Gestión de Estado BLoC:** Arquitectura limpia y desacoplada de la UI.
*   **Offline-First:** Cola de sincronización local SQLite que guarda reportes e imágenes cuando la cuadrilla técnica opera en zonas sin cobertura de telefonía.
*   **Auditoría y Seguridad (Control de Fraudes):** Cámara nativa obligatoria y verificación de metadatos GPS EXIF de las capturas del antes/después.
*   **Validación Hidráulica Dinámica:** Botón de "Validar Presión" que consulta en vivo los data loggers a través de la API para confirmar el sellado de la red.

## Estructura del Proyecto
El proyecto sigue el patrón **Clean Architecture / Feature-First** especificado en el diseño de ingeniería.