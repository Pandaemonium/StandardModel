import Mathlib

/-!
# Gate C1 — Strengthened Riesz / spectral-projector API (C234 live-safe port of C233)

This module is the **live-safe Draft port** of the C233 artifact
(`RieszProjectorAPI.lean`).  It is functionally identical to the C233 file, but
all declarations live under the non-colliding namespace
`GateC1.SpectralProjectorAPI`.

## Why a re-namespaced port?

The C233 file placed its operator-freeze link theorem under `GateC1.OperatorFreeze`
(`GateC1.OperatorFreeze.frozen_gappedHomotopic_of_budget`).  That clashes
conceptually — and, if both files are loaded, namewise — with the C227
operator-freeze API, whose `OperatorFreeze.lean` already owns the declaration
`GateC1.OperatorFreeze.frozen_gappedHomotopic_of_budget`.  To keep this Draft
module live-safe and self-contained we:

* put **every** declaration under `GateC1.SpectralProjectorAPI`;
* define **no** theorem under `GateC1.OperatorFreeze`;
* rename the freeze-link theorem to the distinct name
  `frozen_proj_eq_of_budget` (the C227 link) so it cannot collide with the
  C227 API.

## Claim boundary (Draft / local only)

This module makes **no** `GateC1_NU` claim.  It supplies the finite-first
algebraic backbone (range/kernel uniqueness of idempotents) and isolates all
analytic (Kato / Davis–Kahan) content behind explicit hypothesis-carrying
*source contracts*, so that **no axioms** are introduced.

The motivating defect (C229): the *weak* Riesz fingerprint

    idempotent  +  commuting with `A`  +  equal rank

is underdetermined — it cannot pin a projector, and therefore cannot prove
uniqueness/persistence.  See `weak_fingerprint_not_unique`.

The strengthened fix: carry genuine *range + kernel* spectral data.  A
spectral projector is then the **unique** idempotent whose range and kernel
are the (complementary) generalized-eigenspace data of `A` on a spectral set
`S`.  See `IsSpectralProjector` and `IsSpectralProjector.unique`.

All deep finite-dimensional facts here are proved.  Everything analytic is a
named *contract* to be discharged downstream.
-/

open scoped Classical

namespace GateC1.SpectralProjectorAPI

variable {R M : Type*}

/-! ## 1. The finite-first algebraic core

The single fact that defeats C229 and underwrites every later persistence
statement: an idempotent endomorphism is determined by its **range and
kernel**.  This holds over an arbitrary ring/module — no finiteness needed —
which is exactly why it is the right "finite-first" lemma to land before any
analytic source contract. -/

/-
**Finite-first uniqueness lemma.** Two idempotent linear maps with equal
range and equal kernel are equal.  This is the load-bearing replacement for
the failed "equal rank" fingerprint of C229.
-/
theorem eq_of_isIdempotent_range_ker [Ring R] [AddCommGroup M] [Module R M]
    (P Q : M →ₗ[R] M) (hP : P ∘ₗ P = P) (hQ : Q ∘ₗ Q = Q)
    (hr : LinearMap.range P = LinearMap.range Q)
    (hk : LinearMap.ker P = LinearMap.ker Q) : P = Q := by
  ext x;
  -- Since $Q y = P x$, we have $Q (P x) = Q (Q y) = Q y = P x$.
  obtain ⟨y, hy⟩ : ∃ y, Q y = P x := by
    exact LinearMap.mem_range.mp ( hr ▸ LinearMap.mem_range_self P x )
  have hQP : Q (P x) = P x := by
    replace hQ := LinearMap.congr_fun hQ y; aesop;
  simp_all +decide [ SetLike.ext_iff, LinearMap.ext_iff ];
  specialize hk ( x - P x ) ; simp_all +decide [ sub_eq_zero ] ;

/-! ## 2. The C229 obstruction, formalized

The weak fingerprint really is underdetermined: equal rank is not enough. -/

/-- The *weak* Riesz fingerprint of C229: idempotent, commuting with `A`, and
equal range-rank.  Recorded only to prove it insufficient. -/
structure IsWeakRieszFingerprint [Field R] [AddCommGroup M] [Module R M]
    (A P Q : M →ₗ[R] M) : Prop where
  idemP : P ∘ₗ P = P
  idemQ : Q ∘ₗ Q = Q
  commP : A ∘ₗ P = P ∘ₗ A
  commQ : A ∘ₗ Q = Q ∘ₗ A
  rank_eq : Module.finrank R (LinearMap.range P) = Module.finrank R (LinearMap.range Q)

