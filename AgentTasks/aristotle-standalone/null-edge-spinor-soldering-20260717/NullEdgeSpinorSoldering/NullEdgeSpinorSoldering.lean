import Mathlib

/-!
# Null-edge soldering: 2-spinors are the future-null directions of Minkowski space

Standalone Aristotle package (Mathlib-only imports). Null-edge foundations,
2026-07-17. This is the load-bearing bridge between the two landed islands of
the program: the Pluecker mass-area calculus on Weyl 2-spinors
(`PhysicsSM.Spinor.PluckerMass` / `PluckerMassCovariance`) and the
SL(2,C) -> SO+(1,3) Lorentz action on Minkowski 4-vectors
(`PhysicsSM.Draft.NullEdge.SL2CLorentzAction`). It solders them together.

## The physical statement

A null edge is a Weyl 2-spinor `psi : Fin 2 -> C` (a light-speed constituent).
The Infeld-van der Waerden map sends it to the Hermitian matrix
`psi psi-dagger`, and thence, via the Pauli soldering form, to a 4-vector
`nu(psi)`. We prove, at the finite kernel level:

1. `nu(psi)` is FUTURE-NULL: its Minkowski square is zero and its time
   component is `(|psi_0|^2 + |psi_1|^2)/2 >= 0`, vanishing iff `psi = 0`.
   So every null edge is a future-null direction of the emergent Minkowski
   space, with the norm of the spinor as its energy.
2. The map is PHASE/SCALE covariant: `nu(c . psi) = |c|^2 . nu(psi)`, so the
   null DIRECTION depends only on the spinor up to complex scale (the extra
   phase is the flag plane, invisible to the direction).
3. It is SL(2,C)-EQUIVARIANT at the Hermitian level: `rankOne (A psi)
   = A (rankOne psi) A-dagger`, i.e. the spinor action A |-> A psi induces
   exactly the congruence (Lorentz) action on the soldered vector.
4. MASS IS AREA, geometrically: two null edges `psi, chi` sum to a vector
   whose Minkowski square is exactly the squared Pluecker wedge
   `|psi_0 chi_1 - psi_1 chi_0|^2`. It is TIMELIKE (positive mass^2) iff the
   two edges are linearly independent, and null (massless) iff they are
   parallel. This is the mass-area law, now realized as the invariant mass of
   the timelike sum of two null momenta.
5. Consequently the emergent mass^2 is SL(2,C)-invariant (a Lorentz scalar):
   for `det A = 1` the two-edge Minkowski square is unchanged.

Together: null edges ARE the future-null directions of an emergent Minkowski
geometry; SL(2,C) acts on them as the emergent Lorentz group; and rest mass is
the invariant length of the timelike sum of two non-parallel null edges, equal
to their Pluecker area. This is the shared root of the program's GR half (null
structure + Lorentz) and matter half (spinors + mass).

## Conventions

Minkowski signature is mostly-minus `(+,-,-,-)`, matching the project's
`MinkowskiConvention.eta = diag(1,-1,-1,-1)`. Pauli matrices are standard.
`Complex.normSq` is `|.|^2`. Index `0` is time. Clean-room formalization from
the standard Infeld-van der Waerden / Penrose null-flag correspondence
([import] for the classical soldering identities; [orig] for the null-EDGE
reading and the assembly into a single mass-area-Lorentz capstone).

## Proof guidance

Everything is finite 2x2 / 4-vector algebra. `hermOfVec` and `vecOfHerm` are
mutually inverse on Hermitian matrices by `Matrix.ext` + `fin_cases` +
`Complex.ext_iff`/`norm_num`. `hermOfVec_det_eq_minkowskiSq` is
`Matrix.det_fin_two` then `ring` after expanding `Complex.normSq`. For the
null-edge results write `rankOne psi` entrywise (`psi i * conj (psi j)`); the
time component and Minkowski-square identities reduce to the single fact
`normSq (psi 0 * conj (psi 1)) = normSq (psi 0) * normSq (psi 1)`
(`Complex.normSq_mul`, `Complex.normSq_conj`). The two-edge mass identity is
the 2x2 Lagrange/Cauchy-Binet identity `det (P + Q) = |wedge|^2` for the two
rank-one Hermitians, provable by `Matrix.det_fin_two` and `ring` on real and
imaginary parts. Equivariance `rankOne (A.mulVec psi) = A * rankOne psi * A^H`
is entrywise `Matrix.mul_apply` + `Finset.sum` expansion. The timelike-iff and
SL(2,C)-invariance corollaries follow from the mass identity plus
`Complex.normSq_pos` and the wedge's `det`-weight behaviour. Helper lemmas are
welcome; the numbered public statements must stay verbatim. Do not weaken any
statement; do not use `native_decide`.
-/

