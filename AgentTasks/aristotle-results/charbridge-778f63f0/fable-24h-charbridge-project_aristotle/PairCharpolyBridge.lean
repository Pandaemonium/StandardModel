import Mathlib
import PairCharpolyBridgeAux

/-!
# T3 (matrix bridge): characteristic polynomial of the composed step `V`

This module proves the deferred matrix-level characteristic-polynomial bridge for
the composed interacting two-particle step `V = U2 * K2` of the sibling
`PairSpectrumFixture` fixture.  The needed definitions of `PairSpectrumFixture`
(`g`, `Vz`, `V`, `p12`, `charpoly_factorization`) are copied here verbatim (the
file is not imported).

The main result `V_charpoly_eq` shows that `5 ^ 11` times the characteristic
polynomial of the physical `28 x 28` step `V` equals the explicit degree-`28`
polynomial displayed on the right-hand side of `charpoly_factorization`; composing
with `charpoly_factorization` (`V_charpoly_factored`) gives `charpoly V` (scaled by
`5^11`) as the explicit product of spectral factors.

## Method

A `28 x 28` characteristic polynomial cannot be expanded by determinant in kernel
(Leibniz over `28!`).  Instead we exhibit an explicit **integer (Gaussian)
similarity** conjugating the integer twin `Vz = 25 • V` to a block-diagonal form
`Bq = diag(16 Gaussian-integer eigenvalues) ⊕ companion(P6a) ⊕ companion(P6b)`,
where `P6a * P6b` is the scaled degree-`12` palindromic factor over `ℤ[i]`
(irreducible over `ℚ(i)` into two Gaussian sextics).  The similarity data are the
`28 x 28` matrices `Sq, Tq` (here `Array`-encoded as `SqA, TqA` for efficient
kernel evaluation).

### Disclosed `native_decide` steps

The Gaussian-integer matrix identities
`SqA*TqA = d•1`, `TqA*SqA = d•1`, `TqA*VzA*SqA = d•BqA`, the block shape of `BqA`,
and the companion annihilation/cyclicity facts are checked by `native_decide`
(matrix arithmetic only).  The bridge `Vz = VzA` between the verbatim literal and
the `Array` encoding is checked by the kernel (`decide +kernel`).  Everything else
(`charpoly_units_conj'`, `charpoly_diagonal`, `charpoly_fromBlocks_zero₂₁`, the
companion-charpoly lemma, the scalar-multiple charpoly lemma, and the final
polynomial coefficient identities) is kernel-checked.
-/

noncomputable section
open Matrix Polynomial

namespace PhysicsSM.Draft.NullEdge.PairCharpolyBridge


/-- `Vz = 25 · V`: the explicit composed interacting step (exact integer form). -/
def Vz : Matrix (Fin 28) (Fin 28) GaussianInt := !![g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g (-16) 0,g 0 12,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 25 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 12,g 9 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 15,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-20) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g (-9) 0,g 0 0,g 0 0,g 16 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 16 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g (-9) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 16 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g (-9) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 20 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-15),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 (-12),g 16 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-25) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 16 0,g 0 (-12),g 0 0,g 0 0,g 0 (-12),g (-9) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 9 0,g 0 12,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0]

/-- The composed interacting step `V` over `ℂ` (the rational-complex matrix). -/
noncomputable def V : Matrix (Fin 28) (Fin 28) ℂ :=
  (25⁻¹ : ℂ) • Vz.map GaussianInt.toComplex

/-- The degree-`12` palindromic factor `p12`. -/
def p12 {R : Type*} [CommRing R] (lam : R) : R :=
  3125 * lam ^ 12 - 2300 * lam ^ 10 + 3219 * lam ^ 8 - 6040 * lam ^ 6
    + 3219 * lam ^ 4 - 2300 * lam ^ 2 + 3125

