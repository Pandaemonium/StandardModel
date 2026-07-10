# LATEST_COMPOSITION_AUDIT_07 — closed quantum engine and arbitrary-mass chain

Independent source-level audit for job
`codex-composition-audit-20260710-07`.
Scope: the six `Sources/` snapshots
(`CheckerboardPathSumTransferPower`, `CheckerboardOperatorHistoryBridge`,
`UnitaryHistoryComposition`, `UnitaryCheckerboardTransfer`,
`ArbitrarySpinorHodgeBridge`, `D4NullRaySpinorFactorization`), the four
`Targets/` proof targets (`PluckerAction`, `SixFour`, `D4Walk`,
`GeometricModes`), the prior audit
(`Docs/2026-07-10_ARISTOTLE_POST_KEYSTONE_AUDIT_06.md`), both control matrices
(`Docs/MANUSCRIPT_CLAIM_MATRIX.md`, `Docs/THEORY_COMPLETION_MATRIX.md`), and the
benchmark manifest (`Docs/SIMULATION_BENCHMARKS.md`).

**No source files were edited.** Findings first, ordered by severity.

Grades: `CLOSED` (statement proves exactly what its caption claims and is a
landed, non-`s o r r y` theorem), `PARTIAL` (statement is honest but strictly
narrower than the surrounding prose, or rests on supplied data / an absent
import), `OPEN` (the claimed arrow is a `s o r r y` target, or is not in the kernel
at all).

Verification legend:
- `[verified-here]` re-elaborated in this Lean/Mathlib (v4.28.0), or its
  arithmetic/orientation re-derived here in a self-contained snippet.
- `[source-only]` module imports upstream `PhysicsSM.Draft.NullEdge.*` /
  `PhysicsSM.Spinor.*` files **absent** from this package; it cannot be
  recompiled here and its `#print a x i o ms … #guard_msgs` guard is **not
  enforceable in this tree**. Per the task the live repo passes
  `OvernightTheoryAxiomGuard` (8067 jobs) with declaration scans reporting only
  `[propext, Classical.choice, Quot.sound]`; this is **not** a live-tree
  failure. Every statement below is audited from source text and re-derived
  arithmetic, not from an executed guard here.
- `[s o r r y-target]` a proof target under `Targets/` whose body is `by s o r r y`; the
  statement is audited and its truth re-derived here, the proof does not exist.

---

## F0 (SEVERITY: MEDIUM) — build surface unchanged; landings source-only, targets `s o r r y`

Three structural facts frame every grade.

1. **The only default-buildable target is a stub.** `lakefile.toml` builds
   exactly `defaultTargets = ["Audit"]` = `Audit/Core.lean`, whose sole theorem
   is `LatestCompositionAudit.package_marker : True` `[verified-here]`. It proves
   nothing about the corpus.

2. **Five of six `Sources/` snapshots are `[source-only]`.** They import
   absent upstreams (`PhysicsSM.Draft.NullEdge.CheckerboardPathSumTransferPower`,
   `…HistoryOperatorMonoidalDagger`, `…Carrier.HodgePluckerMassBridge`,
   `…GeneralGramTurnScale`, `…D4NullShellLattice`, `PhysicsSM.Spinor.PluckerMass`,
   …). Their `#print a x i o ms` guards cannot run here. **Exception:**
   `Sources/CheckerboardPathSumTransferPower.lean` imports **only `Mathlib`** and
   is the sole in-package self-contained Source (its `directionPathSum`,
   `transfer`, `directionPathSum_eq_transfer_pow`, and integer `85` witness are
   independent of the absent tree).

3. **All four `Targets/` files import only `Mathlib` and are `s o r r y` stubs.**
   Every headline theorem in `PluckerAction`, `SixFour`, `D4Walk`,
   `GeometricModes` is `by s o r r y`; each is `OPEN` until a non-`s o r r y` proof
   lands. Their statements were re-derived here and are true and non-vacuous
   (details per question). No matrix row may read a `Targets/` statement as
   achieved.

Recommendation: keep the five upstream-importing `Sources/` snapshots at
`[import]`/source-only in this package, mark
`CheckerboardPathSumTransferPower` in-package-buildable, and mark the four
`Targets/` rows `OPEN / s o r r y`.

---

