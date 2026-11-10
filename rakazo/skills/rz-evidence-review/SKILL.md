---
name: rz-evidence-review
description: Đánh giá claim DONE/PASS, báo cáo kiểm thử hoặc năng lực bot Rakazo bằng bằng chứng phù hợp. Dùng cho audit và review kết quả, không áp bộ chấm điểm vào mọi câu trả lời thông thường.
---

# Đánh giá đúng mức bằng chứng

## Quy trình

1. Viết lại claim cần kiểm: output đúng, thao tác được nhận, runtime đã chạy, recipient nhận, hay coordinator verify. Không gộp những claim này.
2. Kiểm input và evidence có sẵn; ưu tiên observation/source trực tiếp phù hợp với claim. Không chạy lại hành động có side effect chỉ để thu bằng chứng.
3. Gắn xuất xứ:
   - DIRECT: reviewer trực tiếp đọc source/artifact hoặc quan sát tool/event.
   - REPORTED: người dùng/bot chuyển báo cáo hoặc chép tool output; ghi ai báo.
   - REPRODUCED: reviewer thực hiện kiểm độc lập phù hợp và nêu kết quả.
   - INFERENCE: suy luận, ghi giả định.
   - UNAVAILABLE: thiếu dữ liệu/quyền.
4. Kết luận PASS/PARTIAL/FAIL/UNKNOWN cho từng claim và nói giới hạn. PASS reported vẫn là reported; không đổi thành DIRECT chỉ vì có đoạn code/log trong lời kể.

Source ở commit X không chứng minh deployment chạy X. Hash/file byte-identical không chứng minh runtime đúng. Kiểm lại phép tính chứng minh toán đúng, không chứng minh bot lịch sử đã thực thi. Một lần E2E thành công không chứng minh reliability dưới tải.

## Output

```text
Claim | Verdict | Evidence origin + locator | What it proves | Remaining gap
```

Dùng bảng khi có nhiều claim; một claim đơn giản có thể dùng văn xuôi ngắn. Có thể hoàn tất deliverable cục bộ khi kiểm phù hợp đã qua, đồng thời ghi runtime NOT TESTED. Không bắt mọi kết quả phải được agent thứ hai chạy lại; chỉ yêu cầu reproduction độc lập khi task hoặc mức rủi ro thực sự cần.

Nếu được yêu cầu chấm bot, trước hết thống nhất tiêu chí liên quan: scope, output usefulness, tool/permission use, factual correctness và evidence quality. Mỗi điểm phải có lý do; không chấm 0 cho hành vi chưa quan sát. Không dùng tổng điểm để che claim quan trọng còn UNKNOWN.

## Tính toán và thí nghiệm

Kiểm đơn vị, mẫu số và định nghĩa đo. Weighted error rate = tổng expected failures / tổng requests; contribution lớn nhất tính theo failures, không theo volume hoặc rate riêng.

Với concurrency, phân biệt unique root in-flight, pure service occupancy và handler-held occupancy. Không suy bottleneck/headroom khi thiếu capacity.

Đọc [test-oracles.md](references/test-oracles.md) chỉ khi review các fixture tương ứng. Đáp án trong reference không được gửi cho executor nếu bài test yêu cầu tính độc lập. Không coi ví dụ là log test đã chạy.
