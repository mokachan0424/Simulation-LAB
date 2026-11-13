extends Control

const ELEMENT_DATA = {
	"H": {"name": "水素", "row": 1, "col": 1, "number": 1, "mass": "1.008", "group": "1族", "period": 1, "category": "非金属", "state": "気体", "desc": "宇宙で最も軽く、最も多く存在する元素です。", "prop": "・無色無臭の気体\n・火をつけると激しく燃えて水になる", "form": "2H₂ + O₂ ➔ 2H₂O", "use": "燃料電池やアンモニア合成に使われます。", "hazard": "可燃性が高く、空気中の混合気は爆発しやすいです。", "electron": "1s¹", "fact": "恒星の核融合で最も重要な元素の1つです。"},
	"Li": {"name": "リチウム", "row": 2, "col": 1, "number": 3, "mass": "6.94", "group": "1族", "period": 2, "category": "アルカリ金属", "state": "固体", "desc": "最も軽い金属で、スマートフォンのバッテリーなどに広く使われています。", "prop": "・ナイフで切れるほど柔らかい\n・水と激しく反応して水素を出す", "form": "2Li + 2H₂O ➔ 2LiOH + H₂", "use": "リチウムイオン電池の材料として重要です。", "hazard": "水と反応して炎や爆発の危険があります。", "electron": "[He] 2s¹", "fact": "軽さと高いエネルギー密度が特徴です。"},
	"Na": {"name": "ナトリウム", "row": 3, "col": 1, "number": 11, "mass": "22.99", "group": "1族", "period": 3, "category": "アルカリ金属", "state": "固体", "desc": "食塩の成分でもあり、非常に反応しやすい金属です。", "prop": "・水に入れると爆発的に反応して激しく燃える\n・炎色反応は黄色", "form": "2Na + 2H₂O ➔ 2NaOH + H₂", "use": "塩や化学工業、熱交換材に使われます。", "hazard": "水と激しく反応し、火災につながることがあります。", "electron": "[Ne] 3s¹", "fact": "ナトリウムランプは黄色い光を放ちます。"},
	"K": {"name": "カリウム", "row": 4, "col": 1, "number": 19, "mass": "39.10", "group": "1族", "period": 4, "category": "アルカリ金属", "state": "固体", "desc": "植物の肥料に必要な成分で、ナトリウムと似た性質を持ちます。", "prop": "・水と激しく反応し、紫色の炎を出して燃える\n・非常に柔らかい金属", "form": "2K + 2H₂O ➔ 2KOH + H₂", "use": "肥料や植物の生育に欠かせません。", "hazard": "強い反応性があり、取り扱いには注意が必要です。", "electron": "[Ar] 4s¹", "fact": "細胞の電気信号にも関わる重要な元素です。"},
	"Be": {"name": "ベリリウム", "row": 2, "col": 2, "number": 4, "mass": "9.01", "group": "2族", "period": 2, "category": "金属", "state": "固体", "desc": "軽くて強い金属で、宇宙機器や特殊合金に使われます。", "prop": "・極めて有毒\n・銅に混ぜると非常に強い合金になる", "form": "Be + 2HCl ➔ BeCl₂ + H₂", "use": "航空宇宙産業や軽量合金に用いられます。", "hazard": "粉じんや蒸気が有毒で、吸入すると危険です。", "electron": "[He] 2s²", "fact": "ベリリウムは非常に軽く、熱に強いです。"},
	"Mg": {"name": "マグネシウム", "row": 3, "col": 2, "number": 12, "mass": "24.31", "group": "2族", "period": 3, "category": "金属", "state": "固体", "desc": "軽くて丈夫な金属で、花火やノートパソコンの筐体に使われます。", "prop": "・火をつけると強烈な白い光を放って激しく燃える\n・実用金属の中で最も軽い", "form": "2Mg + O₂ ➔ 2MgO", "use": "合金、花火、医薬品などに用いられます。", "hazard": "燃焼時に強い光と熱を放ちます。", "electron": "[Ne] 3s²", "fact": "マグネシウムは生体内でも重要な役割を果たします。"},
	"Ca": {"name": "カルシウム", "row": 4, "col": 2, "number": 20, "mass": "40.08", "group": "2族", "period": 4, "category": "金属", "state": "固体", "desc": "骨や歯の主成分であり、地球の岩石にも多く含まれます。", "prop": "・水に入れると水素を発生しながらゆっくり溶ける\n・炎色反応は橙赤色", "form": "Ca + 2H₂O ➔ Ca(OH)₂ + H₂", "use": "骨の成分やセメント、石灰に使われます。", "hazard": "反応性があり、空気中では酸化しやすいです。", "electron": "[Ar] 4s²", "fact": "人体の筋肉収縮と神経伝達に関係しています。"},
	"B": {"name": "ホウ素", "row": 2, "col": 3, "number": 5, "mass": "10.81", "group": "13族", "period": 2, "category": "半金属", "state": "固体", "desc": "耐熱ガラスや植物の成長に不可欠な元素です。", "prop": "・非常に硬い結晶を作る\n・ゴキブリ退治の「ホウ酸ダンゴ」にも使われる", "form": "4B + 3O₂ ➔ 2B₂O₃", "use": "洗浄剤、耐熱ガラス、半導体材料に使われます。", "hazard": "粉じんは刺激性があります。", "electron": "[He] 2s²2p¹", "fact": "植物にとって欠かせない微量元素です。"},
	"Al": {"name": "アルミニウム", "row": 3, "col": 3, "number": 13, "mass": "26.98", "group": "13族", "period": 3, "category": "金属", "state": "固体", "desc": "アルミホイルや缶ジュースで身近に使われる軽い金属です。", "prop": "・電気や熱をよく通す\n・軽くて加工しやすく、リサイクルが簡単", "form": "4Al + 3O₂ ➔ 2Al₂O₃", "use": "容器、飛行機、電線、建築材料に使われます。", "hazard": "粉じんは火災の危険があり、切削時に注意が必要です。", "electron": "[Ne] 3s²3p¹", "fact": "表面に薄い酸化皮膜ができて腐食しにくいです。"},
	"C": {"name": "炭素", "row": 2, "col": 4, "number": 6, "mass": "12.01", "group": "14族", "period": 2, "category": "非金属", "state": "固体", "desc": "ダイヤモンドや黒鉛のように姿を変えられる、生命の土台となる元素です。", "prop": "・結びつき方で黒鉛（柔らかい）にもダイヤモンド（超硬い）にもなる\n・燃えると二酸化炭素になる", "form": "C + O₂ ➔ CO₂", "use": "燃料、黒鉛、ダイヤモンド、プラスチックの基礎です。", "hazard": "粉じんは可燃性で、過度な吸入は有害です。", "electron": "[He] 2s²2p²", "fact": "有機化合物の中心元素で、生命の基本構造を作ります。"},
	"Si": {"name": "ケイ素", "row": 3, "col": 4, "number": 14, "mass": "28.09", "group": "14族", "period": 3, "category": "半金属", "state": "固体", "desc": "地球の地殻に多く含まれ、半導体としてパソコンに使われます。", "prop": "・ガラスやシリコン製品の原料になる\n・金属のような光沢を持つ半導体", "form": "Si + O₂ ➔ SiO₂", "use": "半導体、ガラス、建材、太陽電池に使われます。", "hazard": "微細粉は呼吸器に刺激を与える可能性があります。", "electron": "[Ne] 3s²3p²", "fact": "半導体産業の中核材料で、スマホやコンピュータに欠かせません。"},
	"N": {"name": "窒素", "row": 2, "col": 5, "number": 7, "mass": "14.01", "group": "15族", "period": 2, "category": "非金属", "state": "気体", "desc": "空気の約78%を占める、地球上でとてもありふれた気体です。", "prop": "・非常に安定していて、他の物質と簡単には反応しない\n・液体窒素はマイナス196度で何でも凍らせる", "form": "N₂ + 3H₂ ➔ 2NH₃ (アンモニアの合成)", "use": "食品の保存、工業ガス、肥料の原料として使われます。", "hazard": "高濃度では窒息の危険があり、低温による凍傷の危険もあります。", "electron": "[He] 2s²2p³", "fact": "空気中の大部分を占め、生命活動にも深く関係しています。"},
	"P": {"name": "リン", "row": 3, "col": 5, "number": 15, "mass": "30.97", "group": "15族", "period": 3, "category": "非金属", "state": "固体", "desc": "DNAや骨の材料に必須の元素で、マッチの頭薬にも使われます。", "prop": "・空気中で自然に発火する種類（白リン）もあるため取り扱い注意\n・植物の肥料の3大成分の1つ", "form": "4P + 5O₂ ➔ 2P₂O₅", "use": "肥料、農薬、合成樹脂、マッチに利用されます。", "hazard": "白リンは高温・摩擦で自然発火しやすいです。", "electron": "[Ne] 3s²3p³", "fact": "ATPのような生命エネルギー分子に不可欠です。"},
	"O": {"name": "酸素", "row": 2, "col": 6, "number": 8, "mass": "16.00", "group": "16族", "period": 2, "category": "非金属", "state": "気体", "desc": "呼吸に不可欠で、地球の生物に特に大切な気体です。", "prop": "・空気中に約21%含まれる\n・他の物質が燃えるのを助ける働き（助燃性）がある", "form": "2H₂ + O₂ ➔ 2H₂O", "use": "呼吸、燃焼、医療、溶接に利用されます。", "hazard": "高濃度では燃焼を促進し、火災の危険が高まります。", "electron": "[He] 2s²2p⁴", "fact": "有機化合物の“燃えやすさ”を支える重要な元素です。"},
	"S": {"name": "硫黄", "row": 3, "col": 6, "number": 16, "mass": "32.06", "group": "16族", "period": 3, "category": "非金属", "state": "固体", "desc": "温泉の成分や火薬の原料として知られる黄色い非金属です。", "prop": "・火をつけると青い炎を出して燃え、特有の刺激臭を放つ\n・水には溶けない", "form": "S + O₂ ➔ SO₂", "use": "肥料、製薬、ゴム加硫、火薬に使われます。", "hazard": "硫黄の燃焼ガスは刺激臭のある有毒ガスです。", "electron": "[Ne] 3s²3p⁴", "fact": "温泉や火山の成分として親しみのある元素です。"},
	"F": {"name": "フッ素", "row": 2, "col": 7, "number": 9, "mass": "19.00", "group": "17族", "period": 2, "category": "ハロゲン", "state": "気体", "desc": "非常に反応しやすく、歯磨き粉やテフロン加工に使われます。", "prop": "・非常に反応しやすく、ほぼすべての元素と結びつく\n・淡黄色の猛毒の気体", "form": "H₂ + F₂ ➔ 2HF", "use": "電池、歯科、化学工業、表面加工に利用されます。", "hazard": "極めて強い腐食性と毒性があり、接触は危険です。", "electron": "[He] 2s²2p⁵", "fact": "非常に強い酸化力を持ち、最も反応しやすい元素の1つです。"},
	"Cl": {"name": "塩素", "row": 3, "col": 7, "number": 17, "mass": "35.45", "group": "17族", "period": 3, "category": "ハロゲン", "state": "気体", "desc": "水道水の消毒やプール、漂白剤の成分として使われます。", "prop": "・強い殺菌作用と漂白作用がある\n・独特な強い刺激臭があり、吸い込むと有害な毒ガス", "form": "2Na + Cl₂ ➔ 2NaCl", "use": "消毒、漂白、塩化物の合成に使われます。", "hazard": "刺激臭が強く、吸入すると気道を傷つけます。", "electron": "[Ne] 3s²3p⁵", "fact": "塩素は大きく分けて「消毒」「漂白」「化学合成」に使われます。"},
	"He": {"name": "ヘリウム", "row": 1, "col": 8, "number": 2, "mass": "4.00", "group": "18族", "period": 1, "category": "希ガス", "state": "気体", "desc": "非常に安定した軽い気体で、風船や飛行船に使われます。", "prop": "・宇宙で2番目に軽い気体\n・他の物質とは絶対に化学反応を起こさない", "form": "※極めて安定しているため、通常は化学反応式を作りません。", "use": "風船、液体ヘリウム、低温実験に使われます。", "hazard": "窒息の危険は低いですが、酸素不足になると危険です。", "electron": "1s²", "fact": "太陽でも多く見つかる元素で、ヘリウムという名前は太陽の「ヘリオス」に由来します。"},
	"Ar": {"name": "アルゴン", "row": 3, "col": 8, "number": 18, "mass": "39.95", "group": "18族", "period": 3, "category": "希ガス", "state": "気体", "desc": "空気中に少量含まれ、反応しにくい安定した気体です。", "prop": "・電球や蛍光灯の中に保護ガスとして封入されている\n・無色無臭で無害", "form": "※極めて安定しているため、通常は化学反応式を作りません。", "use": "保護ガス、溶接、照明、インクの製造に使われます。", "hazard": "濃度が高いと酸素不足の危険があります。", "electron": "[Ne] 3s²3p⁶", "fact": "「不活性ガス」の中でも、工業的に最も多く使われる気体です。"}
}

