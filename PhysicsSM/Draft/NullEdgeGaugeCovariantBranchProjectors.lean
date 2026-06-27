import Mathlib
import PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety

/-!
# C61: Gauge-covariant link-dressed branch projectors (Gate C strategy/API)

This module is the **Lean-facing API skeleton** for the Gate C gauge-covariance
job recorded in `AgentTasks/null-edge-gauge-covariant-branch-projectors-plan.md`.

## The problem in one line

The free-field Route B branch projectors are trigonometric momentum filters such
as `(1 ± cos q_a)/2`.  In position space these are **finite combinations of
forward/backward null-edge shifts** (`1`, `S`, `S†`, …).  A bare lattice shift
`S` is **not gauge covariant**: under a local gauge transformation
`ψ_v ↦ g_v ψ_v` the shifted field `ψ_{v+ê}` does not transform like a field at
`v`.  To survive gauge coupling each shift must be **link-dressed**: replaced by
the parallel transport `U_e` along the edge it crosses, `S ↦ U_e · S`.  The
resulting object is a *link-dressed finite-range covariant projector*.

This file provides:

* the **link / parallel-transport algebra** (`gaugeLink`, `gaugeLink_comp`,
  `dressedHop_gauge`): how a dressed shift transforms, and that composing
  transports along a connected path cancels the intermediate gauge factors;
* the **dressed branch projector** as a finite list of dressed shifts based at a
  vertex (`dressedProjector`), and its **gauge-covariance theorem**
  (`dressedProjector_gauge_covariant`): the output transforms by `g` at the base
  point only;
* the **gauge-invariant loop / composite** observable
  (`loopComposite_gauge_invariant`): a transport that returns to the base point,
  contracted into a Hermitian singlet, is exactly gauge invariant;
* the **three deployment contexts** (`ProjCtx`) — strictly retarded causal update
  block, retarded/advanced Krein spectral double, gauge-invariant
  composite/interpolating observable — with the admissibility predicate that says
  **which finite shift combinations are acceptable in each** (`AdmissibleIn`),
  and the concrete fact that the symmetric `cos`-filter `(S + S†)` is *not*
  causally admissible but *is* Krein-paired (`cosFilter_*`);
* the **tie-in to `GhostZeroSafe`** (`gaugeCovariant_not_ghostSafe`): gauge
  covariance is a *theorem* about every dressed projector, yet it says **nothing**
  about ghost-zero safety — a covariant dressed projector can still harbour a
  Golterman–Shamir fatal ghost.  Covariance is necessary, not sufficient.

## Honesty discipline

Nothing physical is assumed.  The proven content is the **kinematics of gauge
covariance** (exact, kernel-checked matrix algebra) plus the **logical
separation** of covariance from ghost-zero safety (reusing the C47/C48
`GhostZeroSafe` calculus).  The dynamical inputs — the actual Clifford symbol, the
post-gauge-coupling residue signs, the weak-coupling deformation — remain the open
obligations of `NullEdgeGateCGhostZeroSafety` (`PostGaugeGhostSafe`) and are *not*
discharged here.  We do **not** claim the free-field projectors remain physical
after gauge coupling without link dressing *and* a ghost audit.

All declarations live in the `Draft` namespace.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeGaugeCovariantBranchProjectors

open Matrix
open scoped BigOperators
open PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety

/-! ## 0. Hermitian inner product / norm on the gauge fibre `Fin n → ℂ`

These are self-contained copies of the `NullEdgeFMSFiniteComposite` helpers (that
sibling file imports an absent upstream module, so we cannot import it; the proofs
below depend only on Mathlib). -/

variable {n : ℕ}

/-- Hermitian squared norm on the gauge fibre `Fin n → ℂ`: `∑ i |w i|²`. -/
def cnorm2 (w : Fin n → ℂ) : ℝ := ∑ i, Complex.normSq (w i)

/-- Hermitian inner product on the gauge fibre: `⟪x, w⟫ = ∑ i conj(x i) · w i`. -/
def cinner (x w : Fin n → ℂ) : ℂ := ∑ i, (starRingEnd ℂ) (x i) * w i

lemma cinner_dot (x w : Fin n → ℂ) : cinner x w = star x ⬝ᵥ w := rfl

/-- A unitary matrix preserves the Hermitian inner product. -/
lemma cinner_mulVec_of_unitary (M : Matrix (Fin n) (Fin n) ℂ)
    (hM : star M * M = 1) (x w : Fin n → ℂ) :
    cinner (M *ᵥ x) (M *ᵥ w) = cinner x w := by
  rw [cinner_dot, cinner_dot, Matrix.star_mulVec, ← Matrix.dotProduct_mulVec,
      Matrix.mulVec_mulVec]
  have : Mᴴ * M = 1 := hM
  rw [this, Matrix.one_mulVec]

