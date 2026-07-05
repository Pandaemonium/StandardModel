# Aristotle semantic context pack

Generated: 2026-07-04T23:54:54
Query: `Lean Q6 Kotecky Preiss boundedTouchSum_succ_le_finitePartial finite labeled rooted tree exponential formula PolymerKPConclusion treeTerm boundedTouchSum`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgeP9BoundaryExact.lean` [testBoundary]

Score: `0.794`

```text
def testBoundary {E C : Type*} [Fintype C] (inc : E -> C -> Real)
    (test : C -> Real) : E -> Real :=
  fun e => Finset.univ.sum fun c => inc e c * test c

/--
Finite summation-by-parts identity for the P9 source-visibility branch.

Boundary-exact bookkeeping pairs with a cell test only through the test's
boundary. This is the finite algebra behind "boundary bookkeeping is invisible
to closed bulk tests."
-/
```

### 2. `PhysicsSM/Draft/CheckerboardCornerClosedFormsAristotle.lean` [Lcnt_rec]

Score: `0.780`

```text
theorem Lcnt_rec (p q k : Nat) (hpq : 0 < p + q) :
    Lcnt p q k
      = (if 0 < q then Lcnt p (q - 1) k else 0)
        + (if 0 < p ∧ 0 < k then Rcnt (p - 1) q (k - 1) else 0) := by
  unfold Lcnt Rcnt;
  convert gcount_succ ( p + q - 1 ) left ( p - q ) k using 1;
  · rw [ Nat.sub_add_cancel hpq ];
  · rcases p with ( _ | p ) <;> rcases q with ( _ | q ) <;> simp_all +decide [ add_comm, add_left_comm ];
    · intro hk;
      convert gcount_eq_zero_of_abs q right ( -q + -1 - 1 ) ( k - 1 ) _ using 1;
      rw [ abs_of_nonpos ] <;> linarith;
    · convert gcount_eq_zero_of_abs p left ( p + 2 ) k _ using 1;
      rw [ abs_of_nonneg ] <;> linarith;
    · grind

/-- The master closed-form identity, proved simultaneously for both incoming
directions by strong induction on `p + q`. -/
```

### 3. `PhysicsSM/Draft/NullEdgeOvernightSynthesisAristotle.lean` [rlClosedForm]

Score: `0.779`

```text
def rlClosedForm [Semiring S] (mu : S) (p q : Nat) : S :=
  if q = 0 then
    0
  else
    ∑ r ∈ Finset.range (p + 1),
      ((p.choose r * (q - 1).choose r : Nat) : S) * mu ^ (2 * r + 1)

/-- Directed endpoint kernel for a right-incoming checkerboard path. -/
```

### 4. `Sources/Luminal_Motion_Checkerboard_Publication_Advance_2026-06-11.md` [Next theorem sequence]

Score: `0.779`

```text
## Next theorem sequence

The next publication-grade Lean targets should stay finite.

Completed trusted targets:

1. Prove `histories` is duplicate-free and has cardinality `2^n`.
2. Define `turnCount` and prove `pathWeight mu d h = mu ^ turnCount d h`.
3. Package the two directed endpoint sums as a two-component lattice spinor and
   prove the finite endpoint recursion and telegraph recursion.

Remaining finite targets:

1. Prove the closed binomial formulas for paths with fixed endpoint,
   terminal direction, and number of turns.
2. Combine the closed binomial formulas into endpoint-level kernel closed
   forms.  This is queued as Aristotle task
   `62a3c14d-d084-4a24-b1e6-4e86a4ec605b`.
3. Relate the closed forms to the standard checkerboard kernel normalization.
4. Only after these finite theorems are complete, decide whether the continuum
   limit is formalized in Lean or cited to Skopenkov--Ustinov as an analytic
   theorem outside the verified contribution.
```

### 5. `PhysicsSM/Draft/NullEdgeOvernightSynthesisAristotle.lean` [rrClosedForm]

Score: `0.776`

```text
def rrClosedForm [Semiring S] (mu : S) (p q : Nat) : S :=
  if q = 0 then
    1
  else
    ∑ r ∈ Finset.Icc 1 (p + q),
      ((p.choose r * (q - 1).choose (r - 1) : Nat) : S) * mu ^ (2 * r)

/-- Right-starting, left-terminal closed form including the straight boundary case. -/
```

### 6. `AgentTasks/checkerboard-kernel-closed-forms-aristotle-2026-06-21.md` [Result and integration]

Score: `0.776`

```text
## Result and integration

Aristotle completed the continuation task and proved all four endpoint-kernel
closed forms:

- `pathSum_right_right_closed_form`
- `pathSum_right_left_closed_form`
- `pathSum_right_right_straight`
- `pathSum_right_left_straight_zero`

