import Mathlib

/-!
# Gate YM / NE-U4: the multi-level OS transfer Hamiltonian `H = -log T`

This module **generalises** the exactly solvable two-state `Z2` transfer
Hamiltonian gap recorded in `OSHamiltonianGap.lean` (the two-level `Z2` center
sector, `H = -log T` on a `2 × 2` transfer matrix) to a **general finite
`k`-level** Osterwalder-Schrader transfer operator.

The input is a finite Hermitian **positive-definite** transfer matrix `T` on
`Fin k` (equivalently: a positive spectrum, as a genuine `T = e^{-H}` has), with

* a strictly positive **top** transfer eigenvalue `lam0` (the vacuum), and
* a **spectral gap** to the second eigenvalue `lam1`, `0 < lam1 < lam0`.

Osterwalder-Schrader reconstruction turns the multiplicative transfer operator
into an additive self-adjoint Hamiltonian by `H = -log T`, i.e. the eigenvalue
transform `lam ↦ -log lam`.  We package the whole finite spectral input in a
group-agnostic structure `OSTransfer k` and prove, at the level of the
Hamiltonian **spectrum** `{E i = -log (lam i)}`:

* `OSTransfer.E0_le` — the top transfer eigenvalue maps to the **lowest**
  Hamiltonian energy: `E0 = -log lam0` is the ground energy (a lower bound for
  the whole spectrum), because `lam ↦ -log lam` is strictly decreasing;
* `OSTransfer.unique_ground` — the ground energy is attained exactly on the
  `lam = lam0` eigenspace;
* `OSTransfer.E1_le_of_ne` — the second eigenvalue maps to the **first excited**
  energy `E1 = -log lam1` (a lower bound for every excited energy);
* `OSTransfer.gap_eq` / `OSTransfer.hamiltonianGap_pos` — the Hamiltonian gap is
  `E1 - E0 = -log (lam1 / lam0) > 0`.

A `Matrix.PosDef` wrapper (`OSTransfer.ofPosDef`) builds the structure directly
from a Hermitian positive-definite matrix using Mathlib's finite-dimensional
Hermitian spectral theorem (`Matrix.IsHermitian.eigenvalues`,
`Matrix.PosDef.eigenvalues_pos`).  A concrete two-level `Z2` instantiation
(`z2Data`) recovers the two-state slab gap `-log (tanh β)`, exhibiting the
attached `OSHamiltonianGap` result as a special case.

## What is NOT claimed (F-YM-CONFLATE guard)

This is an honest **abstract finite-level OS spectral gap**: a purely spectral
statement about the eigenvalue transform `lam ↦ -log lam` on a finite
positive-definite transfer matrix.  It is **NOT** the full nonabelian Yang-Mills
mass gap: there is no continuum limit, no infinite-volume Hamiltonian, no
physical mass gap, and nothing group-specific — the `Z2` slab is merely one
instance.  The content is the finite spectral gap identity, group-agnostic.

Draft-trust: kernel-checked, no `sorry`, no `axiom`, no `native_decide`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace FiniteAbelianOSGap

open scoped BigOperators Matrix ComplexOrder

/-! ## The group-agnostic finite-level OS transfer spectral data -/

/-- **Finite `k`-level OS transfer spectral data.**  This bundles the spectrum
of a finite Hermitian positive-definite transfer operator `T` on `Fin k`
together with the two data of the OS gap picture: a distinguished top (vacuum)
eigenvalue index `i0` and a distinguished second (first-excited) index `i1`.

The hypotheses are:
* `pos`   — all transfer eigenvalues are strictly positive (`T` positive definite);
* `top`   — `lam i0` is the top of the transfer spectrum;
* `second`— `lam i1` is the largest eigenvalue *other than* the top (the second);
* `gap`   — a strict spectral gap `lam i1 < lam i0` separates them. -/
structure OSTransfer (k : ℕ) where
  /-- The transfer eigenvalues (spectrum of the transfer matrix `T`). -/
  lam : Fin k → ℝ
  /-- Index of the top (vacuum) transfer eigenvalue. -/
  i0 : Fin k
  /-- Index of the second (first-excited) transfer eigenvalue. -/
  i1 : Fin k
  /-- The vacuum and first-excited indices are distinct. -/
  hne : i0 ≠ i1
  /-- All transfer eigenvalues are strictly positive. -/
  pos : ∀ i, 0 < lam i
  /-- `lam i0` is the top of the transfer spectrum. -/
  top : ∀ i, lam i ≤ lam i0
  /-- `lam i1` dominates every eigenvalue other than the top: it is the second. -/
  second : ∀ i, i ≠ i0 → lam i ≤ lam i1
  /-- A strict spectral gap separates the top from the second. -/
  gap : lam i1 < lam i0

