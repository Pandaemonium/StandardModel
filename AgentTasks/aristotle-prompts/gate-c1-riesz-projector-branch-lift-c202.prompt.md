Project name: gate-c1-riesz-projector-branch-lift-c202

You are Aristotle, working on the StandardModel Lean/null-edge research project.

Gate C1 needs a branch-line lift after the free reference sign split:

```text
Pi_phys(q) = (1 / 2 pi i) integral_C (z - H_ne(q))^-1 dz
```

informally, or an equivalent spectral-island projector.

Task:

1. State a clean theorem package for persistence of the physical projector under
   a maintained spectral gap.
2. Separate finite-dimensional matrix/operator facts from analytic contour
   integration facts.
3. Provide a practical Lean-facing abstraction that avoids heavy complex
   integration if needed:

```text
SpectralIslandSeparated H q physIsland gap
ProjectorRankStable Pi_phys q
ChiralIndexStable Pi_phys q
```

4. Explain how this uses C193's `gamma_free` and the later kappa/alpha/beta
   error budget.
5. Identify what must be supplied by the actual null-edge endpoint.

Success criteria:

```text
The branch lift should not be confused with proving the mass window.
The projector must persist because a spectral island remains separated, not
because a mirror branch is replaced by a propagator zero.
```

Please finish with:

```text
Definitions:
Main persistence theorem:
Minimal finite-dimensional version:
Analytic version:
Inputs needed from H_ne:
No-go/failure cases:
```
