import PhysicsSM.Draft.NullEdge.Carrier.KreinPositiveSectorWitness

/-!
# A positive Hodge decoder for finite null information

This module isolates a finite, kernel-checked core of the proposed slogan
"physics is the positive Hodge theory of finite null information." It uses the
explicit three-dimensional Kugo-Ojima witness from
`Carrier.KreinPositiveSectorWitness` and keeps two operators separate:

* the **constraint Hodge Laplacian** `Q^* Q + Q Q^*`, whose harmonic vectors
  represent `ker Q / range Q`;
* the **spectral mass square** `D# D`, which can act nontrivially on those
  harmonic physical classes.

This distinction is essential: identifying `D` with the constraint differential
`Q` would make every harmonic cohomology class a zero mode and therefore could
not describe a massive physical class.

For the explicit witness we prove:

* every `Q`-closed vector is cohomologous to a harmonic vector;
* `e2` is harmonic, closed, non-exact, and positive in the `Jpos` quotient;
* a gauge-compatible Krein-self-adjoint decoder gives that class a nonzero
  spectral mass square;
* changing only the surviving Krein sign preserves the Hodge/cohomology data
  but makes the same class negative, giving a sharp positivity no-go.

Honest scope: this is a nonvacuous finite witness, not a derivation of the
universal carrier, a continuum Hodge theorem, confinement, gravity, or the Born
rule. `LinearMap.adjoint` is the ordinary Hilbert adjoint; `kreinAdjoint` is the
separate adjoint used by the spectral mass operator.

Provenance: clean-room finite linear algebra inspired by the "positive Hodge
theory of finite null information" synthesis (Pro review, 2026-07-09), built on
the finite Kugo-Ojima and positive-sector modules in this repository.
-/

open scoped InnerProductSpace

namespace PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgeDecoder

open KugoOjima

/-- The Hilbert-adjoint matrix of the finite constraint differential. -/
noncomputable def QdagMat : Matrix (Fin 3) (Fin 3) ℂ := Qmat.conjTranspose

/-- The Hilbert adjoint `Q^*` of the finite constraint differential. -/
noncomputable def QdagOp : W →ₗ[ℂ] W := Matrix.toEuclideanLin QdagMat

/-- The constraint Hodge Laplacian `Q^* Q + Q Q^*`. -/
noncomputable def constraintLaplacian : W →ₗ[ℂ] W :=
  QdagOp ∘ₗ Qop + Qop ∘ₗ QdagOp

/-- The harmonic projection for the explicit witness: retain only the surviving
`e2` coordinate. -/
noncomputable def harmonicPart (x : W) : W := EuclideanSpace.single 2 (x.ofLp 2)

