extends Control

# Simulation LAB - 新規登録・ログイン画面
# Godot 4.x

const BLUE := Color("#2563EB")
const LIGHT_BLUE := Color("#E0F2FE")
const TEXT_COLOR := Color("#075985")
const SUB_COLOR := Color("#64748B")
const WHITE := Color("#FFFFFF")
const SUCCESS_COLOR := Color("#059669")

var main_menu: Node
var page_root: Control
# ★v27追加★ 画面幅に合わせるための変数
var page_w := 550.0
var field_w := 350.0
var field_x := 100.0
var _page := "auth"


# =====================================
# 初期設定
# =====================================

func setup(menu: Node) -> void:
	main_menu = menu


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_show_auth_page()


# ★v27追加★ 画面サイズが変わったら、今のページを作り直す
func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		match _page:
			"auth":
				_show_auth_page()
			"register":
				_show_register_page()
			"login":
				_show_login_page()


# =====================================
# 共通画面作成
# =====================================

func _clear_page(content_height: float = 720.0) -> void:

	for child in get_children():
		child.queue_free()

	# 背景
	var background := ColorRect.new()
	background.color = LIGHT_BLUE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	# 余白
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	margin.add_theme_constant_override("margin_left", 30)
	margin.add_theme_constant_override("margin_right", 30)
	margin.add_theme_constant_override("margin_top", 25)
	margin.add_theme_constant_override("margin_bottom", 25)

	add_child(margin)

	# スクロール
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(scroll)

	# 中央配置用コンテナ
	var center := CenterContainer.new()
	center.custom_minimum_size = Vector2(0, content_height)
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(center)

	# 各部品を自由に配置する領域
	# ★v27追加★ 画面幅に合わせて列の幅を決める
	var vp := get_viewport().get_visible_rect().size
	page_w = minf(550.0, maxf(300.0, vp.x - 24.0))
	field_w = minf(350.0, page_w - 32.0)
	field_x = (page_w - field_w) / 2.0
	page_root = Control.new()
	page_root.custom_minimum_size = Vector2(page_w, content_height)
	center.add_child(page_root)


# =====================================
# ラベル作成
# =====================================

func _make_label(
	value: String,
	font_size: int,
	color: Color = TEXT_COLOR
) -> Label:

	var label := Label.new()

	label.text = value
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)

	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	return label


# =====================================
# ボタン作成
# =====================================

func _make_button(
	value: String,
	callback: Callable,
	color: Color = BLUE,
	font_color: Color = WHITE,
	button_width: float = 350,
	button_height: float = 55
) -> Button:

	var button := Button.new()

	button.text = value

	# ボタンの大きさ
	button.custom_minimum_size = Vector2(button_width, button_height)

	button.add_theme_font_size_override("font_size", 17)

	button.add_theme_color_override("font_color", font_color)

	var style := StyleBoxFlat.new()

	style.bg_color = color
	style.set_corner_radius_all(14)

	style.content_margin_left = 12
	style.content_margin_right = 12

	var hover := style.duplicate()
	hover.bg_color = color.lightened(0.12)

	var pressed := style.duplicate()
	pressed.bg_color = color.darkened(0.12)

	button.add_theme_stylebox_override("normal", style)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)

	button.pressed.connect(callback)

	return button


# =====================================
# 入力欄作成
# =====================================

func _make_input(
	hint: String,
	is_password: bool = false,
	input_width: float = 350,
	input_height: float = 48
) -> LineEdit:

	var input := LineEdit.new()

	input.placeholder_text = hint

	input.custom_minimum_size = Vector2(input_width, input_height)

	input.add_theme_font_size_override("font_size", 16)

	input.secret = is_password

	input.clear_button_enabled = true

	input.add_theme_color_override("font_color", TEXT_COLOR)
	input.add_theme_color_override("font_placeholder_color", SUB_COLOR)
	input.add_theme_color_override("caret_color", BLUE)

	# 通常時のデザイン
	var style := StyleBoxFlat.new()

	style.bg_color = Color("#F8FAFC")
	style.set_corner_radius_all(10)
	style.set_border_width_all(2)
	style.border_color = Color("#94A3B8")

	style.content_margin_left = 14
	style.content_margin_right = 14

	# 入力中のデザイン
	var focus_style := style.duplicate()

	focus_style.bg_color = WHITE
	focus_style.set_border_width_all(3)
	focus_style.border_color = BLUE

	input.add_theme_stylebox_override("normal", style)
	input.add_theme_stylebox_override("focus", focus_style)

	return input


