extends Control

# 単元を選ぶページ (★v14★ 単元 → 小単元の2段階に変更)
# マイページの「単元を選ぶ」ボタン、またはメイン画面の
# 「練習問題に挑戦する」から開かれる
# 単元ボタンを押すと、その単元の小単元 (学習項目) のボタンが出る
# 小単元を選ぶと practice_quiz_page.gd (小単元モード) が上に開く
# 一番下には元素図鑑 (encyclopedia.gd) と難しめ模擬問題のボタンもある

var main_script

# 表示の状態: "units" = 単元の一覧 / "subs" = 小単元の一覧
var view := "modes"  # ★v30変更★ 最初は問題の種類を選ぶ画面
var current_unit := 0

const SAVE_PATH := "user://practice_history.json"
const QUIZ_PATH := "res://scripts/practice_quiz_page.gd"
const ENCYCLOPEDIA_PATH := "res://scripts/encyclopedia.gd"
const REACTION_PATH := "res://scripts/reaction_practice_page.gd"
const BLUE := Color("#2b5cb7")
const VIOLET := Color("#7c3aed")
const TEXT_COLOR := Color("#334155")

# practice_quiz_page.gd の QUESTIONS の単元分けと合わせること
const UNIT_INFO := [
	{"name": "第1単元　分解", "desc": "物質を分解させる実験・電気分解"},
	{"name": "第2単元　化合", "desc": "2つの物質を化合させる実験・性質の変化"},
	{"name": "第3単元　原子と分子", "desc": "原子や分子・化学反応式・イオン（発展）"},
	{"name": "第4単元　酸化と還元", "desc": "酸化の実験・還元の実験"},
	{"name": "第5単元　物質と化学変化の応用", "desc": "化学変化で熱や電気を取り出す"}
]
const QUESTIONS_PER_UNIT := 10

# 小単元 (学習項目): first は問題番号 (id) の始まり、count は問題数
const SUB_INFO := [
	{"name": "物質を分解させる実験", "unit": 0, "first": 1, "count": 5},
	{"name": "発展：塩化銅水溶液の電気分解", "unit": 0, "first": 6, "count": 5},
	{"name": "2つの物質を化合させる実験", "unit": 1, "first": 11, "count": 5},
	{"name": "化学変化前後での性質の変化", "unit": 1, "first": 16, "count": 5},
	{"name": "原子や分子", "unit": 2, "first": 21, "count": 4},
	{"name": "化学反応式", "unit": 2, "first": 25, "count": 3},
	{"name": "発展：周期表・原子の構造・イオン", "unit": 2, "first": 28, "count": 3},
	{"name": "酸化の実験", "unit": 3, "first": 31, "count": 5},
	{"name": "還元の実験", "unit": 3, "first": 36, "count": 5},
	{"name": "化学変化で熱や電気を取り出す", "unit": 4, "first": 41, "count": 10}
]


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)  # ★v27変更★ 大きさは _update_layout で管理
	_update_layout()
	_build_page()


# ★v27追加★ 画面が小さいときは全体を縮めて収める
func _update_layout() -> void:
	var vp := get_viewport().get_visible_rect().size
	var s := minf(1.0, minf(vp.y / 780.0, vp.x / 740.0))
	s = maxf(s, 0.05)
	scale = Vector2.ONE * s
	size = vp / s


# ★v27追加★ 画面サイズが変わったら作り直す
func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_update_layout()
		_build_page()


func _build_page() -> void:
	_clear_page()
	if view == "subs":
		_build_subs()
	elif view == "units":
		_build_units()
	elif view == "easy":
		_build_easy_units()
	else:
		_build_modes()


func _clear_page() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()


func _add_bg() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#f4f7fc")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)


func _add_title(title_text: String) -> void:
	var screen_size := size  # ★v27変更★
	var title := Label.new()
	title.text = title_text
	title.position = Vector2(0, 30)
	title.size = Vector2(screen_size.x, 50)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", BLUE)
	add_child(title)


