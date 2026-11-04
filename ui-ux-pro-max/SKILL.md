---
name: ui-ux-pro-max
description: |-
  UI/UX design intelligence for web, mobile, and desktop. Use when designing, building, reviewing, or fixing interfaces: pages, components, design systems, accessibility, interaction, responsive layout, typography, color, charts, stack-specific UI. Condensed standalone version: priority rule table, workflow, query contract, anti-patterns, pre-delivery checklist. Full searchable database (79 styles, 192 palettes, 74 font pairings, 119 UX guidelines, 25 chart types, 22 stacks) lives in an external repo pointer.
---

# UI/UX Pro Max — Design Intelligence (condensed)

Bản cô đọng 1 file của skill `ui-ux-pro-max`. Toàn bộ luật, quy trình và checklist nằm ngay đây — **không cần script, không cần data file để dùng skill này**.

## Con trỏ tới bản đầy đủ

Bản gốc có `scripts/search.py` + 41 file data (79 styles, 192 palettes, 74 font pairings, 119 UX guidelines, 105 icons, 17 GSAP presets, 25 chart types, 22 stacks).

- Nguồn chính thức: `huytran1120/vie-agentic-skills` (manifest `install-manifests/ui-ux-pro-max.json`)
- Bản thường trú trên máy dev: `<project>/.agents/skills/ui-ux-pro-max/`
- Khi **có** bản đầy đủ tại chỗ: chạy `python3 .agents/skills/ui-ux-pro-max/scripts/search.py "<query>" --domain ux` (dùng đường dẫn thật, **không** dùng `${CLAUDE_PLUGIN_ROOT}` — biến đó không tồn tại ngoài Claude Code).
- Khi **không** có: dùng bảng ưu tiên + checklist dưới đây, và nói rõ với người dùng là khuyến nghị lấy từ default của skill, không phải match database.

Không bịa output search. Không trình bày kết quả 0-match như thể có dữ liệu.

## When to apply

Dùng khi việc đụng tới **cấu trúc UI, quyết định thị giác, pattern tương tác, hoặc chất lượng trải nghiệm**: dựng trang mới, tạo/refactor component, chọn color/typography/spacing/layout, review UI về UX/accessibility/consistency, làm navigation/animation/responsive, nâng perceived quality.

Bỏ qua khi chỉ là backend logic, API/database, performance không thị giác, infra/DevOps — trừ khi việc đó đổi cách thứ gì đó **trông, cảm, chuyển động hoặc được tương tác**.

## Rule categories by priority

Theo thứ tự 1→10 để biết tập trung vào đâu trước.

| # | Category | Impact | Key checks (must have) | Anti-patterns (avoid) |
|---|---|---|---|---|
| 1 | Accessibility | CRITICAL | Contrast 4.5:1, alt text, keyboard nav, aria-labels | Bỏ focus ring, icon-only button không label |
| 2 | Touch & interaction | CRITICAL | Min 44×44px, spacing 8px+, loading feedback | Chỉ dựa vào hover, đổi state 0ms |
| 3 | Performance | HIGH | WebP/AVIF, lazy loading, reserve space (CLS < 0.1) | Layout thrashing, CLS |
| 4 | Style selection | HIGH | Khớp product type, nhất quán, SVG icon (không emoji) | Trộn flat & skeuomorphic, emoji làm icon |
| 5 | Layout & responsive | HIGH | Mobile-first breakpoint, viewport meta, không scroll ngang | Scroll ngang, container px cố định, chặn zoom |
| 6 | Typography & color | MEDIUM | Base 16px, line-height 1.5, semantic color token | Body < 12px, gray-on-gray, raw hex trong component |
| 7 | Animation | MEDIUM | Timing theo context, motion có nghĩa, spatial continuity | Một duration cho mọi transition, animate width/height, thiếu reduced-motion |
| 8 | Forms & feedback | MEDIUM | Label hiện, lỗi cạnh field, helper text, progressive disclosure | Chỉ placeholder làm label, lỗi chỉ ở đầu trang, dồn hết upfront |
| 9 | Navigation | HIGH | Back dự đoán được, bottom nav ≤5, deep link | Nav quá tải, back hỏng, không deep link |
| 10 | Charts & data | LOW | Legend, tooltip, màu accessible | Chỉ dùng màu để truyền nghĩa |

