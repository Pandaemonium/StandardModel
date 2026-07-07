import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.Q11RealStructure
import PhysicsSM.Draft.NullEdge.GateI1.Q11BLDictionary

/-!
# Q11/Q04: the finite C3 Majorana identity and the bare-turn invariant census

This module is the audited L3/L4 lane for the Q11/Q04 construction.  It builds
directly on top of the top-form-duality real structure `J_R` on `Λ(C^5)` landed
in `Q11RealStructure` and the occupation/B-L dictionary landed in
`Q11BLDictionary`.

On the concrete `32`-dimensional model `Form := Finset (Fin 5) → ℂ` it
formalizes the finite algebra of the *bare Majorana turn*
`T = m·θ_ω + conj(m)·ι_ω`, where

* `θ_ω` creates the full pentad, `e_∅ ↦ e_univ` (the vacuum-to-top-form
  creation `a₁† … a₅†`), and
* `ι_ω = θ_ω†` is its adjoint, `e_univ ↦ e_∅`.

## PROVED finite algebra

* `JR_theta_eq_iota` / `JR_iota_eq_theta` : `J_R θ_ω J_R⁻¹ = ι_ω` and the
  reverse (all interleaving signs `+1`).
* `JR_turn_invariant` : `J_R T J_R⁻¹ = T` **for every complex `m`** — the
  Majorana phase survives the reality condition (`ε' = +1` on C3).
* `turn_eq_theta_iota` : `T = m·θ + conj(m)·ι` at the coefficient level.
* `turn_selfadjoint` : `T` is Hermitian for the standard fiber metric `Bstd`.
* `turn_parity_anticomm` : `T` is `(-1)^F`-odd.
* `bJR_eq_top` : the `J_R`-pairing `⟨J_R x, y⟩` equals the bilinear top pairing
  `top(x ∧ y)`.
* `turn_pairing` / `turn_pairing_symm` / `turn_mass_vacuum` : the exact value of
  `⟨J_R x, T y⟩`, its symmetry (the internal Weyl-mass bilinear is *symmetric*,
  as the antisymmetric Lorentz `ε` requires), and that the vacuum matrix element
  is exactly the mass `m`.  This is the identity **"the C3 bare turn IS `m`
  times the `J_R`-pairing on the sterile plane."**
* `deltaBL_turn` : the turn shifts `B-L` by `-2` (the seesaw `ΔL = 2`).

## PROVED bare-turn invariant census (sector level)

* `invariant_sector_iff` : the gauge-invariant (color/weak/hypercharge-trivial)
  monomial sectors of `Λ(C^5)` are **exactly** `∅` (the sterile vacuum, one SM
  `ν^c`) and `univ` (the top form `ω`).  This is the sterile plane
  `span{1, ω}`.
* `census_card_two` : there are exactly `2` invariant sectors, hence the space
  of gauge-invariant bare monomials connecting them is spanned by `θ_ω, ι_ω` —
  one bare Majorana turn (up to its adjoint).

## PROVED order-condition scalar identities (L4)

Let a degree-preserving decoration `a` act by scalars `(λ, κ)` on
`(Λ⁰, Λ⁵) = (e_∅, e_univ)`.

* `firstOrder_comm` : `[a, T] = (κ - λ)·(m θ) + (λ - κ)·(conj(m) ι)` exactly.
* `firstOrder_RC0_vacuous` : under RC0 (`λ = κ`, the unimodular/gauge-exact
  case) `[a, T] = 0` — **first order holds vacuously on C3**.
* `firstOrder_twist_nonzero` : when `λ ≠ κ` (drop RC0 / gauge B-L) and `m ≠ 0`,
  `[a, T] ≠ 0` — **first order fails by an exact scalar identity**.
* `secondOrder_RC0_vacuous` : under RC0 the Boyle–Farnsworth double commutator
  `[[T, a], b]` also vanishes.

## Claim boundary (MEMO / OPEN — not proved here)

* The *operator*-level uniqueness statement "the space of `G`-invariant,
  `(-1)^F`-odd operators on `Λ(C^5)` is exactly `C·θ_ω + C·ι_ω`" requires the
  full `S(U(3)×U(2))` representation-theoretic decomposition; here it is
  established only at the invariant-*sector* level (`invariant_sector_iff`,
  `census_card_two`), which pins the sterile plane and hence the bare turns.
