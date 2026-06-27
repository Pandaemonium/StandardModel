# Wave 6 job: Gate A super-Dirac sign closeout and theorem-interface plan

You are Aristotle. This is a no-build theorem-interface and convention-closeout job. Use the files in `materials/` as the complete context packet.

## Core request

Gate A controls whether finite-square theorem packages can ever be promoted. Recent work produced a super-Dirac sign/counterexample report and a kinetic-normalization report. We need a precise closeout: what is proved, what remains convention, what must be counterexample-protected, and what theorem interface should future Lean code use.

## Tasks

1. Extract the correct super-Dirac square statement under the locked grading conventions.
2. Extract the wrong-grading / wrong-sign counterexamples and state exactly what they rule out.
3. Reconcile the names `K_null`, `Boxnull`, `K_full`, `Kplus`, `Cdiamond`, `Tframe`, and the zero-order internal block `Phi_H`.
4. Produce a promotion-safe theorem-interface sketch for future Lean code, separating:
   - finite ring-algebra naming identities;
   - graded super-Dirac square identities;
   - kinetic matching / no-double-counting identities;
   - continuum-symbol claims, which remain gated.
5. Say what should be locked in `docs/CONVENTIONS.md` now and what should remain theorem-gated.
6. Identify the smallest next Lean theorem that would make Gate A genuinely pass for promotion purposes.

## Guardrails

- No finite-square theorem promotion until Gate A is passed.
- Do not collapse spacetime chirality and internal grading.
- Do not use `K_null = K_full` unless `Cdiamond = 0` is proved.
- Do not present `Phi_H^2` as an additional mass added on top of Plucker spread; preserve no-double-counting.

## Deliverable

Write `AgentTasks/null-edge-gate-a-closeout.md` with theorem statements, counterexample statements, convention-lock recommendations, and the next proof target.
