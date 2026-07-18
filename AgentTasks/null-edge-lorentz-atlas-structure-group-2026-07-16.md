# Null-edge Lorentz atlas structure group

Date: 2026-07-16
Work item: `GRAV-GROWING-ATLAS-001`
Claim grade: `M [comp]` for finite matrix/group algebra only

## Objective

Package the matrix predicate `IsEtaLorentz` as a subgroup of
`GL (Fin 4) Real`, lift every eta-preserving graph transition into that group,
and turn the already-proved time and determinant signs into monoid
homomorphisms to `Multiplicative (ZMod 2)`.  Then instantiate the generic Cech
component-obstruction algebra for both characters.

This closes a finite structure-group bridge only.  It does not prove that a
bare graph selects a rank-four sector, that either component class vanishes,
that an `SL(2,C)` spin lift exists, or that discrete curvature converges to
continuum curvature.

## Focused proof target

- Source:
  `AgentTasks/aristotle-standalone/null-edge-lorentz-component-character-20260716/LorentzComponentCharacter/AtlasStructureGroup.lean`
- Context pack:
  `AgentTasks/context-packs/lorentz-atlas-structure-group-20260716-20260716-124932.md`
- The source imports the already-verified focused component-character core.
- Open proof handoff markers cover subgroup inverse closure, the explicit
  eta-adjoint inverse, character packaging, and kernel characterizations.

## Intended production module

`PhysicsSM/Draft/NullEdge/LorentzAtlasStructureGroup.lean`

SHA-256:
`ac03d2415413488564db5b456e5b999d80fc5131c0f09d3e7648a078d152155c`

## Landed finite results

- `etaAdjoint_mul` and `mul_etaAdjoint`: the eta-adjoint
  `eta * M.transpose * eta` is a two-sided inverse of every eta-Lorentz
  matrix.
- `EtaLorentzGroup`: the exact eta-preserving subgroup of `GL(4, Real)`.
- `ofMatrix`: a canonical lift from the matrix predicate into the subgroup,
  with no additional determinant or invertibility hypothesis.
- `timeCharacter` and `determinantCharacter`: monoid homomorphisms from the
  eta-Lorentz group to `Multiplicative (ZMod 2)`.
- `isRestricted_iff_characters_eq_one`: the proper-orthochronous component is
  exactly the simultaneous kernel of the two characters.
- `RestrictedLorentzGroup` bundles that simultaneous kernel as the concrete
  project version of `SO^+(1,3)`, and
  `mem_restrictedLorentzGroup_iff` identifies subgroup membership with the
  existing matrix predicate.
- `timeComponentTransition_isCech` and
  `determinantComponentTransition_isCech`: any exact eta-Lorentz Cech atlas
  induces the two exact component cocycles through the generic obstruction
  algebra.

No production theorem contains a proof handoff marker.  The focused Aristotle
source retains ten such markers because it is the submitted proof task, not a
trusted or production landing.

## Aristotle

```yaml
aristotle:
  project_id: 4c731131-ea72-4590-b7e3-1f2aa63eef4d
  task_id: 3d2a1142-bbdb-4f40-bc31-2e50049ef8a0
  target_file: PhysicsSM/Draft/NullEdge/LorentzAtlasStructureGroup.lean
  expected_module: PhysicsSM.Draft.NullEdge.LorentzAtlasStructureGroup
  submission_project: AgentTasks/aristotle-submit/null-edge-lorentz-atlas-structure-group-20260716-project
  output_dir: AgentTasks/aristotle-output/4c731131-ea72-4590-b7e3-1f2aa63eef4d
  status: harvested
```

## Semantic review checklist

- The subgroup carrier must be exactly `transpose M * eta * M = eta`.
- Multiplication order must match matrix composition and the existing atlas
  convention `T i j * T j k = T i k`.
- The time character uses the sign of the `00` entry; the determinant
  character uses determinant sign.
- Character multiplication is addition in `ZMod 2`, viewed through
  `Multiplicative`.
- No theorem may claim the component classes vanish on graph-derived data.
- Cech transitions remain distinct from connection holonomy.

## Verification log

- The focused source typechecks under the root pinned toolchain with exactly
  ten proof handoff warnings:
  `lake env lean -R AgentTasks/aristotle-standalone/null-edge-lorentz-component-character-20260716 AgentTasks/aristotle-standalone/null-edge-lorentz-component-character-20260716/LorentzComponentCharacter/AtlasStructureGroup.lean`.
- Aristotle project `4c731131-ea72-4590-b7e3-1f2aa63eef4d`, task
  `3d2a1142-bbdb-4f40-bc31-2e50049ef8a0`, was submitted from the focused
  package on 2026-07-16.
- The completed project was harvested to
  `AgentTasks/aristotle-output/4c731131-ea72-4590-b7e3-1f2aa63eef4d`.
  Its returned focused module fills all ten target handoffs without changing
  the declarations and passes
  `lake env lean -R <extracted-project> <extracted-project>/LorentzComponentCharacter/AtlasStructureGroup.lean`
  with no warnings.  The production implementation had already landed
  independently, so the returned source is retained as a corroborating proof
  audit rather than copied over the live module.
- Local production implementation completed independently while Aristotle was
  running:
  `lake env lean PhysicsSM/Draft/NullEdge/LorentzAtlasStructureGroup.lean`
  passed with no warnings.
- Targeted build passed:
  `lake build PhysicsSM.Draft.NullEdge.LorentzAtlasStructureGroup` built 8044
  jobs.  It replayed one pre-existing unused-variable warning in
  `AtlasTransitionHolonomy.lean`; the new module itself was clean.
- Build-enforced axiom guards report only `propext`, `Classical.choice`, and
  `Quot.sound` for the representative eta-inverse, restricted-kernel, and Cech
  corollary theorems.

## Remaining gates

1. Derive a nondegenerate rank-four selected probe sector from the graph.
2. Prove graph-derived overlap transitions have trivial determinant and time
   component classes, or exhibit the obstruction explicitly.
3. Construct and verify the concrete `SL(2,C)` double cover and spin-lift
   obstruction.
4. Separate connection transport from Cech gluing and prove curvature
   convergence.
5. Derive physical stress-energy and Einstein dynamics with constants.
