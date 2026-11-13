extends Control

# Simulation LAB - メイン画面
# Godot 4.x
# 新規登録・ログイン画面と連携したメインスクリプト

const SIMULATION_SCENE: PackedScene = preload("res://node_2d.tscn")
const PRACTICE_SCRIPT = preload("res://scripts/practice_page.gd")
const AUTH_SCRIPT = preload("res://scripts/user_auth.gd")
# ★v10追加★ 練習問題に挑戦する から開く「問題を選ぶ画面」
const UNIT_SELECT_SCRIPT = preload("res://scripts/unit_select_page.gd")
# ★v21追加★ 教科書ページ
const TEXTBOOK_SCRIPT = preload("res://scripts/textbook_page.gd")

const COLORS := {
	"background": Color("#E0F2FE"),
	"blue": Color("#2563EB"),
	"sky": Color("#7DD3FC"),
	"cyan": Color("#CFFAFE"),
	"purple": Color("#EDE9FE"),
	"white": Color("#FFFFFF"),
	"text": Color("#075985"),
	"subtext": Color("#64748B")
}

var menu_root: Control
var simulation_page: Control
var practice_page: Control
var textbook_page: Control
var encyclopedia_page: Control  # ★v42追加★
var auth_page: Control
var about_panel: Panel
var about_button: Button
var logged_in_user_name: String = ""
var user_status_label: Label
var _menu_built_size := Vector2.ZERO


# =====================================
# 起動処理
# =====================================

func _ready() -> void:
	# ★v18追加★ 起動したら全画面にする
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	# 先にメインメニューを作成
	_build_menu()
	# 起動直後はメニューを隠す
	menu_root.hide()
	# 新規登録・ログイン画面を表示
	_open_auth()


# ★v27追加★ 画面サイズが変わったらメニューを作り直す
func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED and is_instance_valid(menu_root):
		var now_size := get_viewport().get_visible_rect().size
		if now_size.distance_to(_menu_built_size) > 4.0:
			var was_visible := menu_root.visible
			menu_root.queue_free()
			about_panel = null
			_build_menu()
			menu_root.visible = was_visible
			if logged_in_user_name != "":
				set_logged_in_user(logged_in_user_name)


# =====================================
# 新規登録・ログイン画面
# =====================================

func _open_auth() -> void:
	auth_page = Control.new()
	auth_page.set_script(AUTH_SCRIPT)
	auth_page.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(auth_page)
	# 認証画面にこのメイン画面を渡す
	auth_page.call("setup", self)


# =====================================
# 認証完了後にメニューへ移動
# =====================================

func show_menu_after_auth() -> void:
	# ログイン画面を削除する
	if is_instance_valid(auth_page):
		auth_page.queue_free()
		auth_page = null
	# メインメニューが存在しない場合は作成
	if not is_instance_valid(menu_root):
		_build_menu()
	# メインメニューを表示
	menu_root.show()


# =====================================
# ログインユーザー情報の設定
# =====================================

func set_logged_in_user(user_name: String) -> void:
	logged_in_user_name = user_name
	if is_instance_valid(user_status_label):
		user_status_label.text = "👤 ログイン中\n" + logged_in_user_name


# ---------------------------------
# タイトル画面
# ---------------------------------

