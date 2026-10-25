import json

raw_olls_3x3 = """
1|Dot|R U2 R2 F R F' U2 R' F R F'|000010000|0000
2|Dot|F R U R' U' F' f R U R' U' f'|000010000|1111
3|Dot|f R U R' U' f' U' F R U R' U' F'|000010000|0101
4|Dot|f R U R' U' f' U F R U R' U' F'|000010000|1010
5|Square|r' U2 R U R' U r|011011000|1001
6|Square|r U2 R' U' R U' r'|110110000|0110
7|Lightning|r U R' U R U2 r'|000011110|1000
8|Lightning|l' U' L U' L' U2 l|000110011|0010
9|Fish|R U R' U' R' F R2 U R' U' F'|110011000|1100
10|Fish|R U R' U R' F R F' R U2 R'|011110000|0011
11|Lightning|r U R' U R' F R F' R U2 r'|010111000|0100
12|Lightning|M' R' U' R U' R' U2 R U' R r'|010111000|1000
13|Knight|F U R U2 R' U' R U R' F'|010010110|1100
14|Knight|R' F R U R' F' R F U' F'|010010011|0011
15|Knight|l' U' l L' U' L U l' U l|011010010|1001
16|Knight|r U r' R U R' U' r U' r'|110010010|0110
17|Dot|F R' F' R2 r' U R U' R' U' M'|010010010|1010
18|Dot|r U R' U R U2 r2 U' R U' R' U2 r|010010010|0101
19|Dot|r' R U R U R' U' M' R' F R F'|010010010|0000
20|OCLL|M U R U R' U' M2 U R U' r'|010111010|1111
21|OCLL|R U2 R' U' R U R' U' R U' R'|010111010|0000
22|OCLL|R U2 R2 U' R2 U' R2 U2 R|010111010|1010
23|OCLL|R2 D R' U2 R D' R' U2 R'|010111010|1100
24|OCLL|r U R' U' r' F R F'|010111010|0110
25|OCLL|F' r U R' U' r' F R|010111010|1001
26|OCLL|R U2 R' U' R U' R'|010111010|0101
27|OCLL|R U R' U R U2 R'|010111010|1010
28|Awkward|M u M' u2 M u M'|010011010|0101
29|Awkward|R U R' U' R U' R' F' U' F R U R'|010111000|1001
30|Awkward|F R' F R2 U' R' U' R U R' F2|010111000|0110
31|P Shape|R' U' F U R U' R' F' R|011011010|1100
32|P Shape|S R U R' U' R' F R f'|110110010|0011
33|T Shape|R U R' U' R' F R F'|010111010|0101
34|C Shape|R U R2 U' R' F R U R U' F'|110110100|0101
35|Fish|R U2 R2 F R F' R U2 R'|011110000|1001
36|Fish|L' U' L U' L' U L U L F' L' F|110011000|0110
37|Awkward|F R' F' R U R U' R'|010111000|1100
38|Awkward|R U R' U R U' R' U' R' F R F'|010111000|0011
39|Lightning|L F' L' U' L U F U' L'|000111010|1001
40|Lightning|R' F R U R' U' F' U R|000111010|0110
41|Awkward|R U R' U R U2 R' F R U R' U' F'|010111000|1010
42|Awkward|R' U' R U' R' U2 R F R U R' U' F'|010111000|0101
43|P Shape|F' U' L' U L F|011011010|0110
44|P Shape|F U R U' R' F'|110110010|1001
45|T Shape|F R U R' U' F'|010111010|1010
46|C Shape|R' U' R' F R F' U R|011011001|1010
47|L Shape|R' U' R' F R F' R' F R F' U R|010011010|0110
48|L Shape|F R U R' U' R U R' U' F'|010110010|1001
49|L Shape|r U' r2 U r2 U r2 U' r|010011010|1010
50|L Shape|r' U r2 U' r2 U' r2 U r'|010110010|0101
51|L Shape|f R U R' U' R U R' U' f'|010011010|0011
52|L Shape|R U R' U R U' B U' B' R'|010110010|1100
53|Line|r' U' R U' R' U R U' R' U2 r|010111010|0000
54|Line|r U R' U R U' R' U R U2 r'|010111010|1111
55|Line|R U2 R2 U' R U' R' U2 F R F'|010111010|0101
56|Line|r' U' r U' R' U R U' R' U R r' U r|010111010|1010
57|Line|R U R' U' M' U R U' r'|010111010|1100
"""

