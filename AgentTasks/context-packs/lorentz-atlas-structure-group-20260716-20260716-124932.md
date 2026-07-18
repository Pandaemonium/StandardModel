# Aristotle semantic context pack

Generated: 2026-07-16T12:50:06
Query: `eta Lorentz subgroup GL(4,R) component characters time orientation determinant Cech atlas`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/context-packs/lorentz-component-character-20260716-20260716-112728.md` [Aristotle semantic context pack]

Score: `0.814`

```text
# Aristotle semantic context pack

Generated: 2026-07-16T11:29:29
Query: `Lorentz component determinant time orientation cocycle SL2C restricted Lorentz null edge carrier atlas`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.
```

### 2. `PhysicsSM/Draft/NullEdge/TetradSpinReconstructionBoundary.lean` [eta4]

Score: `0.781`

```text
def eta4 : Matrix (Fin 4) (Fin 4) ℚ :=
  !![1, 0, 0, 0;
     0, -1, 0, 0;
     0, 0, -1, 0;
     0, 0, 0, -1]

/-- A nonidentity rational boost in the first spatial direction. -/
```

### 3. `PhysicsSM/Draft/NullEdge/Carrier/GWRetardedTransfer.lean` [gamma5_hermiticity]

Score: `0.773`

```text
where `P` is the spatial reflection `x ↦ -x` and `Z`
is `σ_z` at each site (chirality = ±1).  The two building blocks are:

* `Gr * S * Gr = S⁻¹` (reflection reverses the shift direction);
* `Gr * Cm * Gr = Cm⁻¹` (`σ_z` conjugation sends the rotation angle `θ ↦ -θ`).

Neither uses `c² + s² = 1`; the Pythagorean identity is needed only to certify
that the explicit `T⁻¹` really is the inverse (`T * T⁻¹ = 1`). -/

open Matrix

/-- Carrier of the concrete model: 4 spatial sites × 2 chirality components. -/
```

### 4. `AgentTasks/g2-fixing-e111-determinant-phase-aristotle-2026-06-01.md` [Aristotle task: G2 fixing-e111 determinant phase package]

Score: `0.766`

```text
# Aristotle task: G2 fixing-e111 determinant phase package

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `db1958a9-b01e-4ff7-a79e-24544bd72626`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave6-20260601-project`
**Output**: `AgentTasks/aristotle-output/g2-fixing-e111-determinant-phase-20260601`
**Integrated**: 2026-06-01
**Type**: Baez octonion-to-C3 determinant API
```

### 5. `PhysicsSM/Draft/E8CartanNoNative.lean`

Score: `0.765`

```text
namespace PhysicsSM.Draft.E8CartanNoNative

set_option maxRecDepth 4000

/-- The E8 Cartan matrix.  Diagonal entries are `2`; the off-diagonal `-1` entries encode the
E8 Dynkin diagram (a chain `1-2-3-4-5-6-7` with an extra node `8` attached to node `5`, i.e.
the `T₁,₂,₄` tree).  Its determinant is `1`. -/
```

### 6. `AgentTasks/g2-fixing-e111-composition-det-hom-aristotle-2026-06-01.md` [Aristotle task: G2 fixing-e111 composition and determinant homomorphism]

Score: `0.764`

```text
# Aristotle task: G2 fixing-e111 composition and determinant homomorphism

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `8cee4e53-4f7a-4f49-80a9-edafadd9b31c`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave7-20260601-project`
**Output**: `AgentTasks/aristotle-output/g2-fixing-e111-composition-det-hom-20260601`
**Integrated**: 2026-06-01
**Type**: Baez octonion-to-C3 functoriality API
```

### 7. `PhysicsSM/Draft/E8CartanNoNative.lean` [E8Cartan]

Score: `0.764`

```text
def E8Cartan : Matrix (Fin 8) (Fin 8) ℤ :=
  !![ 2,-1, 0, 0, 0, 0, 0, 0;
     -1, 2,-1, 0, 0, 0, 0, 0;
      0,-1, 2,-1, 0, 0, 0, 0;
      0, 0,-1, 2,-1, 0, 0, 0;
      0, 0, 0,-1, 2,-1, 0,-1;
      0, 0, 0, 0,-1, 2,-1, 0;
      0, 0, 0, 0, 0,-1, 2, 0;
      0, 0, 0, 0,-1, 0, 0, 2]

