import Mathlib
import PhysicsSM.Draft.NullEdgeFureyChiE
import PhysicsSM.Draft.NullEdgeFureyInternalSpectrum

/-!
# FUR-H8A — Number-parity `chi_E` on the Furey occupation / internal-spectrum API

This module realizes the abstract internal grading `chi_E` of the null-edge
program **concretely** on the finite Furey occupation model that already powers
the computed internal spectrum in
`PhysicsSM.Draft.NullEdgeFureyInternalSpectrum`.

The eight basis states of the minimal left ideal `J` are modelled there as
`Occ := Finset (Fin 3)` — the occupation patterns of three fermionic ladder
modes — with electric charge `Occ.charge s = -(1/3) · |s|`.  Here we equip the
same eight states with the **occupation-number parity**

```
occParitySign s := (-1) ^ |s|      -- the eigenvalue of (-1)^N
chiEParity      := diagonal occParitySign   -- the chi_E grading operator
```

## What is proved

* **Grading / involution.** `chiEParity_mul_self : chiEParity * chiEParity = 1`,
  i.e. `chiEParity` is an honest `Z/2` grading
  (`FureyChiE.IsZ2Grading`), and `occParitySign s ∈ {+1, -1}` with
  `occParitySign s * occParitySign s = 1`.

* **Distinct from the ruled-out complex structure.**  The Furey/Krasnov complex
  structure analysed in `NullEdgeFureyChiE.lean` squares to `-1`
  (`FureyChiE.IsComplexStructure`).  The parity grading squares to `+1`, so it is
  **not** a complex structure (`chiEParity_not_complexStructure`) and differs
  from every complex structure on the eight-state space
  (`chiEParity_ne_complexStructure`).  This is exactly the data shown to be
  *missing* in `FUR-H2`: a genuine non-complex involution.

* **Separates the chirality classes of the computed spectrum.**  The parity
  splits the eight `J`-states into two four-element classes with **disjoint**
  electric-charge content,
  `even = {0, -2/3, -2/3, -2/3}` and `odd = {-1/3, -1/3, -1/3, -1}`,
  exchanged by the occupation complement `s ↦ sᶜ` (charge conjugation).  These
  are the two occupation-number-parity halves of the single generation computed
  in `NullEdgeFureyInternalSpectrum`.

* **Anti-commutation with `Phi_H` (H7A) is a clean hypothesis, not a forced
  bridge.**  We do *not* build the internal mass map here.  Instead `H7A PhiH`
  names the property that `Phi_H` is `chi_E`-odd, and
  `chiEParity_tachyonic_under_H7A` derives the tachyonic super-Dirac sign
  `(chiEParity·PhiH)² = -(PhiH²)` from it (the Gate A sign dichotomy of
  `NullEdgeFureyChiE.sign_bridge_with_grading`).  `H7A_satisfiable` shows the
  hypothesis is non-vacuous: an explicit complement-permutation block is
  `chi_E`-odd and nonzero.

## Convention guard

`chiEParity` is the *internal* `chi_E` grading on the occupation lattice; it is
kept strictly separate from spacetime chirality `Gamma_s` and from the
Furey/Krasnov complex structure.  Nothing here supplies `Phi_H`, Yukawa, or mass
data: the only mass-sector statement is the conditional sign theorem under the
named hypothesis `H7A`.

## Status and soundness (draft)

