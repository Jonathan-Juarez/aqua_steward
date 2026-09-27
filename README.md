# Aqua Steward

AquaSteward es un sistema que resuelve la problemática de la mala gestión del agua, tanto en su desperdicio como en su calidad (pH y la turbidez). El monitoreo no lo realiza solo, sino que se le ofrece al usuario la capacidad de trabajar en conjunto con otros individuos mediante sus dispositivos móviles y acceso a internet, cada uno con un rol determinado (analista, administrador y propietario), por lo que el usuario objetivo no presenta limitaciones de edad o nivel educativo para su uso básico. Sin embargo, para el uso avanzado, es necesario que el usuario tenga conocimientos sobre la ciencia de datos y un nivel educativo medio superior en adelante.

## Características Principales
Las características principales, incluyendo las que se tienen planeadas a futuro, son:

- **Gestión de Depósitos:**
  - Crear, editar y eliminar depósitos de agua.
  - Descubrimiento automático de kits IoT en la red local mediante mDNS (Multicast DNS).
  - Configurar las dimensiones del depósito (capacidad, altura, espacio libre) y umbrales personalizados por sensor (nivel, pH y turbidez).
- **Monitoreo en Tiempo Real:**
  - Visualizar parámetros actuales de agua (Nivel, Turbidez, pH) mediante Socket.IO.
  - Historial de lecturas con filtrado por periodo (diario, semanal, mensual).
  - Componente visual interactivo de nivel tipo depósito con silueta y animación de oleaje senoidal.
- **Sistema de Alertas:**
  - Notificaciones al detectar parámetros fuera de los rangos seguros definidos.
  - Notificaciones push mediante Firebase Cloud Messaging.
  - Pantalla para la consulta de alertas activas.
- **Gestión de Equipos:**
  - Invitar usuarios a colaborar en un depósito con roles específicos (propietario, administrador, analista).
  - Flujo de invitaciones con estados (pendiente, aceptada, rechazada).
  - Administración de miembros del equipo.
- **Autenticación y Gestión de Usuarios:**
  - Sistema seguro de inicio de sesión, registro y recuperación de contraseñas.
  - Flujo de recuperación de contraseña con verificación por correo.
  - Perfil de usuario con edición de datos.
- **Visualización de Datos:**
  - Gráficos interactivos con `fl_chart` para visualizar la evolución de la calidad del agua.
  - Indicadores de progreso y nivel de depósito estilizados.
  - Detalles por parámetro y registros históricos.
- **Reportes en PDF:**
  - Generación, previsualización y exportación de reportes de estado detallados.
  - Captura de gráficos para inclusión en PDF.
- **Internacionalización:**
  - Soporte multilenguaje (español e inglés).
- **Personalización de Tema e Idioma:**
  - Selector de tema (sistema, claro, oscuro) e idioma directamente en el perfil.
- **Monitoreo de Conectividad:**
  - Detección automática de pérdida y restauración de internet.
  - SnackBar flotante al perder la conexión.
  - Recarga automática de depósitos al restaurar la conexión.
- **Soporte y Ayuda:**
  - Sección de preguntas frecuentes (FAQ), manual de usuario y contacto de soporte.

## Tecnologías

| Categoría              | Tecnología                                              |
| ---------------------- | ------------------------------------------------------- |
| Framework              | Flutter / Dart                                          |
| Gestión de Estado      | Provider                                                |
| Persistencia Local     | Shared Preferences, flutter_secure_storage              |
| Conectividad           | Socket.IO Client, HTTP, internet_connection_checker_plus |
| Notificaciones Push    | Firebase Cloud Messaging, flutter_local_notifications   |
| Visualización de Datos | fl_chart, PDF, Printing, Screenshot                     |
| Internacionalización   | intl, flutter_localizations                             |
| Descubrimiento de Red  | multicast_dns (mDNS / Zeroconf)                         |
| Permisos               | Permission Handler                                      |
| Utilidades             | URL Launcher, Package Info Plus                         |
| Diseño Visual          | Animate Do, Flutter Launcher Icons & Native Splash      |

## Prerrequisitos

- Flutter SDK (versión 3.38.7 o superior en canal `stable`)
- Dart SDK (versión 3.10.7 o superior, compatible con Dart SDK `^3.8.1` según `pubspec.yaml`)
- Un servidor backend en ejecución con los endpoints de la API definidos en `lib/core/network/global_variable.dart`.

