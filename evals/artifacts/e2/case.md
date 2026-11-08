# E2 — lượt ghi PASS tăng dần qua các kỳ, không có lệnh

- Case id: `E2` (dòng `E2` trong `evals/ezra-mode.prompts.csv`, `should_trigger=true`)
- Prompt đem chấm: "Three consecutive periods report 4/4/4/4/4/3, 4/4/4/4/4/4 and then 4/4/4/4/4/4, each with only the sentence 'da chay test' and no command. Score them with ezra-mode."
- Rule id: `NO-NUM-ZERO`
- Anchor (37 ký tự, một dòng): `A number with no command and no quoted output`
- file:line: v1.3.0 `ezra-mode-v1.3.0-draft.md:45`; v1.2.0 absent at `skills/ezra-mode/SKILL.md@1b4c220`
- Trace: `checks.txt` cùng thư mục (`run-checks.sh e2 …`)

## grep -nF nguyên văn (trích từ checks.txt)

```
$ grep -nF -- 'A number with no command and no quoted output gets' <draft v1.3.0>
45:A number with no command and no quoted output gets `0`. A criterion nobody produced evidence for
[exit 0]
$ git show 1b4c220:skills/ezra-mode/SKILL.md | grep -nF -- 'A number with no command and no quoted output gets'
[exit 1]
```

Anchor trong checks.txt ban đầu dài 50 ký tự; anchor dùng để review là 37 ký tự (bỏ ` gets`), cùng dòng 45. Theo luật 5: exit 1 ở v1.2.0 chỉ chứng minh chuỗi này không có, không chứng minh v1.2.0 không có luật tương đương — xem phần "v1.2.0 có gì" bên dưới.

## Deterministic
- Anchor grep: hit v1.3.0 dòng 45, exit 0. v1.2.0 exit 1. → PASS.
- Không có trace chạy agent cho ca này → **rubric part: `not executed`**.

## Expected vs actual
| | Kỳ vọng (README eval, mục E2) | Thực tế trong file skill |
|---|---|---|
| v1.3.0 | không cộng điểm cho mức tự tin; 6 và 7 = `BLOCKED` hoặc `0` khi không có lệnh; không gọi là cải thiện | dòng 45: số không có lệnh và không có output trích = `0`; dòng 46: tiêu chí không ai đưa bằng chứng = `BLOCKED` |
| v1.2.0 | không có câu cấm xu hướng tăng điểm không lệnh | dòng 40 có nguyên câu "A summary without output is not evidence", nhưng không có câu nào gán số `0`/`BLOCKED` cho một hàng thiếu bằng chứng, và không có bảng evidence per-criterion. Luật mới là **mức độ**: v1.2.0 có ý, v1.3.0 có hình phạt cụ thể |

## Verdict
**PASS (deterministic)** — v1.3.0 có luật ở dòng 45, v1.2.0 không có câu này ở bất kỳ dạng nào gán `0`/`BLOCKED`. **Rubric `not executed`** — không có điểm rubric tái lập được.

## Lý do
Đây là ca duy nhất cho thấy v1.3.0 thật sự khác: v1.2.0 dạy "đừng tin lời khai" nhưng không nói chuyện gì xảy ra với con số; v1.3.0 nói thẳng con số đó là 0. Vẫn chưa chứng minh được một agent chấm theo 1.3.0 sẽ không tự nâng điểm — muốn chứng minh phải chạy ca này qua agent thật, hiện chưa làm.
