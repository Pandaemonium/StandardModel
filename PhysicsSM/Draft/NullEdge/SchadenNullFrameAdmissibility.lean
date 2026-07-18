import PhysicsSM.Draft.NullEdge.SchadenProperTimeBridge
import PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge

/-!
# Schaden null-frame and backward-simplex admissibility

This module formalizes the local algebraic core of the manifold-consistency
conditions in Martin Schaden, *Causal Space-Times on a Null Lattice*,
arXiv:1509.03095v2, Secs. III and V.

Four complex two-spinors determine six spatial lengths through the norms of
their pairwise Pluecker wedges. Their three opposite-edge products obey the
triangle inequalities because the `4 x 4` wedge matrix has zero Pfaffian. The
determinant of the corresponding hollow squared-length matrix is therefore
nonpositive. In the project's `(+,-,-,-)` convention it is exactly `-16`
times the square of the soldered coframe determinant.

The backward-simplex layer is deliberately separate. Its six lengths are
sampled at six different two-step predecessor sites, so the local Pfaffian
identity does not make its triangle inequalities automatic. The predicate
`BackwardSimplexAdmissible` is the explicit F1 gluing gate that a carrier
dynamics or reconstruction theorem must satisfy.

This module proves finite kinematics and an admissibility interface. It does
not prove that a graph supplies the commuting shifts, that a path integral
enforces the gate, or that admissible refinements converge to a manifold.

Claim grades:

* `T [import]`: the six-length, Pfaffian, triangle, and backward-simplex
  interpretation;
* `M [comp]`: the exact spinor, determinant, coframe, and carrier-interface
  theorems below.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.SchadenNullFrameAdmissibility

open Matrix
open NullEdgeSpinorSoldering
open NullEdgeCoframeEinsteinBridge
open CoframeVolumeMetricVariation

/-- The six independent spatial edge lengths of a tetrahedron. -/
structure SixLengths where
  l01 : Real
  l02 : Real
  l03 : Real
  l12 : Real
  l13 : Real
  l23 : Real

/-- Hollow symmetric matrix whose off-diagonal entries are squared spatial
lengths. This is Schaden's `ell^2_{mu nu}` matrix in zero-based indices. -/
def squaredLengthMatrix (L : SixLengths) : Matrix (Fin 4) (Fin 4) Real :=
  !![0, L.l01 ^ 2, L.l02 ^ 2, L.l03 ^ 2;
     L.l01 ^ 2, 0, L.l12 ^ 2, L.l13 ^ 2;
     L.l02 ^ 2, L.l12 ^ 2, 0, L.l23 ^ 2;
     L.l03 ^ 2, L.l13 ^ 2, L.l23 ^ 2, 0]

/-- First product of opposite tetrahedral edge lengths. -/
def oppositeA (L : SixLengths) : Real := L.l01 * L.l23

/-- Second product of opposite tetrahedral edge lengths. -/
def oppositeB (L : SixLengths) : Real := L.l02 * L.l13

/-- Third product of opposite tetrahedral edge lengths. -/
def oppositeC (L : SixLengths) : Real := L.l03 * L.l12

/-- The signed Heron polynomial. It is nonpositive exactly when nonnegative
`a`, `b`, and `c` satisfy all three triangle inequalities. -/
def heronDiscriminant (a b c : Real) : Real :=
  a ^ 4 + b ^ 4 + c ^ 4 - 2 * a ^ 2 * b ^ 2 -
    2 * b ^ 2 * c ^ 2 - 2 * c ^ 2 * a ^ 2

/-- All six lengths are nonnegative. -/
structure NonnegativeLengths (L : SixLengths) : Prop where
  l01 : 0 <= L.l01
  l02 : 0 <= L.l02
  l03 : 0 <= L.l03
  l12 : 0 <= L.l12
  l13 : 0 <= L.l13
  l23 : 0 <= L.l23

