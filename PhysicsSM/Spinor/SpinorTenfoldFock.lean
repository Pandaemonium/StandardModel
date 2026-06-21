import Mathlib

/-!
# Spinor.SpinorTenfoldFock

Concrete fermionic Fock model for the `Spin(10)` spinor representation.

## Mathematical context

The 32-dimensional Dirac spinor representation of `Spin(10)` can be modeled as
the exterior algebra `Λ•(ℂ⁵)` on a maximal isotropic subspace of `ℂ¹⁰`. The
basis of `Λ•(ℂ⁵)` is indexed by subsets `S ⊆ {0,…,4}`; the positive-chirality
Weyl representation `S⁺` (the `16` of `Spin(10)`) is the even-degree part, and
`S⁻` (the `16-bar`) is the odd-degree part.

The 10-dimensional vector representation `V ≅ ℂ¹⁰` is split hyperbolically as
`V = W ⊕ W*` with `W = ℂ⁵`, written here as pairs `(a, b)` of coordinate
vectors. The Clifford action of `(a, b)` on `Λ•(ℂ⁵)` is

  `(a, b) · ψ = Σᵢ aᵢ (eᵢ ∧ ψ) + Σᵢ bᵢ (ι_{fᵢ} ψ)`,

creation plus annihilation, and it satisfies the Clifford relation
`v · (v · ψ) = Q(v) ψ` for the hyperbolic quadratic form `Q(a, b) = Σᵢ aᵢ bᵢ`.

## Conventions

- Subsets `S : Finset (Fin 5)` index wedge monomials `e_{s₁} ∧ … ∧ e_{s_k}`
  with the indices in **increasing** order.
- Creation: `(eᵢ ∧ ψ)(S) = (-1)^{#{j ∈ S : j < i}} ψ(S \ {i})` for `i ∈ S`.
- Annihilation: `(ι_{fᵢ} ψ)(S) = (-1)^{#{j ∈ S : j < i}} ψ(S ∪ {i})` for `i ∉ S`.
- Quadratic form: `Q(a, b) = Σᵢ aᵢ bᵢ`, with symmetric bilinear form
  `B(v, w) = Σᵢ (v₁ᵢ w₂ᵢ + v₂ᵢ w₁ᵢ)`, so `B(v, v) = 2 Q(v)`.

These conventions are validated against an exact-arithmetic oracle in
`Scripts/oracle/validate_spinor_tenfold.py` (CPython, Fraction arithmetic),
which also confirms downstream facts (symmetry of the gamma-bilinear, the
ten-dimensional Fierz identity) that depend delicately on these signs.

## Main declarations

- `FockSpinor`, `V10`: the spinor and vector spaces.
- `basisSpinor`: the wedge-monomial basis.
- `IsEvenSpinor`, `IsOddSpinor`: the chirality predicates.
- `wedge`, `contract`, `cliffordAction`: creation, annihilation, Clifford action.
- `Q10`, `B10`: quadratic and bilinear forms on `V10`.
- Linearity, parity, and basis-action lemmas for all of the above.

The Clifford relation `cliffordAction v (cliffordAction v ψ) = Q10 v • ψ` and
the canonical anticommutation relations are stated and proved in the draft
module `PhysicsSM.Draft.SpinorTenfoldCARAristotle` (Aristotle handoff); see
also `PhysicsSM.Spinor.SpinorTenfoldPurity` for the Chevalley pairing and the
pure-spinor (Cartan) quadric.

## Sources

- C. Chevalley, "The Algebraic Theory of Spinors and Clifford Algebras"
  (Fock-model construction of half-spin representations).
- Krasnov, "Geometry of Spin(10) Symmetry Breaking", arXiv:2209.05088.
- Internal research notes: `Sources/Spin10_stabilizer.txt` (pure-spinor
  collinearity and the Standard Model stabilizer program).
- Provenance: clean-room formalization from the mathematical definitions;
  no external code copied.

Status: trusted — no `s o r r y`.
-/

noncomputable section

