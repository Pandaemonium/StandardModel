# Aristotle audit job - K2 finite-product form plumbing 2026-07-07 23:12 PDT

```yaml
aristotle:
  project_id: d8c051bf-0edb-4d73-ab46-4faa442ddfc4
  task_id: 51dbc881-39f4-4076-ae99-51752cf74d59
  target_file: PhysicsSM/Draft/NullEdge/GateYM/S1ClosureCurrentAlgebra.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.S1ClosureCurrentAlgebra
  submission_project: none
  output_dir: AgentTasks/aristotle-output/d8c051bf-0edb-4d73-ab46-4faa442ddfc4-extracted/51dbc881-39f4-4076-ae99-51752cf74d59_aristotle
  status: harvested
```

Submitted with:

```powershell
aristotle submit (Get-Content -Raw ARISTOTLE_AUDIT_K2_FORM_PLUMBING_2026-07-07_2312.md)
```

## Prompt

You are Aristotle, asked for a source-aware semantic audit, not a proof attempt.

Context: after your audit downgraded `closure_current_square_pi` to pointwise
plumbing, Codex added a small finite-product bilinear-form layer and a concrete
non-vacuity witness. Please audit whether this is honest K2 progress and what
exact next theorem should follow.

New source snippets from
`PhysicsSM/Draft/NullEdge/GateYM/S1ClosureCurrentAlgebra.lean`:

```lean
/-- Include one finite-product component into the product target.

This is the algebraic placeholder for a pair block in the K2 direct-sum route.
It does not choose the physical pair index, signs, or carrier normalization. -/
def componentInclusion (i : ι) : V →ₗ[R] (ι → V) where
  toFun v := Pi.single i v

/-- The finite orthogonal-product bilinear form with component forms `β i`.

For K2 this is the carrier-abstract form-level object whose off-diagonal
orthogonality is proved below. It is not a positivity structure and is not yet
the concrete null-edge carrier's Krein form. -/
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

Non-vacuity snippets:

```lean
def witnessI : GaussianInt := ⟨0, 1⟩
def witnessC1 : Matrix (Fin 2) (Fin 2) GaussianInt := !![1, witnessI; witnessI, -1]
def witnessC2 : Matrix (Fin 2) (Fin 2) GaussianInt := !![1, -witnessI; -witnessI, -1]
theorem witnessC1_square : witnessC1 * witnessC1 = 0 := by decide
theorem witnessC2_square : witnessC2 * witnessC2 = 0 := by decide
theorem witnessC1_mul_C2_ne_C2_mul_C1 : witnessC1 * witnessC2 ≠ witnessC2 * witnessC1 := by decide
```

Guard footprints observed:

```text
finiteProductForm_component_same/ne/assemble_eval: [propext, Classical.choice, Quot.sound]
witnessC1_square/witnessC2_square/witnessC1_mul_C2_ne_C2_mul_C1: [propext, Classical.choice, Quot.sound]
```

Commands Codex ran and observed passing:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/S1ClosureCurrentAlgebra.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.S1ClosureCurrentAlgebra
lake env lean PhysicsSM/Draft/NullEdge/GateYM/SlabAxiomGuard.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.SlabAxiomGuard
```

Request:

1. Verdict first: should this be classified as honest K2 progress, plumbing, or
   too thin to count?
2. Are the theorem statements semantically aligned with the claim "abstract
   finite-product form orthogonality for component inclusions"?
3. Is the non-vacuity witness relevant and correctly bounded?
4. What should the exact next Lean theorem be: total current square under an
   orthogonal inclusion hypothesis, concrete pair index, or carrier
   normalization?
5. List any prose still forbidden around this result.

Return concise sections: verdict, statement audit, witness audit, next theorem,
forbidden prose.

## Harvested result

Status: complete; downloaded to the `output_dir` above. Main file:
`AUDIT_K2_FORM_PLUMBING.md`.

Verdict:

- Honest K2-adjacent plumbing / carrier-abstract infrastructure, not yet a K2
  result. Safe to keep and build on, but it does not touch the physical carrier,
  Krein form, positivity, pair index, signs, or actual closure-current square.
- The statement "abstract finite-product form orthogonality for component
  inclusions" is semantically aligned. `finiteProductForm_component_ne` is the
  real orthogonality content; `finiteProductForm_assemble_eval` is only an
  unfolding convenience.
- The Gaussian-integer witness is relevant and bounded: it proves noncommuting
  square-zero examples exist, not that the physical carrier or form has been
  realized.
- Next theorem should be the carrier-abstract total assembly lemma:
  `finiteProductForm_total`, followed by a total-square specialization and a
  per-component-vanishing corollary.
- Do not yet jump to concrete pair index, carrier normalization, or positivity.
  Forbidden prose: no "carrier Krein form", "metric", "positive", "K2 closed",
  "physical current", "gauge closure realized", or similar physics-language
  promotion around these lemmas.
