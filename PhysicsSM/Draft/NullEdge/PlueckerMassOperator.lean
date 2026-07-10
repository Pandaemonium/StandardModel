import Mathlib

/-!
# The Plücker mass operator: one operator from the complex wedge coordinate

Pro-review integration centerpiece.  The reviewer's diagnosis: the manuscript
currently WIRES the same scalar into several finite modules; the fix is to
DERIVE every downstream quantity from one operator constructed canonically
from the spinor data.  This package builds that operator.  For two spinors
with complex Plücker coordinate `z = psi wedge phi`, define the odd Hermitian
mass operator

  `Bz = !![0, z; conj z, 0]`.

Then `Bz^2 = |z|^2 = det P` — the mass operator squares to the Gram
determinant with NO independent mass parameter — and the finite Dirac symbol
`H(k) = k sigma_z + Bz` obeys the hero identity `H(k)^2 = (k^2 + det P) 1`
with rest eigenvalues exactly `± |z| = ± sqrt(det P)`.

## Targets

1. `Bz_hermitian_odd` — `Bz` is Hermitian and anticommutes with `sigma_z`
   (odd with respect to the velocity grading).
2. `Bz_sq` — `Bz^2 = (|z|^2) • 1`, and for the spinor pair,
   `Bz(wedge)^2 = det P • 1` (the wedge-determinant identity in-bundle).
3. `hero_identity` — `H(k)^2 = (k^2 + det P) • 1` for every real `k`.
4. `rest_eigenvectors` — explicit rest eigenvectors: `Bz ![z, |z|] = |z| •
   ![z, |z|]` and `Bz ![z, -|z|] = (-|z|) • ![z, -|z|]`, nonzero when
   `z ≠ 0`: the rest gap is exactly `2|z| = 2 sqrt(det P)`.
5. `phase_covariance` — under `z -> exp(I theta) z` the operator transforms
   by the chiral unitary `U = diag(exp(I theta), 1)`:
   `B_{e^{i theta} z} = U * Bz * Uᴴ`, and `U` commutes with `sigma_z`, so the
   spectrum and the Dirac symbol class are phase independent.
6. `decomposition_independence` — a right-unitary change of the null
   decomposition `M -> M * V` (`V` unitary `2x2`) leaves `P = M * Mᴴ`
   unchanged and rescales the wedge by `det V` (a unit-modulus phase):
   `wedge(M * V) = det V * wedge(M)` and `|det V| = 1`.  Hence the
   unitary-equivalence class of `Bz` depends only on `P`.
7. `derived_evolution` — the derived one-parameter evolution
   `C(a) = cos(a ‖z‖) • 1 - (I sin(a ‖z‖)/‖z‖) • Bz` is unitary and obeys
   the exact group law `C(a) C(b) = C(a + b)`: the walk coin — including
   its orientation-sensitive corner phases — is DERIVED from the wedge
   coordinate, not supplied.  (Algebraic form of `exp(-i a Bz)`; the series
   identification is commentary, not a target.)
8. `collinear_control` — `z = 0` gives `Bz = 0` and `H(0) = 0`: the gap
   closes exactly on the collinear boundary.
9. `hermitian_uniqueness` — the Pro-strengthened uniqueness: a real quadratic
   form on Hermitian `2x2` matrices (coordinates `(p, q, r, s) <->
   !![p, r + I s; r - I s, q]`) vanishing on EVERY rank-one positive
   Hermitian matrix `v vᴴ` is a real multiple of the determinant form
   `p q - r^2 - s^2`.  (Coefficient extraction by explicit `v` choices, as
   in the landed symmetric version; this is the Hermitian upgrade.)

Honest scope: two-spinor construction; the `N > 2` Plücker-Clifford lift
(odd `B(w)` with `B(w)^2 = |w|^2` from the full wedge vector) is the named
next rung, not claimed.  Do not weaken statements; report any false-looking
clause.  Run `lake env lean PlueckerMassOperator/BzOperator.lean` first.
Recovered from Aristotle project `c8b24c90-9957-40a3-aa57-8f34fddb8286`; statements audited unchanged
and proof bodies verified locally under the pinned toolchain before porting.
-/

