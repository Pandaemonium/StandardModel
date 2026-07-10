import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.WeitzenbockMaster
import PhysicsSM.Draft.NullEdge.Carrier.CarrierPotentialTurn

/-!
# Move-1 ASSEMBLY - the discrete Weitzenbock square `4 D^2 = Q_A + Q_C + 4 Q_T`

Combines brick 2b (`weitzenbock_master`: `4 D0^2 = Q_A + Q_C`) with the turn brick
(`dirac_square_with_potential`: `(D0 + Gamma phi)^2 = D0^2 + phi^2` at
covariantly-constant `phi`) into the assembled square of the FULL carrier
`D = D0 + Gamma phi = sum_e gamma_e nabla_e + Gamma phi`:

>   `4 • D^2 = Q_A + Q_C + 4 • Q_T`,   with `Q_T = phi^2`.

This is the Move-1 headline at the `D^2` level, in the clean regime (flat/constant
soldering, covariantly-constant Higgs) where the gravity remainder `E` vanishes. Each
term is the named block of the discrete Weitzenbock decomposition:

* `Q_A = sum_e sum_f g e f • {nabla_e, nabla_f}`  (aperture Gram, symmetric),
* `Q_C = sum_e sum_f [gamma_e,gamma_f] [nabla_e,nabla_f]`  (closure, antisymmetric),
* `Q_T = phi^2`  (turn, the chirality-dressed potential square).

## Scope / honesty (draft)

Abstract algebra over a `CommRing`; the identity is the exact combination of the two
banked bricks under their combined hypotheses. This is the `E = 0` regime by
construction (the hypotheses `hcomm`, `hCov`, and the `Gamma` relations encode
constant soldering + covariantly-constant `Phi`); the general `E`-carrying case
(varying soldering) is the separate E-slot brick. NO Krein `#` yet - this is `D^2`,
not `D^#D`; the Krein upgrade (`D^# = D` conditions) is a later brick, and NO spectral
positivity is claimed. Identifying `Q_A/Q_C/Q_T` with the lane functionals is Move-2.

## Provenance

Direct corollary of `weitzenbock_master` (brick 2b) and `dirac_square_with_potential`
(brick Q_T), both from the Fable-5 call-01 CRACK.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier

variable {R B E : Type*} [CommRing R] [Ring B] [Algebra R B] [Fintype E]

/-- **Move-1 assembly: the carrier square decomposes as `Q_A + Q_C + 4 Q_T`.**
For the full carrier `D = D0 + Gamma phi` with the soldered `D0 = sum_e gamma_e nabla_e`,
the Clifford relation `hcl`, soldering-transport commutation `hcomm`, the chirality
relations on `Gamma`, and covariantly-constant `phi` (`hCov`):

`4 • (D0 + Gamma phi)^2
   = (sum_e sum_f g e f • {nabla_e, nabla_f})            -- Q_A
   + (sum_e sum_f [gamma_e,gamma_f] [nabla_e,nabla_f])   -- Q_C
   + 4 • phi^2`                                          -- 4 Q_T
-/
theorem carrier_square_assembly (gamma nabla : E → B) (Gamma phi : B) (g : E → E → R)
    (hcl : ∀ e f, gamma e * gamma f + gamma f * gamma e = algebraMap R B (g e f))
    (hcomm : ∀ e f, gamma e * nabla f = nabla f * gamma e)
    (hGammaSq : Gamma * Gamma = 1)
    (hGammaAnti : ∀ e, Gamma * gamma e = - (gamma e * Gamma))
    (hGammaNabla : ∀ e, Gamma * nabla e = nabla e * Gamma)
    (hPhiGamma : ∀ e, phi * gamma e = gamma e * phi)
    (hPhiComm : Gamma * phi = phi * Gamma)
    (hCov : ∀ e, nabla e * phi = phi * nabla e) :
    (4 : R) • (solderedNC gamma nabla + Gamma * phi) ^ 2
      = (∑ e, ∑ f, g e f • (nabla e * nabla f + nabla f * nabla e))
        + (∑ e, ∑ f, (gamma e * gamma f - gamma f * gamma e)
            * (nabla e * nabla f - nabla f * nabla e))
        + (4 : R) • phi ^ 2 := by
  rw [dirac_square_with_potential gamma nabla Gamma phi hGammaSq hGammaAnti hGammaNabla
        hPhiGamma hPhiComm hCov, smul_add, weitzenbock_master gamma nabla g hcl hcomm]

end PhysicsSM.Draft.NullEdge.Carrier
