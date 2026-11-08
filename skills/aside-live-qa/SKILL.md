---
name: aside-live-qa
description: "Kiểm (test/review) extension hoặc web app bằng cách chạy nó trong Aside thật của chủ nhân và đọc runtime — không dùng Chrome, không dùng container Chromium. Dùng khi cần bằng chứng \"code đã nạp và chạy thật\" (extension có inject không, key localStorage có sinh ra không, UI có render không, phiên đăng nhập có không) trước khi ký PASS một PR."
---

# aside-live-qa

Mục tiêu: biến "PR này chạy được không" từ **đọc diff** thành **số đo runtime trên profile thật của chủ nhân**. Chạy trên máy chủ nhân (macOS) qua Aside CLI.

## 0. Luật cứng

Quyền chia làm **ba mức**, không nới hơn mức đã ghi:

- **(a) Đọc state — tự làm.** `listBrowserTabs`, `attachBrowserTab`, `page.evaluate`, `snapshot`, đọc file cấu hình, `git`, test tĩnh.
- **(b) Reload extension / reload tab host — cần đồng ý MỘT lần cho mỗi phiên QA**, ghi bằng chứng trước và sau (extension id, `location`, `path`, mtime `manifest.json`, version trên card). Không làm khi chưa có đồng ý đó.
- **(c) Cấm tuyệt đối — luôn xin phép, không tự làm.** Nạp/gỡ extension, sửa `Secure Preferences`, login thay chủ nhân, click Connect/Sign, đụng ví/seed, mở Chrome, restart/kill Aside, bật cờ debug.

Các luật khác vẫn nguyên:

- **Không mở Chrome.** Không đụng `~/Library/Application Support/Google/Chrome`. Chủ nhân đã cấm.
- **Không restart/kill Aside**, không bật cờ debug rồi thoát app. Nếu CDP `/json*` trả 404 → bỏ CDP, đi bằng `aside repl`.
- **Không `aside exec`.** Tuân `user-computer-browser`: chỉ `aside repl`.
- Mọi kết luận phải kèm **số đo** (độ dài DOM, tên key, giá trị, md5 file, mtime). Không dùng ảnh desktop làm bằng chứng khi cần state runtime.
- Phân biệt **"không tìm thấy"** với **"không tồn tại"**. Grep manifest = 0 **không** chứng minh extension không chạy: nó có thể được nạp unpacked từ thư mục dev. Kiểm bằng runtime (`window.<hub>`, key localStorage).
- **Màn hình khoá thì không có gì để đo.** `Aside` trả "The user's screen is locked" → ghi *chưa đo được*, không suy diễn.

## 1. Kiểm tra CLI (máy chủ nhân, không phải container)

```bash
which aside            # ~/.local/bin/aside
aside --version
aside guide            # đọc hướng dẫn thật, KHÔNG đoán cú pháp
aside guide repl       # đọc riêng phần repl trước khi dùng
aside --update && aside guide   # nếu guide báo CLI cũ
```

Ghi version vào báo cáo. Không chép version từ báo cáo người khác: version trong tài liệu QA là **số của máy đã chạy lệnh đó**.

## 1bis. Gate nạp build mới — chạy TRƯỚC mọi số đo

`aside repl` gắn vào page đang có, **không** nạp lại extension MV3. Đo trước khi reload là đo build cũ, và mọi kết luận "code sai" rút ra từ đó đều sai.

### 1bis.1 Có phải build cũ không?

```js
console.log(await page.evaluate(() => ({
  url: location.href,
  marker: document.body.dataset.<marker-cũ>,
  hasHub: typeof window.__<hub> !== 'undefined',
  hasNewGlobal: typeof window.<global-của-PR> !== 'undefined',
})));
```

Marker cũ **có**, global của PR **undefined** → một trong hai: build cũ, hoặc build mới nhưng content script cũ còn trong tab. **Không được kết luận "code sai".** Phải tách hai khả năng bằng §1bis.2 rồi §1bis.4.

### 1bis.2 Đang nạp build nào — đọc từ profile Aside

```bash
P="$HOME/Library/Application Support/Aside/Default/Secure Preferences"
python3 -c "import json,sys; d=json.load(open(sys.argv[1]));
[print(eid, v.get('location'), v.get('path')) for eid,v in d['extensions']['settings'].items() if 'farmstead' in str(v.get('path',''))]" "$P"

cd <path-in-manifest>            # đường dẫn vừa in ra
git rev-parse --short HEAD
git log -1 --format=%cI
python3 -c "import json;print(json.load(open('manifest.json'))['version'])"
stat -f '%Sm %N' -t '%Y-%m-%d %H:%M:%S' manifest.json
```

