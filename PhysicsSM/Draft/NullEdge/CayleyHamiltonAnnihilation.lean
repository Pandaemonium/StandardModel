/-
Provenance: Aristotle job dac47b71 (fable-24h-chlighten), harvested
2026-07-12 ~05:00 PDT. KERNEL-ONLY (0 native). Namespace renamed to
CayleyHamiltonAnnihilation to avoid clashing with PairCharpolyBridge
(which shares the copied V/Vz/g defs). Contents: the reusable general
lemma aeval_eq_zero_of_charpoly_smul (C c * M.charpoly = P => aeval M P
= 0, pure Cayley-Hamilton), and V_annihilated derived KERNEL-ONLY from
the charpoly identity taken as hypothesis - so the E fixture's
annihilation is a kernel consequence of V_charpoly_eq, not an
independent heavy native.
-/
/-
Lightened companion to `context/PairCharpolyBridge.lean`.

Goal: derive `V_annihilated` — the explicit degree-28 polynomial `charpolyRHS`
evaluated at the matrix `V` is `0` (`aeval V charpolyRHS = 0`) — using ONLY the
kernel Cayley–Hamilton theorem `Matrix.aeval_self_charpoly` together with the
charpoly identity `V_charpoly_eq` (`C (5^11) * V.charpoly = charpolyRHS`).

This removes one independent heavy `native_decide` (the `Vz^28`-style annihilation
check): `V_annihilated` is obtained purely in the kernel from the charpoly
identity, with no matrix power expansion.

The charpoly identity itself is the heavy result proved by `native_decide` in the
sibling fixture module `PairCharpolyBridge` (`V_charpoly_eq`). To keep THIS module
light (it is deliberately not routed through the heavy 28x28 `native_decide`), the
charpoly identity is taken as an explicit hypothesis of `V_annihilated` (named
`V_charpoly_eq`), exactly matching the statement proved in the fixture. The
`V, Vz, g, charpolyRHS` definitions are copied verbatim from the fixture so the
hypothesis and conclusion have the same shape there.
-/
import Mathlib

noncomputable section
open Matrix Polynomial

namespace PhysicsSM.Draft.NullEdge.CayleyHamiltonAnnihilation

/-- `g a b = a + b·i` as a Gaussian integer (copied verbatim from the fixture). -/
def g (a b : ℤ) : GaussianInt := ⟨a, b⟩

/-- `Vz = 25 · V`: the explicit composed interacting step (copied verbatim). -/
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

/-- The composed interacting step `V` over `ℂ` (copied verbatim). -/
noncomputable def V : Matrix (Fin 28) (Fin 28) ℂ :=
  (25⁻¹ : ℂ) • Vz.map GaussianInt.toComplex

/-- The explicit degree-`28` polynomial (`5^11` times `charpoly V`), copied
verbatim as the right-hand side of the fixture `V_charpoly_eq`. -/
def charpolyRHS : Polynomial ℂ :=
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
      48828125

/-- **General kernel reduction.** If a scalar multiple `C c * M.charpoly` of the
characteristic polynomial of a matrix `M` equals a polynomial `P`, then `P`
annihilates `M`. This is pure Cayley–Hamilton (`Matrix.aeval_self_charpoly`)
plus the algebra-hom property of `aeval`; no determinant/power expansion. -/
theorem aeval_eq_zero_of_charpoly_smul {n : Type*} [DecidableEq n] [Fintype n]
    {R : Type*} [CommRing R] (M : Matrix n n R) (c : R) (P : Polynomial R)
    (h : C c * M.charpoly = P) : aeval M P = 0 := by
  rw [← h, map_mul, Matrix.aeval_self_charpoly, mul_zero]

/-- **`V_annihilated`.** The explicit degree-`28` polynomial `charpolyRHS`
(`= 5^11 · charpoly V`) annihilates the physical composed step matrix `V`:
`aeval V charpolyRHS = 0`.

Derived KERNEL-ONLY from the charpoly identity `V_charpoly_eq`
(`C (5^11) * V.charpoly = charpolyRHS`, the heavy fixture result) via the
Cayley–Hamilton theorem: `aeval V charpolyRHS = aeval V (C (5^11) * V.charpoly)
= aeval V (C (5^11)) * aeval V V.charpoly = (5^11 : matrix scalar) * 0 = 0`.
The scalar `C (5^11)` factor is handled by `map_mul` (algebra-hom property of
`aeval`), so no separate heavy `Vz^28` `native_decide` is needed here. -/
theorem V_annihilated
    (V_charpoly_eq : Polynomial.C (48828125 : ℂ) * V.charpoly = charpolyRHS) :
    aeval V charpolyRHS = 0 :=
  aeval_eq_zero_of_charpoly_smul V 48828125 charpolyRHS V_charpoly_eq

end PhysicsSM.Draft.NullEdge.CayleyHamiltonAnnihilation

end
