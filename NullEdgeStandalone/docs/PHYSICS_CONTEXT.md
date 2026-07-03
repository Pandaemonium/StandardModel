# Physics Context

This note is written for an Aristotle submission. It explains what physical
program the standalone Lean package is trying to model, what the finite Lean
theorems currently say, and which statements are deliberately not claimed.

## Executive Summary

The null-edge program tries to model relativistic transport from primitive
finite null steps. A basic degree of freedom travels along causal null edges,
but a visible massive mode can arise when several such null contributions fail
to remain one aligned, gapless, rank-one mode.

The strongest theorem in the package is the finite Pluecker mass identity:
for a finite family of complex two-spinors `psi_i`, the determinant of the
total Hermitian momentum

```text
P = sum_i psi_i psi_i^dagger
```

equals the total pairwise squared wedge spread:

```text
det(P) = sum_{i<j} |psi_i wedge psi_j|^2.
```

Physically, this says that the invariant mass squared of a finite bundle of
null spinor momenta is exactly the obstruction to all the null directions being
one common projective beam. This is a finite kinematic identity, not a dynamics
or a mass-spectrum prediction.

The second major target is a finite dual-soldered null-edge Dirac operator:

```text
D_N = sum_a c(alpha^a) nabla_a.
```

Here `nabla_a` differentiates or transports along a primitive null edge
direction `ell_a`, while the Clifford symbol uses the dual covector `alpha^a`.
The point is that edge support is null, but the Dirac symbol is reconstructed
from the dual soldering covectors. This distinction is central.

The package also contains the current Gate C audit. Gate C is the problem of
releasing a physical chiral branch from the flat tetrahedral null-edge symbol.
The bare symbol has high-momentum determinant-zero branches and does not by
itself select one chirality. Therefore the current release target is a projected
and audited physical operator `D_phys`, not the bare retarded operator `D_+`.

Aristotle's July 1, 2026 evaluation sharpens the priority order; see
[`ARISTOTLE_EVALUATION.md`](ARISTOTLE_EVALUATION.md). The central technical
fact is now the bare-symbol no-go
`PhysicsSM.Draft.NullEdgeActualCliffordSymbol.no_full_symbol_single_chirality`:
each high-momentum null branch has a two-dimensional, chirality-balanced
kernel. The follow-up module
`PhysicsSM.Draft.NullEdgeHyperdiamondNoGo` strengthens this to a per-branch
bare-symbol no-go and identifies explicit chirality-projection data as
sufficient extra data. The bridge module
`PhysicsSM.Draft.NullEdgeHyperdiamondBridge` proves the exact frame/covector
crosswalk between the Gate C tetrahedral symbol data and the dual-soldered
tetrahedral frame, plus the shared principal-symbol-square contract. The
projected/Wilson Gate C release files remain useful as an audit ledger, but
they are frozen schema material, not evidence that a physical operator has been
released. Future Gate C work should attach release clauses to an actual
projected operator or prove operator-level crosswalk theorems.

## The Physical Picture

The proposed finite ontology is a decorated causal graph. The graph has null
edge directions, finite transports, spinor fibers, Clifford symbols, and
internal finite data. The idealized local data look like:

```text
vertices x
primitive null edge directions ell_a(x)
dual soldering covectors alpha^a(x)
edge lengths h_a(x)
parallel transports U_a(x)
Krein fundamental symmetries J_x
spacetime chirality Gamma_s
internal finite grading chi_E
finite internal mass/Yukawa block Phi_x
```

The near-term program is not to derive all of spacetime or the Standard Model
from a bare graph. The finite package instead isolates algebraic identities
that any such model must satisfy if it is to behave like a Lorentzian Dirac
system with finite null-edge support.

The core slogan is:

```text
mass = canonical quadratic obstruction to staying one free null mode
```

This is not meant as a single formula for all masses. It is an obstruction
geometry principle. Different sectors may realize it through different
canonical maps:

- finite null bundles: Pluecker spread;
- Dirac/Yukawa fermions: an internal mass map;
- electroweak vector bosons: orbit stiffness after a Higgs vacuum is chosen;
- Higgs scalar: radial Hessian of a potential;
- branch release: spectral gaps, projectors, and determinant-zero control.

The Lean package proves the finite algebraic parts of this picture and records
conditional APIs for the parts that remain open.

The first dynamical seed is now the 1+1D checkerboard module
`PhysicsSM.Draft.Checkerboard1D`; see
[`CHECKERBOARD_1D.md`](CHECKERBOARD_1D.md). It proves the finite algebra that
the mass channel is the off-diagonal null-direction reversal amplitude and that
finite matrix powers expand as endpoint-constrained path sums, with
turn-grouped weights, tuple/list bridge lemmas, reverse-turn invariance, and a
unitary isotropic normalization. The follow-up scaffold
`PhysicsSM.Draft.CheckerboardContinuumScaffold` adds endpoint bookkeeping,
unitary-step generator algebra, and typed small-step hypotheses. It does not yet
prove a continuum Dirac limit.

## P1: Finite Pluecker Mass

A massless visible degree of freedom is represented by a complex Weyl spinor

```text
psi : Fin 2 -> Complex.
```

It contributes a rank-one Hermitian momentum matrix:

```text
psi psi^dagger.
```

A visible finite bundle is the sum of such rank-one null momenta:

```text
P = sum_i psi_i psi_i^dagger.
```

The determinant of `P` is the usual two-spinor determinant mass square in this
finite model. The theorem
`PhysicsSM.Spinor.PluckerMass.fin_bundle_plucker_mass_identity` proves:

```text
det(P) = sum_{i<j} |psi_i wedge psi_j|^2.
```

The package also proves:

- a single rank-one null contribution has zero determinant;
- the determinant mass is the coercion of a nonnegative real number;
- the massless locus is exactly common projective direction, assuming a chosen
  nonzero base spinor;
- the twistor chart version matches the same determinant convention.

Physical reading: if all visible null spinors point in one projective direction,
the finite bundle is still one null beam and has zero invariant mass. If the
resolved null directions spread, the pairwise wedge terms produce positive
mass square.

Important boundary: this is finite kinematics. It does not prove a continuum
field equation, a probability rule, a scattering theory, QCD confinement, or a
numerical particle mass.

## Static Slash Bridge

The package includes a static finite chiral slash operator built from the
two-by-two momentum matrix. It proves that the chiral slash squares to the
Minkowski determinant scalar, and therefore, after inserting the Pluecker
identity, squares to the finite Pluecker mass.

The key theorem is:

```text
PhysicsSM.NullStrand.FiniteCore.finiteCore_staticMassSquareRoot
```

Physical reading: the package has a finite algebraic square-root bridge from
the Pluecker determinant mass to a chiral Dirac-slash matrix.

Boundary: this is a static square-root identity. It is not a dynamical Dirac
equation and does not assert propagation, locality, or a continuum limit.

## Dual-Soldered Null-Edge Dirac Operator

The active finite first-order operator is:

```text
D_N = sum_a C_a nabla_a
C_a = c(alpha^a)
```

The primitive finite-difference or transport direction is `ell_a`. The
Clifford symbol uses the dual covector `alpha^a`. For the four-dimensional
tetrahedral frame:

```text
ell_A = (1, n_A)
alpha^A = 1/4 dt + 3/4 n_A . dx
```

with mostly-minus metric `(+---)`.

The important theorem-level facts are:

- the dual covectors reconstruct every covector from edge evaluations;
- the finite commutator with multiplication by a function is exactly the
  Clifford action of a discrete differential;
- the square of the principal symbol equals the Lorentzian quadratic form of
  the soldered covector;
- the concrete tetrahedral frame has null `ell_A`, dual pairing
  `alpha^A(ell_B) = delta_AB`, and the expected rational Gram data.

