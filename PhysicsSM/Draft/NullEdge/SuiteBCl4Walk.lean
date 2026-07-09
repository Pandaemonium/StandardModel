import Mathlib

open scoped BigOperators
open scoped Classical
open Matrix

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

/-!
# Suite B rung B2 — the Cl(4) checkerboard lift

A landed result (`CheckerboardCarrierBridge`) shows that the 1+1D Dirac quantum walk **is**
a finite Krein null-edge carrier: its kinetic and mass parts are Krein-self-adjoint and the
mass part is chiral-odd.  This file lifts that bridge to a **Cl(4)-flavored** 4-component real
walk, the first step toward the 3+1D checkerboard.

## The model (REAL 4×4 rational matrices — a Majorana-type real choice)

All objects are honest real `4 × 4` matrices over `ℚ`, written in the tensor form `P ⊗ Q`
of Pauli-type blocks.  We use

* `G1 = σx ⊗ I`      — the **Krein form** `J` (symmetric, `J² = 1`, `trace J = 0`, indefinite);
* `Gk = I ⊗ σz`      — the **kinetic** gamma;
* `Gm = I ⊗ σx`      — the **mass** gamma;
* `G5 = σx ⊗ σz`     — the **chirality** `Γ₅ = G1 · Gk` (convention: `Γ₅² = +1`).

The one-step momentum-free walk generator is the clean real Cl(4) split
`D(a,m) = a • Gk + m • Gm` with an explicit **kinetic** part `a • Gk` and **mass** part
`m • Gm`.

### Convention notes (honest scope)

* The **Clifford anticommuting pair** of the walk is `(Gk, Gm)`: both square to `1` and they
  anticommute.  The Krein form `J = G1` is a *distinct* symmetric involution which **commutes**
  with the two walk gammas — exactly what makes the symmetric parts Krein-self-adjoint (a real
  symmetric matrix commuting with `J` satisfies `J Xᵀ J = X`).  A symmetric involution
  *anticommuting* with `J` would be Krein-*anti*-self-adjoint and, together with the positive
  mass-shell square below, could not give `D² = (a²+m²)·1`.  So this commuting split is the
  unique clean real Cl(4)-flavored choice consistent with all five targets.
* Chirality convention: `Γ₅ = G1 · Gk = σx ⊗ σz`, so `Γ₅² = +1`.
* Honest scope: this is **one momentum-free finite step**, not the full 3+1D walk.
-/

namespace SuiteB_Cl4Walk

/-- Real `4 × 4` rational matrices — the carrier space. -/
abbrev M4 := Matrix (Fin 4) (Fin 4) ℚ

/-- Krein form `J = G1 = σx ⊗ I`. -/
def J : M4 := !![0,0,1,0; 0,0,0,1; 1,0,0,0; 0,1,0,0]

/-- Kinetic gamma `Gk = I ⊗ σz`. -/
def Gk : M4 := !![1,0,0,0; 0,-1,0,0; 0,0,1,0; 0,0,0,-1]

/-- Mass gamma `Gm = I ⊗ σx`. -/
def Gm : M4 := !![0,1,0,0; 1,0,0,0; 0,0,0,1; 0,0,1,0]

/-- Chirality `Γ₅ = G1 · Gk = σx ⊗ σz` (convention `Γ₅² = +1`). -/
def G5 : M4 := !![0,0,1,0; 0,0,0,-1; 1,0,0,0; 0,-1,0,0]

/-- The one-step momentum-free walk generator `D(a,m) = a • Gk + m • Gm`
(kinetic part `a • Gk`, mass part `m • Gm`). -/
def D (a m : ℚ) : M4 := a • Gk + m • Gm

/-- `Γ₅ = G1 · Gk` — the chirality really is the product of the Krein form and the kinetic
gamma. -/
theorem G5_eq_J_mul_Gk : G5 = J * Gk := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [G5, J, Gk]

/-- The kinetic part `a • Gk` is exactly the `Gk`-component of `D`, the mass part `m • Gm` the
`Gm`-component. -/
theorem D_split (a m : ℚ) : D a m = a • Gk + m • Gm := rfl

/-! ### Target 1 — Clifford + Krein-form relations -/

