import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldFock
import PhysicsSM.Spinor.SpinorTenfoldPurity

/-!
# Spinor.SpinorTenfoldGammaSymm

Symmetry of the gamma-bilinear `q` on the `Spin(10)` Fock model, via a
computable integer mirror of the Chevalley-pairing definitions.

## Mathematical context

The gamma-bilinear `q(ψ, φ) = ψ Γ^a φ` of `PhysicsSM.Spinor.SpinorTenfoldPurity`
is symmetric — this is the classical fact that in ten dimensions the vector
sits in the *symmetric* square of each Weyl representation. With symmetry,
Krasnov's alignment condition simplifies from the symmetrized form
`q(ψ₁, ψ₂) + q(ψ₂, ψ₁) = 0` to the single equation `q(ψ₁, ψ₂) = 0`
(`sum_quadric_iff_single` below).

## Proof engineering

By bilinearity, symmetry reduces to the `32 × 32` wedge-monomial pairs. Those
are finite *integer* sign facts, so they are checked on a computable `ℤ`-mirror
of the Fock model (`FockSpinorZ`, `gammaBilinearZ`, …) and transported to `ℂ`
by casting. Two ingredients keep the kernel check cheap:

- `gBasisZ S T`, a closed form for `gammaBilinearZ` on basis monomials with at
  most one nonvanishing component per half, proved equal to the defining
  32-term Chevalley sum *structurally* (`gBasisZ_eq`), not by enumeration;
- the actual `32 × 32` symmetry check `gBasisZ_symm`, discharged by kernel
  `decide` on the closed form.

No `native_decide` is used anywhere in this module: every enumeration is
checked by the Lean kernel itself.

## Provenance

The integer-mirror architecture, cast layer, and multilinear expansion are due
to the Aristotle proof agent (job `198550bc-ef58-4789-bda2-b7361cc6c3f7`, task
`AgentTasks/spin10-fierz-cayley-chart-aristotle-2026-06-09.md`), reviewed and
reworked during integration: Aristotle's `native_decide` closures of
`gBasisZ_eq` and the basis symmetry were replaced by the structural proof and
kernel `decide` respectively. The basis-level symmetrized Fierz identity was
subsequently kernel-cleaned as well (job
`93e29d35-37f8-4c3c-bad7-02b5fca82612`) and lives in the trusted modules
`PhysicsSM.Spinor.SpinorTenfoldFierzKernel` and
`PhysicsSM.Spinor.SpinorTenfoldFierz`.

Conventions are those of `PhysicsSM.Spinor.SpinorTenfoldFock`, validated by
`Scripts/oracle/validate_spinor_tenfold.py`.

Status: trusted — no `sorry`, no `axiom` (in particular no `native_decide`).
-/

namespace PhysicsSM.Spinor.SpinorTenfold

open Finset

/-! ## The computable integer mirror of the Fock model -/

/-- Integer-valued Fock spinor. -/
abbrev FockSpinorZ := Finset (Fin 5) → ℤ

/-- Integer-valued vector in the hyperbolic split. -/
abbrev V10Z := (Fin 5 → ℤ) × (Fin 5 → ℤ)

/-- Integer wedge-monomial basis spinor. -/
def basisZ (T : Finset (Fin 5)) : FockSpinorZ := fun S => if S = T then 1 else 0

/-- Integer fermionic ordering sign. -/
def opSignZ (i : Fin 5) (S : Finset (Fin 5)) : ℤ := (-1 : ℤ) ^ belowCount i S

/-- Integer creation operator. -/
def wedgeZ (i : Fin 5) (f : FockSpinorZ) : FockSpinorZ := fun S =>
  if i ∈ S then opSignZ i S * f (S.erase i) else 0

/-- Integer annihilation operator. -/
def contractZ (i : Fin 5) (f : FockSpinorZ) : FockSpinorZ := fun S =>
  if i ∈ S then 0 else opSignZ i S * f (insert i S)

/-- Integer Chevalley sign (alpha twist times shuffle sign). -/
def chevSignZ (S : Finset (Fin 5)) : ℤ :=
  (-1 : ℤ) ^ (S.card * (S.card - 1) / 2 + shuffleInversions S)