/-- A separate spectral decoder supported on the physical `e2` class. -/
noncomputable def massDecoderMat (mu : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  !![0, 0, 0; 0, 0, 0; 0, 0, (mu : ℂ)]

/-- The first-order spectral decoder with physical eigenvalue `mu`. -/
noncomputable def massDecoder (mu : ℝ) : W →ₗ[ℂ] W :=
  Matrix.toEuclideanLin (massDecoderMat mu)

/-- The spectral mass-square operator `D# D` on the positive Krein carrier. -/
noncomputable def spectralMassSquare (mu : ℝ) : W →ₗ[ℂ] W :=
  kreinAdjoint Jpos (massDecoder mu) ∘ₗ massDecoder mu

/-! ## Constraint Hodge theory -/

/-- The explicitly defined codifferential really is the Hilbert adjoint of `Q`. -/
theorem QdagOp_eq_adjoint : QdagOp = LinearMap.adjoint Qop := by
  exact Matrix.toEuclideanLin_conjTranspose_eq_adjoint Qmat

/-- The constraint Laplacian is the diagonal projector onto the gauge pair:
`diag(1,1,0)`. -/
theorem constraintLaplacian_apply (x : W) :
    (constraintLaplacian x).ofLp = ![x.ofLp 0, x.ofLp 1, 0] := by
  funext i
  fin_cases i <;>
    simp [constraintLaplacian, QdagOp, QdagMat, Qop, Qmat,
      Matrix.toEuclideanLin, Matrix.mulVec, dotProduct, Fin.sum_univ_three]

/-- The selected representative is harmonic. -/
theorem harmonicPart_is_harmonic (x : W) :
    constraintLaplacian (harmonicPart x) = 0 := by
  ext i
  fin_cases i <;>
    simp [constraintLaplacian_apply, harmonicPart]

/-- The selected representative is `Q`-closed. -/
theorem harmonicPart_is_closed (x : W) :
    harmonicPart x ∈ LinearMap.ker Qop := by
  ext i
  fin_cases i <;>
    simp [harmonicPart, Qop, Qmat, Matrix.toEuclideanLin, Matrix.mulVec,
      dotProduct, Fin.sum_univ_three]

/-- **Explicit finite Hodge representative theorem.** Every closed vector is
cohomologous to its harmonic `e2` component. -/
theorem closed_cohomologous_to_harmonic (x : W) (hx : x ∈ LinearMap.ker Qop) :
    constraintLaplacian (harmonicPart x) = 0 ∧
      x - harmonicPart x ∈ LinearMap.range Qop := by
  refine ⟨harmonicPart_is_harmonic x, ?_⟩
  have hx1 : x.ofLp 1 = 0 := by
    replace hx := congr_arg (fun y : W => y.ofLp 0) hx
    simpa [Qop, Qmat, Matrix.toEuclideanLin, Matrix.mulVec, dotProduct,
      Fin.sum_univ_three] using hx
  refine ⟨EuclideanSpace.single 1 (x.ofLp 0), ?_⟩
  ext i
  fin_cases i <;>
    simp [Qop, Qmat, harmonicPart, Matrix.toEuclideanLin, Matrix.mulVec,
      dotProduct, Fin.sum_univ_three, hx1]

/-- The surviving class representative `e2` is harmonic. -/
theorem e2_is_harmonic : constraintLaplacian e2 = 0 := by
  simpa [e2] using harmonicPart_is_harmonic e2

/-- Every nonzero cohomology class in the positive witness has strictly positive
Krein norm. -/
theorem positive_of_closed_not_exact (x : W) (hx : x ∈ LinearMap.ker Qop)
    (hxe : x ∉ LinearMap.range Qop) :
    0 < (kreinForm Jpos x x).re := by
  have hnonneg := kreinForm_pos_nonneg_on_ker x hx
  have hne : (kreinForm Jpos x x).re ≠ 0 := by
    intro hzero
    exact hxe (kreinForm_pos_definite_on_quotient x hx hzero)
  exact lt_of_le_of_ne hnonneg (Ne.symm hne)

/-! ## A separate spectral mass on positive cohomology -/

/-- The spectral decoder commutes with the constraint differential, so it
preserves closed and exact representatives. -/
theorem massDecoder_commutes_Q (mu : ℝ) :
    massDecoder mu ∘ₗ Qop = Qop ∘ₗ massDecoder mu := by
  ext x
  rename_i i
  fin_cases i <;>
    simp [massDecoder, massDecoderMat, Qop, Qmat, Matrix.toEuclideanLin,
      Matrix.mulVec, dotProduct, Fin.sum_univ_three]

/-- The real diagonal decoder is self-adjoint for the auxiliary Hilbert inner
product. -/
theorem massDecoder_hilbertSelfAdjoint (mu : ℝ) :
    LinearMap.adjoint (massDecoder mu) = massDecoder mu := by
  unfold massDecoder
  rw [← Matrix.toEuclideanLin_conjTranspose_eq_adjoint]
  congr 1
  ext i j
  fin_cases i <;> fin_cases j <;> simp [massDecoderMat]

/-- The decoder is Krein-self-adjoint for the positive fundamental symmetry. -/
theorem massDecoder_kreinSelfAdjoint (mu : ℝ) :
    kreinAdjoint Jpos (massDecoder mu) = massDecoder mu := by
  unfold kreinAdjoint
  rw [massDecoder_hilbertSelfAdjoint]
  ext x
  rename_i i
  fin_cases i <;>
    simp [Jpos, GmatPos, massDecoder, massDecoderMat, Matrix.toEuclideanLin,
      Matrix.mulVec, dotProduct, Fin.sum_univ_three] <;> ring

/-- The nontrivial harmonic class is an eigenvector of the first-order decoder. -/
theorem massDecoder_e2 (mu : ℝ) :
    massDecoder mu e2 = (mu : ℂ) • e2 := by
  ext i
  fin_cases i <;>
    simp [massDecoder, massDecoderMat, e2, Matrix.toEuclideanLin,
      Matrix.mulVec, dotProduct, Fin.sum_univ_three]

/-- The positive cohomology class has spectral mass square `mu^2`. -/
theorem spectralMassSquare_e2 (mu : ℝ) :
    spectralMassSquare mu e2 = ((mu ^ 2 : ℝ) : ℂ) • e2 := by
  rw [spectralMassSquare, massDecoder_kreinSelfAdjoint, LinearMap.comp_apply,
    massDecoder_e2, LinearMap.map_smul, massDecoder_e2]
  rw [smul_smul]
  congr 1
  norm_num [pow_two]

/-- The Krein form is linear in its second argument. -/
theorem kreinForm_smul_right (J : W →ₗ[ℂ] W) (x y : W) (c : ℂ) :
    kreinForm J x (c • y) = c * kreinForm J x y := by
  simp [kreinForm]

/-- A nonzero spectral parameter gives a genuinely positive decoding cost on
the positive harmonic class. -/
theorem spectral_cost_pos (mu : ℝ) (hmu : mu ≠ 0) :
    0 < (kreinForm Jpos e2 (spectralMassSquare mu e2)).re := by
  rw [spectralMassSquare_e2, kreinForm_smul_right, kreinForm_pos_e2]
  simpa [pow_two, Complex.mul_re] using (mul_self_pos.mpr hmu)

/-- **Nonvacuous positive Hodge decoder.** The class of `e2` survives the
constraint quotient, has positive norm, is harmonic, and carries exact spectral
mass square `4` under the gauge-compatible decoder with `mu = 2`. -/
theorem positive_hodge_mass_witness :
    e2 ∈ LinearMap.ker Qop ∧
      e2 ∉ LinearMap.range Qop ∧
      constraintLaplacian e2 = 0 ∧
      0 < (kreinForm Jpos e2 e2).re ∧
      spectralMassSquare 2 e2 = (4 : ℂ) • e2 ∧
      0 < (kreinForm Jpos e2 (spectralMassSquare 2 e2)).re := by
  refine ⟨e2_mem_ker, e2_not_mem_range, e2_is_harmonic,
    positive_of_closed_not_exact e2 e2_mem_ker e2_not_mem_range, ?_,
    spectral_cost_pos 2 (by norm_num)⟩
  norm_num [spectralMassSquare_e2]

/-- **Positivity is independent data.** The same `Q`, Hodge Laplacian, harmonic
class, and cohomology survive for `Jneg`, but the class has negative norm. -/
theorem hodge_without_positivity_no_go :
    e2 ∈ LinearMap.ker Qop ∧
      e2 ∉ LinearMap.range Qop ∧
      constraintLaplacian e2 = 0 ∧
      (kreinForm Jneg e2 e2).re < 0 := by
  refine ⟨e2_mem_ker, e2_not_mem_range, e2_is_harmonic, ?_⟩
  rw [kreinForm_neg_e2]
  norm_num

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgeDecoder.closed_cohomologous_to_harmonic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms closed_cohomologous_to_harmonic

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgeDecoder.positive_hodge_mass_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positive_hodge_mass_witness

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgeDecoder.hodge_without_positivity_no_go' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hodge_without_positivity_no_go

end PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgeDecoder
