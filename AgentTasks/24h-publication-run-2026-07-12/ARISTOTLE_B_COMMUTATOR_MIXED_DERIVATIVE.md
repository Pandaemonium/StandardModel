# Aristotle target: mixed derivative of the exact commutator

Close every proof hole without changing statements. The flagship theorem is
the exact mixed Frechet derivative identity for the trigonometric four-factor
unitary commutator:

```text
d_q (d_p U)(0,0) = G*A - A*G.
```

Also preserve the zero complete first derivative, live nonzero
`alpha1/beta` fixture, and repeated-generator zero control. Small calculus
helper lemmas are welcome.

Do not weaken to an informal series, entrywise finite difference, or supplied
derivative. Do not claim Laurent locality or root exclusion. Return the current
target promptly if a broad build is slow.

```yaml
aristotle:
  project_id: 2ed756dc-b838-4fa3-8fea-0bffe6a433bc
  task_id: 254c6643-7dc4-4ae4-8a26-fbc55aafc74f
  target_file: PhysicsSM/Draft/NullEdge/CommutatorMixedDerivative.lean
  expected_module: PhysicsSM.Draft.NullEdge.CommutatorMixedDerivative
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-commutator-mixed-derivative-20260711-project
  output_dir: AgentTasks/aristotle-output/2ed756dc-b838-4fa3-8fea-0bffe6a433bc
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Integrated 2026-07-11. Identity value, zero complete first Frechet derivative,
exact Lie-coefficient mixed derivative, live nonzero fixture, and repeated-
generator control pass direct Lean, targeted build, and the aggregate guard.

Direct target typecheck PASS with five isolated proof holes before submission.

Independent SymPy oracle on the live `alpha1/beta` matrices confirms the exact
sign: `d_q d_p U(0,0) = beta*alpha1 - alpha1*beta`, with nonzero entries
`(0,3)=2`, `(1,2)=2`, `(2,1)=-2`, `(3,0)=-2`; both first partial derivatives
vanish. The oracle is not proof.