const CATEGORY_COLORS = {
	"非金属": Color("#38BDF8"),
	"金属": Color("#F59E0B"),
	"アルカリ金属": Color("#F97316"),
	"半金属": Color("#A78BFA"),
	"ハロゲン": Color("#EC4899"),
	"希ガス": Color("#14B8A6")
}

# ★v42追加★ 反応式の左辺の原子の組み合わせ（研究室に出せる元素だけ）
const FORM_PRESETS := {
	"H": ["H", "H", "H", "H", "O", "O"],
	"Na": ["Na", "Na", "H", "H", "H", "H", "O", "O"],
	"C": ["C", "O", "O"],
	"N": ["N", "N", "H", "H", "H", "H", "H", "H"],
	"O": ["H", "H", "H", "H", "O", "O"],
	"S": ["S", "O", "O"],
	"Cl": ["Na", "Na", "Cl", "Cl"],
	"Li": ["Li", "Li", "H", "H", "H", "H", "O", "O"],
	"K": ["K", "K", "H", "H", "H", "H", "O", "O"],
	"Be": ["Be", "H", "H", "Cl", "Cl"],
	"Mg": ["Mg", "Mg", "O", "O"],
	"Ca": ["Ca", "H", "H", "H", "H", "O", "O"],
	"B": ["B", "B", "B", "B", "O", "O", "O", "O", "O", "O"],
	"Al": ["Al", "Al", "Al", "Al", "O", "O", "O", "O", "O", "O"],
	"Si": ["Si", "O", "O"],
	"P": ["P", "P", "P", "P", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
	"F": ["H", "H", "F", "F"],
}

var main_script
var detail_panel: Panel

const DESIGN_SIZE := Vector2(1920.0, 1080.0)  # ★v28追加★ 設計上の画面サイズ


# ★v28追加★ 画面に収まるよう全体を拡大・縮小する
func _update_layout() -> void:
	var vp := get_viewport().get_visible_rect().size
	var s := minf(vp.x / DESIGN_SIZE.x, vp.y / DESIGN_SIZE.y)
	size = DESIGN_SIZE
	scale = Vector2.ONE * s
	position = (vp - DESIGN_SIZE * s) / 2.0


# ★v28追加★ 画面サイズが変わったら合わせ直す
func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_update_layout()


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)  # ★v28変更★ 大きさは _update_layout で管理
	_update_layout()

	var bg = ColorRect.new()
	bg.color = Color("#f4f7fc")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var title = Label.new()
	title.text = "元素図鑑"
	title.position = Vector2(0, 35)
	title.size = Vector2(size.x, 50)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color("#1d4ed8"))
	add_child(title)

	var subtitle = Label.new()
	subtitle.text = "代表元素をまとめて見る｜19種類の基本元素"
	subtitle.position = Vector2(0, 82)
	subtitle.size = Vector2(size.x, 26)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 16)
	subtitle.add_theme_color_override("font_color", Color("#475569"))
	add_child(subtitle)

	if main_script and main_script.has_method("_make_button"):
		var back_btn = main_script._make_button("⬅ 戻る", Vector2(40, 40), Vector2(120, 45), Color("#1d4ed8"))
		back_btn.pressed.connect(func(): queue_free())
		add_child(back_btn)

	_create_element_grid()

