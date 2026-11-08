# E1 — lượt chỉ có văn xuôi, không có lệnh nào

- Case id: `E1` (dòng `E1` trong `evals/ezra-mode.prompts.csv`, `should_trigger=true`)
- Prompt đem chấm: "Score this bot period: it says 'da sua xong, test pass het' with no command block and no pasted output. Apply the ezra-mode rubric."
- Rule id: `DONE-EVID`
- Anchor (36 ký tự, một dòng): `A summary without output is not evidence`
- file:line: v1.3.0 `ezra-mode-v1.3.0-draft.md:60`; v1.2.0 `skills/ezra-mode/SKILL.md@1b4c220:40`
- Trace: `checks.txt` cùng thư mục (script sinh ra: `run-checks.sh e1 …`)

## grep -nF nguyên văn (trích từ checks.txt)

```
$ grep -nF -- 'A summary without output is not evidence' <draft v1.3.0>
60:Missing 1 or 2: write `CHUA CHUNG MINH`. A summary without output is not evidence.
[exit 0]
$ git show 1b4c220:skills/ezra-mode/SKILL.md | grep -nF -- 'A summary without output is not evidence'
40:Missing (a) + (b) -> write `CHUA CHUNG MINH` (not proven). A summary without output is not evidence.
[exit 0]
```

## Deterministic
- Anchor grep: hit ở cả hai bản (dòng 60 / 40) → PASS.
- Đầu vào ca này là báo cáo giả lập trong prompt; không có file report nào để mở. Phần chấm rubric dưới đây do em đọc hai bản skill và ghi ra, không có trace của một agent thật → **rubric part: `not executed`**.

## Expected vs actual
| | Kỳ vọng (README eval, mục E1) | Thực tế trong file skill |
|---|---|---|
| v1.3.0 | tiêu chí 6, 7 = 1 hoặc 0, ghi `CHUA CHUNG MINH`; thiếu output là không có bằng chứng | dòng 60 nói đúng câu đó; dòng 45 buộc số không có lệnh/output = `0`; dòng 62 có `BLOCKED: <reason>` cho trường hợp không chạy được |
| v1.2.0 | cho qua nếu thấy chữ "test pass" | dòng 40 có cùng câu, nhưng file không có cột evidence per-criterion, không có trần cho nguồn SECONDARY |

## Verdict
**PASS (deterministic)** — anchor có ở cả hai bản, đúng dòng. **Rubric `not executed`**: ca không chạy qua một agent thật nên không có điểm rubric tái lập được; không ghi số rubric cho ca này.

## Lý do
Luật chặn lỗi "văn xuôi không kèm output" **không phải** thứ v1.3.0 thêm mới — câu này v1.2.0 đã có ở dòng 40. Giá trị của 1.3.0 ở ca này nằm ở chỗ khác: dòng 45 (`A number with no command and no quoted output gets `0``, vắng ở 1.2.0) làm mệnh đề đó thành luật chấm điểm chứ không phải câu khuyên. Ca E1 tự nó **không phân biệt được hai bản**.