/-- **T1.** The product of the displayed spectral factors equals the explicit
degree-`28` polynomial (the characteristic polynomial of `V`, cleared to
integer coefficients: leading coefficient `5^11 = 48828125`). Every coefficient
on the right-hand side was recomputed from the factorization; the identity is
closed by `ring`, so it holds over every commutative ring. -/
theorem charpoly_factorization {R : Type*} [CommRing R] (lam : R) :
    (lam + 1) ^ 2 * (lam - 1) ^ 4 * (25 * lam ^ 2 + 14 * lam + 25)
      * (5 * lam ^ 2 - 6 * lam + 5) ^ 2 * (5 * lam ^ 2 + 6 * lam + 5) ^ 2
      * p12 lam
    =
      48828125 * lam ^ 28 +
      (-70312500) * lam ^ 27 +
      (-35937500) * lam ^ 26 +
      43312500 * lam ^ 25 +
      113734375 * lam ^ 24 +
      (-79830000) * lam ^ 23 +
      (-254465000) * lam ^ 22 +
      229590000 * lam ^ 21 +
      201373725 * lam ^ 20 +
      (-45757764) * lam ^ 19 +
      (-390430372) * lam ^ 18 +
      82918404 * lam ^ 17 +
      482590239 * lam ^ 16 +
      (-159920640) * lam ^ 15 +
      (-331387184) * lam ^ 14 +
      (-159920640) * lam ^ 13 +
      482590239 * lam ^ 12 +
      82918404 * lam ^ 11 +
      (-390430372) * lam ^ 10 +
      (-45757764) * lam ^ 9 +
      201373725 * lam ^ 8 +
      229590000 * lam ^ 7 +
      (-254465000) * lam ^ 6 +
      (-79830000) * lam ^ 5 +
      113734375 * lam ^ 4 +
      43312500 * lam ^ 3 +
      (-35937500) * lam ^ 2 +
      (-70312500) * lam +
      48828125 := by
  simp only [p12]; ring


/-! ## Similarity data and block form (generated, verified) -/

/-! ### Array-encoded matrix data (for fast `native_decide`) -/

def vzData : Array GaussianInt := #[g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 25 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 15,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-20) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g (-9) 0,g 0 0,g 0 0,g 16 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 16 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g (-9) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 16 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g (-9) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 20 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-15),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 (-12),g 16 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-25) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 16 0,g 0 (-12),g 0 0,g 0 0,g 0 (-12),g (-9) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0]

def VzA : Matrix (Fin 28) (Fin 28) GaussianInt := Matrix.of (fun i j => vzData.getD (i.val*28+j.val) 0)