* The *physical* reading of the second-order identity — which side of the
  Chamseddine–Connes–van Suijlekom vs Boyle–Farnsworth first-vs-second-order
  dispute the strand construction sits on — is MEMO.  What is PROVED is the
  finite fact that on C3 both order conditions are *vacuous under RC0*, so the
  C3 entry alone cannot arbitrate the dispute; the discriminator activates only
  at the B-L-gauged (drop-RC0) deformation, where `firstOrder_twist_nonzero`
  shows first order fails.

Provenance: `Q11_answer.md` §4 and formalization ladder L3/L4; `Q04_answer.md`
rows C3/C4 (bare-turn census).  Built on `Q11RealStructure` and
`Q11BLDictionary`.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.Q11C3Majorana

open Finset
open PhysicsSM.Draft.NullEdge.GateI1.Q11RealStructure
open PhysicsSM.Draft.NullEdge.GateI1.Q11BLDictionary

/-! ## Elementary sign / cardinality facts on `Finset (Fin 5)` -/

lemma sigmaSign_univ5 : sigmaSign (univ : Finset (Fin 5)) = 1 := by decide
lemma sigmaSign_empty5 : sigmaSign (∅ : Finset (Fin 5)) = 1 := by decide
lemma univ_ne_empty5 : (univ : Finset (Fin 5)) ≠ ∅ := by decide
lemma empty_ne_univ5 : (∅ : Finset (Fin 5)) ≠ univ := by decide
lemma card_univ5 : (univ : Finset (Fin 5)).card = 5 := by decide
lemma card_empty5 : (∅ : Finset (Fin 5)).card = 0 := by decide

/-- `J_R ∘ J_R = id` as a function (from the pointwise involutivity). -/
lemma JR_JR (f : Form) : JR (JR f) = f :=
  funext fun T => JR_involutive f T

/-! ## The bare turn operators -/

/-- Full-pentad creation `θ_ω = a₁† … a₅†` : `e_∅ ↦ e_univ`, everything else
`↦ 0`. -/
def theta (f : Form) : Form := fun S => if S = univ then f ∅ else 0

/-- Full-pentad annihilation `ι_ω = θ_ω†` : `e_univ ↦ e_∅`, everything else
`↦ 0`. -/
def iota (f : Form) : Form := fun S => if S = ∅ then f univ else 0

/-- The Hermitian gauge-exact bare Majorana turn `T = m·θ_ω + conj(m)·ι_ω`. -/
def turn (m : ℂ) (f : Form) : Form :=
  fun S => (if S = univ then m * f ∅ else 0)
    + (if S = ∅ then (starRingEnd ℂ) m * f univ else 0)

/-- The coefficient-level decomposition `T = m·θ + conj(m)·ι`. -/
theorem turn_eq_theta_iota (m : ℂ) (f : Form) (S : Finset (Fin 5)) :
    turn m f S = m * theta f S + (starRingEnd ℂ) m * iota f S := by
  simp only [turn, theta, iota]
  split <;> split <;> ring

/-! ## The C3 identity: the bare turn IS the real structure -/

/-- `J_R θ_ω J_R⁻¹ = ι_ω` (all interleaving signs `+1`). -/
theorem JR_theta_eq_iota (f : Form) (T : Finset (Fin 5)) :
    JR (theta (JR f)) T = iota f T := by
  simp only [JR, theta, iota]
  by_cases hT : T = ∅
  · subst hT
    simp [sigmaSign_univ5]
  · have : Tᶜ ≠ univ := by
      intro h; apply hT; simpa [compl_eq_top] using congrArg compl h
    simp [this, hT]

/-- `J_R ι_ω J_R⁻¹ = θ_ω`. -/
theorem JR_iota_eq_theta (f : Form) (T : Finset (Fin 5)) :
    JR (iota (JR f)) T = theta f T := by
  simp only [JR, theta, iota]
  by_cases hT : T = univ
  · subst hT
    simp [sigmaSign_empty5]
  · have : Tᶜ ≠ ∅ := by
      intro h; apply hT; simpa using congrArg compl h
    simp [this, hT]

