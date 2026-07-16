# Aristotle semantic context pack

Generated: 2026-07-14T21:13:52
Query: `null-edge finite gravitational field equation contracted Bianchi identity universal parallel coupling source stress energy covariant conservation commutator`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [10. Current theorem ledger]

Score: `0.828`

```text
able | Curvature normalization and continuum limit |
| Finite tetrad postulate implies Clifford-metric and curvature compatibility | M [orig] | Exact commutator identities | Rotating labels, bundle reconstruction, and convergence |
| Finite commutator curvature obeys cyclic adjoint Bianchi | M [orig] | Exact Jacobi identity | Geometric and contracted Bianchi limits |
| Fixed-label Cartan torsion obeys the torsionful first-Bianchi shape | M [orig] | Exact cyclic derivative/curvature-action identity and torsion-free corollary | Graded cochains, local labels, anholonomy, and 3-cell content |
| Null-soldered Dirac square splits into Gram and commutator sectors | M [orig] | Exact finite Weitzenbock-shaped identity | Continuum Lichnerowicz identification |
| Finite connection identities compose with the tetrad-specialized Lichnerowicz square | M [orig] | One guarded G3/G4/G5 theorem chain | Principal-symbol and curvature-coefficient convergence |
| Finite stationarity, source, and Clausius avatars | M [orig] | Nonvacuous finite equations | Einstein tensor and conserved stress tensor |
| One finite symmetry hypothesis transports mass-shell solutions and conserves an operator expectation | M [orig] | Exact finite Noether link | Spacetime symmetry, local current, and stress-tensor conservation |
| Gravity emerges from entropy monotonicity on nested causal regions | C [orig] | Research route only | Raychaudhuri, area law, all-null-direction theorem |
| The null-edge framework reproduces Einstein's equation | C [orig] | Not established | Full reconstruction ladder below |
```

### 2. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [7. Matter, source, and the equivalence principle]

Score: `0.817`

```text
## 7. Matter, source, and the equivalence principle

The finite carrier separates aperture, closure, turn, and soldering sectors.
The repository also contains explicit finite actions in which a soldering
response is sourced by a sum of matter-channel budgets with a channel-blind
coupling. These are **M [orig]** finite weak-equivalence-principle avatars.

There is also an **M [orig]** finite Noether link in
`FiniteDynamicsNoetherThermoCapstone.lean`. For a self-adjoint finite operator
\(A\) and a unitary \(U\) commuting with it, the same commutation hypothesis
both transports mass-shell solutions to solutions with the same eigenvalue and
conserves the real \(A\)-expectation along the complete discrete \(U\)-orbit.
This is a real symmetry/conservation theorem, but its conserved observable is
not a spacetime stress tensor and the orbit parameter is not yet reconstructed
proper time.

Continuum gravitational sourcing requires substantially more:

1. a local stress-energy tensor obtained by variation with respect to the
   reconstructed coframe or metric;
2. a proof of covariant conservation,
   \(\nabla_\mu T^{\mu\nu}=0\);
3. a discrete Bianchi or Noether identity whose limit gives
   \(\nabla_\mu G^{\mu\nu}=0\);
4. universal coupling before taking traces or expectation values;
5. agreement with the matter equations of motion;
6. weak-field and equivalence-principle tests.

A scalar budget equality is not yet a tensor field equation. The project
charter correctly requires gravity to remain a constrained quotient until a
covariant conserved source exists.
```

### 3. `NULL_EDGE_RESULTS.md` [10. Carrier-layer results (2026-07-07 update)]

Score: `0.814`

