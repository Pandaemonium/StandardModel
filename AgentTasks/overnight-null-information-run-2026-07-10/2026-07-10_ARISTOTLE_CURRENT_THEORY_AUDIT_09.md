# Live-repository reconciliation

The focused package saw FiniteGibbs as a target. The live repository has since landed FiniteGibbsResponse, PluckerHessianSL2Invariance, PluckerOscillatorGroup, and ConcreteD4InvariantSector, and passes an 8,080-job consolidated guard. The audit's semantic verdict remains controlling: the concrete first-four-channel sector is real but anisotropic, the simultaneous six-channel coin is not a 3+1 Clifford coin, and the stronger invariant-block no-go is the exact remaining kill theorem.

# CURRENT_THEORY_AUDIT_09 -- concrete D4 sector, action dynamics, and ensemble wave

Adversarial mathematical-physics and Lean-statement audit for job
`codex-current-theory-audit-20260710-09`.

**Scope.** Five `Sources/` modules
(`D4FiniteUnitaryWalk`, `ExplicitSixChannelCoin`, `SixFourInvariantBlock`,
`PluckerActionHessian`, `PluckerOscillatorDynamics`); one `Targets/` proof stub
(`Targets/Core.lean` = `FiniteGibbs`); the prior audit
(`Docs/2026-07-10_ARISTOTLE_LATEST_DYNAMICS_WALK_AUDIT_08.md`); the grand
strategy (`Docs/2026-07-10_ARISTOTLE_GRAND_STRATEGY_03.md`); both control
matrices (`Docs/MANUSCRIPT_CLAIM_MATRIX.md`, `Docs/THEORY_COMPLETION_MATRIX.md`);
the benchmark manifest (`Docs/SIMULATION_BENCHMARKS.md`); and the literature log
(`Docs/LIT_SEARCH_LOG.md`).

**No source files were edited.** Per the task, Audit-08's pre-integration status
labels are treated as stale; its *semantic* findings remain evidence.

**Packaging note (must be recorded).** The task text and the run matrices speak
of "four new target files," but this package's `Targets/` directory contains
exactly one file, `Targets/Core.lean` (namespace `FiniteGibbs`). The other three
proposed targets from Audit-08 -- `SixCoin`, `InvariantBlock`,
`PluckerOscillator` -- have since **landed into `Sources/`** as
`ExplicitSixChannelCoin`, `SixFourInvariantBlock`, and
`PluckerOscillatorDynamics`. This audit therefore treats the four new flagship
modules of this wave as: `ExplicitSixChannelCoin`, `SixFourInvariantBlock`,
`PluckerOscillatorDynamics` (landed), plus `FiniteGibbs` (still a `s o r r y` stub),
with `PluckerActionHessian` carried from the prior wave. Any matrix that lists
all four as "targets" or all four as "landed" is inaccurate; see §7.

## Verification legend

- `[verified-here]` -- re-elaborated in this Lean/Mathlib (`v4.28.0`), or its
  arithmetic re-derived in a self-contained snippet in this session.
- `[source-only]` -- module imports upstream `PhysicsSM.Draft.NullEdge.*` /
  `PhysicsSM.Spinor.*` files **absent** from this focused package; it cannot be
  recompiled here and its `#print a x i o ms … #guard_msgs` guard is **not
  enforceable in this tree**. Per the task the live repo passes its consolidated
  8,075-job guard reporting only `[propext, Classical.choice, Quot.sound]`; this
  is not a live-tree failure. Statements are audited from source text plus
  re-derived arithmetic, not an executed guard here.
- `[s o r r y-target]` -- a `Targets/` file whose theorem bodies are `by s o r r y`; the
  statement is audited and its truth re-derived here; the proof is not yet in the
  kernel.

Grades reuse the run vocabulary: `D` derived, `H` conditional with displayed
hypotheses, `I` imported dictionary/constant, `B` bridge conjecture with
finite avatar + kill, `O` open interface, `K` killed by theorem/counterexample.
`CLOSED*` = source-only in this package but a genuine finite theorem.

---