Draft/experimental module. The structural algebra theorems
(`chiEParity_mul_self`, `chiEParity_ne_complexStructure`,
`chiEParity_tachyonic_under_H7A`, `H7A_satisfiable`, ...) are kernel-checked and
depend only on `propext, Classical.choice, Quot.sound`. The finite-enumeration
theorems over the eight occupation states
(`occParitySign_eq_one_iff_even`, `occParitySign_eq_negOne_iff_odd`,
`occEven_chargeMultiset`, `occOdd_chargeMultiset`, `occEven_occOdd_charges_disjoint`,
`H7A_satisfiable`'s complement-permutation check) use `native_decide`, which adds
`Lean.ofReduceBool` and `Lean.trustCompiler` to their axiom footprint; this is
draft-trust, not kernel-trust, and matches the existing convention in
`NullEdgeFureyInternalSpectrum` in the same directory. Replace each
`native_decide` with a kernel-checked proof before any promotion to trusted.
-/

namespace PhysicsSM.NullEdge.FureyOccParity

open PhysicsSM.NullEdge
open PhysicsSM.NullEdge.FureyJ

/-! ## 1. Occupation-number parity -/

/-- The occupation number `N = |s|` of an occupation pattern (number of occupied
ladder modes). -/
def occNumber (s : Occ) : ℕ := s.card

/-- The occupation-number **parity sign** `(-1)^N`, i.e. the eigenvalue of the
number-operator parity operator `(-1)^N` on the state `s`. -/
def occParitySign (s : Occ) : ℚ := (-1) ^ s.card

/-- The parity sign is always `+1` or `-1`. -/
theorem occParitySign_values (s : Occ) :
    occParitySign s = 1 ∨ occParitySign s = -1 := by
  rcases Nat.even_or_odd s.card with h | h
  · exact Or.inl (h.neg_one_pow)
  · exact Or.inr (h.neg_one_pow)

/-- The parity sign squares to `1` (involution at the eigenvalue level). -/
theorem occParitySign_mul_self (s : Occ) :
    occParitySign s * occParitySign s = 1 := by
  rcases occParitySign_values s with h | h <;> rw [h] <;> ring

/-- The parity sign is `+1` exactly on even occupation number. -/
theorem occParitySign_eq_one_iff_even (s : Occ) :
    occParitySign s = 1 ↔ Even s.card := by
  constructor
  · intro h
    rcases Nat.even_or_odd s.card with he | ho
    · exact he
    · rw [occParitySign, ho.neg_one_pow] at h; norm_num at h
  · intro he; exact he.neg_one_pow

/-- The parity sign is `-1` exactly on odd occupation number. -/
theorem occParitySign_eq_negOne_iff_odd (s : Occ) :
    occParitySign s = -1 ↔ Odd s.card := by
  constructor
  · intro h
    rcases Nat.even_or_odd s.card with he | ho
    · rw [occParitySign, he.neg_one_pow] at h; norm_num at h
    · exact ho
  · intro ho; exact ho.neg_one_pow

/-- The occupation complement `s ↦ sᶜ` (charge conjugation) **flips** the parity
sign: `occParitySign sᶜ = - occParitySign s`. -/
theorem occParitySign_compl (s : Occ) :
    occParitySign sᶜ = - occParitySign s := by
  revert s; native_decide

/-- Charge conjugation maps charge `q` to `-1 - q`: `charge s + charge sᶜ = -1`. -/
theorem charge_add_charge_compl (s : Occ) :
    Occ.charge s + Occ.charge sᶜ = -1 := by
  revert s; native_decide

/-! ## 2. The `chi_E` parity grading operator and the involution -/

open Matrix in
/-- The internal `chi_E` grading on the eight occupation states: the diagonal
operator with the parity eigenvalues `(-1)^N`. -/
def chiEParity : Matrix Occ Occ ℚ := Matrix.diagonal occParitySign

/-- **Involution / `Z/2` grading.** The parity grading squares to the identity. -/
theorem chiEParity_mul_self : chiEParity * chiEParity = 1 := by
  unfold chiEParity
  rw [Matrix.diagonal_mul_diagonal]
  have : (fun i => occParitySign i * occParitySign i) = (fun _ => (1 : ℚ)) :=
    funext occParitySign_mul_self
  rw [this, Matrix.diagonal_one]

/-- The parity grading is an honest `Z/2` grading in the sense of
`NullEdgeFureyChiE`. -/
theorem chiEParity_isZ2Grading : FureyChiE.IsZ2Grading chiEParity :=
  chiEParity_mul_self

/-! ## 3. Distinct from the Furey/Krasnov complex structure ruled out in FUR-H2 -/

/-- On the eight-state space, `1 ≠ -1` (characteristic `≠ 2`), so the FUR-H2
separation results apply. -/
theorem matrix_one_ne_negOne : (1 : Matrix Occ Occ ℚ) ≠ -1 := by
  intro h
  have h2 := congrFun (congrFun h ∅) ∅
  simp only [Matrix.one_apply_eq, Matrix.neg_apply] at h2
  norm_num at h2

/-- **The parity grading is not a complex structure.**  Unlike the Furey/Krasnov
"multiplication by `i`" datum (`J² = -1`), the parity grading squares to `+1`. -/
theorem chiEParity_not_complexStructure :
    ¬ FureyChiE.IsComplexStructure chiEParity :=
  fun h =>
    FureyChiE.complexStructure_not_grading chiEParity matrix_one_ne_negOne h
      chiEParity_isZ2Grading

/-- **The parity grading differs from every complex structure** on the
eight-state space.  Hence the Furey/Krasnov complex structure cannot be the
internal `chi_E`; the parity grading supplies the missing genuine involution. -/
theorem chiEParity_ne_complexStructure (J : Matrix Occ Occ ℚ)
    (hJ : FureyChiE.IsComplexStructure J) : J ≠ chiEParity :=
  FureyChiE.complexStructure_ne_grading J chiEParity matrix_one_ne_negOne hJ
    chiEParity_isZ2Grading

/-! ## 4. Parity separates the chirality classes of the computed spectrum -/

/-- Even-parity occupation states (`(-1)^N = +1`). -/
def occEven : Finset Occ := Finset.univ.filter (fun s => Even s.card)

/-- Odd-parity occupation states (`(-1)^N = -1`). -/
def occOdd : Finset Occ := Finset.univ.filter (fun s => Odd s.card)

/-- Membership in `occEven` is exactly parity `+1`. -/
theorem mem_occEven_iff (s : Occ) : s ∈ occEven ↔ occParitySign s = 1 := by
  rw [occEven, Finset.mem_filter]
  simp [occParitySign_eq_one_iff_even s]

/-- Membership in `occOdd` is exactly parity `-1`. -/
theorem mem_occOdd_iff (s : Occ) : s ∈ occOdd ↔ occParitySign s = -1 := by
  rw [occOdd, Finset.mem_filter]
  simp [occParitySign_eq_negOne_iff_odd s]

/-- Four states have even parity. -/
theorem occEven_card : occEven.card = 4 := by decide

/-- Four states have odd parity. -/
theorem occOdd_card : occOdd.card = 4 := by decide

/-- The two parity classes are disjoint. -/
theorem occEven_occOdd_disjoint : Disjoint occEven occOdd := by decide

/-- The two parity classes exhaust the eight states. -/
theorem occEven_union_occOdd : occEven ∪ occOdd = Finset.univ := by decide

/-- Charge conjugation (occupation complement) sends even-parity to odd-parity. -/
theorem compl_mem_occOdd_of_mem_occEven {s : Occ} (h : s ∈ occEven) :
    sᶜ ∈ occOdd := by
  rw [mem_occOdd_iff, occParitySign_compl]
  rw [mem_occEven_iff] at h; simp [h]

/-- Charge conjugation (occupation complement) sends odd-parity to even-parity. -/
theorem compl_mem_occEven_of_mem_occOdd {s : Occ} (h : s ∈ occOdd) :
    sᶜ ∈ occEven := by
  rw [mem_occEven_iff, occParitySign_compl]
  rw [mem_occOdd_iff] at h; simp [h]

/-- **Charge content of the even-parity class.** The four even-parity states
carry charges `{0, -2/3, -2/3, -2/3}` (the `ν`/up-antiquark-triplet half). -/
theorem occEven_chargeMultiset :
    occEven.val.map Occ.charge = {0, -2/3, -2/3, -2/3} := by native_decide

/-- **Charge content of the odd-parity class.** The four odd-parity states carry
charges `{-1/3, -1/3, -1/3, -1}` (the down-quark-triplet/charged-lepton half). -/
theorem occOdd_chargeMultiset :
    occOdd.val.map Occ.charge = {-1/3, -1/3, -1/3, -1} := by native_decide

/-- The parity classes have **disjoint** charge content: no charge occurs in
both the even and the odd class.  This is the precise sense in which the
number-operator parity *separates* the two chirality halves of the computed
spectrum. -/
theorem occEven_occOdd_charges_disjoint :
    ∀ s ∈ occEven, ∀ t ∈ occOdd, Occ.charge s ≠ Occ.charge t := by
  native_decide

/-! ## 5. Anti-commutation with `Phi_H` — the H7A hypothesis (not a forced bridge)

We do not construct the internal mass map.  `H7A PhiH` is the clean hypothesis
that `Phi_H` is `chi_E`-odd; from it the tachyonic super-Dirac sign follows
abstractly.  `H7A_satisfiable` records that the hypothesis is non-vacuous. -/

/-- General algebra: if `Xe` is a `Z/2` grading and the block `Ph` is `Xe`-odd,
the gradient-squared term flips sign: `(Xe·Ph)² = -(Ph²)`. -/
theorem oddBlock_sq_neg {A : Type*} [Ring A] (Xe Ph : A)
    (hXe : FureyChiE.IsZ2Grading Xe) (hodd : FureyChiE.IsOdd Xe Ph) :
    (Xe * Ph) * (Xe * Ph) = -(Ph * Ph) := by
  have h : Xe * Ph = -(Ph * Xe) := hodd
  have hPhXe : Ph * Xe = -(Xe * Ph) := by rw [h, neg_neg]
  have hXe' : Xe * Xe = 1 := hXe
  calc (Xe * Ph) * (Xe * Ph)
      = Xe * ((Ph * Xe) * Ph) := by noncomm_ring
    _ = Xe * ((-(Xe * Ph)) * Ph) := by rw [hPhXe]
    _ = -((Xe * Xe) * (Ph * Ph)) := by noncomm_ring
    _ = -(Ph * Ph) := by rw [hXe', one_mul]

/-- **H7A hypothesis.** The internal mass map `Phi_H` is `chi_E`-odd: it
anti-commutes with the occupation-number parity grading.  Stated as a named
property rather than proved, since constructing `Phi_H` is out of scope here
(it is the content of job H7A). -/
def H7A (PhiH : Matrix Occ Occ ℚ) : Prop := FureyChiE.IsOdd chiEParity PhiH

/-- **Conditional Gate A sign theorem.** *Under H7A*, the parity grading produces
the tachyonic super-Dirac sign `(chiEParity·Phi_H)² = -(Phi_H²)`, exactly the
`chi_E`-odd branch of `NullEdgeFureyChiE.sign_bridge_with_grading`. -/
theorem chiEParity_tachyonic_under_H7A (PhiH : Matrix Occ Occ ℚ) (h : H7A PhiH) :
    (chiEParity * PhiH) * (chiEParity * PhiH) = -(PhiH * PhiH) :=
  oddBlock_sq_neg chiEParity PhiH chiEParity_isZ2Grading h

/-- The complement-permutation block: `s ↦ sᶜ` realised as a `0/1` matrix.  Since
the complement flips parity, this block is `chi_E`-odd. -/
def complPerm : Matrix Occ Occ ℚ := fun s t => if t = sᶜ then 1 else 0

/-- **H7A is non-vacuous.** There is a nonzero block that is `chi_E`-odd, so the
conditional sign theorem is not empty. -/
theorem H7A_satisfiable : ∃ PhiH : Matrix Occ Occ ℚ, PhiH ≠ 0 ∧ H7A PhiH := by
  refine ⟨complPerm, ?_, ?_⟩
  · intro h
    have := congrFun (congrFun h ∅) (∅ : Occ)ᶜ
    simp [complPerm] at this
  · unfold H7A FureyChiE.IsOdd chiEParity complPerm
    native_decide

end PhysicsSM.NullEdge.FureyOccParity
