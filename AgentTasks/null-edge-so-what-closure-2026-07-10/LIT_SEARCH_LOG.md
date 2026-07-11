# Literature and Lean-reference log

2026-07-10 14:31 PDT | Flagship A defect/index extraction | Spark + local Lean inventory | Strongest landed finite index shape is `WindingLowModes.windingDirac_index` with protection in `IndexProtectionBridge`; `IndexAnomalyInterface` already states the exact reduction bucket needed for a future local `D_z`; explicit controls are `N=3,w=1`, `w=0`, `z=3+4i`, and `z=0`; primary context includes Mlodinow-Brun arXiv:1802.03910, Arrighi et al. arXiv:1803.01015, Debbasch arXiv:1806.02313, and the current doubling/QCA literature | Next: define position-dependent `z` operator and prove or refute the reduction.
2026-07-10 15:03 PDT | Codex/Spark | Spatial `z(x)` to finite winding/index/defect mode | Neo4j chunks + repo APIs | No instantiated bridge exists; strongest route is `VariablePlueckerLocalWalk` plus `VariablePlueckerPhaseConnection` reduced to the canonical `F4Winding` operator, with `(N,w)=(3,1)` as the nonzero kernel witness and `w=0` as the kill control; relevant domain-wall/spectral-flow leads include arXiv:2402.09774 and arXiv:1011.0761. |
2026-07-10 | literature_search | focused_scan_3p1_QCA_QW_doubling | hits=2505.07900,2601.15885,2105.12314,1603.06442,1802.03910,1708.00826,2404.09840,2011.05597,1509.08851,1208.2143 | focus=strictly finite-range unitary constructions; zero/pi doubling; BCC/tetrahedral cell choices; split-step and Wilson-like unitary dilation

## 06:31 PDT 2026-07-11 (Fable) - comprehensive blocker review (user-requested)

Per-blocker anchors, all IDs verified via crossref/arXiv metadata (not eyeballed):

1. C protection law (gates 1-2, decisive): Cedzich, Geib, Werner, Werner,
   "Chiral Floquet Systems and Quantum Walks at Half-Period", Ann. Henri
   Poincare 22 (2021), arXiv:2006.04634, DOI 10.1007/s00023-020-00982-6.
   Complete classification of chiral half-step operators by FIVE integer
   indices; two timeframes from one half-step operator; bulk-edge
   correspondence; a second timeframe distinguishes protected +1 vs -1
   states, impossible for a single timeframe. Our palindromic S.C.S walk is
   exactly a symmetric-timeframe walk; the 8-vs-4 equal-winding split is the
   single-frame insufficiency their second-timeframe index resolves.
   ACTION: design job f4879a60 (submitted pre-freeze, RUNNING) computes the
   half-step/second-timeframe indices on our fixtures and delivers Lean-ready
   statements or an honest negative. Related anchors from the same sweep:
   mirror-graded winding (PMC5705599, graphene), time-glide walks
   (arXiv:2004.09332), mirror-protected DQPTs (arXiv:2105.12768).
2. E interaction derivation (R7 demand 1): Bisio, D'Ariano, Perinotti,
   Tosini, "The Thirring quantum cellular automaton", PRA 97, 032132 (2018),
   arXiv:1711.03920 (exact two-particle diagonalization); Bisio, Perinotti,
   Pizzamiglio, Rota, arXiv:2406.19917, Entropy 27, 198 (2025)
   (perturbative path sums; results for ANY on-site number-preserving 1D
   interaction). Finding: the field APPENDS the interaction to the free
   automaton by definition - nobody derives it. R7 demand (1) is an open
   problem in the field; our Gamma(U) pair-minor route is a candidate
   answer, not a missing feature. Register R7 updated.
3. 3+1 architecture (R3): Bisio, D'Ariano, Perinotti, Tosini,
   arXiv:1601.04832, Found. Phys. (2015) and D'Ariano, Perinotti,
   arXiv:1608.02004 - Weyl/Dirac/Maxwell QCAs derived from
   unitarity+locality+homogeneity+isotropy on Cayley graphs; the BCC Weyl
   automaton is the standard 3+1 comparison object for our
   axis-block/tetrahedral no-gos. Register R3 updated.
4. Companion novelty (mixedness): Peres, Terno, RMP 76, 93 (2004),
   arXiv:quant-ph/0212023 ("spin entropy is not a relativistic scalar and
   has no invariant meaning"); Gingrich, Adami, PRL 89, 270402 (2002),
   arXiv:quant-ph/0205179 (boosts interchange spin/momentum entanglement).
   Adjacent line studies frame-VARIATION of reduced-state mixedness; our
   identity pins mixedness frame-by-frame to mu^2/T^2 with the invariant in
   the numerator - complementary, not overlapping. Companion draft: fourth
   boundary paragraph + 2 bibitems added.
5. Wetterich CA-fermion line noted for context (arXiv:2203.14081,
   2007.06366, 2111.06728): probabilistic classical automata equivalent to
   interacting fermionic QFTs incl. Thirring-type - different program
   (classical statistics), relevant to GA-paper related work only.

Zotero ingest of 2006.04634 + 1711.03920 deferred to the existing
rate-limited queue (with 1003.1729, 1208.2143, 1611.04439, 2603.15770).

## 06:57 PDT 2026-07-11 (Fable) - advisor citation verification (C lane)

All four H5 citations verified via arXiv metadata; corrections to
from-memory details:
- Asboth, PRB 86, 195414 (2012) = arXiv:1208.2143: PH-symmetric walk (NO
  chiral symmetry there; "topology arises from particle-hole symmetry
  alone"); notable for us: protected edge states between bulks with the
  SAME Floquet operator. In deferred Zotero queue already.
- Asboth-Obuse, PRB 88, 121406(R) (2013) = arXiv:1303.1199: THE two-frame
  origin ("timeframes", inversion-symmetric pulse sequence, bulk ZxZ
  invariant controlling 0 and pi edge states). This, not 1208.2143, is
  the load-bearing two-frame citation.
- CGGSVWZ = Cedzich, Geib, GRUNBAUM, Stahl, Velazquez, Werner, Werner,
  arXiv:1611.04439, Ann. Henri Poincare (2018), DOI
  10.1007/s00023-017-0630-x: real-space tenfold classification, no
  translation invariance, left/right indices stable under compact
  perturbations, sum = lower bound on +-1 eigenstates, FINITE-lattice
  discussion included (directly relevant to our L=8 cycle). In deferred
  queue already.
- Companion: Cedzich, Geib, Stahl, Velazquez, Werner, Werner,
  arXiv:1804.04520, Quantum 2, 95 (2018): complete homotopy invariants,
  translation-invariant case, winding-number formulas for all symmetry
  types (the advisor's six-name list matches THIS paper).
- Bonus shortest-path cite for exact +-1 modes: Cedzich, Grunbaum, Stahl,
  Velazquez, Werner, Werner, arXiv:1502.02592, J. Phys. A 49, 21LT01
  (2016): index sum lower-bounds the number of +1/-1 eigenstates.