raw_plls_3x3 = """
H|Edge only|M2 U M2 U2 M2 U M2|Scambia gli edge opposti.
Z|Edge only|M2 U M2 U M' U2 M2 U2 M'|Scambia due coppie di edge adiacenti.
Ua|Edge only|M2 U M U2 M' U M2|Cicla 3 edge in senso orario.
Ub|Edge only|M2 U' M U2 M' U' M2|Cicla 3 edge in senso antiorario.
Aa|Corner only|x L2 D2 L' U' L D2 L' U L' x'|Cicla 3 angoli in senso antiorario.
Ab|Corner only|x' L2 D2 L U L' D2 L U' L x|Cicla 3 angoli in senso orario.
E|Corner only|x' L' U L D' L' U' L D L' U' L D' L' U L D x|Scambia angoli adiacenti in orizzontale.
F|Corner + Edge|R' U' F' R U R' U' R' F R2 U' R' U' R U R' U R|Scambia 2 angoli e 2 edge adiacenti.
Ga|Corner + Edge|R2 U R' U R' U' R U' R2 U' D R' U R D'|Cicla 3 edge e scambia 2 angoli.
Gb|Corner + Edge|R' U' R y R2 u R' U R U' R u' R2|Cicla 3 edge e scambia 2 angoli.
Gc|Corner + Edge|R2 U' R U' R U R' U R2 U D' R U' R' D|Cicla 3 edge e scambia 2 angoli.
Gd|Corner + Edge|R U R' y' R2 u' R U' R' U R' u R2|Cicla 3 edge e scambia 2 angoli.
Ja|Corner + Edge|x R2 F R F' R U2 r' U r U2 x'|Scambia 2 angoli e 2 edge (L shape).
Jb|Corner + Edge|R U R' F' R U R' U' R' F R2 U' R'|Scambia 2 angoli e 2 edge (L shape).
Na|Corner + Edge|R U R' U R U R' F' R U R' U' R' F R2 U' R' U2 R U' R'|Scambia 2 blocchi 1x2 opposti.
Nb|Corner + Edge|R' U R U' R' F' U' F R U R' F R' F' R U' R|Scambia 2 blocchi 1x2 opposti.
Ra|Corner + Edge|R U R' F' R U2 R' U2 R' F R U R U2 R'|Scambia 2 angoli adiacenti e 2 edge adiacenti.
Rb|Corner + Edge|R' U2 R U2 R' F R U R' U' R' F' R2 U'|Scambia 2 angoli adiacenti e 2 edge adiacenti.
T|Corner + Edge|R U R' U' R' F R2 U' R' U' R U R' F'|Scambia 2 angoli adiacenti e 2 edge opposti.
V|Corner + Edge|R' U R' d' R' F' R2 U' R' U R' F R F|Scambia 2 angoli in diagonale e 2 edge adiacenti.
Y|Corner + Edge|F R U' R' U' R U R' F' R U R' U' R' F R F'|Scambia 2 angoli in diagonale e 2 edge opposti.
"""

# Pyraminx 
raw_pyraminx = """
Skip|LL| |
Flip 2 adj|LL|R' L R L' U L' U' L|
U-PLL CW|LL|R' U' R U' R' U' R|
U-PLL CCW|LL|L U L' U L U L'|
Flip 2 opp|LL|R' L R L' U' R U R'|
"""

# Megaminx
raw_mega = """
Flipped All|EOLL|F U R U' R' F' + rot + F U R U' R' F'|
Flipped L|EOLL|F U R U' R' F'|
Flipped Line|EOLL|F' R U R' U' F'|
Sune|OCLL|R U R' U R U2 R'|(U2 = due turn da 72°)
Antisune|OCLL|R U2 R' U' R U' R'|(U2 = due turn da 72°)
Pi|OCLL|F R U R' U' R U R' U' F'|
H|OCLL|F R U R' U' F' U F R U R' U' F'|
T|OCLL|R U R' U' R' F R F'|
U|OCLL|R U2 R2 U' R2 U' R2 U2 R|
L|OCLL|F' r U R' U' r' F R|
CW|EPLL|R U R' U R U3 R' U|U3 è equivalente a U'2
CCW|EPLL|U' R U2 R' U' R U' R'|
Skip|EPLL| |
CW|CPLL|L' U2 R U'2 L U2 R' U'2|
CCW|CPLL|U2 R U'2 L' U2 R' U'2 L|
Skip|CPLL| |
"""

