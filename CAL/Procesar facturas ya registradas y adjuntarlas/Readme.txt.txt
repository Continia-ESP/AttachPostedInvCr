Pasos a seguir:
1. Importar el objeto PostedPurchInv
2. Ejecutar el asistente de configuración de DC e importar el archivo Setup.xml
3. Si se ha cambiado el ID de la codeunit hay que entrar en la plantilla maestra de la nueva configuración HISTFAC y cambiar la codeunit de registro y poner la que se acaba de importar.
4. Enviar un documento a la nueva clasificación
5. Importar el nuevo documento
6. Se debería reconocer el proveedor automáticamente, en caso de no hacerlo, asignar proveedor de forma manual.
7. Si el Nº de factura del proveedor no se ha reconocido automáticamente, seleccionarlo de forma manual
8. Registrar documento
9. Ir al histórico de facturas de comprar y comprobar que la factura con Nº factura proveedor capturado en el paso 7 tiene ahora adjunto el documento.
