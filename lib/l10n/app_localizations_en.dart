// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get comun_guardar => 'Save';

  @override
  String get comun_cancelar => 'Cancel';

  @override
  String get comun_eliminar => 'Delete';

  @override
  String get comun_confirmar => 'Confirm';

  @override
  String comun_error(Object message) {
    return 'An error occurred: $message';
  }

  @override
  String get comun_cargando => 'Loading...';

  @override
  String get logo_nombre => 'AquaSteward';

  @override
  String get logo_slogan => 'Smart Water Monitoring';

  @override
  String get button_inicio => 'Home';

  @override
  String get button_perfil => 'Profile';

  @override
  String get titulo_dashboard => 'My Deposits';

  @override
  String get titulo_soporte => 'Support';

  @override
  String get titulo_acerca_de => 'About';

  @override
  String get titulo_perfil => 'My profile';

  @override
  String get titulo_manual_usuario => 'User manual';

  @override
  String get titulo_contactar_soporte => 'Contact Support';

  @override
  String get titulo_reportes => 'Generate Reports';

  @override
  String get titulo_miembros => 'Manage Members';

  @override
  String get titulo_alertas => 'Notifications';

  @override
  String get titulo_agregar_deposito => 'Add Deposit';

  @override
  String titulo_detalles_sensor(Object sensorName) {
    return '$sensorName Details';
  }

  @override
  String get titulo_configurar_umbrales => 'Configure Thresholds';

  @override
  String get titulo_vista_previa_pdf => 'Report Preview';

  @override
  String get titulo_reporte_pdf => 'AquaSteward Report';

  @override
  String get titulo_qr => 'Scan QR Code';

  @override
  String get auth_iniciar_sesion => 'Sign In';

  @override
  String get auth_registrarse => 'Sign Up';

  @override
  String get auth_correo => 'Email';

  @override
  String get auth_contrasena => 'Password';

  @override
  String get auth_nombre => 'Name';

  @override
  String get auth_apellido => 'Last Name';

  @override
  String get auth_olvido_contrasena => 'Forgot your password?';

  @override
  String get auth_no_tiene_cuenta => 'Don\'t have an account?';

  @override
  String get auth_tiene_cuenta => 'Already have an account?';

  @override
  String get auth_confirmar_codigo => 'Confirm code';

  @override
  String get auth_ingresa_codigo =>
      'Enter the confirmation code sent to your email.';

  @override
  String get auth_no_recibiste => 'Didn\'t receive it?';

  @override
  String get auth_reenviar => 'Resend';

  @override
  String get auth_cambiar_contrasena => 'Change password';

  @override
  String get perfil_titulo => 'My profile';

  @override
  String get perfil_info_personal => 'Personal Information';

  @override
  String get perfil_nombre => 'Name';

  @override
  String get perfil_apellido => 'Last Name';

  @override
  String get perfil_ajustes_cuenta => 'Account Settings';

  @override
  String get perfil_personalizacion => 'Customization';

  @override
  String get perfil_tema_idioma => 'Theme and Language';

  @override
  String get perfil_cambiar_contrasenia => 'Change password';

  @override
  String get perfil_cerrar_sesion => 'Logout';

  @override
  String perfil_cambiar_dialogo_titulo(Object field) {
    return 'Change $field';
  }

  @override
  String get perfil_tema => 'Theme';

  @override
  String get perfil_tema_sistema => 'System';

  @override
  String get perfil_tema_claro => 'Light';

  @override
  String get perfil_tema_oscuro => 'Dark';

  @override
  String get perfil_idioma => 'Language';

  @override
  String get perfil_espanol => 'Spanish';

  @override
  String get perfil_ingles => 'English';

  @override
  String get dashboard_titulo => 'My Deposits';

  @override
  String get dashboard_sin_depositos => 'No deposits added';

  @override
  String get dashboard_menu_miembros => 'Members';

  @override
  String get dashboard_menu_umbrales => 'Edit thresholds';

  @override
  String get dashboard_menu_editar => 'Edit deposit';

  @override
  String get sensor_nivel => 'Level';

  @override
  String get sensor_ph => 'pH';

  @override
  String get sensor_turbidez => 'Turbidity';

  @override
  String sensor_valor_pantalla(Object sensorName, Object value) {
    return 'The value of $sensorName is $value';
  }

  @override
  String get soporte_titulo => 'Support';

  @override
  String get soporte_recursos => 'Resources and information';

  @override
  String get soporte_manual => 'User manual';

  @override
  String get soporte_acerca_de => 'About';

  @override
  String get soporte_preguntas_frecuentes => 'Frequently Asked Questions';

  @override
  String get soporte_faq_p1 => '1. What does water turbidity mean?';

  @override
  String get soporte_faq_r1 =>
      'Turbidity indicates the amount of particles present in the water. A high value can affect quality.';

  @override
  String get soporte_faq_p2 => '2. What does water pH mean?';

  @override
  String get soporte_faq_r2 =>
      'pH indicates the acidity or alkalinity of the water. A high value can affect quality.';

  @override
  String get soporte_faq_p3 => '3. Why do I receive water level notifications?';

  @override
  String get soporte_faq_r3 =>
      'Alerts are sent when the level approaches the limit set in the configuration.';

  @override
  String get soporte_faq_p4 => '4. How do I adjust limits and thresholds?';

  @override
  String get soporte_faq_r4 =>
      'Go to the Settings section, move the sliders and save the changes.';

  @override
  String get soporte_faq_p5 => '5. What if I don\'t receive notifications?';

  @override
  String get soporte_faq_r5 =>
      'Check your connection and that notifications are enabled in both the app and the operating system.';

  @override
  String get soporte_faq_p6 => '6. How often are readings updated?';

  @override
  String get soporte_faq_r6 =>
      'Sensors send data in real time, with an update time of 1 minute.';

  @override
  String get soporte_contacto_ayuda => 'Need more help?';

  @override
  String get soporte_contacto_desc =>
      'If you didn\'t find what you were looking for, our technical support team is ready to help.';

  @override
  String get soporte_contacto_boton => 'Contact Support';

  @override
  String get manual_guia_basica => 'Basic guide';

  @override
  String get manual_roles_titulo => '1. Roles and Collaboration';

  @override
  String get manual_roles_desc =>
      'AquaSteward allows several people to monitor the same deposits. Depending on your role, you will have different permissions:\n\n• Owner: Total control of the space. They are the only ones who can assign ownership to another person or delete the entire environment.\n• Admin: Can add, configure and delete deposits. They also have permission to invite new members, assign roles or remove them from the group.\n• Analyst: Their role is active monitoring. They can view readings, alerts and generate reports, but they cannot modify the configuration of the deposits or manage users.';

  @override
  String get manual_agregar_titulo => '2. How to add a new Deposit';

  @override
  String get manual_agregar_desc =>
      'If you have the Admin or Owner role, you can register a new monitoring point following these steps:\n\n1. Go to the Deposits section in the main menu.\n2. Press the add button (+).\n3. Identification: Assign a name (e.g. \"Main Tank\") and a physical address.\n4. Connection: Enter the IP address of your ESP32 device to link it.\n5. Configuration: Define the maximum capacity of the container and the sensors it has installed (Level, pH, Turbidity).\n6. Limits: Set the alert ranges (minimum and maximum) to receive notifications if the water goes out of safe levels.';

  @override
  String get manual_invitaciones_titulo => '3. Invitation Management';

  @override
  String get manual_invitaciones_desc =>
      'To work together and monitor the same deposits, the Owner or the Admin must invite the new members:\n\nSend invitation: From the users section, enter the email address of the person you want to add and assign them a role (Analyst or Admin).\n\nRegistration: The guest will receive an email with a secure link. They just have to follow that link to create their account and automatically join your environment.\n\nAccess control: As an Admin or Owner, you can remove access from any user or modify their role at any time from this same section.';

  @override
  String get manual_monitoreo_titulo => '4. Intelligent Monitoring';

  @override
  String get manual_monitoreo_desc =>
      'Once configured, the Control Panel will show you the health status of the water:\n\n• Readings: Updated sensor values.\n• Alerts: If a value exceeds the configured ranges, you will see a critical notification in the alert bell.\n• Reports: You can check the history of previous days and export it in digital format if you need to share it or perform an external analysis.';

  @override
  String get contacto_titulo => 'Contact';

  @override
  String get contacto_formulario => 'Contact Form';

  @override
  String get contacto_asunto => 'Subject';

  @override
  String get contacto_mensaje => 'Message';

  @override
  String get contacto_enviar => 'Send Message';

  @override
  String get reporte_periodo => 'Report period';

  @override
  String get reporte_seleccionar_fechas => 'Select dates';

  @override
  String get reporte_abrir_calendario => 'Tap to open calendar';

  @override
  String get reporte_metricas => 'Metrics and Visualization';

  @override
  String get reporte_estadisticas => 'Statistics (Min, Max, Avg)';

  @override
  String get reporte_tendencias => 'Trend visualization';

  @override
  String get reporte_cumplimiento => 'Compliance Percentage';

  @override
  String get reporte_grafico_pastel => 'Pie Chart';

  @override
  String get reporte_estabilidad => 'Stability';

  @override
  String get reporte_grafico_medidor => 'Gauge Chart';

  @override
  String get reporte_total_alertas => 'Total Alerts';

  @override
  String get reporte_resumen_numerico => 'Numerical summary';

  @override
  String get reporte_eventos_criticos => 'Critical Events';

  @override
  String get reporte_tabla_logs => 'Detailed logs table';

  @override
  String get reporte_generar_pdf => 'Generate PDF';

  @override
  String get reporte_exportar_csv => 'Export CSV';

  @override
  String get alertas_filtro_todos => 'All';

  @override
  String get alertas_filtro_nivel => 'Level';

  @override
  String get alertas_filtro_ph => 'pH';

  @override
  String get alertas_filtro_turbidez => 'Turbidity';

  @override
  String get alertas_sin_notificaciones => 'No notifications';

  @override
  String get alertas_filtro_invitaciones => 'Invitations';

  @override
  String get alertas_sin_invitaciones => 'No invitations';

  @override
  String get alertas_filtro_alertas => 'Alerts';

  @override
  String get alertas_invitacion_titulo => 'Invitation to deposit';

  @override
  String alertas_invitacion_descripcion(Object name) {
    return 'You have an invitation to join this deposit $name.';
  }

  @override
  String alertas_rol_asignado(Object role) {
    return 'Assigned role: $role';
  }

  @override
  String get miembros_filtro_miembros => 'Members';

  @override
  String get miembros_filtro_invitaciones => 'Invitations';

  @override
  String get miembros_rol_admin => 'Admin';

  @override
  String get miembros_rol_propietario => 'Owner';

  @override
  String get miembros_rol_analista => 'Analyst';

  @override
  String get umbrales_medidas_deposito => 'Deposit measurements';

  @override
  String get umbrales_medidas_desc =>
      'Values needed to calculate the deposit level.';

  @override
  String get umbrales_capacidad => 'Deposit capacity';

  @override
  String get umbrales_altura => 'Deposit height';

  @override
  String get umbrales_espacio_sensor => 'Space between sensor and deposit';

  @override
  String get umbrales_titulo => 'Thresholds';

  @override
  String get umbrales_desc =>
      'If values are exceeded, a notification will be sent.';

  @override
  String get umbrales_nivel_permitido => 'Allowed level';

  @override
  String get umbrales_ph_optimo => 'Optimal pH';

  @override
  String get umbrales_turbidez_maxima => 'Maximum turbidity';

  @override
  String get deposito_sensores_instalados => 'Installed sensors';

  @override
  String get deposito_sensor_nivel_nombre => 'Level sensor';

  @override
  String get deposito_sensor_turbidez_nombre => 'Turbidity sensor';

  @override
  String get deposito_sensor_ph_nombre => 'pH sensor';

  @override
  String get deposito_sensor_nivel_desc => 'HC-SR04 Sensor';

  @override
  String get deposito_sensor_turbidez_desc => 'TS300B Sensor';

  @override
  String get deposito_sensor_ph_desc => 'PH-4502C Sensor';

  @override
  String get snackbar_invitacion_aceptada => 'Invitation accepted successfully';

  @override
  String get snackbar_invitacion_rechazada => 'Invitation rejected';

  @override
  String get snackbar_alertas_activas => 'You will receive readings and alerts';

  @override
  String get snackbar_alertas_inactivas =>
      'You will not receive readings and alerts';

  @override
  String get snackbar_deposito_creado => 'Deposit successfully created';

  @override
  String get snackbar_deposito_actualizado => 'Deposit successfully updated';

  @override
  String get snackbar_deposito_eliminado => 'Deposit successfully deleted';

  @override
  String get snackbar_alertas_eliminadas => 'All notifications were deleted';

  @override
  String get snackbar_miembro_eliminado =>
      'The member was successfully removed';

  @override
  String get snackbar_contrasena_restablecida => 'Password successfully reset';

  @override
  String get snackbar_usuario_registrado => 'User successfully registered';

  @override
  String get snackbar_inicio_sesion_exitoso => 'Login successful';

  @override
  String get snackbar_error_correo => 'Could not open email application';

  @override
  String get snackbar_perfil_actualizado => 'Profile successfully updated';

  @override
  String get snackbar_miembro_invitado_exitoso => 'Member successfully invited';

  @override
  String get deposito_info_kit => 'Kit information';

  @override
  String get deposito_ingresa_ip => 'Enter the water kit IP';

  @override
  String get deposito_ip_label => 'IP';

  @override
  String get deposito_ingresa_nombre =>
      'Enter the identifier name of the water deposit';

  @override
  String get deposito_nombre_label => 'Deposit';

  @override
  String get detalles_tab_registros => 'Records';

  @override
  String get detalles_tab_reportes => 'Reports';

  @override
  String get detalles_historial => 'History';

  @override
  String get detalles_diario => 'Day';

  @override
  String get detalles_semanal => 'Week';

  @override
  String get detalles_mensual => 'Month';

  @override
  String get validar_campo_requerido => 'Field required';

  @override
  String get validar_numero_invalido => 'Invalid number';

  @override
  String get validar_correo_invalido => 'Invalid email';

  @override
  String get validar_contrasena_invalida =>
      'Password must have at least 8 characters, one uppercase, one lowercase, one number and one special character';

  @override
  String get validar_ip_invalida => 'Invalid IP';

  @override
  String acerca_version(String version, String build) {
    return 'Version $version (Build $build)';
  }

  @override
  String get acerca_proposito_titulo => 'Purpose';

  @override
  String get acerca_proposito_desc =>
      'AquaSteward is a system designed for monitoring water level and quality in real time using IoT technology, promoting efficient and responsible management of water resources.';

  @override
  String get acerca_creditos_titulo => 'Credits and Development';

  @override
  String get acerca_creditos_desarrollado_por => 'Developed by:';

  @override
  String get acerca_creditos_institucion => 'Institution:';

  @override
  String get acerca_creditos_universidad => 'Linda Vista University';

  @override
  String get acerca_creditos_facultad => 'Faculty:';

  @override
  String get acerca_creditos_facultad_nombre =>
      'Software Development Engineering';

  @override
  String get acerca_legal_titulo => 'Legal and Privacy';

  @override
  String get acerca_legal_terminos => 'Terms and Conditions';

  @override
  String get acerca_legal_privacidad => 'Privacy Policy';

  @override
  String get acerca_software_titulo => 'Open Source Licenses';

  @override
  String get acerca_software_licencias => 'Open Source Licenses';
}
