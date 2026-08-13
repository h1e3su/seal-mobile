# SEAL Mobile — Bộ prompt tạo wireframe (7 đợt, mỗi đợt ≤4 màn)

## Cách dùng
1. Công cụ giới hạn 4 màn/lần → 27 màn hình được chia thành **7 đợt** bên dưới.
2. Ở **mỗi đợt**, dán nguyên khối **"DESIGN SYSTEM"** ngay phía trên phần "Yêu cầu 4 màn hình" — kể cả khi tạo trong cùng 1 phiên hay phiên mới, để tool không tự bịa lại style.
3. Làm lần lượt Batch 1 → Batch 7. Nếu tool cho đính kèm ảnh, đính kèm 1-2 wireframe của đợt trước vào đợt sau để giữ đồng bộ (font, corner radius, khoảng cách) — nếu không hỗ trợ ảnh, khối Design System text là đủ.
4. Batch 7 chỉ có 3 màn hình (27 = 6×4 + 3), không cần thêm cho đủ 4.

---

## 🔒 DESIGN SYSTEM (dán vào MỌI đợt)

```
Thiết kế wireframe mobile app theo design system "Command Deck, Pocket Edition":

THEME: Dark navy HUD/cyber-tactical, không dùng theme SaaS trắng/bo tròn kiểu Notion/Linear.

MÀU SẮC:
- Nền chính: #070b14 (navy đậm) | Nền panel/card: #0f1826 | Nền input: #152238
- Accent chính: #00d9ff (cyan điện) | Accent phụ: #3b82f6
- Accent theo vai trò: Contestant/Team = #38bdf8 (sky blue) | Mentor = #2dd4bf (teal)
- Trạng thái: success #10b981 | danger #ef4444 | warning #f59e0b
- Chữ: primary #e6edf7 | muted #8a97ac | border #1e2e4a

TYPOGRAPHY (đều có dấu tiếng Việt):
- Tiêu đề màn hình: Chakra Petch, 22px/600
- Tiêu đề section: Chakra Petch, 16px/600
- Body: Sora, 15px/400 | Caption: Sora, 13px/400
- Số liệu/mono (điểm, ID, ngày, đếm ngược): JetBrains Mono, 14px/500; đếm ngược lớn 28px/700
- Không chữ nào < 13px

HÌNH KHỐI & KHOẢNG CÁCH:
- Góc bo dạng "clipped corner" (vát góc chéo 8px), KHÔNG bo tròn thường
- Card có thanh accent màu ở cạnh trái theo vai trò/trạng thái
- Tap target tối thiểu 44×44pt, đơn vị spacing 4/8/12/16/24/32, padding ngang màn hình 16px
- CTA chính luôn neo cố định ở đáy màn hình dạng thanh action bar full-width, cao 48pt
- Glow nhẹ (opacity ~0.10), không dùng blur nặng

COMPONENT PATTERNS:
- List/bảng desktop → Card list dạng stack (mỗi item 1 card, không dùng table)
- Modal/drawer desktop → Bottom sheet trượt lên từ đáy, có thể vuốt để đóng
- Badge trạng thái: nền mờ + viền 1px + icon/text tag đi kèm (không chỉ dùng màu) — ví dụ: "✔ REGISTERED" (xanh), "✘ DISQUALIFIED" (đỏ), "⚠ PENDING" (vàng)
- Bottom tab bar 4 mục, tab active có viền trên 2px màu accent, icon set Lucide
- Mỗi màn hình chỉ có 1 hành động chính (single-focus screen), không nhồi nhiều panel như desktop

NAVIGATION:
- Contestant: tab bar [Home] [My Team] [Submissions] [Leaderboard] + icon chuông (Notifications) và avatar (Profile) ở góc phải trên, không tính vào 4 tab
- Mentor: tab bar [Home] [My Tracks] [Teams] [Notifications] + avatar (Profile) góc phải trên

Với mỗi màn hình, vẽ ở khung mobile 375×812 (iPhone chuẩn), thể hiện rõ: trạng thái mặc định, trạng thái rỗng (empty state) nếu có, và vị trí tab bar/status bar.
```

---

