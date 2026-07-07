# Run ledger (two-day carrier run) - APPEND-ONLY

The single coordination channel. Both agents append; nobody edits or deletes.
Entry types:

```
[CLAIM agent HH:MM] <lane/module/thread>            # before touching anything shared
[RELEASE agent HH:MM] <what>
[HB agent HH:MM] <cycle digest: landed / in-flight / next>
[REVIEW-REQ agent HH:MM] <commit/module> -> other agent
[REVIEW-OK|REVIEW-FLAG agent HH:MM] <module>: <verdict / reason>
[AUDIT-FINDING agent HH:MM] <module>: <finding + severity + fix>
[FABLE-CALL NN HH:MM] <5-line digest + DECISION TAKEN + who acts>
[QUEUE ...] lives in FABLE_QUEUE.md, not here
[RED-FLAG agent HH:MM] <AGENTS.md red-flag condition; thread stopped>
[SAT-SIGNAL agent HH:MM] <lane>: <evidence work is saturated>
```

Claims are cheap - post them liberally; a collision costs an hour, a claim line
costs nothing. Read the other agent's open claims at the top of every cycle.

---

## Seed state (run start)

- [CLAIM Claude T+0] standing lanes: T, A, Carrier/** (incl. CarrierAxiomGuard.lean), A=T bridge, B-commutant.
- [CLAIM Codex T+0] standing lanes: C, GateYM/** (incl. SlabAxiomGuard.lean), QMF/product-Haar, OS1, QC, KP.
- [HB setup T+0] In-flight Aristotle jobs to harvest cycle 1:
  - sm-weitzenbock-brick c6af1315-a4f0-4bf3-ab69-bd4cd9f3ba8a (Claude harvests) -
    null nilpotency + zero-edge-diagonal, the W1 brick 1.
  - sm-color-commutant 1e9ac867-9537-48f7-8e7d-cb89fe7af1eb (Claude harvests) -
    the [H2] Schur/commutant constraint.
  - sm-product-haar ac751ecb-a6c8-492f-865b-062980931183 (Codex harvests) -
    closes `reflForm_self_nonneg` in `ProductHaarConfig.lean` (the PH thread).
- [HB setup T+0] Known stale-hazard note: much of the pre-carrier backlog is
  LANDED in-tree; stale-check every submit (playbook sec 2.2). Known verified
  negatives to respect: `kp_convergence_bound_false`, the Spin(10) Transitivity
  falsification, the hollow nn-fix artifact.
- [HB setup T+0] First Fable call due T+3 (call 01: RATIFY Move-1 brick
  statements + FORK OS1 route). Codex: have the OS1 route comparison ready by
  then. Queue file: FABLE_QUEUE.md (seeded).

---

## Live entries (append below)
