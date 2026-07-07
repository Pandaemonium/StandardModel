import PhysicsSM.Draft.NullEdge.Carrier.KugoOjima

/-!
# Q01 -- Krein positive-sector witness vs. no-go

This module makes precise, and kernel-checks, the central separation of the Q01
answer (`Q01_answer.md`, Theorem A + Finding A): the finite Kugo-Ojima quotient
form on `ker Q / range Q` is nondegenerate under the algebraic hypotheses of
`finite_kugo_ojima`, but physical positivity of that quotient is a separate
question governed by the inertia of the ambient Krein form.

We witness both sides of the separation with two models on
`W := EuclideanSpace ℂ (Fin 3)` that share the same nilpotent
Krein-self-adjoint charge `Q` and differ only in the sign of one diagonal entry
of the Krein Gram matrix `J`:

* `Jpos` has Gram `[[0,1,0],[1,0,0],[0,0,1]]`: inertia `(2,1)`, with the
  constraint direction `e0` isotropic.  The induced form on `ker Q / range Q`
  is one-dimensional and positive definite.
* `Jneg` has Gram `[[0,1,0],[1,0,0],[0,0,-1]]`: inertia `(1,2)`.  With the
  identical `Q`, `finite_kugo_ojima` still certifies quotient nondegeneracy, but
  the surviving physical class has negative Krein norm.

Scope / honesty: this is PROVED finite linear algebra.  The physical reading
that `dim(physical sector) = ind(D)` and that `p > q` is the nonvacuity
condition is the MEMO/OPEN interpretation layer of `Q01_answer.md`, of which
these are two extremal finite witnesses.

Provenance: Aristotle project
`ne-q01-krein-positive-sector-witness-or-no-go-audit-20260707`; clean-room
finite linear algebra built on `KugoOjima.finite_kugo_ojima`.
-/

open scoped InnerProductSpace

namespace PhysicsSM.Draft.NullEdge.Carrier.KugoOjima

/-- The shared witness space `ℂ³` with its Euclidean Hilbert inner product. -/
abbrev W : Type := EuclideanSpace ℂ (Fin 3)

/-- The shared nilpotent Krein-self-adjoint charge matrix
`Q = [[0,1,0],[0,0,0],[0,0,0]]` (`Q e₁ = e₀`, `Q e₀ = Q e₂ = 0`). -/
noncomputable def Qmat : Matrix (Fin 3) (Fin 3) ℂ := !![0, 1, 0; 0, 0, 0; 0, 0, 0]

/-- The shared BRST-type charge operator. -/
noncomputable def Qop : W →ₗ[ℂ] W := Matrix.toEuclideanLin Qmat

/-- Krein Gram of the positive-sector model: inertia `(2,1)`, `e₀` isotropic. -/
noncomputable def GmatPos : Matrix (Fin 3) (Fin 3) ℂ := !![0, 1, 0; 1, 0, 0; 0, 0, 1]

/-- The fundamental symmetry of the positive-sector model. -/
noncomputable def Jpos : W →ₗ[ℂ] W := Matrix.toEuclideanLin GmatPos

/-- Krein Gram of the no-go model: inertia `(1,2)`, identical to `GmatPos`
except the sign of the single non-null direction `e₂`. -/
noncomputable def GmatNeg : Matrix (Fin 3) (Fin 3) ℂ := !![0, 1, 0; 1, 0, 0; 0, 0, -1]

/-- The fundamental symmetry of the no-go model. -/
noncomputable def Jneg : W →ₗ[ℂ] W := Matrix.toEuclideanLin GmatNeg

/-- The surviving physical class representative. -/
noncomputable def e2 : W := EuclideanSpace.single 2 1

/-! ### Shared algebraic facts -/

theorem Qop_sq : Qop ∘ₗ Qop = 0 := by
  ext x
  rename_i i
  fin_cases i <;> simp +decide [Qop, Qmat, Matrix.mulVec]

theorem Jpos_involutive : Jpos ∘ₗ Jpos = LinearMap.id := by
  ext x
  rename_i i
  fin_cases i <;> simp +decide [Jpos, GmatPos] <;> rfl

theorem Jneg_involutive : Jneg ∘ₗ Jneg = LinearMap.id := by
  ext x
  simp [Jneg]
  rename_i i
  fin_cases i <;>
    norm_num [Fin.sum_univ_succ, Matrix.mulVec, dotProduct, GmatNeg] <;>
    rfl

