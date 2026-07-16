# Aristotle semantic context pack

Generated: 2026-07-15T00:01:34
Query: `full symmetric metric variation uniquely determines stress energy tensor null-edge matter action conservation`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [10. Current theorem ledger]

Score: `0.870`

```text
rad-specialized Lichnerowicz square | M [orig] | One guarded G3/G4/G5 theorem chain | Principal-symbol and curvature-coefficient convergence |
| Finite stationarity, source, and Clausius avatars | M [orig] | Nonvacuous finite equations | Einstein tensor and conserved stress tensor |
| One finite symmetry hypothesis transports mass-shell solutions and conserves an operator expectation | M [orig] | Exact finite Noether link | Spacetime symmetry, local current, and stress-tensor conservation |
| Field equation plus adjoint Bianchi and parallel left-cancellative coupling implies source conservation | M [orig] | Exact noncommutative Leibniz/cancellation implication; a left-invertible matrix witness with noncommuting source/coupling | Construct the Einstein operator, contracted Bianchi theorem, variational stress tensor, and universal coupling |
| Scalar matter budgets do not determine stress-energy | M [orig] | Explicit distinct symmetric four-tensors with equal rest energy density or equal trace | Construct the full metric/coframe variation, including pressures and fluxes |
| Full symmetric metric first variation determines a symmetric stress tensor uniquely | M [orig] | Equality of Frobenius response on every symmetric probe forces tensor equality | Prove the null-edge matter action has this limiting derivative and satisfies the Noether identity |
| The standard weak-field `00` reduction with \(8\pi G/c^4\) is equivalent to Poisson normalization | M [comp] | Exact constant arithmetic with a nonzero witness | Derive the linearized Einstein component and nonrelativistic source from null-edge dynamics |
| Dust and radiation density laws satisfy scale-factor FLRW continuity | M [comp] | Exact derivative and conservation checks for \(\rho\sim a^{-3}\) and \(\rho\sim a^{-4}\) |
```

### 2. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G6. Source and conservation]

Score: `0.839`

```text
### G6. Source and conservation

Define the matter action on the same reconstructed geometry and vary it with
respect to the coframe.

**Success:** a local symmetric or convention-appropriate stress tensor with
covariant conservation.  
**Kill:** channel-dependent gravitational coupling or failure of the discrete
Noether/Bianchi identity.

The current finite conservation theorem checks only the final algebraic
cancellation in this rung once a field equation, Bianchi premise, and parallel
left-invertible coupling have already been supplied. It does not discharge the
stress-tensor construction or geometric Bianchi obligations.

There is now also an explicit scalar-budget no-go. Distinct symmetric
four-tensors can have the same `00` energy density, and distinct symmetric
four-tensors can have the same trace. Therefore the existing scalar channel
sums and expectation budgets cannot by themselves be identified with
\(T_{\mu\nu}\). A successful G6 construction must vary the limiting matter
functional with respect to every independent coframe or metric component and
recover the appropriate symmetry, pressure, flux, and conservation properties.
The complementary uniqueness theorem is now checked: two symmetric tensors
with the same Frobenius response against every symmetric metric variation are
equal. Thus a full limiting first variation is sufficient to identify the
tensor; the open problem is to construct that derivative from the null-edge
matter action and prove its Noether conservation law.
```

### 3. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean` [traceBudget_not_stressTensor_witness]

Score: `0.827`

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

/-! ## Full symmetric variation determines the tensor -/
```

### 4. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean` [metricVariationPairing_symmetricProbe]

Score: `0.817`

```text
theorem metricVariationPairing_symmetricProbe
    (T : Matrix I I ℝ) (i j : I) :
    metricVariationPairing T (symmetricProbe i j) = T i j + T j i := by
  classical
  unfold metricVariationPairing symmetricProbe
  rw [Matrix.mul_add, Matrix.trace_add,
    Matrix.trace_mul_single, Matrix.trace_mul_single]
  simp

/-- **Full-variation uniqueness.** Two symmetric tensors representing the same
linear response against every symmetric metric variation are equal. This is
the constructive counterpart of the scalar-budget no-go: a full metric first
variation can determine stress-energy uniquely. -/
```

### 5. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean`

Score: `0.811`

```text
import Mathlib

/-!
# Stress-energy boundary and weak-field/cosmological controls

This module isolates three G6-G8 facts.

First, neither of the two displayed scalar summaries determines a spacetime
stress tensor. Explicit pairs of distinct symmetric four-dimensional tensors
have either the same rest-frame energy density or the same ordinary matrix
trace. These witnesses do not rule out an artificial scalar encoding of every
component. A physical matter construction must instead provide the full
metric/coframe variation, including stresses and fluxes, rather than identify a
single channel sum with `T_mu_nu`.

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

### 6. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [6.2 Thermodynamic route]

Score: `0.801`

```text
on, but every
local-horizon, equilibrium, area-entropy, Unruh, Raychaudhuri, and conservation
hypothesis matters. It is attractive for null edges because the contraction is
tested in every null direction rather than assumed as a full tensor equation.

