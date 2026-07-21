import PhysicsSM.Draft.NullEdge.DixonWeakLadders

/-!
# The Dirac algebra as bar operators on `C(x)H(x)O` - signature from `H` (P2)

SM-branch, plan P2 (`Sources/Null_Edge_Ten_Priorities_Research_Plan_2026-07-18.md`).
Furey 1806.00612 eq. 13 (verbatim, PDF p. 5): the Dirac generators in the Weyl
basis are the BAR operators

  `gamma^0 = 1|i_1`, `gamma^1 = i_1|i_2`, `gamma^2 = i_2|i_2`, `gamma^3 = i_3|i_2`,

where `(x|y) z = x z y` (per [47]'s bar notation; construction from Furey's
thesis [46] sec. 4.7). This module realizes them on the Dixon algebra (they only
involve the `H`-units, so they act on all of `C(x)H(x)O` with the colour factor
passing through) and kernel-checks the full Clifford table.

## The headline (P2): the Lorentzian signature EMERGES

The kernel-computed table below is `{gamma^mu, gamma^nu} = 2 eta^{mu nu}` with

  `eta = diag(-1, +1, +1, +1)`  (mostly-plus; `(gamma^0)^2 = -1`).

Per the plan discipline the statements were written from a hand computation and
the KERNEL is the arbiter - had any failed, the failure would be recorded, not
tuned away. Convention note: this is the mostly-plus signature; PhysLean and
much of the physics literature use mostly-minus `(+,-,-,-)`. The two differ by
`gamma^mu -> i gamma^mu` overall; the project convention bridge must be pinned
before any cross-import (see `Sources/Dixon_CxHxO_Convention_Reference.md` sec 5).

