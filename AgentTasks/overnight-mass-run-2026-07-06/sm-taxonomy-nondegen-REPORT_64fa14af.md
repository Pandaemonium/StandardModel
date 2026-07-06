# Mass-taxonomy non-degeneracy — delivery report

## Deliverable

`MassTaxonomyNonDegeneracy.lean` (namespace
`PhysicsSM.Draft.NullEdge.GateI1.MassTaxonomyNonDegeneracy`) — the
independent-realizability / non-degeneracy companion to
`MassTaxonomySeparation.massTaxonomy_functionals_pairwise_separated`. It reuses
the existing functionals verbatim (nothing weakened or restated) and proves, on
the **independent** parameter domains of the four masses, that each obstruction
is realizable independently of the others.

Status: builds under `lake build MassTaxonomyNonDegeneracy` (full mathlib cache
present). Every final theorem is `sorry`-free; `massTaxonomy_nondegenerate`
depends only on `[propext, Classical.choice, Quot.sound]` (kernel-checked axiom
guard `#print axioms` embedded in the file). No `axiom` / `native_decide`.

## Theorems

- `regulator_on_others_off` (`r > 0`): regulator ON; bare, closure (boundary),
  aperture OFF.
- `closure_on_others_off` (`β > 0`): closure ON; bare, regulator, aperture OFF.
- `aperture_on_others_off`: aperture ON (non-collinear null pair); bare,
  regulator, closure (boundary) OFF.
- `turn_off_others_on` (`r, β > 0`): bare/turn identically OFF while the other
  three are independently ON (honest dual — see below).
- `turn_identically_off`, `z2GlueballMass_boundary_zero`,
  `z2GlueballMass_no_inrange_zero`, `z2GlueballMass_off_limit` — supporting
  honesty lemmas.
- `massTaxonomy_nondegenerate` — the bundled headline (conjunction of the four).

## Which legs have clean in-range witnesses (honesty report)

| leg | ON witness | OFF witness |
| --- | ---------- | ----------- |
| **regulator** `wilsonRegulatorMass r` | clean, `r > 0` | **clean, in-range** `r = 0` |
| **aperture** `compositeApertureMassSq` | clean, non-collinear null pair | **clean, in-range** collinear |
| **closure** `z2GlueballMass β` | clean, `β > 0` | **no finite in-range zero** — strictly positive for all `β > 0`, vanishes only in the limit `β → ∞` (`z2GlueballMass_off_limit`); the equality `z2GlueballMass 0 = 0` used in the bundle is the degenerate boundary value from Lean's div-by-zero convention (`coth` singular at 0), documented as such |
| **turn / bare** `quarkMassParameter` | **no ON witness** — a detached input pinned to `0`, never strictly positive | clean, trivially `0` |

So two legs (regulator, aperture) are cleanly two-sided; **closure** is the leg
whose OFF is only a limit (no finite zero); **turn/bare** is the exceptional leg
that is identically OFF (no ON witness), for which the honest non-degeneracy
statement is `turn_off_others_on`.

## Scope / honesty note

Independent realizability holds *because the four functionals live on independent
parameter domains*. This is a non-degeneracy / basis-like statement about the
functionals (no one is a shadow of another). It is **not** a claim that a single
physical model exhibits all four masses at once (the "common carrier" claim),
which is separate and explicitly not proved here.

## Note on the workspace

The delivered workspace did not include the upstream
`PhysicsSM.Draft.NullEdge.GateI1.{Core, CompositeApertureMass, MassWithoutMass}`
modules that `MassTaxonomySeparation.lean` imports, so neither attached file
typechecked as-is. To make the workspace self-consistent and kernel-checkable,
minimal **reconstruction shims** for those three modules were added under
`PhysicsSM/Draft/NullEdge/GateI1/`, providing exactly the API surface the
attached files exercise, with definitions chosen so every proof already written
in the attached files goes through unchanged. In the full upstream project these
shims are unnecessary — the real modules supply the same API, and the deliverable
imports them by their real module paths.
