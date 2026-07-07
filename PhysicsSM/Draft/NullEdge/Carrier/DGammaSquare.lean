import Mathlib

/-!
# Finite second-quantization square identity

This module formalizes the Q08 finite identity

`dGamma(D)^2 = dGamma(D^2) + 2 dGammaTwo(D)`.

The first square identity is made on decomposable fermionic Fock states in the
exterior algebra.  The later `Globalization` section constructs the one-body
second-quantized operator `dGammaOp D` as a genuine derivation on all of
`ExteriorAlgebra R V`, and proves that its square on decomposable states is the
tuple-level Leibniz double sum.

Claim boundary: this is finite algebra only.  It does not prove positivity of
the Gupta-Bleuler quotient, construct a global two-body operator, or prove the
exterior quotient theorem.

Provenance: Aristotle project
`7067efa0-9755-482a-8d74-9c0b9a8318c7`
(`ne-q08-dgamma-square-identity-20260707`) and follow-up project
`97417bb8-8d9b-443a-8588-b895d0ce005c`
(`ne-q08-dgamma-exterior-globalization-proof-20260707`), clean-room
formalization of `AgentTasks/fable_parallel/Q08_answer.md` target L-Q8-3 /
T-I1.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare

variable {R : Type*} [CommRing R]
variable {V : Type*} [AddCommGroup V] [Module R V]
variable {k : ℕ}

/-- Apply the one-body operator `D` in slot `i`. -/
def applyAt (D : V →ₗ[R] V) (i : Fin k) (v : Fin k -> V) : Fin k -> V :=
  Function.update v i (D (v i))

/-- Applying `D` twice in the same slot inserts `D^2` there. -/
theorem applyAt_same (D : V →ₗ[R] V) (i : Fin k) (v : Fin k -> V) :
    applyAt D i (applyAt D i v) = Function.update v i (D (D (v i))) := by
  unfold applyAt
  simp [Function.update_idem, Function.update_self]

/-- Applying `D` in two distinct slots commutes. -/
theorem applyAt_comm (D : V →ₗ[R] V) {i j : Fin k} (hij : i ≠ j)
    (v : Fin k -> V) :
    applyAt D i (applyAt D j v) = applyAt D j (applyAt D i v) := by
  unfold applyAt
  rw [Function.update_comm hij, Function.update_of_ne hij,
    Function.update_of_ne (Ne.symm hij)]

/-- The exterior-algebra wedge of a tuple as an ordered product of generators. -/
noncomputable def wedge (v : Fin k -> V) : ExteriorAlgebra R V :=
  (List.ofFn (fun i => ExteriorAlgebra.ι R (v i))).prod

section Core

variable {M : Type*} [AddCommGroup M]

