/-
Copyright (c) 2026 Harmonic. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Aristotle (Harmonic)
-/
import Mathlib

set_option linter.style.nativeDecide false

/-!
# Stabilizer Plaquette Test (Job S6)

## Goal

Test the quantum-information thesis that signed sedenion zero-product affine
plaquettes define 4-qubit stabilizer states.

## Approach

We work entirely in a finite decidable setting:

* The 4-qubit computational basis is `Fin 16`.
* State vectors are `Fin 16 → ℤ` (integer amplitudes).
* Pauli operators are `±X^u Z^v` parameterized by `(sign, u, v)` where
  `u, v : Fin 16` encode 4-bit vectors in `𝔽₂⁴`.
* The action is `(s · X^u Z^v) |x⟩ = s · (-1)^{v · x} |x ⊕ u⟩`.
* Stabilization is: `ψ(y) = s · (-1)^{v · y} · ψ(y ⊕ u)` for all `y`.

## Main results

For a representative signed zero-product plaquette from the Cayley-Dickson
sedenion multiplication table (the product `(e₁ + e₁₀)(e₄ - e₁₅) = 0`),
we prove:

1. Four explicit Pauli operators each stabilize the plaquette state.
2. The four generators pairwise commute (symplectic orthogonality).
3. The four generators are `𝔽₂`-linearly independent.
4. The full stabilizer group of the plaquette state has exactly 16 elements.
5. The plaquette support `{1, 4, 10, 15}` is an affine 2-plane in `𝔽₂⁴`.

## Convention

The sedenion basis labels follow the Cayley-Dickson convention from
`Sedenions/CayleyDickson_Convention.md`:  `abcd ↔ i^d j^c ℓ^b m^a`.

The plaquette arises from the assessor pair `(i = 1, j = 2)` with
strut `1 ⊕ 2 = 3`, crossed with `(p = 4, q = 7)` with strut `4 ⊕ 7 = 3`.
The sign pattern `(+1, +1, +1, -1)` on support `{1, 4, 10, 15}` comes from
the Cayley-Dickson products:
  `e₁ · e₄ = +e₅`,  `e₁ · e₁₅ = -e₁₄`,
  `e₁₀ · e₄ = -e₁₄`,  `e₁₀ · e₁₅ = +e₅`,
yielding the zero-product relation `(e₁ + e₁₀)(e₄ - e₁₅) = 0`.
-/

namespace StabilizerPlaquettes

/-! ## 1. Finite 𝔽₂⁴ arithmetic -/

/-- Single bit extraction. -/
@[inline] def bitAt (n : Nat) (i : Nat) : Nat := (n >>> i) &&& 1

/-- 𝔽₂-inner product of two 4-bit vectors (encoded as `Fin 16`). -/
@[inline] def dotF2 (u v : Fin 16) : Bool :=
  let a := u.val &&& v.val
  (bitAt a 0 + bitAt a 1 + bitAt a 2 + bitAt a 3) % 2 == 1

/-- XOR of two 4-bit labels. -/
@[inline] def xorF (u v : Fin 16) : Fin 16 :=
  ⟨u.val ^^^ v.val,
    Nat.xor_lt_two_pow (show u.val < 2 ^ 4 from u.isLt)
      (show v.val < 2 ^ 4 from v.isLt)⟩

/-- Phase `(-1)^{v · x}`, encoded as `ℤ`. -/
@[inline] def phase (v x : Fin 16) : ℤ := if dotF2 v x then -1 else 1

/-! ## 2. Signed Pauli operators and stabilization -/

/-- A signed Pauli operator `s · X^u Z^v` on 4 qubits, where `s ∈ {+1, -1}`. -/
structure SignedPauli where
  sign : ℤ
  xPart : Fin 16
  zPart : Fin 16
  deriving DecidableEq, Repr

/-- Integer state vector on the 4-qubit computational basis. -/
abbrev StateVec := Fin 16 → ℤ

