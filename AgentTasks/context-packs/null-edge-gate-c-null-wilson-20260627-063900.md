# Aristotle semantic context pack

Generated: 2026-06-27T06:39:10
Query: `Gate C null Wilson regulator determinant zeros projected physical sector ghost residue`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/NullStrand_Lean_Roadmap_Improved.md` [Revised G5 split]

Score: `0.761`

```text
#### Revised G5 split

```text
G5a -- reconstruction gate:
  one concrete dual-soldered null-edge/Krein super-Dirac architecture reproduces
  the known Dirac, gauge, Higgs/Yukawa, and Born-equivariant structures with
  exact finite algebra and controlled scaling.

G5b -- rigidity/prediction gate:
  the finite null/spectral axioms force a proper lower-dimensional image in
  continuum EFT parameter space, yielding at least one relation, exclusion, or
  correction not inserted by hand.
```

G5a is already scientifically worthwhile. G5b is the stronger new-dynamics gate.
This avoids making the project look unsuccessful merely because an exactly
Born-equivariant hidden-variable reconstruction reproduces ordinary quantum
statistics.
```

### 2. `AgentTasks/model-calls/gemini/2026-06-24-round-015-constructive-next-job.md` [Query]

Score: `0.758`

```text
## Query

We are advancing the null-edge causal graph program in a constrained autonomous loop. Latest integrated result:

P2 determinant parity guardrail: for the finite branch reflection R = H/E, explicit 2x2 determinant is multiplicative, det(R) = -1 on shell, product of two branch reflections has determinant +1, and any finite product of det=-1 reflections has determinant (-1)^length. Thus determinant-only path products carry only reflection-count parity, not proper-time geometry.

Current priorities: P1-F Plucker/observer normalization; P1/P4/P7 null-step chirality dynamics and proper-time readout; P2-R one-diamond super-Dirac gate; P9-F finite source-visibility/noise and coarse-map guardrails.

What is the single highest-value next scientific move for one focused Aristotle proof job? Please propose one concrete finite theorem target, why it matters physically, one likely failure mode, and one literature/source check. Avoid determinant-only path sums and broad continuum claims.
```

### 3. `AgentTasks/model-calls/claude/2026-06-24-round-021-constructive-next-target.md` [Current integrated theorem state]

Score: `0.752`

```text
## Current integrated theorem state

Recent P2 branch-reflection results in
`PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace`:

- one branch reflection is trace zero;
- determinant products of branch reflections carry only reflection-count parity;
- two-reflection trace:
  `trace(R2 R1) = 2 * (h1*h2*p1*p2 + m1*m2)/(E1*E2)`;
- three-reflection trace is zero;
- four-reflection trace has an explicit scalar formula in the current
  `h,p,m,E` API;
- concrete witnesses prove unconstrained four-reflection trace is not constant:
  `trace(A A A A)=2` and `trace(B A B A)=-2` for
  `A = branchReflection 1 1 0 1`,
  `B = branchReflection 1 0 1 1`.

Recent P2/P3 super-Dirac gate:

- `PhysicsSM.Draft.NullEdgeSuperDiracDiamondCurvature` proves finite scalar
  identities relating additive one-diamond defect and multiplicative holonomy
  defect:
  `left - right = (left / right - 1) * right` when `right != 0`;
  multiplicative triviality is equivalent to additive defect zero.

Recent P9 source-visibility results:

- `PhysicsSM.Draft.NullEdgeP9DiamondScreenVisibility` proves exact local screen
  bookkeeping pairs to zero with closed tests, rank-one exact-source noise also
  vanishes, and any source with nonzero closed-test response cannot be exact.
- `PhysicsSM.Draft.NullEdgeP9ScreenQuotientBound`,
  `NullEdgeP9ScreenVarianceBound`, and P2/P9 reflection-screen variance modules
  provide screen-cardinality and variance support.

Recent P1 observer-normalization support:

- fixed observer/rest Hermitian data leaves residual `SU(2)` spin-frame
  freedom;
- two-null observer-axis scalar bridge relates unnormalized mass square and
  trace-normalized determinant;
- residual unitary determinant-one congruence preserves the trace-normalized
  determinant;
- normalized readout can recover `m^2` when
```

### 4. `Sources/NullStrand_Lean_Roadmap.md` [Gate B — relativistic one-particle continuum model]

Score: `0.748`

```text
### Gate B — relativistic one-particle continuum model

Adds:

- intrinsic covariant null measure;
- flux-weighted observer current;
- global process existence;
- spectral gap/ergodicity for positive mass;
- correct massless boundary behavior.
```

### 5. `Sources/NullStrand_Lean_Roadmap.md` [Gate D — graph-derived physical theory]

Score: `0.748`

```text
### Gate D — graph-derived physical theory

Adds:

- one concrete first-order graph operator;
- null-continuation support;
- correct super-Dirac square;
- correct continuum/scaling limit;
- a prediction or constraint not inserted by hand.

Only Gate D upgrades the program from an empirically equivalent ontology to a candidate new dynamics.

