# Live-repository reconciliation

This strategy snapshot was prepared before the latest integration wave. The
live repository now has fourteen benchmark families (thirteen V0/V1 and one
V2), an internal successive-axis `4x4` split-step theorem, an action-derived
discrete variational recurrence, and a kernel-checked stability theorem for that
recurrence. The first V2 is a fixed-momentum free-Dirac propagator reproduction,
not the Schottky or dispersion proposals below. The rational boost/Hessian
control remains `4/25`; the report's isolated `9/25` reference is a typo. Spatial
shifts, a walk-specific convergence rate, Gibbs variance, and the strongest
complex-scalar simultaneous-coin no-go remain frontier work.

# GRAND_STRATEGY_04 — from finite theory engine to physics confrontation

Author: Aristotle (Codex grand strategy job 04), 2026-07-10.
Scope read: the run constitution (`Docs/RUN_PLAN.md`); the theory, claim, and
benchmark control surfaces (`Docs/THEORY_COMPLETION_MATRIX.md`,
`Docs/MANUSCRIPT_CLAIM_MATRIX.md`, `Docs/SIMULATION_BENCHMARKS.md`); the prior
strategy (`Docs/2026-07-10_ARISTOTLE_GRAND_STRATEGY_03.md`); the controlling
adversarial audit (`Docs/2026-07-10_ARISTOTLE_CURRENT_THEORY_AUDIT_09.md`); the
literature log (`Docs/LIT_SEARCH_LOG.md`); the focused manuscript
(`Essays/Null_Edge_Mass_Rank_Defect_Manuscript_2026-07-09.tex`) and the three Pro
essays; and — decisively — the nine vendored Lean modules in `Sources/` plus the
one live proof stub in `Targets/Core.lean`. **No source files were edited.**

