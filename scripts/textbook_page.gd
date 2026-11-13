extends Control

# Simulation LAB - 教科書ページ
# Godot 4.x
# 中学の教科書のように、本文・ことばの説明・図・実験で学習項目を説明する。
# 実験の「シミュレーションで実験する」を押すと、必要な原子が並んだ状態で実験画面が開く。

const BG_COLOR := Color("#E0F2FE")
const TEXT_COLOR := Color("#075985")
const SUB_COLOR := Color("#64748B")
const BLUE := Color("#2563EB")
const TEAL := Color("#0D9488")
const WHITE := Color("#FFFFFF")

const UNITS := ["分解", "化合", "原子と分子", "酸化と還元", "物質と化学変化の応用"]

const EXPERIMENTS := [
	{
		"unit": 0,
		"no": 1,
		"title": "物質を分解させる実験",
		"exp_name": "水の電気分解",
		"body": [
			"1つの物質が、2つ以上の別の物質に分かれる化学変化を分解という。水を熱すると水蒸気になるが、これは状態が変わっただけで、水そのものは変わっていない。",
			"ところが、水に電流を流すと、水素と酸素という、もとの水とはまったく別の物質に分けることができる。このように、電流を流して物質を分解することを電気分解という。",
			"水の電気分解では、電源の−極につないだ陰極に水素が、＋極につないだ陽極に酸素が発生する。集まる気体の体積の比は、水素：酸素＝2：1になる。これは、水の分子1つが、水素原子2つと酸素原子1つからできていることと対応している。"
		],
		"words": [
			{"term": "分解", "def": "1つの物質が、2つ以上の別の物質に分かれる化学変化。"},
			{"term": "電気分解", "def": "電流を流して物質を分解すること。"},
			{"term": "陰極・陽極", "def": "電源の−極につないだ電極が陰極、＋極につないだ電極が陽極。"}
		],
		"figure": "electrolysis_water",
		"figure_caption": "図　水の電気分解の装置（水素と酸素が2：1の体積で集まる）",
		"purpose": "水に電気を流すと、どんな物質に分かれるか調べる。",
		"steps": "1. まずシミュレーションで、水（H₂O）のモデルを作ってみよう\n2. 水に電流を流すと、＋極側に酸素、−極側に水素が発生する\n3. 集まった気体の体積の比は、水素：酸素 ＝ 2：1 になる",
		"result": "水は、水素と酸素に分解できる。\n化学反応式： 2H₂O → 2H₂ ＋ O₂",
		"summary": "分解とは、1つの物質が別の物質に分かれる変化。水は電気分解で水素と酸素に分かれる。",
		"preset": ["H", "H", "O"]
	},
	{
		"unit": 0,
		"no": 2,
		"title": "発展的内容（塩化銅水溶液の電気分解）",
		"exp_name": "塩化銅水溶液の電気分解",
		"body": [
			"塩化銅が水に溶けると、銅イオン（Cu²⁺）と塩化物イオン（Cl⁻）に分かれて、水溶液の中に広がっている。このように、物質が水に溶けてイオンに分かれることを電離という。塩化銅水溶液の青色は、銅イオンの色である。",
			"電流を流すと、＋の電気を帯びた銅イオンは陰極（−極）に、−の電気を帯びた塩化物イオンは陽極（＋極）に引き寄せられる。陰極では、銅イオンが電子を受け取って赤茶色の銅になり、陽極では、塩化物イオンが塩素の気体になる。",
			"実験が進むと、銅イオンが減っていくので、水溶液の青色はだんだんうすくなる。"
		],
		"words": [
			{"term": "イオン", "def": "原子や原子の集まりが、電気を帯びたもの。"},
			{"term": "電離", "def": "物質が水に溶けて、イオンに分かれること。"},
			{"term": "電子", "def": "−の電気をもつ、原子の中にある小さな粒。"}
		],
		"figure": "electrolysis_cucl2",
		"figure_caption": "図　塩化銅水溶液の電気分解（陰極に銅、陽極に塩素）",
		"purpose": "塩化銅水溶液に電気を流すと、電極に何が現れるか調べる。",
		"steps": "1. まずシミュレーションで、塩化銅（CuCl₂）のモデルを作ってみよう\n2. 電流を流すと、陰極（−極）には赤茶色の銅が、陽極（＋極）には塩素が発生する\n3. 青色の水溶液の色は、だんだんうすくなる",
		"result": "塩化銅は、銅と塩素に分解できる。\n水溶液の中で分かれていたイオンが、電極に引き寄せられて物質になる。",
		"summary": "電流を流すとイオンが電極に集まり、陰極に銅、陽極に塩素ができる。",
		"preset": ["Cu", "Cl", "Cl"]
	},
	{
		"unit": 1,
		"no": 3,
		"title": "2つの物質を化合させる実験",
		"exp_name": "鉄と硫黄の化合",
		"body": [
			"2つ以上の物質が結びついて、別の物質ができる化学変化を化合という。反対に、1つの物質が別の物質に分かれる変化が分解だった。",
			"鉄の粉と硫黄の粉を混ぜて加熱すると、混合物の一部が赤く光り始め、熱が全体に伝わって反応が進む。冷やすと、硫化鉄という、もとの鉄や硫黄とは別の物質ができている。",
			"このように、化合によってできた物質を化合物という。硫化鉄は、鉄原子と硫黄原子が1：1の割合で結びついた化合物である。"
		],
		"words": [
			{"term": "化合", "def": "2つ以上の物質が結びついて、別の物質ができる化学変化。"},
			{"term": "化合物", "def": "化合によってできた物質。2種類以上の元素からできている。"},
			{"term": "元素", "def": "物質を作っている原子の種類のこと。"}
		],
		"figure": "heating_fes",
		"figure_caption": "図　鉄と硫黄を加熱すると、硫化鉄ができる",
		"purpose": "鉄と硫黄を混ぜて加熱すると、どんな物質ができるか調べる。",
		"steps": "1. まずシミュレーションで、鉄（Fe）と硫黄（S）を近づけてみよう\n2. 混ぜて加熱すると、光と熱を出して反応する\n3. 硫化鉄（FeS）という新しい物質ができる",
		"result": "2つの物質が結びついて別の物質になる変化を、化合という。\n化学反応式： Fe ＋ S → FeS",
		"summary": "化合とは、2つ以上の物質が結びついて別の物質になる変化。鉄＋硫黄→硫化鉄。",
		"preset": ["Fe", "S"]
	},
	{
		"unit": 1,
		"no": 4,
		"title": "化学変化前後での物質の性質の変化",
		"exp_name": "硫化鉄の性質を調べる",
		"body": [
			"化学変化が起こると、もとの物質とは性質の違う、新しい物質ができる。性質とは、色や臭い、磁石につくかどうかなど、物質を見分けるための特徴のことである。",
			"鉄は磁石につき、硫黄は黄色い粉である。しかし、鉄と硫黄が化合してできた硫化鉄は黒っぽく、磁石にはつかない。ただ混ぜただけの混合物は、磁石で鉄だけを引き寄せることができるが、硫化鉄からは鉄を取り出せない。",
			"また、硫化鉄に塩酸を加えると、腐卵臭（腐った卵のような臭い）のある硫化水素という気体が発生する。このように、性質の変化を調べることで、化学変化が起こったかどうかを確かめることができる。"
		],
		"words": [
			{"term": "性質", "def": "色・臭い・磁石につくかなど、物質を見分ける特徴。"},
			{"term": "硫化水素", "def": "腐卵臭のある有毒な気体。硫化鉄に塩酸を加えると発生する。"},
			{"term": "混合物", "def": "2つ以上の物質が、化学変化せずに混ざったもの。"}
		],
		"figure": "magnet",
		"figure_caption": "図　鉄は磁石につくが、硫化鉄はつかない",
		"purpose": "化合の前と後で、物質の性質がどう変わるか比べる。",
		"steps": "1. 化合の前の鉄は磁石につき、硫黄は黄色い粉である\n2. 化合してできた硫化鉄は、磁石につかない\n3. 硫化鉄に塩酸を加えると、腐卵臭のある硫化水素が発生する",
		"result": "化学変化が起こると、元の物質とは性質の違う、新しい物質ができる。",
		"summary": "化学変化の前後では物質の性質が変わる。性質を調べると変化が確かめられる。",
		"preset": ["Fe", "S"]
	},
	{
		"unit": 2,
		"no": 5,
		"title": "原子や分子",
		"exp_name": "分子モデルを作ろう",
		"body": [
			"物質を細かく分けていくと、最後には、それ以上分けることのできない小さな粒になる。この粒を原子という。原子はとても小さく、直径はおよそ1億分の1cmほどしかない。原子には、鉄・酸素・水素など、たくさんの種類があり、種類ごとに性質が違う。",
			"多くの物質は、原子が決まった数だけ結びついた分子という粒からできている。例えば、水の分子は水素原子2つと酸素原子1つが結びついたもので、水の性質を示す最小の粒である。",
			"物質がどんな原子でできているかを記号で表したものを化学式という。水の化学式はH₂Oで、水素原子2つと酸素原子1つからできていることを表している。"
		],
		"words": [
			{"term": "原子", "def": "物質を作っている、それ以上分けられない小さな粒。"},
			{"term": "分子", "def": "原子が結びついた粒で、物質の性質を示す最小の単位。"},
			{"term": "化学式", "def": "物質を元素記号と数字で表したもの。例：水はH₂O。"}
		],
		"figure": "molecule",
		"figure_caption": "図　水の分子モデル（酸素原子1つに水素原子2つ）",
		"purpose": "原子の組み合わせで、いろいろな物質の分子ができることを確かめる。",
		"steps": "1. シミュレーションで原子を組み合わせて、水（H₂O）の分子モデルを作ってみよう\n2. 分子は、その物質の性質を示す最小の粒である\n3. アンモニア（NH₃）やメタン（CH₄）など、他の分子にも挑戦してみよう",
		"result": "物質は原子の組み合わせでできている。原子の種類と数が決まると、できる物質が決まる。",
		"summary": "物質は原子からできていて、原子が結びついた分子が性質を示す最小の粒。",
		"preset": ["H", "H", "O"]
	},
	{
		"unit": 2,
		"no": 6,
		"title": "化学反応式",
		"exp_name": "水ができる反応を式で表す",
		"body": [
			"化学変化を化学式で表したものを化学反応式という。例えば、水素が燃えて水ができる変化は、2H₂＋O₂→2H₂Oと表される。矢印の左側が反応する前の物質、右側が反応のあとにできる物質である。",
			"化学反応式を作るときに大切なことは、反応の前後で原子の種類と数が変わらないことである。原子は、化学変化によって新しく生まれたり、消えたりすることはない。",
			"そこで、化学式の前につける数字（係数）を調節して、左右の原子の数をそろえる。水素分子2つと酸素分子1つが反応すると、水の分子が2つできるので、係数は2、1、2になる。"
		],
		"words": [
			{"term": "化学反応式", "def": "化学変化を化学式で表したもの。"},
			{"term": "係数", "def": "化学式の前につけて、原子の数をそろえるための数字。"}
		],
		"figure": "equation",
		"figure_caption": "図　2H₂＋O₂→2H₂O（原子の数は前後で変わらない）",
		"purpose": "化学変化を、化学式を使って表す方法を学ぶ。",
		"steps": "1. 水素が燃えて、水ができる変化を考える\n2. 反応の前後で、原子の種類と数は変わらない\n3. 左右で原子の数が等しくなるように、係数をそろえる",
		"result": "化学反応式： 2H₂ ＋ O₂ → 2H₂O\nシミュレーションで水のモデルを作って、原子の数を確認してみよう。",
		"summary": "化学反応式は、原子の数が左右で等しくなるように係数をつけて表す。",
		"preset": ["H", "H", "O"]
	},
	{
		"unit": 2,
		"no": 7,
		"title": "発展的内容（周期表、原子の構造、イオン）",
		"exp_name": "イオンが結びつく物質",
		"body": [
			"原子は、中心にある原子核と、そのまわりを回っている電子からできている。原子核は＋の電気をもち、電子は−の電気をもっている。ふつうの原子では＋と−の量が等しいので、原子全体では電気を帯びていない。",
			"原子が電子を失ったり、受け取ったりして電気を帯びたものをイオンという。電子を失って＋のイオンになったものを陽イオン、電子を受け取って−のイオンになったものを陰イオンという。",
			"食塩（塩化ナトリウム）は、陽イオンのナトリウムイオンと、陰イオンの塩化物イオンが、＋と−で引き合って規則正しく並んだ物質である。また、原子を性質の似たもの同士が並ぶように整理した表を周期表といい、元素の性質を調べるのに役立っている。"
		],
		"words": [
			{"term": "原子核", "def": "原子の中心にあり、＋の電気をもつ部分。"},
			{"term": "陽イオン・陰イオン", "def": "＋の電気を帯びたイオンが陽イオン、−の電気を帯びたイオンが陰イオン。"},
			{"term": "周期表", "def": "原子を、性質の似たもの同士が並ぶように整理した表。"}
		],
		"figure": "ion",
		"figure_caption": "図　塩化ナトリウムのイオンの並び方",
		"purpose": "原子の構造と、電気を帯びた粒「イオン」について学ぶ。",
		"steps": "1. 原子は、中心にある原子核と、そのまわりを回る電子からできている\n2. 原子が電子を失ったり受け取ったりすると、イオンになる\n3. 食塩（NaCl）は、ナトリウムイオンと塩化物イオンが結びついた物質。シミュレーションでモデルを作ってみよう",
		"result": "周期表は、原子を性質の似たもの同士で並べた表である。イオンの組み合わせで、いろいろな物質ができる。",
		"summary": "原子は原子核と電子からできていて、電子のやりとりでイオンになる。",
		"preset": ["Na", "Cl"]
	},
	{
		"unit": 3,
		"no": 8,
		"title": "酸化の実験",
		"exp_name": "銅の酸化",
		"body": [
			"物質が酸素と結びつく化学変化を酸化という。銅の粉を空気中で加熱すると、空気中の酸素と化合して、黒い酸化銅になる。",
			"このとき、結びついた酸素の分だけ、加熱後の質量は加熱前より増える。酸素と化合してできた化合物を酸化物という。",
			"鉄が空気中の酸素や水と結びついてさびるのも、時間をかけて進む酸化である。また、物質が激しく光や熱を出して酸化する現象を燃焼という。"
		],
		"words": [
			{"term": "酸化", "def": "物質が酸素と結びつく化学変化。"},
			{"term": "酸化物", "def": "酸素と化合してできた化合物。例：酸化銅。"},
			{"term": "燃焼", "def": "激しく光や熱を出して酸化する現象。"}
		],
		"figure": "oxidation",
		"figure_caption": "図　銅を加熱すると、酸素と結びついて黒い酸化銅になる",
		"purpose": "金属を空気中で加熱すると、質量や性質がどう変わるか調べる。",
		"steps": "1. まずシミュレーションで、銅（Cu）に酸素（O）を近づけて、酸化銅（CuO）のモデルを作ってみよう\n2. 銅を加熱すると、空気中の酸素と結びついて、黒い酸化銅になる\n3. 酸素と結びついた分だけ、質量が増える",
		"result": "酸素と結びつく化学変化を、酸化という。\n化学反応式： 2Cu ＋ O₂ → 2CuO",
		"summary": "酸化は酸素と結びつく変化。酸化すると、結びついた酸素の分だけ質量が増える。",
		"preset": ["Cu", "O"]
	},
	{
		"unit": 3,
		"no": 9,
		"title": "還元の実験",
		"exp_name": "酸化銅から銅を取り出す",
		"body": [
			"酸化物から酸素を取り除く化学変化を還元という。酸化銅と炭素の粉を混ぜて加熱すると、酸化銅は赤茶色の銅に戻る。",
			"この変化では、炭素が酸化銅から酸素を奪っている。酸素を奪った炭素は、二酸化炭素になる。つまり、酸化銅が還元されると同時に、炭素が酸化されている。",
			"このように、酸化と還元は、いつも同時に起こっている。鉄などの金属を鉱石から取り出す製錬でも、還元の仕組みが利用されている。"
		],
		"words": [
			{"term": "還元", "def": "酸化物から酸素を取り除く化学変化。"},
			{"term": "製錬", "def": "鉱石から金属を取り出すこと。還元を利用する。"}
		],
		"figure": "heating_cuo",
		"figure_caption": "図　酸化銅と炭素を加熱すると、銅が取り出せる",
		"purpose": "酸化銅から酸素を取り除いて、銅に戻す方法を調べる。",
		"steps": "1. まずシミュレーションで、酸化銅（CuO）のモデルを用意しよう\n2. 酸化銅と炭素を混ぜて加熱すると、銅が取り出せる\n3. 炭素が酸化銅から酸素を奪って、二酸化炭素になる",
		"result": "酸素を奪う化学変化を、還元という。酸化と還元は、いつも同時に起こっている。\n化学反応式： 2CuO ＋ C → 2Cu ＋ CO₂",
		"summary": "還元は酸素を奪う変化。酸化と還元は同時に起こる。",
		"preset": ["Cu", "O"]
	},
	{
		"unit": 4,
		"no": 10,
		"title": "化学変化によって熱や電気を取り出す",
		"exp_name": "燃料電池とカイロ",
		"body": [
			"化学変化では、熱や光、電気などのエネルギーが出入りする。使い捨てカイロは、中の鉄が酸化するときに出る熱を利用したものである。反対に、水と混ぜると温度が下がる冷却パックは、熱を吸収する化学変化を利用している。",
			"電池は、化学変化を利用して電気を取り出す装置である。ボルタ電池やダニエル電池では、2種類の金属と水溶液のはたらきで電気が流れる。",
			"水素と酸素を反応させて電気を取り出す燃料電池は、反応のあとにできるのが水だけなので、環境にやさしい電池として、自動車などへの利用が広がっている。"
		],
		"words": [
			{"term": "電池", "def": "化学変化を利用して、電気を取り出す装置。"},
			{"term": "燃料電池", "def": "水素と酸素の反応を利用して電気を取り出す電池。排出されるのは水だけ。"}
		],
		"figure": "battery",
		"figure_caption": "図　電池の仕組み（化学変化で電気を取り出す）",
		"purpose": "化学変化で出る熱や電気が、どのように利用されているか調べる。",
		"steps": "1. 使い捨てカイロは、鉄が酸化するときに出る熱を利用している\n2. 電池は、化学変化を使って電気を取り出す仕組みである\n3. 燃料電池は、水素と酸素を反応させて、電気と水を作る。シミュレーションで水のモデルを作ってみよう",
		"result": "化学変化は、新しい物質を作るだけでなく、熱や電気を取り出すのにも利用されている。",
		"summary": "化学変化を使うと、熱や電気を取り出すことができる。カイロや電池がその例。",
		"preset": ["H", "H", "O"]
	}
]

