# Codex proof job: exact path-sum equals transfer-matrix power

Close every proof in `PathTransfer/Core.lean` without changing definitions,
matrix orientation, theorem statements, coefficients, or assumptions. The main
theorem must derive the finite direction-history sum as the corresponding
matrix element of the `n`th transfer power. Preserve the outgoing-step phase
convention and the exact nonzero value `85` in the two-step fixture.

This is the missing derived arrow from scalar checkerboard history composition
to operator evolution. It is finite and exact. Do not claim the Fourier
momentum dictionary, the existing complex unitary split-step walk, a continuum
propagator, or a path integral measure until those are separately composed.

Run `lake env lean PathTransfer/Core.lean`. Return the complete file, helper
lemmas used, and any orientation/convention issue discovered.

Context pack:
`AgentTasks/context-packs/checkerboard-pathsum-transfer-power-20260710-20260710-000458.md`.

Project: `18f119a4-7469-4e93-a592-d3342605e5d4`  
Status at launch: RUNNING  
Submission: `AgentTasks/aristotle-submit/codex-checkerboard-pathsum-transfer-power-20260710-01-project`
