# HELP NEEDED — brief for Fable 5 (self-contained)

You are **Fable 5**, Anthropic's most capable model. You are being handed the
**hardest open problems** of a large, mature Lean 4 formalization program and asked
to push them as far as you can. This brief is fully self-contained: it assumes you
know nothing about the repository. Read it end to end, then attack whichever
challenges you can move — ideally producing **kernel-checkable Lean 4 proofs**, and
where a full proof is out of reach, a **rigorous, formalization-ready proof
strategy** or a **kernel-checked no-go / counterexample**.

Do not optimize for volume. One genuinely hard theorem, honestly proved and
correctly stated, is worth more than a hundred restatements. **Over-claiming is the
cardinal sin here** (see §2). If a target is false or underspecified, say so and
prove the obstruction.

---

## 1. The project in one screen

**PhysicsSM** is a Lean 4 (Mathlib, toolchain pinned at `leanprover/lean4:v4.28.0`)
formalization of mathematical structures behind the Standard Model: octonions and
division algebras, exceptional Lie theory (E8), Clifford/spinor algebra, lattice
gauge theory, and a research program called **null-edge theory** whose thesis is:

> **Mass is a relational obstruction to null (lightlike) transport**, appearing in
> three taxonomically-distinct modes, each formalized as a finite, kernel-checked
> theorem:
> - **T (Turn)** — matter/chirality mass (Higgs–Yukawa; the chirality-flipping vertex),
> - **C (Closure)** — gauge mass (Yang–Mills mass gap / confinement scale),
> - **A (Aperture)** — composite/kinematic mass (invariant mass of several null momenta).

A running program has, over the last ~day, built a broad corpus of ~40 finite
kernel-checked modules across all these lanes (see §4). The program has now hit its
**genuinely hard frontier**, which is what this brief is about (§5).

**The Lean kernel is the source of truth.** A result counts only when: (1) the Lean
statement faithfully represents the intended mathematics, (2) the proof is accepted
by the kernel, (3) it builds under the pinned toolchain, (4) provenance is recorded,
(5) convention choices are documented.

---

## 2. The bar: honest claim discipline (read this twice)

This program has a hard-won discipline. Every headline theorem is **axiom-guarded**:
a build-time `#guard_msgs (whitespace := lax) in #print axioms <thm>` block fails the
build if the theorem's transitive axiom footprint ever drifts from
`[propext, Classical.choice, Quot.sound]` (a leaked `sorry`, an introduced
`native_decide` = `Lean.ofReduceBool`/`Lean.trustCompiler`, or a new `axiom`).

**Forbidden in trusted code:** `axiom`, `opaque`, `unsafe`, `admit`, `sorry`,
`native_decide`. (`native_decide` is fine in draft/experimental code but expands the
trusted base, so it is never in a trusted result.) A documented `sorry` in a clearly
draft/handoff context is acceptable *only* as an honest failure marker.

During this very run, **four over-claims were caught and corrected** — this is the
standard you must meet:
- A `clustering` field written `∀ m, ∃ C, …` was **vacuous** (the constant may depend
  on `m`, so it asserts no decay); the real lemma has `C` uniform in `m`. Fixed.
- A "finite Nielsen–Ninomiya no-go" module (`DoublingTurnPrice`) actually proved only
  local per-vertex spin algebra (`no_chiral_and_doubler_removal` reduced to
  `γ_μ ≠ 0`); it did **not** establish the topological no-go or necessity. Downgraded.
- A follow-up "fix" (`FiniteNielsenNinomiya`) telescoped a branch of a *nowhere-zero*
  symbol — trivially 0, chiral symmetry unused — so it too was **not** the no-go.
  Downgraded to "topological skeleton."
- A second "fix" (`signedCountOfD`) had the *same* hollowness (telescoping a
  single-valued branch, hypotheses unused) — **rejected outright** (not integrated),
  and the genuine target was re-derived from scratch (see the win below).

The genuine version (`FiniteNNZeroCount`) then **landed**: the signed count of *sign
crossings* of a real periodic dispersion is 0 (up-crossings balance down-crossings on
the boundaryless torus), tied *exactly* to the overlap-operator index. That is the
bar: separate "the topological skeleton" from "the genuine theorem," and prove the
genuine one — or prove precisely why it is hard/false.

**When you deliver: state, for every theorem, exactly what is PROVED vs what is
MODELED (an explicit hypothesis, not derived) vs what remains OPEN. Report the axiom
footprint. Never smuggle the hard part in as a hypothesis and call the theorem
"done."**

---

## 3. Environment and how work is checked