/-- **`gamma_relations`.** The chosen real 4×4 matrices satisfy the Clifford relations and the
Krein-form properties:

* the walk gammas `Gk, Gm, G5` square to `1`;
* `Gk` and `Gm` **anticommute** (the Clifford pair);
* the Krein form `J` is symmetric (`Jᵀ = J`), squares to `1`, and has `trace J = 0`
  (genuinely indefinite);
* `J` **commutes** with both walk gammas (so the symmetric parts are Krein-self-adjoint). -/
theorem gamma_relations :
    Gk * Gk = 1 ∧ Gm * Gm = 1 ∧ G5 * G5 = 1 ∧
    (Gk * Gm + Gm * Gk = 0) ∧
    J.transpose = J ∧ J * J = 1 ∧ Matrix.trace J = 0 ∧
    (J * Gk = Gk * J) ∧ (J * Gm = Gm * J) := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · ext i j; fin_cases i <;> fin_cases j <;> simp [Gk]
  · ext i j; fin_cases i <;> fin_cases j <;> simp [Gm]
  · ext i j; fin_cases i <;> fin_cases j <;> simp [G5]
  · ext i j; fin_cases i <;> fin_cases j <;> simp [Gk, Gm]
  · ext i j; fin_cases i <;> fin_cases j <;> simp [J, Matrix.transpose_apply]
  · ext i j; fin_cases i <;> fin_cases j <;> simp [J]
  · simp [J, Matrix.trace, Matrix.diag, Fin.sum_univ_four]
  · ext i j; fin_cases i <;> fin_cases j <;> simp [J, Gk]
  · ext i j; fin_cases i <;> fin_cases j <;> simp [J, Gm]

/-! ### Target 2 — Krein-self-adjointness of the kinetic and mass parts -/

/-- `Gk` is symmetric (real, so its own transpose adjoint). -/
theorem Gk_symm : Gk.transpose = Gk := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [Gk, Matrix.transpose_apply]

/-- `Gm` is symmetric. -/
theorem Gm_symm : Gm.transpose = Gm := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [Gm, Matrix.transpose_apply]

/-- The kinetic gamma is fixed under `J`-conjugation. -/
theorem J_conj_Gk : J * Gk * J = Gk := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [J, Gk, Matrix.mul_apply, Fin.sum_univ_four]

/-- The mass gamma is fixed under `J`-conjugation. -/
theorem J_conj_Gm : J * Gm * J = Gm := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [J, Gm, Matrix.mul_apply, Fin.sum_univ_four]

/-- **`krein_selfadjoint`.** Both the kinetic part `a • Gk` and the mass part `m • Gm` are
Krein-self-adjoint with respect to the real transpose adjoint: `J Xᵀ J = X`. -/
theorem krein_selfadjoint (a m : ℚ) :
    J * (a • Gk).transpose * J = a • Gk ∧
    J * (m • Gm).transpose * J = m • Gm := by
  refine ⟨?_, ?_⟩
  · rw [Matrix.transpose_smul, Gk_symm, Matrix.mul_smul, Matrix.smul_mul, J_conj_Gk]
  · rw [Matrix.transpose_smul, Gm_symm, Matrix.mul_smul, Matrix.smul_mul, J_conj_Gm]

/-! ### Target 3 — chiral-odd mass, chiral-even kinetic -/

/-- **`chiral_odd_mass`.** The mass part anticommutes with the chirality
(`Γ₅ M Γ₅ = -M`) while the kinetic part commutes appropriately (`Γ₅ K Γ₅ = K`) — the
Ginsparg-Wilson-flavored grading of the landed 1+1D bridge, now on 4 components. -/
theorem chiral_odd_mass (a m : ℚ) :
    G5 * (m • Gm) * G5 = -(m • Gm) ∧
    G5 * (a • Gk) * G5 = a • Gk := by
  constructor
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [G5, Gm, Matrix.mul_apply, Fin.sum_univ_four]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [G5, Gk, Matrix.mul_apply, Fin.sum_univ_four]

/-! ### Target 4 — the Cl(4) mass-shell square (no sqrt) -/