namespace PhysicsSM.Spinor.SpinorTenfold

open Finset

/-! ## The spinor and vector spaces -/

/-- The full 32-dimensional Dirac spinor space of `Spin(10)`, modeled as the
exterior algebra `Λ•(ℂ⁵)` with basis indexed by subsets of `{0,…,4}`. -/
abbrev FockSpinor := Finset (Fin 5) → ℂ

/-- The 10-dimensional complex vector representation of `Spin(10)`, in
hyperbolic split form `V = W ⊕ W*` with `W = ℂ⁵`. The first component holds
the creation coefficients, the second the annihilation coefficients. -/
abbrev V10 := (Fin 5 → ℂ) × (Fin 5 → ℂ)

/-- The wedge-monomial basis spinor supported on the subset `T`. -/
def basisSpinor (T : Finset (Fin 5)) : FockSpinor := fun S => if S = T then 1 else 0

@[simp] theorem basisSpinor_self (T : Finset (Fin 5)) : basisSpinor T T = 1 := by
  simp [basisSpinor]

theorem basisSpinor_ne (T S : Finset (Fin 5)) (h : S ≠ T) : basisSpinor T S = 0 := by
  simp [basisSpinor, h]

theorem basisSpinor_ne_zero (T : Finset (Fin 5)) : basisSpinor T ≠ 0 := by
  intro h
  have := congrFun h T
  simp [basisSpinor] at this

/-! ## Chirality (parity) predicates -/

/-- A spinor is *even* (positive chirality, the `16` of `Spin(10)`) if it is
supported on even-cardinality subsets. -/
def IsEvenSpinor (ψ : FockSpinor) : Prop :=
  ∀ S : Finset (Fin 5), S.card % 2 = 1 → ψ S = 0

/-- A spinor is *odd* (negative chirality, the `16-bar` of `Spin(10)`) if it is
supported on odd-cardinality subsets. -/
def IsOddSpinor (ψ : FockSpinor) : Prop :=
  ∀ S : Finset (Fin 5), S.card % 2 = 0 → ψ S = 0

theorem isEvenSpinor_zero : IsEvenSpinor 0 := fun _ _ => rfl

theorem isOddSpinor_zero : IsOddSpinor 0 := fun _ _ => rfl

theorem IsEvenSpinor.add {ψ φ : FockSpinor} (hψ : IsEvenSpinor ψ)
    (hφ : IsEvenSpinor φ) : IsEvenSpinor (ψ + φ) := fun S hS => by
  rw [Pi.add_apply, hψ S hS, hφ S hS, add_zero]

theorem IsOddSpinor.add {ψ φ : FockSpinor} (hψ : IsOddSpinor ψ)
    (hφ : IsOddSpinor φ) : IsOddSpinor (ψ + φ) := fun S hS => by
  rw [Pi.add_apply, hψ S hS, hφ S hS, add_zero]

theorem IsEvenSpinor.smul {ψ : FockSpinor} (hψ : IsEvenSpinor ψ) (c : ℂ) :
    IsEvenSpinor (c • ψ) := fun S hS => by
  rw [Pi.smul_apply, hψ S hS, smul_zero]

theorem IsOddSpinor.smul {ψ : FockSpinor} (hψ : IsOddSpinor ψ) (c : ℂ) :
    IsOddSpinor (c • ψ) := fun S hS => by
  rw [Pi.smul_apply, hψ S hS, smul_zero]

/-- A wedge monomial on an even-cardinality subset is an even spinor. -/
theorem isEvenSpinor_basisSpinor {T : Finset (Fin 5)} (hT : T.card % 2 = 0) :
    IsEvenSpinor (basisSpinor T) := by
  intro S hS
  apply basisSpinor_ne
  intro h
  rw [h] at hS
  omega

/-! ## Creation and annihilation operators -/

/-- The number of elements of `S` strictly below `i`: the exponent of the
fermionic sign picked up when the operator for index `i` moves past the
generators of `S` with smaller index. -/
def belowCount (i : Fin 5) (S : Finset (Fin 5)) : ℕ :=
  (S.filter (fun j => j < i)).card