- **Lean 4**, `leanprover/lean4:v4.28.0`, Mathlib present. Build a module with
  `lake build PhysicsSM.Path.To.Module`; typecheck a standalone file with
  `lake env lean <file>`.
- Deliverables should be **self-contained Lean files importing only `Mathlib`** (plus,
  where essential, a small number of named upstream lemmas *reproduced as explicit
  hypotheses or restated definitions*, since the packaging you receive may not carry
  the full repo import graph). If a full `lake build` would stall on a large Mathlib
  compile, skip it and return the best `lake env lean`-typechecking file plus a report.
- No `sorry`/`axiom`/`native_decide` in final theorems (a documented `sorry` is a
  last-resort handoff marker with a proof plan). Kernel `decide` on genuinely small
  finite goals is fine (it is *not* `native_decide`).
- **Octonions are nonassociative.** Never rewrite under octonion products without
  explicit parenthesization; compose *linear maps / left-multiplication operators*,
  not raw octonion products. The project octonion convention is an XOR binary-label
  Fano orientation (bases `e000…e111`, product index = bitwise XOR, signs from a fixed
  Fano orientation); it is **not** Baez-2002 or Furey-2015 verbatim — do not import
  their product formulas without relabeling and sign correction.

---

## 4. What is already landed (so you don't redo it)

All of the following are kernel-checked, `sorry`-free, standard axioms, and
axiom-guarded (theorem names given so you can build on them; assume each is a finite,
honestly-scoped identity unless noted):

**A — aperture/kinematic (essentially complete):**
- `NBodyAperture.nbody_aperture_massless_iff_collinear` — for any `N` future-null
  momenta, `minkowskiSq (∑ pᵢ) = 0 ↔` a single null direction (the iff, both
  directions).
- `ApertureEntropy` / `ApertureObserverState` — the null-direction "spread" entropy;
  `H = 0 ↔` single direction; max-entropy = rest frame; massive ⟹ `0 < H < log N`.
- `BindingMassQuantitative.compositeMassSq_eq_sin_half` — `M² = 4E² sin²(θ/2)` exactly
  for two equal-energy null momenta.
- `MassFromMasslessNEU5.compositeMass_pos` — a composite of individually *massless*
  constituents has strictly positive mass (mass-from-relation).
- `PluckerSpinorBridge` — `det P = m²` tied to the Weyl-spinor wedge.

**T — turn/matter (genuine 1D no-go landed; higher-d open):**
- `FiniteNNZeroCount.signedZeroCount_eq_zero` — **the genuine 1D Nielsen–Ninomiya
  no-go**: `∑_p (sgn f(p+1) − sgn f p) = 0` for every real periodic dispersion
  `f : ZMod N → ℚ/ℝ` (signed zero-crossing count vanishes; up/down crossings balance).
  `single_crossing_impossible` (odd crossing count is impossible).
- `FiniteNNZeroCount2D` — the honest 2D version (Weyl nodes in ± pairs).
- `GinspargWilson` / `OverlapDirac` — the finite matrix-grade Ginsparg–Wilson relation
  `γ₅D + Dγ₅ = Dγ₅D` and the Neuberger overlap operator satisfying it; `γ̂₅ = γ₅(1−D)`
  is an involution (exact deformed chiral symmetry — the "price of the turn").
- `OverlapIndex` (index `= ½Tr(γ₅D)`, integer) and `NNIndexExact.signedZeroCount_eq_two_indexTr_diff`
  — **the crossing count equals the overlap index** (the two T-leg strands tied).
- `YukawaTurnAmplitude.turnAmplitude_eq_zero_iff` — n-flavor "no turn ⟺ no mass."

**C — closure/gauge (Z2 complete; nonabelian is the crown-jewel open problem, §5.1):**
- `WilsonSlabConnected.wilsonSlabConnected_reflectionPositive` — a connected
  cut-bearing Z2 Wilson slab is reflection-positive (arbitrary finite gauge group).
- `SlabGapAssembly.slabGapAssembly` — the assembled **Z2** chain as one theorem:
  RP-block PSD → Hermitian/self-adjoint OS transfer → strictly-positive spectral gap
  `= −log(tanh β)` → vacuum separation → **exponential clustering** `‖conn(m)‖ ≤ C·exp(−m·gap)`
  (uniform in `m`), reached via OS/GNS reconstruction — **KP-crux-free**.
- `OSHamiltonianGap`, `FiniteAbelianOSGap`, `TwoLevelOSGap` — the OS Hamiltonian gap
  `H = −log T`, generalized to any k-level Hermitian-PSD transfer block.
