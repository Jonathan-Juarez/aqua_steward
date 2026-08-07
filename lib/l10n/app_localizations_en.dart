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
  String get comun_miembros => 'Members';

  @override
  String get comun_deposito => 'Deposit';

  @override
  String get comun_umbrales => 'Thresholds';

  @override
  String get comun_abandonar => 'Leave';

  @override
  String comun_rango(Object max, Object min, Object unit) {
    return 'Range: $min - $max $unit';
  }

  @override
  String get logo_nombre => 'AquaSteward';

  @override
  String get logo_slogan => 'Smart Water Monitoring';

  @override
  String get button_inicio => 'Home';

  @override
  String get button_perfil => 'Profile';

  @override
  String get red_sin_conexion => 'No internet connection';

  @override
  String get red_conexion_restaurada => 'Internet connection restored';

  @override
  String get dialogo_salida => 'Are you sure you want to leave this space?';

  @override
  String get dialogo_salida_titulo => 'Leave AquaSteward';

  @override
  String get dialogo_eliminar_deposito =>
      'Are you sure you want to delete this deposit?';

  @override
  String get dialogo_eliminar_deposito_titulo => 'Delete deposit';

  @override
  String get dialogo_eliminar_cuenta =>
      'Are you sure you want to delete your account?';

  @override
  String get dialogo_eliminar_cuenta_titulo => 'Delete account';

  @override
  String get dialogo_cerrar_sesion => 'Are you sure you want to log out?';

  @override
  String get dialogo_cerrar_sesion_titulo => 'Logout';

  @override
  String get dialogo_presiona_nuevamente_salir => 'Swipe again to exit';

  @override
  String get tech_panel_titulo => 'Technician Panel';

  @override
  String get tech_usuarios => 'Users';

  @override
  String get tech_depositos => 'Deposits';

  @override
  String get tech_sensores_activos => 'Active Sensors';

  @override
  String get tech_estado_sistema => 'Infrastructure Status';

  @override
  String get tech_ver_usuarios => 'Global User Management';

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
  String get titulo_reportes => 'Reports';

  @override
  String get titulo_alertas => 'Notifications';

  @override
  String titulo_detalles_sensor(Object sensorName) {
    return '$sensorName Details';
  }

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
  String perfil_cambiar_dialogo_titulo(Object field) {
    return 'Change $field';
  }

  @override
  String get perfil_editar_titulo => 'Edit profile';

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
  String get dashboard_estado => 'State:';

  @override
  String get dashboard_sin_depositos => 'No deposits added';

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
  String get manual_roles_titulo => '1. Deposit Roles and Permissions';

  @override
  String get manual_roles_desc =>
      'AquaSteward organizes collaboration across 3 hierarchical roles:\n• Analyst: Active monitoring. Can view readings, logs, and alerts, consult team members, generate reports, and export logs.\n• Admin: Includes Analyst permissions, plus the ability to edit deposit settings, manage members (invite and remove users), and manage notifications.\n• Owner: Includes all previous permissions and is the only role authorized to delete the deposit.';

  @override
  String get manual_agregar_titulo => '2. How to add a new Deposit';

  @override
  String get manual_agregar_desc =>
      'Any user can register a new water deposit:\n1. Go to the Deposits section and tap the add button (+).\n2. General Data: Enter the name and location of the deposit.\n3. Sensors: Configure installed sensors (Level, pH, Turbidity).\n4. Alert Ranges: Set minimum and maximum thresholds to receive alerts when values exceed safety parameters.';

  @override
  String get manual_invitaciones_titulo => '3. Member & Invitation Management';

  @override
  String get manual_invitaciones_desc =>
      'To collaborate on deposit monitoring:\n• Send Invitation: The Owner or Admin enters a user\'s email and assigns a role (Admin or Analyst).\n• Respond to Invitation: The invited user receives an in-app notification to accept or decline the request.\n• Team Management: Admins and Owners can update roles or remove members from the Members section.';

  @override
  String get manual_monitoreo_titulo => '4. Monitoring, Alerts & Reports';

  @override
  String get manual_monitoreo_desc =>
      'Comprehensive water quality supervision:\n• Readings & Logs: Check real-time status and historical data for level, pH, and turbidity.\n• Alerts: Receive and manage notifications whenever a reading exceeds configured safety ranges.\n• Reports: Generate status reports and export logs for analysis or auditing.';

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
  String get reporte_filtro_dia => 'Day';

  @override
  String get reporte_filtro_semana => 'Week';

  @override
  String get reporte_filtro_mes => 'Month';

  @override
  String get reporte_seleccionar_fecha => 'Select date';

  @override
  String get reporte_abrir_calendario => 'Tap to open calendar';

  @override
  String get reporte_metricas => 'Metrics and Visualization';

  @override
  String get reporte_estadisticas => 'Average statistics';

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
  String get cantidad_eventos_criticos => 'Number of critical events';

  @override
  String get reporte_nota_tema =>
      'Note: The color of the graphics will adapt to the theme selected within the PDF.';

  @override
  String get alertas_filtro_todos => 'All';

  @override
  String get alertas_filtro_invitaciones => 'Team';

  @override
  String get alertas_filtro_nivel => 'Level';

  @override
  String get alertas_filtro_ph => 'pH';

  @override
  String get alertas_filtro_turbidez => 'Turbidity';

  @override
  String get alertas_sin_notificaciones => 'No notifications';

  @override
  String get alertas_sin_invitaciones => 'No team updates';

  @override
  String get alertas_filtro_alertas => 'Alerts';

  @override
  String get alertas_marcar_leidas => 'Mark all as read';

  @override
  String get alertas_eliminar_todas => 'Delete all';

  @override
  String get alertas_invitacion_titulo => 'Invitation to deposit';

  @override
  String alertas_invitacion_descripcion(Object name, Object role) {
    return 'You have been invited to collaborate in the deposit $name as $role.';
  }

  @override
  String alertas_rol_asignado(Object role) {
    return 'Assigned role: $role';
  }

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
  String get snackbar_abandonar_deposito => 'Successfully left the deposit';

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
  String get snackbar_error_correo => 'Error: Could not open email application';

  @override
  String get snackbar_csv_exportando => 'Exporting data, please wait...';

  @override
  String get snackbar_usuario_eliminado => 'User successfully deleted';

  @override
  String snackbar_csv_error(String message) {
    return 'Error: $message';
  }

  @override
  String get snackbar_csv_sin_datos =>
      'Error: No data available for the selected range and sensors.';

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
  String get detalles_tab_registros => 'Records';

  @override
  String get detalles_tab_reportes => 'Reports';

  @override
  String get detalles_historial => 'History';

  @override
  String get detalles_capacidad => 'Capacity';

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
      'Password does not meet requirements';

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
      'AquaSteward is a system designed for monitoring water level and quality in real time using Internet of Things, promoting efficient and responsible management of water resources.';

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
  String get acerca_software_titulo => 'Licenses';

  @override
  String get acerca_software_licencias => 'Open Source Licenses';

  @override
  String get acerca_privacidad_titulo => 'Privacy Policy';

  @override
  String get acerca_privacidad_subtitulo =>
      'Information regarding data management and protection';

  @override
  String get privacidad_introduccion =>
      'This privacy notice establishes AquaSteward\'s commitment to protecting information, transparently explaining how personal data is handled, stored, and protected on the platform.';

  @override
  String get privacidad_sec1_titulo => '1. What information is collected?';

  @override
  String get privacidad_sec1_desc =>
      'To provide water monitoring and management features, the application collects the following information provided by the user when registering and setting up the system:\n• Account Data: Full name, email address, and securely encrypted password.\n• Tank and IoT Device Data: Tank names, physical dimensions, alert thresholds, and the IP address of the sensor kit.\n• Water Quality Readings: Periodic measurements of water level, pH, and turbidity.\n• Team Data: Email addresses and invitations to collaborate with other members under specific roles (owner, administrator, or analyst).';

  @override
  String get privacidad_sec2_titulo => '2. How is the information used?';

  @override
  String get privacidad_sec2_desc =>
      'The information obtained is used exclusively for the internal operation of the platform, specifically to:\n• Display the status of water tanks, both in real-time and in historical logs.\n• Issue alert notifications upon critical variations in level, pH, or turbidity.\n• Manage access permissions and control for team members.\n• Enable the generation of detailed PDF reports and CSV exports.';

  @override
  String get privacidad_sec3_titulo => '3. Data Sharing and Privacy Practices';

  @override
  String get privacidad_sec3_desc =>
      'AquaSteward does not sell, rent, or share personal data with analytics companies, ad networks, or other third parties for commercial purposes.\n\nTo guarantee this privacy, the platform establishes the following operational restrictions:\n• Does not use tracking cookies or tools to track user behavior outside the application.\n• Does not collect precise real-time GPS location data under any circumstances.\n• Does not use Artificial Intelligence (AI) technologies aimed at profiling.\n\nThe only external application integration is with Firebase Cloud Messaging (Google). This technical connection is strictly necessary and used exclusively to send real-time push notifications to the device, whether when water parameters exceed configured limits or when updates occur in a shared tank.';

  @override
  String get privacidad_firebase_link => 'Firebase (Google) Privacy Policy';

  @override
  String get privacidad_sec4_titulo => '4. Data Retention and User Rights';

  @override
  String get privacidad_sec4_desc =>
      'Personal data is retained only while the user\'s account remains active. The information owner has full control over their data and possesses the following rights:\n• Access and Update: It is possible to view or update profile and tank information directly from application settings.\n• Deletion: Users can delete their account directly from the application, which permanently removes all associated data from the system.';

  @override
  String get privacidad_sec5_titulo => '5. Information Security';

  @override
  String get privacidad_sec5_desc =>
      'Rigorous technical security measures are implemented to protect data against unauthorized access. This includes encrypted password storage using secure hash algorithms (bcrypt) and data transmission encrypted in transit using secure protocols (HTTPS, WebSockets).';

  @override
  String get privacidad_sec6_titulo => '6. Advertising';

  @override
  String get privacidad_sec6_desc =>
      'AquaSteward is designed to be a clean and functional tool; therefore, it contains no advertisements of any kind.';

  @override
  String get privacidad_sec7_titulo => '7. Changes to this policy';

  @override
  String get privacidad_sec7_desc =>
      'This Privacy Policy may be updated or modified as necessary. Any significant modification will be notified within the application and the updated text will be reflected in this section.';

  @override
  String get privacidad_sec8_titulo => '8. Contact';

  @override
  String get privacidad_sec8_desc =>
      'For any questions regarding this Privacy Policy or data processing, contact: jonathan.juarez@ulv.edu.mx';

  @override
  String get tiempo_ahora => 'Just now';

  @override
  String tiempo_hace_minutos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String tiempo_hace_horas(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String tiempo_hace_dias(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String tiempo_hace_semanas(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks ago',
      one: '1 week ago',
    );
    return '$_temp0';
  }

  @override
  String tiempo_hace_meses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months ago',
      one: '1 month ago',
    );
    return '$_temp0';
  }

  @override
  String get csv_dialogo_titulo => 'Export CSV';

  @override
  String get csv_seleccionar_sensores => 'Select sensors to export:';

  @override
  String get csv_rango_temporal => 'Time range:';

  @override
  String get csv_rango_dia => 'Today';

  @override
  String get csv_rango_semana => 'Current week';

  @override
  String get csv_rango_mes => 'Current month';

  @override
  String get csv_todos => 'All sensors';

  @override
  String get estado_error_lectura => 'Reading error';

  @override
  String get estado_muy_acido => 'Very acidic';

  @override
  String get estado_acido => 'Acidic';

  @override
  String get estado_optimo => 'Optimal';

  @override
  String get estado_alcalino => 'Alkaline';

  @override
  String get estado_muy_alcalino => 'Very alkaline';

  @override
  String get estado_ideal => 'Ideal';

  @override
  String get estado_aceptable => 'Acceptable';

  @override
  String get estado_turbio => 'Turbid';

  @override
  String get estado_muy_turbio => 'Very turbid';
}
