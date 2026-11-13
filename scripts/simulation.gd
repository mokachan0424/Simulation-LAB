extends Control

class_name SimulationPage

# Godot 4.x
# 原子を追加・ドラッグし、近づけた原子を結合線で表示する学習用シミュレーション。
# 原子の距離と個数による簡易モデルであり、実際の化学反応や生成条件を再現するものではありません。

const ATOM_COLORS := {
	"H": Color("#dbeafe"),
	"O": Color("#fee2e2"),
	"C": Color("#e5e7eb"),
	"N": Color("#ede9fe"),
	"Na": Color("#fef3c7"),
	"Cl": Color("#dcfce7"),
	"Cu": Color("#cffafe"),
	"Fe": Color("#fed7aa"),
	"S": Color("#fef9c3"),
	"Li": Color("#fce7f3"),
	"K": Color("#e9d5ff"),
	"Be": Color("#ccfbf1"),
	"Mg": Color("#ffedd5"),
	"Ca": Color("#fde68a"),
	"B": Color("#d9f99d"),
	"Al": Color("#e0e7ff"),
	"Si": Color("#cbd5e1"),
	"P": Color("#fca5a5"),
	"F": Color("#bbf7d0"),
	"He": Color("#fbcfe8"),
	"Ar": Color("#a5f3fc")
}

const ELEMENTS := [
	{"symbol": "H", "name": "水素"},
	{"symbol": "O", "name": "酸素"},
	{"symbol": "C", "name": "炭素"},
	{"symbol": "N", "name": "窒素"},
	{"symbol": "Na", "name": "ナトリウム"},
	{"symbol": "Cl", "name": "塩素"},
	{"symbol": "Cu", "name": "銅"},
	{"symbol": "Fe", "name": "鉄"},
	{"symbol": "S", "name": "硫黄"},
	{"symbol": "Li", "name": "リチウム"},
	{"symbol": "K", "name": "カリウム"},
	{"symbol": "Be", "name": "ベリリウム"},
	{"symbol": "Mg", "name": "マグネシウム"},
	{"symbol": "Ca", "name": "カルシウム"},
	{"symbol": "B", "name": "ホウ素"},
	{"symbol": "Al", "name": "アルミニウム"},
	{"symbol": "Si", "name": "ケイ素"},
	{"symbol": "P", "name": "リン"},
	{"symbol": "F", "name": "フッ素"},
	{"symbol": "He", "name": "ヘリウム"},
	{"symbol": "Ar", "name": "アルゴン"}
]