## 0. Executive summary (five findings)

1. **The concrete coin `ExplicitSixChannelCoin.axisBlockCoin` is
   `B ⊕ B ⊕ B`** -- three decoupled 1+1 checkerboard blocks
   `B = [[3/5, 4i/5],[4i/5, 3/5]]`, one per spatial axis, with **no cross-axis
   mixing** (`axisBlockCoin 0 2 = 0`, `[verified-here]`). It is a genuine
   two-sided unitary and yields a genuine finite norm-preserving 3+1 walk, but
   it is not an isotropic 3+1 Dirac coin.

2. **The actual coin DOES have rank-four invariant sectors, but they are
   necessarily anisotropic and none carries a Clifford square.** Every
   coin-invariant subspace is a sum of eigenlines of the three axis blocks; the
   coin's eigenvalues are exactly `3/5 ± 4i/5` (each with multiplicity three),
   and their squares `-7/25 ± 24i/25` are **distinct** (`[verified-here]`). A
   four-dimensional invariant subspace therefore mixes both eigenvalue-squares,
   so its restriction `H` can never satisfy `H² = r·I`. The naive
   "6-channel walk = 4-component Dirac walk" identification is **refutable** for
   this coin -- a kernel-checkable **no-go**, not merely an open problem (§2, §8).

3. **The action→Hessian→oscillator-conservation chain is a real finite calculus
   result but inserts the supplied mass twice.** `action_exact_taylor` genuinely
   exposes the EOM (linear coefficient) and the Hessian (quadratic coefficient);
   `action_positive_hessian` equals `massSq` by construction;
   `hessian_energy_conserved` is an exact invariant of a **supplied** symplectic
   rotation with `ω² = m² = massSq` inserted. No arrow derives the mass, and the
   oscillator `step` is **not** derived from the action's EOM (§3).

4. **All five `FiniteGibbs` targets are TRUE and provable `[verified-here]`,
   including the derivative theorem** `d/dβ log Z = −⟨E⟩`. Types and
   normalization are correct (`probability_sum_one`, `meanEnergy` divided by `Z`,
   derivative sign `−meanEnergy`). `NeZero n` is load-bearing (nonempty index for
   `partition_pos`). It is the canonical finite canonical-ensemble identity -- a
   real result, but it does not by itself advance thermodynamics beyond a
   textbook finite fact (§4, §5).

5. **The `SixFourInvariantBlock` intertwiner has been repaired.** Audit-08's F1
   (false `dirac_block_intertwiner` for arbitrary `A`) is fixed by the displayed
   hypothesis `hA : A 0 = 0`; the repaired statement is TRUE `[verified-here]`,
   and the negation without `hA` is still provable `[verified-here]`. It remains
   **tautological** (invariance by the block-diagonal definition) and is never
   instantiated with `axisBlockCoin`; `direction_has_four_plus_two_block` is a
   non-canonical dimension count that engages no coin structure (§1, §6).

---

## 1. Semantic audit -- concrete six-channel coin and the 4+2 block architecture

### 1a. `ExplicitSixChannelCoin` `[source-only]`; arithmetic `[verified-here]`

`axisBlockCoin finish start` returns `3/5` on the diagonal within an axis pair,
`4i/5` off-diagonal within an axis pair (`finish/2 = start/2`,
`finish%2 ≠ start%2`), and `0` across axis pairs. Re-derived here:

- `axisBlockCoin 0 2 = 0` (x⁺ vs y⁺): **no cross-axis leakage** `[verified-here]`.
- `axisBlockCoin 0 1 = I·(4/5)` (x⁺ vs x⁻): genuine intra-pair mix `[verified-here]`.
- Each axis block `B = 3/5·I + 4i/5·X` (with `X = [[0,1],[1,0]]`) is two-sided
  unitary: `(3/5)² + (4/5)² = 1`, off-diagonal cancels. `axis_block_coin_unitary`
  is therefore a genuine, non-vacuous `IsUnitary` (`UᴴU = 1 ∧ UUᴴ = 1`).
