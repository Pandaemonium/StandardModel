import Mathlib

/-!
# The null-chain joint witness: one carrier, every arrow

Closure target for the whole-theory Composition test.  Every arrow of the
chain (primitive null data -> gauge class -> positive state -> spectral mass
-> dynamics -> benchmark -> falsifier) is separately kernel-checked in the
parent repository, but on DIFFERENT carriers.  This package ties the chain to
ONE explicit carrier: the three-dimensional Kugo-Ojima/positive-Hodge witness
`Q = !![0,1,0;0,0,0;0,0,0]`, `J = !![0,1,0;1,0,0;0,0,1]` (a Krein involution
pairing the null gauge pair e0,e1 and fixing the physical e2),
`D mu = diag(0,0,mu)`, and the surviving class `e2`, joined to the primitive
spinor pair `psi = (mu,0)`, `phi = (0,1)` whose Gram determinant is `mu^2`,
and to the checkerboard walk symbol at the SAME mass.

## Targets

C1 `null_chain_carrier_spectrum` (primitive -> quotient -> positive ->
spectral, one scalar): the Gram determinant of the explicit pair equals
`mu^2` and equals the squared wedge (Cauchy-Binet instance); `Q` is nilpotent;
`e2` is closed, NOT exact, harmonic for the Hilbert constraint Laplacian
`Q^H Q + Q Q^H`, and Krein-POSITIVE (`<e2, J e2> = 1`); the Krein spectral
square `(J D^H J) D` has `e2` as eigenvector with the SAME eigenvalue `mu^2`;
and every chain-homotopy shift `D + QR + RQ` moves `D e2` only by an exact
vector (channel-gauge invariance of the physical action).

C2 `null_chain_dirac_benchmark` (spectral -> dynamics -> benchmark ->
falsifier, same `mu`): the walk symbol `U(k, mu) = e^{-ik sigma_z} e^{-i mu
sigma_x}` (explicit closed form below) has trace `2 cos k cos mu`,
determinant `1`, and is unitary; on the shell `E^2 = p^2 + mu^2` the group
speed squared `p^2/(p^2+mu^2)` is strictly below `1` for `mu /= 0`; and the
per-edge Lipschitz (Connes) distance across one edge of local scale `mu` is
exactly `1/mu` (`IsGreatest` packaging): the Compton length of the SAME mass.

SEAM `null_chain_seam_witness` (mu = 4): one conjunction displaying the single
scalar through the whole chain: `det P = 16`, spectral eigenvalue `16`, group
speed `9/25` at `p = 3` (the 3-4-5 shell), Compton length `1/4`.

NEGATIVE CONTROLS in-bundle: `e2` non-exactness (the chain fails on exact
representatives); strict subluminality fails only at `mu = 0`.

Honest scope: finite witness composition; no continuum limit, no position-
space walk, no derivation of the decoder.  Do not weaken the statements.
Helper lemmas welcome.  Run the narrow check
`lake env lean NullChainJointWitness/NullChainWitness.lean` first; avoid a
full lake build until the holes are closed.
Recovered from Aristotle project `9014b77f-94d0-4ddf-b6f2-62e99b1ba187`; statements audited unchanged
against the submitted originals and proof bodies verified locally under the
pinned toolchain before porting.
-/

namespace PhysicsSM.Draft.NullEdge.NullChainJointWitness

open Matrix

/-- The finite constraint differential of the witness. -/
def Qc : Matrix (Fin 3) (Fin 3) ℂ := !![0, 1, 0; 0, 0, 0; 0, 0, 0]

/-- The Krein involution: null gauge pair `e0, e1`, positive physical `e2`. -/
def Jc : Matrix (Fin 3) (Fin 3) ℂ := !![0, 1, 0; 1, 0, 0; 0, 0, 1]

