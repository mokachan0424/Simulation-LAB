extends Control

var main_script

const SAVE_PATH := "user://practice_history.json"
const TOTAL_QUESTIONS := 50
const BLUE := Color("#2b5cb7")
const TEXT_COLOR := Color("#334155")
const SUB_COLOR := Color("#64748b")

var card_style: StyleBoxFlat
var username := "ゲスト"
var title_label: Label


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	# ★v2追加★ main.gd 経由で名前が渡ってこなくても、
	# ログイン・登録時に保存された名前を自分で読み込む
	var saved_name := _load_current_user()
	if saved_name != "":
		username = saved_name
	_build_page()


func _load_current_user() -> String:
	var path := "user://current_user.txt"
	if not FileAccess.file_exists(path):
		return ""
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""
	var saved := file.get_as_text().strip_edges()
	file.close()
	return saved


# ★修正★ 表示済みのタイトルも書き換える set_username
func set_username(new_name: String) -> void:
	if new_name.strip_edges() == "":
		return
	username = new_name
	if is_instance_valid(title_label):
		title_label.text = username + ":マイページ"


func _build_page() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#f4f7fc")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	# ★修正★ ローカル変数 title ではなく title_label に入れる
	title_label = Label.new()
	title_label.text = username + ":マイページ"
	title_label.position = Vector2(0, 40)
	title_label.size = Vector2(size.x, 50)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 28)
	title_label.add_theme_color_override("font_color", BLUE)
	add_child(title_label)

	var back_btn = _make_btn(
		"⬅ 戻る",
		Vector2(40, 40),
		Vector2(120, 45),
		BLUE
	)
	back_btn.pressed.connect(_go_back)
	add_child(back_btn)

	_create_layout_cards()


