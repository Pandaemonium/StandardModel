import Mathlib

/-!
# Finite gauge-invariant vector FMS observable

This module isolates finite matrix algebra behind the custodial-vector part of
the Froehlich-Morchio-Strocchi (FMS) reconstruction.  A Higgs matrix transforms
on the left under a local gauge transformation, while the resulting composite
matrix retains its right/global index pair.  The theorem suite proves:

* exact cancellation of a simultaneous local gauge transformation;
* the complete leading, mixed, and quadratic finite expansion;
* bijectivity of the leading two-by-two bridge at nonzero vacuum; and
* an explicit three-to-two representation-mismatch control.

Provenance: clean-room finite formalization oriented by Axel Maas, "The
Froehlich-Morchio-Strocchi mechanism: A underestimated legacy,"
arXiv:2305.01960v2, especially the custodial-vector observable discussion.
Proof bodies were completed by Aristotle task
`823b672e-6b4e-447d-83e5-98733e22b5e4`.  During integration, Boolean nonzero
hypotheses in the focused package were strengthened to proposition-level
hypotheses; the returned proof terms require only the corresponding direct
nonzero facts.

This is finite observable-reconstruction algebra.  It is not a new mass
source and does not prove perturbative dominance, a spectral pole, an LSZ
statement, or the observed W/Z masses.  Claim grade: `M [comp]`.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.HiggsFMSVectorObservable

noncomputable section

abbrev M2 := Matrix (Fin 2) (Fin 2) Complex
abbrev M3 := Matrix (Fin 3) (Fin 3) Complex

/-- Higgs matrix expanded about a real scalar vacuum. -/
def higgsMatrix (v : Real) (eta : M2) : M2 :=
  (v : Complex) • (1 : M2) + eta

/-- Matrix-valued gauge-invariant vector observable in the finite model. -/
def vectorObservable (v : Real) (eta W : M2) : M2 :=
  (higgsMatrix v eta)ᴴ * W * higgsMatrix v eta

/-- Leading FMS response at vanishing fluctuation. -/
def leadingVectorObservable (v : Real) (W : M2) : M2 :=
  ((v ^ 2 : Real) : Complex) • W

/-- Simultaneous left transformation of the Higgs matrix and adjoint
transformation of the gauge response cancel exactly. -/
theorem vectorObservable_gauge_invariant
    (U X W : M2) (hU : Uᴴ * U = 1) :
    (U * X)ᴴ * (U * W * Uᴴ) * (U * X) = Xᴴ * W * X := by
  simp [Matrix.conjTranspose_mul, Matrix.mul_assoc]
  simp [← Matrix.mul_assoc, hU]

/-- Exact leading, two-mixed-term, and quadratic expansion. -/
theorem vectorObservable_expansion (v : Real) (eta W : M2) :
    vectorObservable v eta W =
      leadingVectorObservable v W +
        (v : Complex) • (etaᴴ * W + W * eta) +
        etaᴴ * W * eta := by
  unfold vectorObservable leadingVectorObservable higgsMatrix
  simp [mul_add, add_mul, mul_assoc]
  norm_num [sq, add_assoc, add_left_comm, add_comm, Algebra.smul_def]
  norm_num [Algebra.algebraMap_eq_smul_one]
  abel_nf

/-- At zero supplied fluctuation, the composite observable is exactly its
leading FMS bridge. -/
theorem vectorObservable_zero (v : Real) (W : M2) :
    vectorObservable v 0 W = leadingVectorObservable v W := by
  simpa using vectorObservable_expansion v 0 W

/-- A propositionally nonzero vacuum makes the leading two-by-two bridge
injective. -/
theorem leadingVectorObservable_injective (v : Real) (hv : v ≠ 0) :
    Function.Injective (leadingVectorObservable v) := by
  have hc : (((v ^ 2 : Real) : Complex)) ≠ 0 := by
    exact_mod_cast pow_ne_zero 2 hv
  exact smul_right_injective M2 hc

/-- A propositionally nonzero vacuum also makes the leading bridge
surjective. -/
theorem leadingVectorObservable_surjective (v : Real) (hv : v ≠ 0) :
    Function.Surjective (leadingVectorObservable v) := by
  have hc : (((v ^ 2 : Real) : Complex)) ≠ 0 := by
    exact_mod_cast pow_ne_zero 2 hv
  intro Y
  refine ⟨(((v ^ 2 : Real) : Complex))⁻¹ • Y, ?_⟩
  exact smul_inv_smul₀ hc Y

/-- Compress a three-dimensional gauge matrix to a two-dimensional global
channel.  This finite map models a representation-size mismatch. -/
def compress3to2 (W : M3) : M2 :=
  fun i j => W (Fin.castSucc i) (Fin.castSucc j)

/-- Third diagonal matrix unit, used as a nondegenerate hidden direction. -/
def hiddenThirdDirection : M3 :=
  fun i j => if i = 2 && j = 2 then 1 else 0

theorem hiddenThirdDirection_nonzero : hiddenThirdDirection ≠ 0 := by
  intro h
  have e := congr_fun (congr_fun h (2 : Fin 3)) (2 : Fin 3)
  simp [hiddenThirdDirection] at e

theorem compress3to2_hiddenThirdDirection :
    compress3to2 hiddenThirdDirection = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;> rfl

/-- A three-to-two representation mismatch destroys injectivity, so physical
multiplicities cannot be inferred merely by naming an index map. -/
theorem compress3to2_not_injective :
    Not (Function.Injective compress3to2) := by
  intro h
  apply hiddenThirdDirection_nonzero
  apply h
  simpa using compress3to2_hiddenThirdDirection

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsFMSVectorObservable.vectorObservable_gauge_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms vectorObservable_gauge_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsFMSVectorObservable.vectorObservable_expansion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms vectorObservable_expansion

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsFMSVectorObservable.leadingVectorObservable_surjective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms leadingVectorObservable_surjective

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsFMSVectorObservable.compress3to2_not_injective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms compress3to2_not_injective

end

end PhysicsSM.Draft.NullEdge.HiggsFMSVectorObservable
