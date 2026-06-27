# Track B cycle 21: Ginsparg-Wilson vocabulary is not a release certificate

Date: 2026-06-27
Cycle: 21
Track: B - information/generalization guardrail

## Trigger

The cycle 21 literature search again surfaced Luscher/Ginsparg-Wilson exact lattice chiral symmetry and the minimally-doubled fermion locality warning. This helps classify language around overlap/GW routes, but it does not itself provide the null-edge release datum.

## Named failure mode

**GW-vocabulary overclaim.** A construction is described with overlap or Ginsparg-Wilson language, and the wording is then treated as a certificate that the physical line, mirror gap, anomaly, ghost, Krein, and locality obligations have been constructed.

## Finite theorem target

Create a finite release-record guardrail in which a `HasGWLabel` field is independent of the actual release audits:

```lean
structure GWLabelToy where
  hasGWLabel : Bool
  hasPhysicalLine : Bool
  hasMirrorGap : Bool
  hasGhostAudit : Bool
  hasLocalityAudit : Bool
```

Target counterexample:

```lean
theorem gwLabel_not_releaseAudit :
    exists d,
      d.hasGWLabel = true /\
      not (d.hasPhysicalLine = true /\ d.hasMirrorGap = true /\
           d.hasGhostAudit = true /\ d.hasLocalityAudit = true)
```

This keeps Track B language honest: a route label can motivate theorem obligations, but the obligations remain separate data.

## Claim boundary

The null-edge program can borrow overlap/GW ideas only as route templates. The release certificate must be local to the null-edge `D_phys` construction and its audits.
