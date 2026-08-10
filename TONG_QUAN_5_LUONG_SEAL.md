# SEAL — Tổng quan 5 luồng nghiệp vụ chính

> Tài liệu chia việc cho 5 người. Đọc **Phần A** trước để hiểu cả hệ thống vận hành ra sao (5-10 phút), sau đó vào đúng phần luồng mình phụ trách ở **Phần B** để hiểu sâu. **Phần C** (phụ lục) là danh sách lỗi/việc cần sửa — chỉ cần khi bắt tay code, không cần đọc để hiểu nghiệp vụ.

## Mục lục
- [Phần A — Bức tranh tổng thể](#phần-a--bức-tranh-tổng-thể-đọc-trước-tiên)
- Phần B — Chi tiết từng luồng: [1. Auth & Người dùng](#luồng-1--auth--người-dùng) · [2. Sự kiện & Cấu hình](#luồng-2--sự-kiện-vòng-thi--cấu-hình) · [3. Đội thi](#luồng-3--đội-thi) · [4. Nộp bài & Chấm điểm](#luồng-4--nộp-bài--chấm-điểm) · [5. Kết quả & Giải thưởng](#luồng-5--kết-quả-xếp-hạng-phúc-khảo--giải-thưởng)
- [Phần C — Phụ lục: vấn đề & checklist](#phần-c--phụ-lục-vấn-đề-kỹ-thuật--checklist)

---

## PHẦN A — Bức tranh tổng thể (đọc trước tiên)

SEAL là hệ thống quản lý 1 cuộc thi hackathon từ đầu đến cuối. Đi theo đúng trình tự thời gian thật của 1 cuộc thi, 5 luồng khớp vào nhau như sau:

**1. Chuẩn bị (Luồng 2 — Sự kiện & Cấu hình).** Admin tạo 1 **Sự kiện** (Event), tự động trở thành **EventCoordinator** (EC) của sự kiện đó. EC dựng cấu trúc: 1 sự kiện có nhiều **Vòng thi** (Round, ví dụ Vòng loại → Vòng chung kết), mỗi Vòng có nhiều **Hạng mục** (Track, ví dụ "AI" và "Web" chạy song song trong cùng 1 Vòng). Mỗi Hạng mục gắn với 1 **Bộ tiêu chí chấm** (Template — kho dùng chung mọi sự kiện, không phải con riêng của Event). EC mời thêm **Giám khảo** (Judge) và **Cố vấn** (Mentor) vào từng Hạng mục cụ thể — 1 người có thể vừa làm Mentor Hạng mục này vừa làm Judge Hạng mục khác trong cùng sự kiện.

**2. Ghi danh (Luồng 1 — Auth & Người dùng).** Thí sinh tự đăng ký tài khoản (email/mật khẩu), sau đó nộp hồ sơ để tự phân loại: **SV FPT** (nhập mã số, hệ thống tự xác minh qua 1 API riêng và **tự động duyệt ngay**) hoặc **SV ngoài trường** (chọn trường, nộp ảnh thẻ, **chờ Admin/EC duyệt tay**). Nếu hồ sơ bị từ chối ≥2 lần, tài khoản bị khóa không nộp lại được nữa, chỉ có thể gửi yêu cầu gỡ khóa.

**3. Lập đội (Luồng 3 — Đội thi).** Thí sinh đã được duyệt tạo **Đội** (3-5 người), mời thành viên qua email (người mới sẽ có tài khoản tạm), thành viên bấm đồng ý mới chính thức vào đội. Đủ người rồi, trưởng nhóm **chốt đăng ký** — đội chuyển sang "chờ duyệt", EC duyệt (→ chính thức thi đấu) hoặc từ chối kèm lý do (→ quay lại chỉnh sửa). Đây là bước duyệt **đội**, hoàn toàn tách biệt với duyệt **hồ sơ cá nhân** ở Luồng 1.

**4. Thi đấu (Luồng 4 — Nộp bài & Chấm điểm).** Đội đã duyệt nộp bài (link repo/demo/slide) cho **từng Hạng mục** trong Vòng — 1 đội nộp riêng từng Hạng mục nếu Vòng có nhiều Hạng mục chạy song song. Sau khi hết hạn nộp bài, Giám khảo được phân công đúng Hạng mục vào chấm theo bộ tiêu chí, mỗi Giám khảo 1 phiếu điểm độc lập, quy đổi về thang điểm 10 có trọng số.

**5. Công bố & vinh danh (Luồng 5 — Kết quả & Giải thưởng).** Sau khi chấm xong, EC bấm **Tính kết quả** — hệ thống tự tính điểm trung bình + xếp hạng cho cả Vòng, ra bản **nháp**. EC rà soát rồi bấm **Công bố** thì mọi người mới xem được. Đội không đồng ý điểm có thể gửi **đơn phúc khảo**. Cuối cùng EC gán **Giải thưởng** cho các đội dựa theo bảng xếp hạng.

**Vai trò xuyên suốt cả 5 luồng:** Admin (toàn quyền) → EC (quản lý 1 sự kiện cụ thể: duyệt hồ sơ, duyệt đội, mời người, tính/công bố kết quả, phúc khảo, giải thưởng) → Judge/Mentor (vai trò gắn theo từng Hạng mục) → TeamLeader/TeamMember (thí sinh).

**3 điểm lệch lớn nhất giữa đề bài và code hiện tại, nên biết ngay từ đầu** (chi tiết đầy đủ ở Phần C):
- Xếp hạng hiện chỉ tính gộp theo **Vòng**, chưa tách riêng theo **từng Hạng mục** như đề bài yêu cầu.
- Tính năng **"Loại đội vi phạm quy chế"** (Disqualify) chưa tồn tại — enum có sẵn chỗ nhưng chưa ai dùng.
- Nhánh **RBL** (thu thập dữ liệu nghiên cứu — vòng hiệu chuẩn, xuất CSV ẩn danh, dashboard phương sai) hoàn toàn chưa làm — 0%.

---

## PHẦN B — Chi tiết từng luồng

### Luồng 1 — Auth & Người dùng

Flow này lo đăng ký/đăng nhập (email+mật khẩu và Google), quên/đổi mật khẩu, nộp hồ sơ sinh viên (FPT tự động duyệt qua mock API, ngoài FPT nộp ảnh thẻ chờ duyệt thủ công), duyệt/từ chối hồ sơ, và cơ chế khóa tài khoản sau 2 lần bị từ chối. Cơ chế "tài khoản tạm" (`IsTemporary`) không chỉ dùng cho giám khảo khách mời như đề bài mô tả mà dùng chung cho mọi loại lời mời (giám khảo, mentor, EC, thành viên đội).

**Nghiệp vụ cần hiểu:**

Đăng ký công khai (`POST /Auth/register`) chỉ cần email/mật khẩu/họ tên. Tài khoản tạo ra chưa xác thực email, chưa duyệt, chưa phân loại gì cả. Việc "tự phân loại SV FPT / SV ngoài trường" diễn ra ở **bước sau**, khi đã đăng nhập và gọi `POST/PUT /Auth/student-profiles` — thiết kế 2 bước, không phải thiếu sót.

**SV FPT**: nộp mã số SV, hệ thống gọi FPT Mock API xác minh, khớp thì **tự động duyệt** ngay. **SV ngoài FPT**: chọn trường từ danh sách có sẵn, bắt buộc ảnh thẻ, chờ Admin/EC duyệt tay.

**Giám khảo khách mời (và mọi vai trò được mời khác)**: khi EC mời ai đó mà email chưa có tài khoản, hệ thống tự tạo **tài khoản tạm** (`IsTemporary=true`) + gửi mail kích hoạt. Bấm link kích hoạt → tự sinh mật khẩu tạm + tự động duyệt. Đăng nhập tài khoản tạm bị giới hạn theo "vòng đời sự kiện": phải còn `EventRole` hoặc lời mời còn hạn.

**Khóa tài khoản sau ≥2 lần từ chối**: mỗi lần từ chối tạo 1 `UserRejection`. Tổng số bản ghi (đếm suốt vòng đời tài khoản) đạt ≥2 thì khóa nộp lại hồ sơ, chỉ gửi được "yêu cầu gỡ khóa" để BTC tự tay xóa bớt 1 bản ghi.

**4 trạng thái hồ sơ** (`resolveRegistrationStatus`): ưu tiên `approved` → `rejected` (có bản ghi từ chối đang active) → `unregistered` (chưa từng nộp) → còn lại `pending`.

**Kiến trúc hiện có (tóm tắt các cụm chính, đầy đủ file:line xem file gốc `FLOW_1_AUTH_NGUOIDUNG.md`):**
- Đăng ký / xác thực email: `AuthController.cs:36-43` → `RegisterUserCommandHandler`; `AuthController.cs:123-130` → `VerifyEmailCommandHandler`.
- Đăng nhập thường/Google/refresh/logout: `AuthController.cs:45-111` → `LoginUserCommandHandler`/`GoogleLoginCommandHandler`/`RefreshTokenCommandHandler`/`LogoutCommandHandler`.
- Quên/đổi mật khẩu: `AuthController.cs:85-121` → `ForgotPasswordCommandHandler`/`ResetPasswordCommandHandler`/`ChangePasswordCommandHandler`. Hash dùng chung `FixedSaltPasswordHasher`.
- Hồ sơ SV FPT/ngoài trường: `AuthController.cs:132-148` → `UpdateStudentProfileCommandHandler` (nhánh FPT gọi `FptMockController`, nhánh ngoài trường bắt buộc ảnh thẻ).
- Duyệt/Từ chối/Khóa: `UsersController.cs:140-160` → `ApproveUserCommandHandler`/`RejectUserCommandHandler`; `AuthController.cs:76-83` → `RequestUnblockCommandHandler`; `UserRejectionsController.cs:89-95` → `DeleteUserRejectionCommandHandler` (cách duy nhất gỡ khóa).
- Trường học: `SchoolsController.cs` — CRUD chuẩn, chỉ Admin sửa được.

---

### Luồng 2 — Sự kiện, Vòng thi & Cấu hình

Flow này gồm `Event → Round → Track`, `Template → TemplateCriteria → Criteria` (bộ tiêu chí, tách biệt hoàn toàn khỏi Event/Round/Track), và `EventRole`/`EventRoleInvitation` (phân vai trò EC/Judge/Mentor).

**Nghiệp vụ cần hiểu:**

**Event** là gốc, chứa nhiều **Round**, mỗi Round chứa nhiều **Track**. Round có `AdvancementRule` (top N / phần trăm / điểm sàn) quyết định đội nào đi tiếp.

**Template** và **Criteria** là 2 thực thể **toàn cục, không gắn EventId** — kho dùng chung cho mọi sự kiện. 1 Track trỏ tới đúng 1 Template. Template phải có tổng trọng số tiêu chí = 100% trước khi gắn vào Track.

**School** chỉ gắn với `User`, **không hề gắn với Event** — không có cơ chế "sự kiện chỉ mở cho trường X".

**EventRole** gán vai trò người dùng ↔ sự kiện, kèm `TrackId` (Judge/Mentor theo hạng mục) hoặc `TeamId` (thí sinh). Judge/Mentor được mời qua **EventRoleInvitation**, chỉ thật sự có vai trò khi bấm "Đồng ý". Quy tắc kiêm nhiệm: EC không kiêm Judge/Mentor trong cùng sự kiện; nhưng Judge và Mentor được kiêm nhiệm nhau **miễn khác Track** (1 người vừa Mentor Track A vừa Judge Track B).

Chỉ **Admin** được tạo Event; người tạo tự động thành EventCoordinator đầu tiên.

**Kiến trúc hiện có (tóm tắt, đầy đủ ở file gốc `FLOW_2_SUKIEN_VONGTHI_CAUHINH.md`):**
- Event: `EventsController.cs:54-131` → `CreateEventCommandHandler` (Admin-only, auto-assign EC), `UpdateEventCommandHandler`, `DeleteEventCommandHandler`.
- Round: `RoundsController.cs:39-103` → Create/Update/Delete/Get, `AdvancementRule` validate bằng regex ngay lúc nhập.
- Track: `TracksController.cs:41-120` → Create/Update/Delete/AssignTemplate, trả kèm danh sách Judges/Mentors.
- Template/Criteria: `TemplatesController.cs`, `CriteriasController.cs` — CRUD, chặn sửa tiêu chí sau khi đã có phiếu chấm dùng.
- Phân vai trò: `EventRolesController.cs` (assign/invitations/respond), `EventCoordinatorsController.cs`, `JudgesController.cs`, `MentorsController.cs` (2 endpoint chuyên biệt FE thực dùng để mời Judge/Mentor theo Track).

---

### Luồng 3 — Đội thi

Tạo đội, mời/duyệt thành viên qua `TeamInvitation` (dùng chung cho cả mời vào đội lẫn chuyển quyền trưởng nhóm), quy trình 2 bước "chốt danh sách rồi chờ EC duyệt" tách biệt khỏi duyệt tài khoản cá nhân.

**Nghiệp vụ cần hiểu:**

1 đội gắn với đúng 1 **Event** (không gắn Track ở tầng Team). Người tạo đội tự động thành `TeamLeader`, đội bắt đầu `Forming` — tối đa 5 người.

Trưởng nhóm mời thành viên bằng email; người được mời `RespondTeamInvitation` (đồng ý/từ chối), đồng ý mới thật sự vào đội.

Đủ 3-5 người và tất cả đã nộp hồ sơ thí sinh, trưởng nhóm `ConfirmTeamRegistration` → đội khóa lại, chuyển `PendingApproval`. EC `ApproveTeamRegistration` (→ `Registered`) hoặc `RejectTeamRegistration` kèm lý do bắt buộc (→ về `Forming`). Đây là quy trình duyệt **hoàn toàn tách biệt** với duyệt tài khoản cá nhân.

Chuyển quyền trưởng nhóm không tức thời — tạo 1 `TeamInvitation` trạng thái `TransferPending`, người nhận phải bấm đồng ý qua chuông thông báo.

Việc "gắn đội vào 1 Hạng mục" không tồn tại như 1 hành động rõ ràng ở Team — nó chỉ phát sinh gián tiếp khi đội nộp bài (thuộc Luồng 4).

**Kiến trúc hiện có (tóm tắt, đầy đủ ở file gốc `FLOW_3_DOITHI.md`):**
- Tạo/sửa/xóa: `TeamsController.cs:112-142` → Create/Update/Delete.
- Mời & xác nhận: `TeamsController.cs:189-274` → AddMember/InviteMember/RespondInvitation/RemoveMember/LeaveTeam/GetTeamInvitations.
- Chuyển quyền: `TeamsController.cs:292` → `TransferTeamLeaderCommandHandler`.
- Chốt & duyệt đăng ký: `TeamsController.cs:312-344` → ConfirmRegistration/ApproveRegistration/RejectRegistration.

---

### Luồng 4 — Nộp bài & Chấm điểm

Đội nộp bài bằng URL cho **từng Track**, không phải cho cả Round — 1 Round có thể có nhiều Track chạy song song, đội nộp riêng từng Track. Giám khảo chấm theo bộ tiêu chí gắn với Track đó.

**Nghiệp vụ cần hiểu:**

**Đơn vị nộp bài là Track, không phải Round.** Mỗi đội nộp 1 bài / 1 Track — hệ thống từng chặn nhầm theo Round khiến đội không nộp được hạng mục thứ 2, **đã fix và vẫn còn nguyên trong code hiện tại**.

Track có khung giờ **nộp bài** (StartDate→EndDate, thừa hưởng từ Round nếu không tự cấu hình) và khung **chấm điểm** (ScoringStartDate→ScoringEndDate) tách biệt, khung chấm luôn mở SAU khi khung nộp đóng.

Giám khảo phân theo Track qua `EventRole.TrackId`. Hệ thống **không có field riêng** phân biệt "giám khảo nội bộ/khách mời" như câu chữ đề bài — cả hai đều là `EventRoleType.Judge`, khác nhau ở có/không gán TrackId.

1 phiếu chấm có 2 trạng thái: **nháp** và **đã chốt** (`Score.IsSubmitted`). "Tính kết quả vòng" tạo `FinalResult` nháp; ngay khi tồn tại (kể cả nháp), toàn bộ nộp/sửa bài/chấm điểm của vòng đó bị khóa cứng.

**Kiến trúc hiện có (tóm tắt, đầy đủ ở file gốc `FLOW_4_NOPBAI_CHAMDIEM.md`):**
- Nộp bài: `SubmitResultsController.cs` → Create/Update/Delete/GetAll/GetById, có chống nộp trùng + chống race condition (bài `CreatedTime` sớm nhất thắng).
- Chấm điểm — endpoint chính: `POST /api/Scores/save` → `SaveScoreCommandHandler` (12 lớp kiểm tra: đúng vai trò Judge, đúng Track, chặn xung đột lợi ích, đủ tiêu chí, đúng khung giờ...).
- 2 luồng UI: chỉ còn `SubmissionsScoringPanel.jsx` là luồng sống thật (dùng ở cả `/scoring` và tab "Bài nộp"); `ScoringPanel.jsx` cũ đã bị gỡ hẳn khỏi route, không còn cách nào vào được qua UI.

---

### Luồng 5 — Kết quả, Xếp hạng, Phúc khảo & Giải thưởng

3 cụm: (1) tự động tính điểm/xếp hạng rồi công bố/thu hồi, (2) xử lý đơn phúc khảo, (3) quản lý và gán giải thưởng.

**Nghiệp vụ cần hiểu:**

Sau khi chấm xong 1 vòng, EC bấm "Tính kết quả" — hệ thống tự tính điểm trung bình + xếp hạng, nhưng ra dạng **NHÁP**, chỉ EC/Admin xem được. EC bấm "Công bố" riêng thì mọi người mới thấy. Phát hiện sai sót: "Thu hồi" (ẩn tạm, giữ số liệu, đảo lại được) hoặc "Xóa & tính lại" (xóa sạch, tính lại từ đầu) — cả 2 khóa nếu vòng sau đã vận hành dựa trên kết quả này.

Đội (qua Team Leader) gửi đơn phúc khảo cho 1 bài nộp trong lúc vòng còn diễn ra; EC/Admin duyệt (chấp nhận → gán giám khảo chấm lại, hoặc từ chối kèm phản hồi).

Giải thưởng: EC tạo trước danh sách giải, rồi **tự tay** chọn giải gán cho từng đội — không có logic "Rank 1 tự động nhận Giải Nhất".

**Kiến trúc hiện có (tóm tắt, đầy đủ ở file gốc `FLOW_5_KETQUA_PHUCKHAO_GIAITHUONG.md`):**
- Tính kết quả: `FinalResultsController.cs:68-77` → `CalculateRoundResultsCommandHandler` (điểm trung bình các Track gộp thành 1 con số cho cả Vòng, xếp hạng kiểu "1-1-3").
- Công bố/Thu hồi: `POST .../publish/{roundId}`, `PUT .../publish-status`, `DELETE .../round/{roundId}` → 3 handler tương ứng.
- Phúc khảo: `AppealsController.cs` → Create/Respond/GetByRound/GetByTeam/GetAssigned.
- Giải thưởng: `PrizesController.cs` (CRUD giải) + `AssignPrizeCommandHandler` (gán tay cho từng đội).

---

## PHẦN C — Phụ lục: Vấn đề kỹ thuật & Checklist

> Đọc phần này khi đã hiểu nghiệp vụ (Phần A+B) và sẵn sàng bắt tay code. Mỗi mục có mức độ ưu tiên P0 (nghiêm trọng, nên sửa trước) / P1 / P2, kèm bằng chứng file:line — xem đầy đủ chi tiết + đoạn code trích dẫn trong 5 file gốc tương ứng (`FLOW_1...md` đến `FLOW_5...md`), ở đây chỉ liệt kê tiêu đề để tra cứu nhanh.

### Luồng 1 — Auth & Người dùng
- **P0**: `UserRejectionsController` không có `[Authorize]` + tin thẳng `RejectedBy` do client tự truyền → giả mạo khóa tài khoản người khác được.
- **P0**: `RegisterUserCommandHandler` gửi email không bọc try/catch → SMTP lỗi crash 500, tài khoản kẹt vĩnh viễn.
- **P0**: FE có UI "Gửi lại email xác thực" nhưng route `POST /Auth/resend-verification` không tồn tại ở BE.
- **P0**: "Bắt buộc đổi mật khẩu cho tài khoản tạm" không hoạt động — BE không trả field `mustChangePassword`.
- **P0**: SV ngoài trường không có cách hoàn tất đăng ký nếu trường chưa có trong danh sách — dead-end.
- P1: hash mật khẩu salt cố định; không rate-limit login; "(Soft Delete)" trong doc sai (thực chất hard delete); `ChangePassword` không vô hiệu refresh token.
- Checklist đầy đủ: xem `FLOW_1_AUTH_NGUOIDUNG.md`.

### Luồng 2 — Sự kiện, Vòng thi & Cấu hình
- **P0**: Bước **chấp nhận** lời mời chặn nhầm case "Mentor Track A + Judge Track B" — đúng case đề bài yêu cầu phải cho phép (thiếu so `TrackId`).
- **P0**: Quyền sửa Template/Criteria cấp cho EC của **bất kỳ** Event nào, không giới hạn theo Event thực dùng.
- **P0**: FE luôn sửa trực tiếp Template dùng chung thay vì tạo bản sao — dựa vào field `isSystem` mà BE không hề trả.
- P1: nhánh permission chết (Validator cho EC tạo Event, Handler chặn cứng chỉ Admin); "(Soft Delete)" sai ở 5 controller; 2 tầng quyền không khớp ở Delete Template/Criteria.
- Checklist đầy đủ: xem `FLOW_2_SUKIEN_VONGTHI_CAUHINH.md`.

### Luồng 3 — Đội thi
- **P0**: Từ chối hồ sơ 1 thành viên → tự động hạ cấp **cả đội** về `Forming`, kể cả đội đã `Registered`/đã nộp bài, không báo lý do.
- P1: `TeamStatus.Rejected`/`Disqualified` chưa từng được gán ở đâu; không có bước "đăng ký đội vào 1 Hạng mục cụ thể" (đội nộp được nhiều Track không giới hạn); FE hứa gửi email khi xóa/rời đội nhưng BE không gửi; `GET /Teams` thiếu Status gây N+1 API; 3 TODO thông báo còn treo trong code.
- Checklist đầy đủ: xem `FLOW_3_DOITHI.md`.

### Luồng 4 — Nộp bài & Chấm điểm
- **P0**: `CalculateRoundResultsCommandHandler` không lọc `Score.IsSubmitted` — điểm nháp vẫn bị tính nếu EC tính kết quả trước khi giám khảo chốt điểm.
- **P0**: 4 endpoint chấm điểm kiểu cũ (`POST/PUT /Scores`, `/ScoreDetails`) vẫn sống, gọi qua Swagger được, validate yếu hơn hẳn `/Scores/save`.
- P1: chưa tích hợp GitHub/GitLab API (đề ghi Optional, 0% đã làm); bài nộp không ẩn danh (URL lộ tên đội); interface FE khai sai field so với model BE thật.
- Checklist đầy đủ: xem `FLOW_4_NOPBAI_CHAMDIEM.md`.

### Luồng 5 — Kết quả, Xếp hạng, Phúc khảo & Giải thưởng
- **P0**: `PrizesController` không có `[Authorize]` ở đâu cả — ai cũng gọi được kể cả chưa đăng nhập.
- **P0**: Tính năng "Loại đội vi phạm quy chế" chưa tồn tại.
- **P0**: Xếp hạng theo **từng Hạng mục** và theo **toàn sự kiện** chưa được tự động hóa — chỉ gộp theo Vòng.
- **P0**: Không có nhật ký kiểm tra (audit log) — Unpublish/Recalculate còn xóa cứng, mất luôn dấu vết.
- **P0**: Nhánh RBL (vòng hiệu chuẩn, xuất CSV ẩn danh, dashboard phương sai) — 0% đã làm.
- P1: `GetFinalResultById` không lọc quyền/`IsPublished`; IDOR trên 3 endpoint GET của Appeals; check "cấm phúc khảo sau công bố" là code chết (biến fetch ra nhưng không dùng); chưa có export CSV/Excel; gán giải hoàn toàn thủ công không liên kết `Rank`.
- Checklist đầy đủ: xem `FLOW_5_KETQUA_PHUCKHAO_GIAITHUONG.md`.