func _create_layout_cards() -> void:
	var screen_size := get_viewport().get_visible_rect().size
	var base_width := screen_size.x

	card_style = StyleBoxFlat.new()
	card_style.bg_color = Color("#FFFFFF")
	card_style.set_corner_radius_all(18)
	card_style.set_border_width_all(2)
	card_style.border_color = Color("#cbd5e1")
	card_style.shadow_size = 6
	card_style.shadow_color = Color(0, 0, 0, 0.05)

	# 保存済み成績を読み込む
	var history := _load_history()
	var stats: Dictionary = history.get("stats", {})
	var mistakes: Array = history.get("mistakes", [])
	var answered_ids: Array = stats.get("answered_question_ids", [])
	var total_answers := int(stats.get("total_answers", 0))
	var correct_answers := int(stats.get("correct_answers", 0))
	var answered_count := answered_ids.size()
	var unanswered_count: int = max(TOTAL_QUESTIONS - answered_count, 0)

	var progress_rate := 0.0
	if TOTAL_QUESTIONS > 0:
		progress_rate = float(answered_count) / float(TOTAL_QUESTIONS) * 100.0

	var accuracy_rate := 0.0
	if total_answers > 0:
		accuracy_rate = float(correct_answers) / float(total_answers) * 100.0

	# 上部の進捗パネル
	var progress_w: float = minf(740.0, base_width - 32.0)  # ★v27変更★ 狭い画面では縮める
	var progress_h := 125.0
	var short_screen := screen_size.y < 660.0  # ★v27追加★ 背の低い画面かどうか
	if short_screen:
		progress_h = 105.0
	var progress_x := (base_width - progress_w) / 2.0
	var progress_y := 125.0
	if short_screen:
		progress_y = 104.0

	var card1 := Panel.new()
	card1.position = Vector2(progress_x, progress_y)
	card1.size = Vector2(progress_w, progress_h)
	card1.add_theme_stylebox_override("panel", card_style)
	add_child(card1)

	var lbl1 := Label.new()
	lbl1.text = "現在の学習進捗状況"
	lbl1.position = Vector2(25, 12)
	lbl1.size = Vector2(250, 25)
	lbl1.add_theme_font_size_override("font_size", 17)
	lbl1.add_theme_color_override("font_color", TEXT_COLOR)
	card1.add_child(lbl1)

	var progress := ProgressBar.new()
	progress.position = Vector2(25, 48)
	progress.size = Vector2(progress_w - 50, 22)
	progress.min_value = 0
	progress.max_value = 100
	progress.value = progress_rate
	card1.add_child(progress)

	var progress_label := Label.new()
	progress_label.text = "%d / %d 問　（%.1f%%）" % [
		answered_count,
		TOTAL_QUESTIONS,
		progress_rate
	]
	progress_label.position = Vector2(25, 77)
	progress_label.size = Vector2(progress_w - 50, 25)
	progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	progress_label.add_theme_font_size_override("font_size", 16)
	progress_label.add_theme_color_override("font_color", BLUE)
	card1.add_child(progress_label)

	# 下部3列カード
	var card_w: float = minf(230.0, (base_width - 32.0 - 50.0) / 3.0)  # ★v27変更★ 画面幅に合わせる
	var card_h := 320.0
	var gap_x := 25.0
	var total_w := card_w * 3.0 + gap_x * 2.0
	var start_x := (base_width - total_w) / 2.0
	var card_gap_y := 30.0
	if short_screen:
		card_gap_y = 14.0
	var start_y := progress_y + progress_h + card_gap_y

	# 単元・小単元カード
	var card2 := _make_card(
		Vector2(start_x, start_y),
		Vector2(card_w, card_h)
	)
	_add_card_title(card2, "単元・小単元", card_w)
	_add_info_label(
		card2,
		"回答済み：%d問\n未回答：%d問" % [
			answered_count,
			unanswered_count
		],
		Vector2(20, 115),
		Vector2(card_w - 40, 75),
		17
	)
	var btn2 = _make_btn(
		"単元を選ぶ",
		Vector2(20, card_h - 75),
		Vector2(card_w - 40, 45),
		BLUE
	)
	btn2.pressed.connect(_open_unit_select)
	card2.add_child(btn2)

	# 成績管理・復習カード
	var card3 := _make_card(
		Vector2(start_x + card_w + gap_x, start_y),
		Vector2(card_w, card_h)
	)
	_add_card_title(card3, "成績管理・復習", card_w)
	_add_info_label(
		card3,
		"累計回答数：%d回\n正解数：%d回\n正答率：%.1f%%\n復習待ち：%d問" % [
			total_answers,
			correct_answers,
			accuracy_rate,
			mistakes.size()
		],
		Vector2(15, 100),
		Vector2(card_w - 30, 120),
		15
	)
	var btn3 = _make_btn(
		"復習する",
		Vector2(20, card_h - 75),
		Vector2(card_w - 40, 45),
		BLUE
	)
	btn3.pressed.connect(_open_quiz.bind("review", -1))
	card3.add_child(btn3)

	# 模擬問題カード
	var card4 := _make_card(
		Vector2(start_x + (card_w + gap_x) * 2.0, start_y),
		Vector2(card_w, card_h)
	)
	_add_card_title(card4, "模擬問題", card_w)
	_add_info_label(
		card4,
		"これまでの学習を\n振り返って\n実力を確認しよう！",
		Vector2(15, 115),
		Vector2(card_w - 30, 90),
		16
	)
	var btn4 = _make_btn(
		"模試に挑戦",
		Vector2(20, card_h - 75),
		Vector2(card_w - 40, 45),
		BLUE
	)
	btn4.pressed.connect(_open_quiz.bind("mock", -1))
	card4.add_child(btn4)

	# ★v8追加★ マイページから直接、元素記号図鑑へつなぐボタン
	var enc_btn = _make_btn(
		"📖 元素記号図鑑を見る",
		Vector2(progress_x, start_y + card_h + 20.0),
		Vector2(progress_w, 50),
		Color("#0e7490")
	)
	enc_btn.pressed.connect(_open_encyclopedia)
	add_child(enc_btn)


func _make_card(pos: Vector2, card_size: Vector2) -> Panel:
	var card := Panel.new()
	card.position = pos
	card.size = card_size
	card.add_theme_stylebox_override("panel", card_style)
	add_child(card)
	return card


func _add_card_title(card: Panel, text_value: String, card_width: float) -> void:
	var label := Label.new()
	label.text = text_value
	label.position = Vector2(0, 40)
	label.size = Vector2(card_width, 40)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", Color("#1e293b"))
	card.add_child(label)


