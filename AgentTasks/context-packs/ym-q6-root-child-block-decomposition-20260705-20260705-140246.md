# Aristotle semantic context pack

Generated: 2026-07-05T14:03:06
Query: `Q6 pairSum_le_expBound root deletion treeRootChildBlock disjoint block decomposition finite connected components fiber count`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgeP9DiamondLocalSeparation.lean` [jointDegreeCount]

Score: `0.757`

```text
def jointDegreeCount (R : Fin 6 -> Fin 6 -> Prop) [DecidableRel R]
    (i o : Nat) : Nat :=
  (Finset.univ.filter fun a : Fin 6 => inDegree R a = i /\ outDegree R a = o).card
```

### 2. `PhysicsSM/Draft/NullEdgeP9OperationalGap.lean` [jointDegreeCount]

Score: `0.757`

```text
def jointDegreeCount (R : Fin 6 -> Fin 6 -> Prop) [DecidableRel R]
    (i o : Nat) : Nat :=
  (Finset.univ.filter fun a : Fin 6 => inDegree R a = i /\ outDegree R a = o).card
```

### 3. `PhysicsSM/Algebra/Octonion/IntegralOctonion.lean` [type2Roots_length]

Score: `0.752`

```text
theorem type2Roots_length : type2Roots.length = 128 := by native_decide

/-- There are exactly 240 E8 root candidates. -/
```

### 4. `PhysicsSM/Draft/SpinorTenfoldBasisTrichotomyAristotle.lean` [finrank_pairAnnihilator_trichotomy]

Score: `0.752`

```text
theorem finrank_pairAnnihilator_trichotomy (S T : Finset (Fin 5))
    (hS : S.card % 2 = 0) (hT : T.card % 2 = 0) :
    Module.finrank ℂ (pairAnnihilator S T) = 1
      ∨ Module.finrank ℂ (pairAnnihilator S T) = 3
      ∨ Module.finrank ℂ (pairAnnihilator S T) = 5 := by
  have key := finrank_pairAnnihilator_symmDiff S T
  have huni := Finset.card_union_add_card_inter S T
  have hsymm : (S ∆ T).card + (S ∩ T).card = (S ∪ T).card := by
    have hsup : (S ∆ T) ∪ (S ∩ T) = S ∪ T := symmDiff_sup_inf S T
    have hd : Disjoint (S ∆ T) (S ∩ T) := disjoint_symmDiff_inf S T
    rw [← hsup]
    exact (Finset.card_union_of_disjoint hd).symm
  have hle : (S ∪ T).card ≤ 5 := by
    have := Finset.card_le_univ (S ∪ T)
    simpa using this
  omega

/-- Stratum witnesses: the three dimensions are all realized (by `(∅, ∅)`,
the Krasnov pair `(∅, {3,4})`, and the generic pair `(∅, {0,1,2,3})`).
Should follow from `finrank_pairAnnihilator_symmDiff` by evaluation. -/
```

### 5. `PhysicsSM/Draft/SpinorTenfoldBasisTrichotomyAristotle.lean` [finrank_pairAnnihilator]

Score: `0.751`

```text
theorem finrank_pairAnnihilator (S T : Finset (Fin 5)) :
    Module.finrank ℂ (pairAnnihilator S T)
      = (S ∩ T).card + (5 - (S ∪ T).card) := by
  rw [(pairAnnihilatorEquivCoord S T).finrank_eq, Module.finrank_prod,
    Module.finrank_pi, Module.finrank_pi, pairCoord_card]

/-- The counting identity rewriting the dimension through the symmetric
difference. (`∆` is `symmDiff`; for subsets of `Fin 5` this is decidable,
and plain kernel `decide` over the 1024 pairs is acceptable.) -/
```

### 6. `PhysicsSM/Coding/ConstructionAThetaConvolution.lean` [finset_card_eq_sum_fibers]

Score: `0.750`

```text
theorem finset_card_eq_sum_fibers (c : BinaryVector 8) (s : ℕ) :
    (residueShellFinset c s).card =
      ∑ p ∈ (Finset.univ : Finset (Fin 8 → Fin (s + 1))),
        if ∑ i : Fin 8, (p i).val = s then
          ((residueShellFinset c s).filter
            (fun z => ∀ i, (z i).natAbs ^ 2 = (p i).val)).card
        else 0 := by
  rw [ ← Finset.sum_filter ];
  rw [ ← Finset.card_biUnion ];
  · congr with z ; simp +decide [ residueShellFinset ];
    constructor <;> intro h;
    · refine' ⟨ fun i => ⟨ ( z i |> Int.natAbs ) ^ 2, _ ⟩, _, _, _ ⟩ <;> norm_num;
      · nlinarith only [ abs_mul_abs_self ( z i ), h.2.1 ▸ Finset.single_le_sum ( fun a _ => sq_nonneg ( z a ) ) ( Finset.mem_univ i ) ];
      · zify;
        simpa using h.2.1;
      · tauto;
    · tauto;
  · intros a ha b hb hab; simp_all +decide [ Finset.disjoint_left ] ;
    exact fun z hz hz' => not_forall.mp fun h => hab <| funext fun i => Fin.ext <| h i

