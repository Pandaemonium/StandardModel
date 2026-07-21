# Aristotle semantic context pack

Generated: 2026-07-19T20:36:56
Query: `Chevalley pure spinor incidence vacuum affine chart orthogonal projectively distinct common annihilator dimension three`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Spinor/SpinorTenfoldPurity.lean` [krasnov_pair]

Score: `0.836`

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

### 2. `PhysicsSM/Spinor/SpinorTenfoldPurity.lean` [cliffordAction_vacuumSpinor]

Score: `0.835`

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

### 3. `PhysicsSM/Spinor/SpinorTenfoldColorAxis.lean`

Score: `0.824`

```text
import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldPurity
import PhysicsSM.Spinor.SpinorTenfoldCAR

/-!
# Spinor.SpinorTenfoldColorAxis

The color axis of the normal-form Krasnov pair: the common annihilator of
`(vacuumSpinor, weakSpinor)` is a 3-dimensional complex subspace — the
color `ℂ³`.

## Mathematical context

For the concrete `d = 3` Krasnov pair of `PhysicsSM.Spinor.SpinorTenfoldPurity`
(`ψ₁ = 1`, `ψ₂ = e₃ ∧ e₄`), the associated maximal isotropic subspaces are

- `N₁ = annihilator vacuumSpinor = ⟨f₀, f₁, f₂, f₃, f₄⟩` (dimension 5),
- `N₂ = annihilator weakSpinor = ⟨e₃, e₄, f₀, f₁, f₂⟩`,
- `N₁ ∩ N₂ = ⟨f₀, f₁, f₂⟩ ≅ ℂ³` (dimension 3).

In the research notes this is "the axis of the pencil is color `ℂ³`": the line
on the spinor tenfold through the two marked pure spinors is classified by the
isotropic 3-plane `N₁ ∩ N₂`, on which the Standard Model stabilizer acts by
its color factor. The matching hypercharge bookkeeping is in
`PhysicsSM.StandardModel.SpinorFockHypercharge` (indices `{0,1,2}` are the
color directions).

This module also records that annihilators of nonzero spinors are isotropic
for `Q10` (a corollary of the Clifford relation of
`PhysicsSM.Spinor.SpinorTenfoldCAR`), so `N₁` really is *maximal* isotropic:
an isotropic subspace of dimension 5 in a 10-dimensional quadratic space.

## Provenance

The annihilator characterizations and the `ℂ³` linear equivalence were proved
by the Aristotle proof agent (job `88884ecb-60f8-41fb-8be0-8977a7da86c9`, task
`AgentTasks/spin10-color-axis-aristotle-2026-06-09.md`) and reviewed for
semantic alignment; the result was a x i o m-clean and is integrated verbatim from
the handoff file `PhysicsSM/Draft/SpinorTenfoldColorAxisAristotle.lean` (now
retired). The isotropy corollary, the vacuum-annihilator dimension count,
```

### 4. `PhysicsSM/Spinor/SpinorTenfoldColorAxis.lean` [finrank_colorAxis]

Score: `0.824`

```text
theorem finrank_colorAxis : Module.finrank Complex colorAxisSubmodule = 3 := by
  rw [colorAxisLinearEquivC3.finrank_eq, Module.finrank_fin_fun]

/-! ## The vacuum annihilator is maximal isotropic -/

/-- Forward map: read off the annihilation-half coordinates of a vacuum
annihilator vector. -/
```

### 5. `PhysicsSM/Spinor/SpinorTenfoldColorAxis.lean` [mem_annihilator_weakSpinor_iff]

Score: `0.821`

```text
theorem mem_annihilator_weakSpinor_iff (v : V10) :
    v ∈ annihilator weakSpinor ↔ IsWeakSpinorAnnihilatorVector v := by
  constructor <;> intro h <;> simp_all +decide [ annihilator, IsWeakSpinorAnnihilatorVector ];
  · have := congr_fun h { 0, 3, 4 } ; ( have := congr_fun h { 1, 3, 4 } ; ( have := congr_fun h { 2, 3, 4 } ; ( have := congr_fun h { 3 } ; ( have := congr_fun h { 4 } ; simp_all +decide [ Fin.sum_univ_succ, cliffordAction ] ; ) ) ) );
    simp_all +decide [ Fin.forall_fin_succ, wedge, contract, weakSpinor ];
    simp_all +decide [ Finset.card, opSign, basisSpinor ];
  · ext S; simp [cliffordAction, h];
    simp_all +decide [ Fin.sum_univ_five, wedge, contract, weakSpinor ];
    fin_cases S <;> simp +decide [ *, basisSpinor ]

/-- Coordinate characterization of the common annihilator: the color axis. -/
```

### 6. `PhysicsSM/Spinor/SpinorTenfoldPurity.lean`

Score: `0.821`

```text
is the color `ℂ³` (the "axis of the pencil"); see the draft module
`PhysicsSM.Draft.SpinorTenfoldColorAxisAristotle` for the dimension count.

## Conventions

