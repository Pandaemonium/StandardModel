Project name: gate-c1-overlap-source-contract-map-c203

You are Aristotle, working on the StandardModel Lean/null-edge research project.

Cycle 2 literature search recovered the core overlap-reference source stack:

```text
Neuberger, hep-lat/9707022:
  overlap construction with Wilson kernel and no unwanted doubling.

Neuberger, hep-lat/9801031:
  overlap matrix obeys the Ginsparg-Wilson relation.

Luscher, hep-lat/9802011:
  exact lattice chiral symmetry from the Ginsparg-Wilson relation.

Hernandez-Jansen-Luscher, hep-lat/9808010:
  locality of Neuberger's lattice Dirac operator under smooth/admissible gauge
  fields.

Adams, hep-lat/9812003:
  axial anomaly/topological charge continuum limit for the overlap operator.

Luscher, hep-lat/9811032 and hep-lat/0006014:
  anomaly-free chiral gauge/determinant-line source lane.

Golterman-Shamir, arXiv:2311.12790 and arXiv:2505.20436:
  propagator-zero ghost/no-go warnings.
```

Task:

1. Build a source-contract map: source -> theorem/predicate field -> exact
   assumptions -> allowed claim -> forbidden overclaim.
2. Split the contracts into:

```text
algebraic overlap/GW;
free no-doubling/sign window;
locality/admissibility;
anomaly/index;
chiral determinant/gauge invariance;
ghost-zero exclusion.
```

3. Say which contracts are needed for `GateC1_NU_Free`,
   `GateC1_NU_BackgroundGauge`, and the stronger quantum/determinant target.
4. Identify missing sources, if any.
5. Return a concise table suitable for insertion into the project docs.

Success criteria:

```text
No overclaiming.
Clear separation between known Wilson/Neuberger reference facts and what must
be proved for the null-edge endpoint.
```

Please finish with:

```text
Source-contract table:
GateC1_NU_Free requirements:
Background-gauge requirements:
Quantum/determinant requirements:
Forbidden claims:
Next source/audit jobs:
```
