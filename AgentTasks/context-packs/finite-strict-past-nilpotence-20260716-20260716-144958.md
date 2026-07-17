# Aristotle semantic context pack

Generated: 2026-07-16T14:50:40
Query: `A weighted past operator on a finite transitive irreflexive causal relation is nilpotent with power bounded by event cardinality`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout.lean` [subdiamondLocalIntervalAbundance]

Score: `0.792`

```text
def subdiamondLocalIntervalAbundance (R : V -> V -> Prop) [DecidableRel R]
    (x y u v : V) (k : Nat) : Nat := by
  classical
  exact (Finset.univ.filter fun p : Prod V V =>
    inClosedDiamond R u v p.1 /\
    inClosedDiamond R u v p.2 /\
    localIntervalCard R x y p.1 p.2 = k).card

/-- Transitivity predicate for the finite causal relation. -/
```

### 2. `AgentTasks/aristotle-p9-sj-reference-state-report.md` [1.1 Vertex set and preorder]

Score: `0.785`

```text
### 1.1 Vertex set and preorder

Fix `n : ℕ` and take the **vertex set** `V := Fin n`. The diamond's causal
structure is a **preorder** `≼` (reflexive + transitive) given as a Boolean
relation, encoded as a 0/1 matrix so it can also be read as a matrix over `ℝ`.

```lean
variable (n : ℕ)
abbrev V := Fin n

/-- Causal relation as a decidable relation. `prec x y` means `x ≼ y`
    (`x` is in the causal past of `y`, including `x = y`). -/
structure FinCauset (n : ℕ) where
  prec : Fin n → Fin n → Prop
  decPrec : DecidableRel prec
  refl  : ∀ x, prec x x
  trans : ∀ x y z, prec x y → prec y z → prec x z
  antisymm : ∀ x y, prec x y → prec y x → x = y   -- partial order (acyclic causet)
```

`antisymm` is the causal-set acyclicity condition (no closed causal loops); it
makes `≼` a genuine partial order. The *strict* relation `x ≺ y := prec x y ∧ x ≠ y`
is the irreflexive causal order used for link/relation counting, matching the
`p.1 < p.2` counting style already in `NullEdgeCausetOrderingFraction.lean`.
```

### 3. `AgentTasks/null-edge-p9-retarded-nilpotent-reach-aristotle-2026-06-23.md` [Task]

Score: `0.777`

```text
## Task

Fill the four proof holes in `NullEdgeP9RetardedNilpotentReach/Core.lean`
without changing definitions or theorem statements.

This is a finite retarded-support scaffold for P9. Causal-set response
operators can be retarded and nonlocal; on a finite acyclic diamond, however, a
support relation that strictly decreases a rank should have a finite propagation
horizon. The target is the corresponding finite theorem: beyond the rank
height, exact reach is empty and the iterated response kernel vanishes.
```

### 4. `AgentTasks/null-edge-finite-causal-order-operator-aristotle-2026-07-15.md` [Finite causal-order operator: Aristotle semantic audit]

Score: `0.775`

```text
# Finite causal-order operator: Aristotle semantic audit

```yaml
aristotle:
  project_id: ff45b96a-3412-44f2-b0b1-c8b8f179ce80
  task_id: 96f20f5a-4531-4558-a9cb-031fa2ca8873
  target_file: PhysicsSM/Draft/NullEdge/FiniteCausalOrderOperator.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator
  submission_project: AgentTasks/aristotle-submit/finite-causal-order-operator-20260715-project
  output_dir: AgentTasks/aristotle-output/ff45b96a-3412-44f2-b0b1-c8b8f179ce80
  status: completed and harvested 2026-07-15
```
```

### 5. `AgentTasks/overnight-allmass-run-2026-07-09/harvest/suiteAop2geom/claude-suiteA-op2geom-20260709_aristotle/STRATEGY_PROMPT.md` [Kills (state as theorems)]

Score: `0.774`

```text
## Kills (state as theorems)

- The causal spectral distance degenerates (identically `0`, `+inf`, or
  independent of `m`) — operator does NOT recover scale.
