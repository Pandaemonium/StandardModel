# Aristotle job: coframe-derived Lorentz-Hodge Palatini face

Date: 2026-07-17
Work item: `GR-PALATINI-LINK-006`

```yaml
aristotle:
  project_id: 26c0bc8e-8857-45c8-9eef-6913eeef31a9
  task_id: 86835503-7179-4eb4-86bd-9c1fa7480b75
  target_file: CoframeHodge/Target.lean
  expected_module: CoframeHodge.Target
  submission_project: AgentTasks/aristotle-submit/null-edge-coframe-hodge-face-20260717-project
  output_dir: AgentTasks/aristotle-output/26c0bc8e-8857-45c8-9eef-6913eeef31a9
  status: completed_integrated
```

## Target

Derive the ordered Palatini face field from a finite coframe as the Lorentz
Hodge dual of its wedge. Prove exterior-square coframe covariance, proper
Lorentz commutation with the Hodge star, and covariance of the resulting
six-component face field.

## Convention lock

- spacetime/internal metric: mostly-minus `(+,-,-,-)`;
- orientation: `0123`;
- bivector basis: `(12,13,23,01,02,03)`;
- Hodge controls: `star(12)=03`, `star(13)=-02`, `star(23)=01`, and
  `star^2=-1`;
- internal Palatini bivector building block: `star (e_a wedge e_b)`;
- covariance gate: eta-Lorentz plus determinant `+1`.

Orientation reversal is deliberately excluded from the commutation theorem.
The job must not change these conventions to simplify the proof.

## Inputs

- `AgentTasks/aristotle-standalone/null-edge-coframe-hodge-face-20260717/CoframeHodge/Target.lean`
- `AgentTasks/aristotle-standalone/null-edge-coframe-hodge-face-20260717/ARISTOTLE_PROMPT.md`
- `AgentTasks/context-packs/lorentz-hodge-palatini-face-20260717-180839.md`
- `PhysicsSM/Draft/NullEdge/LorentzBivectorKreinBridge.lean`
- `PhysicsSM/Draft/NullEdge/FinitePeriodicKreinLinkPalatiniVariation.lean`

## Preflight status

The package contains three intended proof handoffs. The easy finite controls
for orientation antisymmetry, repeated-direction vanishing, and
`star^2=-1` are completed before submission.

The repo-wide semantic-index refresh was attempted twice but remained silent
past two minutes and was terminated. Context-pack generation against the
already indexed corpus completed successfully and supplied the file above.