func _create_element_grid() -> void:
	var screen_size = size  # ★v28変更★ 自分の大きさ（設計サイズ）を使う
	var gap_x = 12.0
	var gap_y = 10.0
	var cell_w = 108.0
	var cell_h = 90.0
	var total_w = (cell_w * 8.0) + (gap_x * 7.0)
	var grid_start_x = (screen_size.x - total_w) / 2.0
	var grid_start_y = 170.0

	for symbol in ELEMENT_DATA.keys():
		var data = ELEMENT_DATA[symbol]
		var btn_x = grid_start_x + (data["col"] - 1) * (cell_w + gap_x)
		var btn_y = grid_start_y + (data["row"] - 1) * (cell_h + gap_y)

		var btn = _make_element_button(symbol, data)
		btn.position = Vector2(btn_x, btn_y)
		btn.size = Vector2(cell_w, cell_h)
		btn.pressed.connect(func(): _show_element_detail(symbol))
		add_child(btn)

func _make_element_button(symbol: String, data: Dictionary) -> Button:
	var btn = Button.new()
	btn.text = ""
	btn.custom_minimum_size = Vector2(100, 85)
	btn.size = Vector2(100, 85)

	var category_color = CATEGORY_COLORS.get(data["category"], Color("#93C5FD"))
	var normal_style = StyleBoxFlat.new()
	normal_style.bg_color = Color("#FFFFFF")
	normal_style.set_corner_radius_all(18)
	normal_style.border_width_left = 2
	normal_style.border_width_right = 2
	normal_style.border_width_top = 2
	normal_style.border_width_bottom = 2
	normal_style.border_color = category_color
	normal_style.shadow_color = Color(0.15, 0.2, 0.4, 0.10)
	normal_style.shadow_size = 5
	normal_style.shadow_offset = Vector2(0.0, 3.0)

	var hover_style = normal_style.duplicate() as StyleBoxFlat  # ★v28修正★ 型を明示
	hover_style.bg_color = category_color.lightened(0.85)
	var pressed_style = normal_style.duplicate() as StyleBoxFlat  # ★v28修正★ 型を明示
	pressed_style.bg_color = category_color.lightened(0.65)

	btn.add_theme_stylebox_override("normal", normal_style)
	btn.add_theme_stylebox_override("hover", hover_style)
	btn.add_theme_stylebox_override("pressed", pressed_style)
	btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	btn.add_theme_color_override("font_color", Color("#0F172A"))
	btn.add_theme_color_override("font_hover_color", Color("#0F172A"))

	var symbol_label = Label.new()
	symbol_label.text = symbol
	symbol_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	symbol_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	symbol_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	symbol_label.add_theme_font_size_override("font_size", 30)
	symbol_label.add_theme_color_override("font_color", Color("#0f172a"))
	btn.add_child(symbol_label)

	var name_label = Label.new()
	name_label.text = data["name"]
	name_label.position = Vector2(0, btn.size.y * 0.72)
	name_label.size = Vector2(btn.size.x, 18)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	name_label.add_theme_font_size_override("font_size", 9)
	name_label.add_theme_color_override("font_color", Color("#334155"))
	btn.add_child(name_label)

	var number_label = Label.new()
	number_label.text = str(data["number"])
	number_label.position = Vector2(8, 6)
	number_label.size = Vector2(24, 12)
	number_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	number_label.add_theme_font_size_override("font_size", 8)
	number_label.add_theme_color_override("font_color", Color("#475569"))
	btn.add_child(number_label)

	return btn