/-- **Majorana invariance**: `J_R T J_R⁻¹ = T` for *every* complex `m`.  The
Majorana phase survives the reality condition (`ε' = +1` on C3). -/
theorem JR_turn_invariant (m : ℂ) (f : Form) (T : Finset (Fin 5)) :
    JR (turn m (JR f)) T = turn m f T := by
  simp only [JR, turn]
  by_cases hT : T = univ
  · subst hT
    simp [sigmaSign_empty5, univ_ne_empty5, empty_ne_univ5]
  · by_cases hT2 : T = ∅
    · subst hT2
      simp [sigmaSign_univ5, univ_ne_empty5, empty_ne_univ5]
    · have h1 : Tᶜ ≠ univ := by
        intro h; apply hT2; simpa [compl_eq_top] using congrArg compl h
      have h2 : Tᶜ ≠ ∅ := by
        intro h; apply hT; simpa using congrArg compl h
      simp [hT, hT2, h1, h2]

/-! ## Hermiticity and grading -/

/-- Fermion parity `(-1)^F`. -/
def parity' (f : Form) : Form := fun S => ((-1 : ℂ) ^ S.card) * f S

/-- `T` is Hermitian for the standard positive fiber metric `Bstd`. -/
theorem turn_selfadjoint (m : ℂ) (f g : Form) :
    Bstd (turn m f) g = Bstd f (turn m g) := by
  unfold Bstd turn
  rw [Finset.sum_eq_add_of_mem ∅ univ (mem_univ _) (mem_univ _) empty_ne_univ5]
  · rw [Finset.sum_eq_add_of_mem ∅ univ (mem_univ _) (mem_univ _) empty_ne_univ5]
    · simp only [univ_ne_empty5, empty_ne_univ5, if_true, if_false, map_mul,
        Complex.conj_conj, add_zero, zero_add]
      ring
    · intro S _ hS
      simp [hS.1, hS.2]
  · intro S _ hS
    simp [hS.1, hS.2]

