# Codex proof job: normalized 3+1 Clifford unitary step

Close every proof in `CliffordStep/Core.lean` without changing definitions,
statements, coefficients, or matrices. Prove the general theorem that
`U = a I - i H` is exactly two-sided unitary whenever `H` is Hermitian,
`H^2=qI`, and `a^2+q=1`. Close the explicit nontrivial rational massive witness
with velocity coefficients `1/2,1/2`, mass coefficient `1/2`, `q=3/4`, and
stay coefficient `a=1/2`.

This is the unitary-evolution rung after `Clifford3Plus1WalkSymbol`. It does not
construct position-space/BCC shifts, prove locality of the step, sum lattice
histories, or establish a 3+1 continuum limit.

Literature orientation: arXiv:1802.03910 and arXiv:2006.08927 momentum-space
walk/Dirac-limit sections from the 00:35 chunk search. PhysLean reference:
finite-target time-evolution and unitary matrix theorem shapes only.

Run `lake env lean CliffordStep/Core.lean`; return the complete file and any
normalization or conjugate-transpose issue.

Context pack:
`AgentTasks/context-packs/normalized-clifford-unitary-step-20260710-20260710-004603.md`.

```yaml
aristotle:
  project_id: c6d496f0-26ba-4c77-99da-05bb56e5be19
  target_file: CliffordStep/Core.lean
  expected_module: CliffordStep.Core
  submission_project: AgentTasks/aristotle-submit/codex-normalized-clifford-unitary-step-20260710-project
  output_dir: AgentTasks/aristotle-output/c6d496f0-26ba-4c77-99da-05bb56e5be19
  status: running
```
