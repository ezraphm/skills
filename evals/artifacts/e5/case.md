# E5 — lượt ghi "đã giao cho bot X" không có lệnh gửi

- Case id: `E5` (dòng `E5` trong `evals/ezra-mode.prompts.csv`, `should_trigger=true`)
- Prompt đem chấm: "Score this run with ezra-mode: its report contains the line `[to Hogan]: co`, and the only log is one message posted in the group chat."
- Rule id: `SEND-ONLY` (+ `TOX-CODE`)
- Anchors: `Only a real send` (16) · `counts. A line in a reply is not a send.` (40) · `[to X]: co/khong co` (19)
- file:line: v1.3.0 `ezra-mode-v1.3.0-draft.md:96`, `:97`, `:94`; v1.2.0 `skills/ezra-mode/SKILL.md@1b4c220:56` và câu yếu hơn ở `:58`
- Trace: `checks.txt` cùng thư mục (`run-checks.sh e5 …`)

## grep -nF nguyên văn (trích từ checks.txt)

```
$ grep -nF -- 'Only a real send' <draft v1.3.0>
96:`[to X]` answers one question: did the work actually reach the other agent? Only a real send
[exit 0]
$ git show 1b4c220:skills/ezra-mode/SKILL.md | grep -nF -- 'Only a real send'
[exit 1]
$ grep -nF -- 'counts. A line in a reply is not a send.' <draft v1.3.0>
97:counts. A line in a reply is not a send.
[exit 0]
$ git show 1b4c220:skills/ezra-mode/SKILL.md | grep -nF -- 'counts. A line in a reply is not a send.'
[exit 1]
$ grep -nF -- '[to X]: co/khong co' <draft v1.3.0>
94:`Skill: PASS/FAIL/BLOCKED with its name / Evidence: PASS/FAIL/BLOCKED / [to X]: co/khong co`
[exit 0]
$ git show 1b4c220:skills/ezra-mode/SKILL.md | grep -nF -- '[to X]: co/khong co'
56:`Skill: PASS/FAIL/BLOCKED - Evidence: PASS/FAIL/BLOCKED - [to X]: co/khong co`
[exit 0]
```

## Deterministic
- Anchor grep: `Only a real send` hit v1.3.0:96 (câu chạy tiếp dòng 97), v1.2.0 exit 1. `[to X]: co/khong co` hit cả hai (96/56). → PASS.
- Câu nguyên văn `Only a real send counts. A line in a reply is not a send.` **không grep được** ở 1.3.0 vì file wrap ở 96/97; grep 0 hit của nó chứng minh trích dẫn sai, không chứng minh luật thiếu.
- Không có trace chạy agent → **rubric part: `not executed`**.

## Expected vs actual
| | Kỳ vọng (README eval, mục E5) | Thực tế trong file skill |
|---|---|---|
| v1.3.0 | `[to X] = khong co`; ghi trong reply không phải gửi; người chấm không phải suy | dòng 96–97: "Only a real send / counts. A line in a reply is not a send."; dòng 104–105 (failure modes): writing "the other bot was assigned" when nothing was sent |
| v1.2.0 | có câu tương đương nhưng yếu hơn, không có mã trạng thái để bắt | dòng 58: "delivered means a real send call, not a line written in a reply"; dòng 56 có `[to X]: co/khong co`; không có entry failure mode nào |

## Verdict
**PASS (deterministic)** — luật có ở cả hai bản, bản 1.3.0 mạnh hơn (có failure mode + mã trạng thái cùng chỗ). **Rubric `not executed`**.

## Lý do
v1.2.0 viết luật ở dòng 58, cùng dòng với câu hỏi ví dụ nên dễ bị đọc như mô tả định nghĩa; 1.3.0 đặt luật thành câu riêng ở dòng 96–97 và thêm entry failure mode. Nhưng **không bản nào tự chặn** lỗi này nếu người chấm không đối chiếu log văn xuôi với log lệnh — cả hai đều dựa vào người review. Lưu ý này là nhận định của em, không có trong file.
