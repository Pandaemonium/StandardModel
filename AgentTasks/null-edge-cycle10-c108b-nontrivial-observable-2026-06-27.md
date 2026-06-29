# Active 30-cycle run: cycle 10 C108b nontrivial observable component

Date: 2026-06-27

## Summary

Cycle 10 found C107c, C111, and C108 still running, refreshed literature on the
origin/projector failure mode, and submitted C108b as the constructive
contrapositive to C108.

## C108b submitted

Project:

```text
9686beef-8138-4c7d-9e11-03792420c27f
```

Task:

```text
e9f9f04d-1875-4028-93f0-f773a2ba88c1
```

Target:

```text
AgentTasks/aristotle-standalone/c108b-nontrivial-branch-observable-20260627/C108bNontrivialBranchObservable/NontrivialBranchObservable.lean
```

Purpose:

- Prove that if some polynomial selector `p(B)` has nonzero chiral trace, then
  the branch observable `B` has a nonzero `J`-odd component.

Claude review:

```text
AgentTasks/model-calls/claude/2026-06-27-155511-cycle10-c108b-nontrivial-observable-review.md
```

Verdict:

- Accept with caveats.
- The theorem is true as stated.
- Factor reusable even/odd decomposition lemmas later.
- Rename "projector" in the commuting-matrix zero-trace helper or add
  idempotence if that name is retained.

## Other active jobs

```text
C107c:
  project e5b6e8b5-3277-40fb-8cb8-c674d6d4994c
  status in_progress

C111:
  project 212cd6b6-7c6a-4817-a513-3b7b3f1cfb4d
  status in_progress

C108:
  project efd86260-78ff-4278-888d-03eff60216eb
  status in_progress
```

## Literature search

Query/source:

```text
neo4j_paper_search.py --chunks --query
"chiral projector trace zero balance symmetry anticommutes chirality polynomial observable lattice fermion"
```

Useful hits:

- Dirac-Kahler chiral/flavour projection chunks are relevant as a projection
  comparison class.
- Luescher/Ginsparg-Wilson chunks reinforce exact chiral symmetry and measure
  obligations.
- Minimal-doubling and point-splitting chunks reinforce the no-go/branch
  pressure.
- Octonion internal-space projection chunks are relevant later for internal
  projector comparisons, not for external Gate C1 release.

Plan impact:

- No strategy change. C108b is a useful finite obstruction/necessity theorem:
  a successful origin branch observable must not be purely balance-even.