Physical reading: this is the finite analogue of a Dirac symbol, with null edge
support but covector soldering. It is close in spirit to hyperdiamond or
minimally doubled lattice Dirac structures, but the package only proves the
finite algebra stated in Lean.

Boundary: the package does not derive the tetrahedral frame from a bare graph.
The frame is decorated input.

## Why The Diagonal Null Soldering Is Rejected

A tempting operator would identify the null edge direction with the Clifford
soldering covector:

```text
sum_a c(ell_a^flat) nabla_ell_a.
```

This is not the active architecture. Since each `ell_a` is null, the diagonal
tensor sum has the wrong trace behavior for reconstructing the identity on
cotangent space. The dual-soldered operator separates:

```text
edge support: ell_a
Clifford covector: alpha^a
```

This is a convention and guardrail, not a theorem that the whole physical
theory follows.

## Super-Dirac Square

The package models a finite super-Dirac operator:

```text
D = i D_N + Gamma_s Phi
D_N = sum_a C_a nabla_a
```

The algebraic square theorem assumes explicit grading and commutation
hypotheses:

```text
Gamma_s^2 = 1
Gamma_s C_a + C_a Gamma_s = 0
Gamma_s nabla_a = nabla_a Gamma_s
Gamma_s Phi = Phi Gamma_s
C_a Phi = Phi C_a
```

Under these hypotheses the theorem
`PhysicsSM.NullStrand.DualSolder.GradedSuperDiracSquare.superDirac_graded_square`
gives the finite square decomposition with:

- a symmetric kinetic or null-box term;
- an antisymmetric diamond or Pauli-curvature term;
- a frame/tetrad defect term;
- a `+ Phi^2` internal mass term;
- a first-order Higgs/Yukawa derivative commutator term.

The sign of `Phi^2` is load-bearing. The package also proves that if `Phi`
anticommutes with `Gamma_s`, the sign flips. Therefore internal oddness must
belong to a separate internal grading `chi_E`; it must not be confused with
spacetime chirality `Gamma_s`.

Boundary: this is algebra in an arbitrary associative complex algebra. It is
not a proof of a continuum Lichnerowicz formula.

## Frame Terms And The Finite Tetrad Postulate

The finite square includes a frame term:

```text
T_frame = sum_{a,b} C_a [nabla_a, C_b] nabla_b.
```

The finite tetrad-postulate theorem proves that if:

```text
[nabla_a, C_b] = 0
```

for all `a,b`, then `T_frame = 0`, and the square reduces to the kinetic plus
diamond terms.

Physical reading: compatible edge transport removes frame contamination.

Boundary: if the commutator does not vanish, the package does not hide the
term. The defect must be classified as nonmetricity, curvature/holonomy,
torsion-like failure, or smooth-limit contamination.

## Spectral Mass-Shell Matching

The package includes a diagonal spectral model of:

```text
K tensor I - I tensor M^2.
```

The kernel is exactly the matching support where the geometric eigenvalue
equals the internal mass-squared eigenvalue:

```text
K_i = M2_j.
```

Physical reading: the finite kinetic operator and internal mass square are
matched by an on-shell condition. They should not be counted as two independent
mass-square contributions.

Boundary: this is a diagonal finite model. It does not determine the internal
spectrum.

## Schur Complement And Hidden Sheets

The package also proves a finite Schur-complement identity. For a block operator

```text
[[D_vis, B],
 [C,     D_hid]]
```

with invertible hidden block, eliminating the hidden variable produces:

```text
D_eff = D_vis - B D_hid^-1 C.
```

Physical reading: local finite block dynamics can project to an effective
visible operator after integrating out a hidden finite sector.

Boundary: the package treats the invertible hidden block case only. It does not
prove locality or positivity of the resulting effective operator.

## Krein Double