var main_script: Node
var root: Control
var current: Dictionary = {}
var _current_index := -1  # ★v27追加★ 開いている項目（-1は一覧）
var nav_button: Button  # ★v35追加★ 左上の「戻る」ボタン
var nav_action := "menu"  # ★v35追加★ "menu"=メニューへ / "list"=一覧へ
var error_label: Label


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build_list()


# ★v27追加★ 画面サイズが変わったら、今の画面を作り直す
func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED and is_inside_tree():
		if _current_index >= 0:
			_open_detail(_current_index)
		else:
			_build_list()


func _clear() -> void:
	for child in get_children():
		if child == nav_button:
			continue  # ★v36修正★ 戻るボタンは消さない（消すと再表示できなくなる）
		child.queue_free()
	var bg := ColorRect.new()
	bg.color = BG_COLOR
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	root = Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(root)


func _make_box(max_content_w: float = 700.0) -> VBoxContainer:  # ★v38変更★ 幅を指定できるように
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	# ★v35変更★ 内容の幅を最大700にして中央に寄せる（横長すぎて見にくい対策）
	var page_w := size.x
	if page_w < 100.0:
		page_w = get_viewport().get_visible_rect().size.x
	var side := int(maxf(60.0, (page_w - max_content_w) / 2.0))  # ★v38変更★
	margin.add_theme_constant_override("margin_left", side)
	margin.add_theme_constant_override("margin_right", side)
	margin.add_theme_constant_override("margin_top", 100)
	margin.add_theme_constant_override("margin_bottom", 24)
	root.add_child(margin)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED  # ★v25追加★ 横はみ出し防止
	scroll.scroll_vertical_custom_step = 25.0  # ★v37追加★ ホイールで少しずつ動くように
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(scroll)
	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 12)
	scroll.add_child(vbox)
	return vbox


