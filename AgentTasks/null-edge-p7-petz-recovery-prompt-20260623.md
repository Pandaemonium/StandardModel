# Aristotle focused job: classical Petz recovery and DPI saturation

```yaml
job_name: null-edge-p7-petz-recovery-20260623
status: integrated
project_id: 73c17dac-d779-4546-85c9-effd69048ed1
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p7-petz-recovery
prepared_project: AgentTasks/aristotle-submit/null-edge-p7-petz-recovery-project
target_module: NullEdgeP7PetzRecovery.Core
target_file: NullEdgeP7PetzRecovery/Core.lean
expected_check: lake env lean NullEdgeP7PetzRecovery/Core.lean
```

## Task

Prove the two remaining sorry proofs in `NullEdgeP7PetzRecovery/Core.lean` without changing the definitions or the theorem statements:

```lean
theorem petzMap_recovers_q {m n : Nat} (T : Fin m -> Fin n -> Real) (q : Fin n -> Real)
    (hTq : ∀ y, 0 < applyMap T q y) :
    applyMap (petzMap T q) (applyMap T q) = q := by

theorem kl_equality_of_petz_recovery {m n : Nat}
    (T : Fin m -> Fin n -> Real)
    (hnonneg : ∀ i j, 0 ≤ T i j)
    (hcol : ∀ j, Finset.univ.sum (fun i => T i j) = 1)
    (p q : Fin n -> Real)
    (hp : ∀ i, 0 ≤ p i) (hq : ∀ i, 0 < q i)
    (hTq : ∀ y, 0 < applyMap T q y)
    (hTpos : ∀ y, 0 < applyMap T p y)
    (h_recover_p : applyMap (petzMap T q) (applyMap T p) = p) :
    kl (applyMap T p) (applyMap T q) = kl p q := by
```

The first theorem establishes that the classical Petz map always perfectly recovers the reference state $q$. The second theorem proves that if the Petz map recovers $p$, then the relative entropy loss is zero (data-processing inequality is saturated).

## Constraints

- Do not weaken or rename any theorem.
- Do not change definitions.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP7PetzRecovery/Core.lean
```

## Completion report requested

Please end with a brief report listing:
- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.