namespace OSTransfer

variable {k : ℕ} (D : OSTransfer k)

/-- The **top (vacuum) transfer eigenvalue** `lam0`. -/
def lam0 : ℝ := D.lam D.i0

/-- The **second (first-excited) transfer eigenvalue** `lam1`. -/
def lam1 : ℝ := D.lam D.i1

/-- The **Hamiltonian spectrum** `E i = -log (lam i)` obtained from `H = -log T`
by the OS eigenvalue transform. -/
def E (i : Fin k) : ℝ := -Real.log (D.lam i)

/-- The **vacuum (ground) energy** `E0 = -log lam0`. -/
def E0 : ℝ := D.E D.i0

/-- The **first-excited energy** `E1 = -log lam1`. -/
def E1 : ℝ := D.E D.i1

/-- The **Hamiltonian gap** `-log (lam1 / lam0)`. -/
def hamiltonianGap : ℝ := -Real.log (D.lam1 / D.lam0)

theorem lam0_pos : 0 < D.lam0 := D.pos D.i0

theorem lam1_pos : 0 < D.lam1 := D.pos D.i1

theorem lam1_lt_lam0 : D.lam1 < D.lam0 := D.gap

theorem E0_eq : D.E0 = -Real.log D.lam0 := rfl

theorem E1_eq : D.E1 = -Real.log D.lam1 := rfl

/-- **The vacuum is the ground state.**  Because `lam ↦ -log lam` is strictly
decreasing on the positives, the top transfer eigenvalue `lam0` maps to the
lowest Hamiltonian energy: `E0` is a lower bound for the whole spectrum. -/
theorem E0_le (i : Fin k) : D.E0 ≤ D.E i := by
  have h : Real.log (D.lam i) ≤ Real.log (D.lam D.i0) :=
    Real.log_le_log (D.pos i) (D.top i)
  simp only [E0, E]
  linarith

/-- **The first-excited energy is the smallest excited energy.**  Every
eigenvalue other than the top is `≤ lam1`, so its energy is `≥ E1`: `E1` is a
lower bound for all energies above the ground state. -/
theorem E1_le_of_ne {i : Fin k} (hi : i ≠ D.i0) : D.E1 ≤ D.E i := by
  have h : Real.log (D.lam i) ≤ Real.log (D.lam D.i1) :=
    Real.log_le_log (D.pos i) (D.second i hi)
  simp only [E1, E]
  linarith

/-- **The vacuum is (spectrally) the unique ground state.**  The ground energy
`E0` is attained precisely on the `lam = lam0` eigenspace: if some level has
energy equal to `E0`, its transfer eigenvalue equals `lam0`. -/
theorem unique_ground {i : Fin k} (hi : D.E i = D.E0) : D.lam i = D.lam0 := by
  have h : Real.log (D.lam i) = Real.log (D.lam D.i0) := by
    simp only [E, E0, E] at hi; linarith
  have := Real.log_injOn_pos (Set.mem_Ioi.mpr (D.pos i))
    (Set.mem_Ioi.mpr (D.pos D.i0)) h
  simpa [lam0] using this

/-- **The vacuum sits strictly below the first excited state.**  `E0 < E1`. -/
theorem E0_lt_E1 : D.E0 < D.E1 := by
  have h : Real.log D.lam1 < Real.log D.lam0 :=
    Real.log_lt_log D.lam1_pos D.lam1_lt_lam0
  simp only [E0_eq, E1_eq]
  linarith

/-- **The Hamiltonian gap is the energy difference.**  `E1 - E0 = -log (lam1 /
lam0)`. -/
theorem gap_eq : D.E1 - D.E0 = D.hamiltonianGap := by
  simp only [E0_eq, E1_eq, hamiltonianGap]
  rw [Real.log_div (ne_of_gt D.lam1_pos) (ne_of_gt D.lam0_pos)]
  ring

/-- **The Hamiltonian gap is strictly positive.**  `E1 - E0 > 0`: there is a
genuine energy gap above the vacuum. -/
theorem hamiltonianGap_pos : 0 < D.hamiltonianGap := by
  rw [← gap_eq]
  have := D.E0_lt_E1
  linarith

/-- Restatement of the gap as `-log (lam1 / lam0)`. -/
theorem hamiltonianGap_eq_neg_log_ratio :
    D.hamiltonianGap = -Real.log (D.lam1 / D.lam0) := rfl