# 2x2
raw_2x2 = """
Adj/Adj|PBL|R2 U R2 U' R2 U R2 U' R2|
Adj/Opp|PBL|R U' R F2 R' U R'|
Diag/Adj|PBL|R U D' R U' R' D R2 F R' F' R|
Diag/Opp|PBL|F R U' R' U' R U R' F' R U R' U' R' F R F'|
Skip/Adj|PBL|R U R' U' R' F R2 U' R' U' R U R' F'|
Skip/Diag|PBL|F R U' R' U' R U R' F' R U R' U' R' F R F'|
OLL 1|OLL|R U2 R2 F R F' U2 R' F R F'|
OLL 2|OLL|F R U R' U' F' f R U R' U' f'|
OLL 3|OLL|f R U R' U' f' U' F R U R' U' F'|
OLL 4|OLL|f R U R' U' f' U F R U R' U' F'|
OLL 5|OLL|r' U2 R U R' U r|
OLL 6|OLL|r U2 R' U' R U' r'|
OLL 7|OLL|r U R' U R U2 r'|
"""

raw_4x4 = """
OLL Parity|OLL Parity|Rw U2 x Rw U2 Rw U2 Rw' U2 Lw U2 Rw' U2 Rw U2 Rw' U2 Rw'|
Opposite|PLL Parity|Rw2 U2 Rw2 Uw2 Rw2 Uw2|
Adjacent|PLL Parity|(R' U R U') Rw2 U2 Rw2 Uw2 Rw2 Uw2 (U R' U' R)|
"""

def parse_grid(s):
    if not s: return [[0]*3]*3
    return [[int(s[0]), int(s[1]), int(s[2])],
            [int(s[3]), int(s[4]), int(s[5])],
            [int(s[6]), int(s[7]), int(s[8])]]

def parse_edge(s):
    if not s: return []
    return [int(c) for c in s]

output = []
output.append("import '../models/oll_pll_case.dart';")
output.append("import '../models/solve.dart';\n")

# 3x3 All cases
output.append("const List<OllPllCase> allCases3x3 = [")
for line in raw_olls_3x3.strip().split('\n'):
    if not line: continue
    parts = line.split('|')
    num, group, alg, grid, edge = parts
    code = f'''  OllPllCase(id: '3x3OLL_{num}', name: 'OLL {num} - {group}', category: 'OLL', group: '{group}', algorithm: "{alg}", uFaceGrid: {parse_grid(grid)}, edgeBand: {parse_edge(edge)}, puzzle: CubeType.threeByThree),'''
    output.append(code)

for line in raw_plls_3x3.strip().split('\n'):
    if not line: continue
    parts = line.split('|')
    name, group, alg, desc = parts
    code = f'''  OllPllCase(id: '3x3PLL_{name}', name: '{name} Permutation', category: 'PLL', group: '{group}', algorithm: "{alg}", uFaceGrid: [[1,1,1],[1,1,1],[1,1,1]], edgeBand: [], puzzle: CubeType.threeByThree, note: "{desc}"),'''
    output.append(code)
output.append("];\n")

# 2x2 All cases
output.append("const List<OllPllCase> allCases2x2 = [")
idx = 1
for line in raw_2x2.strip().split('\n'):
    if not line: continue
    name, group, alg, _ = line.split('|')
    code = f'''  OllPllCase(id: '2x2_{idx}', name: '{name}', category: '{group}', group: '{group}', algorithm: "{alg}", uFaceGrid: [[0,0,0],[0,0,0],[0,0,0]], edgeBand: [], puzzle: CubeType.twoByTwo),'''
    output.append(code)
    idx+=1
# Insert placeholders for 42 CLLs
for cll in range(1, 43):
    code = f'''  OllPllCase(id: '2x2_CLL_{cll}', name: 'CLL {cll}', category: 'CLL', group: 'CLL', algorithm: "", uFaceGrid: [[0,0,0],[0,0,0],[0,0,0]], edgeBand: [], puzzle: CubeType.twoByTwo),'''
    output.append(code)
output.append("];\n")


# 4x4
output.append("const List<OllPllCase> allCases4x4 = [")
idx = 1
for line in raw_4x4.strip().split('\n'):
    if not line: continue
    name, group, alg, _ = line.split('|')
    code = f'''  OllPllCase(id: '4x4_{idx}', name: '{name}', category: '{group}', group: '{group}', algorithm: "{alg}", uFaceGrid: [[0,0,0],[0,0,0],[0,0,0]], edgeBand: [], puzzle: CubeType.fourByFour),'''
    output.append(code)
    idx+=1
output.append("];\n")