# ★v48追加★ 一覧に戻す（メニューから開き直したとき用）
func show_list() -> void:
	if is_instance_valid(detail_panel):
		detail_panel.queue_free()
		detail_panel = null


func _show_element_detail(symbol: String) -> void:
	if is_instance_valid(detail_panel):
		detail_panel.queue_free()

	var data = ELEMENT_DATA[symbol]
	var card_color = CATEGORY_COLORS.get(data["category"], Color("#BFDBFE"))
	var screen_size = size  # ★v28変更★ 自分の大きさ（設計サイズ）を使う

	detail_panel = Panel.new()
	detail_panel.position = Vector2.ZERO
	detail_panel.size = screen_size

	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = Color("#eef6ff")
	detail_panel.add_theme_stylebox_override("panel", bg_style)
	add_child(detail_panel)

	var back_btn = Button.new()
	back_btn.text = "← 元素一覧に戻る"
	back_btn.position = Vector2(60, 38)
	back_btn.size = Vector2(220, 52)
	back_btn.add_theme_font_size_override("font_size", 18)
	back_btn.add_theme_color_override("font_color", Color("#FFFFFF"))
	var back_style = StyleBoxFlat.new()
	back_style.bg_color = Color("#2563eb")
	back_style.set_corner_radius_all(16)
	back_btn.add_theme_stylebox_override("normal", back_style)
	back_btn.add_theme_stylebox_override("hover", back_style)
	back_btn.add_theme_stylebox_override("pressed", back_style)
	back_btn.pressed.connect(func():
		detail_panel.queue_free()
		detail_panel = null
	)
	detail_panel.add_child(back_btn)

	var symbol_panel = Panel.new()
	symbol_panel.position = Vector2(90, 130)
	symbol_panel.size = Vector2(420, 520)
	var symbol_style = StyleBoxFlat.new()
	symbol_style.bg_color = Color("#FFFFFF")
	symbol_style.set_corner_radius_all(30)
	symbol_style.border_width_left = 3
	symbol_style.border_width_right = 3
	symbol_style.border_width_top = 3
	symbol_style.border_width_bottom = 3
	symbol_style.border_color = card_color
	symbol_panel.add_theme_stylebox_override("panel", symbol_style)
	detail_panel.add_child(symbol_panel)

	var symbol_label = Label.new()
	symbol_label.text = symbol
	symbol_label.position = Vector2(0, 18)
	symbol_label.size = Vector2(420, 190)
	symbol_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	symbol_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	symbol_label.add_theme_font_size_override("font_size", 150)
	symbol_label.add_theme_color_override("font_color", Color("#1d4ed8"))
	symbol_panel.add_child(symbol_label)

	var name_label = Label.new()
	name_label.text = data["name"]
	name_label.position = Vector2(0, 210)
	name_label.size = Vector2(420, 48)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	name_label.add_theme_font_size_override("font_size", 35)
	name_label.add_theme_color_override("font_color", Color("#0F172A"))
	symbol_panel.add_child(name_label)

	var badge = Panel.new()
	badge.position = Vector2(120, 270)
	badge.size = Vector2(180, 42)
	var badge_style = StyleBoxFlat.new()
	badge_style.bg_color = card_color
	badge_style.set_corner_radius_all(18)
	badge.add_theme_stylebox_override("panel", badge_style)
	symbol_panel.add_child(badge)
	var badge_label = Label.new()
	badge_label.text = data["category"]
	badge_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	badge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	badge_label.add_theme_font_size_override("font_size", 17)
	badge_label.add_theme_color_override("font_color", Color("#FFFFFF"))
	badge.add_child(badge_label)

	var stat_row = HBoxContainer.new()
	stat_row.position = Vector2(220, 225)
	stat_row.size = Vector2(0, 0)
	stat_row.add_theme_constant_override("separation", 12)
	stat_row.alignment = BoxContainer.ALIGNMENT_END
	detail_panel.add_child(stat_row)

	var info_panel = Panel.new()
	info_panel.position = Vector2(560, 130)
	info_panel.size = Vector2(1250, 760)
	var info_style = StyleBoxFlat.new()
	info_style.bg_color = Color("#FFFFFF")
	info_style.set_corner_radius_all(28)
	info_style.border_width_left = 2
	info_style.border_width_right = 2
	info_style.border_width_top = 2
	info_style.border_width_bottom = 2
	info_style.border_color = Color("#dbeafe")
	info_panel.add_theme_stylebox_override("panel", info_style)
	detail_panel.add_child(info_panel)

	var title_label = Label.new()
	title_label.text = "要点" + "  •  " + data["name"]
	title_label.position = Vector2(36, 22)
	title_label.size = Vector2(1180, 48)
	title_label.add_theme_font_size_override("font_size", 32)
	title_label.add_theme_color_override("font_color", Color("#1e3a8a"))
	info_panel.add_child(title_label)

	var overview = Label.new()
	overview.text = data["fact"]
	overview.position = Vector2(36, 82)
	overview.size = Vector2(1180, 50)
	overview.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	overview.add_theme_font_size_override("font_size", 20)
	overview.add_theme_color_override("font_color", Color("#475569"))
	info_panel.add_child(overview)

	_add_info_card(info_panel, "基本情報", [
		"原子番号: " + str(data["number"]),
		"原子量: " + str(data["mass"]),
		"周期: " + str(data["period"]),
		"族: " + data["group"],
		"分類: " + data["category"],
		"状態: " + data["state"]
	], 36, 150, 320, 215)

	_add_info_card(info_panel, "元素の説明", [data["desc"]], 390, 150, 820, 100)
	_add_info_card(info_panel, "主な用途", [data["use"]], 390, 265, 820, 100)
	_add_info_card(info_panel, "性質・特徴", [data["prop"]], 36, 380, 1174, 125)
	_add_info_card(info_panel, "注意事項", [data["hazard"]], 36, 520, 1174, 100)
	_add_info_card(info_panel, "電子配置 / 反応式", ["電子配置: " + data["electron"], "反応式: " + data["form"]], 36, 635, 1174, 110)
	# ★v42追加★ 反応式をタップすると、研究室でその式の組み合わせが出る
	if FORM_PRESETS.has(symbol):
		var form_btn := Button.new()
		form_btn.text = ""
		form_btn.position = Vector2(52, 700)
		form_btn.size = Vector2(1160, 42)
		form_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		form_btn.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
		form_btn.add_theme_stylebox_override("hover", StyleBoxEmpty.new())
		form_btn.add_theme_stylebox_override("pressed", StyleBoxEmpty.new())
		form_btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		form_btn.pressed.connect(_open_form_in_lab.bind(symbol))
		info_panel.add_child(form_btn)
		var form_hint := Label.new()
		form_hint.text = "🧪 タップで研究室で見る"
		form_hint.position = Vector2(830, 704)
		form_hint.size = Vector2(370, 34)
		form_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		form_hint.add_theme_font_size_override("font_size", 17)
		form_hint.add_theme_color_override("font_color", Color("#1d4ed8"))
		form_hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
		info_panel.add_child(form_hint)
	else:
		# ★v43追加★ リンクが無い理由を表示する
		var no_hint := Label.new()
		if str(data["form"]).begins_with("※"):
			no_hint.text = "※ 反応式が無いため、研究室リンクはありません"
		else:
			no_hint.text = "※ " + str(data["name"]) + "は研究室のパレットに無いので出せません"
		no_hint.position = Vector2(470, 704)
		no_hint.size = Vector2(730, 34)
		no_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		no_hint.add_theme_font_size_override("font_size", 15)
		no_hint.add_theme_color_override("font_color", Color("#64748B"))
		no_hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
		info_panel.add_child(no_hint)