func _make_label(value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label


func _make_btn(value: String, bg: Color, font_color: Color, height: float = 54.0) -> Button:
	var button := Button.new()
	button.text = value
	button.custom_minimum_size = Vector2(0, height)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 17)
	button.add_theme_color_override("font_color", font_color)
	button.add_theme_color_override("font_hover_color", font_color)
	button.add_theme_color_override("font_pressed_color", font_color)
	button.add_theme_color_override("font_focus_color", font_color)
	button.add_theme_color_override("font_disabled_color", font_color)
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.set_corner_radius_all(12)
	style.content_margin_left = 16
	style.content_margin_right = 16
	button.add_theme_stylebox_override("normal", style)
	var hover := style.duplicate()
	hover.bg_color = bg.lightened(0.08)
	button.add_theme_stylebox_override("hover", hover)
	var pressed := style.duplicate()
	pressed.bg_color = bg.darkened(0.08)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_stylebox_override("focus", style)
	return button


# 囲み（ことば・実験）の箱を作って、中の並び先を返す
func _add_box(parent_vbox: VBoxContainer, bg: Color) -> VBoxContainer:
	var panel := PanelContainer.new()  # ★v26修正★ PanelContainerなら中身に合わせて高さが決まる
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.set_corner_radius_all(12)
	panel.add_theme_stylebox_override("panel", style)
	parent_vbox.add_child(panel)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_bottom", 14)
	panel.add_child(margin)
	var inner := VBoxContainer.new()
	inner.add_theme_constant_override("separation", 8)
	margin.add_child(inner)
	return inner


