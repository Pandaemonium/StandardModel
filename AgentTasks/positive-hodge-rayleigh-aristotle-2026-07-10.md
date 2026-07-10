# Aristotle job: variational mass = least positive Hodge cost

Date: 2026-07-10.  Origin: Pro moduli-theory analysis (round-8, sec 5 and
theorem program A).  Own-analysis correction incorporated: the Krein-
normalized representative set is non-compact, so the "least decoding cost"
definition is well-posed exactly under (i) the Kugo-Ojima radical property
(exact directions Krein-orthogonal to closed vectors — already M in-repo)
and (ii) ghost-positivity of the spectral cost on exact directions.  The
package proves the norm is class-constant, the cost splits exactly, the
harmonic representative attains the least cost (`IsLeast`), that
ghost-positivity is NECESSARY (explicit counterexample target), and a
rational witness with `mu2 = 4/25`.

## Metadata

```yaml
aristotle:
  project_id: be5c5929-b9ca-4763-a103-4e9c79cab5db
  target_file: AgentTasks/aristotle-standalone/positive-hodge-rayleigh-20260710/PositiveHodgeRayleigh/VariationalMass.lean
  expected_module: PositiveHodgeRayleigh.VariationalMass
  submission_project: AgentTasks/aristotle-submit/positive-hodge-rayleigh-20260710-project
  output_dir: AgentTasks/aristotle-output/be5c5929-b9ca-4763-a103-4e9c79cab5db
  status: integrated
```

Integration: port to the Carrier lane beside `PositiveHodgeDecoder`; this is
the variational upgrade of the spectral-mass reading.  Do not let the
docstring claim attainment without the ghost-positivity hypothesis.

## Integration result (2026-07-09 23:22 PDT)

All targets returned placeholder-free with unchanged signatures (vacuum-shift:
see the in-file corrected negative control note), verified with the pinned
local Lean check pre-port, landed at PhysicsSM/Draft/NullEdge/Carrier/PositiveHodgeRayleigh.lean
with project namespace and passing axiom guards, imported by PhysicsSMDraft,
and covered by a green targeted lake build.
