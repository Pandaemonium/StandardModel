# Aristotle audit job - K1 replacement theorem shape 2026-07-07 22:52 PDT

```yaml
aristotle:
  project_id: bb1d8672-7d45-44a5-8c29-b27da9977fa4
  task_id: 81d4e75e-3f74-44af-a5ba-3261a35de440
  target_file: PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion
  submission_project: none
  output_dir: AgentTasks/aristotle-output/pending
  status: harvested
```

Submitted with:

```powershell
aristotle submit (Get-Content -Raw ARISTOTLE_AUDIT_K1_REPLACEMENT_SHAPE_2026-07-07_2252.md)
```

## Harvested result

Status: complete. Aristotle could not inspect `PolymerKPConclusion.lean`, but
audited the supplied K1 STEP0 findings and theorem shape.

Key findings:

- Do both routes in sequence: first land the sound free-slot
  `(m_j - 1)!` replacement, then pursue the structured ordered-block route only
  if downstream KP bounds require the full `m_j!` factor.
- Keep the generic `fiber_card_mul_le_factorial` reducer unchanged; the bug is
  in the KP-specific fiber map, not in the abstract injection-to-permutation
  reducer.
- Replacement route: supply
  `Fib × Perm(Fin k) × (∀ j, Perm(Fin (m_j - 1))) ↪ Perm(Fin n)`.
- Full-factor route: use an ordered-set-partition/structured-block codomain
  before final encoding, without pinning the connection slot.
- Add the `n = 3`, one-block negative/positive toy case as an anti-regression
  test so the root-pinned flat encoder cannot be revived silently.

## Prompt

You are Aristotle, asked for a K1 theorem-shape audit after STEP0, not a full
proof attempt.

Context: Codex ran the required K1 STEP0 root-hygiene audit before any new KP
fixed-forest prover attempt. The result was that the live scaffold appears to
use total child-block sizes, while a root-pinned flat-word encoder cannot
justify the full `m_j!` factor. A structured ordered-block route may still
preserve the full factor.

Codex audit finding:

```text
In `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`:

- `childBlockOf T r j` is a Finset of deleted-root slots
  `{x : Fin n // x != r}`.
- `sum_childBlockOf_card` proves the child blocks sum to `n - 1`.
- `restrictCluster_childBlock_n_eq` proves
  `(restrictCluster ... (childBlockOf T r j).image ...).n =
  (childBlockOf T r j).card`.
- `perPair_absWeight_bound` uses `Nat.factorial (childBlockOf T r j).card`.
- `fiber_card_mul_le_factorial` uses arbitrary `m : Fin k -> Nat` and a
  supplied injection
  `Fib x Perm(Fin k) x (forall j, Perm(Fin (m j))) -> Perm(Fin n)`.

Therefore, in the live K1 scaffold, the natural `m_j` intended for child
clusters is total child-block size, including the root-child/connection slot
inside the deleted-root block. It is not already a free-slot count.
```

Oracle script summary:

```text
Small case: root=0, root_child=1, block=(1,2).
Total block permutations: 2.
Pinned-word image count: 1.
Structured image count: 2.
Conclusion: full `m_j!` is compatible with a structured-partition route, but not
with a word encoder that canonicalizes/pins the root-child inside the block.
```

First Aristotle K1 audit summary:

```text
The failure mode is encoder non-injectivity, not raw size of the inequality.
The minimal decisive toy case is one child block of total size `m_1 = 2`,
with `n = 3`; pinning the connection slot collapses two `Perm (Fin 2)` inputs
to the same word image.

If `m_j` counts total child-block size and the connection slot is pinned, the
least disruptive replacement is the injection with factors `(m_j - 1)!`.
A structured-block codomain remains the viable route for preserving full
`m_j!`.
```

Request:

1. Verdict first: should the next K1 Lean target be the free-slot factorial
   replacement, the structured ordered-block route, or both in sequence?
2. State the cleanest replacement theorem shape in Lean-ish terms, separating
   pure finite combinatorics from the Penrose/KP-specific fiber map.
3. If we keep the full `m_j!` factor, what exact structured codomain should
   replace the flat `Perm (Fin n)` word target before final encoding?
4. What minimal anti-regression test or oracle should remain in the repo so a
   future agent does not revive the root-pinned flat encoder?
5. Give a no-go sentence for the manuscript/task notes that downgrades the old
   flat parse attempt without downgrading the whole K1 program.

Return a concise audit memo with sections: verdict, theorem shape, codomain,
anti-regression, no-go wording.