# =====================================
# 実験の一覧
# =====================================

func _build_list() -> void:
	_current_index = -1
	_clear()
	var vbox := _make_box(940.0)  # ★v38変更★ 一覧は2列にするので少し広く
	vbox.add_child(_make_label("📖 教科書", 30, TEXT_COLOR))
	vbox.add_child(_make_label("やりたい項目を選んでね。本文と図で学んで、実験はシミュレーションで試せます。", 14, SUB_COLOR))
	_show_nav("menu")  # ★v35変更★ 戻るは左上のボタンに統一
	for u in range(UNITS.size()):
		var header := _make_label("第" + str(u + 1) + "単元　" + UNITS[u], 19, BLUE)
		vbox.add_child(header)
		# ★v38変更★ 項目ボタンを2列に並べて、スクロールなしで全部見えるように
		var grid := GridContainer.new()
		grid.columns = 2
		grid.add_theme_constant_override("h_separation", 12)
		grid.add_theme_constant_override("v_separation", 12)
		grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox.add_child(grid)
		for i in range(EXPERIMENTS.size()):
			var exp: Dictionary = EXPERIMENTS[i]
			if int(exp["unit"]) != u:
				continue
			var btn := _make_btn(str(exp["no"]) + ".　" + exp["title"], WHITE, TEXT_COLOR)
			btn.pressed.connect(_open_detail.bind(i))
			grid.add_child(btn)
	error_label = _make_label("", 14, Color("#DC2626"))
	vbox.add_child(error_label)
	# ★v37追加★ 一番下に余白（最後の項目が画面の端に張りつかないように）
	var bottom_spacer := Control.new()
	bottom_spacer.custom_minimum_size = Vector2(0, 40)  # ★v38変更★
	bottom_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(bottom_spacer)


