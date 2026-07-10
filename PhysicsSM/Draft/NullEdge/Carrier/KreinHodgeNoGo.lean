import PhysicsSM.Draft.NullEdge.Carrier.KugoOjima

/-!
# Krein-Hodge no-go in dimension two

This module records the minimal negative control for any proposed
"positive Hodge" reconstruction. On `C^2`, take

```text
J = [[0,1],[1,0]],    Q = [[0,1],[0,0]].
```

Then `Q` is nilpotent and Krein-self-adjoint, but its Krein-adjoint
Laplacian

```text
Delta# = Q# Q + Q Q#
```

vanishes identically. Hence every vector is `Delta#`-harmonic, while
`ker Q = range Q`, so the cohomology is zero. In particular `e1` is harmonic
but is not even closed.

This proves that Krein self-adjointness and nilpotence do not supply a Hodge
isomorphism. Harmonic representative theory must use an auxiliary positive
Hilbert adjoint, while selection of a physical `J`-positive sector is separate,
model-dependent data.

Provenance: clean-room transcription of the two-dimensional counterexample in
the Fable review supplied by the user on 2026-07-09. Matrix conventions use
zero-based coordinates, so the shared kernel/range is `span(e0)`.
-/

open scoped InnerProductSpace

namespace PhysicsSM.Draft.NullEdge.Carrier.KreinHodgeNoGo

open KugoOjima

abbrev W2 := EuclideanSpace ℂ (Fin 2)

/-- The exchange fundamental symmetry of signature `(1,1)`. -/
noncomputable def Jmat : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

noncomputable def Jop : W2 →ₗ[ℂ] W2 := Matrix.toEuclideanLin Jmat

/-- The rank-one nilpotent charge `Q e1 = e0`. -/
noncomputable def Qmat : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 0, 0]

noncomputable def Qop : W2 →ₗ[ℂ] W2 := Matrix.toEuclideanLin Qmat

/-- The Laplacian obtained from the Krein adjoint rather than the auxiliary
positive Hilbert adjoint. -/
noncomputable def kreinLaplacian : W2 →ₗ[ℂ] W2 :=
  kreinAdjoint Jop Qop ∘ₗ Qop + Qop ∘ₗ kreinAdjoint Jop Qop

noncomputable def e1 : W2 := EuclideanSpace.single 1 1

theorem Jop_involutive : Jop ∘ₗ Jop = LinearMap.id := by
  ext x
  rename_i i
  fin_cases i <;> simp [Jop, Jmat, Matrix.toEuclideanLin, Matrix.mulVec,
    dotProduct, Fin.sum_univ_two]

theorem Jop_hilbertSelfAdjoint : LinearMap.adjoint Jop = Jop := by
  unfold Jop
  rw [← Matrix.toEuclideanLin_conjTranspose_eq_adjoint]
  congr 1
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Jmat]

theorem Qop_sq : Qop ∘ₗ Qop = 0 := by
  ext x
  rename_i i
  fin_cases i <;> simp [Qop, Qmat, Matrix.toEuclideanLin, Matrix.mulVec,
    dotProduct, Fin.sum_univ_two]

/-- The nilpotent charge is Krein-self-adjoint. -/
theorem Qop_kreinSelfAdjoint : kreinAdjoint Jop Qop = Qop := by
  unfold kreinAdjoint Qop
  rw [← Matrix.toEuclideanLin_conjTranspose_eq_adjoint]
  ext x
  rename_i i
  fin_cases i <;>
    simp [Jop, Jmat, Qmat,
      Matrix.toEuclideanLin, Matrix.mulVec, dotProduct, Fin.sum_univ_two]

/-- The Krein-adjoint Laplacian collapses to zero. -/
theorem kreinLaplacian_eq_zero : kreinLaplacian = 0 := by
  rw [kreinLaplacian, Qop_kreinSelfAdjoint, Qop_sq]
  simp

/-- The finite cohomology is trivial: every closed vector is exact. -/
theorem ker_Qop_eq_range_Qop : LinearMap.ker Qop = LinearMap.range Qop := by
  apply le_antisymm
  · intro x hx
    have hx1 : x.ofLp 1 = 0 := by
      replace hx := congr_arg (fun y : W2 => y.ofLp 0) hx
      simpa [Qop, Qmat, Matrix.toEuclideanLin, Matrix.mulVec, dotProduct,
        Fin.sum_univ_two] using hx
    refine ⟨EuclideanSpace.single 1 (x.ofLp 0), ?_⟩
    ext i
    fin_cases i <;>
      simp [Qop, Qmat, Matrix.toEuclideanLin, Matrix.mulVec, dotProduct,
        Fin.sum_univ_two, hx1]
  · exact kugo_ojima_range_le_ker Qop Qop_sq

/-- A concrete vector is Krein-harmonic although it is not closed. -/
theorem e1_harmonic_not_closed : kreinLaplacian e1 = 0 ∧ e1 ∉ LinearMap.ker Qop := by
  constructor
  · rw [kreinLaplacian_eq_zero]
    rfl
  · intro h
    replace h := congr_arg (fun y : W2 => y.ofLp 0) h
    norm_num [Qop, Qmat, e1, Matrix.toEuclideanLin, Matrix.mulVec,
      dotProduct, Fin.sum_univ_two] at h

/-- **Krein-Hodge no-go.** The algebraic BRST hypotheses hold, the Krein
Laplacian makes every vector harmonic, but cohomology is zero and a harmonic
vector need not be closed. -/
theorem krein_hodge_no_go :
    Jop ∘ₗ Jop = LinearMap.id ∧
      LinearMap.adjoint Jop = Jop ∧
      Qop ∘ₗ Qop = 0 ∧
      kreinAdjoint Jop Qop = Qop ∧
      kreinLaplacian = 0 ∧
      LinearMap.ker Qop = LinearMap.range Qop ∧
      kreinLaplacian e1 = 0 ∧
      e1 ∉ LinearMap.ker Qop := by
  exact ⟨Jop_involutive, Jop_hilbertSelfAdjoint, Qop_sq, Qop_kreinSelfAdjoint,
    kreinLaplacian_eq_zero, ker_Qop_eq_range_Qop,
    e1_harmonic_not_closed.1, e1_harmonic_not_closed.2⟩

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KreinHodgeNoGo.krein_hodge_no_go' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms krein_hodge_no_go

end PhysicsSM.Draft.NullEdge.Carrier.KreinHodgeNoGo
