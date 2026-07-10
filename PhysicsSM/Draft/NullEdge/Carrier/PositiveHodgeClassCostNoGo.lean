import PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgeRayleigh

/-!
# Positive-Hodge class-cost invariance and variational no-go

This module corrects a false-shape risk in the proposed variational mass over
representatives `h + Q chi`. Under the actual cohomological hypotheses
`Q^2 = 0`, Kugo-Ojima radicality, and descent `[S,Q] = 0`, an exact direction is
closed and its image under `S` is exact. Its spectral pairing therefore
vanishes, so the cost is constant across the cohomology class rather than
nontrivially minimized by a preferred representative.

The previously landed `PositiveHodgeRayleigh.witness` remains a valid affine
variational example, but its `Q` is a projection and is not nilpotent. This file
proves that boundary explicitly and replaces it with a nonzero nilpotent
rational witness whose surviving positive class has cost `4/25`.

Scientific consequence: a class-invariant spectral value survives. Calling it
a positive physical mass additionally requires positivity of the spectral
pairing on the normalized representative. That conditional implication and a
nondegenerate nilpotent Krein quartet are supplied by
`PositiveHodgePhysicalMass`. What fails here is the claim that varying by exact
representatives changes the cost while radicality, nilpotence, and decoder
descent all hold. A nontrivial variational theory must instead vary decoder
moduli, positive-sector data, non-exact physical states, or one of those
hypotheses.

Provenance: semantic audit of Aristotle project
`be5c5929-b9ca-4763-a103-4e9c79cab5db`, followed by a clean-room correction
formalized and checked by Codex on 2026-07-09. Aristotle project `8d0c1db2` was
also launched for independent proof/audit.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgeClassCostNoGo

open PhysicsSM.Draft.NullEdge.PositiveHodgeRayleigh

variable {V : Type*} [AddCommGroup V] [Module ℝ V]

