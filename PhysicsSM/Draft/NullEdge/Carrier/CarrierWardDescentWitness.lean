import PhysicsSM.Draft.NullEdge.Carrier.KreinPositiveSectorWitness

/-!
# Ward/descent symmetry witness on the positive-sector model

This module closes a model-audit gap left open by
`KreinPositiveSectorWitness.lean`.

`KugoOjima.descent_unitary` proves that a `J`-unitary operator `U` commuting
with a nilpotent charge `Q` preserves `ker Q`, preserves `range Q`, and
preserves the Krein form on representatives.  Until this file, the repository
had not exhibited a concrete non-identity operator satisfying those two
hypotheses on the `(2,1)` positive-sector model.

Here we give such a witness.  For any phase `a` with `star a * a = 1`,
`Uop a = diag(a, a, 1)` is `Jpos`-unitary and commutes with `Qop`.  Therefore
`descent_unitary` applies nonvacuously, and every `Uop a` fixes the surviving
physical-class representative `e2`.  The special phase `a = Complex.I` gives a
genuine non-identity symmetry.

Claim boundary: this is finite linear algebra on `EuclideanSpace C (Fin 3)`.
It witnesses the hypotheses of the finite descent lemma.  It does not prove a
physical Ward identity, BRST cohomology statement, or state-space positivity
beyond the displayed finite model.

Provenance: Aristotle audit lane
`ne-solo-lane-hstar-gauss-ward-realsplit-model-audit-20260707`, clean-room
finite linear algebra built on `KugoOjima.descent_unitary` and the existing
`KreinPositiveSectorWitness` model.
-/

open scoped InnerProductSpace

namespace PhysicsSM.Draft.NullEdge.Carrier.KugoOjima

/-- The diagonal phase matrix `diag(a, a, 1)`. Equal entries in the first two
diagonal slots are exactly what makes it commute with the charge `Q = e1 -> e0`. -/
noncomputable def Umat (a : ℂ) : Matrix (Fin 3) (Fin 3) ℂ :=
  !![a, 0, 0; 0, a, 0; 0, 0, 1]

/-- The candidate Ward/descent symmetry operator `Uop a = diag(a, a, 1)`. -/
noncomputable def Uop (a : ℂ) : W →ₗ[ℂ] W :=
  Matrix.toEuclideanLin (Umat a)

/-- `toEuclideanLin` turns matrix multiplication into composition in the `3 x 3`
case. -/
private theorem toEuclideanLin_mul3 (M N : Matrix (Fin 3) (Fin 3) ℂ) :
    Matrix.toEuclideanLin (M * N)
      = Matrix.toEuclideanLin M ∘ₗ Matrix.toEuclideanLin N :=
  Matrix.toLpLin_mul 2 2 2 M N

/-- `Uop a` commutes with the charge `Qop`: the finite Ward commutation
hypothesis. -/
theorem Uop_comm_Qop (a : ℂ) : Uop a ∘ₗ Qop = Qop ∘ₗ Uop a := by
  rw [Uop, Qop, ← toEuclideanLin_mul3, ← toEuclideanLin_mul3]
  congr 1
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Umat, Qmat, Matrix.mul_apply, Fin.sum_univ_three]

/-- `Uop a` is `Jpos`-unitary whenever `a` is a phase. -/
theorem Uop_kreinUnitary (a : ℂ) (ha : star a * a = 1) :
    kreinAdjoint Jpos (Uop a) ∘ₗ Uop a = LinearMap.id := by
  have key : GmatPos * ((Umat a).conjTranspose * GmatPos) * (Umat a) = 1 := by
    have conjT : (Umat a).conjTranspose = Umat (star a) := by
      ext i j
      fin_cases i <;> fin_cases j <;> simp [Umat, Matrix.conjTranspose_apply]
    rw [conjT]
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [GmatPos, Umat, Matrix.mul_apply, Fin.sum_univ_three] <;>
      simp_all [mul_comm]
  unfold kreinAdjoint Jpos Uop
  rw [← Matrix.toEuclideanLin_conjTranspose_eq_adjoint, ← toEuclideanLin_mul3,
    ← toEuclideanLin_mul3, ← toEuclideanLin_mul3, key]
  ext x i
  simp [Matrix.toEuclideanLin, Matrix.toLpLin]

