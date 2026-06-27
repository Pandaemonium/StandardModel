# Wave 6 job: B4 finite-square rebase on NullSolderFrame foundations

You are Aristotle. This is a no-build proof-planning job, with optional Lean theorem sketches if the materials are sufficient. Use the files in `materials/` as context.

## Core request

Gate B now has stronger NullSolderFrame foundations: reconstruction identity, simplex frame, inverse-Gram identities, and the trace obstruction rejecting diagonal-flat misuse. Separately, kinetic-normalization work names `K_null`, `K_full`, `Cdiamond`, `Tframe`, and finite square decompositions imported from an older tetrad-postulate file. We need a rebase plan for B4: future finite-square identities should rest on the NullSolderFrame foundation rather than on stale local encodings.

## Tasks

1. Compare the B-core NullSolderFrame report with the kinetic-normalization report.
2. Identify exactly which definitions/theorems in the finite square should be rebased onto `dualBasis` / inverse-Gram data.
3. Preserve the trace obstruction: diagonal flats are a rejected comparison object, not the carrier of the dual-soldered architecture.
4. Produce promotion-safe theorem statements for:
   - `K_null` as the symmetric null kinetic block;
   - `K_full = K_null + Cdiamond`;
   - finite Dirac-square decomposition with `Tframe`;
   - conditions under which `Cdiamond = 0`;
   - conditions under which no-double-counting matching to `Phi_H^2` can be stated.
5. Specify the exact dependency order B1 -> B3 -> B2 -> B4 and what must not be promoted before Gate A.
6. Give a minimal Lean-file skeleton for the future B4 rebase, including imports, namespace, declarations, and handoff comments.

## Guardrails

- Mostly-minus signature.
- No Euclidean edge-sum collapse.
- No continuum theorem.
- No prediction language.
- No finite-square promotion before Gate A.

## Deliverable

Write `AgentTasks/null-edge-b4-square-rebase-plan.md` with a dependency map, theorem-interface plan, and minimal Lean skeleton.
