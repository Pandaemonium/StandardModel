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

/-! ### The induced action on the physical quotient `ker Q / range Q`

The previous results witness the descent hypotheses only at the level of
representatives.  This section makes the descent literal: it constructs the map
induced by `Uop a` on the physical quotient
`LinearMap.ker Qop ⧸ (LinearMap.range Qop).submoduleOf (LinearMap.ker Qop)`,
packages it as a linear equivalence for every phase `a`, shows it fixes the
class of `e2`, and shows it preserves the descended Krein form.

Claim boundary: this remains finite linear algebra on `EuclideanSpace ℂ (Fin 3)`.
Nothing here asserts a physical Ward identity, BRST cohomology, carrier/Gauss
completeness, or physical positivity. -/

/-- `Uop a` preserves the constraint space `ker Qop`.  This follows from the
commutation `Uop a ∘ Qop = Qop ∘ Uop a` alone (no phase hypothesis needed). -/
theorem Uop_mapsTo_ker (a : ℂ) : ∀ x ∈ LinearMap.ker Qop, Uop a x ∈ LinearMap.ker Qop := by
  intro x hx
  have h := LinearMap.congr_fun (Uop_comm_Qop a) x
  rw [LinearMap.comp_apply, LinearMap.comp_apply] at h
  rw [LinearMap.mem_ker] at *
  rw [hx, map_zero] at h
  exact h.symm

/-- `Uop a` preserves `range Qop`.  Again a consequence of commutation alone. -/
theorem Uop_mapsTo_range (a : ℂ) :
    ∀ y ∈ LinearMap.range Qop, Uop a y ∈ LinearMap.range Qop := by
  rintro y ⟨z, rfl⟩
  have h := LinearMap.congr_fun (Uop_comm_Qop a) z
  rw [LinearMap.comp_apply, LinearMap.comp_apply] at h
  exact ⟨Uop a z, h.symm⟩

/-- `Uop a` restricted to an endomorphism of the constraint space `ker Qop`. -/
noncomputable def UopKer (a : ℂ) : (LinearMap.ker Qop) →ₗ[ℂ] (LinearMap.ker Qop) :=
  (Uop a).restrict (Uop_mapsTo_ker a)

theorem UopKer_coe (a : ℂ) (x : LinearMap.ker Qop) : ((UopKer a x : W)) = Uop a (x : W) := by
  rw [UopKer, LinearMap.restrict_apply]

/-- `UopKer a` maps `range Qop` (seen inside `ker Qop`) into itself, so it
descends to the quotient. -/
theorem UopKer_maps_range (a : ℂ) :
    ((LinearMap.range Qop).submoduleOf (LinearMap.ker Qop)) ≤
      Submodule.comap (UopKer a) ((LinearMap.range Qop).submoduleOf (LinearMap.ker Qop)) := by
  intro x hx
  simp only [Submodule.submoduleOf, Submodule.mem_comap, Submodule.coe_subtype] at *
  rw [UopKer_coe]
  exact Uop_mapsTo_range a _ hx

private theorem tel3' (M N : Matrix (Fin 3) (Fin 3) ℂ) :
    Matrix.toEuclideanLin (M * N)
      = Matrix.toEuclideanLin M ∘ₗ Matrix.toEuclideanLin N :=
  Matrix.toLpLin_mul 2 2 2 M N

/-- The diagonal phases compose: `Uop a ∘ Uop b = Uop (a * b)`. -/
theorem Uop_comp (a b : ℂ) : Uop a ∘ₗ Uop b = Uop (a * b) := by
  rw [Uop, Uop, Uop, ← tel3']
  congr 1
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Umat, Matrix.mul_apply, Fin.sum_univ_three]

/-- `Uop 1` is the identity. -/
theorem Uop_one : Uop 1 = LinearMap.id := by
  rw [Uop]
  ext x i
  fin_cases i <;>
    simp [Umat, Matrix.toLpLin_apply, dotProduct, Fin.sum_univ_three]

theorem UopKer_comp_apply (a b : ℂ) (x : LinearMap.ker Qop) :
    UopKer a (UopKer b x) = UopKer (a * b) x := by
  apply Subtype.ext
  rw [UopKer_coe, UopKer_coe, UopKer_coe]
  have := LinearMap.congr_fun (Uop_comp a b) (x : W)
  rw [LinearMap.comp_apply] at this
  exact this

theorem UopKer_one_apply (x : LinearMap.ker Qop) : UopKer 1 x = x := by
  apply Subtype.ext
  rw [UopKer_coe, Uop_one, LinearMap.id_apply]