theorem Qop_kreinAdjoint_pos : kreinAdjoint Jpos Qop = Qop := by
  ext x
  unfold Qop
  simp +decide [Matrix.toEuclideanLin]
  unfold kreinAdjoint
  erw [show (Matrix.toLpLin 2 2 Qmat).adjoint =
    Matrix.toLpLin 2 2 (Qmat.conjTranspose) from ?_]
  · simp +decide [Jpos, GmatPos, Qmat]
    rename_i i
    fin_cases i <;> simp +decide [Matrix.vecHead, Matrix.vecTail, Matrix.vecMul]
  · ext
    simp +decide [Matrix.toEuclideanLin_conjTranspose_eq_adjoint]

theorem Qop_kreinAdjoint_neg : kreinAdjoint Jneg Qop = Qop := by
  refine' LinearMap.ext fun x => _
  convert Matrix.toLpLin_apply 2 2 (GmatNeg * Qmat.conjTranspose * GmatNeg) x using 1
  · have hJneg : Jneg = Matrix.toEuclideanLin GmatNeg := by
      rfl
    have hQop : Qop = Matrix.toEuclideanLin Qmat := by
      rfl
    simp [hJneg, hQop, Matrix.toEuclideanLin_conjTranspose_eq_adjoint]
    rfl
  · refine' congr_arg (fun m => Matrix.toEuclideanLin m x) _
    ext i j
    fin_cases i <;> fin_cases j <;> norm_num [Matrix.mul_apply, Fin.sum_univ_succ] <;>
      simp +decide [Qmat, GmatNeg]

theorem e2_mem_ker : e2 ∈ LinearMap.ker Qop := by
  ext i
  fin_cases i <;> simp +decide [Qop, Qmat, e2]

theorem e2_not_mem_range : e2 ∉ LinearMap.range Qop := by
  unfold Qop e2
  norm_num [Qmat, Matrix.toEuclideanLin]
  intro x hx
  have := congr_arg (fun y => y.ofLp 2) hx
  norm_num [Matrix.mulVec] at this
  simp_all +decide [dotProduct, Fin.sum_univ_three]

theorem kreinForm_pos_e2 : kreinForm Jpos e2 e2 = 1 := by
  have hJpos_e2 : Jpos e2 = e2 := by
    simp [Jpos, GmatPos]
    ext i
    fin_cases i <;> simp +decide [Matrix.toLpLin_apply, e2]
  simp [kreinForm, hJpos_e2]
  exact Or.inl (by unfold e2; norm_num)

theorem kreinForm_neg_e2 : kreinForm Jneg e2 e2 = -1 := by
  convert congr_arg (fun x : W => inner ℂ e2 x) (show Jneg e2 = -e2 from _) using 1
  · norm_num [e2]
  · ext i
    fin_cases i <;> norm_num [Jneg, GmatNeg, e2] <;> simp +decide

/-- On the positive-sector model, the Krein form is positive semidefinite on the
whole representative space `ker Q`. -/
theorem kreinForm_pos_nonneg_on_ker (x : W) (hx : x ∈ LinearMap.ker Qop) :
    0 ≤ (kreinForm Jpos x x).re := by
  unfold Qop at hx
  unfold Qmat at hx
  simp_all +decide [Matrix.toEuclideanLin]
  simp_all +decide [funext_iff, Fin.forall_fin_succ, Matrix.toLpLin]
  simp_all +decide [Matrix.vecHead, Matrix.vecTail, kreinForm, Jpos, GmatPos]
  simp_all +decide [Matrix.toEuclideanLin, Matrix.mulVec, dotProduct, Fin.sum_univ_three, inner]
  nlinarith