- `axis_block_coin_controls` (`≠ 1`, entry `(0,1) = 4i/5`, entry `(0,2) = 0`) is
  TRUE; the `(0,2) = 0` clause is *exactly* the no-cross-axis-mixing statement.
- `axis_block_walk_preserves_norm` is the generic `walk_preserves_norm`
  instantiated at `axisBlockCoin`. Genuine but not coin-specific: it holds for
  every unitary coin.

**Semantic verdict.** This is precisely the "concrete coin" nominated by the
matrices, but it is **three decoupled 1+1 checkerboard walks** (each `B` is the
1+1 physical transfer coin with `c = 3/5, s = 4/5` and imaginary turn phase),
not an isotropic 3+1 Dirac coin. The module docstring states this correctly
("does not exhibit a four-dimensional coin-invariant Dirac sector").

### 1b. `SixFourInvariantBlock` `[source-only]`; logic `[verified-here]`

- `include_dirac_injective`, `include_dirac_isometry`
  (`inner6 (v,0) (w,0) = inner4 v w`), `auxiliary_outside_control`
  (`(0, ![1,0]) ∉ range includeDirac`): TRUE `[verified-here]`.
- `dirac_block_intertwiner (hA : A 0 = 0)`: **repaired** and TRUE
  `[verified-here]`. The pre-repair statement (Audit-08 F1) is FALSE; I re-proved
  the negation without `hA` here (take `H = id`, `A ≡ ![1,0]`, `v = 0`). The
  displayed `hA : A 0 = 0` is the exact necessary and sufficient condition.
- `direction_block_intertwiner`, `direction_has_four_plus_two_block`: TRUE, but
  `direction_has_four_plus_two_block` only asserts existence of *some* linear
  isomorphism `DirectionSpace ≃ₗ DiracSpace × AuxiliarySpace` (from
  `four_plus_two_decomposition`, i.e.
  `nonempty_linearEquiv_iff_finrank_eq` on two 6-dimensional spaces). It engages
  **no coin, unitary, or Clifford structure**.

**Semantic verdict.** The 4+2 block architecture is *constructed*, not *derived*
for the actual coin. It models "a block-diagonal operator fixes the first
factor" (true once `A 0 = 0`) and is never connected to `axisBlockCoin`, the D4
shift, or the Clifford symbol. The module docstring says exactly this.

---

## 2. Verdict -- rank-four invariant sector, anisotropy, and the missing Dirac theorem

**Q: Does the actual coin have a rank-four invariant sector?**
**YES.** `axisBlockCoin = B ⊕ B ⊕ B` is block-diagonal on the axis pairs
`(0,1) = x±`, `(2,3) = y±`, `(4,5) = z±`. Any sum of two axis planes -- e.g.
`span{e₀,e₁,e₂,e₃}` (x-plane ⊕ y-plane) -- is a four-dimensional coin-invariant
subspace, on which the coin restricts to `B ⊕ B`. So a rank-four invariant
sector exists, and in fact many do (the coin-invariant subspaces are exactly the
eigenline sums, so a 4-dim one is any choice of 4 of the 6 eigenlines). The
obstruction is **not** absence of an invariant 4-space.

**Q: Is that sector necessarily anisotropic?**
**YES.** Because `axisBlockCoin` is block-diagonal by axis, every coin-invariant
subspace is a direct sum of eigenlines of the three copies of `B`. `B` has
eigenvalues `3/5 ± 4i/5` (both on the unit circle, `|3/5 + 4i/5| = 1`) with
eigenvectors `(1, 1)` and `(1, −1)`. A four-dimensional invariant subspace must
select four of the six eigenlines, hence cannot treat the three spatial axes
symmetrically: it distinguishes at least one axis from the others (an
anisotropic two-or-three-axis sector), matching the 3D-quantum-walk literature
warning recorded in `LIT_SEARCH_LOG.md` (Mlodinow-Brun, arXiv:1802.03910: a
four-dimensional internal space arises from parity + axis symmetry +
anticommutation, not from a raw first-four-channel projector).