/-- Under nilpotence and descent, every exact direction has zero spectral
pairing with itself. -/
theorem exact_spectral_cost_zero
    (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (Q S : V →ₗ[ℝ] V)
    (hrad : RadicalProperty B Q) (hQQ : Q ∘ₗ Q = 0)
    (hcomm : S ∘ₗ Q = Q ∘ₗ S) (chi : V) :
    B (Q chi) (S (Q chi)) = 0 := by
  have hclosed : Q (Q chi) = 0 := by
    have h := LinearMap.congr_fun hQQ chi
    simpa using h
  have hSQ : S (Q chi) = Q (S chi) := LinearMap.congr_fun hcomm chi
  rw [hSQ]
  exact (hrad (Q chi) (S chi) hclosed).1

/-- The spectral pairing of a normalized closed eigen-representative is
constant under addition of exact vectors. -/
theorem class_cost_constant
    (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (Q S : V →ₗ[ℝ] V)
    (hrad : RadicalProperty B Q) (hQQ : Q ∘ₗ Q = 0)
    (hcomm : S ∘ₗ Q = Q ∘ₗ S)
    (h : V) (hclosed : Q h = 0) (mu2 : ℝ)
    (heig : S h = mu2 • h) (hnorm : B h h = 1) (chi : V) :
    B (h + Q chi) (S (h + Q chi)) = mu2 := by
  have hsplit :
      B (h + Q chi) (S (h + Q chi)) =
        mu2 + B (Q chi) (S (Q chi)) := by
    have hSQ : S (Q chi) = Q (S chi) := LinearMap.congr_fun hcomm chi
    obtain ⟨_, hr2⟩ := hrad h chi hclosed
    obtain ⟨hr3, _⟩ := hrad h (S chi) hclosed
    rw [map_add S, heig]
    simp only [map_add, map_smul, LinearMap.add_apply, smul_eq_mul, hnorm]
    rw [hSQ, hr3, hr2]
    ring
  rw [hsplit, exact_spectral_cost_zero B Q S hrad hQQ hcomm chi, add_zero]

/-- The set of spectral costs over cohomologous representatives is exactly a
singleton. -/
theorem class_cost_set_eq_singleton
    (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (Q S : V →ₗ[ℝ] V)
    (hrad : RadicalProperty B Q) (hQQ : Q ∘ₗ Q = 0)
    (hcomm : S ∘ₗ Q = Q ∘ₗ S)
    (h : V) (hclosed : Q h = 0) (mu2 : ℝ)
    (heig : S h = mu2 • h) (hnorm : B h h = 1) :
    {c : ℝ | ∃ chi : V, c = B (h + Q chi) (S (h + Q chi))} = {mu2} := by
  ext c
  constructor
  · rintro ⟨chi, rfl⟩
    simpa using class_cost_constant B Q S hrad hQQ hcomm h hclosed mu2 heig hnorm chi
  · intro hc
    have hcmu : c = mu2 := by simpa using hc
    subst c
    exact ⟨0, (class_cost_constant B Q S hrad hQQ hcomm h hclosed mu2 heig hnorm 0).symm⟩

/-- The projection used by `PositiveHodgeRayleigh.witness` is not a
cohomological differential: its square is nonzero. -/
theorem landed_projection_witness_not_nilpotent :
    cexQ ∘ₗ cexQ ≠ 0 := by
  intro hzero
  have h1 := LinearMap.congr_fun hzero (![1, 0, 0] : Fin 3 → ℝ)
  have h2 := congrFun h1 0
  simp [cexQ, LinearMap.comp_apply, Matrix.toLin'_apply, Matrix.mulVec,
    dotProduct, Fin.sum_univ_three] at h2

open Matrix in
/-- Degenerate form `diag(0,1,1)`; the exact `e0` direction is radical while
the surviving `e2` class is positive. -/
noncomputable def witnessB :
    (Fin 3 → ℝ) →ₗ[ℝ] (Fin 3 → ℝ) →ₗ[ℝ] ℝ :=
  Matrix.toLinearMap₂' ℝ !![(0 : ℝ), 0, 0; 0, 1, 0; 0, 0, 1]

open Matrix in
/-- Nonzero nilpotent differential sending `e1` to `e0`. -/
noncomputable def witnessQ : (Fin 3 → ℝ) →ₗ[ℝ] (Fin 3 → ℝ) :=
  Matrix.toLin' !![(0 : ℝ), 1, 0; 0, 0, 0; 0, 0, 0]

open Matrix in
/-- Spectral operator with cost `4/25` on the surviving `e2` class and zero on
the exact direction. -/
noncomputable def witnessS : (Fin 3 → ℝ) →ₗ[ℝ] (Fin 3 → ℝ) :=
  Matrix.toLin' !![(0 : ℝ), 0, 0; 0, 0, 0; 0, 0, 4 / 25]

/-- Nondegenerate rational fixture for the class-invariant cost theorem. -/
theorem nilpotent_positive_class_witness :
    witnessQ ≠ 0 ∧
      witnessQ ∘ₗ witnessQ = 0 ∧
      RadicalProperty witnessB witnessQ ∧
      witnessS ∘ₗ witnessQ = witnessQ ∘ₗ witnessS ∧
      witnessQ (![0, 0, 1] : Fin 3 → ℝ) = 0 ∧
      witnessS (![0, 0, 1] : Fin 3 → ℝ) =
        (4 / 25 : ℝ) • (![0, 0, 1] : Fin 3 → ℝ) ∧
      witnessB (![0, 0, 1] : Fin 3 → ℝ) (![0, 0, 1] : Fin 3 → ℝ) = 1 ∧
      ∀ chi : Fin 3 → ℝ,
        witnessB ((![0, 0, 1] : Fin 3 → ℝ) + witnessQ chi)
          (witnessS ((![0, 0, 1] : Fin 3 → ℝ) + witnessQ chi)) = 4 / 25 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro hcon
    have h1 := DFunLike.congr_fun hcon (![0, 1, 0] : Fin 3 → ℝ)
    have h2 := congrFun h1 0
    simp [witnessQ, Matrix.toLin'_apply, Matrix.mulVec, dotProduct,
      Fin.sum_univ_three] at h2
  · unfold witnessQ
    rw [← Matrix.toLin'_mul]
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_three, Matrix.cons_val_two]
  · intro y chi hy
    constructor <;>
      simp [witnessB, witnessQ, Matrix.toLinearMap₂'_apply,
        Matrix.toLin'_apply, dotProduct, Fin.sum_univ_three]
  · unfold witnessQ witnessS
    rw [← Matrix.toLin'_mul, ← Matrix.toLin'_mul]
    congr 1
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_three, Matrix.cons_val_two]
  · funext i
    fin_cases i <;>
      simp +decide [witnessQ, Matrix.toLin'_apply, Matrix.mulVec, dotProduct,
        Fin.sum_univ_three, Matrix.cons_val_two]
  · funext i
    fin_cases i <;>
      norm_num [witnessS, Matrix.toLin'_apply, Matrix.mulVec, dotProduct,
        Fin.sum_univ_three, Matrix.cons_val_zero, Matrix.cons_val_one,
        Matrix.cons_val_two]
  · norm_num [witnessB, Matrix.toLinearMap₂'_apply, Fin.sum_univ_three,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two]
  · intro chi
    simp +decide [witnessB, witnessQ, witnessS, Matrix.toLinearMap₂'_apply,
      Matrix.toLin'_apply, dotProduct, Fin.sum_univ_three,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgeClassCostNoGo.class_cost_set_eq_singleton' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms class_cost_set_eq_singleton

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgeClassCostNoGo.landed_projection_witness_not_nilpotent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms landed_projection_witness_not_nilpotent

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgeClassCostNoGo.nilpotent_positive_class_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nilpotent_positive_class_witness

end PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgeClassCostNoGo
