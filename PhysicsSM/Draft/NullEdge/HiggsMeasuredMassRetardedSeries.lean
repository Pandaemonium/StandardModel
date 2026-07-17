import Mathlib
import PhysicsSM.Draft.NullEdge.HiggsEdgeEulerOperator

/-!
# Measured local mass insertions in a finite retarded series

This module replaces the spatially uniform scalar mass insertion in a
finite causal Green series by the diagonal matrix

```text
M_xx = massSq * vertexMeasure x.
```

For a primitive retarded kernel `K`, define

```text
G_M(H) = sum_{k=0}^{H-1} (-1)^k (K M)^k K.
```

The requested identities are the finite Dyson/resolvent equations

```text
(I + K M) G_M(H) = K - (-1)^H (K M)^H K,
G_M(H) (I + M K) = K - (-1)^H K (M K)^H.
```

The asymmetric operator order is intentional. It records a local mass
insertion between primitive causal propagations. The three-event witness has
no direct endpoint hop, while its two-hop response is weighted by the measure
at the intermediate event.

This is finite matrix algebra. It does not select a physical kernel or vertex
measure, prove a continuum Klein-Gordon equation, or predict a Higgs mass.

Provenance: clean-room finite algebra extending the matrix geometric-series
construction in Steven Johnston, "Particle propagators on discrete
spacetime," arXiv:0806.3083, and the massive-from-massless causal-set Green
function treatment in Nomaan X, Fay Dowker, and Sumati Surya, arXiv:1701.07212.
All seven proof bodies were completed by Aristotle task
`b836f213-ca4f-4492-aec1-981e385c4af4` and replayed under the pinned project
toolchain without changing a public statement. Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsMeasuredMassRetardedSeries

open scoped BigOperators

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- Diagonal local mass insertion supplied by a squared mass and vertex
measure. -/
def localMassMatrix (massSq : Real) (vertexMeasure : V -> Real) :
    Matrix V V Real :=
  Matrix.diagonal (fun vertex => massSq * vertexMeasure vertex)

/-- Truncated retarded series with a measured local mass insertion. -/
def measuredMassRetardedSeries
    (K M : Matrix V V Real) (H : Nat) : Matrix V V Real :=
  ∑ k ∈ Finset.range H, (-1 : Real) ^ k • ((K * M) ^ k * K)

