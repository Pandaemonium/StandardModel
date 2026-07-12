# Literature and public Lean-package search log

Run at least every 30 minutes. Use primary full text before relying on theorem
content. Abstract or metadata checks may rank sources but do not establish an
internal claim.

Format:

```text
YYYY-MM-DD HH:MM PDT | Agent | Topic | Method/query | Ranked primary sources or packages | Finding used | Follow-up
```

Starting priorities:

- CGGSVWZ/Cedzich real-space indices and finite-walk stability;
- Shannon interpolation and strong quantum-walk continuum limits;
- interacting fermionic QCA and exact CAR dynamics;
- GNVW one-particle index and Laurent conventions;
- finite Dirac/spectral-triple moduli and Krein positive subspaces;
- Furey/Baez/Dixon octonion conventions and formalization comparisons.
- Baez-Schwahn arXiv:2606.15235: exact nested-subalgebra stabilizer,
  connected-component, transitivity, and complement statements;
- Furey arXiv:1603.04078: both conjugate ideals, occupation degrees, charges,
  and triplet/antitriplet conventions;
- Baez-Huerta exterior-algebra/Spin(10) organization and exact global quotient;
- `G2 -> SU(3)` Yang-Mills-Higgs order parameters and the metadata problem for
  the source cited as arXiv:1111.0496;
- Furey-Hughes triality versus Gresnigt `S3` generation mechanisms, including
  Higgs/Yukawa intertwiners and phenomenological discriminators.

## 10:14 PDT Fable lit pass 1 (E dynamics; JC exterior/Z6)

- E/Trotter + JC/exterior-Spin(10) arXiv keyword searches empty
  (over-AND + rate limits); the load-bearing anchors are already
  verified and in the graph: Thirring QCA 1711.03920 (free step +
  on-site interaction composition; exact two-particle sector) and
  2406.19917 for E; Baez-Huerta 0904.1556 sec 3 (one generation + nu_R
  = Lambda C^5 as the Spin(10) 16, even/odd split) is the primary
  citation for JC4's exterior_even(W+V) dim-16 module - no new search
  needed, provenance already in the manuscript bibliography.
- New analysis note (E lane): the landed 4-mode pair kick K(z) has
  K^3 = |z|^2 K (acts on a 2-dim pair block), so exp(-i alpha K) has an
  exact closed form: 1 + ((cos(|z| alpha) - 1)/|z|^2) K^2
  - i (sin(|z| alpha)/|z|) K. The P3 item-1 "derivation from a finite
  Hermitian generator" is therefore a small exact theorem: the landed
  pairKick should BE exp(-i alpha0 K) at the right parameter. Oracle
  verification next; then a focused kernel job.

## 10:50 PDT Codex lit pass 1 (B/D/F and Jordan-flag scope)

- Read primary full text for Gross--Nesme--Vogts--Werner,
  arXiv:0910.3675. Its translation-invariant walk result identifies the
  integer walk index from `det Uhat(p) = exp(i p n)`; the cellular-automaton
  index is instead positive rational. Consequence: Paper B may bridge the
  Laurent determinant exponent only to the one-particle walk index, never to
  the many-body GNVW QCA index.
- Read Arrighi--Forets--Nesme, arXiv:1307.3524, for the consistency,
  stability, and convergence framework for space-discretized quantum walks.
  Consequence: the landed growing-window theorem is a modewise consistency
  rung; sampling/interpolation and a normed position-space convergence
  statement remain separate obligations.
- Read Cacic, arXiv:0902.2068, on moduli of Dirac operators for finite
  spectral triples. Consequence: Paper F must compare its decorated-carrier
  quotient with genuine finite spectral-triple moduli and must not advertise
  the finite Ward witness as a complete moduli classification.
- Rechecked Baez--Schwahn, arXiv:2606.15235. The identity component in
  `Stab(X) cap Stab(B)_0` is load-bearing, and the transitivity result is the
  external intrinsic glue beyond the repository's coordinate models.
  Consequence: JC1 preserves the connected-component hypothesis and keeps the
  full stabilizer/transitivity layer source-verified rather than machine-graded.

## 11:39 PDT Codex lit pass 2 (Furey conventions and local G2 order parameter)

- Verified Furey, "Charge quantization from a number operator", as
  arXiv:1603.04078 in primary full text. The paper explicitly gives the
  occupation spectrum `0,1,1,1,2,2,2,3`, identifies `Q=N/3`, distinguishes
  the conjugate ideal via complex conjugation, and states the ladder CAR as
  relations of associative left-action operators. Consequence: corrected two
  stale repository provenance comments that incorrectly cited `1603.04783`;
  JC2's signed Fock-action target matches the source's operator-level reading.
