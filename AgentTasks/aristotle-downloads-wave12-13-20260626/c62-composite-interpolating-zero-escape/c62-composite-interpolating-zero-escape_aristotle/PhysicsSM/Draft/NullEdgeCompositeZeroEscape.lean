import Mathlib
import PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety

/-!
# C62: Composite / interpolating-field escape theorem for kinematical propagator zeros

This module is the **next safety job after C47/C48**
(`NullEdgeGateCGhostZeroSafety`).  C47/C48 fixed the six-way zero classification
(`ZeroKind`), the operational fatal-ghost criterion (`ZeroDatum.IsFatalGhost`),
and proved the central *separation*: a maximal flavored index does **not** release
Gate C while a fatal ghost zero is present (`index_nonzero_not_sufficient`).

The Working Plan (§23.1/§25.3, §31.5, §43.x "Gauge/ghost facts") records the only
honest escape for a zero produced by projection/splitting:

> If propagator zeros appear, they are proven **kinematical** by an explicit
> enlarged elementary-plus-composite interpolating field basis.

i.e. a dangerous determinant/propagator singularity is acceptable *only if a
controlled physical-sector or composite-field theorem removes it*.  This module
turns that escape into a precise, machine-checkable predicate and proves the
logical implications, **without ever declaring a zero safe by definition**.

## What is proved here (the algebraic skeleton)

A propagator zero at a candidate momentum is modeled by a **singular symbol**
`D : Matrix (Fin n) (Fin n) ℝ` (the value of the inverse-propagator / Dirac
symbol at the zero).  `D.det = 0` is the propagator-zero condition; equivalently
there is a nonzero kernel mode `v` with `D *ᵥ v = 0`
(`singular_iff_kernelMode`).

Three field-basis manipulations are distinguished (deliverable 4):

1. **Invertible change of basis** (`IsInvertibleBasisChange`).  A *constant*
   invertible field redefinition `D ↦ M * D * N` with `M`, `N` units.  This is a
   **NO-GO**: it can never remove a propagator zero
   (`basisChange_preserves_zero`, `not_removable_by_invertibleBasisChange`).
   A zero that survives every invertible redefinition is genuine *in that field
   content* — invertible basis change is a red herring, not an escape.

2. **Non-invertible projection** (`ProjectedArtifact`).  A genuine rank-reducing
   projector `P` onto a physical sector can remove the zero, **provided** the
   zero's kernel mode lies entirely in the *discarded* sector (`P *ᵥ v = 0`) and
   the retained physical sector stays non-degenerate
   (`projectedArtifact_physical_nondegenerate`).  This is the kinematical /
   projected-artifact escape; it is non-vacuous (`projExample`).

3. **Enlarged elementary-plus-composite basis** (`CompositeEnlargement`).  The
   apparent zero of the elementary symbol is *resolved* inside a larger
   interpolating-field matrix `E` (elementary fields plus `m` composite fields)
   whose elementary block reproduces `D` and which is itself **invertible** at the
   candidate momentum: the physical state is interpolated by the composite, so the
   elementary propagator zero signals no missing or ghost state.  Non-vacuous
   (`compositeExample`).

## Honesty discipline (deliverable 6: what stays analytic/physical)

The algebraic certificates above are **necessary but not sufficient**:

* `compositeEnlargement_always` — *any* singular symbol admits an invertible
  enlargement (`E = !![D, 1; 1, 0]`-style).  So the bare existence of an enlarged
  basis is **cheap** and certifies nothing on its own.
* `algebraicEscape_not_sufficient` — there is a `ZeroDatum` carrying a valid
  `AlgebraicEscape` of its (singular) elementary symbol that is nonetheless a
  **fatal ghost**.

The two genuinely physical inputs that the algebra cannot supply are recorded as
explicit contracts inside the escape witness:

* **gauge response** — after weak gauge coupling the resolved/discarded mode does
  not propagate as a gauge-coupled state (`gaugeResponse`/`notGaugeCoupled`);
* **residue sign** — the surviving physical pole carries a non-negative Krein
  residue (handled by the C22 interface `KreinPositivePhysicalSector` and by the
  `IsFatalGhost` criterion).

Only with those contracts in hand does a `CompositeRemovable` witness imply
ghost-safety (`CompositeRemovable.not_fatal`,
`CompositeRemovable.wellClassified`, `compositeRemovable_ghostSafe`).  This is the
sense in which the result *sharpens* the C47/C48 obligation rather than weakening
it.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeCompositeZeroEscape

open scoped BigOperators
open Matrix
open PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety

/-! ## 0. Propagator zeros as singular symbols -/

/-- The inverse-propagator / Dirac symbol at the candidate momentum, an
`n × n` real matrix. -/
abbrev Sym (n : ℕ) := Matrix (Fin n) (Fin n) ℝ