**Q: What additional theorem is required for a genuine 3+1 Clifford/Dirac
identification?** A theorem exhibiting a coin-invariant, isometric
four-dimensional subspace whose restriction `H` satisfies the full 3+1 Clifford
relation -- concretely a momentum-parameterized symbol with
`H(k,m)² = (|k|² + m²)·I` (equivalently four anticommuting gamma generators) --
obtained as a restriction of the **actual** coin + shift, not a separately
constructed `4×4` symbol.

**For `axisBlockCoin` this additional theorem is FALSE (a kernel-checkable
no-go).** The restriction of the coin to any invariant 4-space is diagonalizable
with eigenvalues in `{3/5 + 4i/5, 3/5 − 4i/5}`, whose squares are
`-7/25 + 24i/25` and `-7/25 − 24i/25` -- **distinct** (`[verified-here]`:
`(B·B) 0 0 = -7/25`, `(B·B) 0 1 = 24i/25 ≠ 0`, so `B²` is not scalar). Each
eigenvalue-square occurs with multiplicity three, so a 4-dim invariant subspace
must contain eigenlines of **both** squares; hence `H²` has at least two distinct
eigenvalues and can never equal `r·I`. Consequently no invariant four-block
carries a Clifford square, and the "D4 walk = Dirac walk" identification is
refuted for this coin. A genuine identification would require a **different**,
axis-mixing coin (with the correct anticommuting structure), whose selection
from primitive data is itself unproven. See §8 for the exact no-go to land.

---

## 3. Action → Hessian → oscillator-conservation chain

`PluckerActionHessian` `[source-only]`; arithmetic `[verified-here]`.
`PluckerOscillatorDynamics` `[source-only]`; pure arithmetic `[verified-here]`.

**Derived equations (genuine finite calculus):**
- `action psi phi x = (1/2)·massSq·(x 2)²` with `massSq = normSq(spinorWedge …)`;
  `action_nonnegative` by `positivity`.
- `action_exact_taylor`: `action(x + t•v) = action x + t·(eom x)·(v 2)
  + (1/2)·t²·massSq·(v 2)²`. The **linear** coefficient is the EOM
  `eom = massSq·(x 2)`; the **quadratic** coefficient is `massSq`. Re-derived
  here by `ring` on the pure identity `[verified-here]`.
- `action_positive_hessian`: the `+`-direction second difference
  `action(x+qe2) + action(x−qe2) − 2·action x = massSq`. Re-derived here for a
  basis vector `qe2` with `qe2 2 = 1` `[verified-here]`.
- `eom_zero_iff` (needs `massSq ≠ 0`): `eom = 0 ↔ x 2 = 0`.
- `energy_conserved` (`hm : m ≠ 0`, `hcs : c² + s² = 1`): the supplied rotation
  `step m c s (q,p) = (c·q + (s/m)·p, −m·s·q + c·p)` preserves
  `energy m (q,p) = p² + m²·q²` exactly. Both `hm` and `hcs` are load-bearing
  (`m = 0` collapses `s/m`; `c² + s² = 1` is the rotation condition). Re-proved
  here `[verified-here]` (`field_simp; linear_combination … * hcs`).

**Supplied flow / `m² = massSq` dictionary (must not be upgraded to
derivations):**
- `action_hessian_eq_hodge_class_cost` equates the Hessian to the arbitrary-pair
  **Hodge class cost** through the absent `arbitrary_spinor_class_cost_eq_plucker`
  -- a real composition arrow into the mass bridge, but it rests on the supplied
  decoder `spinorSelectedDecoder = quartetSAt ∘ turnScale`. Mass **inserted** as
  curvature.
- `hessian_energy_conserved (hms : m² = massSq)` bundles (i) the pure oscillator
  conservation and (ii) `m² = action-Hessian`. The frequency is fixed by
  `m² = massSq`, i.e. the Pluecker mass is inserted as `ω²`.
- `step` is a **supplied** symplectic rotation; it is **not** derived from
  `PluckerActionHessian.eom` (which is the first-order gradient `massSq·x2` on
  `Quartet`, a different object from a 2-D `(q,p)` flow).

