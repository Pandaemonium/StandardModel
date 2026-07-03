import PhysicsSM.Draft.NullEdge.GateC1.TetraSymbolHermitian
import PhysicsSM.Draft.NullEdge.GateC1.OverlapGinspargWilson

/-!
# Gate C1: symbol-level overlap / Ginsparg-Wilson release

This Draft module lands the chiral release at the momentum-symbol level - the
flagship payoff of the Gate C1 free-operator programme - WITHOUT any functional
calculus or spectral representation, because the tetrahedral Wilson symbol has
the Euclidean-Clifford *scalar square* property.

## The key simplification

For the Hermitian sign-kernel symbol `H = gamma5 * K` on the tetrahedral torus,
under the two chirality relations that also give self-adjointness
(`star gamma5 = gamma5`, `{gamma5, Q} = 0`, plus `gamma5` unitary),

    H(k)^2 = coeff(k) . I,     coeff(k) = (qExact(sin k) + mWilson^2) / a^2 > 0,

a *scalar* multiple of the identity (from `H^dagger = H`,
`H^dagger H = K^dagger K = coeff . I` via `K_star_mul`, and `gamma5^2 = 1`).
Because `H^2` is a positive scalar, the sign function is ELEMENTARY:

    eps(k) := coeff(k)^{-1/2} . H(k)

is an explicit self-adjoint involution (`eps^2 = I`, `star eps = eps`) - no
`sign(.)` functional calculus, no matrix diagonalization, no representation
bridge needed. The overlap Dirac symbol `Dov = 1 + gamma5 . eps` then satisfies
the Ginsparg-Wilson relation immediately, by the already-proven abstract algebra
`OverlapGinspargWilson.dov_ginsparg_wilson` (which needs only `gamma5^2 = 1` and
`eps^2 = 1`).

This discharges the "hard half" of the GW rung scoped in
`AgentTasks/nerd-gate-c1-gw-release-setup-2026-07-03.md` at the symbol level:
the scalar-square property is exactly what let the sign bypass the functional
calculus. (The remaining work to a full operator-level release is packaging
these per-momentum symbols back through the block diagonalization; that is a
successor, and does not affect the per-momentum chiral release proved here.)

## Status and claim scope

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem**.  Regulator-level per `docs/NERD_ROADMAP.md`
- this is the free (no-gauge) chiral release on the fixed tetrahedral regulator,
per momentum; NOT a gauge-background index theorem (Gate C2) and NOT a continuum
or Lorentz-invariant claim. The free global index may be zero, which is expected
(the free C1 goal is a valid GW involution + Weyl projectors, not a nonzero
vacuum index).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraSymbolOverlapGW

open TetraScalarWilsonSymbol
open TetraQMatrixSquareExact
open OverlapGinspargWilson

variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- The scalar `H`-square coefficient (the same positive coefficient as the
uniform gap): `coeff(k) = (qExact(sin k) + mWilson^2) / a^2`. -/
def sqCoeff (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) (k : Fin 4 → ℝ) : ℝ :=
  (TetraQSquareExact.qExact (sinCoeffs k) + (mWilson r rho k) ^ 2) / a ^ 2

/-- **Scalar square of the Hermitian sign-kernel symbol.**  Under the chirality
relations that make `H` self-adjoint, `H(k)^2 = coeff(k) . I`.  This is the
Euclidean-Clifford property that makes the sign elementary. -/
theorem H_symbol_sq
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) (k : Fin 4 → ℝ)
    (hgU : star gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hgH : star gamma5 = gamma5)
    (hanti : gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs k)
        + TetraEuclideanSlashData.Q D (sinCoeffs k) * gamma5 = 0) :
    H gamma5 D a r rho k * H gamma5 D a r rho k =
      ((sqCoeff D a r rho k : ℝ) : ℂ) • (1 : Matrix Spin Spin ℂ) := by
  have hHerm : star (H gamma5 D a r rho k) = H gamma5 D a r rho k :=
    TetraSymbolHermitian.H_symbol_hermitian gamma5 D a r rho k hgH hanti
  have hg2 : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ) := by
    nth_rewrite 1 [← hgH]; exact hgU
  calc
    H gamma5 D a r rho k * H gamma5 D a r rho k
        = star (H gamma5 D a r rho k) * H gamma5 D a r rho k := by rw [hHerm]
    _ = (star (K D a r rho k) * gamma5) * (gamma5 * K D a r rho k) := by
          unfold H
          rw [star_mul, hgH]
    _ = star (K D a r rho k) * K D a r rho k := by
          rw [Matrix.mul_assoc, ← Matrix.mul_assoc gamma5 gamma5,
            hg2, one_mul]
    _ = ((sqCoeff D a r rho k : ℝ) : ℂ) • (1 : Matrix Spin Spin ℂ) := by
          unfold sqCoeff; exact K_star_mul D a r rho k

