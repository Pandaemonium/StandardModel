import PhysicsSM.Draft.NullEdge.MassiveRetardedLinkSeries

/-!
# Johnston 3+1 scalar path-sum normalization

This module locks the parameter translation between the project's abstract
finite massive retarded series and Johnston's `3+1`-dimensional link-path
normalization. For sprinkling density `rho` and continuum scalar mass `m`, the
hop and stop amplitudes are

```text
a = sqrt(rho) / (2 * pi * sqrt(6)),
b = -m^2 / rho.
```

Thus the abstract coefficient named `massSq` equals `m^2 / rho` in this
specific convention, while the primitive matrix is the link matrix scaled by
`a`. This is exact finite convention algebra. It does not prove the
large-density continuum limit, concentration on individual sprinklings, or
that this normalization is correct for the interacting Higgs sector.

Provenance: Steven Johnston, "Particle propagators on discrete spacetime,"
arXiv:0806.3083, equations (3.25) and (3.44). No source implementation or proof
text was copied. Claim grade: `M [comp]` for the finite equality and
`T|H [import]` for the continuum interpretation.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.Johnston3Plus1ScalarNormalization

open scoped BigOperators
open PhysicsSM.Draft.NullEdge.MassiveRetardedLinkSeries

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- Johnston's `3+1` hop amplitude for a link at sprinkling density `rho`. -/
def hopAmplitude (rho : Real) : Real :=
  Real.sqrt rho / (2 * Real.pi * Real.sqrt 6)

/-- Johnston's `3+1` stop amplitude for continuum mass `m`. -/
def stopAmplitude (m rho : Real) : Real :=
  -(m ^ 2 / rho)

/-- Density-scaled coefficient entering the abstract massive series. -/
def densityScaledMassSq (m rho : Real) : Real :=
  m ^ 2 / rho

/-- The Johnston stop amplitude is the negative of the coefficient expected by
the project's massive-series convention. -/
theorem stopAmplitude_eq_neg_densityScaledMassSq (m rho : Real) :
    stopAmplitude m rho = -densityScaledMassSq m rho := by
  rfl

/-- The primitive Johnston hop matrix is the density-scaled link matrix. -/
def hopKernel (rho : Real) (L : Matrix V V Real) : Matrix V V Real :=
  hopAmplitude rho • L

/-- Finite Johnston path sum with one hop amplitude per primitive step and one
stop amplitude per intermediate event. -/
def johnstonPathSeries
    (m rho : Real) (L : Matrix V V Real) (H : Nat) : Matrix V V Real :=
  ∑ k ∈ Finset.range H,
    (stopAmplitude m rho) ^ k • (hopKernel rho L) ^ (k + 1)

/-- Exact convention bridge to the project's abstract massive retarded
series. The abstract `massSq` parameter is `m^2/rho`, not `m^2`. -/
theorem johnstonPathSeries_eq_massiveRetardedSeries
    (m rho : Real) (L : Matrix V V Real) (H : Nat) :
    johnstonPathSeries m rho L H =
      massiveRetardedSeries (hopKernel rho L)
        (densityScaledMassSq m rho) H := by
  rfl

/-- At nonzero density the density-scaled coefficient recovers `m^2` after
multiplication by `rho`. -/
theorem densityScaledMassSq_mul_density
    (m rho : Real) (hRho : rho ≠ 0) :
    densityScaledMassSq m rho * rho = m ^ 2 := by
  simp [densityScaledMassSq, hRho]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Johnston3Plus1ScalarNormalization.johnstonPathSeries_eq_massiveRetardedSeries' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms johnstonPathSeries_eq_massiveRetardedSeries

/-- info: 'PhysicsSM.Draft.NullEdge.Johnston3Plus1ScalarNormalization.densityScaledMassSq_mul_density' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms densityScaledMassSq_mul_density

end PhysicsSM.Draft.NullEdge.Johnston3Plus1ScalarNormalization

end
