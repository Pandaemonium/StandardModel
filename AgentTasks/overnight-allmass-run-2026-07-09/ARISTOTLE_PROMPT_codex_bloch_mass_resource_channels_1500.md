# codex Bloch mass-resource channel classification, 2026-07-09 15:00

aristotle:
  project_id: b6c2a9e3-1b9a-412d-938a-39f00d9fbb8e
  target_file: PhysicsSM/Draft/NullEdge/BlochMassResourceChannels.lean
  expected_module: PhysicsSM.Draft.NullEdge.BlochMassResourceChannels
  submission_project: AgentTasks/aristotle-submit/codex-frontier-wave-1500-20260709-project
  output_dir: AgentTasks/aristotle-output/b6c2a9e3-1b9a-412d-938a-39f00d9fbb8e
  status: submitted 2026-07-09 15:03 PDT

You are Aristotle. Turn the program's “mass as retained which-direction
information” slogan into a sharp finite resource theorem with a maximal honest
channel class and an exact counterexample outside it.

Target:

```text
PhysicsSM/Draft/NullEdge/BlochMassResourceChannels.lean
```

Imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.EntropyMonotoneReal
import PhysicsSM.Draft.NullEdge.LeanQuantumDPIMass
import PhysicsSM.Draft.NullEdge.MassCoherencePathEquivalence
import PhysicsSM.Draft.NullEdge.GateI1.MassEntropyMonotone
```

Context pack:

```text
AgentTasks/context-packs/bloch-mass-resource-channel-20260709-150110.md
```

## Core geometry

Work over real `2x2` trace-one symmetric states in Bloch-disk coordinates:

```text
rho(x,z) = 1/2 * [[1+z, x], [x, 1-z]]
radiusSq(x,z) = x^2 + z^2
massSq(rho) = det rho = (1-radiusSq)/4.
```

Prove exact equivalence between PSD statehood and `radiusSq <= 1`, the closed
determinant formula, and the pure/massless boundary `det rho = 0 <-> radiusSq=1`
under the state hypotheses.

## Sharp channel theorem

Represent a real affine Bloch operation by `F(v)=L v+t`, with `v : Fin 2 -> R`,
`L : Matrix (Fin 2) (Fin 2) R`, and `t : Fin 2 -> R`. Define the geometric
condition that `F` is mass-nondecreasing on every Bloch state:

```text
forall v, radiusSq v <= 1 -> det(rho v) <= det(rho (F v)).
```

Prove the strongest clean classification available. The key exact theorem
should expose:

1. determinant monotonicity is exactly Bloch-radius contraction;
2. any universally mass-nondecreasing affine map must be unital/translation-free
   (`t=0`), because the maximally mixed point `v=0` detects every nonzero `t`;
3. after `t=0`, universal monotonicity is equivalent to `L` being a Euclidean
   contraction (first on the unit disk, preferably extended to every vector by
   homogeneity);
4. orthogonal/coherent rotations preserve mass exactly;
5. strict contractions create positive mass from at least one pure state, with
   an exact rational witness.

A precise theorem such as the following is ideal:

```text
AffineMassNondecreasing L t <-> t = 0 /\ LinearBlochContraction L
```

if your definitions make both directions true. If state preservation needs a
separate hypothesis, state it explicitly and do not smuggle it into prose.

## Mandatory kill and positive fixtures

Give both:

* a rational unital contraction, e.g. `L=(1/2)I`, taking a pure state to a
  strictly positive determinant;
* a rational non-unital translation taking the maximally mixed state to a valid
  state of smaller determinant, disproving monotonicity. For example a small
  `z` translation with exact entries.

Then recover the existing pinching theorem as a specialization of the general
contraction result, not merely as an imported conjunct.

Preferred names:

```lean
blochRho
blochRadiusSq
bloch_det_formula
bloch_state_iff_radiusSq_le_one
AffineMassNondecreasing
LinearBlochContraction
affine_mass_nondecreasing_iff_unital_contraction
orthogonal_preserves_mass
strict_contraction_creates_mass
nonunital_translation_kills_monotonicity
pinch_is_bloch_contraction
bloch_mass_resource_verdict
```

## Claim boundary and references

This is a complete theorem about a real Bloch-disk avatar. It is not a
classification of all complex CPTP maps, and linear entropy/determinant is not
the von Neumann relative entropy. The result may justify a finite resource
interpretation only for the displayed contraction class.

Reference/clean-room sources already recorded in RUN_PLAN section 1c:

```text
lean-quantum: density operators, channels, entropy, DPI theorem shapes
testing-lower-bounds: divergence and data-processing proof shapes
```

They are version-pinned away and must not be imported. Use only Mathlib and the
local modules. Add exact rational witnesses, in-file axiom-footprint guard pins,
and a concise completion report.

Literature addendum (15:42 PDT): Li and Choi, `On unital qubit channels`,
arXiv:2301.01358, gives the canonical Bloch-sphere-to-ellipsoid description and
the convex-mixture-of-unitaries structure for unital qubit channels. It supports
the unital contraction interpretation, but this job must retain its narrower
real Bloch-disk scope and must not claim a full CPTP classification.