/-- All six lengths are strictly positive. -/
structure PositiveLengths (L : SixLengths) : Prop where
  l01 : 0 < L.l01
  l02 : 0 < L.l02
  l03 : 0 < L.l03
  l12 : 0 < L.l12
  l13 : 0 < L.l13
  l23 : 0 < L.l23

/-- The three products of opposite edge lengths form the sides of a possibly
degenerate triangle. -/
structure TriangleInequalities (a b c : Real) : Prop where
  a_le : a <= b + c
  b_le : b <= c + a
  c_le : c <= a + b

/-- Schaden admissibility for six positive spatial lengths. -/
def IsAdmissible (L : SixLengths) : Prop :=
  PositiveLengths L /\ TriangleInequalities (oppositeA L) (oppositeB L) (oppositeC L)

/-- Strict positivity implies nonnegativity. -/
theorem PositiveLengths.nonnegative {L : SixLengths} (h : PositiveLengths L) :
    NonnegativeLengths L :=
  ⟨h.l01.le, h.l02.le, h.l03.le, h.l12.le, h.l13.le, h.l23.le⟩

/-- Factorization of the signed Heron polynomial. -/
theorem heronDiscriminant_factor (a b c : Real) :
    heronDiscriminant a b c =
      -(a + b + c) * (-a + b + c) * (a - b + c) * (a + b - c) := by
  unfold heronDiscriminant
  ring

/-- Triangle inequalities force the signed Heron polynomial to be
nonpositive. -/
theorem heronDiscriminant_nonpos
    {a b c : Real} (ha : 0 <= a) (hb : 0 <= b) (hc : 0 <= c)
    (h : TriangleInequalities a b c) :
    heronDiscriminant a b c <= 0 := by
  rw [heronDiscriminant_factor]
  have hs : 0 <= a + b + c := by linarith
  have hA : 0 <= -a + b + c := by linarith [h.a_le]
  have hB : 0 <= a - b + c := by linarith [h.b_le]
  have hC : 0 <= a + b - c := by linarith [h.c_le]
  have hp :
      0 <= (a + b + c) * (-a + b + c) * (a - b + c) * (a + b - c) :=
    mul_nonneg (mul_nonneg (mul_nonneg hs hA) hB) hC
  nlinarith

/-- For nonnegative side lengths, a nonpositive signed Heron polynomial
forces all three triangle inequalities. -/
theorem triangleInequalities_of_heronDiscriminant_nonpos
    {a b c : Real} (ha : 0 <= a) (hb : 0 <= b) (hc : 0 <= c)
    (hD : heronDiscriminant a b c <= 0) :
    TriangleInequalities a b c := by
  constructor
  · by_contra h
    have hlt : b + c < a := lt_of_not_ge h
    have hs : 0 < a + b + c := by linarith
    have hA : -a + b + c < 0 := by linarith
    have hB : 0 < a - b + c := by linarith
    have hC : 0 < a + b - c := by linarith
    have hp1 : (a + b + c) * (-a + b + c) < 0 :=
      mul_neg_of_pos_of_neg hs hA
    have hp2 : (a + b + c) * (-a + b + c) * (a - b + c) < 0 :=
      mul_neg_of_neg_of_pos hp1 hB
    have hp3 :
        (a + b + c) * (-a + b + c) * (a - b + c) * (a + b - c) < 0 :=
      mul_neg_of_neg_of_pos hp2 hC
    rw [heronDiscriminant_factor] at hD
    linarith
  · by_contra h
    have hlt : c + a < b := lt_of_not_ge h
    have hs : 0 < a + b + c := by linarith
    have hA : 0 < -a + b + c := by linarith
    have hB : a - b + c < 0 := by linarith
    have hC : 0 < a + b - c := by linarith
    have hp1 : 0 < (a + b + c) * (-a + b + c) := mul_pos hs hA
    have hp2 : (a + b + c) * (-a + b + c) * (a - b + c) < 0 :=
      mul_neg_of_pos_of_neg hp1 hB
    have hp3 :
        (a + b + c) * (-a + b + c) * (a - b + c) * (a + b - c) < 0 :=
      mul_neg_of_neg_of_pos hp2 hC
    rw [heronDiscriminant_factor] at hD
    linarith
  · by_contra h
    have hlt : a + b < c := lt_of_not_ge h
    have hs : 0 < a + b + c := by linarith
    have hA : 0 < -a + b + c := by linarith
    have hB : 0 < a - b + c := by linarith
    have hC : a + b - c < 0 := by linarith
    have hp1 : 0 < (a + b + c) * (-a + b + c) := mul_pos hs hA
    have hp2 : 0 < (a + b + c) * (-a + b + c) * (a - b + c) :=
      mul_pos hp1 hB
    have hp3 :
        (a + b + c) * (-a + b + c) * (a - b + c) * (a + b - c) < 0 :=
      mul_neg_of_pos_of_neg hp2 hC
    rw [heronDiscriminant_factor] at hD
    linarith

