# Aristotle task: final exact exterior-action kernel composition

Status: landed locally while Aristotle was running; exact target compiles with
no handoff markers. Aristotle remains review-only if it returns a different
proof.

Target:
`AgentTasks/aristotle-targets/codex_24h_jc_exact_exterior_kernel_composition.lean`.

Close every proof hole without weakening a statement or adding assumptions.
The generic exterior-minor lemma and full-action-to-degree-two reduction are
already proof-complete. The pure block theorem is landed and imported.

The remaining mathematical hinge is `star_relation`: apply
`exteriorSquare_minor_relation` to one weak and one color coordinate of the
block-diagonal `generationActLinear`; the cross terms vanish and the direct
minor is exactly the displayed block product. The image-block and target-unit
lemmas should be definitional/simp reductions through the trusted product-cover
API. Run the target first.

Required controls are the explicit six-element positive family and the
outside-family nontriviality theorem. Scope is the algebraic true product cover
only: no topology, smooth Lie groups, Jordan-derived split, Furey intertwiner,
chirality, or physics dynamics.

```yaml
aristotle:
  project_id: 63facda3-fcd6-487f-af95-7d0d6a43cf2d
  target_file: AgentTasks/aristotle-targets/codex_24h_jc_exact_exterior_kernel_composition.lean
  expected_module: PhysicsSM.Draft.JordanCliffordExactExteriorKernel
  submission_project: AgentTasks/aristotle-submit/codex-24h-jc-exact-exterior-composition-20260711-project
  output_dir: AgentTasks/aristotle-output/63facda3-fcd6-487f-af95-7d0d6a43cf2d
  status: submitted
```
