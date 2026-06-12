import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldGammaSymm

/-!
# Spinor.SpinorTenfoldFierzKernel

Kernel-checkable closed-form machinery for the basis-level symmetrized
`Spin(10)` Fierz identity.

The key fact is that `cliffordActionZ (gBasisZ S T) (basisZ U)` is **a single
signed wedge monomial** (the closed form `termData S T U`): the `a`-half of
`gBasisZ S T` is supported on the unique index `i ∈ S` with `S.erase i = Tᶜ`,
and the `b`-half on the unique `i ∉ S` with `insert i S = Tᶜ`, and the two
halves require incompatible cardinalities, so at most one monomial survives.

This reduces the symmetrized Fierz identity to a finite per-configuration sign
cancellation that the Lean kernel can check by `decide` on the cheap
`(coeff, target)` data, with no `native_decide`.

## Provenance

Proofs produced by the Aristotle proof agent
(job `93e29d35-37f8-4c3c-bad7-02b5fca82612`, task
`AgentTasks/spin10-fierz-kernel-decide-aristotle-2026-06-10.md`) and reviewed
for semantic alignment. The identity is independently verified by
`Scripts/oracle/validate_spinor_tenfold.py`. The main theorems built on
`fierzZ_three` are in `PhysicsSM.Spinor.SpinorTenfoldFierz`.

The original `cancel_all` was a single kernel `decide` over all `32³` triples of
subsets of `Fin 5`, which spends roughly seven minutes reducing
`Finset`/`Multiset` operations in the kernel. It is now derived (with the same
statement) from a much cheaper `decide` run on a `Nat` bit-mask mirror of the
combinatorics (`Fz.cancelAllN`), transported back through the encoding
`enc32`/`dec32`. The kernel reduces the bit-mask model with its native integer
arithmetic over only the `16³` even codes, so the module builds in well under a
minute. The definitions `gBasisZ`, `termData`, `cliffordActionZ`, `cancel3`, and
all sign conventions are unchanged.

Status: trusted — no `sorry`, no `axiom` (in particular no `native_decide`).
-/

namespace PhysicsSM.Spinor.SpinorTenfold

open Finset

/-- The Clifford action written as a sum of scaled basis operators (integer
mirror of `cliffordAction_eq_sum`). -/
theorem cliffordActionZ_eq_sum (v : V10Z) (f : FockSpinorZ) :
    cliffordActionZ v f
      = (∑ i, v.1 i • wedgeZ i f) + (∑ i, v.2 i • contractZ i f) := by
  funext S
  simp [cliffordActionZ, Finset.sum_apply]

/-- Closed-form single monomial `(coeff, target)` for
`cliffordActionZ (gBasisZ S T) (basisZ U)`.

The `a`-half index is the unique `i ∈ S` with `S.erase i = Tᶜ` and `i ∉ U`;
the `b`-half index is the unique `i ∉ S` with `insert i S = Tᶜ` and `i ∈ U`.
At most one of these exists. -/
def termData (S T U : Finset (Fin 5)) : ℤ × Finset (Fin 5) :=
  match (List.finRange 5).find? (fun i => decide (i ∈ S ∧ S.erase i = Tᶜ ∧ i ∉ U)) with
  | some i => ((gBasisZ S T).1 i * opSignZ i (insert i U), insert i U)
  | none =>
    match (List.finRange 5).find? (fun i => decide (i ∉ S ∧ insert i S = Tᶜ ∧ i ∈ U)) with
    | some i => ((gBasisZ S T).2 i * opSignZ i (U.erase i), U.erase i)
    | none => (0, ∅)

/-
The `a`-half of `gBasisZ S T` is supported on at most one index: if `i ∈ S`
with `S.erase i = Tᶜ`, then `(gBasisZ S T).1 j = 0` for every `j ≠ i`.
-/
theorem gBasisZ_fst_eq_zero_of_ne (S T : Finset (Fin 5)) {i j : Fin 5}
    (hi : i ∈ S) (he : S.erase i = Tᶜ) (hj : j ≠ i) :
    (gBasisZ S T).1 j = 0 := by
  unfold gBasisZ; simp +decide [ he, hi, hj.symm ] ;
  intro hjS hjT; replace he := congr_arg ( fun x => j ∈ x ) he; simp_all +decide [ Finset.ext_iff ] ;
  grind