**Separation.** Derived: the Taylor expansion, EOM/Hessian identification, and
exact energy conservation. Supplied: the action's coefficient `massSq`, the
decoder feeding the Hodge equality, the oscillator `step`, and `ω² = m² = massSq`.
No new action→EOM→mass arrow; the `action` is also flat in three of four quartet
directions, so `∀ x` reads stronger than a one-parameter family. Grade:
`PluckerActionHessian` CLOSED* (finite calculus) / PARTIAL (physics);
`PluckerOscillatorDynamics` CLOSED* (finite mechanics) / PARTIAL (mass inserted,
`step` not from the EOM). `rational_plucker_oscillator_control`: energy part
re-verified here at `(m,c,s) = (2/5, 3/5, 4/5)`, `x = (1,2)`; the
`massSq edge0 (edge1 (2/5)) = 4/25` part is `[source-only]`.

---

## 4. Truth / type / normalization audit of the new target files

| File / theorem | Type | Truth | Normalization | Status |
|---|---|---|---|---|
| `FiniteGibbs.partition_pos` | `0 < ∑ exp(-βEᵢ)` | TRUE | needs `NeZero n` (nonempty index) -- load-bearing | `[verified-here]` |
| `FiniteGibbs.probability_nonnegative` | `0 ≤ wᵢ/Z` | TRUE | `exp ≥ 0`, `Z > 0` | `[verified-here]` |
| `FiniteGibbs.probability_sum_one` | `∑ pᵢ = 1` | TRUE | `∑ wᵢ / Z = Z/Z = 1` | `[verified-here]` |
| `FiniteGibbs.log_partition_hasDerivAt` | `HasDerivAt (log∘Z) (−⟨E⟩) β` | TRUE | sign & mean correct: `dZ/dβ = ∑(−Eᵢ)wᵢ`, `⟨E⟩ = ∑Eᵢwᵢ/Z` | `[verified-here]` |
| `FiniteGibbs.rational_two_level_control` | `Z = 1 + exp(−β·4/25) ∧ 0 < Z` | TRUE | `twoLevelEnergy(4/25)` gap = Pluecker `4/25` via dictionary | `[verified-here]` |
| `ExplicitSixChannelCoin.*` | `Matrix (Fin 6) (Fin 6) ℂ` | TRUE | per-axis `c²+s²=1`; block-diagonal | `[source-only]`, arith `[verified-here]` |
| `SixFourInvariantBlock.dirac_block_intertwiner` | needs `A 0 = 0` | TRUE (repaired) | -- | `[source-only]`, `[verified-here]` |
| `SixFourInvariantBlock.direction_has_four_plus_two_block` | `∃ e, …` | TRUE | non-canonical (dimension count) | `[source-only]`, `[verified-here]` |
| `PluckerActionHessian.*` | `Quartet → ℝ` | TRUE | mass inserted as curvature | `[source-only]`, arith `[verified-here]` |
| `PluckerOscillatorDynamics.*` | `ℝ × ℝ` osc. | TRUE | `ω² = m² = massSq` inserted | `[source-only]`, arith `[verified-here]` |

**No false target in this wave.** The one previously false target
(`dirac_block_intertwiner`, Audit-08 F1) is repaired with `hA : A 0 = 0`; I
confirmed both the repaired truth and the falsity of the un-hypothesized form
`[verified-here]`. No repaired statement or counterexample is required for the
current files. The full `FiniteGibbs` module (all five theorems) was re-proved
`[verified-here]` in a self-contained Mathlib snippet, including the derivative
theorem via `HasDerivAt.sum`, `Real.hasDerivAt_exp`, and `HasDerivAt.log`.

---

## 5. The finite Gibbs derivative theorem -- audit and marginal value

`FiniteGibbs.log_partition_hasDerivAt : HasDerivAt (fun b => log (Z E b))
(−meanEnergy E β) β`, all data `Fin n → ℝ`, `[s o r r y-target]`, TRUE and provable
`[verified-here]`.