/-- The fermionic ordering sign `(-1)^{#{j ∈ S : j < i}}`. -/
def opSign (i : Fin 5) (S : Finset (Fin 5)) : ℂ :=
  (-1 : ℂ) ^ belowCount i S

theorem opSign_mul_self (i : Fin 5) (S : Finset (Fin 5)) :
    opSign i S * opSign i S = 1 := by
  unfold opSign
  rw [← pow_add, ← two_mul, pow_mul]
  simp

/-- `belowCount` ignores whether `i` itself is in the set. -/
theorem belowCount_erase (i : Fin 5) (S : Finset (Fin 5)) :
    belowCount i (S.erase i) = belowCount i S := by
  unfold belowCount
  congr 1
  ext j
  simp only [mem_filter, mem_erase]
  constructor
  · rintro ⟨⟨_, hj⟩, hlt⟩; exact ⟨hj, hlt⟩
  · rintro ⟨hj, hlt⟩; exact ⟨⟨ne_of_lt hlt, hj⟩, hlt⟩

/-- Creation operator: exterior multiplication `eᵢ ∧ ψ` in coordinates. -/
def wedge (i : Fin 5) (ψ : FockSpinor) : FockSpinor := fun S =>
  if i ∈ S then opSign i S * ψ (S.erase i) else 0

/-- Annihilation operator: interior multiplication `ι_{fᵢ} ψ` in coordinates. -/
def contract (i : Fin 5) (ψ : FockSpinor) : FockSpinor := fun S =>
  if i ∈ S then 0 else opSign i S * ψ (insert i S)

/-! ### Linearity of creation and annihilation -/

theorem wedge_add (i : Fin 5) (ψ φ : FockSpinor) :
    wedge i (ψ + φ) = wedge i ψ + wedge i φ := by
  funext S
  simp only [wedge, Pi.add_apply]
  split <;> ring

theorem wedge_smul (i : Fin 5) (c : ℂ) (ψ : FockSpinor) :
    wedge i (c • ψ) = c • wedge i ψ := by
  funext S
  simp only [wedge, Pi.smul_apply, smul_eq_mul]
  split <;> ring

@[simp] theorem wedge_zero (i : Fin 5) : wedge i (0 : FockSpinor) = 0 := by
  funext S
  simp [wedge]

theorem contract_add (i : Fin 5) (ψ φ : FockSpinor) :
    contract i (ψ + φ) = contract i ψ + contract i φ := by
  funext S
  simp only [contract, Pi.add_apply]
  split <;> ring

theorem contract_smul (i : Fin 5) (c : ℂ) (ψ : FockSpinor) :
    contract i (c • ψ) = c • contract i ψ := by
  funext S
  simp only [contract, Pi.smul_apply, smul_eq_mul]
  split <;> ring

@[simp] theorem contract_zero (i : Fin 5) : contract i (0 : FockSpinor) = 0 := by
  funext S
  simp [contract]

/-! ### Nilpotency (the easy halves of the CAR) -/

/-- Creating the same index twice gives zero: `eᵢ ∧ eᵢ ∧ ψ = 0`. -/
theorem wedge_wedge_self (i : Fin 5) (ψ : FockSpinor) :
    wedge i (wedge i ψ) = 0 := by
  funext S
  simp only [wedge, Pi.zero_apply]
  split
  · rw [if_neg (Finset.notMem_erase i S), mul_zero]
  · rfl

/-- Annihilating the same index twice gives zero: `ι_{fᵢ} ι_{fᵢ} ψ = 0`. -/
theorem contract_contract_self (i : Fin 5) (ψ : FockSpinor) :
    contract i (contract i ψ) = 0 := by
  funext S
  simp only [contract, Pi.zero_apply]
  split
  · rfl
  · rw [if_pos (Finset.mem_insert_self i S), mul_zero]

/-! ### Parity: creation and annihilation flip chirality -/