/-- On the positive-sector model, the induced form is definite: a representative
with zero Krein norm lies in `range Q`, i.e. is null in the quotient. -/
theorem kreinForm_pos_definite_on_quotient (x : W) (hx : x ∈ LinearMap.ker Qop)
    (h0 : (kreinForm Jpos x x).re = 0) : x ∈ LinearMap.range Qop := by
  have h_expansion : (kreinForm Jpos x x).re = x.ofLp 2 * star x.ofLp 2 := by
    unfold Qop at *
    simp_all +decide [Matrix.toEuclideanLin]
    simp_all +decide [Qmat, Matrix.toLpLin]
    unfold kreinForm Jpos at h0
    simp_all +decide
    unfold GmatPos at h0
    simp_all +decide [Matrix.toEuclideanLin, Matrix.vecHead, Matrix.vecTail]
    simp_all +decide [Matrix.toLpLin, dotProduct, Fin.sum_univ_three, inner]
    exact Complex.ext (by norm_num; nlinarith) (by norm_num; nlinarith)
  have hx_form : x = x.ofLp 0 • EuclideanSpace.single 0 1 := by
    ext i
    fin_cases i <;> simp_all +decide [Qop]
    replace hx := congr_arg (fun y => y.ofLp 0) hx
    simp_all +decide [Qmat]
    exact hx
  refine' ⟨EuclideanSpace.single 1 (x.ofLp 0), _⟩
  rw [hx_form]
  ext i
  fin_cases i <;> norm_num [Qop, Qmat]

/-! ### The nonvacuous positive-sector witness -/

/-- Nonvacuous positive-sector witness, with inertia `(2,1)`.  `Q` is a nilpotent
Krein-self-adjoint charge for `Jpos`, so `finite_kugo_ojima` applies.  The
Kugo-Ojima quotient `ker Q / range Q` is nonvacuous, the class of `e₂` is
nonzero, and the induced form is positive definite on representatives modulo
`range Q`. -/
theorem nonvacuous_positive_sector :
    (Jpos ∘ₗ Jpos = LinearMap.id) ∧ (Qop ∘ₗ Qop = 0) ∧ (kreinAdjoint Jpos Qop = Qop) ∧
    (∀ x ∈ LinearMap.ker Qop, x ∉ LinearMap.range Qop →
      ∃ y ∈ LinearMap.ker Qop, kreinForm Jpos y x ≠ 0) ∧
    (e2 ∈ LinearMap.ker Qop ∧ e2 ∉ LinearMap.range Qop) ∧
    (∀ x ∈ LinearMap.ker Qop, 0 ≤ (kreinForm Jpos x x).re) ∧
    (∀ x ∈ LinearMap.ker Qop, (kreinForm Jpos x x).re = 0 → x ∈ LinearMap.range Qop) ∧
    0 < (kreinForm Jpos e2 e2).re := by
  refine ⟨Jpos_involutive, Qop_sq, Qop_kreinAdjoint_pos, ?_, ⟨e2_mem_ker, e2_not_mem_range⟩,
    kreinForm_pos_nonneg_on_ker, kreinForm_pos_definite_on_quotient, ?_⟩
  · exact (finite_kugo_ojima Jpos Jpos_involutive Qop Qop_sq Qop_kreinAdjoint_pos).2.2
  · rw [kreinForm_pos_e2]
    norm_num

/-! ### The sharp no-go -/

/-- Sharp no-go, with inertia `(1,2)`.  With the identical nilpotent
Krein-self-adjoint charge `Q`, the finite Kugo-Ojima theorem still certifies that
the quotient form on `ker Q / range Q` is nondegenerate, yet the surviving class
`e₂` has strictly negative Krein norm.  The only change from
`nonvacuous_positive_sector` is the sign of one ambient Gram entry. -/
theorem nondegenerate_but_indefinite_no_go :
    (Jneg ∘ₗ Jneg = LinearMap.id) ∧ (Qop ∘ₗ Qop = 0) ∧ (kreinAdjoint Jneg Qop = Qop) ∧
    (∀ x ∈ LinearMap.ker Qop, x ∉ LinearMap.range Qop →
      ∃ y ∈ LinearMap.ker Qop, kreinForm Jneg y x ≠ 0) ∧
    (e2 ∈ LinearMap.ker Qop ∧ e2 ∉ LinearMap.range Qop ∧
      (kreinForm Jneg e2 e2).re < 0) := by
  refine ⟨Jneg_involutive, Qop_sq, Qop_kreinAdjoint_neg, ?_,
    ⟨e2_mem_ker, e2_not_mem_range, ?_⟩⟩
  · exact (finite_kugo_ojima Jneg Jneg_involutive Qop Qop_sq Qop_kreinAdjoint_neg).2.2
  · rw [kreinForm_neg_e2]
    norm_num

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.nonvacuous_positive_sector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonvacuous_positive_sector

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.nondegenerate_but_indefinite_no_go' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nondegenerate_but_indefinite_no_go

end PhysicsSM.Draft.NullEdge.Carrier.KugoOjima
