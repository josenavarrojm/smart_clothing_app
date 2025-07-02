# SmartClothingProject

Aplicación Flutter para el proyecto de ropa inteligente.

## 🧠 Descripción

Este proyecto es una aplicación móvil desarrollada en Flutter para conectar prendas inteligentes mediante Bluetooth, manejar datos biométricos y visualizarlos de forma interactiva. Utiliza bases de datos locales y en la nube, además de notificaciones, gráficos y conexión con sensores.

---

## 🖥️ Requisitos del sistema

- Flutter SDK >= 3.5.3
- Dart SDK >= 3.5.3
- Android Studio o VS Code con extensiones de Flutter
- Dispositivo físico con Bluetooth o emulador con servicios simulados
- MongoDB (si se usa base de datos remota)
- Acceso a internet (para paquetes y funcionalidades online)

---

## 🚀 Instalación en PC (Onboarding Completo)

### 1. Clonar el repositorio

```bash
git clone https://github.com/tu_usuario/smartclothingproject.git
cd smartclothingproject
```

### 2. Instalar Flutter SDK (si no lo tienes)

[Guía oficial de instalación](https://docs.flutter.dev/get-started/install)

```bash
flutter doctor
```

Asegúrate de que todo esté OK.

### 3. Instalar dependencias del proyecto

```bash
flutter pub get
```

### 4. Configurar permisos (Android)

Revisa y ajusta `AndroidManifest.xml` para incluir los permisos necesarios de Bluetooth, localización y almacenamiento si aplica.

### 5. Ejecutar el proyecto

En dispositivo o emulador:

```bash
flutter run
```

---

## 📦 Paquetes utilizados

- `flutter_blue_plus`, `flutter_reactive_ble`: Conexión BLE
- `mqtt_client`: Comunicación con brokers MQTT
- `sqflite`, `shared_preferences`, `mongo_dart`: Almacenamiento local y remoto
- `syncfusion_flutter_charts`: Visualización de datos
- `flutter_local_notifications`: Notificaciones
- `provider`, `get`: Gestión de estado
- Otros: `fluttertoast`, `uuid`, `bcrypt`, `email_validator`, etc.

---

## 📁 Estructura del proyecto

```
smartclothingproject/
├── assets/             # Imágenes, CSVs
├── lib/                # Código fuente
├── pubspec.yaml        # Configuración del proyecto
└── README.md
```

---

## 📸 Recursos multimedia

Asegúrate de colocar los archivos necesarios dentro de `assets/` como:

- `assets/images/ladys_logo.png`
- `assets/data/data.csv`

---

## 🧪 Tests

Este proyecto aún no cuenta con pruebas automatizadas.

---

## 📄 Licencia

Este proyecto está bajo licencia privada o institucional. Contacta a los autores para más información.

---

## 🧑‍💻 Contribuciones

Actualmente no se aceptan contribuciones públicas.
