# Gate C1 Aristotle Completed Results Integration

Date: 2026-06-27

Status: summary-integrated into the Gate C1 planning docs; standalone Aristotle
Lean artifacts are not promoted to trusted `PhysicsSM` modules in this pass.

## Scope

This note integrates the recent completed Aristotle jobs most relevant to the
Gate C1 pivot toward a null-edge overlap/Ginsparg-Wilson/domain-wall
reinterpretation:

- C109a passive origin-polarizer API.
- C112-C115 Furey/Hughes-inspired branch-selector, centralizer, bridge, and
  ghost/gap jobs.
- C118-C120 Pro-synthesis finite algebra jobs.
- C127 flavored-overlap/staggered-Wilson translation job.

Several later overlap-program jobs are still running or held; they are not
integrated here.

## Integrated conclusions

### C109a: passive origin-polarizer API

Aristotle repaired and completed the passive API:

```text
NativeOriginBranchData;
Selector D = Polynomial.aeval D.B0 D.p;
IsOriginPolarizerCertificate D =
  ChiralTrace D.Gamma0 (Selector D) != 0.
```

The important point is boundary discipline. C109a contains no release, gauge,
gap, anomaly, Krein, spectral-island, path-sum, or locality fields. It is only
the finite origin entry ticket.

### C112-C113: finite origin selector and centralizer audit

Aristotle confirmed the C108 family in finite matrix form:

```text
balance-even selector -> zero chiral trace;
nonzero chiral trace -> nonzero J-odd content;
chiral trace sees only the J-odd part;
scalar/central selectors fail;
2 x 2 balance-odd witnesses exist.
```

C113 adds a finite centralizer/gauge-safety audit:

```text
GaugeSafe G B := G is contained in the centralizer of B.
```

False positives are now explicit:

```text
nonzero chiral trace but gauge-unsafe;
gauge-safe but balance-even;
bare trace imbalance selecting taste rather than physical branch.
```

These results support the current policy that the origin test is necessary but
not a physical release theorem.

### C114: origin-to-branch bridge

C114 gives the right bridge architecture:

```text
finite origin polarizer
  + isolated spectral island
  + uniform gap separation
  + constant kernel dimension
  + smooth/analytic branch locus
  + gauge covariance
  -> nearby stable branch projector.
```

The finite Lean core proves the continuous persistence shadow of the bridge, but
not the spectral gap itself. The project should continue treating the spectral
island as a mandatory hypothesis, not a consequence of nonzero origin trace.

### C115: true gap versus ghost zero

C115 formalizes the most important mirror-sector audit:

```text
true bad-sector inverse gap and ghost zero are mutually exclusive.
```

It also gives the structured-gapping pattern:

```text
D = A + m P_bad
```

with `P_bad` a genuine branch projector on the unwanted sector. Gauge covariance
requires the bad branch to be a genuine subrepresentation. The anomaly audit is
kept explicit: removing a sector changes the total anomaly by exactly that
sector's contribution unless it is vectorlike/anomaly-free.

This supports the current rule:

```text
Do not remove a gauge-charged mirror by a propagator zero.
Require a true inverse-propagator gap.
```

### C118: Schur-Feshbach parity criterion

C118 formalizes the Schur parity rule:

```text
Sigma = V M^{-1} W;
J_L Sigma J_L = (sigma_V sigma_M sigma_W) Sigma.
```

When `Sigma != 0`, the Schur self-energy is balance-odd exactly when:

```text
sigma_V sigma_M sigma_W = -1.
```

Aristotle also supplied a 2 x 2 witness and the negative control:

```text
if all three ingredients are balance-even, then Sigma is balance-even and has
zero chiral trace.
```

This is now the finite algebraic test for whether a Schur/domain-wall auxiliary
channel can generate a useful matrix-valued Wilson/flavored-mass term.

### C119: C1-Origin+ certificate

C119 formalizes the strengthened pre-release origin audit:

```text
idempotent projector;
self-adjoint or Krein-self-adjoint finite model;
intended selected dimension;
nonzero J-odd part;
nonzero chiral trace;
chirality purity;
gauge-safety placeholder;
tangent-residue nondegeneracy placeholder.
```

It proves:

```text
C1-Origin+ -> passive C109a origin-polarizer certificate;
Odd_J(P0) = 0 -> not C1-Origin+;
C1-Origin+ alone does not imply GateC1_NU_Free.
```

This cleanly inserts a middle audit layer:

```text
C109a passive entry ticket
  -> C1-Origin+ pre-release audit
  -> spectral-island/Riesz bridge
  -> GateC1_NU_Free
  -> background-gauge/quantum audits.
```

### C120: sign-involution origin no-go

C120 formalizes the key overlap/GW origin warning:

```text
if H0 commutes with J, then every polynomial p(H0) commutes with J;
if sign(H0) is built spectrally from H0, then sign(H0) also commutes with J;
therefore balance-even H0 gives zero origin chiral trace.
```

So the overlap route only helps if:

```text
Odd_J(P0 sign(H_ne(0,1)) P0) != 0.
```

This prevents a renamed balance-even Wilson/null-edge kernel from masquerading
as a Gate C1 solution.

### C127: staggered-Wilson/flavored-mass translation

C127 gives the most actionable reference-model recommendation:

```text
1. Adams staggered-Wilson/flavored mass is the primary physical model for
   W_branch.
2. Schur-generated self-energy is the best finite-origin / Lean-friendly
   generator.
3. Domain-wall transfer is the anomaly/Krein cross-check.
4. Naive flavored-mass overlap is a fallback.
```

The warning lanes are also clear:

```text
standard scalar Wilson-overlap fails the finite origin entry test if the origin
compression remains balance-even;
Karsten-Wilczek / Borici-Creutz need anisotropic counterterm audits;
SLAC/Stacey/tangent kernels are warning examples for tails, zone-edge
singularities, gauge, and anomaly risks.
```

## Updated working target

The best current target is:

```text
Null-edge flavored overlap:

D_kernel(U) = D_ne(U) + W_branch(U) - m0 R;
H_ne(U) = Gamma_K D_kernel(U);
T_br(U) = sign(H_ne(U));
P_phys(U) = (1 + T_br(U)) / 2.
```

with `W_branch` modeled first on Adams-style flavored mass, and preferably
generated or audited by the C118 Schur parity criterion.

## Trust status

The Aristotle outputs report clean builds and no proof holes in their standalone
Mathlib projects. This integration pass did not download/promote those Lean files
into trusted `PhysicsSM` modules and did not run local Lean or pre-commit.

Any future promotion into trusted Lean should:

```text
download the exact Aristotle project archive;
inspect theorem statements for semantic alignment;
scan for placeholder tokens and native-decision trust;
run lake env lean on the candidate file;
run the targeted build and pre-commit before claiming trusted integration.
```