# counts は学習用の組成モデル。実際に生成できることを示すものではありません。
const SUBSTANCES := [
	{
		"counts": {"H": 2, "O": 1},
		"formula": "H₂O",
		"name": "水",
		"kind": "分子モデル",
		"explanation": "水素原子2個と酸素原子1個からなる水の組成モデルです。",
		"hazard": "水は身近な物質です。",
		"art": "water"
	},
	{
		"counts": {"C": 1, "O": 2},
		"formula": "CO₂",
		"name": "二酸化炭素",
		"kind": "分子モデル",
		"explanation": "炭素原子1個と酸素原子2個からなる分子モデルです。",
		"hazard": "高濃度では酸素不足を起こす危険があります。",
		"art": "co2"
	},
	{
		"counts": {"O": 2},
		"formula": "O₂",
		"name": "酸素",
		"kind": "分子モデル",
		"explanation": "酸素原子2個が結びついた分子モデルです。",
		"hazard": "酸素は燃焼を激しくする性質があります。",
		"art": "oxygen"
	},
	{
		"counts": {"N": 2},
		"formula": "N₂",
		"name": "窒素",
		"kind": "分子モデル",
		"explanation": "空気の約78%を占める気体の分子モデルです。",
		"hazard": "高濃度では酸素不足を起こす危険があります。",
		"art": "nitrogen"
	},
	{
		"counts": {"N": 1, "H": 3},
		"formula": "NH₃",
		"name": "アンモニア",
		"kind": "分子モデル",
		"explanation": "窒素原子1個と水素原子3個からなる分子モデルです。",
		"hazard": "刺激性・腐食性があり、吸い込むと危険です。",
		"art": "ammonia"
	},
	{
		"counts": {"C": 1, "H": 4},
		"formula": "CH₄",
		"name": "メタン",
		"kind": "分子モデル",
		"explanation": "炭素原子1個と水素原子4個からなる分子モデルです。",
		"hazard": "可燃性の気体です。火気を近づけてはいけません。",
		"art": "methane"
	},
	{
		"counts": {"Na": 1, "Cl": 1},
		"formula": "NaCl",
		"name": "塩化ナトリウム",
		"kind": "イオン結晶の組成モデル",
		"explanation": "ナトリウムイオンと塩化物イオンが1対1で並ぶ食塩の組成モデルです。",
		"hazard": "原子を置くだけで食塩が生成するわけではありません。",
		"art": "salt"
	},
	{
		"counts": {"H": 1, "Cl": 1},
		"formula": "HCl",
		"name": "塩化水素",
		"kind": "分子モデル",
		"explanation": "水に溶けると塩酸になる物質の分子モデルです。",
		"hazard": "刺激性・腐食性があります。",
		"art": "hcl"
	},
	{
		"counts": {"H": 2},
		"formula": "H₂",
		"name": "水素",
		"kind": "分子モデル",
		"explanation": "水素原子2個が結びついた分子です。",
		"hazard": "燃えやすい気体です。",
		"art": "molecule"
	},
	{
		"counts": {"Cl": 2},
		"formula": "Cl₂",
		"name": "塩素",
		"kind": "分子モデル",
		"explanation": "塩素原子2個からなる分子です。",
		"hazard": "有毒で、吸い込むと危険です。",
		"art": "molecule"
	},
	{
		"counts": {"H": 2, "O": 2},
		"formula": "H₂O₂",
		"name": "過酸化水素",
		"kind": "分子モデル",
		"explanation": "水素原子2個と酸素原子2個からなる物質です。",
		"hazard": "濃度によっては皮膚や目を傷つけます。",
		"art": "molecule"
	},
	{
		"counts": {"S": 1, "O": 2},
		"formula": "SO₂",
		"name": "二酸化硫黄",
		"kind": "分子モデル",
		"explanation": "硫黄原子1個と酸素原子2個からなる分子です。",
		"hazard": "刺激性のある有毒な気体です。",
		"art": "molecule"
	},
	{
		"counts": {"S": 1, "O": 3},
		"formula": "SO₃",
		"name": "三酸化硫黄",
		"kind": "分子モデル",
		"explanation": "硫黄原子1個と酸素原子3個からなる物質です。",
		"hazard": "水と反応し、強い腐食性を示します。",
		"art": "molecule"
	},
	{
		"counts": {"N": 1, "O": 2},
		"formula": "NO₂",
		"name": "二酸化窒素",
		"kind": "分子モデル",
		"explanation": "窒素原子1個と酸素原子2個からなる分子です。",
		"hazard": "有毒で、呼吸器に悪影響を与えます。",
		"art": "molecule"
	},
	{
		"counts": {"C": 1, "O": 1},
		"formula": "CO",
		"name": "一酸化炭素",
		"kind": "分子モデル",
		"explanation": "炭素原子1個と酸素原子1個からなる分子です。",
		"hazard": "非常に危険な有毒ガスです。無色・無臭です。",
		"art": "molecule"
	},
	{
		"counts": {"S": 8},
		"formula": "S₈",
		"name": "硫黄分子",
		"kind": "分子モデル",
		"explanation": "硫黄原子8個が環状につながった分子です。",
		"hazard": "実際の取り扱いには適切な安全管理が必要です。",
		"art": "molecule"
	},
	{
		"counts": {"Fe": 1, "S": 1},
		"formula": "FeS",
		"name": "硫化鉄",
		"kind": "化合物モデル",
		"explanation": "鉄原子1個と硫黄原子1個からなる化合物のモデルです。鉄と硫黄を加熱するとできます。",
		"hazard": "塩酸と反応すると、腐卵臭のある硫化水素が発生します。",
		"art": "molecule"
	},
	{
		"counts": {"Cu": 1, "Cl": 2},
		"formula": "CuCl₂",
		"name": "塩化銅",
		"kind": "イオン結晶の組成モデル",
		"explanation": "銅イオンと塩化物イオンからなる物質の組成モデルです。水溶液は青色です。",
		"hazard": "電気分解すると、陰極に銅、陽極に塩素が発生します。",
		"art": "molecule"
	},
	{
		"counts": {"Cu": 1, "O": 1},
		"formula": "CuO",
		"name": "酸化銅",
		"kind": "化合物モデル",
		"explanation": "銅原子1個と酸素原子1個からなる化合物のモデルです。銅を加熱するとできます。",
		"hazard": "炭素と加熱すると、還元されて銅に戻ります。",
		"art": "molecule"
	},
	{
		"counts": {"Na": 1, "O": 1, "H": 1},
		"formula": "NaOH",
		"name": "水酸化ナトリウム",
		"kind": "化合物モデル",
		"explanation": "ナトリウムが水と反応してできる強いアルカリ性の物質の組成モデルです。",
		"hazard": "強いアルカリ性で、さわると危険です。",
		"art": "molecule"
	},
	{
		"counts": {"Li": 1, "O": 1, "H": 1},
		"formula": "LiOH",
		"name": "水酸化リチウム",
		"kind": "化合物モデル",
		"explanation": "リチウムが水と反応してできる水酸化物の組成モデルです。",
		"hazard": "アルカリ性で、さわると危険です。",
		"art": "molecule"
	},
	{
		"counts": {"K": 1, "O": 1, "H": 1},
		"formula": "KOH",
		"name": "水酸化カリウム",
		"kind": "化合物モデル",
		"explanation": "カリウムが水と反応してできる強いアルカリ性の物質の組成モデルです。",
		"hazard": "強いアルカリ性で、さわると危険です。",
		"art": "molecule"
	},
	{
		"counts": {"Be": 1, "Cl": 2},
		"formula": "BeCl₂",
		"name": "塩化ベリリウム",
		"kind": "化合物モデル",
		"explanation": "ベリリウムと塩酸の反応でできる化合物の組成モデルです。",
		"hazard": "ベリリウムの化合物には毒性があります。",
		"art": "molecule"
	},
	{
		"counts": {"Mg": 1, "O": 1},
		"formula": "MgO",
		"name": "酸化マグネシウム",
		"kind": "化合物モデル",
		"explanation": "マグネシウムが燃えてできる白い粉の組成モデルです。",
		"hazard": "燃えるときの強い光を直接見てはいけません。",
		"art": "molecule"
	},
	{
		"counts": {"Ca": 1, "O": 1},
		"formula": "CaO",
		"name": "酸化カルシウム",
		"kind": "化合物モデル",
		"explanation": "カルシウムを加熱してできる物質（生石灰）の組成モデルです。",
		"hazard": "水と反応して熱を出します。",
		"art": "molecule"
	},
	{
		"counts": {"Ca": 1, "O": 2, "H": 2},
		"formula": "Ca(OH)₂",
		"name": "水酸化カルシウム",
		"kind": "化合物モデル",
		"explanation": "石灰水の成分（消石灰）の組成モデルです。二酸化炭素で白くにごります。",
		"hazard": "目に入ると危険です。",
		"art": "molecule"
	},
	{
		"counts": {"B": 2, "O": 3},
		"formula": "B₂O₃",
		"name": "酸化ホウ素",
		"kind": "化合物モデル",
		"explanation": "ホウ素が酸素と結びついた化合物の組成モデルです。",
		"hazard": "粉を吸い込むと体に悪いです。",
		"art": "molecule"
	},
	{
		"counts": {"Al": 2, "O": 3},
		"formula": "Al₂O₃",
		"name": "酸化アルミニウム",
		"kind": "化合物モデル",
		"explanation": "アルミニウムの表面をおおう酸化物（アルミナ）の組成モデルです。",
		"hazard": "粉じんは火災の危険があります。",
		"art": "molecule"
	},
	{
		"counts": {"Si": 1, "O": 2},
		"formula": "SiO₂",
		"name": "二酸化ケイ素",
		"kind": "化合物モデル",
		"explanation": "ガラスや水晶の主成分の組成モデルです。",
		"hazard": "細かい粉を吸い込むと呼吸器に悪いです。",
		"art": "molecule"
	},
	{
		"counts": {"P": 2, "O": 5},
		"formula": "P₂O₅",
		"name": "五酸化二リン",
		"kind": "化合物モデル",
		"explanation": "リンが燃えてできる白い煙の成分の組成モデルです。",
		"hazard": "水と激しく反応します。",
		"art": "molecule"
	},
	{
		"counts": {"H": 1, "F": 1},
		"formula": "HF",
		"name": "フッ化水素",
		"kind": "化合物モデル",
		"explanation": "水素とフッ素が結びついた化合物の組成モデルです。",
		"hazard": "非常に強い毒性と腐食性があります。",
		"art": "molecule"
	},
	{
		"counts": {"Fe": 2, "O": 3},
		"formula": "Fe₂O₃",
		"name": "酸化鉄（III）",
		"kind": "化合物モデル",
		"explanation": "鉄のさび（赤さび）の主成分の組成モデルです。",
		"hazard": "粉を吸い込むと体に悪いです。",
		"art": "molecule"
	},
	{
		"counts": {"Fe": 1, "O": 1},
		"formula": "FeO",
		"name": "酸化鉄（II）",
		"kind": "化合物モデル",
		"explanation": "鉄と酸素が1対1で結びついた化合物の組成モデルです。",
		"hazard": "粉を吸い込むと体に悪いです。",
		"art": "molecule"
	},
	{
		"counts": {"Fe": 1, "Cl": 2},
		"formula": "FeCl₂",
		"name": "塩化鉄（II）",
		"kind": "化合物モデル",
		"explanation": "鉄が塩酸に溶けてできる化合物の組成モデルです。",
		"hazard": "目に入ると危険です。",
		"art": "molecule"
	},
	{
		"counts": {"H": 2, "S": 1},
		"formula": "H₂S",
		"name": "硫化水素",
		"kind": "化合物モデル",
		"explanation": "温泉地などで出る、腐った卵のようなにおいの気体の組成モデルです。",
		"hazard": "有毒な気体です。大量に吸うと危険です。",
		"art": "molecule"
	},
	{
		"counts": {"O": 3},
		"formula": "O₃",
		"name": "オゾン",
		"kind": "分子モデル",
		"explanation": "酸素原子3個が結びついた分子モデルです。空気の殺菌などに使われます。",
		"hazard": "高濃度では呼吸器に悪いです。",
		"art": "molecule"
	},
	{
		"counts": {"N": 1, "O": 1},
		"formula": "NO",
		"name": "一酸化窒素",
		"kind": "分子モデル",
		"explanation": "窒素と酸素が1個ずつ結びついた分子モデルです。空気にふれると二酸化窒素になります。",
		"hazard": "有毒な気体です。",
		"art": "molecule"
	},
	{
		"counts": {"Ca": 1, "C": 1, "O": 3},
		"formula": "CaCO₃",
		"name": "炭酸カルシウム",
		"kind": "化合物モデル",
		"explanation": "石灰石や貝殻、チョークの主成分の組成モデルです。",
		"hazard": "粉を吸い込むと体に悪いです。",
		"art": "molecule"
	},
	{
		"counts": {"Na": 1, "H": 1, "C": 1, "O": 3},
		"formula": "NaHCO₃",
		"name": "炭酸水素ナトリウム",
		"kind": "化合物モデル",
		"explanation": "重そう（ふくらし粉）の成分の組成モデルです。加熱すると二酸化炭素を出して分解します。",
		"hazard": "目に入ると危険です。",
		"art": "molecule"
	},
	{
		"counts": {"Na": 2, "C": 1, "O": 3},
		"formula": "Na₂CO₃",
		"name": "炭酸ナトリウム",
		"kind": "化合物モデル",
		"explanation": "炭酸水素ナトリウムを加熱するとできる物質の組成モデルです。ガラスの原料にもなります。",
		"hazard": "強いアルカリ性で、さわると危険です。",
		"art": "molecule"
	},
	{
		"counts": {"H": 2, "S": 1, "O": 4},
		"formula": "H₂SO₄",
		"name": "硫酸",
		"kind": "化合物モデル",
		"explanation": "代表的な強い酸の組成モデルです。自動車のバッテリーにも使われます。",
		"hazard": "非常に強い酸です。さわると大やけどをします。",
		"art": "molecule"
	},
	{
		"counts": {"H": 1, "N": 1, "O": 3},
		"formula": "HNO₃",
		"name": "硝酸",
		"kind": "化合物モデル",
		"explanation": "代表的な強い酸の組成モデルです。肥料の原料にもなります。",
		"hazard": "非常に強い酸です。さわると危険です。",
		"art": "molecule"
	},
	{
		"counts": {"Cu": 1, "S": 1, "O": 4},
		"formula": "CuSO₄",
		"name": "硫酸銅",
		"kind": "化合物モデル",
		"explanation": "青い水溶液で知られる化合物の組成モデルです。電気分解の実験に使われます。",
		"hazard": "有毒です。飲み込むと危険です。",
		"art": "molecule"
	},
	{
		"counts": {"Ca": 1, "Cl": 2},
		"formula": "CaCl₂",
		"name": "塩化カルシウム",
		"kind": "化合物モデル",
		"explanation": "乾燥剤や融雪剤に使われる化合物の組成モデルです。",
		"hazard": "目に入ると危険です。",
		"art": "molecule"
	},
	{
		"counts": {"Mg": 1, "Cl": 2},
		"formula": "MgCl₂",
		"name": "塩化マグネシウム",
		"kind": "化合物モデル",
		"explanation": "豆腐を固める「にがり」の主成分の組成モデルです。",
		"hazard": "目に入ると危険です。",
		"art": "molecule"
	},
	{
		"counts": {"Al": 1, "Cl": 3},
		"formula": "AlCl₃",
		"name": "塩化アルミニウム",
		"kind": "化合物モデル",
		"explanation": "アルミニウムと塩素が結びついた化合物の組成モデルです。",
		"hazard": "水と反応して塩化水素を出します。",
		"art": "molecule"
	},
	{
		"counts": {"N": 1, "H": 4, "Cl": 1},
		"formula": "NH₄Cl",
		"name": "塩化アンモニウム",
		"kind": "化合物モデル",
		"explanation": "アンモニアと塩化水素の白い煙の実験でできる物質の組成モデルです。",
		"hazard": "目に入ると危険です。",
		"art": "molecule"
	},
	{
		"counts": {"Na": 2, "O": 1},
		"formula": "Na₂O",
		"name": "酸化ナトリウム",
		"kind": "化合物モデル",
		"explanation": "ナトリウムが酸素と結びついた化合物の組成モデルです。",
		"hazard": "水と激しく反応します。",
		"art": "molecule"
	},
	{
		"counts": {"K": 2, "O": 1},
		"formula": "K₂O",
		"name": "酸化カリウム",
		"kind": "化合物モデル",
		"explanation": "カリウムが酸素と結びついた化合物の組成モデルです。",
		"hazard": "水と激しく反応します。",
		"art": "molecule"
	},
	{
		"counts": {"Li": 2, "O": 1},
		"formula": "Li₂O",
		"name": "酸化リチウム",
		"kind": "化合物モデル",
		"explanation": "リチウムが酸素と結びついた化合物の組成モデルです。",
		"hazard": "水と反応して熱を出します。",
		"art": "molecule"
	},
	{
		"counts": {"C": 2, "H": 6, "O": 1},
		"formula": "C₂H₅OH",
		"name": "エタノール",
		"kind": "化合物モデル",
		"explanation": "アルコールランプの燃料としておなじみの物質の組成モデルです。",
		"hazard": "燃えやすい液体です。火に注意してください。",
		"art": "molecule"
	}
]