/-
When the `a`-half geometry holds (`i ∈ S`, `S.erase i = Tᶜ`), the `b`-half
of `gBasisZ S T` vanishes identically (incompatible cardinalities).
-/
theorem gBasisZ_snd_eq_zero_of_aActive (S T : Finset (Fin 5)) {i : Fin 5}
    (hi : i ∈ S) (he : S.erase i = Tᶜ) (j : Fin 5) :
    (gBasisZ S T).2 j = 0 := by
  unfold gBasisZ;
  simp +decide [ Finset.ext_iff ] at he ⊢;
  grind +ring

/-
The `b`-half of `gBasisZ S T` is supported on at most one index.
-/
theorem gBasisZ_snd_eq_zero_of_ne (S T : Finset (Fin 5)) {i j : Fin 5}
    (hi : i ∉ S) (he : insert i S = Tᶜ) (hj : j ≠ i) :
    (gBasisZ S T).2 j = 0 := by
  unfold gBasisZ
  simp only [Prod.snd]
  rw [if_neg]
  rintro ⟨hjS, hjc⟩
  have h1 : insert j S = Tᶜ := (compl_eq_comm.mp hjc).symm
  have h2 : insert j S = insert i S := h1.trans he.symm
  have hjmem : j ∈ insert i S := by rw [← h2]; exact Finset.mem_insert_self j S
  rcases Finset.mem_insert.mp hjmem with h | h
  · exact hj h
  · exact hjS h

/-
When the `b`-half geometry holds (`i ∉ S`, `insert i S = Tᶜ`), the `a`-half
of `gBasisZ S T` vanishes identically (incompatible cardinalities).
-/
theorem gBasisZ_fst_eq_zero_of_bActive (S T : Finset (Fin 5)) {i : Fin 5}
    (hi : i ∉ S) (he : insert i S = Tᶜ) (j : Fin 5) :
    (gBasisZ S T).1 j = 0 := by
  unfold gBasisZ;
  simp_all +decide [ Finset.ext_iff ];
  grind

/-
The `a`-half index, if any, is genuinely the head returned by `find?`.
-/
theorem find?_aHalf_eq (S T U : Finset (Fin 5)) {i : Fin 5}
    (hi : i ∈ S) (he : S.erase i = Tᶜ) (hU : i ∉ U) :
    (List.finRange 5).find? (fun k => decide (k ∈ S ∧ S.erase k = Tᶜ ∧ k ∉ U)) = some i := by
  have huniq : ∀ k : Fin 5, k ∈ S → S.erase k = Tᶜ → k = i := by
    intro k hkS hkc
    by_contra hki
    have heq : S.erase k = S.erase i := by rw [hkc, he]
    have hik : i ∈ S.erase k := by
      rw [Finset.mem_erase]; exact ⟨fun h => hki h.symm, hi⟩
    rw [heq] at hik
    exact (Finset.notMem_erase i S) hik
  have hpi : (decide (i ∈ S ∧ S.erase i = Tᶜ ∧ i ∉ U)) = true := by
    simp [hi, he, hU]
  have hfalse : ∀ k : Fin 5, k ≠ i →
      (decide (k ∈ S ∧ S.erase k = Tᶜ ∧ k ∉ U)) = false := by
    intro k hk
    simp only [decide_eq_false_iff_not, not_and]
    intro hkS hkc _
    exact hk (huniq k hkS hkc)
  rw [show List.finRange 5 = [0,1,2,3,4] from by decide]
  fin_cases i
  · exact List.find?_cons_of_pos hpi
  · rw [List.find?_cons_of_neg (by rw [hfalse 0 (by decide)]; decide)]
    exact List.find?_cons_of_pos hpi
  · rw [List.find?_cons_of_neg (by rw [hfalse 0 (by decide)]; decide),
        List.find?_cons_of_neg (by rw [hfalse 1 (by decide)]; decide)]
    exact List.find?_cons_of_pos hpi
  · rw [List.find?_cons_of_neg (by rw [hfalse 0 (by decide)]; decide),
        List.find?_cons_of_neg (by rw [hfalse 1 (by decide)]; decide),
        List.find?_cons_of_neg (by rw [hfalse 2 (by decide)]; decide)]
    exact List.find?_cons_of_pos hpi
  · rw [List.find?_cons_of_neg (by rw [hfalse 0 (by decide)]; decide),
        List.find?_cons_of_neg (by rw [hfalse 1 (by decide)]; decide),
        List.find?_cons_of_neg (by rw [hfalse 2 (by decide)]; decide),
        List.find?_cons_of_neg (by rw [hfalse 3 (by decide)]; decide)]
    exact List.find?_cons_of_pos hpi