/-- The physical quotient `ker Q / range Q` of the positive-sector model. -/
abbrev PhysQuot := LinearMap.ker Qop ⧸ (LinearMap.range Qop).submoduleOf (LinearMap.ker Qop)

/-- The map induced by `Uop a` on the physical quotient `ker Q / range Q`. -/
noncomputable def UopQuot (a : ℂ) : PhysQuot →ₗ[ℂ] PhysQuot :=
  ((LinearMap.range Qop).submoduleOf (LinearMap.ker Qop)).mapQ _ (UopKer a) (UopKer_maps_range a)

theorem UopQuot_mk (a : ℂ) (x : LinearMap.ker Qop) :
    UopQuot a (Submodule.Quotient.mk x) = Submodule.Quotient.mk (UopKer a x) :=
  Submodule.mapQ_apply _ _ _ x

/-- The physical class of the surviving representative `e2`. -/
noncomputable def e2Class : PhysQuot := Submodule.Quotient.mk ⟨e2, e2_mem_ker⟩

/-- The induced quotient map fixes the physical class of `e2`. -/
theorem UopQuot_e2 (a : ℂ) : UopQuot a e2Class = e2Class := by
  rw [e2Class, UopQuot_mk]
  congr 1
  apply Subtype.ext
  rw [UopKer_coe]
  exact Uop_e2 a

theorem UopQuot_comp_apply (a b : ℂ) (z : PhysQuot) :
    UopQuot a (UopQuot b z) = UopQuot (a * b) z := by
  induction z using Submodule.Quotient.induction_on with
  | H x => rw [UopQuot_mk, UopQuot_mk, UopQuot_mk, UopKer_comp_apply]

theorem UopQuot_one (z : PhysQuot) : UopQuot 1 z = z := by
  induction z using Submodule.Quotient.induction_on with
  | H x => rw [UopQuot_mk, UopKer_one_apply]

/-- For every phase `a`, the induced quotient map is a linear equivalence of the
physical quotient, with inverse induced by `Uop (star a)`. -/
noncomputable def UopQuotEquiv (a : ℂ) (ha : star a * a = 1) : PhysQuot ≃ₗ[ℂ] PhysQuot :=
  LinearEquiv.ofLinear (UopQuot a) (UopQuot (star a))
    (by
      ext z
      simp only [LinearMap.comp_apply, LinearMap.id_apply]
      rw [UopQuot_comp_apply]
      have : a * star a = 1 := by rw [mul_comm]; exact ha
      rw [this, UopQuot_one])
    (by
      ext z
      simp only [LinearMap.comp_apply, LinearMap.id_apply]
      rw [UopQuot_comp_apply, ha, UopQuot_one])

theorem UopQuotEquiv_apply (a : ℂ) (ha : star a * a = 1) (z : PhysQuot) :
    UopQuotEquiv a ha z = UopQuot a z := rfl

/-- The induced quotient equivalence fixes the physical class of `e2`. -/
theorem UopQuotEquiv_e2 (a : ℂ) (ha : star a * a = 1) : UopQuotEquiv a ha e2Class = e2Class :=
  UopQuot_e2 a

/-! ### The descended Krein form on the physical quotient -/

/-- The Krein form vanishes between a constraint vector and a `range Q` vector. -/
theorem kreinForm_ker_range (v r : W) (hv : v ∈ LinearMap.ker Qop)
    (hr : r ∈ LinearMap.range Qop) : kreinForm Jpos v r = 0 := by
  have hob : LinearMap.range Qop = orthoB Jpos (LinearMap.ker Qop) := by
    rw [orthoB_ker_eq_range Jpos Jpos_involutive Qop, Qop_kreinAdjoint_pos]
  rw [hob] at hr
  exact (mem_orthoB Jpos (LinearMap.ker Qop) r).1 hr v hv

/-- The Krein form vanishes between a `range Q` vector and a constraint vector. -/
theorem kreinForm_range_ker (r v : W) (hr : r ∈ LinearMap.range Qop)
    (hv : v ∈ LinearMap.ker Qop) : kreinForm Jpos r v = 0 := by
  obtain ⟨z, rfl⟩ := hr
  rw [krein_adjoint_pairing Jpos Jpos_involutive Qop z v, Qop_kreinAdjoint_pos]
  rw [LinearMap.mem_ker] at hv
  rw [hv, kreinForm]
  simp

