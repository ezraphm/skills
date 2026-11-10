---
name: rz-agent-delegation
description: Giao một nhiệm vụ hoặc stage cho bot Rakazo khác; chọn direct message hay group handoff và định nghĩa result callback. Dùng trước khi giao việc, không dùng chỉ để báo cáo stage đã xong.
---

# Giao việc có đường về

Mục tiêu: chuyển đúng phần việc tới đúng bot và định nghĩa cách coordinator tiếp nhận kết quả.

## Trước khi gửi

1. Chỉ delegate khi phần việc có ích để tách độc lập. Xác định mục tiêu, input, output và điều kiện hoàn tất; không giao lại cùng stage đồng thời cho bot và subagent.
2. Xác định coordinator/executor từ task và context đáng tin. Discovery roster nếu run có tool; bot-message run có thể không có list_fleet. Không coi tên vai trò trong instructions là bot tồn tại.
3. Kiểm tool đang listed hoặc discovery deferred, đọc schema thật. Không suy tool có sẵn từ instructions hay lần chạy trước.
4. Chọn kênh:
   - Cần kết quả quay về coordinator tự động: direct message_bot với intent request; executor trả message_bot intent result nếu tool được expose.
   - Chuyển một stage khác biệt vào group: handoff_to_bot; ngoài group cần group_id. Executor đăng kết quả trong group; không hứa automatic coordinator return.
   - Không có tool phù hợp: NOT_SENT / BLOCKED, nêu tool/context thiếu. Không viết [to X] như bằng chứng gửi, không dùng @mention hay reverse handoff để giả lập callback.

Chỉ đọc [routing.md](references/routing.md) khi cần xác định context/filter hoặc kiểm source version.

## Request contract

Gửi một request qua tool thật, gồm:
- Workflow-ID duy nhất trong phạm vi task; Originator, Coordinator, Executor và IDs đã biết.
- Input đủ tự làm, nguồn/provenance, output cần nhận và đơn vị.
- Phạm vi được phép, hành động không được phép, callback destination.
- Deadline nếu task có; nếu không thì ghi chưa đặt, không tự biến thành blocker.

Nếu cần kiểm chứng tính toán độc lập, coordinator chuẩn bị baseline trước gửi và không đưa đáp án cho executor. Skill không cấp phép sửa memory/config, tạo group, routine hoặc bot.

## Executor và callback

Executor kiểm capability của chính run. Hoàn thành phần việc rồi trả result chứa Workflow-ID, kết quả, bằng chứng và unknowns. Thiếu tool trả kết quả: báo BLOCKED tại thread đang có; không tự đổi transport.

Coordinator đối chiếu workflow, sender/executor và input trước verify. Nếu baseline trước gửi không còn truy xuất được, tính lại và nói rõ không chứng minh được precommit. Callback sai/thiếu identity: NEEDS_REVIEW, không finalize nhầm.

## Trạng thái

Báo riêng: request ACCEPTED, work COMPLETE, result RECEIVED, verification VERIFIED/MISMATCH/UNKNOWN. ok:true chỉ là response của thao tác; không chứng minh work đã chạy hay coordinator đã nhận.

Không polling hoặc resend chỉ vì đang chờ. Sau interruption, đối chiếu history/receipt có quyền đọc trước khi gửi lại; nếu không biết đã gửi chưa thì UNKNOWN, không blind retry. Không tạo timer/routine để theo dõi nếu task chưa cho phép.

Kết thúc lượt với điều đã thực hiện, evidence của mốc đã đạt và phần còn chờ. Manual user invocation không là bằng chứng automatic callback wake.
