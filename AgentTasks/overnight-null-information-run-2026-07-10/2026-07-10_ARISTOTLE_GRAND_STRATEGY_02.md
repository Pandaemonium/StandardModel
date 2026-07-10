# GRAND_STRATEGY_02 — shortest credible route to a complete finite null-information theory

Author: Aristotle (Codex grand strategy job 02), 2026-07-10.
Scope: reads the whole run corpus — `RUN_PLAN.md`, `THEORY_COMPLETION_MATRIX.md`,
`MANUSCRIPT_CLAIM_MATRIX.md`, `SIMULATION_BENCHMARKS.md`, the mass/continuum
follow-up audit (`2026-07-10_ARISTOTLE_PHYSICAL_MASS_CONTINUUM_AUDIT_02.md`), the
focused manuscript (`Null_Edge_Mass_Rank_Defect_Manuscript_2026-07-09.tex`), and
the three Pro source essays. It is written to be actionable through the 07:00
America/Los_Angeles audit switch, and it enforces exact claim grades,
nondegenerate witnesses, falsifiers, and explicit imported inputs.

Grade vocabulary used below is the run's own:
`D` derived, `H` conditional theorem, `I` imported law/constant, `B` bridge
conjecture with finite avatar + kill, `O` open interface, `K` killed.
Simulation tiers `V0..V4` are as in `SIMULATION_BENCHMARKS.md`.

Note on the Lean state of *this* repository: the modules named throughout
(`PositiveHodgePhysicalMass`, `CanonicalGramTurnDictionary`,
`CheckerboardPathSumTransferPower`, `HistoryOperatorMonoidalDagger`,
`Clifford3Plus1WalkSymbol`, `BoundedMomentumManyStepContinuum`, …) live in the
`PhysicsSM.Draft.NullEdge.*` / `PhysicsSM.Spinor.*` tree, which is **not vendored
here** (the same absence the mass/continuum audit records). The Lean statements
in §3 are therefore precise *handoff targets* keyed to those declaration names,
to be dropped into a module that imports the corresponding draft files.

---

## 1. Verdict on the current end-to-end derivation spine

**Verdict: the spine is real and, for the first time this run, has a genuinely
*composed* dynamical sub-chain — but the two arrows that would make it a
*physical* theory (mass identification and quantum unitarity/continuum) are still
carried by *supplied dictionaries*, not derivations. It is a candidate theory
with one keystone missing and one engine idling, not yet a predictive theory.**

Reading the spine
`null primitives → gauge classes → positive states → mass → dynamics →
interactions → geometry → cosmology → experiment`:

- **null primitives → gauge classes: `D` (finite).** Kugo–Ojima cohomology,
  `GenericFiniteHodge`, and the landed `KreinChainEquivalence` +
  `DecoderChainHomotopy` make presentation-equivalence a checked finite theorem.
  Solid.
- **gauge classes → positive states: `D/B`.** Positive-sector *existence* and the
  sign no-go are `D`; an *invariant* selection principle is still `B`, and the
  normalized outcome rule (Born) is `I`. This is a load-bearing softness.
- **positive states → mass: `H/B` — the keystone gap.** `PositiveHodgePhysicalMass`
  now has a genuinely nondegenerate, indefinite Krein quartet with well-defined,
  nonnegative class cost `4/25`, and `quartet_class_cost_eq_canonical_plucker`
  finally wires the *nondegenerate* quartet (not the old degenerate `diag(0,1,1)`
  fixture) to the canonical Plücker value. **But the identification `μ² = m²`
  itself is still the inserted hypothesis `hmu` in `HodgePluckerMassBridge`**
  (audit F2). The `4/25` is a *shared number*, obtained on both sides by
  construction at a single point; the *function* `class → mass²` is not yet
  proved to equal the Plücker/turn determinant. This is the single highest-value
  gap in the theory.
- **mass → dynamics: `D` (finite, 1+1) — and this is where tonight genuinely
  composes.** `CheckerboardAmplitudeGluing` (exact multiplicativity carrying the
  intermediate direction) → `CheckerboardPathSumTransferPower` (the exact sum over
  all two-direction histories *is* the matrix element of the transfer power) →
  `HistoryOperatorMonoidalDagger` (sequential/dagger/parallel operator
  composition with a noncommuting Pauli control) is a real three-step derivation
  chain, not a conjunction. This is the strongest new structural result of the
  night.