The repository proves **M [orig]** a finite two-variable avatar in which

\[
  \delta Q=T\,\delta S

\]

for all displayed variations is equivalent to a finite gradient equation.
This validates an integrability pattern. It does not reproduce the continuum
argument's local horizons, focusing equation, stress tensor, or universality in
all null directions.

The successor theorem must supply those missing identifications rather than
relabel the finite variables.
```

### 7. `Sources/Null_Edge_Mass_Rank_Defect_Manuscript_2026-07-09.tex` [The canonical null-edge mass invariant]

Score: `0.793`

```text
\section{The canonical null-edge mass invariant}
```

### 8. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [Abstract]

Score: `0.793`

```text
## Abstract

The null-edge program starts from causal events, primitive null support, local
soldering data, and amplitudes or transports assigned to finite histories.
General relativity starts from a smooth Lorentzian metric whose null cones,
proper times, volume form, connection, and curvature are dynamical. The two
descriptions meet at a sharp reconstruction problem.

The strongest established bridge is kinematical. Causal structure determines
the continuum conformal geometry under standard causality hypotheses, while a
volume element fixes the missing conformal scale. Sums of noncollinear null
displacements become timelike and acquire positive endpoint proper time; sums
of noncollinear null momenta become timelike and acquire invariant mass. The
same Lorentzian cross terms underlie both facts.

The current null-edge formalization adds finite coframes, local-frame
covariance, induced metrics, transport defects, holonomy, Clifford soldering,
and exact Dirac-square decompositions. It also contains finite variational,
thermodynamic, spectral, and teleparallel avatars of gravitational equations.
These are useful algebraic tests, but they do not yet derive the Einstein
equation, a continuum tetrad, Newton's constant, or gravitational backreaction.

This note separates established general relativity, machine-checked finite
identities, conditional reconstructions, and conjectural dynamics. Its central
proposal is:

> A viable null-edge route to general relativity must reconstruct the metric in
> two stages: causal order supplies the conformal class, while counting or
> soldering supplies exactly one scale field. Connection and curvature must
> then arise from covariant transport, and an independently justified action or
> equation-of-state principle must select Einstein dyna
```

## Scoped paper hits

### 1. Noise kernel in stochastic gravity and stress energy bitensor of quantum fields in curved spacetimes

Score: `0.759`
Zotero key: `5T5BQ6PT`
DOI: `10.1103/physrevd.63.104001`

### 2. CPT-Symmetric Universe

Score: `0.746`
Zotero key: `68R6TZ6X`
arXiv: `1803.08928`
DOI: `10.1103/PhysRevLett.121.251301`
URL: http://arxiv.org/abs/1803.08928

### 3. The Spectral Action Principle

Score: `0.745`
Zotero key: `6WURA7MF`
DOI: `10.1007/s002200050126`
URL: https://doi.org/10.1007/s002200050126

### 4. General Relativity from a Thermodynamic Perspective

Score: `0.740`
Zotero key: `5DVPDP6J`
arXiv: `1312.3253`
DOI: `10.1007/s10714-014-1673-7`
URL: https://www.zotero.org/19894138/items/5DVPDP6J

Abstract:

I show that the gravitational dynamics in a bulk region of space can be connected to a thermodynamic description in the boundary of that region, thereby providing clear physical interpretations of several mathematical features of classical general relativity: (1) The Noether charge contained in a bulk region, associated with a specific time evolution vector field, has a direct thermodynamic interpretation as the gravitational heat content of the boundary surface. (2) This result, in turn, shows that all static spacetimes maintain holographic equipartition in the following sense: In these spacetimes, the number of degrees of freedom in the boundary is equal to the number of degrees of freedom in the bulk. (3) In a general, evolving spacetime, the rate of change of gravitational momentum is related to the difference between the number of bulk and boundary degrees of freedom. It is this departure from the holographic equipartition which drives the time evolution of the spacetime. (4) When the equations of motion hold, the (naturally defined) total energy of the gravity plus matter within a bulk region, will be equal to the boundary heat content. (5) After motivating the need for an alternate description of gravity (if we have to solve the cosmological constant problem), I describe a thermodynamic variational principle based on null surfaces to achieve this goal. The concept of gravitational heat density of the null surfaces arises naturally from the Noether charge associated with the null congruence. The variational principle, in fact, extremises the total heat content of the matter plus gravity system. Several variations on this theme and implications are described.

### 5. Modular Hamiltonians for Deformed Half-Spaces and the Averaged Null Energy Condition

Score: `0.738`
Zotero key: `E9J46MCG`
arXiv: `1605.08072`
URL: http://arxiv.org/abs/1605.08072

Abstract:

We study modular Hamiltonians corresponding to the vacuum state for deformed half-spaces in relativistic quantum field theories on R^{1,d-1}. We show that in addition to the usual boost generator, there is a contribution to the modular Hamiltonian at first order in the shape deformation, proportional to the integral of the null components of the stress tensor along the Rindler horizon. We use this fact along with monotonicity of relative entropy to prove the averaged null energy condition in Minkowski space-time.
