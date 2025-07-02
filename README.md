# SmartClothingProject

Aplicación Flutter multiplataforma para el proyecto de ropa inteligente.

---

## 🧠 Descripción

Esta aplicación permite la interacción con prendas inteligentes mediante Bluetooth y protocolos IoT, visualización de datos biométricos, almacenamiento local/remoto, gráficos avanzados y notificaciones en tiempo real.

---

## 🖥️ Requisitos del sistema

- Flutter SDK >= 3.5.3
- Dart SDK >= 3.5.3
- Visual Studio (con workload "Desktop development with C++")
- Android Studio (opcional para compilar en móviles)
- Git
- MongoDB (si se usa base de datos remota)
- Sistema operativo: Windows 10/11 recomendado

---

## 🚀 Onboarding: Cómo ejecutar el proyecto en una PC

### 1. Clonar el repositorio

```bash
git clone https://github.com/tu_usuario/smartclothingproject.git
cd smartclothingproject
```

### 2. Instalar Flutter

[Guía oficial de instalación](https://docs.flutter.dev/get-started/install)

```bash
flutter doctor
```

Revisa que todos los entornos (Windows, Android, etc.) estén configurados correctamente.

### 3. Instalar dependencias

```bash
flutter pub get
```

---

## 🪟 Ejecutar como aplicación de escritorio en Windows

### 1. Habilitar soporte de escritorio

```bash
flutter config --enable-windows-desktop
flutter doctor
```

Asegúrate de que `Windows desktop is available` esté habilitado.

### 2. Ejecutar en modo desarrollo

```bash
flutter run -d windows
```

### 3. Compilar versión ejecutable

```bash
flutter build windows
```

El ejecutable quedará en:

```
build/windows/runner/Release/
```

Puedes hacer doble clic sobre el `.exe` generado.

> Nota: Asegúrate de tener Visual Studio instalado con el workload de desarrollo C++ para escritorio.

---

## 📱 Ejecutar como app móvil

```bash
flutter run -d <dispositivo>
```

Puedes conectar un dispositivo Android físico o emular uno desde Android Studio.

---

## 🌐 Ejecutar como app web

```bash
flutter config --enable-web
flutter run -d chrome
```

---

## 📦 Paquetes destacados

- `flutter_blue_plus`, `flutter_reactive_ble`: BLE y Bluetooth clásico
- `mqtt_client`: Protocolo MQTT
- `sqflite`, `mongo_dart`: Bases de datos local y remota
- `syncfusion_flutter_charts`: Gráficas
- `provider`, `get`: Gestión de estado
- `flutter_local_notifications`, `shared_preferences`, `fluttertoast`

---

## 📁 Estructura del proyecto (resumen)

```
.
├── lib/                 # Código fuente principal
│   ├── controllers/     # Controladores
│   ├── views/           # Interfaces
│   ├── handlers/        # Gestión de eventos
│   ├── models/          # Modelos de datos
│   └── main.dart        # Punto de entrada
├── assets/              # Imágenes, datos CSV
├── windows/             # Código nativo para Windows
├── android/, ios/       # Archivos nativos móviles
├── test/                # Pruebas
├── pubspec.yaml         # Configuración del proyecto
```

---

## 🔒 Permisos necesarios

### Android (`android/app/src/main/AndroidManifest.xml`)

- Bluetooth y ubicación

### Windows

- El ejecutable puede requerir permisos de red o Bluetooth según la configuración del sistema.

---

## 🧪 Pruebas

El archivo base de pruebas está en:

```
test/widget_test.dart
```

---

## 📄 Licencia

Licencia privada/institucional.

---

## 🧑‍💻 Contribuciones

Actualmente este proyecto no acepta contribuciones externas.