# 16×16の小さなドット絵。記号ごとに色を割り当て、実行時にTextureを作ります。
const PIXEL_ART := {
	"water": [
		".......BB.......",
		"......BBBB......",
		".....BBBBBB.....",
		"....BBBBBBBB....",
		"...BBBBBBBBBB...",
		"..BBBBBBBBBBBB..",
		"..BBBBBBBBBBBB..",
		".BBBBBBBBBBBBBB.",
		".BBBBBBBBBBBBBB.",
		".BBBBBBBBBBBBBB.",
		".BBBBBBBBBBBBBB.",
		"..BBBBBBBBBBBB..",
		"...BBBBBBBBBB...",
		"....BBBBBBBB....",
		".....BBBBBB.....",
		"......BBBB......"
	],
	"co2": [
		"................",
		"......GG........",
		".....GGGG.......",
		"...GGGGGGGG.....",
		"..GGGGGGGGGG....",
		".GGGGGGGGGGGG...",
		".GGGGGGGGGGGG...",
		"GGGGGGGGGGGGGG..",
		"GGGGGGGGGGGGGG..",
		".GGGGGGGGGGGG...",
		".GGGGGGGGGGGG...",
		"..GGGGGGGGGG....",
		"...GGGGGGGG.....",
		".....GGGG.......",
		"................",
		"................"
	],
	"oxygen": [
		"................",
		".....RRRR.......",
		"...RRRRRRRR.....",
		"..RRRRRRRRRR....",
		".RRRRRRRRRRRR...",
		".RRRRRRRRRRRR...",
		"..RRRRRRRRRR....",
		"...RRRRRRRR.....",
		".....RRRR.......",
		".......RRRR.....",
		".....RRRRRRRR...",
		"....RRRRRRRRRR..",
		"...RRRRRRRRRRRR.",
		"...RRRRRRRRRRRR.",
		"....RRRRRRRRRR..",
		"......RRRRRR...."
	],
	"nitrogen": [
		"................",
		"....PP....PP....",
		"...PPPP..PPPP...",
		"..PPPPPPPPPPPP..",
		".PPPPPPPPPPPPPP.",
		".PPPPPPPPPPPPPP.",
		"..PPPPPPPPPPPP..",
		"...PPPPPPPPPP...",
		"....PPPPPPPP....",
		".....PPPPPP.....",
		"......PPPP......",
		".....PPPPPP.....",
		"....PPPPPPPP....",
		"...PPPP..PPPP...",
		"................",
		"................"
	],
	"ammonia": [
		"................",
		".....WWWW.......",
		"...WWWWWWWW.....",
		"..WWWWWWWWWW....",
		".WWWWWWWWWWWW...",
		".WWWWWWWWWWWW...",
		"WWWWWWWWWWWWWW..",
		"WWWWWWWWWWWWWW..",
		".WWWWWWWWWWWW...",
		"..WWWWWWWWWW....",
		"...WWWWWWWW.....",
		".....WWWW.......",
		"................",
		"................",
		"................",
		"................"
	],
	"methane": [
		".......YY.......",
		"......YYYY......",
		".....YYYYYY.....",
		".....YYYYYY.....",
		"....YYYYYYYY....",
		"....YYYYYYYY....",
		"...YYYYYYYYYY...",
		"...YYYYYYYYYY...",
		"..YYYYYYYYYYYY..",
		"..YYYYYYYYYYYY..",
		"...YYYYYYYYYY...",
		"....YYYYYYYY....",
		".....YYYYYY.....",
		"......YYYY......",
		".......YY.......",
		"................"
	],
	"salt": [
		"................",
		"....LLLL........",
		"...LLLLLL.......",
		"..LLLLLLLL......",
		"...LLLLLL.......",
		"....LLLL........",
		"...........LLLL.",
		"..........LLLLLL",
		".........LLLLLLL",
		"..........LLLLLL",
		"...........LLLL.",
		"................",
		"...LLLL.........",
		"..LLLLLL........",
		"...LLLL.........",
		"................"
	],
	"hcl": [
		"................",
		"...CCCC.........",
		"..CCCCCC........",
		".CCCCCCCC.......",
		"CCCCCCCCCC......",
		"CCCCCCCCCC......",
		".CCCCCCCC.......",
		"..CCCCCC........",
		"...CCCC.........",
		".........CCCC...",
		"........CCCCCC..",
		".......CCCCCCCC.",
		"......CCCCCCCCCC",
		"......CCCCCCCCCC",
		".......CCCCCCCC.",
		"........CCCCCC.."
	],
	"molecule": [
		"................",
		"....BBBB........",
		"...BBBBBB.......",
		"...BBBBBB.......",
		"....BBBB........",
		"......GGGG......",
		"........GGGG....",
		".......GGGGGG...",
		".......GGGGGG...",
		"........GGGG....",
		"............RR..",
		"...........RRRR.",
		"...........RRRR.",
		"............RR..",
		"................",
		"................"
	]
}

