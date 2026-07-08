# K1-STEP0 root hygiene audit - 2026-07-07 22:55 PDT

Status: draft/oracle audit, not a Lean theorem.

## Question

Before a sixth KP fixed-forest prover attempt, the run plan requires checking
whether the current factorial target uses total child-block sizes or free
non-root slots after a root-child/connection slot is pinned.

## Lean evidence

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

## Probe

Script:

```text
Scripts/oracle/probe_kp_root_hygiene_v01.py
```

The script checks the smallest one-block case: root `0`, child block `{1,2}`,
root-child `1`.

Result:

- A word encoder that pins the root-child first inside the block collapses the
  two total-block permutations to one image.
- A structured codomain that retains the whole ordered child block keeps the
  two images distinct.

Interpretation:

- Full `m_j!` cannot be justified by a root-pinned word encoder that
  canonicalizes the root-child slot.
- Full `m_j!` is still plausible if K1 follows the SevenChallenges repair:
  factor through structured ordered partitions/blocks rather than parsing a
  flat canonicalized word.
- If a future proof insists on pinning the root-child inside each block, the
  local factorial should be `(m_j - 1)!` for that block's free slots, not
  `m_j!`.

## Recommended K1 next target

Do not submit another full `pairSum_le_expBound` proof attempt yet. The next
Lean target should be a small structured-partition counting lemma, separate
from the Penrose classification:

```text
root + canonically ordered block sets + block order permutations +
internal total-block permutations inject into structured ordered blocks,
then into Perm(Fin n)
```

Only after that should the program-specific fiber-to-structured-partition map be
attempted.

## Claim boundary

This audit does not prove or refute `pairSum_le_expBound`. It only establishes:

1. live `m_j` semantics are total child-block sizes;
2. the root-pinned flat-word encoder is insufficient for full `m_j!`;
3. the structured-partition route remains the viable way to preserve full
   `m_j!`.
