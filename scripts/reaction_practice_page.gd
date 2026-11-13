extends Control

# 問題演習：原子・化学反応式問題 (レイアウトv1 スライド8 の形)
# 上のカードに問題文と反応式 [箱] + [箱] = 生成物 を出す
# 下の「原子一覧」から化学式のカードをタップすると、選んでいる箱に入る
# ボタン: ホームへ / 前の問題へ / チェック / 解答 / 次へ (★v34変更★ 5ボタン)
#   「ホームへ」= 問題を選ぶ画面に戻る、「前の問題へ」= 1つ前の問題に戻る
# v1 では練習履歴 (practice_history.json) には保存しない。
# 進捗の混ざりを避けるため、形が決まってから保存方法を決める。

var main_script

const BLUE := Color("#2b5cb7")
const TEXT_COLOR := Color("#334155")
const SUB_COLOR := Color("#64748b")
const GREEN := Color("#16a34a")
const RED := Color("#dc2626")
const BORDER := Color("#cbd5e1")

# q: 問題文 / pair: 箱に入る正解2つ (左右どちらの順でも正解)
# product: = の右に表示する生成物 / choices: 原子一覧に出すカード
# exp: チェック正解時と「解答」で出す説明
const QUESTIONS := [
	{"q": "水素と酸素が反応すると、水ができます。\n反応する物質を2つ選んで、化学反応式を完成させよう。", "pair": ["2H₂", "O₂"], "product": "2H₂O", "choices": ["2H₂", "O₂", "H₂", "CO₂", "N₂"], "exp": "水素と酸素が化合すると水ができます。原子の数が左右で同じになるように係数がついています。"},
	{"q": "炭素 (木炭) が空気中で燃えると、二酸化炭素ができます。\n反応する物質を2つ選ぼう。", "pair": ["C", "O₂"], "product": "CO₂", "choices": ["C", "O₂", "CO", "S", "H₂"], "exp": "炭素と酸素が化合すると二酸化炭素 CO₂ ができます。"},
	{"q": "マグネシウムが空気中で燃えると、酸化マグネシウムができます。\n反応する物質を2つ選ぼう。", "pair": ["2Mg", "O₂"], "product": "2MgO", "choices": ["2Mg", "O₂", "Mg", "H₂", "CO₂"], "exp": "マグネシウムは強い光を出して燃え、酸素と化合して酸化マグネシウムになります。"},
	{"q": "銅を空気中で加熱すると、酸化銅ができます。\n反応する物質を2つ選ぼう。", "pair": ["2Cu", "O₂"], "product": "2CuO", "choices": ["2Cu", "O₂", "Cu", "Fe", "H₂O"], "exp": "銅が酸素と化合する (酸化する) と、黒い酸化銅ができます。"},
	{"q": "鉄と硫黄を混ぜて加熱すると、硫化鉄ができます。\n反応する物質を2つ選ぼう。", "pair": ["Fe", "S"], "product": "FeS", "choices": ["Fe", "S", "Zn", "C", "O₂"], "exp": "鉄と硫黄が化合すると硫化鉄 FeS ができます。磁石につかなくなるのが目印です。"},
	{"q": "酸化銅に炭素を混ぜて加熱すると、銅と二酸化炭素ができます。\n反応する物質を2つ選ぼう。", "pair": ["2CuO", "C"], "product": "2Cu + CO₂", "choices": ["2CuO", "C", "Cu", "H₂", "O₂"], "exp": "炭素が酸化銅から酸素をうばう変化 (還元) です。銅がもどり、二酸化炭素が出ます。"},
	{"q": "マグネシウムにうすい塩酸を加えると、水素が発生します。\n反応する物質を2つ選ぼう。", "pair": ["Mg", "2HCl"], "product": "MgCl₂ + H₂", "choices": ["Mg", "2HCl", "HCl", "H₂", "O₂"], "exp": "金属と酸が反応すると水素が発生します。塩酸は HCl です。"},
	{"q": "塩酸に水酸化ナトリウム水溶液を加えると、中和が起こります。\n反応する物質を2つ選ぼう。", "pair": ["HCl", "NaOH"], "product": "NaCl + H₂O", "choices": ["HCl", "NaOH", "CaCO₃", "Mg", "O₂"], "exp": "酸とアルカリの中和では、塩 (NaCl) と水ができます。"},
	{"q": "炭酸カルシウム (石灰石) にうすい塩酸を加えると、二酸化炭素が発生します。\n反応する物質を2つ選ぼう。", "pair": ["CaCO₃", "2HCl"], "product": "CaCl₂ + H₂O + CO₂", "choices": ["CaCO₃", "2HCl", "HCl", "NaOH", "H₂"], "exp": "石灰石に塩酸をかけると二酸化炭素が出ます。石灰水が白くにごるのが確かめ方です。"},
	{"q": "鉄を硫酸銅水溶液に入れると、銅が出てきます。\n反応する物質を2つ選ぼう。", "pair": ["Fe", "CuSO₄"], "product": "FeSO₄ + Cu", "choices": ["Fe", "CuSO₄", "Cu", "NaOH", "HCl"], "exp": "鉄は銅よりイオンになりやすいので、銅と入れかわります。"}
]

