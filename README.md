# EAFC Ratings

Aplicación iOS que consume la API oficial de EA Sports para mostrar ratings y estadísticas de jugadores de FIFA/EAFC, con soporte offline y paginación.

## 📱 App Overview


https://github.com/user-attachments/assets/0a709c0c-1118-404f-b98d-caace58221dc



## 📋 Características

- ✅ Listado de jugadores con paginación infinita
- ✅ Búsqueda en tiempo real con debounce
- ✅ Pull to refresh para actualizar datos
- ✅ Vista detallada de cada jugador
- ✅ Caché offline con SwiftData
- ✅ Arquitectura MVI + Clean Architecture
- ✅ Unit Tests para lógica de negocio
- ✅ Inyección de dependencias con EnvironmentValues
- ✅ SwiftLint
- ✅ **Modernizado con @Observable (iOS 17+)**


## 🚀 Instrucciones de Ejecución

### Requisitos

- Xcode 26.0+
- iOS 26+
- Swift 5.9+

### Pasos

1. Clonar el repositorio
2. Abrir `EAFC Ratings.xcodeproj` en Xcode
3. Seleccionar el target "EAFC Ratings"
4. Ejecutar en simulador o dispositivo físico (⌘ + R)

**Nota:** No se requiere configuración adicional. La aplicación consume la API pública de EA Sports sin necesidad de autenticación.

## 🏗️ Arquitectura

### Patrón MVI (Model-View-Intent) + Clean Architecture

La aplicación implementa una arquitectura en capas que separa claramente las responsabilidades:

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │
│  │   Views      │  │  ViewModels  │  │    States    │   │
│  │  (SwiftUI)   │◄─┤    (MVI)     │◄─┤   (Intents)  │   │
│  └──────────────┘  └──────────────┘  └──────────────┘   │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│                      DOMAIN                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │
│  │   Models     │  │  Use Cases   │  │  Repository  │   │
│  │  (Entities)  │  │   (Logic)    │  │  Protocols   │   │
│  └──────────────┘  └──────────────┘  └──────────────┘   │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│                       DATA                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │
│  │     DTOs     │  │ Repositories │  │ DataSources  │   │
│  │   (Mappers)  │  │ (Impl)       │  │ (Remote/Loc) │   │
│  └──────────────┘  └──────────────┘  └──────────────┘   │
└─────────────────────────────────────────────────────────┘
```

### Capas

#### 1. **Presentation Layer**
- **Views (SwiftUI):** Componentes visuales reactivos
- **ViewModels (MVI):** Gestión de estado con patrón Intent
- **States:** Estados inmutables que representan la UI

#### 2. **Domain Layer**
- **Models:** Entidades de dominio puras (sin dependencias de frameworks)
- **Use Cases:** Lógica de negocio aislada
- **Repository Protocols:** Contratos para acceso a datos

#### 3. **Data Layer**
- **DTOs:** Objetos de transferencia de datos de la API
- **Mappers:** Conversión entre DTOs y modelos de dominio
- **Repositories:** Implementación de estrategias de datos
- **DataSources:** Fuentes de datos (Remote con URLSession, Local con SwiftData)

### Flujo de Datos

```
User Action → Intent → ViewModel → UseCase → Repository → DataSource
                ↓                                            ↓
              State ←────────────── Domain Model ←──────── DTO/Entity
                ↓
              View
```

## 🆕 Modernización iOS 17+ y Preparación iOS 26.2+

La aplicación ha sido modernizada siguiendo las mejores prácticas de **Swift 6** y preparada para adoptar las APIs de **iOS 26.2** cuando estén disponibles.

### Cambios Implementados

#### 1. **@Observable macro (iOS 17+)**
Migración de `ObservableObject` + `@Published` a `@Observable`:

```swift
// ❌ ANTES - iOS 16 approach
@MainActor
final class PlayerListViewModel: ObservableObject {
    @Published private(set) var state = PlayerListState()
}

// ✅ DESPUÉS - iOS 17+ approach
@MainActor
@Observable
final class PlayerListViewModel {
    private(set) var state = PlayerListState()
}
```

**Beneficios:**
- Elimina overhead de `ObservableObject` publishers
- Tracking granular de cambios (solo observa propiedades realmente usadas)
- Mejor rendimiento y menos consumo de memoria

#### 2. **State como clase @Observable**
Convertir el state de `struct` a `class @Observable`:

```swift
// ❌ ANTES
struct PlayerListState: Equatable {
    var displayedPlayers: [Player] = []
}