## Q1 — Do `physicalTransfer_eq_transfer`, exact path-sum equality, transfer unitarity, and replicated-history unitarity form one orientation-correct finite quantum chain? What normalized parameters remain supplied?

Modules: `CheckerboardPathSumTransferPower` (`[verified-here]`, Mathlib-only),
`CheckerboardOperatorHistoryBridge`, `UnitaryHistoryComposition`,
`UnitaryCheckerboardTransfer` (`[source-only]`; orientation + witness arithmetic
`[verified-here]`).

**Verdict: YES — the four results compose into one orientation-correct finite
quantum chain, in 1+1 (two directions). Grade CLOSED\* as a theorem chain for the
supplied normalized parameters; PARTIAL for physics (nothing derives those
parameters, and the chain is 2-dimensional, not the 6-direction D4 walk).**

Chain, each arrow re-derived here:

1. **Exact path sum = transfer power.**
   `directionPathSum_eq_transfer_pow`: the finite sum over all length-`n`
   two-direction histories (one turn weight `turnWeight mu`, one outgoing phase
   per step) equals `(transfer mu phase ^ n) finish start`, over any
   `CommSemiring`. Orientation: `transfer finish start = turnWeight mu start
   finish * phase finish` — **rows = outgoing/final direction, columns =
   incoming**, phase on the outgoing step. `directionPathSum … start finish` is
   read at matrix index `(finish, start)`; the transposed index order is
   internally consistent (propagation column→row) and matches
   `Matrix.mul_apply`. Nonzero control `two_step_nontrivial_witness`: value `85`,
   off-diagonal entries nonzero (excludes straight-only / diagonal collapse).

2. **Path sum = operator history.**
   `pathSum_as_operator_history`: `directionPathSum mu phase n start finish =
   historyOperator (List.replicate n (transfer mu phase)) finish start`, via
   `directionPathSum_eq_transfer_pow` + `List.prod_replicate`. Fixture
   `two_step_operator_history_witness` = `85` on both sides. This is the first
   arrow from the primitive direction-history layer to the operator-valued
   monoidal layer.

3. **Physical transfer = the same transfer, and is unitary.**
   `physicalTransfer_eq_transfer` (**orientation `[verified-here]`**):
   `physicalTransfer c s uL uR = transfer (I·s/c) (fun left ↦ c·uL, right ↦
   c·uR)` when `c ≠ 0`. I re-derived all four entries: `(left,left)=c·uL`,
   `(left,right)=I·s·uL`, `(right,left)=I·s·uR`, `(right,right)=c·uR`, matching
   `turnWeight(mu; start,finish)·phase(finish)` with `mu = I·s/c` — the outgoing
   phase attaches to the row (final) direction, consistent with the path-sum
   convention. `physicalTransfer_unitary`: two-sided unitary under
   `c²+s²=1`, `normSq uL = normSq uR = 1`, factored as
   `outgoingPhase · turnCoin` with each factor unitary.

4. **Replicated history unitary.** `physical_transfer_history_unitary`:
   `IsUnitary (historyOperator (List.replicate n (physicalTransfer c s uL uR)))`
   via the already-landed `replicated_history_operator_unitary`
   (`UnitaryHistoryComposition`), which itself rests on `historyOperator_unitary`
   (sequential), `parallel_history_operator_unitary` (Kronecker), and
   `isUnitary_kronecker`. `IsUnitary` is two-sided (`Uᴴ U = 1 ∧ U Uᴴ = 1`)
   throughout — no one-sided vacuity.

**Witness / control `[verified-here]`:**
`rational_massive_transfer_controls`: `(c,s,uL,uR)=(3/5,4/5,1,I)` is two-sided
unitary and `≠ 1` (nontrivial: diagonal `UᴴU` entries `9/25+16/25=1`, off-diag
`0`), while the real-turn `wrongRealTurnTransfer` (`3/5` diagonal, `4/5`
off-diagonal) is **not** unitary — I re-derived its off-diagonal overlap
`(3/5)(4/5)+(4/5)(3/5)=24/25 ≠ 0`. So the imaginary turn phase `I` is
load-bearing.

**Normalized parameters that remain SUPPLIED (not derived):**
- `(c, s)` with `c²+s²=1` — the coin amplitudes (straight/turn split); the
  turn/straight ratio `s/c` is the checkerboard "mass" input.
