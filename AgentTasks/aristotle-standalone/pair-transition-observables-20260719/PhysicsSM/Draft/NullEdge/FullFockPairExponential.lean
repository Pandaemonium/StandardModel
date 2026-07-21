import Mathlib

/-!
# Full-Fock exponential of the pair-transfer generator

Draft module. The occupation basis has sixteen states, indexed by finite subsets
of `Fin 4`. The matrix `KopMatrix z` has one active two-by-two block coupling
`lowPair` and `highPair` and vanishes elsewhere. This proves that its genuine
matrix exponential (`NormedSpace.exp`), acting by `mulVec`, equals the displayed
closed-form `Uop` on every occupation coordinate.

Over the whole occupation basis, the theorem includes the identity action on all
fourteen inactive basis states, quantified by `funext`, not the two-state active
block alone.

## Scope (anti-overclaim; cross-family red team, Codex 2026-07-12)

This is a finite algebraic identity: the real `NormedSpace.exp` of a fixed
sixteen-dimensional Hermitian generator equals a supplied closed form. `Uop` is
the reconstructed evolution, not an independently derived physical dynamics; no
Hilbert-space completion, interaction, or continuum limit is claimed.

Crucially, `KopMatrix` and `Uop` here are LOCAL redeclarations, NOT the canonical
live objects: the theorem is not yet bridged to `PlueckerPairGenerator.Kop` or
the canonical Paper E `Uop` used by `PairActiveSectorExponential` and the
manuscripts. Structural similarity is not an API bridge. Until exact bridge
lemmas (`local KopMatrix mulVec = canonical Kop`, `local Uop = canonical Uop`)
land and a composed canonical theorem is pinned, this module is a STANDALONE
finite model over its own definitions, not the live-generator successor. It is a
`DYN-MODULAR-001` companion, NOT a prerequisite for the energy-constrained
variational theorem.

Boundary: the theorem assumes `z != 0` (the normalized `Jmat` divides by
`‖z‖`); the `z = 0` identity boundary is not covered here.

## Trust status

Draft-trust by kernel: `exp_mulVec_eq_Uop` is `sorry`-free and depends only on
`[propext, Classical.choice, Quot.sound]` (no `native_decide` /
`Lean.ofReduceBool`), pinned by the `#print axioms` guard block at the end.
Machine-generated helper proofs may emit cosmetic style-linter warnings (unused
`simp` arguments / one unused section variable); these do not affect the build,
correctness, or axiom footprint.

## Provenance

Statement authored in-project (AFPL run 2026-07-12, DYN-MODULAR exponential
line). Proof search by Aristotle (project
`508eafd0-8314-4e5f-911c-6f8f6aa8ddf0`), then independently re-checked in this
repo (`lake env lean`; axiom footprint confirmed kernel-only). Mathematics: the
exponent is `ν • J` with `J` the block scaled to a tripotent (`J³ = J`,
`J² = P` the active-sector projection) and `ν = -a·i·‖z‖`; a Banach-algebra
idempotent-exponential lemma and a tripotent diagonalization give
`exp(ν•J) = 1 + sinh ν • J + (cosh ν - 1)•J²`, and `cosh`/`sinh` at `ν` reduce to
`cos(a‖z‖)`, `-i·sin(a‖z‖)`. Clean-room formalization from the mathematical
statement.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FullFockPairExponential

open Matrix

abbrev Occ := Finset (Fin 4)
abbrev Fock := Occ -> Complex

def lowPair : Occ := {0, 1}
def highPair : Occ := {2, 3}

/-- The Hermitian pair-transfer matrix on the full occupation basis. -/
def KopMatrix (z : Complex) : Matrix Occ Occ Complex := fun S T =>
  if S = lowPair ∧ T = highPair then z
  else if S = highPair ∧ T = lowPair then (starRingEnd Complex) z
  else 0

