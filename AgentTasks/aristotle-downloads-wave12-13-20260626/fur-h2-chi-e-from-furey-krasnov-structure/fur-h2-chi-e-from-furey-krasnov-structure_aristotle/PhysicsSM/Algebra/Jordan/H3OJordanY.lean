import Mathlib
import PhysicsSM.Algebra.Octonion.Basic
import PhysicsSM.Algebra.Octonion.Conjugation
import PhysicsSM.Algebra.Jordan.H3O

/-!
# H3O Jordan identity: y component

Proves the y coordinate equality of the Jordan identity for `h₃(𝕆)`.

Status: trusted — no `s o r r y`.
-/

namespace PhysicsSM.Algebra.Jordan.H3OJordan

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O

local infixl:70 " ○ " => jordanProduct

set_option maxHeartbeats 3200000 in
-- Jordan identity for h₃(𝕆): off-diagonal y component (8 real polynomial identities)
theorem jordanIdentity_y (a b : H3O) :
    ((a ○ b) ○ (a ○ a)).y = (a ○ (b ○ (a ○ a))).y := by
  obtain ⟨aα, aβ, aγ, ⟨ax0, ax1, ax2, ax3, ax4, ax5, ax6, ax7⟩,
                        ⟨ay0, ay1, ay2, ay3, ay4, ay5, ay6, ay7⟩,
                        ⟨az0, az1, az2, az3, az4, az5, az6, az7⟩⟩ := a
  obtain ⟨bα, bβ, bγ, ⟨bx0, bx1, bx2, bx3, bx4, bx5, bx6, bx7⟩,
                        ⟨by0, by1, by2, by3, by4, by5, by6, by7⟩,
                        ⟨bz0, bz1, bz2, bz3, bz4, bz5, bz6, bz7⟩⟩ := b
  ext <;> simp only [jordanProduct, octonionInner, conj,
    Octonion.smul_c0, Octonion.smul_c1, Octonion.smul_c2, Octonion.smul_c3,
    Octonion.smul_c4, Octonion.smul_c5, Octonion.smul_c6, Octonion.smul_c7,
    Octonion.add_c0, Octonion.add_c1, Octonion.add_c2, Octonion.add_c3,
    Octonion.add_c4, Octonion.add_c5, Octonion.add_c6, Octonion.add_c7,
    Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2, Octonion.mul_c3,
    Octonion.mul_c4, Octonion.mul_c5, Octonion.mul_c6, Octonion.mul_c7] <;>
  ring

end PhysicsSM.Algebra.Jordan.H3OJordan