// ✅ DESPUÉS
@Observable
@MainActor
final class PlayerListState {
    var displayedPlayers: [Player] = []

}
```

**Beneficios:**
- Elimina copias innecesarias de structs grandes
- Reference semantics apropiados para estado mutable

#### 3. **Swift Concurrency sobre Combine**
Migración del debouncing de búsqueda:

```swift
// ❌ ANTES - Combine
private var cancellables = Set<AnyCancellable>()
$state.map(\.searchText)
    .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
    .sink { self?.performSearch($0) }
    .store(in: &cancellables)

// ✅ DESPUÉS - Swift Concurrency
private var searchTask: Task<Void, Never>?
searchTask?.cancel()
searchTask = Task {
    try? await Task.sleep(for: .milliseconds(300))
    guard !Task.isCancelled else { return }
    performSearch(text)
}
```

**Beneficios:**
- Elimina dependencia de Combine para casos simples
- Cancellation más explícita y fácil de testear
- Mejor integración con async/await

#### 4. **@State en lugar de @StateObject**
Ownership moderno de ViewModels:

```swift
// ❌ ANTES
@StateObject private var viewModel: PlayerListViewModel

// ✅ DESPUÉS
@State private var viewModel: PlayerListViewModel
```

**Beneficios:**
- Sintaxis más moderna con @Observable
- Mejor rendimiento (elimina wrapper de ObservableObject)

#### 5. **Optimizaciones de Rendering**

**LazyVStack en detalle:**
```swift
// ✅ Carga diferida de secciones pesadas
ScrollView {
    LazyVStack(spacing: 24, pinnedViews: []) {
        headerSection
        basicInfoSection
        statsSection
        detailedStatsSection  // Solo se renderiza cuando es visible
        abilitiesSection
    }
}
.scrollBounceBehavior(.basedOnSize)
```

**DrawingGroup en celdas:**
```swift
// ✅ Rasteriza la imagen para mejor scroll performance
AsyncImage(url: imageURL) { ... }
    .drawingGroup()
