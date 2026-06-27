/-
# Graded super-Dirac square (dual-soldered null Dirac operator)

This file is **self-contained and Mathlib-only** (no `PhysicsSM.*` imports).

We prove the finite ring/matrix identity for the graded super-Dirac operator

  `D = i • D_N + Γ_s * Φ`,        with `D_N = ∑_a C_a * ∇_a`,

over an arbitrary associative `ℂ`-algebra `A`.  The Clifford symbols `C_a`,
the connection pieces `∇_a`, the spacetime-chirality element `Γ_s` and the
mass/Yukawa scalar `Φ` are arbitrary elements of `A`; all structural facts are
supplied as **explicit hypotheses** so the dependence on each grading rule is
manifest.

## Main results

* `square_decomposition_quarter` : the *pure algebra* split of `D_N^2` into the
  symmetric "box" part `boxNull`, the antisymmetric "diamond" part `cDiamond`,
  and the frame term `tFrame = ∑_{a,b} C_a [∇_a, C_b] ∇_b`.  No hypotheses are
  needed: it is an identity in any ring (the quarter factors come from the
  symmetric/antisymmetric resolution `XY = ½{X,Y}+½[X,Y]`).

* `superDirac_graded_square` :
    `(i • D_N + Γ_s Φ)^2
       = -boxNull - cDiamond - tFrame + Φ^2
         - i • (Γ_s * ∑_a C_a [∇_a, Φ])`.
  This uses the five HARD grading hypotheses below, each load-bearing:
    - `Γ_s^2 = 1`                           (`hΓsq`)
    - `{Γ_s, C_a} = 0`                      (`hΓC`,  spacetime chirality flips C_a)
    - `[Γ_s, ∇_a] = 0`                      (`hGnab`)
    - `[Γ_s, Φ] = 0`   ← gives the `+Φ²` sign (`hΓΦ`)
    - `[C_a, Φ] = 0`                        (`hCΦ`)

## Grading guardrails (see also the lemmas `mass_sign_flip`, `gammaPhi_sq`)

* If instead `Φ` **anticommutes** with `Γ_s` (`{Γ_s,Φ}=0`), then
  `(Γ_s Φ)^2 = -Φ²` and the mass-term sign flips — `mass_sign_flip`.  Any
  *internal* odd grading must therefore be carried by a SEPARATE chirality
  `χ_E`; one must NOT reuse `χ_E` to justify the `+Φ²` sign under `Γ_s`.

* `boxNull` here is the **kinetic mass-shell** operator built from the Clifford
  anticommutators `{C_a,C_b}` and the second-derivative symbols `{∇_a,∇_b}`.  To
  read `P² = m²` off `-boxNull + Φ² = 0` one needs the plane-wave *symbol* of
  `boxNull` to equal `P(ξ)²`; that is a statement about the symbol map, not about
  this algebraic identity, and is not asserted here.

## No-doubling caveat (DETERMINANT level, not coefficient level)

On the flat tetrahedral patch the symbol is
  `p(q) = h⁻¹ ∑_a (e^{i q_a} - 1) α^a`.
At the Brillouin point `q = (π,π,π,0)` the coefficient vector
`(e^{iπ}-1, e^{iπ}-1, e^{iπ}-1, e^{i·0}-1) = (-2,-2,-2,0)` is **nonzero**, yet
`p(q)² = 0` is possible (a high-momentum null Clifford singularity / candidate
doubler).  Hence the honest no-doubling statement must analyse
`det (i • D₊(q) + Γ_s Φ) = 0`, NOT merely `p(q) = 0`.  That determinant analysis
is recorded here as a caveat only; it is not proved in this file, so the square
theorem below is not overclaimed as a no-doubling theorem.

## Tetrahedral convention (unit observer-normalized tetrahedron)

  s₁=(1,1,1), s₂=(1,-1,-1), s₃=(-1,1,-1), s₄=(-1,-1,1);   n_A = s_A/√3;
  ℓ_A = (1, n_A) future-null, e₀·ℓ_A = 1.
  Gram of ℓ_A : diag 0, off-diag 4/3.   Inverse Gram : diag -1/2, off-diag 1/4.
  Dual covectors α^A = ¼ dt + ¾ n_A·dx satisfy α^A(ℓ_B) = δ^A_B.
