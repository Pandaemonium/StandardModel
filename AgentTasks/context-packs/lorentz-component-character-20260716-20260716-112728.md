# Aristotle semantic context pack

Generated: 2026-07-16T11:29:29
Query: `Lorentz component determinant time orientation cocycle SL2C restricted Lorentz null edge carrier atlas`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `NULL_EDGE_RESULTS.md` [10. Carrier-layer results (2026-07-07 update)]

Score: `0.803`

```text
## 10. Carrier-layer results (2026-07-07 update)

The two-day carrier run (`AgentTasks/twoday-carrier-run-2026-07-07/`, joint
Claude/Codex/Aristotle execution) added an operator layer above the P1
kinematics. Everything below is DRAFT-layer but kernel-clean with
build-enforced axiom pins (`[propext, Classical.choice, Quot.sound]`) in
`PhysicsSM/Draft/NullEdge/Carrier/CarrierAxiomGuard.lean` - none of it is in
the trusted namespace yet.

- **Null-tick aggregate proper time (finite identity, 2026-07-14).**
  `NullTickProperTime.lean` kernel-checks the standard 1+1 formula
  `tau^2 = 4 * epsilon^2 * nPlus * nMinus` and the exact nonempty-history
  identity `tau^2 = t^2 * (1 - v^2)`, proves that one-direction support is null
  while two-direction support is timelike, and proves that balanced populations
  uniquely saturate the coordinate-time bound for nonzero tick scale. This is
  endpoint Lorentzian geometry, not positive proper time on individual null
  segments and not a claim that reversal count defines time.
- **Discrete Weitzenbock decomposition (finite identity).** For the carrier
  `D = sum_e c(alpha_e) nabla_e + Gamma phi` with null soldering
  (`c(alpha_e)^2 = 0`, kernel-checked), the square decomposes exactly:
  `4 D^2 = Q_A + Q_C + 4 Q_T` in the covariantly-constant regime, and
  `4 D^#D = Q_A^# + Q_C^# + 4 Q_T + 4 E_#` with varying soldering - aperture,
  closure, turn, and soldering-gradient (gravity-shaped) channels separated in
  one operator identity. "Unification is decomposition, not identification."
- **Finite connection/Dirac geometry chain (finite identity, 2026-07-14).**
  `PhysicsSM/Draft/NullEdge/FiniteConnectionGeometry.lean` proves that the
  adjoint commutator curvature obeys the cyclic Jacobi/Bianchi identity, and
  that the strong finite tetra
```

### 2. `AgentTasks/fable_parallel/Q10_answer.md` [Q10 — Verdict first]

Score: `0.794`

```text
# Q10 — Verdict first

**V1 (signature): OUTPUT, theorem grade.** Euclidean signature dies at the first kernel axiom (`c(alpha)^2 = 0` forces alpha null; definite forms have no nonzero nulls). Multi-time signatures die at a *finite frustration lemma*: there is an explicit integer triple of null vectors in R^{2,2} admitting no consistent retarded/advanced coloring. Both are one-page Lean targets today. Lorentzian is the unique signature class with an orientable null cone; equivalently (Vinberg) the unique one with an invariant convex cone. Your candidate principle 1(a) is correct and can be made finite.

**V2 (a correction to the naive form of V1 — flag this loudly):** retardation on a *fixed* finite complex does **not** certify Lorentzian signature. I exhibit below four integer null vectors *spanning* R^{2,2} with all pairwise products strictly positive — a perfectly "retarded-looking" sky in a two-time world. The true theorem is a **stability** statement: Lorentzian ⟺ *every extension of the sky by null edges remains orientable*. Signature is a theorem about stable order, not about order at one complex. This matters for how Q3's equivalence must be phrased, and it is a small-dimension counterexample of exactly the kind your protocol requests.

**V3 (dimension): RECONSTRUCTION, not output, not free parameter.** Pure consistency of the carrier's soldering axiom gives exactly the Hurwitz ladder d ∈ {3,4,6,10} (Kugo–Townsend identity). The cut to 4 is done by two axioms, each with a finite algebraic formulation and an empirical anchor, neither a pure consistency requirement: **(A) chirality exists** (kills d = 3: no Γ on an irreducible odd-dimensional Clifford module), and **(B) the mass amplitude is a scalar** — a singlet exists in S ⊗ S for the minimal spinor S. Finite r
```

### 3. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G3. Nondegenerate coframe and spin structure]

Score: `0.793`

```text
class vanishes exactly when one edge
sign cochain trivializes every supplied face holonomy. The explicit square has
a nonzero defect representative but zero quotient class, because its displayed
edge correction flattens the face. This is the correct distinction between a
lift-dependent cocycle representative and its obstruction class; it is still
finite cochain algebra, not an identification with \(w_2\).

The program still owes surjectivity onto the proper orthochronous Lorentz
group, derivation of face attachments and local `SL(2,C)` lifts from bare graph,
coframe, and Lorentz data, proof that Lorentz-flat face products land in the
central kernel, proof that the concrete Hermitian-action kernel is exactly
\(\{I,-I\}\), invariance under general cover changes and refinement,
identification of the resulting obstruction with the second Stiefel--Whitney
class on a convergent good-cover nerve, derivation of gauge-relative coframes
from graph data, and continuum spin-bundle convergence.

**Success:** nondegeneracy, local Lorentz covariance, and patch compatibility.  
**Kill:** unavoidable frame singularities or non-equivariant preferred
directions.
```

### 4. `PhysicsSM/Draft/NullEdgeCoreAristotle.lean` [targets]

Score: `0.790`

```text
import Mathlib

