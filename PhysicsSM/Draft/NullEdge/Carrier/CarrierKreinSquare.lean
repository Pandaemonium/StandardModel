import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.WeitzenbockMasterPair
import PhysicsSM.Draft.NullEdge.Carrier.CarrierPotentialTurn

/-!
# Move-1 BRICK - the KREIN square `D^#D` upgrade

Transports the Move-1 assembly from the *algebraic* square `D^2` to the physical
**Krein square** `D^#D = star D * D` (Fable-5 call-02 CRACK 1). Mass is `inf spec D^#D`,
and on an indefinite (Krein) space `D^2 != D^#D`, so this is the brick that turns the
`D^2` scaffold into a mass-form statement.

Using `weitzenbock_master_pair` with `m := star nabla`, `n := nabla` (so
`star D0 = sum_e (star nabla_e) gamma_e` when `star gamma_e = gamma_e`), the Krein square
of the full carrier `D = D0 + Gamma phi` decomposes as:

>   `4 • (star D * D) = Q_A^# + Q_C^# + 4 Q_T + 4 E_#`

- `Q_A^# = sum_ef g e f • (star nabla_e * nabla_f + star nabla_f * nabla_e)` - the
  **positivity-carrying** aperture block (a sum of `star X * X`-shaped terms - unlike the
  bare `Q_A`, this one has a chance at `>= 0`);
- `Q_C^# = sum_ef [gamma_e,gamma_f] (star nabla_e * nabla_f - star nabla_f * nabla_e)`;
- `Q_T = phi^2` (the potential is Krein-self-adjoint via `hphiStar` + `hGammaStar` + `hPhiComm`);
- `E_# = sum_e gamma_e Gamma phi (star nabla_e - nabla_e)` - the **Krein self-adjointness
  defect**: covariant constancy alone does NOT kill the Krein cross term; it vanishes
  exactly when `star nabla_e = nabla_e` (the edge-reflection gauge class), giving the
  self-adjoint corollary `carrier_krein_square_selfAdjoint` where the banked `D^2` assembly
  transports verbatim to `D^#D`.

## Honesty / scope (draft)

Uses Mathlib `StarRing`/`StarModule` for `#`. The all-plus adjoint table (`star gamma = gamma`,
`star Gamma = Gamma`, `star phi = phi`) is the correct one (the naive `star nabla = -nabla`
is anti-self-adjoint AND unsatisfiable for the torus forward difference - the `Z2` shift is
an involution, so the difference is in the self-adjoint class at `N=2`; this dies at `N>2`).
Still NO spectral positivity claim - `Q_A^#` is only positivity-*shaped*; the physical-sector
positivity is the separate open Krein-positivity crux. Provenance: Fable-5 call-02.

Proof handoff (for Aristotle):
- `star D0 = sum_e (star nabla_e) * gamma_e` via `star_sum`, `star_mul`, `hgammaStar`.
- `star D0 * D0` = `weitzenbock_master_pair gamma (star nabla) nabla g hcl hcommMStar hcomm`,
  where `hcommMStar : gamma e * star nabla f = star nabla f * gamma e` is DERIVED by applying
  `star` to `hcomm` (using `hgammaStar`). Gives `Q_A^# + Q_C^#`.
- `star Phi = Phi` (self-adjoint) via `hphiStar`, `hGammaStar`, `hPhiComm`; `star Phi * Phi = phi^2`.
- The cross term `star D0 * Phi + star Phi * D0 = sum_e gamma_e Gamma phi (star nabla_e - nabla_e)`
  is `kreinCrossTerm_eq_defect` - mirror of the banked `crossTerm_eq_covariant_gradient` with
  the derived `hCovStar : star nabla_e * phi = phi * star nabla_e` (from `hCov` + `hphiStar`).
- Assemble `star (D0 + Phi) * (D0 + Phi)` by `star_add`, distribute, scale by `4`.
The self-adjoint corollary sets `hnablaStar : star nabla_e = nabla_e`, collapsing `E_# -> 0`,
`Q_A^# -> Q_A`, `Q_C^# -> Q_C` (then it is `carrier_square_assembly` verbatim).
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier

variable {R B E : Type*} [CommRing R] [StarRing R] [Ring B] [Algebra R B]
  [StarRing B] [StarModule R B] [Fintype E]

/-- **The Krein square of the full carrier.**  `4 • (star D * D) = Q_A^# + Q_C^# + 4 Q_T
+ 4 E_#`, the self-adjointness-defect-carrying decomposition of the mass form. -/
theorem carrier_krein_square (gamma nabla : E → B) (Gamma phi : B) (g : E → E → R)
    (hcl : ∀ e f, gamma e * gamma f + gamma f * gamma e = algebraMap R B (g e f))
    (hcomm : ∀ e f, gamma e * nabla f = nabla f * gamma e)
    (hGammaSq : Gamma * Gamma = 1)
    (hGammaAnti : ∀ e, Gamma * gamma e = - (gamma e * Gamma))
    (hGammaNabla : ∀ e, Gamma * nabla e = nabla e * Gamma)
    (hPhiGamma : ∀ e, phi * gamma e = gamma e * phi)
    (hPhiComm : Gamma * phi = phi * Gamma)
    (hCov : ∀ e, nabla e * phi = phi * nabla e)
    (hgammaStar : ∀ e, star (gamma e) = gamma e)
    (hGammaStar : star Gamma = Gamma) (hphiStar : star phi = phi) :
    (4 : R) • (star (solderedNC gamma nabla + Gamma * phi)
        * (solderedNC gamma nabla + Gamma * phi))
      = (∑ e, ∑ f, g e f • (star (nabla e) * nabla f + star (nabla f) * nabla e))
        + (∑ e, ∑ f, (gamma e * gamma f - gamma f * gamma e)
            * (star (nabla e) * nabla f - star (nabla f) * nabla e))
        + (4 : R) • phi ^ 2
        + (4 : R) • (∑ e, gamma e * Gamma * (phi * (star (nabla e) - nabla e))) := by
  sorry

/-- **Self-adjoint corollary: the assembly transports to `D^#D`.**  When every transport
is Krein-self-adjoint (`star nabla_e = nabla_e`, the edge-reflection gauge class), the
defect `E_#` vanishes and the Krein square equals the banked `D^2` assembly:
`4 • (star D * D) = Q_A + Q_C + 4 Q_T`. -/
theorem carrier_krein_square_selfAdjoint (gamma nabla : E → B) (Gamma phi : B) (g : E → E → R)
    (hcl : ∀ e f, gamma e * gamma f + gamma f * gamma e = algebraMap R B (g e f))
    (hcomm : ∀ e f, gamma e * nabla f = nabla f * gamma e)
    (hGammaSq : Gamma * Gamma = 1)
    (hGammaAnti : ∀ e, Gamma * gamma e = - (gamma e * Gamma))
    (hGammaNabla : ∀ e, Gamma * nabla e = nabla e * Gamma)
    (hPhiGamma : ∀ e, phi * gamma e = gamma e * phi)
    (hPhiComm : Gamma * phi = phi * Gamma)
    (hCov : ∀ e, nabla e * phi = phi * nabla e)
    (hgammaStar : ∀ e, star (gamma e) = gamma e)
    (hGammaStar : star Gamma = Gamma) (hphiStar : star phi = phi)
    (hnablaStar : ∀ e, star (nabla e) = nabla e) :
    (4 : R) • (star (solderedNC gamma nabla + Gamma * phi)
        * (solderedNC gamma nabla + Gamma * phi))
      = (∑ e, ∑ f, g e f • (nabla e * nabla f + nabla f * nabla e))
        + (∑ e, ∑ f, (gamma e * gamma f - gamma f * gamma e)
            * (nabla e * nabla f - nabla f * nabla e))
        + (4 : R) • phi ^ 2 := by
  sorry

end PhysicsSM.Draft.NullEdge.Carrier