# =====================================
# 学習項目のページ（本文・図・ことば・実験）
# =====================================

func _open_detail(index: int) -> void:
	_current_index = index
	current = EXPERIMENTS[index]
	_clear()
	var vbox := _make_box()
	_show_nav("list")  # ★v35変更★ 戻るは左上のボタンに統一
	vbox.add_child(_make_label(str(current["no"]) + ". " + current["title"], 24, TEXT_COLOR))
	vbox.add_child(_make_label("第" + str(int(current["unit"]) + 1) + "単元　" + UNITS[int(current["unit"])], 14, SUB_COLOR))
	# 本文
	for para in current["body"]:
		vbox.add_child(_make_label(para, 15, TEXT_COLOR))
	# 図
	vbox.add_child(_make_figure(current["figure"]))
	var caption := _make_label(current["figure_caption"], 12, SUB_COLOR)
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(caption)
	# ことば
	var words_box := _add_box(vbox, Color("#EFF6FF"))
	words_box.add_child(_make_label("📘 ことば", 16, BLUE))
	for w in current["words"]:
		words_box.add_child(_make_label("■ " + w["term"] + "： " + w["def"], 14, TEXT_COLOR))
	# 実験
	var exp_box := _add_box(vbox, Color("#F0FDFA"))
	exp_box.add_child(_make_label("🧪 実験： " + current["exp_name"], 17, TEAL))
	exp_box.add_child(_make_label("【目的】", 15, TEAL))
	exp_box.add_child(_make_label(current["purpose"], 14, TEXT_COLOR))
	exp_box.add_child(_make_label("【手順】", 15, TEAL))
	exp_box.add_child(_make_label(current["steps"], 14, TEXT_COLOR))
	exp_box.add_child(_make_label("【結果・わかること】", 15, TEAL))
	exp_box.add_child(_make_label(current["result"], 14, TEXT_COLOR))
	var go := _make_btn("🧪 シミュレーションで実験する", TEAL, WHITE, 60.0)
	go.add_theme_font_size_override("font_size", 18)
	go.pressed.connect(_start_experiment)
	exp_box.add_child(go)
	# まとめ
	vbox.add_child(_make_label("【まとめ】", 16, BLUE))
	vbox.add_child(_make_label(current["summary"], 15, TEXT_COLOR))
	error_label = _make_label("", 14, Color("#DC2626"))
	vbox.add_child(error_label)
	# ★v37追加★ 一番下に余白（最後の項目が画面の端に張りつかないように）
	var bottom_spacer := Control.new()
	bottom_spacer.custom_minimum_size = Vector2(0, 40)  # ★v38変更★
	bottom_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(bottom_spacer)


