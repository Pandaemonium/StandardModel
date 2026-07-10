# Aristotle semantic context pack

Generated: 2026-07-09T13:57:44
Query: `Concrete null-edge carrier four-channel decomposition rigidity with selecting grading operator, versus proven non-rigidity of chirality grading alone`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/aristotle-downloads-wave12-13-20260626/f16-post-route-b-prediction-ledger/f16-post-route-b-prediction-ledger_aristotle/AgentTasks/null-edge-post-route-b-prediction-ledger.md` [Alive — Route R1: operator-forced branch chirality / flavored-index rigidity]

Score: `0.801`

```text
### Alive — Route R1: operator-forced branch chirality / flavored-index rigidity
- **Mechanism:** discrete forcing. `aligned_signs_forced` already proves
  `tr(Γ_flavOp s · P_null)=4 ⇔ s=g5` over `±1` signs, with `|tr|≤4`
  (`flavoredOp_index_le_four`). The chirality texture is rigid *given* the
  branch-chirality eigenvalues.
- **Single obligation:** prove `OperatorForcesAlignment` for the actual flat
  tetrahedral null-edge Clifford symbol, i.e. that the zero mode on branch `a`
  carries spacetime-chirality eigenvalue `g5 a`. Currently `def
  OperatorForcesAlignment bc := (bc = g5)` is a posited hypothesis fed to
  `gateC_conditional_release`.
- **Falsifier (must be checked, per plan §26.3):** the determinant-zero set is
  *not* a finite isolated branch set (extended nodal surfaces / null cones /
  complex sheets), or the symbol assigns a chirality pattern not in the `±g5`
  orbit, or yields a higher-dimensional / Krein-negative branch kernel. Any of
  these kills R1 and triggers redesign rather than a prediction.
- **Verdict:** **highest-value live route.** Status PRED-COND.
```

### 2. `PhysicsSM/Draft/NullEdgeScalarOriginBalancedKernelNoGo.lean` [R]

Score: `0.787`

```text
def R : Fin 2 → ℂ := ![0, 1]

/-- The chirality grading `γ = diag(1, -1)` on the two origin lines. -/
```

### 3. `PhysicsSM/Draft/NullEdgeSuperDiracProductGradingKrein.lean`

Score: `0.785`

```text
import Mathlib

/-!
# Draft.NullEdgeSuperDiracProductGradingKrein

Finite product-grading and Krein-symmetry layer for the corrected null-edge
super-Dirac conjecture.

The module proves that:

* a diagonal grading anticommutes with any operator supported on opposite signs;
* the product grading on degree times chirality flips under either an external
  degree-odd block or an internal chirality-odd block;
* finite `J`-self-adjointness is the natural Lorentzian/Krein predicate;
* ordinary self-adjointness plus commutation with `J` implies
  `J`-self-adjointness.
-/
```

### 4. `AgentTasks/aristotle-downloads-wave12-13-20260626/c58-projected-branch-weyl-projector/c58-projected-branch-weyl-projector_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [25.3 Gate C: determinant zeros are branch singularities until classified]

Score: `0.783`

```text
entum null branch;
redesign trigger.
```

Modified or flavored chirality should wait until this branch structure is known.
If the determinant-zero set is a finite set of isolated branches, a minimally
doubled-style operator

```text
Gamma_flav = sum_{rho in branches} epsilon_rho P_rho Gamma_s P_rho
```

may be the right tool. If the zero set is a surface, high-momentum cone, or
complex locus, the minimally doubled analogy probably fails and the operator
needs redesign, a Wilson/overlap/domain-wall layer, or a physical-sector
projection.

Keep these gradings strictly separate:

```text
Gamma_s       = spacetime chirality
chi_E         = internal grading
epsilon_form  = cochain/form-degree grading
J             = Krein fundamental symmetry
```
```

### 5. `AgentTasks/aristotle-downloads-wave12-13-20260626/c60-species-split-nodal-line-lift/c60-species-split-nodal-line-lift_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [25.3 Gate C: determinant zeros are branch singularities until classified]

Score: `0.783`

```text
entum null branch;
redesign trigger.
```

Modified or flavored chirality should wait until this branch structure is known.
If the determinant-zero set is a finite set of isolated branches, a minimally
doubled-style operator

```text
Gamma_flav = sum_{rho in branches} epsilon_rho P_rho Gamma_s P_rho
```