# ★v42追加★ 反応式の組み合わせを研究室に出す
func _open_form_in_lab(sym: String) -> void:
	if not FORM_PRESETS.has(sym):
		return
	if main_script and main_script.has_method("open_simulation_with_preset"):
		main_script.set("encyclopedia_page", self)  # 戻ってくるために main に覚えてもらう
		main_script.call("open_simulation_with_preset", FORM_PRESETS[sym], "encyclopedia")
		visible = false  # ページを消さずに隠す（研究室から同じページに戻れるように）

func _add_stat_chip(container: Container, label_text: String, value_text: String) -> void:
	var chip = Panel.new()
	chip.size = Vector2(110, 100)
	var style = StyleBoxFlat.new()
	style.bg_color = Color("#E0F2FE")
	style.set_corner_radius_all(18)
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_color = Color("#93C5FD")
	chip.add_theme_stylebox_override("panel", style)
	container.add_child(chip)

	var label = Label.new()
	label.text = label_text
	label.position = Vector2(0, 10)
	label.size = Vector2(110, 22)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 11)
	label.add_theme_color_override("font_color", Color("#475569"))
	chip.add_child(label)

	var value = Label.new()
	value.text = value_text
	value.position = Vector2(0, 36)
	value.size = Vector2(110, 52)
	value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	value.add_theme_font_size_override("font_size", 23)
	value.add_theme_color_override("font_color", Color("#1e3a8a"))
	chip.add_child(value)

func _add_info_card(panel: Panel, title_text: String, lines: Array, x: float, y: float, width: float, height: float) -> void:
	var card = Panel.new()
	card.position = Vector2(x, y)
	card.size = Vector2(width, height)
	var style = StyleBoxFlat.new()
	style.bg_color = Color("#F8FAFC")
	style.set_corner_radius_all(20)
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_color = Color("#dbeafe")
	card.add_theme_stylebox_override("panel", style)
	panel.add_child(card)

	var title = Label.new()
	title.text = title_text
	title.position = Vector2(22, 12)
	title.size = Vector2(width - 40, 30)
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color("#1d4ed8"))
	card.add_child(title)

	var text = Label.new()
	var text_value = ""
	for i in range(lines.size()):
		text_value += str(lines[i])
		if i < lines.size() - 1:
			text_value += "\n"
	text.text = text_value
	text.position = Vector2(22, 48)
	text.size = Vector2(width - 40, height - 60)
	text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text.add_theme_font_size_override("font_size", 18)
	text.add_theme_color_override("font_color", Color("#334155"))
	card.add_child(text)