# ★v29追加★ スライド風の大きな枠
func _add_frame(x: float, y: float, w: float, h: float) -> void:
	var frame := Panel.new()
	frame.position = Vector2(x, y)
	frame.size = Vector2(w, h)
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color.WHITE
	style.set_corner_radius_all(20)
	style.set_border_width_all(2)
	style.border_color = Color("#64748B")
	style.shadow_size = 10  # ★v31追加★ 影で囲いをきれいに
	style.shadow_color = Color(0.12, 0.18, 0.30, 0.12)
	style.shadow_offset = Vector2(0, 4)
	frame.add_theme_stylebox_override("panel", style)
	add_child(frame)


# ★v29追加★ スライド風のタイトル（左寄せ）
func _add_page_title(title_text: String, x: float, y: float, w: float) -> void:
	var title := Label.new()
	title.text = title_text
	title.position = Vector2(x, y)
	title.size = Vector2(w, 32)
	title.add_theme_font_size_override("font_size", 23)
	title.add_theme_color_override("font_color", TEXT_COLOR)
	add_child(title)


# ★v29追加★ スライド風の丸角バー型ボタン（白＋枠線）。accent=true で青くする
func _make_bar_btn(text_value: String, pos: Vector2, btn_size: Vector2, accent := false) -> Button:
	var btn := Button.new()
	btn.text = text_value
	btn.position = pos
	btn.size = btn_size
	btn.custom_minimum_size = btn_size
	var line_color := Color("#475569")
	var font_color := TEXT_COLOR
	if accent:
		line_color = BLUE
		font_color = BLUE
	btn.add_theme_font_size_override("font_size", 17)
	btn.add_theme_color_override("font_color", font_color)
	btn.add_theme_color_override("font_hover_color", font_color)
	btn.add_theme_color_override("font_pressed_color", font_color)
	btn.add_theme_color_override("font_focus_color", font_color)
	btn.add_theme_color_override("font_disabled_color", font_color)
	var style := StyleBoxFlat.new()
	style.bg_color = Color.WHITE
	style.set_corner_radius_all(26)
	style.shadow_size = 4  # ★v31追加★ バーにも薄い影
	style.shadow_color = Color(0.12, 0.18, 0.30, 0.08)
	style.shadow_offset = Vector2(0, 2)
	style.set_border_width_all(2)
	style.border_color = line_color
	style.content_margin_left = 16
	style.content_margin_right = 16
	var hover := style.duplicate() as StyleBoxFlat
	hover.bg_color = Color("#F1F5F9")
	if accent:
		hover.bg_color = Color("#EFF6FF")
	var pressed := style.duplicate() as StyleBoxFlat
	pressed.bg_color = Color("#E2E8F0")
	if accent:
		pressed.bg_color = Color("#DBEAFE")
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", pressed)
	btn.add_theme_stylebox_override("focus", style)
	return btn


# 単元の一覧
# 単元の一覧（★v29変更★ スライドの見た目：枠＋丸角の長いボタン）
# ★v30追加★ 問題の種類を選ぶ画面（最初に出る画面）
func _build_modes() -> void:
	_add_bg()
	var screen_size := size  # ★v27変更★
	var back_btn := _make_btn("⬅ 戻る", Vector2(40, 40), Vector2(120, 45), BLUE, Color.WHITE)
	back_btn.pressed.connect(func(): queue_free())
	add_child(back_btn)
	var btn_w: float = minf(700.0, screen_size.x - 96.0)
	var btn_h := 68.0
	var gap := 10.0
	var start_x := (screen_size.x - btn_w) / 2.0
	var frame_x := start_x - 32.0
	var frame_w := btn_w + 64.0
	var frame_y := 118.0
	_add_page_title("問題演習", frame_x, 74.0, frame_w)
	var bar_texts := [
		"📗 単元の簡易問題\n単元ごとに、かんたんな問題10問",
		"📘 小単元の少し細かい問題\n学習項目ごとに、くわしい問題",
		"📝 テスト問題\n難しい問題と自分で書く問題のテスト（50問）／記録は残らない",
		"📖 元素図鑑を見る\n勉強してから解く",
	]
	var frame_h := 24.0 + bar_texts.size() * btn_h + (bar_texts.size() - 1) * gap + 24.0
	_add_frame(frame_x, frame_y, frame_w, frame_h)
	var start_y := frame_y + 24.0
	for i in bar_texts.size():
		var btn := _make_bar_btn(bar_texts[i], Vector2(start_x, start_y + i * (btn_h + gap)), Vector2(btn_w, btn_h))
		if i == 0:
			btn.pressed.connect(_show_easy)
		elif i == 1:
			btn.pressed.connect(_show_units)
		elif i == 2:
			btn.pressed.connect(func(): _open_quiz("mock_hard", 0))
		else:
			btn.pressed.connect(_open_encyclopedia)
		add_child(btn)
	# 反応式の問題（枠の下）
	var reaction_y := frame_y + frame_h + 14.0
	var reaction_btn := _make_bar_btn("🧪 化学反応式の問題（箱をうめる）\n問題文を見て、反応式の箱を完成させよう　／　全10問", Vector2(start_x, reaction_y), Vector2(btn_w, btn_h))
	reaction_btn.pressed.connect(_open_reaction)
	add_child(reaction_btn)