/-- `Uop a` fixes the surviving physical-class representative `e2`. -/
theorem Uop_e2 (a : ℂ) : Uop a e2 = e2 := by
  unfold Uop e2
  ext i
  fin_cases i <;>
    simp [Umat, Matrix.toLpLin_apply, EuclideanSpace.single_apply]

/-- `Uop a` scales the isotropic constraint direction `e0` by `a`, so it acts
nontrivially on `ker Q` unless `a = 1`. -/
theorem Uop_e0 (a : ℂ) :
    Uop a (EuclideanSpace.single 0 1) = EuclideanSpace.single 0 a := by
  unfold Uop
  ext i
  fin_cases i <;>
    simp [Umat, Matrix.toLpLin_apply, EuclideanSpace.single_apply]

/-- Ward/descent preservation, witnessed.  For every phase `a`, the operator
`Uop a` satisfies both hypotheses of `descent_unitary` on the `(2,1)`
positive-sector model.  It therefore preserves `ker Qop`, preserves
`range Qop`, preserves `kreinForm Jpos`, and fixes `e2`. -/
theorem ward_descent_preservation (a : ℂ) (ha : star a * a = 1) :
    (∀ x ∈ LinearMap.ker Qop, Uop a x ∈ LinearMap.ker Qop) ∧
    (∀ y ∈ LinearMap.range Qop, Uop a y ∈ LinearMap.range Qop) ∧
    (∀ x y : W, kreinForm Jpos (Uop a x) (Uop a y) = kreinForm Jpos x y) ∧
    Uop a e2 = e2 :=
  ⟨(descent_unitary Jpos Jpos_involutive Qop (Uop a)
      (Uop_kreinUnitary a ha) (Uop_comm_Qop a)).1,
   (descent_unitary Jpos Jpos_involutive Qop (Uop a)
      (Uop_kreinUnitary a ha) (Uop_comm_Qop a)).2.1,
   (descent_unitary Jpos Jpos_involutive Qop (Uop a)
      (Uop_kreinUnitary a ha) (Uop_comm_Qop a)).2.2,
   Uop_e2 a⟩

/-- The `a = Complex.I` witness is a genuine non-identity symmetry: it moves the
constraint direction `e0`. -/
theorem Uop_I_ne_id : Uop Complex.I ≠ LinearMap.id := by
  intro h
  have h0 := Uop_e0 Complex.I
  rw [h] at h0
  simp only [LinearMap.id_coe, id_eq] at h0
  have := congr_arg (fun v : W => v.ofLp 0) h0
  simp [EuclideanSpace.single_apply, Complex.ext_iff] at this

/-- Nonvacuity of the Ward/descent hypotheses.  There is an explicit
non-identity operator on the `(2,1)` positive-sector model satisfying both
hypotheses of `descent_unitary`, hence preserving the constraint complex and
the Krein form while fixing the physical-class representative `e2`. -/
theorem ward_descent_nonvacuous :
    ∃ U : W →ₗ[ℂ] W, U ≠ LinearMap.id ∧
      kreinAdjoint Jpos U ∘ₗ U = LinearMap.id ∧
      U ∘ₗ Qop = Qop ∘ₗ U ∧
      (∀ x ∈ LinearMap.ker Qop, U x ∈ LinearMap.ker Qop) ∧
      (∀ y ∈ LinearMap.range Qop, U y ∈ LinearMap.range Qop) ∧
      (∀ x y : W, kreinForm Jpos (U x) (U y) = kreinForm Jpos x y) ∧
      U e2 = e2 := by
  have hI : star Complex.I * Complex.I = 1 := by
    simp
  obtain ⟨hk, hr, hf, he2⟩ := ward_descent_preservation Complex.I hI
  exact ⟨Uop Complex.I, Uop_I_ne_id, Uop_kreinUnitary Complex.I hI,
    Uop_comm_Qop Complex.I, hk, hr, hf, he2⟩

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.ward_descent_preservation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ward_descent_preservation

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.ward_descent_nonvacuous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ward_descent_nonvacuous

end PhysicsSM.Draft.NullEdge.Carrier.KugoOjima