def sqData : Array GaussianInt := #[g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-1) 0,g 0 0,g (-180) (-135),g 0 0,g 1825 (-36600),g 0 0,g 1 0,g 0 0,g 180 (-135),g 0 0,g (-1825) (-36600),g 0 0,g 0 0,g 0 (-4),g 0 (-4),g (-1) 0,g 0 3,g (-1) 0,g 1 0,g 1 0,g (-10) 5,g 5 0,g 10 5,g 5 0,g 5 (-10),g 5 0,g (-5) (-10),g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 3 0,g 0 0,g 0 0,g 2 0,g 0 0,g 1 0,g (-1) 0,g 0 5,g 0 0,g 0 (-5),g 0 0,g 0 10,g 0 0,g 0 (-10),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 180 (-240),g 4500 (-6000),g (-38700) 119100,g (-967500) 2977500,g 0 0,g 0 0,g 180 240,g (-4500) (-6000),g (-38700) (-119100),g 967500 2977500,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 8000 6000,g 0 0,g 6030000 6210000,g 0 0,g 0 0,g 0 0,g 8000 (-6000),g 0 0,g 6030000 (-6210000),g 0 0,g 0 4,g 0 4,g 1 0,g 0 0,g (-1) 0,g 1 0,g 1 0,g 4 8,g 3 (-4),g (-4) 8,g 3 4,g (-8) (-4),g (-3) (-4),g 8 (-4),g (-3) 4,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-1) 0,g 0 0,g 0 0,g 0 0,g (-2) 0,g 0 0,g 1 0,g (-1) 0,g (-6) 8,g 8 (-4),g (-6) (-8),g (-8) (-4),g 3 4,g (-2) 4,g 3 (-4),g 2 4,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 3 0,g 0 0,g 2 0,g 0 0,g 1 0,g (-1) 0,g (-10) 0,g 0 0,g (-10) 0,g 0 0,g (-5) 0,g 0 0,g (-5) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 1 0,g 1 0,g 1 0,g 0 0,g (-5) 0,g 0 0,g (-5) 0,g 0 0,g (-5) 0,g 0 0,g (-5) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-20) (-15),g 0 0,g (-1575) (-5400),g 0 0,g 585500 (-704625),g 0 0,g (-20) 15,g 0 0,g (-1575) 5400,g 0 0,g 585500 704625,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-180) 240,g 4500 (-6000),g 38700 (-119100),g (-967500) 2977500,g 0 0,g 0 0,g (-180) (-240),g (-4500) (-6000),g 38700 119100,g 967500 2977500,g 1 0,g (-3) 0,g (-3) 0,g 0 0,g (-2) 0,g 0 0,g 1 0,g (-1) 0,g 4 3,g (-2) (-4),g 4 (-3),g 2 (-4),g 8 (-6),g 8 4,g 8 6,g (-8) 4,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-1) 0,g 0 (-3),g 1 0,g 1 0,g 1 0,g (-6) 3,g 3 (-4),g 6 3,g 3 4,g (-3) 6,g (-3) (-4),g 3 6,g (-3) 4,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 180 135,g 0 0,g (-1825) 36600,g 0 0,g 1 0,g 0 0,g 180 (-135),g 0 0,g (-1825) (-36600),g 0 0,g 0 0,g 0 (-4),g 0 (-4),g (-1) 0,g 0 0,g 1 0,g (-1) 0,g (-1) 0,g 4 8,g 3 (-4),g (-4) 8,g 3 4,g (-8) (-4),g (-3) (-4),g 8 (-4),g (-3) 4,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-1) 0,g 3 0,g 3 0,g 0 0,g 2 0,g 0 0,g (-1) 0,g 1 0,g 4 3,g (-2) (-4),g 4 (-3),g 2 (-4),g 8 (-6),g 8 4,g 8 6,g (-8) 4,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-180) 240,g 4500 (-6000),g 38700 (-119100),g (-967500) 2977500,g 0 0,g 0 0,g 180 240,g 4500 6000,g (-38700) (-119100),g (-967500) (-2977500),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-20) (-15),g 0 0,g (-1575) (-5400),g 0 0,g 585500 (-704625),g 0 0,g 20 (-15),g 0 0,g 1575 (-5400),g 0 0,g (-585500) (-704625),g 1 0,g 0 0,g 0 0,g 0 0,g 2 0,g 0 0,g (-1) 0,g 1 0,g (-6) 8,g 8 (-4),g (-6) (-8),g (-8) (-4),g 3 4,g (-2) 4,g 3 (-4),g 2 4,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 3,g (-1) 0,g (-1) 0,g (-1) 0,g (-6) 3,g 3 (-4),g 6 3,g 3 4,g (-3) 6,g (-3) (-4),g 3 6,g (-3) 4,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 8000 6000,g 0 0,g 6030000 6210000,g 0 0,g 0 0,g 0 0,g (-8000) 6000,g 0 0,g (-6030000) 6210000,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 180 (-240),g 4500 (-6000),g (-38700) 119100,g (-967500) 2977500,g 0 0,g 0 0,g (-180) (-240),g 4500 6000,g 38700 119100,g (-967500) (-2977500),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-320) (-240),g 0 0,g (-241200) (-248400),g 0 0,g 0 0,g 0 0,g 320 (-240),g 0 0,g 241200 (-248400),g 0 0,g 0 0,g 0 (-4),g 0 (-4),g (-1) 0,g 0 3,g (-1) 0,g 1 0,g 1 0,g 10 (-5),g (-5) 0,g (-10) (-5),g (-5) 0,g (-5) 10,g (-5) 0,g 5 10,g (-5) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 3 0,g 0 0,g 0 0,g 2 0,g 0 0,g 1 0,g (-1) 0,g 0 (-5),g 0 0,g 0 5,g 0 0,g 0 (-10),g 0 0,g 0 10,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 3 0,g 0 0,g 2 0,g 0 0,g 1 0,g (-1) 0,g 10 0,g 0 0,g 10 0,g 0 0,g 5 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 1 0,g 1 0,g 1 0,g 0 0,g 5 0,g 0 0,g 5 0,g 0 0,g 5 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 320 240,g 0 0,g 241200 248400,g 0 0,g 0 0,g 0 0,g 320 (-240),g 0 0,g 241200 (-248400),g 0 0]

def SqA : Matrix (Fin 28) (Fin 28) GaussianInt := Matrix.of (fun i j => sqData.getD (i.val*28+j.val) 0)