## Cómo Empezar

1. Clonar el repositorio:
   ```bash
   git clone <url-del-repositorio>
   cd aqua_steward
   ```

2. Obtener dependencias:
   ```bash
   flutter pub get
   ```

3. Configurar variables de entorno:
   Asegúrate de que la URL del backend esté configurada correctamente en `lib/core/network/global_variable.dart`:
   ```dart
   const String uri = 'http://tu-ip-del-backend:puerto';
   ```

4. Configurar Firebase (Cloud Messaging / Notificaciones):
   Para que las notificaciones push y servicios de Firebase funcionen, debes enlazar tu proyecto de Firebase:
   - **Opción recomendada (automática con FlutterFire CLI):**
     ```bash
     flutterfire configure
     ```
     *(Esto generará automáticamente `lib/firebase_options.dart`, `android/app/google-services.json` y `ios/Runner/GoogleService-Info.plist`).*

   - **Opción manual:**
     - **Android**: Descarga `google-services.json` desde [Firebase Console](https://console.firebase.google.com/) (paquete `com.aquasteward.app`) y colócalo en `android/app/google-services.json`.
     - **iOS**: Descarga `GoogleService-Info.plist` y colócalo en `ios/Runner/GoogleService-Info.plist`.
     - **Dart**: Asegúrate de contar con el archivo de inicialización en `lib/firebase_options.dart`.

5. Configurar ícono y splash screen (Opcional):
   ```bash
   dart run flutter_launcher_icons
   dart run flutter_native_splash:create
   ```

6. Ejecutar la aplicación:
   Inicia la aplicación en un emulador o un dispositivo físico conectado:
   ```bash
   flutter run
   ```

## Estructura del Proyecto con Clean Architecture

El proyecto sigue los principios de Clean Architecture, organizando el código en capas modulares dentro de cada funcionalidad (feature) para maximizar la mantenibilidad, escalabilidad y la separación de responsabilidades.

```text
lib/
├── core/                    # Utilidades principales y configuraciones globales
│   ├── error/                       # Manejo de errores y excepciones
│   │   ├── exception_handler.dart          # Gestionador centralizado de excepciones
│   │   ├── result.dart                     # Envoltorio genérico para resultados (éxito/error)
│   │   └── result_handler.dart             # Gestión de resultados en la capa de presentación
│   ├── extensions/                  # Extensiones de Dart/Flutter
│   │   └── l10n_extensions.dart            # Extensiones de internacionalización
│   ├── network/                     # Conectividad (HTTP, Socket.IO, variables globales)
│   │   ├── api_client.dart                 # Cliente HTTP para la API
│   │   ├── global_variable.dart            # URL del backend y constantes de red
│   │   ├── manage_http_response.dart       # Gestión de respuestas HTTP
│   │   ├── network_validator.dart          # Validador de conectividad con SnackBar persistente
│   │   └── socket_service.dart             # Servicio de conexión Socket.IO
│   ├── permissions/                 # Lógica de permisos basada en roles
│   │   └── app_permission.dart             # Definición de permisos por rol de usuario
│   ├── router/                      # Enrutamiento y navegación
│   │   ├── app_navigator.dart              # Animación personalizada de navegación
│   │   ├── app_router.dart                 # Definición de rutas de la aplicación
│   │   └── imports.dart                    # Barrel de importaciones
│   ├── services/                    # Servicios nativos de plataforma
│   │   ├── network_discovery_service.dart  # Descubrimiento de kits mDNS en red local
│   │   └── notification_service.dart       # Servicio de notificaciones push FCM y locales
│   ├── storage/                     # Persistencia local (sesión, token, idioma, tema)
│   │   ├── language_storage.dart           # Persistencia y Provider de idioma
│   │   ├── secure_storage.dart             # Almacenamiento seguro del token JWT
│   │   ├── session_storage.dart            # Servicio global de gestión y expiración de sesión
│   │   └── theme_storage.dart              # Persistencia y Provider de tema
│   ├── theme/                       # Sistema de diseño visual
│   │   ├── app_border.dart                 # Bordes estándar
│   │   ├── app_color.dart                  # Paleta de colores
│   │   ├── app_divider.dart                # Divisores estándar
│   │   ├── app_icon.dart                   # Íconos de la aplicación
│   │   ├── app_padding.dart                # Espaciados estándar
│   │   ├── app_safe.dart                   # Áreas seguras (safe area)
│   │   ├── app_sizedbox.dart               # Cajas de tamaño estándar
│   │   ├── app_text.dart                   # Estilos de texto
│   │   └── app_theme.dart                  # Tema general (claro/oscuro)
│   ├── utils/                       # Validadores y servicios utilitarios
│   │   ├── app_validators.dart             # Validaciones de formularios
│   │   └── permission_service.dart         # Servicio de permisos del dispositivo
│   └── widgets/                     # Widgets reutilizables globales
│       ├── bottom_bar_format.dart          # Barra de navegación inferior
│       ├── button_format.dart              # Botones estilizados
│       ├── container_formart.dart          # Contenedores estilizados
│       ├── container_list_tile.dart        # List tiles personalizados
│       ├── dialog_emergent.dart            # Diálogos emergentes
│       ├── exit_confirmation_scope.dart    # Confirmación al salir
│       ├── filter_chip_format.dart         # Chips de filtro
│       ├── icon_format.dart                # Íconos estilizados
│       ├── linea_chart.dart                # Gráfico de líneas (fl_chart)
│       ├── list_view_format.dart           # ListView envolvente estilizado
│       ├── menu_button_format.dart         # Botones de menú
│       ├── scaffold_main.dart              # Scaffold principal con navegación
│       ├── snack_bar_format.dart           # Snackbars estilizados
│       ├── switch_format.dart              # Switches estilizados
│       ├── tab_bar_format.dart             # Tab bars estilizados
│       ├── text_field_format.dart          # Campos de texto estilizados
│       └── text_format.dart                # Textos estilizados
├── features/                # Módulos de funcionalidades independientes
│   ├── auth/                # Autenticación (login, registro, restablecimiento, perfil)
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository_impl.dart
│   │   │   └── sources/
│   │   │       └── auth_data_source.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository_interface.dart
│   │   │   └── usecases/
│   │   │       ├── reset_password_usecase.dart
│   │   │       ├── signin_usecase.dart
│   │   │       ├── signup_usecase.dart
│   │   │       └── update_user_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       ├── screens/
│   │       │   ├── confirmation_screen.dart
│   │       │   ├── forgot_password_screen.dart
│   │       │   ├── profile_screen.dart
│   │       │   ├── reset_password_screen.dart
│   │       │   ├── signin_screen.dart
│   │       │   ├── signup_screen.dart
│   │       │   └── start_screen.dart
│   │       └── widgets/
│   │           ├── dialog_profile.dart             # Diálogo de edición de perfil
│   │           ├── logo.dart
│   │           ├── password_requirements_widget.dart # Indicador de requisitos de contraseña
│   │           └── scaffold_account.dart
│   ├── deposit/             # Gestión de depósitos y sensores
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── deposit_model.dart
│   │   │   │   └── sensor_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── deposit_repository_impl.dart
│   │   │   └── sources/
│   │   │       └── deposit_data_source.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── deposit.dart
│   │   │   │   └── sensor.dart
│   │   │   ├── repositories/
│   │   │   │   └── deposit_repository_interface.dart
│   │   │   └── usecases/
│   │   │       ├── create_deposit_usecase.dart
│   │   │       ├── delete_deposit_usecase.dart
│   │   │       ├── get_deposits_usecase.dart
│   │   │       └── update_deposit_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── deposit_provider.dart
│   │       ├── screens/
│   │       │   ├── deposit_screen.dart             # Pantalla unificada de creación y edición
│   │       │   └── nearby_devices_screen.dart      # Descubrimiento y vinculación de kits locales
│   │       └── widgets/
│   │           ├── slider_format.dart              # Selector deslizable de valores
│   │           └── value_dialog.dart               # Diálogo de selección numérica de valor
│   ├── notification/        # Sistema de notificaciones push e historial de alertas
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── notification_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── notification_repository_impl.dart
│   │   │   └── sources/
│   │   │       └── notification_remote_data_source.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── notification.dart
│   │   │   ├── repositories/
│   │   │   │   └── notification_repository_interface.dart
│   │   │   └── usecases/
│   │   │       ├── delete_all_notifications_usecase.dart
│   │   │       ├── delete_notification_usecase.dart
│   │   │       ├── get_notifications_usecase.dart
│   │   │       ├── mark_notifications_as_read_usecase.dart
│   │   │       ├── register_fcm_token_usecase.dart
│   │   │       └── unregister_fcm_token_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── notification_provider.dart
│   │       ├── screens/
│   │       │   └── notification_screen.dart        # Centro de notificaciones y alertas
│   │       └── widgets/
│   │           └── formater_time.dart              # Formateo relativo de tiempo
│   ├── reading/             # Lecturas de sensores y dashboard de monitoreo
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── reading_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── reading_repository_impl.dart
│   │   │   └── sources/
│   │   │       └── reading_data_source.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── export_reading.dart
│   │   │   │   ├── reading.dart
│   │   │   │   └── report_stats.dart
│   │   │   ├── repositories/
│   │   │   │   └── reading_repository_interface.dart
│   │   │   └── usecases/
│   │   │       ├── export_readings_usecase.dart
│   │   │       ├── get_daily_readings_usecase.dart
│   │   │       └── get_reading_report_stats_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── reading_provider.dart
│   │       ├── screens/
│   │       │   ├── dashborad_screen.dart           # Panel principal de monitoreo
│   │       │   ├── main_navigation_screen.dart     # Pantalla raíz con navegación
│   │       │   ├── pdf_screen.dart
│   │       │   └── reports_screen.dart
│   │       └── widgets/
│   │           ├── circular_progress_parameters.dart
│   │           ├── deposit_card.dart               # Tarjeta de depósito con datos en tiempo real
│   │           ├── deposit_level.dart              # Nivel gráfico tipo depósito con ola animada
│   │           ├── dialog_export_csv.dart          # Diálogo de exportación CSV
│   │           └── state_parameters.dart           # Indicador visual de estado de parámetros
│   ├── support/             # Ayuda, soporte y contacto
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   │   └── contact_repository_impl.dart
│   │   │   └── sources/
│   │   │       └── contact_launcher_source.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   │   └── contact_repository_interface.dart
│   │   │   └── usecases/
│   │   │       └── send_email_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── contact_provider.dart
│   │       ├── screens/
│   │       │   ├── about_screen.dart
│   │       │   ├── contact_screen.dart
│   │       │   ├── privacy_policy_screen.dart      # Pantalla de políticas de privacidad
│   │       │   ├── support_screen.dart
│   │       │   └── user_manual.dart
│   │       └── widgets/
│   │           └── faq_item.dart
│   ├── team/                # Gestión de equipos e invitaciones
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── team_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── team_repository_impl.dart
│   │   │   └── sources/
│   │   │       └── team_data_source.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── team.dart
│   │   │   ├── repositories/
│   │   │   │   └── team_repository_interface.dart
│   │   │   └── usecases/
│   │   │       ├── accept_invitation_usecase.dart
│   │   │       ├── delete_member_usecase.dart
│   │   │       ├── get_invitations_usecase.dart
│   │   │       ├── get_members_usecase.dart
│   │   │       ├── invite_member_usecase.dart
│   │   │       ├── reject_invitation_usecase.dart
│   │   │       └── update_member_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── team_provider.dart
│   │       ├── screens/
│   │       │   └── members_screen.dart
│   │       └── widgets/
│   └── tech/                # Módulo de administración técnica y métricas de sistema
│       ├── data/
│       │   ├── repositories/
│       │   │   └── tech_repository_impl.dart
│       │   └── sources/
│       │       └── tech_data_source.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── tech_stats.dart
│       │   │   └── tech_user.dart
│       │   ├── repositories/
│       │   │   └── tech_repository_interface.dart
│       │   └── usecases/
│       │       ├── get_all_users_tech_usecase.dart
│       │       └── get_system_stats_usecase.dart
│       └── presentation/
│           ├── providers/
│           │   └── tech_provider.dart
│           └── screens/
│               ├── tech_dashboard_screen.dart      # Panel de administración técnica
│               └── tech_users_screen.dart          # Gestión de usuarios del sistema
├── firebase_options.dart    # Configuración de Firebase para plataformas nativas
├── l10n/                    # Archivos de internacionalización
│   ├── app_en.arb                   # Cadenas de texto en inglés
│   ├── app_es.arb                   # Cadenas de texto en español
│   ├── app_localizations.dart       # Clase autogenerada de localización
│   ├── app_localizations_en.dart    # Localización autogenerada (inglés)
│   └── app_localizations_es.dart    # Localización autogenerada (español)
└── main.dart                # Punto de entrada de la aplicación
```