The standalone target passed under the main repository's pinned Mathlib
toolchain with exactly the three intended proof-hole warnings and no other
diagnostics:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-coframe-hodge-face-20260717/CoframeHodge/Target.lean
```

A direct check inside the fresh focused copy cloned Mathlib but did not finish
building its dependency cache before the command timed out. The clean
submission package therefore omits `.lake`, as intended for a focused
Aristotle build, and contains no copied dependency or generated-output tree.

## Submission

Submitted on 2026-07-17 as project
`26c0bc8e-8857-45c8-9eef-6913eeef31a9`, task
`86835503-7179-4eb4-86bd-9c1fa7480b75`. Initial state was project `RUNNING`,
task `QUEUED`.

The preparation helper reported three proof-hole lines, zero admission tokens,
zero assumption-declaration tokens, and zero unsafe tokens. Aristotle was told
to run the narrow target first, preserve all statements and conventions, and
report a counterexample or sign/variance mismatch instead of modifying a
false target.

## In-progress harvest

At 32 minutes the task remained `IN_PROGRESS`. A nonredirecting `--mode ask`
status query timed out without a response and did not change the task. A
read-only snapshot was downloaded to
`AgentTasks/aristotle-output/26c0bc8e-8857-45c8-9eef-6913eeef31a9/in-progress-snapshot.zip`.

The snapshot had solved `coframeWedge_mul` and introduced one helper proof hole
for the proper-Lorentz Hodge commutation, leaving that helper plus the two
orientation-sensitive targets open. The snapshot target passed under the main
repository toolchain with exactly those three proof-hole warnings. The solved
exterior-square proof was independently simplified, inserted into
`LorentzCoframePalatiniFace.lean`, and verified locally. The Aristotle task is
still running for Hodge commutation and final face covariance.

At roughly 75 minutes, a fresh snapshot showed further progress: both
`wedgeTwoTransport_commutes_lorentzHodgeStar` and `palatiniFaceWeight_mul` are
now complete downstream of the helper, leaving only
`properLorentz_hodge_entry`. Aristotle was redirected to the Jacobi
complementary-minor route, with the available Mathlib adjugate and nonsingular
inverse APIs named explicitly. A 95-minute snapshot still had that single
proof hole, so no incomplete Hodge proof has been copied into the live module.
The project remains running under the same project identifier.

At roughly 115 minutes, a fresh snapshot added and kernel-checked two further
helpers: `etaLorentz_inverse` and `properLorentz_adjugate`, the latter proving
`adj(L) = eta * L^T * eta` from eta-Lorentz orthogonality and `det L = 1`.
The snapshot still contains exactly one proof hole, in
`properLorentz_hodge_entry`; its downstream covariance theorems remain
complete. A separate Claude Opus audit was attempted through the logged repo
wrapper, but the provider returned `Credit balance is too low` before doing
any mathematical work. The failed call is recorded at
`AgentTasks/model-calls/claude/2026-07-17-200511-null-edge-hodge-covariance-helper-audit-20260717.md`.

Aristotle was then redirected with a sharper compound-matrix proof. In the
fixed bivector basis, let `G = diag(1,1,1,-1,-1,-1)` and let the Euclidean
complement matrix be `E = lorentzHodgeStar * G`. The finite identities
`E^2=G^2=1`, `E*G=lorentzHodgeStar`, and `E*G=-(G*E)` were checked, as was the
Jacobi compound identity
`C2(adj L) = det(L) * E * C2(L)^T * E` on an exact integer oracle fixture.
Together with `C2(eta)=G`, compound multiplicativity, transpose covariance,
and the new adjugate helper, that identity reduces the target to a short
matrix calculation. The oracle check fixes signs only; the returned Lean
proof must still establish every identity in the kernel.

## Curvature-face label audit

The submitted covariance target remains correct for the internal bivector
building block. A later audit clarified that when `(a,b)` label the actual
curvature plaquette, the action coefficient is the complementary spacetime
contraction `(1/2) epsilon^(cdab) star(e_c wedge e_d)`. The live module now
implements that contraction. Any returned local Lorentz covariance theorem
extends to it termwise because the spacetime alternating coefficients are
internal-gauge scalars.

## Completion and integration

Aristotle completed project `26c0bc8e-8857-45c8-9eef-6913eeef31a9` and task
`86835503-7179-4eb4-86bd-9c1fa7480b75`. The final archive was harvested to
`AgentTasks/aristotle-output/26c0bc8e-8857-45c8-9eef-6913eeef31a9/project-files.tar.gz`;
the final target and summary were extracted to the `final/` subdirectory. The
standalone target passes under the pinned repository toolchain.

The live integration uses the returned compound-matrix route, with an explicit
coordinate display proved equal to the repository's canonical derived
bivector metric. It proves proper-Lorentz Hodge commutation and covariance of
the internal Palatini face. The complementary curvature-face covariance was
then derived termwise in the live module. Finally,
`NonlinearLorentzPalatiniAction.nonlinearCoframePlaquetteAction_gaugeTransform`
combines that result with plaquette-holonomy conjugation to prove exact gauge
invariance of the concrete scalar action. All three live covariance results
have build-enforced standard-three axiom guards.

Verified during integration:

```text
lake env lean PhysicsSM/Draft/NullEdge/LorentzCoframePalatiniFace.lean
lake build PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
lake env lean PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniAction.lean
```

Final repository verification also passed:

```text
pre-commit run --all-files
lake build
```

The full build completed all 8,319 jobs. Two auxiliary semantic-index refresh
attempts, first over all changed files and then over the ten relevant GR files,
timed out while silent; no Neo4j refresh is claimed from those attempts.