func _build_menu() -> void:
	menu_root = Control.new()
	menu_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(menu_root)
	# 基準となる画面サイズを取得
	var screen_size = get_viewport().get_visible_rect().size
	var base_width = screen_size.x
	var base_height = screen_size.y
	_menu_built_size = screen_size
	# 背景
	var bg := ColorRect.new()
	bg.color = COLORS["background"]
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_root.add_child(bg)
	# 背景の装飾
	_add_bubbles()
	# 上部の小さなロゴ（5% ➔ 3% へ少し上へ）
	var logo := Label.new()
	logo.text = "🧪 SCIENCE EDUCATION GAME"
	logo.position = Vector2(0, base_height * 0.03)
	logo.size = Vector2(base_width, 30)
	logo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	logo.add_theme_font_size_override("font_size", 15)
	logo.add_theme_color_override("font_color", COLORS["blue"])
	menu_root.add_child(logo)
	# ログイン中のユーザー表示
	user_status_label = Label.new()
	user_status_label.text = "👤 ログイン中\n" + logged_in_user_name
	user_status_label.position = Vector2(base_width - 260, 15)
	user_status_label.size = Vector2(240, 55)
	user_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	user_status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	user_status_label.add_theme_font_size_override("font_size", 15)
	user_status_label.add_theme_color_override("font_color", COLORS["blue"])
	user_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	menu_root.add_child(user_status_label)
	# ★v18変更★ ログアウトボタンは右上に移動
	var logout_top_btn := _make_button(
		"🚪 ログアウト",
		Vector2(base_width - 170, 78),
		Vector2(140, 42),
		COLORS["white"],
		COLORS["text"]
	)
	logout_top_btn.add_theme_font_size_override("font_size", 14)
	logout_top_btn.pressed.connect(_logout)
	menu_root.add_child(logout_top_btn)
	# タイトル（11% ➔ 8% へ上へずらす）
	var title := Label.new()
	title.text = "Simulation LAB"
	title.position = Vector2(0, base_height * 0.08)
	title.size = Vector2(base_width, 85)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 55 if base_width >= 700.0 else 38)  # ★v27変更★ 狭い画面では小さく
	title.add_theme_color_override("font_color", COLORS["blue"])
	menu_root.add_child(title)
	# サブタイトル（22% ➔ 18% へ上へずらす）
	var subtitle := Label.new()
	subtitle.text = "原子を組み合わせて、科学のふしぎを発見しよう！"
	subtitle.position = Vector2(0, base_height * 0.18)
	subtitle.size = Vector2(base_width, 35)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 19)
	subtitle.add_theme_color_override("font_color", COLORS["text"])
	menu_root.add_child(subtitle)
	# 原子のイメージ（画面中央40% ➔ 33% へ引き上げる）
	_add_atom_decoration(Vector2(base_width / 2.0, base_height * 0.40))
	# 説明文
	var description := Label.new()
	description.text = "自分だけの実験室で、原子と分子の世界を体験しよう。"
	description.position = Vector2(0, base_height * 0.55)
	description.size = Vector2(base_width, 30)
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	description.add_theme_font_size_override("font_size", 16)
	description.add_theme_color_override("font_color", COLORS["subtext"])
	menu_root.add_child(description)
	# --- 🛠️ ボタン配置設定（★v27変更★ 画面幅に合わせて列数を変える）---
	var gap_x = 25.0 # ボタン同士の横の隙間
	var gap_y = 20.0 # ボタン同士の縦の隙間
	var cols := 3
	if base_width < 700.0:
		cols = 2
	var btn_w := 260.0
	var btn_h := 55.0
	if cols == 2:
		btn_w = (base_width - 32.0 - gap_x) / 2.0
	var total_grid_w = (btn_w * cols) + (gap_x * (cols - 1))
	var start_x = (base_width - total_grid_w) / 2.0
	var start_y = base_height * 0.68
	if cols == 2:
		start_y = base_height * 0.60
	# ボタンの並び（文字・背景色・文字色・文字サイズ・押したときの関数名）
	var menu_items := [
		["🧪 実験をはじめる", COLORS["blue"], Color.WHITE, 18, "_start_simulation"],
		["📝 練習問題に挑戦する", COLORS["white"], COLORS["text"], 16, "_open_practice"],
		["📖 元素図鑑", COLORS["white"], COLORS["text"], 16, "_open_encyclopedia"],
		["👤 マイページ", COLORS["white"], COLORS["text"], 16, "_open_mypage"],
		["📖 遊び方・アプリについて", COLORS["white"], COLORS["text"], 15, "_show_about"],
		["📖   教科書", COLORS["white"], COLORS["text"], 16, "_open_textbook"],
	]
	for i in range(menu_items.size()):
		var item: Array = menu_items[i]
		var bx: float = start_x + (i % cols) * (btn_w + gap_x)
		var by: float = start_y + (i / cols) * (btn_h + gap_y)
		var btn := _make_button(item[0], Vector2(bx, by), Vector2(btn_w, btn_h), item[1], item[2])
		btn.add_theme_font_size_override("font_size", item[3])
		btn.pressed.connect(Callable(self, item[4]))
		if item[4] == "_show_about":
			about_button = btn
		menu_root.add_child(btn)
	# フッター
	var footer:= Label.new()
	footer.text = "LEARN • EXPERIMENT • DISCOVER"
	footer.position = Vector2(0, base_height - 40)
	footer.size = Vector2(base_width, 25)
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	footer.add_theme_font_size_override("font_size", 12)
	footer.add_theme_color_override("font_color", COLORS["subtext"])
	menu_root.add_child(footer)