def tqData : Array GaussianInt := #[g 0 0,g 0 22500000,g 16875000 0,g 0 0,g 0 0,g 0 (-22500000),g (-110625000) 0,g 16875000 0,g 0 22500000,g 0 0,g 0 0,g 76875000 0,g 0 (-22500000),g 0 0,g 0 22500000,g (-76875000) 0,g 0 0,g 0 0,g 110625000 0,g 0 22500000,g 0 0,g 0 0,g 0 0,g 0 22500000,g 16875000 0,g 16875000 0,g 0 22500000,g 0 0,g 0 0,g 0 7500000,g 36875000 0,g 0 0,g 0 0,g 0 (-7500000),g (-5625000) 0,g (-25625000) 0,g 0 7500000,g 0 0,g 0 0,g (-5625000) 0,g 0 (-7500000),g 0 0,g 0 7500000,g 5625000 0,g 0 0,g 0 0,g 5625000 0,g 0 7500000,g 0 0,g 0 0,g 0 0,g 0 7500000,g 36875000 0,g (-25625000) 0,g 0 7500000,g 0 0,g 0 0,g 0 7500000,g (-25625000) 0,g 0 0,g 0 0,g 0 (-7500000),g (-5625000) 0,g 36875000 0,g 0 7500000,g 0 0,g 0 0,g (-5625000) 0,g 0 (-7500000),g 0 0,g 0 7500000,g 5625000 0,g 0 0,g 0 0,g 5625000 0,g 0 7500000,g 0 0,g 0 0,g 0 0,g 0 7500000,g (-25625000) 0,g 36875000 0,g 0 7500000,g 0 0,g 0 0,g (-16875000) 0,g 0 (-22500000),g 0 0,g 0 0,g 16875000 0,g 0 22500000,g 0 (-22500000),g 76875000 0,g 0 0,g 0 0,g 0 22500000,g (-76875000) 0,g 0 0,g (-16875000) 0,g 0 (-22500000),g 0 0,g 0 0,g 0 (-22500000),g 76875000 0,g 0 0,g 0 0,g 0 0,g (-16875000) 0,g 0 (-22500000),g 0 (-22500000),g 76875000 0,g 0 0,g 0 0,g 0 (-11250000),g 15000000 0,g 0 0,g 0 0,g 0 11250000,g (-15000000) 0,g 15000000 0,g 0 (-11250000),g 0 0,g 0 0,g (-15000000) 0,g 0 11250000,g 0 0,g 0 (-11250000),g 15000000 0,g 0 0,g 0 0,g 15000000 0,g 0 (-11250000),g 0 0,g 0 0,g 0 0,g 0 (-11250000),g 15000000 0,g 15000000 0,g 0 (-11250000),g 0 0,g 0 0,g (-30000000) 0,g 0 22500000,g 0 0,g 0 0,g (-63750000) 0,g 0 (-22500000),g 0 22500000,g 63750000 0,g 0 0,g 0 0,g 0 (-22500000),g 30000000 0,g 0 0,g 63750000 0,g 0 22500000,g 0 0,g 0 0,g 0 22500000,g (-30000000) 0,g 0 0,g 0 0,g 0 0,g (-30000000) 0,g 0 22500000,g 0 22500000,g 63750000 0,g 0 0,g 0 0,g 23437500 0,g 23437500 0,g 0 0,g 0 0,g 23437500 0,g 23437500 0,g 23437500 0,g 23437500 0,g 0 0,g 0 0,g 23437500 0,g 23437500 0,g 0 0,g (-23437500) 0,g (-23437500) 0,g 0 0,g 0 0,g (-23437500) 0,g (-23437500) 0,g 0 0,g 0 0,g 0 0,g 23437500 0,g 23437500 0,g 23437500 0,g 23437500 0,g 0 0,g 0 0,g 23437500 0,g (-23437500) 0,g 0 0,g 0 0,g 23437500 0,g (-23437500) 0,g (-23437500) 0,g 23437500 0,g 0 0,g 0 0,g (-23437500) 0,g 23437500 0,g 0 0,g (-23437500) 0,g 23437500 0,g 0 0,g 0 0,g 23437500 0,g (-23437500) 0,g 0 0,g 0 0,g 0 0,g 23437500 0,g (-23437500) 0,g (-23437500) 0,g 23437500 0,g 0 0,g 0 0,g (-3750000) (-1875000),g 0 (-3750000),g 0 0,g 0 0,g 3750000 (-1875000),g 0 0,g (-7500000) 0,g (-3750000) (-1875000),g 0 0,g 0 0,g 0 0,g (-3750000) 1875000,g 0 0,g 3750000 (-1875000),g 0 0,g 0 0,g 0 0,g 0 0,g (-3750000) 1875000,g 0 0,g 0 0,g 0 0,g 3750000 1875000,g 0 3750000,g 7500000 0,g 3750000 1875000,g 0 0,g 0 0,g 0 0,g (-1875000) (-3750000),g 0 0,g 0 0,g 5625000 0,g 7500000 3750000,g (-7500000) 3750000,g (-9375000) 0,g 0 0,g 0 0,g (-1875000) 3750000,g 0 7500000,g 0 0,g 5625000 0,g (-1875000) 3750000,g 0 0,g 0 0,g 7500000 3750000,g 0 7500000,g 0 0,g 0 0,g 0 0,g 0 0,g 1875000 3750000,g 7500000 (-3750000),g 9375000 0,g 0 0,g 0 0,g 3750000 (-1875000),g 0 3750000,g 0 0,g 0 0,g (-3750000) (-1875000),g 0 0,g (-7500000) 0,g 3750000 (-1875000),g 0 0,g 0 0,g 0 0,g 3750000 1875000,g 0 0,g (-3750000) (-1875000),g 0 0,g 0 0,g 0 0,g 0 0,g 3750000 1875000,g 0 0,g 0 0,g 0 0,g (-3750000) 1875000,g 0 (-3750000),g 7500000 0,g (-3750000) 1875000,g 0 0,g 0 0,g 0 0,g 1875000 (-3750000),g 0 0,g 0 0,g 5625000 0,g (-7500000) 3750000,g 7500000 3750000,g (-9375000) 0,g 0 0,g 0 0,g 1875000 3750000,g 0 (-7500000),g 0 0,g 5625000 0,g 1875000 3750000,g 0 0,g 0 0,g (-7500000) 3750000,g 0 (-7500000),g 0 0,g 0 0,g 0 0,g 0 0,g (-1875000) 3750000,g (-7500000) (-3750000),g 9375000 0,g 0 0,g 0 0,g 1875000 3750000,g 0 (-7500000),g 0 0,g 0 0,g (-1875000) 3750000,g 0 0,g (-3750000) 0,g 1875000 3750000,g 0 0,g 0 0,g 0 0,g 1875000 (-3750000),g 0 0,g (-1875000) 3750000,g 0 0,g 0 0,g 0 0,g 0 0,g 1875000 (-3750000),g 0 0,g 0 0,g 0 0,g (-1875000) (-3750000),g 0 7500000,g 3750000 0,g (-1875000) (-3750000),g 0 0,g 0 0,g 0 0,g 7500000 3750000,g 0 0,g 0 0,g (-5625000) 0,g (-1875000) (-3750000),g 1875000 (-3750000),g (-9375000) 0,g 0 0,g 0 0,g 7500000 (-3750000),g 0 7500000,g 0 0,g (-5625000) 0,g 7500000 (-3750000),g 0 0,g 0 0,g (-1875000) (-3750000),g 0 7500000,g 0 0,g 0 0,g 0 0,g 0 0,g (-7500000) (-3750000),g (-1875000) 3750000,g 9375000 0,g 0 0,g 0 0,g (-1875000) 3750000,g 0 7500000,g 0 0,g 0 0,g 1875000 3750000,g 0 0,g (-3750000) 0,g (-1875000) 3750000,g 0 0,g 0 0,g 0 0,g (-1875000) (-3750000),g 0 0,g 1875000 3750000,g 0 0,g 0 0,g 0 0,g 0 0,g (-1875000) (-3750000),g 0 0,g 0 0,g 0 0,g 1875000 (-3750000),g 0 (-7500000),g 3750000 0,g 1875000 (-3750000),g 0 0,g 0 0,g 0 0,g (-7500000) 3750000,g 0 0,g 0 0,g (-5625000) 0,g 1875000 (-3750000),g (-1875000) (-3750000),g (-9375000) 0,g 0 0,g 0 0,g (-7500000) (-3750000),g 0 (-7500000),g 0 0,g (-5625000) 0,g (-7500000) (-3750000),g 0 0,g 0 0,g 1875000 (-3750000),g 0 (-7500000),g 0 0,g 0 0,g 0 0,g 0 0,g 7500000 (-3750000),g 1875000 3750000,g 9375000 0,g 0 0,g (-187500000) 0,g 0 0,g 0 0,g 0 (-42968750),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 42968750,g 0 0,g 0 0,g 187500000 0,g 0 0,g 0 0,g 0 42968750,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-42968750),g 41015625 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-41015625) 0,g 0 0,g 0 0,g 0 0,g 0 (-1718750),g (-1640625) 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-6000000) 4500000,g 0 (-1718750),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-1718750),g (-6000000) 4500000,g 0 0,g 0 0,g (-1640625) 0,g 0 (-1718750),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 101250 191250,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-101250) (-191250),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-101250) (-191250),g 0 0,g 0 0,g 0 0,g 0 0,g 101250 191250,g (-88125) 129375,g 0 0,g 0 0,g 0 0,g 0 0,g 88125 (-129375),g 0 0,g 0 0,g 0 0,g 4050 7650,g 3525 (-5175),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 4050 7650,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 4050 7650,g 0 0,g 0 0,g 0 0,g 3525 (-5175),g 4050 7650,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-150) (-200),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 150 200,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 150 200,g 0 0,g 0 0,g 0 0,g 0 0,g (-150) (-200),g (-300) 225,g 0 0,g 0 0,g 0 0,g 0 0,g 300 (-225),g 0 0,g 0 0,g 0 0,g (-6) (-8),g 12 (-9),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-6) (-8),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-6) (-8),g 0 0,g 0 0,g 0 0,g 12 (-9),g (-6) (-8),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 187500000 0,g 0 0,g 0 0,g 0 42968750,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-42968750),g 0 0,g 0 0,g 187500000 0,g 0 0,g 0 0,g 0 42968750,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-42968750),g (-41015625) 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-41015625) 0,g 0 0,g 0 0,g 0 0,g 0 (-1718750),g (-1640625) 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-6000000) (-4500000),g 0 (-1718750),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 1718750,g 6000000 4500000,g 0 0,g 0 0,g 1640625 0,g 0 1718750,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 101250 (-191250),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-101250) 191250,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 101250 (-191250),g 0 0,g 0 0,g 0 0,g 0 0,g (-101250) 191250,g 88125 129375,g 0 0,g 0 0,g 0 0,g 0 0,g 88125 129375,g 0 0,g 0 0,g 0 0,g (-4050) 7650,g 3525 5175,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-4050) 7650,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 4050 (-7650),g 0 0,g 0 0,g 0 0,g (-3525) (-5175),g 4050 (-7650),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-150) 200,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 150 (-200),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-150) 200,g 0 0,g 0 0,g 0 0,g 0 0,g 150 (-200),g 300 225,g 0 0,g 0 0,g 0 0,g 0 0,g 300 225,g 0 0,g 0 0,g 0 0,g 6 (-8),g 12 9,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 6 (-8),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-6) 8,g 0 0,g 0 0,g 0 0,g (-12) (-9),g (-6) 8,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0]