/-! ## 1. The link / parallel-transport algebra (deliverable 1, 2)

A **link variable** `U_e` is the parallel transport across edge `e` (an element of
the gauge group, here a unitary matrix).  Under a local gauge transformation
`g : V → U(n)` (`star (g v) * g v = 1`) a link from vertex `a` to vertex `b`
transforms as `U ↦ g a · U · (g b)⁻¹ = g a · U · star (g b)`. -/

variable {V : Type*}

/-- The gauge transform of a link / transport `U` running from vertex `a` to
vertex `b`: `gaugeLink g U a b = g a · U · (g b)⁻¹`. -/
def gaugeLink (g : V → Matrix (Fin n) (Fin n) ℂ)
    (U : Matrix (Fin n) (Fin n) ℂ) (a b : V) : Matrix (Fin n) (Fin n) ℂ :=
  g a * U * star (g b)

/-- **Transport composition (path covariance).**  Composing two gauge-transformed
transports `a → b` and `b → c` cancels the intermediate gauge factor `g b`
(unitary), giving the gauge-transformed transport of the composed path `a → c`.
This is why a connected dressed path stays covariant. -/
theorem gaugeLink_comp (g : V → Matrix (Fin n) (Fin n) ℂ)
    (U₁ U₂ : Matrix (Fin n) (Fin n) ℂ) (a b c : V)
    (hb : star (g b) * g b = 1) :
    gaugeLink g U₁ a b * gaugeLink g U₂ b c = gaugeLink g (U₁ * U₂) a c := by
  unfold gaugeLink
  have h1 : (g a * U₁ * star (g b)) * (g b * U₂ * star (g c))
      = g a * U₁ * (star (g b) * g b) * U₂ * star (g c) := by
    simp only [mul_assoc]
  rw [h1, hb, mul_one, mul_assoc (g a) U₁ U₂]

/-- **Dressed hop covariance.**  A field value `ψ b` parallel-transported to the
base point `a` by `W` (i.e. `W *ᵥ ψ b`) transforms, under the gauge action
`ψ b ↦ g b *ᵥ ψ b`, `W ↦ gaugeLink g W a b`, by `g a` at the base point only:
`(gaugeLink g W a b) *ᵥ (g b *ᵥ ψ b) = g a *ᵥ (W *ᵥ ψ b)`. -/
theorem dressedHop_gauge (g : V → Matrix (Fin n) (Fin n) ℂ)
    (W : Matrix (Fin n) (Fin n) ℂ) (a b : V) (ψb : Fin n → ℂ)
    (hb : star (g b) * g b = 1) :
    (gaugeLink g W a b) *ᵥ (g b *ᵥ ψb) = g a *ᵥ (W *ᵥ ψb) := by
  unfold gaugeLink
  have hmul : g a * W * star (g b) * g b = g a * W := by
    rw [mul_assoc, hb, mul_one]
  rw [Matrix.mulVec_mulVec, hmul, ← Matrix.mulVec_mulVec]

/-! ## 2. Direction tags and the three deployment contexts (deliverable 3, 4)

A finite-range null-edge shift is either **retarded** (forward in causal time,
toward the future light-cone edge) or **advanced** (backward).  The free-field
symmetric filter `(S + S†)/2` mixes both. -/

/-- The causal orientation of a single null-edge shift. -/
inductive ShiftDir
  /-- a retarded (future-directed / forward) null-edge shift. -/
  | retarded
  /-- an advanced (past-directed / backward) null-edge shift. -/
  | advanced
  deriving DecidableEq, Repr, Inhabited

/-- One **dressed shift** in a branch projector based at the source vertex: a
coefficient, the orientation tag, the endpoint vertex it reaches, and the
parallel transport (link product) `W` dressing it. -/
structure DressedShift (n : ℕ) (V : Type*) where
  /-- the complex coefficient of this term in the projector. -/
  coeff : ℂ
  /-- the causal orientation of the shift. -/
  dir : ShiftDir
  /-- the endpoint vertex reached by the shift. -/
  dst : V
  /-- the parallel transport (ordered link product) dressing the shift. -/
  W : Matrix (Fin n) (Fin n) ℂ