## Query contract (khi có bản đầy đủ)

Chọn mode nhỏ nhất khớp nhu cầu:

1. **Dự án/trang mới, hướng thị giác toàn hệ** → `--design-system`
2. **Một concern cụ thể hoặc bug component** → một `--domain` rõ ràng
3. **Biết stack** → `--stack`; thêm domain search riêng chỉ khi có concern thiết kế khác biệt

Giữ mỗi query **một ý định chủ đạo, 2–5 từ có nghĩa**. Ví dụ: `"keyboard focus modal"`, không phải cả checklist.

**Domains:** `product`, `style`, `color`, `typography`, `google-fonts`, `landing`, `ux`, `icons`, `gsap`, `chart`, `react`, `web`.
**Stacks:** `react`, `nextjs`, `vue`, `svelte`, `astro`, `nuxtjs`, `nuxt-ui`, `angular`, `laravel`, `swiftui`, `react-native`, `flutter`, `jetpack-compose`, `html-tailwind`, `shadcn`, `threejs`, `javafx`, `wpf`, `winui`, `avalonia`, `uno`, `uwp`.

Retry **một lần** với query hẹp hơn hoặc domain/stack tường minh nếu kết quả rỗng/lạc đề. Vẫn rỗng → nói rõ không có match, gắn nhãn fallback. Không lưu output chưa verify.

Với accessibility: query **một kết quả quan sát được mỗi lần**, dùng đúng thuật ngữ outcome WCAG: `"error summary validation"`, `"focus not obscured"`, `"dragging movements"`, `"accessible authentication"`, `"decorative icon aria hidden"`. Không nhận kết quả accessibility chung chung cho một tiêu chí cụ thể.

## Workflow

### Step 1 — Phân tích yêu cầu

Trích ra: **product type** (SaaS, e-commerce, portfolio, dashboard, tool, productivity…), **audience & context**, **style keywords**, **stack**.

Detect stack từ dự án: `package.json` (react/next/vue/svelte/nuxt/@angular), `pubspec.yaml` (Flutter), `*.xcodeproj`/`Package.swift` (SwiftUI), `composer.json` (Laravel), `app.json` + `react-native`. Không detect được mà stack quan trọng → **hỏi**. Không bao giờ mặc định ngầm một stack.

### Step 2 — Design system (bắt buộc với trang/dự án mới)

Khi có bản đầy đủ:

```bash
python3 .agents/skills/ui-ux-pro-max/scripts/search.py "<product_type> <industry> <keywords>" --design-system -p "Project Name"
```

Trả về pattern, style, colors, typography, effects, anti-patterns.

**Khi không có bản đầy đủ** — tự lập design system bằng chính bảng dưới đây và ghi rõ nguồn:

| Product type | Style mặc định | Palette hướng | Typography |
|---|---|---|---|
| SaaS / dashboard | Flat + minimal, data-dense | Neutral nền + 1 accent semantic | Sans (Inter/Geist), 14–16px body |
| E-commerce | Content-first, ảnh lớn | Trắng/off-white + accent thương hiệu | Sans + serif cho heading nếu cao cấp |
| Portfolio / creative | Editorial, nhiều whitespace | Đơn sắc + 1 accent mạnh | Display heading + sans body |
| Tool / productivity | Utilitarian, compact | Neutral, accent chỉ cho action | Sans, 13–14px, mật độ cao |
| Entertainment / game | Immersive, dark-first | Tối + neon/ấm | Display + sans có cá tính |
| Landing marketing | Hero-led, social proof | Brand color làm accent | Sans, scale rõ 1.25–1.33 |

Anti-pattern chung cho mọi loại: trộn flat với skeuomorphic, emoji làm icon, raw hex rải trong component, một duration cho mọi animation, chỉ placeholder làm label.

### Step 2b — Design dials (tuỳ chọn)