Grade vocabulary (the run's own): `D` derived by a checked finite theorem;
`H` conditional theorem with all load-bearing hypotheses displayed; `I` imported
law/dictionary/constant; `B` bridge conjecture with a finite avatar + kill;
`O` open interface; `K` killed by theorem or counterexample. Manuscript grades:
`T`, `T|H`, `M` (kernel-verified finite), `C` (pre-registered conjecture),
`[interp]`, `[import]`. Simulation tiers `V0..V4` per `SIMULATION_BENCHMARKS.md`.

**What changed since GS-03.** GS-03 was written when T1 (a Dirac sector inside
the six-channel walk) and T3–T5 (conservation, invariance, ensemble) were open
targets. The kernel has since moved, and — critically — moved partly *against*
the optimistic reading:

- **T4 landed (invariance):** `PluckerHessianSL2Invariance` proves the Plücker
  mass, the whole quadratic action, and its positive-direction Hessian are
  `SL(2,ℂ)`-presentation invariants, with a rational-boost witness keeping the
  Hessian `9/25` and a load-bearing determinant-one control (`2·I` dilation
  moves the Hessian to `64/25`).
- **T3/T5 landed (dynamics + ensemble):** `PluckerOscillatorGroup` makes the
  supplied Plücker scale the stiffness of an exact determinant-one reversible
  oscillator with inverse, angle-addition composition, and conserved energy;
  `FiniteGibbsResponse` proves finite positivity, normalization, and the exact
  response `d log Z/dβ = −⟨E⟩`, with the `4/25` two-level fixture.
- **T1 partially landed and partially killed:** `ExplicitSixChannelCoin` gives a
  genuine nonidentity two-sided-unitary `6×6` coin, but it is
  `B ⊕ B ⊕ B` — three decoupled 1+1 checkerboard blocks with **no cross-axis
  mixing** (`axis_block_coin_controls` proves entry `(0,2)=0`) — and its square
  is **not** a scalar for any `r` (`axis_block_coin_sq_ne_scalar`).
  `ConcreteD4InvariantSector` exhibits a real rank-four coin-and-shift-invariant
  sector (`concrete_coin_intertwines_four_sector`, `four_sector_has_exact_rank`),
  but Audit-09 establishes that **every** invariant four-space of this coin is
  anisotropic, and the module itself proves the sector **excludes** the `z⁺`
  channel (`excluded_z_channel_control`). The eigenvalues are `3/5 ± 4i/5`, their
  squares `−7/25 ± 24i/25` are distinct, so no invariant four-block can satisfy
  a Clifford square `H² = r·I`. **The naive "six-channel walk = four-component
  Dirac walk" identification is refutable for this coin (`K`), not merely open.**

That is the pivot of this wave: the single most valuable new fact is again a
**rigidity/no-go**, and the honest task for 04 is to (i) *promote that
refutation to a kernel-checked universal no-go*, (ii) *open the successive-axis
Route B that the no-go does not touch*, and (iii) *close the two cheap
derived-dynamics rungs (variance, action-derived recurrence)* so the theory
gains a genuinely new positivity fact and its first empirical confrontations.

---

## 1. The strongest honest end-to-end candidate-theory spine now in the kernel

Two long derived sub-chains terminate in genuine composition objects, joined at
the shared invariant `massSq = |ψ∧φ|²`. Each arrow is tagged `[D]/[I]/[O]/[K]`
with the theorem or dictionary that carries it. `[I]` marks a supplied
dictionary the rest of the theory must still eliminate.

### Column A — mass as an invariant curvature (strongest column; nearly all `D`)

```
arbitrary decorated spinor pair (ψ,φ)
  │  [I] spinor decorations + decoder-selection rule supplied
  ▼
nonnegative Plücker turn scale → nondegenerate quartet decoder
  │  [D] spinorSelectedDecoder := quartetSAt (turnScale ψ φ)
  ▼
exact class cost = |ψ∧φ|² for every representative
  │  [D] arbitrary_spinor_class_cost_eq_plucker  (controls 4/25, 9/25, collinear 0)
  ▼
finite nonnegative action with EOM (linear Taylor coeff) and Hessian (quadratic)
  │  [D] action_exact_taylor, action_positive_hessian, eom_zero_iff
  ▼
Hessian curvature = arbitrary-pair Hodge class cost (same invariant)
  │  [D] action_hessian_eq_hodge_class_cost
  ▼
that invariant is SL(2,ℂ)-presentation invariant, not a representative artifact
  │  [D] massSq_sl2_invariant, action_hessian_sl2_invariant
  │      (control: nonunimodular 2·I moves 4/25 → 64/25)
  ▼
same invariant is the stiffness of an exact reversible conserved oscillator group
  │  [D] group_hessian_energy_conserved, step_determinant_one, step_composition
  │  [I] the symplectic step (flow) and ω² = m² = massSq are SUPPLIED, not from the EOM
  ▼
finite canonical ensemble over that spectrum: positive, normalized, exact response
  │  [D] partition_pos, probability_sum_one, log_partition_hasDerivAt (d log Z/dβ = −⟨E⟩)
  │  [I] Gibbs weight exp(−βE), β, and the energy dictionary massSq = twoLevel gap supplied
  ▼
(open) fluctuation-response positivity ⇒ heat capacity ⇒ thermodynamic limit
  │  [O] Targets/FiniteGibbsVariance (variance = ⟨E²⟩−⟨E⟩² ≥ 0) is a s o r r y stub
```

Honest verdict on Column A: **the only non-`D` rungs are the four supplied
dictionaries (decorations/decoder, the oscillator flow + `ω²=m²`, the Gibbs
form + `β`), and the terminal variance rung which is a `s o r r y` stub landing
tonight.** Everything between "arbitrary pair" and "exact ensemble response" is a
theorem. This is the spine to lead with.

### Column B — unitary quantum history dynamics (1+1 derived; 3+1 blocked by a no-go)

```
selected D4 null shell: six unit-luminal future axial directions
  │  [D] (upstream) six_roots_are_unit_luminal
  ▼
finite periodic norm-preserving six-channel 3+1 walk (any unitary coin)
  │  [D] axis_block_walk_preserves_norm
  │  [I] coordinate-0 chosen as time; six axial shifts + coin coefficients supplied
  ▼
── rank wall ──  [K] no_direct_six_to_four_equivalence  (gap exactly 2)
  │  the six channels are NOT the four Dirac components by any linear iso
  ▼
── Clifford wall ──  [K, this coin] axis_block_coin_sq_ne_scalar; excluded_z_channel_control
  │  axisBlockCoin = B⊕B⊕B; eigenvalue-squares −7/25 ± 24i/25 distinct;
  │  every invariant 4-space is anisotropic and carries no Clifford square
  ▼
   ┌────────────────────────────────────────────────────────────────┐
   │ 3+1 Dirac identification of the SIMULTANEOUS coin: KILLED (§3)   │
   └────────────────────────────────────────────────────────────────┘
  │  reroute ▼ (successive-axis, §3 Route B — does not hit either wall)
  ▼
1+1 checkerboard normalized transfer (separate, 2-channel construction)
  │  [D] physicalTransfer_eq_transfer : physical matrix = path-sum transfer
  ▼
two-sided unitary step on c²+s²=1, imaginary turn, unit phases
  │  [D] physicalTransfer_unitary  (control: wrongRealTurnTransfer not unitary)
  ▼
every finite replicated history is unitary
  │  [D] physical_transfer_history_unitary
  ▼
exact operator-valued sum over all null histories = transfer power
  │  [D, upstream] CheckerboardPathSumTransferPower
  ▼
countable Fourier synthesis converges in norm under a summable envelope
  │  [D] infinite_fourier_tendsto ; [I] a walk-specific SUMMABLE envelope is ASSUMED
  ▼
(open) bounded-band L² propagator → infinite-volume / PDE Dirac
  │  [O]  Dbox ∼ e^{K+M} divergence is the named falsifier
```

Honest verdict on Column B: **the 1+1 quantum-history engine is `D` end to end
except the supplied normalized coefficients and the still-assumed envelope; the
3+1 identification of the simultaneous coin is now `K`.** The live question is
whether a *successive-axis* composite recovers 3+1 Dirac (Route B, §3) — that is
the only surviving path from Column B to relativistic kinematics.

### The frontier, restated as five supplied dictionaries (quarantine verbatim)

1. `μ² = m²` — physical mass identification (unchanged since GS-03).
2. Spinor decorations + the decoder-selection rule `spinorSelectedDecoder`.
3. The oscillator **flow** (symplectic step) and `ω² = m² = massSq` — supplied,
   not derived from `PluckerActionHessian.eom` (Audit-09 §3).
4. The Gibbs weight form `exp(−βE)`, `β`, and the energy spectrum.
5. Transfer normalization (`c,s,uL,uR`, imaginary turn) and the walk-specific
   summable envelope.
6. The D4 time-axis + six-shift assignment and the coin coefficients — and, by
   the two walls, these are provably **not** the simultaneous Dirac coin (`K`).

The full ledger of every inserted number is §7.

---

## 2. The five highest-value exact theorems for 04:10–06:30

Ranked by (scientific leverage × Lean feasibility). Each is a **composition,
rigidity, or positivity** result, never a conjunction. Each names imports, a
mandatory nondegenerate witness, a control, a kill condition, and the exact
manuscript upgrade. All must land before the 06:30 no-broad-jobs cutoff.

### T04-1 — Universal positive-real Clifford-block no-go for the simultaneous coin
*(highest leverage: converts a coin-specific refutation into a rigidity theorem)*

Statement sketch. For the actual landed coin (inline `axisBlockCoin`), there is
no injective four-channel inclusion whose image is coin-invariant and on which
the restricted step is a genuine Clifford step `H² = r·I`, `r>0`.

```lean
-- Targets/D4CoinDiracBlockNoGo.lean  (imports: Mathlib only; inline axisBlockCoin)
theorem axisBlockCoin_has_no_clifford_block :
    ¬ ∃ (ι : (Fin 4 → ℂ) →ₗ[ℂ] (Fin 6 → ℂ)) (H : (Fin 4 → ℂ) →ₗ[ℂ] (Fin 4 → ℂ)) (r : ℝ),
        Function.Injective ι ∧
        (∀ v, axisBlockCoin.mulVec (ι v) = ι (H v)) ∧
        (∀ v, H (H v) = (r : ℂ) • v) ∧ 0 < r := by
  s o r r y
-- companion (non-vacuity): the coin DOES have an invariant 4-space (B⊕B on x/y),
theorem axisBlockCoin_has_invariant_four_space : True := by trivial  -- placeholder; state via ConcreteD4InvariantSector
```

- **Import**: Mathlib only (inline the coin so no `PhysicsSM.*` dependency);
  reuse `ConcreteD4InvariantSector` for the non-vacuity companion.
- **Witness (that the no-go is non-vacuous)**: `span{e₀,e₁,e₂,e₃}` is a real
  rank-four invariant sector where the coin restricts to `B ⊕ B`
  (`concrete_coin_intertwines_four_sector`, `four_sector_has_exact_rank`). The
  no-go is therefore about the **Clifford square**, not the existence of an
  invariant 4-space.
- **Control**: one axis block `B` is unitary and a valid 1+1 checkerboard step,
  yet `B² = [[−7/25, 24i/25],[24i/25, −7/25]]` is non-scalar
  (`axis_block_coin_sq_ne_scalar` already banks `B² ≠ r·I`). The failure is the
  3+1 anticommuting structure, not unitarity.
- **Kill**: any coin-invariant 4-space with `H² = r·I`, `r>0`. Impossible: six
  eigenlines, squares `−7/25 ± 24i/25` each of multiplicity three; any four
  lines mix both squares, so `H²` has ≥2 eigenvalues.
- **Upgrade**: M6 flips its "invariant four-component reduction" sub-claim from
  `running` to **`K` (killed)**; the Kinematics row of the theory matrix records
  "simultaneous six-direction coin = three decoupled 1+1 checkerboard walks + a
  *separate* `4×4` Clifford symbol," retiring the temptation permanently.

### T04-2 — Finite fluctuation-response positivity (the Gibbs variance stub)
*(new positivity fact; already staged as a `s o r r y` stub — land it verbatim)*

Statement sketch. Land all six theorems of `Targets/Core.lean`
(`FiniteGibbsVariance`): the centered-variance identity, `variance ≥ 0`, the
derivative `d⟨E⟩/dβ = −Var(E)`, the `4/25` control (`variance = 4/625 > 0`), and
the degenerate-spectrum zero control.

```lean
-- Targets/Core.lean  (already present, all `by s o r r y`)
theorem variance_nonnegative (E : Fin n → ℝ) (beta : ℝ) : 0 ≤ variance E beta
theorem meanEnergy_hasDerivAt (E : Fin n → ℝ) (beta : ℝ) :
    HasDerivAt (meanEnergy E) (-variance E beta) beta
theorem rational_two_level_variance_control :
    variance (twoLevelEnergy (4/25)) 0 = 4/625 ∧ 0 < variance (twoLevelEnergy (4/25)) 0
theorem degenerate_spectrum_zero_control (c beta : ℝ) :
    variance (fun _ : Fin n => c) beta = 0
```

- **Import**: Mathlib (`HasDerivAt.sum`, `Real.hasDerivAt_exp`, `HasDerivAt.log`,
  `Finset.inner_mul_le_norm_mul_norm`/`sq_nonneg` for positivity). Audit-09 §4
  already re-proved all five older Gibbs theorems `[verified-here]`; this is the
  next rung of the same module.
- **Witness**: `twoLevelEnergy(4/25)` at `β=0` gives `variance = 4/625` (the
  Plücker gap squared over four); this is the numeric anchor for S18.
- **Control**: degenerate spectrum forces `variance = 0`
  (`degenerate_spectrum_zero_control`) — proves the positivity is load-bearing,
  not vacuous.
- **Kill**: any spectrum with `d²/dβ² log Z < 0` (would break heat-capacity
  positivity). Cannot exist — variance is a sum of squares.
- **Upgrade**: gives the Thermodynamics row its first **genuinely new positivity
  statement** (heat capacity `C = β²·Var(E) ≥ 0`), beyond the textbook response
  identity `M17` already carries; unlocks V2-α (Schottky, §5).

### T04-3 — Action-derived discrete recurrence (close the "flow is supplied" gap)
*(retires supplied dictionary #3 — the highest-value dynamics rung)*

Statement sketch. Define the adjacent-link discrete action
`S[x₋,x₀,x₊] = ½·massSq·((x₊−x₀)² + (x₀−x₋)²)` (or the standard midpoint form) and
prove its discrete Euler–Lagrange equation `∂S/∂x₀ = 0` is *exactly* a
three-term linear recurrence `x₊ − 2x₀ + x₋ = −massSq·x₀` whose solution is the
oscillator already banked in `PluckerOscillatorGroup`. This makes the flow
*derived from the action*, not inserted.

```lean
-- Targets/PluckerActionRecurrence.lean  (imports: PluckerActionHessian; Mathlib)
theorem action_euler_lagrange_recurrence (ψ φ : CSpinor) (xm x0 xp : ℝ) :
    discreteAction ψ φ xm x0 xp |>.derivMid = 0 ↔
      xp - 2*x0 + xm = - massSq ψ φ * x0 := by
  s o r r y
theorem recurrence_solved_by_oscillator (ψ φ : CSpinor) (n : ℕ) :
    (oscillatorTrajectory ψ φ n) satisfies action_euler_lagrange_recurrence := by
  s o r r y
```

- **Import**: `PluckerActionHessian` (for `massSq`, `action_exact_taylor`), and
  `PluckerOscillatorGroup` for the closed-form trajectory to match against.
- **Witness**: `ψ,φ = edge0, edge1(2/5)`, `massSq = 4/25`; the recurrence
  `xp − 2x0 + xm = −(4/25)x0` and its rotation solution with frequency `2/5`.
- **Control**: a non-quadratic perturbed action (add `x0³`) must **break** the
  linear recurrence — proves the derivation is load-bearing, not tautological.
- **Kill**: if the discrete EL equation is not the recurrence solved by the
  banked oscillator (Audit-09 §3 warns the quartet `eom = massSq·x₂` is a
  gradient, a *different object* from a `(q,p)` flow), then "action ⇒ dynamics"
  stays `B` and dictionary #3 remains.
- **Upgrade**: M16 changes "flow is not derived from the quartet EOM" to
  "recurrence derived from the adjacent-link action"; the Dynamics row gains its
  first *derived* (not supplied) evolution law.

### T04-4 — Successive-axis (Route B) split-step generator = 3+1 Dirac symbol
*(the only surviving path from Column B to relativistic kinematics; §3)*

Statement sketch. Compose three 2-channel axis walks `stepX ∘ stepY ∘ stepZ`
(each a banked `physicalTransfer`-style unitary), acting on the same internal
`ℂ⁴`, and prove the leading (first-order in the spacing) generator of the
product is the 3+1 Dirac symbol — concretely that the composite momentum symbol
`H(k,m)` satisfies `H(k,m)² = (|k|² + m²)·I` and the correct anticommutators,
matching `Clifford3Plus1WalkSymbol`.

```lean
-- Targets/SuccessiveAxisDiracSplitStep.lean
-- imports: UnitaryCheckerboardTransfer, UnitaryHistoryComposition,
--          Clifford3Plus1WalkSymbol (upstream)
theorem successive_axis_leading_symbol_is_dirac
    (a : ℝ) (ha : 0 < a) (k : Fin 3 → ℝ) (m : ℝ) :
    ∃ H : Matrix (Fin 4) (Fin 4) ℂ,
      leadingSymbol (splitStep a k m) = H ∧
      H * H = ((‖k‖^2 + m^2 : ℝ) : ℂ) • (1 : Matrix (Fin 4) (Fin 4) ℂ) := by
  s o r r y
```

- **Import**: `UnitaryCheckerboardTransfer` (`physicalTransfer_unitary`),
  `UnitaryHistoryComposition` (sequential unitary), upstream
  `Clifford3Plus1WalkSymbol` (`H² = (|k|²+m²)I`, witness `k=(1,2,2), m=3 → 18`).
- **Witness**: `k=(1,2,2), m=3`, reproducing `H² = 18·I` from three sequential
  binary axis steps rather than one 6-vector.
- **Control**: the *simultaneous* product with the wrong ordering, or a
  commuting (non-anticommuting) axis pair, must fail `H² = r·I` — this is
  exactly what T04-1 forbids for the simultaneous coin, so the contrast is the
  whole point.
- **Kill**: the three-axis product's leading symbol has the wrong
  anticommutators (Audit-09 §2, Mlodinow–Brun arXiv:1802.03910: four-dim
  internal space needs parity + axis symmetry + anticommutation). Then Route B
  fails and 3+1 Dirac kinematics stays `O`, resting on the internal algebra
  alone.
- **Upgrade**: if it lands, M6 gains a *derived* 3+1 Dirac generator via the
  successive-axis route (with the shift theorem T04-5 still required for a full
  spacetime walk); if it fails, the manuscript states the honest dichotomy.

### T04-5 — Required spatial-shift theorem for the successive-axis walk
*(makes Route B a spacetime walk, not just an internal algebra; gates the continuum)*

Statement sketch. Prove the successive-axis composite carries genuine
per-axis spatial shifts on the finite `ZMod L` torus — i.e. `stepX` translates by
`±x̂`, `stepY` by `±ŷ`, `stepZ` by `±ẑ` — and that the full step
`shift ∘ coin` is norm-preserving, so the split-step is an actual quantum walk
on the lattice, not a momentum-space symbol alone.

```lean
-- Targets/SuccessiveAxisSpatialShift.lean
-- imports: SuccessiveAxisDiracSplitStep, D4FiniteUnitaryWalk (upstream)
theorem successive_axis_walk_preserves_norm {L : ℕ} [NeZero L]
    (a : ℝ) (k : Fin 3 → ℝ) (m : ℝ) :
    IsNormPreserving (fullSplitStepWalk (L:=L) a k m) := by
  s o r r y
theorem successive_axis_shift_per_axis {L : ℕ} [NeZero L] :
    shiftsBy stepX x̂ ∧ shiftsBy stepY ŷ ∧ shiftsBy stepZ ẑ := by
  s o r r y
```

- **Import**: `SuccessiveAxisDiracSplitStep` (T04-4), upstream
  `D4FiniteUnitaryWalk` shift machinery.
- **Witness**: `L=5`, the same lattice as `axis_block_walk_preserves_norm`.
- **Control**: a shift that translates the wrong axis (or by zero) must break
  either norm preservation or the per-axis assignment.
- **Kill**: if the split-step cannot acquire independent per-axis shifts while
  staying unitary, Route B is a symbol-only construction and cannot feed a
  continuum limit — the continuum rung stays `O`.
- **Upgrade**: together with T04-4 this is the M6 replacement for the killed
  simultaneous-coin identification; it also supplies the concrete modes that
  T2's envelope (GS-03) needs, feeding the bounded-band continuum bound.

**Priority for the night: T04-1 ≈ T04-2 > T04-3 > T04-4 > T04-5.** T04-1 and
T04-2 are Mathlib-only, near-certain, and each closes a matrix row (one to `K`,
one to `D` with new positivity). T04-3 retires a supplied dictionary. T04-4/T04-5
are the higher-risk kinematics pair; land them if the cheap four land early,
otherwise pre-register their dichotomy honestly.

---

## 3. Kinematics decision tree after the simultaneous-axis coin

The simultaneous six-channel coin is decided. The tree below is firm: every
branch ends in either a kernel theorem or a pre-registered `O` with a named
falsifier.

```
                    axisBlockCoin = B ⊕ B ⊕ B  (LANDED, unitary, norm-preserving walk)
                                 │
              ┌──────────────────┴───────────────────┐
              ▼                                        ▼
   Does it contain a 3+1 Dirac              Universal statement of the
   sector (simultaneous)?                   obstruction (T04-1)
              │                                        │
     NO — proved (K):                        axisBlockCoin_has_no_clifford_block
     • no_direct_six_to_four_equivalence     • non-vacuity: rank-4 invariant
       (rank gap 2)                            sector EXISTS (B⊕B on x/y)
     • axis_block_coin_sq_ne_scalar          • control: single-axis B²
     • excluded_z_channel_control              non-scalar
     • eigenvalue-squares −7/25 ± 24i/25     ⇒ Kinematics simultaneous branch: K
       distinct                                       │
              │                                        │
              └───────────── reroute ─────────────────┘
                                 ▼
                    SUCCESSIVE-AXIS ROUTE B  (stepX ∘ stepY ∘ stepZ on ℂ⁴)
                                 │
              ┌──────────────────┼───────────────────────────┐
              ▼                   ▼                           ▼
   T04-4 leading symbol   T04-5 spatial-shift        quantitative continuum
   = Dirac (H²=(|k|²+m²)I) theorem (per-axis shifts   bound (shortest form)
              │            + norm preservation)               │
     PASS ⇒ derived 3+1          │                    bounded-band operator-norm:
     generator (M6 up)     PASS ⇒ genuine lattice     ‖split-step^n − e^{-iH t}‖
     FAIL ⇒ 3+1 stays O,    walk (feeds continuum)      ≤ Dbox(K,M)·t²/n  on |k|≤K, |m|≤M
     rests on internal      FAIL ⇒ symbol-only,        (reuse BoundedMomentumManyStepContinuum
     Clifford algebra       continuum stays O            shape; envelope from T2/T04-5 modes)
                                                                 │
                                                          FAIL falsifier:
                                                          Dbox ∼ e^{K+M} divergence ⇒
                                                          only bounded-box statement survives
```

**Universal no-go (branch 1):** T04-1. This is the honest capstone of the
simultaneous branch — a coin-specific refutation promoted to "no positive-real
Clifford block exists," with the invariant-four-space companion proving it is a
statement about the Clifford *square*, not about invariant subspaces.

**Successive-axis Route B (branch 2):** T04-4. The literature (Mlodinow–Brun
arXiv:1802.03910; Arrighi et al. arXiv:1803.01015) builds 3+1 Dirac walks as a
*product of three one-dimensional axis walks on a shared internal `ℂ⁴`*, with
parity + axis symmetry + anticommutation forcing the four-dim internal space and
the coin flip supplying the mass. `6 = 3 axes × 2` is read as three sequential
binary choices, so neither the rank wall nor the Clifford wall applies.

**Required spatial-shift theorem (branch 3):** T04-5. A leading-symbol match is
not a spacetime walk. Route B is only kinematics once the composite carries
independent per-axis lattice shifts and stays norm-preserving; this is the exact
theorem that separates "a `4×4` symbol we wrote down" from "a walk on the torus."

**Shortest quantitative continuum bound (branch 4):** reuse the banked
`BoundedMomentumManyStepContinuum` shape — a single explicit `Dbox(K,M)·t²/n`
operator-norm bound valid for all `|k| ≤ K`, `|m| ≤ M`, converging as `1/n` — now
instantiated with the *successive-axis* modes from T04-5 and the T2 envelope.
This is the shortest honest continuum statement: **a bounded-band L² propagator**,
not an infinite-volume PDE. The named falsifier is the `Dbox ∼ e^{K+M}`
divergence; if it bites, only the bounded-box statement survives and the
continuum row stays `O`.

**Recommendation.** Land T04-1 first (decide and close the simultaneous branch as
a rigidity theorem). Pursue T04-4 then T04-5 as the Route-B pair. Hold the
bounded-band bound as the continuum deliverable that both feeds and is gated by
T04-5. The night ends with either a derived successive-axis 3+1 generator (best
case) or a strengthened universal no-go plus an honest Route-B dichotomy (still a
publishable rigidity result) — never a stalled `O`.

---

## 4. Shortest action → EOM → stable flow → ensemble → thermodynamics chain

Ordered rungs, each naming the exact theorem and every dictionary that remains
`[I]` after the rung lands. This is Column A made operational.

1. **Action → EOM (LANDED, `D`).** `action_exact_taylor` exposes the EOM as the
   linear Taylor coefficient (`eom = massSq·x₂`) and the Hessian as the quadratic
   coefficient (`= massSq`); `eom_zero_iff` gives the critical set. *Remaining
   `[I]`:* the action coefficient `massSq` itself, and `μ²=m²`.

2. **EOM → discrete recurrence (T04-3, target).** Derive the three-term
   recurrence `xp − 2x0 + xm = −massSq·x0` from the adjacent-link action's
   discrete Euler–Lagrange equation, and match it to the banked oscillator.
   *Removes `[I]` dictionary #3 (the supplied flow)* if it lands; the frequency
   `ω=√massSq` becomes derived from the action rather than inserted.

3. **Recurrence → stable reversible flow (LANDED + one target).** LANDED:
   `PluckerOscillatorGroup` — `step_determinant_one`, `step_inverse`,
   `step_composition` (angle addition), `vector_energy_conserved`,
   `group_hessian_energy_conserved`. TARGET (stability, GS-03/lit job
   `04affe6e`): all-iterate positive-definiteness / bounded-orbit stability
   `∀ n, energy(stepⁿ x) = energy(x)` with the energy a positive-definite form,
   so orbits stay on a compact energy shell. *Remaining `[I]`:* `ω²=m²=massSq`
   until T04-3 lands; the time parameterization.

4. **Flow → ensemble (LANDED, `D`).** `FiniteGibbsResponse`: `partition_pos`,
   `probability_sum_one`, `log_partition_hasDerivAt` (`d log Z/dβ = −⟨E⟩`), with
   the `4/25` two-level fixture. *Remaining `[I]`:* the Gibbs weight
   `exp(−βE)` (max-entropy principle not derived), `β`, and the energy
   dictionary `massSq = twoLevel gap`.

5. **Ensemble → thermodynamics positivity (T04-2, target).**
   `FiniteGibbsVariance`: `variance ≥ 0`, `d⟨E⟩/dβ = −Var(E)`, heat capacity
   `C = β²Var(E) ≥ 0`, `4/25` control (`variance=4/625`), degenerate control.
   *Remaining `[I]`:* everything from rung 4; additionally the **thermodynamic
   limit** (`n→∞`), coarse-graining, initial-state principle, and any arrow of
   time stay `O` — this rung is a finite fluctuation-response, not irreversibility.

**Net chain and its dictionary residue.** After T04-2 and T04-3 land:
`action (D) → recurrence (D) → reversible stable flow (D) → canonical ensemble
(D) → fluctuation-response positivity (D)`. The chain is then **fully derived
between the action and heat-capacity positivity**, with exactly four dictionaries
still inserted at its two ends: (i) the action coefficient `massSq` / `μ²=m²`,
(ii) the decorations+decoder feeding `massSq`, (iii) the Gibbs weight form + `β`,
and (iv) the thermodynamic limit / arrow of time (open, not merely supplied).
Name all four in the manuscript at exactly the rungs above.

---

## 5. The first two honest V2 reproductions completable tonight

Both confront **accepted physics** (not just a landed Lean identity), use only
theorems that land tonight, and disclose every imported input. Neither is a
prediction; both are labeled reproductions.

### V2-α — Two-level Schottky specific heat / fluctuation-response (S18)
*(anchored on T04-2; the cleanest physics confrontation available tonight)*

- **Accepted-physics reference (analytic):** the exact two-level (Schottky)
  canonical results — mean energy `⟨E⟩ = Δ/(1+e^{βΔ})`, heat capacity
  `C(β) = β²Δ²·e^{βΔ}/(1+e^{βΔ})²`, with the Schottky anomaly peak at
  `βΔ ≈ 2.399` and peak `C ≈ 0.4392`. This is a standard, self-generated
  analytic reference (no external dataset, no fit).
- **Lean/source anchor:** `FiniteGibbsResponse.log_partition_hasDerivAt`
  (`d log Z/dβ = −⟨E⟩`) + `FiniteGibbsVariance.meanEnergy_hasDerivAt`
  (`d⟨E⟩/dβ = −Var(E)`) + `rational_two_level_variance_control` (`Var = 4/625`).
- **Observables:** `Z(β)`, `⟨E⟩(β)`, `Var(E)(β)`, and `C(β)=β²Var(E)` on a `β`
  grid, with the gap `Δ = 4/25` (Plücker two-level fixture).
- **Units:** `Δ` in Plücker/dimensionless action units; `β` in inverse action
  units; `C` dimensionless. All rational at the fixture points, real on the grid.
- **Error metric:** max absolute deviation between the simulated `C(β)` grid and
  the analytic Schottky curve; exact (`0`) at the rational fixtures
  (`β=0`: `⟨E⟩=2/25`, `Var=4/625`, `C=0`), V2 (`< 10⁻¹⁰`) on the grid; plus
  reproduction of the anomaly peak location within grid spacing.
- **Negative control:** degenerate spectrum (`degenerate_spectrum_zero_control`)
  gives `Var = C = 0` for all `β` — no Schottky peak, as required.
- **Falsifier:** simulated `C(β)` not matching `β²Var(E)`, a wrong peak location,
  or `C < 0` anywhere (would contradict `variance_nonnegative`).

### V2-β — 1+1 free-Dirac dispersion from the unitary checkerboard (S19)
*(anchored on already-landed `UnitaryCheckerboardTransfer`; no envelope needed)*

- **Accepted-physics reference (analytic):** the free 1+1 Dirac dispersion
  `E² = k² + m²` and its lattice principal-branch form (manuscript §"tetrahedral
  kinematic lift"): `cos(ωa) = cos(ka)cos(ma)`, with leading massive expansion
  `ω² = k² + m² − (a²/3)k²m² + O(a⁴)` and the exactly luminal massless sector
  `m=0 ⇒ ω = |k|`. This is the dispersion, **not** the full propagator, so it
  needs no summable envelope.
- **Lean/source anchor:** `physicalTransfer_unitary`,
  `physicalTransfer_eq_transfer` (the transfer eigenphases give `ω(k)`); the
  eigenvalues of the explicit `2×2` `physicalTransfer c s uL uR` on the circle
  `c²+s²=1`.
- **Observables:** the two transfer eigenphases `e^{±iω(k)a}` extracted on a
  momentum grid `k ∈ [−π/a, π/a]`, compared to `cos(ωa)=cos(ka)cos(ma)`; and the
  small-`a` slope check against `E²=k²+m²`.
- **Units:** spacing `a`, mass `m` in inverse-length; `k` in inverse-length;
  `ω` in inverse-time; `c=1`. Disclosed calibration: `c=3/5, s=4/5`, `εm=1/4`.
- **Error metric:** max deviation of the extracted principal-branch dispersion
  from `cos(ka)cos(ma)` (exact at rational fixtures, V2 `<10⁻¹⁰` on the grid),
  and the fitted continuum slope vs `E²=k²+m²` at small `a`.
- **Negative control:** the `wrongRealTurnTransfer` (real turn) is non-unitary
  (`rational_massive_transfer_controls`) and its "eigenphases" leave the unit
  circle — no real dispersion; a wrong turn phase must fail.
- **Falsifier:** extracted dispersion not of the form `cos(ka)cos(ma)`; a
  nonzero massless-sector deviation from `ω=|k|` (would be spurious — the
  principal branch forbids it); or eigenvalues off the unit circle.

**Why these two.** V2-α needs only Mathlib and the variance stub (T04-2), which
lands tonight; it confronts a textbook statistical-mechanics curve with a peak,
not just an identity. V2-β needs only the already-landed explicit `2×2` transfer
and confronts the relativistic dispersion on a bounded band **without** the open
envelope. Both are strictly V2 (disclosed imports), both have realized negative
controls, and neither can be laundered into a prediction. The one
pre-registerable V4 remains the species-dependent `−(a²/3)k²m²` lattice
dispersion with an exactly luminal photon sector (GS-03 §6) — do not confuse
V2-β (reproduction of the dispersion shape) with that V4 (pre-registered
deviation with a single free `a`).

---

## 6. The most defensible bold manuscript thesis and section architecture

### Thesis (defensible today, every clause backed by a vendored theorem)

> *On a selected finite null shell we machine-verify a norm-preserving (3+1)
> six-channel quantum walk together with two rigidity theorems that forbid its
> naive identification with the four-component Dirac walk — a rank obstruction
> (gap exactly two) and a Clifford-square obstruction proving no invariant
> four-block of the explicit coin carries a positive Dirac square. In a separate
> 1+1 sector we machine-verify that the exact operator-valued sum over null
> histories is two-sided unitary, and that the Plücker area of any decorated
> spinor pair is simultaneously an SL(2,ℂ)-invariant Hodge class cost, the
> positive Hessian of a finite action, the conserved stiffness of a reversible
> oscillator group, and the energy gap of a finite canonical ensemble whose
> logarithmic response and fluctuation positivity are exact — assembling mass,
> unitary history dynamics, reversible flow, and finite thermodynamics into one
> candidate theory whose remaining frontier is a small, explicitly named set of
> dictionaries and a single kinematic reroute (successive-axis Route B).*

Every clause carries a theorem: `axis_block_walk_preserves_norm`,
`no_direct_six_to_four_equivalence`, `axisBlockCoin_has_no_clifford_block`
(T04-1), `physicalTransfer_unitary`, `arbitrary_spinor_class_cost_eq_plucker`,
`action_hessian_sl2_invariant`, `action_positive_hessian`,
`group_hessian_energy_conserved`, `log_partition_hasDerivAt`, and
`variance_nonnegative` (T04-2). The closing clause is the honesty spine.

### Section architecture (announce the theory, then catalogue evidence)

1. **Introduction — one candidate theory of finite null information.** State the
   claim: null information is the common origin of quantum state, mass,
   reversible dynamics, and finite thermodynamics. Announce the derivation spine
   (Column A + Column B) and the explicit frontier.
2. **Postulates and the derivation spine.** The primitive data; what is derived,
   supplied, open, killed. Present §1 of this document as the architecture figure.
3. **The invariant mass column (flagship).** Plücker area = Hodge class cost =
   SL(2,ℂ)-invariant action Hessian; the reversible oscillator stiffness; the
   ensemble gap. Lead with `action_hessian_sl2_invariant` as the rigidity result.
4. **Unitary quantum histories (1+1).** Exact path sum = transfer power; two-sided
   unitarity; unitary replicated histories; bounded-band synthesis (conditional).
5. **Kinematic rigidity and the reroute (lead with the no-go).** The rank wall,
   the Clifford wall (T04-1), the anisotropic invariant sector, and the
   successive-axis Route B dichotomy (T04-4/T04-5) stated with its falsifier.
6. **Finite reversible dynamics and thermodynamics.** Action → recurrence
   (T04-3) → reversible stable flow → canonical ensemble → fluctuation-response
   positivity (T04-2); name every dictionary at its rung.
7. **Empirical confrontation.** The V0/V1 board; the two V2 reproductions
   (Schottky, checkerboard dispersion); the single pre-registered V4
   (`−(a²/3)k²m²` with a luminal photon sector). A parameter-accounting table.
8. **The frontier.** The six supplied dictionaries (§7 ledger) and the open
   layers (continuum PDE, thermodynamic limit, Born rule, gauge/gravity).

### Exact forbidden phrasings (must not appear in the manuscript)

- "The finite walk **is** the Dirac equation" / "the six-channel walk **is** a
  Dirac walk." — the rank wall and Clifford wall make this `K` for the
  simultaneous coin; only the successive-axis route (conditional) may claim a
  3+1 generator, and only if T04-4/T04-5 land.
- "Mass **is derived**." — `μ²=m²` and the decorations/decoder are supplied.
  Say "mass² is realized as an SL(2,ℂ)-invariant Plücker/Hessian curvature; its
  identification with physical mass² is a displayed dictionary."
- "The theory recovers the Dirac **propagator/PDE**." — conditional on the
  envelope and the L²/infinite-volume upgrade; say "converges to a bounded-band
  L² propagator under an assumed summable envelope."
- "We **derive** unitary evolution / the Born rule / quantum mechanics." — the
  positive-sector selection and Born rule remain `O/I`.
- "The theory **explains irreversibility / the arrow of time / entropy
  production**." — the ensemble is finite and time-symmetric; the thermodynamic
  limit and coarse-graining are `O`. Say "an exact finite fluctuation-response
  identity with heat-capacity positivity; irreversibility open."
- "The oscillator flow **follows from** the action." — forbidden until T04-3
  lands; the symplectic step is supplied (Audit-09 §3).
- Any V2/V3 row called a "**prediction**." — only the `−(a²/3)k²m²` dispersion
  with a luminal photon sector is pre-registerable as V4.
- Hedging verbs as a substitute for a decision: "may," "might," "could,"
  "suggests," "is consistent with." Replace with the exact missing theorem,
  input, scale limit, or experiment.
- "**Isotropic** Dirac coin" applied to `axisBlockCoin` — it is `B⊕B⊕B`,
  anisotropic by construction (Audit-09 §1–2).

---

## 7. Parameter / dictionary ledger — everything still inserted, not derived

Every coefficient, phase, scale, frame, action, `β`, and observed constant that
the corpus currently *stipulates*. This table is the manuscript's honesty
appendix; each row names the carrier and the theorem that would retire it.

| # | Inserted quantity | Where it enters (module / def) | Grade | Retiring theorem / status |
|---|---|---|---|---|
| 1 | `μ² = m²` physical mass identification | mass-column terminus | `I` | none scheduled; the deepest dictionary |
| 2 | Action coefficient `massSq` as `ω²` / oscillator stiffness | `PluckerActionHessian.action`, `PluckerOscillatorGroup.stepMatrix` | `I` | T04-3 (action-derived recurrence) makes `ω=√massSq` derived-from-action |
| 3 | Oscillator **flow** (symplectic rotation step) | `PluckerOscillatorGroup.step` | `I` | T04-3 |
| 4 | Spinor decorations + decoder-selection rule | `ArbitrarySpinorHodgeBridge.spinorSelectedDecoder := quartetSAt ∘ turnScale` | `I` | primitive-dynamics selection of decoder — `O`, unscheduled |
| 5 | Gibbs weight form `exp(−βE)` (max-entropy principle) | `FiniteGibbsResponse.weight` | `I` | max-entropy/equilibrium derivation — `O` |
| 6 | Inverse temperature `β` and energy spectrum `E` | `FiniteGibbsResponse` / `FiniteGibbsVariance` | `I` | supplied; `β` is a control parameter, not derived |
| 7 | Transfer normalization `c=3/5, s=4/5`, `uL,uR` unit phases | `UnitaryCheckerboardTransfer.physicalTransfer` | `I` | derive from primitive physical data — `O` |
| 8 | Imaginary turn phase `i·s` (vs real-turn control) | `UnitaryCheckerboardTransfer.turnCoin` | `I` | forced by unitarity given the convention; still a convention |
| 9 | Walk-specific summable envelope `g` | `SummableFourierContinuumLift` (assumed hyp) | `I` | GS-03 T2 (construct `g` from checkerboard modes) |
| 10 | D4 time-axis (coordinate 0 = time) | D4 shell / walk setup | `I` | primitive selection of a preferred axis — `O` |
| 11 | Six axial shift assignment | `D4FiniteUnitaryWalk` shifts | `I` | `O` |
| 12 | Coin coefficients `3/5, 4i/5` (per axis block) | `ExplicitSixChannelCoin.axisBlockCoin` | `I` | and by T04-1 these are provably **not** a Dirac coin (`K`) |
| 13 | SL(2,ℂ) frame / positive-cone selection | `PluckerHessianSL2Invariance`, positive-sector modules | `I`/`O` | invariant sector selection — `B` (see completion matrix Positivity row) |
| 14 | Lattice spacing `a` (continuum limit) | continuum modules / V4 | `I` | single free parameter of the one pre-registered V4 |
| 15 | Born rule / probability postulate | measurement layer | `O` | finite instrument / no-disturbance theorem — `O` |
| 16 | `ω² = m² = massSq` frequency identity | `PluckerOscillatorGroup.group_hessian_energy_conserved` (`hms`) | `I` | subsumed by rows 2–3 once T04-3 lands |

**Reading rule for the manuscript.** Rows 1, 4, 5, 10, 11, 13, 15 are the
*irreducible* current inputs (no scheduled retiring theorem this wave). Rows 2,
3, 9, 16 are *scheduled for retirement tonight* (T04-3, T2). Rows 7, 8, 12, 14
are *conventions/calibrations* to be disclosed, not claimed as derived. Every
manuscript sentence touching one of these must carry its grade inline.

---

## 8. What a hard 07:00 audit must verify — one candidate theory or an anthology?

The 07:00 audit switch is the decision point. To rule "one candidate theory"
rather than "a checked anthology of correct lemmas," the audit must verify **all**
of the following; any failure downgrades the corpus to an anthology for that row.

1. **Kernel hygiene.** Every `Sources/` and newly landed `Targets/` module
   `#print a x i o ms` reports exactly `[propext, Classical.choice, Quot.sound]`;
   the consolidated guard passes; no `s o r r y`/`a d m i t` remains in any theorem the
   manuscript cites. Re-run, do not trust status reports.

2. **The two rigidity walls are real and non-vacuous.** `no_direct_six_to_four_equivalence`
   (gap 2) and T04-1 (`axisBlockCoin_has_no_clifford_block`) both hold, and the
   companion non-vacuity lemma (an invariant rank-four sector *exists*) is present
   so the no-go is about the Clifford square, not the absence of invariant
   4-spaces. Confirm the eigenvalue-square arithmetic `−7/25 ± 24i/25` distinct.

3. **Column A composes as a single chain, not a conjunction.** Verify the arrows
   `class cost → Hodge cost → action Hessian → SL(2,ℂ) invariant → oscillator
   stiffness → ensemble gap` each cite a theorem whose hypotheses connect to the
   previous rung's conclusion (not five independent facts about the number
   `4/25`). Specifically check `action_hessian_eq_hodge_class_cost` genuinely
   routes through `arbitrary_spinor_class_cost_eq_plucker`, and that the
   oscillator stiffness and ensemble gap are the *same* `massSq`, not a re-inserted
   constant.

4. **No hollow telescoping or vacuity in the new flagships (Audit-09 §6 checks
   V/T/D/F).** In particular: T04-2's `variance_nonnegative` must be genuinely
   load-bearing (degenerate control gives `0`); T04-3's recurrence must be broken
   by a non-quadratic perturbation (not tautological); any `∃`-quantified
   architecture lemma (cf. `direction_has_four_plus_two_block`) must not be read
   in a caption as more than a dimension count.

5. **Dictionary ledger (§7) is complete and matches the kernel.** Every inserted
   constant/phase/frame in the ledger is actually the one the cited theorem uses,
   and no manuscript sentence promotes an `I`/`O` row to `D`. Confirm rows 2, 3,
   9, 16 are genuinely retired iff T04-3/T2 landed (do not credit them otherwise).

6. **Empirical rows are reproductions, not predictions.** V2-α and V2-β have
   disclosed imports, realized negative controls, and exact-at-fixture behavior;
   neither is labeled a prediction. The single V4 (`−(a²/3)k²m²`, luminal photon)
   has `a`, the deviation shape, and the luminal constraint pre-registered before
   any comparison. No forbidden-phrasing (§6) appears anywhere.

7. **The composition test executes.** At least one chain from
   `THEORY_COMPLETION_MATRIX.md` runs end to end with every arrow citing a
   theorem, a displayed import, or a bridge conjecture with a kill — concretely
   the Column A chain `primitive pair → invariant mass → action → reversible flow
   → ensemble → fluctuation-response`, with the four named dictionaries at its
   ends. An unnamed arrow anywhere = anthology.

8. **The kinematics branch is decided, not deferred.** The simultaneous-coin
   Dirac identification is recorded `K` (not `O`/`running`) in M6 and the theory
   matrix; Route B is either landed (`D`, with T04-4/T04-5) or pre-registered as
   a dichotomy with its exact falsifier. No row ends the night with only "future
   work."

**Decision rule.** If items 1–3 and 7–8 all pass, the corpus is *one candidate
theory with a finite, explicitly named frontier*. If any of 1–3 fails, it is an
anthology regardless of how many lemmas passed; if 7 or 8 fails, it is a theory
with a broken spine and the manuscript must not claim end-to-end derivation.

---

## Bottom line

The wave since GS-03 turned three open targets into derived rungs (SL(2,ℂ)
invariance, reversible conserved oscillator, exact Gibbs response) and turned the
tempting T1 shortcut into a **refutation**: the simultaneous six-channel coin is
`B⊕B⊕B`, its every invariant four-block is anisotropic, and no such block carries
a Clifford square. The 04 night should (1) promote that refutation to the
universal kernel no-go **T04-1**, (2) land the fluctuation-response positivity
stub **T04-2** for a genuinely new thermodynamic fact, (3) retire the supplied
oscillator flow via the action-derived recurrence **T04-3**, and (4) open the
only surviving kinematic path — the successive-axis **Route B** (T04-4/T04-5)
with its pre-registered dichotomy and bounded-band continuum bound. Confront
accepted physics tonight with two honest V2 reproductions (Schottky heat
capacity; checkerboard dispersion). Keep the mass column as the flagship, lead
the kinematics section with the rigidity walls, disclose the six-row dictionary
ledger, and the corpus reads as one candidate theory with a finite frontier —
not a theorem anthology.
