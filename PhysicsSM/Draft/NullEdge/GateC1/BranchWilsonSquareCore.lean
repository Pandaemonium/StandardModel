import Mathlib

/-!
# Gate C1 branch-Wilson square and gap-transfer core (abstract)

This module provides the **machine-checked algebraic core** behind the
matrix-valued branch-Wilson program (Gate C1 job C274).  Everything here is
abstract finite-dimensional linear algebra over `ℂ`: no upstream null-edge
symbol, no `TetraEuclideanSlashData`, no overlap/locality theory.  The concrete
branch-Wilson wrappers in `TetraBranchWilsonSymbol` are thin specializations of
these lemmas with `Q := TetraEuclideanSlashData.Q D (sinCoeffs k)` and
`W := BW.W k`.

The model object is the inverse-propagator symbol

`Kab a Q W = a⁻¹ • (i • Q + W)`,

with `Q` (the kinetic slash symbol) and `W` (the branch-Wilson correction) both
**Hermitian** (`star Q = Q`, `star W = W`) and `a : ℝ`.

## Decisive vs. bookkeeping

* `Kab_sq_exact` is the **exact square identity** (bookkeeping spine):
  `star K * K = a⁻² • (Q² + W² + i • [W, Q])`.
  Note `i • [W, Q]` is Hermitian (`[W, Q]` is anti-Hermitian for Hermitian
  `W, Q`), so the right-hand side is Hermitian, as it must be.

* `Kab_badSector_gap` is the **decisive gap-transfer** for the branch
  architecture.  It needs **no** commutation hypothesis: it transfers a
  positivity gap of the Hermitian combination `W² + i • [W, Q]` on a sector
  `E = 1 - P` into an inverse-propagator gap of `K` on that sector, with the
  kinetic part `Q²` only ever *helping*.  Because it does not require
  `[W, Q] = 0`, the branch term `W` is free to break the chirality-balancing
  symmetry that forces a zero index (the `zero_index_commuting_trap` of
  `SpectralIslandIndexPredicates`).  This is the clause-3
  (`inverseBadSectorGap`) input.

* `Kab_global_gap_of_commute` is the **C0-style** species-health gap: under
  commutation a `W`-sector gap becomes a global lower bound on `star K * K`.
  This is bookkeeping for C0, *not* a chiral release: a `W` that commutes with
  everything is exactly the regime that the zero-index trap kills for C1.

* `scalar_commutes` is the **compatibility check**: a scalar `W = c • 1` always
  commutes, so scalar Wilson can only ever land in the commuting (C0) regime —
  it can never supply the chirality-breaking commutator needed for C1.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace BranchWilsonSquareCore

open Matrix
open scoped ComplexOrder

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Abstract branch/free inverse-propagator symbol `a⁻¹ • (i • Q + W)`. -/
def Kab (a : ℝ) (Q W : Matrix n n ℂ) : Matrix n n ℂ :=
  (a : ℂ)⁻¹ • (Complex.I • Q + W)

omit [Fintype n] [DecidableEq n] in
/-- Conjugate transpose of the symbol for Hermitian `Q`, `W`:
`star K = a⁻¹ • (W - i • Q)`. -/
theorem star_Kab (a : ℝ) (Q W : Matrix n n ℂ) (hQ : star Q = Q) (hW : star W = W) :
    star (Kab a Q W) = (a : ℂ)⁻¹ • (W - Complex.I • Q) := by
  unfold Kab
  rw [star_smul, star_add, star_smul, hQ, hW]
  have : star ((a : ℝ) : ℂ)⁻¹ = ((a : ℝ) : ℂ)⁻¹ := by rw [star_inv₀]; simp
  rw [this]; simp [Complex.conj_I]; module

omit [DecidableEq n] in
/-- **Exact square identity (bookkeeping spine).**
`star K * K = a⁻² • (Q² + W² + i • (W·Q − Q·W))`.
The commutator term `i • [W, Q]` is Hermitian, so the whole right-hand side is
Hermitian. -/
theorem Kab_sq_exact (a : ℝ) (Q W : Matrix n n ℂ) (hQ : star Q = Q) (hW : star W = W) :
    star (Kab a Q W) * Kab a Q W =
      (((a ^ 2)⁻¹ : ℝ) : ℂ) • (Q * Q + W * W + Complex.I • (W * Q - Q * W)) := by
  rw [star_Kab a Q W hQ hW]; unfold Kab
  rw [Matrix.smul_mul, Matrix.mul_smul, smul_smul]
  have hcoef : ((a : ℝ) : ℂ)⁻¹ * ((a : ℝ) : ℂ)⁻¹ = (((a ^ 2)⁻¹ : ℝ) : ℂ) := by
    push_cast; ring
  rw [hcoef]; congr 1
  rw [Matrix.mul_add, Matrix.sub_mul, Matrix.sub_mul]
  simp only [Matrix.smul_mul, Matrix.mul_smul, smul_smul]
  rw [Complex.I_mul_I]; module

