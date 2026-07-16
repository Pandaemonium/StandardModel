# Aristotle semantic context pack

Generated: 2026-07-15T03:08:50
Query: `flat FLRW scale Euler Lagrange acceleration equation lapse Einstein Hilbert boundary term scalar pressure null edge general relativity`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [10. Current theorem ledger]

Score: `0.849`

```text
rspace action, adding the constructed homogeneous scalar action and varying the lapse gives exactly (H^2=(8\pi G/3)\rho+\Lambda/3), with a nondegenerate positive-matter witness | Derive the FLRW reduction, Einstein-Hilbert action, lapse, scale factor, (G), and (Lambda) from graph data; add the acceleration equation and inhomogeneous dynamics |
| The standard weak-field `00` reduction with \(8\pi G/c^4\) is equivalent to Poisson normalization | M [comp] | Exact constant arithmetic with a nonzero witness | Derive the linearized Einstein component and nonrelativistic source from null-edge dynamics |
| Dust and radiation density laws satisfy scale-factor FLRW continuity | M [comp] | Exact derivative and conservation checks for \(\rho\sim a^{-3}\) and \(\rho\sim a^{-4}\) | Derive homogeneous geometry, Friedmann dynamics, and the equations of state from the model |
| Gravity emerges from entropy monotonicity on nested causal regions | C [orig] | Research route only | Raychaudhuri, area law, all-null-direction theorem |
| The null-edge framework reproduces Einstein's equation | C [orig] | Not established | Full reconstruction ladder below |
```

### 2. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [10. Current theorem ledger]

Score: `0.819`

```text
invertible matrix witness with noncommuting source/coupling | Construct the Einstein operator, contracted Bianchi theorem, variational stress tensor, and universal coupling |
| Scalar matter budgets do not determine stress-energy | M [orig] | Explicit distinct symmetric four-tensors with equal rest energy density or equal ordinary matrix trace | Construct the full metric/coframe variation, including pressures and fluxes |
| A full symmetric component response determines its symmetric coefficient tensor uniquely | M [orig] | Equality of finite Frobenius response on every symmetric probe forces matrix equality | Prove the null-edge matter action has the corresponding localized, measure-normalized derivative and satisfies the Noether identity |
| A homogeneous scalar one-cell action yields density and pressure from distinct diagonal responses | M [comp] | The action includes the oriented diagonal coframe determinant and inverse lapse; lapse variation gives minus the oriented spatial-volume factor times `rho`, each spatial-scale variation gives lapse times an oriented opposite-face factor times `p`, and a nonzero covariant orthonormal perfect-fluid component matrix is assembled | Positive-orientation and nondegeneracy hypotheses for the geometric reading; spatial gradients and fluxes; arbitrary coframe variations; graph localization; the scalar equation of motion; Lorentz/Noether identities; covariant conservation |
| Flat-FLRW lapse stationarity is equivalent to the first Friedmann equation | T\|H [comp/import] | Assuming the standard boundary-reduced Einstein-Hilbert minisuperspace action, adding the constructed homogeneous scalar action and varying the lapse gives exactly (H^2=(8\pi G/3)\rho+\Lambda/3), with a nondegenerate positive-matter witness | Derive the FLRW reduc
```

### 3. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean` [weakField_nonzero_witness]

Score: `0.792`

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

### 4. `PhysicsSM/Draft/NullEdge/GoalIVReconciliationCapstone.lean` [source_equation_route_capstone]

Score: `0.781`

```text
HilbertTerm.D E) =
          Matrix.trace (EinsteinHilbertTerm.Dkin * EinsteinHilbertTerm.Dkin) + EinsteinHilbertTerm.Rfin E) ∧
      (∀ E : ℚ, EinsteinHilbertTerm.Rfin E = 4 * E + 2 * E ^ 2) ∧
      HasDerivAt (fun x : ℚ => Matrix.trace (EinsteinHilbertTerm.D x * EinsteinHilbertTerm.D x)) 0
        EinsteinHilbertTerm.Estar ∧
      EinsteinHilbertTerm.Estar =
        -Matrix.trace (EinsteinHilbertTerm.Dkin * EinsteinHilbertTerm.Dsold) /
          Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold) ∧
      0 < Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold)) ∧
    (TeleparallelSoldering.curvatureLoop = 1 ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
      (∀ g : TeleparallelSoldering.M,
        g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
      (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gPure ≠ 0) ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
        TeleparallelSoldering.nonmetricity TeleparallelSoldering.gGrav ≠ 0) ∧
      TeleparallelSoldering.torsion TeleparallelSoldering.gFlat = 0) ∧
    ((TeleparallelSoldering.curvatureLoop = 1 ∧
        (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
        (∀ g : TeleparallelSoldering.M,
          g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
        (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gPu
```