`location 4` = UNPACKED. Suy luận đúng: `mtime(manifest.json)` **cũ hơn** mốc commit/reload và global mới vắng mặt → **code chưa nạp**, không phải code sai. Nếu `mtime` mới hơn mốc reload mà global vẫn `undefined` → lúc đó mới được nghi code.

### 1bis.3 Mở trang quản lý extension (mức (b): cần đồng ý 1 lần)

Trước hết kiểm tab đã có chưa — rẻ và không tạo tab rác:

```js
const t = await listBrowserTabs();
console.log(t.map(x => ({ id: x.targetId, active: x.active, url: x.url })));
```

- **Đã có tab quản lý extension** → `await attachBrowserTab('<targetId>')`, sang §1bis.4.
- **Chưa có** → thử `openTab('chrome://extensions')` (hoặc `coccoc://extensions` nếu Aside báo lỗi scheme), rồi `listBrowserTabs()` lại để xác nhận tab tồn tại **và** attach được.

**Đã đo trên Aside 1.26.1104.1843 (2026-11-08) — đừng thử lại các đường này:**

| Cách | Kết quả |
|---|---|
| `openTab('chrome://extensions/')` | Tab được tạo nhưng **không thành page**: `waitForInteractive` timeout 30s |
| `page.goto('chrome://extensions/')` | `page` = `null` |
| `page.evaluate` trên `chrome://…` | Bị chặn — scheme nội bộ không cho script chèn |
| `attachBrowserTab` / `snapshot` trên tab `chrome://…` | **Chưa đo** — đừng viết như đã biết |
| `chrome.management.setEnabled(id, false→true)` | Không có `reload` trong API công khai |
| Cài extension thứ ba để reload hộ (`http://reload.extensions`) | Cần đồng ý + là dependency lạ; `manifest.json` không được nạp lại bằng cách này |

Nếu `openTab`/attach thất bại → **dừng, xin takeover**, đừng thử vòng.

### 1bis.4 Reload — việc của chủ nhân (mức (b))

Không có đường lập trình nào reload một extension MV3 đã nạp trong profile Aside. Giao diện cho chủ nhân, đúng thứ tự:

1. Gõ `chrome://extensions` vào thanh địa chỉ (URL này **không** dạng link được — by design).
2. Bật **Developer mode** (góc trên phải) để nút ⟳ hiện ra.
3. Tìm card extension (unpacked: tên + đường dẫn dev) → bấm **⟳ Reload**.
4. Quay lại tab app → **F5** (content script đã nạp trong tab cũ vẫn là bản cũ).
5. Nhắn **"reload xong"**.

Chỉ bấm nút Reload hay bật Developer mode khi đã có đồng ý ở mức (b); nếu agent tự bấm được qua snapshot thì vẫn ghi lại như một hành động UI có đồng ý.

### 1bis.5 Đo lại sau reload (thứ tự bắt buộc)

`reload extension → reload tab host → chờ DOM sẵn → đo lại §1bis.1`.

Chỉ số ghi vào báo cáo: extension **id + `location` + `path`**, **version** trên card, **`mtime` manifest**, **`committer-date` HEAD**, global mới có/không, hành vi UI của PR. Global mới vẫn `undefined` sau reload+reload tab → build mới chưa nạp hoặc manifest không trỏ tới file mới: kiểm mục **Errors** trên card (`chrome://extensions`) và `grep` manifest (§4). Lúc đó mới được coi là lỗi code.

## 2. Vào repo và **pull sạch trước khi review**

Luôn chứng minh code sẽ test **đúng là code trên nhánh đích**, không lẫn file rơi rớt.

```bash
cd <repo>
git remote -v                   # xác nhận đúng repo (đừng nhầm repo cùng tên)
git fetch --all --prune
git status -sb                  # behind/ahead + file untracked
git rev-list --left-right --count HEAD...origin/<branch>
```

Nếu untracked file **sẽ bị ghi đè** bởi pull (`would be overwritten by merge`):