func _make_option_button(options: Array[String]) -> OptionButton:
	var option_button := OptionButton.new()
	option_button.custom_minimum_size = Vector2(field_w, 48)
	option_button.add_theme_font_size_override("font_size", 16)
	option_button.add_theme_color_override("font_color", TEXT_COLOR)

	var style := StyleBoxFlat.new()
	style.bg_color = Color("#F8FAFC")
	style.set_corner_radius_all(10)
	style.set_border_width_all(2)
	style.border_color = Color("#94A3B8")
	style.content_margin_left = 14
	style.content_margin_right = 14
	option_button.add_theme_stylebox_override("normal", style)
	option_button.add_theme_stylebox_override("hover", style)
	option_button.add_theme_stylebox_override("pressed", style)

	for option in options:
		option_button.add_item(option)

	return option_button


# =====================================
# 部品を指定位置に配置する関数
# =====================================

func _add_label_at(
	value: String,
	font_size: int,
	color: Color,
	x: float,
	y: float,
	width: float,
	height: float
) -> Label:

	var label := _make_label(value, font_size, color)

	label.position = Vector2(x, y)
	label.size = Vector2(width, height)

	page_root.add_child(label)

	return label


func _add_button_at(
	value: String,
	callback: Callable,
	x: float,
	y: float,
	width: float,
	height: float,
	color: Color = BLUE
) -> Button:

	var button := _make_button(
		value,
		callback,
		color,
		WHITE,
		width,
		height
	)

	button.position = Vector2(x, y)

	page_root.add_child(button)

	return button


# =====================================
# 戻るボタン
# =====================================

func _add_back_button(x: float, y: float) -> void:

	_add_button_at(
		"← 戻る",
		_show_auth_page,
		x,
		y,
		field_w,
		55,
		SUB_COLOR
	)


# =====================================
# 最初の画面
# =====================================

# =====================================
# 最初の画面（ログイン画面）
# =====================================

func _show_auth_page() -> void:
	_page = "auth"

	_clear_page()

	# ロゴ
	_add_label_at(
		"🧪",
		55,
		BLUE,
		0,
		10,
		page_w,
		70
	)

	# タイトル
	_add_label_at(
		"Simulation LAB",
		34,
		BLUE,
		0,
		85,
		page_w,
		60
	)

	# メールアドレス・ユーザー名
	_add_label_at(
		"メールアドレス / ユーザー名",
		15,
		TEXT_COLOR,
		40,
		180,
		field_w,
		25
	)

	var login_name := _make_input(
		"メールアドレス / ユーザー名",
		false,
		field_w,
		48
	)

	login_name.position = Vector2(field_x, 210)
	page_root.add_child(login_name)

	# パスワード
	_add_label_at(
		"パスワード",
		15,
		TEXT_COLOR,
		0,
		280,
		field_w,
		25
	)

	var password := _make_input(
		"パスワード",
		true,
		field_w,
		48
	)

	password.position = Vector2(field_x, 310)
	page_root.add_child(password)

	# ログインボタン
	_add_button_at(
		"ログイン",
		_finish_auth.bind("ログインしました！", login_name),
		field_x,
		410,
		field_w,
		48,
		Color("#0891B2")
	)

	# 右下の新規登録ボタン
	_add_button_at(
		"新規登録はこちら",
		_show_register_page,
		field_x + field_w - 120,
		490,
		120,
		35,
		BLUE
	)


# =====================================
# 新規登録画面
# =====================================