### 5. `PhysicsSM/Draft/NullEdge/LambdaGravityCosmologyBridge.lean` [gravityUnificationStmt]

Score: `0.777`

```text
nHilbertTerm.Rfin E = 4 * E + 2 * E ^ 2) ∧
      HasDerivAt (fun x : ℚ => Matrix.trace (EinsteinHilbertTerm.D x * EinsteinHilbertTerm.D x)) 0
        EinsteinHilbertTerm.Estar ∧
      EinsteinHilbertTerm.Estar =
        -Matrix.trace (EinsteinHilbertTerm.Dkin * EinsteinHilbertTerm.Dsold) /
          Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold) ∧
      0 < Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold)) ∧
    (TeleparallelSoldering.curvatureLoop = 1 ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
      (∀ g : TeleparallelSoldering.M,
        g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
      (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gPure ≠ 0) ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
        TeleparallelSoldering.nonmetricity TeleparallelSoldering.gGrav ≠ 0) ∧
      TeleparallelSoldering.torsion TeleparallelSoldering.gFlat = 0) ∧
    ((TeleparallelSoldering.curvatureLoop = 1 ∧
        (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
        (∀ g : TeleparallelSoldering.M,
          g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
        (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gPure ≠ 0) ∧
        (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
          TeleparallelSoldering.nonmetricity TeleparallelSoldering.g
```

### 6. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean` [einsteinCoupling]

Score: `0.777`

```text
def einsteinCoupling (G c : ℝ) : ℝ :=
  8 * Real.pi * G / c ^ 4

/-- Standard weak-field `00` component equation after inserting
`G_00 = 2 Laplacian(Phi) / c^2` and `T_00 = rho c^2`. It assumes a
mostly-minus-compatible reduction, a mass-density source, and zero
cosmological term; it does not derive or encode a metric. -/
```

### 7. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [9. Horizons, entropy, and cosmology]

Score: `0.775`

```text
## 9. Horizons, entropy, and cosmology

Null boundaries are natural in both general relativity and the null-edge
framework, but several distinct claims must remain separated.
```

### 8. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [6.2 Thermodynamic route]

Score: `0.775`

```text
### 6.2 Thermodynamic route

Jacobson's continuum argument derives Einstein's equation as an equation of
state by imposing the Clausius relation on every local Rindler horizon, together
with entropy-area proportionality, Unruh temperature, energy flux, and the
Raychaudhuri equation.

The derivation is short enough to display. Choose a local horizon generator
\(k^\mu\), affine parameter \(\lambda\), and an instantaneously stationary cut
with expansion and shear vanishing at the reference event. The null
Raychaudhuri equation then gives, to leading order,

\[
  \theta(\lambda)=-\lambda R_{\mu\nu}k^\mu k^\nu+O(\lambda^2),
\]

so the area change is

\[
  \delta A
    =-\int \lambda R_{\mu\nu}k^\mu k^\nu
      \,d\lambda\,dA.
\]

For entropy density \(\eta\), \(\delta S=\eta\,\delta A\). Near the horizon,
the approximate boost Killing field is
\(\chi^\mu=-\kappa\lambda k^\mu\), so the matter heat flux is

\[
  \delta Q
    =-\kappa\int \lambda T_{\mu\nu}k^\mu k^\nu
      \,d\lambda\,dA.
\]

Using the Unruh temperature \(T=\hbar\kappa/(2\pi)\), the Clausius relation
\(\delta Q=T\delta S\) implies

\[
  R_{\mu\nu}k^\mu k^\nu
    =\frac{2\pi}{\hbar\eta}
      T_{\mu\nu}k^\mu k^\nu
\]

for every null \(k^\mu\). Therefore

\[
  R_{\mu\nu}-\frac{2\pi}{\hbar\eta}T_{\mu\nu}
    =f g_{\mu\nu}
\]

for some scalar \(f\). Stress-energy conservation and the contracted Bianchi
identity then fix \(f=-R/2+\Lambda\). With
\(\eta=1/(4\hbar G)\) in units \(c=k_B=1\), one obtains

\[
  G_{\mu\nu}+\Lambda g_{\mu\nu}=8\pi G T_{\mu\nu}.
\]

This is **T|H [import]**: the conclusion is Einstein's equation, but every
local-horizon, equilibrium, area-entropy, Unruh, Raychaudhuri, and conservation
hypothesis matters. It is attractive for null edges because the contraction is
tested in every null direct
```

