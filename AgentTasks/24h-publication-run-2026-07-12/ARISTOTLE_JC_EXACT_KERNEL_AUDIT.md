# Hostile semantic audit: exact algebraic exterior-action kernel

Review only. Do not edit Lean source.

Audit the uploaded live source
`PhysicsSM/Draft/JordanCliffordExactExteriorKernel.lean` together with its two
local predecessors. The intended reading is narrowly this:

> On the true algebraic `U(1) x SU(2) x SU(3)` product-cover domain, acting on
> the repository's supplied `C^2 + C^3` carrier and its even exterior degrees
> `0,2,4`, the complete sixteen-state action is identity exactly for the six
> standard covering-kernel elements.

Check, adversarially:

1. vacuity and witness existence on both sides of the iff;
2. whether `exteriorSquare_minor_relation` and `star_relation` really extract
   the mixed weak/color Kronecker identity from the degree-two action;
3. whether determinant-one and common phase hypotheses are used rather than
   decorative;
4. whether `blockUnits_eq_one_of_blocks` identifies the intended trusted image;
5. theorem statement stability and axiom footprint;
6. every stronger reading that is forbidden: no smooth/topological group
   theorem, no Jordan derivation of the `2+3` split, no Furey-module
   intertwiner, no chirality or dynamics claim.

Return PASS, PASS WITH REQUIRED SCOPE EDITS, or FAIL. Quote exact declaration
names and give manuscript-safe wording plus the strongest overclaim to ban.

```yaml
aristotle:
  project_id: 3347f240-3a7e-490d-a514-dcc61c6c3349
  task_id: 12c040ee-2813-4d5e-b0de-a202f0c27650
  target_file: PhysicsSM/Draft/JordanCliffordExactExteriorKernel.lean
  expected_module: review-only
  output_dir: AgentTasks/aristotle-output/3347f240-3a7e-490d-a514-dcc61c6c3349
  status: PASS WITH REQUIRED SCOPE EDITS; build-wiring already satisfied live, cosmetic binder fix applied
```
