# China Prices - Instrucciones de Ejecución

## 🚀 Cómo ejecutar la aplicación

### Prerrequisitos
- Flutter 3.0 o superior
- Dart 3.0 o superior
- Android Studio / VS Code
- Dispositivo Android/iOS o emulador

### Pasos para ejecutar

1. **Verificar Flutter**
```bash
flutter doctor
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Ejecutar la aplicación**
```bash
flutter run
```

### Configuración opcional

#### Para usar datos de ejemplo locales:
1. Modifica `lib/constants/app_constants.dart`
2. Cambia la URL del JSON a un archivo local:
```dart
static const String currentJsonUrl = 'assets/data/sample_products.json';
```

#### Para configurar AdMob:
1. Crea una cuenta en [Google AdMob](https://admob.google.com/)
2. Obtén los IDs de anuncios
3. Reemplaza en `lib/constants/app_constants.dart`:
```dart
static const String adMobAppId = 'tu-app-id';
static const String adMobBannerId = 'tu-banner-id';
static const String adMobInterstitialId = 'tu-interstitial-id';
static const String adMobAppOpenId = 'tu-app-open-id';
```

### Funcionalidades principales

1. **Pantalla de Inicio**: Muestra categorías y productos destacados
2. **Búsqueda**: Busca productos en tiempo real
3. **Comparación de Precios**: Compara precios entre tiendas chinas
4. **Favoritos**: Guarda productos favoritos localmente
5. **Anuncios**: Integración con Google AdMob

### Estructura de datos

La aplicación espera un JSON con el siguiente formato:
```json
[
  {
    "ProductId": 1005004572453697,
    "Image Url": "https://example.com/image.jpg",
    "Product Desc": "Nombre del producto",
    "Origin Price": "USD 10.00",
    "Discount Price": "USD 8.00",
    "Discount": "20%",
    "Promotion Url": "https://aliexpress.com/product"
  }
]
```

### Notas importantes

- Los warnings sobre `withOpacity` son informativos y no afectan la funcionalidad
- La aplicación está optimizada para dispositivos móviles
- Los anuncios solo se muestran si están configurados correctamente
- El almacenamiento local se usa para favoritos e historial de búsquedas

### Solución de problemas

Si encuentras errores:
1. Ejecuta `flutter clean`
2. Ejecuta `flutter pub get`
3. Reinicia el emulador/dispositivo
4. Ejecuta `flutter run` nuevamente

### Build para producción

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

---

¡La aplicación está lista para usar! 🎉
