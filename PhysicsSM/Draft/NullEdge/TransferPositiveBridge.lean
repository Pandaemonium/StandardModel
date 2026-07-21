import Mathlib

/-!
# A3 positive finite transfer-decay bridge (Opus, verified Aristotle 35962102)

The positive complement to `transfer_gap_does_not_fix_correlation_mass`: when the
observable overlaps the first excited mode, the connected correlation has the
exact decay ratio set by that transfer eigenvalue. Interpreting this finite
decay scale as a physical mass additionally requires an observable
reconstruction, a continuum limit, and the appropriate rest-energy or pole
semantics.
Provenance: verified at the pinned toolchain from Aristotle task cd4acf69.
Clean-room Mathlib port; standard three axioms. Claim grade M, [comp]. -/

open scoped BigOperators
open scoped Matrix
open Filter Topology

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace PhysicsSM.Draft.NullEdge.TransferPositiveBridge

/-- A finite diagonal transfer matrix with eigenvalues `lam`. -/
def diagonalTransfer {m : ℕ} (lam : Fin m → ℝ) : Matrix (Fin m) (Fin m) ℝ :=
  Matrix.diagonal lam

/-- The Euclidean two-point function of `v` for a diagonal transfer matrix. -/
def correlation {m : ℕ} (lam v : Fin m → ℝ) (n : ℕ) : ℝ :=
  v ⬝ᵥ ((diagonalTransfer lam) ^ n).mulVec v

/-- The connected correlator obtained by subtracting the distinguished ground mode. -/
def connectedCorrelation {m : ℕ} [NeZero m]
    (lam v : Fin m → ℝ) (n : ℕ) : ℝ :=
  correlation lam v n - (v 0) ^ 2 * (lam 0) ^ n

/-
Spectral decomposition of a finite diagonal-transfer-matrix correlator.
-/
theorem correlation_spectral_decomposition {m : ℕ} (lam v : Fin m → ℝ) (n : ℕ) :
    correlation lam v n = ∑ j, (v j) ^ 2 * (lam j) ^ n := by
  unfold correlation;
  rw [ show diagonalTransfer lam ^ n = Matrix.diagonal ( fun j ↦ lam j ^ n ) from ?_ ];
  · simp +decide [Matrix.mulVec_diagonal, pow_two, mul_assoc, mul_comm, dotProduct]
  · induction n <;> simp_all +decide [ pow_succ, diagonalTransfer ]

/-
After subtracting the ground mode, only non-ground spectral weights remain.
-/
theorem connectedCorrelation_spectral_decomposition {m : ℕ} [NeZero m]
    (lam v : Fin m → ℝ) (n : ℕ) :
    connectedCorrelation lam v n = ∑ j with j ≠ 0, (v j) ^ 2 * (lam j) ^ n := by
  simp +decide only [connectedCorrelation, correlation_spectral_decomposition];
  simp +decide [ Finset.filter_ne' ]

/-
In the two-state sector the connected correlator is exactly the first-excited
spectral weight times its transfer eigenvalue to the Euclidean time.
-/
theorem connectedCorrelation_fin2_exact (lam v : Fin 2 → ℝ) (n : ℕ) :
    connectedCorrelation lam v n = (v 1) ^ 2 * (lam 1) ^ n := by
  rw [ connectedCorrelation_spectral_decomposition ];
  rw [ Finset.sum_eq_single 1 ] <;> simp +decide

/-
**Finite positive bridge (two-state sector).**  If the transfer eigenvalues
are strictly positive, the ground eigenvalue is strictly larger, and the
observable overlaps the first excited mode, then normalization by the first
excited eigenvalue is identically the positive spectral weight.  Consequently
it converges to that positive constant.
-/
theorem connectedCorrelation_fin2_normalized_tendsto
    (lam v : Fin 2 → ℝ)
    (hpos1 : 0 < lam 1)
    (hgap : lam 1 < lam 0) (hoverlap : v 1 ≠ 0) :
    (∀ n : ℕ, connectedCorrelation lam v n / (lam 1) ^ n = (v 1) ^ 2) ∧
      Tendsto (fun n : ℕ => connectedCorrelation lam v n / (lam 1) ^ n)
        atTop (𝓝 ((v 1) ^ 2)) ∧
      0 < (v 1) ^ 2 ∧
      0 < Real.log (lam 0 / lam 1) := by
  simp_all +decide [connectedCorrelation_fin2_exact]
  exact ⟨fun n => mul_div_cancel_right₀ _ (pow_ne_zero _ hpos1.ne'),
    tendsto_const_nhds.congr fun n => by
      rw [mul_div_cancel_right₀ _ (pow_ne_zero _ hpos1.ne')],
    sq_pos_of_ne_zero hoverlap,
    Real.log_pos <| by rw [lt_div_iff₀ hpos1]; linarith⟩

/-
Dividing by the ground-state propagation makes the decay base the spectral
ratio `lam 1 / lam 0`, whose negative logarithm is the transfer mass.
-/
theorem connectedCorrelation_fin2_ground_normalized
    (lam v : Fin 2 → ℝ) (n : ℕ) :
    connectedCorrelation lam v n / (lam 0) ^ n =
      (v 1) ^ 2 * (lam 1 / lam 0) ^ n := by
  rw [ connectedCorrelation_fin2_exact, div_pow, mul_div_assoc ]

/-- The logarithmic transfer gap is the usual mass written as minus the logarithm
of the excited-to-ground eigenvalue ratio. -/
theorem log_transfer_gap_eq_mass (lam : Fin 2 → ℝ) :
    Real.log (lam 0 / lam 1) = -Real.log (lam 1 / lam 0) := by
  rw [ ← Real.log_inv, inv_div ]

end PhysicsSM.Draft.NullEdge.TransferPositiveBridge
