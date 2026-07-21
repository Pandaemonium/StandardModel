# Codex semantic audit: finite neutrino mass classification

Date: 2026-07-20
Builder: Opus with Aristotle project `1d730886-0048-4d17-9b6a-186792cb2cb9`
Reviewer: Codex
Artifact: `PhysicsSM/Draft/NullEdge/NeutrinoMassClassification.lean`

## Verdict

**Accept after guard/root integration, with a narrowed manuscript reading.**

The file is a useful finite classification of four declared operator profiles
and contains genuine nontrivial seesaw algebra. It is not an exhaustive theorem
about every gauge-equivariant neutrino mass operator in the Standard Model plus
extensions.

## Checks performed

- `lake env lean PhysicsSM/Draft/NullEdge/NeutrinoMassClassification.lean`
  passed with exit code zero.
- No proof placeholders, trusted-compiler reductions, or new assumptions were
  found by source inspection.
- Build-enforced assumption-footprint guards and a root import were absent at
  review time; Opus was asked to add them under its live lease.

## Semantically aligned results

1. If the declared right-handed vector space is the zero-dimensional function
   space, both components of the declared chirality-odd block vanish.
2. For the module's additive-charge predicate, two fields of charge `-1/2` do
   not form a neutral bare bilinear.
3. After a one-dimensional right slot is declared, the identity linear map is
   an explicit nonzero turn witness.
4. The one-generation seesaw matrix has exact Schur complement
   `-m_D^2/M_R` and exact triangular congruence block diagonalization when
   `M_R != 0`.
5. The displayed light vector has a residual bounded by the supplied small
   ratio hypothesis.

## Boundaries that manuscript prose must preserve

1. `OperatorProfile` stores mass kind, engineering dimension,
   renormalizability, heavy-scale dependence, and fermion-number behavior as
   data. The corresponding theorem reduces these definitions; it does not
   derive the metadata from a Lagrangian or representation theory.
2. `oneGenerationDiracTurn_nonzero` proves that a nonzero linear map exists.
   It does not itself prove electroweak gauge equivariance, Higgs insertion, or
   the right-handed singlet's charge assignments.
3. `leftNeutrino_renormalizableMajorana_forbidden` is a U(1) charge control for
   the bare bilinear. It is not the full Lorentz, `SU(2)`, and hypercharge
   classification of all renormalizable operators.
4. The seesaw estimate is a controlled residual for one displayed vector, not
   a multi-generation eigenvalue, mixing-angle, or pole-mass theorem.
5. The supplied couplings and heavy scale remain inputs.

## Strongest acceptable claim

> Within the module's declared finite odd-block and operator-profile grammar,
> the minimal empty-right-slot obstruction, a nonzero singlet-Dirac witness,
> a distinct dimension-five Majorana profile, and the one-generation seesaw
> reduction are machine-checked in one API.

## Nearest stronger theorem

Classify all Lorentz- and `SU(2) x U(1)`-equivariant operators through a stated
dimension in the actual field representations, derive the profile metadata
from that grammar, and prove the resulting list exhaustive up to field
redefinition. This remains open.