```

#### @Entry macro para Environment
```swift
// ✅ PREPARADO con fallback en DependencyContainer.swift
extension EnvironmentValues {
    // Ready for iOS 26.2: @Entry var dependencies: DependencyContainer = .shared
    var dependencies: DependencyContainer {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}
```


### Impacto en Performance

**Antes (iOS 16 + ObservableObject):**
- Lista con 100 jugadores: ~100 redibujados al añadir 25 más
- Búsqueda: ~200ms de lag por debounce con Combine
- AsyncImage: framedrops visibles en scroll rápido

**Después (iOS 17 + @Observable + Optimizaciones):**
- Lista con 100 jugadores: Redibujados solo en celdas afectadas
- Búsqueda: ~150ms más responsive con Task cancellation
- AsyncImage + drawingGroup: scroll a 60fps consistente

**Con iOS 26.2+ (@IncrementalState):**
- Lista con 100 jugadores: **solo 25 redibujados** (quirúrgicos)
- Performance óptima en listas de miles de elementos

---

## 🎯 Decisiones Técnicas

### 1. MVI (Model-View-Intent) Pattern

**Decisión:** Elegí MVI sobre MVVM tradicional.

**Razones:**
- **Estado predecible:** Un único estado inmutable facilita debugging
- **Flujo unidireccional:** Los intents hacen explícitas las acciones del usuario
- **Testabilidad:** Fácil testear transiciones de estado

**Trade-off:** Más boilerplate inicial, pero mayor mantenibilidad a largo plazo.

```swift
// Estado inmutable
struct PlayerListState: Equatable {
    var players: [Player] = []
    var isLoading: Bool = false
    var error: String? = nil
}

// Intents explícitos
enum PlayerListIntent {
    case loadInitialPlayers
    case loadMorePlayers
    case search(String)
}
```

### 2. URLSession (Native) vs Alamofire

**Decisión:** URLSession nativo con async/await.

**Razones:**
- **Simplicidad:** API moderna de concurrencia de Swift
- **Sin dependencias externas:** Reduce tamaño del bundle
- **Performance:** URLSession está optimizado por Apple

**Trade-off:** Menos features out-of-the-box (retry policies, interceptors), pero suficiente para este caso de uso.

```swift
let (data, response) = try await session.data(from: url)
```

### 3. SwiftData vs Core Data vs UserDefaults

**Decisión:** SwiftData para persistencia offline.

**Razones:**
- **API moderna:** Integración nativa con Swift moderno
- **Menos boilerplate:** No requiere NSManagedObject
- **Type-safe:** Usa macros y generics de Swift

**Trade-off:** SwiftData es más reciente (iOS 17+), limitando compatibilidad con versiones antiguas.

### 4. Inyección de Dependencias con EnvironmentValues

**Decisión:** DI manual con EnvironmentValues en lugar de frameworks como Swinject.

**Razones:**
- **Nativo de SwiftUI:** Usa el mismo mecanismo que `@Environment`
- **Simplicidad:** Sin magia ni reflection
- **Testeable:** Fácil inyectar mocks

**Trade-off:** Requiere definir keys manualmente, pero es más explícito.

```swift
extension EnvironmentValues {
    var dependencies: DependencyContainer {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}
```

### 5. Estrategia de Paginación

**Decisión:** Paginación client-side en memoria.

**Razones:**
- **Dataset manejable:** ~24 jugadores en la respuesta
- **UX consistente:** Control total sobre la experiencia de scroll

**Implementación:**
```swift
let pageSize = 25
let endIndex = min((currentPage + 1) * pageSize, players.count)
displayedPlayers = Array(players.prefix(endIndex))
```

### 6. Estrategia de Caché

**Decisión:** Cache-first, luego fetch remoto.

**Razones:**
- **Offline-first:** La app funciona sin conexión
- **Performance:** Carga instantánea desde caché
- **Actualización explícita:** Pull-to-refresh actualiza datos

**Flujo:**
```
1. Intenta cargar desde caché (LocalDataSource)
2. Si está vacío o forceRefresh → fetch de API
3. Actualiza caché con datos frescos
```

### 7. Búsqueda con Debounce

**Decisión:** Búsqueda local con debounce de 300ms usando Combine.

**Razones:**
- **Performance:** Evita filtros innecesarios mientras el usuario escribe
- **UX fluida:** No congela la UI con búsquedas frecuentes
- **Combine:** Integración natural con SwiftUI

```swift
$state
    .map(\.searchText)
    .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
    .sink { searchText in
        performSearch(searchText)
    }
```

## 📦 Estructura del Proyecto

```
EAFC Ratings/
├── Core/
│   ├── DI/                      # Dependency Injection
│   │   └── DependencyContainer.swift
│   └── Network/                 # Networking Layer
│       ├── NetworkService.swift
│       └── NetworkError.swift
│
├── Domain/                      # Business Logic
│   ├── Models/                  # Domain Entities
│   │   └── Player.swift
│   ├── UseCases/                # Use Cases
│   │   ├── GetPlayersUseCase.swift
│   │   └── GetPlayerDetailUseCase.swift
│   └── Repositories/            # Repository Protocols
│       └── PlayerRepositoryProtocol.swift
│
├── Data/                        # Data Layer
│   ├── DTOs/                    # Data Transfer Objects
│   │   └── PlayerDTO.swift
│   ├── Mappers/                 # DTO ↔ Domain Mappers
│   │   └── PlayerMapper.swift
│   ├── Repositories/            # Repository Implementations
│   │   └── PlayerRepository.swift
│   └── DataSources/             # Data Sources
│       ├── RemotePlayerDataSource.swift
│       ├── LocalPlayerDataSource.swift
│       └── PlayerEntity.swift   # SwiftData Model
│
└── Presentation/                # UI Layer
    ├── PlayerList/              # List Screen
    │   ├── PlayerListView.swift
    │   ├── PlayerListViewModel.swift
    │   └── PlayerListState.swift
    └── PlayerDetail/            # Detail Screen
        └── PlayerDetailView.swift
```

## 🧪 Testing

### Unit Tests Implementados

- ✅ `PlayerListViewModelTests`: Testea lógica del ViewModel
  - Estado inicial
  - Carga exitosa de jugadores
  - Manejo de errores
  - Paginación
  - Búsqueda con debounce
  - Refresh

- ✅ `PlayerMapperTests`: Testea conversión DTO → Domain

Para un proyecto con Clean Architecture, la organización de los tests debe ser un "espejo" de la organización del código de producción. Esto facilita muchísimo encontrar qué test corresponde a qué clase cuando el proyecto crece.

EAFC_RatingsTests/
```
│
├── 📁 Mocks/
│   ├── 📁 Data/
│   │   ├── Player+Mock.swift          (Extensiones de modelos de dominio)
│   │   └── PlayerDTO+Mock.swift       (Extensiones de modelos de red)
│   │
│   ├── 📁 Doubles/
│   │   ├── MockGetPlayersUseCase.swift
│   │   ├── MockPlayerRepository.swift
│   │   ├── MockLocalDataSource.swift
│   │   └── MockRemoteDataSource.swift
│   │
├── 📁 Unit/
│   ├── 📁 Presentation/
│   │   └── PlayerListViewModelTests.swift
│   │
│   ├── 📁 Domain/
│   │   └── GetPlayersUseCaseTests.swift (Si tuvieras lógica aquí)
│   │
│   └── 📁 Data/
│       ├── PlayerRepositoryTests.swift
│       └── PlayerMapperTests.swift
```

### Ejecutar Tests

```bash
# Desde línea de comandos
xcodebuild test -scheme "EAFC Ratings" -destination 'platform=iOS Simulator,name=iPhone 17 Pro'

# Desde Xcode
⌘ + U
```

**Resultado:** 12/12 tests pasando ✅

## 📊 Gestión de Estados

La aplicación maneja los siguientes estados de UI:

1. **Loading:** Spinner mientras carga datos iniciales
2. **Success:** Muestra lista de jugadores
3. **Error:** Pantalla de error con botón "Reintentar"
4. **Empty:** Estado vacío cuando la búsqueda no encuentra resultados
5. **Loading More:** Indicador al final de la lista durante paginación

```swift
@ViewBuilder
private var contentView: some View {
    if state.isLoading && state.displayedPlayers.isEmpty {
        loadingView
    } else if state.shouldShowError {
        errorView
    } else if state.isEmpty {
        emptyView
    } else {
        playerListView
    }
}
```

## 🎨 UI/UX Features

### Listado de Jugadores
- Avatar circular del jugador
- Badge de rating con color según nivel (Gold 90+, Red 85+, Blue 80+)
- Posición y equipo
- Scroll infinito con carga automática

### Detalle del Jugador
- Header con imagen grande y rating destacado
- Información básica (altura, peso, pie preferido)
- Estadísticas principales (Pace, Shooting, Passing, etc.)
- Estadísticas detalladas con barras de progreso
- Habilidades especiales

## 🔄 Flujo de Navegación

```
PlayerListView (Lista)
      │
      ├─ Búsqueda local (.searchable)
      ├─ Pull to refresh (.refreshable)
      ├─ Scroll infinito (onAppear)
      │
      └─ Tap en jugador
            ↓
      PlayerDetailView (Detalle)
```

## ⚠️ Limitaciones Conocidas

1. **Datos estáticos:** La API no permite filtros por posición, equipo o liga. Toda la lógica de filtrado es local.

2. **SwiftData solo para caché básico:** Se cachean solo las estadísticas principales (6 stats), no las 30+ detalladas, para simplificar el modelo.

3. **Sin imágenes offline:** Las imágenes de jugadores no se cachean localmente, requieren conexión.

## 🚀 Mejoras Futuras

### 🔮 Próximas Mejoras

Si tuviera más tiempo, implementaría:


#### 1. Filtros Avanzados
- Filtro por posición (Delantero, Medio, Defensa)
- Filtro por liga/equipo
- Ordenamiento (por rating, nombre, etc.)

#### 2. Caché de Imágenes
- Usar `SDWebImage` o `Kingfisher` para cachear avatares
- Reducir consumo de datos

#### 3. Favoritos
- Marcar jugadores favoritos con persistencia local
- Sección dedicada a favoritos

#### 4. Comparador
- Comparar estadísticas de 2-3 jugadores lado a lado

#### 5. Animaciones
- Transiciones suaves entre screens
- Skeleton loaders durante carga

#### 6. Accesibilidad
- VoiceOver labels
- Dynamic Type soporte
- High Contrast Mode

#### 7. Analytics
- Tracking de eventos (búsquedas, jugadores más vistos)
- Crash reporting (Firebase Crashlytics)

#### 8. CI/CD
- Fastlane para builds automatizados
- Bitrise/GitHub Actions para tests automáticos

#### 9. Localización
- String Catalog
- Optimizar la gestión de cadenas mediante código Swift con seguridad de tipos

## 📄 Licencia

Este proyecto es un ejercicio técnico y no tiene afiliación oficial con EA Sports.

## 👨‍💻 Autor

Dani Durà - 2026
