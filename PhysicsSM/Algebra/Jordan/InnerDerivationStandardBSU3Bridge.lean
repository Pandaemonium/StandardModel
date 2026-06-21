import Mathlib
import PhysicsSM.Algebra.Jordan.InnerDerivationStandardBLieSubalgebra

/-!
# Algebra.Jordan.InnerDerivationStandardBSU3Bridge

Eight explicit inner-derivation generator candidates for the `su(3)`-shaped
Lie subalgebra inside `Der(h₃(𝕆))`.

## Mathematical context

The expected Lie subalgebra of inner derivations `D_{a,b}` with
`a, b ∈ h₃(ℂ)` should be isomorphic to `su(3)` and therefore have
dimension 8. This file proves a concrete first step toward that target by
exhibiting eight explicit generator candidates built from Gell-Mann-like
elements of `h₃(ℂ)`.

The Gell-Mann matrices `λ₁, …, λ₈` are 3×3 traceless Hermitian matrices
that form a basis of `su(3)` (via `X ↦ iX`). In the `H3O` coordinate model:

- **Diagonal** elements like `λ₃ = diag(1,−1,0)` and `√3 λ₈ = diag(1,1,−2)`
  set only `alpha`, `beta`, `gamma`.
- **Off-diagonal** elements like `λ₁` set one of `x`, `y`, `z` to a unit
  octonion in the chosen complex line `ℂ = span_ℝ{1, e₁₁₁}`.

## Main declarations

- `gellMannH3O` — nine convenient Gell-Mann-like elements of `h₃(ℂ)`.
- `gellMannH3O_inStandardB` — every basis element lies in `InStandardB`.
- `standardBInnerDerivationGenerator` — eight generators indexed by `Fin 8`,
  each an inner derivation `D_{λᵢ, λⱼ}`.
- `standardB_innerDerivation_eight_generators_mem` — every generator lies in
  `innerDerivationStandardBSubspace`.
- `StandardBSU3BridgePackage` — a bundled record summarizing all results.

## Claim boundary

This file defines eight generator candidates and proves their membership in the
inner derivation subspace from `h₃(ℂ)`. It does **not** prove:
- Linear independence of the eight generators (dimension = 8).
- An explicit Lie algebra isomorphism with `su(3)`.

## Status

Trusted module — no `s o r r y`.
-/

namespace PhysicsSM.Algebra.Jordan.H3O

open PhysicsSM.Algebra.Jordan.Derivation
open PhysicsSM.Algebra.Jordan.H3OJordan
open PhysicsSM.Algebra.Octonion

local infixl:70 " ○ " => jordanProduct

/-! ## Octonion constants -/

/-- The unit real octonion `1 = (1,0,…,0)`. -/
private def octOne : Octonion := ⟨1, 0, 0, 0, 0, 0, 0, 0⟩

/-- The chosen imaginary unit `e₁₁₁ = (0,0,…,0,1)`. -/
private def octI : Octonion := ⟨0, 0, 0, 0, 0, 0, 0, 1⟩

private theorem octOne_inComplexLine : InChosenComplexLine octOne :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

private theorem octI_inComplexLine : InChosenComplexLine octI :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

private theorem neg_octI_inComplexLine : InChosenComplexLine (-octI) := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> simp [octI]

/-! ## Gell-Mann-like elements of h₃(ℂ)

The nine Gell-Mann-like elements of `h₃(ℂ)` cover:
- Three off-diagonal real-part matrices (indices 0, 3, 5 → λ₁, λ₄, λ₆).
- Three off-diagonal imaginary-part matrices (indices 1, 4, 6 → λ₂, λ₅, λ₇).
- Three diagonal matrices (indices 2, 7, 8 → λ₃, √3·λ₈, 1).

The matrix convention is:
```
[[α,      z,       conj(y)],
 [conj(z), β,       x      ],
 [y,       conj(x), γ      ]]
```
-/