# ★v30追加★ 簡易問題の単元を選ぶ画面
func _build_easy_units() -> void:
	_add_bg()
	var screen_size := size  # ★v27変更★
	var back_btn := _make_btn("⬅ 戻る", Vector2(40, 40), Vector2(120, 45), BLUE, Color.WHITE)
	back_btn.pressed.connect(_back_to_modes)
	add_child(back_btn)
	var btn_w: float = minf(700.0, screen_size.x - 96.0)
	var btn_h := 68.0
	var gap := 10.0
	var start_x := (screen_size.x - btn_w) / 2.0
	var frame_x := start_x - 32.0
	var frame_w := btn_w + 64.0
	var frame_y := 118.0
	_add_page_title("問題演習：単元の簡易問題", frame_x, 74.0, frame_w)
	var frame_h := 24.0 + UNIT_INFO.size() * btn_h + (UNIT_INFO.size() - 1) * gap + 24.0
	_add_frame(frame_x, frame_y, frame_w, frame_h)
	var start_y := frame_y + 24.0
	for i in UNIT_INFO.size():
		var info: Dictionary = UNIT_INFO[i]
		var text := "%s\n%s　／　簡易10問" % [info["name"], info["desc"]]
		var btn := _make_bar_btn(text, Vector2(start_x, start_y + i * (btn_h + gap)), Vector2(btn_w, btn_h))
		btn.pressed.connect(_open_easy_unit.bind(i))
		add_child(btn)


# 単元の一覧（小単元の少し細かい問題用）
func _build_units() -> void:
	_add_bg()
	var screen_size := size  # ★v27変更★
	var back_btn := _make_btn("⬅ 戻る", Vector2(40, 40), Vector2(120, 45), BLUE, Color.WHITE)
	back_btn.pressed.connect(_back_to_modes)
	add_child(back_btn)
	var btn_w: float = minf(700.0, screen_size.x - 96.0)
	var btn_h := 68.0
	var gap := 10.0
	var start_x := (screen_size.x - btn_w) / 2.0
	var frame_x := start_x - 32.0
	var frame_w := btn_w + 64.0
	var frame_y := 118.0
	_add_page_title("問題演習：単元・小単元", frame_x, 74.0, frame_w)
	var cleared := _load_cleared_ids()
	var frame_h := 24.0 + UNIT_INFO.size() * btn_h + (UNIT_INFO.size() - 1) * gap + 24.0
	_add_frame(frame_x, frame_y, frame_w, frame_h)
	var start_y := frame_y + 24.0
	for i in UNIT_INFO.size():
		var info: Dictionary = UNIT_INFO[i]
		var count := _count_cleared_in(cleared, i * QUESTIONS_PER_UNIT + 1, QUESTIONS_PER_UNIT)
		var text := "%s\n%s　／　クリア %d / %d問" % [info["name"], info["desc"], count, QUESTIONS_PER_UNIT]
		var btn := _make_bar_btn(text, Vector2(start_x, start_y + i * (btn_h + gap)), Vector2(btn_w, btn_h))
		btn.pressed.connect(_select_unit.bind(i))
		add_child(btn)