- Verified arXiv:1111.0496 metadata: Wellegehausen, "Phase diagram of the G(2)
  Higgs model and G(2)-QCD". It is relevant but its abstract is less direct
  about the subgroup reduction than Holland--Minkowski--Pepe--Wiese,
  arXiv:hep-lat/0302023, and Pepe--Wiese, arXiv:hep-lat/0610076. The latter two
  explicitly state that a scalar in the fundamental `7` breaks `G2` to
  `SU(3)`; the 2003 source also states `14 -> 8 + 3 + 3bar` under `SU(3)`.
  Consequence: the local-order-parameter lane now has exact primary metadata,
  while dynamical/phenomenological claims remain external and model-specific.

## 11:58 PDT Codex lit pass 3 (paraunitary rigidity and the first SU(3) factor)

- Rechecked Baez--Schwahn, arXiv:2606.15235, against the new JC1 target. The
  paper's intrinsic theorem remains `Stab(X) cap Stab(B)_0`, while the submitted
  Lean target proves only the coordinate first-factor statement: conjugation by
  a unitary `3 x 3` matrix preserves the chosen upper `h2(C)` block iff it is
  block diagonal for the `2+1` split. The identity-component and `F4`
  transitivity claims remain external.
- Searched the paraunitary/Laurent-polynomial literature, including Hur--Okoudjou,
  arXiv:1409.6938, and the orthogonal Laurent-polynomial literature. The
  terminology confirms that a Laurent-polynomial matrix unitary on the circle
  is paraunitary, while the exact proof obligation for our build is narrower:
  show its determinant is a constant-modulus Laurent monomial and then use the
  adjugate/determinant unit criterion. No external implementation is needed;
  Aristotle `4644f3df-cda8-411d-84dc-dc3c7536b058` is tasked with a clean-room
  Mathlib proof and an explicit failure report if the statement is malformed.

## 12:33 PDT Codex lit pass 4 (global quotient and paraunitary factorization)

- Cvetic--Lin, arXiv:1706.08521, supplies an independent primary example in
  which the Standard Model algebra realizes the global group
  `[SU(3) x SU(2) x U(1)]/Z6`. This supports the importance of the quotient,
  but not our representation-kernel derivation; the new finite additive
  character theorem remains program-internal and the continuous action lift
  remains open.
- Alpay--Jorgensen--Lewkowicz, arXiv:1410.0283, characterizes rational
  paraunitary functions using Blaschke--Potapov products and matrix-fraction
  descriptions. This is useful architecture for Paper B's successor, but the
  live Lean target stays narrower: a finite Laurent matrix pointwise unitary on
  the circle should have a finite Laurent inverse. No external code is copied.

## 13:22 PDT Codex lit pass 5 (even polyforms and the origin of the `2+3` split)

- Read Krasnov, arXiv:2209.05088, in primary full text. The paper explicitly
  models `Spin(10)` Weyl spinors as even/odd polyforms on `C^5`, identifies the
  compatible Pati--Salam choice with a split `C^5 = C^2 + C^3`, and states in
  Theorem A that the Standard Model subgroup stabilizes one pure spinor and
  projectively stabilizes an orthogonal second pure spinor whose linear span is
  pure. This is the best verified external route from geometric spinor data to
  the weak/color split; it also confirms that the split is selected structure,
  not something the current block-action module has derived.
- No useful primary source was found that would improve the exact Lean proof
  obligation `Lambda^4(g) = 1` plus `det(g)=1` implies `g=1`. Treat it as
  elementary finite-dimensional linear algebra, not as a literature-derived
  physics claim. Aristotle `ca0e21e7` has the exact formal target.

## 13:07 PDT Codex lit pass 6 (stabilizer action on the derived weak quotient)

- Ran full-text chunk search for pure-spinor pairs, common annihilators,
  quotient representations, and weak `SU(2)`. The strongest directly relevant
  primary hit remains Krasnov's pure-spinor characterization and its selected
  `C^5 = C^2 + C^3` structure from the preceding pass. Nearby division-algebra
  papers discuss `SU(3) x SU(2) x U(1)` actions on ladder-operator spaces, but
  they do not supply the missing theorem that the stabilizer of this project's
  fixed ordered spinor pair descends to the quotient
  `N1 / (N1 intersect N2)` with the physical weak action.