## BATCH 1 — Auth Core (S1–S4)
```
Tạo 4 màn hình wireframe theo Design System ở trên:

1. SPLASH / LANDING
   - Logo khiên SEAL (SVG tĩnh, không animation loop) căn giữa trên nền navy có lưới hexagon mờ 4% opacity
   - Không có nút bấm, chỉ là màn hình chuyển tiếp trong lúc check session

2. LOGIN
   - Input email, input mật khẩu (icon show/hide password)
   - Nút "Quên mật khẩu?" dạng text link nhỏ
   - CTA chính "// ĐĂNG NHẬP >" neo đáy
   - Nút phụ "Đăng nhập với Google" (ghost button, icon Google)
   - Link "Chưa có tài khoản? Đăng ký" dưới cùng

3. REGISTER
   - Input: Họ tên, Email, Mật khẩu, Xác nhận mật khẩu
   - Checkbox đồng ý điều khoản
   - CTA "// TẠO TÀI KHOẢN >" neo đáy

4. CHECK YOUR EMAIL (S4 — KHÔNG có OTP, KHÔNG phải màn đích riêng)
   - ⚠️ S4 không phải 1 điểm đến điều hướng mới — nó CHÍNH LÀ màn Login (S2), chỉ khác là có thêm 1 lớp thông báo (banner/toast) nổi đè lên trên. Vẽ 2 khung riêng để thấy rõ 2 trạng thái là hợp lý cho việc thiết kế, nhưng khi LINK các màn (Phần 2), nút của S3 phải trỏ về **S2**, không trỏ tới "S4" như một màn hình độc lập
   - Sau khi đăng ký xong ở S3, app tự động redirect về S2, và ngay khi vừa vào S2 thì "nổ" (bật) thêm 1 banner/toast nổi phía trên form: icon mail, text "Kiểm tra hộp thư [email] và bấm vào link kích hoạt để hoàn tất đăng ký"
   - Nút text nhỏ "Không nhận được email? Gửi lại" (đếm ngược 00:59 trước khi bấm lại được)
   - Nếu user cố đăng nhập khi tài khoản chưa kích hoạt → inline error dưới nút Login: "Tài khoản chưa kích hoạt — vui lòng kiểm tra email", nút "ĐĂNG NHẬP" chuyển trạng thái disabled (viền đỏ)
   - Việc kích hoạt thật sự diễn ra khi user bấm link trong Gmail → mở trình duyệt/deep-link xác nhận → quay lại app ở S2, LẦN NÀY banner đổi màu xanh "✔ Kích hoạt thành công, hãy đăng nhập" rồi tự biến mất sau vài giây (không phải banner vàng "kiểm tra hộp thư" nữa)
```

---

## BATCH 2 — Auth cont. + Home + Profile (S5–S6, C1–C2)
```
Tạo 4 màn hình wireframe theo Design System ở trên:

1. FORGOT / RESET PASSWORD (2 bước trong 1 khung, thể hiện bước 1)
   - Bước 1: input email + CTA "Gửi yêu cầu"
   - Bước 2 (thumbnail nhỏ bên cạnh hoặc mô tả riêng): input mật khẩu mới + xác nhận + CTA "Đặt lại mật khẩu"

2. ONBOARDING ROLE CHECK
   - Chỉ hiện khi user có ≥2 EventRole (Contestant + Mentor)
   - 2 card lớn để chọn: "Tham gia với vai trò Thí sinh" (accent sky-blue) / "Tham gia với vai trò Mentor" (accent teal)

3. HOME (Contestant — C1)
   - Bento-style stacked cards, KHÔNG phải dashboard dày đặc
   - Card countdown lớn (mono 28px) đến hạn nộp bài gần nhất, chuyển đỏ nháy nếu <24h
   - Card tóm tắt đội (tên đội, số thành viên, status badge)
   - Card quick-link "Nộp bài" / "Xem BXH"
   - Bottom tab bar Contestant active ở "Home"

4. PROFILE VERIFICATION (C2 — bước 1: chọn loại hồ sơ)
   - 2 lựa chọn dạng card lớn: "Tôi là sinh viên FPT" / "Tôi là sinh viên trường khác"
   - Nhánh FPT: hiện thêm input "Mã số sinh viên" + CTA "Xác minh"
   - Nhánh ngoài FPT: hiện dropdown chọn trường + Dropzone camera-first "Chụp/tải ảnh thẻ SV"
   - Progress indicator dạng step 1/2 ở đầu màn hình
```

