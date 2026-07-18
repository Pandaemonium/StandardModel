import Mathlib

/-!
# Cayley-Dickson doubling of the quaternions preserves the composition norm

**Status: DRAFT / Aristotle handoff skeleton. Contains `s o r r y`.**

Item 5 (why the internal algebra is the octonions), FORWARD tower direction. The
companion result `PhysicsSM/Draft/SedenionZeroDivisors.sedenion_composition_fails`
shows that doubling the NON-associative octonions LOSES the composition law
(sedenions have a non-multiplicative norm and zero divisors). This module proves
the complementary FORWARD step: doubling the ASSOCIATIVE quaternions PRESERVES
the composition law - which is exactly why the octonions (the double of `H`) are
a composition, hence division, algebra. Together they localize "why the tower
stops at O" at the loss of associativity between `H` and `O`.

Uses Mathlib's `Quaternion R` (associative, with a multiplicative `normSq` and a
conjugation `star` satisfying `star q * q = normSq q`). Self-contained (Mathlib
only). Grade target: `M [orig formalization; comp Cayley-Dickson/Hurwitz theory]`.
-/

noncomputable section

namespace CDQuat

/-- The quaternions over `R` (associative composition algebra). -/
abbrev H := Quaternion ℝ

/-- The Cayley-Dickson double of the quaternions (a model of the octonions),
as a pair of quaternions. -/
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
octonions fails (`sedenion_composition_fails`). **Aristotle handoff; `s o r r y`.** -/
theorem cd_norm_multiplicative (p q : Octo) :
    cdNormSq (cdMul p q) = cdNormSq p * cdNormSq q := by
  sorry

end CDQuat