/-- The core counting theorem. -/
```

### 7. `PhysicsSM/Algebra/Octonion/E8WeylOrbitConvergence.lean` [rootWordTable]

Score: `0.749`

```text
,
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,7,6,2],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,0,1,6,2],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,7,6],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,0,1,6],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,6,0],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,6],
  [7,6,4,5,3,4,1,0,6],
  [7,6,4,5,3,4,6,1],
  [7,6,4,5,3,4,6],
  [1,2,3,0,7,1,6,2],
  [7,6,4,5,3,4,6,2],
  [1,2,3,0,7,1,6],
  [1,0,7,2,6,3],
  [1,2,7,3,6],
  [7,6,4,5,3,4,2,3,6],
  [1,0,7,2,6,1],
  [1,0,7,2,6],
  [7,6,1,2],
  [7,6,1,0],
  [7,6,1],
  [7,6],
  [1,2,0,1,3,2,4,3,5,4,7],
  [7,6,4,5,3,4,2,3,6,4],
  [1,0,7,2,6,1,4],
  [7,6,1,0,4,2],
  [7,6,1,2,4],
  [7,6,1,0,4],
  [7,6,4,1],
  [7,6,4],
  [1,2,3,4,0,1,5,2,7,3],
  [7,6,4,3,1,0],
  [7,6,4,3,1],
  [7,6,4,3],
  [1,2,3,4,0,1,5,2,7],
  [7,6,4,3,2],
  [1,2,3,4,5,0,7,1],
  [1,2,3,4,5,0,7],
  [1,2,3,4,7,5],
  [7,6,4,5,3,4,2,3,6,4,5],
  [7,6,1,0,4,2,5,1],
  [7,6,1,0,4,2,5],
  [7,6,4,5,1,2],
  [7,6,4,5,1,0],
  [7,6,4,5,1],
  [7,6,4,5],
  [1,2,0,1,3,2,4,3,7],
  [7,6,4,5,1,0,3],
  [7,6,4,3,1,5],
  [7,6,4,5,3],
  [1,2,3,4,0,1,7,2],
  [7,6,4,3,2,5],
  [1,2,3,4,0,1,7],
  [1,2,3,0,7,4],
  [1,2,3,4,7],
  [7,6,4,5,3,4,1,0],
  [7,6,4,5,3,4,1],
  [7,6,4,5,3,4],
  [1,2,0,1,3,2,7],
  [7,6,4,5,3,4,2],
  [1,2,3,0,7,1],
  [1,2,3,0,7],
  [1,2,7,3],
  [7,6,4,5,3,4,2,3],
  [1,2,0,1,7],
  [1,0,7,2],
  [1,2,7],
  [1,0,7],
  [7,1],
  [7],
  [1,2,0,1,3,2,4,3,5,4,7,6]]

set_option maxRecDepth 100000 in
-- 240 roots × 8 coordinates, each verified by kernel reduction
set_option maxHeartbeats 8000000 in
/-- **Word table correctness**: applying each word to `firstRoot` gives the
corresponding root, verified pointwise by kernel reduction (`decide`). -/
```

### 8. `PhysicsSM/Draft/NullEdgeP9IsohistogramSeparation.lean` [intervalSignature]

Score: `0.748`

```text
def intervalSignature (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R] : Fin 6 -> Nat :=
  fun k => intervalAbundance R k.val

/-- Frozen readout: vertices with in-degree two and out-degree one. -/
```

## Scoped paper hits

### 1. Tri-partitions and Bases of an Ordered Complex

Score: `0.728`
Zotero key: `D7352JCI`
DOI: `10.1007/s00454-020-00188-x`
URL: https://doi.org/10.1007/s00454-020-00188-x

### 2. Graph Sparsification by Effective Resistances

Score: `0.705`
Zotero key: `UFHN99H4`
arXiv: `0803.0929`
DOI: `10.1137/080734029`
URL: https://doi.org/10.1137/080734029

### 3. Random Walks on Simplicial Complexes and the Normalized Hodge 1-Laplacian

Score: `0.704`
Zotero key: `N7T76U5H`
arXiv: `1807.05044`
DOI: `10.1137/18M1201019`
URL: https://doi.org/10.1137/18M1201019

### 4. Combinatorial and Hodge Laplacians: Similarities and Differences

Score: `0.701`
Zotero key: `9RE64BCV`
DOI: `10.1137/22M1482299`
URL: https://doi.org/10.1137/22M1482299

### 5. Hodgelets: Localized Spectral Representations of Flows on Simplicial Complexes

Score: `0.701`
Zotero key: `33X7ZETB`
arXiv: `2109.08728`
URL: http://arxiv.org/abs/2109.08728