---

## BATCH 3 — Profile Locked + Event + Team Hub (C3–C6)
```
Tạo 4 màn hình wireframe theo Design System ở trên:

1. PROFILE LOCKED (C3)
   - Full-screen blocking state, icon ⚠ lớn màu warning
   - Text: "PROFILE LOCKED — Hồ sơ đăng ký của bạn đã bị từ chối 2 lần trở lên"
   - CTA "[ REQUEST UNBLOCK ]" — sau khi bấm chuyển thành đếm ngược mono "Đang chờ xử lý — 23:59:12"
   - Không có tab bar (chặn toàn màn hình)

2. EVENT LIST (C4)
   - Card list các sự kiện: tên event, thời gian diễn ra, StatusBadge (Đang mở/Đã đóng)
   - Search/filter bar phía trên
   - Empty state: "Chưa có sự kiện nào đang mở đăng ký"

3. EVENT DETAIL (C5)
   - Header ảnh/banner event
   - Tabs con: Luật chơi | Timeline | Hạng mục (Track)
   - Nội dung read-only dạng text/card
   - CTA "[ TẠO ĐỘI ]" hoặc "[ VÀO ĐỘI ]" neo đáy tùy trạng thái user

4. MY TEAM HUB (C6) — thể hiện cả 3 trạng thái dưới dạng 3 khung nhỏ cạnh nhau hoặc chọn trạng thái "Team Leader" làm chính
   - Unassigned: 2 CTA lớn "[Tạo đội]" / "[Vào đội]"
   - Member: card roster read-only, nút "Rời đội" (ghost, cần confirm dialog)
   - Leader: card roster (edit được), banner cảnh báo nếu LastRejectReason tồn tại (viền đỏ + text lý do), nút "[ CHỐT ĐĂNG KÝ ]" — disabled kèm tooltip nếu chưa đủ 3-5 thành viên hoặc có thành viên chưa xác minh hồ sơ
```

---

## BATCH 4 — Roster/Invite + Submissions (C7–C10)
```
Tạo 4 màn hình wireframe theo Design System ở trên:

1. TEAM ROSTER & INVITE (C7 — chỉ Leader)
   - Danh sách member card (avatar, tên, badge xác minh hồ sơ)
   - Swipe-to-remove trên mỗi card (kèm icon nút xóa tương đương để không chỉ dựa vào vuốt)
   - CTA "[ MỜI THÀNH VIÊN ]" mở Bottom Sheet: input email + nút gửi
   - Nút "[ CHUYỂN QUYỀN TRƯỞNG NHÓM ]" (ghost), khi bấm hiện banner đếm ngược 24h "Yêu cầu chuyển quyền — hết hạn sau 23:45:00"

2. TEAM INVITATION RESPONSE (C8)
   - Bottom Sheet: tên đội mời, tên người mời, vai trò
   - 2 nút "[ CHẤP NHẬN ]" (cyan fill) / "[ TỪ CHỐI ]" (ghost, viền đỏ)

3. SUBMISSION LIST (C9)
   - Card list theo từng Track (không theo Round): tên Track, StatusBadge (Chưa nộp/Đã nộp/Đã chấm), countdown chip nếu vòng nộp còn mở
   - Tap → Submission Detail

4. SUBMISSION DETAIL / EDIT (C10)
   - Input URL (paste-from-clipboard icon), textarea mô tả
   - Trạng thái khóa: nếu vòng nộp đã đóng, toàn bộ input hiện dạng disabled + banner "Đã hết hạn nộp bài"
   - CTA "[ CẬP NHẬT ]" / "[ XÓA BÀI NỘP ]" (chỉ hiện khi chưa qua hạn)
```

---

