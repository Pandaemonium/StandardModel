import PhysicsSM.Draft.NullEdge.GateC1.TetraScalarWilsonSymbol

/-!
# Gate C1: momentum-symbol Hermiticity of the sign-kernel symbol `H`

This Draft module banks the momentum-space half of the Gate C1
self-adjointness rung, following the exact recipe returned by the C1
operator-gap semantic red-team (Aristotle project `ffed1801`, finding 5a).

The operator-gap milestone `tetraFreeOperator_gap_equalN` proves a coercive
inverse-propagator bound `Hfree^* Hfree >= gamma` under only *unitarity* of the
chirality `gamma5`.  To upgrade that to a genuine self-adjoint spectral gap and
unlock the `sign(H)` / Ginsparg-Wilson release, `Hfree` must be self-adjoint,
which needs two further Clifford relations on `gamma5`:

* `star gamma5 = gamma5`   (Hermitian involution, the Hermitian part), and
* `{gamma5, Q} = 0`        (anticommutation with the kinetic slash `Q`).

Here we discharge the **symbol-level** consequence: under those two relations
the momentum symbol `H gamma5 D a r rho k = gamma5 * K` is self-adjoint,
`star (H ...) = H ...`, for each momentum `k`.  The remaining **real-space**
self-adjointness of `Hfree` additionally requires a bilinear field inner
product and an inner-product (not merely norm-level) Parseval identity; that is
the next rung and is left as a documented successor.

## Status and claim scope

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem** (symbol self-adjointness is forced once the
two `gamma5` Clifford relations are assumed).  Regulator-level, per
`docs/NERD_ROADMAP.md`.

Prerequisites: `TetraScalarWilsonSymbol` (the symbol `H`, `K`, and `K_star`),
`TetraQMatrixSquareExact` (`TetraEuclideanSlashData` and its slash `Q`).
Successor: real-space self-adjointness of `Hfree` (needs inner-product
Parseval), then the overlap `sign(H)` / GW release.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraSymbolHermitian

open TetraScalarWilsonSymbol
open TetraQMatrixSquareExact

variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- **Momentum-symbol Hermiticity of `H = gamma5 * K`.**

For a Hermitian chirality `gamma5` (`star gamma5 = gamma5`) that anticommutes
with the kinetic slash `Q = TetraEuclideanSlashData.Q D (sinCoeffs k)`
(`gamma5 * Q + Q * gamma5 = 0`), the Hermitian sign-kernel symbol
`H gamma5 D a r rho k` is self-adjoint.

Proof: `star (gamma5 * K) = star K * gamma5` by `star_mul` and the Hermitian
involution; `K_star` gives `star K = a⁻¹((-i) Q + m)` while `K = a⁻¹((i) Q + m)`;
the anticommutation turns `gamma5 * Q` into `-(Q * gamma5)`, matching the two
sides. -/
theorem H_symbol_hermitian
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) (k : Fin 4 → ℝ)
    (hg : star gamma5 = gamma5)
    (hanti : gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs k)
        + TetraEuclideanSlashData.Q D (sinCoeffs k) * gamma5 = 0) :
    star (H gamma5 D a r rho k) = H gamma5 D a r rho k := by
  have hgQ :
      gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs k)
        = -(TetraEuclideanSlashData.Q D (sinCoeffs k) * gamma5) :=
    eq_neg_of_add_eq_zero_left hanti
  unfold H
  rw [star_mul, hg, K_star]
  unfold K
  simp only [add_mul, mul_add, smul_mul_assoc, mul_smul_comm, one_mul, mul_one]
  rw [hgQ]
  simp only [neg_smul, smul_neg]

end TetraSymbolHermitian
end GateC1
end NullEdge
end Draft
end PhysicsSM