noncomputable section

namespace NullEdgeSpinorSoldering

open Matrix Complex

/-- A null edge: a Weyl 2-spinor. -/
abbrev Spinor := Fin 2 → ℂ

/-- A Minkowski 4-vector; index `0` is time. -/
abbrev Vec4 := Fin 4 → ℝ

/-- Pauli `sigma_0 = 1`. -/
def sigma0 : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, 1]

/-- Pauli `sigma_1`. -/
def sigma1 : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

/-- Pauli `sigma_2`. -/
def sigma2 : Matrix (Fin 2) (Fin 2) ℂ := !![0, -Complex.I; Complex.I, 0]

/-- Pauli `sigma_3`. -/
def sigma3 : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- Soldering form: a 4-vector as a Hermitian 2x2 matrix
`x0 sigma0 + x1 sigma1 + x2 sigma2 + x3 sigma3`. -/
def hermOfVec (x : Vec4) : Matrix (Fin 2) (Fin 2) ℂ :=
  (x 0 : ℂ) • sigma0 + (x 1 : ℂ) • sigma1 + (x 2 : ℂ) • sigma2 + (x 3 : ℂ) • sigma3

/-- Inverse soldering: the real 4-vector read off a Hermitian matrix. -/
def vecOfHerm (X : Matrix (Fin 2) (Fin 2) ℂ) : Vec4 :=
  ![ ((X 0 0 + X 1 1).re) / 2, (X 0 1).re, -(X 0 1).im, ((X 0 0 - X 1 1).re) / 2 ]

/-- Minkowski square, signature `(+,-,-,-)`. -/
def minkowskiSq (x : Vec4) : ℝ := (x 0) ^ 2 - (x 1) ^ 2 - (x 2) ^ 2 - (x 3) ^ 2

/-- The rank-one Hermitian `psi psi-dagger`. -/
def rankOne (psi : Spinor) : Matrix (Fin 2) (Fin 2) ℂ :=
  fun i j => psi i * (starRingEnd ℂ) (psi j)

/-- The soldered future-null 4-vector of a null edge. -/
def nullEdgeVector (psi : Spinor) : Vec4 := vecOfHerm (rankOne psi)

/-- Pluecker wedge of two null edges. -/
def spinorWedge (psi chi : Spinor) : ℂ := psi 0 * chi 1 - psi 1 * chi 0

/-- **Soldering is an involution on Hermitian data.** Reading a 4-vector into a
Hermitian matrix and back is the identity. -/
theorem vecOfHerm_hermOfVec (x : Vec4) : vecOfHerm (hermOfVec x) = x := by
  unfold vecOfHerm hermOfVec;
  ext i; fin_cases i <;> norm_num [ sigma0, sigma1, sigma2, sigma3 ] ;
  · ring;
  · rfl;
  · rfl

/-- **The soldering form realizes the Minkowski metric as a determinant.** -/
theorem hermOfVec_det_eq_minkowskiSq (x : Vec4) :
    (hermOfVec x).det = ((minkowskiSq x : ℝ) : ℂ) := by
  convert Matrix.det_fin_two _;
  unfold hermOfVec minkowskiSq; norm_num [ sigma0, sigma1, sigma2, sigma3 ] ; ring;
  norm_num

/-- **1a. Null edges are null.** The soldered vector has zero Minkowski
square. -/
theorem nullEdgeVector_minkowskiSq (psi : Spinor) :
    minkowskiSq (nullEdgeVector psi) = 0 := by
  simp +decide [ minkowskiSq, nullEdgeVector, vecOfHerm, rankOne ];
  ring

/-- **1b. Null edges are future-directed with energy the spinor norm.** -/
theorem nullEdgeVector_time (psi : Spinor) :
    nullEdgeVector psi 0 = (Complex.normSq (psi 0) + Complex.normSq (psi 1)) / 2 := by
  convert congr_arg ( fun x : ℝ => x / 2 ) ( show ( psi 0 * ( starRingEnd ℂ ) ( psi 0 ) + psi 1 * ( starRingEnd ℂ ) ( psi 1 ) |> Complex.re ) = normSq ( psi 0 ) + normSq ( psi 1 ) by simp +decide [ Complex.normSq, Complex.mul_conj ] ) using 1