## BATCH 5 — Submit New + Results + Notifications (C11–C13, N1)
```
Tạo 4 màn hình wireframe theo Design System ở trên:

1. SUBMIT NEW ENTRY (C11)
   - Chọn Track (dropdown, nếu Round có nhiều Track song song)
   - Input URL repo/demo/slide (validate regex, hiện lỗi inline nếu sai định dạng)
   - Textarea mô tả ngắn
   - CTA "// NỘP BÀI >" neo đáy

2. LEADERBOARD (C12)
   - Mobile Podium: top 3 xếp DỌC (không ngang như desktop) — rank 1 trên cùng, khung clipped-corner glow
   - Card list các đội còn lại: rank (mono lớn), tên đội, điểm (mono, phải), mũi tên ▲/▼ + màu đổi hạng
   - Tap 1 row → mở Score Detail Sheet (bottom sheet hiện breakdown điểm theo tiêu chí, read-only)

3. APPEALS (C13)
   - Danh sách đơn phúc khảo đã gửi: card có StatusBadge (Đang chờ/Chấp nhận/Từ chối)
   - CTA "[ GỬI PHÚC KHẢO ]" mở Bottom Sheet: chọn bài nộp liên quan, textarea lý do, đính kèm ảnh tùy chọn

4. NOTIFICATIONS CENTER (N1)
   - Card list: icon theo loại (mời đội/kết quả/phúc khảo/deadline), text, timestamp, chấm tròn cyan cho tin chưa đọc
   - Swipe để đánh dấu đã đọc (kèm nút tương đương)
```

---

## BATCH 6 — Settings + Mentor Home/Tracks (N2–N3, M1–M2)
```
Tạo 4 màn hình wireframe theo Design System ở trên:

1. PROFILE / SETTINGS (N2)
   - Avatar + nút đổi ảnh
   - Input tên hiển thị
   - Mục "Đổi mật khẩu" (link tới flow riêng)
   - Toggle pill 2 trạng thái "EN / VI" (không dùng icon cờ)
   - Nút "[ ĐĂNG XUẤT ]" (ghost, viền đỏ) ở cuối

2. REJECTION HISTORY (N3 — chỉ Contestant)
   - Card list các lần bị từ chối hồ sơ: ngày, lý do (text field từ EC/Admin), badge đỏ
   - Empty state: "Bạn chưa từng bị từ chối hồ sơ"

3. MENTOR HOME (M1)
   - Bento cards: số Track được gán, số đội "cần chú ý" (sắp hết hạn nộp mà chưa nộp) nổi bật màu warning
   - KHÔNG có bất kỳ nút chấm điểm/sửa nào trên toàn màn hình
   - Bottom tab bar Mentor active ở "Home", accent teal

4. MY TRACKS (M2)
   - Card list các Track được phân công: tên Track, tên Round/Event cha, số đội trong Track
   - Tap → Teams in Track
```

---

## BATCH 7 — Mentor Teams + Viewer + Invite (M3–M5, chỉ 3 màn)
```
Tạo 3 màn hình wireframe theo Design System ở trên:

1. TEAMS IN TRACK (M3)
   - Card list đội thuộc Track: tên đội, StatusBadge, avatar stack thành viên (tối đa 5, +N nếu dư)
   - Read-only hoàn toàn, tap → Team/Submission Viewer

2. TEAM / SUBMISSION VIEWER (M4)
   - Card roster đội (read-only)
   - Card tiến độ nộp bài theo từng Track được gán (StatusBadge, không hiện điểm nếu Mentor không có quyền xem điểm)
   - KHÔNG có nút sửa/chấm điểm nào xuất hiện dù disabled — đây là ranh giới cứng, không vẽ nút bị mờ

3. ROLE INVITATION RESPONSE (M5)
   - Bottom Sheet giống C8: tên sự kiện, Track được mời làm Mentor, tên người mời
   - 2 nút "[ CHẤP NHẬN ]" / "[ TỪ CHỐI ]"
```

---

---

# PHẦN 2 — Prompt liên kết (link) các màn hình qua button

Cùng lý do giới hạn 4/lần, việc gắn link cũng chia theo **đúng 7 đợt** ở Phần 1 — mỗi đợt bạn nối các nút của 4 màn vừa tạo tới đích của chúng (đích có thể nằm ở đợt khác, cứ tham chiếu bằng mã màn hình vì màn đó đã tồn tại trong file/board của bạn rồi).