def TqA : Matrix (Fin 28) (Fin 28) GaussianInt := Matrix.of (fun i j => tqData.getD (i.val*28+j.val) 0)

def bqData : Array GaussianInt := #[g 25 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 25 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 25 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 25 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-25) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-25) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-7) 24,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-7) (-24),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 15 20,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 15 20,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 15 (-20),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 15 (-20),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-15) 20,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-15) 20,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-15) (-20),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-15) (-20),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 195312500 146484375,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g (-165625) (-18750),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 230 135,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 195312500 (-146484375),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g (-165625) 18750,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 230 (-135),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0]

def BqA : Matrix (Fin 28) (Fin 28) GaussianInt := Matrix.of (fun i j => bqData.getD (i.val*28+j.val) 0)

def compAData : Array GaussianInt := #[g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 195312500 146484375,g 1 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g (-165625) (-18750),g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 230 135,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0]

def compA : Matrix (Fin 6) (Fin 6) GaussianInt := Matrix.of (fun i j => compAData.getD (i.val*6+j.val) 0)

def compBData : Array GaussianInt := #[g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 195312500 (-146484375),g 1 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g (-165625) 18750,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 230 (-135),g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0]

def compB : Matrix (Fin 6) (Fin 6) GaussianInt := Matrix.of (fun i j => compBData.getD (i.val*6+j.val) 0)