var current_index := 0
var score := 0
var slot_values: Array = ["", ""]
var selected_slot := 0
var counted := false
var counted_list: Array = []  # ★v34追加★ 得点済みの問題
var revealed_list: Array = []  # ★v34追加★ 解答を見た問題
var revealed := false
var judge_state := ""

var slot_buttons: Array = []
var _showing_result := false  # ★v27追加★
var feedback_label: Label


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)  # ★v27変更★ 大きさは _update_layout で管理
	_update_layout()
	_build_question()


# ★v27追加★ 画面が小さいときは全体を縮めて収める
func _update_layout() -> void:
	var vp := get_viewport().get_visible_rect().size
	var s := minf(1.0, minf(vp.x / 880.0, vp.y / 780.0))
	s = maxf(s, 0.05)
	scale = Vector2.ONE * s
	size = vp / s


# ★v27追加★ 画面サイズが変わったら作り直す（答えの入力は残る）
func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_update_layout()
		if _showing_result:
			_build_result()
		else:
			_build_question()


func _clear_page() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	slot_buttons.clear()


func _build_question() -> void:
	_showing_result = false
	_clear_page()
	slot_values = ["", ""]
	selected_slot = 0
	_ensure_state()
	counted = counted_list[current_index]
	revealed = revealed_list[current_index]
	judge_state = ""

	var data: Dictionary = QUESTIONS[current_index]
	var screen_size := size  # ★v27変更★

	var bg := ColorRect.new()
	bg.color = Color("#f4f7fc")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	var title := _make_label("問題演習：原子・化学反応式問題", 28, BLUE)
	title.position = Vector2(0, 22)
	title.size = Vector2(screen_size.x, 46)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	var progress := _make_label("第 %d 問 / %d 問" % [current_index + 1, QUESTIONS.size()], 16, SUB_COLOR)
	progress.position = Vector2(screen_size.x - 190, 34)
	progress.size = Vector2(160, 30)
	progress.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(progress)

	var card_w: float = minf(1020.0, screen_size.x - 60.0)
	var card_x := (screen_size.x - card_w) / 2.0
	var card_y := 84.0
	var card_h := 396.0

	var card := Panel.new()
	card.position = Vector2(card_x, card_y)
	card.size = Vector2(card_w, card_h)
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color.WHITE
	card_style.set_corner_radius_all(30)
	card_style.set_border_width_all(2)
	card_style.border_color = BORDER
	card.add_theme_stylebox_override("panel", card_style)
	add_child(card)

	var q_label := _make_label(str(data["q"]), 21, TEXT_COLOR)
	q_label.position = Vector2(card_x + 40, card_y + 26)
	q_label.size = Vector2(card_w - 80, 108)
	q_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	q_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	add_child(q_label)

	var slot_w := 172.0
	var slot_h := 118.0
	var sign_w := 56.0
	var product_w := 300.0
	var row_w := slot_w * 2.0 + sign_w * 2.0 + product_w
	var row_x := (screen_size.x - row_w) / 2.0
	var row_y := card_y + 168.0

	for i in 2:
		var slot := _make_slot(Vector2(row_x + i * (slot_w + sign_w), row_y), Vector2(slot_w, slot_h))
		slot.pressed.connect(_on_slot_pressed.bind(i))
		add_child(slot)
		slot_buttons.append(slot)

	var plus_label := _make_label("+", 44, TEXT_COLOR)
	plus_label.position = Vector2(row_x + slot_w, row_y + 30)
	plus_label.size = Vector2(sign_w, 60)
	plus_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(plus_label)

	var eq_label := _make_label("=", 44, TEXT_COLOR)
	eq_label.position = Vector2(row_x + slot_w * 2.0 + sign_w, row_y + 30)
	eq_label.size = Vector2(sign_w, 60)
	eq_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(eq_label)

	var product_label := _make_label(str(data["product"]), 30, TEXT_COLOR)
	product_label.position = Vector2(row_x + slot_w * 2.0 + sign_w * 2.0 + 8.0, row_y + 38)
	product_label.size = Vector2(product_w - 8.0, 50)
	add_child(product_label)

	feedback_label = _make_label("", 19, TEXT_COLOR)
	feedback_label.position = Vector2(card_x + 40, card_y + card_h - 62)
	feedback_label.size = Vector2(card_w - 80, 52)
	feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	feedback_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(feedback_label)

	var list_y := card_y + card_h + 16.0
	var list_h := 108.0
	var list_panel := Panel.new()
	list_panel.position = Vector2(card_x, list_y)
	list_panel.size = Vector2(card_w, list_h)
	var list_style := StyleBoxFlat.new()
	list_style.bg_color = Color.WHITE
	list_style.set_corner_radius_all(16)
	list_style.set_border_width_all(2)
	list_style.border_color = BORDER
	list_panel.add_theme_stylebox_override("panel", list_style)
	add_child(list_panel)

	var list_title := _make_label("原子一覧（タップすると、選んでいる箱に入ります）", 15, SUB_COLOR)
	list_title.position = Vector2(card_x + 22, list_y + 8)
	list_title.size = Vector2(card_w - 44, 24)
	add_child(list_title)

	var choices: Array = (data["choices"] as Array).duplicate()
	choices.shuffle()
	var chip_gap := 10.0
	var chip_w: float = minf(132.0, (card_w - 44.0 - chip_gap * float(choices.size() - 1)) / float(choices.size()))
	var chips_total := chip_w * float(choices.size()) + chip_gap * float(choices.size() - 1)
	var chip_x := card_x + (card_w - chips_total) / 2.0
	for i in choices.size():
		var chip := _make_btn(str(choices[i]), Vector2(chip_x + i * (chip_w + chip_gap), list_y + 42), Vector2(chip_w, 52), Color("#eaf1fb"), TEXT_COLOR, 20)
		chip.pressed.connect(_on_chip_pressed.bind(str(choices[i])))
		add_child(chip)

	var btn_y := list_y + list_h + 16.0
	var btn_w := 160.0  # ★v34変更★ 5ボタン並べるため少し細く
	var btn_gap := 16.0
	var btns_total := btn_w * 5.0 + btn_gap * 4.0
	var btn_x := (screen_size.x - btns_total) / 2.0

	# ★v34変更★ 「ホームへ」= 問題を選ぶ画面に戻る
	var home_btn := _make_btn("🏠 ホームへ", Vector2(btn_x, btn_y), Vector2(btn_w, 56), Color.WHITE, TEXT_COLOR, 16)
	home_btn.pressed.connect(func(): queue_free())
	add_child(home_btn)

	# ★v34追加★ 「前の問題へ」= 1つ前の問題に戻る (第1問では押せない)
	var prev_btn := _make_btn("⬅ 前の問題へ", Vector2(btn_x + (btn_w + btn_gap), btn_y), Vector2(btn_w, 56), Color.WHITE, TEXT_COLOR, 16)
	prev_btn.pressed.connect(_on_prev_pressed)
	prev_btn.disabled = current_index == 0
	add_child(prev_btn)

	var check_btn := _make_btn("チェック", Vector2(btn_x + (btn_w + btn_gap) * 2.0, btn_y), Vector2(btn_w, 56), BLUE, Color.WHITE, 16)
	check_btn.pressed.connect(_on_check_pressed)
	add_child(check_btn)

	var answer_btn := _make_btn("解答", Vector2(btn_x + (btn_w + btn_gap) * 3.0, btn_y), Vector2(btn_w, 56), Color.WHITE, TEXT_COLOR, 16)
	answer_btn.pressed.connect(_on_answer_pressed)
	add_child(answer_btn)

	var next_btn := _make_btn("次へ ➡", Vector2(btn_x + (btn_w + btn_gap) * 4.0, btn_y), Vector2(btn_w, 56), Color.WHITE, TEXT_COLOR, 16)
	next_btn.pressed.connect(_on_next_pressed)
	add_child(next_btn)

	_refresh_slots()