```text
bels, not a continuum Riemann tensor,
  contracted Bianchi identity, conserved stress tensor, or Einstein equation.
  The companion `NondegenerateSolderingGeometry` module proves that zero
  matrix-coframe defect is exactly parallel transport, that an internally
  Lorentz edge then preserves the induced metric, and that zero-defect metric
  preservation composes across two edges. `FiniteCartanBianchi.lean` adds the
  torsionful fixed-label Cartan identity
  `D_a T_bc + cyclic = [F_ab,E_c] + cyclic`, its torsion-free cyclic-curvature
  corollary, and a paired first/second algebraic Bianchi theorem. It does not
  yet supply graded cellular cochains, local frame rotations, anholonomic
  structure coefficients, or nonvacuous 3-cell content.
- **Finite Noether link (finite identity).**
  `FiniteDynamicsNoetherThermoCapstone.action_symmetry_conservation_packet`
  proves that one unitary-commutation hypothesis both transports finite
  mass-shell solutions at fixed eigenvalue and conserves the corresponding
  real operator expectation along the discrete orbit. This is not a local
  stress-energy current, diffeomorphism Noether identity, or proof of
  covariant source conservation.
- **Closure-current square algebra, abstract rung (finite identity,
  2026-07-08 early).**
  In the GateYM lane, `S1ClosureCurrentAlgebra.closure_current_square`
  proves that a two-direction null-soldered current with skew transport pairing
  has square `2 * b * A^#B`: a signed chromomagnetic channel, with no PSD
  diagonal claim. The new guarded rung
  `S1ClosureCurrentAlgebra.closure_current_square_pi` lifts this componentwise
  to an arbitrary indexed pointwise-product target; by itself this is plumbing,
  not a carrier cross-term theorem. The same module now
  includes `finiteProductForm_componen
```

### 4. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G6. Source and conservation]

Score: `0.814`

```text
### G6. Source and conservation

Define the matter action on the same reconstructed geometry and vary it with
respect to the coframe.

**Success:** a local symmetric or convention-appropriate stress tensor with
covariant conservation.  
**Kill:** channel-dependent gravitational coupling or failure of the discrete
Noether/Bianchi identity.
```

### 5. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [6.2 Thermodynamic route]

Score: `0.805`

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

### 6. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [12.4 Conservation, motion, and clocks]

Score: `0.797`

```text
### 12.4 Conservation, motion, and clocks

Once the limiting gravitational action is diffeomorphism invariant, the
contracted Bianchi identity and the matter Noether identity give

\[
  \nabla_\mu T^{\mu\nu}=0.
\]

Universal coupling then supplies the standard equivalence-principle route to
geodesic motion for suitable test bodies, with the usual qualifications for
spin and finite size. Proper time is no longer an additional primitive:

\[
  \tau[\gamma]
    =\frac1c\int_\gamma
       \sqrt{g_{\mu\nu}\,dx^\mu dx^\nu}.
\]

The null-tick formula of Section 2 is the flat, coarse-grained kinematic
prototype of this reconstructed functional.
```

### 7. `PhysicsSM/Draft/NullEdge/LambdaGravityCosmologyBridge.lean` [gravityResourcePacketStmt]

Score: `0.786`

