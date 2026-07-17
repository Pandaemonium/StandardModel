import Mathlib

/-!
# Measured local mass insertions in a finite retarded series

This focused package replaces the spatially uniform scalar mass insertion in a
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
-/

noncomputable section

namespace HiggsMeasuredMassRetardedSeries

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
  sorry

/-- Powers of the two possible insertion orders intertwine through the
primitive kernel. -/
theorem kernel_mass_power_intertwine
    (K M : Matrix V V Real) (n : Nat) :
    (K * M) ^ n * K = K * (M * K) ^ n := by
  sorry

/-- Exact right finite resolvent identity. The insertion order is `M K` on
the right, as required by the intertwining identity. -/
theorem series_mul_one_add_mass_kernel
    (K M : Matrix V V Real) (H : Nat) :
    measuredMassRetardedSeries K M H * (1 + M * K) =
      K - (-1 : Real) ^ H • (K * (M * K) ^ H) := by
  sorry

/-- Nilpotence of the left insertion operator removes the terminal
remainder. -/
theorem one_add_kernel_mass_mul_series_of_nilpotent
    (K M : Matrix V V Real) (H : Nat)
    (hNil : (K * M) ^ H = 0) :
    (1 + K * M) * measuredMassRetardedSeries K M H = K := by
  sorry

/-- Nilpotence of the right insertion operator removes the terminal
remainder. -/
theorem series_mul_one_add_mass_kernel_of_nilpotent
    (K M : Matrix V V Real) (H : Nat)
    (hNil : (M * K) ^ H = 0) :
    measuredMassRetardedSeries K M H * (1 + M * K) = K := by
  sorry

/-- A positive truncation with zero local mass reduces to the primitive
retarded kernel. -/
theorem measuredMassRetardedSeries_zero_mass
    (K : Matrix V V Real) (vertexMeasure : V -> Real)
    (H : Nat) (hH : 0 < H) :
    measuredMassRetardedSeries K (localMassMatrix 0 vertexMeasure) H = K := by
  sorry

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
  sorry

end HiggsMeasuredMassRetardedSeries

end
