/-
Provenance: Aristotle job fcd99149 (fable-24h-schurjet), harvested
2026-07-12 ~00:55 PDT. KERNEL-ONLY throughout (the jets landed
algebraically: U(q0 + t e_j) = cos t * U0 + sin t * D_j, so no
analysis entered). Closes hostile2's #1 finding: at the central node
the walk symbol's structure (involution, traceless, dim-2 kernels both
gaps), the exact directional-derivative compressions, the 3x3 Jacobian
(4/5)diag(1,-1,1) with the load-bearing gap-orientation factor s, the
naming bridge J_recorded = -J_here against the landed census fixtures,
and the per-node Floquet opposition are all DERIVED from the symbol.
Gated oracle: schur_gate_out.txt + schur_gate2_out.txt (2026-07-11).
-/
import Mathlib

/-!
# Split-step Schur jet: deriving the crossing-census Jacobians from the walk symbol

This module closes the audit gap "nothing machine-checked ties the charge census to
the walk" for the central crossing node of the null-edge Paper A massive split-step
walk.  Everything here is **derived from the walk symbol** `U`, not supplied.

## The gated oracle conventions (reproduced here as Lean definitions)

The walk symbol is
`U(qx,qy,qz) = E(β,θ45) · E(α₃,qz) · E(α₂,qy) · E(α₁,qx)`,
with `E(M,t) = cos t · 1 + i sin t · M` (each `M` an involution) and the 3-4-5 coin
`E(β,θ45) = (4/5) · 1 + (3/5) i β` (`cos θ45 = 4/5`, `sin θ45 = 3/5`; no transcendental
is needed to name the coin).  The Dirac generators `α₁,α₂,α₃,β` are copied VERBATIM
from `context/Pluecker3Plus1ComplexMass.lean` (the live representation).

## Targets

* **T1 (exact node structure).**  At the central node `q0 = (π/2,π/2,π/2)` the symbol is
  the exact matrix `U0 = ((4/5) + (3/5) i β) · (i α₃) · (i α₂) · (i α₁)`.  We prove
  `dim ker (U0 - 1) = 2` and `dim ker (U0 + 1) = 2`.  `U0` is Hermitian and unitary,
  hence an involution with trace `0`; the kernel dimensions are read off as the traces
  of the spectral projectors `(1 ± U0)/2` (the certificate route).

* **T2 (the jet).**  `U0` is unitary hence normal, so each eigenspace `ker (U0 ∓ 1)` is
  reducing and the Schur complement's first-order jet is the compression
  `V0ᴴ · Dⱼ · V0`, where `V0` is an orthonormal kernel basis and `Dⱼ = ∂U/∂qⱼ` at `q0`.
  Differentiating the product, only the `j`-th factor contributes; the exact jet is the
  algebraic identity `U(q0 + t·eⱼ) = cos t · U0 + sin t · Dⱼ`, so `Dⱼ` is literally the
  coefficient of the linear term.  We then prove the real `3×3` Jacobian
  `J[a,j] = -(s/2) · Im tr(σₐ · V0ᴴ Dⱼ V0)` equals `(4/5)·diag(1,-1,1)` at `(q0, gap +1)`
  and flips sign with the **load-bearing gap-orientation factor** `s` (`s = +1` at gap 0,
  `s = -1` at gap π).  This matches, up to the documented naming `J_recorded = -J_here`,
  the landed census module's `Jplus`/`Jminus`.

* **T3 (the tie).**  Consequently `chargeOf (J at q0, gap 0)` and
  `chargeOf (J at q0, gap π)` are opposite: the landed `census_floquet_opposition`
  instance at this node is now *derived* from the walk symbol.

All arithmetic is Gaussian-rational (the `1/√2` normalisations cancel to `1/2`).
Kernel only.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.SplitStepSchurJet

abbrev Mat4 := Matrix (Fin 4) (Fin 4) ℂ

/-! ## Dirac generators (VERBATIM from `context/Pluecker3Plus1ComplexMass.lean`) -/

def alpha1 : Mat4 :=
  !![0, 0, 0, 1; 0, 0, 1, 0; 0, 1, 0, 0; 1, 0, 0, 0]

