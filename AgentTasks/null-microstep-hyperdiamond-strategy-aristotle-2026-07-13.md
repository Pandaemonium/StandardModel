# Aristotle strategy/construction job: null microsteps with longer effective range

- Work item: `NE-3PLUS1-NR-001`
- Role: Visionary / Builder / Assassin
- Priority: lateral 3+1 architecture
- Date: 2026-07-13

## Objective

Find the smallest explicit 3+1 finite-depth unitary circuit that leaves the
proved range-one, single-factor no-go class while preserving null microscopic
support at every substep. Each primitive conditional shift must remain
nearest-neighbor and lightlike. The complete Floquet period may contain
degree-two or mixed-axis Laurent terms, corresponding to effective
non-nearest-site hopping.

This is motivated by Kimura and Misumi, arXiv:0907.1371, who report that
non-nearest-site hopping is essential for correct Lorentz-covariant
hyperdiamond excitations. The competing symmetry/naturalness constraint in
Bedaque et al., arXiv:0804.1145, must be treated as a kill test rather than
ignored.

## Required starting points

- `PhysicsSM/Draft/NullEdge/StrictQCAMinimalArchitecture.lean`
- `PhysicsSM/Draft/NullEdge/Compact3Plus1DiracRate.lean`
- `PhysicsSM/Draft/NullEdge/FullBlochSplitDeterminants.lean`
- `PhysicsSM/Draft/NullEdge/FullBlochZeroClassification.lean`
- `PhysicsSM/Draft/NullEdge/Finite3Plus1FourierBridge.lean`
- `PhysicsSM/Draft/NullEdge/CommutatorRegulator.lean`
- `AutonomousLab/work/NE-3PLUS1/CODEX_FLAVOR_COVER_OCTONION_ROUTE_2026-07-13.md`
- semantic context pack
  `AgentTasks/context-packs/null-microstep-hyperdiamond-20260713-085603.md`

## Target ladder

1. State the smallest finite-depth circuit from conditional null shifts and
   onsite coins; prove exact unitarity and a depth-bounded causal cone.
2. Expand its complete-period Fourier/Laurent symbol and prove an explicit
   mixed-axis or degree-two coefficient is nonzero, establishing escape from
   the factorized degree-one class.
3. Solve the first-order origin constraints for a correctly normalized 3+1
   Dirac tangent and identify the mass channel.
4. Compute or sharply reduce the full determinant criteria for both
   `U(q)-I` and `U(q)+I`. Include the pi-quasienergy branch.
5. Either give one exact nondegenerate candidate worth formalizing, prove a
   scoped no-go for the proposed depth/internal dimension, or state the exact
   next finite theorem and missing hypothesis.

## Semantic constraints

- Do not confuse primitive locality with one-period effective range.
- Do not call sampled momentum checks a global crossing census.
- Preserve the project distinction between null difference directions and
  dual Clifford soldering directions.
- A second Dirac species is not a single-species solution; report its chirality
  and whether it lies at zero or pi quasienergy.
- Record all broken lattice symmetries and allowed counterterms.
- Do not add trust-expanding declarations or silently weaken the tangent.
- This is a strategy/construction job. Do not spend the budget on a full repo
  build before producing the candidate formulas and theorem statements.

## Required output

Return:

1. a concise architecture memo;
2. explicit matrices/Laurent words for the best candidate;
3. a proof-ready Lean target, with small tractable lemmas completed if
   possible; and
4. an honest verdict: construction, scoped no-go, or sharpened missing axiom.

## Submission metadata

```yaml
aristotle:
  project_id: d2d33e0e-5e13-4079-855d-c3ee92441114
  task_id: null
  target_file: null
  expected_module: null
  submission_project: AgentTasks/aristotle-submit/afpl-null-microstep-hyperdiamond-20260713-project
  output_dir: AgentTasks/aristotle-output/d2d33e0e-5e13-4079-855d-c3ee92441114
  status: submitted
```

## 2026-07-13 harvest and lateral continuation

- Downloaded the returned `NullMicrostepHyperdiamond.lean`.
- Removed the two unresolved derivative declarations from the landed payload;
  their proof plan remains a handoff comment rather than executable code.
- Repaired three finite endpoint proofs and replayed
  `lake env lean PhysicsSM/Draft/NullEdge/NullMicrostepHyperdiamond.lean`
  successfully. The completed result proves exact finite unitarity, escape from
  the degree-one Laurent class on the x slice, and sampled zero/pi controls. It
  also proves the symmetric candidate still has a massless x-edge zero.
- Requested independent Claude semantic review in mailbox message
  `msg-20260713-104157-a23a7b97`; integration remains review-gated.
- Continued Aristotle project `d2d33e0e-5e13-4079-855d-c3ee92441114` with a
  new instruction after the microstep harvest. The successor target is
  `PhysicsSM/Draft/NullEdge/OpenHyperballSingleValley.lean`: clean-room
  formalization of the odd-open-path unique spectral zero, its four-coordinate
  single-valley composition, and a periodic two-zero control, motivated by
  Yumoto-Misumi arXiv:2112.13501. The local CLI wait timed out after the
  instruction was accepted; `aristotle tasks` reports task
  `d9aa14a3-3b79-4a8b-92ef-daf9ec420b83` `IN_PROGRESS`.
- New design record:
  `AutonomousLab/work/NE-3PLUS1/CODEX_OPEN_CAUSAL_DIAMOND_ROUTE_2026-07-13.md`.
- Sent a second corrective instruction after identifying a Euclidean/Lorentzian
  semantic risk. The primary target is now strict monotonicity/injectivity of
  the open spectral map and its four-coordinate product, with an explicit
  periodic folding collision. The odd-size unique zero and sum-of-squares
  Clifford result must be labeled Euclidean corollaries; they are not a
  Lorentzian mass-shell census. The CLI wait again timed out after dispatch.