/-
The `b`-half index, if any, is genuinely the head returned by `find?`.
-/
theorem find?_bHalf_eq (S T U : Finset (Fin 5)) {i : Fin 5}
    (hi : i ∉ S) (he : insert i S = Tᶜ) (hU : i ∈ U) :
    (List.finRange 5).find? (fun k => decide (k ∉ S ∧ insert k S = Tᶜ ∧ k ∈ U)) = some i := by
  have huniq : ∀ k : Fin 5, k ∉ S → insert k S = Tᶜ → k = i := by
    intro k hkS hkc
    have heq : insert k S = insert i S := by rw [hkc, he]
    have hkmem : k ∈ insert i S := by rw [← heq]; exact Finset.mem_insert_self k S
    rcases Finset.mem_insert.mp hkmem with h | h
    · exact h
    · exact absurd h hkS
  have hpi : (decide (i ∉ S ∧ insert i S = Tᶜ ∧ i ∈ U)) = true := by
    simp [hi, he, hU]
  have hfalse : ∀ k : Fin 5, k ≠ i →
      (decide (k ∉ S ∧ insert k S = Tᶜ ∧ k ∈ U)) = false := by
    intro k hk
    simp only [decide_eq_false_iff_not, not_and]
    intro hkS hkc _
    exact hk (huniq k hkS hkc)
  rw [show List.finRange 5 = [0,1,2,3,4] from by decide]
  fin_cases i
  · exact List.find?_cons_of_pos hpi
  · rw [List.find?_cons_of_neg (by rw [hfalse 0 (by decide)]; decide)]
    exact List.find?_cons_of_pos hpi
  · rw [List.find?_cons_of_neg (by rw [hfalse 0 (by decide)]; decide),
        List.find?_cons_of_neg (by rw [hfalse 1 (by decide)]; decide)]
    exact List.find?_cons_of_pos hpi
  · rw [List.find?_cons_of_neg (by rw [hfalse 0 (by decide)]; decide),
        List.find?_cons_of_neg (by rw [hfalse 1 (by decide)]; decide),
        List.find?_cons_of_neg (by rw [hfalse 2 (by decide)]; decide)]
    exact List.find?_cons_of_pos hpi
  · rw [List.find?_cons_of_neg (by rw [hfalse 0 (by decide)]; decide),
        List.find?_cons_of_neg (by rw [hfalse 1 (by decide)]; decide),
        List.find?_cons_of_neg (by rw [hfalse 2 (by decide)]; decide),
        List.find?_cons_of_neg (by rw [hfalse 3 (by decide)]; decide)]
    exact List.find?_cons_of_pos hpi