omit [DecidableEq n] in
/-- **Commuting specialization.** When `W` and `Q` commute the commutator drops:
`star K * K = a⁻² • (Q² + W²)`. -/
theorem Kab_sq_commuting (a : ℝ) (Q W : Matrix n n ℂ)
    (hQ : star Q = Q) (hW : star W = W) (hcomm : W * Q = Q * W) :
    star (Kab a Q W) * Kab a Q W = (((a ^ 2)⁻¹ : ℝ) : ℂ) • (Q * Q + W * W) := by
  rw [Kab_sq_exact a Q W hQ hW, hcomm]; simp

/-- **Compatibility check.** A scalar branch term `W = c • 1` always commutes
with `Q`; hence scalar Wilson can never provide the chirality-breaking
commutator and is confined to the commuting (C0) regime. -/
theorem scalar_commutes (Q : Matrix n n ℂ) (c0 : ℂ) :
    (c0 • (1 : Matrix n n ℂ)) * Q = Q * (c0 • (1 : Matrix n n ℂ)) := by
  rw [Matrix.smul_mul, Matrix.mul_smul, Matrix.one_mul, Matrix.mul_one]

omit [DecidableEq n] in
/-- For Hermitian `Q`, the kinetic square `Q²` is positive semidefinite. -/
theorem Qsq_posSemidef (Q : Matrix n n ℂ) (hQ : star Q = Q) : (Q * Q).PosSemidef := by
  have hh : Qᴴ = Q := by rw [← Matrix.star_eq_conjTranspose]; exact hQ
  have h := Matrix.posSemidef_conjTranspose_mul_self Q
  rw [hh] at h; exact h

omit [DecidableEq n] in
/-- **General lower bound (no commutation).**
`star K * K ⪰ a⁻² • (W² + i • [W, Q])`, because the dropped remainder is
`a⁻² • Q² ⪰ 0`.  This isolates the branch-Wilson-plus-commutator combination as
the genuine inverse-propagator lower bound; the kinetic part only helps. -/
theorem Kab_sq_ge_branch (a : ℝ) (Q W : Matrix n n ℂ) (hQ : star Q = Q) (hW : star W = W) :
    (star (Kab a Q W) * Kab a Q W -
      (((a ^ 2)⁻¹ : ℝ) : ℂ) • (W * W + Complex.I • (W * Q - Q * W))).PosSemidef := by
  have hdiff : star (Kab a Q W) * Kab a Q W -
      (((a ^ 2)⁻¹ : ℝ) : ℂ) • (W * W + Complex.I • (W * Q - Q * W))
      = (((a ^ 2)⁻¹ : ℝ) : ℂ) • (Q * Q) := by
    rw [Kab_sq_exact a Q W hQ hW]; module
  rw [hdiff]
  exact (Qsq_posSemidef Q hQ).smul (by exact_mod_cast (by positivity : (0 : ℝ) ≤ (a ^ 2)⁻¹))