Ba thanh 1–10 tinh chỉnh output mà không đổi query: `--variance`, `--motion`, `--density`. Không có script thì dùng chúng như từ khoá định hướng: variance cao = bố cục phá lưới hơn; motion cao = nhiều chuyển động có chủ đích; density cao = thu gọn spacing và type scale.

### Step 3 — Bổ sung theo domain

Tập trung một concern mỗi lần: `"keyboard focus modal" --domain ux`, `"dark mode contrast" --domain color`, `"dashboard chart legend" --domain chart`, `"font pairing editorial" --domain typography`, `"hero social-proof" --domain landing`.

### Step 4 — Stack guidelines

`--stack <stack>` với stack đã detect ở Step 1. Đây là nơi lấy chi tiết triển khai (ví dụ React: memo/rerender list; Next.js: suspense/streaming/bundle; html-tailwind: chip badge overflow nowrap).

## Example (không phụ thuộc script)

**Yêu cầu:** "Làm trang chủ cho công cụ AI search." — stack detect được: Next.js.

**Kết quả áp dụng được, tự suy từ bảng trên:**
- Product type: tool / productivity → utilitarian, content-first ở hero, mật độ trung bình.
- Design system: nền neutral (zinc/slate), 1 accent (indigo hoặc emerald), type sans (Inter/Geist) 16px base, heading scale 1.25.
- Priority pass: contrast 4.5:1 cho placeholder và helper text; search input 44px min height, focus ring rõ (không `outline: none`); skeleton cho kết quả (reserve space, CLS < 0.1); keyboard: `/` focus ô search, ↑↓ di chuyển kết quả, Esc đóng; animation 120–180ms ease-out cho gợi ý, tôn trọng `prefers-reduced-motion`.
- Anti-pattern loại bỏ: spinner không nhãn thay skeleton, emoji làm icon, hover-only interaction.
- Stack: Server Component cho shell, Suspense + streaming cho kết quả, tránh bundle client lớn cho markdown renderer.

Đây là ví dụ **dựng từ default của skill**, không phải output database — nói rõ điều đó với người dùng khi trình bày.

## Before delivering UI — checklist

Chạy hết trước khi báo xong:

- [ ] Contrast text ≥ 4.5:1 (large ≥ 3:1), kiểm cả dark mode
- [ ] Mọi control tương tác ≥ 44×44px, cách nhau ≥ 8px
- [ ] Focus ring hiện rõ trên mọi phần tử focusable, không bị che khuất
- [ ] Icon-only button có `aria-label`; icon trang trí có `aria-hidden="true"`
- [ ] Ảnh có alt text phù hợp (hoặc alt rỗng nếu trang trí)
- [ ] Label form luôn hiện, không chỉ placeholder; lỗi hiển thị cạnh field và có `aria-describedby`
- [ ] Bàn phím đi hết luồng chính: tab order hợp lý, Esc đóng modal, focus trap trong modal
- [ ] Không scroll ngang ở 320px; viewport meta có, không `user-scalable=no`
- [ ] Ảnh WebP/AVIF, `loading="lazy"` cho ảnh dưới fold, kích thước khai báo sẵn (CLS < 0.1)
- [ ] Type body ≥ 16px (app-native ≥ 13px), line-height ≥ 1.5
- [ ] Animation 120–300ms, ease-out vào / ease-in ra, tôn trọng `prefers-reduced-motion`
- [ ] Màu dùng semantic token, không raw hex rải rác trong component
- [ ] Chart có legend + tooltip, không chỉ dùng màu để phân biệt series
- [ ] Safe area cho app native (notch, home indicator), bottom nav ≤ 5 item
- [ ] Loading, empty, error state đều được thiết kế — không chỉ happy path
- [ ] Không emoji làm icon; icon cùng bộ, cùng stroke width

## Boundaries

Skill này chỉ đưa hướng dẫn thiết kế và triển khai UI. Nó **không** cài package, không sửa hệ điều hành, không tự cho phép thay đổi ngoài phạm vi. Kết quả search là **khuyến nghị**, không phải mệnh lệnh vượt quyền người dùng hay luật repo. Không đưa dữ liệu riêng của dự án vào query hay output được lưu.