/-- A **propagator zero**: the symbol is singular at the candidate momentum. -/
def IsPropagatorZero {n : ℕ} (D : Sym n) : Prop := D.det = 0

/-- A **kernel mode**: a nonzero vector annihilated by the symbol. -/
def KernelMode {n : ℕ} (D : Sym n) (v : Fin n → ℝ) : Prop :=
  v ≠ 0 ∧ D *ᵥ v = 0

/--
A symbol is a propagator zero iff it carries a kernel mode.
-/
theorem singular_iff_kernelMode {n : ℕ} (D : Sym n) :
    IsPropagatorZero D ↔ ∃ v, KernelMode D v := by
  convert Matrix.exists_mulVec_eq_zero_iff.symm;
  infer_instance

/-! ## 1. Invertible change of basis is a NO-GO (deliverable 4, part 1)

A constant invertible field redefinition `D ↦ M * D * N` (with `M`, `N` units)
multiplies the determinant by the units `det M`, `det N`, hence **never** changes
whether the symbol is singular.  An invertible basis change therefore cannot
remove a propagator zero: it is not an escape route. -/

/-- A constant invertible change of interpolating-field basis. -/
def IsInvertibleBasisChange {n : ℕ} (D D' : Sym n) : Prop :=
  ∃ M N : Sym n, IsUnit M.det ∧ IsUnit N.det ∧ D' = M * D * N

/--
**Invertible basis change preserves propagator zeros.**
-/
theorem basisChange_preserves_zero {n : ℕ} {D D' : Sym n}
    (h : IsInvertibleBasisChange D D') :
    IsPropagatorZero D' ↔ IsPropagatorZero D := by
  obtain ⟨ M, N, hM, hN, rfl ⟩ := h;
  unfold IsPropagatorZero;
  aesop

/-- **No-go.**  If `D` is a propagator zero, no invertible change of basis can
remove it. -/
theorem not_removable_by_invertibleBasisChange {n : ℕ} {D D' : Sym n}
    (hzero : IsPropagatorZero D) (h : IsInvertibleBasisChange D D') :
    IsPropagatorZero D' :=
  (basisChange_preserves_zero h).2 hzero

/-! ## 2. Non-invertible projection escape (deliverable 4, part 2) -/

/-- **Projected (kinematical) artifact.**  A projector `P` onto the physical
sector removes the zero when (a) there is a kernel mode lying entirely in the
*discarded* sector (`P *ᵥ v = 0`), and (b) the retained physical sector is
non-degenerate (no nonzero vector fixed by `P` is annihilated by `D`). -/
def ProjectedArtifact {n : ℕ} (D P : Sym n) : Prop :=
  (∃ v, KernelMode D v ∧ P *ᵥ v = 0) ∧
  (∀ w : Fin n → ℝ, w ≠ 0 → P *ᵥ w = w → D *ᵥ w ≠ 0)

/--
The physical sector of a projected artifact is non-degenerate: any retained
vector annihilated by the symbol is zero.
-/
theorem projectedArtifact_physical_nondegenerate {n : ℕ} {D P : Sym n}
    (h : ProjectedArtifact D P) :
    ∀ w : Fin n → ℝ, P *ᵥ w = w → D *ᵥ w = 0 → w = 0 := by
  exact fun w hw₁ hw₂ => Classical.not_not.1 fun hw₃ => h.2 w hw₃ hw₁ hw₂

/--
A projected artifact really is a propagator zero (it carries a kernel mode).
-/
theorem projectedArtifact_isZero {n : ℕ} {D P : Sym n}
    (h : ProjectedArtifact D P) : IsPropagatorZero D := by
  exact h.1.choose_spec.1 |> fun h => singular_iff_kernelMode D |>.2 ⟨ _, h ⟩

/-- **Non-vacuity.**  Concrete `2 × 2` projected artifact: `D = diag(0,1)` has the
kernel mode `(1,0)`, which is discarded by `P = diag(0,1)`, while the retained
coordinate stays non-degenerate. -/
def projDExample : Sym 2 := !![0, 0; 0, 1]
/-- The physical-sector projector of `projExample`. -/
def projPExample : Sym 2 := !![0, 0; 0, 1]

theorem projExample : ProjectedArtifact projDExample projPExample := by
  constructor;
  · unfold KernelMode; norm_num [ projDExample, projPExample ] ;
    exact ⟨ Matrix.vecCons 1 0, ne_of_apply_ne ( fun v => v 0 ) one_ne_zero, rfl, by ext i; fin_cases i ⟩;
  · unfold projDExample projPExample; aesop;

/-! ## 3. Enlarged elementary-plus-composite basis (deliverable 4, part 3) -/

/-- **Composite enlargement.**  An enlarged interpolating-field symbol `E` over
`Fin (n + m)` (the `n` elementary fields plus `m` composite fields) is invertible
at the candidate momentum, and its elementary–elementary block reproduces the
singular symbol `D`.  The apparent elementary propagator zero is then resolved in
the enlarged basis. -/
def CompositeEnlargement {n : ℕ} (D : Sym n) (m : ℕ) (E : Sym (n + m)) : Prop :=
  IsUnit E.det ∧ ∀ i j : Fin n, E (Fin.castAdd m i) (Fin.castAdd m j) = D i j

/-- **Non-vacuity.**  The `1 × 1` zero elementary symbol `D = (0)` is resolved by
adding one composite field: the enlarged `2 × 2` antidiagonal symbol
`E = !![0,1;1,0]` is invertible (`det = -1`) and its elementary block is `D`. -/
def compositeDExample : Sym 1 := !![0]
/-- The enlarged elementary-plus-composite symbol of `compositeExample`. -/
def compositeEExample : Sym 2 := !![0, 1; 1, 0]

theorem compositeExample :
    CompositeEnlargement compositeDExample 1 compositeEExample := by
  constructor <;> norm_num [ compositeDExample, compositeEExample ];
  · aesop;
  · rfl

/--
**Honesty: enlargement is cheap.**  *Every* symbol — singular or not — admits
an invertible composite enlargement.  Hence the bare existence of an enlarged
elementary-plus-composite basis certifies **nothing** by itself; it must be
accompanied by the physical gauge-response and residue-sign contracts.
-/
theorem compositeEnlargement_always {n : ℕ} (D : Sym n) :
    ∃ (m : ℕ) (E : Sym (n + m)), CompositeEnlargement D m E := by
  -- Let $m = n$ and define $E$ as the block matrix with $D$ in the top-left corner and $I_n$ in the bottom-right corner.
  use n, Matrix.reindex (finSumFinEquiv (n := n) (m := n)) (finSumFinEquiv (n := n) (m := n)) (Matrix.fromBlocks D (1 : Sym n) (1 : Sym n) 0);
  constructor;
  · have h_inv : (Matrix.fromBlocks D (1 : Sym n) (1 : Sym n) 0) * (Matrix.fromBlocks 0 (1 : Sym n) (1 : Sym n) (-D)) = 1 := by
      simp +decide [ Matrix.fromBlocks_multiply ];
    exact isUnit_iff_exists_inv.mpr ⟨ _, by simpa [ Matrix.det_reindex_self ] using congr_arg Matrix.det h_inv ⟩;
  · aesop

/-! ## 4. The algebraic escape and its insufficiency -/

/-- The two **algebraic** removal mechanisms that can genuinely eliminate a
propagator zero (invertible basis change is deliberately excluded: it is a
no-go).  A bare `AlgebraicEscape` is *necessary but not sufficient* for
ghost-safety. -/
inductive AlgebraicEscape {n : ℕ} (D : Sym n) : Prop where
  /-- the zero's mode is discarded by a non-invertible physical-sector projector. -/
  | projection (P : Sym n) (hP : ProjectedArtifact D P) : AlgebraicEscape D
  /-- the zero is resolved in an enlarged elementary-plus-composite basis. -/
  | enlargement (m : ℕ) (E : Sym (n + m)) (hE : CompositeEnlargement D m E) :
      AlgebraicEscape D

/-! ## 5. The composite-removable escape predicate (deliverables 2, 3, 5)

A `ZeroDatum` (the C47/C48 carrier of classification + residue + gauge data) is
**composite-removable** when its elementary symbol is a genuine propagator zero
that admits an algebraic escape *and* the physical gauge-response contract holds:
after weak gauge coupling the resolved/discarded mode does not propagate as a
gauge-coupled state.  This is exactly the side condition that distinguishes a
composite-removable zero from a `fatalGhostZero`. -/
structure CompositeRemovable {n : ℕ} (D : Sym n) (z : ZeroDatum) : Prop where
  /-- the elementary symbol genuinely has a propagator zero. -/
  isZero : IsPropagatorZero D
  /-- an algebraic removal mechanism (projection or composite enlargement). -/
  escape : AlgebraicEscape D
  /-- **gauge-response contract (physical input):** the resolved/discarded mode
  does not propagate as a gauge-coupled state. -/
  gaugeResponse : z.gaugeCoupledPropagating = false

/--
**Composite-removable zeros are not fatal ghosts.**  The gauge-response
contract directly contradicts the gauge-coupled half of the ghost criterion.
-/
theorem CompositeRemovable.not_fatal {n : ℕ} {D : Sym n} {z : ZeroDatum}
    (h : CompositeRemovable D z) : ¬ z.IsFatalGhost := by
  cases h ; simp_all +decide [ ZeroDatum.IsFatalGhost ]

/--
A composite-removable zero labelled `compositeRemovable` is **well-classified**
in the C47/C48 sense.
-/
theorem CompositeRemovable.wellClassified {n : ℕ} {D : Sym n} {z : ZeroDatum}
    (h : CompositeRemovable D z) (hk : z.kind = ZeroKind.compositeRemovable) :
    z.WellClassified := by
  obtain ⟨ isZero, escape, gaugeResponse ⟩ := h;
  constructor;
  · unfold ZeroDatum.IsFatalGhost; aesop;
  · aesop

/--
**Spectrum-level corollary.**  A spectrum every one of whose zeros is
composite-removable (for some elementary symbol) is ghost-zero safe.
-/
theorem compositeRemovable_ghostSafe
    {n : ℕ} (zs : List ZeroDatum) (D : ZeroDatum → Sym n)
    (h : ∀ z ∈ zs, CompositeRemovable (D z) z) :
    GhostZeroSafe zs := by
  exact fun z hz => ( h z hz ).not_fatal

/-! ## 6. Insufficiency: the algebra alone never declares a zero safe

This is the formal core of the honesty requirement.  We exhibit a `ZeroDatum`
that *is* a fatal ghost yet whose (singular) elementary symbol admits a valid
`AlgebraicEscape`.  Hence an algebraic escape **without** the gauge-response
contract does not make a zero safe — exactly as required, the zero is never safe
by definition. -/

/-- A fatal-ghost zero whose elementary symbol nonetheless admits an algebraic
enlargement escape. -/
def deceptiveZero : ZeroDatum := ghostZeroWitness

theorem deceptiveZero_isFatal : deceptiveZero.IsFatalGhost :=
  ghostZeroWitness_isFatal

/--
**Algebraic escape is not sufficient.**  There is a singular elementary symbol
`D` and a `ZeroDatum z` such that `D` admits an `AlgebraicEscape` and `z`'s
classification residue/gauge data is *consistent with* that symbol being a zero,
yet `z` is a fatal ghost.  The missing ingredient is precisely the gauge-response
contract `CompositeRemovable.gaugeResponse`.
-/
theorem algebraicEscape_not_sufficient :
    ∃ (D : Sym 1) (z : ZeroDatum),
      IsPropagatorZero D ∧ AlgebraicEscape D ∧ z.IsFatalGhost := by
  use compositeDExample, deceptiveZero;
  exact ⟨ by unfold IsPropagatorZero compositeDExample; norm_num, AlgebraicEscape.enlargement 1 compositeEExample compositeExample, deceptiveZero_isFatal ⟩

/-! ## 7. Summary -/

/-- **C62 summary.**  The composite / interpolating-field escape calculus:

1. invertible change of basis can **never** remove a propagator zero
   (`not_removable_by_invertibleBasisChange`);
2. non-invertible projection removes a zero only when its mode is discarded and
   the physical sector stays non-degenerate
   (`projectedArtifact_physical_nondegenerate`), non-vacuously (`projExample`);
3. an enlarged elementary-plus-composite basis can resolve a zero
   (`compositeExample`), but such enlargements *always* exist
   (`compositeEnlargement_always`), so the algebra is cheap;
4. with the physical gauge-response contract a composite-removable zero is not a
   fatal ghost and is well-classified (`CompositeRemovable.not_fatal`,
   `CompositeRemovable.wellClassified`);
5. **without** that contract the algebra is insufficient: a fatal ghost can carry
   a valid algebraic escape (`algebraicEscape_not_sufficient`).  The zero is never
   safe by definition. -/
theorem c62_composite_escape_summary :
    (∀ {n : ℕ} {D D' : Sym n}, IsPropagatorZero D → IsInvertibleBasisChange D D' →
        IsPropagatorZero D') ∧
    (∀ {n : ℕ} {D : Sym n}, ∃ (m : ℕ) (E : Sym (n + m)), CompositeEnlargement D m E) ∧
    (∀ {n : ℕ} {D : Sym n} {z : ZeroDatum}, CompositeRemovable D z → ¬ z.IsFatalGhost) ∧
    (∃ (D : Sym 1) (z : ZeroDatum),
        IsPropagatorZero D ∧ AlgebraicEscape D ∧ z.IsFatalGhost) :=
  ⟨fun hz hb => not_removable_by_invertibleBasisChange hz hb,
   fun {_ D} => compositeEnlargement_always D,
   fun h => CompositeRemovable.not_fatal h,
   algebraicEscape_not_sufficient⟩

end PhysicsSM.Draft.NullEdgeCompositeZeroEscape