/-- The elementary sign symbol `eps(k) = coeff(k)^{-1/2} . H(k)`. -/
def signSymbol (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) (k : Fin 4 → ℝ) :
    Matrix Spin Spin ℂ :=
  (((Real.sqrt (sqCoeff D a r rho k))⁻¹ : ℝ) : ℂ) • H gamma5 D a r rho k

/-- **The sign symbol is a self-adjoint involution.**  `eps^2 = I` (from the
scalar square and `coeff > 0`) and `star eps = eps` (from `H^dagger = H`). -/
theorem signSymbol_sq
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) (k : Fin 4 → ℝ)
    (hgU : star gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hgH : star gamma5 = gamma5)
    (hanti : gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs k)
        + TetraEuclideanSlashData.Q D (sinCoeffs k) * gamma5 = 0)
    (hpos : 0 < sqCoeff D a r rho k) :
    signSymbol gamma5 D a r rho k * signSymbol gamma5 D a r rho k =
      (1 : Matrix Spin Spin ℂ) := by
  have hsq := H_symbol_sq gamma5 D a r rho k hgU hgH hanti
  have hscalar :
      (((Real.sqrt (sqCoeff D a r rho k))⁻¹ : ℝ) : ℂ) *
        (((Real.sqrt (sqCoeff D a r rho k))⁻¹ : ℝ) : ℂ) *
          ((sqCoeff D a r rho k : ℝ) : ℂ) = 1 := by
    have hr : ((Real.sqrt (sqCoeff D a r rho k))⁻¹ *
        (Real.sqrt (sqCoeff D a r rho k))⁻¹ * sqCoeff D a r rho k : ℝ) = 1 := by
      have h1 : (Real.sqrt (sqCoeff D a r rho k))⁻¹ *
          (Real.sqrt (sqCoeff D a r rho k))⁻¹ = (sqCoeff D a r rho k)⁻¹ := by
        rw [← mul_inv_rev, Real.mul_self_sqrt hpos.le]
      rw [h1, inv_mul_cancel₀ hpos.ne']
    exact_mod_cast hr
  unfold signSymbol
  rw [Matrix.smul_mul, Matrix.mul_smul, smul_smul, hsq, smul_smul, hscalar,
    one_smul]

/-- The sign symbol is self-adjoint. -/
theorem signSymbol_star
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) (k : Fin 4 → ℝ)
    (hgH : star gamma5 = gamma5)
    (hanti : gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs k)
        + TetraEuclideanSlashData.Q D (sinCoeffs k) * gamma5 = 0) :
    star (signSymbol gamma5 D a r rho k) = signSymbol gamma5 D a r rho k := by
  have hHerm : star (H gamma5 D a r rho k) = H gamma5 D a r rho k :=
    TetraSymbolHermitian.H_symbol_hermitian gamma5 D a r rho k hgH hanti
  unfold signSymbol
  rw [star_smul, hHerm]
  simp [Complex.conj_ofReal]

/-- **Symbol-level overlap Ginsparg-Wilson release.**

The overlap Dirac symbol `Dov = 1 + gamma5 . eps(k)` built from the elementary
sign involution `eps(k) = coeff(k)^{-1/2} H(k)` satisfies the Ginsparg-Wilson
relation

    gamma5 * Dov + Dov * gamma5 = Dov * gamma5 * Dov

at every momentum `k` in the first Wilson band (`coeff(k) > 0`), for a Hermitian
unitary chirality `gamma5` anticommuting with the kinetic slash `Q`. -/
theorem symbol_ginsparg_wilson
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) (k : Fin 4 → ℝ)
    (hgU : star gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hgH : star gamma5 = gamma5)
    (hanti : gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs k)
        + TetraEuclideanSlashData.Q D (sinCoeffs k) * gamma5 = 0)
    (hpos : 0 < sqCoeff D a r rho k) :
    gamma5 * Dov gamma5 (signSymbol gamma5 D a r rho k)
        + Dov gamma5 (signSymbol gamma5 D a r rho k) * gamma5 =
      Dov gamma5 (signSymbol gamma5 D a r rho k) * gamma5 *
        Dov gamma5 (signSymbol gamma5 D a r rho k) := by
  have hg2 : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ) := by
    nth_rewrite 1 [← hgH]; exact hgU
  exact dov_ginsparg_wilson gamma5 (signSymbol gamma5 D a r rho k) hg2
    (signSymbol_sq gamma5 D a r rho k hgU hgH hanti hpos)

end TetraSymbolOverlapGW
end GateC1
end NullEdge
end Draft
end PhysicsSM