**What it is.** The standard finite canonical-ensemble identity
`⟨E⟩ = −d/dβ log Z`, i.e. the mean energy is minus the log-partition derivative,
proved rigorously for an arbitrary finite spectrum `E : Fin n → ℝ` with a genuine
`HasDerivAt` witness (not a formal manipulation). `partition_pos`,
`probability_sum_one`, and `rational_two_level_control` supply the well-posed
probability structure and a nonzero rational fixture whose two-level gap `4/25`
is the Pluecker mass of the run's `edge0, edge1(2/5)` pair.

**What it would add to thermodynamics if proved.**
- A kernel-checked finite avatar of the mean-energy identity, giving the run its
  first `Thermodynamics` row deliverable with an exact witness (currently that
  row is `O`).
- A clean hook for the *next* rung: the variance / heat-capacity identity
  `d²/dβ² log Z = ⟨E²⟩ − ⟨E⟩² = Var(E) ≥ 0` (fluctuation-response), which would
  be a genuinely new positivity statement and connect to entropy/free-energy.

**What it does NOT add (guard against over-reading).**
- No derivation of the Gibbs form itself (max-entropy / equilibrium principle):
  `weight = exp(−βE)` is stipulated.
- No coarse-graining, initial-state principle, finite monotonicity, entropy
  production, or arrow of time -- the `Thermodynamics` row's open deliverables.
- No thermodynamic (infinite-`n`) limit; `n` is finite and `NeZero`.
- No connection to the null-information primitives beyond the supplied dictionary
  `massSq = twoLevelEnergy` gap `4/25`. It is a textbook finite identity, correct
  and useful as a benchmark anchor, not a thermodynamic-limit result.

---

## 6. Four over-claim checks for every new flagship theorem

Checks: **(V)** vacuity / unsatisfiable hypothesis / trivially true;
**(T)** hollow telescoping (re-bundles definitions or conjoins unrelated facts);
**(D)** docstring/matrix prose outruns the kernel statement;
**(F)** false shape (literally false, mis-typed, or mis-normalized).

| Flagship theorem | V | T | D | F |
|---|---|---|---|---|
| `axis_block_coin_unitary` (+ `axis_block_walk_preserves_norm`) | clean -- `IsUnitary` two-sided, non-vacuous | clean -- genuine matrix computation | **caption risk**: honest docstring, but any matrix reading of `axisBlockCoin` as the "isotropic Dirac coin" outruns the kernel (it is `B⊕B⊕B`) | clean |
| `direction_has_four_plus_two_block` (+ `dirac_block_intertwiner`, repaired) | clean (`hA` satisfiable) but **weak quantifier**: `∃ e` over *some* iso of equal-dim spaces | **hollow**: dimension count / tautological invariance by block-diagonal definition; never instantiated with `axisBlockCoin` | **caption risk**: reading it as an "invariant four-component Dirac sector" outruns the kernel | clean now (was **F** pre-repair, Audit-08 F1) |
| `action_hessian_eq_hodge_class_cost` (+ `action_exact_taylor`, `action_positive_hessian`) | clean | partial -- Hessian `= massSq` by construction; Hodge equality rests on supplied decoder | honest docstring ("no mass prediction claimed"); flat in 3/4 dirs so `∀ x` reads strong | clean (`[source-only]`; arith verified) |
| `hessian_energy_conserved` (+ `energy_conserved`, `rational_plucker_oscillator_control`) | clean (`hm, hcs, hms` jointly satisfiable -- rational control) | **mild bundling**: conjunct (i) is the pure oscillator fact, independent of `psi, phi, hms`; conjunct (ii) carries the supplied-mass identity | honest docstring ("supplied flow / frequency dictionary; not a Noether theorem") | clean |
| `log_partition_hasDerivAt` (+ `partition_pos`, `probability_sum_one`, `rational_two_level_control`) | clean (`NeZero n` load-bearing) | clean -- genuine derivative | **caption risk**: reading it as "thermodynamics/ensemble wave" progress outruns the kernel (no thermo limit, Gibbs form supplied) | clean (sign & normalization correct) |