/-- Closed-form full-Fock evolution: a cosine-sine block on the active pair
sector and identity on its complement. -/
def Uop (c s : Real) (z : Complex) (m : Real) (psi : Fock) : Fock := fun S =>
  if S = lowPair then
    (c : Complex) * psi lowPair -
      Complex.I * (s : Complex) * (z / (m : Complex)) * psi highPair
  else if S = highPair then
    (c : Complex) * psi highPair -
      Complex.I * (s : Complex) *
        ((starRingEnd Complex) z / (m : Complex)) * psi lowPair
  else psi S

/-! ## Helper development -/

/-- Normalised generator: the active block scaled to a "sign"-type matrix with
`J^2` equal to the block projection and `J^3 = J`. -/
def Jmat (z : Complex) : Matrix Occ Occ Complex := fun S T =>
  if S = lowPair ∧ T = highPair then z / (‖z‖ : Complex)
  else if S = highPair ∧ T = lowPair then (starRingEnd Complex) z / (‖z‖ : Complex)
  else 0

/-- Projection onto the active pair sector `{lowPair, highPair}`. -/
def Pmat : Matrix Occ Occ Complex := fun S T =>
  if S = T ∧ (S = lowPair ∨ S = highPair) then 1 else 0

lemma lowPair_ne_highPair : lowPair ≠ highPair := by decide

section Banach

variable {𝔸 : Type*} [NormedRing 𝔸] [NormedAlgebra ℚ 𝔸] [CompleteSpace 𝔸]
  [NormedAlgebra ℂ 𝔸]