/-- The determinant of the hollow squared-length matrix is the signed Heron
polynomial of the three opposite-edge products. -/
theorem squaredLengthMatrix_det (L : SixLengths) :
    (squaredLengthMatrix L).det =
      heronDiscriminant (oppositeA L) (oppositeB L) (oppositeC L) := by
  simp (maxSteps := 8000000) [squaredLengthMatrix,
    Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove,
    Matrix.submatrix_apply, Matrix.of_apply, heronDiscriminant,
    oppositeA, oppositeB, oppositeC]
  ring

/-- For six nonnegative lengths, Schaden's triangle gate is exactly the
nonpositivity of the squared-length determinant. -/
theorem squaredLengthMatrix_det_nonpos_iff
    (L : SixLengths) (hL : NonnegativeLengths L) :
    (squaredLengthMatrix L).det <= 0 <->
      TriangleInequalities (oppositeA L) (oppositeB L) (oppositeC L) := by
  rw [squaredLengthMatrix_det]
  have hA : 0 <= oppositeA L := mul_nonneg hL.l01 hL.l23
  have hB : 0 <= oppositeB L := mul_nonneg hL.l02 hL.l13
  have hC : 0 <= oppositeC L := mul_nonneg hL.l03 hL.l12
  constructor
  · exact triangleInequalities_of_heronDiscriminant_nonpos hA hB hC
  · exact heronDiscriminant_nonpos hA hB hC

/-- With strict positivity supplied, the full admissibility predicate can be
checked by one determinant inequality. -/
theorem isAdmissible_iff_positive_and_det_nonpos (L : SixLengths) :
    IsAdmissible L <-> PositiveLengths L /\ (squaredLengthMatrix L).det <= 0 := by
  constructor
  · rintro ⟨hPositive, hTriangle⟩
    exact ⟨hPositive,
      (squaredLengthMatrix_det_nonpos_iff L hPositive.nonnegative).2 hTriangle⟩
  · rintro ⟨hPositive, hDet⟩
    exact ⟨hPositive,
      (squaredLengthMatrix_det_nonpos_iff L hPositive.nonnegative).1 hDet⟩

/-! ## Four-spinor forward null frames -/

/-- Spatial length associated with a pair of spinor-soldered null edges. -/
def pairLength (edges : Fin 4 -> Spinor) (i j : Fin 4) : Real :=
  ‖spinorWedge (edges i) (edges j)‖

/-- The six lengths produced by one four-spinor null frame. -/
def fromSpinors (edges : Fin 4 -> Spinor) : SixLengths where
  l01 := pairLength edges 0 1
  l02 := pairLength edges 0 2
  l03 := pairLength edges 0 3
  l12 := pairLength edges 1 2
  l13 := pairLength edges 1 3
  l23 := pairLength edges 2 3

/-- The complex Pluecker relation for four two-spinors: the Pfaffian of their
antisymmetric wedge matrix vanishes. -/
theorem spinor_plucker_relation (edges : Fin 4 -> Spinor) :
    spinorWedge (edges 0) (edges 1) * spinorWedge (edges 2) (edges 3) -
      spinorWedge (edges 0) (edges 2) * spinorWedge (edges 1) (edges 3) +
      spinorWedge (edges 0) (edges 3) * spinorWedge (edges 1) (edges 2) = 0 := by
  simp only [spinorWedge]
  ring