This convention is verified concretely (rationally) in the `Tetrahedron` section.

Literature anchor (context only, not imported): up to Lorentzian signature this
dual-soldered `D_N` is the minimally-doubled Borici–Creutz / 4D-hyperdiamond
Dirac operator (Creutz arXiv:0712.1201, Borici arXiv:0812.0092); the
`cos θ = -1/4` inverse-Gram soldering is the hyperdiamond structure.  The naive
diagonal ansatz `∑_a c(ℓ_a) ∇_a` fails the Dirac-symbol (trace) test.
-/
import Mathlib

open scoped BigOperators

namespace PhysicsSM.NullStrand.DualSolder

/-! ## Commutator / anticommutator helpers -/

/-- The ring commutator `[x, y] = x*y - y*x`. -/
def commr {A : Type*} [Ring A] (x y : A) : A := x * y - y * x

/-- The ring anticommutator `{x, y} = x*y + y*x`. -/
def acommr {A : Type*} [Ring A] (x y : A) : A := x * y + y * x

section Algebra

variable {A : Type*} [Ring A] [Algebra ℂ A]

/-! ## The dual-soldered Dirac operator and the pieces of its square -/

/-- The dual-soldered null Dirac operator `D_N = ∑_a C_a * ∇_a`. -/
def DN (C nabla : Fin 4 → A) : A := ∑ a, C a * nabla a

/-- Symmetric "box" (kinetic mass-shell) part:
`boxNull = ¼ ∑_{a,b} {C_a,C_b} {∇_a,∇_b}`. -/
noncomputable def boxNull (C nabla : Fin 4 → A) : A :=
  (1 / 4 : ℂ) • ∑ a, ∑ b, acommr (C a) (C b) * acommr (nabla a) (nabla b)

/-- Antisymmetric "diamond" part:
`cDiamond = ¼ ∑_{a,b} [C_a,C_b] [∇_a,∇_b]`. -/
noncomputable def cDiamond (C nabla : Fin 4 → A) : A :=
  (1 / 4 : ℂ) • ∑ a, ∑ b, commr (C a) (C b) * commr (nabla a) (nabla b)

/-- Frame term `T_frame = ∑_{a,b} C_a [∇_a, C_b] ∇_b`. -/
def tFrame (C nabla : Fin 4 → A) : A :=
  ∑ a, ∑ b, C a * commr (nabla a) (C b) * nabla b

/-- The graded super-Dirac operator `D = i • D_N + Γ_s * Φ`. -/
noncomputable def superD (C nabla : Fin 4 → A) (Gamma_s Phi : A) : A :=
  Complex.I • DN C nabla + Gamma_s * Phi

/-! ### Pure-algebra square decomposition -/

/-
The symmetric + antisymmetric Clifford resolution collapses the box and
diamond parts to the "ordered" double sum `∑_{a,b} C_a C_b (∇_a ∇_b)`.
-/
lemma boxNull_add_cDiamond (C nabla : Fin 4 → A) :
    boxNull C nabla + cDiamond C nabla
      = ∑ a, ∑ b, C a * C b * (nabla a * nabla b) := by
  unfold boxNull cDiamond;
  simp +decide only [acommr, mul_add, add_mul, mul_assoc, Finset.sum_add_distrib, commr, mul_sub, sub_mul,
      Finset.sum_sub_distrib];
  simp +decide [ ← Finset.mul_sum _ _ _, Finset.sum_comm ];
  module

/-
**Pure ring identity.**  `D_N² = boxNull + cDiamond + T_frame`.  No grading
hypotheses are needed: this is the symmetric/antisymmetric split together with
the frame (non-commuting `[∇_a, C_b]`) remainder.
-/
theorem square_decomposition_quarter (C nabla : Fin 4 → A) :
    DN C nabla * DN C nabla
      = boxNull C nabla + cDiamond C nabla + tFrame C nabla := by
  rw [ boxNull_add_cDiamond ];
  simp +decide only [DN];
  simp +decide [ Finset.sum_mul, mul_assoc, tFrame, commr ];
  simp +decide [ mul_sub, sub_mul, Finset.mul_sum _ _ _, mul_assoc ]

/-! ### Grading guardrail lemmas -/