namespace PhysicsSM.Draft.NullEdge.PlueckerMassOperator

open Matrix

/-- Pauli Z (the velocity/chirality grading). -/
def sigmaZ : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- The Plücker mass operator of a complex wedge coordinate. -/
def Bz (z : ℂ) : Matrix (Fin 2) (Fin 2) ℂ := !![0, z; starRingEnd ℂ z, 0]

/-- The finite Dirac symbol with derived mass term. -/
noncomputable def Hsym (z : ℂ) (k : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  (k : ℂ) • sigmaZ + Bz z

/-- The spinor wedge. -/
def wedge (ψ φ : Fin 2 → ℂ) : ℂ := ψ 0 * φ 1 - ψ 1 * φ 0

/-- The Gram matrix of the pair. -/
def P (ψ φ : Fin 2 → ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  Matrix.of fun i j => ψ i * starRingEnd ℂ (ψ j) + φ i * starRingEnd ℂ (φ j)

/-- Target 1: Hermitian and odd. -/
theorem Bz_hermitian_odd (z : ℂ) :
    (Bz z)ᴴ = Bz z ∧ Bz z * sigmaZ = -(sigmaZ * Bz z) := by
  constructor
  · ext i j; fin_cases i <;> fin_cases j <;> simp [Bz]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [Bz, sigmaZ, Matrix.mul_apply, Fin.sum_univ_two]

/-- Target 2: the operator squares to the determinant. -/
theorem Bz_sq (ψ φ : Fin 2 → ℂ) :
    Bz (wedge ψ φ) * Bz (wedge ψ φ) = (P ψ φ).det • (1 : Matrix (Fin 2) (Fin 2) ℂ) ∧
    (P ψ φ).det = (Complex.normSq (wedge ψ φ) : ℂ) := by
  have hdet : (P ψ φ).det = (Complex.normSq (wedge ψ φ) : ℂ) := by
    rw [← Complex.mul_conj]
    simp only [P, wedge, det_fin_two, Matrix.of_apply, map_sub, map_mul]
    ring
  refine ⟨?_, hdet⟩
  rw [hdet, ← Complex.mul_conj]
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Bz, wedge, Matrix.mul_apply, Fin.sum_univ_two] <;> ring

/-- Target 3: the hero identity. -/
theorem hero_identity (ψ φ : Fin 2 → ℂ) (k : ℝ) :
    Hsym (wedge ψ φ) k * Hsym (wedge ψ φ) k =
      (((k : ℂ) ^ 2 + (P ψ φ).det)) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  have hdet : (P ψ φ).det = (wedge ψ φ) * starRingEnd ℂ (wedge ψ φ) := by
    simp only [P, wedge, det_fin_two, Matrix.of_apply, map_sub, map_mul]
    ring
  rw [hdet]
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Hsym, sigmaZ, Bz, wedge, Matrix.mul_apply, Fin.sum_univ_two,
      Matrix.smul_apply] <;> ring

/-- Target 4: explicit rest eigenvectors with eigenvalues `± |z|`. -/
theorem rest_eigenvectors (z : ℂ) :
    (Bz z).mulVec ![z, (‖z‖ : ℂ)] =
      (‖z‖ : ℂ) • ![z, (‖z‖ : ℂ)] ∧
    (Bz z).mulVec ![z, -(‖z‖ : ℂ)] =
      (-(‖z‖ : ℂ)) • ![z, -(‖z‖ : ℂ)] ∧
    (z ≠ 0 → ![z, (‖z‖ : ℂ)] ≠ 0) := by
  have hzz : starRingEnd ℂ z * z = ((‖z‖ : ℂ)) * (‖z‖ : ℂ) := by
    rw [mul_comm, Complex.mul_conj]; norm_cast
    rw [Complex.normSq_eq_norm_sq]; ring
  refine ⟨?_, ?_, ?_⟩
  · ext i; fin_cases i <;>
      simp [Bz, Matrix.mulVec, dotProduct, Fin.sum_univ_two] <;> ring_nf <;>
      rw [hzz] <;> ring
  · ext i; fin_cases i <;>
      simp [Bz, Matrix.mulVec, dotProduct, Fin.sum_univ_two] <;> ring_nf <;>
      rw [hzz] <;> ring
  · intro hz hcontra
    have h0 : (![z, (‖z‖ : ℂ)]) 0 = 0 := by rw [hcontra]; rfl
    simp only [Matrix.cons_val_zero] at h0
    exact hz h0