theorem IsEvenSpinor.wedge {ψ : FockSpinor} (hψ : IsEvenSpinor ψ) (i : Fin 5) :
    IsOddSpinor (wedge i ψ) := by
  intro S hS
  unfold SpinorTenfold.wedge
  split
  · rename_i hi
    have hcard : (S.erase i).card % 2 = 1 := by
      rw [Finset.card_erase_of_mem hi]
      have := Finset.card_pos.mpr ⟨i, hi⟩
      omega
    rw [hψ _ hcard, mul_zero]
  · rfl

theorem IsOddSpinor.wedge {ψ : FockSpinor} (hψ : IsOddSpinor ψ) (i : Fin 5) :
    IsEvenSpinor (wedge i ψ) := by
  intro S hS
  unfold SpinorTenfold.wedge
  split
  · rename_i hi
    have hcard : (S.erase i).card % 2 = 0 := by
      rw [Finset.card_erase_of_mem hi]
      have := Finset.card_pos.mpr ⟨i, hi⟩
      omega
    rw [hψ _ hcard, mul_zero]
  · rfl

theorem IsEvenSpinor.contract {ψ : FockSpinor} (hψ : IsEvenSpinor ψ) (i : Fin 5) :
    IsOddSpinor (contract i ψ) := by
  intro S hS
  unfold SpinorTenfold.contract
  split
  · rfl
  · rename_i hi
    have hcard : (insert i S).card % 2 = 1 := by
      rw [Finset.card_insert_of_notMem hi]
      omega
    rw [hψ _ hcard, mul_zero]

theorem IsOddSpinor.contract {ψ : FockSpinor} (hψ : IsOddSpinor ψ) (i : Fin 5) :
    IsEvenSpinor (contract i ψ) := by
  intro S hS
  unfold SpinorTenfold.contract
  split
  · rfl
  · rename_i hi
    have hcard : (insert i S).card % 2 = 0 := by
      rw [Finset.card_insert_of_notMem hi]
      omega
    rw [hψ _ hcard, mul_zero]

/-! ### Action on basis spinors -/

/-- Creation on a wedge monomial not containing `i`: a signed monomial. -/
theorem wedge_basisSpinor_of_not_mem (i : Fin 5) (T : Finset (Fin 5)) (h : i ∉ T) :
    wedge i (basisSpinor T) = opSign i (insert i T) • basisSpinor (insert i T) := by
  funext S
  simp only [wedge, basisSpinor, Pi.smul_apply, smul_eq_mul]
  by_cases hS : S = insert i T
  · subst hS
    rw [if_pos (Finset.mem_insert_self i T), Finset.erase_insert h,
      if_pos rfl, if_pos rfl, mul_one]
  · rw [if_neg hS, mul_zero]
    split
    · rename_i hi
      rw [if_neg, mul_zero]
      intro hT
      exact hS (by rw [← hT, Finset.insert_erase hi])
    · rfl

/-- Creation on a wedge monomial already containing `i` is zero. -/
theorem wedge_basisSpinor_of_mem (i : Fin 5) (T : Finset (Fin 5)) (h : i ∈ T) :
    wedge i (basisSpinor T) = 0 := by
  funext S
  simp only [wedge, basisSpinor, Pi.zero_apply]
  split
  · rw [if_neg, mul_zero]
    intro hT
    exact (Finset.notMem_erase i S) (hT ▸ h)
  · rfl

/-- Annihilation on a wedge monomial containing `i`: a signed monomial. -/
theorem contract_basisSpinor_of_mem (i : Fin 5) (T : Finset (Fin 5)) (h : i ∈ T) :
    contract i (basisSpinor T) = opSign i (T.erase i) • basisSpinor (T.erase i) := by
  funext S
  simp only [contract, basisSpinor, Pi.smul_apply, smul_eq_mul]
  by_cases hiS : i ∈ S
  · rw [if_pos hiS, if_neg, mul_zero]
    intro hST
    exact (Finset.notMem_erase i T) (hST ▸ hiS)
  · rw [if_neg hiS]
    by_cases hST : S = T.erase i
    · subst hST
      rw [if_pos (Finset.insert_erase h), if_pos rfl, mul_one]
    · rw [if_neg hST, mul_zero, if_neg, mul_zero]
      intro hins
      exact hST (by rw [← hins, Finset.erase_insert hiS])

