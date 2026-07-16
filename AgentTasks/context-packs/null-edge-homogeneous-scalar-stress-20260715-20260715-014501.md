# Aristotle semantic context pack

Generated: 2026-07-15T01:45:09
Query: `homogeneous scalar field stress energy from lapse and diagonal coframe variation volume factor energy density pressure plus minus signature minisuperspace Noether conservation`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean`

Score: `0.819`

```text
import Mathlib

/-!
# Stress-energy boundary and weak-field/cosmological controls

This module isolates three G6-G8 facts.

First, neither of the two displayed scalar summaries determines a spacetime
stress tensor. Explicit pairs of distinct symmetric four-dimensional tensors
have either the same rest-frame energy density or the same ordinary matrix
trace. These witnesses do not rule out an artificial scalar encoding of every
component. A physical matter construction must instead specify a metric or
coframe convention and provide the corresponding full variation of the actual
matter action, including its index and measure normalization, stresses, and
fluxes, rather than identify a single channel sum with `T_mu_nu`. The symmetric
matrix argument below applies to metric variations; a coframe variation has a
different index interface.

Second, with the convention

```text
G_mu_nu = (8 pi G / c^4) T_mu_nu,
```

the standard weak-field identifications

```text
G_00 = (2 / c^2) Laplacian(Phi),   T_00 = rho c^2
```

are exactly equivalent to `Laplacian(Phi) = 4 pi G rho`. This checks the
physical constant normalization; it does not derive either weak-field
identification from null edges.

Third, for a homogeneous perfect fluid in the natural-unit continuity
convention

```text
a * d rho/da + 3 * (rho + pressure) = 0,
```

the standard dust and radiation density laws satisfy the equation exactly.
This is a cosmological conservation control, not a derivation of FLRW geometry
or the Friedmann equations.
-/

open Matrix
```

### 2. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean` [weakField_nonzero_witness]

Score: `0.789`

```text
theorem weakField_nonzero_witness :
    WeakFieldEinstein00 1 1 1 (4 * Real.pi) ∧
      PoissonEquation 1 1 (4 * Real.pi) ∧
      (4 * Real.pi : ℝ) ≠ 0 := by
  refine ⟨(weakFieldEinstein00_iff_poisson 1 1 1 (4 * Real.pi) one_ne_zero).2 ?_,
    ?_, ?_⟩
  · simp [PoissonEquation]
  · simp [PoissonEquation]
  · positivity

/-! ## FLRW continuity controls in scale-factor form -/

/-- Scale-factor form of homogeneous perfect-fluid conservation in natural
units: `a rho'(a) + 3 (rho + p) = 0`. Here `rho` is energy density in the same
units as pressure, and the reduced equation is assumed rather than derived. -/
```

### 3. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean`

Score: `0.780`

```text
namespace PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls

/-! ## Scalar source budgets do not determine stress-energy -/

/-- Real covariant stress-tensor components in a fixed four-frame. -/
```

### 4. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean` [restStress_symmetric]

Score: `0.779`

```text
theorem restStress_symmetric (rho pressure : ℝ) :
    (restDustStress rho).IsSymm ∧
      (restPressuredStress rho pressure).IsSymm :=
  ⟨Matrix.isSymm_diagonal _, Matrix.isSymm_diagonal _⟩

/-- Equal rest-frame energy density does not determine spatial pressure. -/
```

### 5. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean` [radiation_continuity_scaleFactor]

Score: `0.773`

```text
theorem radiation_continuity_scaleFactor
    (rho0 a derivative : ℝ) (ha : a ≠ 0)
    (hderiv : HasDerivAt (radiationDensity rho0) derivative a) :
    ScaleFactorContinuity a (radiationDensity rho0 a)
      (radiationPressure rho0 a) derivative := by
  have hu := (hasDerivAt_radiationDensity rho0 a ha).unique hderiv
  rw [← hu]
  simp [ScaleFactorContinuity, radiationDensity, radiationPressure]
  field_simp [ha]
  ring

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.energyDensity_not_stressTensor_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.energyDensity_not_stressTensor_witness

/-- info: 'PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.traceBudget_not_stressTensor_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.traceBudget_not_stressTensor_witness

/-- info: 'PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.symmetricStress_unique_of_fullMetricVariation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.symmetricStress_unique_of_fullMetricVariation

/-- info: 'PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.weakFieldEinstein00_iff_poisson' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.weakFieldEinstein00_iff_poisson

/-- info: 'PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.dust_continuity_scale
```

### 6. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean` [Stress4]

Score: `0.772`

```text
abbrev Stress4 := Matrix (Fin 4) (Fin 4) ℝ

/-- Rest-frame pressureless component matrix with `00` entry `rho`.
Here `rho` has energy-density units; this definition does not choose a metric. -/
```

