# Active 30-cycle run: cycle 9 C108 origin certificate

Date: 2026-06-27

## Summary

Cycle 9 found C107c and C111 still running, refreshed literature around finite
spectral/projector covariance, and submitted C108 as an independent origin
branch-observable rejection certificate.

## C108 submitted

Project:

```text
efd86260-78ff-4278-888d-03eff60216eb
```

Task:

```text
ced781b1-832c-4e7e-9732-625aa4047223
```

Target:

```text
AgentTasks/aristotle-standalone/c108-origin-branch-observable-certificate-20260627/C108OriginBranchObservable/ZeroIndexCertificate.lean
```

Purpose:

- Prove the finite algebra rejection certificate:
  if `B` commutes with the balance symmetry `J`, then every polynomial selector
  `p(B)` has zero chiral trace against a `Gamma` anti-commuting with `J`.

Claude review:

```text
AgentTasks/model-calls/claude/2026-06-27-155100-cycle9-c108-origin-certificate-review.md
```

Verdict:

- Accept with caveats.
- Keep the stronger theorem: any `J`-commuting `P` has zero chiral trace; do not
  require idempotence.
- Make the anti-commutation sign explicit as `J * Gamma = -(Gamma * J)`.

Follow-up:

- Local C108 source was patched with the explicit parenthesization.
- Live clarification was sent to the running Aristotle project.

## Other active jobs

```text
C107c:
  project e5b6e8b5-3277-40fb-8cb8-c674d6d4994c
  status in_progress

C111:
  project 212cd6b6-7c6a-4817-a513-3b7b3f1cfb4d
  status in_progress
```

## Literature search

Query/source:

```text
neo4j_paper_search.py --chunks --query
"finite spectral island projector covariance matrix spectrum conjugation polynomial selector chiral lattice gauge"
```

Useful hits:

- Dirac-Kahler chiral/flavour projection chunks are relevant as projection
  comparison material.
- Gauge-network finite spectral-triple chunks are relevant later for gauge
  wrappers.
- Nielsen-Ninomiya and Ginsparg-Wilson chunks reinforce that projector algebra
  cannot be overclaimed as release.
- SMG projector/propagator-zero chunks reinforce the ghost-zero warning.

Plan impact:

- No change. C108 is the right rejection-certificate complement to the C107
  polynomial projector ladder.