- `uL, uR` with `normSq = 1` — unit-modulus outgoing phases.
- `mu = I·s/c` and outgoing phases `c·uL, c·uR` are then determined, but the
  identification `physical = transfer` **requires `c ≠ 0`** (pure-turn `c=0` is
  still unitary but is outside the transfer-power/path-sum identification).
- Nothing selects these from primitive null data; the chain is **1+1**
  (`Direction = {left, right}`), disconnected from the 6-direction `D4Walk` coin,
  the `4×4` Clifford symbol, and the `2`-spinor decorations (see Q4).

This is exactly the arrow Audit-06 nominated as the highest-value next theorem
(`physicalTransfer_unitary` + history corollary). It has landed (source-only),
upgrading `THEORY_COMPLETION` "Quantum composition" from PARTIAL to CLOSED\* for
supplied normalized parameters.

---

## Q2 — Does `ArbitrarySpinorHodgeBridge` genuinely compose arbitrary D4 spinor decorations into the same Hodge/Pluecker mass API? Which selection rules remain definitional?

Module: `ArbitrarySpinorHodgeBridge` (`[source-only]`; arithmetic
`[verified-here]`).

**Verdict: YES — it genuinely extends the mass bridge from the single canonical
pair `(edge0, edge1 m)` to an *arbitrary* decorated pair `(psi, phi)`, which is
the arrow needed to feed the six D4 Gaussian-spinor decorations into the decoder.
But it remains a *supplied dictionary*: the decoder is constructed from the pair,
so the answer is encoded, not derived. Grade if landed: PARTIAL.**

Detail:
- `spinorSelectedDecoder psi phi := quartetSAt (turnScale psi phi)`.
- `arbitrary_spinor_class_cost_eq_plucker`: for every `chi`,
  `quartetB (qe2 + quartetQ chi) (spinorSelectedDecoder psi phi (qe2 + quartetQ
  chi)) = complexAbsSq (spinorWedge psi phi)`, via `quartetSAt_class_cost`,
  `turnScale_sq`, `complexAbsSq_eq_ofReal_normSq`. True for every `psi, phi,
  chi`.
- `arbitrary_spinor_bridge_controls`: `(edge0, edge1 2/5) ↦ 4/25`,
  `(edge0, edge1 3/5) ↦ 9/25`, `(edge0, collinearEdge) ↦ 0`, and `4/25 ≠ 9/25`.
  Two nonzero scales + a genuine collinear zero rule out a renamed one-point
  fixture.
- **Composition with the D4 decorations is real:** `D4NullRaySpinorFactorization`
  supplies six explicit `CSpinor` values (`spinor .xPos = ![1,1]`, `.yPos =
  ![1,I]`, `.zPos = ![1,0]`, …), each a rank-one Hermitian half-Pauli factor of a
  scaled null root (`all_d4_null_rays_factor`, `[verified-here by inspection]`),
  with `noncollinear_spinor_control` giving a nonzero wedge for `(xPos, yPos)`.
  Any two of these are a valid `(psi, phi)` for the bridge, so the arrow
  "arbitrary D4 decoration pair → its Plücker disagreement → decoder class cost"
  composes cleanly.

**Selection rules that remain DEFINITIONAL (supplied, not derived):**
1. **Decoder = `quartetSAt ∘ turnScale`.** The mass answer `normSq(wedge)` is
   written into the decoder through `turnScale psi phi = √(normSq(spinorWedge))`
   (`turnScale_sq`). Same supplied-dictionary status as the canonical bridge,
   generalized.
2. **The nondegenerate quartet Krein form `quartetB`** (null 0–1 block, positive
   2, negative 3) and the nilpotent `quartetQ` (`Q e1 = e0`, `Q² = 0`) are fixed
   by construction.
3. **Exact-representative family `x = qe2 + quartetQ chi`.** The cost sees only
   component `2`, and every such `x` has `x 2 ≡ 1`; the "for every `chi`"
   quantifier is over a **fixed point of the cost** — the class-invariance is
   real (it *is* the class-cost no-go) but the quantifier reads stronger than it
   is (carried from Audit-05/06 Q1.2).