/-- `T` is `(-1)^F`-odd: it anticommutes with fermion parity. -/
theorem turn_parity_anticomm (m : ℂ) (f : Form) (T : Finset (Fin 5)) :
    parity' (turn m f) T = - turn m (parity' f) T := by
  simp only [parity', turn]
  by_cases hu : T = univ
  · subst hu
    simp [univ_ne_empty5]; ring
  · by_cases he : T = ∅
    · subst he
      simp [empty_ne_univ5]; ring
    · simp [hu, he]

/-! ## The `J_R`-pairing and the sterile Majorana bilinear -/

/-- The `J_R`-pairing `⟨J_R x, y⟩` equals the bilinear top pairing
`top(x ∧ y) = (x ∧ y)_ω`. -/
theorem bJR_eq_top (x y : Form) : Bstd (JR x) y = wedge x y univ := by
  rw [← Btop_eq_Bstd]
  unfold Btop
  rw [JR_JR]

/-- **The C3 identity.**  The exact value of the Majorana matrix element
`⟨J_R x, T y⟩` on the sterile plane: `m` pairs the two vacua and `conj(m)`
pairs the two top forms. -/
theorem turn_pairing (m : ℂ) (x y : Form) :
    Bstd (JR x) (turn m y)
      = m * (x ∅ * y ∅) + (starRingEnd ℂ) m * (x univ * y univ) := by
  rw [bJR_eq_top]
  unfold wedge turn
  rw [Finset.powerset_univ]
  rw [Finset.sum_eq_add_of_mem ∅ univ (mem_univ _) (mem_univ _) empty_ne_univ5]
  · have e1 : (univ : Finset (Fin 5)) \ ∅ = univ := by simp
    have e2 : (univ : Finset (Fin 5)) \ univ = ∅ := by simp
    rw [e1, e2]
    have s1 : interSign (∅ : Finset (Fin 5)) univ = 1 := by decide
    have s2 : interSign (univ : Finset (Fin 5)) ∅ = 1 := by decide
    simp only [univ_ne_empty5, empty_ne_univ5, if_true, if_false, s1, s2]
    push_cast
    ring
  · intro S _ hS
    have hSne : S ≠ ∅ := hS.1
    have hSnu : S ≠ univ := hS.2
    have hd1 : univ \ S ≠ univ := by
      rw [← Finset.compl_eq_univ_sdiff]
      intro h; exact hSne (by simpa [compl_eq_top] using h)
    have hd2 : univ \ S ≠ ∅ := by
      rw [← Finset.compl_eq_univ_sdiff]
      intro h; exact hSnu (by simpa [compl_eq_bot] using h)
    simp [hd1, hd2]

/-- The internal Weyl-mass bilinear is **symmetric** — exactly as required for
pairing against the antisymmetric Lorentz `ε` in a Weyl mass term. -/
theorem turn_pairing_symm (m : ℂ) (x y : Form) :
    Bstd (JR x) (turn m y) = Bstd (JR y) (turn m x) := by
  rw [turn_pairing, turn_pairing]; ring

/-- A single monomial coefficient function `e_S`. -/
def mono (S : Finset (Fin 5)) : Form := fun U => if U = S then 1 else 0

/-- The vacuum matrix element of the turn is exactly the mass `m`:
`⟨J_R ν^c, T ν^c⟩ = m`, with `ν^c = e_∅`. -/
theorem turn_mass_vacuum (m : ℂ) :
    Bstd (JR (mono ∅)) (turn m (mono ∅)) = m := by
  rw [turn_pairing]
  simp [mono, univ_ne_empty5]

/-! ## The turn shifts `B-L` by `-2` -/

/-- Color occupation of a monomial (strands `0,1,2`). -/
def ncolor (S : Finset (Fin 5)) : ℕ := (S.filter (fun i : Fin 5 => i.val < 3)).card

/-- Weak occupation of a monomial (strands `3,4`). -/
def nweak (S : Finset (Fin 5)) : ℕ := (S.filter (fun i : Fin 5 => 3 ≤ i.val)).card

lemma ncolor_empty : ncolor ∅ = 0 := by decide
lemma ncolor_univ : ncolor univ = 3 := by decide
lemma nweak_empty : nweak ∅ = 0 := by decide
lemma nweak_univ : nweak univ = 2 := by decide

/-- The bare turn connects the vacuum (`n_c = 0`) to the top form (`n_c = 3`);
`B-L` shifts by `-2` (the seesaw `ΔL = 2`). -/
theorem deltaBL_turn :
    BLval (ncolor univ : ℚ) - BLval (ncolor ∅ : ℚ) = -2 := by
  rw [ncolor_univ, ncolor_empty]
  norm_num [BLval]

/-! ## The bare-turn invariant census (sector level) -/

/--
A monomial sector `S` is *gauge invariant* iff it is trivial under color
`SU(3)` (`n_c ∈ {0,3}`), weak `SU(2)` (`n_w ∈ {0,2}`), and hypercharge
(`Y = -n_c/3 + n_w/2 = 0`, i.e. `2 n_c = 3 n_w`).  Every zero-weight monomial of
`Λ(C^3)`/`Λ(C^2)` is automatically a full `SU`-invariant line, so this is the
exact `S(U(3)×U(2))`-invariance condition at the monomial level.
-/
def IsInvariantSector (S : Finset (Fin 5)) : Prop :=
  (ncolor S = 0 ∨ ncolor S = 3) ∧ (nweak S = 0 ∨ nweak S = 2)
    ∧ (2 * ncolor S = 3 * nweak S)

instance : DecidablePred IsInvariantSector := fun S => by
  unfold IsInvariantSector; infer_instance

/-- The integer hypercharge condition `2 n_c = 3 n_w` is exactly `Y = 0` for
`Y = -n_c/3 + n_w/2`. -/
theorem invariant_Y_zero_iff (S : Finset (Fin 5)) :
    (2 * ncolor S = 3 * nweak S)
      ↔ (-(ncolor S : ℚ) / 3 + (nweak S : ℚ) / 2 = 0) := by
  constructor <;> intro h
  · have : (2 * (ncolor S : ℚ)) = 3 * nweak S := by exact_mod_cast h
    field_simp; linarith
  · have : (2 * (ncolor S : ℚ)) = 3 * nweak S := by field_simp at h; linarith
    exact_mod_cast this

/-- **Bare-turn invariant census.**  The gauge-invariant monomial sectors of
`Λ(C^5)` are **exactly** the sterile vacuum `∅` (one SM `ν^c`) and the top form
`univ = ω`.  These span the sterile plane `span{1, ω}` on which the bare turn
lives. -/
theorem invariant_sector_iff (S : Finset (Fin 5)) :
    IsInvariantSector S ↔ (S = ∅ ∨ S = univ) := by
  revert S; decide

/-- There are exactly two invariant sectors: the census count is `2`, so the
gauge-invariant bare monomials connecting them are spanned by `θ_ω` and `ι_ω`
— one bare Majorana turn (up to its adjoint). -/
theorem census_card_two :
    (Finset.univ.filter IsInvariantSector).card = 2 := by decide

/-! ## Order-condition scalar identities (L4)

A degree-preserving decoration `a` acts on the sterile plane by scalars
`λ` on `Λ⁰ = e_∅` and `κ` on `Λ⁵ = e_univ`, the identity elsewhere.
-/

/-- A diagonal decoration acting by `λ` on the vacuum line and `κ` on the top
line. -/
def deco (l k : ℂ) (f : Form) : Form :=
  fun S => if S = univ then k * f S else if S = ∅ then l * f S else f S

/-- **First-order tensor.**  `[a, T] = (κ - λ)·(m θ) + (λ - κ)·(conj(m) ι)`,
exactly. -/
theorem firstOrder_comm (l k m : ℂ) (f : Form) (S : Finset (Fin 5)) :
    deco l k (turn m f) S - turn m (deco l k f) S
      = (if S = univ then (k - l) * m * f ∅ else 0)
        + (if S = ∅ then (l - k) * (starRingEnd ℂ) m * f univ else 0) := by
  simp only [deco, turn]
  by_cases hu : S = univ
  · subst hu
    simp [univ_ne_empty5, empty_ne_univ5]; ring
  · by_cases he : S = ∅
    · subst he
      simp [empty_ne_univ5]; ring
    · simp [hu, he]

/-- **RC0 ⇒ first order vacuous.**  When `λ = κ` (unimodular / gauge-exact
case) the decoration commutes with the turn: `[a, T] = 0`. -/
theorem firstOrder_RC0_vacuous (l m : ℂ) (f : Form) (S : Finset (Fin 5)) :
    deco l l (turn m f) S = turn m (deco l l f) S := by
  have h := firstOrder_comm l l m f S
  simp only [sub_self, zero_mul, ite_self, add_zero] at h
  exact sub_eq_zero.mp h

/-- **Drop RC0 ⇒ first order fails.**  When `λ ≠ κ` and `m ≠ 0`, the decoration
does not commute with the turn (exact nonzero scalar on the top line). -/
theorem firstOrder_twist_nonzero (l k m : ℂ) (hlk : l ≠ k) (hm : m ≠ 0) :
    deco l k (turn m (mono ∅)) univ ≠ turn m (deco l k (mono ∅)) univ := by
  intro h
  have hcm : k * m = m * l := by
    simpa [deco, turn, mono, univ_ne_empty5] using h
  have hmk : m * k = m * l := by rw [mul_comm]; exact hcm
  exact hlk (mul_left_cancel₀ hm hmk).symm

/-- **RC0 ⇒ second order vacuous.**  Under RC0 (`λ = κ`) the Boyle–Farnsworth
double commutator `[[T, a], b]` vanishes for the opposite decoration `b`. -/
theorem secondOrder_RC0_vacuous (l r s m : ℂ) (f : Form) (S : Finset (Fin 5)) :
    deco r s (fun U => turn m (deco l l f) U - deco l l (turn m f) U) S
      - (fun U => turn m (deco l l (deco r s f)) U
          - deco l l (turn m (deco r s f)) U) S = 0 := by
  have key : ∀ (g : Form) (U), turn m (deco l l g) U - deco l l (turn m g) U = 0 := by
    intro g U
    have h := firstOrder_comm l l m g U
    simp only [sub_self, zero_mul, ite_self, add_zero] at h
    rw [(sub_eq_zero.mp h)]; ring
  have hz : (fun U => turn m (deco l l f) U - deco l l (turn m f) U)
      = (fun _ => (0 : ℂ)) := by
    funext U; exact key f U
  rw [hz]
  simp only [key (deco r s f) S]
  simp [deco]

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11C3Majorana.JR_turn_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms JR_turn_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11C3Majorana.turn_pairing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms turn_pairing

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11C3Majorana.invariant_sector_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms invariant_sector_iff

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11C3Majorana.firstOrder_comm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms firstOrder_comm

end PhysicsSM.Draft.NullEdge.GateI1.Q11C3Majorana
