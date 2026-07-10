import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 4000000

/-!
# Massless: chirality = helicity; mass is what couples opposite helicities

A self-contained finite matrix model (one fixed momentum, chiral / Weyl basis) capturing the
standard Dirac facts:

* **Massless** ⇒ chirality (γ₅ eigenvalue) = helicity (spin along the momentum), the two Weyl
  components are decoupled definite-helicity luminal modes.
* **Mass** is precisely the term that couples the two chirality (hence opposite-helicity) Weyl
  pieces — the "zigzag": the electron is a right-handed and a left-handed massless piece,
  swapped by the mass.

## Conventions and honest scope

Everything is over `ℚ` with explicit `4×4` (and `2×2` Weyl-block) rational matrices; momentum is
fixed along the `z`-axis with unit magnitude and unit energy (`c = 1`).

* `sigma3` : the Weyl-block helicity operator `σ₃` (eigenvalues `±1`).
* `h4 = diag(σ₃, σ₃) = diag(1,-1,1,-1)` : the full `4×4` **helicity** operator `Σ₃`.
* `g5 = diag(1,1,-1,-1)` : **chirality** `γ₅` (upper Weyl block chirality `+1`, lower `-1`).
* `D0 = diag(σ₃, -σ₃) = diag(1,-1,-1,1)` : the **massless Dirac Hamiltonian** `α·p` in the chiral
  basis. In this basis `α·p = diag(σ·p, -σ·p)` is block-diagonal, so it manifestly **preserves
  each chirality block** (`D0` commutes with `g5`). Its eigenvalues `±1` are the energies of the
  propagating modes.
* `Dmass m = m·β = m·[[0,I],[I,0]]` : the **mass term** `β m`, block-**off**-diagonal in chirality.
* `Dtot m = D0 + Dmass m` : the full Dirac Hamiltonian.

**Physics nuance (stated honestly).** For a *free* particle with fixed momentum the true helicity
operator `h4 = Σ₃` is conserved *even with mass* (`Dtot m` commutes with `h4`): helicity is spin
along a conserved momentum. What mass breaks is **chirality** conservation: `Dtot m` does **not**
commute with `g5`. Because for the *massless* propagating (positive-energy) modes chirality equals
helicity, the mass term — which flips chirality (`g5 (Dmass m) g5 = -(Dmass m)`) — is exactly the
operator that couples the two would-be opposite-helicity Weyl pieces. That is the precise content of
"mass couples opposite helicities", and the nonzero commutator `[Dtot 1, g5] ≠ 0` (explicit entry
`-2`) exhibits it.
-/

namespace HelicityChirality

open Matrix

/-- Weyl-block helicity operator `σ₃` (eigenvalues `±1`). -/
abbrev sigma3 : Matrix (Fin 2) (Fin 2) ℚ := !![1,0;0,-1]

/-- Full `4×4` helicity operator `Σ₃ = diag(σ₃, σ₃) = diag(1,-1,1,-1)`. -/
abbrev h4 : Matrix (Fin 4) (Fin 4) ℚ := !![1,0,0,0;0,-1,0,0;0,0,1,0;0,0,0,-1]

/-- Chirality `γ₅ = diag(1,1,-1,-1)` : upper Weyl block chirality `+1`, lower `-1`. -/
abbrev g5 : Matrix (Fin 4) (Fin 4) ℚ := !![1,0,0,0;0,1,0,0;0,0,-1,0;0,0,0,-1]

/-- Massless Dirac Hamiltonian `α·p = diag(σ₃, -σ₃) = diag(1,-1,-1,1)` (chiral basis). -/
abbrev D0 : Matrix (Fin 4) (Fin 4) ℚ := !![1,0,0,0;0,-1,0,0;0,0,-1,0;0,0,0,1]

/-- Mass term `β m = m·[[0,I],[I,0]]`, block-off-diagonal in chirality. -/
def Dmass (m : ℚ) : Matrix (Fin 4) (Fin 4) ℚ := !![0,0,m,0;0,0,0,m;m,0,0,0;0,m,0,0]

/-- Full Dirac Hamiltonian `Dtot m = D0 + β m`. -/
def Dtot (m : ℚ) : Matrix (Fin 4) (Fin 4) ℚ := D0 + Dmass m