```text
def gravityResourcePacketStmt : Prop :=
  -- `GravityUnificationCapstone.finite_gravity_nondegeneracy_bundle`
  ((Goal4FieldEquation.Qform 1 1 = 0 ∧
      (Goal4FieldEquation.Mmat 2 3 *ᵥ ![(1 : ℝ), 1] =
        (-6 : ℝ) • (Goal4FieldEquation.eta *ᵥ ![1, 1])) ∧ (-6 : ℝ) ≠ 0) ∧
    (GravitySourceMatter.matterBudget ![1, 0] ≠ 0 ∧
      GravitySourceMatter.solderingCurv 1 ≠ 0 ∧ (GravitySourceMatter.kappa : ℝ) ≠ 0 ∧
      GravitySourceMatter.solderingCurv 1 =
        (GravitySourceMatter.kappa : ℝ) * (GravitySourceMatter.matterBudget ![1, 0] : ℝ) ∧
      GravitySourceMatter.solderingCurv 1 = 18) ∧
    (JacobsonClausius.FieldEq ((1 : ℝ), (1 : ℝ)) ∧
      deriv (fun t => JacobsonClausius.heat
          (JacobsonClausius.path ((1 : ℝ), (1 : ℝ)) ((1 : ℝ), (0 : ℝ)) t)) 0 =
        JacobsonClausius.temp *
          deriv (fun t => JacobsonClausius.entropy
            (JacobsonClausius.path ((1 : ℝ), (1 : ℝ)) ((1 : ℝ), (0 : ℝ)) t)) 0 ∧
      deriv (fun t => JacobsonClausius.heat
          (JacobsonClausius.path ((1 : ℝ), (1 : ℝ)) ((1 : ℝ), (0 : ℝ)) t)) 0 ≠ 0) ∧
    (0 < Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold)) ∧
    (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
      TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
    (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
      TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
      TeleparallelSoldering.curvatureLoop = 1 ∧
      GravitySourceMatter.solderingCurv 1 = 18 ∧
      (GravitySourceMatter.matterBudget ![1, 0] ≠ 0 ∧
        GravitySourceMatter.solderingCurv 1 ≠ 0 ∧ (GravitySourceMatter.kappa : ℝ) ≠ 0 ∧
        GravitySourceMatter.solderingCurv 1 =
          (GravitySourceMatter.kappa : ℝ) * (
```

### 8. `PhysicsSM/Draft/NullEdge/LambdaGravityCosmologyBridge.lean` [gravityResourcePacketStmt]

Score: `0.785`

```text
Budget ![1, 0] ≠ 0 ∧
        GravitySourceMatter.solderingCurv 1 ≠ 0 ∧ (GravitySourceMatter.kappa : ℝ) ≠ 0 ∧
        GravitySourceMatter.solderingCurv 1 =
          (GravitySourceMatter.kappa : ℝ) * (GravitySourceMatter.matterBudget ![1, 0] : ℝ) ∧
        GravitySourceMatter.solderingCurv 1 = 18) ∧
      (Goal4FieldEquation.Qform 1 1 = 0 ∧
        (Goal4FieldEquation.Mmat 2 3 *ᵥ ![(1 : ℝ), 1] =
          (-6 : ℝ) • (Goal4FieldEquation.eta *ᵥ ![1, 1])) ∧ (-6 : ℝ) ≠ 0)) ∧
    (0 < HolographicEdgeBound.edges ∧
      0 < Module.finrank ℚ HolographicEdgeBound.Phys ∧
      Module.finrank ℚ HolographicEdgeBound.Phys ≤ HolographicEdgeBound.edges) ∧
    ((∃ P : MassEntropyMonotone.FutureConeMomentum,
        MassEntropyMonotone.massEntropyMonotone.value P = 0) ∧
      (∃ P : MassEntropyMonotone.FutureConeMomentum,
        0 < MassEntropyMonotone.massEntropyMonotone.value P))) ∧
  -- `GravityUnificationCapstone.finite_gravity_claim_boundary`
  ((MinkowskiConvention.eta 0 0 : ℚ) = 1
    ∧ (MinkowskiConvention.eta 1 1 : ℚ) = -1
    ∧ TeleparallelSoldering.curvatureLoop = 1
    ∧ TeleparallelSoldering.torsion TeleparallelSoldering.gFlat = 0
    ∧ EinsteinHilbertTerm.Rfin EinsteinHilbertTerm.Estar = -2
    ∧ JacobsonClausius.FieldEq ((1 : ℝ), (1 : ℝ))) ∧
  -- `UnifiedActionCapstone.finite_unification_nonvacuous`
  ((∃ gM gG : ℚ, gM ≠ 0 ∧ gG ≠ 0
      ∧ ((SpectralActionAvatar.D 2 1 3 5 ^ 2).trace - 6 = gG)
      ∧ ((SpectralActionAvatar.D 2 1 3 5 ^ 4).trace
            - (SpectralActionAvatar.D 2 0 0 0 ^ 4).trace = gM))
      ∧ (∃ bE : ℚ, bE ≠ 0 ∧ bE = UnifiedMassBudget.bE)
      ∧ (∃ g : ℝ, g ≠ 0 ∧ GravitySourceMatter.solderingCurv 1 = g)
      ∧ (∃ gamma : ℝ × ℝ, JacobsonClausius.FieldEq gamma)) ∧
  -- `HolographicResourceCapstone.positive_boundary_nonvacuity_bundle`
  (0 < Holograp
```