- Consequence for the run: retain the new quotient as a derived complex
  two-space only. The next literature-sensitive formal target is stabilizer
  invariance of `N1`, invariance of the common annihilator, and equivariance of
  the quotient map; only after those gates may the induced action be compared
  with the defining `SU(2)` representation.

## 13:23 PDT Codex lit pass 7 (strong continuum limits for quantum walks)

- Full-text chunk search ranked Mlodinow--Brun, arXiv:1802.03910, and Arrighi
  et al. quantum-walk continuum papers as the closest primary comparators. The
  former explicitly formulates a continuum limit by scaling both spatial and
  temporal lattice units and deriving the limiting relativistic wave equation;
  the surrounding literature likewise treats the limiting evolution, not only
  pointwise multiplier convergence, as the physical result.
- Manuscript consequence: the new weighted countable aggregation theorem is a
  legitimate strong coefficient-space advance, but Paper D must remain
  theorem-gated until the live quartic walk error is instantiated and the
  sampling/interpolation plus Fourier-isometry layer identifies the limiting
  position-space Dirac flow. Do not relabel the current result a PDE limit.

- 2026-07-11 14:15 PDT | JC/B successor pass | Neo4j abstract + full-text chunk search | Krasnov/pure-spinor stabilizer retrieval remained weak; the closest internal anchor was Furey 2018 (`arXiv:1806.00612`) for the five-ladder `SU(3)_C x SU(2)_L x U(1)` action, while no hit licensed upgrading the new coordinate `so(10)` quotient generator to physical `SU(2)_L`. For Paper B, Gross et al. (`arXiv:1804.04520`) remained the best classification anchor, but the graph did not surface a proof of constant-modulus Laurent-polynomial rigidity; keep that scalar theorem as a separate complex-analysis/algebra gate rather than citing the quantum-walk literature as if it proves it.

- 2026-07-11 14:50 PDT | Paper D Fourier/PDE bridge pass | `lean-explore` over Mathlib plus Neo4j abstract/full-text search | Mathlib's `Mathlib.Analysis.Fourier.AddCircleMulti` already supplies `UnitAddTorus.mFourierBasis`, an isometric Hilbert-basis equivalence between torus `L2` and square-summable `Z^d` coefficients, together with `hasSum_mFourier_series_L2`, `hasSum_sq_mFourierCoeff`, and `orthonormal_mFourier`. This licenses a fixed-torus `L2` transport of the newly landed complete coefficient theorem. It does not by itself supply changing-lattice sampling/interpolation or an `R^3` Dirac PDE limit. Primary comparison hits remain Arrighi--Di Molfetta (`arXiv:1803.01015`), Mlodinow--Brun (`arXiv:1802.03910`), and the `3+1` Dirac quantum-walk paper (`arXiv:1603.06442`); their continuum discussions reinforce that the physical gate concerns the limiting evolution, not merely pointwise multipliers.

- 2026-07-11 15:25 PDT | JC exact-kernel / Paper D continuum-boundary pass | primary arXiv search plus Mathlib cross-check | Baez--Schwahn (`arXiv:2606.15235`) supports the intrinsic nested-Jordan stabilizer and coordinate-independence program, but its stated result does not supply the exterior-fermion action or prove that action's exact kernel; retain those as this project's separate bridge theorems. For continuum comparison, Arrighi--Forets--Nesme (`arXiv:1307.3524`) proves observational convergence of a lattice walk to the continuum Dirac solution, while Maeda--Suzuki (`arXiv:1902.02017`) explicitly compares `delta Z` with `R` using Shannon interpolation and proves Sobolev convergence. These sources sharpen the boundary: the newly completed Mathlib-Parseval theorem is a legitimate fixed-`T^3` strong-L2 result, but the publication-grade `R^3` claim still owes an explicit changing-lattice Shannon map and comparison to the continuum Dirac flow.

## 2026-07-11 15:30 PDT - Fable lit pass: SMG / embrace-doubling (Route C anchors)

- Query: symmetric mass generation mirror decoupling chiral gauge.
- In-graph with full text: Golterman-Shamir arXiv:2311.12790 (propagator
  zeros vs SMG) + arXiv:2505.20436 (constraints on SMG for lattice
  chiral gauge) - the adversarial pair for Route C; anchored in
  MEMO_3PLUS1_ATTACK.md 5b. Also relevant: 2105.10977 (naive fermion
  without doublers - claim to scrutinize), 2311.02487 (Kaehler-Dirac
  reduced fermions route).
- Route C manuscript use requires exact-statement checks of both G-S
  papers (chunks available); internal memo anchoring done.
## 2026-07-11 16:05 PDT - changing-spacing R3 interpolation after D-R3-1

