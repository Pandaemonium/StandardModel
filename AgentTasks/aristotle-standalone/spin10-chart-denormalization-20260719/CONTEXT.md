# Aristotle semantic context pack

Generated: 2026-07-19T20:36:34
Query: `Spin(10) pure spinor normalized vacuum affine chart scalar units exact even Clifford orbit nonzero vacuum coefficient`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Spinor/SpinorTenfoldBasisOrbit.lean` [exists_evenCliffordGroup_vacuum_weak]

Score: `0.850`

```text
theorem exists_evenCliffordGroup_vacuum_weak :
    ∃ g ∈ evenCliffordGroup,
      (g : Module.End ℂ FockSpinor) vacuumSpinor = weakSpinor := by
  have h := exists_evenCliffordGroup_basisSpinor ∅ ({3, 4} : Finset (Fin 5))
    (by decide) (by decide)
  simpa [vacuumSpinor, weakSpinor] using h

end PhysicsSM.Spinor.SpinorTenfold

end
```

### 2. `PhysicsSM/Draft/SpinorTenfoldBasisOrbitAristotle.lean` [exists_evenCliffordGroup_vacuum_weak]

Score: `0.850`

```text
theorem exists_evenCliffordGroup_vacuum_weak :
    ∃ g ∈ evenCliffordGroup,
      (g : Module.End ℂ FockSpinor) vacuumSpinor = weakSpinor := by
  have h := exists_evenCliffordGroup_basisSpinor ∅ ({3, 4} : Finset (Fin 5))
    (by decide) (by decide)
  simpa [vacuumSpinor, weakSpinor] using h

end PhysicsSM.Draft.SpinorTenfoldBasisOrbit

end
```

### 3. `PhysicsSM/Spinor/PureSpinor10.lean` [recording]

Score: `0.835`

```text
import Mathlib

/-!
# Spinor.PureSpinor10

A typed scaffold for Krasnov's `Spin(10)` two-pure-spinor characterization
of the Standard Model gauge group.

## Mathematical context

The positive-chirality Weyl spinor representation of `Spin(10)` is
16-dimensional over `ℂ`. It can be modeled as `Λ^even(ℂ⁵)`, the even part
of the exterior algebra on `ℂ⁵`. A spinor `ψ` is *pure* if it lies in the
`Spin(10)` orbit of a highest-weight vector — equivalently, if it satisfies
certain quadratic (Cartan) purity equations.

Krasnov (arXiv:2209.05088, arXiv:2504.16465) shows that the Standard Model
gauge group `G_SM = S(U(2) × U(3))` can be characterized as the subgroup of
`Spin(10)` that preserves an aligned pair of orthogonal pure spinors.

## This module

This module provides a *typed mathematical interface* — definitions and basic
proved facts — rather than a fake `Spin(10)` Standard Model theorem. It
defines:

- `WeylSpinor10`: the 16-dimensional complex spinor space.
- `spinorInner`: a `ℂ`-valued bilinear pairing on spinors.
- `IsPureSpinor10`: the Cartan purity predicate.
- `PureSpinorOrthogonal`: orthogonality of two spinors.
- `PureSpinorAlignedPair`: two orthogonal pure spinors whose sum is pure.
- `InducedComplexStructurePair`: a structure recording a pair of commuting
  complex structures induced by an aligned pair (placeholder).

Basic facts:
- `PureSpinorOrthogonal.symm`: orthogonality is symmetric.
- `PureSpinorAlignedPair.symm`: the aligned-pair relation is symmetric.
- `PureSpinorAlignedPair.smul`: aligned pairs are stable under simultaneous
  nonzero scalar rescaling.
- `IsPureSpinor10.smul`: pure spinors are stable under nonzero scalar rescaling.

## Claim boundary

This module does NOT:
- Construct the `Spin(10)` group or its Lie algebra.
- Prove the Standard Model
```

### 4. `PhysicsSM/Spinor/SpinorTenfoldPurity.lean` [mem_annihilator_vacuumSpinor_iff]

Score: `0.834`

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

### 5. `AgentTasks/publication-frontier-aristotle-2026-05-06.md` [Job P6: Spin(10) pure-spinor condition scaffold]

Score: `0.833`

```text
## Job P6: Spin(10) pure-spinor condition scaffold

Publication target:

- Target 3 in the frontier backlog.

Write scope:

- `PhysicsSM/Spinor/PureSpinor10.lean`

Goal:

Create a precise scaffold for Krasnov's `Spin(10)` two-pure-spinor
characterization of the Standard Model subgroup. This should be a typed
mathematical interface, not a fake group theorem.

Target declarations:

- a placeholder or finite exterior-algebra model for complex spinors in
  dimension 10, using mathlib APIs if available.
- `IsPureSpinor10`
- `PureSpinorOrthogonal`
- `PureSpinorAlignedPair`, representing orthogonal pure spinors whose sum is
  pure.
- a structure/predicate for the induced commuting complex structures, if
  feasible.

Stretch:

- Prove basic symmetry facts: orthogonality is symmetric, aligned-pair
  projections recover pure spinors, and the pair predicate is stable under
  simultaneous nonzero scalar rescaling.

Sources:

- Krasnov, arXiv:2209.05088:
  <https://arxiv.org/abs/2209.05088>
- Krasnov, arXiv:2504.16465:
  <https://arxiv.org/abs/2504.16465>
