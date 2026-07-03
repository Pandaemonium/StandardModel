# Provenance

This package was extracted from `C:/Projects/StandardModel` on 2026-07-01.

The Lean files are copied from these source modules:

- `PhysicsSM/Spinor/PluckerMass.lean`
- `PhysicsSM/Spinor/TwistorPluckerMass.lean`
- `PhysicsSM/NullStrand/Conventions.lean`
- `PhysicsSM/NullStrand/FiniteCore.lean`
- `PhysicsSM/NullStrand/DualSolder/*.lean`
- `PhysicsSM/Draft/NullEdgeDiracSlashCore.lean`
- `PhysicsSM/Draft/NullEdgeBundleDiracPluckerCore.lean`
- `PhysicsSM/Draft/NullEdgeFiniteTetradPostulate.lean`
- `PhysicsSM/Draft/NullEdgeSuperDiracMassShellBridge.lean`
- `PhysicsSM/Draft/Checkerboard1D.lean`
- selected Gate C audit modules under `PhysicsSM/Draft/`

The scope is anchored by:

- `docs/NULLSTRAND.md` in the parent repo;
- `NULL_EDGE_RESULTS.md` in the parent repo;
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`;
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`;
- task notes under `AgentTasks/` for Gate C and Wilson/projected release audits.
- Aristotle project `b1558b4a-ab97-4522-a6d5-16f9862dc2b6`, returned on
  2026-07-01; its evaluation is copied into
  `docs/ARISTOTLE_EVALUATION.md`.
- Aristotle checkerboard project `d3d18bbc-13e9-4ffb-9f39-a151055488d9`, task
  `1298d6d3-9732-482c-8c78-84641c443b50`, returned on 2026-07-01; its finite
  path-sum layer is integrated into `PhysicsSM/Draft/Checkerboard1D.lean` and
  summarized in `docs/CHECKERBOARD_ARISTOTLE_REPORT.md`.
- Aristotle checkerboard remaining-targets project
  `52a66ff8-7b3c-4ef9-bb4d-397541a5c727`, task
  `dff7ce5d-f551-4056-80bd-f910d094e709`, returned on 2026-07-01; its
  reverse-turn, tuple/list bridge, and isotropic unitarity layer is integrated
  into `PhysicsSM/Draft/Checkerboard1D.lean`.
- Aristotle hyperdiamond project `b347d197-c5f4-4289-a07e-a90447c2d020`, task
  `99bc83d2-4022-4835-91b3-8259b7963cd6`, returned on 2026-07-01; its
  per-branch bare-symbol no-go layer is integrated into
  `PhysicsSM/Draft/NullEdgeHyperdiamondNoGo.lean` and summarized in
  `docs/HYPERDIAMOND_NOGO_ARISTOTLE_REPORT.md`.
- Aristotle hyperdiamond bridge project `359b4428-8c43-4f89-b43d-07815dbfb3a6`,
  task `d9b0e9a0-1928-49e0-8e53-826c521427b9`, returned on 2026-07-01; its
  frame/covector bridge, represented-data Nielsen-Ninomiya ledger, and
  `chiralProj` idempotence layer is integrated into
  `PhysicsSM/Draft/NullEdgeHyperdiamondBridge.lean` and summarized in
  `docs/HYPERDIAMOND_BRIDGE_REPORT.md`.
- Aristotle checkerboard generator-expansion project
  `b50db3dd-7395-46fd-924f-c75e62638d21`, task
  `212e5c96-f926-42a4-a02a-b0e6f16ff340`, returned on 2026-07-02; its
  arbitrary-angle derivative theorem is integrated into
  `PhysicsSM/Draft/CheckerboardContinuumScaffold.lean`.
- Aristotle hyperdiamond pole-structure project
  `b9d659b1-e7fd-4c2b-ad2f-406b2722a6ab`, task
  `9428dd68-3a54-4143-badd-f35c220e956c`, returned on 2026-07-02; its
  source-side pole predicates and source-independent no-four-edge theorem are
  integrated into `PhysicsSM/Draft/NullEdgeHyperdiamondOperatorScaffold.lean`.
- Aristotle checkerboard remainder-estimates project
  `1286560f-0f6c-4b3a-9376-8f97ec7ff08c`, task
  `b56f3daf-9d43-410b-8d5d-234b655ae421`, returned on 2026-07-02; its scalar
  and entrywise quotient/asymptotic estimates are integrated into
  `PhysicsSM/Draft/CheckerboardContinuumScaffold.lean`.
- Checkerboard and hyperdiamond orientation references listed in
  `docs/CHECKERBOARD_1D.md` and `docs/HYPERDIAMOND_CROSSWALK.md`.
- Gate C claim labels and represented-vs-missing assumptions are tracked in
  `docs/GATE_C_ASSUMPTION_LEDGER.md`.
- Active next-theorem and integration planning lives in
  `docs/NEXT_THEOREMS.md` and `docs/ARISTOTLE_INTEGRATION_SLOTS.md`.
- Checkerboard literature review and continuum-scaffold source orientation
  lives in `docs/CHECKERBOARD_LITERATURE_REVIEW.md`.

The extraction keeps original namespaces and theorem names to make comparison
against the parent repository direct.