- `CharacterExpansion.charCoeff_abs_le_dim_mul_trivCoeff` — the correct **nonabelian**
  strong-coupling character dominance `‖c_R(β)‖ ≤ dim(R)·c_triv(β)` (SU(2)/SU(3)-applicable).
- `TYAreaLaw` (Z2 Tomboulis–Yaffe area law), `TYAreaLawSUN.TwistSystem` (an abstract
  SU(N) center-twist system with `tyBaseSUN ∈ [0,1)`, positive string tension, area
  law; `tyBaseSUN_two_landed` reconciles it with the Z2 base), `TYTwistSystemZ2`
  (a concrete `TwistSystem 2` with the twist-monotonicity `Z_le` *derived*),
  `Q8StringTension` (a first genuinely **nonabelian** (quaternion group Q8, dim-2
  irrep) concrete string tension `σ₂ ≥ 0`, area law), `SU2TwoLevelGap`,
  `StrongCouplingAreaLaw.wilson_area_law` (`‖⟨W_R⟩‖ ≤ exp(−σ_R·A)` from the dominance).
- `GapAsymptotics` — the Z2 gap `g(β) = −log(tanh β)`: `→ +∞` as `β→0⁺`
  (confinement), `→ 0` as `β→∞` (weak coupling).
- **Modeled, not derived** (the honest gap in lane C): the reflection-positivity
  "raw bound" `hW : |W| ≤ 2·q^r` is an *explicit hypothesis* in the TY theorems, and
  the SU(N) partition functions `Z, Z^{[k]}` are *modeled* (one-plaquette Boltzmann
  weights / abstract twist systems), **not** built from an actual SU(N) Haar measure.

**X — taxonomy / unification:**
- `MassTaxonomySeparation.massTaxonomy_functionals_pairwise_separated` (the 4 masses
  are pairwise distinct), `MassTaxonomyNonDegeneracy.massTaxonomy_nondegenerate`
  (each independently realizable), `MassCommonCarrier.no_common_carrier_via_turn`
  (the honest negative: no single non-artificial model carries all four).
- `GrandMassCapstoneUnconditional.grandMassCapstoneUnconditional` — the fully
  **unconditional** all-lane capstone conjoining one graded representative per lane
  (A/T/C/X/B/V). Scrupulously labeled: a *bundle of distinct finite obstructions*,
  **NOT** the SU(N) YM gap, NOT continuum, NOT a physical-mass derivation.

**B — division algebra → SM:**
- `su3Submonoid = SU(3)`, color triplet = fundamental, charge co-location verdict;
  anomaly cancellation (`grav/cubic/su2u1/su3u1_anomaly_cancels`, Witten even).
- `OctonionMassCoupling` / `OctonionMassCouplingFaithful` — a coupling *beyond* charge
  co-location: a split mass matrix does **not** commute with the su(3) *ladder*
  generators (`[T_root, M] = (mᵢ−mⱼ)·T_root`), proved *faithful* to the octonionic
  color action on the triplet.
- **Open, with documented `sorry`s:** the Spin(10) pure-spinor stabilizer program
  (`Spin10Stabilizer*`): the Transitivity claim was proved **false** (a verified
  negative); the Isomorphism claim is **false as stated** (complex GSpin(10,ℂ),
  real-dim 24, cannot be `MulEquiv` to the compact `S(U(2)×U(3))`, real-dim 12); the
  Selector claim is underspecified.

**V — trust:** the entire **E8-240 root system is de-nativized** (kernel-checked, no
`native_decide`): `E8Root240NoNative.E8RootSet_card = 240` (structural count
`112 = 4·C(8,2)` integer roots `±eᵢ±eⱼ` + `128 = 2⁷` half-integer even-parity roots)
and `E8Root240Complete.E8RootSet_eq_lattice_norm2` (`E8RootSet` is *exactly* the norm-2
E8-lattice vectors). Four kernel-checked **verified negatives** exist across the run.

---

## 5. The hard problems — throw yourself at these

Ranked by importance. For each: the precise target, what is proved/modeled/open, and
what a solution looks like. **Pick the ones you can move.**

### 5.1 THE CROWN JEWEL — a nonabelian lattice Yang–Mills mass gap at fixed spacing

This is the "single gate" of the whole program and is adjacent to the Clay problem
(at *fixed lattice spacing*, no continuum limit required).

**What exists:** the complete Z2 chain (`SlabGapAssembly`), the abstract SU(N)
twist-system scaffold (`TYAreaLawSUN`), a concrete Q8 string tension
(`Q8StringTension`), and the nonabelian character dominance
(`CharacterExpansion.charCoeff_abs_le_dim_mul_trivCoeff`).