/-- Integer Chevalley pairing. -/
def chevalleyPairingZ (f g : FockSpinorZ) : ℤ :=
  ∑ S : Finset (Fin 5), chevSignZ S * f S * g Sᶜ

/-- Integer gamma-bilinear. -/
def gammaBilinearZ (f g : FockSpinorZ) : V10Z :=
  (fun j => chevalleyPairingZ (contractZ j f) g,
   fun j => chevalleyPairingZ (wedgeZ j f) g)

/-- Integer Clifford action. -/
def cliffordActionZ (v : V10Z) (f : FockSpinorZ) : FockSpinorZ := fun S =>
  (∑ i, v.1 i * wedgeZ i f S) + (∑ i, v.2 i * contractZ i f S)

/-- Closed form for the integer gamma-bilinear on a pair of basis monomials.
At most one index `j` satisfies each membership-and-complement condition, so
this form has at most one nonzero entry per half — cheap enough for the kernel
`decide` in `gBasisZ_symm` (and for the cubic Fierz check in the draft). -/
def gBasisZ (S T : Finset (Fin 5)) : V10Z :=
  (fun j =>
      if j ∈ S ∧ (S.erase j)ᶜ = T then opSignZ j (S.erase j) * chevSignZ (S.erase j) else 0,
   fun j =>
      if j ∉ S ∧ (insert j S)ᶜ = T then opSignZ j (insert j S) * chevSignZ (insert j S) else 0)

/-! ## Integer basis-action lemmas

These are verbatim `ℤ`-ports of the trusted `ℂ`-level lemmas
`wedge_basisSpinor_of_not_mem` etc. in `PhysicsSM.Spinor.SpinorTenfoldFock`,
with the output written as a signed indicator function. -/

/-- Creation on an integer monomial not containing `i`: a signed monomial. -/
theorem wedgeZ_basisZ_of_not_mem (i : Fin 5) (T : Finset (Fin 5)) (h : i ∉ T) :
    wedgeZ i (basisZ T)
      = fun S => if S = insert i T then opSignZ i (insert i T) else 0 := by
  funext S
  simp only [wedgeZ, basisZ]
  by_cases hS : S = insert i T
  · subst hS
    rw [if_pos (Finset.mem_insert_self i T), Finset.erase_insert h,
      if_pos rfl, if_pos rfl, mul_one]
  · rw [if_neg hS]
    split
    · rename_i hi
      rw [if_neg, mul_zero]
      intro hT
      exact hS (by rw [← hT, Finset.insert_erase hi])
    · rfl

/-- Creation on an integer monomial already containing `i` is zero. -/
theorem wedgeZ_basisZ_of_mem (i : Fin 5) (T : Finset (Fin 5)) (h : i ∈ T) :
    wedgeZ i (basisZ T) = 0 := by
  funext S
  simp only [wedgeZ, basisZ, Pi.zero_apply]
  split
  · rw [if_neg, mul_zero]
    intro hT
    exact (Finset.notMem_erase i S) (hT ▸ h)
  · rfl

/-- Annihilation on an integer monomial containing `i`: a signed monomial. -/
theorem contractZ_basisZ_of_mem (i : Fin 5) (T : Finset (Fin 5)) (h : i ∈ T) :
    contractZ i (basisZ T)
      = fun S => if S = T.erase i then opSignZ i (T.erase i) else 0 := by
  funext S
  simp only [contractZ, basisZ]
  by_cases hiS : i ∈ S
  · rw [if_pos hiS, if_neg]
    intro hST
    exact (Finset.notMem_erase i T) (hST ▸ hiS)
  · rw [if_neg hiS]
    by_cases hST : S = T.erase i
    · subst hST
      rw [if_pos (Finset.insert_erase h), if_pos rfl, mul_one]
    · rw [if_neg hST, if_neg, mul_zero]
      intro hins
      exact hST (by rw [← hins, Finset.erase_insert hiS])

/-- Annihilation on an integer monomial not containing `i` is zero. -/
theorem contractZ_basisZ_of_not_mem (i : Fin 5) (T : Finset (Fin 5)) (h : i ∉ T) :
    contractZ i (basisZ T) = 0 := by
  funext S
  simp only [contractZ, basisZ, Pi.zero_apply]
  split
  · rfl
  · rw [if_neg, mul_zero]
    intro hins
    exact h (hins ▸ Finset.mem_insert_self i S)

