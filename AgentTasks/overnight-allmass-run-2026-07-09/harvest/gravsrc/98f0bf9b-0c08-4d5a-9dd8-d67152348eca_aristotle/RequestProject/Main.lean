import Mathlib

/-!
# claude-gravity-source-matter — the finite field equation

A finite, kernel-checked rational avatar of the unification coupling `G = κ T`:
the null-edge **soldering** (gravity) channel of a single Dirac square is *sourced*
by the **matter** channels (aperture / closure / turn) of the *same* Dirac square,
with a **channel-blind** (universal) coupling — the finite weak equivalence principle.

Everything is built from explicit rational matrices over `ℚ`; the dynamical
(stationarity) layer lives over `ℝ` purely so that `HasDerivAt` is available, with
the rational data cast in at the boundary.

Honest scope: this is a finite one-edge / one-frame avatar of `G = κ T`, **not** the
continuum Einstein equations.

This extends the Goal-IV field-equation line in the UNIFICATION direction
(source = matter channels). The overlap with a bare stationarity statement is flagged
for reconciliation: here the SOURCE is exhibited as the matter channels specifically.
-/

open Matrix
open scoped Classical

namespace GravitySourceMatter

/-! ## The carrier Dirac square and its four channels (explicit rational matrices) -/

/-- Aperture matter channel `Q_A`. -/
def Q_A : Matrix (Fin 2) (Fin 2) ℚ := !![2, 0; 0, 0]
/-- Closure matter channel `Q_C`. -/
def Q_C : Matrix (Fin 2) (Fin 2) ℚ := !![0, 0; 0, 2]
/-- Turn matter channel `Q_T`. -/
def Q_T : Matrix (Fin 2) (Fin 2) ℚ := !![0, 1; 1, 0]
/-- Soldering geometry channel `E_sold`. -/
def E_sold : Matrix (Fin 2) (Fin 2) ℚ := !![2, 1; 1, 2]

/-- The carrier Dirac square `D#D`. -/
def DsqD : Matrix (Fin 2) (Fin 2) ℚ := !![1, (1 : ℚ) / 2; (1 : ℚ) / 2, 1]

/-- The fixed rational frame/state vector. -/
def frame : Fin 2 → ℚ := ![1, 1]

/-- The Dirac square decomposes into the three matter channels plus the soldering
    geometry channel: `4 D#D = Q_A + Q_C + Q_T + E_sold`. -/
theorem dirac_square_decomp :
    (4 : ℚ) • DsqD = Q_A + Q_C + Q_T + E_sold := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Q_A, Q_C, Q_T, E_sold, DsqD] <;> norm_num

/-! ## The matter channel budgets -/

/-- The total matter matrix `Q_A + Q_C + Q_T`. -/
def matterMat : Matrix (Fin 2) (Fin 2) ℚ := Q_A + Q_C + Q_T

/-- Total matter-channel expectation `⟨ψ, (Q_A+Q_C+Q_T) ψ⟩`. -/
def matterBudget (psi : Fin 2 → ℚ) : ℚ := dotProduct psi (matterMat.mulVec psi)

/-- Aperture-channel budget `⟨ψ, Q_A ψ⟩`. -/
def qA (psi : Fin 2 → ℚ) : ℚ := dotProduct psi (Q_A.mulVec psi)
/-- Closure-channel budget `⟨ψ, Q_C ψ⟩`. -/
def qC (psi : Fin 2 → ℚ) : ℚ := dotProduct psi (Q_C.mulVec psi)
/-- Turn-channel budget `⟨ψ, Q_T ψ⟩`. -/
def qT (psi : Fin 2 → ℚ) : ℚ := dotProduct psi (Q_T.mulVec psi)

/-! ## Target 1 : the gravitational source IS the matter channels -/

/-- **`matter_stress_decomp`.** The source `M(ψ) = matterBudget ψ` of the soldering
    field equation equals the sum of the three matter-channel budgets:
    `M(ψ) = Q_A(ψ) + Q_C(ψ) + Q_T(ψ)`. The gravitational source *is* the matter
    channels. -/
theorem matter_stress_decomp (psi : Fin 2 → ℚ) :
    matterBudget psi = qA psi + qC psi + qT psi := by
  simp [matterBudget, qA, qC, qT, matterMat, Q_A, Q_C, Q_T,
        dotProduct, Matrix.mulVec, Fin.sum_univ_two]
  ring

/-! ## The soldering geometric response -/

/-- Soldering-norm constant `⟨E_sold·frame, E_sold·frame⟩` (rational). -/
def soldNorm : ℚ := dotProduct (E_sold.mulVec frame) (E_sold.mulVec frame)