const PIXEL_COLORS := {
	"B": Color("#38bdf8"),
	"G": Color("#94a3b8"),
	"R": Color("#f87171"),
	"P": Color("#a78bfa"),
	"W": Color("#c4b5fd"),
	"Y": Color("#facc15"),
	"L": Color("#f8fafc"),
	"C": Color("#cbd5e1")
}

var atom_layer: Control
var result_label: Label
var result_detail: Label
var count_label: Label
var result_art: TextureRect
var from_textbook := false  # ★v33追加★ 教科書から開いたかどうか
var return_target := ""  # ★v42追加★ 戻り先 "" / "textbook" / "encyclopedia"
var textbook_button: Button  # ★v33追加★ 「教科書に戻る」ボタン

var _atoms: Array[Dictionary] = []
var _dragging_atom: Control
var _atom_serial := 0
var _bond_lines: Dictionary = {}

const BOND_DISTANCE := 110.0
const BASE_LAYOUT_SIZE := Vector2(1150.0, 700.0)

var _layout_root: Control
var guide_panel: Panel
var guide_scroll: ScrollContainer  # ★v39追加★
var guide_body: Label  # ★v39追加★
var guide_close_button: Button  # ★v39追加★
var guide_drag_bar: Control  # ★v39追加★ 移動用バー
var guide_handle: Control  # ★v39追加★ 大きさ変更ハンドル
var guide_hint: Label  # ★v39追加★
var guide_dragging := false  # ★v39追加★
var guide_resizing := false  # ★v39追加★


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_ui()
	_update_layout()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED and is_instance_valid(_layout_root):
		_update_layout()


func _update_layout() -> void:
	var viewport_size := get_viewport_rect().size
	var scale_factor := maxf(
		0.1,
		minf(
			viewport_size.x / BASE_LAYOUT_SIZE.x,
			viewport_size.y / BASE_LAYOUT_SIZE.y
		)
	)
	_layout_root.scale = Vector2.ONE * scale_factor
	_layout_root.position = (viewport_size - BASE_LAYOUT_SIZE * scale_factor) / 2.0