**What is MODELED (the gap):** the reflection-positivity raw bound `hW : |W| ≤ 2·q^r`
is an explicit hypothesis; the SU(N) partition functions `Z^{[k]}` are modeled, not
built from an actual Haar measure over `SU(N)^{edges}`.

**Target (choose the most tractable rung you can genuinely close):**
1. Construct a **genuine finite SU(2) lattice gauge measure** — Haar measure on
   `SU(2)^{E}` for a small explicit finite lattice / connected Wilson slab, with the
   Wilson plaquette action — in Lean, and **prove reflection positivity** of the
   associated transfer operator (generalize `WilsonSlabConnected` from finite abstract
   `G` with modeled weights to genuine SU(2) Haar). Mathlib has Haar measure on compact
   groups; SU(2) ≅ unit quaternions / `Sp(1)`.
2. From that measure, **derive the Tomboulis–Yaffe raw bound** `hW` (the RP + iterated
   Cauchy–Schwarz reflection inequality) — the input currently assumed — so that
   `TYAreaLawSUN`'s area law becomes *unconditional* for genuine SU(2), and prove a
   **strictly positive string tension / mass gap at strong coupling** for the
   nonabelian group. The relevant physics: Kanazawa (arXiv:0808.3442) generalizes the
   Tomboulis–Yaffe inequality to SU(N); the bound's "constant" is the finite 't Hooft
   vortex free energy `Z^{[k]}/Z`, so nothing needs a memorized numeric constant.
3. Failing a full construction, **prove the abstract SU(N) twist-monotonicity `Z_le`
   (`Z^{[k]} ≤ Z^{[0]}`) from reflection positivity** (a Griffiths-type / RP
   inequality) rather than assuming it — this discharges one of the two modeled
   hypotheses for the general nonabelian case (currently derived only for Z2, in
   `TYTwistSystemZ2.Z2Twist_le`).

A kernel-checked, honestly-labeled **finite-spacing nonabelian positive mass gap**
(even SU(2), even small lattice) with the RP bound *derived from a real measure* would
be the headline result of the entire program.

### 5.2 THE PARKED ANALYTIC CRUX — the Kotecký–Preiss / Fernández–Procacci bound

An alternative route to §5.1 goes through a convergent **cluster/polymer expansion**,
which is gated by one hard inequality that has been attempted 4+ times and parked:

- File: `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` (3 remaining `sorry`s).
- Crux lemma name: **`pairSum_le_expBound`** — the labeled-tree exponential bound
  underlying Kotecký–Preiss / Fernández–Procacci cluster-expansion convergence:
  roughly, for an abstract polymer system with a pair-incompatibility structure and a
  Kotecký–Preiss weight condition, the sum over connected clusters (equivalently the
  sum over labeled trees on the polymer set, via the tree-graph inequality) is bounded
  by an exponential of the single-polymer weight. Supporting scaffold already built:
  `treeRootChildBlock`, `treeRootChildBlock_card_pos`, `exists_canonical_root`,
  `rhs_forest_expand`, `factorial_mul_prod_factorial_le`, and a subtree-reindexing
  layer.
- **Known trap:** a naive "root-overcounted reduction" is FALSE at order `x³` (recorded).
- **The false shape:** `kp_convergence_bound_false` is a *disproof* of the bare
  (mis-stated) bound; the correct statement threads a self-incompatibility hypothesis
  (`hself`) everywhere. Do **not** re-prove the false shape.

**Target:** prove `pairSum_le_expBound` (the Fernández–Procacci inductive route on
polymer count via the species/exponential-formula decomposition, or a direct injective
encoding of clusters into forests, is the recommended attack). This unlocks
`kp_convergence_bound_of_selfIncompatible` → `kp_tail_bound` → a convergent
strong-coupling expansion → exponential clustering → the gap. This is a genuinely hard
combinatorial-analytic inequality; a complete Lean proof, or a fully explicit
formalization-ready reduction to named Mathlib lemmas, is what we need.

Reference: Fernández & Procacci, "Cluster expansion for abstract polymer models. New
bounds from an old approach" (math-ph/0605041); Kotecký–Preiss (1986).

### 5.3 THE GENUINE HIGHER-DIMENSIONAL NIELSEN–NINOMIYA (topological)