func _refresh_slots() -> void:
	for i in slot_buttons.size():
		var btn: Button = slot_buttons[i]
		var value := str(slot_values[i])
		if value == "":
			btn.text = "？"
			btn.add_theme_color_override("font_color", SUB_COLOR)
		else:
			btn.text = value
			btn.add_theme_color_override("font_color", TEXT_COLOR)
		var style := StyleBoxFlat.new()
		style.bg_color = Color.WHITE
		style.set_corner_radius_all(14)
		if judge_state == "ok":
			style.set_border_width_all(4)
			style.border_color = GREEN
		elif judge_state == "ng":
			style.set_border_width_all(4)
			style.border_color = RED
		elif i == selected_slot:
			style.set_border_width_all(4)
			style.border_color = BLUE
		else:
			style.set_border_width_all(2)
			style.border_color = Color("#94a3b8")
		btn.add_theme_stylebox_override("normal", style)
		btn.add_theme_stylebox_override("hover", style)
		btn.add_theme_stylebox_override("pressed", style)


func _on_slot_pressed(index: int) -> void:
	if str(slot_values[index]) != "":
		slot_values[index] = ""
		judge_state = ""
		_set_feedback("箱を空にしました。原子一覧から選んでね。", TEXT_COLOR)
	selected_slot = index
	_refresh_slots()