/-- Weyl basis vector `e₀ = (1,0,0,0)` : upper block, spin up. -/
def e0 : Fin 4 → ℚ := ![1,0,0,0]
/-- Weyl basis vector `e₂ = (0,0,1,0)` : lower block, spin up. -/
def e2 : Fin 4 → ℚ := ![0,0,1,0]
/-- Weyl basis vector `e₃ = (0,0,0,1)` : lower block, spin down. -/
def e3 : Fin 4 → ℚ := ![0,0,0,1]

/-! ## Target 1 : helicity operator basics -/

/-- **Target 1.** On each Weyl block the helicity operator `σ₃` squares to the identity and is
traceless; the two Weyl blocks carry opposite chirality — `γ₅ = +1` on the upper block
(`g5 e₀ = e₀`) and `γ₅ = -1` on the lower block (`g5 e₂ = -e₂`). -/
theorem helicity_ops :
    sigma3 * sigma3 = 1 ∧ Matrix.trace sigma3 = 0 ∧
      g5.mulVec e0 = e0 ∧ g5.mulVec e2 = -e2 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [sigma3, Matrix.mul_apply, Fin.sum_univ_two]
  · simp [sigma3, Matrix.trace, Matrix.diag, Fin.sum_univ_two]
  · funext i; fin_cases i <;>
      simp [g5, e0, Matrix.mulVec, Fin.sum_univ_four, dotProduct]
  · funext i; fin_cases i <;>
      simp [g5, e2, Matrix.mulVec, Fin.sum_univ_four, dotProduct]

/-- The full `4×4` helicity operator squares to the identity: `Σ₃² = 1`. -/
theorem helicity_sq : h4 * h4 = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [h4, Matrix.mul_apply, Fin.sum_univ_four]

/-! ## Target 2 : massless ⇒ chirality = helicity -/

/-- **Target 2 (payload).** At `m = 0`:

* `D0` **preserves each chirality block** (`D0 * g5 = g5 * D0`) and commutes with helicity
  (`D0 * h4 = h4 * D0`);
* on the propagating **positive-energy** modes (nonzero eigenvalue `+1` of `D0`), chirality equals
  helicity: `g5 v = h4 v` for every `v` with `D0 v = v`;
* the explicit modes realize the correspondence **right-handed ↔ +1 helicity**,
  **left-handed ↔ -1 helicity**:
  `e₀` has energy `+1`, helicity `+1`, chirality `+1`; `e₃` has energy `+1`, helicity `-1`,
  chirality `-1`. -/
theorem massless_helicity_eq_chirality :
    (D0 * g5 = g5 * D0) ∧
    (D0 * h4 = h4 * D0) ∧
    (∀ v : Fin 4 → ℚ, D0.mulVec v = v → g5.mulVec v = h4.mulVec v) ∧
    (D0.mulVec e0 = e0 ∧ h4.mulVec e0 = e0 ∧ g5.mulVec e0 = e0) ∧
    (D0.mulVec e3 = e3 ∧ h4.mulVec e3 = -e3 ∧ g5.mulVec e3 = -e3) := by
  refine ⟨?_, ?_, ?_, ⟨?_, ?_, ?_⟩, ?_, ?_, ?_⟩
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [D0, g5, Matrix.mul_apply, Fin.sum_univ_four]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [D0, h4, Matrix.mul_apply, Fin.sum_univ_four]
  · intro v hv
    have h1 : (D0.mulVec v) 1 = v 1 := by rw [hv]
    have h2 : (D0.mulVec v) 2 = v 2 := by rw [hv]
    simp [D0, Matrix.mulVec, Fin.sum_univ_four, dotProduct] at h1 h2
    funext i; fin_cases i <;>
      simp [g5, h4, Matrix.mulVec, Fin.sum_univ_four, dotProduct] <;> linarith
  · funext i; fin_cases i <;> simp [D0, e0, Matrix.mulVec, Fin.sum_univ_four, dotProduct]
  · funext i; fin_cases i <;> simp [h4, e0, Matrix.mulVec, Fin.sum_univ_four, dotProduct]
  · funext i; fin_cases i <;> simp [g5, e0, Matrix.mulVec, Fin.sum_univ_four, dotProduct]
  · funext i; fin_cases i <;> simp [D0, e3, Matrix.mulVec, Fin.sum_univ_four, dotProduct]
  · funext i; fin_cases i <;> simp [h4, e3, Matrix.mulVec, Fin.sum_univ_four, dotProduct]
  · funext i; fin_cases i <;> simp [g5, e3, Matrix.mulVec, Fin.sum_univ_four, dotProduct]