/-- **`dispersion_square`.** The Cl(4) mass-shell square, stated via the square (no `sqrt`):
`D(a,m)² - (a²+m²)·1 = 0`, so the walk's spectrum is `±√(a²+m²)`-shaped.  Massless case
`m = 0` collapses to `D² = a²·1`.  The mandatory non-degeneracy instance at `a = 3, m = 4`
gives the 3-4-5 shell `D² = 25·1`. -/
theorem dispersion_square (a m : ℚ) :
    D a m * D a m - (a ^ 2 + m ^ 2) • (1 : M4) = 0 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [D, Gk, Gm] <;> ring

/-- Massless collapse: `D(a,0)² = a²·1`. -/
theorem dispersion_square_massless (a : ℚ) :
    D a 0 * D a 0 = (a ^ 2) • (1 : M4) := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [D, Gk, Gm] <;> ring

/-- The mandatory non-degeneracy instance: the 3-4-5 mass shell `D(3,4)² = 25·1`. -/
theorem dispersion_square_three_four :
    D 3 4 * D 3 4 = (25 : ℚ) • (1 : M4) := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [D, Gk, Gm] <;> norm_num

/-! ### Target 5 — the carrier verdict -/

/-- **`carrier_verdict`.** Packaging targets 1-4: the 4-component real walk **is** a finite
Krein null-edge carrier with chiral-odd mass — the Cl(4) lift of the landed 1+1D bridge.

Concretely, for every rational `a, m`:

1. the Clifford + Krein-form relations hold (`gamma_relations`);
2. the kinetic part `a • Gk` and mass part `m • Gm` are Krein-self-adjoint (`krein_selfadjoint`);
3. the mass part is chiral-odd and the kinetic part chiral-even (`chiral_odd_mass`);
4. the mass-shell square holds: `D(a,m)² = (a²+m²)·1` (`dispersion_square`), specializing to
   the 3-4-5 shell `D(3,4)² = 25·1`.

Honest scope: this is one momentum-free finite step, not the full 3+1D walk. -/
theorem carrier_verdict (a m : ℚ) :
    -- (1) Clifford + Krein-form relations
    (Gk * Gk = 1 ∧ Gm * Gm = 1 ∧ G5 * G5 = 1 ∧
      (Gk * Gm + Gm * Gk = 0) ∧
      J.transpose = J ∧ J * J = 1 ∧ Matrix.trace J = 0 ∧
      (J * Gk = Gk * J) ∧ (J * Gm = Gm * J)) ∧
    -- (2) Krein-self-adjoint kinetic and mass parts
    (J * (a • Gk).transpose * J = a • Gk ∧ J * (m • Gm).transpose * J = m • Gm) ∧
    -- (3) chiral-odd mass, chiral-even kinetic
    (G5 * (m • Gm) * G5 = -(m • Gm) ∧ G5 * (a • Gk) * G5 = a • Gk) ∧
    -- (4) Cl(4) mass-shell square, plus the 3-4-5 non-degeneracy instance
    (D a m * D a m - (a ^ 2 + m ^ 2) • (1 : M4) = 0) ∧
    (D 3 4 * D 3 4 = (25 : ℚ) • (1 : M4)) :=
  ⟨gamma_relations, krein_selfadjoint a m, chiral_odd_mass a m,
    dispersion_square a m, dispersion_square_three_four⟩

/-! ### Axiom footprint audits (exactly `[propext, Classical.choice, Quot.sound]`) -/

/-- info: 'SuiteB_Cl4Walk.gamma_relations' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms gamma_relations

/-- info: 'SuiteB_Cl4Walk.krein_selfadjoint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms krein_selfadjoint

/-- info: 'SuiteB_Cl4Walk.chiral_odd_mass' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms chiral_odd_mass

/-- info: 'SuiteB_Cl4Walk.dispersion_square' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms dispersion_square

/-- info: 'SuiteB_Cl4Walk.dispersion_square_massless' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms dispersion_square_massless

/-- info: 'SuiteB_Cl4Walk.dispersion_square_three_four' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms dispersion_square_three_four

/-- info: 'SuiteB_Cl4Walk.carrier_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms carrier_verdict

end SuiteB_Cl4Walk