/-- The signed Pauli `p` stabilizes `ψ`:
    `ψ(y) = p.sign · (-1)^{p.zPart · y} · ψ(y ⊕ p.xPart)` for all `y`. -/
def stabilizes (p : SignedPauli) (ψ : StateVec) : Prop :=
  ∀ y : Fin 16, ψ y = p.sign * phase p.zPart y * ψ (xorF y p.xPart)

instance instDecidableStabilizes (p : SignedPauli) (ψ : StateVec) :
    Decidable (stabilizes p ψ) :=
  Fintype.decidableForallFintype

/-- Symplectic inner product (mod 2) of two Pauli operators.
    Two Paulis commute iff their symplectic inner product vanishes. -/
def sympDotF2 (p q : SignedPauli) : Bool :=
  dotF2 p.xPart q.zPart == dotF2 p.zPart q.xPart

/-! ## 3. The representative Cayley-Dickson signed plaquette -/

/-- Signed plaquette state from the sedenion zero product
    `(e₁ + e₁₀)(e₄ - e₁₅) = 0`.
    Support `{1, 4, 10, 15}` with signs `(+1, +1, +1, -1)`. -/
def signedPlaq : StateVec := fun x =>
  if x = 1 then 1
  else if x = 4 then 1
  else if x = 10 then 1
  else if x = 15 then -1
  else 0

/-! ## 4. Stabilizer generators -/

/-- Generator 1: `X_{0101} Z_{0010}`.
    Corresponds to an X-translation by `0101` (within the affine plane)
    combined with a Z-correction for the sign pattern. -/
def gen₁ : SignedPauli := ⟨1, 5, 2⟩

/-- Generator 2: `X_{1011} Z_{0100}`. -/
def gen₂ : SignedPauli := ⟨1, 11, 4⟩

/-- Generator 3: `Z_{1010}`.
    Pure Z-stabilizer from the dual of the translation space. -/
def gen₃ : SignedPauli := ⟨1, 0, 10⟩

/-- Generator 4: `−Z_{0111}`.
    Negative-sign Z-stabilizer: `(-1)^{1 + v·x} = 1` on support. -/
def gen₄ : SignedPauli := ⟨-1, 0, 7⟩

/-! ## 5. Core stabilization theorems -/

/-- Generator 1 stabilizes the signed plaquette. -/
theorem gen₁_stabilizes : stabilizes gen₁ signedPlaq := by decide

/-- Generator 2 stabilizes the signed plaquette. -/
theorem gen₂_stabilizes : stabilizes gen₂ signedPlaq := by decide

/-- Generator 3 stabilizes the signed plaquette. -/
theorem gen₃_stabilizes : stabilizes gen₃ signedPlaq := by decide

/-- Generator 4 stabilizes the signed plaquette. -/
theorem gen₄_stabilizes : stabilizes gen₄ signedPlaq := by decide

/-! ## 6. Commutativity -/

theorem gen₁₂_commute : sympDotF2 gen₁ gen₂ = true := by decide
theorem gen₁₃_commute : sympDotF2 gen₁ gen₃ = true := by decide
theorem gen₁₄_commute : sympDotF2 gen₁ gen₄ = true := by decide
theorem gen₂₃_commute : sympDotF2 gen₂ gen₃ = true := by decide
theorem gen₂₄_commute : sympDotF2 gen₂ gen₄ = true := by decide
theorem gen₃₄_commute : sympDotF2 gen₃ gen₄ = true := by decide

/-- All four generators pairwise commute (symplectic orthogonality). -/
theorem generators_pairwise_commute :
    sympDotF2 gen₁ gen₂ = true ∧ sympDotF2 gen₁ gen₃ = true ∧
    sympDotF2 gen₁ gen₄ = true ∧ sympDotF2 gen₂ gen₃ = true ∧
    sympDotF2 gen₂ gen₄ = true ∧ sympDotF2 gen₃ gen₄ = true :=
  ⟨gen₁₂_commute, gen₁₃_commute, gen₁₄_commute,
   gen₂₃_commute, gen₂₄_commute, gen₃₄_commute⟩

