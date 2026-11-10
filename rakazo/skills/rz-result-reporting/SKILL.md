---
name: rz-result-reporting
description: Báo cáo kết quả stage hoặc chuyển kết quả về coordinator trong Rakazo, với evidence và trạng thái delivery riêng. Dùng khi công việc đã có kết quả, không để giao stage mới.
---

# Báo cáo kết quả tới đúng nơi

Mục tiêu: người nhận hiểu kết quả, mức kiểm chứng và việc còn mở mà không phải đoán từ chữ DONE.

## Chọn nơi nhận

Lấy coordinator/destination từ task, không hardcode tên người hoặc bot. Nếu task không chỉ định người nhận khác, trả kết quả ngay trong cuộc trò chuyện hiện tại.

- Direct request có return contract: dùng message_bot intent result nếu được expose và đã được giao nhiệm vụ trả kết quả.
- Stage trong group: đăng kết quả trong shared thread; không dùng handoff ngược chỉ để báo xong.
- Đích bắt buộc ở nơi khác nhưng không có transport được phép: giữ RESULT_READY, báo blocker tại thread hiện tại. Blocker post không chứng minh result đã tới đích.

Không suy plain-text @Name trong bot output sẽ đánh thức coordinator. Không cần gửi thêm ack-only hoặc bản sao owner nếu task không yêu cầu.

## Packet mặc định

Dùng cấu trúc ngắn dưới đây; nếu người dùng yêu cầu format khác thì giữ yêu cầu đó và bảo toàn thông tin:

```text
RESULT: <kết quả hiện có; work COMPLETE/PARTIAL/BLOCKED>
EVIDENCE: <nguồn hoặc observation, điều nó chứng minh; không có thì UNVERIFIED>
DELIVERY: <RESULT_READY | POSTED | RECEIVED | ACKNOWLEDGED | UNKNOWN>
LIMITS: <unknowns, rủi ro ảnh hưởng kết luận; hoặc NONE>
NEXT: <bước còn lại và owner đã biết; hoặc NONE>
```

Đưa chi tiết dài vào artifact nếu có nơi ghi được phép; nếu không thì để trực tiếp trong message. Không ghi outbox/shared memory chỉ để đáp ứng format. Không bắt buộc raw command output hoặc checksum khi platform receipt/source phù hợp hơn; không đưa secrets vào report.

## Evidence của delivery

- RESULT_READY: nội dung sẵn sàng, chưa có bằng chứng publish/send.
- POSTED: platform đã nhận post đúng destination, có receipt hoặc final đã xuất hiện trong invoked thread. Không gọi bản draft là POSTED.
- RECEIVED: có bằng chứng ở recipient, ví dụ inbound message liên quan đúng workflow.
- ACKNOWLEDGED: coordinator xác nhận đúng result/stage; membership, tool success và finished worker run không đủ.
- UNKNOWN: không đủ quyền/log để xác định một mốc. Ghi ID unavailable thay vì tự tạo ID.

Work COMPLETE có thể cùng DELIVERY POSTED và verification pending. Không chờ ACK vô hạn mới cho phép báo phần việc đã xong, và không tự gọi coordinator bằng user turn để chứng minh wake.

Khi bị gián đoạn hoặc có result trùng, đối chiếu accessible history và Workflow-ID trước gửi lại. Không tuyên bố platform có dedup theo digest do mình đặt. Nội dung sửa đổi phải ghi supersedes report nào nếu biết; chưa biết post cũ có thành công thì giữ uncertainty.
