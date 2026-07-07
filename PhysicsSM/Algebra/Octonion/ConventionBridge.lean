import PhysicsSM.Algebra.Octonion.Basic

/-!
# Algebra.Octonion.ConventionBridge

Explicit translation between the project XOR convention and the Baez/Furey conventions.

## Summary

The project XOR convention and Baez (2002) differ by:
1. A **permutation** of the seven imaginary basis labels.
2. A **sign flip** on exactly one basis element (Baez e₅ → −e100 in XOR).

The full map, with canonical choice s₁=s₂=s₃=+1, is:

| Baez | XOR   | Sign |
|------|-------|------|
| e₁   | e001  | +1   |
| e₂   | e010  | +1   |
| e₃   | e110  | +1   |
| e₄   | e011  | +1   |
| e₅   | e100  | **−1** ← only sign flip |
| e₆   | e101  | +1   |
| e₇   | e111  | +1   |

This map sends every Baez positive triple to the correct XOR product.
Verified: all 21 forward products and 21 reversed products pass against
`Scripts/oracle/validate_octonion.py`. See also `Index/convention_bridge.json`.

## Furey ladder operators in XOR convention

Furey (arXiv:1806.00612) defines in Baez convention:
  α₁ = (−e₅ + i·e₄) / 2
  α₂ = (−e₃ + i·e₁) / 2
  α₃ = (−e₆ + i·e₂) / 2

After applying the permutation and sign correction:
  α₁ (XOR) = (+e100 + i·e011) / 2
  α₂ (XOR) = (−e110 + i·e001) / 2
  α₃ (XOR) = (−e101 + i·e010) / 2

These definitions live in `PhysicsSM.Algebra.Furey.LadderOperators`.

## Safety rule

Every formula from Baez (2002) or Furey (2015–2018) that refers to
a specific basis element must be checked against this module before use.
The ConventionBridge lemmas are the proof of correctness; informal
"it's the same convention" is not sufficient.

## Source

Sign corrections computed by `Scripts/oracle/validate_convention_bridge.py`.
Provenance: clean-room derivation, no external code copied.
-/

namespace PhysicsSM.Algebra.Octonion.ConventionBridge

/-! ## Label permutation -/

/-- Permutation sending Baez (2002) imaginary-unit indices to project XOR
    decimal indices. Unit (index 0) maps to unit. Imaginary units 1–7 are
    permuted as: 1↦1, 2↦2, 3↦6, 4↦3, 5↦4, 6↦5, 7↦7.

    Derivation: match the seven Fano lines of Baez's mod-7 convention
    against the XOR lines. The unique index-permutation that maps all
    seven Baez lines to XOR lines is this function.
    Verified by `Scripts/oracle/validate_convention_bridge.py`. -/
def baezToXORIndex : Fin 8 → Fin 8
  | ⟨0, _⟩ => ⟨0, by omega⟩  -- unit -> unit
  | ⟨1, _⟩ => ⟨1, by omega⟩  -- e1  -> e001
  | ⟨2, _⟩ => ⟨2, by omega⟩  -- e2  -> e010
  | ⟨3, _⟩ => ⟨6, by omega⟩  -- e3  -> e110
  | ⟨4, _⟩ => ⟨3, by omega⟩  -- e4  -> e011
  | ⟨5, _⟩ => ⟨4, by omega⟩  -- e5  -> e100
  | ⟨6, _⟩ => ⟨5, by omega⟩  -- e6  -> e101
  | ⟨7, _⟩ => ⟨7, by omega⟩  -- e7  -> e111

/-! ## Sign correction -/

/-- Sign correction for the Baez→XOR translation. For each Baez imaginary
    unit index i, the corresponding XOR basis element is
      `baezToXORSign i * basisElem (baezToXORIndex i)`.

    Only Baez e₅ (index 5) requires a sign flip (value −1).
    All other imaginaries and the unit map with sign +1.

    Canonical choice: s₁=s₂=s₃=+1 (three degrees of freedom from
    sign-flipping pairs of basis elements). Other valid sign vectors
    differ by flipping an even number of signs consistently. -/
def baezToXORSign (i : Fin 8) : ℤ :=
  if i = ⟨5, by omega⟩ then -1 else 1

/-! ## Combined translation -/

/-- The full Baez→XOR basis translation: given a Baez imaginary-unit index i,
    returns the signed XOR basis element `f(eᵢ) = baezToXORSign(i) * e_{π(i)}`.

    This is the function that must be applied to every Baez formula before
    using it in the project convention. -/
def baezBasisInXOR (i : Fin 8) : Octonion :=
  let xi := baezToXORIndex i
  let si := baezToXORSign i
  if si = 1 then basisElem xi else -(basisElem xi)

/-! ## Baez oriented Fano lines -/

/-- The seven positive oriented Fano lines of Baez (2002), in Baez indices.
Each entry `(a, b, c)` records the Baez product `e_a * e_b = e_c`, using the
cyclic convention `e_i * e_{i+1} = e_{i+3}` with indices taken mod `7` in
`1..7`. -/
def baezTriples : List (Fin 8 × Fin 8 × Fin 8) :=
  [ (⟨1, by omega⟩, ⟨2, by omega⟩, ⟨4, by omega⟩)
  , (⟨2, by omega⟩, ⟨3, by omega⟩, ⟨5, by omega⟩)
  , (⟨3, by omega⟩, ⟨4, by omega⟩, ⟨6, by omega⟩)
  , (⟨4, by omega⟩, ⟨5, by omega⟩, ⟨7, by omega⟩)
  , (⟨5, by omega⟩, ⟨6, by omega⟩, ⟨1, by omega⟩)
  , (⟨6, by omega⟩, ⟨7, by omega⟩, ⟨2, by omega⟩)
  , (⟨7, by omega⟩, ⟨1, by omega⟩, ⟨3, by omega⟩) ]

/-! ## Correctness statement -/

/--
`baezBasisInXOR` intertwines the Baez oriented Fano line products with the
project XOR multiplication.

For every positive Baez Fano line `e_a * e_b = e_c`, the translated signed XOR
basis elements satisfy the same product under the project's `Octonion`
multiplication:

  `baezBasisInXOR a * baezBasisInXOR b = baezBasisInXOR c`.

This is exactly the correctness property the module docstring describes: the
permutation `baezToXORIndex` together with the single sign flip
`baezToXORSign` makes the translation product-preserving on all seven oriented
Fano lines.
-/
theorem baez_line_products :
    ∀ t ∈ baezTriples,
      baezBasisInXOR t.1 * baezBasisInXOR t.2.1 = baezBasisInXOR t.2.2 := by
  intro t ht
  fin_cases ht <;>
    (ext <;>
      simp [baezBasisInXOR, baezToXORIndex, baezToXORSign, basisElem])

/-- info: 'PhysicsSM.Algebra.Octonion.ConventionBridge.baez_line_products' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms baez_line_products

end PhysicsSM.Algebra.Octonion.ConventionBridge