func _start_experiment() -> void:
	if is_instance_valid(main_script) and main_script.has_method("open_simulation_with_preset"):
		var preset: Array = current["preset"]
		main_script.call("open_simulation_with_preset", preset)
		visible = false  # ★v33変更★ ページを消さずに隠す（研究室から同じページに戻れるように）
	else:
		error_label.text = "⚠ 実験画面を開けませんでした。main.gd が最新版か確認してね。"


# ★v35追加★ 左上の「⬅ 戻る」ボタン（問題演習の画面と位置・大きさをそろえた）
func _show_nav(action: String) -> void:
	nav_action = action
	if not is_instance_valid(nav_button):
		nav_button = _make_btn("⬅ 戻る", BLUE, Color.WHITE, 45.0)
		nav_button.custom_minimum_size = Vector2(120, 45)
		nav_button.position = Vector2(40, 40)
		nav_button.size = Vector2(120, 45)
		nav_button.pressed.connect(_on_nav_pressed)
		add_child(nav_button)
	nav_button.visible = true
	move_child(nav_button, get_child_count() - 1)


func _on_nav_pressed() -> void:
	if nav_action == "list":
		_build_list()
	else:
		_go_back()


func _go_back() -> void:
	queue_free()


# =====================================
# 図（コードで描くイラスト）
# =====================================

func _frect(parent: Control, x: float, y: float, w: float, h: float, color: Color, radius: int = 0, border_color: Color = Color(0, 0, 0, 0), border_w: int = 0) -> Panel:
	var panel := Panel.new()
	panel.position = Vector2(x, y)
	panel.size = Vector2(w, h)
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(radius)
	if border_w > 0:
		style.set_border_width_all(border_w)
		style.border_color = border_color
	panel.add_theme_stylebox_override("panel", style)
	parent.add_child(panel)
	return panel


func _fcircle(parent: Control, cx: float, cy: float, r: float, color: Color, text: String = "", font_size: int = 14, font_color: Color = Color("#1E293B")) -> Panel:
	var panel := _frect(parent, cx - r, cy - r, r * 2, r * 2, color, int(r))
	if text != "":
		var label := Label.new()
		label.text = text
		label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", font_size)
		label.add_theme_color_override("font_color", font_color)
		panel.add_child(label)
	return panel