def alpha2 : Mat4 :=
  !![0, 0, 0, -I; 0, 0, I, 0; 0, -I, 0, 0; I, 0, 0, 0]

def alpha3 : Mat4 :=
  !![0, 0, 1, 0; 0, 0, 0, -1; 1, 0, 0, 0; 0, -1, 0, 0]

def beta : Mat4 :=
  !![1, 0, 0, 0; 0, 1, 0, 0; 0, 0, -1, 0; 0, 0, 0, -1]

/-! ## The walk symbol -/

/-- The elementary walk factor `E(M,t) = cos t · 1 + i sin t · M`. -/
def E (M : Mat4) (t : ℝ) : Mat4 :=
  (Real.cos t : ℂ) • (1 : Mat4) + ((I : ℂ) * (Real.sin t : ℂ)) • M

/-- The exact 3-4-5 mass coin `E(β,θ45) = (4/5) · 1 + (3/5) i β`. -/
def Bmat : Mat4 := ((4 : ℂ) / 5) • (1 : Mat4) + (((3 : ℂ) / 5) * I) • beta

/-- The walk symbol `U(qx,qy,qz)`. -/
def U (qx qy qz : ℝ) : Mat4 := Bmat * E alpha3 qz * E alpha2 qy * E alpha1 qx

/-- The exact symbol at the central node `q0 = (π/2,π/2,π/2)`. -/
def U0 : Mat4 := Bmat * (I • alpha3) * (I • alpha2) * (I • alpha1)

/-- `E(M,π/2) = i·M`. -/
lemma E_pi_div_two (M : Mat4) : E M (Real.pi / 2) = I • M := by
  simp [E, Real.cos_pi_div_two, Real.sin_pi_div_two]

/-- The symbol at the central node is `U0`. -/
lemma walkNode : U (Real.pi / 2) (Real.pi / 2) (Real.pi / 2) = U0 := by
  simp only [U, U0, E_pi_div_two]

/-- The exact Gaussian-rational form of `U0`.  With `w = 4/5 + (3/5) i` (a unit),
`U0` has `(0,2) = (1,3) = -w` and `(2,0) = (3,1) = -w̄`. -/
def U0mat : Mat4 :=
  !![0, 0, -(4/5) - (3/5) * I, 0;
     0, 0, 0, -(4/5) - (3/5) * I;
     -(4/5) + (3/5) * I, 0, 0, 0;
     0, -(4/5) + (3/5) * I, 0, 0]

lemma U0_eq : U0 = U0mat := by
  norm_num [ U0, U0mat, Bmat, alpha1, alpha2, alpha3, beta ];
  norm_num [ ← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply, Fin.sum_univ_succ ];
  norm_num [ Fin.ext_iff, Complex.ext_iff ]

/-
`U0` squares to the identity (Hermitian unitary ⇒ involution).
-/
lemma U0_mul_self : U0 * U0 = 1 := by
  rw [ U0_eq ];
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ, U0mat ] <;> ring_nf <;> norm_num [ Complex.ext_iff ]

/-
`U0` is traceless.
-/
lemma U0_trace : Matrix.trace U0 = 0 := by
  rw [ U0_eq ] ; norm_num [ U0mat, trace ];
  norm_num [ Fin.sum_univ_succ ]

/-! ## T1 — exact node structure: kernel dimensions via spectral projectors

`P± = (1 ± U0)/2` are idempotents (using `U0² = 1`); their ranges are `ker (U0 ∓ 1)`
and their (matrix) traces are `2`, hence each kernel has dimension `2`. -/

/-- Positive spectral projector. -/
def Pplus : Mat4 := (2 : ℂ)⁻¹ • ((1 : Mat4) + U0)

/-- Negative spectral projector. -/
def Pminus : Mat4 := (2 : ℂ)⁻¹ • ((1 : Mat4) - U0)

lemma Pplus_trace : Matrix.trace Pplus = 2 := by
  unfold Pplus;
  rw [ Matrix.trace_smul, Matrix.trace_add, Matrix.trace_one, U0_trace ] ; norm_num

