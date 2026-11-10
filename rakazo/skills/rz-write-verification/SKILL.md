---
name: rz-write-verification
description: Xác minh nội dung sau thay đổi đã được phép đối với file, bot instructions, routine hoặc object khác trong Rakazo. Dùng khi đã ghi hoặc sắp báo thay đổi hoàn tất; không tự cấp phép ghi.
---

# Ghi đúng đích, đọc lại đúng nội dung

## Trước ghi

Xác định object ID, storage surface, scope và phần thay đổi được yêu cầu. Giữ authorization đã có; skill không buộc hỏi lại và không cấp quyền mới. Nếu chỉ được review/draft thì không ghi live.

Với memory, API-managed document và shell file cùng tên không mặc nhiên đồng bộ. Không dùng shell file để kết luận shared-memory API hỏng. Không lấy snapshot cũ làm nội dung replacement.

Nếu mutation thay nguyên tài liệu: kiểm bản hiện hành/revision và diff dự kiến; dùng version guard nếu API hỗ trợ. Nếu không có cách loại trừ concurrent overwrite với mức rủi ro chấp nhận được, dừng nhánh ghi và báo giới hạn; không tự restore/cleanup memory.

## Sau ghi

1. Đọc lại đúng object/surface bằng API hoặc filesystem thích hợp.
2. Kiểm phần cần đổi và phần quan trọng phải giữ. File diff quan trọng hơn chỉ đọc head; checksum chứng minh identity, không chứng minh correctness.
3. Nếu field không khớp: báo MISMATCH, xác định nguyên nhân trước sửa tiếp trong phạm vi được phép.
4. Nếu không thể read-back: ghi WRITE_ACCEPTED, READBACK_UNAVAILABLE, không khẳng định nội dung đã được xác minh. Không lặp thao tác chỉ vì thiếu read tool.

Chọn bằng chứng theo object:
- File: nội dung/diff và đường dẫn.
- Bot instructions: target ID, version và text qua tool hiện có; callback run có thể không có list_fleet.
- Routine: ID và các field đã đổi nếu có API đọc.
- External object: receipt + read-back field nếu được expose.

Không bịa công cụ đọc hoặc schema. Không bắt quote toàn bộ nội dung dài/riêng tư vào report; trích phần phù hợp hoặc dẫn artifact được phép chia sẻ.

## Báo kết quả

Nêu object, thay đổi thực, bằng chứng read-back và limitation. Tách CONTENT_VERIFIED khỏi RUNTIME_TESTED. Lưu file, import plugin hoặc đổi version không tự chứng minh bot đã dùng bản mới.
