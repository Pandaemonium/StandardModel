# Aristotle audit job - S1-CC count helper source 2026-07-08 03:40 PDT

```yaml
aristotle:
  project_id: c45cba26-f069-4653-a7aa-416940b6666b
  task_id: 1ecab266-5f4c-48c6-980a-8d4398e15ca2
  target_file: PhysicsSM/Draft/NullEdge/GateYM/S1CCBalancedInertia.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia
  submission_project: none
  output_dir: AgentTasks/aristotle-output/c45cba26-f069-4653-a7aa-416940b6666b-extracted/1ecab266-5f4c-48c6-980a-8d4398e15ca2_aristotle
  status: harvested_COMPLETE_WITH_ERRORS_but_substantive_audit_positive
```

Submitted with:

```powershell
aristotle submit (Get-Content -Raw ARISTOTLE_AUDIT_S1CC_COUNT_HELPER_SOURCE_2026-07-08_0340.md)
```

## Prompt

You are Aristotle, asked for a source-aware semantic audit, not a proof attempt.

Context: after your S1-CC audit, Codex softened two trace-theorem docstrings and
landed the pure finite count helper for the balanced-inertia capstone. The
helper is intentionally not the Hermitian spectral bridge; it only says that
negation-invariant real multisets / finite indexed families have equal positive
and negative counts.

Please audit whether the source below:

1. proves the advertised finite combinatorial statement;
2. has the right statement shape for use after the Hermitian eigenvalue multiset
   is proved negation-invariant;
3. avoids overclaim about charpoly, eigenvalues, inertia, or positivity;
4. has adequate guard pins.

Source excerpt:

```lean
/-! ## Count helper for the balanced-inertia capstone -/

/-- A real multiset invariant under negation has as many positive entries as
negative entries, counted with multiplicity.

This is the finite combinatorial half of the balanced-inertia capstone. The
remaining spectral bridge is to prove that the Hermitian eigenvalue multiset is
negation-invariant from the characteristic-polynomial symmetry. -/
theorem countP_pos_eq_countP_neg_of_map_neg_eq (s : Multiset ℝ)
    (h : s.map Neg.neg = s) :
    s.countP (fun x => 0 < x) = s.countP (fun x => x < 0) := by
  calc
    s.countP (fun x => 0 < x) = (s.map Neg.neg).countP (fun x => 0 < x) := by
      rw [h]
    _ = s.countP (fun x => 0 < -x) := by
      rw [Multiset.countP_map]
      simp [Multiset.countP_eq_card_filter]
    _ = s.countP (fun x => x < 0) := by
      apply Multiset.countP_congr rfl
      intro x _
      simp

/-- Index-count form of `countP_pos_eq_countP_neg_of_map_neg_eq`.

If the multiset of real values indexed by a finite type is invariant under
negation, the number of positive indexed values equals the number of negative
indexed values. This matches the count shape needed for Hermitian eigenvalues. -/
theorem card_pos_eq_card_neg_of_multiset_map_neg_eq {m : Type*} [Fintype m]
    (f : m → ℝ)
    (h : (Finset.univ.val.map f).map Neg.neg = Finset.univ.val.map f) :
    (Finset.univ.filter (fun i => 0 < f i)).card =
      (Finset.univ.filter (fun i => f i < 0)).card := by
  have hm := countP_pos_eq_countP_neg_of_map_neg_eq (Finset.univ.val.map f) h
  have hpos : (Finset.univ.filter (fun i => 0 < f i)).card =
      (Finset.univ.val.map f).countP (fun x => 0 < x) := by
    rw [Multiset.countP_eq_card_filter, Multiset.filter_map]
    change (Finset.univ.filter (fun i => 0 < f i)).val.card = _
    rw [Finset.filter_val]
    simp
  have hneg : (Finset.univ.filter (fun i => f i < 0)).card =
      (Finset.univ.val.map f).countP (fun x => x < 0) := by
    rw [Multiset.countP_eq_card_filter, Multiset.filter_map]
    change (Finset.univ.filter (fun i => f i < 0)).val.card = _
    rw [Finset.filter_val]
    simp
  rw [hpos, hneg]
  exact hm
```

Guard pins in `SlabAxiomGuard.lean`:

```lean
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia.countP_pos_eq_countP_neg_of_map_neg_eq
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia.card_pos_eq_card_neg_of_multiset_map_neg_eq
```

Observed verification:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/S1CCBalancedInertia.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.SlabAxiomGuard
```

Return concise sections: verdict, statement audit, overclaim guard, guard audit,
next bridge theorem.

## Harvest

Aristotle returned `COMPLETE_WITH_ERRORS`, but the visible response is a
substantive positive source-aware audit.

Verdict:

- The two count-helper theorems are correct, compile, and are honestly scoped.
- Aristotle independently re-elaborated the excerpt and confirmed the expected
  standard axiom footprint.
- The strict-sign count shape is right: zeros are excluded on both sides, so the
  theorem gives `n_+ = n_-` but says nothing about nullity.

Follow-up:

- Codex subsequently landed the spectral bridge and final finite Hermitian count
  theorem, while keeping the physical `J Q_C` and `V'/N` identification separate.