func _on_chip_pressed(value: String) -> void:
	var other := 1 - selected_slot
	if str(slot_values[other]) == value:
		_set_feedback("同じものは2つの箱に入らないよ。もう一方を選んでね。", RED)
		return
	slot_values[selected_slot] = value
	judge_state = ""
	if str(slot_values[other]) == "":
		selected_slot = other
	_set_feedback("", TEXT_COLOR)
	_refresh_slots()


func _on_check_pressed() -> void:
	if str(slot_values[0]) == "" or str(slot_values[1]) == "":
		_set_feedback("箱を全部うめてからチェックしてね。", RED)
		return
	var data: Dictionary = QUESTIONS[current_index]
	var pair: Array = data["pair"]
	var mine: Array = [str(slot_values[0]), str(slot_values[1])]
	var correct_vals: Array = [str(pair[0]), str(pair[1])]
	mine.sort()
	correct_vals.sort()
	if mine == correct_vals:
		judge_state = "ok"
		if not counted and not revealed:
			score += 1
			counted = true
			counted_list[current_index] = true  # ★v34追加★ 前の問題に戻っても二重に数えない
		_set_feedback("⭕ 正解！ " + str(data["exp"]), GREEN)
	else:
		judge_state = "ng"
		_set_feedback("❌ ちがうみたい。もう一度考えてみよう。", RED)
	_refresh_slots()


