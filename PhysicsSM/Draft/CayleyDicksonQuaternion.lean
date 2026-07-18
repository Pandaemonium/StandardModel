import Mathlib

/-!
# Cayley-Dickson doubling of the quaternions preserves the composition norm

SM-branch, item 5 (why the internal algebra is the octonions), FORWARD tower
direction. The companion result
`PhysicsSM/Draft/SedenionZeroDivisors.sedenion_composition_fails` shows that
doubling the NON-associative octonions LOSES the composition law. This module
proves the complementary FORWARD step: doubling the ASSOCIATIVE quaternions
PRESERVES it - `N(pq) = N(p) N(q)` for the Cayley-Dickson double of `H`. That is
exactly why the octonions (a model of the double of `H`) are a composition, hence
division, algebra. Together the two results localize Hurwitz's "why the tower
stops at O" at the loss of associativity between `H` and `O`:

* `H` associative  => its double has a multiplicative norm (this file);
* `O` non-associative => its double (the sedenions) does NOT
  (`sedenion_composition_fails`, `octonion_not_associative`).

Uses Mathlib's `Quaternion R` (associative; `normSq` multiplicative; `star` the
conjugation). Proof ported from Aristotle e9d9ebbf and kernel-verified here.
Self-contained (Mathlib only). `M [orig formalization; comp Cayley-Dickson/Hurwitz].`
-/

noncomputable section

namespace PhysicsSM.Draft.CayleyDicksonQuaternion

/-- The quaternions over `R` (associative composition algebra). -/
abbrev H := Quaternion ℝ

/-- The Cayley-Dickson double of the quaternions (a model of the octonions). -/
abbrev Octo := H × H

/-- The Cayley-Dickson product on `Octo = H × H`:
`(a,b)(c,d) = (a c - star d · b, d a + b · star c)`. -/
def cdMul (p q : Octo) : Octo :=
  (p.1 * q.1 - star q.2 * p.2, q.2 * p.1 + p.2 * star q.1)

/-- The Cayley-Dickson norm `N(a,b) = normSq a + normSq b`. -/
def cdNormSq (p : Octo) : ℝ :=
  Quaternion.normSq p.1 + Quaternion.normSq p.2

/-- **Doubling the associative quaternions preserves composition.**
`N(p · q) = N(p) · N(q)` for the Cayley-Dickson double of `H`. Because `H` is
ASSOCIATIVE (and `normSq` is multiplicative, `star` an anti-automorphism with
`star q * q = normSq q`), the octonionic double has a multiplicative norm - the
structural reason the octonions are a composition/division algebra. The
associativity of `H` is essential; the analogous doubling of the non-associative
octonions fails (`SedenionZeroDivisors.sedenion_composition_fails`). -/
theorem cd_norm_multiplicative (p q : Octo) :
    cdNormSq (cdMul p q) = cdNormSq p * cdNormSq q := by
  unfold cdNormSq cdMul
  simp [Quaternion.normSq] at *
  grind

end PhysicsSM.Draft.CayleyDicksonQuaternion

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.CayleyDicksonQuaternion.cd_norm_multiplicative' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.CayleyDicksonQuaternion.cd_norm_multiplicative
