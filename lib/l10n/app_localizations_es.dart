// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get comun_guardar => 'Guardar';

  @override
  String get comun_cancelar => 'Cancelar';

  @override
  String get comun_eliminar => 'Eliminar';

  @override
  String get comun_confirmar => 'Confirmar';

  @override
  String comun_error(Object message) {
    return 'Ha ocurrido un error: $message';
  }

  @override
  String get comun_cargando => 'Cargando...';

  @override
  String get comun_miembros => 'Miembros';

  @override
  String get comun_deposito => 'Depósito';

  @override
  String get comun_umbrales => 'Umbrales';

  @override
  String get comun_abandonar => 'Abandonar';

  @override
  String get logo_nombre => 'AquaSteward';

  @override
  String get logo_slogan => 'Monitoreo Inteligente del Agua';

  @override
  String get button_inicio => 'Inicio';

  @override
  String get button_perfil => 'Perfil';

  @override
  String get dialogo_salida =>
      '¿Estás seguro de que quieres salir de este espacio?';

  @override
  String get dialogo_salida_titulo => 'Salir de AquaSteward';

  @override
  String get dialogo_eliminar_deposito =>
      '¿Estás seguro de que deseas eliminar este depósito?';

  @override
  String get dialogo_eliminar_deposito_titulo => 'Eliminar depósito';

  @override
  String get dialogo_eliminar_cuenta =>
      '¿Estás seguro de que deseas eliminar tu cuenta?';

  @override
  String get dialogo_eliminar_cuenta_titulo => 'Eliminar cuenta';

  @override
  String get dialogo_cerrar_sesion =>
      '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get dialogo_cerrar_sesion_titulo => 'Cerrar sesión';

  @override
  String get dialogo_presiona_nuevamente_salir => 'Desliza de nuevo para salir';

  @override
  String get titulo_dashboard => 'Mis Depósitos';

  @override
  String get titulo_soporte => 'Soporte';

  @override
  String get titulo_acerca_de => 'Acerca de';

  @override
  String get titulo_perfil => 'Mi perfil';

  @override
  String get titulo_manual_usuario => 'Manual de usuario';

  @override
  String get titulo_contactar_soporte => 'Contactar Soporte';

  @override
  String get titulo_reportes => 'Reportes';

  @override
  String get titulo_alertas => 'Notificaciones';

  @override
  String titulo_detalles_sensor(Object sensorName) {
    return 'Detalles de $sensorName';
  }

  @override
  String get titulo_vista_previa_pdf => 'Vista Previa de Reporte';

  @override
  String get titulo_reporte_pdf => 'Reporte de AquaSteward';

  @override
  String get titulo_qr => 'Escanear Código QR';

  @override
  String get auth_iniciar_sesion => 'Iniciar sesión';

  @override
  String get auth_registrarse => 'Registrarse';

  @override
  String get auth_correo => 'Correo electrónico';

  @override
  String get auth_contrasena => 'Contraseña';

  @override
  String get auth_nombre => 'Nombre';

  @override
  String get auth_apellido => 'Apellido';

  @override
  String get auth_olvido_contrasena => '¿Olvidaste tu contraseña?';

  @override
  String get auth_no_tiene_cuenta => '¿No tienes cuenta?';

  @override
  String get auth_tiene_cuenta => '¿Tienes cuenta?';

  @override
  String get auth_confirmar_codigo => 'Confirmar código';

  @override
  String get auth_ingresa_codigo =>
      'Ingresa el código de confirmación enviado a tu correo electrónico.';

  @override
  String get auth_no_recibiste => '¿No lo recibiste?';

  @override
  String get auth_reenviar => 'Reenviar';

  @override
  String get auth_cambiar_contrasena => 'Cambiar contraseña';

  @override
  String get perfil_titulo => 'Mi perfil';

  @override
  String get perfil_nombre => 'Nombre';

  @override
  String get perfil_apellido => 'Apellido';

  @override
  String get perfil_ajustes_cuenta => 'Configuración de Cuenta';

  @override
  String get perfil_personalizacion => 'Personalización';

  @override
  String get perfil_tema_idioma => 'Tema e Idioma';

  @override
  String get perfil_cambiar_contrasenia => 'Cambiar contraseña';

  @override
  String perfil_cambiar_dialogo_titulo(Object field) {
    return 'Cambiar $field';
  }

  @override
  String get perfil_editar_titulo => 'Editar perfil';

  @override
  String get perfil_tema => 'Tema';

  @override
  String get perfil_tema_sistema => 'Sistema';

  @override
  String get perfil_tema_claro => 'Claro';

  @override
  String get perfil_tema_oscuro => 'Oscuro';

  @override
  String get perfil_idioma => 'Idioma';

  @override
  String get perfil_espanol => 'Español';

  @override
  String get perfil_ingles => 'Inglés';

  @override
  String get dashboard_titulo => 'Mis Depósitos';

  @override
  String get dashboard_estado => 'Estado:';

  @override
  String get dashboard_sin_depositos => 'No hay depósitos agregados';

  @override
  String get sensor_nivel => 'Nivel';

  @override
  String get sensor_ph => 'pH';

  @override
  String get sensor_turbidez => 'Turbidez';

  @override
  String sensor_valor_pantalla(Object sensorName, Object value) {
    return 'El valor de $sensorName es $value';
  }

  @override
  String get soporte_titulo => 'Soporte';

  @override
  String get soporte_manual => 'Manual de usuario';

  @override
  String get soporte_acerca_de => 'Acerca de';

  @override
  String get soporte_preguntas_frecuentes => 'Preguntas Frecuentes';

  @override
  String get soporte_faq_p1 => '1. ¿Qué significa la turbidez del agua?';

  @override
  String get soporte_faq_r1 =>
      'La turbidez indica la cantidad de partículas presentes en el agua. Un valor alto puede afectar la calidad.';

  @override
  String get soporte_faq_p2 => '2. ¿Qué significa el pH del agua?';

  @override
  String get soporte_faq_r2 =>
      'El pH indica la acidez o alcalinidad del agua. Un valor alto puede afectar la calidad.';

  @override
  String get soporte_faq_p3 =>
      '3. ¿Por qué recibo notificaciones de nivel de agua?';

  @override
  String get soporte_faq_r3 =>
      'Se envían alertas cuando el nivel se acerca al límite establecido en la configuración.';

  @override
  String get soporte_faq_p4 => '4. ¿Cómo ajusto los límites y umbrales?';

  @override
  String get soporte_faq_r4 =>
      'Ve a la sección Ajustes, mueve los controles deslizantes y guarda los cambios.';

  @override
  String get soporte_faq_p5 => '5. ¿Qué hago si no recibo notificaciones?';

  @override
  String get soporte_faq_r5 =>
      'Verifica tu conexión y que las notificaciones estén activadas tanto en la app como en el sistema operativo.';

  @override
  String get soporte_faq_p6 =>
      '6. ¿Con qué frecuencia se actualizan las lecturas?';

  @override
  String get soporte_faq_r6 =>
      'Los sensores envían datos en tiempo real, con un tiempo de actualización de 1 minuto.';

  @override
  String get soporte_contacto_ayuda => '¿Necesitas más ayuda?';

  @override
  String get soporte_contacto_desc =>
      'Si no encontraste lo que buscabas, nuestro equipo de soporte técnico está listo para ayudarte.';

  @override
  String get soporte_contacto_boton => 'Contactar Soporte';

  @override
  String get manual_guia_basica => 'Guía básica';

  @override
  String get manual_roles_titulo => '1. Roles y Colaboración';

  @override
  String get manual_roles_desc =>
      'AquaSteward permite que varias personas supervisen los mismos depósitos. Según tu rol, tendrás diferentes permisos:\n\n• Propietario: Control total del espacio. Es el único que puede ceder la propiedad a otra persona o eliminar el entorno completo.\n• Administrador: Puede agregar, configurar y eliminar depósitos. También tiene permiso para invitar a nuevos miembros, asignarles roles o eliminarlos del grupo.\n• Analista: Su función es el monitoreo activo. Puede visualizar lecturas, alertas y generar reportes, pero no puede modificar la configuración de los depósitos ni gestionar usuarios.';

  @override
  String get manual_agregar_titulo => '2. Cómo agregar un nuevo Depósito';

  @override
  String get manual_agregar_desc =>
      'Si tienes el rol de Administrador o Propietario, puedes registrar un nuevo punto de monitoreo siguiendo estos pasos:\n\n1. Ve a la sección Depósitos en el menú principal.\n2. Presiona el botón de agregar (+).\n3. Identificación: Asigna un nombre (ej. \"Tanque Principal\") y una dirección física.\n4. Conexión: Ingresa la dirección IP de tu dispositivo ESP32 para vincularlo.\n5. Configuración: Define la capacidad máxima del contenedor y los sensores que tiene instalados (Nivel, pH, Turbidez).\n6. Límites: Establece los rangos de alerta (mínimos y máximos) para recibir notificaciones si el agua sale de los niveles seguros.';

  @override
  String get manual_invitaciones_titulo => '3. Gestión de Invitaciones';

  @override
  String get manual_invitaciones_desc =>
      'Para trabajar en conjunto y monitorear los mismos depósitos, el Propietario o el Administrador deben invitar a los nuevos integrantes:\n\nEnviar invitación: Desde la sección de usuarios, ingresa el correo electrónico de la persona que deseas agregar y asígnale un rol (Analista o Administrador).\n\nRegistro: El invitado recibirá un correo con un enlace seguro. Solo debe seguir ese enlace para crear su cuenta y unirse automáticamente a tu entorno.\n\nControl de accesos: Como Administrador o Propietario, puedes eliminar el acceso de cualquier usuario o modificar su rol en cualquier momento desde esta misma sección.';

  @override
  String get manual_monitoreo_titulo => '4. Monitoreo Inteligente';

  @override
  String get manual_monitoreo_desc =>
      'Una vez configurado, el Panel de Control te mostrará el estado de salud del agua:\n\n• Lecturas: Valores actualizados de los sensores.\n• Alertas: Si un valor sale de los rangos configurados, verás una notificación crítica en la campana de alertas.\n• Reportes: Puedes consultar el historial de días anteriores y exportarlo en formato digital si necesitas compartirlo o realizar un análisis externo.';

  @override
  String get contacto_titulo => 'Contacto';

  @override
  String get contacto_formulario => 'Formulario de Contacto';

  @override
  String get contacto_asunto => 'Asunto';

  @override
  String get contacto_mensaje => 'Mensaje';

  @override
  String get contacto_enviar => 'Enviar Mensaje';

  @override
  String get reporte_periodo => 'Periodo del reporte';

  @override
  String get reporte_filtro_dia => 'Día';

  @override
  String get reporte_filtro_semana => 'Semana';

  @override
  String get reporte_filtro_mes => 'Mes';

  @override
  String get reporte_seleccionar_fecha => 'Seleccionar fecha';

  @override
  String get reporte_abrir_calendario => 'Toque para abrir calendario';

  @override
  String get reporte_metricas => 'Métricas y Visualización';

  @override
  String get reporte_estadisticas => 'Estadísticas promedio';

  @override
  String get reporte_tendencias => 'Visualización de tendencias';

  @override
  String get reporte_cumplimiento => 'Porcentaje de Cumplimiento';

  @override
  String get reporte_grafico_pastel => 'Gráfico de Pastel';

  @override
  String get reporte_estabilidad => 'Estabilidad';

  @override
  String get reporte_grafico_medidor => 'Gráfico de Medidor (Gauge)';

  @override
  String get reporte_total_alertas => 'Total de Alertas';

  @override
  String get reporte_resumen_numerico => 'Resumen numérico';

  @override
  String get reporte_eventos_criticos => 'Eventos Críticos';

  @override
  String get reporte_tabla_logs => 'Tabla detallada de logs';

  @override
  String get reporte_generar_pdf => 'Generar PDF';

  @override
  String get reporte_exportar_csv => 'Exportar CSV';

  @override
  String get cantidad_eventos_criticos => 'Cantidad de eventos críticos';

  @override
  String get reporte_nota_tema =>
      'Nota: El color de las gráficas se adaptarán al tema seleccionado dentro del PDF.';

  @override
  String get alertas_filtro_todos => 'Todos';

  @override
  String get alertas_filtro_invitaciones => 'Equipo';

  @override
  String get alertas_filtro_nivel => 'Nivel';

  @override
  String get alertas_filtro_ph => 'pH';

  @override
  String get alertas_filtro_turbidez => 'Turbidez';

  @override
  String get alertas_sin_notificaciones => 'Sin notificaciones';

  @override
  String get alertas_sin_invitaciones => 'Sin novedades de equipo';

  @override
  String get alertas_filtro_alertas => 'Alertas';

  @override
  String get alertas_marcar_leidas => 'Marcar todas como leídas';

  @override
  String get alertas_eliminar_todas => 'Eliminar todas';

  @override
  String get alertas_invitacion_titulo => 'Invitación a depósito';

  @override
  String alertas_invitacion_descripcion(Object name, Object role) {
    return 'Has sido invitado a colaborar en el depósito $name como $role.';
  }

  @override
  String alertas_rol_asignado(Object role) {
    return 'Rol asignado: $role';
  }

  @override
  String get miembros_filtro_invitaciones => 'Invitaciones';

  @override
  String get miembros_rol_admin => 'Administrador';

  @override
  String get miembros_rol_propietario => 'Propietario';

  @override
  String get miembros_rol_analista => 'Analista';

  @override
  String get umbrales_medidas_deposito => 'Medidas del depósito';

  @override
  String get umbrales_medidas_desc =>
      'Valores necesarios para calcular el nivel del depósito.';

  @override
  String get umbrales_capacidad => 'Capacidad del depósito';

  @override
  String get umbrales_altura => 'Altura del depósito';

  @override
  String get umbrales_espacio_sensor => 'Espacio entre sensor y depósito';

  @override
  String get umbrales_desc =>
      'Si los valores son sobrepasados, se enviará una notificación.';

  @override
  String get umbrales_nivel_permitido => 'Nivel permitido';

  @override
  String get umbrales_ph_optimo => 'pH óptimo';

  @override
  String get umbrales_turbidez_maxima => 'Turbidez máxima';

  @override
  String get deposito_sensores_instalados => 'Sensores instalados';

  @override
  String get deposito_sensor_nivel_nombre => 'Sensor de nivel';

  @override
  String get deposito_sensor_turbidez_nombre => 'Sensor de turbidez';

  @override
  String get deposito_sensor_ph_nombre => 'Sensor de pH';

  @override
  String get deposito_sensor_nivel_desc => 'Sensor HC-SR04';

  @override
  String get deposito_sensor_turbidez_desc => 'Sensor TS300B';

  @override
  String get deposito_sensor_ph_desc => 'Sensor PH-4502C';

  @override
  String get snackbar_invitacion_aceptada => 'Invitación aceptada exitosamente';

  @override
  String get snackbar_invitacion_rechazada => 'Invitación rechazada';

  @override
  String get snackbar_abandonar_deposito => 'Abandonó con éxito el depósito';

  @override
  String get snackbar_alertas_activas => 'Recibirás lecturas y alertas';

  @override
  String get snackbar_alertas_inactivas => 'No recibirás lecturas y alertas';

  @override
  String get snackbar_deposito_creado => 'Depósito creado exitosamente';

  @override
  String get snackbar_deposito_actualizado =>
      'Depósito actualizado exitosamente';

  @override
  String get snackbar_deposito_eliminado => 'Depósito eliminado exitosamente';

  @override
  String get snackbar_alertas_eliminadas =>
      'Se eliminaron todas las notificaciones';

  @override
  String get snackbar_miembro_eliminado => 'Se eliminó el miembro exitosamente';

  @override
  String get snackbar_contrasena_restablecida =>
      'Contraseña restablecida exitosamente';

  @override
  String get snackbar_usuario_registrado => 'Usuario registrado exitosamente';

  @override
  String get snackbar_inicio_sesion_exitoso => 'Inicio de sesión exitoso';

  @override
  String get snackbar_error_correo =>
      'Error: No se pudo abrir la aplicación de correo';

  @override
  String get snackbar_csv_exportando => 'Exportando datos, por favor espera...';

  @override
  String get snackbar_usuario_eliminado => 'Usuario eliminado exitosamente';

  @override
  String snackbar_csv_error(String message) {
    return 'Error: $message';
  }

  @override
  String get snackbar_csv_sin_datos =>
      'Error: No hay datos disponibles para el rango y sensores seleccionados.';

  @override
  String get snackbar_perfil_actualizado => 'Perfil actualizado';

  @override
  String get snackbar_miembro_invitado_exitoso =>
      'Miembro invitado exitosamente';

  @override
  String get deposito_info_kit => 'Información del kit';

  @override
  String get deposito_ingresa_ip => 'Ingresa la IP del kit de agua';

  @override
  String get deposito_ip_label => 'IP';

  @override
  String get deposito_ingresa_nombre =>
      'Ingresa el nombre identificador del depósito de agua';

  @override
  String get detalles_tab_registros => 'Registros';

  @override
  String get detalles_tab_reportes => 'Reportes';

  @override
  String get detalles_historial => 'Historial';

  @override
  String get detalles_capacidad => 'Capacidad';

  @override
  String get detalles_diario => 'Día';

  @override
  String get detalles_semanal => 'Semana';

  @override
  String get detalles_mensual => 'Mes';

  @override
  String get validar_campo_requerido => 'Campo requerido';

  @override
  String get validar_numero_invalido => 'Número inválido';

  @override
  String get validar_correo_invalido => 'Correo inválido';

  @override
  String get validar_contrasena_invalida =>
      'Contraseña no cumple los requisitos';

  @override
  String get validar_ip_invalida => 'IP inválida';

  @override
  String acerca_version(String version, String build) {
    return 'Versión $version (Build $build)';
  }

  @override
  String get acerca_proposito_titulo => 'Propósito';

  @override
  String get acerca_proposito_desc =>
      'AquaSteward es un sistema diseñado para el monitoreo del nivel y calidad del agua en tiempo real mediante tecnología IoT, promoviendo una gestión eficiente y responsable del recurso hídrico.';

  @override
  String get acerca_creditos_titulo => 'Créditos y Desarrollo';

  @override
  String get acerca_creditos_desarrollado_por => 'Desarrollado por:';

  @override
  String get acerca_creditos_institucion => 'Institución:';

  @override
  String get acerca_creditos_universidad => 'Universidad Linda Vista';

  @override
  String get acerca_creditos_facultad => 'Facultad:';

  @override
  String get acerca_creditos_facultad_nombre =>
      'Ingeniería en Desarollo de Software';

  @override
  String get acerca_software_titulo => 'Licencias';

  @override
  String get acerca_software_licencias => 'Licencias de Código Abierto';

  @override
  String get tiempo_ahora => 'Ahora';

  @override
  String tiempo_hace_minutos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count minutos',
      one: 'Hace 1 minuto',
    );
    return '$_temp0';
  }

  @override
  String tiempo_hace_horas(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count horas',
      one: 'Hace 1 hora',
    );
    return '$_temp0';
  }

  @override
  String tiempo_hace_dias(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count días',
      one: 'Hace 1 día',
    );
    return '$_temp0';
  }

  @override
  String tiempo_hace_semanas(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count semanas',
      one: 'Hace 1 semana',
    );
    return '$_temp0';
  }

  @override
  String tiempo_hace_meses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count meses',
      one: 'Hace 1 mes',
    );
    return '$_temp0';
  }

  @override
  String get csv_dialogo_titulo => 'Exportar CSV';

  @override
  String get csv_seleccionar_sensores => 'Selecciona los sensores a exportar:';

  @override
  String get csv_rango_temporal => 'Rango temporal:';

  @override
  String get csv_rango_dia => 'Hoy';

  @override
  String get csv_rango_semana => 'Semana actual';

  @override
  String get csv_rango_mes => 'Mes actual';

  @override
  String get csv_todos => 'Todos los sensores';

  @override
  String get estado_error_lectura => 'Error de lectura';

  @override
  String get estado_muy_acido => 'Muy ácido';

  @override
  String get estado_acido => 'Ácido';

  @override
  String get estado_optimo => 'Óptimo';

  @override
  String get estado_alcalino => 'Alcalino';

  @override
  String get estado_muy_alcalino => 'Muy alcalino';

  @override
  String get estado_ideal => 'Ideal';

  @override
  String get estado_aceptable => 'Aceptable';

  @override
  String get estado_turbio => 'Turbio';

  @override
  String get estado_muy_turbio => 'Muy turbio';
}