/-- **Bundled multi-level OS ground-state / gap statement.**  On a finite
`k`-level positive-definite transfer operator, the top transfer eigenvalue is
the unique Hamiltonian ground state, the second eigenvalue is the first excited
state, and the gap is `-log (lam1 / lam0) > 0`. -/
theorem ground_state_with_gap :
    (∀ i, D.E0 ≤ D.E i) ∧
      (∀ i, D.E i = D.E0 → D.lam i = D.lam0) ∧
      (∀ i, i ≠ D.i0 → D.E1 ≤ D.E i) ∧
      D.E1 - D.E0 = D.hamiltonianGap ∧
      0 < D.hamiltonianGap :=
  ⟨D.E0_le, fun _ => D.unique_ground, fun _ => D.E1_le_of_ne,
    D.gap_eq, D.hamiltonianGap_pos⟩

end OSTransfer

/-! ## Building the spectral data from a Hermitian positive-definite matrix

Using Mathlib's finite-dimensional Hermitian spectral theorem, the eigenvalues
of a Hermitian positive-definite matrix `T` are real and strictly positive, so a
choice of top/second indices with the gap hypotheses yields `OSTransfer k`. -/

/-- Build `OSTransfer k` from a Hermitian **positive-definite** matrix `T` on
`Fin k` together with a choice of top index `i0`, second index `i1`, and the
top/second/gap hypotheses on the (real, positive) Hermitian eigenvalues
`hT.isHermitian.eigenvalues`. -/
def OSTransfer.ofPosDef {k : ℕ} {T : Matrix (Fin k) (Fin k) ℂ} (hT : T.PosDef)
    (i0 i1 : Fin k) (hne : i0 ≠ i1)
    (htop : ∀ i, hT.isHermitian.eigenvalues i ≤ hT.isHermitian.eigenvalues i0)
    (hsecond : ∀ i, i ≠ i0 →
      hT.isHermitian.eigenvalues i ≤ hT.isHermitian.eigenvalues i1)
    (hgap : hT.isHermitian.eigenvalues i1 < hT.isHermitian.eigenvalues i0) :
    OSTransfer k where
  lam := hT.isHermitian.eigenvalues
  i0 := i0
  i1 := i1
  hne := hne
  pos := hT.eigenvalues_pos
  top := htop
  second := hsecond
  gap := hgap

/-! ## The two-level `Z2` slab as an instance

We recover the exactly solvable two-state `Z2` OS gap (`OSHamiltonianGap.lean`)
as the special case `k = 2` with the vacuum eigenvalue `2 (e^β + e^{-β})` and the
flux eigenvalue `2 (e^β - e^{-β})`.  The resulting Hamiltonian gap is
`-log (tanh β)`, matching `osSpectralGap`. -/

/-- The two-level `Z2` OS transfer data: vacuum eigenvalue `2 (e^β + e^{-β})`
(index `0`) and flux eigenvalue `2 (e^β - e^{-β})` (index `1`). -/
def z2Data (beta : ℝ) (hbeta : 0 < beta) : OSTransfer 2 where
  lam := fun i => 2 * (Real.exp beta +
    (if i = 0 then Real.exp (-beta) else -Real.exp (-beta)))
  i0 := 0
  i1 := 1
  hne := by decide
  pos := by
    intro i
    fin_cases i
    · have := add_pos (Real.exp_pos beta) (Real.exp_pos (-beta))
      simp; linarith
    · have h : Real.exp (-beta) < Real.exp beta :=
        Real.exp_lt_exp.mpr (by linarith)
      simp; linarith
  top := by
    intro i
    fin_cases i
    · simp
    · have h : 0 < Real.exp (-beta) := Real.exp_pos _
      simp; linarith
  second := by
    intro i hi
    fin_cases i
    · simp at hi
    · simp
  gap := by
    have h : 0 < Real.exp (-beta) := Real.exp_pos _
    simp; linarith

/-- The `Z2` two-level instance realises the two-state slab Hamiltonian gap
`-log (tanh β)`, matching `OSHamiltonianGap.osSpectralGap`. -/
theorem z2Data_hamiltonianGap (beta : ℝ) (hbeta : 0 < beta) :
    (z2Data beta hbeta).hamiltonianGap = -Real.log (Real.tanh beta) := by
  simp only [OSTransfer.hamiltonianGap, OSTransfer.lam0, OSTransfer.lam1, z2Data]
  congr 1
  rw [Real.tanh_eq]
  rw [if_neg (show ¬((1 : Fin 2) = 0) by decide)]
  simp only [if_true]
  have hsum : Real.exp beta + Real.exp (-beta) ≠ 0 :=
    ne_of_gt (add_pos (Real.exp_pos beta) (Real.exp_pos (-beta)))
  have hden : (2 : ℝ) * (Real.exp beta + Real.exp (-beta)) ≠ 0 := by positivity
  congr 1
  field_simp
  ring

end FiniteAbelianOSGap
end GateYM
end NullEdge
end Draft
end PhysicsSM
