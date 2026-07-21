# Aristotle semantic context pack

Generated: 2026-07-19T20:36:45
Query: `Spin(10) vacuum stabilizer GL5 basis change transitive decomposable two forms pure spinor common annihilator dimension three`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Spinor/SpinorTenfoldColorAxis.lean` [finrank_annihilator_vacuumSpinor]

Score: `0.849`

```text
theorem finrank_annihilator_vacuumSpinor :
    Module.finrank Complex (annihilator vacuumSpinor) = 5 := by
  rw [vacuumAnnihilatorLinearEquivC5.finrank_eq, Module.finrank_fin_fun]

end PhysicsSM.Spinor.SpinorTenfold

end
```

### 2. `PhysicsSM/Draft/SpinorTenfoldBasisTrichotomyAristotle.lean`

Score: `0.824`

```text
import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldColorAxis

/-!
# Draft.SpinorTenfoldBasisTrichotomyAristotle

Aristotle handoff: the annihilator-intersection dimension formula for pairs
of Fock basis spinors, and the resulting `d ∈ {1, 3, 5}` trichotomy on
normal forms.

## Mathematical intent

This is the normal-form backbone of Proposition 3 (the orbit trichotomy) of
`Sources/Spin10_stabilizer.txt`. Every Fock basis spinor
`basisSpinor T` is pure with maximal isotropic annihilator

  `N_T = ⟨e_i : i ∈ T⟩ ⊕ ⟨f_i : i ∉ T⟩`,

and for two basis spinors the intersection is read off index by index:

  `N_S ∩ N_T = ⟨e_i : i ∈ S ∩ T⟩ ⊕ ⟨f_i : i ∉ S ∪ T⟩`,

so `dim(N_S ∩ N_T) = |S ∩ T| + (5 - |S ∪ T|) = 5 - |S ∆ T|`. For two
*even* subsets the symmetric difference has even cardinality `0`, `2`, or
`4`, giving exactly the trichotomy `d ∈ {5, 3, 1}`:

- `d = 5`: same spinor (the trivial stratum);
- `d = 3`: the Krasnov stratum (e.g. `∅` and `{3,4}`: the witness pair,
  whose intersection is the color axis of
  `PhysicsSM.Spinor.SpinorTenfoldColorAxis` — `pairAnnihilator_vacuum_weak`
  below anchors this);
- `d = 1`: the generic stratum (e.g. `∅` and `{0,1,2,3}`).

Once the group-level `Spin(10)` action with its transitivity statements is
available, the trichotomy on basis pairs extends to all pure-spinor pairs;
this module deliberately stays at the kernel-checkable normal-form level.

## Proof guidance

- `mem_annihilator_basisSpinor_iff`: expand `cliffordAction` via
  `cliffordAction_eq_sum`; the images `wedge i (basisSpinor T)` (for
  `i ∉ T`) and `contract i (basisSpinor T)` (for `i ∈ T`) are signed
  *distinct* basis spinors (`wedge_basisSpinor_of_not_mem`,
  `contract_basisSpinor_of_mem`), so the sum vanishes iff every coefficient
  does. Evaluating the sum at the indiv
```

### 3. `PhysicsSM/Spinor/SpinorTenfoldPurity.lean` [cliffordAction_vacuumSpinor]

Score: `0.823`

```text
theorem cliffordAction_vacuumSpinor (v : V10) :
    cliffordAction v vacuumSpinor = ∑ i, v.1 i • basisSpinor {i} := by
  rw [vacuumSpinor, cliffordAction_eq_sum]
  have hc : ∀ i : Fin 5, contract i (basisSpinor (∅ : Finset (Fin 5))) = 0 :=
    fun i => contract_basisSpinor_of_not_mem i ∅ (Finset.notMem_empty i)
  have hw : ∀ i : Fin 5,
      wedge i (basisSpinor (∅ : Finset (Fin 5))) = basisSpinor {i} := by
    intro i
    rw [wedge_basisSpinor_of_not_mem i ∅ (Finset.notMem_empty i)]
    have hins : (insert i ∅ : Finset (Fin 5)) = {i} := rfl
    have hsign : opSign i ({i} : Finset (Fin 5)) = 1 := by
      unfold opSign belowCount
      rw [Finset.filter_singleton, if_neg (lt_irrefl i)]
      simp
    rw [hins, hsign, one_smul]
  simp only [hw, hc, smul_zero, Finset.sum_const_zero, add_zero]