We have the genuine **1D** no-go (`FiniteNNZeroCount`) and its exact tie to the overlap
index (`NNIndexExact`), plus an honest 2D *skeleton* (`FiniteNN2D`) and a genuine 2D
crossing/winding version (`FiniteNNZeroCount2D`). The honest **general d / 4D** result
is open.

**Target:** a kernel-checked finite theorem that for a chirally-symmetric lattice Dirac
symbol on the discrete Brillouin torus `(ZMod N)^d` (`{γ₅, D(k)} = 0`, isolated simple
zeros), the **signed sum of the chiralities (local degrees) of the zeros vanishes** —
a discrete Poincaré–Hopf / index-theorem statement (sum of local degrees over a closed
boundaryless manifold = 0). The chirality of a zero is the local degree of the map
`k ↦ D(k)` near it. The genuine content (as the 1D win shows) must count *actual zeros*
and use *chiral symmetry*, not telescope a nowhere-zero branch. Tie it, if possible, to
the overlap index à la `NNIndexExact` (index = signed zero count) in `d` dimensions.

### 5.4 OCTONION → STANDARD MODEL: a genuine dynamical step

Lane B currently has charge **co-location** plus a structural **coupling**
(`OctonionMassCoupling`). The deep open problem: derive a genuine piece of SM *dynamics*
(not just where charges sit) from the complex octonions `ℂ⊗𝕆`.

**Targets (any one is valuable):**
- The one-generation fermion mass/mixing structure as an intertwiner/eigenvalue problem
  for the associative left-action algebra generated by complex-octonion left
  multiplications (compose linear maps; do **not** use raw octonion products — the safe
  object is a *module / minimal left ideal for the left-action algebra*, never "the
  minimal left ideal of the complex octonions").
- Repair the Spin(10) stabilizer program: the Isomorphism target is false as stated
  (complex vs compact real form) — either prove the correct compact-form statement
  (impose a Hermitian structure, take the stabilizer inside compact Spin(10), build the
  explicit block iso to `S(U(2)×U(3))`), or prove the compact-vs-complex
  dimension/torsion obstruction as a clean kernel-checked negative. The Selector's
  backward direction (conjugate ⇒ stabilizer of a pair) needs two equivariance lemmas.

### 5.5 SHARPER, SELF-CONTAINED CHALLENGES (good warm-ups; still real)

- **Discharge `hW` on the Z2 slab by iterated reflection.** Currently `TYAreaLaw`'s
  `|W| ≤ 2·q^r` is a hypothesis even for Z2. Derive it from the *landed* connected-slab
  reflection positivity (`WilsonSlabConnected.wilsonSlabConnected_reflectionPositive`)
  by the explicit iterated reflection / Cauchy–Schwarz doubling on the Z2 slab. This
  removes the last modeled input for Z2 and builds the reusable machinery for §5.1.
- **Uniqueness/nondegeneracy of the OS spectral gap** beyond the two-state sector:
  extend `OSHamiltonianGap`/`FiniteAbelianOSGap` to prove the *vacuum is the unique
  ground state and the gap is the true spectral gap* of the full (not 2×2-reduced)
  connected-slab OS transfer operator.
- **E8 → SM branching beyond dimension-counting.** `E8DimensionBudget` has the integer
  dimension identities (e.g. `248 = 78 + 8 + 81 + 81` for E6×SU(3)). Formalize an
  actual **branching rule** (a rep-theoretic decomposition, e.g. `E8 ↓ E6×SU(3)`) at
  the level of weights/root-system combinatorics, kernel-checked.

---

## 6. What to deliver

For each challenge you engage:
1. A **self-contained Lean 4 file** (`import Mathlib` + minimal restated context) that
   `lake env lean`-typechecks with **no `sorry`/`axiom`/`native_decide`** in the final
   theorems (a documented `sorry` only as an explicit, planned handoff), OR
2. a **rigorous, formalization-ready proof strategy**: the exact statement to prove,
   the decomposition into named lemmas, the specific Mathlib API to use, and the one or
   two genuinely hard steps isolated, OR
3. a **kernel-checked no-go / counterexample** if the stated target is false or
   underspecified (these are first-class results here).

Always report: what is **proved** vs **modeled (hypotheses)** vs **open**; the exact
theorem names; and the **axiom footprint** (aim for `[propext, Classical.choice,
Quot.sound]` or fewer). Match the honest-labels discipline of §2 — do not let a
docstring claim more than the kernel checks.

**Highest expected value:** §5.1 rung 2 or 3 (derive the RP bound / twist-monotonicity
for genuine SU(2)/SU(N)), or §5.2 (`pairSum_le_expBound`). Either would move the single
gate the whole program hinges on. Go as far as you can.