may be the right tool. If the zero set is a surface, high-momentum cone, or
complex locus, the minimally doubled analogy probably fails and the operator
needs redesign, a Wilson/overlap/domain-wall layer, or a physical-sector
projection.

Keep these gradings strictly separate:

```text
Gamma_s       = spacetime chirality
chi_E         = internal grading
epsilon_form  = cochain/form-degree grading
J             = Krein fundamental symmetry
```
```

### 6. `AgentTasks/aristotle-downloads-wave12-13-20260626/c61-gauge-covariant-link-dressed-projectors/c61-gauge-covariant-link-dressed-projectors_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [25.3 Gate C: determinant zeros are branch singularities until classified]

Score: `0.783`

```text
entum null branch;
redesign trigger.
```

Modified or flavored chirality should wait until this branch structure is known.
If the determinant-zero set is a finite set of isolated branches, a minimally
doubled-style operator

```text
Gamma_flav = sum_{rho in branches} epsilon_rho P_rho Gamma_s P_rho
```

may be the right tool. If the zero set is a surface, high-momentum cone, or
complex locus, the minimally doubled analogy probably fails and the operator
needs redesign, a Wilson/overlap/domain-wall layer, or a physical-sector
projection.

Keep these gradings strictly separate:

```text
Gamma_s       = spacetime chirality
chi_E         = internal grading
epsilon_form  = cochain/form-degree grading
J             = Krein fundamental symmetry
```
```

### 7. `AgentTasks/aristotle-downloads-wave12-13-20260626/c59-post-c21-projected-release-criterion/c59-post-c21-projected-release-criterion_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [25.3 Gate C: determinant zeros are branch singularities until classified]

Score: `0.783`

```text
entum null branch;
redesign trigger.
```

Modified or flavored chirality should wait until this branch structure is known.
If the determinant-zero set is a finite set of isolated branches, a minimally
doubled-style operator

```text
Gamma_flav = sum_{rho in branches} epsilon_rho P_rho Gamma_s P_rho
```

may be the right tool. If the zero set is a surface, high-momentum cone, or
complex locus, the minimally doubled analogy probably fails and the operator
needs redesign, a Wilson/overlap/domain-wall layer, or a physical-sector
projection.

Keep these gradings strictly separate:

```text
Gamma_s       = spacetime chirality
chi_E         = internal grading
epsilon_form  = cochain/form-degree grading
J             = Krein fundamental symmetry
```
```

### 8. `Sources/Archive/Null_Edge_Unified_Mass_Model_Working_Plan_Longform_2026-06-27.md` [25.3 Gate C: determinant zeros are branch singularities until classified]

Score: `0.783`

```text
entum null branch;
redesign trigger.
```

Modified or flavored chirality should wait until this branch structure is known.
If the determinant-zero set is a finite set of isolated branches, a minimally
doubled-style operator

```text
Gamma_flav = sum_{rho in branches} epsilon_rho P_rho Gamma_s P_rho
```

may be the right tool. If the zero set is a surface, high-momentum cone, or
complex locus, the minimally doubled analogy probably fails and the operator
needs redesign, a Wilson/overlap/domain-wall layer, or a physical-sector
projection.

Keep these gradings strictly separate:

```text
Gamma_s       = spacetime chirality
chi_E         = internal grading
epsilon_form  = cochain/form-degree grading
J             = Krein fundamental symmetry
```
```

## Scoped paper hits

### 1. Extension of the Nielsen-Ninomiya theorem

Score: `0.733`
Zotero key: `arxiv:hep-lat/9803002`
arXiv: `hep-lat/9803002`
DOI: `10.1103/PhysRevD.58.057505`
URL: http://arxiv.org/abs/hep-lat/9803002

Abstract:

Extends the Nielsen-Ninomiya no-go theorem for lattice chiral Dirac fermions using the index theorem, including translation non-invariant and non-local formulations.

### 2. Superconnections and the Chern character

Score: `0.730`
Zotero key: `WNATKBT5`
DOI: `10.1016/0040-9383(85)90047-3`
URL: https://doi.org/10.1016/0040-9383(85)90047-3

### 3. Locality properties of Neuberger's lattice Dirac operator

Score: `0.729`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 4. Finite-Difference Approach to the Hodge Theory of Harmonic Forms

Score: `0.727`
Zotero key: `TSAQXS9N`
DOI: `10.2307/2373615`
URL: https://doi.org/10.2307/2373615

### 5. Higher gauge theory

Score: `0.727`
DOI: `10.1090/conm/431/08264`
URL: https://doi.org/10.1090/conm/431/08264
