# Null-edge super-Dirac conjecture attack plan

Date: 2026-06-23

## Goal

Answer the corrected finite super-Dirac conjecture:

```text
D_{U,Phi} = d_U + delta_U + Phi + Phi^dagger
```

should be a natural Lorentzian/Krein first-order operator on a finite causal
order complex. Its square should contain:

- a kinetic graph Dirac/Laplacian block whose symbol on bundle momentum `P` is
  the trusted Pluecker determinant `det(P)`;
- a causal-diamond curvature block from `d_U^2`;
- a Higgs/Yukawa mass block `Phi^dagger Phi`;
- a gauged Higgs kinetic cross term;
- an on-shell equality, not an additive double count:

```text
kinetic Pluecker symbol det(P) = Yukawa square Phi^dagger Phi.
```

## Correction from the 2026-06-23 critique

The old target "visible Pluecker scalar block plus Yukawa mass block" double
counts mass. The new target is:

```text
kinetic block symbol = det(P)
Yukawa block         = Phi^dagger Phi
mass shell           = det(P) = Phi^dagger Phi
```

The operator should also be Lorentzian. Ordinary positive-definite
self-adjointness is not enough; the target is finite `J`-self-adjointness over a
Krein form.

## Banked theorem pieces

- `PhysicsSM.Spinor.PluckerMass`
  - finite bundle determinant / Pluecker theorem.
- `PhysicsSM.Draft.NullEdgeDiracSlashCore`
  - chiral Dirac slash square in `(+---)` conventions.
- `PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore`
  - bundle momentum slash square equals trusted Pluecker mass.
- `PhysicsSM.Draft.NullEdgeDiracTwoSheetCore`
  - branch projectors from `D^2 = m^2 I`.
- `PhysicsSM.Draft.NullEdgeDiracMassShellProjectorsCore`
  - concrete chiral slash branch projectors on mass shell.
- `PhysicsSM.Draft.NullEdgeSuperDiracBlockCore`
  - off-diagonal block square and chirality anticommutation.
- `PhysicsSM.Draft.NullEdgeSuperconnectionExpansionCore`
  - square expansion into Laplacian, cross, and mass blocks.
- `PhysicsSM.Draft.NullEdgeCovariantDifferentialCore`
  - scalar triangle curvature from `d_U^2`.
- `PhysicsSM.Gauge.CausalDiamondHolonomy`
  - diamond holonomy invariance and composition.
- `PhysicsSM.Draft.NullEdgeYukawaMassOperator`
  - finite scalar Yukawa flip anticommutes with chirality and squares to
    `m^2`.
- `PhysicsSM.Draft.NullEdgeSuperDiracKreinCore`
  - new finite `J`-self-adjointness predicate, mass-shell `J = (1 / m) D`,
    `J^2 = 1`, branch-projector difference, and `MassShellConstraint`.

## Literature anchors added this pass

Added to Zotero collection `9W59V3K9` and linked in Neo4j under
`null-edge-super-dirac-krein-lorentzian-audit`:

- `5DURW8DU`: van den Dungen, *Families of spectral triples and foliations of
  space(time)*.
- `PM83B8QI`: Bizi, Brouder, Besnard, *Space and time dimensions of algebras
  with applications to Lorentzian noncommutative geometry and quantum
  electrodynamics*.
- `5VWPZ8BP`: Besnard and Bizi, *On the definition of spacetimes in
  Noncommutative Geometry, Part I*.
- `5RJUDATF`: Devastato, Farnsworth, Lizzi, Martinetti, *Lorentz signature and
  twisted spectral triples*.
- `Q6R3PCGJ`: Martinetti and Singh, *Lorentzian fermionic action by twisting
  Euclidean spectral triples*.

## Dependency-ordered proof program

### Layer 1: finite Krein / grading surface

Already started in `NullEdgeSuperDiracKreinCore`.

Next targets:

```lean
productGrading_anticommutes_externalBlock
productGrading_anticommutes_internalBlock
gradedTensorSum_is_odd
kreinAdjoint_of_unitaryTransport
kreinSelfAdjoint_superDirac_of_unitaryTransport
```