omit [DecidableEq n] in
/-- **Decisive sector gap-transfer (no commutation).**
Let `E` be a Hermitian sector compressor (intended `E = 1 - P`, the mirror /
bad sector).  If the Hermitian combination `W² + i • [W, Q]` has a gap
`γ` on that sector, i.e.
`E (W² + i • [W, Q]) E ⪰ γ • E`,
then the inverse propagator `star K * K` has the scaled gap on the same sector:
`E (star K * K) E ⪰ (a⁻² γ) • E`.
This is exactly the clause-3 `inverseBadSectorGap` input, and crucially needs
**no** `[W, Q] = 0` hypothesis, so `W` may break chirality balance. -/
theorem Kab_badSector_gap (a : ℝ) (Q W E : Matrix n n ℂ) (γ : ℝ)
    (hQ : star Q = Q) (hW : star W = W) (hE : star E = E)
    (hWgap : (E * (W * W + Complex.I • (W * Q - Q * W)) * E - (γ : ℂ) • E).PosSemidef) :
    (E * (star (Kab a Q W) * Kab a Q W) * E - (((a ^ 2)⁻¹ * γ : ℝ) : ℂ) • E).PosSemidef := by
  set c : ℂ := (((a ^ 2)⁻¹ : ℝ) : ℂ) with hc_def
  set Wc : Matrix n n ℂ := W * W + Complex.I • (W * Q - Q * W) with hWc
  have hc : (0 : ℂ) ≤ c := by
    rw [hc_def]; exact_mod_cast (by positivity : (0 : ℝ) ≤ (a ^ 2)⁻¹)
  have hEQ : (E * (Q * Q) * E).PosSemidef := by
    have hh : Eᴴ = E := by rw [← Matrix.star_eq_conjTranspose]; exact hE
    have h := (Qsq_posSemidef Q hQ).conjTranspose_mul_mul_same E
    rwa [hh] at h
  have e1 : star (Kab a Q W) * Kab a Q W = c • (Q * Q) + c • Wc := by
    rw [Kab_sq_exact a Q W hQ hW, hWc, ← smul_add]; congr 1; abel
  have hcompress : E * (star (Kab a Q W) * Kab a Q W) * E
      = c • (E * (Q * Q) * E) + c • (E * Wc * E) := by
    rw [e1]; simp only [Matrix.mul_add, Matrix.add_mul, Matrix.mul_smul, Matrix.smul_mul]
  have hscale : (((a ^ 2)⁻¹ * γ : ℝ) : ℂ) • E = c • ((γ : ℂ) • E) := by
    rw [smul_smul, hc_def]; push_cast; ring_nf
  rw [hcompress, hscale]
  have hsum : c • (E * (Q * Q) * E) + c • (E * Wc * E) - c • ((γ : ℂ) • E)
      = c • (E * (Q * Q) * E) + c • (E * Wc * E - (γ : ℂ) • E) := by rw [smul_sub]; abel
  rw [hsum]
  exact (hEQ.smul hc).add (hWgap.smul hc)

omit [DecidableEq n] in
/-- Sector gap-transfer under commutation: when `[W, Q] = 0` the gap input
simplifies to a pure `W²` gap on the sector. -/
theorem Kab_badSector_gap_of_commute (a : ℝ) (Q W E : Matrix n n ℂ) (γ : ℝ)
    (hQ : star Q = Q) (hW : star W = W) (hE : star E = E) (hcomm : W * Q = Q * W)
    (hWgap : (E * (W * W) * E - (γ : ℂ) • E).PosSemidef) :
    (E * (star (Kab a Q W) * Kab a Q W) * E - (((a ^ 2)⁻¹ * γ : ℝ) : ℂ) • E).PosSemidef := by
  apply Kab_badSector_gap a Q W E γ hQ hW hE
  have hz : W * Q - Q * W = 0 := by rw [hcomm]; abel
  rw [hz]; simpa using hWgap

/-- **Bridge to the Hermitian island (clause 1 ↔ clause 3).** For a Hermitian
unitary chirality `g` (`star g = g`, `g·g = 1`), the Hermitian seed `H = g·K`
satisfies `Hᴴ H = star K · K` for *any* `K`. -/
theorem starH_mul_self (g K : Matrix n n ℂ) (hg : star g = g) (hg2 : g * g = 1) :
    star (g * K) * (g * K) = star K * K := by
  rw [Matrix.star_mul, hg, mul_assoc, ← mul_assoc g g K, hg2, Matrix.one_mul]

/-- **Bridge to the Hermitian island.** If additionally the seed `H = g·K` is
Hermitian, then `H² = star K · K`.  Hence an inverse-propagator (singular-value)
gap of `star K · K` on a sector is exactly an `H²`-gap there, i.e. a separated
spectral island of `H` of half-width `√γ` — connecting the clause-3 gap to the
clause-1 island separation. -/
theorem H_sq_eq_Ksq (g K : Matrix n n ℂ) (hg : star g = g) (hg2 : g * g = 1)
    (hH : star (g * K) = g * K) :
    (g * K) * (g * K) = star K * K := by
  nth_rewrite 1 [← hH]; exact starH_mul_self g K hg hg2

/-- **C0-style global species-health gap (commuting).** A global `W²`-gap
becomes a global inverse-propagator gap `star K * K ⪰ (a⁻² γ) • 1`. -/
theorem Kab_global_gap_of_commute (a : ℝ) (Q W : Matrix n n ℂ) (γ : ℝ)
    (hQ : star Q = Q) (hW : star W = W) (hcomm : W * Q = Q * W)
    (hWgap : (W * W - (γ : ℂ) • (1 : Matrix n n ℂ)).PosSemidef) :
    (star (Kab a Q W) * Kab a Q W
      - (((a ^ 2)⁻¹ * γ : ℝ) : ℂ) • (1 : Matrix n n ℂ)).PosSemidef := by
  have h := Kab_badSector_gap_of_commute a Q W (1 : Matrix n n ℂ) γ hQ hW
    (by simp) hcomm (by simpa using hWgap)
  simpa using h

end BranchWilsonSquareCore
end GateC1
end NullEdge
end Draft
end PhysicsSM
