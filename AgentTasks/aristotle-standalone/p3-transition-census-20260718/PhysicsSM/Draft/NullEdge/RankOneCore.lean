import PhysicsSM.Draft.NullEdge.CompositionSU2

/-!
# Rank-one closed forms for the omega-nests (bridge for the eq-36 gradings)

**Status: PROVEN structure theorems** (mirrors of the repo's
`CompositionSuSdBridge` results, restated self-containedly for this package).

The composition nests are RANK-ONE operators: they read only the head-plane
coordinates `{re.c0, re.c7, im.c0, im.c7}` of their argument and output a
multiple of ONE fixed idempotent-line state:

  `hatOmega z    = phi(z) . vIdemStar`
  `hatOmegaDag z = psi(z) . vIdem`

with explicit `C`-valued functionals `phi`, `psi`. These closed forms
COLLAPSE any composite containing `hatOmega`/`hatOmegaDag` (and their `co`
slot-lifts) to scalar-functional multiplications - substitute them to turn
the eq-36 `adT3` operator computations into short scalar algebra instead of
combinatorial rewriting.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.RankOneCore

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Draft.NullEdge.DixonWeakCARTau3 (vIdem vIdemStar)
open PhysicsSM.Draft.NullEdge.CompositionWeakLadders

set_option maxHeartbeats 64000000
set_option maxRecDepth 20000

/-- The raising-nest coefficient functional
`phi(z) = -(z.re.c7 + z.im.c0) + (z.re.c0 - z.im.c7) i`. -/
def phi (z : ComplexOctonion) : ℂ :=
  ⟨-(z.re.c7 + z.im.c0), z.re.c0 - z.im.c7⟩

/-- The lowering-nest coefficient functional
`psi(z) = (z.im.c0 - z.re.c7) - (z.re.c0 + z.im.c7) i`. -/
def psi (z : ComplexOctonion) : ℂ :=
  ⟨z.im.c0 - z.re.c7, -(z.re.c0 + z.im.c7)⟩

/-- **Rank-one closed form of the raising nest**: for every `z`,
`hatOmega z = phi(z) . vIdemStar`. -/
theorem hatOmega_rank_one (z : ComplexOctonion) :
    hatOmega z = phi z • vIdemStar := by
  unfold hatOmega phi
  ext <;>
    simp [alpha1, alpha2, alpha3,
      PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdemStar,
      ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- **Rank-one closed form of the lowering nest**: for every `z`,
`hatOmegaDag z = psi(z) . vIdem`. -/
theorem hatOmegaDag_rank_one (z : ComplexOctonion) :
    hatOmegaDag z = psi z • vIdem := by
  unfold hatOmegaDag psi
  ext <;>
    simp [alpha1_dag, alpha2_dag, alpha3_dag,
      PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem,
      ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

end PhysicsSM.Draft.NullEdge.RankOneCore
