import Mathlib.Tactic
import PhysicsSM.StandardModel.OneGenerationTable

/-!
# Draft.NullEdgeYukawaFlip

Finite Standard Model bookkeeping for the null-edge interpretation of Higgs
permitted chirality flips.

The theorem in this file is intentionally modest: it checks only
`U(1)_Y` hypercharge neutrality of one-generation Yukawa flip vertices in the
repo's convention `Q = T3 + Y/2`.  It does not prove a full Standard Model
Yukawa Lagrangian, an `SU(2)` tensor contraction, or mass generation dynamics.

Interpretation for the null-edge program:

```text
left-handed null-edge state + Higgs insertion -> right-handed state
```

is gauge-legal at the hypercharge level exactly for the usual Higgs or
conjugate-Higgs insertion.
-/

namespace PhysicsSM.Draft.NullEdgeYukawaFlip

open PhysicsSM.StandardModel.OneGenerationTable

/-- One-generation Yukawa flip channels. -/
inductive YukawaFlip where
  | chargedLepton
  | downQuark
  | upQuark
  | neutrino
deriving DecidableEq, Repr

namespace YukawaFlip

/-- The left-handed source multiplet of a Yukawa flip. -/
def leftMultiplet : YukawaFlip -> PhysicalMultiplet
  | .chargedLepton => .L_L
  | .downQuark => .Q_L
  | .upQuark => .Q_L
  | .neutrino => .L_L

/-- The right-handed target multiplet of a Yukawa flip. -/
def rightMultiplet : YukawaFlip -> PhysicalMultiplet
  | .chargedLepton => .e_R
  | .downQuark => .d_R
  | .upQuark => .u_R
  | .neutrino => .nu_R

/--
Hypercharge of the Higgs insertion in the physical Yukawa term.

In the repo convention `Q = T3 + Y/2`, the Higgs doublet has `Y = 1` and the
conjugate Higgs has `Y = -1`.
-/
def higgsInsertionHypercharge : YukawaFlip -> ℚ
  | .chargedLepton => 1
  | .downQuark => 1
  | .upQuark => -1
  | .neutrino => -1

/--
The hypercharge defect of the physical Yukawa monomial
`bar(left) * HiggsInsertion * right`.

The bar on the left-handed field contributes the negated left hypercharge.
-/
def hyperchargeDefect (v : YukawaFlip) : ℚ :=
  -(leftMultiplet v).hypercharge +
    higgsInsertionHypercharge v +
    (rightMultiplet v).hypercharge

/--
Every one-generation Yukawa chirality flip is hypercharge neutral after
inserting the Higgs or conjugate Higgs with the usual Standard Model charge.
-/
theorem hyperchargeDefect_eq_zero (v : YukawaFlip) :
    hyperchargeDefect v = 0 := by
  cases v <;>
    norm_num [hyperchargeDefect, leftMultiplet, rightMultiplet,
      higgsInsertionHypercharge, PhysicalMultiplet.hypercharge]

/--
Machine-readable claim boundary: this file checks only the `U(1)_Y` part of
Yukawa gauge legality.
-/
structure ClaimBoundary where
  only_hypercharge_checked : True
  no_su2_tensor_contraction : True
  no_mass_generation_dynamics : True

/-- The claim boundary for this draft theorem package is explicit. -/
def claimBoundary : ClaimBoundary where
  only_hypercharge_checked := trivial
  no_su2_tensor_contraction := trivial
  no_mass_generation_dynamics := trivial

end YukawaFlip

end PhysicsSM.Draft.NullEdgeYukawaFlip