- The Chevalley pairing on `Λ•(ℂ⁵)` is
  `β(ψ, φ) = Σ_S (-1)^{|S|(|S|-1)/2} ε(S) ψ(S) φ(Sᶜ)`,
  where `ε(S)` is the shuffle sign of `(S, Sᶜ)` and the **alpha twist**
  `(-1)^{|S|(|S|-1)/2}` comes from the main anti-automorphism of the exterior
  algebra. The twist is load-bearing: the oracle
  `Scripts/oracle/validate_spinor_tenfold.py` confirms that with it `q` is
  symmetric on even spinors and the ten-dimensional Fierz identity holds,
  and that both fail without it.
- `q(ψ, φ) ∈ V10` is defined componentwise by the adjunction
  `B10 (q ψ φ) v = β(v · ψ, φ)`, proved below as `B10_gammaBilinear`.
- Purity: `ψ ≠ 0`, even, and `q(ψ, ψ) = 0`.

## Main declarations

- `chevalleyPairing` : the Chevalley bilinear form `β`.
- `gammaBilinear` : the vector-valued bilinear `q`.
- `B10_gammaBilinear` : the defining adjunction.
- `Q10_gammaBilinear_eq_zero_of_clifford` : `q(ψ)·ψ = 0 → Q(q(ψ)) = 0`
  (the contraction step of Lemma 1(b) of the research notes).
- `IsPureSpinor`, `gammaBilinear_polarization`, `sum_quadric_iff`,
  `line_quadric` : the purity quadric and the Proposition 2 chain.
- `vacuumSpinor`, `weakSpinor`, `krasnov_pair` : the concrete `d = 3` witness.
- `annihilator`, `mem_annihilator_vacuumSpinor_iff` : annihilator subspaces.

## Claim boundary

This module does NOT construct the group `Spin(10)`, classify orbits of
pure-spinor pairs, or compute stabilizers. The orbit trichotomy
(`d ∈ {5, 3, 1}`) and the `S(U(2) × U(3))` Selector Theorem of the research
notes remain future work; this module provides the kernel-checked quadric-level
layer those results sit on.

## Sources

- C. Chevalley, "The Algebraic Theo
```

### 7. `AgentTasks/spin10-color-axis-aristotle-2026-06-09.md` [Preferred theorem targets]

Score: `0.817`

```text
## Preferred theorem targets

Fill the holes in:

```lean
mem_annihilator_weakSpinor_iff
mem_colorAxis_iff
colorAxisLinearEquivC3
```

The key expected coordinate facts are:

- `annihilator weakSpinor` is the span of `e_3`, `e_4`, `f_0`, `f_1`, `f_2`.
- `annihilator vacuumSpinor inf annihilator weakSpinor` is the span of
  `f_0`, `f_1`, `f_2`.
```

### 8. `AgentTasks/spin10-color-axis-aristotle-2026-06-09.md` [Goal]

Score: `0.816`

```text
## Goal

Compute the common annihilator of the normal-form Krasnov pure-spinor pair
`(vacuumSpinor, weakSpinor)` and identify it with the color `C^3` axis.

Primary target file:

```text
PhysicsSM/Draft/SpinorTenfoldColorAxisAristotle.lean
```

Trusted source file:

```text
PhysicsSM/Spinor/SpinorTenfoldPurity.lean
```
```

## Scoped paper hits

### 1. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.756`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 2. The Chiral and flavour projection of Dirac-Kahler fermions in the geometric discretization

Score: `0.748`
Zotero key: `WENPW6UZ`
arXiv: `0706.4385`
DOI: `10.1142/S0219887808002825`
URL: https://www.zotero.org/19894138/items/WENPW6UZ

Abstract:

It is shown that an exact chiral symmetry can be described for Dirac-Kahler fermions using the two complexes of the geometric discretization. This principle is extended to describe exact flavour projection and it is shown that this necessitates the introduction of a new operator and two new structures of complex. To describe simultaneous chiral and flavour projection, eight complexes are needed in all and it is shown that projection leaves a single flavour of chiral field on each.

### 3. Superconnections and the Chern character

Score: `0.736`
Zotero key: `WNATKBT5`
DOI: `10.1016/0040-9383(85)90047-3`
URL: https://doi.org/10.1016/0040-9383(85)90047-3

### 4. On the definition of spacetimes in Noncommutative Geometry, Part I

Score: `0.735`
Zotero key: `5VWPZ8BP`
arXiv: `1611.07830`
DOI: `10.48550/arXiv.1611.07830`
URL: https://arxiv.org/abs/1611.07830

Abstract:

Part I develops Lorentzian spectral-spacetime foundations in the commutative continuous case, including signature characterization by time-orientation one-forms and a Krein product on spinors.

### 5. Hierarchies without symmetries from extra dimensions

Score: `0.733`
Zotero key: `M9KJ7UCN`
arXiv: `hep-ph/9903417`
DOI: `10.1103/PhysRevD.61.033005`
URL: https://doi.org/10.1103/physrevd.61.033005
