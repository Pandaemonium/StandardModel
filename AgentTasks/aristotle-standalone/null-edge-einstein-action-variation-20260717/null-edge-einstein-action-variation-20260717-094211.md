# Aristotle semantic context pack

Generated: 2026-07-17T09:42:56
Query: `null-edge interval-count gravity action Einstein-Hilbert first metric variation stationarity Einstein equation variation-limit interchange`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/context-packs/null-edge-stress-energy-controls-v2-20260714-20260715-000126.md` [1. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [10. Current theorem ledger]]

Score: `0.818`

```text
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
| Dust and radiation density laws satisfy scal
```

### 2. `AgentTasks/context-packs/null-edge-flat-flrw-acceleration-20260715-20260715-030842.md` [1. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [10. Current theorem ledger]]

Score: `0.813`

```text
### 1. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [10. Current theorem ledger]

Score: `0.849`

```text
rspace action, adding the constructed homogeneous scalar action and varying the lapse gives exactly (H^2=(8\pi G/3)\rho+\Lambda/3), with a nondegenerate positive-matter witness | Derive the FLRW reduction, Einstein-Hilbert action, lapse, scale factor, (G), and (Lambda) from graph data; add the acceleration equation and inhomogeneous dynamics |
| The standard weak-field `00` reduction with \(8\pi G/c^4\) is equivalent to Poisson normalization | M [comp] | Exact constant arithmetic with a nonzero witness | Derive the linearized Einstein component and nonrelativistic source from null-edge dynamics |
| Dust and radiation density laws satisfy scale-factor FLRW continuity | M [comp] | Exact derivative and conservation checks for \(\rho\sim a^{-3}\) and \(\rho\sim a^{-4}\) | Derive homogeneous geometry, Friedmann dynamics, and the equations of state from the model |
| Gravity emerges from entropy monotonicity on nested causal regions | C [orig] | Research route only | Raychaudhuri, area law, all-null-direction theorem |
| The null-edge framework reproduces Einstein's equation | C [orig] | Not established | Full reconstruction ladder below |
```
```

### 3. `PhysicsSM/Draft/NullEdge/GoalIVReconciliationCapstone.lean`

Score: `0.811`

```text
namespace GoalIVReconciliationCapstone

/-- **Variational route capstone.**  Bundles the finite spectral-action variation
lane: one action `S(E,g)`, its closed form, the gravity (`dS/dE = 0`) and matter
(`dS/dg = 0`) field equations, their coupled joint stationary point `(-1,-1)`, and
the fact that the two variations are genuinely distinct.  Every conjunct is an
imported proof term from `UnifiedActionVariation`. -/
```

### 4. `AgentTasks/context-packs/null-edge-flat-flrw-friedmann-20260715-20260715-021520.md` [2. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [10. Current theorem ledger]]

Score: `0.809`

```text
### 2. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [10. Current theorem ledger]

Score: `0.818`

