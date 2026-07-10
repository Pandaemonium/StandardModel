# GRAND_STRATEGY_03 -- candidate full theory after the closed finite engine

Author: Aristotle (Codex grand strategy job 03), 2026-07-10.
Scope: reads the run constitution (`RUN_PLAN.md`), the theory/claim/benchmark
matrices (`THEORY_COMPLETION_MATRIX.md`, `MANUSCRIPT_CLAIM_MATRIX.md`,
`SIMULATION_BENCHMARKS.md`), the focused manuscript
(`Null_Edge_Mass_Rank_Defect_Manuscript_2026-07-09.tex`), the three Pro essays
(`A_broader_physics_of_finite_null_information.md`,
`A_moduli_theory_of_self-decoding_null_information.md`,
`Toward_a_complete_finite_null-information_theory.md`), the prior grand strategy
(`2026-07-10_ARISTOTLE_GRAND_STRATEGY_02.md`), the keystone audit
(`2026-07-10_ARISTOTLE_POST_KEYSTONE_AUDIT_06.md`), and -- decisively -- the six
now-vendored Lean modules in `Sources/`. It does not edit source files.

Grade vocabulary (run's own): `D` derived, `H` conditional theorem with all
load-bearing hypotheses displayed, `I` imported law/dictionary/constant,
`B` bridge conjecture with finite avatar + kill, `O` open interface, `K` killed.
Simulation tiers `V0..V4` as in `SIMULATION_BENCHMARKS.md`.

**What changed since GS-02.** GS-02 was written against a repository where the
key modules were *not vendored* and the statements were handoff targets. That is
no longer true. `Sources/` now contains six clean-room modules, each with a
`#print a x i o ms` guard pinned to `[propext, Classical.choice, Quot.sound]`:

- `D4FiniteUnitaryWalk` -- an actual periodic six-channel unitary D4 walk on a
  finite 3-torus (`walk_preserves_norm`), with the six future axial null roots
  verified in the shell and unit-luminal.
- `SixFourRankObstruction` -- an exact no-go: `¬ (ℂ^6 ≃ₗ ℂ^4)`
  (`no_direct_six_to_four_equivalence`) with `exact_rank_gap = 2`.
- `ArbitrarySpinorHodgeBridge` -- for *arbitrary* decorated spinor pairs, class
  cost `=` Plücker mass (`arbitrary_spinor_class_cost_eq_plucker`), with
  `4/25`, `9/25`, and collinear-`0` controls.
- `PluckerActionHessian` -- a finite nonnegative action whose exact Taylor
  formula exposes an EOM and whose positive-direction Hessian *is* the Plücker
  mass (`action_positive_hessian`, `action_hessian_eq_hodge_class_cost`).
- `SummableFourierContinuumLift` -- countable Fourier synthesis error bound and
  norm convergence under a summable envelope (`infinite_fourier_error_bound`,
  `infinite_fourier_tendsto`) with a normalized geometric witness.
- `UnitaryCheckerboardTransfer` -- the *same* matrix that appears in the exact
  path sum is two-sided unitary on the normalized circle
  (`physicalTransfer_eq_transfer`, `physicalTransfer_unitary`), and every
  replicated finite history is unitary (`physical_transfer_history_unitary`),
  with a nontrivial `3/5, 4/5` witness and a real-turn nonunitary control.

The two arrows GS-02 called "keystone missing / engine idling" have both moved:
step-unitarity is now *derived* on the normalized circle, and the mass
identification is now *arbitrary-pair* (no per-pair `hmu`). The frontier has
therefore shifted from "ignite the engine" to "close the four still-supplied
dictionaries and connect the finite engine to a genuine limit." This document
is organized around that shift.

---

## 1. The strongest honest end-to-end implication spine now in the kernel

Below, each arrow is graded and tagged `[derived]` (a checked theorem carries
it) or `[dictionary]` (a supplied definition/hypothesis carries it). The point
of the separation is that a reader can see exactly where the theory *reasons*
and where it *stipulates*.

```
null roots on selected D4 shell
  │  [derived] future_roots_in_selected_shell, six_roots_are_unit_luminal
  ▼
six-channel finite state space on a 3-torus
  │  [dictionary] coordinate-0 chosen as time; six axial shifts chosen
  ▼
exactly norm-preserving finite 3+1 walk (any unitary coin)
  │  [derived] shift_preserves_inner ∘ coin_preserves_inner = walk_preserves_norm
  ▼
── rank wall ──   [derived, no-go] no_direct_six_to_four_equivalence (gap = 2)
  │  the 6-channel walk is NOT the 4-component Dirac walk by any linear iso
  ▼
1+1 checkerboard normalized transfer (separate, 2-channel construction)
  │  [derived] physicalTransfer_eq_transfer : physical matrix = path-sum transfer
  ▼
two-sided unitary step on the circle c²+s²=1, imaginary turn, unit phases
  │  [derived] physicalTransfer_unitary  (control: wrongRealTurnTransfer not unitary)
  ▼
unitary finite history operator for every replicate length n
  │  [derived] physical_transfer_history_unitary  (via UnitaryHistoryComposition)
  ▼
exact operator-valued sum over all null histories = transfer power
  │  [derived, imported module] CheckerboardPathSumTransferPower
  ▼
countable abstract synthesis bound + norm convergence
  │  [derived] infinite_fourier_error_bound / infinite_fourier_tendsto
  │  [dictionary] a walk-specific SUMMABLE envelope is ASSUMED, not built
  ▼
(open) infinite-volume / L² / PDE Dirac propagator
```

and in parallel, the mass/positivity column:

```
arbitrary decorated spinor pair (ψ,φ)
  │  [dictionary] spinor decorations + decoder-selection rule supplied
  ▼
nonnegative Plücker turn scale → nondegenerate quartet decoder
  │  [derived] spinorSelectedDecoder := quartetSAt (turnScale ψ φ)
  ▼
exact class cost = |ψ∧φ|²  for every representative
  │  [derived] arbitrary_spinor_class_cost_eq_plucker  (4/25, 9/25, collinear 0)
  ▼
finite action with EOM and positive-direction Hessian = |ψ∧φ|²
  │  [derived] action_positive_hessian, action_exact_taylor, eom_zero_iff
  ▼
Hessian curvature = arbitrary-pair Hodge class cost (same invariant)
  │  [derived] action_hessian_eq_hodge_class_cost
  ▼
(dictionary) μ² = m²  physical mass identification -- still supplied
  ▼
(open) decorations/decoder/absolute units DERIVED from primitive dynamics
```

**Honest verdict.** For the first time the run has two *long derived
sub-chains that each terminate in a genuine composition object rather than a
conjunction*:

- **Quantum-history engine (1+1):** normalization ⇒ unitary step ⇒ unitary
  history ⇒ path-sum = transfer power ⇒ countable synthesis bound. Every arrow
  is a theorem except (i) the choice of normalized coefficients/phases and (ii)
  the summability envelope in the last rung.
- **Mass-as-curvature column:** arbitrary pair ⇒ Plücker turn scale ⇒
  invariant class cost ⇒ action Hessian ⇒ same invariant. Every arrow is a
  theorem except the supplied decorations/decoder rule and the final `μ²=m²`.

**The four supplied dictionaries that the rest of the theory must eliminate**
(quarantine these verbatim in the manuscript):

1. `μ² = m²` -- the physical mass identification (still a displayed hypothesis
   at the very end of the mass column).
2. Normalized transfer coefficients/phases (`c,s,uL,uR`) -- supplied, not
   derived from primitive physical data.
3. The walk-specific *summable envelope* consumed by
   `infinite_fourier_error_bound` -- assumed to exist; not constructed from the
   checkerboard modes.
4. The D4 time-axis + six-shift assignment and the coin `U` in
   `D4FiniteUnitaryWalk` -- chosen, not derived; and by the rank no-go they are
   *not* the Dirac walk.

**The one genuinely new structural fact of this phase is a no-go, not a
capstone:** `no_direct_six_to_four_equivalence`. The corpus should lead with it
precisely because it is a rigidity result -- it forbids the tempting shortcut of
declaring the six-channel walk to be the Dirac walk, and it *defines* the
constructive problem in §3.

---

## 2. The five highest-value exact next theorems

Ranked by (scientific leverage × Lean feasibility). Each names imports, a
mandatory nondegenerate witness, a control, a kill condition, and the exact
manuscript upgrade. All are stated to be *composition* or *rigidity* results,
not conjunctions.

### T1 -- Four-dimensional invariant Dirac sector of the six-channel walk
*(this is the constructive companion to the §3 no-go -- highest leverage)*

Statement sketch. Exhibit an explicit `ℂ`-linear `P : DirectionSpace →ₗ[ℂ]
DirectionSpace` with `P∘P = P`, `finrank (range P) = 4`, that commutes with the
coin `U` and with the shift generator, such that the restricted step is
conjugate to `Clifford3Plus1WalkSymbol.H(k,m)` up to the supplied phase; and a
complementary rank-2 projector `Q = 1−P` onto the auxiliary/gauge channels with
`walk`-invariance.

```lean
-- imports: D4FiniteUnitaryWalk, SixFourRankObstruction, Clifford3Plus1WalkSymbol
theorem d4_walk_has_invariant_dirac_sector
    (U : Matrix Direction Direction ℂ) (hU : IsUnitary U) (hUcoin : PhysicalCoin U) :
    ∃ P : Matrix Direction Direction ℂ,
      P * P = P ∧ Matrix.rank P = 4 ∧ P * U = U * P ∧
      (∃ e : (range P) ≃ₗ[ℂ] (Fin 4 → ℂ), IsConjugateToDiracStep e) := by
  s o r r y
```

- Witness: the concrete coin used in `walk_preserves_norm`; the four surviving
  channels must reproduce `H(1,2,2,3)² = 18·I` on the restricted sector.
- Control: `Q = 1−P` must be `walk`-invariant *and* nontrivial (rank exactly 2,
  matching `exact_rank_gap`); a would-be rank-3 or rank-5 projector must fail.
- Kill: if no coin-commuting rank-4 idempotent conjugate to the Dirac step
  exists, the six-channel walk does not *contain* a Dirac sector; the D4 walk is
  then reported as an inequivalent unitary model, and "3+1 Dirac dynamics" stays
  `O`. (Sharper no-go fallback: prove *no* coin-commuting rank-4 subspace closes
  the Clifford algebra -- a rigidity upgrade of the same value.)
- Upgrade: turns M6 from "internal algebra + inequivalent walk" into a
  *derived* 3+1 dynamics arrow; retires supplied dictionary #4's Dirac gap.

### T2 -- Walk-specific summable envelope from the checkerboard modes
*(closes the only remaining assumed hypothesis in the continuum rung)*

Statement sketch. Construct the explicit mode family of the 1+1 transfer power
and prove its per-mode relative error is dominated by a *summable* nonnegative
envelope, so `infinite_fourier_error_bound` applies with a *constructed* `g`
rather than an assumed one.

```lean
-- imports: SummableFourierContinuumLift, UnitaryCheckerboardTransfer,
--          CheckerboardPathSumTransferPower, BoundedMomentumManyStepContinuum
theorem checkerboard_envelope_summable (c s : ℝ) (hcs : c^2 + s^2 = 1) :
    ∃ g : ℤ → ℝ, Summable g ∧ (∀ k, 0 ≤ g k) ∧
      ∀ n k, ‖transferMode c s n k - diracMode c s k‖ ≤ (Dbox .. / n) * g k := by
  s o r r y
```

- Witness: the `3/5, 4/5` unitary transfer; `geometricEnvelope` (or a Schwartz
  tail) as the concrete `g` with `∑ g = 1` (already a witness in the module).
- Control: a nonsummable candidate envelope (e.g. constant `g`) must be shown
  to *fail* the hypothesis -- this is the honest boundary of the theorem.
- Kill: if the true checkerboard modes decay too slowly for any summable `g`
  (the `Dbox ∼ e^{K+M}` divergence GS-02 flagged), the synthesis-to-position-space arrow
  fails and "continuum" must stay a bounded-box statement.
- Upgrade: converts M5's continuum clause from "conditional on a supplied
  envelope" to "conditional only on the checkerboard convention," i.e. removes
  supplied dictionary #3.

### T3 -- Noether conservation from the finite action's translation symmetry
*(shortest genuine-dynamics rung; pure composition)*

Statement sketch. The action `action ψ φ x = ½ m² (x₂)²` has an exact discrete
translation/first-integral: along the finite EOM flow, a discrete energy
`E(x, p) := ½ m² x₂² + …` is exactly conserved step-to-step, and the second
difference (already `action_positive_hessian`) is the conserved curvature.

```lean
-- imports: PluckerActionHessian
theorem action_discrete_energy_conserved (ψ φ : CSpinor) (x v : Quartet) (t : ℝ) :
    discreteEnergy ψ φ (flowStep ψ φ x v t) = discreteEnergy ψ φ x v := by
  s o r r y
```

- Witness: `ψ,φ = edge0, edge1(2/5)` gives conserved `E` with Hessian `4/25`.
- Control: a non-symmetric perturbed action must *break* conservation (nonzero
  drift) -- proving the conservation law is load-bearing, not vacuous.
- Kill: if no nonconstant conserved quantity exists, the "action ⇒ dynamics ⇒
  conservation" arrow is empty and the Dynamics row stays `B`.
- Upgrade: gives the Dynamics/action row (`H/B`, currently *unclaimed flagship*)
  its first *derived* conserved quantity -- the missing vertex of the completion
  matrix's Dynamics layer.

### T4 -- Positive-cone / presentation invariance of the Hessian mass
*(rigidity result upgrading M3 toward universal)*

Statement sketch. The action Hessian `|ψ∧φ|²` is invariant under the
pairing-preserving presentation changes already banked (`SL2` invariance of
`spinorWedge`, boost transport of the positive cone), i.e. the *derived* mass is
a class invariant, not a representative artifact.

```lean
-- imports: PluckerActionHessian, ArbitrarySpinorHodgeBridge, GeneralGramTurnScale
theorem hessian_mass_presentation_invariant (g : SL2C) (ψ φ : CSpinor) (x : Quartet) :
    (action (g • ψ) (g • φ)) .hessianAt x = (action ψ φ).hessianAt x := by
  s o r r y
```

- Witness: a rational boost carrying `edge0, edge1(3/5)` keeps Hessian `9/25`.
- Control: a non-pairing-preserving (e.g. non-unimodular) map must change the
  Hessian -- isolating exactly which transformations preserve mass.
- Kill: if the Hessian is not `SL2`-invariant, mass-as-curvature is
  presentation-dependent and M3's "invariant" claim is retracted to a fixture.
- Upgrade: pushes M3 from "finite decorated family" toward the universal `C`
  clause; strengthens the flagship of §7.

### T5 -- Ensemble/partition object over the finite action
*(bridge to thermodynamics + measurable simulation; nondegenerate model)*

Statement sketch. Define the finite Gibbs weight `exp(−β·action ψ φ x)` over a
finite quartet coordinate grid and prove the partition function, its
expectation of the Hessian, and a fluctuation-response identity
`⟨(x₂)²⟩ − ⟨x₂⟩² = (β m²)⁻¹`-shaped equipartition are exact and computable.

```lean
-- imports: PluckerActionHessian
theorem action_equipartition (ψ φ : CSpinor) (hm : massSq ψ φ ≠ 0) (β : ℝ) (hβ : 0 < β) :
    variance (gibbs β (action ψ φ)) coord2 = 1 / (β * massSq ψ φ) := by
  s o r r y
```

- Witness: a Gaussian-rational discretization reproducing `4/25` as the
  curvature that sets the variance; a computable `#eval` fixture for S-sim.
- Control: `β → 0` (flat ensemble) must give the ungapped result; wrong-sign
  `β` must fail positivity.
- Kill: if no closed fluctuation-response identity holds on the finite grid,
  the ensemble/thermodynamics layer stays `O`.
- Upgrade: gives the Thermodynamics row its first exact monotone/response
  identity *and* a directly measurable V0/V1 simulation observable.

Priority order for the night: **T1 > T2 > T3 > T4 > T5.** T1 is the single
highest-value rung (it decides whether the six-channel walk is physics). T2
removes the last assumed hypothesis in the continuum chain. T3-T5 are
high-feasibility composition rungs that populate three still-empty completion
rows.

---

## 3. A constructive route around the `6 ≠ 4` rank obstruction

The vendored `no_direct_six_to_four_equivalence` (gap exactly 2) forbids the
naive identification. Three constructive escapes, ranked.

### Route A -- Four-dimensional invariant sector + two auxiliary/gauge channels
*(Rank #1: highest physical plausibility, highest Lean feasibility)*

Physics: the six axial directions carry a reducible representation; the physical
Dirac spinor is the rank-4 coin-commuting sub-representation, and the remaining
2 channels are auxiliary (gauge/constraint/ghost) modes removed by a projector --
exactly the `exact_rank_gap = 2` deficit. This mirrors how lattice/QCA
constructions carry redundant internal coin dimensions that a projector or
gauge condition trims. Because the residual is *2*, the natural reading is a
`Krein`/BRST doublet -- which the corpus already speaks (`KugoOjima`,
positive-sector machinery).

Lean feasibility: high -- this is exactly **T1**. It reuses `IsUnitary`,
`Clifford3Plus1WalkSymbol`, and idempotent/`rank` API. The proof is a concrete
projector plus a `LinearEquiv` onto `Fin 4 → ℂ`, all decidable/`norm_num`-able
on a rational coin.

Kill: no coin-commuting rank-4 idempotent conjugate to the Clifford step.

### Route B -- Successive-axis (Trotter/split-step) walk
*(Rank #2: strong physical pedigree, medium Lean feasibility)*

Physics: rather than one six-channel step, compose three 2-channel axis walks
(x, then y, then z), each a `physicalTransfer`-style unitary already banked. The
product of three 2-dim coins acts on `2 = 2` per axis but the *composite*
generator is a 4×4 Dirac-shaped operator (this is the standard route by which
split-step QWs reproduce (3+1) Dirac; see the honeycomb/triangular and QCA
literature already in the source library). Here `6 = 3 axes × 2` is read as
*three sequential binary choices*, never as one 6-vector, so the no-go simply
does not apply.

Lean feasibility: medium -- needs a Trotter composition lemma
`(stepX ∘ stepY ∘ stepZ)` with a controlled commutator/leading-symbol
statement; reuses `UnitaryHistoryComposition` and `HistoryOperatorMonoidalDagger`
but requires a new 3-axis symbol computation and an error term (which naturally
feeds T2's envelope).

Kill: the three-axis product's leading symbol is *not* the (3+1) Dirac symbol
(wrong anticommutators), i.e. successive binary axes do not assemble Dirac.

### Route C -- Sharper no-go (partial isometry / representation-theoretic)
*(Rank #3: lowest physical payoff, highest certainty; the honest fallback)*

Physics: if Routes A and B both fail, upgrade the obstruction: prove there is
no *coin-equivariant* partial isometry `ℂ^6 → ℂ^4` intertwining the D4 walk and
the Dirac walk (not merely no linear iso). This converts a mild dimensional
no-go into a *dynamical* rigidity theorem -- the strongest kind of result the run
prefers -- and honestly reports that the D4 walk is a genuinely distinct unitary
model of finite null dynamics.

Lean feasibility: high (it is a no-go, hence a contradiction from a `finrank`/
representation invariant), but low physical payoff: it closes the door rather
than opening it.

**Recommendation.** Pursue Route A (T1) first and Route B in parallel; hold
Route C as the pre-registered fallback so that the night ends with either a
derived Dirac sector (A/B) or a strengthened rigidity theorem (C) -- never a
stalled `O`.

---

## 4. Shortest route from finite action/Hessian to genuine dynamics

The vendored `PluckerActionHessian` gives a *static* variational object: action,
EOM (`eom_zero_iff`), exact Taylor (`action_exact_taylor`), Hessian = mass
(`action_positive_hessian`). To become *dynamics* it needs a flow, a conserved
quantity, an ensemble, and a measurable observable. Shortest ordered path:

1. **Flow (definition, then a theorem).** Promote the single positive
   coordinate `x₂` to a discrete-time trajectory `x₂(n)` under the EOM
   (`massSq · x₂` as a restoring term). This is a finite harmonic oscillator;
   its exact solution is a rotation of frequency `√(massSq)`. Cheap.
2. **Conservation (T3).** Prove the discrete energy is step-invariant. This is
   the vertex the Dynamics completion row lacks. Pure algebra on the quadratic
   action -- very high feasibility.
3. **Ensemble (T5).** Gibbs weight over a finite coordinate grid; exact
   partition function and equipartition/fluctuation-response identity tying the
   Hessian mass to a variance. This is both the thermodynamics bridge *and* the
   measurable simulation observable.
4. **Measurable simulation.** Add an S-ID benchmark (S16, below) computing the
   oscillator frequency `√(4/25) = 2/5` and the equipartition variance from the
   Gibbs ensemble, with the harmonic recovery as the V2 confrontation (finite
   oscillator ↔ continuum SHO). All `#eval`/`n a t i v e _ d e c i d e`-checkable on
   rationals.

Net: **T3 → T5 → S16** turns a static curvature identity into a conserved,
ensemble-averaged, numerically measurable finite dynamics in three rungs, none
of which needs new imports beyond `PluckerActionHessian`. This is the
lowest-risk way to populate the two emptiest completion rows (Dynamics;
Thermodynamics) with *derived* content.

Deliberately deferred: coupling multiple oscillators (interactions), and the
continuum action limit -- both belong after T1/T2 land, since they inherit the
lattice-symbol and envelope questions.

---

## 5. Shortest route from countable mode synthesis to walk-specific recovery

`SummableFourierContinuumLift` proves the *conditional*: given a summable
envelope, countable synthesis converges in norm (`infinite_fourier_tendsto`).
The gap to a real propagator is exactly the *construction* of that envelope for
the checkerboard walk, then the upgrade to L²/PDE. Ordered path:

1. **Envelope construction (T2).** Build the concrete `g` for the 1+1 transfer
   modes and prove summability, discharging the assumed hypothesis. This is the
   single blocking rung; everything downstream is conditional on it.
2. **L² synthesis object.** Instantiate `synthInfinite` with `E = L²(ℝ)` (or a
   finite-band `ℓ²`) and the transfer modes; `infinite_fourier_error_bound`
   then gives an *L² operator-norm* error `≤ ε · ∑ g`, i.e. the finite walk
   converges to a bounded L² propagator. Reuses the vendored theorem verbatim
   with a concrete Banach `E`.
3. **PDE identification.** Prove the limit operator's symbol equals the free
   Dirac symbol `exp(−iH(k,m)t)` on each mode (this is where
   `BoundedMomentumManyStepContinuum`'s `Dbox` bound supplies the per-mode
   `1/n` rate); assemble via the L² synthesis into "the limit solves the free
   Dirac equation on the band."
4. **Infinite-volume boundary.** State honestly that the box `L → ∞` limit is a
   separate rung: the periodic `D4FiniteUnitaryWalk` (finite `ZMod L` torus) is
   the natural infinite-volume candidate, but connecting its `L → ∞` limit to
   the L² propagator is `O` until the D4/Dirac sector (T1) is settled.

Net: **T2 → L²-instantiation → per-mode symbol match** is the shortest honest
route to a *bounded L² propagator on a momentum band*. The full unbounded-`k`,
infinite-volume PDE remains `O` and must be labeled so -- the `Dbox ∼ e^{K+M}`
divergence is the named falsifier that keeps this conditional.

---

## 6. V2 / V3 / V4 simulation ladder against known physics

Tiers per `SIMULATION_BENCHMARKS.md`: V2 = reproduction with disclosed imports;
V3 = calibrated fit with held-out data; V4 = pre-registered prediction. The
current board is entirely V0/V1; the engine now makes three honest V2s reachable
and exactly one V4 pre-registerable.

### V2-a -- Free 1+1 Dirac propagator from the unitary checkerboard
- Anchor: `physicalTransfer_unitary`, `physicalTransfer_eq_transfer`,
  `CheckerboardPathSumTransferPower`, and T2's envelope.
- Dataset: analytic free 1+1 Dirac propagator `exp(−iH(k,m)t)` on a momentum
  grid (self-generated reference; no external fit).
- Observable: L²/operator-norm error between the n-step walk kernel and the
  Dirac kernel per mode.
- Calibration params (disclosed): spacing `a`, `εm = 1/4`, `c = 1`, the imported
  free Dirac Hamiltonian, and the normalized `c,s,uL,uR`.
- Falsifier: error does not fall as `Dbox·t²/n`, or the required envelope is
  nonsummable (T2 kill). **Labeled reproduction, never prediction.**

### V2-b -- Finite harmonic oscillator from the Plücker action
- Anchor: T3 (conservation) + T5 (equipartition) + `action_positive_hessian`.
- Dataset: continuum SHO frequency `ω = √(mass)` and equipartition variance.
- Observable: measured oscillator frequency `2/5` (from Hessian `4/25`) and
  Gibbs variance `1/(β·massSq)`.
- Calibration: `β`, the coordinate grid spacing.
- Falsifier: measured frequency ≠ `√(Hessian)` or variance ≠ response identity.

### V2-c -- 3+1 Dirac dispersion on the D4 invariant sector *(gated on T1)*
- Anchor: T1 (Dirac sector) + `Clifford3Plus1WalkSymbol` (`H² = (|k|²+m²)I`).
- Dataset: relativistic dispersion `E² = |k|² + m²`.
- Observable: restricted-sector step spectrum vs `√(|k|²+m²)`; witness
  `k=(1,2,2), m=3 → 18`.
- Falsifier: no coin-commuting rank-4 sector reproduces `H²` (T1 kill) -- then
  this row is withdrawn, not downgraded.

### V3 -- Species spacing calibration (only if ≥2 mass channels land)
- Anchor: `ArbitrarySpinorHodgeBridge` costs `4/25`, `9/25` as two "species."
- Held-out protocol: fit the single spacing `a` to one mass ratio, predict a
  second. Discloses training/held-out split; strictly V3 (calibrated), never V4.
- Falsifier: predicted second ratio outside tolerance.

### V4 -- Species-dependent lattice dispersion (the one honest prediction)
- Anchor: the exact principal-branch relation `cos(ωa) = cos(ka)cos(ma)` (in the
  manuscript), leading massive expansion
  `ω² = k² + m² − (a²/3) k² m² + O(a⁴)`.
- Single free parameter: microscopic spacing `a` (one number).
- Fixed shape: deviation exactly `−(a²/3) k² m²` -- mass-and-momentum dependent,
  hence species-dependent.
- **Massless sector exactly luminal:** `m=0 ⇒ ω = |k|` on the principal branch,
  so a photon time-of-flight / GRB bound is *forbidden* here (would be spurious).
- Kill threshold: measured massive-dispersion deviation with the wrong `k²m²`
  structure, a photon-sector deviation, or a bound on `a` inconsistent with any
  fixed `a`. This is the manuscript's only pre-registerable V4; register `a`,
  the shape, and the luminal-photon constraint *before* any comparison.

Do **not** promote closure-binding, Λ-fluctuation, or generation counts to V4:
`FamilyRankNoGo`/`GenerationPermutationNoGo` show three generations is not
forced, Λ scaling imports volume statistics, and binding is plane-dependent --
each would be a fitted or vacuous "prediction."

---

## 7. What the manuscript can now state boldly, and what stays conditional

### Sentences that can be stated boldly (each carries a checked theorem)

- "A selected D4 null shell supplies six unit-luminal future axial directions
  and an **exactly norm-preserving finite (3+1) six-channel quantum walk** for
  every unitary coin." -- `six_roots_are_unit_luminal`, `walk_preserves_norm`.
- "The six direction channels **cannot** be identified with the four Dirac
  components by any invertible complex-linear map; the rank gap is exactly
  two." -- `no_direct_six_to_four_equivalence`, `exact_rank_gap`. *(Lead with
  this rigidity result.)*
- "For **every** decorated spinor pair, the selected positive Hodge decoder's
  exact class cost equals the pair's Plücker area `|ψ∧φ|²`, with distinct
  nonzero values `4/25`, `9/25` and a collinear zero." --
  `arbitrary_spinor_class_cost_eq_plucker`, `arbitrary_spinor_bridge_controls`.
- "This Plücker area is **exactly the positive-direction Hessian of a finite
  nonnegative action**, whose Taylor expansion exhibits the equation of
  motion." -- `action_positive_hessian`, `action_exact_taylor`,
  `action_hessian_eq_hodge_class_cost`.
- "The **same matrix** appearing in the exact 1+1 path sum over null histories
  is two-sided unitary on the circle `c²+s²=1`, and every finite replicated
  history is unitary." -- `physicalTransfer_eq_transfer`,
  `physicalTransfer_unitary`, `physical_transfer_history_unitary`, with the
  real-turn nonunitary control.
- "Countable Fourier synthesis of the walk converges in norm under a summable
  mode envelope." -- `infinite_fourier_tendsto` (state the envelope as a
  hypothesis; see conditional list).

### Phrases that must remain conditional (name the missing arrow inline)

- "The finite walk **is** the Dirac equation." -- CONDITIONAL. Blocked by the
  rank no-go until T1/Route A or B produces a coin-commuting rank-4 Dirac
  sector. Until then: "contains a candidate Dirac sector (open)."
- "Mass **is** derived." -- CONDITIONAL on `μ² = m²` (still supplied) and on
  spinor decorations/decoder selection being derived from primitive dynamics.
  Say: "mass² is realized as an invariant Plücker/Hessian curvature; its
  identification with physical mass² is a displayed dictionary."
- "The theory recovers the Dirac **propagator / PDE**." -- CONDITIONAL on T2
  (walk-specific summable envelope) and the L²/unbounded-`k` upgrade; the
  `Dbox ∼ e^{K+M}` divergence is the named obstruction. Say: "converges on a
  bounded momentum band / under an assumed summable envelope."
- "The transfer coefficients/phases and the D4 coin/time-axis are **derived**."
  -- CONDITIONAL; all supplied. Say "supplied normalized parameters."
- "Unitary evolution is **quantum mechanics**, including the Born rule." --
  CONDITIONAL; Born and the invariant positive-sector selection remain `O/I`.
- Any V2/V3 row described as a "prediction." -- FORBIDDEN; only the `−(a²/3)k²m²`
  dispersion with an exactly luminal photon sector is pre-registerable as V4.

### Recommended flagship sentence (defensible today)

> *On a selected finite null shell we machine-verify a norm-preserving (3+1)
> quantum walk and a rigidity theorem forbidding its naive identification with
> the four-component Dirac walk; in a separate 1+1 sector we machine-verify that
> the exact operator-valued sum over null histories is two-sided unitary and
> that the invariant Plücker area of any decorated spinor pair is exactly the
> positive-direction Hessian of a finite action -- assembling mass, unitary
> history dynamics, and a finite continuum bound into one candidate theory whose
> remaining frontier is four explicitly named dictionaries.*

Every clause of that sentence is backed by a vendored theorem; the closing
clause is the honesty spine. The four named dictionaries (`μ²=m²`, transfer
normalization, summable envelope, D4 coin/axis + Dirac gap) are exactly the
targets of T1-T5.

---

## Bottom line

The closed finite engine has done two things GS-02 called missing: it made the
transfer step *derivably* unitary and it made the mass identification
*arbitrary-pair*. The single most valuable new fact of this phase is a **no-go**
(`6 ≠ 4`), and the strategy converts it into the constructive T1/Route-A target
(a rank-4 invariant Dirac sector + rank-2 auxiliary channels). Spend the night
on T1 (decide the D4↔Dirac question), T2 (build the walk-specific envelope so
the continuum rung stands on its own), and the cheap T3/T5 rungs (conservation +
ensemble) that populate the two emptiest completion rows with derived content.
Keep every propagator, "is-Dirac," and "mass-is-derived" sentence conditional
with its named arrow, lead the manuscript with the rigidity theorem, and the
corpus reads as one candidate theory with a finite, four-item frontier rather
than an anthology of correct lemmas.