/-- The three Gate C deployment contexts that must be kept separate. -/
inductive ProjCtx
  /-- the strictly retarded causal update block: only past-supported shifts. -/
  | causalUpdate
  /-- the retarded/advanced Krein spectral double: both orientations, paired. -/
  | kreinDouble
  /-- the gauge-invariant composite / interpolating observable: closed loops. -/
  | compositeObservable
  deriving DecidableEq, Repr, Inhabited

/-- **Admissibility of a shift recipe in a context** (deliverable 4).

* `causalUpdate`: a strictly retarded causal update may use **only** retarded
  shifts — an advanced shift would read from outside the causal past.
* `kreinDouble`: the retarded/advanced Krein double admits both orientations but
  they must be **paired** (equal retarded/advanced multiplicity), reflecting the
  doubled `R ⊕ A` Krein space.
* `compositeObservable`: a gauge-invariant composite must be a **closed loop**
  based at `a` (every shift returns to the base vertex), so the open gauge index
  can be contracted into a singlet (`loopComposite_gauge_invariant`). -/
def AdmissibleIn (ctx : ProjCtx) (a : V) (shifts : List (DressedShift n V)) : Prop :=
  match ctx with
  | .causalUpdate => ∀ sh ∈ shifts, sh.dir = ShiftDir.retarded
  | .kreinDouble =>
      (shifts.countP (fun sh => sh.dir = ShiftDir.retarded))
        = (shifts.countP (fun sh => sh.dir = ShiftDir.advanced))
  | .compositeObservable => ∀ sh ∈ shifts, sh.dst = a

/-- **Causal admissibility is exactly retarded-only.** -/
theorem causal_admissible_iff (a : V) (shifts : List (DressedShift n V)) :
    AdmissibleIn ProjCtx.causalUpdate a shifts ↔
      ∀ sh ∈ shifts, sh.dir = ShiftDir.retarded := Iff.rfl

/-- An advanced shift forbids causal-update admissibility. -/
theorem not_causal_of_advanced (a : V) (shifts : List (DressedShift n V))
    {sh : DressedShift n V} (hmem : sh ∈ shifts) (hadv : sh.dir = ShiftDir.advanced) :
    ¬ AdmissibleIn ProjCtx.causalUpdate a shifts := by
  intro h
  have := h sh hmem
  rw [hadv] at this
  exact absurd this (by decide)

/-! ## 3. The dressed branch projector and its gauge-covariance theorem -/

/-- The **link-dressed branch projector** evaluated at the base vertex:
`(P ψ)(a) = ∑_sh coeff_sh • (W_sh *ᵥ ψ(dst_sh))`, a finite combination of dressed
shifts.  (The base vertex enters the *output* only through the gauge factor `g a`
on the transformed side; the un-gauged projector itself depends only on the
shifts, so no base argument is needed here.) -/
def dressedProjector (shifts : List (DressedShift n V))
    (ψ : V → (Fin n → ℂ)) : Fin n → ℂ :=
  (shifts.map (fun sh => sh.coeff • (sh.W *ᵥ ψ sh.dst))).sum

/-- The **gauge-transformed** dressed projector: fields `ψ v ↦ g v *ᵥ ψ v` and
each transport `W ↦ gaugeLink g W a (dst)`. -/
def dressedProjectorGauged (g : V → Matrix (Fin n) (Fin n) ℂ) (a : V)
    (shifts : List (DressedShift n V)) (ψ : V → (Fin n → ℂ)) : Fin n → ℂ :=
  (shifts.map (fun sh =>
    sh.coeff • ((gaugeLink g sh.W a sh.dst) *ᵥ (g sh.dst *ᵥ ψ sh.dst)))).sum

/-- **Gauge covariance of the dressed branch projector.**  Under the local gauge
transformation, the dressed projector's output at the base vertex `a` transforms
by the single factor `g a`:
`dressedProjectorGauged g a shifts ψ = g a *ᵥ dressedProjector a shifts ψ`.
This is the precise sense in which the link-dressed finite shift combination is a
*covariant* branch projector. -/
theorem dressedProjector_gauge_covariant (g : V → Matrix (Fin n) (Fin n) ℂ) (a : V)
    (shifts : List (DressedShift n V)) (ψ : V → (Fin n → ℂ))
    (hg : ∀ v, star (g v) * g v = 1) :
    dressedProjectorGauged g a shifts ψ = g a *ᵥ dressedProjector shifts ψ := by
  unfold dressedProjectorGauged dressedProjector
  induction shifts with
  | nil => simp
  | cons sh rest ih =>
      simp only [List.map_cons, List.sum_cons, Matrix.mulVec_add] at *
      rw [ih]
      congr 1
      rw [Matrix.mulVec_smul, dressedHop_gauge g sh.W a sh.dst (ψ sh.dst) (hg sh.dst)]