```text
rspace action, adding the constructed homogeneous scalar action and varying the lapse gives exactly (H^2=(8\pi G/3)\rho+\Lambda/3), with a nondegenerate positive-matter witness | Derive the FLRW reduction, Einstein-Hilbert action, lapse, scale factor, (G), and (Lambda) from graph data; add the acceleration equation and inhomogeneous dynamics |
| The standard weak-field `00` reduction with \(8\pi G/c^4\) is equivalent to Poisson normalization | M [comp] | Exact constant arithmetic with a nonzero witness | Derive the linearized Einstein component and nonrelativistic source from null-edge dynamics |
| Dust and radiation density laws satisfy scale-factor FLRW continuity | M [comp] | Exact derivative and conservation checks for \(\rho\sim a^{-3}\) and \(\rho\sim a^{-4}\) | Derive homogeneous geometry, Friedmann dynamics, and the equations of state from the model |
| Gravity emerges from entropy monotonicity on nested causal regions | C [orig] | Research route only | Raychaudhuri, area law, all-null-direction theorem |
| The null-edge framework reproduces Einstein's equation | C [orig] | Not established | Full reconstruction ladder below |
```
```

### 5. `PhysicsSM/Draft/NullEdge/GoalIVReconciliationCapstone.lean` [variational_route_capstone]

Score: `0.797`

```text
theorem variational_route_capstone :
    -- `one_action_verdict`: one functional, two field equations
    ((∀ E g : ℝ, UnifiedActionVariation.S E g =
          10 - 8 * UnifiedActionVariation.wComb E g + 2 * (UnifiedActionVariation.wComb E g) ^ 2) ∧
      (∀ g E : ℝ, HasDerivAt (fun E => UnifiedActionVariation.S E g)
          ((-8 + 4 * UnifiedActionVariation.wComb E g) * (3 + g)) E) ∧
      (∀ E g : ℝ, HasDerivAt (fun g => UnifiedActionVariation.S E g)
          ((-8 + 4 * UnifiedActionVariation.wComb E g) * (2 + E)) g) ∧
      (HasDerivAt (fun E => UnifiedActionVariation.S E (-1)) 0 (-1) ∧
        HasDerivAt (fun g => UnifiedActionVariation.S (-1) g) 0 (-1)) ∧
      ((-8 + 4 * UnifiedActionVariation.wComb 0 0) * (3 + 0) ≠ 0 ∧
        (-8 + 4 * UnifiedActionVariation.wComb 0 0) * (2 + 0) ≠ 0)) ∧
    -- `action_closed_form`
    (∀ E g : ℝ, UnifiedActionVariation.S E g =
        10 - 8 * UnifiedActionVariation.wComb E g + 2 * (UnifiedActionVariation.wComb E g) ^ 2) ∧
    -- `gravity_equation`
    (∀ (g E : ℝ), (3 : ℝ) + g ≠ 0 →
        ((-8 + 4 * UnifiedActionVariation.wComb E g) * (3 + g) = 0 ↔ E = (-4 - 2 * g) / (3 + g))) ∧
    -- `matter_equation`
    (∀ (E g : ℝ), (2 : ℝ) + E ≠ 0 →
        ((-8 + 4 * UnifiedActionVariation.wComb E g) * (2 + E) = 0 ↔ g = (-4 - 3 * E) / (2 + E))) ∧
    -- `coupled_stationary_point`
    ((-8 + 4 * UnifiedActionVariation.wComb (-1) (-1)) * (3 + (-1)) = 0 ∧
      (-8 + 4 * UnifiedActionVariation.wComb (-1) (-1)) * (2 + (-1)) = 0 ∧
      (-1 : ℝ) = (-4 - 2 * (-1)) / (3 + (-1)) ∧
      (-1 : ℝ) = (-4 - 3 * (-1)) / (2 + (-1))) ∧
    -- `derivatives_distinct`
    ((-8 + 4 * UnifiedActionVariation.wComb 0 0) * (3 + 0) ≠
      (-8 + 4 * UnifiedActionVariation.wComb 0 0) * (2 + 0)) :=
  ⟨UnifiedActionVariation.one_action_verdict,
    UnifiedAct
```

### 6. `AgentTasks/context-packs/null-edge-adm-shift-scalar-flux-20260715-20260715-030830.md` [5. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G6. Source and conservation]]

Score: `0.795`

```text
### 5. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G6. Source and conservation]

Score: `0.764`

```text
riation are equal. The diagonal probes carry a harmless factor of two over
\(\mathbb R\). This proves coefficient uniqueness if an actual first variation
has already been represented by that pairing. The theorem contains no spacetime
integral, volume density, localization, or covariance theorem. The open problem
is to construct the localized measure-normalized derivative from the null-edge
matter action and derive its on-shell Noether conservation law.

One restricted construction now goes beyond uniqueness. On a single
homogeneous diagonal `(+---)` cell, the scalar matter action includes both the
oriented determinant `N a_1 a_2 a_3` and inverse metric component
`g^{00}=N^{-2}`.
Its reduced form is

\[
  S_m=a_1a_2a_3\left(\frac{\dot\phi^2}{2N}-NV\right).
\]

Varying the lapse gives `-a_1a_2a_3 rho`, while varying `a_i` gives `N` times
the oriented opposite-face factor times `p`, with

\[
  \rho=\frac{\dot\phi^2}{2N^2}+V,
  \qquad
  p=\frac{\dot\phi^2}{2N^2}-V.
\]

All four derivatives come from the same checked action. The usual
`sqrt(-g)` reading additionally requires the positive-orientation sector
`N a_1a_2a_3>0`, and a nondegenerate Lorentzian metric requires every diagonal
coframe scale to be nonzero. The assembled matrix `diag(rho,p,p,p)` records
covariant orthonormal components; the normalized coframe responses instead
couple to the mixed components `diag(rho,-p,-p,-p)`. Zero displayed flux is a
fact about the assembled definition, not a result of an off-diagonal
variation. This is a genuine measure-aware diagonal response, but only in the
homogeneous sector. It does not yet supply spatial gradients, off-diagonal
responses, graph loca
```