/-
If `Γ_s² = 1` and `[Γ_s, Φ] = 0`, then `(Γ_s Φ)² = Φ²`.  This is what makes
the mass term enter with a `+Φ²`.
-/
omit [Algebra ℂ A] in
lemma gammaPhi_sq (Gamma_s Phi : A) (hΓsq : Gamma_s * Gamma_s = 1)
    (hΓΦ : Gamma_s * Phi = Phi * Gamma_s) :
    (Gamma_s * Phi) * (Gamma_s * Phi) = Phi * Phi := by
  grind +qlia

/-
**Guardrail (sign flip).**  If `Γ_s² = 1` but `Φ` *anticommutes* with `Γ_s`
(`{Γ_s,Φ} = 0`, i.e. `Γ_s Φ = -(Φ Γ_s)`), then `(Γ_s Φ)² = -Φ²`: the mass-term
sign flips.  Hence an internal odd grading must be carried by a separate `χ_E`,
never by reinterpreting `Γ_s`.
-/
omit [Algebra ℂ A] in
lemma mass_sign_flip (Gamma_s Phi : A) (hΓsq : Gamma_s * Gamma_s = 1)
    (hanti : Gamma_s * Phi = -(Phi * Gamma_s)) :
    (Gamma_s * Phi) * (Gamma_s * Phi) = -(Phi * Phi) := by
  simp_all +decide [ mul_assoc, neg_mul ];
  simp_all +decide [ ← mul_assoc ];
  simp +decide [ mul_assoc, hΓsq ]

/-
The mixed (kinetic × mass) cross term collapses to a single commutator sum.
Uses: `[Γ_s,∇_a]=0`, `{Γ_s,C_a}=0`, `[C_a,Φ]=0`.
-/
omit [Algebra ℂ A] in
lemma cross_term (C nabla : Fin 4 → A) (Gamma_s Phi : A)
    (hΓC : ∀ a, Gamma_s * C a + C a * Gamma_s = 0)
    (hGnab : ∀ a, Gamma_s * nabla a = nabla a * Gamma_s)
    (hCΦ : ∀ a, C a * Phi = Phi * C a) :
    DN C nabla * (Gamma_s * Phi) + (Gamma_s * Phi) * DN C nabla
      = -(Gamma_s * ∑ a, C a * commr (nabla a) Phi) := by
  simp +decide [ DN, commr, Finset.mul_sum, Finset.sum_add_distrib, mul_add, mul_assoc, sub_eq_add_neg ];
  simp +decide [ ← mul_assoc, ← Finset.sum_mul, hCΦ ];
  simp_all +decide [ mul_assoc, Finset.sum_mul _ _ _, add_eq_zero_iff_eq_neg ];
  exact add_comm _ _

/-! ### Main theorem -/

/-
**Graded super-Dirac square.**
`(i • D_N + Γ_s Φ)² = -boxNull - cDiamond - tFrame + Φ²
                       - i • (Γ_s * ∑_a C_a [∇_a, Φ])`.

All five grading hypotheses are load-bearing; in particular `[Γ_s,Φ]=0`
(`hΓΦ`) is what yields the `+Φ²` sign (contrast `mass_sign_flip`).
-/
theorem superDirac_graded_square (C nabla : Fin 4 → A) (Gamma_s Phi : A)
    (hΓsq : Gamma_s * Gamma_s = 1)
    (hΓC : ∀ a, Gamma_s * C a + C a * Gamma_s = 0)
    (hGnab : ∀ a, Gamma_s * nabla a = nabla a * Gamma_s)
    (hΓΦ : Gamma_s * Phi = Phi * Gamma_s)
    (hCΦ : ∀ a, C a * Phi = Phi * C a) :
    superD C nabla Gamma_s Phi * superD C nabla Gamma_s Phi
      = -boxNull C nabla - cDiamond C nabla - tFrame C nabla
        + Phi * Phi
        - Complex.I • (Gamma_s * ∑ a, C a * commr (nabla a) Phi) := by
  unfold superD;
  -- Expand the product using the distributive property.
  simp [mul_add, add_mul, sub_eq_add_neg];
  rw [ square_decomposition_quarter ];
  -- Apply the cross_term lemma to simplify the mixed term.
  have h_cross : DN C nabla * (Gamma_s * Phi) + (Gamma_s * Phi) * DN C nabla = -(Gamma_s * ∑ a, C a * commr (nabla a) Phi) := by
    convert cross_term C nabla Gamma_s Phi hΓC hGnab hCΦ using 1;
  convert congr_arg ( fun x : A => Complex.I • Complex.I • ( boxNull C nabla + cDiamond C nabla + tFrame C nabla ) + Complex.I • x + Phi * Phi ) h_cross using 1 ; abel_nf;
  · simp +decide [ mul_assoc, add_assoc, add_left_comm, add_comm, smul_add, smul_smul, Complex.I_mul_I ];
    grind +splitImp;
  · simp +decide [ ← smul_assoc, Complex.I_mul_I ] ; abel_nf