# 小単元の一覧 (選んだ単元の学習項目)（★v29変更★ スライドの見た目）
func _build_subs() -> void:
	_add_bg()
	var screen_size := size  # ★v27変更★
	var back_btn := _make_btn("⬅ 戻る", Vector2(40, 40), Vector2(120, 45), BLUE, Color.WHITE)
	back_btn.pressed.connect(_back_to_units)
	add_child(back_btn)
	var cleared := _load_cleared_ids()
	var btn_w: float = minf(700.0, screen_size.x - 96.0)
	var btn_h := 68.0
	var gap := 10.0
	var start_x := (screen_size.x - btn_w) / 2.0
	var frame_x := start_x - 32.0
	var frame_w := btn_w + 64.0
	var frame_y := 118.0
	_add_page_title("問題演習：単元・小単元", frame_x, 74.0, frame_w)
	# 右上に選んだ単元名を出す
	var unit_label := Label.new()
	unit_label.text = UNIT_INFO[current_unit]["name"]
	unit_label.position = Vector2(frame_x, 74.0)
	unit_label.size = Vector2(frame_w, 32)
	unit_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	unit_label.add_theme_font_size_override("font_size", 18)
	unit_label.add_theme_color_override("font_color", BLUE)
	add_child(unit_label)
	# この単元の小単元の数を数える
	var sub_count := 0
	for s0 in SUB_INFO.size():
		if int(SUB_INFO[s0]["unit"]) == current_unit:
			sub_count += 1
	var frame_h := 24.0 + sub_count * btn_h + (sub_count - 1) * gap + 14.0 + 60.0 + 24.0
	_add_frame(frame_x, frame_y, frame_w, frame_h)
	var start_y := frame_y + 24.0
	var row := 0
	for s in SUB_INFO.size():
		var info: Dictionary = SUB_INFO[s]
		if int(info["unit"]) != current_unit:
			continue
		var count := _count_cleared_in(cleared, int(info["first"]), int(info["count"]))
		var text := "%s\nクリア %d / %d問" % [info["name"], count, int(info["count"])]
		var btn := _make_bar_btn(text, Vector2(start_x, start_y + row * (btn_h + gap)), Vector2(btn_w, btn_h))
		btn.pressed.connect(_open_quiz.bind("sub", s))
		add_child(btn)
		row += 1
	# 単元の問題ぜんぶをまとめて解くボタン（枠の中の青いバー）
	var all_y := start_y + row * (btn_h + gap) + 4.0
	var unit_count := _count_cleared_in(cleared, current_unit * QUESTIONS_PER_UNIT + 1, QUESTIONS_PER_UNIT)
	var all_text := "📚 この単元の問題ぜんぶ（%d問）　／　クリア %d / %d問" % [QUESTIONS_PER_UNIT, unit_count, QUESTIONS_PER_UNIT]
	var all_btn := _make_bar_btn(all_text, Vector2(start_x, all_y), Vector2(btn_w, 60), true)
	all_btn.pressed.connect(func(): _open_quiz("unit", current_unit))
	add_child(all_btn)


func _show_easy() -> void:
	view = "easy"
	_build_page()


func _show_units() -> void:
	view = "units"
	_build_page()


func _back_to_modes() -> void:
	view = "modes"
	_build_page()


func _open_easy_unit(unit_index: int) -> void:
	_open_quiz("easy", unit_index)


func _select_unit(unit_index: int) -> void:
	current_unit = unit_index
	view = "subs"
	_build_page()


func _back_to_units() -> void:
	view = "units"
	_build_page()