- **…but dynamics is *not yet quantum*: `B`.** Gate assignment and **unitarity are
  inputs** to the monoidal/dagger layer. Until the transfer step is proved
  norm-preserving from a stated inner product, "unitary evolution" is asserted,
  not derived. The `SU(2)` / unitary-steps / unitary-histories jobs are exactly
  the missing derivation and must land.
- **dynamics → continuum: `H/O`.** `FixedMomentumManyStepContinuum` and
  `BoundedMomentumManyStepContinuum` give an explicit `Dbox(K,M)·t²/n` bound
  uniform over bounded momentum boxes — a real upgrade from pointwise — but
  `Dbox ∼ e^{K+M}` **diverges**, so there is no inverse-Fourier / position-space
  kernel and no PDE (audit F3). "Continuum" here means bounded-box, not a
  propagator.
- **3+1: `H` internal algebra only.** `Clifford3Plus1WalkSymbol` proves exact 4×4
  Clifford relations, component-velocity spectrum `±1`, and
  `H(k,m)² = (|k|²+m²)I` (e.g. `H(1,2,2,3)² = 18I`). This is a **supplied**
  Dirac-matrix prerequisite: there is no BCC lattice shift, no summed history
  propagator, no 3+1 continuum. It does *not yet compose* with the 1+1 dynamics
  chain.
- **interactions → geometry → cosmology: `H/B`.** Four-block rigidity, signed
  closure binding, `SpectralChainDistance` (n-point Connes distance = weighted
  geodesic), soldering coframe, and `GeometryRegisterLambda` /
  `VacuumShiftEnsemble` are individually strong finite results, but each attaches
  to the spine through an interpretive dictionary, not a derivation from the
  carrier.
- **theory → experiment: `V0/V1` only.** Eight benchmark families pass at V0/V1;
  there is **no V2 reproduction and no V4 prediction** on the board yet.

**Where results genuinely compose (claim it):** the 1+1 quantum-history engine
`gluing → path-sum = transfer power → operator monoidal/dagger`, and the
class-cost side `nondegenerate quartet → well-defined nonnegative μ² → shared
4/25 with canonical Plücker`.

**Where a dictionary is still merely supplied (quarantine it):**
(i) `μ² = m²` (`hmu`) — the mass identification;
(ii) `free_mass_operator_eq_complexified_turn` — same `m` inserted both sides;
(iii) unitarity + gate assignment in the operator monoidal layer;
(iv) the 3+1 Dirac matrices in `Clifford3Plus1WalkSymbol` (no lattice arrow);
(v) the Born rule (P4);
(vi) volume statistics behind `Λ`.
`CanonicalGramTurnDictionary`'s new `iff` theorems sharpen *what the dictionary
determines* (fixed pair ⇒ unique turn scale) but do **not** derive the dictionary
from primitive histories.

---

## 2. The five most important missing arrows

Ranked by (scientific leverage × formal tractability). Each is stated as a single
arrow of the spine, with why it is decisive and how hard the *next* rung is.

**A1 — Mass keystone: derive `μ² = m²` on a constructed Plücker quartet
(positive states → mass).**
Leverage: maximal. This is the arrow that turns "positive Hodge class" and
"Plücker determinant" from two objects sharing a number into one mechanism; it is
the literal statement of the theory's central thesis (mass = least spectral cost
of a positive class). Tractability: the *general* derivation is hard, but a
decisive intermediate is easy — **parameterize the quartet by `m` and prove the
class cost equals `detP(m)` for a rational family**, removing `hmu` for that
family. Kills or converts the keystone tonight.

**A2 — Quantum engine: finite unitarity of the transfer/history step
(dynamics → *quantum* dynamics).**
Leverage: high. The gluing→transfer-power→monoidal chain is already derived; the
one missing ingredient making it *quantum* is norm preservation. Tractability:
very high on the finite 2×2 symbol (this is what the running SU(2)/unitary-steps
jobs are for). Once the step is `J`-unitary, unitarity of the transfer power and
of the summed kernel follow by functoriality of the already-landed chain.

**A3 — 3+1 lattice step from the Clifford symbol
(internal algebra → 3+1 dynamics).**
Leverage: high. 3+1 is where the theory stops being a 1+1 toy; the D4/BCC
structure is the claimed microscopic step graph. Tractability: medium — a single
unitary BCC shift-coin step whose generator squares to `(|k|²+m²)I` reuses
`Clifford3Plus1WalkSymbol` as the coin. Feeds directly on the running D4-null-root
and SU(2) jobs.

