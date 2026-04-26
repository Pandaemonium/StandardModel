import PhysicsSM.Algebra.Furey.MinimalLeftIdeal

/-!
# Algebra.Furey.SMStates

Standard Model particle states as elements of the minimal left ideal J.

## State identification

One generation of SM fermions (and anti-fermions) is identified with the
8 basis elements of J (and their complex conjugates from the second ideal J'):

| Element of J      | SM particle       | Charge | SU(3) rep |
|-------------------|-------------------|--------|-----------|
| nu = a1 a2 a3 w   | anti-neutrino     |   0    | singlet   |
| a1† nu            | anti-up quark (r) |  +2/3  | triplet   |
| a2† nu            | anti-up quark (g) |  +2/3  | triplet   |
| a3† nu            | anti-up quark (b) |  +2/3  | triplet   |
| a1† a2† nu        | positron          |  +1    | singlet   |
| a1† a3† nu        | anti-down quark (r) | +1/3 | triplet   |
| a2† a3† nu        | anti-down quark (g) | +1/3 | triplet   |
| a1† a2† a3† nu    | anti-down quark (b) | +1/3 | triplet   |

(Antiparticles from J'; full particle content includes both ideals.)

The electric charges follow from the number operator:
  Q = -(1/3)(N_1 + N_2 + N_3)  +  (offset from idempotent)
where N_k = alpha_k† * alpha_k is the number operator for mode k.

## Convention note

The SU(3) colour structure comes from the symmetry of the three
alpha_k operators under the group of unitary transformations
preserving the anticommutation relations. This is the source of
Furey's claim that SU(3)_c is unbroken by the algebra.

## Sources

Source: Furey, arXiv:1806.00612, Table 1 and Section 3.
Provenance: clean-room formalization.

## Status

Stub — state definitions require active LadderOperators and MinimalLeftIdeal.
-/

namespace PhysicsSM.Algebra.Furey.SMStates

end PhysicsSM.Algebra.Furey.SMStates
