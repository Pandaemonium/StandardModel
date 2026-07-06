import PhysicsSM.Draft.NullEdge.GrandMassCapstone
import PhysicsSM.Algebra.Furey.OctonionMassCoupling

/-!
# The Grand Null-Edge Mass Capstone — **unconditional** form

`PhysicsSM.Draft.NullEdge.GrandMassCapstoneUncond`

## What this file *is*

The companion module `GrandMassCapstone` proves `grandMassCapstone`, an honest
bundle of one representative per lane of the null-edge mass program.  That
theorem carries **one** hypothesis, `hOct : OctSplitMassNotCentral` — the
octonion-coupling fact that a mass grading is *not central* with respect to the
color action ("coupling beyond mere co-location").

The sibling module `OctonionMassCoupling` **proves exactly that fact** at the
induced-linear-operator level: `mass_not_central_of_split` shows that a *split*
(non-degenerate) diagonal mass matrix `M = diag(m0, m1, m2)` with `m0 ≠ m1` fails
to commute with the `su(3)` color ladder `T23m`, i.e. `M · T23 ≠ T23 · M`.

This file **discharges** the hypothesis: it constructs the `OctSplitMassNotCentral`
witness from `OctonionMassCoupling.mass_not_central_of_split` using a concrete
split mass (`m0 = 0 ≠ 1 = m1`), and then states `grandMassCapstoneUnconditional`
— the same grand bundle with **no octonion hypothesis at all**.

## Honest scope (unchanged from the conditional capstone)

Nothing about the mathematical grade of any conjunct changes here.  This is a
bundle of finite, kernel-checked, **distinct** obstruction results — it is:

* **NOT** the SU(N) Yang–Mills mass gap (a Clay/Millennium problem),
* **NOT** a continuum quantum field theory,
* **NOT** a derivation of any physical mass value.

The only thing accomplished beyond `grandMassCapstone` is *logical*: the octonion
antecedent is no longer assumed, because it is supplied by a proved finite matrix
identity (`OctonionMassCoupling.mass_not_central_of_split`).  Concretely,
`OctSplitMassNotCentral` asks for *some* magma with a distinguished element that
fails to commute with another element; we take the magma of `3 × 3` complex
matrices, the mass grading `massM 0 1 2`, and the color ladder `T23m`, and the
non-commutation is exactly the proved coupling.  The faithfulness caveat of
`OctonionMassCoupling` (the generators are reconstructed to match the color
triplet action table of `ColorTripletFundamental`, whose upstream octonion stack
was absent from this build) carries over verbatim and is **not** re-litigated.

## Axiom footprint

The final theorem uses only Lean/Mathlib standard axioms (`propext`,
`Classical.choice`, `Quot.sound`).  No `sorry`, no `axiom`, no `native_decide`.
See the `#print axioms grandMassCapstoneUnconditional` guard at the end.
-/

namespace PhysicsSM.Draft.NullEdge.GrandMassCapstoneUncond

open PhysicsSM.Draft.NullEdge.GrandMassCapstone
open PhysicsSM.Algebra.Furey.OctonionMassCoupling

/-! ## Discharging the octonion hypothesis

The witness for `OctSplitMassNotCentral` is the magma `Matrix (Fin 3) (Fin 3) ℂ`
with distinguished "mass" element `massM 0 1 2 = diag(0,1,2)` and the color ladder
`T23m`; the non-commutation `massM 0 1 2 * T23m ≠ T23m * massM 0 1 2` is exactly
`OctonionMassCoupling.mass_not_central_of_split` at the concrete split `m0 = 0 ≠
1 = m1`. -/

/-- The octonion split-mass non-centrality fact, **proved** (no longer a
hypothesis): built from `OctonionMassCoupling.mass_not_central_of_split` with the
concrete non-degenerate mass grading `diag(0, 1, 2)`. -/
theorem octSplitMassNotCentral_holds : OctSplitMassNotCentral :=
  ⟨Matrix (Fin 3) (Fin 3) ℂ, inferInstance,
    massM 0 1 2, T23m, mass_not_central_of_split (by norm_num)⟩

/-! ## The unconditional grand capstone -/

/-- **The Grand Null-Edge Mass Capstone (unconditional).**

The identical honest conjunction of one representative per lane as in
`grandMassCapstone`, but with **no hypothesis**: the octonion factorization
("split mass not central") is discharged by `octSplitMassNotCentral_holds`, which
in turn is the proved finite matrix identity
`OctonionMassCoupling.mass_not_central_of_split`.

This remains a bundle of finite, kernel-checked, distinct obstruction results —
**not** the Yang–Mills mass gap, **not** a continuum theory, **not** a derivation
of physical masses.  See the module docstring of `GrandMassCapstone` for the
grade of each conjunct; nothing about those grades changes here. -/
theorem grandMassCapstoneUnconditional :
    -- (A) aperture
    A_masslessIffCollinear ∧
    A_entropyIff ∧
    -- (T) turn
    T_crossCountZero ∧
    T_GWExists ∧
    -- (C) closure
    C_rpChain ∧
    C_tensionNonneg ∧
    C_tyAreaLaw ∧
    -- (X) taxonomy
    X_taxonomy ∧
    -- (B) division algebra
    B_su3Coloc ∧
    OctSplitMassNotCentral ∧
    -- (V) trust (realized by the `#print axioms` guard below)
    True :=
  grandMassCapstone octSplitMassNotCentral_holds

/-! ## Trust guard (lane V)

`#print axioms` must report only the standard `propext / Classical.choice /
Quot.sound` axioms.  No `sorry`, no `native_decide`, no custom `axiom` — and, in
particular, no leftover hypothesis. -/

/-- info: 'PhysicsSM.Draft.NullEdge.GrandMassCapstoneUncond.grandMassCapstoneUnconditional' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms grandMassCapstoneUnconditional

end PhysicsSM.Draft.NullEdge.GrandMassCapstoneUncond