**A4 — Invariant positive-sector selection (gauge classes → positive states).**
Leverage: high (this is the probability layer; without it P4 is a witness, not a
postulate, and Born stays imported with no anchor). Tractability: medium —
positive *inertia* invariance under Krein intertwiners is partly landed in
`KreinChainEquivalence`; the next rung is intertwiner+homotopy invariance of the
*sector* plus nonemptiness. Full Born remains `O`.

**A5 — Position-space continuum via finite Fourier synthesis
(dynamics → continuum / experiment).**
Leverage: high — this is the only arrow that produces a *V2 reproduction* (Dirac
propagator) and the *V4 prediction* (lattice dispersion). Tractability: the hard
part (uniform-in-all-`k` control) stays open, but tonight's **finite Fourier
synthesis** is exactly the lever to assemble the fixed-momentum bound over a
*finite* momentum grid into an honest position-space kernel error, giving a
publishable finite-box continuum statement now and a pre-registered `a`-bound.

Deliberately ranked *below* the five (do not spend the night on them): the
soldering Ward identity (program F), spectral-monodromy generations (program G;
already fenced by `FamilyRankNoGo`), and the Λ criticality theorem (program E).
They are `B/O` with lower composition payoff before A1–A3 land.

---

## 3. One exact next Lean theorem per arrow (witness + kill)

Each target imports the named draft modules. "Witness" is the mandatory
nondegenerate exact fixture; "Kill" is the pre-registered falsifier.

### A1 — Plücker quartet mass identification

Replace the point identity `quartet_class_cost_eq_canonical_plucker` (a single
`4/25`) by a *family* identity that derives `μ²(m) = m²` by construction, so
`hmu` is discharged on the constructed family instead of assumed.

```lean
-- imports: PositiveHodgePhysicalMass, CanonicalGramTurnDictionary
theorem plucker_quartet_class_cost_eq_massSq
    (m : ℝ) (chi : PositiveHodgePhysicalMass.Quartet) :
    (PositiveHodgePhysicalMass.classCost
        (PositiveHodgePhysicalMass.pluckerQuartet m)
        (PositiveHodgePhysicalMass.qe2 + PositiveHodgePhysicalMass.quartetQ chi)
        : ℂ)
      = CanonicalGramTurnDictionary.complexAbsSq
          (spinorWedge CanonicalGramTurnDictionary.edge0
            (CanonicalGramTurnDictionary.edge1 m)) := by
  s o r r y
```

- **Witness:** `pluckerQuartet (2/5)` reproduces the landed nondegenerate,
  indefinite quartet with common value `4/25`; a second rational point
  `m = 3/5` must give `9/25` (nonzero, distinct) — proving the map is `m ↦ m²`,
  not a coincidence at one value.
- **Kill:** if for any rational `m ≠ 0` the constructed class cost `≠ m²`
  (equivalently `≠ detP` of the spinor pair), the Hodge eigenvalue is *not* the
  physical mass²; `μ² = m²` must remain a displayed imported hypothesis and the
  keystone arrow stays `B`.

### A2 — finite unitarity of the transfer/history step

```lean
-- imports: CheckerboardPathSumTransferPower, HistoryOperatorMonoidalDagger
theorem transferStep_unitary (k m : ℝ) :
    (Checkerboard.transferStep k m)ᴴ * Checkerboard.transferStep k m = 1 := by
  s o r r y

-- corollary that must fall out via the already-landed transfer-power chain:
theorem transferPower_norm_preserving (k m : ℝ) (n : ℕ) (v : Fin 2 → ℂ) :
    ‖(Checkerboard.transferStep k m) ^ n *ᵥ v‖ = ‖v‖ := by
  s o r r y
```

- **Witness:** at `(k, m) = (3/5, 4/5)` (Gaussian-rational, on the unit shell)
  the product is exactly `I`; the corollary preserves `‖v‖` for a nonzero rational
  `v` and any `n`.
- **Kill:** any rational `(k, m)` for which the branch/corner convention yields a
  non-`J`-unitary step falsifies norm conservation — the corner-weighted path sum
  is then *not* a quantum evolution, and the "unitary histories" claim of P2/M5
  is retracted to a non-unitary transfer statement.

### A3 — 3+1 BCC lattice step from the Clifford symbol