## Scoped paper hits

### 1. Non-equilibrium thermodynamics of spacetime

Score: `0.772`
Zotero key: `E77VUBZI`
arXiv: `gr-qc/0602001`
DOI: `10.1103/PhysRevLett.96.121301`
URL: https://www.zotero.org/19894138/items/E77VUBZI

Abstract:

It has previously been shown that the Einstein equation can be derived from the requirement that the Clausius relation dS = dQ/T hold for all local acceleration horizons through each spacetime point, where dS is one quarter the horizon area change in Planck units, and dQ and T are the energy flux across the horizon and Unruh temperature seen by an accelerating observer just inside the horizon. Here we show that a curvature correction to the entropy that is polynomial in the Ricci scalar requires a non-equilibrium treatment. The corresponding field equation is derived from the entropy balance relation dS =dQ/T+dS_i, where dS_i is a bulk viscosity entropy production term that we determine by imposing energy-momentum conservation. Entropy production can also be included in pure Einstein theory by allowing for shear viscosity of the horizon.

### 2. General Relativity from a Thermodynamic Perspective

Score: `0.754`
Zotero key: `5DVPDP6J`
arXiv: `1312.3253`
DOI: `10.1007/s10714-014-1673-7`
URL: https://www.zotero.org/19894138/items/5DVPDP6J

Abstract:

I show that the gravitational dynamics in a bulk region of space can be connected to a thermodynamic description in the boundary of that region, thereby providing clear physical interpretations of several mathematical features of classical general relativity: (1) The Noether charge contained in a bulk region, associated with a specific time evolution vector field, has a direct thermodynamic interpretation as the gravitational heat content of the boundary surface. (2) This result, in turn, shows that all static spacetimes maintain holographic equipartition in the following sense: In these spacetimes, the number of degrees of freedom in the boundary is equal to the number of degrees of freedom in the bulk. (3) In a general, evolving spacetime, the rate of change of gravitational momentum is related to the difference between the number of bulk and boundary degrees of freedom. It is this departure from the holographic equipartition which drives the time evolution of the spacetime. (4) When the equations of motion hold, the (naturally defined) total energy of the gravity plus matter within a bulk region, will be equal to the boundary heat content. (5) After motivating the need for an alternate description of gravity (if we have to solve the cosmological constant problem), I describe a thermodynamic variational principle based on null surfaces to achieve this goal. The concept of gravitational heat density of the null surfaces arises naturally from the Noether charge associated with the null congruence. The variational principle, in fact, extremises the total heat content of the matter plus gravity system. Several variations on this theme and implications are described.

### 3. Noise kernel in stochastic gravity and stress energy bitensor of quantum fields in curved spacetimes

Score: `0.751`
Zotero key: `5T5BQ6PT`
DOI: `10.1103/physrevd.63.104001`

### 4. Thermodynamics of space-time: The Einstein equation of state

Score: `0.744`
Zotero key: `EXN2NMZJ`
arXiv: `gr-qc/9504004`
DOI: `10.1103/PhysRevLett.75.1260`
URL: https://www.zotero.org/19894138/items/EXN2NMZJ

Abstract:

The Einstein equation is derived from the form of black hole entropy together with the fundamental relation $\delta Q=TdS$ connecting heat, entropy, and temperature. The key idea is to demand that this relation hold for all the local Rindler horizons through each spacetime point. Viewed in this way, the Einstein equation is an equation of state. It is born in the thermodynamic limit as a relation between thermodynamic variables, and its validity is seen to depend on the existence of local equilibrium conditions. As such there is no reason to think the gravitational field equations should be quantized, i.e., promoted to operator relations.

### 5. Stochastic Gravity: Theory and Applications

Score: `0.736`
Zotero key: `TXN5JSZ5`
DOI: `10.12942/lrr-2008-3`
URL: https://doi.org/10.12942/lrr-2008-3