Key hypothesis to make explicit: transport `U` must be unitary. Non-unitary
transport breaks even the Krein-adjoint story.

### Layer 2: no double-count mass-shell bridge

Already started by `MassShellConstraint`.

Next targets:

```lean
superDiracSq_kineticSymbol_eq_pluckerDet
massShell_kinetic_eq_yukawa
noDoubleCount_laplacianSymbol_plusYukawa_is_constraint_not_sum
```

This layer should import `NullEdgeBundleDiracPluckerCore` and
`NullEdgeYukawaMassOperator`, but it should not assemble the full
superconnection yet.

### Layer 3: cross term equals Higgs kinetic term

Existing expansion theorem:

```lean
finiteSuperconnection_sq_leftBlock
finiteSuperconnection_sq_rightBlock
```

already exposes cross terms. The next step is naming them:

```lean
leftCrossTerm_eq_deltaPhi_plus_psiD
rightCrossTerm_eq_dPsi_plus_phiDelta
superDiracSq_crossTerm_eq_gaugedHiggsKinetic
crossTerm_zero_iff_phi_is_covariantly_constant
```

The important conceptual point: do not try to make the cross term disappear
unless the Higgs field is covariantly constant. In the interacting theory it is
the Higgs kinetic/gauge-coupling block.

### Layer 4: diamond holonomy equals curvature block

Existing triangle curvature:

```text
kappa(i,j,k) = U_ij U_jk - U_ik.
```

For a minimal diamond with two paths `p -> a -> q` and `p -> b -> q`, plus a
direct comparison edge `p -> q`, target:

```text
diamond defect = kappa(p,a,q) - kappa(p,b,q)       -- Abelian/additive version
```

or multiplicatively:

```text
Delta = (U_pa U_aq U_pq^{-1}) * (U_pb U_bq U_pq^{-1})^{-1}.
```

Lean targets:

```lean
diamondDefect_eq_triangleCurvature_ratio
diamondHolonomy_linearized_eq_triangleCurvature_difference
covariantOrderDifferential_sq_eq_diamondCurvature
```

The first target should probably be a focused standalone Aristotle job in the
Abelian scalar transport setting.

### Layer 5: assembled theorem

Only after Layers 1-4:

```lean
superDirac_sq_eq_laplacian_plus_curvature_plus_higgs
```

The theorem statement should say:

- kinetic block symbol is Pluecker;
- Yukawa block is the internal mass square;
- mass shell equates the two;
- cross term is Higgs kinetic;
- curvature block is diamond curvature;
- the operator is Krein/J-self-adjoint, not merely Hilbert self-adjoint.

## Next Aristotle jobs

Do not submit until current completed jobs are integrated or slots are open.
Highest-value focused jobs:

1. `null-edge-super-dirac-product-grading-krein`
   - prove product grading oddness and finite `J`-self-adjointness lemmas.
   - Aristotle project: `c0ddd3bf-04b6-44c4-8eff-db4472f226e9`.
2. `null-edge-super-dirac-mass-shell-bridge`
   - import/copy the bundle Pluecker and Yukawa scalar block APIs; prove the
     no-double-count equality statement.
   - Aristotle project: `1de5924b-07e9-4052-bc88-161e881d896b`.
3. `null-edge-diamond-two-triangle-curvature`
   - prove Abelian diamond defect equals the difference or ratio of two triangle
     curvatures.
   - Aristotle project: `c60a6698-2567-49f6-92c4-541094a1f322`.
4. `null-edge-superconnection-cross-term-higgs-kinetic`
   - name and prove the cross-term decomposition from the existing expansion.
   - Aristotle project: `6387b084-fa39-4e19-bc2c-64828962b899`.

## Failure modes to keep visible

- The only self-adjoint operator is positive-definite/Euclidean, so the
  Lorentzian operator is not a single Hilbert self-adjoint object.
- The Pluecker determinant and Yukawa square can only be added, not equated,
  implying mass double-counting.
- The cross term cannot be interpreted as a covariant Higgs kinetic term.
- Diamond holonomy does not match `d_U^2` curvature on minimal diamonds.
- Product grading fails unless artificial doubling is introduced.