func _add_info_label(
	card: Panel,
	text_value: String,
	pos: Vector2,
	label_size: Vector2,
	font_size: int
) -> void:
	var label := Label.new()
	label.text = text_value
	label.position = pos
	label.size = label_size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", TEXT_COLOR)
	card.add_child(label)


func _load_history() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {
			"stats": {
				"total_answers": 0,
				"correct_answers": 0,
				"answered_question_ids": []
			},
			"mistakes": []
		}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return {}
	var json_text := file.get_as_text()
	file.close()
	var parsed = JSON.parse_string(json_text)
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	return parsed


func _go_back() -> void:
	if main_script and main_script.has_method("show_menu_after_auth"):
		main_script.show_menu_after_auth()
	elif main_script and main_script.has_method("show_menu_from_practice"):
		main_script.show_menu_from_practice()
	queue_free()


# =====================================
# ★v3追加★ 青ボタンから各ページへ移動
# =====================================

const UNIT_SELECT_PATH := "res://scripts/unit_select_page.gd"
const QUIZ_PATH := "res://scripts/practice_quiz_page.gd"
const ENCYCLOPEDIA_PATH := "res://scripts/encyclopedia.gd"


func _open_unit_select() -> void:
	if not ResourceLoader.exists(UNIT_SELECT_PATH):
		_show_error("unit_select_page.gd が見つかりません。scripts フォルダに入っているか確認してね")
		return
	var script = load(UNIT_SELECT_PATH)
	if script == null:
		push_error("unit_select_page.gd が見つかりません: " + UNIT_SELECT_PATH)
		return
	var page = script.new()
	page.main_script = main_script
	_add_page_on_top(page)


func _open_encyclopedia() -> void:
	if not ResourceLoader.exists(ENCYCLOPEDIA_PATH):
		_show_error("encyclopedia.gd が見つかりません。scripts フォルダに入っているか確認してね")
		return
	var script = load(ENCYCLOPEDIA_PATH)
	if script == null:
		_show_error("encyclopedia.gd が見つかりません。scripts フォルダに入っているか確認してね")
		return
	var page = script.new()
	page.main_script = main_script
	_add_page_on_top(page)


func _open_quiz(mode: String, unit_index: int) -> void:
	if not ResourceLoader.exists(QUIZ_PATH):
		_show_error("practice_quiz_page.gd が見つかりません。scripts フォルダに入っているか確認してね")
		return
	var script = load(QUIZ_PATH)
	if script == null:
		push_error("practice_quiz_page.gd が見つかりません: " + QUIZ_PATH)
		return
	var page = script.new()
	page.main_script = main_script
	# add_child の前にモードを渡す (_ready で使われるため)
	page.setup_quiz(mode, unit_index)
	_add_page_on_top(page)


func _add_page_on_top(page: Node) -> void:
	# マイページは消さず、上に重ねて開く。戻るでマイページに戻れる
	if get_parent() != null:
		get_parent().add_child(page)
	else:
		add_child(page)


# ★v7追加★ main.gd の _make_button に頼らず、自分でボタンを作る
func _make_btn(text_value: String, pos: Vector2, btn_size: Vector2, bg_color: Color, font_color: Color = Color.WHITE) -> Button:
	var btn := Button.new()
	btn.text = text_value
	btn.position = pos
	btn.size = btn_size
	btn.custom_minimum_size = btn_size
	btn.add_theme_font_size_override("font_size", 16)
	btn.add_theme_color_override("font_color", font_color)
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.set_corner_radius_all(12)
	style.set_border_width_all(2)
	style.border_color = Color("#cbd5e1")
	var hover := style.duplicate() as StyleBoxFlat
	hover.bg_color = bg_color.lightened(0.08)
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", style)
	return btn

# ★v7追加★ 開くファイルが無いとき、画面にも知らせる（今までは裏でエラーだけだった）
func _show_error(message: String) -> void:
	var label := Label.new()
	label.text = message
	label.position = Vector2(0, 8)
	label.size = Vector2(get_viewport().get_visible_rect().size.x, 30)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 16)
	label.add_theme_color_override("font_color", Color("#dc2626"))
	add_child(label)
