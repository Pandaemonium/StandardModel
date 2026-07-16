# Aristotle semantic context pack

Generated: 2026-07-15T23:11:25
Query: `Poisson covariance decay for two-pivot smeared causal-set d Alembertian with global pivot selection, complete dependency, and kappa_N tending to zero`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/context-packs/causal-levi-civita-20260715-121444.md` [4. Local d'Alembertian for causal sets]

Score: `0.780`

```text
### 4. Local d'Alembertian for causal sets

Score: `0.730`
Zotero key: `I72KXVQA`
arXiv: `2506.18745`
```

### 2. `PhysicsSM/Draft/NullEdge/CARAnnihilationLocality.lean` [gamma_create_covariance_restrict]

Score: `0.778`

```text
theorem gamma_create_covariance_restrict
    (U : Matrix ι ι Complex) (R : ι -> ι -> Prop) [DecidableRel R]
    (i : ι) (psi : Fock ι)
    (hlocal : ∀ j, ¬ R j i -> U j i = 0) :
    Gamma U (create i psi) =
      ∑ j ∈ Finset.univ.filter (fun j => R j i),
        U j i • create j (Gamma U psi) := by
  rw [gamma_create_covariance]
  symm
  apply Finset.sum_subset (Finset.filter_subset _ _)
  intro j _ hj
  have hnot : ¬ R j i := by simpa using hj
  simp [hlocal j hnot]

/-- Annihilation covariance inherits the displayed row-support relation of the
one-particle matrix, with no coefficients outside that relation. -/
```

### 3. `AgentTasks/overnight-allmass-run-2026-07-09/harvest/lcov/0e24552b-045e-42a9-9f98-969f5fbc27d6_aristotle/ARISTOTLE_SUMMARY.md` [claude-lambda-two-region-covariance — summary]

Score: `0.774`

```text
# claude-lambda-two-region-covariance — summary

A finite, kernel-checked covariance model for the everpresent-Lambda dark-energy
fluctuation between two **nested** causal regions `R1 ⊆ R2`. All results live in
`RequestProject/Main.lean`, namespace `LambdaTwoRegionCovariance`.
```

### 4. `AgentTasks/overnight-allmass-run-2026-07-09/jobs/lambda-two-region-covariance.md` [claude-lambda-two-region-covariance — the finite covariance of Lambda between nested causal regions (observational distinguisher)]

Score: `0.773`

```text
# claude-lambda-two-region-covariance — the finite covariance of Lambda between nested causal regions (observational distinguisher)
```

### 5. `AgentTasks/overnight-publication-run-2026-07-11/GA_SYNC_DELTA.md` [4. Creation covariance (Codex, FiniteCARSecondQuantization)]

Score: `0.768`

```text
## 4. Creation covariance (Codex, FiniteCARSecondQuantization)

- "When one particle is not enough" says: "Full compatibility with adding a
  particle, probability preservation, and inherited spatial locality are
  the remaining gates." UPDATE: compatibility with adding a particle
  (creation covariance) is now proved; probability preservation and
  locality remain.
```

### 6. `PhysicsSM/Draft/NullEdgeDecoherenceChannelAristotle.lean` [decoheredSpinorPairMomentum_eq_twoEdgeMomentum]

Score: `0.768`

```text
theorem decoheredSpinorPairMomentum_eq_twoEdgeMomentum
    (psi phi : CSpinor) :
    decoheredSpinorPairMomentum psi phi = twoEdgeMomentum psi phi := by
  rfl

/-- Decohered two-alternative determinant mass is exactly Pluecker spread. -/
```

### 7. `PhysicsSM/Draft/NullEdge/CARAnnihilationLocality.lean`

Score: `0.768`

```text
import PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization

/-!
# Finite CAR covariance and inherited coefficient support

This module packages locality-shaped consequences of the determinant-minor
second quantization in `FiniteCARSecondQuantization`.

The first layer proves that occupation-basis creation and annihilation are
exact adjoints for the displayed finite Fock inner product. The support layer
starts with the creation half: when a one-particle matrix
coefficient vanishes outside a displayed relation `R`, creation covariance has
exactly the same relation-filtered support. This is a finite algebraic support
law. It is not a Lieb--Robinson estimate, a causal-cone theorem for interacting
observables, or a completed local quantum field theory.