## 🔒 QUY ƯỚC CHUNG (dán vào mọi đợt link)
```
Khi liên kết các khung: mỗi nút/CTA/card chỉ trỏ tới ĐÚNG 1 màn đích. Nút dạng "ghost/text link" trỏ đích phụ (VD: quên mật khẩu, đăng xuất). Bottom sheet (C8, M5, Score Detail trong C12) coi là lớp phủ lên trên màn gọi nó, không phải màn full-screen riêng — khi đóng sheet, quay lại đúng màn nền đã mở nó. Card trong bottom tab bar luôn trỏ về đúng 1 trong 4 tab gốc theo persona.
```

## BATCH LINK 1 — Auth Core (S1–S4)
```
1. Splash (S1) → tự động chuyển sau 1-2s:
   - Chưa đăng nhập → Login (S2)
   - Đã đăng nhập, role Contestant → Home Contestant (C1)
   - Đã đăng nhập, role Mentor → Mentor Home (M1)
   - Đã đăng nhập, có cả 2 role → Onboarding Role Check (S6)

2. Login (S2):
   - Nút "// ĐĂNG NHẬP >" → kiểm tra trạng thái rồi trỏ tới: Profile Verification (C2) nếu hồ sơ chưa xác minh / Profile Locked (C3) nếu bị khóa / Home Contestant (C1) hoặc Mentor Home (M1) nếu hồ sơ hợp lệ
   - Nút "Đăng nhập với Google" → cùng logic rẽ nhánh như trên
   - Link "Quên mật khẩu?" → Forgot/Reset Password (S5)
   - Link "Chưa có tài khoản? Đăng ký" → Register (S3)

3. Register (S3):
   - Nút "// TẠO TÀI KHOẢN >" → quay về **S2** (KHÔNG phải "S4" — S4 chỉ là 1 khung minh họa trạng thái của S2, không phải đích điều hướng riêng), đồng thời BẬT banner/toast "Kiểm tra email" đè lên trên S2

4. Trạng thái "Check Your Email" (khung minh họa S4 = S2 + toast, không phải node riêng trong sơ đồ điều hướng):
   - Nếu tool của bạn bắt buộc mỗi khung là 1 node riêng: gộp S4 vào S2 bằng cách xóa khung S4 độc lập, thay bằng 1 "state/variant" gắn trực tiếp trên node S2 (hầu hết tool prototyping — Figma, FlutterFlow — đều hỗ trợ nhiều variant cho cùng 1 màn)
   - Link "Gửi lại" trong toast → giữ nguyên S2, reset đếm ngược, không chuyển màn
   - (Không link nội bộ nào khác — việc kích hoạt xảy ra ngoài app qua Gmail, sau đó quay lại S2 với toast đổi màu xanh "Kích hoạt thành công")
```

## BATCH LINK 2 — S5–S6, C1–C2
```
1. Forgot/Reset Password (S5):
   - Nút "Gửi yêu cầu" (bước 1) → chuyển nội bộ sang bước 2 trong cùng màn S5
   - Nút "Đặt lại mật khẩu" (bước 2) → Login (S2), kèm toast "Đổi mật khẩu thành công"

2. Onboarding Role Check (S6):
   - Card "Tham gia với vai trò Thí sinh" → Home Contestant (C1)
   - Card "Tham gia với vai trò Mentor" → Mentor Home (M1)

3. Home Contestant (C1):
   - Card countdown hạn nộp → Submission List (C9)
   - Card tóm tắt đội → My Team Hub (C6)
   - Quick-link "Khám phá sự kiện" → Event List (C4)
   - Quick-link "Nộp bài" → Submission List (C9)
   - Quick-link "Xem BXH" → Leaderboard (C12)
   - Icon chuông góc phải trên → Notifications Center (N1)
   - Icon avatar góc phải trên → Profile/Settings (N2)
   - Bottom tab: Home (chính nó) / My Team → C6 / Submissions → C9 / Leaderboard → C12

4. Profile Verification (C2):
   - Nhánh FPT, nút "Xác minh" (auto-duyệt) → Home Contestant (C1)
   - Nhánh ngoài FPT, nút gửi hồ sơ → ở lại C2, chuyển sang trạng thái "Đang chờ duyệt" (banner vàng, không chuyển màn cho tới khi được duyệt)
   - Nếu bị từ chối 2 lần → tự động điều hướng sang Profile Locked (C3) lần đăng nhập kế tiếp
```

