# Aristotle semantic context pack

Generated: 2026-07-10T03:02:00
Query: `Pluecker mass harmonic oscillator discrete step exact energy conservation action Hessian`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgeSuperDiracKreinCore.lean` [massShellJ_kreinSelfAdjoint_of_selfAdjoint]

Score: `0.799`

```text
theorem massShellJ_kreinSelfAdjoint_of_selfAdjoint
    (D : Matrix Idx Idx Complex) (m : Complex)
    (hD : D.conjTranspose = D) :
    IsKreinSelfAdjoint (massShellJ D m) D := by
  unfold IsKreinSelfAdjoint massShellJ
  rw [hD]
  rw [Matrix.smul_mul, Matrix.mul_smul]

/-- The mass-shell constraint equates the kinetic Pluecker symbol and the
internal Yukawa mass square.  This deliberately records equality, not an
additive contribution to the square. -/
```

### 2. `AgentTasks/aristotle-downloads-wave12-13-20260626/fur-h6-dvt-jordan-yukawa-constraint-audit/fur-h6-dvt-jordan-yukawa-constraint-audit_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [Double-counting risk]

Score: `0.793`

```text
### Double-counting risk

Risk: Pluecker mass is added to `Phi_H^2` as a second mass source.

Guardrail:

```text
Pluecker/null spread = kinetic symbol invariant.
Phi_H^2              = zero-order internal mass block.
On shell: K_h(xi) = eigenvalue(Phi_H^2).
```
```

### 3. `AgentTasks/aristotle-downloads-wave12-13-20260626/c58-projected-branch-weyl-projector/c58-projected-branch-weyl-projector_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [Double-counting risk]

Score: `0.792`

```text
### Double-counting risk

Risk: Pluecker mass is added to `Phi_H^2` as a second mass source.

Guardrail:

```text
Pluecker/null spread = kinetic symbol invariant.
Phi_H^2              = zero-order internal mass block.
On shell: K_h(xi) = eigenvalue(Phi_H^2).
```
```

### 4. `AgentTasks/aristotle-downloads-wave12-13-20260626/c60-species-split-nodal-line-lift/c60-species-split-nodal-line-lift_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [Double-counting risk]

Score: `0.792`

```text
### Double-counting risk

Risk: Pluecker mass is added to `Phi_H^2` as a second mass source.

Guardrail:

```text
Pluecker/null spread = kinetic symbol invariant.
Phi_H^2              = zero-order internal mass block.
On shell: K_h(xi) = eigenvalue(Phi_H^2).
```
```

### 5. `AgentTasks/aristotle-downloads-wave12-13-20260626/c61-gauge-covariant-link-dressed-projectors/c61-gauge-covariant-link-dressed-projectors_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [Double-counting risk]

Score: `0.792`

```text
### Double-counting risk

Risk: Pluecker mass is added to `Phi_H^2` as a second mass source.

Guardrail:

```text
Pluecker/null spread = kinetic symbol invariant.
Phi_H^2              = zero-order internal mass block.
On shell: K_h(xi) = eigenvalue(Phi_H^2).
```
```

### 6. `AgentTasks/aristotle-downloads-wave12-13-20260626/c62-composite-interpolating-zero-escape/c62-composite-interpolating-zero-escape_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [Double-counting risk]

Score: `0.792`

```text
### Double-counting risk

Risk: Pluecker mass is added to `Phi_H^2` as a second mass source.

Guardrail:

```text
Pluecker/null spread = kinetic symbol invariant.
Phi_H^2              = zero-order internal mass block.
On shell: K_h(xi) = eigenvalue(Phi_H^2).
```
```

### 7. `AgentTasks/aristotle-downloads-wave12-13-20260626/c59-post-c21-projected-release-criterion/c59-post-c21-projected-release-criterion_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [Double-counting risk]

Score: `0.792`

```text
### Double-counting risk

Risk: Pluecker mass is added to `Phi_H^2` as a second mass source.

Guardrail:

```text
Pluecker/null spread = kinetic symbol invariant.
Phi_H^2              = zero-order internal mass block.
On shell: K_h(xi) = eigenvalue(Phi_H^2).
```
```

### 8. `Sources/Archive/Null_Edge_Unified_Mass_Model_Working_Plan_Longform_2026-06-27.md` [Double-counting risk]

Score: `0.792`

```text
### Double-counting risk

Risk: Pluecker mass is added to `Phi_H^2` as a second mass source.

Guardrail:

```text
Pluecker/null spread = kinetic symbol invariant.
Phi_H^2              = zero-order internal mass block.
On shell: K_h(xi) = eigenvalue(Phi_H^2).
```
```

## Scoped paper hits

### 1. The Spectral Action Principle

Score: `0.763`
Zotero key: `6WURA7MF`
DOI: `10.1007/s002200050126`
URL: https://doi.org/10.1007/s002200050126

### 2. Finite-Difference Approach to the Hodge Theory of Harmonic Forms

Score: `0.744`
Zotero key: `TSAQXS9N`
DOI: `10.2307/2373615`
URL: https://doi.org/10.2307/2373615

### 3. Combinatorial and Hodge Laplacians: Similarities and Differences

Score: `0.734`
Zotero key: `9RE64BCV`
DOI: `10.1137/22M1482299`
URL: https://doi.org/10.1137/22M1482299

### 4. Finite element exterior calculus: from Hodge theory to numerical stability

Score: `0.718`
Zotero key: `8JFSI9CS`
DOI: `10.1090/s0273-0979-10-01278-4`
URL: https://doi.org/10.1090/s0273-0979-10-01278-4

### 5. Modular Hamiltonians for Deformed Half-Spaces and the Averaged Null Energy Condition

Score: `0.714`
Zotero key: `B68T629C`
arXiv: `1605.08072`
DOI: `10.1007/JHEP09(2016)038`
URL: http://arxiv.org/abs/1605.08072

Abstract:

Derives a modular Hamiltonian term for deformed half-spaces and uses relative-entropy monotonicity to prove ANEC.