- The recovered relation is not a partial order (fails antisymmetry/transitivity)
  — operator does NOT recover causal order.
```

### 6. `AgentTasks/aristotle-standalone/claude-suiteA-op2geom-20260709/STRATEGY_PROMPT.md` [Kills (state as theorems)]

Score: `0.774`

```text
## Kills (state as theorems)

- The causal spectral distance degenerates (identically `0`, `+inf`, or
  independent of `m`) — operator does NOT recover scale.
- The recovered relation is not a partial order (fails antisymmetry/transitivity)
  — operator does NOT recover causal order.
```

### 7. `PhysicsSM/Draft/NullEdgeP9RetardedNilpotentReach.lean`

Score: `0.772`

```text
import Mathlib.Tactic

/-!
# P9 retarded nilpotent reach scaffold

This draft module records a finite retarded-support theorem for the P9
source-visibility route.

If a response kernel is supported on a finite relation that strictly decreases
a rank function, then exact propagation has a finite horizon: after more steps
than the available rank height, no point is reachable and the iterated response
kernel vanishes.

This is a discrete-first theorem. It does not require a microscopic continuum
interpretation; it supplies a finite acyclic-retarded guardrail for later
causal-diamond response models.
-/
```

### 8. `AgentTasks/null-edge-codex-overnight-run-ledger-2026-06-23.md` [Submitted P9 retarded nilpotent reach job]

Score: `0.768`

```text
## Submitted P9 retarded nilpotent reach job

Submitted Aristotle project:

- `dd4fb31d-a4d4-4d1e-a565-510c57aafe3a`
  `null-edge-p9-retarded-nilpotent-reach-20260623`

Task:

- `a24c6395-edc0-44dc-bd1e-71a8a9b95213`

Staged source:

- `AgentTasks/aristotle-standalone/null-edge-p9-retarded-nilpotent-reach-20260623/NullEdgeP9RetardedNilpotentReach/Core.lean`

Task note:

- `AgentTasks/null-edge-p9-retarded-nilpotent-reach-aristotle-2026-06-23.md`

Targets:

- `applyKernel_vanishes_off_reach`
- `iterateApply_supported_in_exact_reach`
- `no_reach_beyond_rank`
- `iterateApply_eq_zero_beyond_rank`

Scientific role: this job turns the causal-set retarded/nonlocal response
literature into a finite theorem target. If a support relation strictly
decreases a rank on a finite diamond, exact reach is empty beyond the rank
height and iterated response kernels vanish. This would give P9 a clean finite
retarded-horizon theorem, independent of any fine-grained continuum limit.

Preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-retarded-nilpotent-reach-20260623/NullEdgeP9RetardedNilpotentReach/Core.lean
rg -n "^\s*sorry\b|^\s*admit\b|\baxiom\b|\bopaque\b|\bunsafe\b|\bnative_decide\b" AgentTasks/aristotle-standalone/null-edge-p9-retarded-nilpotent-reach-20260623/NullEdgeP9RetardedNilpotentReach/Core.lean
rg -n "[^\x00-\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-retarded-nilpotent-reach-20260623/NullEdgeP9RetardedNilpotentReach/Core.lean
```

The Lean preflight found exactly the four intended proof-hole warnings and no
other errors; non-ASCII scan was clean. The focused package helper reported
four proof-hole lines, zero proof-escape tokens, and zero unsafe tokens.

Integrated module:

- `PhysicsSM.Draft.NullEdgeP9RetardedNilpotentReach`

Verification:
```

## Scoped paper hits

### 1. Local d'Alembertian for causal sets

Score: `0.739`
Zotero key: `I72KXVQA`
arXiv: `2506.18745`

### 2. Evolution in Quantum Causal Histories

Score: `0.733`
Zotero key: `KDEECE8M`
arXiv: `hep-th/0302111`
URL: http://arxiv.org/abs/hep-th/0302111

Abstract:

Defines quantum causal histories as locally finite causal pre-spacetime with matrix algebras at events and completely positive maps between causally related algebras. Important prior art for finite causal quantum processes.
