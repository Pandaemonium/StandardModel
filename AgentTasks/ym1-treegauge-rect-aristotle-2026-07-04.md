# Aristotle job: YM1 comb-gauge plaquette coordinatization of the 2D rectangle (2026-07-04)

```yaml
aristotle:
  project_id: 1d9b5b19-bbd4-4d29-9c15-1ee08156ec95
  target_file: Ym1TreeGauge/RectCoordinatization.lean
  expected_module: Ym1TreeGauge
  submission_project: AgentTasks/aristotle-submit/ym1-treegauge-rect-20260704-project
  source_root: AgentTasks/aristotle-standalone/ym1-treegauge-rect-20260704
  prompt: AgentTasks/aristotle-prompts/ym1-treegauge-rect.prompt.md
  status: SUBMITTED
```

## Target

Construct `rectCoordinatization (Lx Ly : N) (G) [Group G] [Fintype G] :
PlaquetteCoordinatization (rectLattice Lx Ly) G (rectPlaquette Lx Ly)
(RectTree Lx Ly)` - the comb-gauge change of variables on the `Lx x Ly`
open rectangle: link fields equivalent to (plaquette holonomies) x (tree
link values), tree = all horizontal links + leftmost vertical column.

This is the last geometric layer of finite-G freeze Theorem 2. The generic
consequences are already kernel-checked in
`PhysicsSM/Draft/NullEdge/GateYM/TreeGaugeBridge.lean`
(`wilson_link_loop_expectation_area_law`): once this instance exists, the
link-ensemble Wilson expectation of the ordered in-region plaquette-holonomy
product is exactly `chi_R(1) * gamma^m` on the concrete lattice.

Conventions in the package are pinned by the kernel-checked `rfl` lemma
`rectPlaquette_hol_formula` (counterclockwise plaquette, right-nested
holonomy, `Sum.inl` horizontal / `Sum.inr` vertical). Skeleton verified
locally: `lake env lean` passes with exactly the one intended documented
`s o r r y`.

Designed-in easy path given in the prompt: forward map = (holonomies, tree
restriction), making `hol_coord` definitional; content = bijectivity via
per-row `Fin.induction` injectivity + cardinality count. Explicit fallback
authorized: `Lx = 1` single-column case, labeled as such.

## Harvest checklist (on completion)

1. `aristotle show 1d9b5b19-bbd4-4d29-9c15-1ee08156ec95` and pull the
   completed file.
2. Semantic-alignment review: conventions unchanged, `rectPlaquette_hol_formula`
   intact, no added hypotheses, no statement weakening; axiom audit
   at most `[propext, Classical.choice, Quot.sound]`.
3. Integrate as `PhysicsSM/Draft/NullEdge/GateYM/RectTreeGauge.lean`
   (renaming `Ym1TreeGauge` defs into the `GateYM` namespaces, replacing the
   copied interface defs with imports of `GaugeCoreGeneral`/`PlaquetteCore`/
   `TreeGaugeBridge`), then instantiate
   `TreeGaugeBridge.wilson_link_loop_expectation_area_law` on the rectangle.
4. Remaining after harvest: the boundary-circuit lasso identification
   (`chi(hol boundary) = chi(orderedProd of enclosed plaquette holonomies)`
   for a comb-compatible ordering) - a SECOND job, deliberately out of this
   one's scope.