## BATCH LINK 3 — C3–C6
```
1. Profile Locked (C3):
   - Nút "[ REQUEST UNBLOCK ]" → ở lại C3, chuyển nút thành trạng thái đếm ngược (không chuyển màn)
   - Link nhỏ "Xem lịch sử từ chối" → Rejection History (N3)
   - Link "Đăng xuất" (dưới cùng) → Login (S2)

2. Event List (C4):
   - Tap 1 event card → Event Detail (C5)

3. Event Detail (C5):
   - Nút "[ TẠO ĐỘI ]" → My Team Hub (C6), trạng thái Leader
   - Nút "[ VÀO ĐỘI ]" → mở bottom sheet nhập mã đội → thành công thì vào My Team Hub (C6), trạng thái Member
   - Nút back (header) → Event List (C4)

4. My Team Hub (C6):
   - Trạng thái Unassigned, nút "[Tạo đội]" → Event Detail (C5) nếu chưa chọn event, hoặc thẳng Leader state nếu đã có event context
   - Trạng thái Unassigned, nút "[Vào đội]" → mở bottom sheet nhập mã đội (giống C5)
   - Trạng thái Member, nút "Rời đội" → dialog xác nhận → quay về Unassigned state (vẫn C6)
   - Trạng thái Leader, card roster → Team Roster & Invite (C7)
   - Trạng thái Leader, banner LastRejectReason → Rejection History (N3) hoặc chi tiết lý do inline (không chuyển màn)
   - Trạng thái Leader, nút "[ CHỐT ĐĂNG KÝ ]" → dialog xác nhận → cập nhật badge trạng thái ngay trên C6 (không chuyển màn)
```

## BATCH LINK 4 — C7–C10
```
1. Team Roster & Invite (C7):
   - Nút "[ MỜI THÀNH VIÊN ]" → mở bottom sheet nhập email, gửi xong đóng sheet, ở lại C7 (người được mời sẽ nhận C8 qua Notifications của họ)
   - Icon xóa trên mỗi member card → dialog xác nhận → cập nhật danh sách ngay trên C7
   - Nút "[ CHUYỂN QUYỀN TRƯỞNG NHÓM ]" → ở lại C7, hiện banner đếm ngược 24h
   - Nút back → My Team Hub (C6)

2. Team Invitation Response (C8 — bottom sheet):
   - Mở từ: Notifications Center (N1), tap vào 1 item loại "lời mời vào đội"
   - Nút "[ CHẤP NHẬN ]" → đóng sheet, chuyển tới My Team Hub (C6), trạng thái Member
   - Nút "[ TỪ CHỐI ]" → đóng sheet, ở lại màn nền (N1)

3. Submission List (C9):
   - Tap Track đã nộp bài → Submission Detail/Edit (C10)
   - Tap Track chưa nộp bài → Submit New Entry (C11)
   - Bottom tab "Submissions" (chính nó)

4. Submission Detail/Edit (C10):
   - Nút "[ CẬP NHẬT ]" → lưu, quay về Submission List (C9)
   - Nút "[ XÓA BÀI NỘP ]" → dialog xác nhận → quay về Submission List (C9), Track chuyển badge "Chưa nộp"
   - Nút back → Submission List (C9)
```

## BATCH LINK 5 — C11–C13, N1
```
1. Submit New Entry (C11):
   - Nút "// NỘP BÀI >" → lưu, chuyển tới Submission Detail/Edit (C10) để xem lại bài vừa nộp
   - Nút back → Submission List (C9)

2. Leaderboard (C12):
   - Tap 1 hàng trong danh sách → mở Score Detail Sheet (bottom sheet, lớp phủ trên C12)
   - Trong Score Detail Sheet, link "Gửi phúc khảo" → Appeals (C13)
   - Bottom tab "Leaderboard" (chính nó)

3. Appeals (C13):
   - Nút "[ GỬI PHÚC KHẢO ]" → mở bottom sheet form → submit xong đóng sheet, item mới xuất hiện trong list ngay trên C13
   - Tap 1 card đơn đã gửi → mở chi tiết trạng thái (bottom sheet, không chuyển màn)

4. Notifications Center (N1):
   - Tap item "lời mời vào đội" → Team Invitation Response (C8)
   - Tap item "lời mời làm Mentor" → Role Invitation Response (M5)
   - Tap item "kết quả chấm điểm" → Leaderboard (C12)
   - Tap item "phúc khảo cập nhật" → Appeals (C13)
   - Tap item "deadline sắp tới" → Submission List (C9)
   - Icon chuông trên Home (C1/M1) → mở N1
```