def dscale : GaussianInt := g 375000000 0



/-! ## Bridge from the verbatim literal `Vz` to the `Array` encoding `VzA` -/

set_option maxRecDepth 100000 in
theorem hVzA : Vz = VzA := by decide +kernel

/-! ## Verified computational facts (`native_decide`, disclosed) -/

theorem hST : SqA * TqA = dscale • (1 : Matrix (Fin 28) (Fin 28) GaussianInt) := by native_decide

theorem hTS : TqA * SqA = dscale • (1 : Matrix (Fin 28) (Fin 28) GaussianInt) := by native_decide

theorem hconj : TqA * VzA * SqA = dscale • BqA := by native_decide

/-! ## Block form of `BqA` -/

def eEquiv : Fin 16 ⊕ (Fin 6 ⊕ Fin 6) ≃ Fin 28 :=
  (Equiv.sumCongr (Equiv.refl (Fin 16)) finSumFinEquiv).trans finSumFinEquiv

def Bblock : Matrix (Fin 16 ⊕ (Fin 6 ⊕ Fin 6)) (Fin 16 ⊕ (Fin 6 ⊕ Fin 6)) GaussianInt :=
  Matrix.fromBlocks (Matrix.diagonal diag16f) 0 0 (Matrix.fromBlocks compA 0 0 compB)