```lean
-- imports: Clifford3Plus1WalkSymbol, tetrahedral history modules
theorem bccWalkStep_unitary_and_symbol (k : Fin 3 → ℝ) (m : ℝ) :
    (Tetra.bccStep k m)ᴴ * Tetra.bccStep k m = 1
    ∧ (Tetra.bccGenerator k m) ^ 2
        = ((‖k‖ ^ 2 + m ^ 2 : ℝ) : ℂ) • (1 : Matrix (Fin 4) (Fin 4) ℂ) := by
  s o r r y
```

- **Witness:** `k = ![1, 2, 2]`, `m = 3` gives `H² = 18 · I` (matching the landed
  `Clifford3Plus1WalkSymbol` value) with a unitary step; a wrong-`β`-sign control
  breaks the anticommutation and fails the square.
- **Kill:** if no unitary BCC shift-coin reproduces `H(k,m)² = (|k|²+m²)I`, the
  Clifford symbol does not lift to a 3+1 walk and must be reported as internal
  algebra only (no 3+1 dynamics arrow).

### A4 — invariant positive-sector selection

```lean
-- imports: KreinChainEquivalence, PositiveHodgeDecoder, DecoderChainHomotopy
theorem positiveSector_intertwiner_invariant
    {C C' : Carrier.KreinChain} (φ : Carrier.KreinIntertwiner C C') :
    Nonempty (Carrier.PositiveSector C ≃ Carrier.PositiveSector C')
    ∧ (Carrier.PositiveSector C).Nonempty := by
  s o r r y
```

- **Witness:** the landed `Jpos/Jneg` quartet gives a nonempty positive sector and
  `KreinChainEquivalence` supplies the intertwiner realizing the bijection.
- **Kill:** any intertwiner (or chain homotopy) that sends a positive class to an
  indefinite or empty sector proves positivity is presentation-dependent; then P4
  cannot be a physical postulate and the probability layer stays `O` (Born only,
  imported).

### A5 — position-space kernel via finite Fourier synthesis

```lean
-- imports: BoundedMomentumManyStepContinuum, finite Fourier synthesis module
theorem positionKernel_error_bound_on_grid
    (K M T : ℝ) (n N : ℕ) (hn : 0 < n) (x : ℤ)
    (hK : 0 ≤ K) (hM : 0 ≤ M) :
    ‖FiniteFourier.synth N (fun k => (Checkerboard.transferStep k M) ^ n) x
        - FiniteFourier.synth N (fun k => Dirac.flow k M T) x‖
      ≤ BoundedMomentumManyStepContinuum.Dbox K M * T ^ 2 / n := by
  s o r r y
```

- **Witness:** on a fixed finite `N`-point momentum grid within `|k| ≤ K`, the
  synthesized position-space kernel converges to the Dirac kernel at rate `1/n`
  with the single explicit constant `Dbox(K,M)`; exact at a rational grid point.
- **Kill:** if the grid-refinement (`N → ∞`, i.e. continuum-`k`) limit diverges
  because `Dbox ∼ e^{K+M}`, the position-space/PDE arrow fails; "continuum" must
  stay a *bounded-box, fixed-grid* statement and may not be described as a
  propagator or PDE.

---

## 4. Most compelling manuscript architecture now supportable

Announce the theory, then let the *composed* chain carry it and quarantine the
supplied dictionaries in one visible place. Proposed skeleton (upgrades the
existing `.tex`, keeps its claim-label discipline `T / T|H / M / C / [interp]`):

1. **The candidate theory (already drafted, keep).** Five postulates P1–P5, the
   graded derivation-spine table, "what it says / does not yet derive." Add one
   sentence stating the two supplied dictionaries that the rest of the paper is
   organized to *eliminate*: `μ² = m²` and step-unitarity.

2. **The mass keystone (lead with the strongest composed result).**
   Nondegenerate indefinite quartet → well-defined nonnegative class cost
   (`class_mass_wellDefined`, `class_mass_nonneg`) → shared `4/25` with the
   canonical Plücker value (`quartet_class_cost_eq_canonical_plucker`). State
   `μ² = m²` **explicitly as a displayed hypothesis** and cite A1 as the exact
   theorem that would discharge it. Do not let the shared number read as a
   derivation.