# ---------------------------------
# ボタンデザイン
# ---------------------------------

func _make_button(
	button_text: String,
	pos: Vector2,
	button_size: Vector2,
	bg_color: Color,
	font_color: Color = Color("#FFFFFF")
) -> Button:
	var button := Button.new()
	button.text = button_text
	button.position = pos
	button.size = button_size
	button.add_theme_font_size_override("font_size", 17)
	button.add_theme_color_override("font_color", font_color)
	button.add_theme_color_override("font_hover_color", font_color)
	var normal := StyleBoxFlat.new()
	normal.bg_color = bg_color
	normal.set_corner_radius_all(18)
	normal.content_margin_left = 12
	normal.content_margin_right = 12
	normal.shadow_color = Color(0.1, 0.3, 0.5, 0.12)
	normal.shadow_size = 5
	normal.shadow_offset = Vector2(0, 3)
	var hover = normal.duplicate()
	hover.bg_color = bg_color.lightened(0.12)
	var pressed = normal.duplicate()
	pressed.bg_color = bg_color.darkened(0.1)
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	return button


# ---------------------------------
# 原子の装飾
# ---------------------------------

func _add_atom_decoration(center: Vector2) -> void:
	var colors := [
		Color("#38BDF8"),
		Color("#A78BFA"),
		Color("#FCA5A5"),
		Color("#FDE68A")
	]
	var positions := [
		Vector2(-147, 0),
		Vector2(0, -91),
		Vector2(147, 0),
		Vector2(0, 91)
	]
	# 結合線
	for offset in positions:
		if offset != Vector2.ZERO:
			var line := Line2D.new()
			line.add_point(center + Vector2.ZERO)
			line.add_point(center + offset)
			line.width = 7
			line.default_color = Color("#7DD3FC")
			line.z_index = -1
			menu_root.add_child(line)
	# 中央の原子
	_make_atom_circle(center, 67, Color("#2563EB"), "ATOM", 21)
	# 周囲の原子
	for i in range(positions.size()):
		var atom_position = center + positions[i]
		_make_atom_circle(
			atom_position,
			41,
			colors[i],
			["H", "O", "C", "N"][i],
			21
		)


func _make_atom_circle(
	pos: Vector2,
	radius: float,
	color: Color,
	symbol: String,
	font_size: int = 15  # ★v41追加★
) -> void:
	var circle := Panel.new()
	circle.position = pos - Vector2(radius, radius)
	circle.size = Vector2(radius * 2, radius * 2)
	circle.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(radius)
	style.border_width_left = 3.0
	style.border_width_right = 3.0
	style.border_width_top = 3.0
	style.border_width_bottom = 3.0
	style.border_color = Color("#FFFFFF")
	style.shadow_color = Color(0.1, 0.3, 0.5, 0.15)
	style.shadow_size = 6.0
	circle.add_theme_stylebox_override("panel", style)
	menu_root.add_child(circle)
	var label := Label.new()
	label.text = symbol
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color("#FFFFFF"))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	circle.add_child(label)
	# ゆっくり浮遊するアニメーション
	var tween := create_tween().set_loops()
	tween.tween_property(
		circle,
		"position:y",
		circle.position.y - 8,
		1.5
	).set_trans(Tween.TRANS_SINE)
	tween.tween_property(
		circle,
		"position:y",
		circle.position.y,
		1.5
	).set_trans(Tween.TRANS_SINE)


# ---------------------------------
# 背景の泡
# ---------------------------------

func _add_bubbles() -> void:
	var bubble_positions := [
		Vector2(100, 180),
		Vector2(220, 350),
		Vector2(950, 180),
		Vector2(1050, 350),
		Vector2(150, 530),
		Vector2(1000, 540)
	]
	var bubble_colors := [
		Color("#BAE6FD"),
		Color("#CFFAFE"),
		Color("#DDD6FE")
	]
	for i in range(bubble_positions.size()):
		var bubble := Panel.new()
		var bubble_size := 18 + (i % 3) * 12
		bubble.position = bubble_positions[i]
		bubble.size = Vector2(bubble_size, bubble_size)
		bubble.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var style := StyleBoxFlat.new()
		style.bg_color = bubble_colors[i % bubble_colors.size()]
		style.bg_color.a = 0.75
		style.set_corner_radius_all(30)
		bubble.add_theme_stylebox_override("panel", style)
		menu_root.add_child(bubble)
		var tween := create_tween().set_loops()
		tween.tween_property(
			bubble,
			"position:y",
			bubble.position.y - 18,
			2.0 + i * 0.2
		).set_trans(Tween.TRANS_SINE)
		tween.tween_property(
			bubble,
			"position:y",
			bubble.position.y,
			2.0 + i * 0.2
		).set_trans(Tween.TRANS_SINE)