/-- Target 5: phase covariance by a chiral unitary commuting with the
velocity grading. -/
theorem phase_covariance (z : ℂ) (θ : ℝ) :
    Bz (Complex.exp (Complex.I * θ) * z) =
      !![Complex.exp (Complex.I * θ), 0; 0, 1] * Bz z *
        (!![Complex.exp (Complex.I * θ), 0; 0, 1])ᴴ ∧
    !![Complex.exp (Complex.I * θ), 0; 0, 1] * sigmaZ =
      sigmaZ * !![Complex.exp (Complex.I * θ), 0; 0, 1] ∧
    !![Complex.exp (Complex.I * θ), 0; 0, 1] *
        (!![Complex.exp (Complex.I * θ), 0; 0, 1])ᴴ = 1 := by
  have hconj : starRingEnd ℂ (Complex.exp (Complex.I * θ)) = Complex.exp (-(Complex.I * θ)) := by
    rw [← Complex.exp_conj]; congr 1; simp [Complex.conj_I]
  have hunit : Complex.exp (Complex.I * θ) * Complex.exp (-(Complex.I * θ)) = 1 := by
    rw [← Complex.exp_add]; simp
  refine ⟨?_, ?_, ?_⟩
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [Bz, Matrix.mul_apply, Fin.sum_univ_two, hconj, map_mul] <;> ring_nf
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [sigmaZ, Matrix.mul_apply, Fin.sum_univ_two]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_two, hconj, hunit]

/-- Target 6: decomposition independence.  Assembling the pair as the columns
of `M`, a right-unitary change of decomposition fixes `P` and rescales the
wedge by the unit-modulus `det V`. -/
theorem decomposition_independence (M V : Matrix (Fin 2) (Fin 2) ℂ)
    (hV : V * Vᴴ = 1) :
    (M * V) * (M * V)ᴴ = M * Mᴴ ∧
    (M * V).det = V.det * M.det ∧
    ‖V.det‖ = 1 := by
  refine ⟨?_, ?_, ?_⟩
  · rw [Matrix.conjTranspose_mul]
    rw [show M * V * (Vᴴ * Mᴴ) = M * (V * Vᴴ) * Mᴴ by noncomm_ring]
    rw [hV]; simp
  · rw [Matrix.det_mul, mul_comm]
  · have hdet : V.det * starRingEnd ℂ (V.det) = 1 := by
      have := congrArg Matrix.det hV
      rw [Matrix.det_mul, Matrix.det_conjTranspose, Matrix.det_one] at this
      exact this
    have hns : Complex.normSq V.det = 1 := by
      have := Complex.mul_conj V.det
      rw [hdet] at this
      exact_mod_cast this.symm
    rw [Complex.normSq_eq_norm_sq] at hns
    nlinarith [norm_nonneg V.det, hns]