/-- The six lengths of any four-spinor frame are nonnegative. -/
theorem fromSpinors_nonnegative (edges : Fin 4 -> Spinor) :
    NonnegativeLengths (fromSpinors edges) := by
  constructor <;> simp [fromSpinors, pairLength]

/-- Pairwise noncollinearity makes all six spatial lengths positive. -/
theorem fromSpinors_positive (edges : Fin 4 -> Spinor)
    (hPair : forall i j, i ≠ j -> spinorWedge (edges i) (edges j) ≠ 0) :
    PositiveLengths (fromSpinors edges) := by
  constructor <;> simp only [fromSpinors, pairLength] <;>
    apply norm_pos_iff.mpr <;> apply hPair <;> decide

/-- The three opposite-edge products of any four-spinor frame satisfy all
three triangle inequalities. -/
theorem fromSpinors_triangle (edges : Fin 4 -> Spinor) :
    TriangleInequalities
      (oppositeA (fromSpinors edges))
      (oppositeB (fromSpinors edges))
      (oppositeC (fromSpinors edges)) := by
  let A := spinorWedge (edges 0) (edges 1) * spinorWedge (edges 2) (edges 3)
  let B := spinorWedge (edges 0) (edges 2) * spinorWedge (edges 1) (edges 3)
  let C := spinorWedge (edges 0) (edges 3) * spinorWedge (edges 1) (edges 2)
  have hABC : A - B + C = 0 := spinor_plucker_relation edges
  have hA : A = B - C := by
    calc
      A = A - (A - B + C) := by rw [hABC, sub_zero]
      _ = B - C := by ring
  have hB : B = A + C := by
    calc
      B = B + (A - B + C) := by rw [hABC, add_zero]
      _ = A + C := by ring
  have hC : C = B - A := by
    calc
      C = C - (A - B + C) := by rw [hABC, sub_zero]
      _ = B - A := by ring
  have eA : oppositeA (fromSpinors edges) = ‖A‖ := by
    simp [oppositeA, fromSpinors, pairLength, A]
  have eB : oppositeB (fromSpinors edges) = ‖B‖ := by
    simp [oppositeB, fromSpinors, pairLength, B]
  have eC : oppositeC (fromSpinors edges) = ‖C‖ := by
    simp [oppositeC, fromSpinors, pairLength, C]
  constructor
  · rw [eA, eB, eC, hA]
    exact norm_sub_le B C
  · rw [eA, eB, eC, hB]
    simpa [add_comm] using norm_add_le A C
  · rw [eA, eB, eC, hC]
    simpa [add_comm] using norm_sub_le B A

/-- A pairwise noncollinear four-spinor frame is Schaden-admissible. -/
theorem fromSpinors_admissible (edges : Fin 4 -> Spinor)
    (hPair : forall i j, i ≠ j -> spinorWedge (edges i) (edges j) ≠ 0) :
    IsAdmissible (fromSpinors edges) :=
  ⟨fromSpinors_positive edges hPair, fromSpinors_triangle edges⟩

/-- Minkowski polarization in the project's mostly-minus convention. -/
def minkowskiDot (x y : Vec4) : Real :=
  x 0 * y 0 - x 1 * y 1 - x 2 * y 2 - x 3 * y 3

/-- Polarization identity for the mostly-minus Minkowski square. -/
theorem minkowskiSq_add (x y : Vec4) :
    minkowskiSq (x + y) =
      minkowskiSq x + minkowskiSq y + 2 * minkowskiDot x y := by
  simp [minkowskiSq, minkowskiDot]
  ring

/-- The null-edge Gram metric is the Minkowski dot product of its soldered
columns. -/
theorem nullEdgeMetricAt_apply (edges : Fin 4 -> Spinor) (i j : Fin 4) :
    nullEdgeMetricAt edges i j =
      minkowskiDot (nullEdgeVector (edges i)) (nullEdgeVector (edges j)) := by
  simp [nullEdgeMetricAt, inducedCovariantMetric, nullEdgeCoframeAt,
    minkowskiMetric, minkowskiDot, Matrix.mul_apply, Fin.sum_univ_succ]
  ring

