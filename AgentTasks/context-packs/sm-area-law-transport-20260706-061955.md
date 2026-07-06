# Aristotle semantic context pack

Generated: 2026-07-06T06:20:05
Query: `Wilson area law transport scalar string tension step scaling summable perimeter cusp defect Faizal Shabir`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/null-edge-pro-c1-resolution-package-2026-06-27.md` [Scalar Wilson no-go at the origin]

Score: `0.761`

```text
### Scalar Wilson no-go at the origin

Scalar Wilson lifting cannot release C1.

A scalar deformation that is scalar on the balanced origin kernel and vanishes
quadratically at the origin cannot polarize the balanced origin kernel into one
Weyl line. If the scalar does not vanish at the origin, it removes the origin
mode rather than selecting the desired one.

Conclusion:

```text
Scalar Wilson can support C0.
Scalar Wilson does not solve C1.
```
```

### 2. `PhysicsSM/Spinor/TwistorPluckerMass.lean` [multiTwistorPairwiseMass_rescale]

Score: `0.756`

```text
theorem multiTwistorPairwiseMass_rescale
    {n : Nat} (a : Fin n -> ℂ) (Z : MultiTwistorChart n) :
    multiTwistorPairwiseMass (rescaleMultiTwistor a Z) =
      ∑ p ∈ finPairIndexSet n,
        complexAbsSq (a p.1) * complexAbsSq (a p.2) *
          complexAbsSq
            (infinityTwistorPairing (Z.twistor p.1) (Z.twistor p.2)) := by
  refine Finset.sum_congr rfl fun p hp => ?_
  convert congr_arg complexAbsSq
      (infinityTwistorPairing_rescale
        (a p.1) (a p.2) (Z.twistor p.1) (Z.twistor p.2)) using 1
  simp [complexAbsSq, mul_assoc, mul_comm, mul_left_comm]

/-- Uniform scalar rescaling scales finite multi-twistor mass quadratically. -/
```

### 3. `PhysicsSM/Draft/NullEdgeDiamondTwoTriangleCurvature.lean`

Score: `0.752`

```text
namespace PhysicsSM.Draft.NullEdgeDiamondTwoTriangleCurvature

open Complex

variable {V : Type}

/-- Scalar triangle transport defect. -/
```

### 4. `PhysicsSM/Spinor/TwistorPluckerMass.lean` [infinityTwistorPairing_rescale]

Score: `0.750`

```text
theorem infinityTwistorPairing_rescale
    (a b : ℂ) (Z W : SpinorChartTwistor) :
    infinityTwistorPairing (rescaleTwistor a Z) (rescaleTwistor b W) =
      (a * b) * infinityTwistorPairing Z W := by
  unfold infinityTwistorPairing rescaleTwistor spinorWedge
  simp [smul_eq_mul]
  ring

/-- Squared two-twistor mass scales by the squared moduli of chart rescalings. -/
```

### 5. `PhysicsSM/Draft/TwistorPluckerMass.lean` [infinityTwistorPairing_rescale]

Score: `0.750`

```text
theorem infinityTwistorPairing_rescale
    (a b : ℂ) (Z W : SpinorChartTwistor) :
    infinityTwistorPairing (rescaleTwistor a Z) (rescaleTwistor b W) =
      (a * b) * infinityTwistorPairing Z W := by
  unfold infinityTwistorPairing rescaleTwistor spinorWedge
  simp [smul_eq_mul]
  ring

/-- Squared two-twistor mass scales by the squared moduli of chart rescalings. -/
```

### 6. `PhysicsSM/Spinor/TwistorPluckerMass.lean` [rescaleMultiTwistorConst]

Score: `0.748`

```text
def rescaleMultiTwistorConst {n : Nat} (a : ℂ)
    (Z : MultiTwistorChart n) : MultiTwistorChart n :=
  rescaleMultiTwistor (fun _ => a) Z

/--
Independent rescaling law for finite multi-twistor pairwise mass.  Each pair
term scales by the squared moduli of the two scalar factors.
-/
```

### 7. `PhysicsSM/Draft/NullEdgeOvernightSynthesisAristotle.lean` [multiTwistorPairwiseMass_rescale]

Score: `0.747`

```text
theorem multiTwistorPairwiseMass_rescale
    {n : Nat} (a : Fin n -> ℂ) (Z : MultiTwistorChart n) :
    multiTwistorPairwiseMass (rescaleMultiTwistor a Z) =
      ∑ p ∈ finPairIndexSet n,
        complexAbsSq (a p.1) * complexAbsSq (a p.2) *
          complexAbsSq
            (infinityTwistorPairing (Z.twistor p.1) (Z.twistor p.2)) := by
  refine' Finset.sum_congr rfl fun p hp => _;
  convert congr_arg complexAbsSq ( PhysicsSM.Draft.TwistorPluckerMass.infinityTwistorPairing_rescale ( a p.1 ) ( a p.2 ) ( Z.twistor p.1 ) ( Z.twistor p.2 ) ) using 1;
  simp +decide [ complexAbsSq, mul_assoc, mul_comm, mul_left_comm ]

/-
Uniform projective rescaling scales finite multi-twistor mass quadratically.
-/
```

### 8. `AgentTasks/null-edge-wave26-c103-scalar-origin-balanced-kernel-no-go-aristotle-2026-06-27.md` [Background]

Score: `0.747`

```text
## Background

The scalar Wilson no-go should be generalized. Any deformation that is scalar
on the balanced origin kernel and vanishes at the origin cannot turn that
kernel into one Weyl line. If it is nonzero at the origin, it removes or masses
the intended physical origin mode rather than releasing a Weyl branch.
```

## Scoped paper hits

### 1. Single twistor description of massless, massive, AdS, and other interacting particles

Score: `0.751`
Zotero key: `zotero:NFHRVF2Q`
arXiv: `hep-th/0512091`
DOI: `10.1103/PhysRevD.73.064002`
URL: https://doi.org/10.1103/PhysRevD.73.064002

### 2. From Twistor-Particle Models to Massive Amplitudes

Score: `0.750`
Zotero key: `zotero:J5GA3CQ8`
arXiv: `2203.08087`
DOI: `10.3842/SIGMA.2022.045`
URL: http://arxiv.org/abs/2203.08087

### 3. An invitation to higher gauge theory

Score: `0.733`
DOI: `10.1007/s10714-010-1070-9`
URL: https://doi.org/10.1007/s10714-010-1070-9

### 4. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.732`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 5. Two-twistor particle models and free massive higher spin fields

Score: `0.731`
Zotero key: `zotero:MFUJKFEA`
arXiv: `1409.7169`
DOI: `10.1007/JHEP04(2015)010`
URL: https://doi.org/10.1007/JHEP04(2015)010