/-
**The closed form is correct**: the Clifford action of a basis
gamma-bilinear on a basis monomial is a single signed wedge monomial.
-/
set_option maxHeartbeats 1000000 in
-- The case analysis over the two `find?` branches with the sum collapses is
-- somewhat heavy; the default heartbeat budget is not quite enough.
theorem termData_eq (S T U : Finset (Fin 5)) :
    cliffordActionZ (gBasisZ S T) (basisZ U)
      = (termData S T U).1 • basisZ (termData S T U).2 := by
  rw [cliffordActionZ_eq_sum];
  unfold termData;
  cases' hfa : List.find? ( fun i => decide ( i ∈ S ∧ S.erase i = Tᶜ ∧ i ∉ U ) ) ( List.finRange 5 ) with i;
  · cases' hfb : List.find? ( fun i => decide ( i ∉ S ∧ insert i S = Tᶜ ∧ i ∈ U ) ) ( List.finRange 5 ) with i;
    · rw [ Finset.sum_eq_zero, Finset.sum_eq_zero ] <;> simp +decide [ * ];
      · intro i; by_cases hi : i ∈ U <;> simp_all +decide [ contractZ_basisZ_of_mem, contractZ_basisZ_of_not_mem ] ;
        unfold gBasisZ; aesop;
      · intro j; by_cases hjU : j ∈ U <;> simp_all +decide [ wedgeZ_basisZ_of_not_mem, wedgeZ_basisZ_of_mem ] ;
        unfold gBasisZ; aesop;
    · rw [ Finset.sum_eq_zero, Finset.sum_eq_single i ] <;> simp_all +decide [ Finset.sum_eq_zero_iff_of_nonneg, mul_nonneg ];
      · rw [ mul_assoc, contractZ_basisZ_of_mem ];
        · ext; simp [basisZ];
        · grind;
      · intro j hj; simp_all +decide [ gBasisZ ] ;
        intro hj₁ hj₂; specialize hfa j; simp_all +decide [ Finset.ext_iff ] ;
        grind;
      · intro x; by_cases hx : x ∈ S <;> simp_all +decide [ gBasisZ ] ;
        intro hx'; specialize hfa x hx; simp_all +decide [ Finset.ext_iff ] ;
        grind;
  · have hfa' : i ∈ S ∧ S.erase i = Tᶜ ∧ i ∉ U := by
      grind;
    rw [ Finset.sum_eq_single i, Finset.sum_eq_zero ] <;> simp_all +decide [ Finset.sum_ite ];
    · rw [ wedgeZ_basisZ_of_not_mem i U hfa'.2.2 ] ; ext ; simp +decide [ mul_assoc, mul_comm, mul_left_comm ];
      unfold basisZ; aesop;
    · intro x; rw [ gBasisZ_snd_eq_zero_of_aActive S T hfa'.1 hfa'.2.1 x ] ; simp +decide ;
    · intro j hj; rw [ gBasisZ_fst_eq_zero_of_ne S T hfa'.1 hfa'.2.1 hj ] ; simp +decide ;

/-- Cancellation predicate for three signed monomials: at every target the
signed coefficients sum to zero. -/
abbrev cancel3 (m1 m2 m3 : ℤ × Finset (Fin 5)) : Prop :=
  ∀ Y ∈ ({m1.2, m2.2, m3.2} : Finset (Finset (Fin 5))),
    (if m1.2 = Y then m1.1 else 0) + (if m2.2 = Y then m2.1 else 0)
      + (if m3.2 = Y then m3.1 else 0) = 0

/-
If three signed monomials cancel at every target, their sum is zero.
-/
theorem cancel3_imp_zero (m1 m2 m3 : ℤ × Finset (Fin 5)) (h : cancel3 m1 m2 m3) :
    m1.1 • basisZ m1.2 + m2.1 • basisZ m2.2 + m3.1 • basisZ m3.2 = 0 := by
  convert h using 1;
  constructor <;> intro h <;> simp_all +decide [ funext_iff, Finset.sum_apply' ];
  · assumption;
  · intro x; specialize h x; by_cases hx : x = m1.2 <;> by_cases hx' : x = m2.2 <;> by_cases hx'' : x = m3.2 <;> simp_all +decide [ basisZ ] ;
    all_goals split_ifs at h <;> simp_all +decide [ add_assoc ] ;

/-! ## Fast kernel enumeration via a `Nat` bit-mask mirror

The per-configuration cancellation `cancel_all` was originally a single kernel
`decide` over all `32³` triples of `Finset (Fin 5)`, which the kernel reduces
through `Multiset`/`Quotient` very slowly. We instead run an equivalent
enumeration on a `Nat` bit-mask mirror — where every set operation becomes
native kernel integer arithmetic — over only the `16³` even codes, and transport
the result back through the encoding `enc32`/`dec32`.

A subset `S ⊆ Fin 5` is encoded as the 5-bit number `enc32 S = ∑_{i ∈ S} 2ⁱ`.
The mirror operations (`Fz.*`) act on the bits; the bridge lemmas below check, by
small kernel `decide`s, that they match the genuine `Finset`/sign operations on
all `32` codes. Nothing about `gBasisZ`, `termData`, `cliffordActionZ`,
`cancel3`, or any sign convention is changed. -/

namespace Fz

/-- Bit `i` (for `i < 5`) of the code `n` (mirror of `i ∈ S`). -/
def bitN (n i : Nat) : Bool :=
  match i with
  | 0 => n % 2 == 1
  | 1 => n / 2 % 2 == 1
  | 2 => n / 4 % 2 == 1
  | 3 => n / 8 % 2 == 1
  | 4 => n / 16 % 2 == 1
  | _ => false

/-- `Bool` to `0/1`. -/
def b2i (b : Bool) : Nat := if b then 1 else 0

/-- Number of set bits (mirror of `S.card`). -/
def cardN (n : Nat) : Nat :=
  b2i (bitN n 0) + b2i (bitN n 1) + b2i (bitN n 2) + b2i (bitN n 3) + b2i (bitN n 4)

/-- Complement within the 5 bits (mirror of `Sᶜ`). -/
def complN (n : Nat) : Nat := 31 - n

/-- `2ⁱ` for `i < 5`. -/
def pw (i : Nat) : Nat :=
  match i with
  | 0 => 1 | 1 => 2 | 2 => 4 | 3 => 8 | 4 => 16 | _ => 0

/-- Set bit `i` (mirror of `insert i S`). -/
def insertN (i n : Nat) : Nat := if bitN n i then n else n + pw i

/-- Clear bit `i` (mirror of `S.erase i`). -/
def eraseN (i n : Nat) : Nat := if bitN n i then n - pw i else n

/-- Number of set bits below `i` (mirror of `belowCount i S`). -/
def belowN (i n : Nat) : Nat :=
  match i with
  | 0 => 0
  | 1 => b2i (bitN n 0)
  | 2 => b2i (bitN n 0) + b2i (bitN n 1)
  | 3 => b2i (bitN n 0) + b2i (bitN n 1) + b2i (bitN n 2)
  | _ => b2i (bitN n 0) + b2i (bitN n 1) + b2i (bitN n 2) + b2i (bitN n 3)

/-- `(-1)ᵏ` as an `Int`. -/
def parToSign (k : Nat) : Int := if k % 2 == 0 then 1 else -1

/-- Mirror of `opSignZ i S`. -/
def signN (i n : Nat) : Int := parToSign (belowN i n)

/-- Mirror of `shuffleInversions S`. -/
def shufN (n : Nat) : Nat :=
  (if bitN n 1 then b2i (!bitN n 0) else 0)
  + (if bitN n 2 then b2i (!bitN n 0) + b2i (!bitN n 1) else 0)
  + (if bitN n 3 then b2i (!bitN n 0) + b2i (!bitN n 1) + b2i (!bitN n 2) else 0)
  + (if bitN n 4 then b2i (!bitN n 0) + b2i (!bitN n 1) + b2i (!bitN n 2) + b2i (!bitN n 3) else 0)

/-- Mirror of `chevSignZ S`. -/
def chevN (n : Nat) : Int := parToSign (cardN n * (cardN n - 1) / 2 + shufN n)

/-- Mirror of `(gBasisZ S T).1 j`. -/
def gBfstN (S T j : Nat) : Int :=
  if bitN S j && (complN (eraseN j S) == T) then signN j (eraseN j S) * chevN (eraseN j S) else 0

/-- Mirror of `(gBasisZ S T).2 j`. -/
def gBsndN (S T j : Nat) : Int :=
  if !bitN S j && (complN (insertN j S) == T) then signN j (insertN j S) * chevN (insertN j S) else 0

/-- `a`-half search predicate (mirror of `i ∈ S ∧ S.erase i = Tᶜ ∧ i ∉ U`). -/
def predA (S T U : Nat) (i : Fin 5) : Bool :=
  bitN S i.val && (eraseN i.val S == complN T) && !bitN U i.val

/-- `b`-half search predicate (mirror of `i ∉ S ∧ insert i S = Tᶜ ∧ i ∈ U`). -/
def predB (S T U : Nat) (i : Fin 5) : Bool :=
  !bitN S i.val && (insertN i.val S == complN T) && bitN U i.val

/-- Unrolled `(List.finRange 5).find? (predA S T U)` (equal by `rfl`). -/
def findA (S T U : Nat) : Option (Fin 5) :=
  if predA S T U 0 then some 0
  else if predA S T U 1 then some 1
  else if predA S T U 2 then some 2
  else if predA S T U 3 then some 3
  else if predA S T U 4 then some 4
  else none

/-- Unrolled `(List.finRange 5).find? (predB S T U)` (equal by `rfl`). -/
def findB (S T U : Nat) : Option (Fin 5) :=
  if predB S T U 0 then some 0
  else if predB S T U 1 then some 1
  else if predB S T U 2 then some 2
  else if predB S T U 3 then some 3
  else if predB S T U 4 then some 4
  else none

/-- Mirror of `termData S T U`. -/
def termDataN (S T U : Nat) : Int × Nat :=
  match findA S T U with
  | some i => (gBfstN S T i.val * signN i.val (insertN i.val U), insertN i.val U)
  | none =>
    match findB S T U with
    | some i => (gBsndN S T i.val * signN i.val (eraseN i.val U), eraseN i.val U)
    | none => (0, 0)

/-- Mirror of `cancel3`: it checks the cancellation at each of the three targets. -/
def cancel3N (m1 m2 m3 : Int × Nat) : Bool :=
  ((m1.1) + (if m2.2 == m1.2 then m2.1 else 0) + (if m3.2 == m1.2 then m3.1 else 0) == 0) &&
  ((if m1.2 == m2.2 then m1.1 else 0) + (m2.1) + (if m3.2 == m2.2 then m3.1 else 0) == 0) &&
  ((if m1.2 == m3.2 then m1.1 else 0) + (if m2.2 == m3.2 then m2.1 else 0) + (m3.1) == 0)

/-- The 16 codes `< 32` with an even number of set bits (mirror of the even
subsets of `Fin 5`). -/
def evenCodes : List Nat := [0,3,5,6,9,10,12,15,17,18,20,23,24,27,29,30]

set_option maxHeartbeats 4000000 in
-- The kernel `decide` enumerates the 16³ even-code triples; the default
-- heartbeat budget is not enough for this many native-arithmetic reductions.
set_option maxRecDepth 10000 in
/-- The bit-mask mirror of the per-configuration cancellation, over the 16 even
codes, checked by the Lean kernel via `decide` on native `Nat`/`Int`
arithmetic (no `native_decide`). -/
theorem cancelAllN :
    (evenCodes.all (fun a => evenCodes.all (fun b => evenCodes.all (fun c =>
      cancel3N (termDataN a b c) (termDataN a c b) (termDataN b c a))))) = true := by decide

end Fz

open Fz

/-- Encode a subset of `Fin 5` as its 5-bit mask. -/
def enc32 (S : Finset (Fin 5)) : ℕ := ∑ i ∈ S, 2 ^ (i : ℕ)

/-- Decode a 5-bit mask to a subset of `Fin 5`. -/
def dec32 (n : ℕ) : Finset (Fin 5) := Finset.univ.filter (fun i => bitN n i.val)

/-! ### Atomic correspondences between the genuine and mirror operations

Each is a small kernel `decide` over the `≤ 160` relevant cases. -/

set_option maxRecDepth 4000 in
theorem dec32_enc32 : ∀ S : Finset (Fin 5), dec32 (enc32 S) = S := by decide

set_option maxRecDepth 4000 in
theorem memN_enc32 : ∀ (i : Fin 5) (S : Finset (Fin 5)),
    bitN (enc32 S) i.val = decide (i ∈ S) := by decide

set_option maxRecDepth 4000 in
theorem eraseN_enc32 : ∀ (i : Fin 5) (S : Finset (Fin 5)),
    enc32 (S.erase i) = eraseN i.val (enc32 S) := by decide

set_option maxRecDepth 4000 in
theorem insertN_enc32 : ∀ (i : Fin 5) (S : Finset (Fin 5)),
    enc32 (insert i S) = insertN i.val (enc32 S) := by decide

set_option maxRecDepth 4000 in
theorem complN_enc32 : ∀ S : Finset (Fin 5), enc32 Sᶜ = complN (enc32 S) := by decide

set_option maxRecDepth 4000 in
theorem signN_enc32 : ∀ (i : Fin 5) (S : Finset (Fin 5)),
    opSignZ i S = signN i.val (enc32 S) := by decide

set_option maxRecDepth 4000 in
theorem chevN_enc32 : ∀ S : Finset (Fin 5), chevSignZ S = chevN (enc32 S) := by decide

set_option maxRecDepth 4000 in
theorem enc32_mem_evenCodes : ∀ S : Finset (Fin 5), S.card % 2 = 0 → enc32 S ∈ Fz.evenCodes := by
  decide

/-! ### Assembly of the bridge -/

/-- `enc32` is injective (it has the left inverse `dec32`). -/
theorem enc32_injective : Function.Injective enc32 := by
  intro S T h
  have := dec32_enc32 S
  rw [h, dec32_enc32 T] at this
  exact this.symm

/-
`(gBasisZ S T).1` matches the bit-mask mirror.
-/
theorem gBfstN_corr (S T : Finset (Fin 5)) (j : Fin 5) :
    (gBasisZ S T).1 j = Fz.gBfstN (enc32 S) (enc32 T) j.val := by
  unfold gBasisZ Fz.gBfstN
  dsimp only
  rw [← eraseN_enc32, ← complN_enc32, memN_enc32, ← signN_enc32 j (S.erase j),
    ← chevN_enc32 (S.erase j)]
  have hiff : ((decide (j ∈ S) && (enc32 (S.erase j)ᶜ == enc32 T)) = true)
      ↔ (j ∈ S ∧ (S.erase j)ᶜ = T) := by
    simp only [Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq, enc32_injective.eq_iff]
  by_cases hc : j ∈ S ∧ (S.erase j)ᶜ = T
  · rw [if_pos hc, if_pos (hiff.mpr hc)]
  · rw [if_neg hc, if_neg (fun h => hc (hiff.mp h))]

/-
`(gBasisZ S T).2` matches the bit-mask mirror.
-/
theorem gBsndN_corr (S T : Finset (Fin 5)) (j : Fin 5) :
    (gBasisZ S T).2 j = Fz.gBsndN (enc32 S) (enc32 T) j.val := by
  unfold gBasisZ Fz.gBsndN
  dsimp only
  rw [← insertN_enc32, ← complN_enc32, memN_enc32, ← signN_enc32 j (insert j S),
    ← chevN_enc32 (insert j S)]
  have hiff : ((!decide (j ∈ S) && (enc32 (insert j S)ᶜ == enc32 T)) = true)
      ↔ (j ∉ S ∧ (insert j S)ᶜ = T) := by
    simp only [Bool.and_eq_true, Bool.not_eq_true', decide_eq_false_iff_not, beq_iff_eq,
      enc32_injective.eq_iff]
  by_cases hc : j ∉ S ∧ (insert j S)ᶜ = T
  · rw [if_pos hc, if_pos (hiff.mpr hc)]
  · rw [if_neg hc, if_neg (fun h => hc (hiff.mp h))]

/-
The `a`-half search predicate matches the mirror predicate.
-/
theorem predA_corr (S T U : Finset (Fin 5)) (i : Fin 5) :
    decide (i ∈ S ∧ S.erase i = Tᶜ ∧ i ∉ U)
      = Fz.predA (enc32 S) (enc32 T) (enc32 U) i := by
        unfold predA; simp +decide [ memN_enc32 ] ;
        rw [ ← eraseN_enc32, ← complN_enc32 ];
        simp +decide [ ← enc32_injective.eq_iff ];
        grind

/-
The `b`-half search predicate matches the mirror predicate.
-/
theorem predB_corr (S T U : Finset (Fin 5)) (i : Fin 5) :
    decide (i ∉ S ∧ insert i S = Tᶜ ∧ i ∈ U)
      = Fz.predB (enc32 S) (enc32 T) (enc32 U) i := by
        unfold predB; simp +decide [ memN_enc32 ] ;
        rw [ ← insertN_enc32, ← complN_enc32 ];
        simp +decide [ ← enc32_injective.eq_iff ];
        grind

/-- `termData` matches its bit-mask mirror, decoded back to a subset. -/
theorem termDataN_corr (S T U : Finset (Fin 5)) :
    termData S T U
      = ((Fz.termDataN (enc32 S) (enc32 T) (enc32 U)).1,
         dec32 (Fz.termDataN (enc32 S) (enc32 T) (enc32 U)).2) := by
  have hA : (List.finRange 5).find? (fun i => decide (i ∈ S ∧ S.erase i = Tᶜ ∧ i ∉ U))
      = Fz.findA (enc32 S) (enc32 T) (enc32 U) := by
    rw [show (fun i => decide (i ∈ S ∧ S.erase i = Tᶜ ∧ i ∉ U))
          = Fz.predA (enc32 S) (enc32 T) (enc32 U) from funext (predA_corr S T U)]
    unfold Fz.findA
    rw [show (List.finRange 5) = [0,1,2,3,4] from by decide]
    simp only [List.find?_cons, List.find?_nil]
    cases Fz.predA (enc32 S) (enc32 T) (enc32 U) 0 <;>
      cases Fz.predA (enc32 S) (enc32 T) (enc32 U) 1 <;>
      cases Fz.predA (enc32 S) (enc32 T) (enc32 U) 2 <;>
      cases Fz.predA (enc32 S) (enc32 T) (enc32 U) 3 <;>
      cases Fz.predA (enc32 S) (enc32 T) (enc32 U) 4 <;> rfl
  have hB : (List.finRange 5).find? (fun i => decide (i ∉ S ∧ insert i S = Tᶜ ∧ i ∈ U))
      = Fz.findB (enc32 S) (enc32 T) (enc32 U) := by
    rw [show (fun i => decide (i ∉ S ∧ insert i S = Tᶜ ∧ i ∈ U))
          = Fz.predB (enc32 S) (enc32 T) (enc32 U) from funext (predB_corr S T U)]
    unfold Fz.findB
    rw [show (List.finRange 5) = [0,1,2,3,4] from by decide]
    simp only [List.find?_cons, List.find?_nil]
    cases Fz.predB (enc32 S) (enc32 T) (enc32 U) 0 <;>
      cases Fz.predB (enc32 S) (enc32 T) (enc32 U) 1 <;>
      cases Fz.predB (enc32 S) (enc32 T) (enc32 U) 2 <;>
      cases Fz.predB (enc32 S) (enc32 T) (enc32 U) 3 <;>
      cases Fz.predB (enc32 S) (enc32 T) (enc32 U) 4 <;> rfl
  unfold termData Fz.termDataN
  rw [hA, hB]
  cases hfa : Fz.findA (enc32 S) (enc32 T) (enc32 U) with
  | some i =>
    refine Prod.ext ?_ ?_
    · dsimp only
      rw [gBfstN_corr, signN_enc32 i (insert i U), insertN_enc32]
    · dsimp only
      rw [← insertN_enc32, dec32_enc32]
  | none =>
    cases hfb : Fz.findB (enc32 S) (enc32 T) (enc32 U) with
    | some i =>
      refine Prod.ext ?_ ?_
      · dsimp only
        rw [gBsndN_corr, signN_enc32 i (U.erase i), eraseN_enc32]
      · dsimp only
        rw [← eraseN_enc32, dec32_enc32]
    | none =>
      refine Prod.ext ?_ ?_
      · rfl
      · dsimp only
        rw [show (0 : ℕ) = enc32 (∅ : Finset (Fin 5)) from by simp [enc32], dec32_enc32]

/-
Transfer the mirror cancellation to the genuine `cancel3`. Whenever a target
code collides under `dec32`, the mirror cancellation already forces the
corresponding coefficient contributions to agree, so no injectivity hypothesis
is needed.
-/
theorem cancel3N_to_cancel3 (a b c : ℤ × ℕ)
    (h : Fz.cancel3N a b c = true) :
    cancel3 (a.1, dec32 a.2) (b.1, dec32 b.2) (c.1, dec32 c.2) := by
  unfold cancel3N at h
  grind

/-- The bit-mask cancellation, specialized to membership in `evenCodes`. -/
theorem evenCodes_fact (a : ℕ) (ha : a ∈ Fz.evenCodes) (b : ℕ) (hb : b ∈ Fz.evenCodes)
    (c : ℕ) (hc : c ∈ Fz.evenCodes) :
    Fz.cancel3N (Fz.termDataN a b c) (Fz.termDataN a c b) (Fz.termDataN b c a) = true := by
  have h := Fz.cancelAllN
  simp only [List.all_eq_true] at h
  exact h a ha b hb c hc

/-- The per-configuration sign cancellation over all even triples. Derived (with
the same statement as the original brute-force `decide`) from the cheap bit-mask
enumeration `Fz.cancelAllN` via the encoding `enc32`/`dec32`. -/
theorem cancel_all :
    ∀ S T U : Finset (Fin 5), S.card % 2 = 0 → T.card % 2 = 0 → U.card % 2 = 0 →
      cancel3 (termData S T U) (termData S U T) (termData T U S) := by
  intro S T U hS hT hU
  have hSc := enc32_mem_evenCodes S hS
  have hTc := enc32_mem_evenCodes T hT
  have hUc := enc32_mem_evenCodes U hU
  have hfact := evenCodes_fact (enc32 S) hSc (enc32 T) hTc (enc32 U) hUc
  rw [termDataN_corr S T U, termDataN_corr S U T, termDataN_corr T U S]
  exact cancel3N_to_cancel3 _ _ _ hfact

/-- The three-term symmetrized Fierz identity in the integer Fock mirror. -/
theorem fierzZ_three (S T U : Finset (Fin 5))
    (hS : S.card % 2 = 0) (hT : T.card % 2 = 0) (hU : U.card % 2 = 0) :
    cliffordActionZ (gBasisZ S T) (basisZ U)
      + cliffordActionZ (gBasisZ S U) (basisZ T)
      + cliffordActionZ (gBasisZ T U) (basisZ S) = 0 := by
  rw [termData_eq S T U, termData_eq S U T, termData_eq T U S]
  exact cancel3_imp_zero _ _ _ (cancel_all S T U hS hT hU)

end PhysicsSM.Spinor.SpinorTenfold