/-- The null-edge Gram metric is symmetric. -/
theorem nullEdgeMetricAt_symm (edges : Fin 4 -> Spinor) (i j : Fin 4) :
    nullEdgeMetricAt edges i j = nullEdgeMetricAt edges j i := by
  rw [nullEdgeMetricAt_apply, nullEdgeMetricAt_apply]
  unfold minkowskiDot
  ring

/-- Squared pair length is twice the null-edge Gram pairing. -/
theorem pairLength_sq_eq_two_mul_metric
    (edges : Fin 4 -> Spinor) (i j : Fin 4) :
    pairLength edges i j ^ 2 = 2 * nullEdgeMetricAt edges i j := by
  rw [pairLength, Complex.sq_norm, nullEdgeMetricAt_apply]
  have hPolar := minkowskiSq_add (nullEdgeVector (edges i)) (nullEdgeVector (edges j))
  rw [nullEdgeVector_minkowskiSq, nullEdgeVector_minkowskiSq, zero_add] at hPolar
  rw [twoEdge_minkowskiSq_eq_wedge] at hPolar
  linarith

/-- The squared-length matrix produced from spinors is exactly twice their
Minkowski Gram metric. -/
theorem squaredLengthMatrix_fromSpinors_eq_two_smul_metric
    (edges : Fin 4 -> Spinor) :
    squaredLengthMatrix (fromSpinors edges) = (2 : Real) • nullEdgeMetricAt edges := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [squaredLengthMatrix, fromSpinors, Matrix.smul_apply,
      pairLength_sq_eq_two_mul_metric, nullEdgeMetricAt_diagonal_zero] <;>
    apply nullEdgeMetricAt_symm

/-- In project conventions, Schaden's squared-length determinant is `-16`
times the square of the oriented soldered coframe volume. -/
theorem squaredLengthMatrix_fromSpinors_det (edges : Fin 4 -> Spinor) :
    (squaredLengthMatrix (fromSpinors edges)).det =
      -16 * (nullEdgeCoframeAt edges).det ^ 2 := by
  rw [squaredLengthMatrix_fromSpinors_eq_two_smul_metric,
    Matrix.det_smul, nullEdgeMetricAt_det]
  norm_num

/-- Every four-spinor forward frame has a real Schaden volume. -/
theorem squaredLengthMatrix_fromSpinors_det_nonpos (edges : Fin 4 -> Spinor) :
    (squaredLengthMatrix (fromSpinors edges)).det <= 0 := by
  rw [squaredLengthMatrix_fromSpinors_det]
  nlinarith [sq_nonneg (nullEdgeCoframeAt edges).det]

/-- Strictly negative length determinant is equivalent to a nondegenerate
soldered four-dimensional coframe. -/
theorem squaredLengthMatrix_fromSpinors_det_neg_iff (edges : Fin 4 -> Spinor) :
    (squaredLengthMatrix (fromSpinors edges)).det < 0 <->
      (nullEdgeCoframeAt edges).det ≠ 0 := by
  rw [squaredLengthMatrix_fromSpinors_det]
  constructor
  · intro h hZero
    simp [hZero] at h
  · intro h
    have hSq : 0 < (nullEdgeCoframeAt edges).det ^ 2 := sq_pos_of_ne_zero h
    nlinarith

/-! ## Backward-simplex carrier gate -/

/-- Four commuting predecessor maps on a carrier. They abstract the
`n |-> n - Delta_mu` translations in Schaden's hypercubic null lattice. -/
structure CommutingRetreat (Site : Type*) where
  retreat : Fin 4 -> Site -> Site
  commute : forall i j site,
    retreat i (retreat j site) = retreat j (retreat i site)