@[simp] theorem chevalleyPairingZ_zero_left (g : FockSpinorZ) :
    chevalleyPairingZ 0 g = 0 := by
  simp [chevalleyPairingZ]

/-- The integer Chevalley pairing against a signed indicator collapses to a
single term. -/
theorem chevalleyPairingZ_signedBasis_left (A : Finset (Fin 5)) (c : ℤ)
    (g : FockSpinorZ) :
    chevalleyPairingZ (fun S => if S = A then c else 0) g
      = c * chevSignZ A * g Aᶜ := by
  unfold chevalleyPairingZ
  rw [Finset.sum_eq_single A]
  · have hA : (fun S => if S = A then c else 0) A = c := by simp
    rw [hA]
    ring
  · intro S _ hS
    have h0 : (fun S' => if S' = A then c else 0) S = 0 := by simp [hS]
    rw [h0, mul_zero, zero_mul]
  · intro h
    exact absurd (Finset.mem_univ A) h

/-- **The closed form agrees with the defining Chevalley-sum version** —
proved structurally (no enumeration). -/
theorem gBasisZ_eq (S T : Finset (Fin 5)) :
    gBasisZ S T = gammaBilinearZ (basisZ S) (basisZ T) := by
  unfold gBasisZ gammaBilinearZ
  refine Prod.ext (funext fun j => ?_) (funext fun j => ?_)
  · change (if j ∈ S ∧ ((S.erase j)ᶜ : Finset (Fin 5)) = T
        then opSignZ j (S.erase j) * chevSignZ (S.erase j) else 0)
      = chevalleyPairingZ (contractZ j (basisZ S)) (basisZ T)
    by_cases hj : j ∈ S
    · rw [contractZ_basisZ_of_mem j S hj, chevalleyPairingZ_signedBasis_left]
      simp only [basisZ]
      by_cases hc : ((S.erase j)ᶜ : Finset (Fin 5)) = T
      · rw [if_pos hc, if_pos ⟨hj, hc⟩, mul_one]
      · rw [if_neg hc, mul_zero, if_neg]
        intro hand
        exact hc hand.2
    · rw [contractZ_basisZ_of_not_mem j S hj, chevalleyPairingZ_zero_left, if_neg]
      intro hand
      exact hj hand.1
  · change (if j ∉ S ∧ ((insert j S)ᶜ : Finset (Fin 5)) = T
        then opSignZ j (insert j S) * chevSignZ (insert j S) else 0)
      = chevalleyPairingZ (wedgeZ j (basisZ S)) (basisZ T)
    by_cases hj : j ∈ S
    · rw [wedgeZ_basisZ_of_mem j S hj, chevalleyPairingZ_zero_left, if_neg]
      intro hand
      exact hand.1 hj
    · rw [wedgeZ_basisZ_of_not_mem j S hj, chevalleyPairingZ_signedBasis_left]
      simp only [basisZ]
      by_cases hc : ((insert j S)ᶜ : Finset (Fin 5)) = T
      · rw [if_pos hc, if_pos ⟨hj, hc⟩, mul_one]
      · rw [if_neg hc, mul_zero, if_neg]
        intro hand
        exact hc hand.2

/-- The `32 × 32` basis symmetry check, on the cheap closed form, by kernel
`decide`. This is the combinatorial heart of the symmetry of the
gamma-bilinear; it is exactly where the alpha twist of `chevalleySign` is
load-bearing. -/
theorem gBasisZ_symm : ∀ S T : Finset (Fin 5), gBasisZ S T = gBasisZ T S := by
  decide

/-- Basis-level symmetry of the integer gamma-bilinear (all subsets). -/
theorem gammaBilinearZ_basis_symm_all (S T : Finset (Fin 5)) :
    gammaBilinearZ (basisZ S) (basisZ T) = gammaBilinearZ (basisZ T) (basisZ S) := by
  rw [← gBasisZ_eq, ← gBasisZ_eq, gBasisZ_symm]

/-! ## Casting from the integer model to `ℂ` -/

noncomputable section

/-- Cast an integer Fock spinor to a complex one. -/
def castS (f : FockSpinorZ) : FockSpinor := fun S => (f S : ℂ)

