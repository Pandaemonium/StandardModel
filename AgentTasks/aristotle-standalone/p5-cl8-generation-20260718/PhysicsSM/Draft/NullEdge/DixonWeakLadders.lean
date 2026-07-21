import PhysicsSM.Draft.NullEdge.DixonAlgebra
import PhysicsSM.Draft.NullEdge.WeakBetaLaddersFromColor
import PhysicsSM.Algebra.Octonion.Conjugation

/-!
# The weak `beta`-ladders on the `C(x)H(x)O` Dixon algebra (Furey 1806.00612 eq. 30-31)

**Status: DRAFT + Aristotle handoff. The CAR theorems carry `s o r r y`.**

SM-branch, item 2 (electroweak). This is the FAITHFUL rebuild of the weak ladders
on the correct substrate - the `C(x)H(x)O` Dixon algebra built in `DixonAlgebra` -
after the kernel+PDF-driven correction that the colour factor `C(x)O` alone gives
`{beta_1, beta_2} = -1/2` (nonzero, `WeakBetaLaddersFromColor.
beta12_anticommutator_ne_zero`), so the fermionic anticommutation must come from
the `H`-quaternion tensor slot (`DixonAlgebra.Dixon.i1_i2_anticomm`: `{i_1,i_2}=0`).

## Verbatim grounding (Furey 1806.00612 p. 8, eq. 29-31; extracted from the PDF)

Cl(4) generators (eq. 29): `{tau_1 i_1, tau_2 i_1, tau_3 i_1, i_2}`, where `i_1,
i_2, i_3` are the `H`-QUATERNION units (a SEPARATE triple from the octonion units
`e_1..e_7` - the `‡` definition negates the two families separately) and
`tau_j` are the COLOUR `C(x)O` elements `tau_1 = omega+omega‡` etc. (eq. 29).

New basis (eq. 30):

  `beta_1 = (1/2)(-i_2 + i i_1 tau_1),   beta_2 = omega‡ i i_1`.

CAR (eq. 31): `{beta_i, beta_j} = {beta_i‡, beta_j‡} = 0`, `{beta_i, beta_j‡} =
delta_ij`, for `i,j in {1,2}`.

The `‡` (eq. 30 text): `i |-> -i` (complex), `i_j |-> -i_j` (quaternion),
`e_k |-> -e_k` (octonion), while REVERSING the order of multiplication - the full
Dixon-algebra anti-automorphism.

## Faithful modelling choices

* **Right action.** Furey's two `Cl(2)`s are both RIGHT actions (p. 8, sec 5.1:
  "the right action on Su+Sd ... transitions between isospin up- and down-type").
  The `C(x)H(x)O` product is non-associative (`O` is), so the right-action
  operators do NOT collapse to `R_{ba}`; the CAR is therefore stated at the
  OPERATOR level, `{R_{beta_i}, R_{beta_j}}(z) = ... z` for all `z`, with
  `R_a z = z * a` and EXPLICIT parenthesization (`(z * a) * b`).
* **The element `‡`.** Each Dixon term `x_k i_k` carries a single `H`-unit that
  commutes with its colour coefficient `x_k`, so the order-reversing `‡` reduces,
  on elements, to "conjugate every colour coefficient (`coStar`) and negate the
  three `H`-unit slots": `Dixon.conjH` below. (The order reversal only bites on
  genuine products, handled by whoever proves the anti-automorphism law.)
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.DixonWeakLadders

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Draft.NullEdge.DixonAlgebra
open PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon
open PhysicsSM.Draft.NullEdge.WeakBetaLaddersFromColor (omega omegaDag tau1)

/-! Complex scalar action + module structure now live upstream in
`DixonAlgebra` (moved 2026-07-18). -/

/-- The complex unit `i` embedded in the Dixon algebra as a colour scalar
(central: `i` commutes with everything). -/
def Idix : Dixon := ofColour I

/-- **Furey eq. 30** `beta_1 = (1/2)(-i_2 + i i_1 tau_1)`, on the Dixon algebra:
`i_1, i_2` are the `H`-units, `tau_1` the colour element, `i` the complex unit. -/
def betaH1 : Dixon := (1 / 2 : ℂ) • ((-i2) + Idix * i1 * ofColour tau1)

/-- **Furey eq. 30** `beta_2 = omega‡ i i_1`, on the Dixon algebra. -/
def betaH2 : Dixon := ofColour omegaDag * Idix * i1

/-! ## The Dixon-algebra conjugation `‡` -/

/-- The colour-coefficient part of `‡`: complex conjugation (`i |-> -i`) AND
octonion conjugation (`e_k |-> -e_k`) on a `C(x)O` element. Concretely
`coStar (re + i im) = conj_O(re) - i conj_O(im)`. -/
def coStar (x : ComplexOctonion) : ComplexOctonion :=
  ⟨PhysicsSM.Algebra.Octonion.conj x.re,
   -(PhysicsSM.Algebra.Octonion.conj x.im)⟩