/-- Six backward-simplex lengths assembled from six distinct two-step
predecessor sites. -/
def backwardLengths {Site : Type*}
    (edges : Site -> Fin 4 -> Spinor) (shift : CommutingRetreat Site)
    (site : Site) : SixLengths where
  l01 := pairLength (edges (shift.retreat 0 (shift.retreat 1 site))) 0 1
  l02 := pairLength (edges (shift.retreat 0 (shift.retreat 2 site))) 0 2
  l03 := pairLength (edges (shift.retreat 0 (shift.retreat 3 site))) 0 3
  l12 := pairLength (edges (shift.retreat 1 (shift.retreat 2 site))) 1 2
  l13 := pairLength (edges (shift.retreat 1 (shift.retreat 3 site))) 1 3
  l23 := pairLength (edges (shift.retreat 2 (shift.retreat 3 site))) 2 3

/-- The explicit quasi-local manifold-admissibility predicate for one
backward simplex. Unlike forward admissibility, this is not automatic. -/
def BackwardSimplexAdmissible {Site : Type*}
    (edges : Site -> Fin 4 -> Spinor) (shift : CommutingRetreat Site)
    (site : Site) : Prop :=
  IsAdmissible (backwardLengths edges shift site)

/-- The backward-simplex gate is equivalently strict positivity of its six
lengths plus one nonpositive determinant test. -/
theorem backwardSimplexAdmissible_iff_positive_and_det_nonpos
    {Site : Type*} (edges : Site -> Fin 4 -> Spinor)
    (shift : CommutingRetreat Site) (site : Site) :
    BackwardSimplexAdmissible edges shift site <->
      PositiveLengths (backwardLengths edges shift site) /\
        (squaredLengthMatrix (backwardLengths edges shift site)).det <= 0 :=
  isAdmissible_iff_positive_and_det_nonpos _

/-- Constant spinor decorations reduce backward lengths to the local
four-spinor lengths, independently of the carrier shifts. -/
theorem backwardLengths_constant
    {Site : Type*} (edges : Fin 4 -> Spinor) (shift : CommutingRetreat Site)
    (site : Site) :
    backwardLengths (fun _ => edges) shift site = fromSpinors edges := rfl

/-- The canonical nondegenerate four-spinor frame is a nonvacuous admissible
backward-simplex witness on every commuting carrier. -/
theorem canonical_backwardSimplexAdmissible
    {Site : Type*} (shift : CommutingRetreat Site) (site : Site) :
    BackwardSimplexAdmissible (fun _ => canonicalNullEdges) shift site := by
  rw [BackwardSimplexAdmissible, backwardLengths_constant]
  apply fromSpinors_admissible
  intro i j hij
  fin_cases i <;> fin_cases j <;>
    simp_all [canonicalNullEdges, spinorWedge, Complex.ext_iff]

end PhysicsSM.Draft.NullEdge.SchadenNullFrameAdmissibility

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.SchadenNullFrameAdmissibility.spinor_plucker_relation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SchadenNullFrameAdmissibility.spinor_plucker_relation

/-- info: 'PhysicsSM.Draft.NullEdge.SchadenNullFrameAdmissibility.squaredLengthMatrix_det_nonpos_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SchadenNullFrameAdmissibility.squaredLengthMatrix_det_nonpos_iff

/-- info: 'PhysicsSM.Draft.NullEdge.SchadenNullFrameAdmissibility.squaredLengthMatrix_fromSpinors_det_neg_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SchadenNullFrameAdmissibility.squaredLengthMatrix_fromSpinors_det_neg_iff

/-- info: 'PhysicsSM.Draft.NullEdge.SchadenNullFrameAdmissibility.backwardSimplexAdmissible_iff_positive_and_det_nonpos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SchadenNullFrameAdmissibility.backwardSimplexAdmissible_iff_positive_and_det_nonpos

/-- info: 'PhysicsSM.Draft.NullEdge.SchadenNullFrameAdmissibility.canonical_backwardSimplexAdmissible' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SchadenNullFrameAdmissibility.canonical_backwardSimplexAdmissible

end