theorem hBshape : BqA = Matrix.reindex eEquiv eEquiv Bblock := by native_decide

theorem hA_aeval : (Polynomial.aeval compA) P6aZ = 0 := by
  unfold P6aZ
  simp only [map_add, map_mul, map_pow, aeval_X, aeval_C, Algebra.algebraMap_eq_smul_one]
  native_decide
theorem hB_aeval : (Polynomial.aeval compB) P6bZ = 0 := by
  unfold P6bZ
  simp only [map_add, map_mul, map_pow, aeval_X, aeval_C, Algebra.algebraMap_eq_smul_one]
  native_decide
theorem hA_cyc : ∀ k : Fin 6,
    (compA ^ (k : ℕ)).mulVec (Pi.single (0 : Fin 6) (1 : GaussianInt)) = Pi.single k 1 := by
  native_decide
theorem hB_cyc : ∀ k : Fin 6,
    (compB ^ (k : ℕ)).mulVec (Pi.single (0 : Fin 6) (1 : GaussianInt)) = Pi.single k 1 := by
  native_decide

theorem hP6aZ_monic : P6aZ.Monic := by unfold P6aZ; monicity!
theorem hP6aZ_deg : P6aZ.natDegree = 6 := by unfold P6aZ; compute_degree!
theorem hP6bZ_monic : P6bZ.Monic := by unfold P6bZ; monicity!
theorem hP6bZ_deg : P6bZ.natDegree = 6 := by unfold P6bZ; compute_degree!

theorem hcharA : compA.charpoly = P6aZ :=
  companion_charpoly compA P6aZ hP6aZ_monic hP6aZ_deg hA_aeval hA_cyc
theorem hcharB : compB.charpoly = P6bZ :=
  companion_charpoly compB P6bZ hP6bZ_monic hP6bZ_deg hB_aeval hB_cyc

/-! ## Characteristic polynomial of `BqA`, hence of `Vz` -/

theorem BqA_charpoly :
    BqA.charpoly = (∏ i : Fin 16, (Polynomial.X - Polynomial.C (diag16f i))) * P6aZ * P6bZ := by
  rw [hBshape, Matrix.charpoly_reindex]
  unfold Bblock
  rw [Matrix.charpoly_fromBlocks_zero₂₁, Matrix.charpoly_fromBlocks_zero₂₁,
    Matrix.charpoly_diagonal, hcharA, hcharB]
  ring


theorem hd_ne : GaussianInt.toComplex dscale ≠ 0 := by
  unfold dscale g; rw [GaussianInt.toComplex_def]; norm_num

/-- Characteristic polynomial of the `Array`-encoded twin. -/
theorem VzA_charpoly_eq : VzA.charpoly = Rpoly := by
  rw [charpoly_conj_of_scaled SqA TqA VzA BqA dscale hd_ne hST hTS hconj,
    BqA_charpoly, prod_eq_Rpoly]