# ---------------------------------
# 実験画面へ移動
# ---------------------------------

func _start_simulation() -> void:
	if is_instance_valid(simulation_page):
		return
	menu_root.hide()
	simulation_page = SIMULATION_SCENE.instantiate() as Control
	if simulation_page == null:
		push_error("実験画面のルートノードがControlではありません。")
		menu_root.show()
		return
	simulation_page.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(simulation_page)


# ---------------------------------
# メニューへ戻る
# ---------------------------------

func show_menu_from_simulation() -> void:
	if is_instance_valid(simulation_page):
		simulation_page.queue_free()
	simulation_page = null
	menu_root.show()


# ---------------------------------
# 練習問題画面へ移動
# ---------------------------------

# ★v10変更★ 「練習問題に挑戦する」で、問題を選ぶ画面
# (unit_select_page.gd) を開くように変更。
# 単元クイズ (全50問)・化学反応式の問題 (全10問)・元素図鑑が
# この画面から選べる。
# 元の作りでは practice_page.gd が開いていた。
# 選択画面は全画面を覆うので、メニューは隠さない
# (選択画面の「戻る」でそのままメニューに戻れる)。
func _open_practice() -> void:
	if is_instance_valid(practice_page):
		return
	practice_page = Control.new()
	practice_page.set_script(UNIT_SELECT_SCRIPT)
	practice_page.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	# 選択画面にこのメイン画面を渡す
	practice_page.set("main_script", self)
	add_child(practice_page)


# ---------------------------------
# 教科書画面へ移動
# ---------------------------------

# ★v21追加★ メニューの「教科書」ボタンで教科書ページを開く
func _open_textbook() -> void:
	if is_instance_valid(textbook_page):
		# ★v33追加★ 隠れている教科書ページがあれば、同じページを再表示する
		textbook_page.show()
		move_child(textbook_page, get_child_count() - 1)
		return
	textbook_page = Control.new()
	textbook_page.set_script(TEXTBOOK_SCRIPT)
	textbook_page.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	textbook_page.set("main_script", self)
	add_child(textbook_page)


# ★v21追加★ 教科書ページから、原子を指定して実験画面を開く
func open_simulation_with_preset(symbols: Array, source: String = "textbook") -> void:
	_start_simulation()
	if is_instance_valid(simulation_page) and simulation_page.has_method("apply_preset"):
		simulation_page.call("apply_preset", symbols)
	# ★v42変更★ どこから来たかを実験画面に知らせる（戻るボタンのため）
	if is_instance_valid(simulation_page) and simulation_page.has_method("set_return_target"):
		simulation_page.call("set_return_target", source)


# ★v33追加★ 実験画面から、見ていた教科書ページに戻る
func back_to_textbook_from_simulation() -> void:
	if is_instance_valid(simulation_page):
		simulation_page.queue_free()
	simulation_page = null
	menu_root.show()
	if is_instance_valid(textbook_page):
		textbook_page.show()
		move_child(textbook_page, get_child_count() - 1)


# ★v42追加★ 実験画面から、見ていた元素図鑑に戻る
func back_to_encyclopedia_from_simulation() -> void:
	if is_instance_valid(simulation_page):
		simulation_page.queue_free()
	simulation_page = null
	menu_root.show()
	if is_instance_valid(encyclopedia_page):
		encyclopedia_page.show()
		if encyclopedia_page.get_parent() == self:
			move_child(encyclopedia_page, get_child_count() - 1)


# ---------------------------------
# 練習問題からメニューへ戻る
# ---------------------------------

func show_menu_from_practice() -> void:
	if is_instance_valid(practice_page):
		practice_page.queue_free()
	practice_page = null
	menu_root.show()


# ---------------------------------
# アプリの説明
# ---------------------------------

