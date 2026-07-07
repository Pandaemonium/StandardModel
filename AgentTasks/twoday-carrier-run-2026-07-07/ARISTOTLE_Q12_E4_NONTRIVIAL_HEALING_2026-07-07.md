# Aristotle task brief - Q12 nontrivial E4 healing witness

Job name: `ne-solo-lane-q12-e4-nontrivial-radical-healing-witness-proof-20260707`

Aristotle project id: `297ae18c-b8a9-49b8-b0ea-55c2cf26e85d`
Submission project:
`AgentTasks/aristotle-submit/ne-solo-lane-q12-e4-nontrivial-radical-healing-witness-proof-20260707-project`
Status: `CANCELED` after Codex locally proved
`E4_nontrivial_healing` before Aristotle returned.

## Goal

Replace or supplement the degenerate `E4_healing` witness in
`PhysicsSM/Draft/NullEdge/GateI1/Q12GammaPrimeQuotient.lean`.

The Q13 global audit found that the current theorem

```lean
theorem E4_healing :
    forall x : (top : Submodule Q W),
        (fW (gW x) - gW (fW x) : W) in (top : Submodule Q W)
```

is true but degenerate: `N = top`, so the proof is just membership in the full
space.  The actual gate needs a proper nonzero radical witnessing that upstairs
non-commutation can heal on a nontrivial quotient.

Please prove, if feasible, a finite rational witness with:

- `W = Fin 2 -> Q` or another tiny rational vector space;
- a proper nonzero radical `N` with `N != bottom` and `N != top`;
- the current noncommuting pair or a similarly explicit pair `f, g`;
- the upstairs commutator is nonzero for some constrained vector;
- nevertheless, for every constrained vector, the commutator lies in `N`, so
  the descended operators commute by `physDescend_commutes_of_commutator_mem`.

The likely witness is `N = span Q {![1, 0]}` for the current
`fW = !![0,1;0,0]` and `gW = !![1,0;0,0]`, since their commutator is a nonzero
multiple of the first coordinate direction.

## Files to inspect

- `PhysicsSM/Draft/NullEdge/GateI1/Q12GammaPrimeQuotient.lean`
- `PhysicsSM/Draft/NullEdge/GateI1/GateI1.lean` if an import/aggregator update is
  needed
- `AgentTasks/twoday-carrier-run-2026-07-07/CLAIM_GRADE_REGRESSION_AUDIT_2026-07-07.md`

## Output requirements

- Prefer a patch against `Q12GammaPrimeQuotient.lean`.
- Keep the claim finite and algebraic only; do not promote to anomaly,
  equivariant McKean-Singer, or physical quotient claims.
- Guard-pin any new headline if you return a patch.
- If Lean proof is not feasible, give exact missing lemmas and a smallest-next
  theorem statement.
