# Aristotle semantic context pack

Generated: 2026-07-19T18:14:56
Query: `pure spinor annihilator intersection dimension incidence orthogonal vacuum Spin(10)`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Spinor/SpinorTenfoldColorAxis.lean` [finrank_annihilator_vacuumSpinor]

Score: `0.852`

```text
theorem finrank_annihilator_vacuumSpinor :
    Module.finrank Complex (annihilator vacuumSpinor) = 5 := by
  rw [vacuumAnnihilatorLinearEquivC5.finrank_eq, Module.finrank_fin_fun]

end PhysicsSM.Spinor.SpinorTenfold

end
```

### 2. `PhysicsSM/Spinor/SpinorTenfoldPurity.lean` [krasnov_pair]

Score: `0.849`

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

### 3. `AgentTasks/24h-publication-run-2026-07-12/JC_WEAK_QUOTIENT_NONIDENTITY_STRATEGY.md` [1.2 From `SpinorTenfoldColorAxis.lean`]

Score: `0.844`

```text
### 1.2 From `SpinorTenfoldColorAxis.lean`
```
theorem Q10_eq_zero_of_mem_annihilator {ψ} (hψ : ψ ≠ 0) {v} (hv : v ∈ annihilator ψ) : Q10 v = 0
def IsColorAxisVector (v : V10) : Prop := v.1 = 0 ∧ v.2 ⟨3,_⟩ = 0 ∧ v.2 ⟨4,_⟩ = 0
theorem mem_annihilator_weakSpinor_iff (v : V10) : v ∈ annihilator weakSpinor ↔ IsWeakSpinorAnnihilatorVector v
theorem mem_colorAxis_iff (v : V10) : v ∈ annihilator vacuumSpinor ⊓ annihilator weakSpinor ↔ IsColorAxisVector v
abbrev colorAxisSubmodule : Submodule Complex V10 := annihilator vacuumSpinor ⊓ annihilator weakSpinor
theorem finrank_colorAxis : Module.finrank Complex colorAxisSubmodule = 3
theorem finrank_annihilator_vacuumSpinor : Module.finrank Complex (annihilator vacuumSpinor) = 5
```
Plus the vacuum characterization used throughout ColorAxis (defined in the
trusted `Purity`/`CAR` layer):
```
theorem mem_annihilator_vacuumSpinor_iff (v : V10) : v ∈ annihilator vacuumSpinor ↔ v.1 = 0
```
```

### 4. `AgentTasks/spin10-basis-trichotomy-aristotle-2026-06-10.md` [Goal]

Score: `0.841`

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

## Scoped paper hits

### 1. Octonions, trace dynamics and non-commutative geometry: a case for unification in spontaneous quantum gravity

Score: `0.746`
Zotero key: `845WNTMG`
arXiv: `2006.16274`
DOI: `10.1515/zna-2020-0196`
URL: http://arxiv.org/abs/2006.16274

Abstract:

We have recently proposed a new matrix dynamics at the Planck scale, building on the theory of trace dynamics. This is a Lagrangian dynamics in which the matrix degrees of freedom are made from Grassmann numbers, and the Lagrangian is trace of a matrix polynomial. Matrices made from even grade elements of the Grassmann algebra are called bosonic, and those made from odd grade elements are called fermionic: together they describe an `aikyon'. In the present article we provide a basic definition of spin angular momentum in this matrix dynamics, and introduce a bosonic (fermionic) configuration variable conjugate to the spin of a boson (fermion). We then show that at energies below Planck scale, where the matrix dynamics reduces to quantum theory, fermions have half-integer spin (in multiples of Planck's constant), and bosons have integral spin. We also show that this definition of spin agrees with the conventional understanding of spin in relativistic quantum mechanics. Consequently, we obtain an elementary proof for the spin-statistics connection. We then motivate why an octonionic space is the natural space in which an aikyon evolves. The group of automorphisms
...[truncated]

### 2. The Octonions

Score: `0.744`
Zotero key: `WRIM6ZI7`
arXiv: `math/0105155`
URL: http://arxiv.org/abs/math/0105155

Abstract:

The octonions are the largest of the four normed division algebras. While somewhat neglected due to their nonassociativity, they stand at the crossroads of many interesting fields of mathematics. Here we describe them and their relation to Clifford algebras and spinors, Bott periodicity, projective and Lorentzian geometry, Jordan algebras, and the exceptional Lie groups. We also touch upon their applications in quantum logic, special relativity and supersymmetry.

### 3. Octonion Internal Space Algebra for the Standard Model

Score: `0.744`
Zotero key: `EPT6PUTC`
arXiv: `2206.06912`
URL: https://arxiv.org/abs/2206.06912

Abstract:

Survey of internal-space algebra for the Standard Model using Clifford algebras with left multiplication by octonions. A distinguished complex structure implements the splitting O = C plus C^3 reflecting lepton-quark symmetry and relates to Pati-Salam and Spin(10) structures.