/-- The derived one-parameter evolution generated by the mass operator. -/
noncomputable def Cw (z : ℂ) (a : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  (Complex.cos (a * ‖z‖)) • (1 : Matrix (Fin 2) (Fin 2) ℂ) -
    (Complex.I * Complex.sin (a * ‖z‖) / (‖z‖ : ℂ)) • Bz z

/-- Target 7: the derived evolution is unitary and a one-parameter group:
the walk coin comes from z, with no supplied corner parameter. -/
theorem derived_evolution (z : ℂ) (hz : z ≠ 0) (a b : ℝ) :
    Cw z a * (Cw z a)ᴴ = 1 ∧ Cw z a * Cw z b = Cw z (a + b) := by
  have hn : (‖z‖ : ℂ) ≠ 0 := by
    simp only [ne_eq, Complex.ofReal_eq_zero, norm_eq_zero]; exact hz
  have hzz1 : starRingEnd ℂ z * z = (‖z‖ : ℂ) * (‖z‖ : ℂ) := by
    rw [mul_comm, Complex.mul_conj]; norm_cast; rw [Complex.normSq_eq_norm_sq]; ring
  have hzz2 : z * starRingEnd ℂ z = (‖z‖ : ℂ) * (‖z‖ : ℂ) := by
    rw [Complex.mul_conj]; norm_cast; rw [Complex.normSq_eq_norm_sq]; ring
  constructor
  · -- unitarity: `C(a) C(a)ᴴ = 1`
    have hcc : starRingEnd ℂ (Complex.cos (↑a * ↑‖z‖)) = Complex.cos (↑a * ↑‖z‖) := by
      rw [← Complex.ofReal_mul, ← Complex.ofReal_cos, Complex.conj_ofReal]
    have hss : starRingEnd ℂ (Complex.sin (↑a * ↑‖z‖)) = Complex.sin (↑a * ↑‖z‖) := by
      rw [← Complex.ofReal_mul, ← Complex.ofReal_sin, Complex.conj_ofReal]
    have hpyth : Complex.cos (↑a * ↑‖z‖) * Complex.cos (↑a * ↑‖z‖)
        + Complex.sin (↑a * ↑‖z‖) * Complex.sin (↑a * ↑‖z‖) = 1 := by
      have := Complex.sin_sq_add_cos_sq (↑(a * ‖z‖) : ℂ)
      push_cast at this ⊢
      ring_nf; ring_nf at this; linear_combination this
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [Cw, Bz, Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply,
        Matrix.sub_apply, Matrix.smul_apply, sub_apply, map_mul, map_div₀,
        Complex.conj_I, hcc, hss] <;>
      field_simp <;>
      first
      | linear_combination (↑‖z‖ : ℂ) ^ 2 * hpyth
          + (-(Complex.sin (↑a * ↑‖z‖)) ^ 2 * Complex.I ^ 2) * hzz2
          + (-(Complex.sin (↑a * ↑‖z‖)) ^ 2 * (↑‖z‖ : ℂ) ^ 2) * Complex.I_sq
      | linear_combination (↑‖z‖ : ℂ) ^ 2 * hpyth
          + (-(Complex.sin (↑a * ↑‖z‖)) ^ 2 * Complex.I ^ 2) * hzz1
          + (-(Complex.sin (↑a * ↑‖z‖)) ^ 2 * (↑‖z‖ : ℂ) ^ 2) * Complex.I_sq
      | ring
  · -- group law: `C(a) C(b) = C(a + b)` via the angle-addition formulas
    have hca : Complex.cos ((↑a + ↑b : ℂ) * ↑‖z‖) =
        Complex.cos (↑a * ↑‖z‖) * Complex.cos (↑b * ↑‖z‖)
          - Complex.sin (↑a * ↑‖z‖) * Complex.sin (↑b * ↑‖z‖) := by
      rw [add_mul, Complex.cos_add]
    have hsa : Complex.sin ((↑a + ↑b : ℂ) * ↑‖z‖) =
        Complex.sin (↑a * ↑‖z‖) * Complex.cos (↑b * ↑‖z‖)
          + Complex.cos (↑a * ↑‖z‖) * Complex.sin (↑b * ↑‖z‖) := by
      rw [add_mul, Complex.sin_add]
    ext i j; fin_cases i <;> fin_cases j
    all_goals simp [Cw, Bz, Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply,
        Matrix.sub_apply, Matrix.smul_apply, sub_apply, hca, hsa]
    all_goals set ca := Complex.cos (↑a * ↑‖z‖)
    all_goals set cb := Complex.cos (↑b * ↑‖z‖)
    all_goals set sa := Complex.sin (↑a * ↑‖z‖)
    all_goals set sb := Complex.sin (↑b * ↑‖z‖)
    all_goals clear_value ca cb sa sb
    all_goals field_simp
    all_goals
      first
      | linear_combination (sa * sb * Complex.I ^ 2) * hzz2
          + (sa * sb * (↑‖z‖ : ℂ) ^ 2) * Complex.I_sq
      | linear_combination (sa * sb * Complex.I ^ 2) * hzz1
          + (sa * sb * (↑‖z‖ : ℂ) ^ 2) * Complex.I_sq
      | ring

/-- Target 8: the collinear boundary closes the gap. -/
theorem collinear_control :
    Bz 0 = 0 ∧ Hsym 0 0 = 0 ∧
    (∀ ψ : Fin 2 → ℂ, wedge ψ ψ = 0) := by
  refine ⟨?_, ?_, ?_⟩
  · ext i j; fin_cases i <;> fin_cases j <;> simp [Bz]
  · ext i j; fin_cases i <;> fin_cases j <;> simp [Hsym, Bz, sigmaZ]
  · intro ψ; simp only [wedge]; ring

/-- Target 9: Hermitian uniqueness of the determinant.  A real quadratic form
in the coordinates `(p, q, r, s)` of a Hermitian matrix that vanishes on
every rank-one positive Hermitian `v vᴴ` is a real multiple of
`p q - r^2 - s^2`. -/
theorem hermitian_uniqueness
    (Q : ℝ → ℝ → ℝ → ℝ → ℝ)
    (hquad : ∃ c : Fin 10 → ℝ, ∀ p q r s,
      Q p q r s = c 0 * p ^ 2 + c 1 * q ^ 2 + c 2 * r ^ 2 + c 3 * s ^ 2 +
        c 4 * p * q + c 5 * p * r + c 6 * p * s + c 7 * q * r +
        c 8 * q * s + c 9 * r * s)
    (hnull : ∀ v : Fin 2 → ℂ,
      Q (Complex.normSq (v 0)) (Complex.normSq (v 1))
        ((v 0 * starRingEnd ℂ (v 1)).re) ((v 0 * starRingEnd ℂ (v 1)).im) = 0) :
    ∃ a : ℝ, ∀ p q r s, Q p q r s = a * (p * q - r ^ 2 - s ^ 2) := by
  obtain ⟨c, hc⟩ := hquad
  have e1 := hnull ![1, 0]
  have e2 := hnull ![0, 1]
  have e3 := hnull ![1, 1]
  have e4 := hnull ![1, -1]
  have e5 := hnull ![1, Complex.I]
  have e6 := hnull ![1, -Complex.I]
  have e7 := hnull ![2, 1]
  have e8 := hnull ![2, Complex.I]
  have e9 := hnull ![1, 1 - Complex.I]
  simp only [hc] at e1 e2 e3 e4 e5 e6 e7 e8 e9
  simp [Complex.normSq] at e1 e2 e3 e4 e5 e6 e7 e8 e9
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9
  have hc0 : c 0 = 0 := by linarith
  have hc1 : c 1 = 0 := by linarith
  have hc5 : c 5 = 0 := by linarith
  have hc7 : c 7 = 0 := by linarith
  have hc6 : c 6 = 0 := by linarith
  have hc8 : c 8 = 0 := by linarith
  have hc2 : c 2 = -c 4 := by linarith
  have hc3 : c 3 = -c 4 := by linarith
  have hc9 : c 9 = 0 := by linarith
  refine ⟨c 4, fun p q r s => ?_⟩
  rw [hc, hc0, hc1, hc2, hc3, hc5, hc6, hc7, hc8, hc9]
  ring

end PhysicsSM.Draft.NullEdge.PlueckerMassOperator

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerMassOperator.Bz_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerMassOperator.Bz_sq

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerMassOperator.hero_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerMassOperator.hero_identity

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerMassOperator.rest_eigenvectors' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerMassOperator.rest_eigenvectors

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerMassOperator.decomposition_independence' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerMassOperator.decomposition_independence

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerMassOperator.derived_evolution' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerMassOperator.derived_evolution

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerMassOperator.hermitian_uniqueness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerMassOperator.hermitian_uniqueness
