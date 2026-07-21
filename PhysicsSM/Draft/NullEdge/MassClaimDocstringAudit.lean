import Mathlib

/-!
# Adversarial docstring audit of the origin-of-mass claims (Opus, 364a29ac)

Severity pass over MY OWN headline mass prose. ALL FIVE claims returned
PROSE-OUTRUNS-STATEMENT, each with a kernel witness. The corrected readings:

1. `gap_does_not_fix_pole` proves only that ONE FIXED, non-conjugacy-invariant
   observable can distinguish conjugate involutions. HONEST FORM: internal spectral
   data do not determine an external readout that is not itself determined by that
   spectral data. It is NOT a general 'gap does not determine physical mass'.
2. The transfer witness separates RAW two-point values, offsets and amplitudes - but
   its CONNECTED NORMALIZED ratios are BOTH EXACTLY 1/2, so it does NOT distinguish
   the connected/normalized decay-mass readout. Any 'observable-dependent MASS'
   phrasing overclaims.
3. Pluecker: diag(1,2) and diag(2,1) share Frobenius norm, determinant AND the full
   singular-value multiset {1,2} - stronger than I claimed - but this defeats only
   selection by THOSE invariants, not by every finer Pluecker datum, and the
   equivalence relation must be specified.
4. 'the fermion sector shares only the scalar v' - one mass functor establishes only
   the DISPLAYED factorization; it does not exclude unmodelled routes. Honest form:
   dependence does not pass through the displayed vector-valued route in that functor.
5. `GammaOdd cap GammaEven = {0}` gives FORMAL parity-class disjointness only; it
   does NOT imply injectivity or non-double-counting of PHYSICAL rows - the witness
   exhibits disjoint classes alongside a non-injective row assignment.

Affected docstrings corrected. Provenance: verified at pin from task 8fa3d006.
Standard three. Grade M, [orig] (independent-review artifact). -/

open scoped BigOperators

namespace OriginOfMassAudit

noncomputable section

/-! # Mathlib witnesses for an adversarial prose audit

Each theorem below formalizes the precise limitation established by a counterexample.
No physical interpretation is introduced as a formal assumption.
-/

namespace SpectralGap

abbrev M2 := Matrix (Fin 2) (Fin 2) ℝ

def A : M2 := !![1, 0; 0, -1]
def U : M2 := !![0, 1; 1, 0]
def B : M2 := U * A * U.transpose

/-- A fixed, coordinate-dependent external readout. -/
def weight (M : M2) : ℝ := (M 0 0 + 1) / 2

/-
Two orthogonally conjugate Hermitian involutions can have different values under
one fixed, non-conjugacy-invariant observable.
-/
theorem one_fixed_observable_not_determined :
    A.transpose = A ∧ U * U.transpose = 1 ∧ A * A = 1 ∧ B * B = 1 ∧
      B = U * A * U.transpose ∧ weight A = 1 ∧ weight B = 0 := by
  refine' ⟨ _, _, _, _, rfl, _, _ ⟩;
  all_goals norm_num [ A, U, B, weight ];
  · ext i j ; fin_cases i <;> fin_cases j <;> rfl;
  · ext i j ; fin_cases i <;> fin_cases j <;> rfl;
  · exact Matrix.one_fin_two.symm;
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.vecHead, Matrix.vecTail ];
  · norm_num [ Matrix.vecHead, Matrix.vecTail ]

end SpectralGap

namespace Correlation

/-- Raw correlators with the same exponential transfer factor but different offsets
and amplitudes. -/
def C₁ (n : ℕ) : ℝ := 3 + 2 * (1 / 2 : ℝ) ^ n
def C₂ (n : ℕ) : ℝ := 7 + 5 * (1 / 2 : ℝ) ^ n

def connected₁ (n : ℕ) : ℝ := C₁ n - 3
def connected₂ (n : ℕ) : ℝ := C₂ n - 7

/-
The witness separates raw values, but both connected normalized readouts have the
same decay ratio.
-/
theorem raw_not_fixed_but_connected_ratio_fixed :
    C₁ 0 ≠ C₂ 0 ∧
      (∀ n, connected₁ (n + 1) / connected₁ n = (1 / 2 : ℝ)) ∧
      (∀ n, connected₂ (n + 1) / connected₂ n = (1 / 2 : ℝ)) := by
  unfold C₁ C₂ connected₁ connected₂; norm_num;
  unfold C₁ C₂; norm_num; ring_nf; norm_num;
  norm_num [ ← mul_pow ]

end Correlation

namespace Yukawa

abbrev M2 := Matrix (Fin 2) (Fin 2) ℝ

def Y₁ : M2 := !![1, 0; 0, 2]
def Y₂ : M2 := !![2, 0; 0, 1]

def frobeniusSq (M : M2) : ℝ := ∑ i, ∑ j, (M i j) ^ 2

/-- For these diagonal examples this is the unordered multiset of squared singular
values, namely the diagonal entries of `MᵀM`. -/
def diagonalGramSpectrum (M : M2) : Multiset ℝ :=
  {((M.transpose * M) 0 0), ((M.transpose * M) 1 1)}

/-
Equal Frobenius norm and determinant do not select a literal matrix.  In this
specific witness, even the full singular-value multiset agrees.
-/
theorem invariants_do_not_select_literal_coupling :
    Y₁ ≠ Y₂ ∧ frobeniusSq Y₁ = frobeniusSq Y₂ ∧
      Matrix.det Y₁ = Matrix.det Y₂ ∧
      diagonalGramSpectrum Y₁ = {1, 4} ∧ diagonalGramSpectrum Y₂ = {1, 4} := by
  unfold Y₁ Y₂ frobeniusSq diagonalGramSpectrum; norm_num;
  norm_num [ Matrix.mul_apply ];
  exact Multiset.cons_swap ..

end Yukawa

namespace Fermion

/-- The particular scalar-factor mass functor used by the audited argument. -/
def displayedMass (v y : ℝ) : ℝ := v * y

/-- A possible additional vector-valued route, absent from `displayedMass`. -/
def extendedMass (v y w : ℝ) : ℝ := v * y + w

/-
Agreement with the displayed functor when the extra route vanishes does not imply
that every extension factors only through `v`.
-/
theorem unmodelled_route_witness :
    (∀ v y, extendedMass v y 0 = displayedMass v y) ∧
      extendedMass 0 0 1 ≠ displayedMass 0 0 := by
  -- Unfold the definitions of `displayedMass` and `extendedMass`.
  simp [displayedMass, extendedMass]

end Fermion

namespace MechanismMatrix

/-- Two formal parity classes, represented by the two coordinate axes. -/
def GammaOdd (x : ℤ × ℤ) : Prop := x.2 = 0
def GammaEven (x : ℤ × ℤ) : Prop := x.1 = 0

/-- A physical-row assignment can still double-count inside one parity class. -/
def physicalRowAssignment (_ : Bool) : ℤ × ℤ := (1, 0)

/-
Disjoint formal parity classes and non-double-counting of physical rows are
logically independent properties in this witness.
-/
theorem parity_disjoint_does_not_force_row_nondoubling :
    (∀ x, GammaOdd x → GammaEven x → x = 0) ∧
      (∀ b, GammaOdd (physicalRowAssignment b)) ∧
      ¬ Function.Injective physicalRowAssignment := by
  simp +decide [GammaOdd, GammaEven, physicalRowAssignment]

end MechanismMatrix

end

end OriginOfMassAudit
