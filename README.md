# 🦭 SEAL Mobile

> **Student Event Activity Lifecycle** — Ứng dụng di động Flutter dành cho sinh viên tham gia và quản lý các sự kiện, cuộc thi trong trường đại học.

---

## 📑 Mục Lục

- [Tổng Quan](#-tổng-quan)
- [Công Nghệ Sử Dụng](#-công-nghệ-sử-dụng)
- [Kiến Trúc Ứng Dụng (MVVM)](#-kiến-trúc-ứng-dụng-mvvm)
- [Dependency Injection & Singleton Pattern](#-dependency-injection--singleton-pattern)
- [Cấu Trúc Thư Mục](#-cấu-trúc-thư-mục)
- [Sơ Đồ Vận Hành Hệ Thống](#-sơ-đồ-vận-hành-hệ-thống)
- [Luồng Người Dùng (Sinh Viên)](#-luồng-người-dùng-sinh-viên)
- [Cài Đặt & Chạy Dự Án](#-cài-đặt--chạy-dự-án)

---

## 🔎 Tổng Quan

SEAL Mobile là ứng dụng di động được xây dựng bằng **Flutter**, kết nối với Backend REST API để cung cấp cho sinh viên các chức năng:

- **Xác thực:** Đăng ký, đăng nhập, xác thực email, làm mới token tự động.
- **Sự kiện:** Xem danh sách sự kiện, chi tiết sự kiện, các track thi đấu.
- **Nhóm:** Tạo nhóm, mời thành viên, quản lý nhóm thi.
- **Nộp bài:** Upload bài dự thi, xem kết quả chấm điểm.
- **Hồ sơ:** Xem và quản lý thông tin cá nhân, trạng thái phê duyệt tài khoản.

---

## 🛠 Công Nghệ Sử Dụng

| Công nghệ | Phiên bản | Vai trò |
|---|---|---|
| **Flutter** | SDK ≥ 3.12.2 | Framework xây dựng giao diện đa nền tảng (Android & iOS) |
| **Dart** | ≥ 3.12.2 | Ngôn ngữ lập trình chính |
| **Dio** | 5.11.0 | HTTP Client — gửi/nhận request đến REST API |
| **Provider** | 6.1.2 | State Management — triển khai MVVM, lắng nghe thay đổi trạng thái |
| **GetIt** | 9.2.1 | Service Locator / Dependency Injection container |
| **Flutter Secure Storage** | 11.0.0 | Lưu trữ bảo mật (access token, refresh token) trên thiết bị |
| **intl** | 0.20.3 | Định dạng ngày tháng, đa ngôn ngữ |
| **Material Design 3** | Built-in | Hệ thống thiết kế giao diện (theme, color scheme, typography) |

---

## 🏗 Kiến Trúc Ứng Dụng (MVVM)

Dự án áp dụng kiến trúc **MVVM (Model – View – ViewModel)** kết hợp **Repository Pattern** để tách biệt rõ ràng các tầng trách nhiệm:

```mermaid
graph TB
    subgraph "🖥️ VIEW Layer"
        V["View<br/>(Flutter Widget)"]
    end

    subgraph "🧠 VIEWMODEL Layer"
        VM["ViewModel<br/>(extends ChangeNotifier)"]
        BS["BaseViewModel<br/>• ViewState: idle | loading | success | error<br/>• errorMessage<br/>• setLoading() / setSuccess() / setError()"]
    end

    subgraph "📦 MODEL / DATA Layer"
        R["Repository"]
        DS["Remote DataSource"]
        M["Model (Data Class)"]
    end

    subgraph "🌐 NETWORK"
        DC["DioClient<br/>(HTTP Client + Interceptor)"]
        API["Backend REST API<br/>api.sealswp391.xyz"]
    end

    V -->|"1. User action<br/>(gọi method)"| VM
    VM -->|"2. notifyListeners()"| V
    VM -->|"3. Gọi Repository"| R
    R -->|"4. Gọi DataSource"| DS
    DS -->|"5. HTTP Request"| DC
    DC -->|"6. Request/Response"| API
    DC -->|"7. JSON Response"| DS
    DS -->|"8. Parse → Model"| M
    M -->|"9. ApiResult"| R
    R -->|"10. ApiResult"| VM
    VM -->|"Extends"| BS

    style V fill:#4FC3F7,stroke:#0288D1,color:#000
    style VM fill:#81C784,stroke:#388E3C,color:#000
    style BS fill:#A5D6A7,stroke:#388E3C,color:#000
    style R fill:#FFB74D,stroke:#F57C00,color:#000
    style DS fill:#FFB74D,stroke:#F57C00,color:#000
    style M fill:#FFB74D,stroke:#F57C00,color:#000
    style DC fill:#CE93D8,stroke:#7B1FA2,color:#000
    style API fill:#EF5350,stroke:#C62828,color:#fff
```

### Giải thích từng tầng

#### 1. View (Giao diện)
- Là các **Flutter Widget** (`StatefulWidget` / `StatelessWidget`).
- Chỉ chịu trách nhiệm **hiển thị dữ liệu** và **nhận thao tác** từ người dùng.
- Lắng nghe thay đổi từ ViewModel thông qua `Consumer<T>` hoặc `Provider.of<T>(context)`.
- **Không chứa business logic**, không gọi trực tiếp API.

#### 2. ViewModel (Xử lý logic)
- Kế thừa từ `BaseViewModel` (extends `ChangeNotifier`).
- Quản lý **trạng thái UI** qua enum `ViewState {idle, loading, success, error}`.
- Gọi Repository để lấy/gửi dữ liệu, sau đó gọi `notifyListeners()` để cập nhật View.
- Xử lý **validation**, **error mapping**, **state transitions**.

#### 3. Repository (Kho dữ liệu)
- Là **lớp trung gian** giữa ViewModel và DataSource.
- Bọc kết quả trả về trong `ApiResult<T>` (sealed class) gồm 2 case:
  - `Success<T>(data)` — thành công, chứa dữ liệu.
  - `Failure<T>(exception)` — thất bại, chứa exception.
- Xử lý **try/catch** và chuyển đổi lỗi mạng thành `ApiResult.Failure`.

#### 4. DataSource (Nguồn dữ liệu)
- Gọi trực tiếp API thông qua `DioClient`.
- Parse JSON response thành **Model** (Data Class) bằng `fromJson()`.
- Không xử lý business logic — chỉ chịu trách nhiệm giao tiếp mạng.

#### 5. Model (Dữ liệu)
- Các class thuần Dart đại diện cho dữ liệu (`AuthResponse`, `EventModel`, `TeamModel`, ...).
- Chứa `fromJson()` factory constructor để parse từ JSON.
- Chứa `toJson()` method để serialize thành JSON khi gửi request.

---

## 💉 Dependency Injection & Singleton Pattern

### Service Locator Pattern (GetIt)

Dự án sử dụng thư viện **GetIt** làm **Service Locator** — một dạng triển khai Dependency Injection (DI) phổ biến trong Flutter. Toàn bộ cấu hình DI nằm trong file `locator.dart`.

```mermaid
graph LR
    subgraph "GetIt Container (Service Locator)"
        direction TB
        S1["🔧 DioClient<br/><i>lazySingleton</i>"]
        S2["🔐 SecureStorageService<br/><i>lazySingleton</i>"]
        
        DS1["AuthRemoteDataSource<br/><i>lazySingleton</i>"]
        DS2["EventRemoteDataSource<br/><i>lazySingleton</i>"]
        DS3["TeamRemoteDataSource<br/><i>lazySingleton</i>"]
        DS4["...DataSource<br/><i>lazySingleton</i>"]

        R1["AuthRepository<br/><i>lazySingleton</i>"]
        R2["EventRepository<br/><i>lazySingleton</i>"]
        R3["TeamRepository<br/><i>lazySingleton</i>"]
        R4["...Repository<br/><i>lazySingleton</i>"]

        VM1["LoginViewModel<br/><i>factory</i>"]
        VM2["RegisterViewModel<br/><i>factory</i>"]
        VM3["EventViewModel<br/><i>factory</i>"]
        VM4["ProfileViewModel<br/><i>lazySingleton</i>"]
    end

    S1 --> DS1
    S1 --> DS2
    S1 --> DS3
    DS1 --> R1
    DS2 --> R2
    DS3 --> R3
    R1 --> VM1
    S2 --> VM1
    R1 --> VM2
    R2 --> VM3

    style S1 fill:#CE93D8,stroke:#7B1FA2,color:#000
    style S2 fill:#CE93D8,stroke:#7B1FA2,color:#000
    style DS1 fill:#FFB74D,stroke:#F57C00,color:#000
    style DS2 fill:#FFB74D,stroke:#F57C00,color:#000
    style DS3 fill:#FFB74D,stroke:#F57C00,color:#000
    style DS4 fill:#FFB74D,stroke:#F57C00,color:#000
    style R1 fill:#81C784,stroke:#388E3C,color:#000
    style R2 fill:#81C784,stroke:#388E3C,color:#000
    style R3 fill:#81C784,stroke:#388E3C,color:#000
    style R4 fill:#81C784,stroke:#388E3C,color:#000
    style VM1 fill:#4FC3F7,stroke:#0288D1,color:#000
    style VM2 fill:#4FC3F7,stroke:#0288D1,color:#000
    style VM3 fill:#4FC3F7,stroke:#0288D1,color:#000
    style VM4 fill:#4FC3F7,stroke:#0288D1,color:#000
```

### Hai kiểu đăng ký trong GetIt

| Kiểu | Phương thức | Ý nghĩa | Dùng cho |
|---|---|---|---|
| **Lazy Singleton** | `registerLazySingleton<T>()` | Tạo **duy nhất 1 instance** khi lần đầu được yêu cầu, các lần sau trả về cùng instance đó | `DioClient`, `SecureStorageService`, tất cả `DataSource`, `Repository`, `ProfileViewModel` |
| **Factory** | `registerFactory<T>()` | Tạo **instance mới mỗi lần** được yêu cầu | `LoginViewModel`, `RegisterViewModel`, `EventViewModel`, `TeamViewModel`, `SubmissionViewModel` |

### Tại sao dùng Singleton cho DioClient?

```mermaid
graph TD
    A["App khởi động"] -->|"setupLocator()"| B["GetIt Container"]
    B -->|"Lần 1: tạo mới"| C["DioClient instance"]
    B -->|"Lần 2: trả cùng instance"| C
    B -->|"Lần N: trả cùng instance"| C
    C --> D["Interceptor gắn token tự động"]
    C --> E["Interceptor refresh token khi 401"]
    C --> F["Dùng chung cho mọi DataSource"]

    style C fill:#CE93D8,stroke:#7B1FA2,color:#000
    style D fill:#FFF9C4,stroke:#F9A825,color:#000
    style E fill:#FFF9C4,stroke:#F9A825,color:#000
    style F fill:#FFF9C4,stroke:#F9A825,color:#000
```

- **DioClient** được đăng ký là `lazySingleton` → chỉ có **1 Dio instance duy nhất** trong toàn bộ app.
- Mọi `DataSource` đều nhận cùng 1 `DioClient` → đảm bảo mọi API call đều đi qua **cùng 1 Interceptor** (tự động gắn Bearer token, tự động refresh token khi hết hạn).
- Nếu dùng `factory`, mỗi DataSource sẽ tạo Dio riêng → mất đồng bộ interceptor.

### Tại sao ViewModel dùng Factory?

- ViewModel chứa **trạng thái tạm thời** (`isLoading`, `errorMessage`, dữ liệu form...).
- Mỗi lần mở màn hình, cần ViewModel **sạch** (reset state) → `factory` tạo instance mới.
- **Ngoại lệ:** `ProfileViewModel` dùng `lazySingleton` vì trạng thái hồ sơ cần được **chia sẻ toàn cục** giữa nhiều màn hình (kiểm tra `isApproved`, `isPending`...).

---

## 📂 Cấu Trúc Thư Mục

```
lib/
├── main.dart                          # Entry point — khởi tạo DI, chạy App
│
├── app/                               # Cấu hình cấp ứng dụng
│   ├── app.dart                       # Root Widget (MultiProvider + MaterialApp)
│   ├── di/
│   │   └── locator.dart               # GetIt DI Container — đăng ký tất cả dependencies
│   ├── router/
│   │   ├── app_router.dart            # Định tuyến màn hình (onGenerateRoute)
│   │   └── route_names.dart           # Hằng số tên route (/login, /register, /events...)
│   └── theme/
│       ├── app_colors.dart            # Bảng màu ứng dụng
│       └── app_theme.dart             # ThemeData (light/dark theme)
│
├── core/                              # Tầng lõi — dùng chung cho toàn project
│   ├── base/
│   │   ├── base_viewmodel.dart        # Abstract ViewModel với state management
│   │   └── view_state.dart            # Enum: idle | loading | success | error
│   ├── constants/
│   │   ├── api_endpoints.dart         # Base URL + tất cả endpoint paths
│   │   └── storage_keys.dart          # Key constants cho Secure Storage
│   ├── errors/
│   │   └── exceptions.dart            # Custom exception classes
│   ├── network/
│   │   ├── api_response.dart          # Wrapper parse {data, message, statusCode, success}
│   │   ├── api_result.dart            # Sealed class: Success<T> | Failure<T>
│   │   └── dio_client.dart            # Dio config + Auth Interceptor + Token Refresh
│   ├── storage/
│   │   └── secure_storage_service.dart # Đọc/ghi token bảo mật
│   └── utils/
│       ├── date_formatter.dart        # Tiện ích format DateTime
│       ├── error_mapper.dart          # Chuyển Exception → thông báo lỗi tiếng Việt
│       └── validators.dart            # Validation logic (email, password...)
│
├── data/                              # Tầng dữ liệu
│   ├── datasources/                   # Remote Data Sources — gọi API
│   │   ├── auth_remote_datasource.dart
│   │   ├── event_remote_datasource.dart
│   │   ├── event_role_remote_datasource.dart
│   │   ├── storage_remote_datasource.dart
│   │   ├── submit_result_remote_datasource.dart
│   │   ├── team_remote_datasource.dart
│   │   ├── track_remote_datasource.dart
│   │   └── user_remote_datasource.dart
│   ├── models/                        # Data Models — parse JSON
│   │   ├── auth/
│   │   │   ├── auth_response.dart     # Token response (accessToken, refreshToken...)
│   │   │   ├── login_request.dart     # Login request body
│   │   │   ├── register_request.dart  # Register request body
│   │   │   └── student_profile_model.dart
│   │   ├── event/
│   │   │   ├── event_model.dart       # Sự kiện
│   │   │   └── track_model.dart       # Track thi đấu
│   │   ├── invitation/
│   │   │   └── my_invitations_model.dart
│   │   ├── submission/
│   │   │   └── submit_result_model.dart
│   │   ├── team/
│   │   │   ├── team_invitation_model.dart
│   │   │   ├── team_member_model.dart
│   │   │   └── team_model.dart
│   │   └── user/
│   │       └── user_profile_model.dart
│   └── repositories/                  # Repositories — bọc DataSource + error handling
│       ├── auth_repository.dart
│       ├── event_repository.dart
│       ├── event_role_repository.dart
│       ├── storage_repository.dart
│       ├── submission_repository.dart
│       ├── team_repository.dart
│       ├── track_repository.dart
│       └── user_repository.dart
│
└── ui/                                # Tầng giao diện
    ├── auth/
    │   ├── viewmodels/
    │   │   ├── login_viewmodel.dart
    │   │   └── register_viewmodel.dart
    │   └── views/
    │       ├── login_view.dart
    │       └── register_view.dart
    ├── common/
    │   └── widgets/                   # Widget dùng chung
    │       ├── app_button.dart
    │       ├── app_text_field.dart
    │       └── loading_indicator.dart
    ├── event/
    │   ├── viewmodels/
    │   │   └── event_viewmodel.dart
    │   └── views/
    │       ├── event_detail_view.dart
    │       └── event_list_view.dart
    ├── profile/
    │   ├── viewmodels/
    │   │   └── profile_viewmodel.dart
    │   └── views/
    │       └── profile_view.dart
    ├── submission/
    │   ├── viewmodels/
    │   │   └── submission_viewmodel.dart
    │   └── views/
    │       └── submit_result_view.dart
    └── team/
        ├── viewmodels/
        │   └── team_viewmodel.dart
        └── views/
            ├── create_team_view.dart
            └── my_team_view.dart
```

---

## ⚙️ Sơ Đồ Vận Hành Hệ Thống

### Luồng khởi động ứng dụng

```mermaid
sequenceDiagram
    participant User as 👤 Người dùng
    participant Main as main.dart
    participant DI as GetIt Container
    participant App as App Widget
    participant Router as AppRouter
    participant Login as LoginView

    User->>Main: Mở ứng dụng
    Main->>Main: WidgetsFlutterBinding.ensureInitialized()
    Main->>DI: setupLocator()
    Note over DI: Đăng ký tất cả:<br/>Services → DataSources<br/>→ Repositories → ViewModels
    Main->>App: runApp(App())
    App->>App: MultiProvider (cung cấp ViewModels)
    App->>Router: initialRoute = '/login'
    Router->>Login: MaterialPageRoute → LoginView
    Login->>User: Hiển thị màn hình Đăng nhập
```

### Luồng xác thực (Authentication Flow)

```mermaid
sequenceDiagram
    participant User as 👤 Sinh viên
    participant View as LoginView
    participant VM as LoginViewModel
    participant Repo as AuthRepository
    participant DS as AuthRemoteDataSource
    participant API as Backend API
    participant SS as SecureStorage

    User->>View: Nhập email + password, nhấn "Đăng nhập"
    View->>VM: login(email, password)
    VM->>VM: validate() → setLoading()
    VM->>Repo: login(email, password)
    Repo->>DS: login(email, password)
    DS->>API: POST /api/Auth/login
    
    alt ✅ Đăng nhập thành công (200)
        API-->>DS: {data: {accessToken, refreshToken, ...}}
        DS-->>Repo: AuthResponse
        Repo-->>VM: Success(AuthResponse)
        VM->>SS: write('access_token', token)
        VM->>SS: write('refresh_token', token)
        VM->>VM: setSuccess()
        VM-->>View: notifyListeners()
        View->>User: Navigate → EventListView (Home)
    else ❌ Sai thông tin (400)
        API-->>DS: {message: "Email hoặc mật khẩu không chính xác"}
        DS-->>Repo: throw DioException
        Repo-->>VM: Failure(exception)
        VM->>VM: setError("Email hoặc mật khẩu không chính xác")
        VM-->>View: notifyListeners()
        View->>User: Hiển thị thông báo lỗi
    end
```

### Cơ chế tự động Refresh Token

```mermaid
sequenceDiagram
    participant DS as DataSource
    participant Dio as DioClient
    participant API as Backend API
    participant SS as SecureStorage

    DS->>Dio: GET /api/Events (token hết hạn)
    Dio->>API: Request + Bearer expired_token
    API-->>Dio: 401 Unauthorized
    
    Note over Dio: Interceptor bắt lỗi 401
    Dio->>SS: read('refresh_token')
    SS-->>Dio: refresh_token_value
    Dio->>API: POST /api/Auth/refresh-token
    
    alt ✅ Refresh thành công
        API-->>Dio: {accessToken: new_token}
        Dio->>SS: write('access_token', new_token)
        Dio->>API: Retry GET /api/Events + Bearer new_token
        API-->>Dio: 200 OK {data: [...]}
        Dio-->>DS: Response thành công
    else ❌ Refresh thất bại
        API-->>Dio: 401
        Dio->>SS: delete tokens
        Dio-->>DS: Trả lỗi → buộc đăng nhập lại
    end
```

---

## 👨‍🎓 Luồng Người Dùng (Sinh Viên)

### Tổng quan luồng chính

```mermaid
flowchart TD
    START(("🚀 Mở App")) --> CHECK{"Có token<br/>trong storage?"}
    
    CHECK -->|"Không"| AUTH["🔐 Màn hình Đăng nhập"]
    CHECK -->|"Có"| HOME["🏠 Trang chủ<br/>(Danh sách Sự kiện)"]
    
    AUTH --> LOGIN["Đăng nhập"]
    AUTH --> REG["Đăng ký tài khoản mới"]
    AUTH --> FORGOT["Quên mật khẩu"]
    
    REG -->|"Thành công"| AUTH
    REG -.->|"Hiện SnackBar:<br/>Vui lòng xác thực email"| AUTH
    
    LOGIN -->|"Thành công"| HOME
    LOGIN -->|"Thất bại"| AUTH
    
    HOME --> EL["📋 Xem danh sách Sự kiện"]
    HOME --> PROFILE["👤 Hồ sơ cá nhân"]
    
    EL --> ED["📄 Xem chi tiết Sự kiện"]
    ED --> TEAM["👥 Quản lý Nhóm"]
    ED --> SUBMIT["📤 Nộp bài dự thi"]
    
    TEAM --> CREATE["Tạo nhóm mới"]
    TEAM --> INVITE["Mời thành viên"]
    TEAM --> VIEW_TEAM["Xem nhóm của tôi"]
    
    SUBMIT --> UPLOAD["Upload file bài thi"]
    SUBMIT --> RESULT["Xem kết quả chấm điểm"]

    style START fill:#E1F5FE,stroke:#0288D1,color:#000
    style AUTH fill:#FFF3E0,stroke:#FF9800,color:#000
    style HOME fill:#E8F5E9,stroke:#4CAF50,color:#000
    style EL fill:#E8F5E9,stroke:#4CAF50,color:#000
    style ED fill:#E8F5E9,stroke:#4CAF50,color:#000
    style TEAM fill:#F3E5F5,stroke:#9C27B0,color:#000
    style SUBMIT fill:#FCE4EC,stroke:#E91E63,color:#000
    style PROFILE fill:#E0F2F1,stroke:#009688,color:#000
```

### Luồng 1: Đăng ký tài khoản

```mermaid
flowchart TD
    A["Nhấn 'Chưa có tài khoản? Đăng ký'"] --> B["Mở RegisterView"]
    B --> C["Nhập Họ tên + Email + Mật khẩu"]
    C --> D{"Validate form"}
    
    D -->|"❌ Lỗi validation"| E["Hiển thị lỗi<br/>(email không hợp lệ,<br/>mật khẩu < 6 ký tự...)"]
    E --> C
    
    D -->|"✅ Hợp lệ"| F["Gọi API POST /api/Auth/register"]
    F --> G{"Kết quả?"}
    
    G -->|"✅ Thành công"| H["Pop về LoginView"]
    H --> I["🟢 SnackBar: 'Đăng ký thành công!<br/>Vui lòng kiểm tra email<br/>để xác thực tài khoản.'"]
    I --> J["Sinh viên mở email → nhấn link xác thực"]
    J --> K["Quay lại app → Đăng nhập"]
    
    G -->|"❌ Thất bại"| L["Hiển thị lỗi<br/>(email đã tồn tại...)"]
    L --> C

    style A fill:#E3F2FD,stroke:#1565C0,color:#000
    style H fill:#C8E6C9,stroke:#2E7D32,color:#000
    style I fill:#C8E6C9,stroke:#2E7D32,color:#000
    style L fill:#FFCDD2,stroke:#C62828,color:#000
```

### Luồng 2: Đăng nhập

```mermaid
flowchart TD
    A["Mở App → LoginView"] --> B["Nhập Email + Mật khẩu"]
    B --> C{"Validate"}
    
    C -->|"❌ Trống/sai format"| D["Hiển thị lỗi validation"]
    D --> B
    
    C -->|"✅ Hợp lệ"| E["Loading spinner..."]
    E --> F["POST /api/Auth/login"]
    F --> G{"Response?"}
    
    G -->|"✅ 200 OK"| H["Lưu accessToken + refreshToken<br/>vào SecureStorage"]
    H --> I["Navigate → EventListView"]
    
    G -->|"❌ 400 Bad Request"| J["'Email hoặc mật khẩu không chính xác'"]
    J --> B
    
    G -->|"❌ Network Error"| K["'Không thể kết nối máy chủ'"]
    K --> B

    style E fill:#FFF9C4,stroke:#F9A825,color:#000
    style H fill:#C8E6C9,stroke:#2E7D32,color:#000
    style I fill:#C8E6C9,stroke:#2E7D32,color:#000
    style J fill:#FFCDD2,stroke:#C62828,color:#000
    style K fill:#FFCDD2,stroke:#C62828,color:#000
```

### Luồng 3: Xem & Tham gia Sự kiện

```mermaid
flowchart TD
    A["🏠 EventListView"] --> B["Gọi GET /api/Events"]
    B --> C["Hiển thị danh sách sự kiện"]
    C --> D["Nhấn vào 1 sự kiện"]
    D --> E["📄 EventDetailView"]
    E --> F["Xem thông tin chi tiết:<br/>• Tên sự kiện<br/>• Thời gian<br/>• Mô tả<br/>• Các Track thi đấu"]
    
    F --> G{"Muốn tham gia?"}
    G -->|"Có"| H["Xem danh sách Track"]
    H --> I{"Đã có nhóm?"}
    
    I -->|"Chưa"| J["👥 Tạo nhóm mới<br/>(CreateTeamView)"]
    J --> K["Nhập tên nhóm + chọn Track"]
    K --> L["POST /api/Teams"]
    L --> M["Mời thành viên vào nhóm"]
    
    I -->|"Rồi"| N["📤 Nộp bài<br/>(SubmitResultView)"]
    N --> O["Upload file bài thi"]
    O --> P["POST /api/Storage/upload"]
    P --> Q["Xem kết quả chấm điểm"]

    style A fill:#E8F5E9,stroke:#4CAF50,color:#000
    style E fill:#E8F5E9,stroke:#4CAF50,color:#000
    style J fill:#F3E5F5,stroke:#9C27B0,color:#000
    style N fill:#FCE4EC,stroke:#E91E63,color:#000
```

### Luồng 4: Quản lý Nhóm

```mermaid
flowchart TD
    A["👥 MyTeamView"] --> B["GET /api/Teams/my-team"]
    B --> C{"Đã có nhóm?"}
    
    C -->|"Chưa"| D["Hiển thị: 'Bạn chưa có nhóm'"]
    D --> E["Nút: Tạo nhóm mới"]
    E --> F["CreateTeamView"]
    F --> G["Nhập tên nhóm<br/>Chọn Track thi đấu"]
    G --> H["POST /api/Teams"]
    H --> I["✅ Tạo thành công"]
    
    C -->|"Rồi"| J["Hiển thị thông tin nhóm"]
    J --> K["Danh sách thành viên"]
    J --> L["Mời thêm thành viên"]
    L --> M["POST /api/EventRoles/invitations"]
    
    K --> N["Xem vai trò từng người<br/>(Leader, Member)"]

    style A fill:#F3E5F5,stroke:#9C27B0,color:#000
    style F fill:#F3E5F5,stroke:#9C27B0,color:#000
    style I fill:#C8E6C9,stroke:#2E7D32,color:#000
```

### Luồng 5: Nộp bài & Xem kết quả

```mermaid
flowchart TD
    A["📤 SubmitResultView"] --> B["Chọn file bài thi"]
    B --> C["Upload → POST /api/Storage/upload"]
    C --> D{"Upload thành công?"}
    
    D -->|"✅ Thành công"| E["Nhận URL file đã upload"]
    E --> F["Submit bài → POST /api/Submissions"]
    F --> G["✅ Nộp bài thành công"]
    G --> H["Chờ kết quả chấm điểm"]
    H --> I["GET /api/Submissions/results"]
    I --> J["Hiển thị điểm + nhận xét"]
    
    D -->|"❌ Thất bại"| K["Hiển thị lỗi upload"]
    K --> B

    style A fill:#FCE4EC,stroke:#E91E63,color:#000
    style G fill:#C8E6C9,stroke:#2E7D32,color:#000
    style J fill:#E8F5E9,stroke:#4CAF50,color:#000
    style K fill:#FFCDD2,stroke:#C62828,color:#000
```

---

## 🚀 Cài Đặt & Chạy Dự Án

### Yêu cầu hệ thống

- **Flutter SDK** ≥ 3.12.2
- **Dart SDK** ≥ 3.12.2
- **Android Studio** / **VS Code** với Flutter plugin
- **Android SDK** ≥ 37 (cho `flutter_secure_storage`)
- **Git**

### Các bước cài đặt

```bash
# 1. Clone repository
git clone <repository-url>
cd seal-mobile

# 2. Cài đặt dependencies
flutter pub get

# 3. Chạy ứng dụng (debug mode)
flutter run

# 4. Build APK (production)
flutter build apk --release
```

### Cấu hình Backend URL

Mở file `lib/core/constants/api_endpoints.dart` và cập nhật `baseUrl`:

```dart
class ApiEndpoints {
  static const String baseUrl = 'https://api.sealswp391.xyz/';
  // ...
}
```

---

## 📄 License

Dự án này được phát triển cho môn học **PRM392** tại trường **FPT University**.