/-- **1c. The energy is nonnegative, and zero exactly for the zero edge.** -/
theorem nullEdgeVector_time_nonneg (psi : Spinor) :
    0 ≤ nullEdgeVector psi 0 ∧ (nullEdgeVector psi 0 = 0 ↔ psi = 0) := by
  rw [ nullEdgeVector_time ];
  exact ⟨ div_nonneg ( add_nonneg ( Complex.normSq_nonneg _ ) ( Complex.normSq_nonneg _ ) ) zero_le_two, ⟨ fun h => by ext i; fin_cases i <;> simp_all +decide [ Complex.normSq_eq_norm_sq, add_eq_zero_iff_of_nonneg, Complex.normSq_eq_norm_sq ], fun h => by simp_all +decide [ Complex.normSq_eq_norm_sq, add_eq_zero_iff_of_nonneg, Complex.normSq_eq_norm_sq ] ⟩ ⟩

/-- **2. Scale covariance.** The soldered vector scales by `|c|^2`; in
particular a pure phase leaves the null direction fixed. -/
theorem nullEdgeVector_smul (c : ℂ) (psi : Spinor) :
    nullEdgeVector (fun i => c * psi i) =
      (Complex.normSq c) • nullEdgeVector psi := by
  ext i;
  fin_cases i <;> norm_num [ nullEdgeVector, vecOfHerm, rankOne ] <;> ring!; all_goals rw [ Complex.normSq_apply ] ; ring

/-- **3. SL(2,C)-equivariance of the soldering.** The spinor action induces the
Hermitian congruence (Lorentz) action on the soldered matrix. -/
theorem rankOne_mulVec (A : Matrix (Fin 2) (Fin 2) ℂ) (psi : Spinor) :
    rankOne (A.mulVec psi) = A * rankOne psi * Aᴴ := by
  ext i j; simp +decide [ Matrix.mul_apply, Matrix.mulVec, rankOne ] ; ring;

/-- **4a. Mass is area.** The Minkowski square of the sum of two null edges is
exactly the squared Pluecker wedge. -/
theorem twoEdge_minkowskiSq_eq_wedge (psi chi : Spinor) :
    minkowskiSq (nullEdgeVector psi + nullEdgeVector chi) =
      Complex.normSq (spinorWedge psi chi) := by
  unfold nullEdgeVector spinorWedge minkowskiSq;
  simp +decide [ rankOne, vecOfHerm, Complex.normSq ];
  ring

/-- **4b. Massive iff non-parallel.** The two-edge sum is timelike exactly when
the edges are linearly independent, and null exactly when they are parallel. -/
theorem twoEdge_timelike_iff_wedge_ne_zero (psi chi : Spinor) :
    0 < minkowskiSq (nullEdgeVector psi + nullEdgeVector chi) ↔
      spinorWedge psi chi ≠ 0 := by
  convert twoEdge_minkowskiSq_eq_wedge psi chi ▸ Complex.normSq_pos

/-- **5. Rest mass is a Lorentz scalar.** For `det A = 1` the two-edge Minkowski
square (the emergent mass squared) is SL(2,C)-invariant. -/
theorem twoEdge_minkowskiSq_sl2_invariant
    (A : Matrix (Fin 2) (Fin 2) ℂ) (hA : A.det = 1) (psi chi : Spinor) :
    minkowskiSq (nullEdgeVector (A.mulVec psi) + nullEdgeVector (A.mulVec chi)) =
      minkowskiSq (nullEdgeVector psi + nullEdgeVector chi) := by
  have h_wedge : spinorWedge (A.mulVec psi) (A.mulVec chi) = A.det * spinorWedge psi chi := by
    unfold spinorWedge Matrix.mulVec;
    norm_num [ Matrix.det_fin_two, dotProduct ] ; ring;
  rw [ twoEdge_minkowskiSq_eq_wedge, twoEdge_minkowskiSq_eq_wedge, h_wedge, hA, one_mul ]

/-- **Nonvacuity witness.** The two coordinate null edges `(1,0)` and `(0,1)`
solder to the future-null vectors `(1/2,0,0,1/2)` and `(1/2,0,0,-1/2)`, whose
sum `(1,0,0,0)` is the unit rest vector: two orthogonal null edges make a
particle at rest with mass one. -/
theorem rest_frame_witness :
    nullEdgeVector ![1, 0] + nullEdgeVector ![0, 1] = ![1, 0, 0, 0] ∧
      minkowskiSq (nullEdgeVector ![1, 0] + nullEdgeVector ![0, 1]) = 1 := by
  unfold nullEdgeVector minkowskiSq;
  unfold vecOfHerm rankOne; norm_num [ Fin.sum_univ_succ ] ;
  simp +zetaDelta at *

end NullEdgeSpinorSoldering

end