lemma Pminus_trace : Matrix.trace Pminus = 2 := by
  unfold Pminus; norm_num [ U0_trace, Pplus_trace ] ;

/-
`(U0 - 1) · Pplus = 0`: the range of `Pplus` lies in `ker (U0 - 1)`.
-/
lemma gap0_proj_annihilates : (U0 - 1) * Pplus = 0 := by
  -- Expand the product and simplify using the fact that $U0^2 = 1$.
  ext i j; simp [Pplus, U0_mul_self]; ring;
  simp +decide [ Matrix.mul_add, Matrix.sub_mul, mul_assoc, U0_mul_self ] ; ring

/-
`(U0 + 1) · Pminus = 0`: the range of `Pminus` lies in `ker (U0 + 1)`.
-/
lemma gapPi_proj_annihilates : (U0 + 1) * Pminus = 0 := by
  unfold Pminus; simp +decide [ mul_sub ] ;
  simp_all +decide [ mul_assoc, add_mul, mul_add, one_mul, mul_one, sub_eq_zero ];
  rw [ U0_mul_self, add_comm ]

/-
**T1a.**  `dim ker (U0 - 1) = 2`.
-/
theorem kerDim_gap0 :
    Module.finrank ℂ (LinearMap.ker (Matrix.toLin' (U0 - 1))) = 2 := by
  -- Let `p := LinearMap.ker (Matrix.toLin' (U0 - 1))`.
  set p := LinearMap.ker (Matrix.toLin' (U0 - 1)) with hp;
  -- Let `f := Matrix.toLin' Pplus`.
  set f := Matrix.toLin' Pplus with hf;
  -- Show that `f` is a projection onto `p`.
  have hproj : LinearMap.IsProj p f := by
    constructor;
    · intro x
      simp [hp, hf];
      convert congr_arg ( fun m => m.mulVec x ) ( gap0_proj_annihilates ) using 1;
      · simp +decide [ sub_mul, Matrix.sub_mulVec ];
      · norm_num;
    · intro x hx; simp_all +decide [ Matrix.toLin'_apply, Pplus ] ;
      rw [ sub_eq_zero.mp hx ] ; ext i ; norm_num ; ring;
  have htr := hproj.trace;
  rw [ ← @Nat.cast_inj ℂ ] ; push_cast ; rw [ ← htr, hf, Matrix.trace_toLin'_eq ] ; norm_num [ Pplus_trace ]

/-
**T1b.**  `dim ker (U0 + 1) = 2`.
-/
theorem kerDim_gapPi :
    Module.finrank ℂ (LinearMap.ker (Matrix.toLin' (U0 + 1))) = 2 := by
  have h_proj : LinearMap.IsProj (LinearMap.ker (Matrix.toLin' (U0 + 1))) (Matrix.toLin' Pminus) := by
    constructor;
    · intro x
      simp [Pminus];
      simp +decide [ Matrix.mulVec_sub, ← Matrix.mul_assoc, U0_mul_self ];
    · simp +decide [ Pminus, Matrix.toLin'_apply ];
      intro x hx; ext i; have := congr_fun hx i; norm_num at *;
      linear_combination' -this / 2;
  have := h_proj.trace;
  rw [ ← @Nat.cast_inj ℂ ] ; push_cast ; rw [ ← this ] ; erw [ Matrix.trace_toLin'_eq ] ; norm_num [ Pminus, Pminus_trace ] ;
  rw [ U0_trace ] ; norm_num

/-! ## T2 — the jet: directional derivatives of the walk symbol at `q0`

Differentiating the product, only the `j`-th factor `E(αⱼ, ·)` contributes. -/

/-- `∂U/∂qx` at `q0` (only the `α₁` factor is differentiated). -/
def Dq1 : Mat4 := -(Bmat * (I • alpha3) * (I • alpha2))

/-- `∂U/∂qy` at `q0`. -/
def Dq2 : Mat4 := -(Bmat * (I • alpha3) * (I • alpha1))

/-- `∂U/∂qz` at `q0`. -/
def Dq3 : Mat4 := -(Bmat * (I • alpha2) * (I • alpha1))

/-- The three directional derivatives. -/
def Dvec : Fin 3 → Mat4
  | 0 => Dq1
  | 1 => Dq2
  | 2 => Dq3

/-- Exact Gaussian-rational form of `Dq1`. -/
def Dq1mat : Mat4 :=
  !![0, 3/5 - 4/5 * I, 0, 0;
     3/5 - 4/5 * I, 0, 0, 0;
     0, 0, 0, -3/5 - 4/5 * I;
     0, 0, -3/5 - 4/5 * I, 0]

/-- Exact Gaussian-rational form of `Dq2`. -/
def Dq2mat : Mat4 :=
  !![0, 4/5 + 3/5 * I, 0, 0;
     -4/5 - 3/5 * I, 0, 0, 0;
     0, 0, 0, 4/5 - 3/5 * I;
     0, 0, -4/5 + 3/5 * I, 0]

/-- Exact Gaussian-rational form of `Dq3`. -/
def Dq3mat : Mat4 :=
  !![3/5 - 4/5 * I, 0, 0, 0;
     0, -3/5 + 4/5 * I, 0, 0;
     0, 0, -3/5 - 4/5 * I, 0;
     0, 0, 0, 3/5 + 4/5 * I]

lemma Dq1_eq : Dq1 = Dq1mat := by
  unfold Dq1 Dq1mat Bmat;
  simp +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply, Fin.sum_univ_succ ];
  simp +decide [ alpha1, alpha2, alpha3, beta ] at * ; ring_nf at * ; norm_num [ Complex.ext_iff, sq ] at *;

lemma Dq2_eq : Dq2 = Dq2mat := by
  ext i j;
  fin_cases i <;> fin_cases j <;> simp +decide [ Dq2, Dq2mat, Bmat, alpha3, alpha2, alpha1, beta, Matrix.mul_apply, Fin.sum_univ_four, Matrix.neg_apply, Matrix.add_apply, Matrix.smul_apply, Matrix.one_apply, Matrix.of_apply ];
  · norm_num [ Complex.ext_iff ];
  · norm_num [ Complex.ext_iff ];
  · ring ; norm_num;
  · norm_num [ Complex.ext_iff ]

lemma Dq3_eq : Dq3 = Dq3mat := by
  unfold Dq3 Dq3mat Bmat;
  ext i j;
  simp +decide [ Matrix.mul_apply, Fin.sum_univ_succ ];
  fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.one_apply, alpha1, alpha2, alpha3, beta ] <;> ring_nf <;> norm_num [ Complex.ext_iff, sq ] at *

/-
The exact shifted factor: `E(M, π/2 + t) = cos t · (i M) + sin t · (-(1))`.
-/
lemma E_shift (M : Mat4) (t : ℝ) :
    E M (Real.pi / 2 + t) = (Real.cos t : ℂ) • (I • M) + (Real.sin t : ℂ) • (-(1 : Mat4)) := by
  ext i j; simp +decide [ E, Real.cos_add, Real.sin_add ] ; ring

/-
**T2 jet, direction `x`.**  Exact first-order expansion; `Dq1` is the coefficient
of the linear (`sin t`) term.
-/
lemma jet_q1 (t : ℝ) :
    U (Real.pi / 2 + t) (Real.pi / 2) (Real.pi / 2)
      = (Real.cos t : ℂ) • U0 + (Real.sin t : ℂ) • Dq1 := by
  unfold U;
  simp +decide [ Dq1, U0, E_shift ];
  simp +decide [ E_pi_div_two, mul_add, add_mul, mul_assoc, mul_left_comm, smul_smul ]

/-
**T2 jet, direction `y`.**
-/
lemma jet_q2 (t : ℝ) :
    U (Real.pi / 2) (Real.pi / 2 + t) (Real.pi / 2)
      = (Real.cos t : ℂ) • U0 + (Real.sin t : ℂ) • Dq2 := by
  unfold U;
  rw [ E_pi_div_two, E_shift, E_pi_div_two ];
  simp +decide [ mul_add, add_mul, mul_assoc, Dq2, U0 ];
  ext i j ; norm_num ; ring

/-
**T2 jet, direction `z`.**
-/
lemma jet_q3 (t : ℝ) :
    U (Real.pi / 2) (Real.pi / 2) (Real.pi / 2 + t)
      = (Real.cos t : ℂ) • U0 + (Real.sin t : ℂ) • Dq3 := by
  unfold U Dq3;
  rw [ E_shift, E_pi_div_two, E_pi_div_two ];
  simp +decide [ U0, Matrix.mul_add, Matrix.add_mul, Matrix.mul_assoc, mul_assoc, mul_left_comm, smul_smul ];
  norm_num [ ← mul_assoc, ← Matrix.ext_iff ]

/-! ## T2 — orthonormal kernel bases and the compression Jacobian -/

/-- The unit `w = 4/5 + (3/5) i`. -/
def wq : ℂ := (4 / 5 : ℂ) + (3 / 5 : ℂ) * I

/-- Unnormalised kernel basis of `ker (U0 - 1)` (columns `(-w,0,1,0)`, `(0,-w,0,1)`). -/
def Wplus : Matrix (Fin 4) (Fin 2) ℂ := !![-wq, 0; 0, -wq; 1, 0; 0, 1]

/-- Unnormalised kernel basis of `ker (U0 + 1)` (columns `(w,0,1,0)`, `(0,w,0,1)`). -/
def Wminus : Matrix (Fin 4) (Fin 2) ℂ := !![wq, 0; 0, wq; 1, 0; 0, 1]

/-- `√2` as a complex scalar. -/
def rt2 : ℂ := (Real.sqrt 2 : ℂ)

lemma rt2_sq : rt2 * rt2 = 2 := by
  unfold rt2; norm_num [ ← Complex.ofReal_mul ] ;

/-- Orthonormal kernel basis at gap 0. -/
def V0plus : Matrix (Fin 4) (Fin 2) ℂ := rt2⁻¹ • Wplus

/-- Orthonormal kernel basis at gap π. -/
def V0minus : Matrix (Fin 4) (Fin 2) ℂ := rt2⁻¹ • Wminus

/-
The `√2⁻¹` normalisation turns a `Wᴴ M W` compression into `(1/2)·(Wᴴ M W)`.
-/
lemma compress_scale (W : Matrix (Fin 4) (Fin 2) ℂ) (M : Mat4) :
    (rt2⁻¹ • W)ᴴ * M * (rt2⁻¹ • W) = (1 / 2 : ℂ) • (Wᴴ * M * W) := by
  simp_all +decide [ Matrix.mul_assoc, Matrix.mul_smul, Matrix.smul_mul, smul_smul ];
  simp +decide [ rt2, Complex.ext_iff ];
  norm_num [ ← sq, ← Complex.ofReal_pow ]

/-
`Wplus` columns lie in `ker (U0 - 1)`.
-/
lemma Wplus_kernel : (U0 - 1) * Wplus = 0 := by
  rw [ U0_eq ];
  unfold U0mat Wplus;
  norm_num [ ← Matrix.ext_iff, Fin.forall_fin_succ ];
  norm_num [ Fin.sum_univ_succ, Matrix.mul_apply, wq ];
  simp +decide [ Fin.ext_iff, Matrix.one_apply ] ; ring_nf ; norm_num [ Complex.ext_iff, sq ] ;

/-
`Wminus` columns lie in `ker (U0 + 1)`.
-/
lemma Wminus_kernel : (U0 + 1) * Wminus = 0 := by
  unfold Wminus;
  unfold wq; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Matrix.add_apply, Fin.sum_univ_four, Matrix.one_apply, U0_eq ] ; ring;
  all_goals simp +decide [ U0mat ];
  · ring;
  · ring_nf; norm_num;
  · ring_nf; norm_num

/-
The gap-0 basis is orthonormal.
-/
lemma V0plus_orthonormal : V0plusᴴ * V0plus = 1 := by
  unfold V0plus;
  -- Now compute `Wplusᴴ * Wplus = (2:ℂ) • (1 : Matrix (Fin 2)(Fin 2) ℂ)`.
  have h_Wplus_HWplus : Wplusᴴ * Wplus = (2 : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
    unfold Wplus; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Matrix.conjTranspose_apply, Fin.sum_univ_four ] ;
    · simp +decide [ wq ] ; ring ; norm_num [ Complex.ext_iff, sq ] ;
    · simp +decide [ wq ];
    · simp +decide [ wq ];
    · simp +decide [ wq ] ; ring ; norm_num [ Complex.ext_iff, sq ] ;
  convert congr_arg ( fun x : Matrix ( Fin 2 ) ( Fin 2 ) ℂ => ( 1 / 2 : ℂ ) • x ) h_Wplus_HWplus using 1;
  · convert compress_scale Wplus 1 using 1; all_goals norm_num;
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num

/-
The gap-π basis is orthonormal.
-/
lemma V0minus_orthonormal : V0minusᴴ * V0minus = 1 := by
  convert compress_scale Wminus 1 using 1;
  · unfold V0minus; norm_num;
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ] <;> ring_nf <;> norm_num [ Complex.normSq, Complex.ext_iff ];
    · norm_num [ Wminus ];
      simp +decide [ wq ] ; ring ; norm_num;
    · unfold Wminus; norm_num [ Fin.ext_iff ] ;
      simp +zetaDelta at *;
    · simp +decide [ Wminus ];
    · unfold Wminus; norm_num [ Fin.succ ] ;
      erw [ Matrix.cons_val_succ' ] ; norm_num [ wq ] ;

/-- The Pauli matrices `σ₁, σ₂, σ₃`. -/
def pauli : Fin 3 → Matrix (Fin 2) (Fin 2) ℂ
  | 0 => !![0, 1; 1, 0]
  | 1 => !![0, -I; I, 0]
  | 2 => !![1, 0; 0, -1]

/-- The `2×2` compressions `V0ᴴ Dⱼ V0` (identical for both gaps). -/
def Cmat : Fin 3 → Matrix (Fin 2) (Fin 2) ℂ
  | 0 => !![0, -(4/5) * I; -(4/5) * I, 0]
  | 1 => !![0, 4/5; -(4/5), 0]
  | 2 => !![-(4/5) * I, 0; 0, (4/5) * I]

/-
The gap-0 compression equals `Cmat`.
-/
lemma compress_plus (j : Fin 3) : V0plusᴴ * Dvec j * V0plus = Cmat j := by
  rw [V0plus, compress_scale Wplus (Dvec j)]
  fin_cases j <;>
    (ext a b; fin_cases a <;> fin_cases b <;>
      simp [Dvec, Dq1_eq, Dq2_eq, Dq3_eq, Dq1mat, Dq2mat, Dq3mat,
        Matrix.smul_apply, Matrix.mul_apply, Matrix.conjTranspose_apply,
        Fin.sum_univ_four, Wplus, wq, Cmat, map_ofNat, map_div₀] <;>
      norm_num [Complex.ext_iff, Complex.div_re, Complex.div_im, Complex.normSq])

/-
The gap-π compression equals `Cmat` (the same matrix; the sign flip is carried
entirely by the orientation factor `s`).
-/
lemma compress_minus (j : Fin 3) : V0minusᴴ * Dvec j * V0minus = Cmat j := by
  rw [V0minus, compress_scale Wminus (Dvec j)]
  fin_cases j <;>
    (ext a b; fin_cases a <;> fin_cases b <;>
      simp [Dvec, Dq1_eq, Dq2_eq, Dq3_eq, Dq1mat, Dq2mat, Dq3mat,
        Matrix.smul_apply, Matrix.mul_apply, Matrix.conjTranspose_apply,
        Fin.sum_univ_four, Wminus, wq, Cmat, map_ofNat, map_div₀] <;>
      norm_num [Complex.ext_iff, Complex.div_re, Complex.div_im, Complex.normSq])


def Jac (s : ℝ) (V : Matrix (Fin 4) (Fin 2) ℂ) : Matrix (Fin 3) (Fin 3) ℝ :=
  Matrix.of (fun a j => -(s / 2) * (Matrix.trace (pauli a * (Vᴴ * Dvec j * V))).im)

/-- The Jacobian at gap 0. -/
def Jhere0 : Matrix (Fin 3) (Fin 3) ℝ :=
  !![(4/5 : ℝ), 0, 0; 0, -(4/5 : ℝ), 0; 0, 0, (4/5 : ℝ)]

/-- The Jacobian at gap π. -/
def JherePi : Matrix (Fin 3) (Fin 3) ℝ :=
  !![-(4/5 : ℝ), 0, 0; 0, (4/5 : ℝ), 0; 0, 0, -(4/5 : ℝ)]

/-
**T2 result, gap 0.**  `J = (4/5)·diag(1,-1,1)`.
-/
theorem Jac_gap0 : Jac 1 V0plus = Jhere0 := by
  unfold Jac Jhere0;
  ext a j; fin_cases a <;> fin_cases j <;> norm_num [ Matrix.trace_fin_two, compress_plus ] ;
  all_goals norm_num [ Matrix.mul_apply, pauli, Cmat ] ;

/-
**T2 result, gap π.**  `J = -(4/5)·diag(1,-1,1)` — the sign flips with `s`.
-/
theorem Jac_gapPi : Jac (-1) V0minus = JherePi := by
  ext a j; fin_cases a <;> fin_cases j <;> norm_num [ Jac, JherePi ] ;
  all_goals rw [ compress_minus ] ;
  all_goals norm_num [ Matrix.trace, Matrix.mul_apply, pauli, Cmat ] ;

/-! ## Tie to the landed census

These mirror `context/SplitStepChargeBalance.lean` (`chargeOf`, `Jplus`, `Jminus`)
so that the derived Jacobians can be compared to the supplied fixtures. -/

/-- Sign charge of a crossing Jacobian (mirrors the landed `chargeOf`). -/
def chargeOf (J : Matrix (Fin 3) (Fin 3) ℝ) : ℤ :=
  if 0 < J.det then 1 else if J.det < 0 then -1 else 0

/-- The landed positive-orientation Jacobian `Jplus = (4/5)·diag(-1,1,-1)`. -/
def Jplus_census : Matrix (Fin 3) (Fin 3) ℝ :=
  !![-(4/5 : ℝ), 0, 0; 0, (4/5 : ℝ), 0; 0, 0, -(4/5 : ℝ)]

/-- The landed negative-orientation Jacobian `Jminus = -Jplus`. -/
def Jminus_census : Matrix (Fin 3) (Fin 3) ℝ := -Jplus_census

/-
Documented naming: `J_recorded = -J_here` at gap 0.
-/
theorem recorded_eq_neg_here_gap0 : Jplus_census = -Jhere0 := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Jplus_census, Jhere0 ] ;

/-
Documented naming: `J_recorded = -J_here` at gap π.
-/
theorem recorded_eq_neg_here_gapPi : Jminus_census = -JherePi := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Jminus_census, JherePi ] ;
  all_goals norm_num [ Jplus_census ] ;

/-
The derived gap-0 charge is `-1` (`det = -64/125 < 0`).
-/
theorem chargeOf_gap0 : chargeOf (Jac 1 V0plus) = -1 := by
  convert congr_arg _ ( Jac_gap0 ) using 1;
  unfold chargeOf; norm_num [ Jhere0, Matrix.det_fin_three ] ;
  simp +zetaDelta at *;
  norm_num

/-
The derived gap-π charge is `+1` (`det = +64/125 > 0`).
-/
theorem chargeOf_gapPi : chargeOf (Jac (-1) V0minus) = 1 := by
  convert congr_arg _ ( Jac_gapPi ) using 1;
  unfold chargeOf; norm_num [ JherePi, Matrix.det_fin_three ] ;
  repeat erw [ Matrix.cons_val_succ' ] ; norm_num;

/-
**T3 — the tie.**  The two gap charges at the central node are opposite: the
landed `census_floquet_opposition` at this node is derived from the walk symbol.
-/
theorem census_floquet_opposition_derived :
    chargeOf (Jac 1 V0plus) = -(chargeOf (Jac (-1) V0minus)) := by
  rw [ chargeOf_gap0, chargeOf_gapPi ]

end PhysicsSM.Draft.NullEdge.SplitStepSchurJet