/-- Exact left finite resolvent identity with terminal remainder. -/
theorem one_add_kernel_mass_mul_series
    (K M : Matrix V V Real) (H : Nat) :
    (1 + K * M) * measuredMassRetardedSeries K M H =
      K - (-1 : Real) ^ H • ((K * M) ^ H * K) := by
  induction' H with H ih;
  · simp +decide [ measuredMassRetardedSeries ];
  · simp_all +decide [ Finset.sum_range_succ, pow_succ', mul_assoc, add_mul, mul_add, measuredMassRetardedSeries ];
    abel1

/-- Powers of the two possible insertion orders intertwine through the
primitive kernel. -/
theorem kernel_mass_power_intertwine
    (K M : Matrix V V Real) (n : Nat) :
    (K * M) ^ n * K = K * (M * K) ^ n := by
  induction' n with n ih;
  · simp +decide;
  · simp +decide only [pow_succ', mul_assoc, ih]

/-- Exact right finite resolvent identity. The insertion order is `M K` on
the right, as required by the intertwining identity. -/
theorem series_mul_one_add_mass_kernel
    (K M : Matrix V V Real) (H : Nat) :
    measuredMassRetardedSeries K M H * (1 + M * K) =
      K - (-1 : Real) ^ H • (K * (M * K) ^ H) := by
  induction H <;> simp_all +decide [pow_succ', mul_one, mul_add,
    sub_eq_add_neg, mul_assoc]
  · simp +decide [measuredMassRetardedSeries]
  · simp_all +decide [measuredMassRetardedSeries, Finset.sum_range_succ,
      mul_assoc, add_mul]
    simp_all +decide [ ← mul_assoc, ← pow_succ', kernel_mass_power_intertwine ];
    grind +qlia

/-- Nilpotence of the left insertion operator removes the terminal
remainder. -/
theorem one_add_kernel_mass_mul_series_of_nilpotent
    (K M : Matrix V V Real) (H : Nat)
    (hNil : (K * M) ^ H = 0) :
    (1 + K * M) * measuredMassRetardedSeries K M H = K := by
  rw [ one_add_kernel_mass_mul_series, hNil ] ; norm_num

/-- Nilpotence of the right insertion operator removes the terminal
remainder. -/
theorem series_mul_one_add_mass_kernel_of_nilpotent
    (K M : Matrix V V Real) (H : Nat)
    (hNil : (M * K) ^ H = 0) :
    measuredMassRetardedSeries K M H * (1 + M * K) = K := by
  rw [ series_mul_one_add_mass_kernel, hNil ] ; norm_num

/-- A positive truncation with zero local mass reduces to the primitive
retarded kernel. -/
theorem measuredMassRetardedSeries_zero_mass
    (K : Matrix V V Real) (vertexMeasure : V -> Real)
    (H : Nat) (hH : 0 < H) :
    measuredMassRetardedSeries K (localMassMatrix 0 vertexMeasure) H = K := by
  unfold measuredMassRetardedSeries localMassMatrix;
  cases H <;> simp_all +decide [ Finset.sum_range_succ', pow_succ' ]

/-- Primitive link kernel on the three-event chain `0 -> 1 -> 2`. Rows are
targets and columns are sources. -/
def threeLinkKernel : Matrix (Fin 3) (Fin 3) Real :=
  !![0, 0, 0; 1, 0, 0; 0, 1, 0]

/-- Nonuniform vertex measure used by the explicit control. -/
def threeLinkMeasure : Fin 3 -> Real := ![2, 3, 5]

/-- The two-hop endpoint response samples the intermediate vertex measure.
There is no direct primitive endpoint entry, while the first measured mass
insertion contributes `-3`. -/
theorem threeLink_measured_intermediate_witness :
    threeLinkKernel 2 0 = 0 ∧
      ((threeLinkKernel * localMassMatrix 1 threeLinkMeasure) *
          threeLinkKernel) 2 0 = 3 ∧
      measuredMassRetardedSeries threeLinkKernel
          (localMassMatrix 1 threeLinkMeasure) 3 2 0 = -3 := by
  unfold threeLinkKernel localMassMatrix measuredMassRetardedSeries;
  simp +decide [ Finset.sum_range_succ, pow_succ', Matrix.mul_apply, Fin.sum_univ_succ ];
  simp +decide [ Matrix.vecMul, Matrix.vecHead, Matrix.vecTail, Matrix.mul_apply, Fin.sum_univ_succ ];
  rfl

/-! ## Connection to the variational Higgs operator -/

omit [Fintype V] in
/-- The diagonal matrix inserted in the retarded series is exactly the local
mass matrix derived in the finite radial Higgs Euler operator. -/
theorem localMassMatrix_eq_radialMassMatrix
    (massSq : Real) (vertexMeasure : V -> Real) :
    localMassMatrix massSq vertexMeasure =
      HiggsEdgeEulerOperator.radialMassMatrix massSq vertexMeasure := by
  ext i j
  by_cases h : i = j
  · subst j
    simp [localMassMatrix, HiggsEdgeEulerOperator.radialMassMatrix]
  · simp [localMassMatrix, HiggsEdgeEulerOperator.radialMassMatrix, h]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsMeasuredMassRetardedSeries.one_add_kernel_mass_mul_series' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms one_add_kernel_mass_mul_series

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsMeasuredMassRetardedSeries.threeLink_measured_intermediate_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms threeLink_measured_intermediate_witness

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsMeasuredMassRetardedSeries.localMassMatrix_eq_radialMassMatrix' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms localMassMatrix_eq_radialMassMatrix

end PhysicsSM.Draft.NullEdge.HiggsMeasuredMassRetardedSeries

end