- Full-text chunk search confirms the next theorem must separate sampling from
  evolution: Mlodinow--Brun (`arXiv:1802.03910`, continuum-limit section)
  introduces independent spatial and temporal scales before deriving the
  relativistic equation; Arrighi--Facchini--Forets (`arXiv:1505.07023`) treats
  local unitary walks whose continuum equation is obtained after an explicit
  scaling procedure.
- Maeda--Suzuki (`arXiv:1902.02017`, retained anchor from the preceding pass)
  remains the closest rigorous Shannon-interpolation reference for comparing a
  changing `delta Z` lattice with `R`; its Sobolev control is more relevant to
  D-R3-3/4 than fixed-torus DFT identities.
- A new adjacent architecture hit, `Convergence of Discrete Exterior Calculus
  for the Hodge-Dirac Operator` (`arXiv:2507.19405`), emphasizes commuting
  interpolation diagrams. It is not evidence for this walk, but its proof
  architecture supports making the sampling/evolution square commute rather
  than identifying coefficient convergence with PDE convergence by prose.
- Consequence: after the landed exact cell isometry, prioritize changing-box
  exhaustion plus a scaled-symbol intertwining theorem; keep the final Dirac
  generator identification as a separate named gate.
2026-07-11 16:25 PDT | Codex | Corrected strict 3+1 charge route | Primary full-text/source audit: Read arXiv:1608.04696v3 explicitly gives `K_1(C[X_1^+-,...,X_d^+-]) ~= C^* + d Z` via Bass-Heller-Swan and says the change-of-rings image has no nonzero `SK_1`/higher-dimensional strong component; notation warning, Read's `R_1` is complex and `R_3` quaternionic. Bessho-Sato arXiv:2006.04204 supplement ties local Floquet charges to bulk topology with a dimension-dependent pi-gap sign. Higashikawa et al. arXiv:1806.06868 and Gupta-Short arXiv:2601.15885v2 retained as positive/escape controls. Composition, finite-rank stabilization, and sign conventions remain VERIFY. Full audit: `B_STRICT_LAURENT_SOURCE_AUDIT_2026-07-11.md`.
2026-07-11 17:04 PDT | Spark/Codex | Global chiral Floquet composition | Bessho-Sato arXiv:2006.04204v3 Theorems 2 and 3' are the closest primary-source loci for three-dimensional local Weyl charge and zero/pi Floquet bookkeeping; Read arXiv:1608.04696v3 remains the separate strict-Laurent stable obstruction. No single finite-rank theorem composes them. Spark report is a locator, not authority: its Read Eq. (64) `K0` discussion does not replace the direct `K1` audit. Full report: `SPARK_LIT_GLOBAL_CHIRAL_FLOQUET_2026-07-11.md`.

[2026-07-11] LIT sidecar: scanned local Neo4j+chunks + primary sources for 2006.04204, 1806.06868, 1705.08552, 1802.03910. Full-text chunks present only for 1802.03910. 0/pi sector split explicitly detailed in 2006.04204; ordered Pauli-product census match found only partially via directional factorized constructions (closest in 1802.03910), not exact theorem form. 16-crossing BCC+cube-corner cancellation appears novel at this architecture level.
2026-07-11 20:12 PDT | Codex direct fallback (Spark context failure) | reciprocal conditional shifts / paraunitary factorization / strict 3+1 successors | Cedzich-Geib-Werner Thm 2.1 makes shift-coin words complete for 1D banded walks; Gupta-Short 3+1 stationary-amplitude family still leaves two extraneous low-energy solutions; Arrighi-Nesme-Werner legitimizes enlarged-cell layered QCA; no exact all-torus single-cone construction found | `SPARK_LIT_RECIPROCAL_SHIFT_PAIRING_2026-07-11.md`
2026-07-11 20:58 PDT | direct fallback (Spark unavailable) | strict 3+1 flavoured/minimal doubling | arXiv:2505.07900 gives a covering-map flavour QCA with enlarged sublattice/register; arXiv:2601.15885 gives exact stationary-amplitude local unitaries but retains two extra low-energy Weyl solutions | `SPARK_LIT_FLAVOURED_MINIMAL_DOUBLING_2026-07-11.md`
2026-07-12 15:00 PDT | LIT bot | D-gate cell-average convergence search | Neo4j abstract + --chunks via Scripts/lit/neo4j_paper_search.py | failed: NEO4J connection refused at 127.0.0.1:7687; fell back to Lean/web sources (mathlib+ergodic refs) | proceed with Lean APIs + external theorem-matching plan