Annihilation covariance and its relation-filtered support law are derived from
these adjoint identities in the successor layer.

Provenance: the two finite-sum reindexing proofs were returned by Aristotle
project `224621b8-d3ac-4a0b-be34-f4f32b09175e`, then adapted to the live
```

### 8. `AgentTasks/overnight-publication-run-2026-07-11/GRAND_STRATEGY5_REVIEW_2026-07-11.md` [1. Probability-weighted ranking of the next six theorem/composition jobs]

Score: `0.766`

```text
_descended_iff`. This is the scientific core; it is
the only job that can move F from "section" to "standalone". Blocker:
noncircular definition + relation-preservation is genuinely hard. Fallback: land
the **kill** direction (`no_descent_of_relation_witness` witness) as an honest
presentation-dependence certificate.

**Job 4 — Paper C guard + honest restatement (P≈0.85, value medium).** Shape:
add `#print axioms twoWall_protected_modes` guard (audit only, no math) and lock
manuscript prose to the demoted statement in §4. Blocker: none technical.
Consequence: prevents the letter/paper from over-claiming under hard audit.
Fallback: if guard cannot be added under freeze, embargo all "protected /
localized / 2 mod 4" language and cite only the eigenmode existence.

**Job 5 — Paper E annihilation covariance + filtered support (P≈0.6, value
medium).** Shape: mirror of `gamma_create_covariance_restrict` for
`annihilate`, then the relation-filtered corollary. Hypotheses: same `hlocal`.
Witness/control already exist for the creation side. Blocker: sign bookkeeping
(`opSign`) on the annihilation branch. Consequence: completes the CAR
covariance pair — necessary infrastructure for Job 6, still not novelty alone.
Fallback: ship creation side only, mark annihilation "in flight".

**Job 6 — Paper E Plücker-phase interaction discriminator composition (P≈0.4,
value high if it lands).** Shape: the covariance-compatible two-particle
observable of §6, invisible to one-particle dynamics. Blocker: needs Job 5 and a
genuine intertwining of `Gamma U` with `witnessPairKickLinearEquiv`.
Consequence: first E result exceeding standard second quantization. Fallback:
present as a preregistered composition target, not a theorem.

Ordering rationale: Jobs 1/2/4 are cheap and de-risk two papers; Job
```

## Scoped paper hits

### 1. Local d'Alembertian for causal sets

Score: `0.801`
Zotero key: `I72KXVQA`
arXiv: `2506.18745`

### 2. Space-time as a causal set

Score: `0.745`
Zotero key: `I8DJ26QC`
DOI: `10.1103/PhysRevLett.59.521`
URL: https://www.zotero.org/19894138/items/I8DJ26QC

### 3. Entanglement Entropy in Causal Set Theory

Score: `0.743`
Zotero key: `G2JGSV9B`
arXiv: `1611.10281`
DOI: `10.1088/1361-6382/aab06f`
URL: http://arxiv.org/abs/1611.10281

Abstract:

Studies causal-set entanglement entropy for causal diamonds and the role of Pauli-Jordan spectral truncation in obtaining area-law behavior.

### 4. Correction terms for propagators and d'Alembertians due to spacetime discreteness

Score: `0.741`
Zotero key: `arxiv:1411.2614`
arXiv: `1411.2614`
DOI: `10.1088/0264-9381/32/19/195020`
URL: http://arxiv.org/abs/1411.2614

Abstract:

Finite-sprinkling correction terms for causal-set retarded propagators and d'Alembertian operators compared with continuum limits.

### 5. Scalar Field Theory on a Causal Set in Histories Form

Score: `0.741`
Zotero key: `9RF2ESFQ`
arXiv: `1107.0698`
DOI: `10.1088/1742-6596/306/1/012017`
URL: https://www.zotero.org/19894138/items/9RF2ESFQ

Abstract:

Recasts into histories-based form a quantum field theory for a free scalar field on a background causal set. The resulting decoherence-functional resembles that of the continuum theory. The counterpart of the d'Alembertian operator is nonlocal and is a generalized inverse of the discrete retarded Green function. Comments on the significance and suggests how to include interactions.
