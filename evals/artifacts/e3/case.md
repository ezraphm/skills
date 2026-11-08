# E3 — lượt tái lập được, có lệnh + output

- Case id: `E3` (dòng `E3` trong `evals/ezra-mode.prompts.csv`, `should_trigger=true`)
- Prompt đem chấm: "Score this run with ezra-mode: it ran `git rev-parse HEAD` and pasted output `1b4c2207a450c5bd555d68d881f6923e991f560d`, which matches the published commit."
- Rule id: `SECONDARY-CAP` (+ `REPRO-4`)
- Anchors: `capped at scale 3, and the label` (32 ký tự) · `present, checkable, and someone else` (37 ký tự)
- file:line: v1.3.0 `ezra-mode-v1.3.0-draft.md:74` và `:35`; v1.2.0 absent ở cả hai (`skills/ezra-mode/SKILL.md@1b4c220`)
- Trace: `checks.txt` cùng thư mục (`run-checks.sh e3 …`)

## grep -nF nguyên văn (trích từ checks.txt)

```
$ grep -nF -- 'capped at scale 3, and the label' <draft v1.3.0>
74:- `SECONDARY`: another agent's report or claimed output. Usable, capped at scale 3, and the label
[exit 0]
$ git show 1b4c220:skills/ezra-mode/SKILL.md | grep -nF -- 'capped at scale 3, and the label'
[exit 1]
$ grep -nF -- 'present, checkable, and someone else reproduced it' <draft v1.3.0>
35:checkable. 4 = present, checkable, and someone else reproduced it.
[exit 0]
$ git show 1b4c220:skills/ezra-mode/SKILL.md | grep -nF -- 'present, checkable, and someone else reproduced it'
[exit 1]
```

Anchor thứ hai trong checks.txt dài 50 ký tự (vượt 40); anchor review là `present, checkable, and someone else`, cùng dòng 35.

## Deterministic
- Anchor grep: hit v1.3.0 dòng 74 và 35, exit 0; v1.2.0 exit 1 cả hai. → PASS.
- Không có trace chạy agent cho ca này → **rubric part: `not executed`**.

## Expected vs actual
| | Kỳ vọng (README eval, mục E3) | Thực tế trong file skill |
|---|---|---|
| v1.3.0 | PRIMARY, tiêu chí 5–7 = 3; chỉ lên 4 khi người khác chạy lại và khớp, và báo cáo ghi ai chạy | dòng 31 (scale): 4 = "reproduced by someone else"; dòng 74: trần 3 cho `SECONDARY`; dòng 48–49: ô evidence phải nói lệnh chứng minh gì và không chứng minh gì |
| v1.2.0 | cho 4 ngay khi đọc một lệnh | dòng 49 chỉ có dòng spot-check `PASS/FAIL`; không có nhãn evidence, không có trần 3, không định nghĩa 4 = có người thứ hai chạy lại |

## Verdict
**PASS (deterministic)** — hai luật khác biệt (trần 3 cho nguồn SECONDARY, 4 chỉ khi tái lập) có ở v1.3.0, không có ở v1.2.0. **Rubric `not executed`**.

## Lý do
Đây là ca mạnh nhất của bộ: v1.2.0 không có khái niệm nguồn SECONDARY, nên một lệnh `git rev-parse HEAD` do chính người chấm chạy lại vẫn có thể bị cho 4 dù nội dung commit chưa ai kiểm. v1.3.0 chặn được bằng hai dòng khác nhau. Lưu ý suy ra chứ không có trong file: ca này **không** chứng minh cách chấm 1.3.0 ra 3 — nó chỉ chứng minh luật có mặt.
