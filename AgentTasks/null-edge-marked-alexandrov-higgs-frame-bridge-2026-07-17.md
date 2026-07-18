# Marked Alexandrov Higgs frame bridge

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Claim grade: `M [orig/comp]`

## Target

Use one marked shell-angular probe family for both finite Lorentzian inertia
and complex Higgs derivative recovery. This checks that the Higgs kinetic
sector is compatible with the same local causal frame used by the corrected
pairing.

## Landed result

`projectLocal_shellAngular_inertia_and_complexRecovery` assumes:

- a nonzero discreteness scale;
- one time probe supported on `L_1(x) union L_3(x)` with a nonzero based
  difference;
- three spatial probes supported on `L_0(x)` whose based-difference
  coordinates detect every nonzero coefficient vector.

It proves the conjunction of:

- the project-local corrected pairing has one positive direction, three
  negative directions, and zero time-space cross terms on those probes; and
- one real-linear recovery map exactly recovers every complex time-plus-three-
  space derivative vector synthesized from the same probes.

The exact shell separation is order-derived. Probe selection and quantitative
conditioning remain supplied reconstruction gates.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/MarkedAlexandrovHiggsFrameBridge.lean`
- `lake build PhysicsSM.Draft.NullEdge.MarkedAlexandrovHiggsFrameBridge`
- Build-enforced theorem assumption footprint: `propext`, `Classical.choice`,
  and `Quot.sound` only.

The module contains no proof handoff markers or trust-expanding evaluator use.

## Provenance

This is a project-internal composition of the kernel-checked marked-shell
inertia theorem and shell-angular complex recovery theorem. It introduces no
continuum or phenomenological input.

## Remaining gate

Construct an order-native, overlap-compatible, well-conditioned radial-plus-
angular selector on generic marked Alexandrov neighborhoods.