### 7. `AgentTasks/context-packs/null-edge-diagonal-scalar-gradient-stress-20260715-20260715-023314.md` [4. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [10. Current theorem ledger]]

Score: `0.794`

```text
### 4. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [10. Current theorem ledger]

Score: `0.788`

```text
invertible matrix witness with noncommuting source/coupling | Construct the Einstein operator, contracted Bianchi theorem, variational stress tensor, and universal coupling |
| Scalar matter budgets do not determine stress-energy | M [orig] | Explicit distinct symmetric four-tensors with equal rest energy density or equal ordinary matrix trace | Construct the full metric/coframe variation, including pressures and fluxes |
| A full symmetric component response determines its symmetric coefficient tensor uniquely | M [orig] | Equality of finite Frobenius response on every symmetric probe forces matrix equality | Prove the null-edge matter action has the corresponding localized, measure-normalized derivative and satisfies the Noether identity |
| A homogeneous scalar one-cell action yields density and pressure from distinct diagonal responses | M [comp] | The action includes the oriented diagonal coframe determinant and inverse lapse; lapse variation gives minus the oriented spatial-volume factor times `rho`, each spatial-scale variation gives lapse times an oriented opposite-face factor times `p`, and a nonzero covariant orthonormal perfect-fluid component matrix is assembled | Positive-orientation and nondegeneracy hypotheses for the geometric reading; spatial gradients and fluxes; arbitrary coframe variations; graph localization; the scalar equation of motion; Lorentz/Noether identities; covariant conservation |
| Flat-FLRW lapse stationarity is equivalent to the first Friedmann equation | T\|H [comp/import] | Assuming the standard boundary-reduced Einstein-Hilbert minisuperspace action, adding the constructed homogeneous scalar action and var
```

### 8. `AgentTasks/context-packs/null-edge-diagonal-scalar-gradient-stress-20260715-20260715-023314.md` [2. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G6. Source and conservation]]

Score: `0.794`

```text
### 2. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G6. Source and conservation]

Score: `0.795`

```text
riation are equal. The diagonal probes carry a harmless factor of two over
\(\mathbb R\). This proves coefficient uniqueness if an actual first variation
has already been represented by that pairing. The theorem contains no spacetime
integral, volume density, localization, or covariance theorem. The open problem
is to construct the localized measure-normalized derivative from the null-edge
matter action and derive its on-shell Noether conservation law.

One restricted construction now goes beyond uniqueness. On a single
homogeneous diagonal `(+---)` cell, the scalar matter action includes both the
oriented determinant `N a_1 a_2 a_3` and inverse metric component
`g^{00}=N^{-2}`.
Its reduced form is

\[
  S_m=a_1a_2a_3\left(\frac{\dot\phi^2}{2N}-NV\right).
\]

Varying the lapse gives `-a_1a_2a_3 rho`, while varying `a_i` gives `N` times
the oriented opposite-face factor times `p`, with

\[
  \rho=\frac{\dot\phi^2}{2N^2}+V,
  \qquad
  p=\frac{\dot\phi^2}{2N^2}-V.
\]

All four derivatives come from the same checked action. The usual
`sqrt(-g)` reading additionally requires the positive-orientation sector
`N a_1a_2a_3>0`, and a nondegenerate Lorentzian metric requires every diagonal
coframe scale to be nonzero. The assembled matrix `diag(rho,p,p,p)` records
covariant orthonormal components; the normalized coframe responses instead
couple to the mixed components `diag(rho,-p,-p,-p)`. Zero displayed flux is a
fact about the assembled definition, not a result of an off-diagonal
variation. This is a genuine measure-aware diagonal response, but only in the
homogeneous sector. It does not yet supply spatial gradients, off-diagonal
responses, graph loca
```

