# Rakazo Operations — v0.1.0

Bộ skill Rakazo làm lại từ các bài học về giao việc, báo cáo và memory.
Đây là candidate cục bộ, chưa được preview/import hay chạy behavioral eval trên Rakazo.

## Cài thử và phạm vi

Plugin root là thư mục này. Khi được phép publish, dùng public GitHub folder URL trỏ đúng
`rakazo`, không dùng root estack để thử bộ này riêng.
Sau preview cần kiểm 6 skills, references và skipped parts; chưa có preview thì chưa gọi installable đã được chứng minh.
Không chứa MCP, commands, agents, scripts, hooks hoặc automation.

Tên skills là inventory importer theo filesystem; manifest dùng Agent Plugins 1.1.0.
Không thêm field skills để làm allowlist: Rakazo importer không dùng field đó làm bộ lọc.
Chỉ đặt skill đã sẵn sàng thử trong thư mục skills của plugin; drafts để ngoài plugin root.

## Migration

Bộ mới có prefix rz- và không phụ thuộc cài skill cũ:
- handoff-that-arrives → rz-agent-delegation
- report-to-cos → rz-result-reporting
- ezra-mode → rz-evidence-review
- write-then-read-back → rz-write-verification
- bot-spec → rz-bot-spec
- memory/context findings → rz-context-management

Skill cũ giữ nguyên trong estack để đối chiếu. Không mặc định cài cả hai bộ:
các description có thể cạnh tranh activation. Pilot bộ mới riêng; chưa tự gỡ/cài skill nào.
Human/UI/browser skills ngoài phạm vi migration này.

Không hardcode bot IDs, Rosie/Chief hoặc shared paths. Role/destination lấy từ task.
Không bắt chấm điểm mọi lượt, independent second-agent reproduction mọi việc hoặc outbox write.
Giữ riêng task completion, delivery, verification và ACK; không sửa routing bằng lời chỉ dẫn.

## Giới hạn

Skills là instructions, không cấp quyền hay cưỡng chế no-write. Dùng actual tool schema mỗi run.
T13 lịch sử là một lần DM E2E PASS theo báo cáo, không là behavioral certification của bộ mới.
Source baseline trong references không chứng minh deployment parity.
Không đổi bot memory/config/instructions, không tạo group/routine, không gửi bot messages khi chỉ cài/đọc nội dung.

Release này chưa quyết định license/author riêng. Chủ sở hữu chốt metadata trước public distribution.
Thay version không tự cập nhật installed commit; update và rollback cần kiểm trên deployment.


## Kiểm tra cục bộ

Từ gốc repo: `python3 rakazo/evals/package-check.py rakazo`.
Kịch bản đánh giá hành vi: [evals/scenarios.md](evals/scenarios.md).