```

### 6. `PhysicsSM/Spinor/SpinorTenfoldPurity.lean` [isPureSpinor_vacuumSpinor]

Score: `0.832`

```text
theorem isPureSpinor_vacuumSpinor : IsPureSpinor vacuumSpinor where
  ne_zero := basisSpinor_ne_zero ∅
  even := isEvenSpinor_basisSpinor (by decide)
  quadric := gammaBilinear_basis_basis_eq_zero ∅ ∅ (by decide) (by decide)
```

### 7. `PhysicsSM/Spinor/SpinorTenfoldPurity.lean` [isPureSpinor_vacuum_add_weak]

Score: `0.831`

```text
theorem isPureSpinor_vacuum_add_weak :
    IsPureSpinor (vacuumSpinor + weakSpinor) where
  ne_zero := by
    intro h
    have h0 := congrFun h ∅
    have hne : (∅ : Finset (Fin 5)) ≠ ({3, 4} : Finset (Fin 5)) := by decide
    simp [vacuumSpinor, weakSpinor, basisSpinor, hne] at h0
  even :=
    (isEvenSpinor_basisSpinor (by decide)).add (isEvenSpinor_basisSpinor (by decide))
  quadric := by
    rw [show vacuumSpinor + weakSpinor = vacuumSpinor + weakSpinor from rfl,
      gammaBilinear_polarization, isPureSpinor_vacuumSpinor.quadric,
      isPureSpinor_weakSpinor.quadric, gammaBilinear_vacuum_weak,
      gammaBilinear_weak_vacuum]
    abel

/-- **The concrete Krasnov configuration exists.** The pair
`(1, e₃ ∧ e₄)` is a `d = 3` aligned pure-spinor pair: both pure, gamma-
orthogonal in both orders, sum pure, and the entire projective line through
them satisfies the purity quadric (it is a line on the spinor tenfold).

This is the normal form whose full `Spin(10)`-stabilizer is the Standard Model
gauge group `S(U(2) × U(3))` in the Selector Theorem of the research notes;
the group-level statement is future work (see the claim boundary). -/
```

### 8. `AgentTasks/context-packs/winding-binding-intertwiner-20260709-152910.md` [2. `PhysicsSM/Spinor/SpinorTenfoldPurity.lean` [vacuumSpinor]]

Score: `0.831`

```text
### 2. `PhysicsSM/Spinor/SpinorTenfoldPurity.lean` [vacuumSpinor]

Score: `0.755`

```text
def vacuumSpinor : FockSpinor := basisSpinor ∅

/-- The wedge monomial `e₃ ∧ e₄ ∈ Λ²`: the second spinor of the concrete
`d = 3` Krasnov pair (the `e^c` direction of the hypercharge table). -/
```
```

## Scoped paper hits

### 1. Octonion Internal Space Algebra for the Standard Model

Score: `0.760`
Zotero key: `EPT6PUTC`
arXiv: `2206.06912`
URL: https://arxiv.org/abs/2206.06912

Abstract:

Survey of internal-space algebra for the Standard Model using Clifford algebras with left multiplication by octonions. A distinguished complex structure implements the splitting O = C plus C^3 reflecting lepton-quark symmetry and relates to Pati-Salam and Spin(10) structures.

### 2. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.751`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 3. Two-twistor particle models and free massive higher spin fields

Score: `0.744`
Zotero key: `zotero:MFUJKFEA`
arXiv: `1409.7169`
DOI: `10.1007/JHEP04(2015)010`
URL: https://doi.org/10.1007/JHEP04(2015)010

### 4. Octonions, trace dynamics and non-commutative geometry: a case for unification in spontaneous quantum gravity

Score: `0.744`
Zotero key: `845WNTMG`
arXiv: `2006.16274`
DOI: `10.1515/zna-2020-0196`
URL: http://arxiv.org/abs/2006.16274

Abstract:

We have recently proposed a new matrix dynamics at the Planck scale, building on the theory of trace dynamics. This is a Lagrangian dynamics in which the matrix degrees of freedom are made from Grassmann numbers, and the Lagrangian is trace of a matrix polynomial. Matrices made from even grade elements of the Grassmann algebra are called bosonic, and those made from odd grade elements are called fermionic: together they describe an `aikyon'. In the present article we provide a basic definition of spin angular momentum in this matrix dynamics, and introduce a bosonic (fermionic) configuration variable conjugate to the spin of a boson (fermion). We then show that at energies below Planck scale, where the matrix dynamics reduces to quantum theory, fermions have half-integer spin (in multiples of Planck's constant), and bosons have integral spin. We also show that this definition of spin agrees with the conventional understanding of spin in relativistic quantum mechanics. Consequently, we obtain an elementary proof for the spin-statistics connection. We then motivate why an octonionic space is the natural space in which an aikyon evolves. The group of automorphisms in this space is the exceptional Lie group $G_2$ which has fourteen generators [could they stand for the twelve vector bosons and two degrees of freedom of the graviton? ]. The aikyon also resembles a closed string, and it has been suggested in the literature that 10-D string theory can be represented as a 2-D string in the 8-D octonionic space. From the work of Cohl Furey and others it is known that the Dixon algebra made from the four division algebras [real numbers, complex numbers, quaternions and octonions] can possibly describe the symmetries of the standard model. In the present paper w
...[truncated]

### 5. Spinors and Twistors in Loop Gravity and Spin Foams

Score: `0.743`
Zotero key: `TCC2N3U6`
arXiv: `1201.2120`
URL: http://arxiv.org/abs/1201.2120

Abstract:

Spinorial tools have recently come back to fashion in loop gravity and spin foams. They provide an elegant tool relating the standard holonomy-flux algebra to the twisted geometry picture of the classical phase space on a fixed graph, and to twistors. In these lectures we provide a brief and technical introduction to the formalism and some of its applications.