/-- The spectral decoder supported on the physical class. -/
noncomputable def Dm (mu : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  !![0, 0, 0; 0, 0, 0; 0, 0, (mu : ℂ)]

/-- The surviving physical class representative. -/
def e2 : Fin 3 → ℂ := ![0, 0, 1]

/-- Krein adjoint with respect to the involution `Jc`. -/
noncomputable def kreinAdj (A : Matrix (Fin 3) (Fin 3) ℂ) :
    Matrix (Fin 3) (Fin 3) ℂ := Jc * Aᴴ * Jc

/-- The primitive spinor pair whose disagreement carries the scalar. -/
noncomputable def psi (mu : ℝ) : Fin 2 → ℂ := ![(mu : ℂ), 0]

/-- The second primitive spinor. -/
def phi : Fin 2 → ℂ := ![0, 1]

/-- The positive momentum Gram matrix of the pair. -/
noncomputable def P (mu : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  Matrix.of fun i j => psi mu i * star (psi mu j) + phi i * star (phi j)

/-- The spinor wedge of the pair. -/
noncomputable def wedge (mu : ℝ) : ℂ :=
  psi mu 0 * phi 1 - psi mu 1 * phi 0

/-- The explicit checkerboard walk symbol `e^{-ik sigma_z} e^{-im sigma_x}`
in closed form. -/
noncomputable def walkU (k m : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![Complex.exp (-(Complex.I * k)), 0; 0, Complex.exp (Complex.I * k)] *
    !![Complex.cos m, -(Complex.I * Complex.sin m);
       -(Complex.I * Complex.sin m), Complex.cos m]

/-! ## C1 helper lemmas -/

/-
The Gram determinant equals `mu^2`.
-/
lemma Pdet (mu : ℝ) : (P mu).det = (mu : ℂ) ^ 2 := by
  unfold P;
  unfold psi phi; norm_num [ Fin.sum_univ_succ, Matrix.det_succ_row_zero ] ; ring;

/-
The Gram determinant equals the squared wedge (Cauchy-Binet).
-/
lemma Pdet_wedge (mu : ℝ) : (P mu).det = wedge mu * star (wedge mu) := by
  convert Pdet mu;
  unfold wedge psi phi; norm_num; ring;

/-
`Q` is nilpotent.
-/
lemma Qc_sq : Qc * Qc = 0 := by
  ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ Qc ]

/-
`e2` is closed.
-/
lemma Qc_mulVec_e2 : Qc.mulVec e2 = 0 := by
  ext i; fin_cases i <;> norm_num [ Qc, e2, Matrix.mulVec ] ;

/-
`e2` is not exact: the range of `Q` is spanned by `e0`.
-/
lemma e2_not_exact : ¬ ∃ x : Fin 3 → ℂ, Qc.mulVec x = e2 := by
  norm_num [ ← List.ofFn_inj, Qc, e2 ]

/-
`e2` is harmonic for the constraint Laplacian.
-/
lemma laplacian_e2 : (Qcᴴ * Qc + Qc * Qcᴴ).mulVec e2 = 0 := by
  ext i;
  fin_cases i <;> norm_num [ Matrix.mul_apply, Matrix.mulVec ];
  · simp +decide [ dotProduct, Fin.sum_univ_succ, Qc, e2 ];
  · simp +decide [ Qc, e2, dotProduct ];
    norm_num [ Fin.sum_univ_succ ];
  · simp +decide [ Qc, e2, dotProduct ];
    norm_num [ Fin.sum_univ_succ ]

/-
`e2` is Krein-positive.
-/
lemma krein_pos : star e2 ⬝ᵥ Jc.mulVec e2 = 1 := by
  norm_num [ e2, Jc, dotProduct ];
  simp +decide [ Fin.sum_univ_succ, vecHead, vecTail ]

/-
The Krein spectral square has `e2` as eigenvector with eigenvalue `mu^2`.
-/
lemma krein_spectral (mu : ℝ) :
    (kreinAdj (Dm mu) * Dm mu).mulVec e2 = ((mu : ℂ) ^ 2) • e2 := by
      ext i;
      fin_cases i <;> simp +decide [ Matrix.mulVec, Matrix.mul_apply, kreinAdj, Dm, e2 ]
      · simp +decide [ vecHead, vecTail, Fin.sum_univ_succ ];
        exact Or.inl <| Or.inl <| Or.inl <| by rfl;
      · simp +decide [ Fin.sum_univ_succ, vecHead, vecTail ];
        exact Or.inl <| Or.inl <| Or.inl <| by rfl;
      · simp +decide [ Jc, vecHead, vecTail, Fin.sum_univ_succ ] ; ring

/-
Every chain-homotopy shift moves `D e2` only by an exact vector.
-/
lemma homotopy_exact (mu : ℝ) (R : Matrix (Fin 3) (Fin 3) ℂ) :
    ∃ z : Fin 3 → ℂ,
      ((Dm mu + (Qc * R + R * Qc)) - Dm mu).mulVec e2 = Qc.mulVec z := by
        use R.mulVec e2;
        simp +decide [ Matrix.add_mulVec ];
        convert congr_arg ( fun x => R.mulVec x ) ( Qc_mulVec_e2 ) using 1;
        · rw [ Matrix.mulVec_mulVec ];
        · norm_num

/-! ## C2 helper lemmas -/

/-
Trace at `k = 0`.
-/
lemma walk_trace0 (mu : ℝ) : (walkU 0 mu).trace = 2 * Complex.cos mu := by
  unfold walkU; norm_num; ring;

/-
Trace of the walk symbol.
-/
lemma walk_trace (k mu : ℝ) :
    (walkU k mu).trace = 2 * Complex.cos k * Complex.cos mu := by
      unfold walkU;
      norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im, Complex.cos ] ; ring

/-
Determinant of the walk symbol.
-/
lemma walk_det (k mu : ℝ) : (walkU k mu).det = 1 := by
  unfold walkU; norm_num; ring ;
  norm_num [ Complex.sin_sq, Complex.cos_sq, mul_assoc, mul_left_comm, ← Complex.exp_add ] ; ring;
  norm_num [ mul_assoc, ← Complex.exp_add ]

/-
The walk symbol is unitary.
-/
lemma walk_unitary (k mu : ℝ) : walkU k mu * (walkU k mu)ᴴ = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [ walkU, Complex.ext_iff, Matrix.vecMul, Matrix.mul_apply ] at *;
  · norm_num [ Complex.exp_re, Complex.exp_im, Complex.cos, Complex.sin ] ; ring_nf
    norm_num [ Real.sin_sq, Real.cos_sq ] ; ring_nf
  · grind +revert;
  · grind;
  · norm_num [ Complex.exp_re, Complex.exp_im, Complex.sin_ofReal_re,
      Complex.cos_ofReal_re ] ; ring
    norm_num [ Real.sin_sq, Real.cos_sq ] ; ring;

/-
Strict subluminality for `mu /= 0`.
-/
lemma subluminal (p mu : ℝ) (h : mu ≠ 0) : p ^ 2 / (p ^ 2 + mu ^ 2) < 1 := by
  rw [ div_lt_iff₀ ] <;> nlinarith [ mul_self_pos.2 h ]

/-
Compton length as a greatest one-edge Lipschitz displacement.
-/
lemma compton (mu : ℝ) (h : 0 < mu) :
    IsGreatest
      {d : ℝ | ∃ f : ℕ → ℝ, (∀ n, |f (n + 1) - f n| ≤ 1 / mu) ∧
        d = f 1 - f 0} (1 / mu) := by
          refine ⟨ ?_, fun x hx => ?_ ⟩;
          · use fun n => n / mu;
            norm_num [ add_div, abs_div, abs_of_pos h ];
          · exact hx.choose_spec.2.symm ▸ le_of_abs_le ( hx.choose_spec.1 0 )

/-! ## Main targets -/

/-- C1: primitive -> quotient -> positive -> spectral, on one carrier with
one scalar. -/
theorem null_chain_carrier_spectrum (mu : ℝ) :
    (P mu).det = (mu : ℂ) ^ 2 ∧
    (P mu).det = wedge mu * star (wedge mu) ∧
    Qc * Qc = 0 ∧
    Qc.mulVec e2 = 0 ∧
    (¬ ∃ x : Fin 3 → ℂ, Qc.mulVec x = e2) ∧
    (Qcᴴ * Qc + Qc * Qcᴴ).mulVec e2 = 0 ∧
    star e2 ⬝ᵥ Jc.mulVec e2 = 1 ∧
    (kreinAdj (Dm mu) * Dm mu).mulVec e2 = ((mu : ℂ) ^ 2) • e2 ∧
    (∀ R : Matrix (Fin 3) (Fin 3) ℂ, ∃ z : Fin 3 → ℂ,
      ((Dm mu + (Qc * R + R * Qc)) - Dm mu).mulVec e2 = Qc.mulVec z) :=
  ⟨Pdet mu, Pdet_wedge mu, Qc_sq, Qc_mulVec_e2, e2_not_exact, laplacian_e2,
    krein_pos, krein_spectral mu, fun R => homotopy_exact mu R⟩

/-- C2: spectral -> dynamics -> benchmark -> falsifier, at the same mass. -/
theorem null_chain_dirac_benchmark (mu : ℝ) :
    (walkU 0 mu).trace = 2 * Complex.cos mu ∧
    (∀ k : ℝ, (walkU k mu).trace = 2 * Complex.cos k * Complex.cos mu) ∧
    (∀ k : ℝ, (walkU k mu).det = 1) ∧
    (∀ k : ℝ, walkU k mu * (walkU k mu)ᴴ = 1) ∧
    (∀ p : ℝ, mu ≠ 0 → p ^ 2 / (p ^ 2 + mu ^ 2) < 1) ∧
    (0 < mu → IsGreatest
      {d : ℝ | ∃ f : ℕ → ℝ, (∀ n, |f (n + 1) - f n| ≤ 1 / mu) ∧
        d = f 1 - f 0} (1 / mu)) :=
  ⟨walk_trace0 mu, fun k => walk_trace k mu, fun k => walk_det k mu,
    fun k => walk_unitary k mu, fun p h => subluminal p mu h,
    fun h => compton mu h⟩

/-- The seam at `mu = 4`: one scalar through the whole chain — Gram
determinant `16`, spectral eigenvalue `16`, group speed `9/25` on the 3-4-5
shell, Compton length `1/4`. -/
theorem null_chain_seam_witness :
    (P 4).det = 16 ∧
    (kreinAdj (Dm 4) * Dm 4).mulVec e2 = (16 : ℂ) • e2 ∧
    (3 : ℝ) ^ 2 / (3 ^ 2 + 4 ^ 2) = 9 / 25 ∧
    IsGreatest
      {d : ℝ | ∃ f : ℕ → ℝ, (∀ n, |f (n + 1) - f n| ≤ 1 / 4) ∧
        d = f 1 - f 0} (1 / 4) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [Pdet]; norm_num
  · have := krein_spectral 4
    rw [this]; norm_num
  · norm_num
  · have := compton 4 (by norm_num)
    norm_num at this ⊢
    convert this using 2
end PhysicsSM.Draft.NullEdge.NullChainJointWitness

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NullChainJointWitness.null_chain_carrier_spectrum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NullChainJointWitness.null_chain_carrier_spectrum

/-- info: 'PhysicsSM.Draft.NullEdge.NullChainJointWitness.null_chain_dirac_benchmark' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NullChainJointWitness.null_chain_dirac_benchmark

/-- info: 'PhysicsSM.Draft.NullEdge.NullChainJointWitness.null_chain_seam_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NullChainJointWitness.null_chain_seam_witness
