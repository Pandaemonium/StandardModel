import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.FiniteAbelianOSGap

/-!
# Gate YM: a concrete SU(2)-flavored few-level OS transfer gap

This module **instantiates** the abstract finite `k`-level Osterwalder-Schrader
transfer gap developed in `FiniteAbelianOSGap.lean` (the group-agnostic
`OSTransfer` spectral picture and its `H = -log T` gap identity) on a concrete,
explicit **SU(2)-motivated three-level transfer block**.

## The physical model (strong-coupling character expansion)

In the strong-coupling / character expansion of SU(2) lattice gauge theory the
one-plaquette transfer operator is diagonal in the irreducible representation
("spin") basis `j = 0, 1/2, 1, …`.  The leading strong-coupling amplitude of the
spin-`j` sector is controlled by a single small parameter, the **tanh-like ratio**
`t = tanh β ∈ (0,1)` (this is exactly the `Z2` ratio that appears in the
two-state slab `z2Data`; SU(2) at leading strong coupling produces the same
tanh ratio per link, cf. the exactly solvable slab).  We model the transfer
block by the diagonal operator whose spin-`j` eigenvalue is `t^{2j}`:

* `j = 0`   (trivial rep, **vacuum**): eigenvalue `t^0 = 1`  — the top of the spectrum;
* `j = 1/2` (fundamental rep, **first excited**): eigenvalue `t^1 = t`;
* `j = 1`   (adjoint rep, next level): eigenvalue `t^2`.

Concretely we take the explicit Hermitian positive-definite transfer matrix
`su2Transfer β = diagonal (1, t, t²)` on `Fin 3` (`su2Transfer_isHermitian`,
`su2Transfer_posDef`), whose spectrum feeds the abstract `OSTransfer 3` data
`su2Data β`.

## What is proved

Applying the abstract OS gap (`OSTransfer.ground_state_with_gap`) to `su2Data β`
gives, for the reconstructed Hamiltonian `H = -log T`:

* **Positive Hamiltonian gap** (`su2_hamiltonianGap_pos`): `E1 - E0 > 0`.
* **Unique ground state = vacuum** (`su2_unique_ground`): the ground energy is
  attained exactly on the `lam = lam0` (trivial-rep) eigenspace.
* **Gap value** (`su2_gap_eq_neg_log_ratio`, `su2_hamiltonianGap_eq`): the gap
  equals `-log (lam1 / lam0) = -log (tanh β)`, the SU(2) strong-coupling string
  tension.

## What is NOT claimed (honesty guard)

This is an honest **finite few-level model motivated by SU(2) strong coupling**.
It is **NOT** the full SU(2) transfer operator (which is infinite-dimensional,
indexed by all spins `j`, with Bessel-function amplitudes), **NOT** the
infinite-volume / continuum Hamiltonian, and **NOT** a physical continuum mass
gap.  It is a concrete 3-level instance of the abstract OS spectral gap — a step
toward the nonabelian gate at the transfer-block level.

Draft-trust: kernel-checked, no `sorry`, no `axiom`, no `native_decide`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace SU2TwoLevelGap

open scoped BigOperators Matrix ComplexOrder
open PhysicsSM.Draft.NullEdge.GateYM.FiniteAbelianOSGap

/-! ## The tanh-like strong-coupling ratio -/

/-- The SU(2) strong-coupling **tanh-like ratio** `t = tanh β`, strictly between
`0` and `1` for `β > 0`. -/
theorem tanh_pos {beta : ℝ} (hbeta : 0 < beta) : 0 < Real.tanh beta := by
  rw [Real.tanh_eq_sinh_div_cosh]; positivity

theorem tanh_lt_one (beta : ℝ) : Real.tanh beta < 1 := Real.tanh_lt_one beta

/-! ## The explicit SU(2)-flavored Hermitian PSD transfer matrix