/-! ## 7. 𝔽₂-linear independence -/

/-- XOR-sum of a subset (selected by a 4-bit mask) of four `Fin 16` values. -/
def maskXorSum (mask : Fin 16) (v₁ v₂ v₃ v₄ : Fin 16) : Fin 16 :=
  let s₁ : Fin 16 := if (mask.val >>> 0) &&& 1 = 1 then v₁ else 0
  let s₂ : Fin 16 := if (mask.val >>> 1) &&& 1 = 1 then v₂ else 0
  let s₃ : Fin 16 := if (mask.val >>> 2) &&& 1 = 1 then v₃ else 0
  let s₄ : Fin 16 := if (mask.val >>> 3) &&& 1 = 1 then v₄ else 0
  xorF (xorF (xorF s₁ s₂) s₃) s₄

/-- The four generators are `𝔽₂`-linearly independent: no nonempty subset
    of `{(xPart, zPart)}` vectors has XOR-sum `(0, 0)`. -/
theorem generators_independent :
    ∀ mask : Fin 16, mask ≠ 0 →
      ¬(maskXorSum mask 5 11 0 0 = 0 ∧ maskXorSum mask 2 4 10 7 = 0) := by
  native_decide

/-! ## 8. Full stabilizer group has exactly 16 elements -/

/-- Computable count of all signed Pauli stabilizers of a state vector. -/
def stabilizerCountFlat (ψ : StateVec) : Nat :=
  let entries := do
    let s ← [1, -1]
    let x ← List.finRange 16
    let z ← List.finRange 16
    if decide (stabilizes ⟨s, x, z⟩ ψ) then return (s, x, z) else []
  entries.length

/-- The signed plaquette state has exactly 16 signed Pauli stabilizers,
    confirming it is a proper 4-qubit stabilizer state. -/
theorem stabilizer_count_eq_16 : stabilizerCountFlat signedPlaq = 16 := by native_decide

/-! ## 9. Affine plane structure of the support -/

/-- The four support indices. -/
def support : List (Fin 16) := [1, 4, 10, 15]

/-- The translation space `V = {0, 5, 11, 14}` of the affine 2-plane. -/
def translationSpace : List (Fin 16) := [0, 5, 11, 14]

/-- The support is closed under translation by elements of `V`:
    for every `x ∈ support` and `v ∈ V`, `x ⊕ v ∈ support`. -/
theorem support_closed_under_translation :
    ∀ x ∈ support, ∀ v ∈ translationSpace, xorF x v ∈ support := by decide

/-- The translation space is closed under XOR (it is an 𝔽₂-subspace). -/
theorem translationSpace_closed :
    ∀ u ∈ translationSpace, ∀ v ∈ translationSpace,
      xorF u v ∈ translationSpace := by decide

/-- The translation space has 4 = 2² elements (dimension 2). -/
theorem translationSpace_card : translationSpace.length = 4 := by decide

/-- The support is a coset of the translation space (affine 2-plane):
    translating any support element by all of V recovers the full support. -/
theorem support_is_coset :
    ∀ x ∈ support,
      (translationSpace.map (xorF x)).toFinset = support.toFinset := by decide

/-! ## 10. Cayley-Dickson sign verification -/

/-- Recursive Cayley-Dickson product sign and index for basis vectors.
    `cdMulBasis n a b = (sign, index)` means `eₐ · eᵦ = sign · e_index`
    in the `2ⁿ`-dimensional Cayley-Dickson algebra. -/
