import json

raw_olls = """
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

raw_plls = """
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

def parse_grid(s):
    return [[int(s[0]), int(s[1]), int(s[2])],
            [int(s[3]), int(s[4]), int(s[5])],
            [int(s[6]), int(s[7]), int(s[8])]]

def parse_edge(s):
    if not s: return []
    return [int(c) for c in s]

output = []
output.append("import '../models/oll_pll_case.dart';\n")
output.append("const List<OllPllCase> allOllCases = [")

for line in raw_olls.strip().split('\n'):
    if not line: continue
    parts = line.split('|')
    num, group, alg, grid, edge = parts
    grid_parsed = parse_grid(grid)
    edge_parsed = parse_edge(edge)
    
    code = f'''  OllPllCase(
    id: 'OLL_{num}',
    name: 'OLL {num} - {group}',
    category: 'OLL',
    group: '{group}',
    algorithm: "{alg}",
    uFaceGrid: {grid_parsed},
    edgeBand: {edge_parsed},
  ),'''
    output.append(code)

output.append("];\n")
output.append("const List<OllPllCase> allPllCases = [")

for line in raw_plls.strip().split('\n'):
    if not line: continue
    parts = line.split('|')
    name, group, alg, desc = parts
    
    code = f'''  OllPllCase(
    id: 'PLL_{name}',
    name: '{name} Permutation',
    category: 'PLL',
    group: '{group}',
    algorithm: "{alg}",
    uFaceGrid: [[1,1,1],[1,1,1],[1,1,1]],
    edgeBand: [],
    description: "{desc}",
  ),'''
    output.append(code)

output.append("];\n")
output.append("const List<OllPllCase> allCases = [...allOllCases, ...allPllCases];")


with open('c:/Users/WORKSTATION/Desktop/cubetrainer/lib/services/oll_pll_data.dart', 'w', encoding='utf-8') as f:
    f.write('\n'.join(output))

print("Completed writing oll_pll_data.dart")