Lorentzian finite systems naturally use an indefinite inner product. The package
models this through a fundamental symmetry:

```text
J = J^dagger = J^-1
A^sharp = J A^dagger J
```

Given a retarded operator `D_+`, define:

```text
D_- = D_+^sharp
D_dbl = [[0,   D_-],
         [D_+, 0  ]]
```

The package proves that `D_dbl` is self-adjoint for the doubled Krein symmetry
and that its square is block diagonal.

Physical reading: this is the finite algebraic hygiene needed for a retarded
and advanced Lorentzian double.

Boundary: Krein self-adjointness is not stability. It does not imply positive
energy, real spectrum, unitarity, anomaly cancellation, or physical Hilbert
space positivity. The package includes explicit counterexample modules for
these overclaims.

## Gate C: Branch Release And No-Doubling

Gate C is the hard obstruction for a Standard-Model-facing chiral operator.
The flat tetrahedral retarded symbol has phase coefficients:

```text
u_a(q) = exp(i q_a) - 1
```

and a Lorentzian quadratic form:

```text
p(q)^2 = u^T G^-1 u.
```

The finite corner theorem shows that among the 16 corners `q_a in {0, pi}`:

- the origin has `u = 0`;
- the four three-pi corners are nonzero null corners;
- ten corners are spacelike;
- the all-pi corner is timelike.

This means retardedness rules out coefficient-zero doublers, but not
determinant-level Clifford singularities. A nonzero coefficient vector can still
be null and therefore make the Clifford symbol singular.

The spectral-graph module further proves that the high-momentum null corners
lie on exact determinant-zero branch lines. Thus the bare symbol does not have
four isolated species points; it has extended nodal curves.

The actual Clifford-symbol module proves the corrected bare-kernel statement:
on each nonzero null branch the full kernel contains both chiralities. The bare
operator does not assign one chirality sign per branch.

The hyperdiamond no-go module strengthens this branch-by-branch:
`no_branch_single_sign` rules out a monochromatic bare kernel on every branch,
and `bare_symbol_proof_cannot_fix_chirality` produces a contradicting bare zero
mode for every candidate sign. It also proves that an explicit chirality
projector can force alignment and cut the balanced kernel, but that projector is
only sufficient extra data, not a released physical operator.

The hyperdiamond bridge module proves an exact frame/covector crosswalk: the
Gate C tetrahedral dual frame is the complexified dual-soldered tetrahedral
frame, and the two symbol layers share the same principal-symbol-square
contract. This is reconstruction progress, not a Borici-Creutz operator
equivalence and not a physical release.

Physical reading: the naive flat bare operator is not a released physical
chiral operator.

Boundary: this is not fatal to the program, but it forces a projected or
regulated physical operator. The current target data are:

```text
D_gap
Pi_phys
D_phys
Gamma_lat
physical/Krein data
```

## Gate C Release API

The package includes conditional release APIs for a projected or Wilson-regulated
physical dataset. A release is not just a nonzero index. It requires:

- nodal-set control;
- branch-projector control;
- one-dimensional projected kernels;
- projected chirality alignment;
- projected Krein positivity;
- ghost-zero safety;
- species-splitting and regulator-moduli audit.

The ghost-zero safety module formalizes the warning that a flavored index can
coexist with a fatal gauge-coupled wrong-sign Krein zero. Therefore a nonzero
index is necessary but not sufficient.

The Wilson release module is explicitly about `D_phys`. It is not a release of
the bare `D_+`.

Post-evaluation boundary: these release APIs are typed conditions for a future
solution. Their bookkeeping records are not derived from the actual
`cliffordSymbol`, so they should not be extended as a substitute for constructing
or refuting a projected physical operator. Keep the ghost-zero
necessary-but-not-sufficient guardrail; otherwise freeze the release ledger
unless a new theorem connects the predicates to concrete operator data.

