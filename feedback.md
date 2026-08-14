# 🦭 SEAL Mobile — Tiến trình Phát triển & Báo cáo Bàn giao (Feedback & Progress Tracker)

> **Dự án**: SEAL Mobile (Student Event Activity Lifecycle)  
> **Cập nhật lần cuối**: 2026-08-14  
> **Kiến trúc**: MVVM + Repository Pattern + Provider + GetIt Service Locator  
> **Design System**: "Command Deck, Pocket Edition" (Dark Navy HUD `#070b14`, Hexagon Grid, Cyan Accent `#00d9ff`, Clipped Corners 8px, Sora & Chakra Petch & JetBrains Mono)  
> **Tài liệu tham chiếu**: `API_LIST.md`, `SEAL_mobile_roadmap.md`, `TONG_QUAN_5_LUONG_SEAL.md`

---

## 📊 1. Tổng quan Trạng thái 9 Giai đoạn Roadmap

| Giai đoạn | Phân hệ / Nghiệp vụ | Trạng thái | Ghi chú / Chi tiết đã hoàn thành |
|:---:|---|:---:|---|
| **GĐ0** | Auth & Onboarding | ✅ **Hoàn thành 100%** | Đăng nhập Email/Google, Đăng ký, Quên MK, Reset MK, Verify Email, Onboarding Role Check, Auto Token Refresh trên 401 |
| **GĐ1** | Hạ tầng dùng chung (Shared Infra) | ✅ **Hoàn thành 100%** | `UserRoleContext`, `ErrorMapper`, `StorageRemoteDataSource` & `StorageRepository` (Multipart Upload), `DioClient` Interceptors, `ApiResult<T>` |
| **GĐ2** | Sự kiện & Hạng mục (Events & Tracks) | ✅ **Hoàn thành 100%** | `EventListView` (Search + Filter), `EventDetailView` (3 Tabs: Luật chơi, Timeline Vòng thi `RoundModel`, Hạng mục `TrackModel`), Vào đội / Tạo đội CTA bar |
| **GĐ3** | Đội thi (Team Management - CRITICAL PATH) | ✅ **Hoàn thành 100%** | `MyTeamView` (State machine: Unassigned, Member, Leader; Warning Banner khi Rejected/Pending; Chốt Đăng ký 3-5 thành viên 100% verified), `CreateTeamView`, `TeamRosterView` (Mời Email, Kick, Chuyển quyền Trưởng nhóm) |
| **GĐ4** | Phân hệ Cố vấn (Mentor Module) | ✅ **Hoàn thành 100%** | `MyTracksView` (Danh sách Track phân công), `TeamsInTrackView` (Roster đội + Avatar Stack), `TeamViewerView` (100% Read-Only, không hiển thị nút chấm điểm/sửa bài) |
| **GĐ5** | Nộp bài dự thi (Submission Flow) | ✅ **Hoàn thành 100%** | `SubmissionListView` (Trạng thái Chưa nộp / Đã nộp / Đã chấm), `SubmitEntryView` (Validate HTTP/HTTPS URL, chọn Track), `SubmissionDetailView` (Chỉnh sửa, Xóa, Khóa chỉnh sửa khi đã chấm hoặc hết hạn) |
| **GĐ6** | Kết quả, BXH & Phúc khảo (Leaderboard & Appeals) | ✅ **Hoàn thành 100%** | `LeaderboardView` (Podium Top 3 dọc với viền sáng Rank #1, Bottom sheet chi tiết điểm tiêu chí), `AppealsView` (Tạo đơn phúc khảo, Xem trạng thái Pending/Accepted/Rejected + Phản hồi từ BTC) |
| **GĐ7** | Thông báo & Hồ sơ cá nhân (Notifications & Profile) | ✅ **Hoàn thành 100%** | `NotificationsView` (Lời mời vào đội thi + Lời mời vai trò Mentor/Judge, Accept/Reject trực tiếp), `ProfileView` (Avatar, Đổi tên, Đổi MK, Ngôn ngữ VI/EN, Đăng xuất), `ProfileVerificationView` (Form cập nhật hồ sơ với search trường đại học qua Schools API, nhập MSSV, upload ảnh thẻ SV, tự động chuyển về Dashboard kèm thông báo hồ sơ đang chờ duyệt), `StudentVerificationGuard` (Chặn tạo đội/vào đội/tham gia sự kiện khi chưa được duyệt sinh viên), `RejectionHistoryView`, `ProfileLockedView` (Request unblock) |
| **GĐ8** | Polish UI/UX, QA & Test Suite | ✅ **Hoàn thành 100%** | `flutter analyze` đạt **0 errors / 0 warnings / 0 infos**, Bộ test `flutter test` đạt **14/14 tests pass 100%** (Unit test State Machine, Auth, Submissions, Widget tests) |

---

## 🌐 2. Ma trận Độ phủ API (23 Controllers / 80+ Endpoints)

| Controller / Nghiệp vụ | Endpoints Phụ trách | Tình trạng Tích hợp |
|---|---|:---:|
| **AuthController** | `login`, `google-login`, `register`, `refresh-token`, `forgot-password`, `reset-password`, `verify-email`, `request-unblock`, `student-profiles` | ✅ Đã kết nối |
| **UsersController** | `GET /api/Users/profile`, `GET /api/Users/my-invitations`, `approve`, `reject` | ✅ Đã kết nối |
| **EventsController** | `GET /api/Events`, `GET /api/Events/{id}`, `GET /api/Events/upcoming`, `GET /api/Events/my-events` | ✅ Đã kết nối |
| **RoundsController** | `GET /api/Rounds/event?eventId={id}` | ✅ Đã kết nối |
| **TracksController** | `GET /api/Tracks`, `GET /api/Tracks/event?eventId={id}`, `GET /api/Tracks/{id}` | ✅ Đã kết nối |
| **TeamsController** | `POST /api/Teams`, `GET /api/Teams/my-team`, `POST /api/Teams/{id}/members/invite`, `POST /api/Teams/invitations/{id}/respond`, `DELETE /api/Teams/{id}/members/{userId}`, `POST /api/Teams/{id}/leave`, `POST /api/Teams/{id}/transfer-leader`, `POST /api/Teams/{id}/confirm-registration` | ✅ Đã kết nối |
| **SubmitResultsController** | `GET /api/SubmitResults`, `POST /api/SubmitResults`, `PUT /api/SubmitResults/{id}`, `DELETE /api/SubmitResults/{id}`, `GET /api/Teams/my-submissions` | ✅ Đã kết nối |
| **StorageController** | `POST /api/Storage/upload` (Multipart file/bytes upload cho ảnh thẻ SV, bài nộp, bằng chứng phúc khảo) | ✅ Đã kết nối |
| **ScoresController** | `GET /api/Scores/team/{teamId}/breakdown`, `POST /api/Scores/save`, `GET /api/Scores/{id}/detail` | ✅ Đã kết nối |
| **FinalResultsController** | `GET /api/FinalResults/round/{roundId}`, `GET /api/FinalResults/team/{teamId}` | ✅ Đã kết nối |
| **AppealsController** | `GET /api/Appeals/my-team`, `GET /api/Appeals/team/{teamId}`, `POST /api/Appeals`, `PUT /api/Appeals/{id}/respond` | ✅ Đã kết nối |
| **Schools & FptMock** | `GET /api/Schools`, `GET /api/fpt-mock/students/{studentCode}` | ✅ Đã kết nối |
| **UserRejectionsController** | `GET /api/UserRejections/my-rejections` | ✅ Đã kết nối |
| **EventRolesController** | `GET /api/EventRoles/my-roles`, `POST /api/EventRoles/invitations/{id}/respond` | ✅ Đã kết nối |

---

## 🏗️ 3. Cấu trúc Source Code Hoàn chỉnh

```
lib/
├── app/
│   ├── app.dart                          # MultiProvider & MaterialApp
│   ├── di/locator.dart                   # GetIt Service Locator đăng ký toàn bộ DataSources, Repos, ViewModels
│   ├── router/                           # AppRouter & RouteNames (27 màn hình)
│   └── theme/                            # AppColors, AppTheme, Typography
├── core/
│   ├── base/base_viewmodel.dart          # Quản lý ViewState (idle, loading, success, error)
│   ├── constants/api_endpoints.dart      # Toàn bộ 80+ endpoints API
│   ├── context/user_role_context.dart    # Role context (Contestant vs Mentor)
│   ├── network/                          # DioClient (Auto Bearer, Refresh Token), ApiResult
│   └── utils/error_mapper.dart           # Chuẩn hóa thông điệp lỗi tiếng Việt
├── data/
│   ├── models/                           # Event, Round, Track, Team, Member, Submission, Score, Appeal, User
│   ├── repositories/                     # Auth, Event, Team, Submission, Score, FinalResult, Appeal, User, Storage
│   └── services/                         # Remote Data Sources kết nối DioClient
└── ui/
    ├── auth/                             # Login, Register, Forgot Password, Splash, Role Check
    ├── common/                           # Shells, BottomNav, Tactical HUD Cards, Buttons, StatusChips
    ├── event/                            # Event List, Event Detail (3 Tabs)
    ├── team/                             # MyTeam Hub, Create Team, Team Roster & Invites
    ├── submission/                       # Submission List, Submit Entry, Submission Detail
    ├── leaderboard/                      # Vertical Top 3 Podium, Criteria Breakdown Sheet
    ├── appeals/                          # Appeals List, Create Appeal
    ├── notifications/                    # Team & Role Invitations Center
    ├── mentor/                           # My Tracks, Teams in Track, Team Viewer
    └── profile/                          # Profile Settings, Student Verification, Rejection History, Locked
```

---

## 🧪 4. Kết quả Kiểm thử Tự động (Verification)

1. **Static Analysis (`flutter analyze`)**:
   ```
   Analyzing seal-mobile...
   No issues found! (0 errors, 0 warnings, 0 infos)
   ```
2. **Automated Test Suite (`flutter test`)**:
   ```
   00:00 +0: AuthRepository Unit Tests: Login success returns Success<AuthResponse> with valid token
   00:00 +1: AuthRepository Unit Tests: Login failure returns Failure result
   00:00 +2: AuthRepository Unit Tests: Register success returns Success<UserProfileModel>
   00:00 +3: SubmissionViewModel Unit Tests: URL validator correctly validates HTTP / HTTPS links
   00:00 +4: SubmissionViewModel Unit Tests: Submitting invalid URL fails validation and sets error
   00:00 +5: SubmissionViewModel Unit Tests: Submitting valid URL adds submission successfully
   00:00 +6: TeamViewModel Unit Tests: Initial user state without team should be TeamUserState.unassigned
   00:00 +7: TeamViewModel Unit Tests: When user is the team leader, userState should be TeamUserState.leader
   00:00 +8: TeamViewModel Unit Tests: When members count is less than 3, canConfirmRegistration returns false
   00:00 +9: TeamViewModel Unit Tests: When team has 3 members but 1 is unverified, canConfirmRegistration returns false
   00:00 +10: TeamViewModel Unit Tests: When team has 3-5 members and 100% verified, canConfirmRegistration returns true
   00:00 +11: TeamViewModel Unit Tests: When team is Rejected, lastRejectReason provides rejection message
   00:01 +12: HudCard Widget Tests: HudCard renders child widget and responds to onTap
   00:02 +13: widget_test.dart: App boots into SplashView and initializes
   00:02 +14: All tests passed! (14/14 tests, 100% SUCCESS)
   ```

---

## 🧭 5. Hướng dẫn Dành cho Developer tiếp tục Phát triển

1. **Khởi động dự án**:
   ```bash
   flutter pub get
   flutter run
   ```
2. **Kiểm tra chuẩn mã nguồn trước khi commit**:
   ```bash
   flutter analyze
   flutter test
   ```
3. **Mở rộng thêm tính năng mới**:
   - Khởi tạo Model trong `lib/data/models/<domain>/`.
   - Thêm phương thức gọi API trong `lib/data/services/<domain>_remote_datasource.dart`.
   - Bọc `ApiResult<T>` trong `lib/data/repositories/<domain>_repository.dart`.
   - Viết ViewModel kế thừa `BaseViewModel` trong `lib/ui/<domain>/viewmodels/`.
   - Đăng ký vào `lib/app/di/locator.dart` và `lib/app/app.dart`.
   - Tích hợp vào View sử dụng `Consumer<YourViewModel>`.
   - Cập nhật checklist trong `feedback.md`.
