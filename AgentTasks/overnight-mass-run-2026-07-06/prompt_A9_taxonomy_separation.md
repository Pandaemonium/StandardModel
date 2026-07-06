Prove the mass-taxonomy SEPARATION theorem: the distinct kinds of "mass" in the
null-edge program are provably DIFFERENT functionals, not the same quantity
relabeled. This is the single best guard against the "all mass is one thing"
over-claim, and it converts the taxonomy table in
`AgentTasks/fourday-ym-run-2026-07-05/NULL_EDGE_MASS_UNIFICATION.md` (section
13.2 mass taxonomy) into MATHEMATICS.

Create a NEW module `PhysicsSM/Draft/NullEdge/GateI1/MassTaxonomySeparation.lean`.
Check with `lake env lean` on it. If broader `lake build` stalls, SKIP and
return source.

## The four mass functionals (define any not already named; reuse existing)

1. **Primitive/bare mass** `quarkMassParameter : R` - ALREADY EXISTS in
   `GateI1/MassWithoutMass.lean`, defined `= 0` (an input parameter).
2. **Closure/glueball spectral mass** `z2GlueballMass (beta) : R` - ALREADY
   EXISTS in `GateI1/MassWithoutMass.lean`, `= log coth beta`, with
   `z2GlueballMass_pos : 0 < beta -> 0 < z2GlueballMass beta`.
3. **Wilson REGULATOR mass** - DEFINE a functional `wilsonRegulatorMass (r) : R`
   for the 2-site Wilson-quark model (a doubler-removal lattice artifact,
   `~ log(1 + 4r)` or the model's exact transfer-gap for Wilson parameter `r`),
   which is POSITIVE for `r > 0` EVEN WHEN `quarkMassParameter = 0`. The point:
   it is nonzero purely from the regulator, with zero bare mass. Keep it a
   clearly separate `def` (the taxonomy row-2 quantity). If a fully honest
   2-site Wilson transfer gap is heavy, a faithful surrogate `log(1 + 4*r)` with
   a docstring pinning it to the Wilson regulator is acceptable AS a named
   functional, provided the separation theorem below is genuine.
4. **Composite aperture mass** - DEFINE `compositeApertureMassSq (p q) : R` as
   `minkowskiSq (p + q)` for `Momentum4` null momenta `p, q` (reuse the
   `minkowskiSq` / `minkDot` API from `GateI1/CompositeApertureMass.lean`;
   `compositeMassSq_eq_zero_iff_collinear` already characterizes when it
   vanishes).

## The separation theorems (the deliverable)

Prove each functional can be zero while another is positive - i.e. they are
pairwise independent, not proportional. Concretely, exhibit witnesses:

- `sep_bare_vs_closure` : `quarkMassParameter = 0` AND
  `0 < z2GlueballMass beta` (for `beta > 0`). (This is essentially the existing
  `massWithoutMass`; restate it as a separation witness.)
- `sep_bare_vs_regulator` : `quarkMassParameter = 0` AND
  `0 < wilsonRegulatorMass r` (for `r > 0`). Bare mass zero, regulator positive.
- `sep_closure_vs_regulator` : the closure mass lives with ZERO fermion content
  (pure gauge) while the regulator mass requires `r > 0` fermions - exhibit a
  configuration (pure-gauge: no `r`) where `z2GlueballMass beta > 0` but the
  regulator functional is `0` (`wilsonRegulatorMass 0 = 0`), and vice-versa a
  fermionic config with `r > 0` regulator but the composite is not a glueball.
- `sep_aperture_vs_all` : two COLLINEAR future-null momenta give
  `compositeApertureMassSq p q = 0` (kinematic mass vanishes) while
  `z2GlueballMass beta > 0` - the aperture (kinematic) mass is independent of
  the spectral/closure mass; AND a NON-collinear null pair gives
  `0 < compositeApertureMassSq p q` while `quarkMassParameter = 0` (aperture
  mass with zero bare mass).

Bundle them into one headline theorem
`massTaxonomy_functionals_pairwise_separated` (a conjunction of the witnesses
above) with a docstring stating: the four taxonomy rows are DISTINCT functionals
(F-YM-CONFLATE at theorem grade); the unification says they share a mechanism
SHAPE, NOT that they are one number.

## Constraints

- No new `a x i o m`, `s o r r y`, `n a t i v e _ d e c i d e`. All witnesses
  must be concrete and kernel-checked.
- Reuse existing API (`quarkMassParameter`, `z2GlueballMass`, `minkowskiSq`,
  `minkDot`, `compositeMassSq_eq_zero_iff_collinear`, the null-momentum
  constructors). Do not redefine them.
- Claim label: finite identity / taxonomy separation. Draft-trust.
- If `lake build` stalls, SKIP it; return the module source.