/-! ## Target 3 : mass couples opposite helicities -/

/-- **Target 3.** The mass term flips chirality — `γ₅ (β m) γ₅ = -(β m)` — hence maps the `+1`
chirality subspace to the `-1` subspace and back, i.e. it couples the two Weyl pieces which for the
massless theory are the opposite-helicity luminal modes. Consequently `Dtot 1` fails to commute
with chirality: `[Dtot 1, g5] ≠ 0`, with the explicit nonzero entry `[Dtot 1, g5]₀₂ = -2`.

Honest nuance: the *true helicity* operator `h4` is still conserved (`Dtot m * h4 = h4 * Dtot m`) —
helicity is spin along the conserved momentum. It is chirality (= helicity of the massless pieces)
that mass no longer preserves. -/
theorem mass_couples_helicities :
    (∀ m : ℚ, g5 * Dmass m * g5 = - Dmass m) ∧
    ((Dtot 1 * g5 - g5 * Dtot 1) 0 2 = -2) ∧
    (Dtot 1 * g5 - g5 * Dtot 1 ≠ 0) ∧
    (∀ m : ℚ, Dtot m * h4 = h4 * Dtot m) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro m
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [g5, Dmass, Matrix.mul_apply, Fin.sum_univ_four]
  · simp [Dtot, D0, Dmass, g5, Matrix.sub_apply]
    norm_num
  · intro hcon
    have h02 : (Dtot 1 * g5 - g5 * Dtot 1) 0 2 = -2 := by
      simp [Dtot, D0, Dmass, g5, Matrix.sub_apply]
      norm_num
    rw [hcon] at h02
    norm_num [Matrix.zero_apply] at h02
  · intro m
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [Dtot, D0, Dmass, h4, Matrix.mul_apply, Fin.sum_univ_four]

/-! ## Target 4 : verdict -/

/-- **Target 4 (verdict).** The package.

*Massless* (`m = 0`): the Dirac Hamiltonian `D0` preserves each chirality block and commutes with
helicity, and on each propagating (positive-energy) mode chirality **equals** helicity — the
electron's massless limit is a right-handed `+1`-helicity piece (`e₀`) together with a left-handed
`-1`-helicity piece (`e₃`), each a definite-helicity luminal mode.

*Mass* (`m ≠ 0`): the mass term flips chirality (`γ₅ (β m) γ₅ = -(β m)`) and so couples the two
Weyl pieces — swapping the two would-be opposite helicities; the failure of chirality conservation
is witnessed by `[Dtot 1, g5] ≠ 0`. This is the zigzag picture: *the electron is a left-helicity
and a right-helicity massless piece, swapped by mass.* -/
theorem verdict :
    -- massless: chirality block preserved, helicity commutes, chirality = helicity on modes
    (D0 * g5 = g5 * D0) ∧
    (∀ v : Fin 4 → ℚ, D0.mulVec v = v → g5.mulVec v = h4.mulVec v) ∧
    (D0.mulVec e0 = e0 ∧ g5.mulVec e0 = e0 ∧ h4.mulVec e0 = e0) ∧
    (D0.mulVec e3 = e3 ∧ g5.mulVec e3 = -e3 ∧ h4.mulVec e3 = -e3) ∧
    -- mass swaps chirality (= opposite helicities) and breaks chirality conservation
    (∀ m : ℚ, g5 * Dmass m * g5 = - Dmass m) ∧
    (Dtot 1 * g5 - g5 * Dtot 1 ≠ 0) := by
  obtain ⟨hb, hc, hcv, ⟨he0D, he0h, he0g⟩, ⟨he3D, he3h, he3g⟩⟩ := massless_helicity_eq_chirality
  obtain ⟨hflip, _, hncomm, _⟩ := mass_couples_helicities
  exact ⟨hb, hcv, ⟨he0D, he0g, he0h⟩, ⟨he3D, he3g, he3h⟩, hflip, hncomm⟩

/-! ## Axiom footprint : exactly `[propext, Classical.choice, Quot.sound]` on every headline. -/

/-- info: 'HelicityChirality.helicity_ops' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms helicity_ops

/-- info: 'HelicityChirality.helicity_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms helicity_sq

/-- info: 'HelicityChirality.massless_helicity_eq_chirality' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_helicity_eq_chirality

/-- info: 'HelicityChirality.mass_couples_helicities' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mass_couples_helicities

/-- info: 'HelicityChirality.verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms verdict

end HelicityChirality