/-- The nine convenient Gell-Mann-like elements of `h₃(ℂ)`. -/
def gellMannH3O : Fin 9 → H3O
  -- λ₁: z-real (entry (1,2) real part)
  | ⟨0, _⟩ => ⟨0, 0, 0, 0, 0, octOne⟩
  -- λ₂: z-imaginary (entry (1,2) imaginary part, z = −e₁₁₁)
  | ⟨1, _⟩ => ⟨0, 0, 0, 0, 0, -octI⟩
  -- λ₃: diagonal (1,−1,0)
  | ⟨2, _⟩ => ⟨1, -1, 0, 0, 0, 0⟩
  -- λ₄: y-real (entry (3,1) real part)
  | ⟨3, _⟩ => ⟨0, 0, 0, 0, octOne, 0⟩
  -- λ₅: y-imaginary (entry (3,1) imaginary part, y = e₁₁₁)
  | ⟨4, _⟩ => ⟨0, 0, 0, 0, octI, 0⟩
  -- λ₆: x-real (entry (2,3) real part)
  | ⟨5, _⟩ => ⟨0, 0, 0, octOne, 0, 0⟩
  -- λ₇: x-imaginary (entry (2,3) imaginary part, x = −e₁₁₁)
  | ⟨6, _⟩ => ⟨0, 0, 0, -octI, 0, 0⟩
  -- √3·λ₈: diagonal (1,1,−2)
  | ⟨7, _⟩ => ⟨1, 1, -2, 0, 0, 0⟩
  -- identity: diagonal (1,1,1) — useful for spanning the full h₃(ℂ)
  | ⟨8, _⟩ => ⟨1, 1, 1, 0, 0, 0⟩

private theorem zz : InChosenComplexLine (0 : Octonion) := zero_inChosenComplexLine

/-- Every Gell-Mann basis element lies in `h₃(ℂ)`. -/
theorem gellMannH3O_inStandardB : ∀ i : Fin 9, InStandardB (gellMannH3O i) := by
  intro i; fin_cases i <;> simp only [gellMannH3O, InStandardB]
  -- λ₁: z = octOne
  · exact ⟨zz, zz, octOne_inComplexLine⟩
  -- λ₂: z = -octI
  · exact ⟨zz, zz, neg_octI_inComplexLine⟩
  -- λ₃: diagonal, all off-diagonal zero
  · exact ⟨zz, zz, zz⟩
  -- λ₄: y = octOne
  · exact ⟨zz, octOne_inComplexLine, zz⟩
  -- λ₅: y = octI
  · exact ⟨zz, octI_inComplexLine, zz⟩
  -- λ₆: x = octOne
  · exact ⟨octOne_inComplexLine, zz, zz⟩
  -- λ₇: x = -octI
  · exact ⟨neg_octI_inComplexLine, zz, zz⟩
  -- √3·λ₈: diagonal
  · exact ⟨zz, zz, zz⟩
  -- identity: diagonal
  · exact ⟨zz, zz, zz⟩

/-! ## Eight inner-derivation generators

We choose eight pairs from the Gell-Mann basis to form inner derivations.
Each pair `(a, b)` is chosen so that the associative commutator `[a, b]`
(which controls the inner derivation on a special Jordan algebra) points in
an independent direction of `su(3)`.

| Generator | Pair         | su(3) direction |
|-----------|-------------|-----------------|
| G₀        | (λ₁, λ₂)   | ∝ ad(iλ₃)      |
| G₁        | (λ₃, λ₁)   | ∝ ad(iλ₂)      |
| G₂        | (λ₂, λ₃)   | ∝ ad(iλ₁)      |
| G₃        | (λ₃, λ₄)   | ∝ ad(iλ₅)      |
| G₄        | (λ₃, λ₅)   | ∝ ad(−iλ₄)     |
| G₅        | (λ₂, λ₄)   | ∝ ad(iλ₆)      |
| G₆        | (λ₁, λ₄)   | ∝ ad(iλ₇)      |
| G₇        | (λ₆, λ₇)   | ∝ ad(i(√3λ₈+λ₃)) |
-/

/-- The eight pairs (i, j) indexing `gellMannH3O` used to form generators. -/
private def generatorPairs : Fin 8 → Fin 9 × Fin 9
  | ⟨0, _⟩ => (⟨0, by omega⟩, ⟨1, by omega⟩)  -- (λ₁, λ₂)
  | ⟨1, _⟩ => (⟨2, by omega⟩, ⟨0, by omega⟩)  -- (λ₃, λ₁)
  | ⟨2, _⟩ => (⟨1, by omega⟩, ⟨2, by omega⟩)  -- (λ₂, λ₃)
  | ⟨3, _⟩ => (⟨2, by omega⟩, ⟨3, by omega⟩)  -- (λ₃, λ₄)
  | ⟨4, _⟩ => (⟨2, by omega⟩, ⟨4, by omega⟩)  -- (λ₃, λ₅)
  | ⟨5, _⟩ => (⟨1, by omega⟩, ⟨3, by omega⟩)  -- (λ₂, λ₄)
  | ⟨6, _⟩ => (⟨0, by omega⟩, ⟨3, by omega⟩)  -- (λ₁, λ₄)
  | ⟨7, _⟩ => (⟨5, by omega⟩, ⟨6, by omega⟩)  -- (λ₆, λ₇)

