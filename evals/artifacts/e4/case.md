# E4 — ca thiếu dữ liệu: 6 bot, 5 bot im lặng

- Case id: `E4` (dòng `E4` trong `evals/ezra-mode.prompts.csv`, `should_trigger=true`)
- Prompt đem chấm: "Score 6 bots for this period. Only one bot had work assigned; the other five were silent. Use the ezra-mode rubric."
- Rule id: `SILENCE-0`
- Anchor (32 ký tự, một dòng): `never 0 for behaviour nobody saw`
- file:line: v1.3.0 `ezra-mode-v1.3.0-draft.md:79`; v1.2.0 absent (`skills/ezra-mode/SKILL.md@1b4c220`)
- Trace: `checks.txt` cùng thư mục (`run-checks.sh e4 …`)

## grep -nF nguyên văn (trích từ checks.txt)

```
$ grep -nF -- 'never 0 for behaviour nobody saw' <draft v1.3.0>
79:Silence is not a fail. No claim in the period means `BLOCKED`, never 0 for behaviour nobody saw.
[exit 0]
$ git show 1b4c220:skills/ezra-mode/SKILL.md | grep -nF -- 'never 0 for behaviour nobody saw'
[exit 1]
```

## Deterministic
- Anchor grep: hit v1.3.0 dòng 79, exit 0; v1.2.0 exit 1. → PASS.
- Không có danh sách 6 bot thật để chấm, không có trace → **rubric part: `not executed`**.

## Expected vs actual
| | Kỳ vọng (README eval, mục E4) | Thực tế trong file skill |
|---|---|---|
| v1.3.0 | 5 bot im lặng ghi `BLOCKED`, không ghi 0 | dòng 76: `BLOCKED`: no evidence exists; dòng 79: "No claim in the period means `BLOCKED`, never 0 for behaviour nobody saw." |
| v1.2.0 | người chấm phải tự suy | dòng 41: `BLOCKED: <reason>` cho trường hợp thiếu quyền/môi trường — nói về *người chấm không kiểm được*, không nói về *bot không có việc*. Không có câu nào cấm ghi 0 cho bot im lặng |

## Verdict
**PASS (deterministic)** — luật `BLOCKED` cho bot im lặng có ở v1.3.0, không có ở v1.2.0. **Rubric `not executed`**.

## Lý do
Khác biệt nằm đúng chỗ dễ sai nhất: v1.2.0 dạy `BLOCKED` là chuyện của người chấm thiếu quyền; v1.3.0 dạy `BLOCKED` cũng là chuyện của bot không làm gì. Ghi 0 cho bot im lặng là "bịa một phép đo", và v1.3.0 là bản duy nhất nói ra.