func _show_about() -> void:
	if is_instance_valid(about_panel):
		about_panel.queue_free()
	# 基準となる画面サイズを取得
	var screen_size = get_viewport().get_visible_rect().size
	var base_width = screen_size.x
	var base_height = screen_size.y
	# ポップアップ全体のサイズと位置を画面に合わせて計算
	var panel_w = 550.0
	var panel_h = 360.0
	var panel_x = (base_width - panel_w) / 2.0
	var panel_y = (base_height - panel_h) / 2.0
	about_panel = Panel.new()
	about_panel.position = Vector2(panel_x, panel_y)
	about_panel.size = Vector2(panel_w, panel_h)
	about_panel.z_index = 10
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#FFFFFF")
	style.set_corner_radius_all(20)
	# 枠線を少し太くして目立たせる（お好みで調整してください）
	style.border_width_left = 3
	style.border_width_top = 3
	style.border_width_right = 3
	style.border_width_bottom = 3
	style.border_color = COLORS["blue"]
	about_panel.add_theme_stylebox_override("panel", style)
	menu_root.add_child(about_panel)
	# --- ここから下に続く、テキスト(Label)や閉じるボタン(Button)の生成処理 ---
	# タイトル
	var popup_title := Label.new()
	popup_title.text = "Simulation LAB について"
	popup_title.position = Vector2(0, 25)
	popup_title.size = Vector2(panel_w, 40)
	popup_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	popup_title.add_theme_font_size_override("font_size", 22)
	popup_title.add_theme_color_override("font_color", COLORS["blue"])
	about_panel.add_child(popup_title)
	# メイン説明文（重ならないようにY座標を少し下げ、高さを確保）
	var popup_text := Label.new()
	popup_text.text = "このアプリでは、原子を自由に配置して\n組み合わせを調べることができます。\n\n原子の種類や個数を変えながら、\n物質の構成について楽しく学びましょう！"
	popup_text.position = Vector2(40, 90) # 左に40ピクセルの余白
	popup_text.size = Vector2(panel_w - 80, 160) # 左右に余白を持たせる
	popup_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	popup_text.add_theme_font_size_override("font_size", 16)
	popup_text.add_theme_color_override("font_color", COLORS["text"])
	about_panel.add_child(popup_text)
	# 閉じるボタン（パネルの一番下付近に配置）
	var close_btn_w = 180
	var close_btn_h = 45
	var close_button := _make_button(
		"閉じる",
		Vector2((panel_w - close_btn_w) / 2.0, panel_h - close_btn_h - 25), # 下から25ピクセル上
		Vector2(close_btn_w, close_btn_h),
		COLORS["blue"]
	)
	close_button.pressed.connect(func(): about_panel.queue_free())
	about_panel.add_child(close_button)


# 図鑑画面を開く関数（main.gdの一番下などに追加）
func _open_encyclopedia() -> void:
	# ★v42追加★ 隠れている図鑑があれば、同じページを再表示する
	if is_instance_valid(encyclopedia_page):
		encyclopedia_page.show()
		# ★v48追加★ メニューから開き直したときは、元素の一覧から始める
		# （研究室から戻るときは、見ていた元素のページのまま）
		if encyclopedia_page.has_method("show_list"):
			encyclopedia_page.call("show_list")
		if encyclopedia_page.get_parent() == self:
			move_child(encyclopedia_page, get_child_count() - 1)
		return
	# 新しい図鑑スクリプトを読み込んでインスタンス化する
	var encyclopedia_scene = preload("res://scripts/encyclopedia.gd").new()
	# main.gdの共通関数を使えるように自分を渡す
	encyclopedia_scene.main_script = self
	encyclopedia_page = encyclopedia_scene
	# 画面に表示する
	add_child(encyclopedia_scene)


# 新しいマイページ画面を開く関数（main.gdの一番下に追加）
func _open_practice_page() -> void:
	var practice_scene = preload("res://scripts/practice_page.gd").new()
	practice_scene.main_menu = self
	add_child(practice_scene)


# マイページ画面（mypage.gd）を開くための新しい関数（main.gdの一番下に追加）
func _open_mypage() -> void:
	var mypage_scene = preload("res://scripts/mypage.gd").new()
	mypage_scene.main_script = self # 相手が「main_menu」という変数名で待っている場合
	add_child(mypage_scene)


# ログアウトして最初の認証画面に戻る関数（main.gdの一番下に追加）
func _logout() -> void:
	# ユーザー情報を消去
	logged_in_user_name = ""
	# 表示中の画面を削除
	if is_instance_valid(menu_root):
		menu_root.queue_free()
	menu_root = null
	user_status_label = null
	# ログイン画面に戻る
	_open_auth()