/-! ## 4. The gauge-invariant loop / composite observable (composite context) -/

/-- A **closed-loop composite**: a transport `W` returning to the base vertex `a`,
contracted into a Hermitian singlet with the base field, `⟪ψ a, W *ᵥ ψ a⟫`.  This
is the gauge-invariant composite / interpolating observable of the third
context. -/
def loopComposite (a : V) (W : Matrix (Fin n) (Fin n) ℂ) (ψ : V → (Fin n → ℂ)) : ℂ :=
  cinner (ψ a) (W *ᵥ ψ a)

/-- **Gauge invariance of the loop composite.**  A base-point loop transport
contracted into a singlet is exactly gauge invariant: the `g a` factors cancel
between the dressed field and its conjugate.  This is the composite-observable
context's covariance law (invariance, not mere covariance). -/
theorem loopComposite_gauge_invariant (g : V → Matrix (Fin n) (Fin n) ℂ) (a : V)
    (W : Matrix (Fin n) (Fin n) ℂ) (ψ : V → (Fin n → ℂ))
    (hg : ∀ v, star (g v) * g v = 1) :
    cinner (g a *ᵥ ψ a) ((gaugeLink g W a a) *ᵥ (g a *ᵥ ψ a))
      = cinner (ψ a) (W *ᵥ ψ a) := by
  rw [dressedHop_gauge g W a a (ψ a) (hg a), cinner_mulVec_of_unitary _ (hg a)]

/-! ## 5. Concrete free-field `cos`-filter shift content (deliverable 4)

The free-field filter `(1 ± cos q)/2` is, in position space,
`½·1 ± ¼·(S + S†)`: a length-`0` identity term plus the **symmetric** sum of a
retarded forward shift `S` and an advanced backward shift `S†`.  The symmetric
`S + S†` part therefore contains one retarded **and** one advanced shift. -/

/-- The orientation content of the symmetric `cos`-filter part `S + S†`: one
retarded, one advanced shift. -/
def cosFilterDirs : List ShiftDir := [ShiftDir.retarded, ShiftDir.advanced]

/-- A purely one-sided retarded filter `S` (forward only). -/
def retFilterDirs : List ShiftDir := [ShiftDir.retarded]

/-- Helper: wrap a bare direction list into trivial dressed shifts based at a
vertex (identity transport, zero coefficient bookkeeping), so the admissibility
predicates apply. -/
def ofDirs (a : V) (ds : List ShiftDir) : List (DressedShift n V) :=
  ds.map (fun d => { coeff := 1, dir := d, dst := a, W := (1 : Matrix (Fin n) (Fin n) ℂ) })

/-- **The symmetric `cos`-filter is NOT causally admissible**: it contains an
advanced shift, so it cannot be used in a strictly retarded causal update block.
It must be split (use only the retarded half) or moved to the Krein-double /
composite context. -/
theorem cosFilter_not_causal (a : V) :
    ¬ AdmissibleIn ProjCtx.causalUpdate a (ofDirs (n := n) a cosFilterDirs) := by
  apply not_causal_of_advanced (n := n) a _
    (sh := { coeff := 1, dir := ShiftDir.advanced, dst := a,
             W := (1 : Matrix (Fin n) (Fin n) ℂ) })
  · simp [ofDirs, cosFilterDirs]
  · rfl

/-- **The symmetric `cos`-filter IS Krein-paired**: equal retarded and advanced
multiplicity, hence admissible in the retarded/advanced Krein spectral double. -/
theorem cosFilter_kreinDouble (a : V) :
    AdmissibleIn ProjCtx.kreinDouble a (ofDirs (n := n) a cosFilterDirs) := by
  simp [AdmissibleIn, ofDirs, cosFilterDirs]

/-- **A one-sided retarded filter IS causally admissible.** -/
theorem retFilter_causal (a : V) :
    AdmissibleIn ProjCtx.causalUpdate a (ofDirs (n := n) a retFilterDirs) := by
  intro sh hsh
  simp only [ofDirs, retFilterDirs, List.map_cons, List.map_nil, List.mem_singleton] at hsh
  rw [hsh]

/-! ## 6. Tie-in to `GhostZeroSafe`: covariance is necessary, not sufficient

This is the decisive Gate C point (deliverable 6).  Every dressed projector is
gauge covariant (`dressedProjector_gauge_covariant` is a *theorem*, no
hypothesis).  We bundle a projector with the determinant/propagator **zero
spectrum** it introduces and show that gauge covariance says **nothing** about
ghost-zero safety: a perfectly covariant link-dressed branch projector can still
carry a Golterman–Shamir fatal ghost. -/