theorem soldNorm_eq : soldNorm = 18 := by
  simp [soldNorm, dotProduct, E_sold, frame, Matrix.mulVec, Fin.sum_univ_two]
  norm_num

/-- The decorated soldering channel: the soldering matrix applied to the frame,
    scaled by the real decoration `g`. -/
def E_soldVec (g : ℝ) : Fin 2 → ℝ := fun i => g * ((E_sold.mulVec frame) i : ℝ)

/-- Soldering curvature: the `⟨E_sold γ, E_sold γ⟩`-type geometric response of the
    soldering channel to the decoration `γ`. -/
def solderingCurv (g : ℝ) : ℝ := dotProduct (E_soldVec g) (E_soldVec g)

theorem solderingCurv_eq (g : ℝ) : solderingCurv g = (soldNorm : ℝ) * g ^ 2 := by
  simp [solderingCurv, E_soldVec, soldNorm, dotProduct, E_sold, frame,
        Matrix.mulVec, Fin.sum_univ_two]
  ring

/-! ## The coupling and the soldering action -/

/-- Fixed rational coupling constant `κ` (channel-blind / universal). -/
def kappa : ℚ := 9

/-- The soldering action as a function of the real decoration `g`, coupled to the
    matter budget `b`. Its stationary points satisfy the finite field equation. -/
noncomputable def action (b : ℚ) (g : ℝ) : ℝ :=
  (soldNorm : ℝ) / 3 * g ^ 3 - (kappa : ℝ) * (b : ℝ) * g

/-- The (kernel-checked) derivative of the soldering action:
    `d/dg action = solderingCurv g - κ·b`. -/
theorem hasDerivAt_action (b : ℚ) (g : ℝ) :
    HasDerivAt (action b) ((soldNorm : ℝ) * g ^ 2 - (kappa : ℝ) * (b : ℝ)) g := by
  have h1 : HasDerivAt (fun x : ℝ => (soldNorm : ℝ) / 3 * x ^ 3)
      ((soldNorm : ℝ) / 3 * ((3 : ℕ) * g ^ (3 - 1))) g :=
    (hasDerivAt_pow 3 g).const_mul ((soldNorm : ℝ) / 3)
  have h2 : HasDerivAt (fun x : ℝ => (kappa : ℝ) * (b : ℝ) * x)
      ((kappa : ℝ) * (b : ℝ)) g := by
    simpa using (hasDerivAt_id g).const_mul ((kappa : ℝ) * (b : ℝ))
  have hsub := h1.sub h2
  convert hsub using 1
  push_cast
  ring

/-! ## Target 2 : soldering stationarity ⇔ the finite field equation -/

/-- **`field_equation_sourced`** (payload). Soldering stationarity (the action has
    vanishing derivative at `γ`) is equivalent to the finite field equation
    `solderingCurv γ = κ · matterBudget ψ`: geometry (LHS) equals matter (RHS). -/
theorem field_equation_sourced (psi : Fin 2 → ℚ) (g : ℝ) :
    HasDerivAt (action (matterBudget psi)) 0 g ↔
      solderingCurv g = (kappa : ℝ) * (matterBudget psi : ℝ) := by
  rw [solderingCurv_eq]
  constructor
  · intro h
    have hu := (hasDerivAt_action (matterBudget psi) g).unique h
    linarith
  · intro h
    have e : (soldNorm : ℝ) * g ^ 2 - (kappa : ℝ) * (matterBudget psi : ℝ) = 0 := by
      linarith
    have hd := hasDerivAt_action (matterBudget psi) g
    rwa [e] at hd

/-! ## Target 3 : channel-blindness = the finite weak equivalence principle -/

/-- **`channel_blind_universal`** (WEP). The coupling depends on the matter channels
    only through their *sum* (the total budget), not any single channel: two states
    with equal total `matterBudget` source exactly the same geometry, whatever their
    individual channel split. All matter gravitates identically. -/
theorem channel_blind_universal (psi1 psi2 : Fin 2 → ℚ) (g : ℝ)
    (h : matterBudget psi1 = matterBudget psi2) :
    (solderingCurv g = (kappa : ℝ) * (matterBudget psi1 : ℝ)) ↔
      (solderingCurv g = (kappa : ℝ) * (matterBudget psi2 : ℝ)) := by
  rw [h]

/-- The two-state, same-total, different-split WEP witness: `![1,0]` and `![0,1]`
    have the *same* total matter budget but *different* aperture-channel budgets,
    yet (by `channel_blind_universal`) source identical geometry. -/
theorem wep_witness :
    matterBudget ![1, 0] = matterBudget ![0, 1] ∧
      qA ![1, 0] ≠ qA ![0, 1] := by
  refine ⟨?_, ?_⟩
  · simp [matterBudget, matterMat, Q_A, Q_C, Q_T, dotProduct, Matrix.mulVec,
          Fin.sum_univ_two]
  · simp [qA, Q_A, dotProduct, Matrix.mulVec, Fin.sum_univ_two]