1. `mkdir -p .rosie-backup && cp <file> .rosie-backup/<file>.<date>.bak` — luôn sao lưu.
2. `diff -u <(git show origin/<branch>:<file>) <file>` — xem nó là bản cũ (trùng ý) hay bản mới hơn.
3. Chỉ xoá khi bản remote là bản cần test; ghi rõ file backup ở đâu trong báo cáo.
4. `git pull --ff-only` → xác nhận `git rev-parse --short HEAD` == `git rev-parse --short origin/<branch>`.

Nếu cần đúng PR: `git fetch origin pull/<n>/head && git checkout -B qa/pr-<n> FETCH_HEAD` để test đúng merge commit.

## 3. Chạy test tĩnh trước (nhanh, rẻ)

```bash
node test/run.js   # hoặc lệnh test của repo
```

Đếm số `passed/failed/skipped` và **số test động tới feature đang review** (`grep -c "<feature>:"`). PASS toàn bộ mà 0 test chạm feature = **chưa có bằng chứng**.

## 4. Xác nhận code thật sự được nạp vào trình duyệt

Trước khi đổ lỗi cho runtime, kiểm build/manifest:

```bash
grep -n "<file>.js" manifest.json          # file có trong content_scripts / web_accessible_resources không
grep -n "<file>.js" sidepanel/*.html       # script có được <script src> không
grep -rn "<feature>" sidepanel/ content/ | head -30   # cả hai nửa: writer + reader
```

Thiếu ở **một** trong ba chỗ (manifest, html, cặp writer/reader) = chưa nạp = **chưa chạy được**, bất kể test xanh.

## 5. Mở Aside và đọc runtime

```bash
aside repl
```

Trong REPL:

```js
const t = await listBrowserTabs();
console.log(t.map(x => ({ id: x.targetId, active: x.active, title: x.title, url: x.url })));
await attachBrowserTab('<targetId>');           // dùng tab đã mở; chỉ openTab() khi không có
const s1 = await snapshot(page, { interactive: true });
console.log(s1.tree);
```

Đọc state thật (dùng `page.evaluate` **chỉ khi biết đúng selector/key**):

```js
console.log(await page.evaluate(() => {
  const ls = JSON.parse(JSON.stringify(localStorage));
  const keys = Object.keys(ls);
  return { url: location.href, len: document.body.innerText.length,
           lsKeys: keys.length, featureKeys: keys.filter(k => k.startsWith('fs')),
           hasKey: keys.includes('<key-của-PR>'),
           hubGlobals: Object.keys(window).filter(k => /hub|FS|fs[A-Z]/i.test(k)),
           bodyDataset: { ...document.body.dataset }, title: document.title };
}));
```

Checklist bằng chứng tối thiểu:

- **Đã qua gate §1bis:** có `mtime` manifest + version đã nạp, không thì mọi số dưới đây là số của build cũ.
- **Trang thật, không phải landing:** DOM vài nghìn ký tự + copy UI thật (hoặc title/URL đúng khu vực sau đăng nhập).
- **Extension đang chạy:** một global của extension (`window.<x>Hub`, `window.__<x>`) hoặc key localStorage do extension ghi.
- **Code của PR đã nạp:** key/dataset/global **mà chỉ code mới sinh ra** phải tồn tại. Absent sau khi đã qua §1bis = code chưa nạp — kết luận cứng, không phải "môi trường thiếu".
- **UI mới render được:** hàm render là function, host element tồn tại và có con.
- **Đối chứng âm:** nếu có bản không PR, đo cùng chỉ số để chứng minh chỉ số đó phân biệt được.

## 6. Kết luận

Bảng 4 cột: **mục nghiệm thu · trạng thái · bằng chứng số · đo lúc nào**.

Ba trạng thái hợp lệ: PASS / FAIL / **chưa đo được** (kèm lý do cụ thể).

Cấm: ký PASS thay bằng suy luận; cấm ghi "chưa chạy" khi môi trường đã sẵn sàng mà chỉ thiếu build; cấm ghi "môi trường thiếu" khi thật ra code chưa nạp; cấm kết luận "code sai" khi chưa qua gate §1bis.

## 7. Bàn giao

- Lưu bằng chứng vào `shared/performance/qa-<date>-<pr>.md` + md5.
- `attach_file` thành artifact cho chủ nhân (name + 1 dòng description), không chỉ nêu đường dẫn.
- Trả verdict cho người điều phối; không merge, không tag, không push, không comment PR nếu chưa được duyệt.