The result adds reindexing and boundary-count helper lemmas in the same draft
file. The claim boundary remains finite combinatorics only: no continuum
limit, no Bessel-function asymptotics, and no equality with the analytic Dirac
propagator.

Integrated locally from the fresh project archive:

```text
AgentTasks/aristotle-output/6fe6a877-4ad1-4b70-91f0-ace14eb90a13/checkerboard-62a3c14d-project-files.tar.gz
```

Verification run locally:

```text
lake env lean PhysicsSM/Draft/CheckerboardKernelClosedFormsAristotle.lean
lake build PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle
```

The touched target file has no proof-command placeholders or forbidden
constructs.
```

### 7. `PhysicsSM/Draft/WeightContribCoeffProof.lean` [coeff_finset_prod_eq_sum_fin]

Score: `0.772`

```text
theorem coeff_finset_prod_eq_sum_fin {k : ℕ} {R : Type*} [CommSemiring R]
    (f : Fin k → PowerSeries R) (s : ℕ) :
    PowerSeries.coeff s (∏ i : Fin k, f i) =
      (Finset.univ : Finset (Fin k → Fin (s + 1))).sum fun parts =>
        if (Finset.univ.sum fun i => (parts i).val) = s then
          Finset.univ.prod fun i => PowerSeries.coeff (parts i).val (f i)
        else 0 := by
  have h_sum : (PowerSeries.coeff s (∏ i, f i)) = ∑ parts ∈ Finset.filter (fun parts : Fin k → ℕ => ∑ i, parts i = s) (Finset.Iic fun _ => s), ∏ i, (PowerSeries.coeff (parts i) (f i)) := by
    convert PowerSeries.coeff_prod using 1;
    rotate_left;
    exact R;
    exact inferInstance;
    exact Fin k;
    infer_instance;
    constructor;
    · exact fun a f d s => PowerSeries.coeff_prod f d s;
    · intro h;
      convert h f s Finset.univ using 1;
      refine' Finset.sum_bij ( fun l hl => Finsupp.equivFunOnFinite.symm l ) _ _ _ _ <;> simp +decide;
      exact fun b hb => ⟨ b, ⟨ fun i => hb ▸ Finset.single_le_sum ( fun a _ => Nat.zero_le ( b a ) ) ( Finset.mem_univ i ), hb ⟩, by simp +decide ⟩;
  rw [ h_sum, ← Finset.sum_filter ];
  refine' Finset.sum_bij ( fun parts hparts => fun i => ⟨ parts i, _ ⟩ ) _ _ _ _ <;> simp_all +decide;
  exacts [ hparts.1 i, fun a₁ ha₁ ha₂ a₂ ha₃ ha₄ h => funext fun i => by simpa using congr_fun h i, fun b hb => ⟨ fun i => b i, ⟨ fun i => Nat.le_of_lt_succ ( Fin.is_lt _ ), hb ⟩, funext fun i => rfl ⟩ ]
```

### 8. `PhysicsSM/Draft/CheckerboardCornerPolynomialAristotle.lean` [pathWeight_eq_pow_turnCount]

Score: `0.772`

```text
theorem pathWeight_eq_pow_turnCount [Semiring S] (mu : S)
    (d : Direction) (h : List Direction) :
    pathWeight mu d h = mu ^ turnCount d h := by
  induction' h with e rest ih generalizing d;
  · cases d <;> simp +decide [ pathWeight, turnCount ];
  · cases h : e == d <;> simp_all +decide [ pow_add, turnCount_cons ];
    cases d <;> cases e <;> tauto

/-- The finite checkerboard path sum is the polynomial in `mu` whose
coefficients count histories with fixed endpoint data and fixed corner count. -/
```

### 9. `PhysicsSM/Draft/NullEdgeOvernightSynthesisAristotle.lean` [RightStartedEndpointKernel]

Score: `0.771`

```text
structure RightStartedEndpointKernel (S : Type*) where
  rightTerminal : S
  leftTerminal : S

/-- Path-sum endpoint kernel for a right-incoming path with `p` right and `q` left steps. -/
```

### 10. `PhysicsSM/Draft/CheckerboardKernelClosedFormsAristotle.lean` [with]

Score: `0.770`

```text
import PhysicsSM.Draft.CheckerboardCornerPolynomialAristotle
import PhysicsSM.Draft.CheckerboardCornerClosedFormsAristotle

/-!
# Draft.CheckerboardKernelClosedFormsAristotle

Focused Aristotle handoff: combine the corner-count polynomial theorem with
the binomial corner-count closed forms to get endpoint-level closed forms for
the finite checkerboard path sum.