/-- Combinatorial core: a double Leibniz sum splits into the diagonal part plus
twice the strict-upper-triangular off-diagonal part. -/
theorem double_sum_split (D : V →ₗ[R] V) (W : (Fin k -> V) -> M) (v : Fin k -> V) :
    (∑ i, ∑ j, W (applyAt D i (applyAt D j v)))
      = (∑ i, W (applyAt D i (applyAt D i v)))
        + 2 • (∑ p ∈ Finset.univ.filter (fun p : Fin k × Fin k => p.1 < p.2),
                  W (applyAt D p.1 (applyAt D p.2 v))) := by
  rw [← Finset.sum_product']
  rw [show (Finset.univ ×ˢ Finset.univ : Finset (Fin k × Fin k)) =
      Finset.image (fun i => (i, i)) Finset.univ ∪
        Finset.filter (fun p : Fin k × Fin k => p.1 < p.2) Finset.univ ∪
        Finset.filter (fun p : Fin k × Fin k => p.2 < p.1) Finset.univ from ?_,
    Finset.sum_union, Finset.sum_union]
  · simp +decide [two_smul]
    rw [Finset.sum_image] <;> simp +decide [add_assoc]
    · apply Finset.sum_bij (fun p hp => (p.2, p.1))
      · grind
      · grind
      · aesop
      · intro a ha
        simp only [Finset.mem_filter] at ha
        exact congr_arg W (applyAt_comm D ha.2.ne' v)
    · exact fun i j h => by injection h
  · simp +decide [Finset.disjoint_left]
  · simp +decide [Finset.disjoint_left]
    exact fun a b h => h.elim (fun h => h.le) fun h => h.le
  · grind

end Core

/-- One-body second quantization on a decomposable state. -/
noncomputable def dGamma (K : V →ₗ[R] V) (v : Fin k -> V) : ExteriorAlgebra R V :=
  ∑ i, wedge (applyAt K i v)

/-- The Leibniz action of `dGamma(D)^2` on a decomposable state. -/
noncomputable def dGammaSq (D : V →ₗ[R] V) (v : Fin k -> V) :
    ExteriorAlgebra R V :=
  ∑ i, ∑ j, wedge (applyAt D i (applyAt D j v))

/-- Two-body second quantization of the pair kernel `Lambda^2 D`, i.e. apply
`D` in both selected pair slots of a decomposable state. -/
noncomputable def dGammaTwo (D : V →ₗ[R] V) (v : Fin k -> V) :
    ExteriorAlgebra R V :=
  ∑ p ∈ Finset.univ.filter (fun p : Fin k × Fin k => p.1 < p.2),
    wedge (applyAt D p.1 (applyAt D p.2 v))

/-- `dGammaSq` is the Leibniz sum iterated. -/
theorem dGammaSq_eq_iterate (D : V →ₗ[R] V) (v : Fin k -> V) :
    dGammaSq D v = ∑ j, dGamma D (applyAt D j v) := by
  unfold dGammaSq dGamma
  rw [Finset.sum_comm]

/-- `dGamma(D^2)` is the diagonal of the double Leibniz sum. -/
theorem dGamma_sq_op (D : V →ₗ[R] V) (v : Fin k -> V) :
    dGamma (D ∘ₗ D) v = ∑ i, wedge (applyAt D i (applyAt D i v)) := by
  unfold dGamma
  refine Finset.sum_congr rfl (fun i _ => ?_)
  rw [applyAt_same]
  rfl

/-- Finite second-quantization square identity on decomposable Fock states. -/
theorem dGamma_sq_identity (D : V →ₗ[R] V) (v : Fin k -> V) :
    dGammaSq D v = dGamma (D ∘ₗ D) v + 2 • dGammaTwo D v := by
  rw [dGammaSq, dGamma_sq_op, dGammaTwo]
  exact double_sum_split D wedge v

/-!
## Genuine exterior-algebra globalization

The identity above is stated in terms of the tuple-level bookkeeping maps
`dGamma`, `dGammaSq`, and `dGammaTwo`.  This section lifts the one-body second
quantization to a genuine linear endomorphism `dGammaOp D` of the whole exterior
algebra `ExteriorAlgebra R V`, built as an algebra derivation, and proves that
the tuple-level `dGammaSq` is the operator square `dGammaOp D` followed by
`dGammaOp D` on a decomposable state `wedge v`.

The derivation is constructed through the square-zero extension
`TrivSqZeroExt A A` of `A := ExteriorAlgebra R V`: the linear map
`v |-> inr (ExteriorAlgebra.ι R (D v)) + inl (ExteriorAlgebra.ι R v)` squares
to zero by the exterior-algebra anticommutator, so it lifts to an
`R`-algebra homomorphism whose second component is the desired derivation.

Claim boundary: still finite algebra only.  We construct the one-body operator
`dGammaOp` globally on all of `ExteriorAlgebra R V`; the two-body term remains
the combinatorial `dGammaTwo`.  No positivity or continuum Fock claim is made.
-/

section Globalization

open TrivSqZeroExt

set_option synthInstance.maxHeartbeats 1000000
set_option maxHeartbeats 1000000

/-- Abbreviation for the ambient exterior algebra. -/
noncomputable abbrev Ext (R V) [CommRing R] [AddCommGroup V] [Module R V] :=
  ExteriorAlgebra R V

/-- The generator-level map into the square-zero extension. -/
noncomputable def fmap (D : V →ₗ[R] V) :
    V →ₗ[R] TrivSqZeroExt (Ext R V) (Ext R V) :=
  ((TrivSqZeroExt.inrHom (Ext R V) (Ext R V)).restrictScalars R).comp
      ((ExteriorAlgebra.ι R).comp D)
    + ((TrivSqZeroExt.inlAlgHom R (Ext R V) (Ext R V)).toLinearMap).comp
        (ExteriorAlgebra.ι R)

/-- Pointwise form of the square-zero-extension generator map. -/
theorem fmap_apply (D : V →ₗ[R] V) (v : V) :
    fmap D v = TrivSqZeroExt.inr (ExteriorAlgebra.ι R (D v))
      + TrivSqZeroExt.inl (ExteriorAlgebra.ι R v) := by
  simp [fmap]

/-- The generator map squares to zero. -/
theorem fmap_sq (D : V →ₗ[R] V) (v : V) : fmap D v * fmap D v = 0 := by
  rw [fmap_apply]
  have key : ExteriorAlgebra.ι R (D v) * ExteriorAlgebra.ι R v
      + ExteriorAlgebra.ι R v * ExteriorAlgebra.ι R (D v) = 0 :=
    ExteriorAlgebra.ι_add_mul_swap (D v) v
  rw [mul_add, add_mul, add_mul, TrivSqZeroExt.inr_mul_inr, TrivSqZeroExt.inr_mul_inl,
    TrivSqZeroExt.inl_mul_inr, TrivSqZeroExt.inl_mul_inl, ExteriorAlgebra.ι_sq_zero]
  simp only [TrivSqZeroExt.inl_zero, add_zero, zero_add, ← TrivSqZeroExt.inr_add,
    op_smul_eq_mul, smul_eq_mul]
  rw [add_comm (ExteriorAlgebra.ι R v * _), key, TrivSqZeroExt.inr_zero]

/-- The `R`-algebra homomorphism lifting `fmap`. -/
noncomputable def dGammaHom (D : V →ₗ[R] V) :
    ExteriorAlgebra R V →ₐ[R] TrivSqZeroExt (Ext R V) (Ext R V) :=
  ExteriorAlgebra.lift R ⟨fmap D, fun v => fmap_sq D v⟩

/-- `dGammaHom` agrees with `fmap` on exterior generators. -/
theorem dGammaHom_ι (D : V →ₗ[R] V) (v : V) :
    dGammaHom D (ExteriorAlgebra.ι R v) = fmap D v := by
  simp [dGammaHom]

/-- The first component of `dGammaHom D` is the identity. -/
theorem dGammaHom_fst (D : V →ₗ[R] V) (a : ExteriorAlgebra R V) :
    (dGammaHom D a).fst = a := by
  have h : (TrivSqZeroExt.fstHom R (Ext R V) (Ext R V)).comp (dGammaHom D)
      = AlgHom.id R _ := by
    apply ExteriorAlgebra.hom_ext
    ext v
    simp [dGammaHom_ι, fmap_apply, TrivSqZeroExt.fst_add]
  exact AlgHom.congr_fun h a

/-- Second quantization of a one-body operator as a derivation of the whole
exterior algebra. -/
noncomputable def dGammaOp (D : V →ₗ[R] V) :
    ExteriorAlgebra R V →ₗ[R] ExteriorAlgebra R V :=
  ((TrivSqZeroExt.sndHom (Ext R V) (Ext R V)).restrictScalars R).comp
    (dGammaHom D).toLinearMap

/-- `dGammaOp D` acts on generators by applying `D` inside `ι`. -/
theorem dGammaOp_ι (D : V →ₗ[R] V) (v : V) :
    dGammaOp D (ExteriorAlgebra.ι R v) = ExteriorAlgebra.ι R (D v) := by
  simp only [dGammaOp, LinearMap.comp_apply, LinearMap.coe_restrictScalars,
    AlgHom.toLinearMap_apply, dGammaHom_ι, fmap_apply]
  simp [TrivSqZeroExt.snd_add]

/-- `dGammaOp D` satisfies the Leibniz rule. -/
theorem dGammaOp_mul (D : V →ₗ[R] V) (a b : ExteriorAlgebra R V) :
    dGammaOp D (a * b) = a * dGammaOp D b + dGammaOp D a * b := by
  simp only [dGammaOp, LinearMap.comp_apply, LinearMap.coe_restrictScalars,
    AlgHom.toLinearMap_apply, map_mul, TrivSqZeroExt.sndHom_apply, TrivSqZeroExt.snd_mul,
    dGammaHom_fst, smul_eq_mul, op_smul_eq_mul]

/-- `dGammaOp D` annihilates the unit. -/
theorem dGammaOp_one (D : V →ₗ[R] V) : dGammaOp D 1 = 0 := by
  simp only [dGammaOp, LinearMap.comp_apply, LinearMap.coe_restrictScalars,
    AlgHom.toLinearMap_apply, map_one, TrivSqZeroExt.sndHom_apply, TrivSqZeroExt.snd_one]

/-- Wedge of a `(k+1)`-tuple splits off the first generator. -/
theorem wedge_succ {k : ℕ} (v : Fin (k + 1) -> V) :
    wedge v = ExteriorAlgebra.ι R (v 0) * wedge (Fin.tail v) := by
  simp only [wedge, List.ofFn_succ, List.prod_cons]
  rfl

/-- Applying `D` in slot `0` peels off `D (v 0)`. -/
theorem wedge_applyAt_zero {k : ℕ} (D : V →ₗ[R] V) (v : Fin (k + 1) -> V) :
    wedge (applyAt D 0 v) = ExteriorAlgebra.ι R (D (v 0)) * wedge (Fin.tail v) := by
  rw [wedge_succ]
  unfold applyAt
  rw [Fin.tail_update_zero, Function.update_self]

/-- Applying `D` in a successor slot keeps the first generator in front. -/
theorem wedge_applyAt_succ {k : ℕ} (D : V →ₗ[R] V) (j : Fin k) (v : Fin (k + 1) -> V) :
    wedge (applyAt D j.succ v)
      = ExteriorAlgebra.ι R (v 0) * wedge (applyAt D j (Fin.tail v)) := by
  rw [wedge_succ]
  unfold applyAt
  rw [Function.update_of_ne (Fin.succ_ne_zero j).symm, Fin.tail_update_succ]
  rfl

/-- The genuine derivation on a decomposable state equals the tuple-level
one-body sum. -/
theorem dGammaOp_wedge (D : V →ₗ[R] V) (v : Fin k -> V) :
    dGammaOp D (wedge v) = ∑ i, wedge (applyAt D i v) := by
  induction k with
  | zero => simp [wedge, dGammaOp_one]
  | succ k ih =>
    rw [wedge_succ, dGammaOp_mul, dGammaOp_ι, ih, Fin.sum_univ_succ, wedge_applyAt_zero]
    simp_rw [wedge_applyAt_succ]
    rw [Finset.mul_sum]
    abel

/-- `dGammaOp K` on a decomposable state is exactly `dGamma K`. -/
theorem dGammaOp_wedge_eq_dGamma (K : V →ₗ[R] V) (v : Fin k -> V) :
    dGammaOp K (wedge v) = dGamma K v :=
  dGammaOp_wedge K v

/-- Applying the identity operator in one tuple slot leaves the tuple unchanged. -/
theorem applyAt_id (i : Fin k) (v : Fin k -> V) :
    applyAt (LinearMap.id : V →ₗ[R] V) i v = v := by
  ext j
  unfold applyAt
  by_cases h : j = i
  · subst h
    simp
  · simp [Function.update_of_ne h]

/-- The second quantization of the identity acts on a decomposable `k`-particle
state by multiplication by the particle number `k`. -/
theorem dGammaOp_id_wedge (v : Fin k -> V) :
    dGammaOp (LinearMap.id : V →ₗ[R] V) (wedge v) = (k : R) • wedge v := by
  rw [dGammaOp_wedge]
  simp [applyAt_id, Algebra.smul_def]

/-- For the identity one-body operator, the tuple-level two-body term counts
strictly ordered pair slots `i < j`. -/
theorem dGammaTwo_id_pair_count (v : Fin k -> V) :
    dGammaTwo (LinearMap.id : V →ₗ[R] V) v =
      ((Finset.univ.filter (fun p : Fin k × Fin k => p.1 < p.2)).card : R) • wedge v := by
  unfold dGammaTwo
  simp [applyAt_id, Algebra.smul_def]

/-- Applying the genuine derivation twice to a decomposable state reproduces
the tuple double sum. -/
theorem dGammaOp_sq_wedge (D : V →ₗ[R] V) (v : Fin k -> V) :
    dGammaOp D (dGammaOp D (wedge v)) = dGammaSq D v := by
  rw [dGammaOp_wedge, map_sum]
  simp_rw [dGammaOp_wedge]
  rw [dGammaSq, Finset.sum_comm]

/-- Globalized square identity on decomposable Fock states. -/
theorem dGamma_sq_identity_operator (D : V →ₗ[R] V) (v : Fin k -> V) :
    dGammaOp D (dGammaOp D (wedge v)) = dGamma (D ∘ₗ D) v + 2 • dGammaTwo D v := by
  rw [dGammaOp_sq_wedge, dGamma_sq_identity]

/-- The same identity, with the one-body terms both written via `dGammaOp`. -/
theorem dGamma_sq_identity_operator' (D : V →ₗ[R] V) (v : Fin k -> V) :
    dGammaOp D (dGammaOp D (wedge v))
      = dGammaOp (D ∘ₗ D) (wedge v) + 2 • dGammaTwo D v := by
  rw [dGamma_sq_identity_operator, dGammaOp_wedge_eq_dGamma]

end Globalization

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare.double_sum_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms double_sum_split

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare.dGamma_sq_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms dGamma_sq_identity

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare.dGamma_sq_identity_operator' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms dGamma_sq_identity_operator

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare.dGammaOp_id_wedge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms dGammaOp_id_wedge

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare.dGammaTwo_id_pair_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms dGammaTwo_id_pair_count

end PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare
