# Proof job: positive Hamiltonian to transfer orbit, reflected kernel, and pole

Work in Lean 4.28 with Mathlib. Build the next origin-of-mass rung upstream of
the already proved finite self-adjoint transfer-orbit theorem.

For a finite-dimensional Hermitian positive-semidefinite Hamiltonian `H` and
time step `a > 0`, define `T = exp(-a H)`. Prove as much of the following exact
chain as Mathlib supports:

1. `T` is Hermitian, positive definite, and a contraction.
2. Every eigenvector `H v = E v` obeys `T v = exp(-a E) v`.
3. For any observable vector, the reflected kernel
   `K(t,s) = <T^t v, T^s v>` is Gram-positive.
4. A nonzero visible eigenvector with `E > 0` gives exact decay
   `exp(-a E n)`, reconstructed energy `E`, and positive simple resolvent
   residue `||v||^2`.
5. Give an exact nondegenerate two-level fixture with ground energy `0`, excited
   energy `log 2 / a` (or choose `a = 1`), and unit visible residue.

If matrix-exponential positivity is the only blocker, isolate and prove the
eigenmode/action-to-transfer theorem plus the complete downstream reflected
kernel and pole chain, and report the exact missing positivity lemma. Do not
replace positivity by an unrelated finite matrix predicate or silently assume
the transfer eigenvalue.

The result is finite quadratic dynamics. It is not an interacting Wilson
action, infinite-volume reconstruction, changing-lattice pole persistence, or
LSZ. Return self-contained Mathlib-only Lean source and a semantic audit of
which hypotheses are load-bearing. No hidden assumptions, proof placeholders,
or compiler-trusted finite evaluation.

Semantic context:
`AgentTasks/context-packs/mass-action-transfer-pole-20260721-20260721-002827.md`.