# 6x6
output.append("const List<OllPllCase> allCases6x6 = [")
idx = 1
for line in raw_4x4.strip().split('\n'):
    if not line: continue
    name, group, alg, _ = line.split('|')
    # replace Rw with 3Rw
    alg = alg.replace('Rw', '3Rw').replace('3Rw2', '3Rw2').replace('Lw', '3Lw') 
    code = f'''  OllPllCase(id: '6x6_{idx}', name: '{name}', category: '{group}', group: '{group}', algorithm: "{alg}", uFaceGrid: [[0,0,0],[0,0,0],[0,0,0]], edgeBand: [], puzzle: CubeType.sixBySix, note: "Outer 3 layers for wide moves"),'''
    output.append(code)
    idx+=1
output.append("];\n")

# 5x5
output.append("const List<OllPllCase> allCases5x5 = [")
idx = 1
for line in raw_4x4.strip().split('\n'):
    if not line: continue
    if "OLL Parity" in line: continue
    name, group, alg, _ = line.split('|')
    code = f'''  OllPllCase(id: '5x5_{idx}', name: '{name}', category: '{group}', group: '{group}', algorithm: "{alg}", uFaceGrid: [[0,0,0],[0,0,0],[0,0,0]], edgeBand: [], puzzle: CubeType.fiveByFive),'''
    output.append(code)
    idx+=1
output.append("];\n")


# 7x7
output.append("const List<OllPllCase> allCases7x7 = [")
idx = 1
for line in raw_4x4.strip().split('\n'):
    if not line: continue
    if "OLL Parity" in line: continue
    name, group, alg, _ = line.split('|')
    alg = alg.replace('Rw', '3Rw').replace('3Rw2', '3Rw2').replace('Lw', '3Lw') 
    code = f'''  OllPllCase(id: '7x7_{idx}', name: '{name}', category: '{group}', group: '{group}', algorithm: "{alg}", uFaceGrid: [[0,0,0],[0,0,0],[0,0,0]], edgeBand: [], puzzle: CubeType.sevenBySeven, note: "Outer 3 layers for wide moves"),'''
    output.append(code)
    idx+=1
output.append("];\n")


# Pyraminx
output.append("const List<OllPllCase> allCasesPyraminx = [")
idx = 1
for line in raw_pyraminx.strip().split('\n'):
    if not line: continue
    name, group, alg, _ = line.split('|')
    code = f'''  OllPllCase(id: 'Pyra_{idx}', name: '{name}', category: '{group}', group: '{group}', algorithm: "{alg}", uFaceGrid: [[0,0,0],[0,0,0],[0,0,0]], edgeBand: [], puzzle: CubeType.pyraminx),'''
    output.append(code)
    idx+=1
# Insert placeholders for 34 L4E
for l4e in range(1, 35):
    code = f'''  OllPllCase(id: 'Pyra_L4E_{l4e}', name: 'L4E {l4e}', category: 'L4E', group: 'L4E', algorithm: "", uFaceGrid: [[0,0,0],[0,0,0],[0,0,0]], edgeBand: [], puzzle: CubeType.pyraminx),'''
    output.append(code)
output.append("];\n")


# Megaminx
output.append("const List<OllPllCase> allCasesMegaminx = [")
idx = 1
for line in raw_mega.strip().split('\n'):
    if not line: continue
    name, group, alg, note = line.split('|')
    code = f'''  OllPllCase(id: 'Mega_{idx}', name: '{name}', category: '{group}', group: '{group}', algorithm: "{alg}", uFaceGrid: [[0,0,0],[0,0,0],[0,0,0]], edgeBand: [], puzzle: CubeType.megaminx, note: "{note}"),'''
    output.append(code)
    idx+=1
output.append("];\n")

# Combine all
output.append('''
const List<OllPllCase> allCases = [
  ...allCases2x2,
  ...allCases3x3,
  ...allCases4x4,
  ...allCases5x5,
  ...allCases6x6,
  ...allCases7x7,
  ...allCasesMegaminx,
  ...allCasesPyraminx,
];

final Map<CubeType, List<OllPllCase>> allCasesByPuzzle = {
  CubeType.twoByTwo: allCases2x2,
  CubeType.threeByThree: allCases3x3,
  CubeType.fourByFour: allCases4x4,
  CubeType.fiveByFive: allCases5x5,
  CubeType.sixBySix: allCases6x6,
  CubeType.sevenBySeven: allCases7x7,
  CubeType.megaminx: allCasesMegaminx,
  CubeType.pyraminx: allCasesPyraminx,
};
''')


with open('c:/Users/WORKSTATION/Desktop/cubetrainer/lib/services/oll_pll_data.dart', 'w', encoding='utf-8') as f:
    f.write('\n'.join(output))

print("Completed writing oll_pll_data.dart")