For the 3+1D branch problem, use the hyperdiamond/minimally doubled lattice
fermion framing in [`HYPERDIAMOND_CROSSWALK.md`](HYPERDIAMOND_CROSSWALK.md).
The assumption ledger is
[`GATE_C_ASSUMPTION_LEDGER.md`](GATE_C_ASSUMPTION_LEDGER.md). The current finite
theorem is a chirality-balance no-go for the bare symbol, not a release
construction.

## Relation To The Standard Model

The long-term target is a finite algebraic substrate that can interface with
Standard Model structures:

- chiral fermions;
- internal finite grading `chi_E`;
- Yukawa/Higgs blocks `Phi`;
- gauge-covariant transports;
- anomaly and ghost audits;
- a finite-to-continuum map.

This standalone package does not include the full Furey/Baez internal algebra
or a completed Standard Model sector. It only provides the finite null-edge
operator and mass-obstruction spine that such an internal sector would have to
couple to.

The intended product architecture is:

```text
H_total = H_null tensor H_internal
D = i D_N tensor 1 + Gamma_s tensor Phi
```

where `Phi` is internally odd under `chi_E` but spacetime-even under `Gamma_s`,
so that the square has the correct `+ Phi^2` sign.

## What Aristotle Should Treat As Established

Treat these as finite, kernel-checked algebraic facts:

- finite Pluecker determinant mass identity;
- massless iff common projective spinor direction, with the stated base
  nonzero hypothesis;
- static chiral slash square-root of the determinant mass;
- tetrahedral dual-solder frame algebra;
- dual-soldered principal symbol square;
- graded super-Dirac square under explicit hypotheses;
- finite tetrad-postulate frame-term vanishing;
- finite Krein retarded/advanced double self-adjointness;
- spectral mass-shell matching in the diagonal finite model;
- Schur-complement elimination for an invertible hidden block;
- finite Gate C branch-count, nodal-line, bare-kernel, and release-audit
  guardrails.
- branch-by-branch Gate C bare-symbol no-go and the explicit chirality
  projector sufficiency theorem.
- exact Gate C / dual-soldered frame-covector bridge and represented-data
  Nielsen-Ninomiya ledger.
- finite 1+1D checkerboard mass-as-reversal, turn-count, matrix-power path-sum,
  isotropic unitarity, and endpoint-bookkeeping identities.

## What Aristotle Should Not Assume

Do not assume:

- the bare graph canonically supplies a tetrad;
- the bare retarded operator `D_+` is a released physical chiral operator;
- retardedness alone proves no-doubling;
- Krein self-adjointness proves positivity or stability;
- `chiralProj` is local, gauge-covariant, Krein-safe, or operator-derived;
- the package proves anomaly cancellation;
- the package proves a continuum scaling theorem;
- the package predicts particle masses;
- the projected physical operator `D_phys` has been constructed.

## Good Aristotle Tasks For This Package

Useful next proof or audit jobs include:

- semantic audit of the finite theorem statements against the physics reading;
- proof simplification and theorem naming cleanup for the standalone package;
- strengthening the finite tetrad-postulate API without hiding frame defects;
- extending the 1+1D Feynman checkerboard layer toward endpoint count closed
  forms, generator expansion, and a carefully stated continuum limit;
- defining a named hyperdiamond/minimally doubled lattice-fermion operator and
  proving an exact operator crosswalk or mismatch theorem;
- upgrading the frame/covector bridge to a concrete position-space
  operator-level bridge if the definitions support it;
- checking whether the frozen Gate C projected release predicates are mutually
  minimal before any future extension;
- proving more precise absence/no-go theorems for scalar Wilson or taste-only
  release routes;
- designing a Lean statement for a local projected `D_phys` construction;
- identifying exact hypotheses needed for a continuum limit from the finite
  dual-soldered square.

The most important review principle is semantic alignment: the Lean kernel
checks the theorem as stated, but Aristotle should verify that the statement
matches the intended finite physics claim and does not silently overclaim.