def cdMulBasis : (n : Nat) → Nat → Nat → ℤ × Nat
  | 0, _, _ => (1, 0)
  | n + 1, a, b =>
    let half := 1 <<< n
    let ah := a / half
    let al := a % half
    let bh := b / half
    let bl := b % half
    if ah == 0 && bh == 0 then
      cdMulBasis n al bl
    else if ah == 0 then  -- bh = 1
      let (s, k) := cdMulBasis n bl al
      (s, k + half)
    else if bh == 0 then  -- ah = 1
      let (s, k) := cdMulBasis n al bl
      (s * (if bl == 0 then 1 else -1), k + half)
    else  -- ah = 1, bh = 1
      let (s, k) := cdMulBasis n bl al
      (-(if bl == 0 then 1 else -1) * s, k)

/-- `e₁ · e₄ = +e₅` in the sedenion algebra. -/
theorem cd_e1_e4 : cdMulBasis 4 1 4 = (1, 5) := by native_decide

/-- `e₁ · e₁₅ = -e₁₄` in the sedenion algebra. -/
theorem cd_e1_e15 : cdMulBasis 4 1 15 = (-1, 14) := by native_decide

/-- `e₁₀ · e₄ = -e₁₄` in the sedenion algebra. -/
theorem cd_e10_e4 : cdMulBasis 4 10 4 = (-1, 14) := by native_decide

/-- `e₁₀ · e₁₅ = +e₅` in the sedenion algebra. -/
theorem cd_e10_e15 : cdMulBasis 4 10 15 = (1, 5) := by native_decide

/-!
From these four products:
  `(e₁ + e₁₀)(e₄ - e₁₅) = e₅ + e₁₄ - e₁₄ - e₅ = 0`,
confirming the zero-product relation and the sign pattern `(+1, +1, +1, -1)`
on support `{1, 4, 10, 15}`.
-/

/-! ## 11. The uniform plaquette is also a stabilizer state -/

/-- Uniform (all +1) plaquette on the same support. -/
def uniformPlaq : StateVec := fun x =>
  if x = 1 || x = 4 || x = 10 || x = 15 then 1 else 0

/-- The uniform plaquette also has 16 stabilizers (it is a stabilizer state). -/
theorem uniform_stabilizer_count_eq_16 :
    stabilizerCountFlat uniformPlaq = 16 := by native_decide

/-- Stabilizer generators for the uniform plaquette:
    `X_{0101}`, `X_{1011}`, `Z_{1010}`, `−Z_{0111}`. -/
def ugen₁ : SignedPauli := ⟨1, 5, 0⟩
def ugen₂ : SignedPauli := ⟨1, 11, 0⟩
def ugen₃ : SignedPauli := ⟨1, 0, 10⟩
def ugen₄ : SignedPauli := ⟨-1, 0, 7⟩

theorem ugen₁_stabilizes : stabilizes ugen₁ uniformPlaq := by decide
theorem ugen₂_stabilizes : stabilizes ugen₂ uniformPlaq := by decide
theorem ugen₃_stabilizes : stabilizes ugen₃ uniformPlaq := by decide
theorem ugen₄_stabilizes : stabilizes ugen₄ uniformPlaq := by decide

/-! ## 12. XOR is the sedenion product index rule -/

/-- In the Cayley-Dickson convention, the product of two basis vectors
    always lands on the XOR index (the sign varies). -/
theorem cd_product_index_is_xor :
    ∀ a b : Fin 16, (cdMulBasis 4 a.val b.val).2 = (xorF a b).val := by native_decide

/-! ## 13. Dot product and XOR properties -/

/-- The F₂ dot product is symmetric. -/
theorem dotF2_comm : ∀ u v : Fin 16, dotF2 u v = dotF2 v u := by decide

/-- `dotF2 0 v = false` for all `v`. -/
theorem dotF2_zero_left : ∀ v : Fin 16, dotF2 0 v = false := by decide

/-- XOR is self-inverse. -/
theorem xorF_self : ∀ u : Fin 16, xorF u u = 0 := by decide

/-- XOR is commutative. -/
theorem xorF_comm : ∀ u v : Fin 16, xorF u v = xorF v u := by decide

/-- XOR with zero is identity. -/
theorem xorF_zero : ∀ u : Fin 16, xorF u 0 = u := by decide

end StabilizerPlaquettes
