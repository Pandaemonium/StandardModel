# Aristotle audit job - K2 total-assembly source audit 2026-07-07 23:50 PDT

```yaml
aristotle:
  project_id: fdf500a4-9a3b-4537-ad30-48d5c362fae8
  task_id: 99f8c0fb-4b1d-4eba-8ff2-f57e48f9705f
  target_file: PhysicsSM/Draft/NullEdge/GateYM/S1ClosureCurrentAlgebra.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.S1ClosureCurrentAlgebra
  submission_project: none
  output_dir: AgentTasks/aristotle-output/fdf500a4-9a3b-4537-ad30-48d5c362fae8-extracted/99f8c0fb-4b1d-4eba-8ff2-f57e48f9705f_aristotle
  status: harvested_COMPLETE_WITH_ERRORS_but_substantive_audit_positive
```

Submitted with:

```powershell
aristotle submit (Get-Content -Raw ARISTOTLE_AUDIT_K2_TOTAL_ASSEMBLY_SOURCE_2026-07-07_2350.md)
```

## Prompt

You are Aristotle, asked for a source-aware semantic audit, not a proof attempt.

Context: Codex landed the K2-adjacent abstract finite-product total-assembly
rung after an earlier Aristotle audit recommended it. This is intentionally
carrier-abstract bilinear-form plumbing. It is not full K2, not positivity, not
a concrete Krein-form theorem, and not a site-diagonal defect-Gram theorem.

Please audit the source excerpt below for:

1. Whether the theorem statements actually prove block-diagonal reconstruction
   for the `finiteProductForm` defined here.
2. Whether `finiteProductForm_total_square` and
   `finiteProductForm_total_eq_zero_of_forall` are honest corollaries of
   `finiteProductForm_total`.
3. Whether any theorem silently assumes more than the docstrings claim, or
   whether the docstrings overclaim relative to the kernel statements.
4. Whether the guard pins and observed verification are adequate for this draft
   rung.
5. The best next theorem to ask Aristotle for, if the goal is to bridge this
   abstract finite-product form to the concrete K2 pair-indexed carrier.

Source excerpt:

```lean
noncomputable section FiniteProductForm

variable {ι V R W : Type*} [Fintype ι] [DecidableEq ι]
variable [CommSemiring R] [AddCommMonoid V] [Module R V]

/-- Include one finite-product component into the product target.

This is the algebraic placeholder for a pair block in the K2 direct-sum route.
It does not choose the physical pair index, signs, or carrier normalization. -/
def componentInclusion (i : ι) : V →ₗ[R] (ι → V) where
  toFun v := Pi.single i v
  map_add' := by
    intro v w
    ext j
    by_cases h : j = i
    · subst j
      simp
    · simp [Pi.single_eq_of_ne h]
  map_smul' := by
    intro a v
    ext j
    by_cases h : j = i
    · subst j
      simp
    · simp [Pi.single_eq_of_ne h]

/-- The finite orthogonal-product bilinear form with component forms `β i`.

For K2 this is the carrier-abstract form-level object whose off-diagonal
orthogonality is proved below. It is not a positivity structure and is not yet
the concrete null-edge carrier's Krein form. -/
abbrev finiteProductForm (β : ι → LinearMap.BilinForm R V) :
    LinearMap.BilinForm R (ι → V) where
  toFun x := {
    toFun := fun y => ∑ i, β i (x i) (y i)
    map_add' := by
      intro y z
      simp [Pi.add_apply, map_add, Finset.sum_add_distrib]
    map_smul' := by
      intro a y
      simp [Pi.smul_apply, map_smul, Finset.mul_sum] }
  map_add' := by
    intro x y
    ext z
    simp [Pi.add_apply, map_add, Finset.sum_add_distrib]
  map_smul' := by
    intro a x
    ext z
    simp [Pi.smul_apply, map_smul, Finset.mul_sum]

/-- A component inclusion is isometric for the matching component form.

This is a finite-product form identity only; it does not identify the component
with a physical closure-current block. -/
theorem finiteProductForm_component_same
    (β : ι → LinearMap.BilinForm R V) (i : ι) (v w : V) :
    finiteProductForm β ((componentInclusion (R := R) i) v)
        ((componentInclusion (R := R) i) w) = β i v w := by
  classical
  simp only [finiteProductForm, componentInclusion, LinearMap.coe_mk, AddHom.coe_mk]
  rw [Finset.sum_eq_single i]
  · simp
  · intro j _ hji
    simp [Pi.single_eq_of_ne hji]
  · intro hi
    exact False.elim (hi (Finset.mem_univ i))

/-- Distinct component inclusions are orthogonal for `finiteProductForm`.

This is the precise no-cross-term algebraic fact needed before the K2
pair-stabilized direct-sum route can be instantiated on a concrete carrier. -/
theorem finiteProductForm_component_ne
    (β : ι → LinearMap.BilinForm R V) {i j : ι} (hij : i ≠ j) (v w : V) :
    finiteProductForm β ((componentInclusion (R := R) i) v)
        ((componentInclusion (R := R) j) w) = 0 := by
  classical
  simp only [finiteProductForm, componentInclusion, LinearMap.coe_mk, AddHom.coe_mk]
  apply Finset.sum_eq_zero
  intro k _
  by_cases hki : k = i
  · subst k
    simp [Pi.single_eq_of_ne hij]
  · simp [Pi.single_eq_of_ne hki]

/-- Evaluating the finite-product form on an assembled family is the sum of
component evaluations.

This is the abstract form-level version of "the square of the assembled
pair-current is the sum of pair squares" once the carrier supplies the actual
component forms and maps. -/
theorem finiteProductForm_assemble_eval
    (β : ι → LinearMap.BilinForm R V) (L : ι → W → V) (x y : W) :
    finiteProductForm β (fun i => L i x) (fun i => L i y)
      = ∑ i, β i (L i x) (L i y) := by
  rfl

/-- Reassembling both arguments from component inclusions recovers the component
sum for the finite-product form.

This is carrier-abstract bilinear-form plumbing: it proves block-diagonal total
assembly for `finiteProductForm`. It is not yet a concrete closure-current or
Krein-form theorem. -/
theorem finiteProductForm_total
    (β : ι → LinearMap.BilinForm R V) (v w : ι → V) :
    finiteProductForm β (∑ i, (componentInclusion (R := R) i) (v i))
        (∑ j, (componentInclusion (R := R) j) (w j))
      = ∑ i, β i (v i) (w i) := by
  simp only [map_sum, LinearMap.coe_sum, Finset.sum_apply]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  rw [Finset.sum_eq_single i]
  · rw [finiteProductForm_component_same]
  · intro j _ hj
    rw [finiteProductForm_component_ne _ (Ne.symm hj)]
  · simp

/-- Total-square specialization of `finiteProductForm_total`. -/
theorem finiteProductForm_total_square
    (β : ι → LinearMap.BilinForm R V) (v : ι → V) :
    finiteProductForm β (∑ i, (componentInclusion (R := R) i) (v i))
        (∑ j, (componentInclusion (R := R) j) (v j))
      = ∑ i, β i (v i) (v i) :=
  finiteProductForm_total β v v

/-- If every component pairing vanishes, then the assembled total pairing
vanishes. -/
theorem finiteProductForm_total_eq_zero_of_forall
    (β : ι → LinearMap.BilinForm R V) (v w : ι → V)
    (h : ∀ i, β i (v i) (w i) = 0) :
    finiteProductForm β (∑ i, (componentInclusion (R := R) i) (v i))
        (∑ j, (componentInclusion (R := R) j) (w j)) = 0 := by
  rw [finiteProductForm_total]
  exact Finset.sum_eq_zero (fun i _ => h i)

end FiniteProductForm
```

Guard pins in `SlabAxiomGuard.lean`:

```lean
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1ClosureCurrentAlgebra.finiteProductForm_total
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1ClosureCurrentAlgebra.finiteProductForm_total_square
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1ClosureCurrentAlgebra.finiteProductForm_total_eq_zero_of_forall
```

Observed commands:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/S1ClosureCurrentAlgebra.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.S1ClosureCurrentAlgebra
lake env lean PhysicsSM/Draft/NullEdge/GateYM/SlabAxiomGuard.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.SlabAxiomGuard
lake build PhysicsSM.Draft.NullEdge.GateYM
pre-commit run --files PhysicsSM/Draft/NullEdge/GateYM/S1ClosureCurrentAlgebra.lean PhysicsSM/Draft/NullEdge/GateYM/SlabAxiomGuard.lean NULL_EDGE_RESULTS.md Sources/Null_Edge_QCD_Mass_Roadmap_2026-07-07.md
```

Return concise sections: verdict, statement audit, overclaim guard,
guard/verification audit, next theorem.

## Harvest

Aristotle returned `COMPLETE_WITH_ERRORS`, but the visible response is a
substantive source-aware semantic audit rather than an objection.

Verdict:

- The finite-product total-assembly rung is honest and correctly scoped.
- `finiteProductForm_total` really proves block-diagonal reconstruction for
  `finiteProductForm`; `finiteProductForm_total_square` and
  `finiteProductForm_total_eq_zero_of_forall` are faithful corollaries.
- The docstrings do not overclaim: no positivity, no concrete carrier Krein
  form, and no full K2 claim is hidden in the statements.

Follow-up guidance:

- Keep the abstract rung as-is.
- Optional guard strengthening: pin `finiteProductForm_component_ne` directly.
  This was already present in `SlabAxiomGuard.lean` when harvested.
- Next concrete bridge: formulate a pullback/congruence theorem saying that a
  concrete pair-current form equal to the pullback of `finiteProductForm`
  inherits total assembly and off-diagonal vanishing. Then instantiate with the
  physical pair index, signs, component forms, and 4-slot normalization.