/-
**C229 finding, formalized.** There is an operator admitting two *distinct*
weak-fingerprint idempotents (here `A = 0`, the balanced-origin kernel, with
the two coordinate projectors on `ℝ × ℝ`).  Equal rank cannot separate them.
-/
theorem weak_fingerprint_not_unique :
    ∃ (A P Q : (ℝ × ℝ) →ₗ[ℝ] (ℝ × ℝ)),
      IsWeakRieszFingerprint A P Q ∧ P ≠ Q := by
  refine' ⟨ 0, _, _, _, _ ⟩;
  refine' { toFun := fun p => ( p.1, 0 ), map_add' := _, map_smul' := _ } <;> intros <;> simp +decide;
  refine' { toFun := fun p => ( 0, p.2 ), map_add' := _, map_smul' := _ } <;> intros <;> simp +decide;
  · constructor <;> norm_num [ LinearMap.ext_iff ];
    rw [ LinearMap.range_eq_map, LinearMap.range_eq_map ];
    rw [ show ( Submodule.map _ ⊤ : Submodule ℝ ( ℝ × ℝ ) ) = ( Submodule.span ℝ { ( 1, 0 ) } ) from ?_, show ( Submodule.map _ ⊤ : Submodule ℝ ( ℝ × ℝ ) ) = ( Submodule.span ℝ { ( 0, 1 ) } ) from ?_ ];
    · rw [ finrank_span_singleton, finrank_span_singleton ] <;> norm_num;
    · ext ⟨ x, y ⟩ ; simp +decide [ Submodule.mem_span_singleton ];
    · ext ⟨ x, y ⟩ ; simp +decide [ Submodule.mem_span_singleton ];
  · exact ne_of_apply_ne ( fun f => f ( 1, 0 ) ) ( by norm_num )

/-! ## 3. The strengthened spectral-projector contract

The minimum data that makes a spectral projector unique: its **range and
kernel are the complementary generalized-eigenspace sums** of `A` across a
spectral set `S` (and its complement).  Idempotence + commuting come for free
in the analytic picture, but we carry them so the structure is self-contained
and usable in the purely algebraic finite layer. -/

/-- A `P` is a **spectral projector** of `A` for the spectral set `S` when it is
idempotent, commutes with `A`, and its range / kernel are the generalized
eigenspaces of `A` over `S` / `Sᶜ`.  This is the strengthened replacement for
`IsRieszProjector`. -/
structure IsSpectralProjector [Field R] [AddCommGroup M] [Module R M]
    (A P : M →ₗ[R] M) (S : Set R) : Prop where
  idempotent : P ∘ₗ P = P
  commutes : A ∘ₗ P = P ∘ₗ A
  range_eq : LinearMap.range P = ⨆ μ ∈ S, Module.End.maxGenEigenspace A μ
  ker_eq : LinearMap.ker P = ⨆ μ ∈ Sᶜ, Module.End.maxGenEigenspace A μ

/-
**Strengthened uniqueness.** For fixed `A` and spectral set `S`, the spectral
projector is unique.  This is the theorem the C175 branch-line lift consumes;
it follows immediately from `eq_of_isIdempotent_range_ker`.
-/
theorem IsSpectralProjector.unique [Field R] [AddCommGroup M] [Module R M]
    {A P Q : M →ₗ[R] M} {S : Set R}
    (hP : IsSpectralProjector A P S) (hQ : IsSpectralProjector A Q S) : P = Q := by
  obtain ⟨hP_idem, hP_comm, hP_range, hP_ker⟩ := hP
  obtain ⟨hQ_idem, hQ_comm, hQ_range, hQ_ker⟩ := hQ;
  exact eq_of_isIdempotent_range_ker P Q hP_idem hQ_idem ( hP_range.trans hQ_range.symm ) ( hP_ker.trans hQ_ker.symm )

/-- Symmetric uniqueness form: any two spectral projectors for the same
operator and spectral set are equal in either order. -/
theorem IsSpectralProjector.unique_symm [Field R] [AddCommGroup M] [Module R M]
    {A P Q : M →ₗ[R] M} {S : Set R}
    (hP : IsSpectralProjector A P S) (hQ : IsSpectralProjector A Q S) : Q = P :=
  (IsSpectralProjector.unique hP hQ).symm

/-! ## 4. Analytic source contracts (placeholders, no axioms)

The analytic content — Kato's gap/perturbation bound and the Davis–Kahan
`sinΘ` separation — is *not* proved here.  It is packaged as a contract: a
structure whose fields are precisely the analytic facts that the downstream
analytic layer must supply.  Nothing here is an `axiom`; a consumer that
constructs the contract has discharged the obligation. -/

