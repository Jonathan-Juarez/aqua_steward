# Aqua Steward

AquaSteward es un sistema que resuelve la problemática de la mala gestión del agua, tanto en su desperdicio como en su calidad (pH y la turbidez). El monitoreo no lo realiza solo, sino que se le ofrece al usuario la capacidad de trabajar en conjunto con otros individuos mediante sus dispositivos móviles y acceso a internet, cada uno con un rol determinado (analista, administrador y propietario), por lo que el usuario objetivo no presenta limitaciones de edad o nivel educativo para su uso básico. Sin embargo, para el uso avanzado, es necesario que el usuario tenga entre 18 y 60 años, fundamentos sobre la ciencia de datos y un nivel educativo medio superior en adelante.

## Características Principales
Las características principales, incluyendo las que se tienen planeadas a futuro, son:

- **Gestión de Dispositivos:**
  - Añadir y configurar kits de monitoreo de agua.
  - Asignar nombres personalizados y direcciones IP a los dispositivos.
- **Configuración de Sensores:**
  - Habilitar/deshabilitar sensores individuales (Nivel, Turbidez, pH).
  - Establecer umbrales personalizados para cada sensor.
- **Monitoreo en Tiempo Real:**
  - Visualizar parámetros actuales de agua (Nivel, Turbidez, pH) mediante Socket.IO y MQTT.
  - Historial de datos (lecturas) en tiempo real.
- **Sistema de Alertas:**
  - Notificaciones al detectar parámetros fuera de los rangos seguros definidos.
  - Pantalla para la consulta de alertas activas.
- **Autenticación y Gestión de Usuarios:**
  - Sistema seguro de inicio de sesión, registro y recuperación de contraseñas.
  - Flujo de recuperación de contraseña con verificación por correo.
  - Perfil de usuario y gestión de miembros.
- **Visualización de Datos:**
  - Gráficos y tablas interactivas con `fl_chart` para visualizar la evolución de la calidad del agua.
  - Detalles por parámetro y registros históricos.
- **Reportes en PDF:**
  - Generación, previsualización y exportación de reportes de estado detallados.
- **Personalización de Tema:**
  - Soporte para modo claro y oscuro, de manera consistente y persistente usando almacenamiento local.
- **Soporte y Ayuda:**
  - Sección de preguntas frecuentes (FAQ), manual de usuario y contacto de soporte.

## Tecnologías

| Categoría              | Tecnología                                              |
| ---------------------- | ------------------------------------------------------- |
| Framework              | Flutter / Dart                                          |
| Gestión de Estado      | Provider                                                |
| Persistencia Local     | Shared Preferences                                      |
| Conectividad           | MQTT Client, Socket.IO Client, HTTP                     |
| Visualización de Datos | fl_chart, PDF, Printing                                 |
| Internacionalización   | intl (Próximamente para el formato de fechas)           |
| Diseño Visual          | Animate Do, Flutter Launcher Icons & Native Splash      |

## Prerrequisitos

- Flutter SDK (versión 3.8.1 o superior, según `pubspec.yaml`)
- Dart SDK
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

4. (Opcional) Configurar ícono y splash screen:
   ```bash
   dart run flutter_launcher_icons
   dart run flutter_native_splash:create
   ```

5. Ejecutar la aplicación:
   Inicia la aplicación en un emulador o un dispositivo físico conectado:
   ```bash
   flutter run
   ```

## Estructura del Proyecto (Clean Architecture)

El proyecto está diseñado para seguir los principios de **Clean Architecture**, organizando el código en capas modulares dentro de cada funcionalidad (*feature*) para maximizar la mantenibilidad, escalabilidad y la separación de responsabilidades:

```text
lib/
├── controller/              # Controladores globales de la aplicación (Próximamente se eliminará, se moverá a cada feature)
│   ├── auth_controller.dart         
│   └── deposit_controller.dart      
├── core/                    # Utilidades principales y configuraciones globales
│   ├── error/                       # Manejo de errores (Próximamente)
│   ├── network/                     # Conectividad (HTTP, Socket.IO, variables globales)
│   ├── router/                      # Enrutamiento y navegación de la aplicación
│   ├── theme/                       # Temas (claro/oscuro), colores, tipografía, provider
│   ├── utils/                       # Validadores y utilidades generales
│   └── widgets/                     # Widgets reutilizables (botones, inputs, barras, etc.)
├── entity/                  # Entidades de negocio globales (Próximamente se eliminará, se moverá a cada feature)
│   └── deposit.dart                 
├── features/                # Módulos de funcionalidades independientes
│   ├── alerts/              # Sistema de alertas
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── screens/
│   │           └── alerts_screen.dart
│   ├── auth/                # Autenticación (login, registro, recuperación de contraseña)
│   │   ├── data/
│   │   │   ├── datasources/         # Fuentes de datos (API)
│   │   │   ├── models/              # Modelos y DTOs
│   │   │   └── repositories/        # Implementaciones de repositorios
│   │   ├── domain/
│   │   │   ├── entities/            # Entidades de negocio (User)
│   │   │   ├── repositories/        # Contratos (interfaces) de repositorios
│   │   │   └── usecases/            # Casos de uso (ResetPassword)
│   │   └── presentation/
│   │       ├── providers/           # Manejadores de estado (ResetPasswordProvider)
│   │       ├── screens/             # Pantallas (SignIn, SignUp, ForgotPassword, etc.)
│   │       └── widgets/             # Widgets específicos de auth (Logo, Scaffold)
│   ├── monitoring/          # Dashboard y monitoreo en tiempo real
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── screens/             # Dashboard, detalles de parámetros
│   │       └── widgets/             # Indicadores circulares, registros, reportes
│   ├── profile/             # Perfil de usuario y miembros
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── screens/             # Perfil, miembros
│   │       └── widgets/             # Diálogos emergentes
│   ├── reports/             # Reportes, depósitos y configuración de umbrales
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── screens/             # Añadir depósito, generar reportes, umbrales
│   └── support/             # Ayuda y soporte
│       ├── data/
│       ├── domain/
│       └── presentation/
│           ├── screens/             # Contacto, soporte, manual de usuario
│           └── widgets/             # Elementos FAQ
└── main.dart                # Punto de entrada de la aplicación
```