Also proved: `gamma^5` = right multiplication by `-i i_3` (thesis sec. 4.7 via
the paper's p. 4 footnote: chirality is right multiplication by `-i i_3`),
`(gamma^5)^2 = 1`, and `{gamma^5, gamma^mu} = 0`.

Bar operators here are maps `Dixon -> Dixon`; parenthesization `(x*z)*y` is
explicit. The `H`-units associate through the Dixon Hamilton product because
their colour coefficients are `0`/`1` (the colour factor is untouched), so no
octonion non-associativity enters - which is exactly why the Lorentz/Dirac
sector lives in the `C(x)H` factor.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.DixonDiracGamma

set_option maxHeartbeats 16000000
set_option maxRecDepth 16000

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Draft.NullEdge.DixonAlgebra
open PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon
open PhysicsSM.Draft.NullEdge.DixonWeakLadders

/-! Local `ComplexOctonion` unit/annihilator simp lemmas (the `DixonAlgebra`
copies are `private`; free-variable coefficients need them). -/
@[local simp] private theorem co_mul_one (x : ComplexOctonion) : x * 1 = x := by
  ext <;> simp
@[local simp] private theorem co_one_mul (x : ComplexOctonion) : 1 * x = x := by
  ext <;> simp
@[local simp] private theorem co_mul_zero (x : ComplexOctonion) : x * 0 = 0 := by
  ext <;> simp
@[local simp] private theorem co_zero_mul (x : ComplexOctonion) : (0 : ComplexOctonion) * x = 0 := by
  ext <;> simp
@[local simp] private theorem co_mul_neg (x y : ComplexOctonion) : x * (-y) = -(x * y) := by
  ext <;> simp [ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring
@[local simp] private theorem co_neg_mul (x y : ComplexOctonion) : (-x) * y = -(x * y) := by
  ext <;> simp [ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- Left multiplication on the Dixon algebra. -/
def Lmul (a z : Dixon) : Dixon := a * z

/-- Right multiplication on the Dixon algebra. -/
def Rmul (a z : Dixon) : Dixon := z * a

/-- Furey's bar operator `(x|y) z = (x z) y` on the Dixon algebra
(parenthesization explicit). -/
def bar (x y z : Dixon) : Dixon := (x * z) * y

/-- `gamma^0 = 1|i_1` (eq. 13). -/
def gamma0 (z : Dixon) : Dixon := bar 1 i1 z
/-- `gamma^1 = i_1|i_2` (eq. 13). -/
def gamma1 (z : Dixon) : Dixon := bar i1 i2 z
/-- `gamma^2 = i_2|i_2` (eq. 13). -/
def gamma2 (z : Dixon) : Dixon := bar i2 i2 z
/-- `gamma^3 = i_3|i_2` (eq. 13). -/
def gamma3 (z : Dixon) : Dixon := bar i3 i2 z
/-- Chirality `gamma^5`: right multiplication by `-i i_3` (thesis sec. 4.7). -/
def gamma5 (z : Dixon) : Dixon := Rmul (-(Idix * i3)) z

/-- Shared closer for the (free-variable) gamma identities: split the Dixon
slots, then the `ComplexOctonion` coordinates, then close with `ring`. -/
macro "gamma_tab" : tactic =>
  `(tactic|
    (refine Dixon.ext ?_ ?_ ?_ ?_ <;>
      ext <;>
        simp [gamma0, gamma1, gamma2, gamma3, gamma5, bar, Rmul, Lmul, Idix,
          ofColour, mul, i1, i2, i3, I, ComplexOctonion.mul_re,
          ComplexOctonion.mul_im] <;>
        ring))

/-! ## The Clifford table: diagonal -/

/-- **`(gamma^0)^2 = -1`**: the timelike direction - the minus sign of the
Lorentzian signature, emerging from the quaternions. -/
theorem gamma0_sq (z : Dixon) : gamma0 (gamma0 z) = -z := by gamma_tab

/-- **`(gamma^1)^2 = +1`**. -/
theorem gamma1_sq (z : Dixon) : gamma1 (gamma1 z) = z := by gamma_tab

/-- **`(gamma^2)^2 = +1`**. -/
theorem gamma2_sq (z : Dixon) : gamma2 (gamma2 z) = z := by gamma_tab

/-- **`(gamma^3)^2 = +1`**. -/
theorem gamma3_sq (z : Dixon) : gamma3 (gamma3 z) = z := by gamma_tab

/-! ## The Clifford table: off-diagonal anticommutators vanish -/

/-- `{gamma^0, gamma^1} = 0`. -/
theorem gamma01_anticomm (z : Dixon) :
    gamma0 (gamma1 z) + gamma1 (gamma0 z) = 0 := by gamma_tab

/-- `{gamma^0, gamma^2} = 0`. -/
theorem gamma02_anticomm (z : Dixon) :
    gamma0 (gamma2 z) + gamma2 (gamma0 z) = 0 := by gamma_tab

/-- `{gamma^0, gamma^3} = 0`. -/
theorem gamma03_anticomm (z : Dixon) :
    gamma0 (gamma3 z) + gamma3 (gamma0 z) = 0 := by gamma_tab

/-- `{gamma^1, gamma^2} = 0`. -/
theorem gamma12_anticomm (z : Dixon) :
    gamma1 (gamma2 z) + gamma2 (gamma1 z) = 0 := by gamma_tab

/-- `{gamma^1, gamma^3} = 0`. -/
theorem gamma13_anticomm (z : Dixon) :
    gamma1 (gamma3 z) + gamma3 (gamma1 z) = 0 := by gamma_tab

/-- `{gamma^2, gamma^3} = 0`. -/
theorem gamma23_anticomm (z : Dixon) :
    gamma2 (gamma3 z) + gamma3 (gamma2 z) = 0 := by gamma_tab

/-! ## Chirality -/

/-- **`(gamma^5)^2 = 1`**. -/
theorem gamma5_sq (z : Dixon) : gamma5 (gamma5 z) = z := by gamma_tab

/-- `{gamma^5, gamma^0} = 0`. -/
theorem gamma50_anticomm (z : Dixon) :
    gamma5 (gamma0 z) + gamma0 (gamma5 z) = 0 := by gamma_tab

/-- `{gamma^5, gamma^1} = 0`. -/
theorem gamma51_anticomm (z : Dixon) :
    gamma5 (gamma1 z) + gamma1 (gamma5 z) = 0 := by gamma_tab

/-- `{gamma^5, gamma^2} = 0`. -/
theorem gamma52_anticomm (z : Dixon) :
    gamma5 (gamma2 z) + gamma2 (gamma5 z) = 0 := by gamma_tab

/-- `{gamma^5, gamma^3} = 0`. -/
theorem gamma53_anticomm (z : Dixon) :
    gamma5 (gamma3 z) + gamma3 (gamma5 z) = 0 := by gamma_tab

end PhysicsSM.Draft.NullEdge.DixonDiracGamma

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.DixonDiracGamma.gamma0_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DixonDiracGamma.gamma0_sq

/-- info: 'PhysicsSM.Draft.NullEdge.DixonDiracGamma.gamma01_anticomm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DixonDiracGamma.gamma01_anticomm

/-- info: 'PhysicsSM.Draft.NullEdge.DixonDiracGamma.gamma5_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DixonDiracGamma.gamma5_sq