end Algebra

/-! ## Tetrahedral convention: concrete rational verification

We verify, fully rationally, the unit observer-normalized tetrahedron Gram and
its dual.  The spatial vectors are `s_A`; the lightlike `ℓ_A = (1, s_A/√3)` have
Minkowski Gram `1 - (s_A·s_B)/3`.  The only nontrivial input is the integer dot
table `s_A·s_B = 3` (A=B), `-1` (A≠B). -/

namespace GradedTetrahedron

/-- The four spatial tetrahedron vectors `s_A`. -/
def sv : Fin 4 → Fin 3 → ℚ :=
  ![![1, 1, 1], ![1, -1, -1], ![-1, 1, -1], ![-1, -1, 1]]

/-- Euclidean dot product of two `s` vectors. -/
def sdot (A B : Fin 4) : ℚ := ∑ i, sv A i * sv B i

/-
The integer dot table: `s_A·s_A = 3`, `s_A·s_B = -1` for `A ≠ B`.
-/
theorem sdot_table (A B : Fin 4) : sdot A B = if A = B then 3 else -1 := by
  fin_cases A <;> fin_cases B <;>
    simp [sdot, sv, Fin.sum_univ_three] <;> norm_num

/-- Minkowski Gram entry of the lightlike `ℓ_A = (1, s_A/√3)`:
`ℓ_A·ℓ_B = 1 - (s_A·s_B)/3`. -/
def gramEll (A B : Fin 4) : ℚ := 1 - sdot A B / 3

/-- The ℓ-Gram is diagonal `0`, off-diagonal `4/3`. -/
theorem gramEll_table (A B : Fin 4) : gramEll A B = if A = B then 0 else 4 / 3 := by
  rw [gramEll, sdot_table]; split <;> norm_num

/-- Pairing of the dual covector `α^A = ¼ dt + ¾ n_A·dx` with `ℓ_B = (1, n_B)`:
`α^A(ℓ_B) = ¼ + ¾ · (s_A·s_B)/3`. -/
def dualPair (A B : Fin 4) : ℚ := 1 / 4 + (3 / 4) * (sdot A B / 3)

/-- **Duality `α^A(ℓ_B) = δ^A_B`.** -/
theorem dualPair_eq_delta (A B : Fin 4) :
    dualPair A B = if A = B then 1 else 0 := by
  rw [dualPair, sdot_table]; split <;> norm_num

/-- The ℓ-Gram as a concrete `4×4` rational matrix. -/
def gramM : Matrix (Fin 4) (Fin 4) ℚ :=
  !![0, 4/3, 4/3, 4/3; 4/3, 0, 4/3, 4/3; 4/3, 4/3, 0, 4/3; 4/3, 4/3, 4/3, 0]

/-- The inverse Gram: diagonal `-1/2`, off-diagonal `1/4`. -/
def gramInvM : Matrix (Fin 4) (Fin 4) ℚ :=
  !![-1/2, 1/4, 1/4, 1/4; 1/4, -1/2, 1/4, 1/4; 1/4, 1/4, -1/2, 1/4;
     1/4, 1/4, 1/4, -1/2]

/-- `gramM` agrees with the abstract `gramEll`. -/
theorem gramM_eq (A B : Fin 4) : gramM A B = gramEll A B := by
  rw [gramEll, sdot_table]
  fin_cases A <;> fin_cases B <;> simp [gramM] <;> norm_num

/-
**The stated inverse Gram is correct:** `gramM * gramInvM = 1`.
-/
theorem gram_mul_inv : gramM * gramInvM = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [gramM, gramInvM, Matrix.mul_apply, Fin.sum_univ_four] <;>
    norm_num

end GradedTetrahedron

end PhysicsSM.NullStrand.DualSolder