/-- Unit lower-triangular factor of the rational `LU` decomposition of `E8Cartan`. -/
```

### 8. `Sources/CodeLatticeE8_Remaining_Migration_Handoff.md` [4. Local Cartan Bridge]

Score: `0.763`

```text
### 4. Local Cartan Bridge

Status: promoted and imported by the clean root.

Current file:

```text
CodeLatticeE8/E8/CartanBridge.lean
```

Optional split if the file grows:

```text
CodeLatticeE8/E8/Cartan.lean
CodeLatticeE8/E8/CartanBridge.lean
```

Likely source files:

```text
PhysicsSM/Coding/E8SpherePackingShape.lean
PhysicsSM/Coding/E8SpherePackingMatrixBridge.lean
PhysicsSM/Draft/E8TransitionMatrixNoNativeAristotle.lean
```

Current public declarations include:

- `e8CartanMatrix`;
- `e8CartanMatrix_det`;
- `e8BasisChangeMatrix`;
- `gramCartan_congruence`;
- `e8BasisChangeMatrix_det_sq`;
- `e8BasisChangeMatrix_isUnit`;
- `e8SimpleRoots`;
- `e8SimpleRoots_mem`;
- `e8SimpleRoots_gram`;
- `e8SimpleRoots_sqNorm`.

Guidance:

- If the clean package needs only an explicit matrix comparison, define the
  Cartan matrix locally in `CodeLatticeE8.E8`.
- If the existing proof imports broad `PhysicsSM.Lie.Exceptional.*` modules,
  do not carry that dependency into the clean root.  Recreate the small matrix
  facts locally.
- If there is a direct comparison with SPL's `E8Matrix`, put that in
  `CodeLatticeE8SPL`, not in `CodeLatticeE8`.
- Avoid huge determinant evaluation.  Use structured matrix proof patterns
  analogous to `E8/Determinant.lean`.
- Current trust note: `gramCartan_congruence`, `e8SimpleRoots_gram`, and
  `e8CartanMatrix_det` avoid `native_decide`.  The Cartan determinant is proved
  by nested cofactor expansion to four 6-by-6 kernel `decide` checks.
```

## Scoped paper hits

### 1. Connections on non-abelian Gerbes and their Holonomy

Score: `0.744`
URL: http://arxiv.org/abs/0808.1923

### 2. Superconnections and the Chern character

Score: `0.742`
Zotero key: `WNATKBT5`
DOI: `10.1016/0040-9383(85)90047-3`
URL: https://doi.org/10.1016/0040-9383(85)90047-3

### 3. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.738`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 4. On the definition of spacetimes in Noncommutative Geometry, part II

Score: `0.734`
Zotero key: `RADF3RUP`
arXiv: `1611.07842`
DOI: `10.48550/arXiv.1611.07842`
URL: https://arxiv.org/abs/1611.07842

Abstract:

Defines spectral spacetimes with time-orientation forms, stable causality, finite graph examples, split Dirac structures, and Lorentzian discretized Dirac operators.

### 5. Temporal Lorentzian Spectral Triples

Score: `0.733`
Zotero key: `JKDD4KGC`
arXiv: `1210.6575`
DOI: `10.48550/arXiv.1210.6575`
URL: https://arxiv.org/abs/1210.6575

Abstract:

Introduces temporal Lorentzian spectral triples, corresponding to a 3+1 decomposition and global time structure for noncommutative Lorentzian spaces.
