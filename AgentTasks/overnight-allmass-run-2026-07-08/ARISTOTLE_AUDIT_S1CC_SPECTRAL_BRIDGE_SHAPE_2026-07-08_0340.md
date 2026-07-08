# Aristotle audit job - S1-CC spectral-bridge theorem shape 2026-07-08 03:40 PDT

```yaml
aristotle:
  project_id: 53266dc6-04f2-4729-b8b2-e555334d5e23
  task_id: ef4606ba-4ba4-4af8-91eb-ef716a921bd9
  target_file: PhysicsSM/Draft/NullEdge/GateYM/S1CCBalancedInertia.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia
  submission_project: none
  output_dir: AgentTasks/aristotle-output/53266dc6-04f2-4729-b8b2-e555334d5e23-extracted/ef4606ba-4ba4-4af8-91eb-ef716a921bd9_aristotle
  status: complete
```

Submitted with:

```powershell
aristotle submit (Get-Content -Raw ARISTOTLE_AUDIT_S1CC_SPECTRAL_BRIDGE_SHAPE_2026-07-08_0340.md)
```

## Harvest

Status: COMPLETE, harvested 2026-07-08 05:54 PDT.

Artifact archive:
`AgentTasks/aristotle-output/53266dc6-04f2-4729-b8b2-e555334d5e23.tar.gz`.
Extracted output:
`AgentTasks/aristotle-output/53266dc6-04f2-4729-b8b2-e555334d5e23-extracted/ef4606ba-4ba4-4af8-91eb-ef716a921bd9_aristotle/`.

Verdict: Aristotle independently confirmed the theorem shape and also proved a
self-contained Mathlib-only bridge. It recommends keeping the two-layer local
shape: the multiset bridge
`hermitian_eigenvalue_multiset_map_neg_eq_of_neg_charpoly` plus the final count
theorem `hermitian_balanced_count_of_neg_charpoly`. The key proof lesson is to
work through roots multisets, not a pointwise eigenvalue-ordering statement.

New reusable suggestion: a general roots lemma
`charpoly_roots_neg : (-B).charpoly.roots = B.charpoly.roots.map Neg.neg`.
The local repo currently has the target-specific bridge landed and
guard-pinned; this general lemma is a possible later cleanup, not a prerequisite
for the manuscript claim.

Audit warning: do not state a pointwise negation theorem for
`Matrix.IsHermitian.eigenvalues`; the ordering is arbitrary and such a theorem
would be false in general. The honest claim is multiset-level negation symmetry
and equal strict positive/negative counts. Zeros are excluded from both counts.

## Prompt

You are Aristotle, asked for a theorem-shape audit and proof-plan triage. Do not
try to over-formalize the physics. We need the smallest honest Lean bridge from
the already-landed charpoly rung to the already-landed finite count helper.

Available landed declarations in
`PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia`:

```lean
theorem anticonj_charpoly_eq (B S : Matrix n n ℂ) [Invertible S]
    (h : ⅟S * B * S = -B) : (-B).charpoly = B.charpoly

theorem card_pos_eq_card_neg_of_multiset_map_neg_eq {m : Type*} [Fintype m]
    (f : m → ℝ)
    (h : (Finset.univ.val.map f).map Neg.neg = Finset.univ.val.map f) :
    (Finset.univ.filter (fun i => 0 < f i)).card =
      (Finset.univ.filter (fun i => f i < 0)).card
```

Relevant Mathlib API observed by Codex:

```lean
noncomputable def Matrix.IsHermitian.eigenvalues
    {A : Matrix n n 𝕜} (hA : A.IsHermitian) : n → ℝ

lemma Matrix.IsHermitian.charpoly_eq :
    A.charpoly = ∏ i, (Polynomial.X - Polynomial.C (hA.eigenvalues i : 𝕜))

lemma Matrix.IsHermitian.roots_charpoly_eq_eigenvalues :
    A.charpoly.roots =
      Multiset.map (RCLike.ofReal ∘ hA.eigenvalues) Finset.univ.val

lemma Matrix.IsHermitian.eigenvalues_eq_eigenvalues_iff :
    hA.eigenvalues = hB.eigenvalues ↔ A.charpoly = B.charpoly
```

Candidate theorem shape:

```lean
theorem hermitian_eigenvalue_multiset_map_neg_eq_of_neg_charpoly
    {n : Type*} [Fintype n] [DecidableEq n]
    (B : Matrix n n ℂ) (hB : B.IsHermitian)
    (hsym : (-B).charpoly = B.charpoly) :
    (Finset.univ.val.map hB.eigenvalues).map Neg.neg =
      Finset.univ.val.map hB.eigenvalues := by
  -- likely route: compare `(-B)` eigenvalues with `B` eigenvalues using
  -- `eigenvalues_eq_eigenvalues_iff`, then prove eigenvalues of `-B` are the
  -- negated eigenvalues of `B`, or work through roots directly.
```

Then the final count theorem would be:

```lean
theorem hermitian_balanced_count_of_neg_charpoly
    {n : Type*} [Fintype n] [DecidableEq n]
    (B : Matrix n n ℂ) (hB : B.IsHermitian)
    (hsym : (-B).charpoly = B.charpoly) :
    (Finset.univ.filter (fun i => 0 < hB.eigenvalues i)).card =
      (Finset.univ.filter (fun i => hB.eigenvalues i < 0)).card :=
  card_pos_eq_card_neg_of_multiset_map_neg_eq hB.eigenvalues
    (hermitian_eigenvalue_multiset_map_neg_eq_of_neg_charpoly B hB hsym)
```

Audit questions:

1. Is this the right theorem shape, or is there a better Mathlib-native
   statement?
2. Is the candidate true as stated despite `Matrix.IsHermitian.eigenvalues`
   being an arbitrary ordered indexing of eigenvalues?
3. What lemma about eigenvalues of `-B` is needed, and is it already likely in
   Mathlib?
4. Would a roots-multiset statement avoid ordering/indexing pitfalls better?
5. Should the proof-focused Aristotle job target the multiset bridge, the final
   count theorem, or both?

Return concise sections: verdict, theorem-shape correction, proof route, likely
Mathlib lemmas, proof-focused job recommendation, risks.