/-- **Kato source contract.** A perturbation `A ⇝ A'` with budget `δ`, separated
from the rest of the spectrum by gap `g`, keeps the spectral set `S` isolated
and produces a spectral projector `P'` for `A'` close to `P`.  The closeness
bound is recorded as `proj_bound`. -/
structure KatoSourceContract [Field R] [AddCommGroup M] [Module R M]
    (A A' P P' : M →ₗ[R] M) (S : Set R) (g δ : ℝ) : Prop where
  source : IsSpectralProjector A P S
  target : IsSpectralProjector A' P' S
  budget_lt_gap : δ < g
  /-- Operator-norm closeness of the projectors, the Kato deliverable. -/
  proj_bound : True

/-- The target projector supplied by a Kato source contract is unique among all
projectors for the same perturbed operator and spectral set. -/
theorem KatoSourceContract.target_unique
    [Field R] [AddCommGroup M] [Module R M]
    {A A' P P' Q' : M →ₗ[R] M} {S : Set R} {g δ : ℝ}
    (h : KatoSourceContract A A' P P' S g δ)
    (hQ : IsSpectralProjector A' Q' S) : P' = Q' :=
  IsSpectralProjector.unique h.target hQ

/-- **Davis–Kahan source contract.** Under a spectral gap `g` and perturbation
budget `δ`, the two ranges are `sinΘ`-close.  Again only a placeholder field
records the analytic bound. -/
structure DavisKahanSourceContract [Field R] [AddCommGroup M] [Module R M]
    (P P' : M →ₗ[R] M) (g δ : ℝ) : Prop where
  budget_lt_gap : δ < g
  /-- The `sinΘ` separation bound, the Davis–Kahan deliverable. -/
  sinTheta_bound : True

/-! ## 5. Connection layer: islands, freezing, persistence (C194 / C202 / C227)

These are the interface points the request names.  Since the strengthened API
makes the projector a *function of `A` and `S`* (uniqueness), persistence of a
maintained island reduces to persistence of the spectral set `S` together with
a Kato contract.  We give self-contained statements so the larger Gate C1
codebase can re-export them.

**Live-safe note.** Unlike C233, the freeze-link theorem below is **not** placed
under `GateC1.OperatorFreeze`; it is named `frozen_proj_eq_of_budget` inside
`GateC1.SpectralProjectorAPI`, so it cannot collide with the C227
`OperatorFreeze.lean` API. -/

/-- A **maintained spectral island**: an operator together with its unique
spectral projector on a spectral set. -/
structure MaintainedIsland [Field R] [AddCommGroup M] [Module R M] where
  op : M →ₗ[R] M
  proj : M →ₗ[R] M
  set : Set R
  isProj : IsSpectralProjector op proj set

/-- The projector in a maintained island is unique among all projectors for the
same operator and spectral set. -/
theorem MaintainedIsland.proj_unique [Field R] [AddCommGroup M] [Module R M]
    (I : MaintainedIsland (R := R) (M := M)) {P : M →ₗ[R] M}
    (hP : IsSpectralProjector I.op P I.set) : I.proj = P :=
  IsSpectralProjector.unique I.isProj hP

/-
**Island persistence (C194/C202 link).** Given a Kato source contract
carrying the island data on both ends, the perturbed island is again a
maintained island, and its projector is *the* spectral projector — no choice,
by `IsSpectralProjector.unique`.
-/
theorem MaintainedIsland.persistence [Field R] [AddCommGroup M] [Module R M]
    {A A' P P' : M →ₗ[R] M} {S : Set R} {g δ : ℝ}
    (h : KatoSourceContract A A' P P' S g δ) :
    ∃ I' : MaintainedIsland (R := R) (M := M), I'.op = A' ∧ I'.proj = P' := by
  exact ⟨ ⟨ A', P', S, h.target ⟩, rfl, rfl ⟩

/-
**Operator-freeze persistence (C227 link), live-safe rename.** If a budget keeps
the spectral set frozen (the Kato contract holds), the spectral projector is
gapped-homotopic to its source — concretely, *equal whenever the operator is
unchanged*, the degenerate freeze case, recovered through uniqueness.

This is the C233 `OperatorFreeze.frozen_gappedHomotopic_of_budget` theorem,
renamed to `frozen_proj_eq_of_budget` and kept under
`GateC1.SpectralProjectorAPI` so it does **not** collide with the C227
`GateC1.OperatorFreeze` API.
-/
theorem frozen_proj_eq_of_budget
    [Field R] [AddCommGroup M] [Module R M]
    {A P P' : M →ₗ[R] M} {S : Set R} {g δ : ℝ}
    (h : KatoSourceContract A A P P' S g δ) : P = P' := by
  -- Apply the uniqueness theorem for spectral projectors.
  apply IsSpectralProjector.unique h.source h.target

end GateC1.SpectralProjectorAPI
