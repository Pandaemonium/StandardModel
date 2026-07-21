import Mathlib

/-!
# Kallen-Lehmann ground-atom finite core (Opus, verified Aristotle c92610f2)

Finite core of the A4 named missing lemma `osterwalderSeiler_AFN_gap_to_KL_atom`.
For a positive diagonal transfer `T` with strict top eigenvalue: ground weight
`w0 = |<e0,v>|^2 >= 0`, `w0 > 0 iff <e0,v> != 0`, `<v,T^n v>/(d0)^n -> w0`, and
the mass is DETECTED iff `w0 > 0` (hidden / propagator-zero when `w0 = 0`).

SCOPE CORRECTION (wave-2 self-audit `bb32d90b`, docstring-outruns-kernel guard):
`physicalMass` (min eigenvalue with nonzero weight) is a genuine physical witness
ONLY when SOME weight is nonzero.  In the degenerate all-zero-weight case (e.g.
`v = 0`) the support is empty and `physicalMass = sInf empty = 0` is a junk DEFAULT,
not a physical mass - guard the nonempty-support hypothesis before reading it as a
mass.
Reduces the A4 gate to purely the continuum/changing-lattice analytic bridge,
named explicitly. Provenance: verified at pin from Aristotle task c44a999a.
Clean-room Mathlib port; standard three axioms. Claim grade M, [comp]. -/

open scoped BigOperators
open Filter

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace PhysicsSM.Draft.NullEdge.KLAtomFiniteCore

/-- The Euclidean pairing on a finite real coordinate space. -/
def dot {m : ℕ} (x y : Fin (m + 1) → ℝ) : ℝ := ∑ i, x i * y i

/-- The projector onto the distinguished zeroth coordinate (the ground state). -/
def groundProjector {m : ℕ} (v : Fin (m + 1) → ℝ) : Fin (m + 1) → ℝ :=
  fun i => if i = 0 then v 0 else 0

/-- The weight of the ground-state atom. -/
def groundWeight {m : ℕ} (v : Fin (m + 1) → ℝ) : ℝ :=
  dot v (groundProjector v)

/-- Correlation in the diagonal spectral representation. -/
def correlation {m : ℕ} (d v : Fin (m + 1) → ℝ) (n : ℕ) : ℝ :=
  ∑ i, (v i) ^ 2 * (d i) ^ n

/-
The abstract spectral sum really is the matrix correlation for `T = diagonal d`.
-/
theorem correlation_eq_diagonal_matrix {m : ℕ} (d v : Fin (m + 1) → ℝ) (n : ℕ) :
    correlation d v n = dot v (((Matrix.diagonal d) ^ n).mulVec v) := by
  simp +decide [ correlation, dot, Matrix.mulVec, Matrix.diagonal_pow ];
  exact Finset.sum_congr rfl fun _ _ => by ring;

/-- The zeroth coordinate vector is a unit vector for the Euclidean pairing. -/
def groundVector {m : ℕ} : Fin (m + 1) → ℝ := fun i => if i = 0 then 1 else 0

theorem groundVector_unit {m : ℕ} :
    dot (groundVector : Fin (m + 1) → ℝ) groundVector = 1 := by
  unfold dot groundVector; aesop;

/-
The finite KL atom is the square, equivalently absolute square, of overlap
with the unit ground vector. In particular it is nonnegative.
-/
theorem groundWeight_formula {m : ℕ} (v : Fin (m + 1) → ℝ) :
    groundWeight v = |dot (groundVector : Fin (m + 1) → ℝ) v| ^ 2 ∧
      0 ≤ groundWeight v := by
  unfold groundWeight dot groundVector;
  simp +decide [groundProjector, sq];
  exact mul_self_nonneg _

/-
A ground atom has positive weight exactly when the observable overlaps the
unit ground vector.
-/
theorem groundWeight_pos_iff_overlap {m : ℕ} (v : Fin (m + 1) → ℝ) :
    0 < groundWeight v ↔ dot (groundVector : Fin (m + 1) → ℝ) v ≠ 0 := by
  simp +decide [ groundWeight_formula ];
  exact ⟨ fun h => by rintro h'; rw [ h' ] at h; norm_num at h, fun h => sq_pos_of_ne_zero h ⟩

/-
Finite spectral-measure limit.  The hypotheses say that all eigenvalues are
positive and the zeroth eigenvalue is strictly largest; thus `diagonal d` is a
positive-definite diagonal transfer matrix with a simple top eigenvalue.
-/
theorem normalized_correlation_tendsto_groundWeight {m : ℕ}
    (d v : Fin (m + 1) → ℝ) (hpos : ∀ i, 0 < d i)
    (hmax : ∀ i, i ≠ 0 → d i < d 0) :
    Tendsto (fun n : ℕ => correlation d v n / (d 0) ^ n)
      atTop (nhds (groundWeight v)) := by
  convert tendsto_finset_sum Finset.univ fun i _ => ?_ using 2;
  convert Finset.sum_div _ _ _ using 2;
  rotate_left;
  exact inferInstance;
  use fun i => if i = 0 then v 0 ^ 2 else 0;
  · split_ifs <;> simp_all +decide [ mul_div_assoc, ← div_pow ];
    · norm_num [ ne_of_gt ( hpos 0 ) ];
    · simpa using tendsto_const_nhds.mul ( tendsto_pow_atTop_nhds_zero_of_lt_one ( div_nonneg ( le_of_lt ( hpos i ) ) ( le_of_lt ( hpos 0 ) ) ) ( show d i / d 0 < 1 by rw [ div_lt_one ( hpos 0 ) ] ; exact hmax i ‹_› ) );
  · unfold groundWeight dot groundProjector; simp +decide; ring;

/-
Detection formulation: the large-distance coefficient is positive exactly
when the ground state is detected by nonzero overlap.
-/
theorem ground_mass_detected_iff {m : ℕ} (v : Fin (m + 1) → ℝ) :
    0 < groundWeight v ↔ dot (groundVector : Fin (m + 1) → ℝ) v ≠ 0 := by
  convert groundWeight_pos_iff_overlap v using 1

/-
Hidden/propagator-zero formulation: the ground coefficient vanishes exactly
when the observable is orthogonal to the ground state.
-/
theorem ground_mass_hidden_iff {m : ℕ} (v : Fin (m + 1) → ℝ) :
    groundWeight v = 0 ↔ dot (groundVector : Fin (m + 1) → ℝ) v = 0 := by
  have := groundWeight_formula v; aesop;

/-!
## Scope boundary

These results are the finite, diagonal spectral core: positivity and overlap of
the rank-one KL atom, its identification as the normalized large-time
correlation limit, and the detected/hidden alternatives.  The remaining
analytic ingredient of `osterwalderSeiler_AFN_gap_to_KL_atom` is the
continuum/changing-lattice bridge: proving the required regularity and the
convergence of overlaps, spectral/dispersion data, and correlations while
passing from finite transfer matrices to the continuum theory.
-/

end PhysicsSM.Draft.NullEdge.KLAtomFiniteCore