/-- The Dixon-algebra conjugation `‡` on ELEMENTS: `coStar` every colour
coefficient and negate the three `H`-unit slots (`i_j |-> -i_j`). Equal to the
full anti-automorphism `‡` on elements because every `x_k i_k` term has a single
`H`-unit that commutes with its colour coefficient (see module docstring). -/
def conjH (d : Dixon) : Dixon :=
  ⟨coStar d.x0, -(coStar d.x1), -(coStar d.x2), -(coStar d.x3)⟩

/-- `beta_1‡`. -/
def betaH1dag : Dixon := conjH betaH1
/-- `beta_2‡`. -/
def betaH2dag : Dixon := conjH betaH2

/-! ## Kernel-checked finding + honest open question: the ELEMENT like-CAR
`{beta_1,beta_2}` is NONZERO (`= 1/2`), so these element `beta`'s are NOT the
right realization of Furey's operator CAR - the `beta`'s are bar/right-action
operators, not algebra elements

Hand-analysis (the nonzero-ness is kernel-verified below at one coordinate). With
`e_1,e_2,e_3` the `H`-units (`{e_1,e_2}=0`, `e_1e_2=e_3`, `e_1^2=-1`) and `I` the
central complex unit,

  `{beta_1, beta_2} = (1/2)[ (I omega‡) e_3 + tau_1 omega‡
                            - (I omega‡) e_3 + omega‡ tau_1 ]
                    = (1/2){tau_1, omega‡}_colour.`

The `H`-unit `e_3` cross-terms DO cancel (exactly the `DixonAlgebra.i1_i2_anticomm`
payoff `{i_1,i_2}=0` working). The surviving colour term is `(1/2){tau_1, omega‡}`
with `tau_1 = omega+omega‡`, `(omega‡)^2 = 0` (`omega = a_1 a_2 a_3`,
Grassmann-nilpotent, PDF p.7), so `{tau_1, omega‡} = {omega, omega‡}`. In the
CONCRETE `C(x)O` realization `omega omega‡` and `omega‡ omega` are the two
COMPLEMENTARY idempotents `(1 - i e_111)/2` and `(1 + i e_111)/2` (repo
`MinimalLeftIdeal.omega`), which SUM TO 1, so `{omega,omega‡} = 1` and hence
`{beta_1, beta_2} = 1/2` (scalar).

**Honest correction (supersedes an earlier "operator-on-ideal" reading of this
finding).** Because `{omega,omega‡}=1` (not a rank-2 projector) AND the repo proves
the COLOUR ladder CAR at the ELEMENT level (`LadderOperators`:
`alpha_i alpha_j‡ + alpha_j‡ alpha_i = delta_ij` as `C(x)O` elements), an
element-level CAR IS achievable in this algebra. So a nonzero element
`{beta_1,beta_2}` does NOT prove the CAR is "operator-on-ideal"; it shows these
ELEMENT `beta`'s are not the intended objects. Furey's `beta`'s are bar/right-action
OPERATORS (eq. 13: the `C(x)H` Dirac matrices are bar operators `1|i_1`,
`i_1|i_2`, ...), so eq-31 is an anticommutator of OPERATORS, which the Dixon
element product does not model. OPEN next step: realize the `beta`'s as bar/right
operators on the Dixon algebra (the `DixonLeftRightAction` scaffolding) and check
the operator CAR there - NOT as element products. The kernel fact below stands;
only its interpretation is corrected. -/

/-! SEMANTICS RESOLUTION (2026-07-18): the operator-vs-element question this
module's findings posed is CLOSED - the faithful realization is COMPOSITION
operators (`DixonWeakCARTau3` anti-Fock dictionary; `CompositionWeakLadders`
cores; `CompositionWeakCAR` assembly). The kernel facts here (element
`{beta_1,beta_2} = 1/2` for the `tau_1`-variant) stand as the no-go that forced
the resolution; the `tau_1` transcription itself was corrected to `tau_3`
(design note CORRECTION 6). -/

set_option maxRecDepth 10000 in
set_option maxHeartbeats 8000000 in
/-- **The element-level like-CAR `{beta_1, beta_2} = 0` is FALSE**: the scalar
(`x0.re.c0`) coordinate of the element anticommutator is a nonzero dyadic rational
(the surviving `(1/2){omega,omega‡} = 1/2` colour term of the hand-analysis above;
the exact value carries the repo `alpha` `1/2`-normalisation). This is the kernel
witness that ELEMENT products are the wrong model for Furey's eq-31 CAR - the
`beta`'s are bar/right-action operators (see the honest correction above). It
mirrors `WeakBetaLaddersFromColor.beta12_anticommutator_ne_zero`. -/
theorem betaH_like_anticomm_ne_zero : betaH1 * betaH2 + betaH2 * betaH1 ≠ 0 := by
  intro h
  have hc : (betaH1 * betaH2 + betaH2 * betaH1).x0.re.c0 = (0 : ℝ) :=
    congrArg (fun d : Dixon => d.x0.re.c0) h
  norm_num [betaH1, betaH2, Idix, mul, tau1, omega, omegaDag, I, ofColour, i1, i2,
    alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag, alpha3_dag] at hc

end PhysicsSM.Draft.NullEdge.DixonWeakLadders

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.DixonWeakLadders.betaH_like_anticomm_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DixonWeakLadders.betaH_like_anticomm_ne_zero