func _flabel(parent: Control, text: String, x: float, y: float, w: float, font_size: int = 13, color: Color = TEXT_COLOR) -> Label:
	var label := Label.new()
	label.text = text
	label.position = Vector2(x, y)
	label.size = Vector2(w, 24)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	parent.add_child(label)
	return label


# ★v35追加★ 図の幅計算用にページ幅を返す
func page_w_for_figure() -> float:
	var w := size.x
	if w < 100.0:
		w = get_viewport().get_visible_rect().size.x
	return w - 120.0


func _make_figure(kind: String) -> Control:
	# ★v24変更★ CenterContainer 経由をやめ、固定サイズで直接置く（スクロール内での崩れ対策）
	var fig := Control.new()
	# ★v27変更★ 画面が狭いときは図を縮めて収める
	var fig_scale: float = clampf(minf(700.0, page_w_for_figure()) / 720.0, 0.3, 1.0)  # ★v35変更★ 内容の幅に合わせる
	fig.custom_minimum_size = Vector2(720, 250) * fig_scale
	fig.size = Vector2(720, 250)
	fig.scale = Vector2.ONE * fig_scale
	fig.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_frect(fig, 0, 0, 720, 250, WHITE, 12, Color("#E2E8F0"), 2)
	match kind:
		"electrolysis_water":
			_fig_electrolysis(fig, false)
		"electrolysis_cucl2":
			_fig_electrolysis(fig, true)
		"heating_fes":
			_fig_heating(fig, "鉄 ＋ 硫黄", true)
		"heating_cuo":
			_fig_heating(fig, "酸化銅 ＋ 炭素", false)
		"magnet":
			_fig_magnet(fig)
		"molecule":
			_fig_molecule(fig)
		"equation":
			_fig_equation(fig)
		"ion":
			_fig_ion(fig)
		"oxidation":
			_fig_oxidation(fig)
		"battery":
			_fig_battery(fig)
	return fig


func _fig_electrolysis(fig: Control, is_cucl2: bool) -> void:
	var liquid := Color("#38BDF8") if is_cucl2 else Color("#BAE6FD")
	_frect(fig, 310, 8, 100, 30, Color("#475569"), 6)
	_flabel(fig, "電源装置", 310, 12, 100, 12, WHITE)
	_frect(fig, 250, 38, 4, 44, Color("#475569"))
	_frect(fig, 466, 38, 4, 44, Color("#475569"))
	_frect(fig, 190, 82, 340, 148, Color(1, 1, 1, 0), 0, Color("#94A3B8"), 2)
	_frect(fig, 194, 112, 332, 114, liquid)
	var gas_l := 8.0 if is_cucl2 else 54.0
	var gas_r := 30.0 if is_cucl2 else 27.0
	_frect(fig, 228, 45, 64, 140, Color(1, 1, 1, 0.35), 0, Color("#64748B"), 2)
	_frect(fig, 428, 45, 64, 140, Color(1, 1, 1, 0.35), 0, Color("#64748B"), 2)
	_frect(fig, 232, 49, 56, gas_l, WHITE)
	_frect(fig, 432, 49, 56, gas_r, WHITE)
	_frect(fig, 252, 150, 16, 32, Color("#475569"))
	_frect(fig, 452, 150, 16, 32, Color("#475569"))
	if is_cucl2:
		_frect(fig, 232, 162, 56, 19, Color("#B45309"))
		_flabel(fig, "陰極（−極）：銅がつく", 130, 232, 220, 12)
		_flabel(fig, "陽極（＋極）：塩素", 380, 232, 220, 12)
	else:
		_flabel(fig, "陰極（−極）：水素", 130, 232, 220, 12)
		_flabel(fig, "陽極（＋極）：酸素", 380, 232, 220, 12)


func _fig_heating(fig: Control, powder_text: String, two_colors: bool) -> void:
	_flabel(fig, powder_text, 260, 92, 200, 15)
	if two_colors:
		_frect(fig, 285, 124, 75, 16, Color("#9CA3AF"), 6)
		_frect(fig, 360, 124, 75, 16, Color("#FDE047"), 6)
	else:
		_frect(fig, 285, 124, 150, 16, Color("#1F2937"), 6)
	_frect(fig, 270, 140, 180, 14, Color("#64748B"), 4)
	_frect(fig, 300, 154, 10, 52, Color("#94A3B8"))
	_frect(fig, 410, 154, 10, 52, Color("#94A3B8"))
	_fcircle(fig, 338, 198, 12, Color("#FDBA74"))
	_fcircle(fig, 362, 192, 16, Color("#F97316"))
	_fcircle(fig, 386, 198, 12, Color("#FDBA74"))
	_frect(fig, 330, 224, 64, 10, Color("#475569"), 3)
	_flabel(fig, "加熱", 320, 200, 90, 12, Color("#DC2626"))