**Net.** No new flagship is vacuous or false-shaped. The two structural flags are
(a) `direction_has_four_plus_two_block` is hollow/telescoping (a dimension count
dressed as architecture), and (b) three modules carry honest disclaimers whose
*matrix readings* could outrun the kernel -- the specific danger is promoting
`axisBlockCoin` or the 4+2 block to a "Dirac sector," which §2/§8 refute.

---

## 7. Exact corrections to the theory, claim, and simulation matrices

**`THEORY_COMPLETION_MATRIX.md`.**
- *Kinematics and causal support*: replace "invariant block and explicit coin
  jobs running" with "explicit coin (`axisBlockCoin = B⊕B⊕B`) and 4+2 block
  **landed**." Record that the coin admits rank-four invariant sectors but that
  **all are anisotropic and none carries a Clifford square** (eigenvalue-squares
  `-7/25 ± 24i/25` distinct), so the deliverable "prove the actual coin has a
  dynamically invariant four-component sector" is **refuted for this coin**:
  grade the "this coin is the Dirac coin" sub-claim `K` (killed), keeping the
  norm-preserving walk `D` and the `6 = 4+2` count as a non-canonical `H`/`I`.
- *Dynamics and action*: mark "harmonic-oscillator energy next" as **landed**
  (`PluckerOscillatorDynamics`), grade `D` (finite mechanics); keep "mass
  inserted as `ω²`, `step` not from the action EOM, dynamical selection open."
- *Thermodynamics, time, classicality* (`B/O`): note the `FiniteGibbs` target,
  if landed, moves the finite mean-energy identity `⟨E⟩ = −d log Z/dβ` to `D` at
  the finite level; coarse-graining, initial-state principle, finite
  monotonicity, and the thermodynamic limit stay `O`; `E, β,` and the Gibbs form
  are `I` (supplied). It must **not** be read as thermodynamic-limit progress.
  (It is currently a Mathlib-only `s o r r y` stub, not landed.)

**`MANUSCRIPT_CLAIM_MATRIX.md`.**
- *M6*: change status "local walk and 4+2 architecture landed; invariant
  block/explicit coin running" to "explicit coin + 4+2 block **landed**;
  invariant four-component reduction for the actual coin **refuted (kill)**." The
  falsifier column "actual coin lacks invariant 4D block" is now **realized in the
  Clifford sense**. Keep `6 = 4+2` as a dimension count only.
- Add a thermodynamics row (proposed `M16`): payload
  `FiniteGibbs.log_partition_hasDerivAt`; assumptions supplied `E, β`, Gibbs
  weights, finite `n`; witness `twoLevelEnergy(4/25)` control; falsifier
  `⟨E⟩ ≠ −d log Z/dβ`; grade `M` (finite), **not** a prediction.

**`SIMULATION_BENCHMARKS.md`.**
- *S06*: record `axisBlockCoin` as the concrete coin with the `B⊕B⊕B` structure;
  add as a **realized negative control** "no Clifford square on any rank-four
  invariant sector" (forbidden `6 = 4` identification concretely killed), not
  merely a pending falsifier.
- *Dynamics*: log the `PluckerOscillatorDynamics` control
  (`energy (2/5) (step (2/5)(3/5)(4/5)(1,2)) = energy (2/5)(1,2)`) under S03 or a
  new dynamics row.
- Add a Gibbs benchmark row (proposed `S16`, V0/V1): anchor `FiniteGibbs`;
  observables `Z`, `∑ pᵢ = 1`, `⟨E⟩ = −d log Z/dβ`; fixture `twoLevelEnergy(4/25)`;
  pass metric exact / V1 against the landed derivative theorem; negative control
  e.g. a `β`-independent (unnormalized-derivative) weight or a wrong-sign mean.
  No such row currently exists.

---

## 8. Highest-value next theorem -- the concrete Dirac-block **no-go**

Turn Audit-08's proposed kill into a fully kernel-checkable no-go about the
**actual** landed coin (Mathlib-only; no `PhysicsSM.*` import needed once
`axisBlockCoin` is inlined). The honest, high-value outcome is a **refutation**.

