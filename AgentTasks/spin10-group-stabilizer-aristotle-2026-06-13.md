# Aristotle task: Spin(10) Group Stabilizers and Selector Theorem

Date: 2026-06-13

## Goal

Fill the `sorry` targets in:

```text
PhysicsSM/Draft/Spin10StabilizerGroup.lean
```

targeting:

- `evenCliffordGroup_transitive_on_krasnov_pairs`
- `standard_pair_stabilizer_isomorphic_to_sm`
- `physical_embedding_selected_by_krasnov_pair`

## Mathematical Intent

1. **Transitivity**: Prove that the general algebraic even Clifford group (`evenCliffordGroup`) acts transitively on collinear pure-spinor pairs `(ψ₁, [ψ₂])` with intersection dimension `d = 3`.
2. **Normal-form stabilizer**: Establish that the joint mixed marked/projective stabilizer of the standard collinear pair `(vacuumSpinor, weakSpinor)` is isomorphic to the Standard Model gauge group `StandardModelGaugeGroup` (from `PhysicsSM.Draft.ExceptionalJordanProjectiveGeometry`).
3. **Selector Theorem**: Show that the physical embedding class is the unique conjugacy class in `evenCliffordGroup` stabilizing a Krasnov pair of pure spinors.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, and no `native_decide` in the final proof.
- Keep conventions explicit.
- Helper lemmas welcome.

## Verification

```bash
lake env lean PhysicsSM/Draft/Spin10StabilizerGroup.lean
```

Axiom check on finished targets: only standard Mathlib axioms.

## Submission

```yaml
aristotle:
  job_id: 050fa92c-48e0-4f22-83c8-991db8424876
  target_file: PhysicsSM/Draft/Spin10StabilizerGroup.lean
  expected_module: PhysicsSM.Draft.Spin10StabilizerGroup
  submission_project: AgentTasks/aristotle-submit/spin10-group-stabilizer-20260613-project
  output_dir: AgentTasks/aristotle-output/050fa92c-48e0-4f22-83c8-991db8424876
  status: out_of_budget

```