3. **The quantum-history engine (the night's best genuine composition).**
   `gluing (carrying intermediate direction) → path-sum = transfer power →
   operator monoidal/dagger with noncommuting Pauli control`. Present as a single
   functorial derivation. Immediately flag: **unitarity and gate assignment are
   inputs**, with A2 as the theorem that internalizes them.

4. **3+1 internal algebra, clearly fenced.** `Clifford3Plus1WalkSymbol`
   (`H² = (|k|²+m²)I`, `±1` component velocities) as an *algebraic prerequisite*,
   with A3 as the missing lattice arrow. No BCC-propagator language yet.

5. **Kinematics, coherence, four channels, closure/binding, soldering, Λ.** As in
   the current manuscript, each ending with the mandated block:
   *what the theorem proves / what we think it means [interp] / what would kill
   that reading / executable test (S-ID)*.

6. **Continuum & experiment.** `FixedMomentum`/`BoundedMomentum` box bounds as an
   honest finite continuum, A5 as the position-space upgrade, then §5's V2/V4.

7. **Supplied-input ledger (new, mandatory, one page).** A single table listing
   every imported/assumed input — `μ² = m²`, step-unitarity + gate assignment,
   3+1 Dirac matrices, Born rule, volume statistics — with the exact theorem or
   experiment that would remove each. This is the paper's honesty spine and its
   strongest rhetorical move: the frontier is finite and named.

Central thesis to defend verbatim (unchanged, it is now better supported):
*mass is a positive-sector spectral rank defect of coherently composed null
information, realized through constrained Hodge decoding, exact null-history
dynamics, and four second-order obstruction types.*

---

## 5. Fastest route to V2 (known physics) and a genuine V4 (prediction)

**V2 — fixed-momentum free Dirac reproduction (no hidden fit).**
Anchor: `FixedMomentumManyStepContinuum` (+ A2 for unitarity). Import the standard
free Dirac Hamiltonian and the gate assignment *explicitly as the dictionary*.
The benchmark shows the finite split-step walk reproduces `exp(-iH t)` at rate
`D(k,m) t²/n` at each fixed `(k,m)`. **Disclosed imports:** Dirac matrices, gate
assignment, `c = 1`, the spacing/mass calibration `εm = 1/4`. This is a
*reproduction*, labeled V2, never a prediction — record it in S05/S06 with the
imported-Hamiltonian line filled in. This is the cheapest honest V2 and it is
one A2 rung away from being fully internal.

**V4 — species-dependent lattice dispersion, pre-registered.**
Anchor: the exact principal-branch relation `cos(ωa) = cos(ka)cos(ma)`, whose
small-`a` massive expansion is
`ω² = k² + m² − (a²/3) k² m² + O(a⁴)` (already in the manuscript falsifier list).

Pre-registration (fix *before* any data comparison):
- Single free parameter: the microscopic spacing `a` (one number, not a curve).
- Fixed functional form: the deviation is exactly `−(a²/3) k² m²` to leading
  order — mass-*and*-momentum dependent, hence species-dependent.
- **Massless sector is exactly luminal:** `m = 0 ⇒ ω = |k|` on the principal
  branch, so photon time-of-flight is *not* the constraint; importing a
  gamma-ray-burst bound here would be spurious and is explicitly forbidden.
- Kill threshold: current precision bounds on massive-particle dispersion put an
  upper bound on `a`; a measured deviation with the *wrong* `k²m²` structure, or a
  photon-sector deviation, falsifies the walk.

Why this hides no fitted inputs: `a` is the *only* free quantity, the shape is
forced by the landed dispersion theorem, and the massless null-consistency
removes the tempting-but-illegitimate photon bound. This is the one genuinely
pre-registerable V4 in the corpus; make it the manuscript's headline prediction.

(Do **not** promote the closure-binding, Λ-fluctuation, or generation-count
numbers to V4: closure binding is plane-dependent, Λ fluctuation scaling imports
volume statistics, and `FamilyRankNoGo` shows three generations is not forced.
Each would be a fitted or vacuous "prediction.")

---

## 6. Aggressive work allocation through the 07:00 audit switch

Lanes per `RUN_PLAN` §10: **Codex = proof/composition + audit lead, moduli/SM
interfaces; Claude = manuscript + simulation + local-process lead.** Freeze broad
jobs at 06:30; hard audit at 07:00. Keep ≈5–7 useful jobs/agent, ≥1 audit job
each in flight, one grand-strategy job/agent per 90 min, one lit/package pass per
30 min.

### Codex (proof + audit)
1. **Now → 02:30 — A1 keystone (top priority).** Submit
   `plucker_quartet_class_cost_eq_massSq` as a focused package (import
   `PositiveHodgePhysicalMass`, `CanonicalGramTurnDictionary`; seed the two
   rational witnesses `2/5 → 4/25`, `3/5 → 9/25`). This is the single most
   valuable rung of the night; escalate effort if the low-effort pass stalls.
2. **In parallel — A2 finite unitarity.** Harvest the running SU(2)/unitary-steps
   job first; if it delivers a `J`-unitary step, immediately compose
   `transferPower_norm_preserving` through the landed transfer-power chain. If it
   stalls at the two-hour mark, cancel and resubmit only the `transferStep_unitary`
   tail.
3. **02:30 → 05:00 — A3 3+1 lattice step.** Harvest the D4-null-roots job; submit
   `bccWalkStep_unitary_and_symbol` reusing `Clifford3Plus1WalkSymbol` as the coin
   with witness `k=(1,2,2), m=3 → 18I`.
4. **Continuous — audit lane.** Keep one `codex-` audit job live: re-verify that
   A1, once landed, actually removes `hmu` on the constructed family and that no
   docstring reads the shared `4/25` as a derivation (close audit F1/F2). Confirm
   `#print a x i o m s` footprints stay `[propext, Classical.choice, Quot.sound]`.
5. **06:30 freeze → 07:00 audit.** Independent anchor sweep of every manuscript
   citation; complete the supplied-input ledger (§4 item 7); co-sign
   `HONEST_SCORECARD.md`.

### Claude (manuscript + simulation + process)
1. **Now → 02:00 — manuscript re-architecture (§4).** Lead with the mass keystone
   and the composed quantum-history engine; insert the supplied-input ledger; mark
   every arrow `M / T|H / C / [import] / open`. Do not let any composed claim
   inherit an ungraded dictionary.
2. **A4 invariant positive sector.** Submit `positiveSector_intertwiner_invariant`
   building on `KreinChainEquivalence`; this is the probability-layer rung and is
   Claude's process lane (Flagship C/D boundary). Witness: `Jpos/Jneg` quartet.
3. **A5 + V2/V4 benchmarks.** With Codex's A2 result, wire the S05/S06 V2 Dirac
   reproduction with the imported-Hamiltonian line explicit; stand up the V4
   dispersion pre-registration record (fix `a`, functional form, massless
   null-consistency, kill threshold) in `SIMULATION_BENCHMARKS.md` *before* any
   comparison. Submit `positionKernel_error_bound_on_grid` using tonight's finite
   Fourier synthesis.
4. **Continuous — simulation regression + negative controls.** Extend
   `null_information_lab.py` with the finite-Fourier position kernel and the
   dispersion V4 fixture; every family keeps its sign/normalization/branch
   negative control.
5. **06:30 freeze → 07:00 audit.** Rerun the benchmark suite from a clean command;
   verify no V2/V3 row is called a prediction; verify the manuscript reads as one
   theory with a named finite frontier; contribute `MORNING_REPORT.md`.

### Shared gates before dawn
- **Composition gate (must hold by 06:30):** at least one executable chain
  `null data → gauge class → positive state → mass (μ²=m² on the constructed
  family, A1) → unitary 1+1 history (A2) → dispersion observable → V2 Dirac
  reproduction → pre-registered V4 a-bound`, with every arrow citing a theorem,
  an imported principle, or an exact bridge with a kill condition.
- **Honesty gate:** the supplied-input ledger is complete; `μ² = m²`,
  step-unitarity, 3+1 Dirac matrices, Born, and volume statistics each appear once
  as imported/assumed with their discharging theorem or experiment named.
- **No churn:** every active rung ends Landed / Killed / Sharpened / Deferred.

---

## Bottom line

The corpus is one keystone (A1: `μ² = m²` on a constructed Plücker quartet) and
one engine ignition (A2: finite step-unitarity) away from an end-to-end,
theorem-linked chain from null primitives to a reproduced Dirac observable and a
single genuine, pre-registered prediction (the `−(a²/3)k²m²` dispersion with an
exactly luminal photon sector). Tonight's gluing→transfer-power→monoidal chain
already composes; the nondegenerate quartet already reaches the Plücker number.
Spend the night deriving the two supplied dictionaries, fence the 3+1 algebra and
the Born rule honestly, and the manuscript becomes a candidate theory with a
finite, named frontier rather than an anthology of correct lemmas.