func _show_register_page() -> void:
	_page = "register"

	_clear_page(820)

	# タイトル
	_add_label_at(
		"新規登録",
		40,
		BLUE,
		0,
		30,
		page_w,
		45
	)

	# ユーザー名
	_add_label_at(
		"ユーザー名",
		15,
		TEXT_COLOR,
		field_x,
		120,
		field_w,
		25
	)

	var username := _make_input("ユーザー名", false, field_w, 48)
	username.position = Vector2(field_x, 150)
	page_root.add_child(username)

	# メールアドレス
	_add_label_at(
		"メールアドレス",
		15,
		TEXT_COLOR,
		field_x,
		210,
		field_w,
		25
	)

	var email := _make_input("メールアドレス", false, field_w, 48)
	email.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_EMAIL_ADDRESS
	email.position = Vector2(field_x, 240)
	page_root.add_child(email)

	# パスワード
	_add_label_at(
		"パスワード",
		15,
		TEXT_COLOR,
		field_x,
		300,
		field_w,
		25
	)

	var password := _make_input("パスワード", true, field_w, 48)
	password.position = Vector2(field_x, 330)
	page_root.add_child(password)

	# パスワード確認
	_add_label_at(
		"パスワード（確認）",
		15,
		TEXT_COLOR,
		field_x,
		390,
		field_w,
		25
	)

	var password_confirm := _make_input(
		"パスワード（確認）",
		true,
		field_w,
		48
	)

	password_confirm.position = Vector2(field_x, 420)
	page_root.add_child(password_confirm)

	# 年齢層
	_add_label_at(
		"年齢層",
		15,
		TEXT_COLOR,
		field_x,
		480,
		field_w,
		25
	)

	var age_group := _make_option_button([
		"選択してください",
		"小学生",
		"中学生",
		"高校生",
		"大学生・専門学生",
		"社会人",
		"その他"
	])
	age_group.position = Vector2(field_x, 510)
	page_root.add_child(age_group)

	# 所属団体
	_add_label_at(
		"所属団体",
		15,
		TEXT_COLOR,
		field_x,
		570,
		field_w,
		25
	)

	var organization := _make_option_button([
		"選択してください",
		"小学校",
		"中学校",
		"高等学校",
		"大学・専門学校",
		"塾・予備校",
		"その他"
	])
	organization.position = Vector2(field_x, 600)
	page_root.add_child(organization)

	# 登録ボタン
	_add_button_at(
		"登録する",
		_finish_auth.bind("新規登録が完了しました！", username),
		field_x,
		670,
		field_w,
		48
	)

	_add_back_button(field_x, 735)


# =====================================
# ログイン画面
# =====================================

func _show_login_page() -> void:
	_page = "login"

	_clear_page()

	# タイトル
	_add_label_at(
		"🧪 Simulation LAB",
		17,
		BLUE,
		0,
		70,
		page_w,
		35
	)

	_add_label_at(
		"ログイン",
		30,
		BLUE,
		0,
		110,
		page_w,
		45
	)

	_add_label_at(
		"登録したアカウントでログインします。",
		15,
		SUB_COLOR,
		0,
		155,
		page_w,
		30
	)

	# メールアドレス
	_add_label_at(
		"メールアドレス",
		15,
		TEXT_COLOR,
		field_x,
		230,
		field_w,
		25
	)

	var email := _make_input("メールアドレス", false, field_w, 48)
	email.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_EMAIL_ADDRESS
	email.position = Vector2(field_x, 260)
	page_root.add_child(email)

	# パスワード
	_add_label_at(
		"パスワード",
		15,
		TEXT_COLOR,
		field_x,
		325,
		field_w,
		25
	)

	var password := _make_input("パスワード", true, field_w, 48)
	password.position = Vector2(field_x, 355)
	page_root.add_child(password)

	# ログインボタン
	_add_button_at(
		"ログイン",
		_finish_auth.bind("ログインしました！", email),
		field_x,
		440,
		field_w,
		55,
		Color("#0891B2")
	)

	_add_back_button(field_x, 620)


# =====================================
# 仮のログイン・登録完了
# =====================================

func _finish_auth(message: String, user_name: LineEdit) -> void:
	_page = "done"

	# ★v19追加★ 名前を保存する（マイページの名前表示で使う）
	var file := FileAccess.open("user://current_user.txt", FileAccess.WRITE)
	if file != null:
		file.store_line(user_name.text)
		file.close()

	# メイン画面にユーザー名を渡す
	if is_instance_valid(main_menu):
		main_menu.call("set_logged_in_user", user_name.text)

	_clear_page()

	_add_label_at(
		"✅",
		60,
		SUCCESS_COLOR,
		0,
		200,
		page_w,
		80
	)

	_add_label_at(
		message,
		24,
		SUCCESS_COLOR,
		0,
		290,
		page_w,
		50
	)

	_add_label_at(
		"メインメニューへ移動します...",
		15,
		SUB_COLOR,
		0,
		field_w,
		page_w,
		35
	)

	await get_tree().create_timer(1.2).timeout

	if is_instance_valid(main_menu):
		main_menu.call("show_menu_after_auth")