/-!
# Draft.NullEdgeCoreAristotle

Aristotle handoff for the highest-leverage finite theorem targets in the
null-edge causal graph program.

Source notes:
- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
- `Sources/Toward_a_Null-Edge_Causal_Graph_Formulation.md`
- `Sources/Luminal_Motion_Checkerboard_Research_Program.md`

The goal is not to formalize a full continuum theory.  This file isolates
three finite, kernel-checkable theorem islands that directly support the
program:

1. Pluecker mass: a two-edge bundle of complex null spinors has determinant
   mass equal to the squared spinor wedge.
2. Causal-diamond holonomy: the Abelian path-comparison defect is invariant
   under vertex gauge transformations.
3. Order-complex seed: the alternating boundary on formal simplices squares
   to zero, the combinatorial start of a graph-native Kahler-Dirac branch.

All statements below are draft targets for Aristotle.  They may contain
documented `s o r r y`s here, and should not be moved to trusted code until the
proofs are reviewed, placeholder-free, and the convention choices are checked.
-/
```

### 5. `AgentTasks/aristotle-wave6-20260626/furey-null-edge-internal-spectrum/materials/null-edge-wave6-gates-native-20260626-20260626-105818.md` [check @PhysicsSM.Draft.NullEdgeDiracSlashCore.sigmaMomentum_det_eq_minkowskiNorm]

Score: `0.785`

```text
#check @PhysicsSM.Draft.NullEdgeDiracSlashCore.sigmaMomentum_det_eq_minkowskiNorm

/-! ## Core 2: NullEdgeBundleDiracPluckerCore (used by `NullStrand.FiniteCore`) -/
```

### 6. `AgentTasks/aristotle-wave6-20260626/gate-c-redesign/materials/null-edge-wave6-gates-native-20260626-20260626-105818.md` [check @PhysicsSM.Draft.NullEdgeDiracSlashCore.sigmaMomentum_det_eq_minkowskiNorm]

Score: `0.785`

```text
#check @PhysicsSM.Draft.NullEdgeDiracSlashCore.sigmaMomentum_det_eq_minkowskiNorm

/-! ## Core 2: NullEdgeBundleDiracPluckerCore (used by `NullStrand.FiniteCore`) -/
```

### 7. `AgentTasks/aristotle-wave6-20260626/gate-a-closeout/materials/null-edge-wave6-gates-native-20260626-20260626-105818.md` [check @PhysicsSM.Draft.NullEdgeDiracSlashCore.sigmaMomentum_det_eq_minkowskiNorm]

Score: `0.785`

```text
#check @PhysicsSM.Draft.NullEdgeDiracSlashCore.sigmaMomentum_det_eq_minkowskiNorm

/-! ## Core 2: NullEdgeBundleDiracPluckerCore (used by `NullStrand.FiniteCore`) -/
```

### 8. `AgentTasks/aristotle-wave6-20260626/b4-square-rebase/materials/null-edge-wave6-gates-native-20260626-20260626-105818.md` [check @PhysicsSM.Draft.NullEdgeDiracSlashCore.sigmaMomentum_det_eq_minkowskiNorm]

Score: `0.785`

```text
#check @PhysicsSM.Draft.NullEdgeDiracSlashCore.sigmaMomentum_det_eq_minkowskiNorm

/-! ## Core 2: NullEdgeBundleDiracPluckerCore (used by `NullStrand.FiniteCore`) -/
```

## Scoped paper hits

### 1. On the definition of spacetimes in Noncommutative Geometry, part II

Score: `0.756`
Zotero key: `RADF3RUP`
arXiv: `1611.07842`
DOI: `10.48550/arXiv.1611.07842`
URL: https://arxiv.org/abs/1611.07842

Abstract:

Defines spectral spacetimes with time-orientation forms, stable causality, finite graph examples, split Dirac structures, and Lorentzian discretized Dirac operators.

### 2. Temporal Lorentzian Spectral Triples

Score: `0.743`
Zotero key: `JKDD4KGC`
arXiv: `1210.6575`
DOI: `10.48550/arXiv.1210.6575`
URL: https://arxiv.org/abs/1210.6575

Abstract:

Introduces temporal Lorentzian spectral triples, corresponding to a 3+1 decomposition and global time structure for noncommutative Lorentzian spaces.

### 3. Locality properties of Neuberger's lattice Dirac operator

Score: `0.738`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 4. On the definition of spacetimes in Noncommutative Geometry, Part I

Score: `0.726`
Zotero key: `5VWPZ8BP`
arXiv: `1611.07830`
DOI: `10.48550/arXiv.1611.07830`
URL: https://arxiv.org/abs/1611.07830

Abstract:

Part I develops Lorentzian spectral-spacetime foundations in the commutative continuous case, including signature characterization by time-orientation one-forms and a Krein product on spinors.

### 5. Causality in noncommutative two-sheeted space-times

Score: `0.722`
Zotero key: `3QJHNHMP`
arXiv: `1502.04683`
DOI: `10.1016/j.geomphys.2015.05.008`
URL: http://arxiv.org/abs/1502.04683

Abstract:

We investigate the causal structure of two-sheeted space-times using the tools of Lorentzian spectral triples. We show that the noncommutative geometry of these spaces allows for causal relations between the two sheets. The computation is given in details when the sheet is a 2- or 4-dimensional globally hyperbolic spin manifold. The conclusions are then generalised to a point-dependent distance between the two sheets resulting from the fluctuations of the Dirac operator.