# クイズページを開く (mode は "unit" / "sub" / "mock_hard")
func _open_quiz(mode: String, index: int) -> void:
	if not ResourceLoader.exists(QUIZ_PATH):
		_show_error("practice_quiz_page.gd が見つかりません。scripts フォルダに入っているか確認してね")
		return
	var script = load(QUIZ_PATH)
	if script == null:
		push_error("practice_quiz_page.gd が見つかりません: " + QUIZ_PATH)
		return
	var page = script.new()
	if not page.has_method("setup_quiz"):
		_show_error("practice_quiz_page.gd がうまく読み込めません。最新版 (v14) を入れ直してね")
		return
	page.main_script = main_script
	page.setup_quiz(mode, index)
	var parent_node: Node = get_parent() if get_parent() != null else self
	parent_node.add_child(page)
	parent_node.move_child(page, parent_node.get_child_count() - 1)


func _open_encyclopedia() -> void:
	if not ResourceLoader.exists(ENCYCLOPEDIA_PATH):
		_show_error("encyclopedia.gd が見つかりません。scripts フォルダに入っているか確認してね")
		return
	var script = load(ENCYCLOPEDIA_PATH)
	if script == null:
		push_error("encyclopedia.gd が見つかりません: " + ENCYCLOPEDIA_PATH)
		return
	var page = script.new()
	if not page.has_method("_create_element_grid"):
		_show_error("encyclopedia.gd がうまく読み込めません。最新版 (v7) を入れ直してね")
		return
	page.main_script = main_script
	var parent_node: Node = get_parent() if get_parent() != null else self
	parent_node.add_child(page)
	parent_node.move_child(page, parent_node.get_child_count() - 1)


func _open_reaction() -> void:
	if not ResourceLoader.exists(REACTION_PATH):
		_show_error("reaction_practice_page.gd が見つかりません。scripts フォルダに入っているか確認してね")
		return
	var script = load(REACTION_PATH)
	if script == null:
		push_error("reaction_practice_page.gd が見つかりません: " + REACTION_PATH)
		return
	var page = script.new()
	if not page.has_method("_build_question"):
		_show_error("reaction_practice_page.gd がうまく読み込めません。最新版 (v6) を入れ直してね")
		return
	page.main_script = main_script
	var parent_node: Node = get_parent() if get_parent() != null else self
	parent_node.add_child(page)
	parent_node.move_child(page, parent_node.get_child_count() - 1)


func _load_cleared_ids() -> Array:
	if not FileAccess.file_exists(SAVE_PATH):
		return []
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return []
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return []
	var stats: Dictionary = parsed.get("stats", {})
	var ids: Array = stats.get("answered_question_ids", [])
	var result: Array = []
	for v in ids:
		result.append(int(v))
	return result


# 問題番号 first から count 個のうち、クリア済みの数を数える
func _count_cleared_in(cleared: Array, first: int, count: int) -> int:
	var n := 0
	for qid in cleared:
		if int(qid) >= first and int(qid) < first + count:
			n += 1
	return n


func _make_btn(text_value: String, pos: Vector2, btn_size: Vector2, bg_color: Color, font_color: Color) -> Button:
	var btn := Button.new()
	btn.text = text_value
	btn.position = pos
	btn.size = btn_size
	btn.custom_minimum_size = btn_size
	btn.add_theme_font_size_override("font_size", 17)
	btn.add_theme_color_override("font_color", font_color)
	btn.add_theme_color_override("font_hover_color", font_color)
	btn.add_theme_color_override("font_pressed_color", font_color)
	btn.add_theme_color_override("font_focus_color", font_color)
	btn.add_theme_color_override("font_disabled_color", font_color)
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.set_corner_radius_all(14)
	style.set_border_width_all(2)
	style.border_color = Color("#cbd5e1")
	style.content_margin_left = 16
	style.content_margin_right = 16
	var hover := style.duplicate() as StyleBoxFlat
	hover.bg_color = bg_color.lightened(0.08)
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", style)
	return btn


# 開くファイルが無いとき、画面にも知らせる（今までは裏でエラーだけだった）
func _show_error(message: String) -> void:
	var label := Label.new()
	label.text = message
	label.position = Vector2(0, 8)
	label.size = Vector2(size.x, 30)  # ★v27変更★
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 16)
	label.add_theme_color_override("font_color", Color("#dc2626"))
	add_child(label)