func _fig_magnet(fig: Control) -> void:
	_frect(fig, 250, 55, 110, 42, Color("#EF4444"), 4)
	_frect(fig, 360, 55, 110, 42, Color("#3B82F6"), 4)
	_flabel(fig, "N", 250, 64, 110, 18, WHITE)
	_flabel(fig, "S", 360, 64, 110, 18, WHITE)
	_fcircle(fig, 250, 175, 27, Color("#9CA3AF"), "鉄", 15)
	_fcircle(fig, 470, 175, 27, Color("#374151"), "硫化鉄", 11, WHITE)
	_flabel(fig, "磁石につく", 160, 212, 180, 13, Color("#059669"))
	_flabel(fig, "磁石につかない", 380, 212, 180, 13, Color("#DC2626"))


func _fig_molecule(fig: Control) -> void:
	_fcircle(fig, 312, 100, 25, Color("#BFDBFE"), "H", 17)
	_fcircle(fig, 408, 100, 25, Color("#BFDBFE"), "H", 17)
	_fcircle(fig, 360, 148, 37, Color("#FCA5A5"), "O", 21)
	_flabel(fig, "水の分子 H₂O", 260, 205, 200, 14)


func _fig_equation(fig: Control) -> void:
	_fcircle(fig, 102, 95, 20, Color("#BFDBFE"), "H", 14)
	_fcircle(fig, 140, 95, 20, Color("#BFDBFE"), "H", 14)
	_fcircle(fig, 102, 165, 20, Color("#BFDBFE"), "H", 14)
	_fcircle(fig, 140, 165, 20, Color("#BFDBFE"), "H", 14)
	_flabel(fig, "＋", 168, 105, 36, 24, TEXT_COLOR)
	_fcircle(fig, 238, 130, 20, Color("#FCA5A5"), "O", 14)
	_fcircle(fig, 276, 130, 20, Color("#FCA5A5"), "O", 14)
	_flabel(fig, "→", 310, 112, 60, 32, BLUE)
	_fcircle(fig, 428, 100, 15, Color("#BFDBFE"), "H", 11)
	_fcircle(fig, 472, 100, 15, Color("#BFDBFE"), "H", 11)
	_fcircle(fig, 450, 128, 22, Color("#FCA5A5"), "O", 15)
	_fcircle(fig, 548, 100, 15, Color("#BFDBFE"), "H", 11)
	_fcircle(fig, 592, 100, 15, Color("#BFDBFE"), "H", 11)
	_fcircle(fig, 570, 128, 22, Color("#FCA5A5"), "O", 15)
	_flabel(fig, "2H₂ ＋ O₂ → 2H₂O", 210, 200, 300, 16)


func _fig_ion(fig: Control) -> void:
	for row in range(3):
		for col in range(6):
			var cx := 175.0 + col * 74.0
			var cy := 62.0 + row * 62.0
			if (row + col) % 2 == 0:
				_fcircle(fig, cx, cy, 24, Color("#FDE68A"), "Na⁺", 12)
			else:
				_fcircle(fig, cx, cy, 24, Color("#BBF7D0"), "Cl⁻", 12)
	_flabel(fig, "＋のイオンと−のイオンが、引き合って規則正しく並ぶ", 160, 218, 400, 12, SUB_COLOR)


func _fig_oxidation(fig: Control) -> void:
	_flabel(fig, "銅", 215, 88, 130, 14)
	_flabel(fig, "酸化銅（黒）", 375, 88, 160, 14)
	_frect(fig, 190, 118, 170, 24, Color("#D97706"))
	_frect(fig, 360, 118, 170, 24, Color("#1F2937"))
	_frect(fig, 220, 142, 10, 56, Color("#94A3B8"))
	_frect(fig, 490, 142, 10, 56, Color("#94A3B8"))
	_fcircle(fig, 338, 192, 12, Color("#FDBA74"))
	_fcircle(fig, 362, 186, 16, Color("#F97316"))
	_fcircle(fig, 386, 192, 12, Color("#FDBA74"))
	_frect(fig, 330, 218, 64, 10, Color("#475569"), 3)


func _fig_battery(fig: Control) -> void:
	_frect(fig, 302, 60, 4, 42, Color("#475569"))
	_frect(fig, 414, 60, 4, 42, Color("#475569"))
	_frect(fig, 302, 58, 116, 4, Color("#475569"))
	_fcircle(fig, 360, 40, 17, Color("#FDE047"), "", 12)
	_flabel(fig, "ランプ", 388, 30, 80, 13)
	_frect(fig, 240, 102, 240, 118, Color(1, 1, 1, 0), 0, Color("#94A3B8"), 2)
	_frect(fig, 244, 132, 232, 84, Color("#E0F2FE"))
	_frect(fig, 292, 112, 26, 96, Color("#9CA3AF"))
	_frect(fig, 402, 112, 26, 96, Color("#D97706"))
	_flabel(fig, "−極", 258, 224, 90, 13)
	_flabel(fig, "＋極", 372, 224, 90, 13)