/-! ## Mandatory non-degeneracy witnesses -/

/-- Non-degeneracy: at `ψ* = ![1,0]`, `γ* = 1` all quantities are nonzero, the field
    equation holds, and **both sides equal the specific nonzero rational `18`** — the
    equation is not the vacuous `0 = 0`. -/
theorem nondegenerate_witness :
    matterBudget ![1, 0] ≠ 0 ∧
      solderingCurv 1 ≠ 0 ∧
      (kappa : ℝ) ≠ 0 ∧
      solderingCurv 1 = (kappa : ℝ) * (matterBudget ![1, 0] : ℝ) ∧
      solderingCurv 1 = 18 := by
  have hb : matterBudget ![1, 0] = 2 := by
    simp [matterBudget, matterMat, Q_A, Q_C, Q_T, dotProduct, Matrix.mulVec,
          Fin.sum_univ_two]
  have hc : solderingCurv 1 = 18 := by rw [solderingCurv_eq, soldNorm_eq]; norm_num
  refine ⟨by rw [hb]; norm_num, by rw [hc]; norm_num, by simp [kappa], ?_, hc⟩
  rw [hc, hb]; norm_num [kappa]

/-- Control: at `γ = 0` the geometry is *not* sourced — the field equation FAILS
    (`solderingCurv 0 = 0 ≠ 18 = κ·matterBudget ψ*`). This certifies the payload is a
    genuine constraint, not a tautology. -/
theorem control_failure :
    solderingCurv 0 ≠ (kappa : ℝ) * (matterBudget ![1, 0] : ℝ) := by
  have hb : matterBudget ![1, 0] = 2 := by
    simp [matterBudget, matterMat, Q_A, Q_C, Q_T, dotProduct, Matrix.mulVec,
          Fin.sum_univ_two]
  rw [solderingCurv_eq, soldNorm_eq, hb]
  norm_num [kappa]

/-! ## Target 4 : the unification verdict -/

/-- **`unification_verdict`.** One finite equation couples the soldering (gravity)
    channel to the matter channels of the same Dirac square, channel-blind:

    * the source `matterBudget` is exactly the sum of the matter-channel budgets
      (`matter_stress_decomp`);
    * soldering stationarity is equivalent to the finite field equation
      `solderingCurv γ = κ · matterBudget ψ` (`field_equation_sourced`);
    * the coupling sees only the *total* budget — the finite weak equivalence
      principle (`channel_blind_universal`);
    * with an explicit nonzero witness (both sides `= 18`) and a control where the
      equation fails.

    Gravity is sourced by (and only by the total of) the matter mass-budget.
    Honest scope: a finite one-edge / one-frame avatar of `G = κ T`. -/
theorem unification_verdict :
    (∀ psi : Fin 2 → ℚ, matterBudget psi = qA psi + qC psi + qT psi) ∧
      (∀ (psi : Fin 2 → ℚ) (g : ℝ),
        HasDerivAt (action (matterBudget psi)) 0 g ↔
          solderingCurv g = (kappa : ℝ) * (matterBudget psi : ℝ)) ∧
      (∀ (psi1 psi2 : Fin 2 → ℚ) (g : ℝ), matterBudget psi1 = matterBudget psi2 →
        ((solderingCurv g = (kappa : ℝ) * (matterBudget psi1 : ℝ)) ↔
          (solderingCurv g = (kappa : ℝ) * (matterBudget psi2 : ℝ)))) ∧
      (matterBudget ![1, 0] ≠ 0 ∧ solderingCurv 1 ≠ 0 ∧ (kappa : ℝ) ≠ 0 ∧
        solderingCurv 1 = (kappa : ℝ) * (matterBudget ![1, 0] : ℝ) ∧
        solderingCurv 1 = 18) ∧
      (solderingCurv 0 ≠ (kappa : ℝ) * (matterBudget ![1, 0] : ℝ)) := by
  exact ⟨matter_stress_decomp, field_equation_sourced, channel_blind_universal,
    nondegenerate_witness, control_failure⟩

/-! ## Axiom audit — footprint exactly `[propext, Classical.choice, Quot.sound]` -/

/-- info: 'GravitySourceMatter.matter_stress_decomp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms matter_stress_decomp

/-- info: 'GravitySourceMatter.field_equation_sourced' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms field_equation_sourced

/-- info: 'GravitySourceMatter.channel_blind_universal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms channel_blind_universal

/-- info: 'GravitySourceMatter.unification_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms unification_verdict

end GravitySourceMatter
