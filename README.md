# rakazo — Rakazo Skill Library

Thư viện skill cho [Rakazo](https://rakazo.com). Mỗi skill là một thư mục con chứa `SKILL.md` tự đứng — không phụ thuộc script, không phụ thuộc data file, không cần runtime ngoài.

## Vì sao cô đọng thành 1 file

Rakazo Skills chỉ nạp **instructions dạng text**. Script đi kèm (`scripts/*.py`), data (`data/*.csv`), asset và reference của skill gốc **không được cài và không được chạy**. Một skill chép nguyên `SKILL.md` gốc sẽ có mọi lệnh `python .../search.py` fail ngay.

Nên mọi skill trong repo này tuân theo cùng một luật:

1. **Không có lệnh gọi script không tồn tại.** Lệnh CLI được chuyển thành example inline, hoặc gắn nhãn rõ "chỉ dùng khi có bản đầy đủ".
2. **Con trỏ thay cho bản sao.** Nếu skill gốc có database lớn, ghi đường dẫn nguồn chính thức + đường dẫn thường trú để tra cứu khi cần, không nhúng cả database.
3. **Fallback phải dùng được.** Thiếu script thì skill vẫn phải cho ra kết quả thật, có ghi rõ nguồn là default của skill chứ không phải match database.
4. **Không bịa output.** Không trình bày kết quả tự suy như thể là kết quả search.

## Skills

| Skill | Mô tả | Gốc |
|---|---|---|
| [`ui-ux-pro-max`](ui-ux-pro-max/SKILL.md) | UI/UX design intelligence: bảng ưu tiên 10 nhóm luật, workflow 4 bước, anti-pattern, checklist 16 mục trước khi giao UI | `huytran1120/vie-agentic-skills` |

## Cách dùng

Skill trong Rakazo Skills Library: mở skill và gõ `/ui-ux-pro-max` trong composer.

Bản đầy đủ có script (79 styles, 192 palettes, 74 font pairings, 119 UX guidelines, 105 icons, 17 GSAP presets, 25 chart types, 22 stacks) cài vào dự án bằng manifest chính thức:

```
https://huytran1120.github.io/vie-agentic-skills/install-manifests/ui-ux-pro-max.json
```

Cài vào `<project>/.agents/skills/ui-ux-pro-max/` rồi chạy `python3 .agents/skills/ui-ux-pro-max/scripts/search.py "<query>" --domain ux`.

Không dùng `${CLAUDE_PLUGIN_ROOT}` — biến đó chỉ tồn tại trong Claude Code.

## Thêm skill mới

1. Tạo `<skill-name>/SKILL.md` với frontmatter `name` + `description`.
2. Áp 4 luật trên: không script ma, con trỏ thay database, fallback dùng được, không bịa output.
3. Thêm một dòng vào bảng Skills.
4. Commit.
