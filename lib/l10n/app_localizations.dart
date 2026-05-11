import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @comun_guardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get comun_guardar;

  /// No description provided for @comun_cancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get comun_cancelar;

  /// No description provided for @comun_eliminar.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get comun_eliminar;

  /// No description provided for @comun_confirmar.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get comun_confirmar;

  /// No description provided for @comun_error.
  ///
  /// In es, this message translates to:
  /// **'Ha ocurrido un error: {message}'**
  String comun_error(Object message);

  /// No description provided for @comun_cargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get comun_cargando;

  /// No description provided for @logo_nombre.
  ///
  /// In es, this message translates to:
  /// **'AquaSteward'**
  String get logo_nombre;

  /// No description provided for @logo_slogan.
  ///
  /// In es, this message translates to:
  /// **'Monitoreo Inteligente del Agua'**
  String get logo_slogan;

  /// No description provided for @button_inicio.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get button_inicio;

  /// No description provided for @button_perfil.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get button_perfil;

  /// No description provided for @titulo_dashboard.
  ///
  /// In es, this message translates to:
  /// **'Mis Depósitos'**
  String get titulo_dashboard;

  /// No description provided for @titulo_soporte.
  ///
  /// In es, this message translates to:
  /// **'Soporte'**
  String get titulo_soporte;

  /// No description provided for @titulo_acerca_de.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get titulo_acerca_de;

  /// No description provided for @titulo_perfil.
  ///
  /// In es, this message translates to:
  /// **'Mi perfil'**
  String get titulo_perfil;

  /// No description provided for @titulo_manual_usuario.
  ///
  /// In es, this message translates to:
  /// **'Manual de usuario'**
  String get titulo_manual_usuario;

  /// No description provided for @titulo_contactar_soporte.
  ///
  /// In es, this message translates to:
  /// **'Contactar Soporte'**
  String get titulo_contactar_soporte;

  /// No description provided for @titulo_reportes.
  ///
  /// In es, this message translates to:
  /// **'Generar Reportes'**
  String get titulo_reportes;

  /// No description provided for @titulo_miembros.
  ///
  /// In es, this message translates to:
  /// **'Gestionar Miembros'**
  String get titulo_miembros;

  /// No description provided for @titulo_alertas.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get titulo_alertas;

  /// No description provided for @titulo_agregar_deposito.
  ///
  /// In es, this message translates to:
  /// **'Agregar Depósito'**
  String get titulo_agregar_deposito;

  /// No description provided for @titulo_detalles_sensor.
  ///
  /// In es, this message translates to:
  /// **'Detalles de {sensorName}'**
  String titulo_detalles_sensor(Object sensorName);

  /// No description provided for @titulo_configurar_umbrales.
  ///
  /// In es, this message translates to:
  /// **'Configurar Umbrales'**
  String get titulo_configurar_umbrales;

  /// No description provided for @titulo_vista_previa_pdf.
  ///
  /// In es, this message translates to:
  /// **'Vista Previa de Reporte'**
  String get titulo_vista_previa_pdf;

  /// No description provided for @titulo_reporte_pdf.
  ///
  /// In es, this message translates to:
  /// **'Reporte de AquaSteward'**
  String get titulo_reporte_pdf;

  /// No description provided for @titulo_qr.
  ///
  /// In es, this message translates to:
  /// **'Escanear Código QR'**
  String get titulo_qr;

  /// No description provided for @auth_iniciar_sesion.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get auth_iniciar_sesion;

  /// No description provided for @auth_registrarse.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get auth_registrarse;

  /// No description provided for @auth_correo.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get auth_correo;

  /// No description provided for @auth_contrasena.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get auth_contrasena;

  /// No description provided for @auth_nombre.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get auth_nombre;

  /// No description provided for @auth_apellido.
  ///
  /// In es, this message translates to:
  /// **'Apellido'**
  String get auth_apellido;

  /// No description provided for @auth_olvido_contrasena.
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get auth_olvido_contrasena;

  /// No description provided for @auth_no_tiene_cuenta.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta?'**
  String get auth_no_tiene_cuenta;

  /// No description provided for @auth_tiene_cuenta.
  ///
  /// In es, this message translates to:
  /// **'¿Tienes cuenta?'**
  String get auth_tiene_cuenta;

  /// No description provided for @auth_confirmar_codigo.
  ///
  /// In es, this message translates to:
  /// **'Confirmar código'**
  String get auth_confirmar_codigo;

  /// No description provided for @auth_ingresa_codigo.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el código de confirmación enviado a tu correo electrónico.'**
  String get auth_ingresa_codigo;

  /// No description provided for @auth_no_recibiste.
  ///
  /// In es, this message translates to:
  /// **'¿No lo recibiste?'**
  String get auth_no_recibiste;

  /// No description provided for @auth_reenviar.
  ///
  /// In es, this message translates to:
  /// **'Reenviar'**
  String get auth_reenviar;

  /// No description provided for @auth_cambiar_contrasena.
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña'**
  String get auth_cambiar_contrasena;

  /// No description provided for @perfil_titulo.
  ///
  /// In es, this message translates to:
  /// **'Mi perfil'**
  String get perfil_titulo;

  /// No description provided for @perfil_info_personal.
  ///
  /// In es, this message translates to:
  /// **'Información Personal'**
  String get perfil_info_personal;

  /// No description provided for @perfil_nombre.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get perfil_nombre;

  /// No description provided for @perfil_apellido.
  ///
  /// In es, this message translates to:
  /// **'Apellido'**
  String get perfil_apellido;

  /// No description provided for @perfil_ajustes_cuenta.
  ///
  /// In es, this message translates to:
  /// **'Configuración de Cuenta'**
  String get perfil_ajustes_cuenta;

  /// No description provided for @perfil_personalizacion.
  ///
  /// In es, this message translates to:
  /// **'Personalización'**
  String get perfil_personalizacion;

  /// No description provided for @perfil_tema_idioma.
  ///
  /// In es, this message translates to:
  /// **'Tema e Idioma'**
  String get perfil_tema_idioma;

  /// No description provided for @perfil_cambiar_contrasenia.
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña'**
  String get perfil_cambiar_contrasenia;

  /// No description provided for @perfil_cerrar_sesion.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get perfil_cerrar_sesion;

  /// No description provided for @perfil_cambiar_dialogo_titulo.
  ///
  /// In es, this message translates to:
  /// **'Cambiar {field}'**
  String perfil_cambiar_dialogo_titulo(Object field);

  /// No description provided for @perfil_tema.
  ///
  /// In es, this message translates to:
  /// **'Tema'**
  String get perfil_tema;

  /// No description provided for @perfil_tema_sistema.
  ///
  /// In es, this message translates to:
  /// **'Sistema'**
  String get perfil_tema_sistema;

  /// No description provided for @perfil_tema_claro.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get perfil_tema_claro;

  /// No description provided for @perfil_tema_oscuro.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get perfil_tema_oscuro;

  /// No description provided for @perfil_idioma.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get perfil_idioma;

  /// No description provided for @perfil_espanol.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get perfil_espanol;

  /// No description provided for @perfil_ingles.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get perfil_ingles;

  /// No description provided for @dashboard_titulo.
  ///
  /// In es, this message translates to:
  /// **'Mis Depósitos'**
  String get dashboard_titulo;

  /// No description provided for @dashboard_sin_depositos.
  ///
  /// In es, this message translates to:
  /// **'No hay depósitos agregados'**
  String get dashboard_sin_depositos;

  /// No description provided for @dashboard_menu_miembros.
  ///
  /// In es, this message translates to:
  /// **'Miembros'**
  String get dashboard_menu_miembros;

  /// No description provided for @dashboard_menu_umbrales.
  ///
  /// In es, this message translates to:
  /// **'Editar umbrales'**
  String get dashboard_menu_umbrales;

  /// No description provided for @dashboard_menu_editar.
  ///
  /// In es, this message translates to:
  /// **'Editar depósito'**
  String get dashboard_menu_editar;

  /// No description provided for @sensor_nivel.
  ///
  /// In es, this message translates to:
  /// **'Nivel'**
  String get sensor_nivel;

  /// No description provided for @sensor_ph.
  ///
  /// In es, this message translates to:
  /// **'pH'**
  String get sensor_ph;

  /// No description provided for @sensor_turbidez.
  ///
  /// In es, this message translates to:
  /// **'Turbidez'**
  String get sensor_turbidez;

  /// No description provided for @sensor_valor_pantalla.
  ///
  /// In es, this message translates to:
  /// **'El valor de {sensorName} es {value}'**
  String sensor_valor_pantalla(Object sensorName, Object value);

  /// No description provided for @soporte_titulo.
  ///
  /// In es, this message translates to:
  /// **'Soporte'**
  String get soporte_titulo;

  /// No description provided for @soporte_recursos.
  ///
  /// In es, this message translates to:
  /// **'Recursos e información'**
  String get soporte_recursos;

  /// No description provided for @soporte_manual.
  ///
  /// In es, this message translates to:
  /// **'Manual de usuario'**
  String get soporte_manual;

  /// No description provided for @soporte_acerca_de.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get soporte_acerca_de;

  /// No description provided for @soporte_preguntas_frecuentes.
  ///
  /// In es, this message translates to:
  /// **'Preguntas Frecuentes'**
  String get soporte_preguntas_frecuentes;

  /// No description provided for @soporte_faq_p1.
  ///
  /// In es, this message translates to:
  /// **'1. ¿Qué significa la turbidez del agua?'**
  String get soporte_faq_p1;

  /// No description provided for @soporte_faq_r1.
  ///
  /// In es, this message translates to:
  /// **'La turbidez indica la cantidad de partículas presentes en el agua. Un valor alto puede afectar la calidad.'**
  String get soporte_faq_r1;

  /// No description provided for @soporte_faq_p2.
  ///
  /// In es, this message translates to:
  /// **'2. ¿Qué significa el pH del agua?'**
  String get soporte_faq_p2;

  /// No description provided for @soporte_faq_r2.
  ///
  /// In es, this message translates to:
  /// **'El pH indica la acidez o alcalinidad del agua. Un valor alto puede afectar la calidad.'**
  String get soporte_faq_r2;

  /// No description provided for @soporte_faq_p3.
  ///
  /// In es, this message translates to:
  /// **'3. ¿Por qué recibo notificaciones de nivel de agua?'**
  String get soporte_faq_p3;

  /// No description provided for @soporte_faq_r3.
  ///
  /// In es, this message translates to:
  /// **'Se envían alertas cuando el nivel se acerca al límite establecido en la configuración.'**
  String get soporte_faq_r3;

  /// No description provided for @soporte_faq_p4.
  ///
  /// In es, this message translates to:
  /// **'4. ¿Cómo ajusto los límites y umbrales?'**
  String get soporte_faq_p4;

  /// No description provided for @soporte_faq_r4.
  ///
  /// In es, this message translates to:
  /// **'Ve a la sección Ajustes, mueve los controles deslizantes y guarda los cambios.'**
  String get soporte_faq_r4;

  /// No description provided for @soporte_faq_p5.
  ///
  /// In es, this message translates to:
  /// **'5. ¿Qué hago si no recibo notificaciones?'**
  String get soporte_faq_p5;

  /// No description provided for @soporte_faq_r5.
  ///
  /// In es, this message translates to:
  /// **'Verifica tu conexión y que las notificaciones estén activadas tanto en la app como en el sistema operativo.'**
  String get soporte_faq_r5;

  /// No description provided for @soporte_faq_p6.
  ///
  /// In es, this message translates to:
  /// **'6. ¿Con qué frecuencia se actualizan las lecturas?'**
  String get soporte_faq_p6;

  /// No description provided for @soporte_faq_r6.
  ///
  /// In es, this message translates to:
  /// **'Los sensores envían datos en tiempo real, con un tiempo de actualización de 1 minuto.'**
  String get soporte_faq_r6;

  /// No description provided for @soporte_contacto_ayuda.
  ///
  /// In es, this message translates to:
  /// **'¿Necesitas más ayuda?'**
  String get soporte_contacto_ayuda;

  /// No description provided for @soporte_contacto_desc.
  ///
  /// In es, this message translates to:
  /// **'Si no encontraste lo que buscabas, nuestro equipo de soporte técnico está listo para ayudarte.'**
  String get soporte_contacto_desc;

  /// No description provided for @soporte_contacto_boton.
  ///
  /// In es, this message translates to:
  /// **'Contactar Soporte'**
  String get soporte_contacto_boton;

  /// No description provided for @manual_guia_basica.
  ///
  /// In es, this message translates to:
  /// **'Guía básica'**
  String get manual_guia_basica;

  /// No description provided for @manual_roles_titulo.
  ///
  /// In es, this message translates to:
  /// **'1. Roles y Colaboración'**
  String get manual_roles_titulo;

  /// No description provided for @manual_roles_desc.
  ///
  /// In es, this message translates to:
  /// **'AquaSteward permite que varias personas supervisen los mismos depósitos. Según tu rol, tendrás diferentes permisos:\n\n• Propietario: Control total del espacio. Es el único que puede ceder la propiedad a otra persona o eliminar el entorno completo.\n• Administrador: Puede agregar, configurar y eliminar depósitos. También tiene permiso para invitar a nuevos miembros, asignarles roles o eliminarlos del grupo.\n• Analista: Su función es el monitoreo activo. Puede visualizar lecturas, alertas y generar reportes, pero no puede modificar la configuración de los depósitos ni gestionar usuarios.'**
  String get manual_roles_desc;

  /// No description provided for @manual_agregar_titulo.
  ///
  /// In es, this message translates to:
  /// **'2. Cómo agregar un nuevo Depósito'**
  String get manual_agregar_titulo;

  /// No description provided for @manual_agregar_desc.
  ///
  /// In es, this message translates to:
  /// **'Si tienes el rol de Administrador o Propietario, puedes registrar un nuevo punto de monitoreo siguiendo estos pasos:\n\n1. Ve a la sección Depósitos en el menú principal.\n2. Presiona el botón de agregar (+).\n3. Identificación: Asigna un nombre (ej. \"Tanque Principal\") y una dirección física.\n4. Conexión: Ingresa la dirección IP de tu dispositivo ESP32 para vincularlo.\n5. Configuración: Define la capacidad máxima del contenedor y los sensores que tiene instalados (Nivel, pH, Turbidez).\n6. Límites: Establece los rangos de alerta (mínimos y máximos) para recibir notificaciones si el agua sale de los niveles seguros.'**
  String get manual_agregar_desc;

  /// No description provided for @manual_invitaciones_titulo.
  ///
  /// In es, this message translates to:
  /// **'3. Gestión de Invitaciones'**
  String get manual_invitaciones_titulo;

  /// No description provided for @manual_invitaciones_desc.
  ///
  /// In es, this message translates to:
  /// **'Para trabajar en conjunto y monitorear los mismos depósitos, el Propietario o el Administrador deben invitar a los nuevos integrantes:\n\nEnviar invitación: Desde la sección de usuarios, ingresa el correo electrónico de la persona que deseas agregar y asígnale un rol (Analista o Administrador).\n\nRegistro: El invitado recibirá un correo con un enlace seguro. Solo debe seguir ese enlace para crear su cuenta y unirse automáticamente a tu entorno.\n\nControl de accesos: Como Administrador o Propietario, puedes eliminar el acceso de cualquier usuario o modificar su rol en cualquier momento desde esta misma sección.'**
  String get manual_invitaciones_desc;

  /// No description provided for @manual_monitoreo_titulo.
  ///
  /// In es, this message translates to:
  /// **'4. Monitoreo Inteligente'**
  String get manual_monitoreo_titulo;

  /// No description provided for @manual_monitoreo_desc.
  ///
  /// In es, this message translates to:
  /// **'Una vez configurado, el Panel de Control te mostrará el estado de salud del agua:\n\n• Lecturas: Valores actualizados de los sensores.\n• Alertas: Si un valor sale de los rangos configurados, verás una notificación crítica en la campana de alertas.\n• Reportes: Puedes consultar el historial de días anteriores y exportarlo en formato digital si necesitas compartirlo o realizar un análisis externo.'**
  String get manual_monitoreo_desc;

  /// No description provided for @contacto_titulo.
  ///
  /// In es, this message translates to:
  /// **'Contacto'**
  String get contacto_titulo;

  /// No description provided for @contacto_formulario.
  ///
  /// In es, this message translates to:
  /// **'Formulario de Contacto'**
  String get contacto_formulario;

  /// No description provided for @contacto_asunto.
  ///
  /// In es, this message translates to:
  /// **'Asunto'**
  String get contacto_asunto;

  /// No description provided for @contacto_mensaje.
  ///
  /// In es, this message translates to:
  /// **'Mensaje'**
  String get contacto_mensaje;

  /// No description provided for @contacto_enviar.
  ///
  /// In es, this message translates to:
  /// **'Enviar Mensaje'**
  String get contacto_enviar;

  /// No description provided for @reporte_periodo.
  ///
  /// In es, this message translates to:
  /// **'Periodo del reporte'**
  String get reporte_periodo;

  /// No description provided for @reporte_seleccionar_fechas.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar fechas'**
  String get reporte_seleccionar_fechas;

  /// No description provided for @reporte_abrir_calendario.
  ///
  /// In es, this message translates to:
  /// **'Toque para abrir calendario'**
  String get reporte_abrir_calendario;

  /// No description provided for @reporte_metricas.
  ///
  /// In es, this message translates to:
  /// **'Métricas y Visualización'**
  String get reporte_metricas;

  /// No description provided for @reporte_estadisticas.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas (Min, Max, Prom)'**
  String get reporte_estadisticas;

  /// No description provided for @reporte_tendencias.
  ///
  /// In es, this message translates to:
  /// **'Visualización de tendencias'**
  String get reporte_tendencias;

  /// No description provided for @reporte_cumplimiento.
  ///
  /// In es, this message translates to:
  /// **'Porcentaje de Cumplimiento'**
  String get reporte_cumplimiento;

  /// No description provided for @reporte_grafico_pastel.
  ///
  /// In es, this message translates to:
  /// **'Gráfico de Pastel'**
  String get reporte_grafico_pastel;

  /// No description provided for @reporte_estabilidad.
  ///
  /// In es, this message translates to:
  /// **'Estabilidad'**
  String get reporte_estabilidad;

  /// No description provided for @reporte_grafico_medidor.
  ///
  /// In es, this message translates to:
  /// **'Gráfico de Medidor (Gauge)'**
  String get reporte_grafico_medidor;

  /// No description provided for @reporte_total_alertas.
  ///
  /// In es, this message translates to:
  /// **'Total de Alertas'**
  String get reporte_total_alertas;

  /// No description provided for @reporte_resumen_numerico.
  ///
  /// In es, this message translates to:
  /// **'Resumen numérico'**
  String get reporte_resumen_numerico;

  /// No description provided for @reporte_eventos_criticos.
  ///
  /// In es, this message translates to:
  /// **'Eventos Críticos'**
  String get reporte_eventos_criticos;

  /// No description provided for @reporte_tabla_logs.
  ///
  /// In es, this message translates to:
  /// **'Tabla detallada de logs'**
  String get reporte_tabla_logs;

  /// No description provided for @reporte_generar_pdf.
  ///
  /// In es, this message translates to:
  /// **'Generar PDF'**
  String get reporte_generar_pdf;

  /// No description provided for @reporte_exportar_csv.
  ///
  /// In es, this message translates to:
  /// **'Exportar CSV'**
  String get reporte_exportar_csv;

  /// No description provided for @alertas_filtro_todos.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get alertas_filtro_todos;

  /// No description provided for @alertas_filtro_nivel.
  ///
  /// In es, this message translates to:
  /// **'Nivel'**
  String get alertas_filtro_nivel;

  /// No description provided for @alertas_filtro_ph.
  ///
  /// In es, this message translates to:
  /// **'pH'**
  String get alertas_filtro_ph;

  /// No description provided for @alertas_filtro_turbidez.
  ///
  /// In es, this message translates to:
  /// **'Turbidez'**
  String get alertas_filtro_turbidez;

  /// No description provided for @alertas_sin_notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Sin notificaciones'**
  String get alertas_sin_notificaciones;

  /// No description provided for @alertas_filtro_invitaciones.
  ///
  /// In es, this message translates to:
  /// **'Invitaciones'**
  String get alertas_filtro_invitaciones;

  /// No description provided for @alertas_sin_invitaciones.
  ///
  /// In es, this message translates to:
  /// **'Sin invitaciones'**
  String get alertas_sin_invitaciones;

  /// No description provided for @alertas_filtro_alertas.
  ///
  /// In es, this message translates to:
  /// **'Alertas'**
  String get alertas_filtro_alertas;

  /// No description provided for @alertas_invitacion_titulo.
  ///
  /// In es, this message translates to:
  /// **'Invitación a depósito'**
  String get alertas_invitacion_titulo;

  /// No description provided for @alertas_invitacion_descripcion.
  ///
  /// In es, this message translates to:
  /// **'Tienes una invitación para ser parte del depósito {name}.'**
  String alertas_invitacion_descripcion(Object name);

  /// No description provided for @alertas_rol_asignado.
  ///
  /// In es, this message translates to:
  /// **'Rol asignado: {role}'**
  String alertas_rol_asignado(Object role);

  /// No description provided for @miembros_filtro_miembros.
  ///
  /// In es, this message translates to:
  /// **'Miembros'**
  String get miembros_filtro_miembros;

  /// No description provided for @miembros_filtro_invitaciones.
  ///
  /// In es, this message translates to:
  /// **'Invitaciones'**
  String get miembros_filtro_invitaciones;

  /// No description provided for @miembros_rol_admin.
  ///
  /// In es, this message translates to:
  /// **'Administrador'**
  String get miembros_rol_admin;

  /// No description provided for @miembros_rol_propietario.
  ///
  /// In es, this message translates to:
  /// **'Propietario'**
  String get miembros_rol_propietario;

  /// No description provided for @miembros_rol_analista.
  ///
  /// In es, this message translates to:
  /// **'Analista'**
  String get miembros_rol_analista;

  /// No description provided for @umbrales_medidas_deposito.
  ///
  /// In es, this message translates to:
  /// **'Medidas del depósito'**
  String get umbrales_medidas_deposito;

  /// No description provided for @umbrales_medidas_desc.
  ///
  /// In es, this message translates to:
  /// **'Valores necesarios para calcular el nivel del depósito.'**
  String get umbrales_medidas_desc;

  /// No description provided for @umbrales_capacidad.
  ///
  /// In es, this message translates to:
  /// **'Capacidad del depósito'**
  String get umbrales_capacidad;

  /// No description provided for @umbrales_altura.
  ///
  /// In es, this message translates to:
  /// **'Altura del depósito'**
  String get umbrales_altura;

  /// No description provided for @umbrales_espacio_sensor.
  ///
  /// In es, this message translates to:
  /// **'Espacio entre sensor y depósito'**
  String get umbrales_espacio_sensor;

  /// No description provided for @umbrales_titulo.
  ///
  /// In es, this message translates to:
  /// **'Umbrales'**
  String get umbrales_titulo;

  /// No description provided for @umbrales_desc.
  ///
  /// In es, this message translates to:
  /// **'Si los valores son sobrepasados, se enviará una notificación.'**
  String get umbrales_desc;

  /// No description provided for @umbrales_nivel_permitido.
  ///
  /// In es, this message translates to:
  /// **'Nivel permitido'**
  String get umbrales_nivel_permitido;

  /// No description provided for @umbrales_ph_optimo.
  ///
  /// In es, this message translates to:
  /// **'pH óptimo'**
  String get umbrales_ph_optimo;

  /// No description provided for @umbrales_turbidez_maxima.
  ///
  /// In es, this message translates to:
  /// **'Turbidez máxima'**
  String get umbrales_turbidez_maxima;

  /// No description provided for @deposito_sensores_instalados.
  ///
  /// In es, this message translates to:
  /// **'Sensores instalados'**
  String get deposito_sensores_instalados;

  /// No description provided for @deposito_sensor_nivel_nombre.
  ///
  /// In es, this message translates to:
  /// **'Sensor de nivel'**
  String get deposito_sensor_nivel_nombre;

  /// No description provided for @deposito_sensor_turbidez_nombre.
  ///
  /// In es, this message translates to:
  /// **'Sensor de turbidez'**
  String get deposito_sensor_turbidez_nombre;

  /// No description provided for @deposito_sensor_ph_nombre.
  ///
  /// In es, this message translates to:
  /// **'Sensor de pH'**
  String get deposito_sensor_ph_nombre;

  /// No description provided for @deposito_sensor_nivel_desc.
  ///
  /// In es, this message translates to:
  /// **'Sensor HC-SR04'**
  String get deposito_sensor_nivel_desc;

  /// No description provided for @deposito_sensor_turbidez_desc.
  ///
  /// In es, this message translates to:
  /// **'Sensor TS300B'**
  String get deposito_sensor_turbidez_desc;

  /// No description provided for @deposito_sensor_ph_desc.
  ///
  /// In es, this message translates to:
  /// **'Sensor PH-4502C'**
  String get deposito_sensor_ph_desc;

  /// No description provided for @snackbar_invitacion_aceptada.
  ///
  /// In es, this message translates to:
  /// **'Invitación aceptada exitosamente'**
  String get snackbar_invitacion_aceptada;

  /// No description provided for @snackbar_invitacion_rechazada.
  ///
  /// In es, this message translates to:
  /// **'Invitación rechazada'**
  String get snackbar_invitacion_rechazada;

  /// No description provided for @snackbar_alertas_activas.
  ///
  /// In es, this message translates to:
  /// **'Recibirás lecturas y alertas'**
  String get snackbar_alertas_activas;

  /// No description provided for @snackbar_alertas_inactivas.
  ///
  /// In es, this message translates to:
  /// **'No recibirás lecturas y alertas'**
  String get snackbar_alertas_inactivas;

  /// No description provided for @snackbar_deposito_creado.
  ///
  /// In es, this message translates to:
  /// **'Depósito creado exitosamente'**
  String get snackbar_deposito_creado;

  /// No description provided for @snackbar_deposito_actualizado.
  ///
  /// In es, this message translates to:
  /// **'Depósito actualizado exitosamente'**
  String get snackbar_deposito_actualizado;

  /// No description provided for @snackbar_deposito_eliminado.
  ///
  /// In es, this message translates to:
  /// **'Depósito eliminado exitosamente'**
  String get snackbar_deposito_eliminado;

  /// No description provided for @snackbar_alertas_eliminadas.
  ///
  /// In es, this message translates to:
  /// **'Se eliminaron todas las notificaciones'**
  String get snackbar_alertas_eliminadas;

  /// No description provided for @snackbar_miembro_eliminado.
  ///
  /// In es, this message translates to:
  /// **'Se eliminó el miembro exitosamente'**
  String get snackbar_miembro_eliminado;

  /// No description provided for @snackbar_contrasena_restablecida.
  ///
  /// In es, this message translates to:
  /// **'Contraseña restablecida exitosamente'**
  String get snackbar_contrasena_restablecida;

  /// No description provided for @snackbar_usuario_registrado.
  ///
  /// In es, this message translates to:
  /// **'Usuario registrado exitosamente'**
  String get snackbar_usuario_registrado;

  /// No description provided for @snackbar_inicio_sesion_exitoso.
  ///
  /// In es, this message translates to:
  /// **'Inicio de sesión exitoso'**
  String get snackbar_inicio_sesion_exitoso;

  /// No description provided for @snackbar_error_correo.
  ///
  /// In es, this message translates to:
  /// **'No se pudo abrir la aplicación de correo'**
  String get snackbar_error_correo;

  /// No description provided for @snackbar_perfil_actualizado.
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado'**
  String get snackbar_perfil_actualizado;

  /// No description provided for @snackbar_miembro_invitado_exitoso.
  ///
  /// In es, this message translates to:
  /// **'Miembro invitado exitosamente'**
  String get snackbar_miembro_invitado_exitoso;

  /// No description provided for @deposito_info_kit.
  ///
  /// In es, this message translates to:
  /// **'Información del kit'**
  String get deposito_info_kit;

  /// No description provided for @deposito_ingresa_ip.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la IP del kit de agua'**
  String get deposito_ingresa_ip;

  /// No description provided for @deposito_ip_label.
  ///
  /// In es, this message translates to:
  /// **'IP'**
  String get deposito_ip_label;

  /// No description provided for @deposito_ingresa_nombre.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el nombre identificador del depósito de agua'**
  String get deposito_ingresa_nombre;

  /// No description provided for @deposito_nombre_label.
  ///
  /// In es, this message translates to:
  /// **'Depósito'**
  String get deposito_nombre_label;

  /// No description provided for @detalles_tab_registros.
  ///
  /// In es, this message translates to:
  /// **'Registros'**
  String get detalles_tab_registros;

  /// No description provided for @detalles_tab_reportes.
  ///
  /// In es, this message translates to:
  /// **'Reportes'**
  String get detalles_tab_reportes;

  /// No description provided for @detalles_historial.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get detalles_historial;

  /// No description provided for @detalles_diario.
  ///
  /// In es, this message translates to:
  /// **'Día'**
  String get detalles_diario;

  /// No description provided for @detalles_semanal.
  ///
  /// In es, this message translates to:
  /// **'Semana'**
  String get detalles_semanal;

  /// No description provided for @detalles_mensual.
  ///
  /// In es, this message translates to:
  /// **'Mes'**
  String get detalles_mensual;

  /// No description provided for @validar_campo_requerido.
  ///
  /// In es, this message translates to:
  /// **'Campo requerido'**
  String get validar_campo_requerido;

  /// No description provided for @validar_numero_invalido.
  ///
  /// In es, this message translates to:
  /// **'Número inválido'**
  String get validar_numero_invalido;

  /// No description provided for @validar_correo_invalido.
  ///
  /// In es, this message translates to:
  /// **'Correo inválido'**
  String get validar_correo_invalido;

  /// No description provided for @validar_contrasena_invalida.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un carácter especial'**
  String get validar_contrasena_invalida;

  /// No description provided for @validar_ip_invalida.
  ///
  /// In es, this message translates to:
  /// **'IP inválida'**
  String get validar_ip_invalida;

  /// No description provided for @acerca_version.
  ///
  /// In es, this message translates to:
  /// **'Versión {version} (Build {build})'**
  String acerca_version(String version, String build);

  /// No description provided for @acerca_proposito_titulo.
  ///
  /// In es, this message translates to:
  /// **'Propósito'**
  String get acerca_proposito_titulo;

  /// No description provided for @acerca_proposito_desc.
  ///
  /// In es, this message translates to:
  /// **'AquaSteward es un sistema diseñado para el monitoreo del nivel y calidad del agua en tiempo real mediante tecnología IoT, promoviendo una gestión eficiente y responsable del recurso hídrico.'**
  String get acerca_proposito_desc;

  /// No description provided for @acerca_creditos_titulo.
  ///
  /// In es, this message translates to:
  /// **'Créditos y Desarrollo'**
  String get acerca_creditos_titulo;

  /// No description provided for @acerca_creditos_desarrollado_por.
  ///
  /// In es, this message translates to:
  /// **'Desarrollado por:'**
  String get acerca_creditos_desarrollado_por;

  /// No description provided for @acerca_creditos_institucion.
  ///
  /// In es, this message translates to:
  /// **'Institución:'**
  String get acerca_creditos_institucion;

  /// No description provided for @acerca_creditos_universidad.
  ///
  /// In es, this message translates to:
  /// **'Universidad Linda Vista'**
  String get acerca_creditos_universidad;

  /// No description provided for @acerca_creditos_facultad.
  ///
  /// In es, this message translates to:
  /// **'Facultad:'**
  String get acerca_creditos_facultad;

  /// No description provided for @acerca_creditos_facultad_nombre.
  ///
  /// In es, this message translates to:
  /// **'Ingeniería en Desarollo de Software'**
  String get acerca_creditos_facultad_nombre;

  /// No description provided for @acerca_legal_titulo.
  ///
  /// In es, this message translates to:
  /// **'Legales y Privacidad'**
  String get acerca_legal_titulo;

  /// No description provided for @acerca_legal_terminos.
  ///
  /// In es, this message translates to:
  /// **'Términos y Condiciones'**
  String get acerca_legal_terminos;

  /// No description provided for @acerca_legal_privacidad.
  ///
  /// In es, this message translates to:
  /// **'Política de Privacidad'**
  String get acerca_legal_privacidad;

  /// No description provided for @acerca_software_titulo.
  ///
  /// In es, this message translates to:
  /// **'Licencias de Código Abierto'**
  String get acerca_software_titulo;

  /// No description provided for @acerca_software_licencias.
  ///
  /// In es, this message translates to:
  /// **'Licencias de Código Abierto'**
  String get acerca_software_licencias;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