/-- Annihilation on a wedge monomial not containing `i` is zero. -/
theorem contract_basisSpinor_of_not_mem (i : Fin 5) (T : Finset (Fin 5)) (h : i ∉ T) :
    contract i (basisSpinor T) = 0 := by
  funext S
  simp only [contract, basisSpinor, Pi.zero_apply]
  split
  · rfl
  · rw [if_neg, mul_zero]
    intro hins
    exact h (hins ▸ Finset.mem_insert_self i S)

/-! ## The Clifford action of `V10` -/

/-- The Clifford action of a vector `v = (a, b) ∈ V10` on a spinor:
creation with coefficients `a` plus annihilation with coefficients `b`. -/
def cliffordAction (v : V10) (ψ : FockSpinor) : FockSpinor := fun S =>
  (∑ i, v.1 i * wedge i ψ S) + (∑ i, v.2 i * contract i ψ S)

/-- The Clifford action written as a sum of scaled basis operators. -/
theorem cliffordAction_eq_sum (v : V10) (ψ : FockSpinor) :
    cliffordAction v ψ
      = (∑ i, v.1 i • wedge i ψ) + (∑ i, v.2 i • contract i ψ) := by
  funext S
  simp [cliffordAction, Finset.sum_apply]

@[simp] theorem cliffordAction_zero_vec (ψ : FockSpinor) :
    cliffordAction (0 : V10) ψ = 0 := by
  funext S
  simp [cliffordAction]

@[simp] theorem cliffordAction_zero_spinor (v : V10) :
    cliffordAction v (0 : FockSpinor) = 0 := by
  funext S
  simp [cliffordAction]

theorem cliffordAction_add_vec (v w : V10) (ψ : FockSpinor) :
    cliffordAction (v + w) ψ = cliffordAction v ψ + cliffordAction w ψ := by
  funext S
  simp only [cliffordAction, Prod.fst_add, Prod.snd_add, Pi.add_apply, add_mul,
    Finset.sum_add_distrib]
  ring

theorem cliffordAction_smul_vec (c : ℂ) (v : V10) (ψ : FockSpinor) :
    cliffordAction (c • v) ψ = c • cliffordAction v ψ := by
  funext S
  simp only [cliffordAction, Prod.smul_fst, Prod.smul_snd, Pi.smul_apply,
    smul_eq_mul, mul_add, Finset.mul_sum, mul_assoc]

theorem cliffordAction_add_spinor (v : V10) (ψ φ : FockSpinor) :
    cliffordAction v (ψ + φ) = cliffordAction v ψ + cliffordAction v φ := by
  funext S
  simp only [cliffordAction, wedge_add, contract_add, Pi.add_apply, mul_add,
    Finset.sum_add_distrib]
  ring

theorem cliffordAction_smul_spinor (c : ℂ) (v : V10) (ψ : FockSpinor) :
    cliffordAction v (c • ψ) = c • cliffordAction v ψ := by
  funext S
  simp only [cliffordAction, wedge_smul, contract_smul, Pi.smul_apply, smul_eq_mul]
  rw [mul_add, Finset.mul_sum, Finset.mul_sum]
  congr 1
  · exact Finset.sum_congr rfl fun i _ => by ring
  · exact Finset.sum_congr rfl fun i _ => by ring

/-- The Clifford action of a vector maps even spinors to odd spinors:
vectors are chirality-flipping. -/
theorem IsEvenSpinor.cliffordAction {ψ : FockSpinor} (hψ : IsEvenSpinor ψ)
    (v : V10) : IsOddSpinor (cliffordAction v ψ) := by
  intro S hS
  unfold SpinorTenfold.cliffordAction
  rw [Finset.sum_eq_zero, Finset.sum_eq_zero, add_zero]
  · intro i _
    rw [hψ.contract i S hS, mul_zero]
  · intro i _
    rw [hψ.wedge i S hS, mul_zero]