4. **Spinor decorations and per-ray projective scale** (`2/2/2/2/1/1`
   `rayScale`) in `D4NullRaySpinorFactorization` are hand-assigned;
   `rankOneHermitian` fixes the null direction only up to positive scale.

Correctly disclaimed in the module docstring ("spinor decorations and the rule
selecting this decoder family remain supplied … does not reconstruct decorations
from a bare graph, derive the decoder from an action, fix units, or predict
masses"). `MANUSCRIPT_CLAIM_MATRIX` M3 and `THEORY_COMPLETION` "Mass" state this
accurately.

---

## Q3 — Would `Targets/PluckerAction.lean` derive an EOM and Hessian from a displayed action, or merely rename the decoder?

Target: `PluckerAction` (`[s o r r y-target]`; all statements + arithmetic
`[verified-here]`).

**Verdict: it DOES display an actual quadratic action and extract the EOM (linear
Taylor coefficient) and Hessian (second difference) from it — this is more than
renaming. BUT the action's curvature is the supplied Plücker mass inserted as the
stiffness constant, so the numerical content is identical to the decoder, and the
"action" is a 1-D harmonic oscillator flat in 3 of 4 quartet directions. Grade if
landed: CLOSED as a finite-calculus theorem; PARTIAL for physics.**

Detail (re-derived here):
- `action psi phi x = (1/2)·massSq·(x 2)²`, `massSq = normSq (wedge psi phi)`,
  `eom psi phi x = massSq·(x 2)`, `e2 = ![0,0,1,0]`.
- `action_exact_taylor`: `action (x + t•v) = action x + t·eom·(v 2) +
  (1/2)·t²·massSq·(v 2)²`. Verified: `(1/2)massSq(x2+t·v2)² ` expands to exactly
  this; the **linear coefficient is `eom = massSq·x2`** and the **quadratic
  coefficient is `massSq`** (the Hessian). This is a genuine derivation of EOM and
  Hessian *from* the displayed action, not a definitional restatement.
- `action_e2_hessian`: `action(x+e2)+action(x−e2)−2·action(x) = massSq`
  (second difference in the `+`-direction = the Plücker mass). Verified:
  `(1/2)massSq[(x2+1)²+(x2−1)²−2x2²] = massSq`.
- `eom_zero_iff` (with `massSq ≠ 0`): `eom = 0 ↔ x2 = 0`. Verified.
- `action_hessian_controls`: `canonical1(2/5) ↦ 4/25`, `canonical1(3/5) ↦ 9/25`,
  `collinear = ![3,0] ↦ 0` (wedge `= 1·0 − 0·3 = 0`). Non-vacuous, two nonzero
  scales + zero control. Verified.

**Why it is not a derivation of mass:** the stiffness `massSq` **is** the Plücker
decoder output; the action `(1/2)·massSq·(x2)²` inserts it as the coefficient of a
displayed quadratic. It does not derive `massSq` from carrier dynamics — it packages
the same number as the curvature of a harmonic potential. Weak-quantifier caveat:
the action depends only on `x 2` (flat in components `0,1,3`), so the EOM
constrains only `x2`; "for every `x : Quartet`" is over a 1-parameter family in
disguise. This is consistent with the quartet decoder (which also sees only
component 2), so it composes, but it does **not** add physical content beyond
"the Plücker mass is the Hessian of a harmonic action I wrote down with that mass
as its curvature."

Net: **materially different from a rename** (it introduces a variational object
and derives EOM/Hessian by finite Taylor/second-difference), but it does **not**
derive the mass from primitives; it re-expresses the supplied decoder as an action
curvature.

---

## Q4 — Is `Targets/SixFour.lean` the correct no-go for the D4 walk? What constrained-subspace/ancilla theorem should follow?

Target: `SixFour` (`[s o r r y-target]`; statements `[verified-here]`).

**Verdict: the statements are true but the no-go is the TRIVIAL dimension-count
no-go — it establishes only that `Fin 6 → ℂ` and `Fin 4 → ℂ` are not
ℂ-linearly isomorphic (`6 ≠ 4`). It is *correct* and it *does* imply the absence
of any structure-preserving (unitary/Clifford) `6 ≃ 4` map, but it engages none
of the unitary or Clifford structure and so does not, by itself, resolve the
real D4-walk↔Dirac gap. Grade if landed: CLOSED as a rank statement; PARTIAL as
"the D4-walk no-go".**

Detail:
- `direction_finrank = 6`, `dirac_finrank = 4`, `exact_rank_gap : 6 = 4 + 2`,
  `no_direct_six_to_four_equivalence : ¬ Nonempty (DirectionSpace ≃ₗ[ℂ]
  DiracSpace)`. All true by `Module.finrank (Fin n → ℂ) = n` and
  `LinearEquiv.finrank_eq`.
- This is exactly the coarse fact behind Audit-06 Q5b: the walk **coin** acts on
  `Direction = Fin 6`, the landed **Clifford symbol** `Clifford3Plus1WalkSymbol`
  is `4×4`, and the D4 **decorations** are `2`-spinors. A linear iso is the
  *weakest* possible identification, so ruling it out rules out every stronger
  (unitary/Clifford) iso — but it does not address the physically correct
  question, which is not "is `6 ≃ 4`?" (obviously no) but "does a distinguished
  4-dimensional **subspace** of the 6-direction coin carry the Dirac/Clifford
  structure, with 2 ancilla directions?"

**Constrained-subspace / ancilla theorem that should follow (the real content):**
exhibit an explicit ℂ-linear isometric embedding `ι : DiracSpace ↪ DirectionSpace`
(`Fin 4 → Fin 6`, `2` ancilla / constraint directions) whose image is a
**coin-invariant** subspace on which the normalized D4 walk coin `U` acts as the
Clifford step, i.e. `U ∘ ι = ι ∘ H(k,m)` (up to the ancilla block), with
`H(k,m)² = (|k|²+m²)·I` inherited from `Clifford3Plus1WalkSymbol`. The `exact_rank_gap`
(`6 = 4 + 2`) is then the *statement of the ancilla count*, not the end of the
story. Witness: an explicit `6×4` isometry + a concrete `(k,m)`; kill condition:
if **no** coin-invariant 4-dim subspace of the 6-direction space carries the
Clifford relations (e.g. the six null-root shift structure forbids a
`U`-invariant Dirac block), the "D4 walk *is* the Dirac walk" claim is false and
M6 / the "Kinematics" row must be restated as "6-direction walk + separate
`4×4` Clifford symbol, not identified."

`MANUSCRIPT_CLAIM_MATRIX` and `THEORY_COMPLETION` currently do **not** claim the
identification (M6 says "internal unitary evolution", the Kinematics row keeps
the shift assignment open), so no row overstates this — but neither names the
constrained-subspace intertwiner as the deliverable. It should be added as the
open arrow.

---

## Q5 — Does `Targets/GeometricModes.lean` materially advance continuum recovery beyond the generic summable theorem?

Target: `GeometricModes` (`[s o r r y-target]`; statements + arithmetic
`[verified-here]`).

**Verdict: NO. It is a self-contained arithmetic instantiation (an explicit
geometric envelope with an explicit vanishing synthesis), decorative with respect
to continuum recovery. It does not construct a walk-specific envelope, has no
position/momentum space, no `L²`, no infinite-volume limit, and no PDE/propagator.
Grade if landed: CLOSED as an arithmetic fixture; it does NOT advance continuum
recovery beyond `SummableFourierContinuumLift`.**

Detail:
- `envelope k = (1/2)^(k+1)`; `envelope_summable_and_normalized`: `Summable`,
  `∑' = 1`, `envelope 0 = 1/2 > 0`. True.
- `approx n k = (1/(n+1))·envelope k`; `synthesis n = ∑' k, approx n k`;
  `synthesis_exact : synthesis n = 1/(n+1)`. True (`∑' envelope = 1`).
- `synthesis_tendsto_zero : Tendsto synthesis atTop (𝓝 0)`. True (`1/(n+1) → 0`).
- `constant_envelope_not_summable : ¬ Summable (fun _ : ℕ ↦ (1:ℝ))`. True
  (negative control).

**Why it does not advance continuum recovery:** `approx`/`synthesis` contain
**no walk data** — they are an arbitrary geometric series times `1/(n+1)`, not a
Fourier synthesis of the checkerboard/D4 walk. It re-exhibits (a concrete
instance of) the `geometric_envelope_witness` already inside
`SummableFourierContinuumLift`. The genuinely open arrow from Audit-06 Q3 —
**construct the walk-specific summable envelope, then prove infinite-volume /
`L²` / PDE convergence** — is untouched. This target functions as a benchmark
control (S05/S15 "geometric saturation"), not a continuum theorem. Any matrix
reading of it as continuum progress overstates it.

---

## Q6 — Hidden normalizations, convention mismatches, vacuities, and matrix rows that over/understate the kernel

**Supplied normalizations / dictionaries (disclosed; must not be upgraded to
derivations):**
1. **1+1 coin normalization** `c²+s²=1`, `normSq uL = normSq uR = 1`,
   `c ≠ 0` for the transfer identification (Q1). Honest displayed hypotheses.
2. **Decoder-from-pair** `spinorSelectedDecoder = quartetSAt ∘ turnScale` (Q2):
   the pair's `normSq(wedge)` answer is written into the decoder.
3. **`massSq` as action curvature** in `PluckerAction` (Q3): the Plücker mass is
   inserted as the harmonic stiffness.
4. **Spinor decorations + `2/2/2/2/1/1` projective scale** (Q2/`D4NullRaySpinor…`):
   hand-assigned; `rankOneHermitian` fixes direction only up to positive scale.
5. **`(+ − − −)` signature with coordinate `0` selected as time** (`pauliHalf`,
   `D4Walk.futureNullRoot`): the time axis is selected, not derived.

**Vacuity / weak-quantifier notes:**
- `arbitrary_spinor_class_cost_eq_plucker` and `PluckerAction`'s
  `action_hessian_controls` quantify over `chi` / `x` but the cost depends only on
  component `2` (`x 2 ≡ 1` on the exact-representative family; the action is flat
  in 3 of 4 directions). Invariance is real; the quantifier reads stronger than
  it is (Q2.3, Q3).
- `D4Walk.walk_preserves_norm` (a `s o r r y`-target) quantifies over an **arbitrary**
  `6×6` unitary coin `hU : IsUnitary U`: correctly stated and non-vacuous, but
  generic — no Clifford/Dirac coin is singled out (Q4).
- No audited statement is vacuously true, uses a contradictory hypothesis, or is
  definitionally `True` (the four `Targets` are honest non-vacuous claims,
  currently `s o r r y`; `Audit/Core.package_marker` is the only `True`, and is
  labelled a stub).

**Convention consistency (good):**
- `physicalTransfer`'s outgoing phase attaches to the **row (final)** direction,
  matching `transfer`'s "rows = outgoing" convention; the
  `physicalTransfer_eq_transfer` orientation was re-derived entry-by-entry here
  and is correct.
- `directionPathSum … start finish` at matrix index `(finish, start)` — the
  transposed argument/index order is consistent (column = initial, row = final).
- `IsUnitary` is two-sided in `UnitaryHistoryComposition`,
  `UnitaryCheckerboardTransfer`, and `D4Walk`. `quartetB`/`quartetQ` conventions
  match across `ArbitrarySpinorHodgeBridge` and the (source-only) quartet layer.

**Convention overreach (captions outrunning kernels):**
- `GeometricModes` "continuum recovery" framing: an abstract geometric series with
  no walk data (Q5).
- `SixFour` "no-go for the D4 walk": only the trivial `6 ≠ 4` linear no-go; the
  Dirac/unitary structure is untouched (Q4).
- Carried from Audit-06: `SummableFourierContinuumLift` "continuum" =
  abstract countable mode index; `PositiveSectorIntertwinerInvariance` "sector" =
  the whole positive cone (presentation invariance only).

**Matrix rows that OVERSTATE the kernel:**
- `MANUSCRIPT_CLAIM_MATRIX` M5 "countable **position-space** convergence" — the
  Fourier-lift index is an abstract countable mode set, and summability of the
  synthesized series is assumed (carried; `GeometricModes` does not fix this).
- `MANUSCRIPT_CLAIM_MATRIX` M6 "twelve … explicit spinor factors" — the
  factorization decorates only the **six future** axial rays; the twelve are
  *roots*, not twelve spinor decorations (carried, re-confirmed:
  `FutureRay` has six constructors).
- Any reading of the four `Targets/` statements (`PluckerAction.*`, `SixFour.*`,
  `D4Walk.*`, `GeometricModes.*`) as achieved overstates them: all `s o r r y` (F0.3).
- M5 status "finite normalized path-sum/unitary-history chain … integrated +
  guarded" is accurate on the **live tree** but is **source-only** in this
  package (only `CheckerboardPathSumTransferPower` builds here).

**Matrix rows that UNDERSTATE / are accurate:**
- `THEORY_COMPLETION` "Quantum composition" — accurate: the finite
  path-sum→operator-history→unitary chain is now closed for supplied normalized
  parameters (Q1). The row could be sharpened to note the chain is **1+1** and
  disconnected from the 6-direction D4 coin.
- The Kinematics/Mass rows correctly keep decoder/decoration/time-axis selection
  open.
- Neither matrix has a row for the four current `Targets/`. Add them as OPEN:
  finite Plücker action/Hessian (Q3); trivial `6→4` rank no-go + the missing
  constrained-subspace intertwiner (Q4); generic D4 walk norm-preservation (Q4);
  geometric-envelope arithmetic control (Q5).

---

## CLOSED / PARTIAL / OPEN summary

| Item | Module / target | Status here | Grade | One line |
|---|---|---|---|---|
| F0 | build surface + guards | `[source-only]` / stub | **OPEN (MED)** | only `Audit/Core` (`= True`) is a default target; 5 snapshots import absent files; `CheckerboardPathSumTransferPower` is Mathlib-only; 4 targets are `s o r r y` |
| Q1 | path-sum = transfer power = operator history; physical transfer unitary; replicated history unitary | `[source-only]` (path-sum `[verified-here]`) | **CLOSED\* / PARTIAL** | one orientation-correct 1+1 quantum chain; `(c,s,uL,uR)` supplied, `c≠0`; not the 6-direction D4 walk |
| Q2 | `ArbitrarySpinorHodgeBridge.arbitrary_spinor_class_cost_eq_plucker` | `[source-only]` | **CLOSED\* / PARTIAL** | arbitrary pair (incl. D4 decorations) → wedge → decoder cost; decoder = `quartetSAt∘turnScale` supplied |
| Q3 | `PluckerAction.action_exact_taylor` / `action_e2_hessian` | `[s o r r y-target]` | **OPEN (→ CLOSED\* / PARTIAL)** | genuine action→EOM→Hessian by Taylor/2nd-difference; mass inserted as curvature, flat in 3/4 directions |
| Q4a | `SixFour.no_direct_six_to_four_equivalence` / `exact_rank_gap` | `[s o r r y-target]` | **OPEN (→ CLOSED, trivial)** | correct but only the `6≠4` linear no-go; no unitary/Clifford content |
| Q4b | 6-direction coin ↔ `4×4` Clifford via constrained subspace / 2 ancilla | not in corpus | **OPEN** | the substantive missing theorem; see next-theorem |
| Q5 | `GeometricModes.synthesis_exact` / `_tendsto_zero` | `[s o r r y-target]` | **OPEN (→ CLOSED, decorative)** | explicit geometric envelope; no walk data, no `L²`/PDE — does not advance continuum recovery |

`*` = source-only in this package; live-tree guard reported by the task, not
executable here.

---

## Strongest honest end-to-end chain

Every arrow is real and carries its true status. The chain is *source-level*
(F0), 1+1 for the quantum layer, and stops being derived at named supplied
arrows.

```
selected D4 null shell (12 axial null roots, decidable)              [prior, verified]
  → 6 future axial null rays decorated by Gaussian 2-spinors,
     rankOneHermitian(spinor r) = pauliHalf(scaledRoot r)            [D4NullRaySpinorFactorization  CLOSED*, supplied 2/2/2/2/1/1 scale]
  → ARBITRARY decorated pair (psi,phi): class cost
     = complexAbsSq(spinorWedge psi phi);  4/25 ≠ 9/25, collinear 0  [ArbitrarySpinorHodgeBridge  CLOSED*/PARTIAL — decoder = quartetSAt∘turnScale supplied]
  ⟂ decoder / scale / positive-sector / dynamical selection          [SUPPLIED / OPEN]

  finite path sum over all length-n direction histories
     = (transfer^n) = operator history of the transfer gate          [CheckerboardPathSumTransferPower (in-package) + …OperatorHistoryBridge  CLOSED*]
  → physical transfer = that transfer (c≠0), two-sided unitary
     under c²+s²=1, |uL|=|uR|=1                                       [UnitaryCheckerboardTransfer  CLOSED*/PARTIAL]
  → every finite replicated physical history is unitary              [via UnitaryHistoryComposition.replicated_history_operator_unitary  CLOSED*]
  ⟂ coin amplitudes (c,s,uL,uR) from primitive data; 1+1 only        [SUPPLIED / OPEN]

  ✗ NO ARROW: 6-direction D4 coin  ↔  4-component Clifford symbol     [OPEN — SixFour proves only the trivial 6≠4 no-go]
  (PluckerAction: action→EOM→Hessian recovers massSq as curvature;   [Q3 OPEN→PARTIAL, mass inserted]
   GeometricModes: decorative geometric envelope, no walk/L²/PDE)     [Q5 OPEN, no continuum advance]
```

Net after this wave: the **1+1 quantum-composition layer is closed** (path sum =
operator history = unitary replicated evolution) for supplied normalized
parameters — the arrow Audit-06 requested has landed. The **arbitrary-pair mass
bridge is closed** (source-only) with the decoder still supplied. The two
remaining structural gaps are (a) connecting the **6-direction** D4 coin to the
**4-component** Clifford symbol (SixFour supplies only the trivial dimension
no-go), and (b) deriving the supplied coin/decoder data from primitive null
dynamics. Continuum recovery, sector selection, and the Born rule remain OPEN.

---

## One exact next theorem (highest value)

Audit-06's nominee (`physicalTransfer_unitary` + history) has landed. The next
highest-leverage move is the one gap that connects the two largest landed pieces
(the D4 spinor/Clifford kinematics and the unitary walk) and turns `SixFour`'s
trivial `6 ≠ 4` no-go into real structure: an explicit **constrained-subspace /
ancilla intertwiner** embedding the 4-component Dirac/Clifford symbol into the
6-direction D4 coin.

```lean
-- Targets/D4CliffordEmbedding.lean  (imports: Mathlib only; self-contained)
-- DiracSpace = Fin 4 → ℂ, DirectionSpace = Fin 6 → ℂ,
-- H : DiracSpace →ₗ[ℂ] DiracSpace  the normalized Clifford step (H² = (|k|²+m²)I),
-- U : DirectionSpace →ₗ[ℂ] DirectionSpace  the D4 walk coin (IsUnitary).

theorem dirac_embeds_as_coin_invariant_subspace :
    ∃ (ι : DiracSpace →ₗ[ℂ] DirectionSpace),
      Function.Injective ι ∧                 -- 4-dim image, 2 ancilla (exact_rank_gap)
      (∀ v w, ⟪ι v, ι w⟫ = ⟪v, w⟫) ∧          -- isometry into the coin inner product
      (∀ v, U (ι v) = ι (H v)) := by          -- image is U-invariant and U|_im ≃ H
  s o r r y
```

- **Witness (mandatory, nondegenerate):** an explicit `6×4` isometry `ι` (2 ancilla
  directions from `exact_rank_gap : 6 = 4 + 2`) and a concrete rational
  `(k,m)` (e.g. the landed `3-4-5` shell) for which `U ∘ ι = ι ∘ H`, together
  with a nonzero control showing `ι` is not the zero/degenerate map and that the
  ancilla block is genuinely 2-dimensional (a direction outside `im ι`).
- **Kill / falsifier:** if **no** coin-invariant 4-dimensional subspace of the
  6-direction space carries the Clifford relations `H² = (|k|²+m²)I` — i.e. the
  six null-root shift structure forbids a `U`-invariant Dirac block — then the
  D4 walk is **not** the Dirac walk. In that case M6 and the `THEORY_COMPLETION`
  "Kinematics and causal support" row must be restated as "6-direction walk **+
  separate** `4×4` Clifford symbol, not identified," and `SixFour` stands only as
  the trivial dimension no-go.

This is strictly smaller than deriving the coin/decoder from dynamics, it
consumes the already-landed `Clifford3Plus1WalkSymbol` and `D4Walk`
norm-preservation, and it is the exact arrow that Audit-06 Q5b flagged as the
missing bridge — now sharpened to the constrained-subspace/ancilla form that
`SixFour.exact_rank_gap` (`6 = 4 + 2`) demands.