```lean
-- Targets/D4CoinDiracBlockNoGo.lean  (imports: Mathlib only; inline axisBlockCoin)
-- U := axisBlockCoin : Matrix (Fin 6) (Fin 6) ℂ  (= B ⊕ B ⊕ B)
theorem axisBlockCoin_has_no_clifford_block :
    ¬ ∃ (ι : (Fin 4 → ℂ) →ₗ[ℂ] (Fin 6 → ℂ)) (H : (Fin 4 → ℂ) →ₗ[ℂ] (Fin 4 → ℂ)) (r : ℝ),
        Function.Injective ι ∧
        (∀ v, axisBlockCoin.mulVec (ι v) = ι (H v)) ∧      -- image is U-invariant, U|_im ≃ H
        (∀ v, H (H v) = (r : ℂ) • v) ∧ 0 < r := by         -- H is a genuine Clifford step
  s o r r y
```

- **Nonzero witness (that the no-go is non-vacuous).** The coin *does* have a
  concrete rank-four invariant sector: `span{e₀,e₁,e₂,e₃}` with `U` restricting
  to `B ⊕ B`. So the no-go is genuinely about the **Clifford square** `H² = r·I`,
  not about the existence of invariant 4-spaces. State this positive fact as a
  companion lemma `axisBlockCoin_has_invariant_four_space`.
- **Negative control.** On any single axis plane the restriction `B` is unitary
  and is itself a valid 1+1 checkerboard step (isotropic within that axis), yet
  `B² = [[-7/25, 24i/25],[24i/25, -7/25]] ≠ r·I` (`[verified-here]`). The failure
  is specifically the 3+1 anticommuting structure, not unitarity or the presence
  of an invariant subspace.
- **Kill condition (what would falsify the no-go).** Any coin-invariant 4-space
  whose restriction `H` satisfies `H² = r·I`, `r > 0`. This cannot exist for
  `axisBlockCoin`: the eigenvalues are exactly `3/5 ± 4i/5` (each multiplicity
  three), with distinct squares `-7/25 ± 24i/25`; a 4-space must contain lines of
  both squares (only three lines per square exist), so `H²` has ≥ 2 distinct
  eigenvalues and is never scalar. Landing this no-go discharges the S06
  "no isotropic Dirac coin" gate at the kernel level and forces the matrices to
  restate Kinematics as "six-direction walk = three decoupled 1+1 checkerboard
  walks + a **separate**, not-identified `4×4` Clifford symbol."

**Secondary constructive option.** If a positive next theorem is preferred, land
the Gibbs fluctuation-response rung
`d²/dβ² log Z = ⟨E²⟩ − ⟨E⟩² ≥ 0` (heat-capacity positivity). Witness:
`twoLevelEnergy(4/25)` with an explicit nonnegative variance; negative control: a
degenerate spectrum (all `Eᵢ` equal) forcing variance `0`; kill: any spectrum
with `d²/dβ² log Z < 0`. This is the honest thermodynamics extension of §5 and,
unlike the derivative identity alone, states a genuinely new positivity fact.

---

## Appendix -- items re-derived `[verified-here]` this session

- `axisBlockCoin 0 2 = 0`, `axisBlockCoin 0 1 = I·(4/5)`;
  `B² 0 0 = -7/25`, `B² 0 1 = 24i/25 ≠ 0` (coin is `B⊕B⊕B`; `B²` not scalar).
- `energy_conserved` (`m ≠ 0`, `c²+s²=1`); rational control at `(2/5;3/5,4/5;(1,2))`.
- Action Taylor identity and `+`-direction second difference `= massSq`.
- `dirac_block_intertwiner` TRUE with `A 0 = 0`; FALSE without it
  (`H = id`, `A ≡ ![1,0]`, `v = 0`); `include_dirac_injective`,
  `auxiliary_outside_control`.
- All five `FiniteGibbs` theorems, including `log_partition_hasDerivAt`
  (`d log Z/dβ = −⟨E⟩`) with a genuine `HasDerivAt` witness, and
  `rational_two_level_control` (`Z = 1 + exp(−β·4/25)`).