/-- The annihilator of the Fock vacuum is exactly the annihilation half
`N₁ = {(0, b)} = ⟨f₀, …, f₄⟩` of the hyperbolic splitting. -/
```

### 4. `PhysicsSM/Spinor/SpinorTenfoldPurity.lean` [krasnov_pair]

Score: `0.821`

```text
theorem krasnov_pair :
    IsPureSpinor vacuumSpinor ∧ IsPureSpinor weakSpinor
      ∧ gammaBilinear vacuumSpinor weakSpinor = 0
      ∧ gammaBilinear weakSpinor vacuumSpinor = 0
      ∧ IsPureSpinor (vacuumSpinor + weakSpinor)
      ∧ ∀ s t : ℂ,
          gammaBilinear (s • vacuumSpinor + t • weakSpinor)
            (s • vacuumSpinor + t • weakSpinor) = 0 := by
  refine ⟨isPureSpinor_vacuumSpinor, isPureSpinor_weakSpinor,
    gammaBilinear_vacuum_weak, gammaBilinear_weak_vacuum,
    isPureSpinor_vacuum_add_weak, ?_⟩
  intro s t
  exact line_quadric isPureSpinor_vacuumSpinor.quadric
    isPureSpinor_weakSpinor.quadric
    (by rw [gammaBilinear_vacuum_weak, gammaBilinear_weak_vacuum, add_zero]) s t

/-! ## Annihilator subspaces -/

