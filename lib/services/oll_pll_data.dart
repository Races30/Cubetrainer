import '../models/oll_pll_case.dart';
import '../models/solve.dart';

const List<OllPllCase> allCases3x3 = [
  OllPllCase(
      id: '3x3OLL_1',
      name: 'OLL 1 - Dot',
      category: 'OLL',
      group: 'Dot',
      algorithm: "R U2 R2 F R F' U2 R' F R F'",
      uFaceGrid: [
        [0, 0, 0],
        [0, 1, 0],
        [0, 0, 0]
      ],
      edgeBand: [0, 0, 0, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_2',
      name: 'OLL 2 - Dot',
      category: 'OLL',
      group: 'Dot',
      algorithm: "F R U R' U' F' f R U R' U' f'",
      uFaceGrid: [
        [0, 0, 0],
        [0, 1, 0],
        [0, 0, 0]
      ],
      edgeBand: [1, 1, 1, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_3',
      name: 'OLL 3 - Dot',
      category: 'OLL',
      group: 'Dot',
      algorithm: "f R U R' U' f' U' F R U R' U' F'",
      uFaceGrid: [
        [0, 0, 0],
        [0, 1, 0],
        [0, 0, 0]
      ],
      edgeBand: [0, 1, 0, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_4',
      name: 'OLL 4 - Dot',
      category: 'OLL',
      group: 'Dot',
      algorithm: "f R U R' U' f' U F R U R' U' F'",
      uFaceGrid: [
        [0, 0, 0],
        [0, 1, 0],
        [0, 0, 0]
      ],
      edgeBand: [1, 0, 1, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_5',
      name: 'OLL 5 - Square',
      category: 'OLL',
      group: 'Square',
      algorithm: "r' U2 R U R' U r",
      uFaceGrid: [
        [0, 1, 1],
        [0, 1, 1],
        [0, 0, 0]
      ],
      edgeBand: [1, 0, 0, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_6',
      name: 'OLL 6 - Square',
      category: 'OLL',
      group: 'Square',
      algorithm: "r U2 R' U' R U' r'",
      uFaceGrid: [
        [1, 1, 0],
        [1, 1, 0],
        [0, 0, 0]
      ],
      edgeBand: [0, 1, 1, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_7',
      name: 'OLL 7 - Lightning',
      category: 'OLL',
      group: 'Lightning',
      algorithm: "r U R' U R U2 r'",
      uFaceGrid: [
        [0, 0, 0],
        [0, 1, 1],
        [1, 1, 0]
      ],
      edgeBand: [1, 0, 0, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_8',
      name: 'OLL 8 - Lightning',
      category: 'OLL',
      group: 'Lightning',
      algorithm: "l' U' L U' L' U2 l",
      uFaceGrid: [
        [0, 0, 0],
        [1, 1, 0],
        [0, 1, 1]
      ],
      edgeBand: [0, 0, 1, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_9',
      name: 'OLL 9 - Fish',
      category: 'OLL',
      group: 'Fish',
      algorithm: "R U R' U' R' F R2 U R' U' F'",
      uFaceGrid: [
        [1, 1, 0],
        [0, 1, 1],
        [0, 0, 0]
      ],
      edgeBand: [1, 1, 0, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_10',
      name: 'OLL 10 - Fish',
      category: 'OLL',
      group: 'Fish',
      algorithm: "R U R' U R' F R F' R U2 R'",
      uFaceGrid: [
        [0, 1, 1],
        [1, 1, 0],
        [0, 0, 0]
      ],
      edgeBand: [0, 0, 1, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_11',
      name: 'OLL 11 - Lightning',
      category: 'OLL',
      group: 'Lightning',
      algorithm: "r U R' U R' F R F' R U2 r'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 0, 0]
      ],
      edgeBand: [0, 1, 0, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_12',
      name: 'OLL 12 - Lightning',
      category: 'OLL',
      group: 'Lightning',
      algorithm: "M' R' U' R U' R' U2 R U' R r'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 0, 0]
      ],
      edgeBand: [1, 0, 0, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_13',
      name: 'OLL 13 - Knight',
      category: 'OLL',
      group: 'Knight',
      algorithm: "F U R U2 R' U' R U R' F'",
      uFaceGrid: [
        [0, 1, 0],
        [0, 1, 0],
        [1, 1, 0]
      ],
      edgeBand: [1, 1, 0, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_14',
      name: 'OLL 14 - Knight',
      category: 'OLL',
      group: 'Knight',
      algorithm: "R' F R U R' F' R F U' F'",
      uFaceGrid: [
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 1]
      ],
      edgeBand: [0, 0, 1, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_15',
      name: 'OLL 15 - Knight',
      category: 'OLL',
      group: 'Knight',
      algorithm: "l' U' l L' U' L U l' U l",
      uFaceGrid: [
        [0, 1, 1],
        [0, 1, 0],
        [0, 1, 0]
      ],
      edgeBand: [1, 0, 0, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_16',
      name: 'OLL 16 - Knight',
      category: 'OLL',
      group: 'Knight',
      algorithm: "r U r' R U R' U' r U' r'",
      uFaceGrid: [
        [1, 1, 0],
        [0, 1, 0],
        [0, 1, 0]
      ],
      edgeBand: [0, 1, 1, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_17',
      name: 'OLL 17 - Dot',
      category: 'OLL',
      group: 'Dot',
      algorithm: "F R' F' R2 r' U R U' R' U' M'",
      uFaceGrid: [
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 0]
      ],
      edgeBand: [1, 0, 1, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_18',
      name: 'OLL 18 - Dot',
      category: 'OLL',
      group: 'Dot',
      algorithm: "r U R' U R U2 r2 U' R U' R' U2 r",
      uFaceGrid: [
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 0]
      ],
      edgeBand: [0, 1, 0, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_19',
      name: 'OLL 19 - Dot',
      category: 'OLL',
      group: 'Dot',
      algorithm: "r' R U R U R' U' M' R' F R F'",
      uFaceGrid: [
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 0]
      ],
      edgeBand: [0, 0, 0, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_20',
      name: 'OLL 20 - OCLL',
      category: 'OLL',
      group: 'OCLL',
      algorithm: "M U R U R' U' M2 U R U' r'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [1, 1, 1, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_21',
      name: 'OLL 21 - OCLL',
      category: 'OLL',
      group: 'OCLL',
      algorithm: "R U2 R' U' R U R' U' R U' R'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [0, 0, 0, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_22',
      name: 'OLL 22 - OCLL',
      category: 'OLL',
      group: 'OCLL',
      algorithm: "R U2 R2 U' R2 U' R2 U2 R",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [1, 0, 1, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_23',
      name: 'OLL 23 - OCLL',
      category: 'OLL',
      group: 'OCLL',
      algorithm: "R2 D R' U2 R D' R' U2 R'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [1, 1, 0, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_24',
      name: 'OLL 24 - OCLL',
      category: 'OLL',
      group: 'OCLL',
      algorithm: "r U R' U' r' F R F'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [0, 1, 1, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_25',
      name: 'OLL 25 - OCLL',
      category: 'OLL',
      group: 'OCLL',
      algorithm: "F' r U R' U' r' F R",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [1, 0, 0, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_26',
      name: 'OLL 26 - OCLL',
      category: 'OLL',
      group: 'OCLL',
      algorithm: "R U2 R' U' R U' R'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [0, 1, 0, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_27',
      name: 'OLL 27 - OCLL',
      category: 'OLL',
      group: 'OCLL',
      algorithm: "R U R' U R U2 R'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [1, 0, 1, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_28',
      name: 'OLL 28 - Awkward',
      category: 'OLL',
      group: 'Awkward',
      algorithm: "M u M' u2 M u M'",
      uFaceGrid: [
        [0, 1, 0],
        [0, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [0, 1, 0, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_29',
      name: 'OLL 29 - Awkward',
      category: 'OLL',
      group: 'Awkward',
      algorithm: "R U R' U' R U' R' F' U' F R U R'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 0, 0]
      ],
      edgeBand: [1, 0, 0, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_30',
      name: 'OLL 30 - Awkward',
      category: 'OLL',
      group: 'Awkward',
      algorithm: "F R' F R2 U' R' U' R U R' F2",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 0, 0]
      ],
      edgeBand: [0, 1, 1, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_31',
      name: 'OLL 31 - P Shape',
      category: 'OLL',
      group: 'P Shape',
      algorithm: "R' U' F U R U' R' F' R",
      uFaceGrid: [
        [0, 1, 1],
        [0, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [1, 1, 0, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_32',
      name: 'OLL 32 - P Shape',
      category: 'OLL',
      group: 'P Shape',
      algorithm: "S R U R' U' R' F R f'",
      uFaceGrid: [
        [1, 1, 0],
        [1, 1, 0],
        [0, 1, 0]
      ],
      edgeBand: [0, 0, 1, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_33',
      name: 'OLL 33 - T Shape',
      category: 'OLL',
      group: 'T Shape',
      algorithm: "R U R' U' R' F R F'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [0, 1, 0, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_34',
      name: 'OLL 34 - C Shape',
      category: 'OLL',
      group: 'C Shape',
      algorithm: "R U R2 U' R' F R U R U' F'",
      uFaceGrid: [
        [1, 1, 0],
        [1, 1, 0],
        [1, 0, 0]
      ],
      edgeBand: [0, 1, 0, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_35',
      name: 'OLL 35 - Fish',
      category: 'OLL',
      group: 'Fish',
      algorithm: "R U2 R2 F R F' R U2 R'",
      uFaceGrid: [
        [0, 1, 1],
        [1, 1, 0],
        [0, 0, 0]
      ],
      edgeBand: [1, 0, 0, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_36',
      name: 'OLL 36 - Fish',
      category: 'OLL',
      group: 'Fish',
      algorithm: "L' U' L U' L' U L U L F' L' F",
      uFaceGrid: [
        [1, 1, 0],
        [0, 1, 1],
        [0, 0, 0]
      ],
      edgeBand: [0, 1, 1, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_37',
      name: 'OLL 37 - Awkward',
      category: 'OLL',
      group: 'Awkward',
      algorithm: "F R' F' R U R U' R'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 0, 0]
      ],
      edgeBand: [1, 1, 0, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_38',
      name: 'OLL 38 - Awkward',
      category: 'OLL',
      group: 'Awkward',
      algorithm: "R U R' U R U' R' U' R' F R F'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 0, 0]
      ],
      edgeBand: [0, 0, 1, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_39',
      name: 'OLL 39 - Lightning',
      category: 'OLL',
      group: 'Lightning',
      algorithm: "L F' L' U' L U F U' L'",
      uFaceGrid: [
        [0, 0, 0],
        [1, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [1, 0, 0, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_40',
      name: 'OLL 40 - Lightning',
      category: 'OLL',
      group: 'Lightning',
      algorithm: "R' F R U R' U' F' U R",
      uFaceGrid: [
        [0, 0, 0],
        [1, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [0, 1, 1, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_41',
      name: 'OLL 41 - Awkward',
      category: 'OLL',
      group: 'Awkward',
      algorithm: "R U R' U R U2 R' F R U R' U' F'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 0, 0]
      ],
      edgeBand: [1, 0, 1, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_42',
      name: 'OLL 42 - Awkward',
      category: 'OLL',
      group: 'Awkward',
      algorithm: "R' U' R U' R' U2 R F R U R' U' F'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 0, 0]
      ],
      edgeBand: [0, 1, 0, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_43',
      name: 'OLL 43 - P Shape',
      category: 'OLL',
      group: 'P Shape',
      algorithm: "F' U' L' U L F",
      uFaceGrid: [
        [0, 1, 1],
        [0, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [0, 1, 1, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_44',
      name: 'OLL 44 - P Shape',
      category: 'OLL',
      group: 'P Shape',
      algorithm: "F U R U' R' F'",
      uFaceGrid: [
        [1, 1, 0],
        [1, 1, 0],
        [0, 1, 0]
      ],
      edgeBand: [1, 0, 0, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_45',
      name: 'OLL 45 - T Shape',
      category: 'OLL',
      group: 'T Shape',
      algorithm: "F R U R' U' F'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [1, 0, 1, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_46',
      name: 'OLL 46 - C Shape',
      category: 'OLL',
      group: 'C Shape',
      algorithm: "R' U' R' F R F' U R",
      uFaceGrid: [
        [0, 1, 1],
        [0, 1, 1],
        [0, 0, 1]
      ],
      edgeBand: [1, 0, 1, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_47',
      name: 'OLL 47 - L Shape',
      category: 'OLL',
      group: 'L Shape',
      algorithm: "R' U' R' F R F' R' F R F' U R",
      uFaceGrid: [
        [0, 1, 0],
        [0, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [0, 1, 1, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_48',
      name: 'OLL 48 - L Shape',
      category: 'OLL',
      group: 'L Shape',
      algorithm: "F R U R' U' R U R' U' F'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 0],
        [0, 1, 0]
      ],
      edgeBand: [1, 0, 0, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_49',
      name: 'OLL 49 - L Shape',
      category: 'OLL',
      group: 'L Shape',
      algorithm: "r U' r2 U r2 U r2 U' r",
      uFaceGrid: [
        [0, 1, 0],
        [0, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [1, 0, 1, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_50',
      name: 'OLL 50 - L Shape',
      category: 'OLL',
      group: 'L Shape',
      algorithm: "r' U r2 U' r2 U' r2 U r'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 0],
        [0, 1, 0]
      ],
      edgeBand: [0, 1, 0, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_51',
      name: 'OLL 51 - L Shape',
      category: 'OLL',
      group: 'L Shape',
      algorithm: "f R U R' U' R U R' U' f'",
      uFaceGrid: [
        [0, 1, 0],
        [0, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [0, 0, 1, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_52',
      name: 'OLL 52 - L Shape',
      category: 'OLL',
      group: 'L Shape',
      algorithm: "R U R' U R U' B U' B' R'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 0],
        [0, 1, 0]
      ],
      edgeBand: [1, 1, 0, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_53',
      name: 'OLL 53 - Line',
      category: 'OLL',
      group: 'Line',
      algorithm: "r' U' R U' R' U R U' R' U2 r",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [0, 0, 0, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_54',
      name: 'OLL 54 - Line',
      category: 'OLL',
      group: 'Line',
      algorithm: "r U R' U R U' R' U R U2 r'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [1, 1, 1, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_55',
      name: 'OLL 55 - Line',
      category: 'OLL',
      group: 'Line',
      algorithm: "R U2 R2 U' R U' R' U2 F R F'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [0, 1, 0, 1],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_56',
      name: 'OLL 56 - Line',
      category: 'OLL',
      group: 'Line',
      algorithm: "r' U' r U' R' U R U' R' U R r' U r",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [1, 0, 1, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3OLL_57',
      name: 'OLL 57 - Line',
      category: 'OLL',
      group: 'Line',
      algorithm: "R U R' U' M' U R U' r'",
      uFaceGrid: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 1, 0]
      ],
      edgeBand: [1, 1, 0, 0],
      puzzle: CubeType.threeByThree),
  OllPllCase(
      id: '3x3PLL_H',
      name: 'H Permutation',
      category: 'PLL',
      group: 'Edge only',
      algorithm: "M2 U M2 U2 M2 U M2",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Scambia gli edge opposti."),
  OllPllCase(
      id: '3x3PLL_Z',
      name: 'Z Permutation',
      category: 'PLL',
      group: 'Edge only',
      algorithm: "M2 U M2 U M' U2 M2 U2 M'",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Scambia due coppie di edge adiacenti."),
  OllPllCase(
      id: '3x3PLL_Ua',
      name: 'Ua Permutation',
      category: 'PLL',
      group: 'Edge only',
      algorithm: "M2 U M U2 M' U M2",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Cicla 3 edge in senso orario."),
  OllPllCase(
      id: '3x3PLL_Ub',
      name: 'Ub Permutation',
      category: 'PLL',
      group: 'Edge only',
      algorithm: "M2 U' M U2 M' U' M2",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Cicla 3 edge in senso antiorario."),
  OllPllCase(
      id: '3x3PLL_Aa',
      name: 'Aa Permutation',
      category: 'PLL',
      group: 'Corner only',
      algorithm: "x L2 D2 L' U' L D2 L' U L' x'",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Cicla 3 angoli in senso antiorario."),
  OllPllCase(
      id: '3x3PLL_Ab',
      name: 'Ab Permutation',
      category: 'PLL',
      group: 'Corner only',
      algorithm: "x' L2 D2 L U L' D2 L U' L x",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Cicla 3 angoli in senso orario."),
  OllPllCase(
      id: '3x3PLL_E',
      name: 'E Permutation',
      category: 'PLL',
      group: 'Corner only',
      algorithm: "x' L' U L D' L' U' L D L' U' L D' L' U L D x",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Scambia angoli adiacenti in orizzontale."),
  OllPllCase(
      id: '3x3PLL_F',
      name: 'F Permutation',
      category: 'PLL',
      group: 'Corner + Edge',
      algorithm: "R' U' F' R U R' U' R' F R2 U' R' U' R U R' U R",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Scambia 2 angoli e 2 edge adiacenti."),
  OllPllCase(
      id: '3x3PLL_Ga',
      name: 'Ga Permutation',
      category: 'PLL',
      group: 'Corner + Edge',
      algorithm: "R2 U R' U R' U' R U' R2 U' D R' U R D'",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Cicla 3 edge e scambia 2 angoli."),
  OllPllCase(
      id: '3x3PLL_Gb',
      name: 'Gb Permutation',
      category: 'PLL',
      group: 'Corner + Edge',
      algorithm: "R' U' R y R2 u R' U R U' R u' R2",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Cicla 3 edge e scambia 2 angoli."),
  OllPllCase(
      id: '3x3PLL_Gc',
      name: 'Gc Permutation',
      category: 'PLL',
      group: 'Corner + Edge',
      algorithm: "R2 U' R U' R U R' U R2 U D' R U' R' D",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Cicla 3 edge e scambia 2 angoli."),
  OllPllCase(
      id: '3x3PLL_Gd',
      name: 'Gd Permutation',
      category: 'PLL',
      group: 'Corner + Edge',
      algorithm: "R U R' y' R2 u' R U' R' U R' u R2",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Cicla 3 edge e scambia 2 angoli."),
  OllPllCase(
      id: '3x3PLL_Ja',
      name: 'Ja Permutation',
      category: 'PLL',
      group: 'Corner + Edge',
      algorithm: "x R2 F R F' R U2 r' U r U2 x'",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Scambia 2 angoli e 2 edge (L shape)."),
  OllPllCase(
      id: '3x3PLL_Jb',
      name: 'Jb Permutation',
      category: 'PLL',
      group: 'Corner + Edge',
      algorithm: "R U R' F' R U R' U' R' F R2 U' R'",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Scambia 2 angoli e 2 edge (L shape)."),
  OllPllCase(
      id: '3x3PLL_Na',
      name: 'Na Permutation',
      category: 'PLL',
      group: 'Corner + Edge',
      algorithm: "R U R' U R U R' F' R U R' U' R' F R2 U' R' U2 R U' R'",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Scambia 2 blocchi 1x2 opposti."),
  OllPllCase(
      id: '3x3PLL_Nb',
      name: 'Nb Permutation',
      category: 'PLL',
      group: 'Corner + Edge',
      algorithm: "R' U R U' R' F' U' F R U R' F R' F' R U' R",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Scambia 2 blocchi 1x2 opposti."),
  OllPllCase(
      id: '3x3PLL_Ra',
      name: 'Ra Permutation',
      category: 'PLL',
      group: 'Corner + Edge',
      algorithm: "R U R' F' R U2 R' U2 R' F R U R U2 R'",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Scambia 2 angoli adiacenti e 2 edge adiacenti."),
  OllPllCase(
      id: '3x3PLL_Rb',
      name: 'Rb Permutation',
      category: 'PLL',
      group: 'Corner + Edge',
      algorithm: "R' U2 R U2 R' F R U R' U' R' F' R2 U'",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Scambia 2 angoli adiacenti e 2 edge adiacenti."),
  OllPllCase(
      id: '3x3PLL_T',
      name: 'T Permutation',
      category: 'PLL',
      group: 'Corner + Edge',
      algorithm: "R U R' U' R' F R2 U' R' U' R U R' F'",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Scambia 2 angoli adiacenti e 2 edge opposti."),
  OllPllCase(
      id: '3x3PLL_V',
      name: 'V Permutation',
      category: 'PLL',
      group: 'Corner + Edge',
      algorithm: "R' U R' d' R' F' R2 U' R' U R' F R F",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Scambia 2 angoli in diagonale e 2 edge adiacenti."),
  OllPllCase(
      id: '3x3PLL_Y',
      name: 'Y Permutation',
      category: 'PLL',
      group: 'Corner + Edge',
      algorithm: "F R U' R' U' R U R' F' R U R' U' R' F R F'",
      uFaceGrid: [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.threeByThree,
      note: "Scambia 2 angoli in diagonale e 2 edge opposti."),
];

const List<OllPllCase> allCases2x2 = [
  OllPllCase(
      id: '2x2_1',
      name: 'Adj/Adj',
      category: 'PBL',
      group: 'PBL',
      algorithm: "R2 U R2 U' R2 U R2 U' R2",
      uFaceGrid: [
        [0, 0],
        [0, 0]
      ],
      edgeBand: [2, 2, 3, 4],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_2',
      name: 'Adj/Opp',
      category: 'PBL',
      group: 'PBL',
      algorithm: "R U' R F2 R' U R'",
      uFaceGrid: [
        [0, 0],
        [0, 0]
      ],
      edgeBand: [2, 2, 3, 5],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_3',
      name: 'Diag/Adj',
      category: 'PBL',
      group: 'PBL',
      algorithm: "R U D' R U' R' D R2 F R' F' R",
      uFaceGrid: [
        [0, 0],
        [0, 0]
      ],
      edgeBand: [2, 4, 3, 3],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_4',
      name: 'Diag/Opp',
      category: 'PBL',
      group: 'PBL',
      algorithm: "F R U' R' U' R U R' F' R U R' U' R' F R F'",
      uFaceGrid: [
        [0, 0],
        [0, 0]
      ],
      edgeBand: [2, 4, 3, 5],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_5',
      name: 'Skip/Adj',
      category: 'PBL',
      group: 'PBL',
      algorithm: "R U R' U' R' F R2 U' R' U' R U R' F'",
      uFaceGrid: [
        [0, 0],
        [0, 0]
      ],
      edgeBand: [2, 3, 3, 2],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_6',
      name: 'Skip/Diag',
      category: 'PBL',
      group: 'PBL',
      algorithm: "F R U' R' U' R U R' F' R U R' U' R' F R F'",
      uFaceGrid: [
        [0, 0],
        [0, 0]
      ],
      edgeBand: [2, 4, 2, 4],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_7',
      name: 'OLL 1 (Pi)',
      category: 'OLL',
      group: 'OLL',
      algorithm: "R U2 R2 F R F' U2 R' F R F'",
      uFaceGrid: [
        [0, 0],
        [0, 0]
      ],
      edgeBand: [1, 0, 1, 0, 1, 0, 1, 0],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_8',
      name: 'OLL 2 (H)',
      category: 'OLL',
      group: 'OLL',
      algorithm: "F R U R' U' F' f R U R' U' f'",
      uFaceGrid: [
        [0, 0],
        [0, 0]
      ],
      edgeBand: [0, 1, 0, 1, 0, 1, 0, 1],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_9',
      name: 'OLL 3 (U)',
      category: 'OLL',
      group: 'OLL',
      algorithm: "f R U R' U' f' U' F R U R' U' F'",
      uFaceGrid: [
        [0, 0],
        [1, 1]
      ],
      edgeBand: [1, 1, 0, 0, 0, 0, 0, 0],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_10',
      name: 'OLL 4 (T)',
      category: 'OLL',
      group: 'OLL',
      algorithm: "f R U R' U' f' U F R U R' U' F'",
      uFaceGrid: [
        [0, 0],
        [1, 1]
      ],
      edgeBand: [0, 1, 0, 0, 0, 1, 0, 0],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_11',
      name: 'OLL 5 (L)',
      category: 'OLL',
      group: 'OLL',
      algorithm: "r' U2 R U R' U r",
      uFaceGrid: [
        [0, 1],
        [1, 0]
      ],
      edgeBand: [0, 0, 1, 0, 0, 0, 0, 1],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_12',
      name: 'OLL 6 (Sune)',
      category: 'OLL',
      group: 'OLL',
      algorithm: "R U R' U R U2 R'",
      uFaceGrid: [
        [1, 0],
        [0, 0]
      ],
      edgeBand: [0, 1, 0, 1, 0, 1, 0, 0],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_13',
      name: 'OLL 7 (Antisune)',
      category: 'OLL',
      group: 'OLL',
      algorithm: "R U2 R' U' R U' R'",
      uFaceGrid: [
        [0, 1],
        [0, 0]
      ],
      edgeBand: [1, 0, 0, 0, 1, 0, 1, 0],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_1',
      name: 'CLL 1',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_2',
      name: 'CLL 2',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_3',
      name: 'CLL 3',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_4',
      name: 'CLL 4',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_5',
      name: 'CLL 5',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_6',
      name: 'CLL 6',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_7',
      name: 'CLL 7',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_8',
      name: 'CLL 8',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_9',
      name: 'CLL 9',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_10',
      name: 'CLL 10',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_11',
      name: 'CLL 11',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_12',
      name: 'CLL 12',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_13',
      name: 'CLL 13',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_14',
      name: 'CLL 14',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_15',
      name: 'CLL 15',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_16',
      name: 'CLL 16',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_17',
      name: 'CLL 17',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_18',
      name: 'CLL 18',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_19',
      name: 'CLL 19',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_20',
      name: 'CLL 20',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_21',
      name: 'CLL 21',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_22',
      name: 'CLL 22',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_23',
      name: 'CLL 23',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_24',
      name: 'CLL 24',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_25',
      name: 'CLL 25',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_26',
      name: 'CLL 26',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_27',
      name: 'CLL 27',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_28',
      name: 'CLL 28',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_29',
      name: 'CLL 29',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_30',
      name: 'CLL 30',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_31',
      name: 'CLL 31',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_32',
      name: 'CLL 32',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_33',
      name: 'CLL 33',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_34',
      name: 'CLL 34',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_35',
      name: 'CLL 35',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_36',
      name: 'CLL 36',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_37',
      name: 'CLL 37',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_38',
      name: 'CLL 38',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_39',
      name: 'CLL 39',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_40',
      name: 'CLL 40',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_41',
      name: 'CLL 41',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
  OllPllCase(
      id: '2x2_CLL_42',
      name: 'CLL 42',
      category: 'CLL',
      group: 'CLL',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.twoByTwo),
];

const List<OllPllCase> allCases4x4 = [
  OllPllCase(
      id: '4x4_1',
      name: 'OLL Parity',
      category: 'OLL Parity',
      group: 'OLL Parity',
      algorithm: "Rw U2 x Rw U2 Rw U2 Rw' U2 Lw U2 Rw' U2 Rw U2 Rw' U2 Rw'",
      uFaceGrid: [
        [0, 1, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.fourByFour),
  OllPllCase(
      id: '4x4_2',
      name: 'Opposite',
      category: 'PLL Parity',
      group: 'PLL Parity',
      algorithm: "Rw2 U2 Rw2 Uw2 Rw2 Uw2",
      uFaceGrid: [
        [0, 1, 0],
        [0, 0, 0],
        [0, 1, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.fourByFour),
  OllPllCase(
      id: '4x4_3',
      name: 'Adjacent',
      category: 'PLL Parity',
      group: 'PLL Parity',
      algorithm: "(R' U R U') Rw2 U2 Rw2 Uw2 Rw2 Uw2 (U R' U' R)",
      uFaceGrid: [
        [0, 1, 0],
        [0, 0, 1],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.fourByFour),
];

const List<OllPllCase> allCases6x6 = [
  OllPllCase(
      id: '6x6_1',
      name: 'OLL Parity',
      category: 'OLL Parity',
      group: 'OLL Parity',
      algorithm:
          "3Rw U2 x 3Rw U2 3Rw U2 3Rw' U2 3Lw U2 3Rw' U2 3Rw U2 3Rw' U2 3Rw'",
      uFaceGrid: [
        [0, 1, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.sixBySix,
      note: "Outer 3 layers for wide moves"),
  OllPllCase(
      id: '6x6_2',
      name: 'Opposite',
      category: 'PLL Parity',
      group: 'PLL Parity',
      algorithm: "3Rw2 U2 3Rw2 Uw2 3Rw2 Uw2",
      uFaceGrid: [
        [0, 1, 0],
        [0, 0, 0],
        [0, 1, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.sixBySix,
      note: "Outer 3 layers for wide moves"),
  OllPllCase(
      id: '6x6_3',
      name: 'Adjacent',
      category: 'PLL Parity',
      group: 'PLL Parity',
      algorithm: "(R' U R U') 3Rw2 U2 3Rw2 Uw2 3Rw2 Uw2 (U R' U' R)",
      uFaceGrid: [
        [0, 1, 0],
        [0, 0, 1],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.sixBySix,
      note: "Outer 3 layers for wide moves"),
];

const List<OllPllCase> allCases5x5 = [
  OllPllCase(
      id: '5x5_1',
      name: 'Opposite',
      category: 'PLL Parity',
      group: 'PLL Parity',
      algorithm: "Rw2 U2 Rw2 Uw2 Rw2 Uw2",
      uFaceGrid: [
        [0, 1, 0],
        [0, 0, 0],
        [0, 1, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.fiveByFive),
  OllPllCase(
      id: '5x5_2',
      name: 'Adjacent',
      category: 'PLL Parity',
      group: 'PLL Parity',
      algorithm: "(R' U R U') Rw2 U2 Rw2 Uw2 Rw2 Uw2 (U R' U' R)",
      uFaceGrid: [
        [0, 1, 0],
        [0, 0, 1],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.fiveByFive),
];

const List<OllPllCase> allCases7x7 = [
  OllPllCase(
      id: '7x7_1',
      name: 'Opposite',
      category: 'PLL Parity',
      group: 'PLL Parity',
      algorithm: "3Rw2 U2 3Rw2 Uw2 3Rw2 Uw2",
      uFaceGrid: [
        [0, 1, 0],
        [0, 0, 0],
        [0, 1, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.sevenBySeven,
      note: "Outer 3 layers for wide moves"),
  OllPllCase(
      id: '7x7_2',
      name: 'Adjacent',
      category: 'PLL Parity',
      group: 'PLL Parity',
      algorithm: "(R' U R U') 3Rw2 U2 3Rw2 Uw2 3Rw2 Uw2 (U R' U' R)",
      uFaceGrid: [
        [0, 1, 0],
        [0, 0, 1],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.sevenBySeven,
      note: "Outer 3 layers for wide moves"),
];

const List<OllPllCase> allCasesPyraminx = [
  OllPllCase(
      id: 'Pyra_1',
      name: 'Skip',
      category: 'LL',
      group: 'LL',
      algorithm: " ",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_2',
      name: 'Flip 2 adj',
      category: 'LL',
      group: 'LL',
      algorithm: "R' L R L' U L' U' L",
      uFaceGrid: [
        [1, 1, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_3',
      name: 'U-PLL CW',
      category: 'LL',
      group: 'LL',
      algorithm: "R' U' R U' R' U' R",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_4',
      name: 'U-PLL CCW',
      category: 'LL',
      group: 'LL',
      algorithm: "L U L' U L U L'",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_5',
      name: 'Flip 2 opp',
      category: 'LL',
      group: 'LL',
      algorithm: "R' L R L' U' R U R'",
      uFaceGrid: [
        [1, 0, 1, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  // Remaining Pyraminx cases will get basic arrays, we fill with default orientations for now
  OllPllCase(
      id: 'Pyra_L4E_1',
      name: 'L4E 1',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_2',
      name: 'L4E 2',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_3',
      name: 'L4E 3',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [0, 1, 1, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_4',
      name: 'L4E 4',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 0, 0, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_5',
      name: 'L4E 5',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [0, 0, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_6',
      name: 'L4E 6',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 0, 1, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_7',
      name: 'L4E 7',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [0, 1, 0, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_8',
      name: 'L4E 8',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_9',
      name: 'L4E 9',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_10',
      name: 'L4E 10',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_11',
      name: 'L4E 11',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_12',
      name: 'L4E 12',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_13',
      name: 'L4E 13',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_14',
      name: 'L4E 14',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_15',
      name: 'L4E 15',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_16',
      name: 'L4E 16',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_17',
      name: 'L4E 17',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_18',
      name: 'L4E 18',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_19',
      name: 'L4E 19',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_20',
      name: 'L4E 20',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_21',
      name: 'L4E 21',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_22',
      name: 'L4E 22',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_23',
      name: 'L4E 23',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_24',
      name: 'L4E 24',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_25',
      name: 'L4E 25',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_26',
      name: 'L4E 26',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_27',
      name: 'L4E 27',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_28',
      name: 'L4E 28',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_29',
      name: 'L4E 29',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_30',
      name: 'L4E 30',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_31',
      name: 'L4E 31',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_32',
      name: 'L4E 32',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_33',
      name: 'L4E 33',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
  OllPllCase(
      id: 'Pyra_L4E_34',
      name: 'L4E 34',
      category: 'L4E',
      group: 'L4E',
      algorithm: "",
      uFaceGrid: [
        [1, 1, 1, 1]
      ],
      edgeBand: [],
      puzzle: CubeType.pyraminx),
];

const List<OllPllCase> allCasesMegaminx = [
  OllPllCase(
      id: 'Mega_1',
      name: 'Flipped All',
      category: 'EOLL',
      group: 'EOLL',
      algorithm: "F U R U' R' F' + rot + F U R U' R' F'",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.megaminx,
      note: ""),
  OllPllCase(
      id: 'Mega_2',
      name: 'Flipped L',
      category: 'EOLL',
      group: 'EOLL',
      algorithm: "F U R U' R' F'",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.megaminx,
      note: ""),
  OllPllCase(
      id: 'Mega_3',
      name: 'Flipped Line',
      category: 'EOLL',
      group: 'EOLL',
      algorithm: "F' R U R' U' F'",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.megaminx,
      note: ""),
  OllPllCase(
      id: 'Mega_4',
      name: 'Sune',
      category: 'OCLL',
      group: 'OCLL',
      algorithm: "R U R' U R U2 R'",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.megaminx,
      note: "(U2 = due turn da 72°)"),
  OllPllCase(
      id: 'Mega_5',
      name: 'Antisune',
      category: 'OCLL',
      group: 'OCLL',
      algorithm: "R U2 R' U' R U' R'",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.megaminx,
      note: "(U2 = due turn da 72°)"),
  OllPllCase(
      id: 'Mega_6',
      name: 'Pi',
      category: 'OCLL',
      group: 'OCLL',
      algorithm: "F R U R' U' R U R' U' F'",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.megaminx,
      note: ""),
  OllPllCase(
      id: 'Mega_7',
      name: 'H',
      category: 'OCLL',
      group: 'OCLL',
      algorithm: "F R U R' U' F' U F R U R' U' F'",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.megaminx,
      note: ""),
  OllPllCase(
      id: 'Mega_8',
      name: 'T',
      category: 'OCLL',
      group: 'OCLL',
      algorithm: "R U R' U' R' F R F'",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.megaminx,
      note: ""),
  OllPllCase(
      id: 'Mega_9',
      name: 'U',
      category: 'OCLL',
      group: 'OCLL',
      algorithm: "R U2 R2 U' R2 U' R2 U2 R",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.megaminx,
      note: ""),
  OllPllCase(
      id: 'Mega_10',
      name: 'L',
      category: 'OCLL',
      group: 'OCLL',
      algorithm: "F' r U R' U' r' F R",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.megaminx,
      note: ""),
  OllPllCase(
      id: 'Mega_11',
      name: 'CW',
      category: 'EPLL',
      group: 'EPLL',
      algorithm: "R U R' U R U3 R' U",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.megaminx,
      note: "U3 è equivalente a U'2"),
  OllPllCase(
      id: 'Mega_12',
      name: 'CCW',
      category: 'EPLL',
      group: 'EPLL',
      algorithm: "U' R U2 R' U' R U' R'",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.megaminx,
      note: ""),
  OllPllCase(
      id: 'Mega_13',
      name: 'Skip',
      category: 'EPLL',
      group: 'EPLL',
      algorithm: " ",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.megaminx,
      note: ""),
  OllPllCase(
      id: 'Mega_14',
      name: 'CW',
      category: 'CPLL',
      group: 'CPLL',
      algorithm: "L' U2 R U'2 L U2 R' U'2",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.megaminx,
      note: ""),
  OllPllCase(
      id: 'Mega_15',
      name: 'CCW',
      category: 'CPLL',
      group: 'CPLL',
      algorithm: "U2 R U'2 L' U2 R' U'2 L",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.megaminx,
      note: ""),
  OllPllCase(
      id: 'Mega_16',
      name: 'Skip',
      category: 'CPLL',
      group: 'CPLL',
      algorithm: " ",
      uFaceGrid: [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ],
      edgeBand: [],
      puzzle: CubeType.megaminx,
      note: ""),
];

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