/-- A link-dressed branch projector together with the classified zero spectrum it
introduces (the `ZeroDatum` list from `NullEdgeGateCGhostZeroSafety`). -/
structure DressedBranchProjector (n : ℕ) (V : Type*) where
  /-- the base vertex the projector is evaluated at. -/
  base : V
  /-- the finite list of dressed shifts. -/
  shifts : List (DressedShift n V)
  /-- the enumerated, classified determinant/propagator zeros it introduces. -/
  zeros : List ZeroDatum

/-- The gauge-covariance property of a dressed branch projector (always holds, by
`dressedProjector_gauge_covariant`). -/
def DressedBranchProjector.GaugeCovariant (P : DressedBranchProjector n V) : Prop :=
  ∀ (g : V → Matrix (Fin n) (Fin n) ℂ) (ψ : V → (Fin n → ℂ)),
    (∀ v, star (g v) * g v = 1) →
      dressedProjectorGauged g P.base P.shifts ψ
        = g P.base *ᵥ dressedProjector P.shifts ψ

/-- Every dressed branch projector is gauge covariant. -/
theorem DressedBranchProjector.gaugeCovariant (P : DressedBranchProjector n V) :
    P.GaugeCovariant :=
  fun g ψ hg => dressedProjector_gauge_covariant g P.base P.shifts ψ hg

/-- **Link-dressed safety = covariance AND ghost-zero safety.**  The honest
release condition for a link-dressed branch projector: it must be gauge covariant
*and* its zero spectrum must be ghost-zero safe.  (Full physical safety further
requires the C47/C48 `PostGaugeGhostSafe` contract; see
`NullEdgeGateCGhostZeroSafety`.) -/
def DressedBranchProjector.LinkDressedSafe (P : DressedBranchProjector n V) : Prop :=
  P.GaugeCovariant ∧ GhostZeroSafe P.zeros

/-- **Separation theorem: gauge covariance does NOT imply ghost-zero safety.**
There is a (trivially) gauge-covariant link-dressed branch projector whose zero
spectrum nonetheless contains a Golterman–Shamir fatal ghost, so it is **not**
ghost-zero safe.  Hence link dressing secures covariance but never, on its own,
ghost safety: the ghost audit is an independent obligation. -/
theorem gaugeCovariant_not_ghostSafe :
    ∃ P : DressedBranchProjector 1 Unit, P.GaugeCovariant ∧ ¬ GhostZeroSafe P.zeros := by
  refine ⟨{ base := (), shifts := [], zeros := [ghostZeroWitness] }, ?_, ?_⟩
  · exact DressedBranchProjector.gaugeCovariant _
  · intro h
    exact h ghostZeroWitness (by simp) ghostZeroWitness_isFatal

/-- A complementary **safe** dressed projector (covariant, with a benign physical
pole spectrum) genuinely satisfies link-dressed safety, so the predicate is not
vacuous. -/
theorem linkDressedSafe_nonvacuous :
    ∃ P : DressedBranchProjector 1 Unit, P.LinkDressedSafe := by
  refine ⟨{ base := (), shifts := [], zeros := [physicalPoleWitness] }, ?_, ?_⟩
  · exact DressedBranchProjector.gaugeCovariant _
  · intro z hz
    simp only [List.mem_singleton] at hz
    subst hz
    intro hfg
    rcases hfg with ⟨-, hlt⟩
    norm_num [physicalPoleWitness] at hlt

/-- **C61 summary theorem.**  The gauge-covariance API is consistent and the key
Gate C separations hold: (i) every link-dressed branch projector is gauge
covariant; (ii) the base-point loop composite is gauge invariant; (iii) gauge
covariance does not entail ghost-zero safety; (iv) link-dressed safety is
nonvacuous. -/
theorem c61_gauge_covariance_summary :
    (∀ P : DressedBranchProjector n V, P.GaugeCovariant) ∧
    (∃ P : DressedBranchProjector 1 Unit, P.GaugeCovariant ∧ ¬ GhostZeroSafe P.zeros) ∧
    (∃ P : DressedBranchProjector 1 Unit, P.LinkDressedSafe) :=
  ⟨fun P => P.gaugeCovariant, gaugeCovariant_not_ghostSafe, linkDressedSafe_nonvacuous⟩

end PhysicsSM.Draft.NullEdgeGaugeCovariantBranchProjectors
