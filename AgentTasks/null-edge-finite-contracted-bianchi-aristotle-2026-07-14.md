# Null-edge finite contracted Bianchi: Aristotle construction and no-go audit

```yaml
aristotle:
  project_id: 69ca474f-6764-4bc2-80d8-1c334d399b14
  task_id: b5067ca8-2f4b-4b7c-95f0-f2292242a28b
  target_file: PhysicsSM/Draft/NullEdge/FiniteContractedBianchi.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteContractedBianchi
  submission_project: AgentTasks/aristotle-submit/null-edge-finite-contracted-bianchi-20260714-project
  output_dir: AgentTasks/aristotle-output/69ca474f-6764-4bc2-80d8-1c334d399b14
  status: harvested 2026-07-14; remote task canceled after semantic audit
```

## Context

The general-relativity reconstruction lane now has exact associative-ring
commutator and fixed-label Cartan Bianchi identities in:

```text
PhysicsSM/Draft/NullEdge/FiniteConnectionGeometry.lean
PhysicsSM/Draft/NullEdge/FiniteCartanBianchi.lean
```

It does not yet have a geometric differential Bianchi theorem for a Riemann
tensor or the contracted identity that makes the Einstein tensor divergence
free. The new conservation bridge in
`FiniteGravityConservation.lean` deliberately assumes its Bianchi premise, so
it does not close this gap.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-finite-contracted-bianchi-20260714-212608.md
```

Related reconstruction note:

```text
Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md
```

## Aristotle mission

Act as a Lean formalization designer, proof agent, and hostile differential-
geometric reviewer. Determine the smallest non-tautological component-level
theorem that derives a contracted Bianchi identity from an uncontracted
differential Bianchi identity.

1. Inspect the two existing finite Bianchi modules and preserve their
   convention boundary. Do not reinterpret their Jacobi identities as an
   already-contracted Riemannian theorem.

2. Prefer a finite-index orthonormal-frame model over a commutative field if
   that is the smallest sound layer. Define explicitly:

   - curvature components and derivative components;
   - all Riemann symmetries actually used;
   - the uncontracted differential Bianchi hypothesis;
   - metric-signature weights or a clearly stated orthonormal Euclidean
     specialization;
   - Ricci contraction, scalar contraction, and Einstein combination;
   - divergence or contracted derivative.

3. Lock the index order and signs in the module docstring. Derive, rather than
   assume under renamed predicates, the analogue of

   ```text
   div Ricci = (1/2) grad scalar
   div Einstein = 0.
   ```

4. Anti-tautology requirement: the result must use an uncontracted Bianchi
   premise and explicit finite sums/contractions. A theorem that assumes
   `divRicci = halfGradScalar`, or unfolds a definition manufactured to be
   zero, is not acceptable.

5. Add a concrete nonzero finite curvature/derivative witness if feasible, or
   explain precisely why a useful nonvacuity witness requires a lattice,
   connection, or position dependence not present in the component layer.

6. If the theorem is sound and manageable, create
   `PhysicsSM/Draft/NullEdge/FiniteContractedBianchi.lean`, prove it without
   proof escape hatches, add build-enforced assumption-footprint guards, and
   run its narrow Lean command. If the target is false or underspecified,
   create no misleading theorem; return a convention-explicit no-go and the
   minimum corrected statement.

7. Explain what still separates this component theorem from the null-edge
   complex: reconstructed metric/coframe, metric-compatible derivative,
   curvature convergence, local labels, and the continuum limit.

## Required report

Return exact definitions and theorem statements, index and signature
conventions, the narrow command and result, assumption footprints, witness or
nonvacuity analysis, and the remaining geometric reconstruction debt. State
explicitly whether a new target file was created.

## Live status notes

- **2026-07-14, parallel local construction:** the live target file now exists
  and passes its narrow Lean check. It defines explicit finite contractions and
  proves `once_contracted_bianchi`, `contracted_bianchi`, `divEinstein_eq`, and
  `divEinstein_eq_zero` from first/last curvature-pair antisymmetry and the
  uncontracted differential Bianchi premise. A nonzero `1+1`
  Lorentz-signature witness `q_e * epsilon_ab * epsilon_cd` satisfies every
  premise, has `divRic = -1` and `gradScalar = -2`, and satisfies the
  divergence-free conclusion. Assumption-footprint guards are active. The
  Aristotle job remains an independent convention, anti-tautology, and proof
  audit; its result must be compared with the live theorem rather than copied
  over it automatically.
- **2026-07-14, mode `instruct`:** sent Aristotle the exact live index order,
  differential Bianchi convention, Ricci contraction, signature condition,
  conclusions, and nonzero area-form witness. Asked for an independent
  sign/counterexample/anti-tautology audit rather than automatic agreement.
- **2026-07-14, 38-minute downloadable snapshot:** the remote worker had
  drafted an alternate Euclidean component API, but its three contraction
  theorems and proposed nonzero witness still had unfinished proof bodies. It
  also discarded the live Lorentz-signature weights, so this snapshot is not
  integration-ready and was not copied into the repository.
- **2026-07-14, mode `ask`:** requested only an adversarial verdict on the live
  weighted contraction, signs, necessary symmetries, and
  \(q_e\epsilon_{ab}\epsilon_{cd}\) witness. The waiting client timed out
  without a synchronous response.
- **2026-07-14, asynchronous audit answer:** Aristotle independently reported
  no sign error, missing curvature symmetry, counterexample, or vacuity defect.
  It checked that the weighted Bianchi contraction gives a second copy of
  `divRic`, that the scalar term enters with the required minus sign, and that
  \(w_d^2=1\) reduces the metric contribution to the scalar gradient. It also
  confirmed that pair-exchange symmetry and the algebraic first Bianchi
  identity are not needed. For the witness, it reduced differential Bianchi to
  the alternating two-dimensional identity
  \(q_e\epsilon_{cd}+q_c\epsilon_{de}+q_d\epsilon_{ec}=0\), confirming
  nonvacuity while retaining the pointwise derivative-jet caveat.
- **2026-07-14, final mode `instruct`:** told the worker to preserve that audit
  verdict, stop retrying the broad failed project build, and package
  immediately. The alternate remote proof skeleton remains unintegrated; the
  complete live weighted theorem is the accepted implementation.
- **2026-07-14, disposition:** the remote task remained active after its failed
  build/commit attempt even though the requested semantic answer had been
  returned. Canceled it to release Aristotle capacity. The audit verdict is
  harvested above; its unfinished alternate Euclidean skeleton was rejected.