/-- Cast an integer vector to a complex one. -/
def cast10 (v : V10Z) : V10 := (fun j => (v.1 j : ℂ), fun j => (v.2 j : ℂ))

@[simp] theorem castS_zero : castS 0 = 0 := by
  funext S; simp [castS]

theorem castS_add (f g : FockSpinorZ) : castS (f + g) = castS f + castS g := by
  funext S; simp [castS]

@[simp] theorem castS_basisZ (T : Finset (Fin 5)) : castS (basisZ T) = basisSpinor T := by
  funext S; by_cases h : S = T <;> simp [castS, basisZ, basisSpinor, h]

theorem opSignZ_castC (i : Fin 5) (S : Finset (Fin 5)) :
    ((opSignZ i S : ℤ) : ℂ) = opSign i S := by
  simp [opSignZ, opSign]

theorem chevSignZ_castC (S : Finset (Fin 5)) :
    ((chevSignZ S : ℤ) : ℂ) = chevalleySign S := by
  simp [chevSignZ, chevalleySign]

theorem castS_wedgeZ (i : Fin 5) (f : FockSpinorZ) :
    castS (wedgeZ i f) = wedge i (castS f) := by
  funext S
  simp only [castS, wedge, wedgeZ]
  split <;> simp [opSignZ_castC]

theorem castS_contractZ (i : Fin 5) (f : FockSpinorZ) :
    castS (contractZ i f) = contract i (castS f) := by
  funext S
  simp only [castS, contract, contractZ]
  split <;> simp [opSignZ_castC]

theorem chevalleyPairingZ_castC (f g : FockSpinorZ) :
    ((chevalleyPairingZ f g : ℤ) : ℂ) = chevalleyPairing (castS f) (castS g) := by
  unfold chevalleyPairingZ chevalleyPairing castS
  simp [← chevSignZ_castC, Int.cast_sum, Int.cast_mul]

theorem gammaBilinearZ_cast (f g : FockSpinorZ) :
    cast10 (gammaBilinearZ f g) = gammaBilinear (castS f) (castS g) := by
  unfold cast10 gammaBilinearZ gammaBilinear
  simp only [chevalleyPairingZ_castC, castS_contractZ, castS_wedgeZ]

theorem cliffordActionZ_cast (v : V10Z) (f : FockSpinorZ) :
    castS (cliffordActionZ v f) = cliffordAction (cast10 v) (castS f) := by
  funext S
  simp [castS, cliffordActionZ, cliffordAction, cast10, wedgeZ, contractZ,
    wedge, contract, opSignZ, opSign]

/-! ## Multilinear expansion in the wedge-monomial basis -/

/-- Every Fock spinor is the sum of its basis components. -/
theorem spinor_eq_sum_basis (ψ : FockSpinor) :
    ψ = ∑ S : Finset (Fin 5), ψ S • basisSpinor S := by
  funext T
  simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul, basisSpinor]
  rw [Finset.sum_eq_single T]
  · simp
  · intro S _ hST
    rw [if_neg (fun h => hST h.symm), mul_zero]
  · intro h
    exact absurd (Finset.mem_univ T) h

theorem gammaBilinear_sum_left {ι : Type*} (s : Finset ι) (f : ι → FockSpinor)
    (φ : FockSpinor) :
    gammaBilinear (∑ i ∈ s, f i) φ = ∑ i ∈ s, gammaBilinear (f i) φ := by
  classical
  induction s using Finset.induction with
  | empty => simp
  | @insert i s hi ih =>
    rw [Finset.sum_insert hi, Finset.sum_insert hi, gammaBilinear_add_left, ih]

theorem gammaBilinear_sum_right {ι : Type*} (s : Finset ι) (ψ : FockSpinor)
    (g : ι → FockSpinor) :
    gammaBilinear ψ (∑ i ∈ s, g i) = ∑ i ∈ s, gammaBilinear ψ (g i) := by
  classical
  induction s using Finset.induction with
  | empty => simp
  | @insert i s hi ih =>
    rw [Finset.sum_insert hi, Finset.sum_insert hi, gammaBilinear_add_right, ih]

