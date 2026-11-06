# N1 — negative control: prompt lân cận KHÔNG được trigger

- Case id: `N1` (dòng `N1` trong `evals/ezra-mode.prompts.csv`, `should_trigger=false`)
- Prompt đem chấm: "Review this pull request diff and tell me whether the retry logic is correct."
- Kỳ vọng: **không** load ezra-mode.
- Anchors: `Skip it for` (11) · `code correctness review` (23)
- file:line: `Skip it for` v1.3.0 `ezra-mode-v1.3.0-draft.md:19`, v1.2.0 `skills/ezra-mode/SKILL.md@1b4c220:17`; `code correctness review` v1.3.0 `:19`, v1.2.0 absent
- Trace: `checks.txt` cùng thư mục (`run-checks.sh n1 …`)

## grep -nF nguyên văn (trích từ checks.txt)

```
$ grep -nF -- 'Skip it for' <draft v1.3.0>
19:Skip it for: code correctness review (that is a PASS/FAIL verdict on a diff, a different job), and
[exit 0]
$ git show 1b4c220:skills/ezra-mode/SKILL.md | grep -nF -- 'Skip it for'
17:Skip it for: review of code correctness (that is a PASS/FAIL verdict on a diff, a different job), and anything about costs or business numbers.
[exit 0]
$ grep -nF -- 'code correctness review' <draft v1.3.0>
19:Skip it for: code correctness review (that is a PASS/FAIL verdict on a diff, a different job), and
[exit 0]
$ git show 1b4c220:skills/ezra-mode/SKILL.md | grep -nF -- 'code correctness review'
[exit 1]
```

## Deterministic
- Anchor grep: câu skip có ở **cả hai** bản (dòng 19 / 17). → PASS cho phần anchor.
- Probe trigger thật (agent nhận prompt, xem ezra-mode có nạp không): **chưa chạy** → `not executed`.

## Verdict
**`not executed`** — theo luật 6, ca này không được tính là pass. Phần suy luận dưới đây không thay cho một lần chạy.

## Lý do — và một chỉnh sửa cho bản ghi trước
Bản eval ban đầu ghi "bản 1.2.0 không có câu skip nào". Grep ở trên cho thấy điều đó **sai**: v1.2.0 dòng 17 có câu skip đúng nghĩa, chỉ khác cách viết ("review of code correctness" vs "code correctness review"). Cả hai bản đều loại PR review ra khỏi phạm vi; khác biệt duy nhất là số dòng và thứ tự chữ. Vậy N1 không chứng minh được cải thiện nào của 1.3.0 về trigger.