func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#e0f2fe")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	_layout_root = Control.new()
	add_child(_layout_root)

	var title := Label.new()
	title.text = "🧪 自由実験シミュレーション"
	title.position = Vector2(280, 14)
	title.size = Vector2(650, 42)
	title.add_theme_font_size_override("font_size", 29)
	title.add_theme_color_override("font_color", Color("#075985"))
	_layout_root.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "原子を追加して近づけよう。線でつながった原子の組み合わせを調べます。"
	subtitle.position = Vector2(280, 57)
	subtitle.size = Vector2(850, 25)
	subtitle.add_theme_font_size_override("font_size", 15)
	subtitle.add_theme_color_override("font_color", Color("#0369a1"))
	_layout_root.add_child(subtitle)

	var palette := _make_panel(Vector2(25, 85), Vector2(245, 540), Color("#ffffff"))  # ★v44変更★ 元素が増えたので幅を広げた
	_layout_root.add_child(palette)

	palette.add_child(_make_label("原子を追加", Vector2(15, 12), Vector2(215, 30), 20, Color("#075985")))
	palette.add_child(_make_label("ボタンを押すと中央に追加", Vector2(15, 43), Vector2(215, 35), 12, Color("#64748b")))

	var grid := GridContainer.new()
	grid.columns = 3  # ★v44変更★ 21元素を3列で表示
	grid.position = Vector2(12, 74)
	grid.size = Vector2(221, 371)
	grid.add_theme_constant_override("h_separation", 7)
	grid.add_theme_constant_override("v_separation", 6)
	palette.add_child(grid)

	for element in ELEMENTS:
		var symbol: String = element["symbol"]
		var atom_button := Button.new()
		atom_button.text = symbol + "\n" + element["name"]
		atom_button.custom_minimum_size = Vector2(69, 47)
		atom_button.add_theme_font_size_override("font_size", 12)
		atom_button.add_theme_color_override("font_color", Color("#1e293b"))
		var style := StyleBoxFlat.new()
		style.bg_color = ATOM_COLORS[symbol]
		style.set_corner_radius_all(9)
		atom_button.add_theme_stylebox_override("normal", style)
		atom_button.add_theme_stylebox_override("hover", style)
		atom_button.pressed.connect(_add_atom.bind(symbol))
		grid.add_child(atom_button)

	var clear_button := Button.new()
	clear_button.text = "原子をすべて消す"
	clear_button.position = Vector2(12, 458)
	clear_button.size = Vector2(221, 38)
	clear_button.pressed.connect(_clear_atoms)
	palette.add_child(clear_button)

	var workspace := _make_panel(Vector2(285, 85), Vector2(530, 540), Color("#f8fdff"))  # ★v44変更★
	_layout_root.add_child(workspace)

	workspace.add_child(_make_label("実験スペース", Vector2(15, 10), Vector2(250, 28), 19, Color("#075985")))
	workspace.add_child(_make_label("原子同士を近づけると結合線が表示されます", Vector2(15, 38), Vector2(440, 22), 12, Color("#64748b")))

	atom_layer = Control.new()
	atom_layer.position = Vector2(10, 68)
	atom_layer.size = Vector2(510, 375)
	atom_layer.clip_contents = true
	workspace.add_child(atom_layer)

	var result_panel := _make_panel(Vector2(830, 85), Vector2(285, 540), Color("#ffffff"))  # ★v44変更★
	_layout_root.add_child(result_panel)

	result_panel.add_child(_make_label("シミュレーション結果", Vector2(15, 12), Vector2(255, 30), 19, Color("#075985")))

	count_label = _make_label("配置した原子：0個", Vector2(15, 48), Vector2(255, 22), 14, Color("#334155"))
	result_panel.add_child(count_label)

	result_art = TextureRect.new()
	result_art.position = Vector2(88, 76)
	result_art.size = Vector2(110, 110)
	result_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	result_art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	result_art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	result_panel.add_child(result_art)

	result_label = _make_label("原子を追加してみよう！", Vector2(15, 192), Vector2(255, 48), 19, Color("#0369a1"))
	result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	result_panel.add_child(result_label)

	# ★v49変更★ 説明文はスクロールできる入れ物に入れる（長い文章がボタンに被らないように）
	var detail_scroll := ScrollContainer.new()
	detail_scroll.position = Vector2(15, 246)
	detail_scroll.size = Vector2(255, 150)
	detail_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	detail_scroll.scroll_vertical_custom_step = 25.0
	result_panel.add_child(detail_scroll)

	result_detail = _make_label(
		"",
		Vector2.ZERO,
		Vector2(238, 30),
		13,
		Color("#334155")
	)
	result_detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_scroll.add_child(result_detail)
	_set_result_detail("原子を近づけて線でつないだら、\n「組み合わせを調べる」を押そう。")

	var analyze_button := Button.new()
	analyze_button.text = "組み合わせを調べる"
	analyze_button.position = Vector2(15, 404)
	analyze_button.size = Vector2(255, 40)
	analyze_button.add_theme_font_size_override("font_size", 16)
	analyze_button.pressed.connect(_analyze_atoms)
	result_panel.add_child(analyze_button)

	var reset_button := Button.new()
	reset_button.text = "結果をリセット"
	reset_button.position = Vector2(15, 450)
	reset_button.size = Vector2(255, 26)
	reset_button.pressed.connect(_reset_result)
	result_panel.add_child(reset_button)

	# ★v33追加★ 教科書から来たときだけ出す「教科書に戻る」ボタン
	textbook_button = Button.new()
	textbook_button.text = "📖 教科書に戻る"
	textbook_button.position = Vector2(15, 482)
	textbook_button.size = Vector2(255, 44)
	textbook_button.add_theme_font_size_override("font_size", 16)
	textbook_button.pressed.connect(_go_back_to_textbook)
	textbook_button.visible = from_textbook
	result_panel.add_child(textbook_button)

	var back_button := Button.new()
	back_button.text = "↩ メニューに戻る"
	back_button.position = Vector2(25, 20)
	back_button.size = Vector2(180, 45)
	back_button.pressed.connect(_go_back_to_menu)
	_layout_root.add_child(back_button)

	# ★v20追加★ 手順書ボタン
	var guide_button := Button.new()
	guide_button.text = "📖 手順書"
	guide_button.position = Vector2(955, 16)
	guide_button.size = Vector2(170, 44)
	guide_button.add_theme_font_size_override("font_size", 16)
	guide_button.pressed.connect(_toggle_guide)
	_layout_root.add_child(guide_button)

	var safety_note := Label.new()
	safety_note.text = "※学習用の簡易モデルです。実際の反応・生成条件・危険性を原子の個数や距離だけで判定するものではありません。"
	safety_note.position = Vector2(30, 650)
	safety_note.size = Vector2(875, 48)
	safety_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	safety_note.add_theme_font_size_override("font_size", 12)
	safety_note.add_theme_color_override("font_color", Color("#475569"))
	_layout_root.add_child(safety_note)

	# ★v20追加★ 手順書パネル（最初は隠しておく）
	_build_guide()