theorem cliffordAction_sum_vec {ι : Type*} (s : Finset ι) (v : ι → V10)
    (ψ : FockSpinor) :
    cliffordAction (∑ i ∈ s, v i) ψ = ∑ i ∈ s, cliffordAction (v i) ψ := by
  classical
  induction s using Finset.induction with
  | empty => simp
  | @insert i s hi ih =>
    rw [Finset.sum_insert hi, Finset.sum_insert hi, cliffordAction_add_vec, ih]

theorem cliffordAction_sum_spinor {ι : Type*} (s : Finset ι) (v : V10)
    (g : ι → FockSpinor) :
    cliffordAction v (∑ i ∈ s, g i) = ∑ i ∈ s, cliffordAction v (g i) := by
  classical
  induction s using Finset.induction with
  | empty => simp
  | @insert i s hi ih =>
    rw [Finset.sum_insert hi, Finset.sum_insert hi, cliffordAction_add_spinor, ih]

/-- Bilinear expansion of the gamma-bilinear in the basis. -/
theorem gammaBilinear_expand (ψ φ : FockSpinor) :
    gammaBilinear ψ φ
      = ∑ S : Finset (Fin 5), ∑ T : Finset (Fin 5),
          (ψ S * φ T) • gammaBilinear (basisSpinor S) (basisSpinor T) := by
  conv_lhs => rw [spinor_eq_sum_basis ψ, spinor_eq_sum_basis φ]
  rw [gammaBilinear_sum_left]
  refine Finset.sum_congr rfl fun S _ => ?_
  rw [gammaBilinear_smul_left, gammaBilinear_sum_right, Finset.smul_sum]
  refine Finset.sum_congr rfl fun T _ => ?_
  rw [gammaBilinear_smul_right, smul_smul]

/-! ## The symmetry theorem and its Krasnov-condition corollary -/

/-- Basis-level symmetry of the gamma-bilinear over `ℂ`, transported from the
kernel-checked integer fact. -/
theorem gammaBilinear_basis_symm (S T : Finset (Fin 5)) :
    gammaBilinear (basisSpinor S) (basisSpinor T)
      = gammaBilinear (basisSpinor T) (basisSpinor S) := by
  rw [← castS_basisZ S, ← castS_basisZ T, ← gammaBilinearZ_cast, ← gammaBilinearZ_cast,
    gammaBilinearZ_basis_symm_all]

/-- **The gamma-bilinear is symmetric** — unconditionally, in particular on
the positive-chirality (even) spinors of the `16`. This is the statement that
`V` sits in `Sym²(S⁺)` for `Spin(10)`. -/
theorem gammaBilinear_symm (ψ φ : FockSpinor) :
    gammaBilinear ψ φ = gammaBilinear φ ψ := by
  rw [gammaBilinear_expand ψ φ, gammaBilinear_expand φ ψ, Finset.sum_comm]
  refine Finset.sum_congr rfl fun a _ => Finset.sum_congr rfl fun b _ => ?_
  rw [gammaBilinear_basis_symm b a, mul_comm (ψ b) (φ a)]

/-- **Proposition 2, single-`q` form** (upgrade of `sum_quadric_iff` using
symmetry): for two spinors on the purity quadric, the sum satisfies the
quadric iff `q(ψ₁, ψ₂) = 0`. This is Krasnov's alignment condition in its
standard form. -/
theorem sum_quadric_iff_single {ψ₁ ψ₂ : FockSpinor}
    (h₁ : gammaBilinear ψ₁ ψ₁ = 0) (h₂ : gammaBilinear ψ₂ ψ₂ = 0) :
    gammaBilinear (ψ₁ + ψ₂) (ψ₁ + ψ₂) = 0 ↔ gammaBilinear ψ₁ ψ₂ = 0 := by
  rw [sum_quadric_iff h₁ h₂, gammaBilinear_symm ψ₂ ψ₁]
  constructor
  · intro h
    have h2 : (2 : ℂ) • gammaBilinear ψ₁ ψ₂ = 0 := by
      rw [two_smul]
      exact h
    rcases smul_eq_zero.mp h2 with h' | h'
    · exact absurd h' two_ne_zero
    · exact h'
  · intro h
    rw [h, add_zero]

end

end PhysicsSM.Spinor.SpinorTenfold
