import Mathlib
import PhysicsSM.Draft.NullEdge.GateC1.OverlapGinspargWilson
import PhysicsSM.Draft.NullEdge.GateC2.OverlapSignExistence
import PhysicsSM.Draft.NullEdge.GateC2.OverlapSignHermitian

/-!
# Gate QCD1: the finite Banks-Casher shadow (T4)

Freeze section 8 (`AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md`):
a FINITE-lattice, fixed-background spectral identity relating the
regularized chiral condensate to the eigenvalue distribution of the
overlap operator's Ginsparg-Wilson-circle spectrum. Built on this
project's existing C1/C2 overlap machinery
(`GateC1.OverlapGinspargWilson.Dov`, `GateC2.OverlapSignExistence.epsCFC`)
rather than a parallel stack, per the task directions.

## What this module supplies tonight

The GW-circle structural fact, proved here (`Dov_sub_one_unitary`): for a
chirality involution `gamma5` and sign involution `eps`, BOTH Hermitian,
the shifted overlap operator `Dov gamma5 eps - 1 = gamma5 * eps` is
UNITARY. This is the standard fact that the overlap operator's spectrum
lies on the circle `|lambda - 1| = 1` in the complex plane (the "GW
circle") - the geometric fact underlying the freeze's `lambda_hat`
circle-to-imaginary-axis map. Also: `gamma5 * Dov gamma5 eps` is
Hermitian (the gamma5-Hermiticity of the overlap Dirac operator,
`Dov^dagger = gamma5 Dov gamma5` in the usual physics notation).

## What remains (NOT attempted tonight - see `idea:qcd1-scope` in
DISCUSSION.md for the semantic-risk assessment before anyone attempts
it)

The full QCD1-i identity needs, beyond the above: (1) the explicit
`lambda_hat` Mobius map `lambda -> lambda / (1 - lambda/2)` sending the
GW circle to the imaginary axis, well-defined away from the doubler point
`lambda = 2`; (2) separating the zero-mode spectrum of `Dov` (which are
exactly the `+1`/`-1` chirality eigenspaces of `gamma5` intersected with
`ker(eps mp gamma5)`-type conditions - needs care) from the nonzero
modes; (3) the CHIRAL PAIRING lemma that nonzero-mode eigenvalues of the
gamma5-Hermitian operator pair under `gamma5` (this is flagged by the
task directions as the one step with genuine semantic risk - which map
is `lambda_hat`, where exactly the GW circle enters - and needs a
`review:qcd1-pairing` round before any Aristotle submission, not a blind
attempt); (4) the condensate sum `Sigma_Lambda(m)` itself as an explicit
finite sum over the spectral data, and the exact decomposition identity.
This is genuinely more setup than "adjacent bookkeeping" - flagging
honestly per the failure protocol rather than rushing a statement that
might silently pick the wrong spectral map.

Draft-trust: `Dov_sub_one_unitary` and `gamma5_mul_Dov_isHermitian` are
kernel-checked, no `s o r r y`, no `n a t i v e _ d e c i d e`. Claim
label: **finite identity** (GW-circle structural fact only; QCD1-i/ii
proper are NOT claimed by this file). Prerequisites:
`GateC1.OverlapGinspargWilson`, `GateC2.OverlapSignExistence`,
`GateC2.OverlapSignHermitian`.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace BanksCasherShadow

open Matrix
open PhysicsSM.Draft.NullEdge.GateC1.OverlapGinspargWilson

variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- The shifted overlap operator `Dov gamma5 eps - 1 = gamma5 * eps` is
unitary, given that `gamma5` and `eps` are BOTH Hermitian involutions.
This is the algebraic content of "the overlap operator's spectrum lies on
the Ginsparg-Wilson circle `|lambda - 1| = 1`" - the geometric fact the
freeze's `lambda_hat` map (section 8) sends to the imaginary axis. -/
theorem Dov_sub_one_unitary (gamma5 eps : Matrix Spin Spin ℂ)
    (hg5herm : gamma5.IsHermitian) (hg5sq : gamma5 * gamma5 = 1)
    (hepsherm : eps.IsHermitian) (hepssq : eps * eps = 1) :
    (Dov gamma5 eps - 1)ᴴ * (Dov gamma5 eps - 1) = 1
      ∧ (Dov gamma5 eps - 1) * (Dov gamma5 eps - 1)ᴴ = 1 := by
  have hshift : Dov gamma5 eps - 1 = gamma5 * eps := by
    unfold Dov; abel
  rw [hshift]
  constructor
  · calc (gamma5 * eps)ᴴ * (gamma5 * eps)
        = (eps * gamma5) * (gamma5 * eps) := by
          rw [Matrix.conjTranspose_mul, hg5herm.eq, hepsherm.eq]
    _ = eps * (gamma5 * gamma5) * eps := by noncomm_ring
    _ = 1 := by rw [hg5sq]; simp [hepssq]
  · calc (gamma5 * eps) * (gamma5 * eps)ᴴ
        = (gamma5 * eps) * (eps * gamma5) := by
          rw [Matrix.conjTranspose_mul, hg5herm.eq, hepsherm.eq]
    _ = gamma5 * (eps * eps) * gamma5 := by noncomm_ring
    _ = 1 := by rw [hepssq]; simp [hg5sq]

/-- The overlap Dirac operator is gamma5-Hermitian: `gamma5 * Dov` is a
Hermitian matrix (the standard physics statement
`Dov^dagger = gamma5 * Dov * gamma5`, rearranged). Given `gamma5`, `eps`
both Hermitian involutions. -/
theorem gamma5_mul_Dov_isHermitian (gamma5 eps : Matrix Spin Spin ℂ)
    (hg5herm : gamma5.IsHermitian) (hg5sq : gamma5 * gamma5 = 1)
    (hepsherm : eps.IsHermitian) :
    (gamma5 * Dov gamma5 eps).IsHermitian := by
  have : gamma5 * Dov gamma5 eps = gamma5 + eps := by
    unfold Dov
    rw [mul_add, mul_one, ← mul_assoc, hg5sq, one_mul]
  rw [this]
  exact hg5herm.add hepsherm

/-- Instantiated at the certified sign `eps = epsCFC H` (the C2 gauge
overlap sign) for a gapped Hermitian gauge Wilson operator `H`: the
shifted overlap is unitary. This connects the abstract GW-circle fact
above to the project's concrete gauge-overlap construction, pending only
the chiral-pairing/condensate layer flagged above. -/
theorem Dov_sub_one_unitary_epsCFC (H gamma5 : Matrix Spin Spin ℂ)
    [Invertible H] (hHherm : H.IsHermitian)
    (hg5herm : gamma5.IsHermitian) (hg5sq : gamma5 * gamma5 = 1) :
    (Dov gamma5 (GateC2.OverlapSignExistence.epsCFC H) - 1)ᴴ
        * (Dov gamma5 (GateC2.OverlapSignExistence.epsCFC H) - 1) = 1
      ∧ (Dov gamma5 (GateC2.OverlapSignExistence.epsCFC H) - 1)
        * (Dov gamma5 (GateC2.OverlapSignExistence.epsCFC H) - 1)ᴴ = 1 :=
  Dov_sub_one_unitary gamma5 (GateC2.OverlapSignExistence.epsCFC H) hg5herm hg5sq
    (GateC2.OverlapSignHermitian.epsCFC_isSelfAdjoint_involution H hHherm).1
    (GateC2.OverlapSignHermitian.epsCFC_isSelfAdjoint_involution H hHherm).2

end BanksCasherShadow
end GateYM
end NullEdge
end Draft
end PhysicsSM