/-- The eight inner-derivation generators of the `su(3)` subalgebra.
    Each generator is `D_{gellMannH3O i, gellMannH3O j}` for specific pairs. -/
noncomputable def standardBInnerDerivationGenerator : Fin 8 → H3ODerivation :=
  fun k =>
    let p := generatorPairs k
    innerDerivation (gellMannH3O p.1) (gellMannH3O p.2)

/-- Every generator lies in `innerDerivationStandardBSubspace`. -/
theorem standardB_innerDerivation_eight_generators_mem :
    ∀ i : Fin 8, standardBInnerDerivationGenerator i ∈
      innerDerivationStandardBSubspace := by
  intro i
  simp only [standardBInnerDerivationGenerator]
  exact innerDerivation_standardB_mem_subspace
    (gellMannH3O_inStandardB _) (gellMannH3O_inStandardB _)

/-! ## Span inclusion -/

/-- The range of the eight generators is contained in the StandardB
    inner-derivation subspace. -/
theorem standardBInnerDerivationGenerator_range_subset :
    Set.range standardBInnerDerivationGenerator ⊆
      ↑innerDerivationStandardBSubspace := by
  rintro D ⟨i, rfl⟩
  exact standardB_innerDerivation_eight_generators_mem i

/-- The span of the eight generators is contained in the StandardB
    inner-derivation subspace. -/
theorem span_standardBInnerDerivationGenerator_le :
    Submodule.span ℝ (Set.range standardBInnerDerivationGenerator) ≤
      innerDerivationStandardBSubspace :=
  Submodule.span_le.mpr standardBInnerDerivationGenerator_range_subset

/-! ## Bracket closure from the Lie subalgebra -/

/-- The bracket of any two elements of `innerDerivationStandardBSubspace`
    stays in the subspace — re-exported for convenience. -/
theorem innerDerivStandardB_bracket_mem
    {D E : H3ODerivation}
    (hD : D ∈ innerDerivationStandardBSubspace)
    (hE : E ∈ innerDerivationStandardBSubspace) :
    ⁅D, E⁆ ∈ innerDerivationStandardBSubspace :=
  innerDerivationStandardBSubspace_closed_bracket hD hE

/-- The bracket of any two generators lies in `innerDerivationStandardBSubspace`. -/
theorem standardBGenerator_bracket_mem (i j : Fin 8) :
    ⁅standardBInnerDerivationGenerator i,
     standardBInnerDerivationGenerator j⁆ ∈
      innerDerivationStandardBSubspace :=
  innerDerivStandardB_bracket_mem
    (standardB_innerDerivation_eight_generators_mem i)
    (standardB_innerDerivation_eight_generators_mem j)

/-! ## Bundled package -/

/-- Package recording the eight generators and their properties. -/
structure StandardBSU3BridgePackage where
  /-- The eight generator derivations. -/
  generators : Fin 8 → H3ODerivation
  /-- Each generator is an inner derivation from h₃(ℂ) elements. -/
  generators_fromStandardB :
    ∀ i : Fin 8, ∃ a b : H3O, InStandardB a ∧ InStandardB b ∧
      generators i = innerDerivation a b
  /-- Each generator lies in the StandardB inner-derivation subspace. -/
  generators_mem :
    ∀ i : Fin 8, generators i ∈ innerDerivationStandardBSubspace
  /-- The bracket of any two generators lies in the subspace. -/
  bracket_closure :
    ∀ i j : Fin 8,
      ⁅generators i, generators j⁆ ∈ innerDerivationStandardBSubspace

/-- Each generator is explicitly an inner derivation from Gell-Mann-like elements. -/
private theorem standardBInnerDerivationGenerator_fromStandardB (k : Fin 8) :
    ∃ a b : H3O, InStandardB a ∧ InStandardB b ∧
      standardBInnerDerivationGenerator k = innerDerivation a b := by
  refine ⟨gellMannH3O (generatorPairs k).1, gellMannH3O (generatorPairs k).2,
    gellMannH3O_inStandardB _, gellMannH3O_inStandardB _, ?_⟩
  rfl

/-- The canonical instance of the SU(3) bridge package. -/
noncomputable def standardBSU3BridgePackage : StandardBSU3BridgePackage where
  generators := standardBInnerDerivationGenerator
  generators_fromStandardB := standardBInnerDerivationGenerator_fromStandardB
  generators_mem := standardB_innerDerivation_eight_generators_mem
  bracket_closure := standardBGenerator_bracket_mem

end PhysicsSM.Algebra.Jordan.H3O