`su2Transfer β = diagonal (t^0, t^1, t^2) = diagonal (1, t, t²)` on `Fin 3`,
with `t = tanh β`.  This is the strong-coupling one-plaquette transfer block in
the spin basis `j = 0, 1/2, 1`. -/

/-- The explicit `3 × 3` SU(2) strong-coupling transfer matrix
`diagonal (1, t, t²)` with `t = tanh β`, as a complex matrix. -/
def su2Transfer (beta : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  Matrix.diagonal (fun i => (((Real.tanh beta) ^ (i : ℕ) : ℝ) : ℂ))

/-- The SU(2) transfer block is Hermitian (it is real diagonal). -/
theorem su2Transfer_isHermitian (beta : ℝ) : (su2Transfer beta).IsHermitian := by
  rw [su2Transfer, Matrix.isHermitian_diagonal_iff]
  intro i
  show star _ = _
  exact Complex.conj_ofReal _

/-- The SU(2) transfer block is positive definite: all its diagonal
eigenvalues `t^j` are strictly positive for `β > 0`. -/
theorem su2Transfer_posDef {beta : ℝ} (hbeta : 0 < beta) :
    (su2Transfer beta).PosDef := by
  have ht : 0 < Real.tanh beta := tanh_pos hbeta
  rw [su2Transfer, Matrix.posDef_diagonal_iff]
  intro i
  rw [Complex.lt_def, Complex.ofReal_re, Complex.ofReal_im]
  exact ⟨by positivity, rfl⟩

/-! ## The abstract OS transfer data for the SU(2) block -/

/-- The SU(2) strong-coupling OS transfer spectral data on `Fin 3`: eigenvalues
`lam j = t^j` (`t = tanh β`) for spins `j = 0, 1/2, 1`, with the trivial rep
(`i0 = 0`, eigenvalue `1`) as the vacuum and the fundamental rep (`i1 = 1`,
eigenvalue `t`) as the first excited state.  These `lam` are exactly the
eigenvalues of the explicit matrix `su2Transfer β`. -/
def su2Data (beta : ℝ) (hbeta : 0 < beta) : OSTransfer 3 where
  lam := fun i => (Real.tanh beta) ^ (i : ℕ)
  i0 := 0
  i1 := 1
  hne := by decide
  pos := by
    have ht : 0 < Real.tanh beta := tanh_pos hbeta
    intro i; positivity
  top := by
    have ht : 0 < Real.tanh beta := tanh_pos hbeta
    have ht1 : Real.tanh beta < 1 := tanh_lt_one beta
    intro i
    simp only [Fin.val_zero, pow_zero]
    exact pow_le_one₀ ht.le ht1.le
  second := by
    have ht : 0 < Real.tanh beta := tanh_pos hbeta
    have ht1 : Real.tanh beta < 1 := tanh_lt_one beta
    intro i hi
    fin_cases i
    · simp at hi
    · simp
    · simp only [Fin.isValue]; norm_num; nlinarith [ht, ht1]
  gap := by
    have ht1 : Real.tanh beta < 1 := tanh_lt_one beta
    simp only [Fin.isValue, Fin.val_zero, Fin.val_one, pow_zero, pow_one]
    exact ht1

/-! ## The gap eigenvalues, spelled out -/

@[simp] theorem su2Data_lam0 (beta : ℝ) (hbeta : 0 < beta) :
    (su2Data beta hbeta).lam0 = 1 := by
  simp [OSTransfer.lam0, su2Data]

@[simp] theorem su2Data_lam1 (beta : ℝ) (hbeta : 0 < beta) :
    (su2Data beta hbeta).lam1 = Real.tanh beta := by
  simp [OSTransfer.lam1, su2Data]

/-! ## The instantiated OS gap results -/

/-- **Positive Hamiltonian gap** for the SU(2) block: the reconstructed
Hamiltonian `H = -log T` has a strictly positive gap above the vacuum. -/
theorem su2_hamiltonianGap_pos (beta : ℝ) (hbeta : 0 < beta) :
    0 < (su2Data beta hbeta).hamiltonianGap :=
  (su2Data beta hbeta).hamiltonianGap_pos

/-- **The vacuum is the ground state** for the SU(2) block: `E0` is a lower
bound for the whole Hamiltonian spectrum. -/
theorem su2_ground_energy_le (beta : ℝ) (hbeta : 0 < beta) (i : Fin 3) :
    (su2Data beta hbeta).E0 ≤ (su2Data beta hbeta).E i :=
  (su2Data beta hbeta).E0_le i

/-- **Unique ground state = vacuum** for the SU(2) block: the ground energy is
attained exactly on the trivial-rep (`lam = lam0`) eigenspace. -/
theorem su2_unique_ground (beta : ℝ) (hbeta : 0 < beta) {i : Fin 3}
    (hi : (su2Data beta hbeta).E i = (su2Data beta hbeta).E0) :
    (su2Data beta hbeta).lam i = (su2Data beta hbeta).lam0 :=
  (su2Data beta hbeta).unique_ground hi

/-- **The fundamental rep is the first excited state** for the SU(2) block:
`E1` is a lower bound for every excited energy. -/
theorem su2_first_excited_le (beta : ℝ) (hbeta : 0 < beta) {i : Fin 3}
    (hi : i ≠ (su2Data beta hbeta).i0) :
    (su2Data beta hbeta).E1 ≤ (su2Data beta hbeta).E i :=
  (su2Data beta hbeta).E1_le_of_ne hi

/-- **Gap = `-log (lam1 / lam0)`** for the SU(2) block. -/
theorem su2_gap_eq_neg_log_ratio (beta : ℝ) (hbeta : 0 < beta) :
    (su2Data beta hbeta).E1 - (su2Data beta hbeta).E0
      = -Real.log ((su2Data beta hbeta).lam1 / (su2Data beta hbeta).lam0) :=
  (su2Data beta hbeta).gap_eq

/-- **The SU(2) strong-coupling string tension.**  The Hamiltonian gap of the
SU(2) block equals `-log (tanh β)`, the leading strong-coupling string tension
(the fundamental-rep energy above the trivial-rep vacuum). -/
theorem su2_hamiltonianGap_eq (beta : ℝ) (hbeta : 0 < beta) :
    (su2Data beta hbeta).hamiltonianGap = -Real.log (Real.tanh beta) := by
  simp only [OSTransfer.hamiltonianGap, su2Data_lam0, su2Data_lam1, div_one]

/-- **Bundled SU(2) two/three-level OS gap statement.**  On the explicit SU(2)
strong-coupling transfer block, the trivial rep is the unique Hamiltonian ground
state (vacuum), the fundamental rep is the first excited state, and the gap is
`-log (tanh β) > 0`, the SU(2) strong-coupling string tension. -/
theorem su2_ground_state_with_gap (beta : ℝ) (hbeta : 0 < beta) :
    (∀ i, (su2Data beta hbeta).E0 ≤ (su2Data beta hbeta).E i) ∧
      (∀ i, (su2Data beta hbeta).E i = (su2Data beta hbeta).E0 →
        (su2Data beta hbeta).lam i = (su2Data beta hbeta).lam0) ∧
      (∀ i, i ≠ (su2Data beta hbeta).i0 →
        (su2Data beta hbeta).E1 ≤ (su2Data beta hbeta).E i) ∧
      (su2Data beta hbeta).E1 - (su2Data beta hbeta).E0
        = (su2Data beta hbeta).hamiltonianGap ∧
      (su2Data beta hbeta).hamiltonianGap = -Real.log (Real.tanh beta) ∧
      0 < (su2Data beta hbeta).hamiltonianGap := by
  obtain ⟨h1, h2, h3, h4, h5⟩ := (su2Data beta hbeta).ground_state_with_gap
  exact ⟨h1, h2, h3, h4, su2_hamiltonianGap_eq beta hbeta, h5⟩

end SU2TwoLevelGap
end GateYM
end NullEdge
end Draft
end PhysicsSM
