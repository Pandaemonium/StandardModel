# Educator brief - "The boundary defect you cannot rub out" (HalfSpaceDefectIndex)

- Model/role: claude / Educator (solo mode, active=claude)
- Result explained: `PhysicsSM/Draft/NullEdge/HalfSpaceDefectIndex.lean`
  (landed, twice independently reviewed 2026-07-13, guard-pinned).
- Contract: one result, accessible explanation + evidence-grade map + visual plan
  + analogy boundaries + formal anchors.

## 1. The idea in plain language

Imagine an infinite line of boxes, `0, 1, 2, ...`, and a machine whose only move
is "shift everything one box to the right." On a truly infinite line this move is
reversible. But a *half*-line has an edge: box `0` has nothing to its left. So
after the shift, box `0` is left empty in a way that can never be undone from
inside the system. That leftover is a **boundary defect**.

Now the subtle part. If you (secretly) also put a far wall at box `N` and add up
the defect over the *whole* finite line, it sums to **zero** - the machine looks
perfectly balanced. The `+1` puzzle at the source box `0` is exactly cancelled by
a `-1` that has been quietly pushed all the way out to the far wall `N`. The
lesson: **the total looks trivial, but the defect is still there - it has just
fled to the far boundary.**

The theorem makes this precise and, crucially, *stable*: if you look only at a
fixed window near box `0`, you always measure exactly `+1`, no matter how far away
you put the wall. Push the wall to `N = 100`, `N = 10^6`, it does not matter - the
near-edge window keeps reading `+1`. The compensating `-1` runs off to infinity
and never comes back to your window.

This is the finite, kernel-checked fingerprint of a famous idea in physics and
math: the **index of the shift operator** - a whole number that counts an
irremovable mismatch between "what can be shifted in" and "what can be shifted
out" at a boundary. Same phenomenon behind why certain edge states in materials
cannot be removed by any local tinkering.

## 2. Why it matters here (one sentence)

For our flagship question - can a finite "null" automaton host a *single* chiral
particle at its edge without the usual doubling? - this is the abstract mechanism
that a boundary can carry a stable, unremovable `+1` while the bulk stays balanced.
It is a *precursor*, not the finished answer (see boundaries).

## 3. Evidence-grade map

| Claim (as a reader hears it) | What is actually proved | Grade |
| --- | --- | --- |
| "There is a boundary defect" | `localized_source_defect`: the commutator `SᴴS - SSᴴ` is `+1` at site 0, `-1` at site `N` | M (kernel, draft-trust) |
| "The total is trivially zero" | `global_defect_trace_zero`: its trace is `0` on any finite square | M |
| "The near-edge value is stable" | `localized_window_trace_stabilizes`: fixed window reads `+1` for every cutoff `N > K` | M (this is the load-bearing one) |
| "Defects add up across channels" | `stabilizedIndex_additive`: index of `m` channels is `m x` one channel | M |
| "Orientation flips the sign" | `stabilizedIndex_add_reversed_eq_zero`: right + left shift index `= 0` | M |
| "A defect-free control exists" | `permMatrix_no_defect`: a bilateral permutation has zero defect | M (negative control) |

All carry `#guard_msgs` axiom pins at the standard three `[propext,
Classical.choice, Quot.sound]`. Grade `M` = machine-verified, program-internal
(draft-trust); no `T` (source-theorem) or physical claim is asserted.

## 4. Visual plan (one figure, three panels, shared across audience levels)

- **Panel A (the move):** a row of boxes `0..N`; an arrow shifts tokens right;
  box 0 ends empty (a small `+1` badge), box `N` ends with a `-1` badge.
- **Panel B (the balance illusion):** the same row with a running sum meter under
  it reading `0` - captioned "add up everything and it cancels."
- **Panel C (the stable window):** a dashed box around sites `0..K`; three copies
  at `N=8, 100, 10^6`, each with the window meter reading `+1` - captioned "look
  only near the edge and the defect never leaves."
- Undergraduate overlay: label `SᴴS` (can-shift-in) vs `SSᴴ` (can-shift-out) as
  the two diagonal projectors whose difference is the badge pattern.
- Researcher overlay: annotate Panel C as "the finite truncation of `ind(S) =
  dim ker S - dim ker Sᴴ = -1`; window-stability = locality of the index density."

## 5. Analogy boundaries (where the story must stop)

- The "index" here is a **finite-matrix precursor**, NOT the genuine Fredholm
  index of an operator on infinite `l^2(N)`. The module says so explicitly ("No
  bulk-boundary / bulk-edge correspondence is claimed"). The honest gap: the true
  index needs the infinite space + Mathlib API our pinned toolchain does not yet
  supply.
- "Edge state that cannot be removed" is an **analogy** to topological edge modes,
  not a proof of one. No band structure, no Chern number, no physical material is
  claimed.
- This is the **abstract unilateral shift**, not yet the HNU null-walk. Connecting
  this `+1` to an actual HNU boundary mode with a gapped interior is the open
  flagship step (my Gate-1 refinement, ledgered 2026-07-13).
- "Balance" (trace zero) is a statement about a **finite** truncation; it is the
  reason a naive global count misses the defect, not evidence the physics is
  trivial.

## 6. Formal anchors (for the reader who wants the kernel)

- Definition: `unilateral (N) : Matrix (Fin (N+1)) (Fin (N+1)) Rat` - the
  truncated right shift.
- `HalfSpaceDefectIndex.localized_source_defect` (site-0 `+1`, site-`N` `-1`).
- `HalfSpaceDefectIndex.global_defect_trace_zero` (trace cancels).
- `HalfSpaceDefectIndex.localized_window_trace_stabilizes` (window `= +1`, all
  `N > K`) - the theorem that makes the "defect never leaves" claim precise.
- `HalfSpaceDefectIndex.stabilizedIndex_additive`,
  `stabilizedIndex_add_reversed_eq_zero`, `permMatrix_no_defect` (controls).
- Provenance: Aristotle jobs `e61eeec5` (single channel) + `a279c86d` (block
  additivity/orientation); independent Claude reviews 2026-07-13 (both ACCEPT).

## 7. Open-question label (Educator honesty tag)

This brief describes a **verified finite precursor**, not a physical edge-mode
theorem. The reader should carry away: "we proved the *arithmetic skeleton* of an
unremovable boundary index; whether the null automaton's edge actually wears it -
with a quiet interior - is still being tested." That is the flagship's live gate,
not a settled result.