# ★v20追加★ 教科書風の手順書パネルを作る
func _build_guide() -> void:
	guide_panel = _make_panel(Vector2(170, 80), Vector2(810, 560), Color("#ffffff"))
	guide_panel.z_index = 10
	guide_panel.visible = false
	_layout_root.add_child(guide_panel)

	guide_panel.add_child(_make_label("📖 実験の手順書", Vector2(20, 14), Vector2(400, 34), 22, Color("#075985")))

	# ★v39追加★ 上の部分をつかんでドラッグすると、パネルを移動できる
	guide_drag_bar = Control.new()
	guide_drag_bar.position = Vector2.ZERO
	guide_drag_bar.mouse_filter = Control.MOUSE_FILTER_STOP
	guide_drag_bar.mouse_default_cursor_shape = Control.CURSOR_MOVE
	guide_drag_bar.gui_input.connect(_on_guide_bar_input)
	guide_panel.add_child(guide_drag_bar)

	guide_scroll = ScrollContainer.new()
	guide_panel.add_child(guide_scroll)

	guide_body = _make_label(_guide_text(), Vector2.ZERO, Vector2(750, 0), 14, Color("#334155"))
	guide_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	guide_body.custom_minimum_size = Vector2(750, 1080)
	guide_scroll.add_child(guide_body)

	guide_close_button = Button.new()
	guide_close_button.text = "閉じる"
	guide_close_button.size = Vector2(200, 42)
	guide_close_button.add_theme_font_size_override("font_size", 15)
	guide_close_button.pressed.connect(_toggle_guide)
	guide_panel.add_child(guide_close_button)

	# ★v39追加★ 操作のヒント
	guide_hint = _make_label("上の部分をドラッグで移動 ／ 右下の角をドラッグで拡大・縮小", Vector2.ZERO, Vector2(430, 24), 12, Color("#64748b"))
	guide_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	guide_hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	guide_panel.add_child(guide_hint)

	# ★v39追加★ 右下の角：ドラッグで大きさ変更
	guide_handle = Control.new()
	guide_handle.mouse_filter = Control.MOUSE_FILTER_STOP
	guide_handle.mouse_default_cursor_shape = Control.CURSOR_FDIAGSIZE
	guide_handle.gui_input.connect(_on_guide_handle_input)
	guide_panel.add_child(guide_handle)
	var handle_mark := _make_label("↘", Vector2.ZERO, Vector2(30, 30), 18, Color("#94a3b8"))
	handle_mark.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	handle_mark.mouse_filter = Control.MOUSE_FILTER_IGNORE
	guide_handle.add_child(handle_mark)

	_layout_guide()


# ★v39追加★ パネルの大きさに合わせて、中身の位置と大きさを決める
func _layout_guide() -> void:
	if not is_instance_valid(guide_panel):
		return
	var pw := guide_panel.size.x
	var ph := guide_panel.size.y
	guide_drag_bar.size = Vector2(pw, 52)
	guide_scroll.position = Vector2(20, 58)
	guide_scroll.size = Vector2(pw - 40.0, ph - 58.0 - 72.0)
	guide_body.custom_minimum_size = Vector2(guide_scroll.size.x - 20.0, 1080)
	guide_close_button.position = Vector2(20, ph - 60.0)
	guide_hint.position = Vector2(pw - 470.0, ph - 52.0)
	guide_handle.position = Vector2(pw - 32.0, ph - 32.0)
	guide_handle.size = Vector2(32, 32)


# ★v39追加★ バーをドラッグでパネル移動
func _on_guide_bar_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var btn_event := event as InputEventMouseButton
		if btn_event.button_index == MOUSE_BUTTON_LEFT:
			guide_dragging = btn_event.pressed
	elif event is InputEventMouseMotion and guide_dragging:
		var motion := event as InputEventMouseMotion
		var s: float = maxf(_layout_root.scale.x, 0.01)
		var np: Vector2 = guide_panel.position + motion.relative / s
		np.x = clampf(np.x, 0.0, maxf(0.0, BASE_LAYOUT_SIZE.x - guide_panel.size.x))
		np.y = clampf(np.y, 0.0, maxf(0.0, BASE_LAYOUT_SIZE.y - guide_panel.size.y))
		guide_panel.position = np


# ★v39追加★ 右下の角をドラッグで大きさ変更
func _on_guide_handle_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var btn_event := event as InputEventMouseButton
		if btn_event.button_index == MOUSE_BUTTON_LEFT:
			guide_resizing = btn_event.pressed
	elif event is InputEventMouseMotion and guide_resizing:
		var motion := event as InputEventMouseMotion
		var s: float = maxf(_layout_root.scale.x, 0.01)
		var ns: Vector2 = guide_panel.size + motion.relative / s
		ns.x = clampf(ns.x, 480.0, BASE_LAYOUT_SIZE.x - guide_panel.position.x)
		ns.y = clampf(ns.y, 340.0, BASE_LAYOUT_SIZE.y - guide_panel.position.y)
		guide_panel.size = ns
		_layout_guide()


# ★v39追加★ ボタンを離したらドラッグ終了（パネルの外で離しても止まるように）
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		guide_dragging = false
		guide_resizing = false


func _toggle_guide() -> void:
	guide_panel.visible = not guide_panel.visible


# ★v20追加★ 手順書の本文（作れる物質はデータから自動で並べる）
func _guide_text() -> String:
	var text := "【目的】\n原子を組み合わせて、いろいろな物質のモデルを作ってみよう。\n\n"
	text += "【手順】\n"
	text += "1. 左の「原子を追加」から、作りたい物質に必要な原子を出す\n"
	text += "2. 原子をドラッグして近づけ、線でつながった状態にする\n"
	text += "3. 右の「組み合わせを調べる」を押す\n"
	text += "4. 物質モデルと一致すると、名前と説明が表示されるよ\n"
	text += "　（2種類以上の組み合わせでもOK。例：水素4個＋酸素2個 → 水×2）\n\n"
	text += "【作れる物質モデル】\n"
	for substance in SUBSTANCES:
		var parts: Array[String] = []
		var counts: Dictionary = substance["counts"]
		for symbol in counts:
			parts.append(_element_name(symbol) + str(counts[symbol]) + "個")
		text += "・" + substance["name"] + "（" + substance["formula"] + "）＝ " + "＋".join(parts) + "\n"
	text += "\n※学習用の簡易モデルです。実際の反応や生成条件を再現するものではありません。"
	return text