### 7. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean` [spatialTraceWitness]

Score: `0.772`

```text
def spatialTraceWitness : Stress4 :=
  Matrix.diagonal ![0, 1, 0, 0]

/-- Rest-frame `00` energy-density component. -/
```

### 8. `NULL_EDGE_RESULTS.md` [10. Carrier-layer results (2026-07-07 update)]

Score: `0.772`

```text
It does not yet supply graded
  cellular cochains, site-dependent local frame rotations and their connection
  correction terms, anholonomic structure coefficients, or nonvacuous 3-cell
  content.
- **Finite-index contracted Bianchi bridge (component identity, 2026-07-14).**
  `FiniteContractedBianchi.lean` explicitly contracts a finite-index
  all-lowered curvature derivative with first/last pair antisymmetry and the
  uncontracted differential Bianchi identity. It proves
  `2 * divRic = gradScalar` and zero divergence of the Einstein combination for
  diagonal orthonormal-frame weights squaring to one. A nonzero `1+1`
  Lorentz-signature area-form witness has `divRic = -1` and
  `gradScalar = -2`, so the contracted equality itself is nontrivial. This
  closes the tensor contraction algebra, not the geometric derivation of those
  components or hypotheses from null-edge holonomy and refinement.
- **Finite Noether link (finite identity).**
  `FiniteDynamicsNoetherThermoCapstone.action_symmetry_conservation_packet`
  proves that one unitary-commutation hypothesis both transports finite
  mass-shell solutions at fixed eigenvalue and conserves the corresponding
  real operator expectation along the discrete orbit. This is not a local
  stress-energy current, diffeomorphism Noether identity, or proof of
  covariant source conservation.
- **Finite conditional Bianchi-to-source conservation (finite identity,
  2026-07-14).** `FiniteGravityConservation.lean` proves in an arbitrary
  associative ring that `G = kappa * T`, adjoint conservation of `G`, parallel
  `kappa`, and left cancellation by `kappa` imply adjoint conservation of `T`.
  The proof uses a separately checked noncommutative adjoint Leibniz rule; a
  displayed left inverse is a convenient sufficient condition. A
```

## Scoped paper hits

### 1. Noise kernel in stochastic gravity and stress energy bitensor of quantum fields in curved spacetimes

Score: `0.771`
Zotero key: `5T5BQ6PT`
DOI: `10.1103/physrevd.63.104001`

### 2. General Relativity from a Thermodynamic Perspective

Score: `0.761`
Zotero key: `5DVPDP6J`
arXiv: `1312.3253`
DOI: `10.1007/s10714-014-1673-7`
URL: https://www.zotero.org/19894138/items/5DVPDP6J

Abstract:

I show that the gravitational dynamics in a bulk region of space can be connected to a thermodynamic description in the boundary of that region, thereby providing clear physical interpretations of several mathematical features of classical general relativity: (1) The Noether charge contained in a bulk region, associated with a specific time evolution vector field, has a direct thermodynamic interpretation as the gravitational heat content of the boundary surface. (2) This result, in turn, shows that all static spacetimes maintain holographic equipartition in the following sense: In these spacetimes, the number of degrees of freedom in the boundary is equal to the number of degrees of freedom in the bulk. (3) In a general, evolving spacetime, the rate of change of gravitational momentum is related to the difference between the number of bulk and boundary degrees of freedom. It is this departure from the holographic equipartition which drives the time evolution of the spacetime. (4) When the equations of motion hold, the (naturally defined) total energy of the gravity plus matter within a bulk region, will be equal to the boundary heat content. (5) After motivating the need for an alternate description of gravity (if we have to solve the cosmological constant problem), I describe a thermodynamic variational principle based on null surfaces to achieve this goal. The concept of gravitational heat density of the null surfaces arises naturally from the Noether charge associated with the null congruence. The variational principle, in fact, extremises the total heat content of the matter plus gravity system. Several variations on this theme and implications are described.

### 3. Aspects of Everpresent Lambda (I): A Fluctuating Cosmological Constant from Spacetime Discreteness

Score: `0.755`
Zotero key: `K5CFI3HI`
arXiv: `2304.03819`
DOI: `10.1088/1475-7516/2023/10/047`
URL: http://arxiv.org/abs/2304.03819

### 4. Gravitational Thermodynamics of Causal Diamonds in (A)dS

Score: `0.745`
Zotero key: `2ZZTQS43`
arXiv: `1812.01596`
URL: http://arxiv.org/abs/1812.01596v3

### 5. The Cosmological Constant Problem: Why it's hard to get Dark Energy from Micro-physics

Score: `0.739`
Zotero key: `TH8UZJ9K`
arXiv: `1309.4133`
URL: http://arxiv.org/abs/1309.4133v1