## Scoped paper hits

### 1. Noise kernel in stochastic gravity and stress energy bitensor of quantum fields in curved spacetimes

Score: `0.751`
Zotero key: `5T5BQ6PT`
DOI: `10.1103/physrevd.63.104001`

### 2. Quantum-gravitational null Raychaudhuri equation

Score: `0.739`
Zotero key: `SIVSBCMC`
arXiv: `2312.17214`
DOI: `10.1007/JHEP07(2024)214`
URL: https://www.zotero.org/19894138/items/SIVSBCMC

Abstract:

We consider a congruence of null geodesics in the presence of a quantized spacetime metric. The coupling to a quantum metric induces fluctuations in the congruence; we calculate the change in the area of a pencil of geodesics induced by such fluctuations. For the gravitational field in its vacuum state, we find that quantum gravity contributes a correction to the null Raychaudhuri equation which is of the same sign as the classical terms. We thus derive a quantum-gravitational focusing theorem valid for linearized quantum gravity.

### 3. Emergent Gravity requires (kinematic) non-locality

Score: `0.732`
Zotero key: `PCHEN9K7`
arXiv: `1409.2509`
DOI: `10.1103/PhysRevLett.114.031104`
URL: http://arxiv.org/abs/1409.2509

Abstract:

This work refines arguments forbidding non-linear dynamical gravity from appearing in the low energy effective description of field theories with local kinematics, even for those with instantaneous long-range interactions. Specifically, we note that gravitational theories with universal coupling to energy -- an intrinsically non-linear phenomenon -- are characterized by Hamiltonians that are pure boundary terms on shell. In order for this to be the low energy effective description of a field theory with local kinematics, all bulk dynamics must be frozen and thus irrelevant to the construction. The result applies to theories defined either on a lattice or in the continuum, and requires neither Lorentz-invariance nor translation-invariance.

### 4. Non-equilibrium thermodynamics of spacetime

Score: `0.731`
Zotero key: `E77VUBZI`
arXiv: `gr-qc/0602001`
DOI: `10.1103/PhysRevLett.96.121301`
URL: https://www.zotero.org/19894138/items/E77VUBZI

Abstract:

It has previously been shown that the Einstein equation can be derived from the requirement that the Clausius relation dS = dQ/T hold for all local acceleration horizons through each spacetime point, where dS is one quarter the horizon area change in Planck units, and dQ and T are the energy flux across the horizon and Unruh temperature seen by an accelerating observer just inside the horizon. Here we show that a curvature correction to the entropy that is polynomial in the Ricci scalar requires a non-equilibrium treatment. The corresponding field equation is derived from the entropy balance relation dS =dQ/T+dS_i, where dS_i is a bulk viscosity entropy production term that we determine by imposing energy-momentum conservation. Entropy production can also be included in pure Einstein theory by allowing for shear viscosity of the horizon.

### 5. On the definition of spacetimes in Noncommutative Geometry, Part I

Score: `0.730`
Zotero key: `5VWPZ8BP`
arXiv: `1611.07830`
DOI: `10.48550/arXiv.1611.07830`
URL: https://arxiv.org/abs/1611.07830

Abstract:

Part I develops Lorentzian spectral-spacetime foundations in the commutative continuous case, including signature characterization by time-orientation one-forms and a Krein product on spinors.