# ★v20追加★ 元素記号から名前を引く
func _element_name(symbol: String) -> String:
	for element in ELEMENTS:
		if element["symbol"] == symbol:
			return element["name"]
	return symbol


func _make_panel(pos: Vector2, panel_size: Vector2, color: Color) -> Panel:
	var panel := Panel.new()
	panel.position = pos
	panel.size = panel_size
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(14)
	style.border_width_left = 1
	style.border_width_right = 1
	style.border_width_top = 1
	style.border_width_bottom = 1
	style.border_color = Color("#bae6fd")
	panel.add_theme_stylebox_override("panel", style)
	return panel


func _make_label(text_value: String, pos: Vector2, label_size: Vector2, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text_value
	label.position = pos
	label.size = label_size
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label


func _add_atom(symbol: String) -> void:
	_atom_serial += 1
	var atom := Panel.new()
	atom.name = "Atom_" + str(_atom_serial)
	atom.z_index = 2
	atom.size = Vector2(58, 58)
	atom.position = Vector2(35 + ((_atom_serial - 1) % 5) * 88, 65 + (int((_atom_serial - 1) / 5.0) % 3) * 90)
	atom.mouse_filter = Control.MOUSE_FILTER_STOP
	var style := StyleBoxFlat.new()
	style.bg_color = ATOM_COLORS[symbol]
	style.set_corner_radius_all(29)
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_color = Color("#64748b")
	atom.add_theme_stylebox_override("panel", style)
	var symbol_label := Label.new()
	symbol_label.text = symbol
	symbol_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	symbol_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	symbol_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	symbol_label.add_theme_font_size_override("font_size", 21 if symbol.length() == 1 else 16)
	symbol_label.add_theme_color_override("font_color", Color("#1e293b"))
	symbol_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	atom.add_child(symbol_label)
	atom.gui_input.connect(_on_atom_gui_input.bind(atom))
	atom_layer.add_child(atom)
	_atoms.append({"symbol": symbol, "node": atom})
	_update_count()
	_update_bond_lines()


func _on_atom_gui_input(event: InputEvent, atom: Control) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_dragging_atom = atom
			atom_layer.move_child(atom, atom_layer.get_child_count() - 1)
		else:
			_dragging_atom = null
			_update_bond_lines()
	elif event is InputEventMouseMotion and _dragging_atom == atom:
		atom.position = atom_layer.get_local_mouse_position() - atom.size / 2
		atom.position.x = clampf(atom.position.x, 0.0, atom_layer.size.x - atom.size.x)
		atom.position.y = clampf(atom.position.y, 0.0, atom_layer.size.y - atom.size.y)
		_update_bond_lines()


func _update_bond_lines() -> void:
	var needed := {}
	for i in range(_atoms.size()):
		var a: Control = _atoms[i]["node"]
		if not is_instance_valid(a):
			continue
		for j in range(i + 1, _atoms.size()):
			var b: Control = _atoms[j]["node"]
			if not is_instance_valid(b):
				continue
			var center_a := a.position + a.size / 2
			var center_b := b.position + b.size / 2
			if center_a.distance_to(center_b) <= BOND_DISTANCE:
				var id_a := a.get_instance_id()
				var id_b := b.get_instance_id()
				var key := str(mini(id_a, id_b)) + "_" + str(maxi(id_a, id_b))
				needed[key] = true
				if not _bond_lines.has(key):
					var line := Line2D.new()
					line.width = 5.0
					line.default_color = Color("#64748b")
					line.begin_cap_mode = Line2D.LINE_CAP_ROUND
					line.end_cap_mode = Line2D.LINE_CAP_ROUND
					line.z_index = 1
					atom_layer.add_child(line)
					atom_layer.move_child(line, 0)
					_bond_lines[key] = line
				var bond: Line2D = _bond_lines[key]
				bond.points = PackedVector2Array([center_a, center_b])
	for key in _bond_lines.keys():
		if not needed.has(key):
			var old_line: Line2D = _bond_lines[key]
			if is_instance_valid(old_line):
				old_line.queue_free()
			_bond_lines.erase(key)


func _connected_groups() -> Array:
	var groups: Array = []
	var visited := {}
	for i in range(_atoms.size()):
		if visited.has(i):
			continue
		var group_indices: Array[int] = []
		var queue: Array[int] = [i]
		visited[i] = true
		while not queue.is_empty():
			var current: int = queue.pop_front()
			group_indices.append(current)
			var current_node: Control = _atoms[current]["node"]
			if not is_instance_valid(current_node):
				continue
			var current_center := current_node.position + current_node.size / 2
			for j in range(_atoms.size()):
				if visited.has(j):
					continue
				var other_node: Control = _atoms[j]["node"]
				if not is_instance_valid(other_node):
					continue
				var other_center := other_node.position + other_node.size / 2
				if current_center.distance_to(other_center) <= BOND_DISTANCE:
					visited[j] = true
					queue.append(j)
		groups.append(group_indices)
	return groups


func _counts_for_group(indices: Array) -> Dictionary:
	var counts := {}
	for index in indices:
		var symbol: String = _atoms[index]["symbol"]
		counts[symbol] = int(counts.get(symbol, 0)) + 1
	return counts


func _same_composition(a: Dictionary, b: Dictionary) -> bool:
	if a.size() != b.size():
		return false
	for key in a.keys():
		if int(a[key]) != int(b.get(key, -1)):
			return false
	return true


func _analyze_atoms() -> void:
	if _atoms.is_empty():
		_show_failure("原子がありません", "左側から原子を追加してみよう。")
		return
	var groups := _connected_groups()
	# まず今まで通り「全部つながって、ちょうど1つの物質」を探す
	if groups.size() == 1:
		var counts0 := _counts_for_group(groups[0])
		for substance in SUBSTANCES:
			if _same_composition(counts0, substance["counts"]):
				_show_single_result(substance)
				return
	# ★v47追加★ グループごとに、物質の組み合わせに分けられるか調べる
	# （例：水素4個＋酸素2個 → 水×2、カリウムの式 → 水酸化カリウム×2＋水素）
	var found := {}
	var total_pieces := 0
	for g in groups:
		var parts := _decompose(_counts_for_group(g))
		if parts.is_empty():
			_show_failure("❌ 失敗！", "登録された物質モデルと一致しませんでした。\n\n原子の種類・個数・つながり方を確認して、もう一度試してみよう。")
			return
		for sub in parts:
			total_pieces += 1
			var f: String = sub["formula"]
			if found.has(f):
				found[f][1] = int(found[f][1]) + 1
			else:
				found[f] = [sub, 1]
	if total_pieces == 1:
		_show_single_result(found.values()[0][0])
		return
	_show_combination_result(found)


# ★v47追加★ 1つの物質ができたときの表示（今まで通り）
func _show_single_result(substance: Dictionary) -> void:
	result_label.text = "✨ " + substance["name"] + "モデル！"
	result_label.add_theme_color_override("font_color", Color("#0369a1"))
	_set_result_detail(substance["formula"] + " ／ " + substance["kind"] + "\n\n" + substance["explanation"] + "\n\n【安全メモ】\n" + substance["hazard"] + "\n\n※組成が一致した学習用モデルです。実際に生成した証明ではありません。")
	result_art.texture = _make_pixel_art(substance["art"])


# ★v47追加★ 複数の物質の組み合わせができたときの表示
func _show_combination_result(found: Dictionary) -> void:
	result_label.text = "✨ 組み合わせ成功！"
	result_label.add_theme_color_override("font_color", Color("#0369a1"))
	var text := "つぎの物質モデルが作れます：\n"
	for f in found.keys():
		var sub: Dictionary = found[f][0]
		text += "\n・" + sub["name"] + "（" + sub["formula"] + "）× " + str(int(found[f][1]))
	text += "\n\n※原子の合計が一致した学習用モデルです。実際に生成した証明ではありません。"
	_set_result_detail(text)
	result_art.texture = _make_pixel_art(found.values()[0][0]["art"])


var _search_steps := 0


# ★v47追加★ 原子の合計を、登録された物質の組み合わせに分けられるか探す
# 分け方の候補が複数あるときは、種類の数が少ない分け方を優先する
func _decompose(counts: Dictionary) -> Array:
	_search_steps = 0
	var holder := {"best": [], "key": [999, 999]}
	_decompose_rec(counts, [], holder)
	return holder["best"]


func _decompose_rec(remaining: Dictionary, current: Array, holder: Dictionary) -> void:
	_search_steps += 1
	if _search_steps > 20000:
		return
	if remaining.is_empty():
		var distinct := {}
		for s in current:
			distinct[s["formula"]] = true
		if distinct.size() < int(holder["key"][0]) or (distinct.size() == int(holder["key"][0]) and current.size() < int(holder["key"][1])):
			holder["key"] = [distinct.size(), current.size()]
			holder["best"] = current.duplicate()
		return
	# 枝刈り：すでに見つけた分け方より種類が多くなりそうなら打ち切る
	var current_distinct := {}
	for s in current:
		current_distinct[s["formula"]] = true
	if current_distinct.size() > int(holder["key"][0]):
		return
	for substance in SUBSTANCES:
		var sc: Dictionary = substance["counts"]
		var fits := true
		for key in sc.keys():
			if int(remaining.get(key, 0)) < int(sc[key]):
				fits = false
				break
		if not fits:
			continue
		var next := remaining.duplicate()
		for key in sc.keys():
			next[key] = int(next[key]) - int(sc[key])
			if int(next[key]) == 0:
				next.erase(key)
		current.append(substance)
		_decompose_rec(next, current, holder)
		current.pop_back()
		if _search_steps > 20000:
			return


# ★v49追加★ 説明文をセットし、スクロール用の高さも合わせる
func _set_result_detail(value: String) -> void:
	result_detail.text = value
	var font := result_detail.get_theme_default_font()
	var h := font.get_multiline_string_size(value, HORIZONTAL_ALIGNMENT_LEFT, 232.0, 13).y
	result_detail.custom_minimum_size = Vector2(238, h + 6.0)


func _show_failure(title_text: String, detail_text: String) -> void:
	result_label.text = title_text
	result_label.add_theme_color_override("font_color", Color("#dc2626"))
	_set_result_detail(detail_text)
	result_art.texture = null


func _make_pixel_art(art_name: String) -> ImageTexture:
	var rows: Array = PIXEL_ART[art_name]
	var image := Image.create(16, 16, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	for y in range(rows.size()):
		var row: String = rows[y]
		for x in range(row.length()):
			var pixel_code := row.substr(x, 1)
			if pixel_code != ".":
				image.set_pixel(x, y, PIXEL_COLORS[pixel_code])
	return ImageTexture.create_from_image(image)


func _clear_atoms() -> void:
	for item in _atoms:
		var node: Control = item["node"]
		if is_instance_valid(node):
			node.queue_free()
	_atoms.clear()
	for key in _bond_lines.keys():
		var line: Line2D = _bond_lines[key]
		if is_instance_valid(line):
			line.queue_free()
	_bond_lines.clear()
	_dragging_atom = null
	_update_count()
	_reset_result()



# ★v21追加★ 教科書から指定された原子を並べる
func apply_preset(symbols: Array) -> void:
	_clear_atoms()
	for symbol in symbols:
		_add_atom(str(symbol))


func _update_count() -> void:
	if is_instance_valid(count_label):
		count_label.text = "配置した原子：" + str(_atoms.size()) + "個"


func _reset_result() -> void:
	if is_instance_valid(result_label):
		result_label.text = "原子を追加してみよう！"
		result_label.add_theme_color_override("font_color", Color("#0369a1"))
	if is_instance_valid(result_detail):
		_set_result_detail("原子を近づけて線でつないだら、「組み合わせを調べる」を押そう。")
	if is_instance_valid(result_art):
		result_art.texture = null


# ★v33追加★ main から「教科書から開いた」と知らせる
func set_from_textbook(value: bool) -> void:
	set_return_target("textbook" if value else "")


# ★v42追加★ 戻り先を指定する（教科書か元素図鑑か）
func set_return_target(target: String) -> void:
	return_target = target
	from_textbook = target != ""
	if is_instance_valid(textbook_button):
		textbook_button.visible = return_target != ""
		if return_target == "encyclopedia":
			textbook_button.text = "📖 元素図鑑に戻る"
		else:
			textbook_button.text = "📖 教科書に戻る"


# ★v33追加★ さっき見ていた教科書ページに戻る
func _go_back_to_textbook() -> void:
	visible = false
	var main_node := get_parent()
	if return_target == "encyclopedia" and main_node and main_node.has_method("back_to_encyclopedia_from_simulation"):
		main_node.back_to_encyclopedia_from_simulation()
	elif main_node and main_node.has_method("back_to_textbook_from_simulation"):
		main_node.back_to_textbook_from_simulation()
	elif main_node and main_node.has_method("show_menu_from_simulation"):
		main_node.show_menu_from_simulation()


func _go_back_to_menu() -> void:
	visible = false
	var main_node := get_parent()
	if main_node and main_node.has_method("show_menu_from_simulation"):
		main_node.show_menu_from_simulation()
