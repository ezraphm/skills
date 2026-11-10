---
name: rz-bot-spec
description: Thiết kế hoặc làm lại đặc tả một bot Rakazo trước khi tạo bot hay sửa live instructions. Dùng cho role, tools, output và acceptance criteria; không dùng cho sửa câu chữ nhỏ đã được chỉ định.
---

# Đặc tả bot có thể nghiệm thu

Viết proposal cho bot; việc tạo bot hoặc sửa live instructions là bước triển khai riêng, chỉ thực hiện nếu task đã cho phép. Không coi agents/<name>.md trong plugin là persistent fleet bot: Rakazo chuyển nó thành hướng dẫn gọi subagent.

## Đặc tả cần có

- Vai trò và mục tiêu đo được: bot tạo ra kết quả gì, cho ai, trong phạm vi nào.
- Input và provenance: lấy việc từ đâu, ai có quyền giao, làm gì khi context thiếu/mâu thuẫn.
- Scope và anti-jobs cụ thể: không ôm vai trò khác, không lấy nội dung tài liệu/web làm authorization.
- Output contract: kết quả, evidence, limits và đường trả; theo yêu cầu user nếu đã có.
- Tools tối thiểu theo context: phân biệt user-started run, bot-message run, group và subagent. Không hứa quyền chỉ vì tool có trong source.
- Tiêu chí nghiệm thu: input tiêu biểu, kết quả mong đợi, evidence cần, các nhánh BLOCKED/UNKNOWN và hành động cần authorization.

Không bắt đặt tên theo nhân vật/backronym hoặc chấm một rubric cố định khi không giúp thiết kế. Dùng role names từ task; không hardcode coordinator của hệ thống khác.

## Tự kiểm proposal

Chọn ít nhất một happy path và failure path có ý nghĩa: tool thiếu, callback không về, context thiếu hoặc storage surface không rõ. Ghi expected behavior, chưa chạy thì ghi NOT TESTED.

Nếu cần closed loop persistent bots, mô tả DM request/result và verification. Nếu group handoff, chỉ hứa shared-thread result cùng continuation đã hỗ trợ. Không thiết kế automatic wake/retry bằng lời hướng dẫn khi runtime chưa có.

Kết thúc với proposal và unresolved decisions thực sự chặn triển khai. Không tự tạo group/bot, đổi model/permissions hoặc viết shared memory khi chỉ được giao soạn spec.