/-- The integer twin's characteristic polynomial. -/
theorem Vz_charpoly_eq : Vz.charpoly = Rpoly := by
  rw [hVzA]; exact VzA_charpoly_eq

/-! ## Scaling to the physical matrix `V` -/

theorem g_intCast (n : ℤ) : g n 0 = (n : GaussianInt) := by unfold g; rfl

set_option maxRecDepth 100000 in
/-- The characteristic polynomial of the physical step `V`, in scaled/composed form
from the integer twin's characteristic polynomial `Rpoly`. -/
theorem V_charpoly_scaled :
    V.charpoly = Polynomial.C (((25 : ℂ)⁻¹) ^ 28)
      * (Rpoly.map GaussianInt.toComplex).comp (Polynomial.C 25 * Polynomial.X) := by
  have hV : V = (25⁻¹ : ℂ) • (VzA.map GaussianInt.toComplex) := by
    show (25⁻¹ : ℂ) • (Vz.map GaussianInt.toComplex) = (25⁻¹ : ℂ) • (VzA.map GaussianInt.toComplex)
    rw [hVzA]
  rw [hV, charpoly_smul (25⁻¹ : ℂ) (by norm_num) (VzA.map GaussianInt.toComplex),
    Matrix.charpoly_map, VzA_charpoly_eq, inv_inv]

set_option maxHeartbeats 4000000 in
/-- **Main result (matrix bridge).** `5 ^ 11` times the characteristic polynomial of
the physical composed step `V` equals the explicit degree-`28` polynomial displayed
on the right-hand side of `charpoly_factorization`. -/
theorem V_charpoly_eq :
    Polynomial.C (48828125 : ℂ) * V.charpoly =
      48828125 * X ^ 28 +
      (-70312500) * X ^ 27 +
      (-35937500) * X ^ 26 +
      43312500 * X ^ 25 +
      113734375 * X ^ 24 +
      (-79830000) * X ^ 23 +
      (-254465000) * X ^ 22 +
      229590000 * X ^ 21 +
      201373725 * X ^ 20 +
      (-45757764) * X ^ 19 +
      (-390430372) * X ^ 18 +
      82918404 * X ^ 17 +
      482590239 * X ^ 16 +
      (-159920640) * X ^ 15 +
      (-331387184) * X ^ 14 +
      (-159920640) * X ^ 13 +
      482590239 * X ^ 12 +
      82918404 * X ^ 11 +
      (-390430372) * X ^ 10 +
      (-45757764) * X ^ 9 +
      201373725 * X ^ 8 +
      229590000 * X ^ 7 +
      (-254465000) * X ^ 6 +
      (-79830000) * X ^ 5 +
      113734375 * X ^ 4 +
      43312500 * X ^ 3 +
      (-35937500) * X ^ 2 +
      (-70312500) * X +
      48828125 := by
  rw [V_charpoly_scaled]
  apply Polynomial.funext
  intro r
  simp only [Rpoly, eval_mul, eval_C, eval_add, eval_neg, eval_pow, eval_X, eval_comp, eval_map,
    eval_ofNat, eval₂_add, eval₂_mul, eval₂_C, eval₂_X, eval₂_pow]
  simp only [g_intCast, map_intCast]
  push_cast
  ring

/-- Corollary: composing with `charpoly_factorization`, the scaled characteristic
polynomial of `V` equals the explicit product of spectral factors. -/
theorem V_charpoly_factored :
    Polynomial.C (48828125 : ℂ) * V.charpoly =
      (Polynomial.X + 1) ^ 2 * (Polynomial.X - 1) ^ 4
        * (Polynomial.C 25 * Polynomial.X ^ 2 + Polynomial.C 14 * Polynomial.X + Polynomial.C 25)
        * (Polynomial.C 5 * Polynomial.X ^ 2 - Polynomial.C 6 * Polynomial.X + Polynomial.C 5) ^ 2
        * (Polynomial.C 5 * Polynomial.X ^ 2 + Polynomial.C 6 * Polynomial.X + Polynomial.C 5) ^ 2
        * p12 Polynomial.X := by
  rw [V_charpoly_eq]
  exact (charpoly_factorization (R := Polynomial ℂ) Polynomial.X).symm

end PhysicsSM.Draft.NullEdge.PairCharpolyBridge

end