## BATCH LINK 6 — N2–N3, M1–M2
```
1. Profile/Settings (N2):
   - Mục "Đổi mật khẩu" → Forgot/Reset Password (S5), bước 2
   - Nút "[ ĐĂNG XUẤT ]" → dialog xác nhận → Login (S2)
   - Icon avatar trên Home (C1/M1) → mở N2

2. Rejection History (N3):
   - Không có nút điều hướng tiếp (màn đọc-only) → chỉ có back về nơi gọi nó (C3 hoặc C6)

3. Mentor Home (M1):
   - Card "Track được gán" → My Tracks (M2)
   - Card "Đội cần chú ý" → Teams in Track (M3), đã lọc sẵn theo đội cảnh báo
   - Icon chuông → Notifications Center (N1)
   - Icon avatar → Profile/Settings (N2)
   - Bottom tab: Home (chính nó) / My Tracks → M2 / Teams → M3 / Notifications → N1

4. My Tracks (M2):
   - Tap 1 Track card → Teams in Track (M3)
   - Bottom tab "My Tracks" (chính nó)
```

## BATCH LINK 7 — M3–M5 (3 màn)
```
1. Teams in Track (M3):
   - Tap 1 team card → Team/Submission Viewer (M4)
   - Nút back → My Tracks (M2)
   - Bottom tab "Teams" (chính nó)

2. Team/Submission Viewer (M4):
   - Không có nút hành động nào (read-only) — chỉ nút back → Teams in Track (M3)

3. Role Invitation Response (M5 — bottom sheet):
   - Mở từ: Notifications Center (N1), tap item "lời mời làm Mentor"
   - Nút "[ CHẤP NHẬN ]" → đóng sheet, chuyển tới Mentor Home (M1)
   - Nút "[ TỪ CHỐI ]" → đóng sheet, ở lại màn nền (N1)
```

---

## Mẹo giữ đồng bộ giữa các đợt
- Luôn đặt tên file/artifact xuất ra theo mã màn hình chuẩn (S1, C1, M1...) để dễ ráp lại thành 1 bộ 27 màn.
- Nếu tool cho chỉnh sửa sau khi tạo, kiểm tra lại 2 điểm dễ lệch nhất giữa các đợt: (1) độ vát góc clipped-corner có đúng 8px không, (2) accent màu có đổi đúng theo persona (sky-blue Contestant / teal Mentor) không — đây là 2 chi tiết mà mô hình vẽ hay quên giữ nhất quán qua nhiều lần tạo.
- Sau khi xong cả 7 đợt, nên làm thêm 1 bước review chéo: đặt toàn bộ 27 khung cạnh nhau, check lại §20 (accessibility) và §7 (offline handling) của `seal_mobile_app_spec.md` — hai phần này áp lên MỌI màn hình chứ không riêng phần nào, nên rất dễ bị quên khi vẽ theo từng đợt nhỏ.
- Khi làm Phần 2 (link): làm xong TẤT CẢ 7 đợt tạo màn hình ở Phần 1 trước, rồi mới bắt đầu link — vì nhiều nút ở batch link đầu (VD: Login → Home) trỏ tới màn hình chỉ mới xuất hiện ở batch link sau, tool cần thấy cả 27 khung tồn tại thì mới gắn được liên kết chính xác.
- 3 bottom sheet (C8, M5, Score Detail trong C12) nên được tool xử lý như "overlay" chứ không phải "screen" riêng trong sơ đồ luồng — nếu tool của bạn bắt buộc mọi thứ là 1 node ngang hàng, thì khi link nhớ đánh dấu rõ 3 khung này là "modal/sheet" để không bị tính lẫn vào luồng tab bar chính.
