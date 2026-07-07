import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.WeitzenbockMaster

/-!
# Move-1 BRICK Q_T - the turn (potential) slot, chirality-dressed

The `Q_T` slot of the discrete Weitzenbock decomposition `D^2 = Q_A + Q_C + Q_T + E`.
Building on the master identity (`WeitzenbockMaster`, brick 2b) for the free square
`D0^2 = Q_A + Q_C`, this module adds a **chirality-dressed potential** and shows the
cross term is a pure covariant gradient (vanishing at a covariantly-constant Higgs),
so the full square gains exactly `Q_T = phi^2`.

## Why chirality-dressed (a corrected design)

The naive "gamma-even `Phi`" cancellation is **FALSE**: for `Phi` commuting with the
`gamma_e`, `{D0, Phi} = sum_e gamma_e ({nabla_e, phi})` retains the first-order drift
`2 phi nabla_e`, which covariant constancy does NOT kill (constancy kills the
commutator `[nabla_e, phi]`, not the anticommutator). This was caught by the Fable-5
call-01 audit. The fix: dress `Phi` with a spacetime chirality `Gamma` that
ANTI-commutes with the soldered generators. Then the cross term is exactly the
covariant gradient `sum_e gamma_e Gamma [nabla_e, phi]`, and the Yukawa reading
(mass = chirality-odd channel) is forced by the algebra.

## Hypotheses (all on one abstract algebra `B`)

* `hGammaSq : Gamma * Gamma = 1`               (chirality involution)
* `hGammaAnti : Gamma * gamma e = - (gamma e * Gamma)`   (Gamma anticommutes with soldering)
* `hGammaNabla : Gamma * nabla e = nabla e * Gamma`      (Gamma commutes with transport)
* `hPhiGamma : phi * gamma e = gamma e * phi`            (phi commutes with soldering)
* `hPhiComm : Gamma * phi = phi * Gamma`                 (phi commutes with chirality)
* `hCov : nabla e * phi = phi * nabla e`                 (phi COVARIANTLY CONSTANT)

## Scope / honesty (draft)

Abstract algebra over a `CommRing`; keeps spacetime chirality `Gamma` separate from
any internal grading (program guardrail). NO Krein `#`, NO 2-complex. `Q_T := phi^2`
is the turn slot; identifying it with the landed `turnAmplitude_eq_zero_iff` is Move-2.

## Provenance

Structure from the Fable-5 call-01 CRACK (chirality-dressed `Phi = Gamma*phi`),
correcting the packet's false gamma-even hypothesis. Continuum reading: Yukawa mass =
chirality-flipping vertex (the T-mode of the null-edge mass thesis).

Proof handoff (for Aristotle): all three are short ring computations.
- `crossTerm_eq_covariant_gradient`: expand `D0*(Gamma*phi) + (Gamma*phi)*D0` over the
  `Finset` sum; on each term use `hGammaNabla` (move `nabla_e` past `Gamma`),
  `hPhiGamma` and `hGammaAnti` (move `phi` and `Gamma` past `gamma_e`, picking up the
  sign), then collect `gamma_e * Gamma * (nabla_e * phi - phi * nabla_e)`.
- `potential_sq`: `(Gamma*phi)^2 = Gamma*phi*Gamma*phi`, use `hPhiComm` then `hGammaSq`.
- `dirac_square_with_potential`: `(D0 + Gamma*phi)^2 = D0^2 + {D0,Gamma*phi} + (Gamma*phi)^2`;
  the cross term is `0` by `crossTerm_eq_covariant_gradient` + `hCov` (each summand has
  `nabla_e*phi - phi*nabla_e = 0`); the last is `phi^2` by `potential_sq`.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier

variable {R B E : Type*} [CommRing R] [Ring B] [Algebra R B] [Fintype E]

/-- **The cross term is a pure covariant gradient.**  With a chirality `Gamma`
anticommuting with the soldered generators and commuting with transport, and a Higgs
`phi` commuting with the soldering, the anticommutator of the soldered operator with
the dressed potential `Gamma*phi` is exactly the sum of covariant gradients
`sum_e gamma_e * Gamma * [nabla_e, phi]` - no first-order drift. -/
theorem crossTerm_eq_covariant_gradient (gamma nabla : E → B) (Gamma phi : B)
    (hGammaAnti : ∀ e, Gamma * gamma e = - (gamma e * Gamma))
    (hGammaNabla : ∀ e, Gamma * nabla e = nabla e * Gamma)
    (hPhiGamma : ∀ e, phi * gamma e = gamma e * phi) :
    solderedNC gamma nabla * (Gamma * phi) + (Gamma * phi) * solderedNC gamma nabla
      = ∑ e, gamma e * Gamma * (nabla e * phi - phi * nabla e) := by
  sorry

/-- **The dressed potential squares to `phi^2`.**  `(Gamma*phi)^2 = phi^2` when
`Gamma^2 = 1` and `phi` commutes with `Gamma`. -/
theorem potential_sq (Gamma phi : B) (hGammaSq : Gamma * Gamma = 1)
    (hPhiComm : Gamma * phi = phi * Gamma) :
    (Gamma * phi) ^ 2 = phi ^ 2 := by
  sorry

/-- **The Dirac square with a covariantly-constant chirality-dressed potential.**
`(D0 + Gamma*phi)^2 = D0^2 + phi^2`: the cross term vanishes because `phi` is
covariantly constant (`hCov : nabla_e * phi = phi * nabla_e`), leaving the turn slot
`Q_T = phi^2` added to the free square `D0^2 = Q_A + Q_C`. -/
theorem dirac_square_with_potential (gamma nabla : E → B) (Gamma phi : B)
    (hGammaSq : Gamma * Gamma = 1)
    (hGammaAnti : ∀ e, Gamma * gamma e = - (gamma e * Gamma))
    (hGammaNabla : ∀ e, Gamma * nabla e = nabla e * Gamma)
    (hPhiGamma : ∀ e, phi * gamma e = gamma e * phi)
    (hPhiComm : Gamma * phi = phi * Gamma)
    (hCov : ∀ e, nabla e * phi = phi * nabla e) :
    (solderedNC gamma nabla + Gamma * phi) ^ 2
      = (solderedNC gamma nabla) ^ 2 + phi ^ 2 := by
  sorry

end PhysicsSM.Draft.NullEdge.Carrier