/-
Exponential of a scalar multiple of an idempotent element.
-/
lemma exp_smul_idem (e : 𝔸) (he : e * e = e) (t : ℂ) :
    NormedSpace.exp (t • e) = 1 + (Complex.exp t - 1) • e := by
  have h_exp : NormedSpace.exp (t • e) = ∑' n : ℕ, (1 / (n.factorial : ℂ)) • (t ^ n • e ^ n) := by
    simp +decide [ NormedSpace.exp_eq_tsum, smul_pow ];
    convert NormedSpace.exp_eq_tsum using 1;
    refine' ⟨ fun h => _, fun h => _ ⟩;
    exact?;
    convert congr_fun ( h ℂ ) ( t • e ) using 1;
    simp +decide [ smul_pow, mul_pow ];
  -- For $n \geq 1$, we have $e^n = e$.
  have h_pow : ∀ n : ℕ, 0 < n → e ^ n = e := by
    intro n hn; induction hn <;> simp_all +decide [ pow_succ' ] ;
  rw [ h_exp, Summable.tsum_eq_zero_add ];
  · simp +decide [ h_pow, Complex.exp_eq_exp_ℂ, NormedSpace.exp_eq_tsum_div ];
    rw [ eq_comm, Summable.tsum_eq_zero_add ];
    · simp +decide [ div_eq_inv_mul, smul_smul, tsum_mul_left ];
      rw [ ← Summable.tsum_smul_const ];
      exact Summable.of_norm <| by simpa [ inv_mul_eq_div ] using summable_nat_add_iff 1 |>.2 <| Real.summable_pow_div_factorial _;
    · exact Summable.of_norm <| by simpa using Real.summable_pow_div_factorial ‖t‖;
  · rw [ ← summable_nat_add_iff 1 ];
    simp +decide [ h_pow _ ( Nat.succ_pos _ ) ];
    have h_summable : Summable (fun n : ℕ => (1 / (n.factorial : ℂ)) • t ^ n • e) := by
      have h_summable : Summable (fun n : ℕ => (1 / (n.factorial : ℂ)) • t ^ n) := by
        exact Summable.of_norm <| by simpa [ inv_mul_eq_div ] using Real.summable_pow_div_factorial ( Complex.normSq t |> Real.sqrt ) ;
      convert h_summable.smul_const e using 2 ; simp +decide [ smul_smul ];
    convert h_summable.comp_injective ( add_left_injective 1 ) using 2 ; aesop

/-
Exponential of a scalar multiple of a "tripotent" element `J^3 = J`.
-/
lemma exp_smul_cube (J : 𝔸) (hJ : J ^ 3 = J) (ν : ℂ) :
    NormedSpace.exp (ν • J) = 1 + Complex.sinh ν • J + (Complex.cosh ν - 1) • J ^ 2 := by
  -- By linearity of normed space exponential we split exponent into sum of eigenvectors.
  have h_exp : NormedSpace.exp (ν • J) = NormedSpace.exp (ν • ((1 / 2 : ℂ) • (J ^ 2 + J)) + (-ν) • ((1 / 2 : ℂ) • (J ^ 2 - J))) := by
    simp +decide [ smul_add, smul_sub, ← smul_assoc ];
    norm_num [ add_assoc, add_left_comm, add_comm ];
    rw [ ← add_smul ] ; ring;
  -- By linearity of normed space exponential we split exponent into sum of eigenvectors and use `exp_smul_idem`.
  have h_exp_smul_idem : NormedSpace.exp (ν • ((1 / 2 : ℂ) • (J ^ 2 + J))) = 1 + (Complex.exp ν - 1) • ((1 / 2 : ℂ) • (J ^ 2 + J)) ∧ NormedSpace.exp ((-ν) • ((1 / 2 : ℂ) • (J ^ 2 - J))) = 1 + (Complex.exp (-ν) - 1) • ((1 / 2 : ℂ) • (J ^ 2 - J)) := by
    constructor <;> apply exp_smul_idem;
    · simp_all +decide [ mul_add, add_mul, pow_succ, mul_assoc ];
      module;
    · simp_all +decide [ pow_succ, mul_assoc, sub_mul, mul_sub ];
      module;
  convert congr_arg₂ ( fun x y : 𝔸 => x * y ) h_exp_smul_idem.1 h_exp_smul_idem.2 using 1;
  · rw [ h_exp, NormedSpace.exp_add_of_commute ];
    simp +decide [ Commute, mul_add, add_mul, mul_sub, sub_mul, pow_succ ];
    simp +decide [ SemiconjBy, mul_sub, sub_mul, mul_assoc, pow_succ ];
    simp +decide [ mul_add, add_mul, mul_assoc, pow_succ ];
  · simp +decide [ Complex.sinh, Complex.cosh, mul_add, add_mul, mul_assoc, mul_left_comm, sub_eq_add_neg, add_assoc ];
    simp_all +decide [ pow_succ, mul_assoc, mul_left_comm, ← smul_assoc ];
    module

end Banach

/-
The exponent matrix is a scalar multiple of `Jmat`.
-/
lemma KopMatrix_eq_smul_Jmat (z : Complex) (a : Real) (hz : z ≠ 0) :
    (-(a : Complex) * Complex.I) • KopMatrix z
      = (-(a : Complex) * Complex.I * (‖z‖ : Complex)) • Jmat z := by
  ext S T; simp [KopMatrix, Jmat];
  simp +decide [ mul_assoc, mul_div_cancel₀, hz ]

/-
`Jmat` squares to the sector projection.
-/
lemma Jmat_sq (z : Complex) (hz : z ≠ 0) : (Jmat z) ^ 2 = Pmat := by
  ext S T;
  by_cases hS : S = lowPair ∨ S = highPair <;> by_cases hT : T = lowPair ∨ T = highPair <;> simp_all +decide [ sq, Matrix.mul_apply, Jmat, Pmat ];
  · rcases hS with ( rfl | rfl ) <;> rcases hT with ( rfl | rfl ) <;> simp +decide [ div_mul_div_comm, Complex.mul_conj, Complex.normSq_eq_norm_sq, hz ];
    · rw [ ← sq, div_self ( by norm_cast; positivity ) ];
    · simp +decide [ mul_comm, Complex.mul_conj, Complex.normSq_eq_norm_sq, hz ];
      rw [ ← sq, div_self ( by norm_cast; positivity ) ];
  · grind

/-
`Jmat` is tripotent.
-/
lemma Jmat_cube (z : Complex) (hz : z ≠ 0) : (Jmat z) ^ 3 = Jmat z := by
  convert congr_arg ( fun x => x * Jmat z ) ( Jmat_sq z hz ) using 1;
  ext S T; simp +decide [ Pmat, Jmat, Matrix.mul_apply ] ;
  rw [ Finset.sum_eq_single S ] <;> aesop

lemma Jmat_mulVec (z : Complex) (psi : Fock) :
    (Jmat z) *ᵥ psi = fun S =>
      if S = lowPair then (z / (‖z‖ : Complex)) * psi highPair
      else if S = highPair then ((starRingEnd Complex) z / (‖z‖ : Complex)) * psi lowPair
      else 0 := by
  -- By definition of Jmat, we know that Jmat z *ᵥ psi is equal to the sum of the products of Jmat z and psi over all T.
  funext S; simp [Jmat, Matrix.mulVec];
  split_ifs <;> simp_all +decide [ dotProduct ]

lemma Pmat_mulVec (psi : Fock) :
    Pmat *ᵥ psi = fun S =>
      if S = lowPair then psi lowPair
      else if S = highPair then psi highPair
      else 0 := by
  funext S;
  rw [ Matrix.mulVec, dotProduct ];
  unfold Pmat; split_ifs <;> simp_all +decide [ Finset.sum_ite, Finset.filter_eq', Finset.filter_ne' ] ;

lemma cosh_neg_ofReal_mul_I (x : Real) :
    Complex.cosh (-(x : Complex) * Complex.I) = (Real.cos x : Complex) := by
  simp +decide [ Complex.cosh, Complex.exp_neg ];
  rw [ Complex.cos, ← Complex.exp_neg ] ; ring

lemma sinh_neg_ofReal_mul_I (x : Real) :
    Complex.sinh (-(x : Complex) * Complex.I) = -(Real.sin x : Complex) * Complex.I := by
  rw [ Complex.sinh ];
  norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im, Real.sin ] ; ring