func _on_answer_pressed() -> void:
	var data: Dictionary = QUESTIONS[current_index]
	var pair: Array = data["pair"]
	slot_values[0] = str(pair[0])
	slot_values[1] = str(pair[1])
	revealed = true
	revealed_list[current_index] = true  # ★v34追加★
	judge_state = "ok"
	_set_feedback("解答： " + str(data["exp"]), BLUE)
	_refresh_slots()


# ★v34追加★ 1つ前の問題に戻る
func _on_prev_pressed() -> void:
	if current_index > 0:
		current_index -= 1
		_build_question()


# ★v34追加★ 問題ごとの状態リストを用意する
func _ensure_state() -> void:
	if counted_list.size() != QUESTIONS.size():
		counted_list.clear()
		revealed_list.clear()
		for i in QUESTIONS.size():
			counted_list.append(false)
			revealed_list.append(false)


func _on_next_pressed() -> void:
	if current_index + 1 >= QUESTIONS.size():
		_build_result()
	else:
		current_index += 1
		_build_question()


func _build_result() -> void:
	_showing_result = true
	_clear_page()
	var screen_size := size  # ★v27変更★

	var bg := ColorRect.new()
	bg.color = Color("#f4f7fc")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	var done_label := _make_label("おつかれさま！", 34, BLUE)
	done_label.position = Vector2(0, 180)
	done_label.size = Vector2(screen_size.x, 56)
	done_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(done_label)

	var score_label := _make_label("%d 問中 %d 問 正解" % [QUESTIONS.size(), score], 30, TEXT_COLOR)
	score_label.position = Vector2(0, 260)
	score_label.size = Vector2(screen_size.x, 50)
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(score_label)

	var msg := ""
	if score == QUESTIONS.size():
		msg = "全問正解！ 反応式マスターだね。"
	elif score >= QUESTIONS.size() / 2:
		msg = "よくできました。まちがえた問題は「解答」で確認してね。"
	else:
		msg = "元素図鑑で復習してから、もう一度挑戦してみよう。"
	var msg_label := _make_label(msg, 19, SUB_COLOR)
	msg_label.position = Vector2(0, 330)
	msg_label.size = Vector2(screen_size.x, 40)
	msg_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(msg_label)

	var back_btn := _make_btn("🏠 ホームへ戻る", Vector2((screen_size.x - 220.0) / 2.0, 420), Vector2(220, 58), BLUE, Color.WHITE, 19)
	back_btn.pressed.connect(func(): queue_free())
	add_child(back_btn)


func _set_feedback(text_value: String, color: Color) -> void:
	if feedback_label != null:
		feedback_label.text = text_value
		feedback_label.add_theme_color_override("font_color", color)


func _make_label(text_value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text_value
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label


func _make_slot(pos: Vector2, slot_size: Vector2) -> Button:
	var btn := Button.new()
	btn.position = pos
	btn.size = slot_size
	btn.custom_minimum_size = slot_size
	btn.add_theme_font_size_override("font_size", 32)
	return btn


func _make_btn(text_value: String, pos: Vector2, btn_size: Vector2, bg_color: Color, font_color: Color, font_size: int) -> Button:
	var btn := Button.new()
	btn.text = text_value
	btn.position = pos
	btn.size = btn_size
	btn.custom_minimum_size = btn_size
	btn.add_theme_font_size_override("font_size", font_size)
	btn.add_theme_color_override("font_color", font_color)
	btn.add_theme_color_override("font_hover_color", font_color)
	btn.add_theme_color_override("font_pressed_color", font_color)
	btn.add_theme_color_override("font_focus_color", font_color)
	btn.add_theme_color_override("font_disabled_color", font_color)
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.set_corner_radius_all(14)
	style.set_border_width_all(2)
	style.border_color = BORDER
	var hover := style.duplicate() as StyleBoxFlat
	hover.bg_color = bg_color.lightened(0.06)
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", style)
	return btn
