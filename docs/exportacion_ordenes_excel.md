# Exportación de órdenes realizadas

En el perfil de supervisor, abrir **O.S. → Exportar Excel**. La aplicación
consulta las órdenes al servidor, genera un archivo `.xlsx` y abre el diálogo
del dispositivo para guardarlo o compartirlo. El archivo facilita la copia
manual de datos a SYSCO.

Se exportan todas las órdenes con estado `COMPLETADO`, además de las
`ARCHIVADO` que tengan una fecha de finalización válida. Se excluyen las
órdenes con un reporte local pendiente de sincronización. Cada ID de orden
aparece una sola vez, en orden ascendente de finalización; las órdenes sin
fecha quedan al final.

## Columnas principales

| Columna | Dato de HYDRA |
| --- | --- |
| Ítem | Número correlativo dentro del archivo |
| N.º de orden | Número de orden, conservado como texto |
| Fecha | Día de finalización del trabajo |
| Motivo | Descripción del tipo de problema del catálogo; código original si no está disponible |
| Acción | Trabajo ejecutado registrado por el gasfitero |
| Dirección | Dirección del reclamo |
| Reporta | Nombre del solicitante |
| Ejecuta | Responsable de la orden y apoyos de la cuadrilla, sin repetir personas |

A la derecha se incluyen cuadrilla, suministro, código de solicitud,
descripción del reclamo, inicio, finalización, insumos, problemas, soluciones,
comentarios, observaciones, chofer, estado e ID de HYDRA.

Las fechas del servidor con zona horaria se convierten al horario de Perú
(UTC-5). Las fechas históricas sin zona se conservan como hora local. Los
datos ausentes quedan vacíos. Los números de orden y códigos se almacenan
como texto para preservar ceros iniciales. Los textos ingresados por los
usuarios se escriben como valores literales.

El archivo tiene una sola hoja, filtros en todas las columnas y la primera
fila y las dos primeras columnas inmovilizadas. La generación se ejecuta
fuera del hilo de interfaz. Si la consulta al servidor falla, se informa el
error y se permite reintentar.