/-- **Full occupation-basis exponential equals `Uop`.** The genuine matrix
exponential of the sixteen-state pair-transfer generator, acting by `mulVec`,
equals the closed-form evolution `Uop` on every occupation coordinate. -/
theorem exp_mulVec_eq_Uop (z : Complex) (a : Real) (hz : z ≠ 0) (psi : Fock) :
    (NormedSpace.exp
        ((-(a : Complex) * Complex.I) • KopMatrix z)).mulVec psi =
      Uop (Real.cos (a * ‖z‖)) (Real.sin (a * ‖z‖)) z ‖z‖ psi := by
  have hexp : NormedSpace.exp ((-(a : Complex) * Complex.I) • KopMatrix z)
      = 1 + Complex.sinh (-(a : Complex) * Complex.I * (‖z‖ : Complex)) • Jmat z
        + (Complex.cosh (-(a : Complex) * Complex.I * (‖z‖ : Complex)) - 1) • (Jmat z) ^ 2 := by
    rw [KopMatrix_eq_smul_Jmat z a hz]
    open scoped Matrix.Norms.Operator in
    exact exp_smul_cube (Jmat z) (Jmat_cube z hz) _
  have harg : -(a : Complex) * Complex.I * (‖z‖ : Complex)
      = -((a * ‖z‖ : Real) : Complex) * Complex.I := by push_cast; ring
  rw [hexp, Jmat_sq z hz, harg, cosh_neg_ofReal_mul_I, sinh_neg_ofReal_mul_I,
    add_mulVec, add_mulVec, smul_mulVec, smul_mulVec, one_mulVec,
    Jmat_mulVec, Pmat_mulVec]
  funext S
  simp only [Uop, Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  by_cases h1 : S = lowPair
  · subst h1
    simp only [if_true]
    ring
  · by_cases h2 : S = highPair
    · subst h2
      simp only [if_neg lowPair_ne_highPair.symm, if_true]
      ring
    · simp only [if_neg h1, if_neg h2]
      ring

end PhysicsSM.Draft.NullEdge.FullFockPairExponential

-- Axiom-footprint guard (draft-trust by kernel): kernel axioms only, no
-- `native_decide` / `Lean.ofReduceBool`.
/--
info: 'PhysicsSM.Draft.NullEdge.FullFockPairExponential.exp_mulVec_eq_Uop' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FullFockPairExponential.exp_mulVec_eq_Uop