## Scoped paper hits

### 1. General Relativity from a Thermodynamic Perspective

Score: `0.763`
Zotero key: `5DVPDP6J`
arXiv: `1312.3253`
DOI: `10.1007/s10714-014-1673-7`
URL: https://www.zotero.org/19894138/items/5DVPDP6J

Abstract:

I show that the gravitational dynamics in a bulk region of space can be connected to a thermodynamic description in the boundary of that region, thereby providing clear physical interpretations of several mathematical features of classical general relativity: (1) The Noether charge contained in a bulk region, associated with a specific time evolution vector field, has a direct thermodynamic interpretation as the gravitational heat content of the boundary surface. (2) This result, in turn, shows that all static spacetimes maintain holographic equipartition in the following sense: In these spacetimes, the number of degrees of freedom in the boundary is equal to the number of degrees of freedom in the bulk. (3) In a general, evolving spacetime, the rate of change of gravitational momentum is related to the difference between the number of bulk and boundary degrees of freedom. It is this departure from the holographic equipartition which drives the time evolution of the spacetime. (4) When the equations of motion hold, the (naturally defined) total energy of the gravity plus matter within a bulk region, will be equal to the boundary heat content. (5) After motivating the need for an alternate description of gravity (if we have to solve the cosmological constant problem), I describe a thermodynamic variational principle based on null surfaces to achieve this goal. The concept of gravitational heat density of the null surfaces arises naturally from the Noether charge associated with the null congruence. The variational principle, in fact, extremises the total heat content of the matter plus gravity system. Several variations on this theme and implications are described.

### 2. Entanglement Equilibrium and the Einstein Equation

Score: `0.760`
Zotero key: `7V9FV86B`
arXiv: `1505.04753`
DOI: `10.1103/PhysRevLett.116.201101`
URL: https://www.zotero.org/19894138/items/7V9FV86B

Abstract:

A link between the semiclassical Einstein equation and a maximal vacuum entanglement hypothesis is established. The hypothesis asserts that entanglement entropy in small geodesic balls is maximized at fixed volume in a locally maximally symmetric vacuum state of geometry and quantum fields. A qualitative argument suggests that the Einstein equation implies the validity of the hypothesis. A more precise argument shows that, for first-order variations of the local vacuum state of conformal quantum fields, the vacuum entanglement is stationary if and only if the Einstein equation holds. For nonconformal fields, the same conclusion follows modulo a conjecture about the variation of entanglement entropy.

### 3. Thermodynamics of space-time: The Einstein equation of state

Score: `0.754`
Zotero key: `EXN2NMZJ`
arXiv: `gr-qc/9504004`
DOI: `10.1103/PhysRevLett.75.1260`
URL: https://www.zotero.org/19894138/items/EXN2NMZJ

Abstract:

The Einstein equation is derived from the form of black hole entropy together with the fundamental relation $\delta Q=TdS$ connecting heat, entropy, and temperature. The key idea is to demand that this relation hold for all the local Rindler horizons through each spacetime point. Viewed in this way, the Einstein equation is an equation of state. It is born in the thermodynamic limit as a relation between thermodynamic variables, and its validity is seen to depend on the existence of local equilibrium conditions. As such there is no reason to think the gravitational field equations should be quantized, i.e., promoted to operator relations.

### 4. Noise kernel in stochastic gravity and stress energy bitensor of quantum fields in curved spacetimes

Score: `0.750`
Zotero key: `5T5BQ6PT`
DOI: `10.1103/physrevd.63.104001`

### 5. Stochastic Gravity: Theory and Applications

Score: `0.747`
Zotero key: `TXN5JSZ5`
DOI: `10.12942/lrr-2008-3`
URL: https://doi.org/10.12942/lrr-2008-3
