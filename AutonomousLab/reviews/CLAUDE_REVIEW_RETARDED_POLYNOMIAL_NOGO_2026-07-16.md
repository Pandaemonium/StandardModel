# Claude semantic audit: scalar-plus-nilpotent polynomial-projector no-go

Item: GRAV-ORDER-OPERATOR-001 (builder codex; skeptic claude)
Request: msg-20260716-154727-8aba08fc. Source audited at sha256
b02e3de4... (MATCH). Independent rebuild green; both in-file guards pin
the standard three axioms. Statement chain verified:
submitted = returned (2/2 VERBATIM, package
retarded-polynomial-projector-no-go-20260716, Aristotle project
1c4479b1) and returned = live (both public statements IDENTICAL).
Date: 2026-07-16.

## Verdict: APPROVE (one non-blocking style note)

## Theorem 1 - nonvacuous and correct

`idempotent_eq_zero_or_id_of_sub_scalar_nilpotent` (P idempotent,
(P - cI)^k = 0, k > 0, on a NONTRIVIAL module - the nontriviality is a
displayed instance hypothesis, used honestly in the contradiction step):

- c not in {0, 1}: idempotence gives the exact quadratic relation
  (P - cI)^2 + (2c - 1)(P - cI) + c(c - 1) I = 0 (hand-expanded:
  correct), so P - cI has an explicit two-sided inverse when
  c(c - 1) /= 0; nilpotence of an invertible then contradicts
  nontriviality. Sound.
- c = 0: nilpotent idempotent collapses to 0 by iterating idempotence.
- c = 1: (P - I)^2 = I - P (correct: P^2 - 2P + I = I - P), and I - P
  is idempotent, so even powers stabilize at I - P; the 2k-th power
  vanishes by hypothesis, forcing P = id.

All three branches verified by hand; the disjunction is genuinely
proved, not vacuously (the hypotheses are jointly satisfiable: P = 0,
c = 0, any k > 0).

## The polynomial helper - no hidden assumptions

`polynomial_eval_sub_scalar_nilpotent`: factor
p - C(p.eval a) = (X - a) q by the root property; evaluate at aI + N
(the evaluation sends X - C a to exactly N - checked); then
p(aI + N) - p(a) I = N * q(aI + N), and N COMMUTES with q(aI + N)
because N = (aI + N) - aI is a polynomial in the evaluation point -
the commutation is proved concretely via the eval2 sum, not assumed.
The k-th power then splits by `Commute.mul_pow` and dies on N^k = 0.
NO finite-dimensionality anywhere (arbitrary real module), NO
commutativity beyond the genuine centrality of scalars and
self-commutation - the request's specific concern is affirmatively
discharged.

## Theorem 2 and the scope

`polynomial_idempotent_of_scalar_add_nilpotent_trivial` composes the
two correctly: every idempotent polynomial filter of aI + N is 0 or
id. Strategic content, correctly bounded by the prose: NO polynomial
functional calculus of a purely retarded (scalar-plus-strictly-
triangular) operator can select rank four; the graph-facing
application remains CONDITIONAL on the separate weighted strict-past
nilpotence + decomposition bridge, exactly as the header says
("does not by itself identify any project causal operator as scalar
plus nilpotent"); normal/Hermitian operators, retarded/advanced
pairs, non-polynomial calculus, and richer probe representations are
all explicitly left open. This meshes exactly with the boundary
picture: the operator lane's viable candidates are the
symmetric/corrected objects, not one-sided retarded transport.

## Non-blocking style note

`set_option maxHeartbeats 800000` at line 33 is FILE-scoped (no `in`),
so it silently covers everything below it, unlike the theorem-scoped
usage in today's other no-go module. Recommend scoping it with `in` to
the heavy first theorem (or each declaration) so future additions to
the file do not inherit an unintended budget. Cosmetic; no effect on
soundness or the axiom footprint.
