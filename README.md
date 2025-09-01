# China Prices - Flutter App

Una aplicación Flutter 3 moderna y responsiva que permite a los usuarios buscar productos y comparar precios en diferentes tiendas chinas, basándose en datos JSON alojados en GitHub con enlaces de afiliados.

## 🚀 Características

### 🔍 Búsqueda Inteligente
- Búsqueda en tiempo real de productos
- Filtrado por nombre de producto
- Historial de búsquedas local
- Resultados con imágenes y precios

### 💰 Comparación de Precios
- Comparación automática entre múltiples tiendas chinas
- AliExpress siempre aparece primero (prioridad)
- Ordenamiento por precio de menor a mayor
- Enlaces de afiliados directos

### 🏪 Tiendas Soportadas
- **AliExpress** (prioridad)
- Taobao
- JD.com
- DHgate
- Pinduoduo
- VIP.com
- Tmall

### ❤️ Favoritos
- Guardar productos favoritos localmente
- Gestión de favoritos con interfaz intuitiva
- Sincronización automática

### 📱 Diseño Moderno
- Material Design 3
- Interfaz responsiva (móvil y tablet)
- Animaciones fluidas
- Colores cálidos y suaves
- Tipografía Google Fonts (Poppins)

### 💰 Monetización
- Google AdMob integrado
- App Open Ads al inicio
- Banner ads adaptativos
- Interstitial ads después de 5 búsquedas

## 🏗️ Estructura del Proyecto

```
lib/
├── constants/
│   └── app_constants.dart          # Constantes de la aplicación
├── models/
│   ├── product_model.dart          # Modelo de producto
│   └── price_comparison_model.dart # Modelo de comparación de precios
├── services/
│   ├── api_service.dart            # Servicio de API
│   ├── storage_service.dart        # Servicio de almacenamiento local
│   ├── ad_service.dart             # Servicio de anuncios
│   ├── url_launcher_service.dart   # Servicio de enlaces
│   └── app_provider.dart           # Provider principal
├── screens/
│   ├── splash_screen.dart          # Pantalla de inicio
│   ├── home_screen.dart            # Pantalla principal
│   ├── search_screen.dart          # Pantalla de búsqueda
│   └── favorites_screen.dart       # Pantalla de favoritos
├── widgets/
│   ├── product_card.dart           # Tarjeta de producto
│   ├── price_comparison_card.dart  # Tarjeta de comparación
│   ├── category_card.dart          # Tarjeta de categoría
│   └── banner_ad_widget.dart       # Widget de anuncios
├── routes.dart                     # Configuración de rutas
└── main.dart                       # Punto de entrada
```

## 📊 Modelos de Datos

### Producto (JSON 1)
```json
{
    "ProductId": 1005004572453697,
    "Image Url": "https://ae04.alicdn.com/kf/S87fb4422f4664de6aa23e486c1efcddf7.jpg",
    "Video Url": "",
    "Product Desc": "Takara Tomy Tomica 67 Toyota Hilux Model Sports Racing Car Toy Gift for Boys and Girls Children",
    "Origin Price": "USD 4.75",
    "Discount Price": "USD 4.27",
    "Discount": "10%",
    "Currency": "USD",
    "Commission Rate": 7,
    "Commission": "USD 0.30",
    "Sales180Day": 26,
    "Positive Feedback": "100.0%",
    "Promotion Url": "https://s.click.aliexpress.com/e/_DEnQJ03"
}
```

### Comparación de Precios (JSON 2)
```json
[
  {
    "name": "Camisa blanca",
    "image_url": "https://example.com/camisa.jpg",
    "prices": [
      { "store_name": "AliExpress", "price": 12.99, "affiliate_url": "https://aliexpress.com/product" },
      { "store_name": "Taobao", "price": 11.50, "affiliate_url": "https://taobao.com/product" },
      { "store_name": "Tmall", "price": 13.20, "affiliate_url": "https://tmall.com/product" }
    ]
  }
]
```

## 🛠️ Configuración

### Prerrequisitos
- Flutter 3.0 o superior
- Dart 3.0 o superior
- Android Studio / VS Code

### Instalación

1. **Clonar el repositorio**
```bash
git clone <repository-url>
cd china_prices
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar AdMob** (opcional)
   - Reemplazar los IDs de AdMob en `lib/constants/app_constants.dart`
   - Configurar `android/app/src/main/AndroidManifest.xml` para AdMob

4. **Ejecutar la aplicación**
```bash
flutter run
```

### Configuración de AdMob

1. Crear cuenta en [Google AdMob](https://admob.google.com/)
2. Crear una nueva aplicación
3. Obtener los IDs de anuncios
4. Reemplazar en `lib/constants/app_constants.dart`:

```dart
static const String adMobAppId = 'ca-app-pub-XXXXXXXXXX~XXXXXXXXXX';
static const String adMobBannerId = 'ca-app-pub-XXXXXXXXXX/XXXXXXXXXX';
static const String adMobInterstitialId = 'ca-app-pub-XXXXXXXXXX/XXXXXXXXXX';
static const String adMobAppOpenId = 'ca-app-pub-XXXXXXXXXX/XXXXXXXXXX';
```

## 🔧 Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0                    # Peticiones HTTP
  url_launcher: ^6.2.1            # Abrir enlaces
  google_mobile_ads: ^4.0.0       # Google AdMob
  shared_preferences: ^2.2.2      # Almacenamiento local
  provider: ^6.1.1                # Manejo de estado
  google_fonts: ^6.1.0            # Tipografía
  flutter_animate: ^4.5.0         # Animaciones
  cached_network_image: ^3.3.0    # Caché de imágenes
  shimmer: ^3.0.0                 # Efectos de carga
```

## 📱 Funcionalidades Principales

### Búsqueda de Productos
- Búsqueda en tiempo real
- Filtrado inteligente
- Historial de búsquedas
- Resultados con imágenes y precios

### Comparación de Precios
- AliExpress siempre primero
- Ordenamiento por precio
- Enlaces de afiliados directos
- Búsqueda en tiendas sin producto

### Gestión de Favoritos
- Guardar productos favoritos
- Interfaz intuitiva
- Almacenamiento local
- Sincronización automática

### Anuncios Integrados
- App Open Ads al inicio
- Banner ads adaptativos
- Interstitial ads programadas
- Configuración flexible

## 🎨 Diseño UI/UX

### Colores
- **Primario**: `#FF6B35` (Naranja cálido)
- **Secundario**: `#FF8E53` (Naranja claro)
- **Acento**: `#FFB347` (Amarillo naranja)
- **Fondo**: `#F8F9FA` (Gris muy claro)
- **Superficie**: `#FFFFFF` (Blanco)

### Tipografía
- **Familia**: Poppins (Google Fonts)
- **Pesos**: Regular, Medium, SemiBold, Bold
- **Tamaños**: 12px - 32px

### Componentes
- Tarjetas con bordes redondeados
- Sombras suaves
- Animaciones fluidas
- Botones modernos
- Iconos Material Design

## 🚀 Despliegue

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor, abre un issue o pull request.

## 📞 Soporte

Para soporte técnico o preguntas, contacta a través de:
- Email: [tu-email@ejemplo.com]
- GitHub Issues: [link-al-repositorio]

---

**China Prices** - Compara precios en tiendas chinas de forma inteligente y moderna.