theorem kreinForm_sub_left (x x' y : W) :
    kreinForm Jpos (x - x') y = kreinForm Jpos x y - kreinForm Jpos x' y := by
  simp [kreinForm]

theorem kreinForm_sub_right (x y y' : W) :
    kreinForm Jpos x (y - y') = kreinForm Jpos x y - kreinForm Jpos x y' := by
  simp [kreinForm, map_sub]

/-- The Krein form descends to a well-defined form on the physical quotient
`ker Q / range Q`.  Well-definedness uses that `range Q` is the radical of the
form restricted to `ker Q` (`kreinForm_ker_range`, `kreinForm_range_ker`). -/
noncomputable def kreinQuotForm : PhysQuot → PhysQuot → ℂ :=
  fun p q => Quotient.liftOn₂' p q
    (fun x y => kreinForm Jpos (x : W) (y : W))
    (by
      intro x₁ y₁ x₂ y₂ hx hy
      have hx' : (x₁ : W) - (x₂ : W) ∈ LinearMap.range Qop := by
        have := (Submodule.Quotient.eq _).1 (Quotient.sound hx)
        simpa [Submodule.submoduleOf, Submodule.mem_comap] using this
      have hy' : (y₁ : W) - (y₂ : W) ∈ LinearMap.range Qop := by
        have := (Submodule.Quotient.eq _).1 (Quotient.sound hy)
        simpa [Submodule.submoduleOf, Submodule.mem_comap] using this
      show kreinForm Jpos (x₁ : W) (y₁ : W) = kreinForm Jpos (x₂ : W) (y₂ : W)
      have e1 : kreinForm Jpos (x₁ : W) (y₁ : W) = kreinForm Jpos (x₁ : W) (y₂ : W) := by
        have h0 : kreinForm Jpos (x₁ : W) ((y₁ : W) - (y₂ : W)) = 0 :=
          kreinForm_ker_range _ _ x₁.2 hy'
        rw [kreinForm_sub_right] at h0; linear_combination h0
      have e2' : kreinForm Jpos (x₁ : W) (y₂ : W) = kreinForm Jpos (x₂ : W) (y₂ : W) := by
        have h0 : kreinForm Jpos ((x₁ : W) - (x₂ : W)) (y₂ : W) = 0 :=
          kreinForm_range_ker _ _ hx' y₂.2
        rw [kreinForm_sub_left] at h0; linear_combination h0
      rw [e1, e2'])

theorem kreinQuotForm_mk (x y : LinearMap.ker Qop) :
    kreinQuotForm (Submodule.Quotient.mk x) (Submodule.Quotient.mk y)
      = kreinForm Jpos (x : W) (y : W) := rfl

/-- The induced quotient map preserves the descended Krein form, for every
phase `a`. -/
theorem kreinQuotForm_UopQuot (a : ℂ) (ha : star a * a = 1) (p q : PhysQuot) :
    kreinQuotForm (UopQuot a p) (UopQuot a q) = kreinQuotForm p q := by
  induction p using Submodule.Quotient.induction_on with
  | H x =>
    induction q using Submodule.Quotient.induction_on with
    | H y =>
      rw [UopQuot_mk, UopQuot_mk, kreinQuotForm_mk, kreinQuotForm_mk, UopKer_coe, UopKer_coe]
      exact (ward_descent_preservation a ha).2.2.1 (x : W) (y : W)

/-- The induced quotient equivalence preserves the descended Krein form. -/
theorem kreinQuotForm_UopQuotEquiv (a : ℂ) (ha : star a * a = 1) (p q : PhysQuot) :
    kreinQuotForm (UopQuotEquiv a ha p) (UopQuotEquiv a ha q) = kreinQuotForm p q :=
  kreinQuotForm_UopQuot a ha p q

/-- **Induced Ward/descent action on the physical quotient.**  For every phase
`a`, `Uop a` induces a linear equivalence of `ker Q / range Q` that fixes the
physical class of `e2` and preserves the descended Krein form.  Finite linear
algebra only; no physical Ward identity, BRST cohomology, carrier/Gauss
completeness, or physical positivity is claimed. -/
theorem quotient_ward_action (a : ℂ) (ha : star a * a = 1) :
    (UopQuotEquiv a ha e2Class = e2Class) ∧
    (∀ p q : PhysQuot,
      kreinQuotForm (UopQuotEquiv a ha p) (UopQuotEquiv a ha q) = kreinQuotForm p q) :=
  ⟨UopQuotEquiv_e2 a ha, kreinQuotForm_UopQuotEquiv a ha⟩

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.quotient_ward_action' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quotient_ward_action

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.UopQuot_e2' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms UopQuot_e2

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.kreinQuotForm_UopQuot' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms kreinQuotForm_UopQuot

end PhysicsSM.Draft.NullEdge.Carrier.KugoOjima
