# Aristotle semantic context pack

Generated: 2026-07-12T22:59:12
Query: `arbitrary qubit density matrix fixed sigmaX expectation unique von Neumann entropy Gibbs optimizer pairBloch surjective`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/dyn-modular-qubit-fixed-energy-maxentropy-aristotle-2026-07-12.md` [Semantic gates]

Score: `0.850`

```text
## Semantic gates

- `pairBloch_sigmaX_expectation` makes the energy constraint operational.
- `pairEntropy_eq_fixedEnergy_iff` is the decisive uniqueness theorem.
- `transverse_strict_control` prevents a commuting-only or equality-vacuous
  reading.
- The later live-tree integration must separately prove that `pairEntropy`
  equals the spectral von Neumann entropy and identify the optimizer with the
  normalized Gibbs state. Do not claim those bridges in this package.
```

### 2. `AgentTasks/dyn-modular-qubit-maxentropy-audit-aristotle-2026-07-12.md` [Aristotle audit: full-Bloch qubit maximum entropy target]

Score: `0.834`

```text
# Aristotle audit: full-Bloch qubit maximum entropy target
```

### 3. `AgentTasks/dyn-modular-qubit-fixed-energy-maxentropy-aristotle-2026-07-12.md` [Objective]

Score: `0.827`

```text
## Objective

Close the non-hollow two-level variational core of `DYN-MODULAR-001`: among
all Bloch-ball density matrices with a fixed expectation of the supplied pair
generator, the zero-transverse-coherence state uniquely maximizes entropy.

This is not a commuting-family theorem. The competitors range over all three
Bloch coordinates. It is still a finite supplied-generator result and does not
derive the Pluecker coupling, inverse temperature, or thermalization law.
```

### 4. `PhysicsSM/Draft/NullEdgeCelestialMixednessAristotle.lean` [blochPurity]

Score: `0.824`

```text
def blochPurity (r : BlochVector) : Real :=
  (Matrix.trace (blochDensity r * blochDensity r)).re

/-- Normalized qubit linear entropy: `2 * (1 - tr(rho^2))`. -/
```

### 5. `AgentTasks/dyn-modular-qubit-fixed-energy-maxentropy-aristotle-2026-07-12.md` [Aristotle task: qubit fixed-energy maximum entropy]

Score: `0.822`

```text
# Aristotle task: qubit fixed-energy maximum entropy
```

### 6. `PhysicsSM/Draft/NullEdgeCelestialMixednessAristotle.lean` [blochDensity_purity_eq_radius_sq]

Score: `0.801`

```text
theorem blochDensity_purity_eq_radius_sq (r : BlochVector) :
    blochPurity r = (1 + dot3 r r) / 2 := by
  unfold blochPurity
  rw [blochDensity_trace_square_eq_radius_sq, Complex.ofReal_re]

/--
For a qubit Bloch density, normalized linear entropy is exactly `4 det`.
This is the finite "mass as visible mixedness" identity.
-/
```

### 7. `AgentTasks/dyn-modular-qubit-fixed-energy-maxentropy-aristotle-2026-07-12.md` [Status]

Score: `0.794`

```text
## Status

Local strengthened statement typecheck passed with exactly ten intended proof
holes. After submission, Codex used `continue --mode instruct` to add the exact
`pairBloch_surjective`, `pairBloch_posSemidef`, and
`pairBloch_posSemidef_iff` bridges to Aristotle's copy; these prevent a hidden
nonexhaustive-family, non-density-matrix, or one-way-ball reading.
Focused submission package:
`AgentTasks/aristotle-submit/qubit-fixed-energy-maxentropy-20260712-project`.
Project metadata will be appended after submission.

```yaml
aristotle:
  project_id: 4ef06d09-a371-46bb-a6b5-ffdcf05aba75
  task_id: d7dda3e2-7bd5-4ac5-991e-849b1452113d
  target_file: QubitFixedEnergyMaxEntropy.lean
  expected_module: QubitFixedEnergyMaxEntropy
  submission_project: AgentTasks/aristotle-submit/qubit-fixed-energy-maxentropy-20260712-project
  output_dir: AgentTasks/aristotle-output/4ef06d09-a371-46bb-a6b5-ffdcf05aba75
  status: submitted
```
```

### 8. `PhysicsSM/Draft/NullEdgeCelestialMixednessAristotle.lean` [blochLinearEntropy]

Score: `0.793`

```text
def blochLinearEntropy (r : BlochVector) : Real :=
  2 * (1 - blochPurity r)

/-- Wrapper: the Bloch density is the coherent spin projector. -/
```

## Scoped paper hits

### 1. Von Neumann algebra automorphisms and time-thermodynamics relation in generally covariant quantum theories

Score: `0.770`
Zotero key: `I8XNBREW`
DOI: `10.1088/0264-9381/11/12/007`
URL: https://doi.org/10.1088/0264-9381/11/12/007

### 2. Equality conditions for the quantum f-relative entropy and generalized data processing inequalities

Score: `0.761`
Zotero key: `2IR54QB2`
DOI: `10.1109/isit.2010.5513655`
URL: https://doi.org/10.1109/isit.2010.5513655

Abstract:

Information-theoretic equality conditions for generalized data-processing inequalities; useful as a guardrail for Petz/recoverability claims.

### 3. Quantum Entropy and Special Relativity

Score: `0.751`
Zotero key: `QDUD2CDE`
DOI: `10.1103/physrevlett.88.230402`
URL: https://doi.org/10.1103/physrevlett.88.230402

### 4. Relative entropy and the Bekenstein bound

Score: `0.750`
Zotero key: `S9FTNNRU`
arXiv: `0804.2182`
DOI: `10.1088/0264-9381/25/20/205021`
URL: http://arxiv.org/abs/0804.2182

Abstract:

Recasts the Bekenstein bound as positivity of relative entropy between reduced states in a region.

### 5. Quantum conditional mutual information and approximate Markov chains

Score: `0.747`
Zotero key: `BHNTND4W`
arXiv: `1410.0664`
DOI: `10.1007/s00220-015-2466-x`
URL: http://arxiv.org/abs/1410.0664

Abstract:

Conditional mutual information quantifies how well a tripartite quantum state approximates a recoverable quantum Markov chain.
