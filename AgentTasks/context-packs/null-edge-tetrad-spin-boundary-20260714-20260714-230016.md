# Aristotle semantic context pack

Generated: 2026-07-14T23:00:28
Query: `null edge bare graph metric coframe tetrad Lorentz gauge spin lift sign ambiguity global spin structure reconstruction`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/TetradSpinReconstructionBoundary.lean`

Score: `0.875`

```text
import PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry

/-!
# Tetrad and spin reconstruction boundary

This module records two local nonuniqueness facts that a graph-to-GR
reconstruction must respect.

First, a metric does not select a unique coframe.  An explicit nonidentity
rational transformation preserves the four-dimensional mostly-minus form
`diag(1, -1, -1, -1)`.  Acting on the identity coframe therefore produces a
distinct nondegenerate coframe with exactly the same induced metric.  A
reconstruction can at most select a Lorentz-gauge class unless it supplies a
gauge choice or additional structure.

Second, the two matrices `S` and `-S`, paired with inverse candidates `SInv`
and `-SInv`, induce the same conjugation action on vector representatives but
opposite actions on spinors.  The explicit determinant-one identity witness
shows that this ambiguity is nonvacuous.  Lorentz transport therefore does not
by itself choose a unique local spin lift.

These are finite local algebraic boundary theorems.  They do not establish the
existence of a tetrad, derive a tetrad from a bare graph, construct a global
spin structure, or discharge the topological obstruction to a spin lift.
-/

open Matrix
```

### 2. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G3. Nondegenerate coframe and spin structure]

Score: `0.829`

```text
### G3. Nondegenerate coframe and spin structure

Construct a measurable or gauge-relative coframe field and the associated spin
bundle data.

**Success:** nondegeneracy, local Lorentz covariance, and patch compatibility.  
**Kill:** unavoidable frame singularities or non-equivariant preferred
directions.
```

### 3. `PhysicsSM/Draft/NullEdge/TetradSpinReconstructionBoundary.lean` [spinLift_sign_witness]

Score: `0.821`

```text
theorem spinLift_sign_witness :
    ∃ (S SInv : Matrix (Fin 2) (Fin 2) ℂ) (psi : Fin 2 -> ℂ),
      S.det = 1 ∧
      (-S).det = 1 ∧
      SInv * S = 1 ∧
      S * SInv = 1 ∧
      (-SInv) * (-S) = 1 ∧
      (-S) * (-SInv) = 1 ∧
      (∀ X, vectorConjugation (-S) (-SInv) X =
        vectorConjugation S SInv X) ∧
      spinorAction (-S) psi ≠ spinorAction S psi := by
  exact ⟨spinIdentity, spinIdentity, up,
    spinIdentity_and_neg_det.1, spinIdentity_and_neg_det.2,
    spinIdentity_inverse, spinIdentity_inverse,
    negSpinIdentity_inverse, negSpinIdentity_inverse,
    fun X => vectorConjugation_neg spinIdentity spinIdentity X,
    spinIdentity_actions_ne⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.metric_does_not_fix_coframe_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.metric_does_not_fix_coframe_witness

/-- info: 'PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.vectorConjugation_neg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.vectorConjugation_neg

/-- info: 'PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.spinorAction_neg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.spinorAction_neg

/-- info: 'PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.spinLift_sign_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Physics
```

### 4. `PhysicsSM/Draft/NullEdge/TetradSpinReconstructionBoundary.lean` [spinLift_sign_witness]

Score: `0.820`

```text
'PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.spinLift_sign_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.spinLift_sign_witness

end PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary
```

### 5. `PhysicsSM/Draft/NullEdge/TetradSpinReconstructionBoundary.lean` [metric_does_not_fix_coframe_witness]

Score: `0.790`

```text
theorem metric_does_not_fix_coframe_witness :
    ∃ (eta e e' : Matrix (Fin 4) (Fin 4) ℚ),
      PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.Nondegenerate e ∧
      PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.Nondegenerate e' ∧
      e' ≠ e ∧
      PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.inducedMetric eta e' =
        PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.inducedMetric eta e := by
  refine ⟨eta4, 1, boost4, ?_, boost4_nondegenerate, boost4_ne_one, ?_⟩
  · simp [PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.Nondegenerate]
  · simpa [PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.transformCoframe] using
      PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.inducedMetric_frame_invariant
        eta4 boost4 (1 : Matrix (Fin 4) (Fin 4) ℚ) boost4_lorentz

/-! ## A Lorentz action determines two local spin lifts -/

/-- Conjugation action of a matrix and a chosen inverse candidate. -/
```

### 6. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [14. Bottom line]

Score: `0.786`

```text
## 14. Bottom line

The null-edge framework has a coherent route toward general relativity, but it
is currently a route, not a completed derivation.

Its strongest assets are:

- a natural causal primitive;
- an exact null-to-timelike aggregation mechanism;
- a disciplined conformal-versus-scale split;
- finite coframe and local-frame covariance;
- gauge-covariant holonomy;
- an exact Dirac-square channel decomposition;
- several finite, nonvacuous dynamics avatars;
- explicit no-go and kill conditions.

Its decisive debts are:

- a Lorentz-compatible continuum ensemble;
- a unique local scale reconstruction;
- a derived nondegenerate tetrad and spin structure;
- curvature convergence;
- a conserved stress tensor;
- an Einstein-equation theorem with physical constants;
- weak-field, wave, horizon, and cosmological controls.

The correct near-term claim is therefore:

\[
  \boxed{\text{finite null-edge Lorentzian and Dirac geometry with a graded GR reconstruction program}}
\]

not

\[
  \boxed{\text{general relativity already derived from a graph}}.
\]
```

### 7. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [3.3 What a bare causal graph does not supply]

Score: `0.772`

```text
### 3.3 What a bare causal graph does not supply

A bare partial order does not canonically produce:

- a finite null tetrad at each event;
- a preferred spatial direction;
- a fixed finite-valency nearest-neighbor graph;
- a spin structure;
- a connection or curvature tensor;
- an absolute discreteness scale;
- the Einstein equation.

The no-preferred-direction result for Poisson sprinklings is especially
important: a Lorentz-equivariant measurable rule cannot extract a spacetime
direction from a sprinkling, and a finite-valency graph cannot be attached in
that manner. Any local null frame must therefore be decorated, gauge-relative,
statistical, or reconstructed by an additional theorem.
```

### 8. `AgentTasks/aristotle-downloads-wave12-13-20260626/fur-h3-conjugate-ideal-right-handed-sector/fur-h3-conjugate-ideal-right-handed-sector_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [Theorem B3: scalar/gauge null kinetic reconstruction]

Score: `0.768`

```text
#### Theorem B3: scalar/gauge null kinetic reconstruction

The scalar/gauge theorem is mandatory for Higgs/W/Z claims to be genuinely null-edge rather than graph-Higgs with null labels:

```text
g^{-1}(xi, eta) = sum_{a,b} G^{ab} xi(ell_a) eta(ell_b)
G^{ab} = g^{-1}(alpha^a, alpha^b)
```

For a scalar or Higgs field:

```text
g^{-1}(D H, D H)
~ sum_{a,b} G^{ab} <nabla_a^A H, nabla_b^A H>
```

A positive sum over edges is not enough; the Lorentzian inverse-Gram cross terms are the point.
```

## Scoped paper hits

### 1. Spinors and Twistors in Loop Gravity and Spin Foams

Score: `0.778`
Zotero key: `TCC2N3U6`
arXiv: `1201.2120`
URL: http://arxiv.org/abs/1201.2120

Abstract:

Spinorial tools have recently come back to fashion in loop gravity and spin foams. They provide an elegant tool relating the standard holonomy-flux algebra to the twisted geometry picture of the classical phase space on a fixed graph, and to twistors. In these lectures we provide a brief and technical introduction to the formalism and some of its applications.

### 2. Dirac gauge theory for topological spinors in 3+1 dimensional networks

Score: `0.751`
Zotero key: `WZBHBDRP`
arXiv: `2212.05621`
DOI: `10.1088/1751-8121/acdc6a`
URL: https://www.zotero.org/19894138/items/WZBHBDRP

Abstract:

A Dirac gauge theory for topological spinors in 3+1 dimensional networks associated to an arbitrary metric. Topological spinors are the direct sum of 0-cochains and 1-cochains on a network. The commutators and anti-commutators of the Dirac operators are non vanishing and they define the curvature tensor and magnetic field of the theory. In the non-relativistic limit the link sector follows the Schroedinger equation with the correct gyromagnetic moment, while the node sector follows the Klein-Gordon equation. The action comprises a Dirac action and a metric action with Abelian and non-Abelian gauge invariance.

### 3. A New Spin Foam Model for 4d Gravity

Score: `0.747`
Zotero key: `K8QAB5UD`
arXiv: `0708.1595`
DOI: `10.1088/0264-9381/25/12/125018`
URL: http://arxiv.org/abs/0708.1595

Abstract:

Spin-foam model for four-dimensional gravity from constrained Plebanski BF theory; source guardrail for distinguishing single-bivector simplicity from full spin-foam cross-simplicity constraints.

### 4. An Introduction to Spin Foam Models of $BF$ Theory and Quantum Gravity

Score: `0.734`
Zotero key: `S9X53A6X`
arXiv: `gr-qc/9905087`
DOI: `10.1007/3-540-46552-9_2`
URL: https://www.zotero.org/19894138/items/S9X53A6X

Abstract:

In loop quantum gravity we now have a clear picture of the quantum geometry of space, thanks in part to the theory of spin networks. The concept of ‘spin foam’ is intended to serve as a similar picture for the quantum geometry of spacetime. In general, a spin network is a graph with edges labeled by represen- tations and vertices labeled by intertwining operators. Similarly, a spin foam is a 2-dimensional complex with faces labeled by representations and edges labeled by intertwining operators. In a ‘spin foam model’ we describe states as linear combina- tions of spin networks and compute transition amplitudes as sums over spin foams. This paper aims to provide a self-contained introduction to spin foam models of quantum gravity and a simpler field theory called BF theory.

### 5. Torsion Degrees of Freedom in the Regge Calculus as Dislocations on the Simplicial Lattice

Score: `0.734`
Zotero key: `IJ2MZ3FH`
arXiv: `gr-qc/0103111`
DOI: `10.1023/A:1013031402382`
URL: http://arxiv.org/abs/gr-qc/0103111

Abstract:

Using the notion of a general conical defect, the Regge Calculus is generalized by allowing for dislocations on the simplicial lattice in addition to the usual disclinations. Since disclinations and dislocations correspond to curvature and torsion singularities, respectively, the method we propose provides a natural way of discretizing gravitational theories with torsion degrees of freedom like the Einstein-Cartan theory. A discrete version of the Einstein-Cartan action is given and field equations are derived, demanding stationarity of the action with respect to the discrete variables of the theory.
