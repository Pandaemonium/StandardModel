# Aristotle strategy task: alias-free strict 3+1 QCA successor

Construct, or prove the sharpest obstruction to, an exactly unitary strictly
finite-range `3+1` Dirac QCA outside the landed separable four-channel
degree-one alias class.

The successor must target:

- exact all-Bloch unitarity and finite propagation;
- the full live `alpha1,alpha2,alpha3,beta` tangent with speed one;
- compatibility with the complex Pluecker mass coin and its phase covariance;
- no unintended zero- or pi-quasienergy modes over the full Brillouin zone;
- explicit inverse and position-space implementation;
- comparison map to the current walk and Wilson Hamiltonian tangent;
- perturbative gap robustness.

Explore second-neighbor, multi-substep, enlarged-cell, ancillary, BCC,
tetrahedral, and D4 routes. Respect `StrictQCAMinimalArchitecture` and its exact
even-corner alias theorem. Return explicit finite formulas and Lean-ready
theorem statements, a nondegenerate massive witness, full-zone kill criterion,
and the smallest decisive no-go if construction fails. Corner sampling alone
is not acceptable.

```yaml
aristotle:
  project_id: 14ce545e-d17b-432f-a2e7-fb1fe35cfa1a
  task_id: a2ff17c1-a91f-4a89-8bf4-dabd49c89e97
  target_file: StrictQCASuccessor/Main.lean
  expected_module: StrictQCASuccessor.Main
  submission_project: AgentTasks/aristotle-submit/strict-qca-successor-strategy-20260710-project
  output_dir: AgentTasks/aristotle-output/14ce545e-d17b-432f-a2e7-fb1fe35cfa1a
  status: submitted
```

## Live literature injection

During the live run, `continue --mode instruct` supplied the focused
doubling-repair references arXiv:2505.07900, 2601.15885, 2105.12314,
1603.06442, 1708.00826, and 2404.09840.  Aristotle was asked to identify the
smallest theorem-ready covering-map, stay-channel, BCC/tetrahedral, or unitary
Wilson architecture outside the landed four-channel degree-one factor no-go,
with an exact full-Bloch kill test.

## Harvest and semantic verdict

Downloaded the in-progress snapshot on 2026-07-10 and locally compiled
`StrictQCASuccessor/Successor.lean`. Its proof-complete algebraic prefix is
valid, but the claimed strict finite-range interpretation is rejected:
`factor (r*q)` is a finite Fourier/Laurent harmonic only for integer `r`, while
the de-aliasing certificates require noninteger trigonometric values. For
integer `r`, the Wilson commutator is trivial at the zone edge and the aliases
return. The corner and body-center certificates also impose different angle
conditions and do not exhibit one parameter removing both. The two final
global-doubler declarations remain proof placeholders backed only by numerical
search. Sent a stop instruction and split the exact family-scoped obstruction
into project `144a848d-d853-4ab5-b741-2a6fd7e0398b`.
