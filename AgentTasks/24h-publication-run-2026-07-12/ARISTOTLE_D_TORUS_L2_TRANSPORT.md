# Aristotle task: fixed-torus L2 transport of the full live walk theorem

Status: superseded by a proof-complete local composition and landed.

Target:
`AgentTasks/aristotle-targets/codex_24h_d_torus_l2_transport.lean`.

Close every proof hole without changing a statement or adding assumptions.
Run the target first. Use Mathlib's `UnitAddTorus.mFourierBasis`, the `lp` norm
identity, `Equiv.summable_iff`/`Equiv.tsum_eq`, and the coordinate bound
`lp.norm_apply_le_norm` as appropriate.

Required semantic result: transport the complete live coefficient error to
strong convergence in the finite product of four fixed-torus scalar L2 spaces.
The exact Parseval/reindex theorem and coordinate-to-spinor comparison must
remain explicit, rather than hiding the conclusion behind an assumed isometry.

Scope exclusions are binding: no claim of changing-lattice interpolation,
`R^3` convergence, a continuum Dirac PDE solution, Lorentz restoration, or
position-space ultraviolet control beyond what the fixed-torus Fourier
isometry supplies.

```yaml
aristotle:
  project_id: 3f6bb22c-323a-4b3d-9f3a-718a0eeb7355
  target_file: AgentTasks/aristotle-targets/codex_24h_d_torus_l2_transport.lean
  expected_module: PhysicsSM.Draft.NullEdge.TorusL2LiveWalk
  submission_project: AgentTasks/aristotle-submit/codex-24h-d-torus-l2-transport-20260711-project
  output_dir: AgentTasks/aristotle-output/3f6bb22c-323a-4b3d-9f3a-718a0eeb7355
  status: canceled-local-proof-landed
```

## 2026-07-11 15:22 PDT local completion

All five target proofs were closed locally while the remote project was
running. The full target passed Lean, so the remote task was canceled. The
result was integrated as guarded draft module
`PhysicsSM.Draft.NullEdge.TorusL2LiveWalk`; targeted module build passed.

The exact scope remains fixed `T^3` strong-L2 convergence in the finite product
of four scalar components. The changing-lattice Shannon map and `R^3` Dirac PDE
comparison remain open.
