# Proof job: local even fermionic interaction and selected-sector audit

Work in Lean 4.28 with Mathlib. Build a self-contained finite fermionic model
that tests the first interacting successor to free QCA locality.

Use at least four ordered fermionic modes and an exact occupation or exterior
algebra realization. Define a genuinely even, nonidentity pair-transfer
interaction of the form

```text
H_z = z a_2^* a_3^* a_1 a_0 + conjugate(z) a_0^* a_1^* a_3 a_2
```

with all ordering signs fixed explicitly. Then prove as much of this ladder as
possible:

1. `H_z` is Hermitian, preserves fermion parity and particle number, vanishes
   on vacuum and the one-particle sector, and acts nontrivially on an explicit
   two-particle state for nonzero `z`.
2. Construct an exact nonidentity unitary interaction update from `H_z`
   (closed form on the pair subspace is acceptable) and prove the same support,
   number, and parity properties.
3. Declare a cell/support set containing the four modes. Prove conjugation fixes
   every creation and annihilation operator outside that support and maps the
   supported CAR algebra into itself. This must be an operator/algebra theorem,
   not locality inferred from the word "quartic".
4. State a selected-sector projector or invariant subspace and prove the exact
   commutator/invariance criterion. Supply one nontrivial selected sector that
   the interaction preserves and one explicit wrong sector that it mixes.
5. If feasible, compose the interaction with one sparse free update and prove
   the resulting CAR light cone enlarges only by the union/composition of the
   free neighborhood and the interaction cell.

This is a finite interacting control, not a continuum QFT or a positive-energy
theorem. Do not call parity a positive-energy sector. Keep preservation and
mixing controls separate. Return all Lean source and a completion report. No
proof placeholders, compiler-trusted evaluation, fake assumptions, or weakened
tautological support predicates.

Relevant semantic context:
`AgentTasks/context-packs/hnu-fock-interaction-sector-20260721-024058.md`.
