Gate C1 strengthened Riesz-projector API, C233

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

C229 found that a weak `IsRieszProjector` fingerprint:

```text
idempotent + commuting + equal rank
```

is underdetermined and cannot prove uniqueness. For example, a zero operator
can admit many rank-matched idempotents. Therefore the Gate C1 spectral-island
API must carry real spectral/range data.

Task:

Design the strengthened Riesz/spectral-projector API needed for the C175
branch-line lift.

Please answer:

1. What minimum finite-dimensional data makes a spectral projector unique?
2. Should the API use:
   range equals generalized eigenspace;
   polynomial spectral projector;
   contour/Riesz projector source contract;
   spectral set membership;
   or another condition?
3. What finite Lean theorem should be proved first before analytic Kato/Davis-
   Kahan source contracts?
4. How should this connect to `MaintainedIsland.persistence` and
   `OperatorFreeze.frozen_gappedHomotopic_of_budget`?
5. What theorem names and structures should Codex add next?
6. What overclaims must be blocked?

Claim boundaries:

```text
Riesz/projector persistence does not prove spacetime no-doubling.
It does not create chiral polarization from a balanced origin kernel.
It does not prove anomaly, determinant-line, Krein, gauge, or ghost safety.
```

Requested output:

- strengthened API proposal;
- exact finite-first theorem statements;
- analytic source-contract placeholders;
- connection theorem to C194/C202/C227;
- no-overclaim checklist.
