# rakazo — Rakazo Skill Library

Thư viện skill cho [Rakazo](https://rakazo.com), đóng gói thành **plugin** để cài thẳng bằng URL repo. Mỗi skill là một thư mục con chứa `SKILL.md` tự đứng — không phụ thuộc script, không phụ thuộc data file, không cần runtime ngoài.

## Cài như plugin

Repo này là một plugin skills-only hợp lệ: `plugin.json` ở gốc + ít nhất một `skills/<name>/SKILL.md`.

Trong Rakazo: **Plugins → Add → From GitHub** → dán `https://github.com/ezraphm/skills`.

- Repo phải **public** — Rakazo không đọc repo private.
- Rakazo pin vào **commit** lúc install. Sửa file sau đó thì phải **Remove rồi Add lại**; đổi `version` trong `plugin.json` không tự cập nhật.
- Cấu trúc:

```
plugin.json
skills/<skill-name>/SKILL.md
```

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
| [`ui-ux-pro-max`](skills/ui-ux-pro-max/SKILL.md) | UI/UX design intelligence: bảng ưu tiên 10 nhóm luật, workflow 4 bước, anti-pattern, checklist 16 mục trước khi giao UI | `huytran1120/vie-agentic-skills` |
| [`handoff-that-arrives`](skills/handoff-that-arrives/SKILL.md) | Giao việc cho bot khác phải tới tay: cấm viết `[to X]` trong chat, chỉ `message_bot` / `handoff_to_bot` là gửi thật, kèm luật bằng chứng gửi | tự viết |
| [`write-then-read-back`](skills/write-then-read-back/SKILL.md) | Sau mọi write phải đọc lại field thật trong cùng lượt trước khi báo done — `ok:true` chỉ chứng minh lệnh chạy, không chứng minh nội dung | tự viết |

## Cách dùng

Sau khi cài plugin, mở skill và gõ `/ui-ux-pro-max` trong composer.

Bản đầy đủ của `ui-ux-pro-max` có script (79 styles, 192 palettes, 74 font pairings, 119 UX guidelines, 105 icons, 17 GSAP presets, 25 chart types, 22 stacks) cài vào dự án bằng manifest chính thức:

```
https://huytran1120.github.io/vie-agentic-skills/install-manifests/ui-ux-pro-max.json
```

Cài vào `<project>/.agents/skills/ui-ux-pro-max/` rồi chạy `python3 .agents/skills/ui-ux-pro-max/scripts/search.py "<query>" --domain ux`.

Không dùng `${CLAUDE_PLUGIN_ROOT}` — biến đó chỉ tồn tại trong Claude Code.

## Thêm skill mới

1. Tạo `skills/<skill-name>/SKILL.md` với frontmatter `name` + `description`.
2. Tên skill phải khớp tên thư mục và không trùng skill có sẵn của Rakazo.
3. Áp 4 luật trên: không script ma, con trỏ thay database, fallback dùng được, không bịa output.
4. Thêm một dòng vào bảng Skills.
5. Commit.
