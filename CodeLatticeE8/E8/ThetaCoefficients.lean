import CodeLatticeE8.E8.ShortVectors
import CodeLatticeE8.Theta.Sigma
import CodeLatticeE8.ConstructionA.ThetaConvolution

/-!
# Semantic low-index theta shells for Hamming Construction A E8

This module records the small semantic theta-shell facts that are already
available in the standalone package.

The unscaled Construction A model uses `sqNorm z = sum_i z_i^2`.  Under the
usual E8 normalization, the coefficient of `q^n` counts vectors with
`sqNorm z = 4 * n`.

Main facts:

- the `q^0` shell is the singleton `{0}`;
- the `q^1` shell is the short shell already counted in
  `CodeLatticeE8.E8.ShortVectors`;
- these two coefficients agree with the normalized `E4` coefficient function.
- the semantic shell `constructionAShellSet s` equals `hammingE8Shell ↑s`.

Higher finite coefficients are packaged as a Hamming weight-contribution table
in `CodeLatticeE8.E8.ThetaTable`; the full unbounded bridge belongs in
the SPL companion package.  The all-shell convolution theorem is in
`CodeLatticeE8.ConstructionA.ThetaConvolution`.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.E8

open CodeLatticeE8.ConstructionA
open CodeLatticeE8.Theta
open CodeLatticeE8

/-- The semantic shell of the Hamming Construction A integer model at unscaled norm `s`. -/
def hammingE8Shell (s : ℤ) : Set (Fin 8 → ℤ) :=
  {z | z ∈ hammingConstructionA ∧ sqNorm z = s}

/-- The zero shell is exactly the singleton containing the zero vector. -/
theorem hammingE8Shell_zero_eq_singleton :
    hammingE8Shell 0 = {0} := by
  ext z
  constructor
  · intro hz
    exact (sqNorm_eq_zero_iff z).mp hz.2
  · intro hz
    rw [Set.mem_singleton_iff] at hz
    subst hz
    simp [hammingE8Shell, sqNorm]

/-- The semantic zero shell has cardinality one. -/
theorem hammingE8Shell_zero_ncard :
    Set.ncard (hammingE8Shell 0) = 1 := by
  rw [hammingE8Shell_zero_eq_singleton]
  simp

/-- The semantic shell at unscaled norm four is the short shell. -/
theorem hammingE8Shell_four_eq_shortShell :
    hammingE8Shell 4 = hammingE8ShortShell := by
  rfl

/-- The first nonconstant theta coefficient is the E8 kissing number `240`. -/
theorem hammingE8Shell_four_ncard :
    Set.ncard (hammingE8Shell 4) = 240 := by
  rw [hammingE8Shell_four_eq_shortShell]
  exact hammingConstructionA_short_vector_count

/-- The semantic `q^0` theta coefficient agrees with the normalized `E4` coefficient. -/
theorem semanticThetaCoeff_eq_e4Coeff_zero :
    Set.ncard (hammingE8Shell 0) = e4Coeff 0 := by
  rw [hammingE8Shell_zero_ncard, e4Coeff_zero]

/-- The semantic `q^1` theta coefficient agrees with the normalized `E4` coefficient. -/
theorem semanticThetaCoeff_eq_e4Coeff_one :
    Set.ncard (hammingE8Shell 4) = e4Coeff 1 := by
  rw [hammingE8Shell_four_ncard, e4Coeff_one]

/-! ## Bridge to the Construction A convolution shell -/

/-- The `hammingE8Shell` at a natural number coincides with
`constructionAShellSet`. -/
theorem hammingE8Shell_nat_eq_constructionAShellSet (s : ℕ) :
    hammingE8Shell ↑s = constructionAShellSet s := by
  rfl

end CodeLatticeE8.E8
