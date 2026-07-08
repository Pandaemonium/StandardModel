# Aristotle audit job - K2 total assembly next theorem 2026-07-07 23:35 PDT

```yaml
aristotle:
  project_id: a692d71f-f536-4b44-afd7-f33660f69f9a
  task_id: ca4dc9cf-03ac-4a1d-9bba-2ad3e6dc789d
  target_file: PhysicsSM/Draft/NullEdge/GateYM/S1ClosureCurrentAlgebra.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.S1ClosureCurrentAlgebra
  submission_project: none
  output_dir: AgentTasks/aristotle-output/a692d71f-f536-4b44-afd7-f33660f69f9a-extracted/ca4dc9cf-03ac-4a1d-9bba-2ad3e6dc789d_aristotle
  status: harvested
```

Submitted with:

```powershell
aristotle submit (Get-Content -Raw ARISTOTLE_AUDIT_K2_TOTAL_ASSEMBLY_NEXT_2026-07-07_2335.md)
```

## Prompt

You are Aristotle, asked for a source-aware next-theorem audit for K2, not a
full proof attempt.

Context: Codex added a carrier-abstract finite-product bilinear form layer in
`PhysicsSM/Draft/NullEdge/GateYM/S1ClosureCurrentAlgebra.lean`:

```lean
def componentInclusion (i : ι) : V →ₗ[R] (ι → V) where
  toFun v := Pi.single i v

abbrev finiteProductForm (β : ι → LinearMap.BilinForm R V) :
    LinearMap.BilinForm R (ι → V) where
  toFun x := {
    toFun := fun y => ∑ i, β i (x i) (y i) }

theorem finiteProductForm_component_same
    (β : ι → LinearMap.BilinForm R V) (i : ι) (v w : V) :
    finiteProductForm β ((componentInclusion (R := R) i) v)
        ((componentInclusion (R := R) i) w) = β i v w := by
  ...

theorem finiteProductForm_component_ne
    (β : ι → LinearMap.BilinForm R V) {i j : ι} (hij : i ≠ j) (v w : V) :
    finiteProductForm β ((componentInclusion (R := R) i) v)
        ((componentInclusion (R := R) j) w) = 0 := by
  ...

theorem finiteProductForm_assemble_eval
    (β : ι → LinearMap.BilinForm R V) (L : ι → W → V) (x y : W) :
    finiteProductForm β (fun i => L i x) (fun i => L i y)
      = ∑ i, β i (L i x) (L i y) := by
  rfl
```

You already audited this as honest K2-adjacent plumbing, not yet a K2 result.
You recommended the next theorem:

```lean
theorem finiteProductForm_total
    (β : ι → LinearMap.BilinForm R V) (v w : ι → V) :
    finiteProductForm β (∑ i, componentInclusion i (v i))
        (∑ j, componentInclusion j (w j))
      = ∑ i, β i (v i) (w i)
```

with a total-square specialization and a per-component-vanishing corollary.

Request:

1. Confirm the exact statement shape and likely imports/typeclass assumptions
   needed in the real file.
2. Give suggested declaration names for the total lemma, total-square lemma, and
   vanishing corollary.
3. Give the shortest robust Lean proof strategy using the already-landed
   `finiteProductForm_component_same/ne` lemmas, or say if `simp`/`rfl` should
   suffice.
4. Identify any semantic trap in using sums of `componentInclusion` in the
   product space.
5. State the claim boundary for docs after landing these lemmas.

Return sections: statement shape, declarations, proof strategy, semantic traps,
claim boundary.

## Harvested result

Status: complete; downloaded to the `output_dir` above. Main report:
`K2_TOTAL_ASSEMBLY_NEXT_AUDIT.md`; verified proof file:
`RequestProject/S1ClosureCurrentAlgebra.lean`.

Verdict:

- Aristotle reconstructed the landed finite-product form layer and verified the
  next lemmas with no proof holes under Lean 4.28.0.
- Recommended declarations: `finiteProductForm_total`,
  `finiteProductForm_total_square`, and
  `finiteProductForm_total_eq_zero_of_forall`.
- Statement shape needs explicit `(componentInclusion (R := R) i)` inside sums;
  otherwise the module ring can become a stuck metavariable.
- Proof strategy: push sums through the bilinear form with `map_sum`,
  `LinearMap.coe_sum`, and `Finset.sum_apply`; commute sums; use
  `Finset.sum_eq_single`, closing the diagonal with
  `finiteProductForm_component_same` and off-diagonal terms with
  `finiteProductForm_component_ne _ (Ne.symm hj)`.
- Claim boundary: carrier-abstract finite-product bilinear assembly only; not
  concrete current algebra, not the physical carrier's Krein form, not
  positivity, not K2 closure.
