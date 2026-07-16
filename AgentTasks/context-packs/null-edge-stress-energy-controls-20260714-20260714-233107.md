# Aristotle semantic context pack

Generated: 2026-07-14T23:31:15
Query: `null edge scalar matter budget stress energy tensor coframe variation weak field Newtonian 8 pi G c4 Poisson FLRW continuity dust radiation controls`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean`

Score: `0.874`

```text
import Mathlib

/-!
# Stress-energy boundary and weak-field/cosmological controls

This module isolates three G6-G8 facts.

First, a scalar matter budget is not a spacetime stress tensor. Explicit pairs
of distinct symmetric four-dimensional tensors have either the same rest-frame
energy density or the same trace. A future matter construction must therefore
provide the full metric/coframe variation, including stresses and fluxes, rather
than identify a single channel sum with `T_mu_nu`.

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

Third, in the natural-unit continuity convention

```text
a * d rho/da + 3 * (rho + pressure) = 0,
```

the standard dust and radiation density laws satisfy the equation exactly.
This is a cosmological conservation control, not a derivation of FLRW geometry
or the Friedmann equations.
-/

open Matrix
```

### 2. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean` [radiation_continuity_scaleFactor]

Score: `0.808`

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

/-- info: 'PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.weakFieldEinstein00_iff_poisson' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.weakFieldEinstein00_iff_poisson

/-- info: 'PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.dust_continuity_scaleFactor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.dust_continuity_scaleFactor

/-- info: 'PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.radiation_continuity_scaleFactor' depends on axioms: [pro
```

### 3. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean` [weakField_nonzero_witness]

Score: `0.805`

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
units: `a rho'(a) + 3 (rho + p) = 0`. -/
```

### 4. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean` [traceBudget_not_stressTensor_witness]

Score: `0.791`

```text
theorem traceBudget_not_stressTensor_witness :
    ∃ T1 T2 : Stress4,
      T1.IsSymm ∧ T2.IsSymm ∧
      traceBudget T1 = traceBudget T2 ∧ T1 ≠ T2 := by
  refine ⟨restDustStress 1, spatialTraceWitness,
    (restStress_symmetric 1 0).1, Matrix.isSymm_diagonal _, ?_, ?_⟩
  · simp [traceBudget, restDustStress, spatialTraceWitness,
      Matrix.trace_diagonal, Fin.sum_univ_four]
  · intro h
    have h00 := congrFun (congrFun h 0) 0
    norm_num [restDustStress, spatialTraceWitness] at h00

/-! ## Weak-field constant normalization -/

/-- Einstein coupling in SI-style units for the displayed field-equation
convention. -/
```

### 5. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean` [radiation_continuity_scaleFactor]

Score: `0.786`

```text
csSM.Draft.NullEdge.StressEnergyPhysicalControls.dust_continuity_scaleFactor

/-- info: 'PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.radiation_continuity_scaleFactor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.radiation_continuity_scaleFactor

end PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls
```

### 6. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean`

Score: `0.783`

```text
namespace PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls

/-! ## Scalar source budgets do not determine stress-energy -/

/-- Real covariant stress-tensor components in a fixed four-frame. -/
```

### 7. `AgentTasks/overnight-allmass-run-2026-07-09/harvest/gravsrc/98f0bf9b-0c08-4d5a-9dd8-d67152348eca_aristotle/ARISTOTLE_SUMMARY.md` [Honest scope]

Score: `0.779`

```text
## Honest scope

This is a finite one-edge / one-frame avatar of `G = κ T`, **not** the continuum
Einstein equations. It extends the Goal-IV field-equation line in the UNIFICATION
direction (source = matter channels); the overlap with a bare stationarity statement
is flagged here for reconciliation — the distinguishing content is that the SOURCE is
exhibited as the matter channels specifically.
```

### 8. `Sources/Null_Edge_Cosmological_Constant_Manuscript_Draft_2026-07-12.tex` [preamble]

Score: `0.769`

```text
chotomy}
\author{[named authors --- release gate]}
\date{July 12, 2026 --- working draft (partial outline)}

\begin{document}
\maketitle

\begin{abstract}
We report a Lean~4 formalization, over Mathlib, of the arithmetic core of a
finite ``null-edge'' account of the cosmological constant $\Lam$.  The value
proposition is exactness and machine-verification of the \emph{structural}
claims, not a first-principles derivation of the observed value.  Three
independently landed, kernel-checked (\Kernel) results organize the account.
(1) \emph{Magnitude dissolution, structurally}: in the finite spectral-action
grading the coefficient of $\operatorname{tr}(\mathbf 1)$ is invariant under
\emph{every} deformation of the Dirac operator, while the order-2 and order-4
traces provably do change; only count statistics can touch the order-0
coefficient.  (This grading invariance is the finite avatar of a classical
heat-kernel fact; the physical statement that no matter or gauge channel
renormalizes $\Lam$ rests on the finite unimodular trade of Section~4, not on
the grading alone --- see the Section~4 remark.)
(2) \emph{The everpresent scaling law}: with the discreteness (Poisson) input
$\langle\delta N^2\rangle = V$ the normalized $\Lam = \delta N/V$ has RMS
$1/\sqrt V$, routed through the framework's own extensive edge count rather than
an abstract volume.  (3) \emph{A pre-registered dichotomy with a sharp
exponent}: the count variance $\operatorname{Var}(N)$ is a finite susceptibility
whose scaling exponent $\alpha$ decides everpresent survival --- the Poisson
branch ($\alpha=1$) gives the everpresent exponent $-\tfrac12$ and predicts
fluctuating dark energy at $1/\sqrt V$, while any hyperuniform branch
($\alpha<1$, the constraint-correlated case realized by Coulomb systems)
suppress
```

## Scoped paper hits

### 1. Noise kernel in stochastic gravity and stress energy bitensor of quantum fields in curved spacetimes

Score: `0.775`
Zotero key: `5T5BQ6PT`
DOI: `10.1103/physrevd.63.104001`

### 2. The Cosmological Constant Problem: Why it's hard to get Dark Energy from Micro-physics

Score: `0.753`
Zotero key: `TH8UZJ9K`
arXiv: `1309.4133`
URL: http://arxiv.org/abs/1309.4133v1

### 3. Stochastic Gravity: Theory and Applications

Score: `0.746`
Zotero key: `TXN5JSZ5`
DOI: `10.12942/lrr-2008-3`
URL: https://doi.org/10.12942/lrr-2008-3

### 4. Aspects of Everpresent Lambda (I): A Fluctuating Cosmological Constant from Spacetime Discreteness

Score: `0.737`
Zotero key: `K5CFI3HI`
arXiv: `2304.03819`
DOI: `10.1088/1475-7516/2023/10/047`
URL: http://arxiv.org/abs/2304.03819

### 5. Is the cosmological constant a nonlocal quantum residue of discreteness of the causal set type?

Score: `0.735`
Zotero key: `G3FT8BXC`
arXiv: `0710.1675`
URL: http://arxiv.org/abs/0710.1675v1