/-- The Clifford action of a vector maps odd spinors to even spinors. -/
theorem IsOddSpinor.cliffordAction {ψ : FockSpinor} (hψ : IsOddSpinor ψ)
    (v : V10) : IsEvenSpinor (cliffordAction v ψ) := by
  intro S hS
  unfold SpinorTenfold.cliffordAction
  rw [Finset.sum_eq_zero, Finset.sum_eq_zero, add_zero]
  · intro i _
    rw [hψ.contract i S hS, mul_zero]
  · intro i _
    rw [hψ.wedge i S hS, mul_zero]

/-! ## The quadratic and bilinear forms on `V10` -/

/-- The hyperbolic quadratic form on `V10`: `Q(a, b) = Σᵢ aᵢ bᵢ`. The Clifford
relation reads `v · (v · ψ) = Q10 v • ψ` (proved in the CAR draft module). -/
def Q10 (v : V10) : ℂ := ∑ i, v.1 i * v.2 i

/-- The symmetric bilinear form on `V10` polarizing `Q10`:
`B(v, w) = Σᵢ (v₁ᵢ w₂ᵢ + v₂ᵢ w₁ᵢ)`, so that `B(v, v) = 2 Q(v)`. -/
def B10 (v w : V10) : ℂ := ∑ i, (v.1 i * w.2 i + v.2 i * w.1 i)

@[simp] theorem Q10_zero : Q10 (0 : V10) = 0 := by
  simp [Q10]

@[simp] theorem B10_zero_left (w : V10) : B10 0 w = 0 := by
  simp [B10]

@[simp] theorem B10_zero_right (v : V10) : B10 v 0 = 0 := by
  simp [B10]

theorem B10_comm (v w : V10) : B10 v w = B10 w v := by
  unfold B10
  exact Finset.sum_congr rfl fun i _ => by ring

theorem B10_self (v : V10) : B10 v v = 2 * Q10 v := by
  unfold B10 Q10
  rw [Finset.mul_sum]
  exact Finset.sum_congr rfl fun i _ => by ring

/-- Polarization: `Q(v + w) = Q(v) + Q(w) + B(v, w)`. -/
theorem Q10_add (v w : V10) : Q10 (v + w) = Q10 v + Q10 w + B10 v w := by
  unfold Q10 B10
  simp only [Prod.fst_add, Prod.snd_add, Pi.add_apply]
  rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
  exact Finset.sum_congr rfl fun i _ => by ring

theorem Q10_smul (c : ℂ) (v : V10) : Q10 (c • v) = c ^ 2 * Q10 v := by
  unfold Q10
  simp only [Prod.smul_fst, Prod.smul_snd, Pi.smul_apply, smul_eq_mul]
  rw [Finset.mul_sum]
  exact Finset.sum_congr rfl fun i _ => by ring

theorem B10_add_left (u v w : V10) : B10 (u + v) w = B10 u w + B10 v w := by
  unfold B10
  simp only [Prod.fst_add, Prod.snd_add, Pi.add_apply]
  rw [← Finset.sum_add_distrib]
  exact Finset.sum_congr rfl fun i _ => by ring

theorem B10_add_right (u v w : V10) : B10 u (v + w) = B10 u v + B10 u w := by
  rw [B10_comm, B10_add_left, B10_comm v u, B10_comm w u]

theorem B10_smul_left (c : ℂ) (v w : V10) : B10 (c • v) w = c * B10 v w := by
  unfold B10
  simp only [Prod.smul_fst, Prod.smul_snd, Pi.smul_apply, smul_eq_mul]
  rw [Finset.mul_sum]
  exact Finset.sum_congr rfl fun i _ => by ring

theorem B10_smul_right (c : ℂ) (v w : V10) : B10 v (c • w) = c * B10 v w := by
  rw [B10_comm, B10_smul_left, B10_comm]

end PhysicsSM.Spinor.SpinorTenfold

end
