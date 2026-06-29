Gate C1 next strategy after completed C240, C246

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

The program has pivoted to:

```text
centered tetrahedral null-edge Hermitian kernel H_ne
  -> scalar Wilson branch mass if possible
  -> optional constrained M_br only if needed
  -> Neuberger overlap sign
  -> Ginsparg-Wilson projectors
  -> staged GateC1_NU_Free / BackgroundGauge / Quantum audits.
```

Completed recent jobs:

```text
C235:
  actual bare branch-kernel zero-index obstruction.

C238:
  strategy audit, confirms H_ne is primitive and D_ov,ne is derived.

C239:
  Hermitian-kernel star-algebra API.

C240:
  tetrahedral coframe/branch/mass-window theorem.
  Scalar Wilson branch masses have the correct sign pattern under
  a > 0 and 0 < rho < 2r, subject to the independent-angle/lattice-duality
  assumption.

C241:
  scalar Wilson vs M_br decision and Walsh branch-mass interpolation theorem.

C242:
  reference-import API: below-margin bound gives gapped homotopy to H_ref.
```

Current best read:

```text
Branch A, scalar Wilson succeeds, is now the leading path.
Branch B, M_br, is fallback if the lattice-duality/global-gap theorem reveals
an unresolved residual branch or if later gauge/internal requirements force it.
```

Task:

Propose the next 5-8 highest-value Aristotle jobs from this updated state.

Please include:

1. Purpose.
2. Target theorem or API.
3. Required input files/modules.
4. Expected output.
5. Whether it should be focused standalone, live-repo proof package, or
   strategy/literature audit.
6. Success/failure interpretation.

Make sure the queue addresses, in order:

```text
1. lattice-duality / Brillouin-torus theorem;
2. Euclidean Clifford/coframe convention theorem;
3. branch-zero theorem;
4. scalar Wilson branch-window theorem;
5. global free gap theorem for H_tet;
6. sign(H_ne) and Ginsparg-Wilson assembly with corrected projectors;
7. free no-mirror-pole theorem for D_ov,tet;
8. transport/reference-import connection to C242 only after the direct free
   theorem;
9. gauge covariance/admissibility/path-sum source-contract layer;
10. anomaly/determinant-line layer;
11. fallback M_br only if needed.
```

Constraints:

- Keep GateC1_NU_Free, BackgroundGauge, and Quantum layers separate.
- Do not claim Standard Model chiral gauge closure from free overlap alone.
- Preserve no-propagator-zero mirror-removal rule.
- Preserve source-contract boundaries.
- Explain whether scalar Wilson is now the default and why the earlier
  scalar-Wilson no-go does not apply to scalar Wilson used as an overlap
  branch-mass term.
- Highlight the hidden traps:
  H_tet must be gapped at k=0;
  Lorentzian Clifford null singularities do not belong in the Euclidean overlap
  sign-kernel proof;
  finite-volume pi corners require even lattice lengths if a finite lattice
  model is used;
  gauge shifts do not commute away from U=1;
  M_br can fake success if introduced without a proved need.

Requested output:

- next-wave job queue;
- branch-dependent decision tree;
- recommended immediate first job after C240;
- risks and stop rules.