The imported draft files already prove:

- the path sum is a polynomial in the corner weight, with coefficients given
  by fixed-endpoint corner classes;
- the right-incoming corner classes have binomial closed forms.

The target here is the publication-facing kernel statement: for a path from
`0` to displacement `p - q` in `p + q` lightlike steps, starting incoming
right, the directed endpoint path sum is the corresponding finite polynomial
in `mu`.

This is still finite combinatorics.  No continuum limit or analytic
normalization is asserted here.
-/
```

### 11. `PhysicsSM/Spinor/SpinorTenfoldOctonionBridge.lean` [sum_finset_fin5]

Score: `0.770`

```text
theorem sum_finset_fin5 {M : Type*} [AddCommMonoid M] (f : Finset (Fin 5) → M) :
    (∑ S : Finset (Fin 5), f S) =
    f ∅ + f {0} + f {1} + f {2} + f {3} + f {4} + f {0,1} + f {0,2} + f {0,3} + f {0,4}
    + f {1,2} + f {1,3} + f {1,4} + f {2,3} + f {2,4} + f {3,4}
    + f {0,1,2} + f {0,1,3} + f {0,1,4} + f {0,2,3} + f {0,2,4} + f {0,3,4}
    + f {1,2,3} + f {1,2,4} + f {1,3,4} + f {2,3,4}
    + f {0,1,2,3} + f {0,1,2,4} + f {0,1,3,4} + f {0,2,3,4} + f {1,2,3,4} + f {0,1,2,3,4} := by
  rw [show (Finset.univ : Finset (Finset (Fin 5))) =
    {∅, {0}, {1}, {2}, {3}, {4}, {0,1}, {0,2}, {0,3}, {0,4},
     {1,2}, {1,3}, {1,4}, {2,3}, {2,4}, {3,4},
     {0,1,2}, {0,1,3}, {0,1,4}, {0,2,3}, {0,2,4}, {0,3,4},
     {1,2,3}, {1,2,4}, {1,3,4}, {2,3,4},
     {0,1,2,3}, {0,1,2,4}, {0,1,3,4}, {0,2,3,4}, {1,2,3,4}, {0,1,2,3,4}} from by decide]
  repeat rw [Finset.sum_insert (by decide)]
  rw [Finset.sum_singleton]
  abel

/-- The bridge written out as `32` explicit basis contributions. -/
```

### 12. `PhysicsSM/Draft/SpinorTenfoldOctonionBridgeAristotle.lean` [sum_finset_fin5]

Score: `0.770`

```text
theorem sum_finset_fin5 {M : Type*} [AddCommMonoid M] (f : Finset (Fin 5) → M) :
    (∑ S : Finset (Fin 5), f S) =
    f ∅ + f {0} + f {1} + f {2} + f {3} + f {4} + f {0,1} + f {0,2} + f {0,3} + f {0,4}
    + f {1,2} + f {1,3} + f {1,4} + f {2,3} + f {2,4} + f {3,4}
    + f {0,1,2} + f {0,1,3} + f {0,1,4} + f {0,2,3} + f {0,2,4} + f {0,3,4}
    + f {1,2,3} + f {1,2,4} + f {1,3,4} + f {2,3,4}
    + f {0,1,2,3} + f {0,1,2,4} + f {0,1,3,4} + f {0,2,3,4} + f {1,2,3,4} + f {0,1,2,3,4} := by
  rw [show (Finset.univ : Finset (Finset (Fin 5))) =
    {∅, {0}, {1}, {2}, {3}, {4}, {0,1}, {0,2}, {0,3}, {0,4},
     {1,2}, {1,3}, {1,4}, {2,3}, {2,4}, {3,4},
     {0,1,2}, {0,1,3}, {0,1,4}, {0,2,3}, {0,2,4}, {0,3,4},
     {1,2,3}, {1,2,4}, {1,3,4}, {2,3,4},
     {0,1,2,3}, {0,1,2,4}, {0,1,3,4}, {0,2,3,4}, {1,2,3,4}, {0,1,2,3,4}} from by decide]
  repeat rw [Finset.sum_insert (by decide)]
  rw [Finset.sum_singleton]
  abel

/-- The bridge written out as `32` explicit basis contributions. -/
```

## Scoped paper hits

### 1. Tri-partitions and Bases of an Ordered Complex

Score: `0.726`
Zotero key: `D7352JCI`
DOI: `10.1007/s00454-020-00188-x`
URL: https://doi.org/10.1007/s00454-020-00188-x

### 2. Local d'Alembertian for causal sets

Score: `0.709`
Zotero key: `I72KXVQA`
arXiv: `2506.18745`