---
```

### 6. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Falsification ledger]

Score: `0.744`

```text
ht finite operator bridge | Gamma/Pauli/signature conventions cannot be aligned with the trusted determinant mass, or the square-root theorem factors only a number but cannot be connected to any graph propagation or chirality-flip operator |
| Normalized celestial mixedness is used only frame-relatively | The program treats `det(P_vis / Tr(P_vis))` as a Lorentz scalar, hides the timelike normalization choice, or fails to prove the unnormalized `det(A P_vis A^dagger) = det(P_vis)` invariant wrapper |
| Two-observer factorization is the right mass-channel interface | The visible boost fails to commute with the internal trace in the physical model, the resolution observer cannot be represented by a finite Gram-bearing internal label family, or the kinematic observer cannot be separated cleanly from the irreversible coarse-graining |
| Internal Gram law is the concrete observer channel | The physical hidden labels are not described by a stable Gram matrix, `det(P_vis)=w^dagger (Lambda^2 G) w` is not the relevant determinant, dephasing of `G` is not monotone in the intended dynamics, or the two-label factorization has no operational meaning |
| Higgs/Yukawa flips are the off-diagonal mass block | The legal flip bookkeeping cannot be realized as an odd left/right operator whose square gives the expected Yukawa mass matrix, or the Yukawa block cannot be equated on shell with the kinetic Pluecker determinant without convention drift or double-counting |
| Complex Plucker amplitude is the first-order mass/phase object | The wedge phase cannot be made invariant under the relevant spinor/gauge rephasings, does not match Bargmann/Pancharatnam phase on triangles, or fails to commute with the graph-native holonomy layer |
| Two-sheet structure is forced by the mass square root | The
```

### 7. `PhysicsSM/Draft/StandardModelAnomalyPackage.lean` [weakDoubletCount]

Score: `0.744`

```text
def weakDoubletCount (multiplets : List ChiralMultiplet) : Nat :=
  (multiplets.map fun m =>
    if m.weak.isDoublet then m.colorMultiplicity else 0).sum

/-- Local perturbative gauge and mixed anomaly cancellation conditions. -/
```

### 8. `Sources/Null_Edge_Key_Conjectures.md` [What might be missing]

Score: `0.744`

```text
### What might be missing

The hardest missing piece is not another scalar identity. It is a real
universality theorem:

- a class of allowed walks with precise locality/unitarity/covariance
  hypotheses;
- a scaling limit theorem rather than a Taylor expansion in one toy model;
- a band-limited convergence estimate using an isolated quasienergy branch and
  a controlled logarithm;
- a full Brillouin-zone census of gap closings, cone locations, chiralities,
  multiplicities, and effective masses;
- a connection between the walk spinor/chirality space and the visible/internal
  observer-channel space;
- an invariant `det P_vis = m^2` bridge, separate from the frame-relative
  normalized `det rho_vis`;
- a single-cone or honest species/doubler accounting;
- a proof that Kähler-Dirac multiplicity, left/right chirality doubling, and
  internal generations are not being double-counted;
- a robust treatment of gauge fields and position dependence;
- a way to handle higher-dimensional isotropy and fermion doubling concerns;
- numerical pilots showing the expected dispersion and stability beyond the
  exactly solvable model.

Failure mode: the null-step walk reproduces Dirac behavior only after fragile
fine-tuning, or the mass parameter in the walk cannot be tied to the Pluecker
and observer-channel invariants without extra assumptions.
Another failure mode is that the walk mass can only be matched to the
frame-normalized `det rho_vis`, with no invariant unnormalized determinant
statement. That would weaken the claimed bridge to P1.

The invariant mass bridge should be derived independently from the walk
dispersion. Starting from a quasienergy `epsilon_a(k)`, prove either an exact
deformed shell

```text
epsilon_a(k)^2 - |q_a(k)|^2 = m^2
```

for a naturally derived lattice mom
```

## Scoped paper hits

### 1. Propagator zeros and lattice chiral gauge theories

Score: `0.763`
Zotero key: `8NRUZ46K`
arXiv: `2311.12790`
URL: http://arxiv.org/abs/2311.12790

Abstract:

Symmetric mass generation (SMG) has been advocated as a mechanism to render mirror fermions massive without symmetry breaking, ultimately aiming for the construction of lattice chiral gauge theories. It has been argued that in an SMG phase, the poles in the mirror fermion propagators are replaced by zeros. Using an effective lagrangian approach, we investigate the role of propagator zeros when the gauge field is turned on, finding that they act as coupled ghost states. In four dimensions, a propagator zero makes an opposite-sign contribution to the one-loop beta function as compared to a normal fermion. In two dimensional abelian theories, a propagator zero makes a negative contribution to the photon mass squared. In addition, propagator zeros generate the same anomaly as propagator poles. Thus, gauge invariance will always be maintained in an SMG phase, in fact, even if the target chiral gauge theory is anomalous, but unitarity of the gauge theory is lost.

### 2. An invitation to higher gauge theory

Score: `0.723`
DOI: `10.1007/s10714-010-1070-9`
URL: https://doi.org/10.1007/s10714-010-1070-9

### 3. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.721`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 4. Lattice Regularization of Reduced Kähler-Dirac Fermions and Connections to Chiral Fermions

Score: `0.721`
Zotero key: `VIQMFAXZ`
arXiv: `2311.02487`
DOI: `10.21468/SciPostPhys.16.4.108`
URL: http://arxiv.org/abs/2311.02487

Abstract:

We show how a path integral for reduced Kähler-Dirac fermions suffers from a phase ambiguity associated with the fermion measure that is an analog of the measure problem seen for chiral fermions. However, unlike the case of chiral symmetry, a doubler free lattice action exists which is invariant under the corresponding onsite symmetry. This allows for a clear diagnosis and solution to the problem using mirror fermions resulting in a unique gauge invariant measure. By introducing an appropriate set of Yukawa interactions which are consistent with 't Hooft anomaly cancellation we conjecture the mirrors can be decoupled from low energy physics. Moreover, the minimal such Kähler-Dirac mirror model yields a light sector which corresponds, in the flat space continuum limit, to the Pati-Salam GUT model.

### 5. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.721`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548