/-- The annihilator of a spinor: the subspace of vectors acting as zero. For a
pure spinor this is the associated maximal isotropic subspace `N_ψ ⊂ ℂ¹⁰`
(isotropy follows from the Clifford relation, proved in the CAR draft
module). -/
```

### 5. `PhysicsSM/Spinor/SpinorTenfoldPurity.lean` [mem_annihilator_vacuumSpinor_iff]

Score: `0.820`

```text
theorem mem_annihilator_vacuumSpinor_iff (v : V10) :
    v ∈ annihilator vacuumSpinor ↔ v.1 = 0 := by
  rw [mem_annihilator, cliffordAction_vacuumSpinor]
  constructor
  · intro h
    funext k
    have hk := congrFun h {k}
    rw [Finset.sum_apply] at hk
    rw [Finset.sum_eq_single k] at hk
    · simpa [basisSpinor] using hk
    · intro i _ hik
      have hne : ({k} : Finset (Fin 5)) ≠ {i} := by
        intro h'
        exact hik (Finset.singleton_injective h').symm
      simp [basisSpinor, hne]
    · intro hk'
      exact absurd (Finset.mem_univ k) hk'
  · intro h
    rw [h]
    simp

end PhysicsSM.Spinor.SpinorTenfold

end
```

### 6. `PhysicsSM/Spinor/SpinorTenfoldColorAxis.lean` [vacuumAnnihilatorLinearEquivC5]

Score: `0.818`

```text
noncomputable def vacuumAnnihilatorLinearEquivC5 :
    annihilator vacuumSpinor ≃ₗ[Complex] (Fin 5 → Complex) :=
  LinearEquiv.ofLinear vacuumAnnihilatorToC5 vacuumAnnihilatorFromC5
    (LinearMap.ext fun _ => rfl) (LinearMap.ext vacuumAnnihilator_left_inv)

/-- `N₁` has complex dimension 5: together with
`Q10_eq_zero_of_mem_annihilator` it is a *maximal* isotropic subspace of the
10-dimensional quadratic space `(V10, Q10)`. -/
```

### 7. `AgentTasks/spin10-basis-trichotomy-aristotle-2026-06-10.md` [Goal]

Score: `0.818`

```text
## Goal

Fill the seven documented `sorry`s in

```text
PhysicsSM/Draft/SpinorTenfoldBasisTrichotomyAristotle.lean
```

establishing the annihilator-intersection dimension formula for pairs of
Fock basis spinors and the `d ∈ {1, 3, 5}` trichotomy:

```lean
mem_annihilator_basisSpinor_iff   -- N_T in coordinates
mem_pairAnnihilator_iff           -- N_S ∩ N_T in coordinates
pairAnnihilator_vacuum_weak       -- consistency with colorAxisSubmodule
finrank_pairAnnihilator           -- dim = |S∩T| + (5 - |S∪T|)
card_inter_add_card_compl_union   -- = 5 - |S ∆ T|
finrank_pairAnnihilator_trichotomy -- even/even: d ∈ {1,3,5}
trichotomy_witnesses              -- all three strata realized
```
```

### 8. `EXECUTION_PLAN.md` [Active priorities]

Score: `0.812`

```text
ess) is
   joined by the physical hypercharge generator `Y = sum y_i rho(e_i ^ f_i)`
   (Prop S3 infinitesimal; `Draft/SpinorTenfoldHyperchargeOpAristotle`; job
   `ee0d7409-c8be-4707-860c-ebfc7969c984`) and the basis-pair annihilator
   trichotomy `dim(N_S cap N_T) = 5 - |S Delta T| in {1,3,5}` (Prop 3 normal
   forms; `Draft/SpinorTenfoldBasisTrichotomyAristotle`; job `5662f6a5`,
   COMPLETE and integrated 2026-06-10 - all seven targets proved, including
   the explicit `pairAnnihilatorEquivCoord` linear equivalence). The
   group-level program proper started 2026-06-10 (wave 6): `Spin(10)` is
   modeled algebraically as `evenCliffordGroup` - the subgroup of
   `(Module.End C FockSpinor)^x` generated by pair products of anisotropic
   Clifford units - in the trusted `Spinor/SpinorTenfoldCliffordGroup`
   (gamma units with explicit inverses, mode-flip units, scalar units,
   twisted reflection; no exponentials or analysis anywhere). Wave 6
   Aristotle jobs: `3408462a` (conjugation = twisted reflection, B10/Q10
   invariance, chirality preservation, conjugation stability of the vector
   image; `Draft/SpinorTenfoldCliffordConjAristotle`) and `701dda9e`
   (mode-flip action on basis spinors and MARKED orbit transitivity on the
   even basis, with the vacuum-to-weak Krasnov anchor derived;
   `Draft/SpinorTenfoldBasisOrbitAristotle`). Remaining after wave 6: the
   spinor Witt theorem (every pure spinor lies in the vacuum orbit), the
   vector representation `evenCliffordGroup -> SO(10, C)`, pair
   transitivity (Lemma S1), the stabilizer computation (Lemma S2), and the
   `S(U(2) x U(3))` Selector Theorem of `Sources/Spin10_stabilizer.txt`.
   Note: `evenCliffordGroup` is `GSpin` (contains all nonzero scalars);
   the spinor-norm-1 cut to `Spin(10)` proper comes later v
```

## Scoped paper hits

### 1. Two-twistor particle models and free massive higher spin fields

Score: `0.748`
Zotero key: `zotero:MFUJKFEA`
arXiv: `1409.7169`
DOI: `10.1007/JHEP04(2015)010`
URL: https://doi.org/10.1007/JHEP04(2015)010

### 2. Massive relativistic particle model with spin from free two-twistor dynamics and its quantization

Score: `0.733`
Zotero key: `zotero:2T3HC5NC`
arXiv: `hep-th/0510161`
DOI: `10.1103/PhysRevD.73.105011`
URL: https://doi.org/10.1103/PhysRevD.73.105011

### 3. Gauged twistor formulation of a massive spinning particle in four dimensions

Score: `0.731`
Zotero key: `arxiv:1512.07740`
arXiv: `1512.07740`
DOI: `10.1103/PhysRevD.93.045016`
URL: http://arxiv.org/abs/1512.07740

Abstract:

Gauged generalized Shirafuji action for a massive spinning particle with local U(1) and SU(2) symmetries, constraints, and Penrose transform to massive spinor fields.

### 4. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.731`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 5. Hierarchies without symmetries from extra dimensions

Score: `0.725`
Zotero key: `M9KJ7UCN`
arXiv: `hep-ph/9903417`
DOI: `10.1103/PhysRevD.61.033005`
URL: https://doi.org/10.1103/physrevd.61.033005
