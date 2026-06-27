# P1 manuscript skeleton: Pluecker mass from null spinor bundles

**Status:** overnight skeleton, 2026-06-22.
**Publication-plan slot:** P1 in
`Sources/Null_Edge_Causal_Graph_Publication_Plan.md`.
**Lean anchors:** `PhysicsSM.Spinor.PluckerMass`,
`PhysicsSM.Draft.TwistorPluckerMass`,
`PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore`,
and standalone Aristotle artifact
`AgentTasks/aristotle-standalone/null-edge-spinor-network-closure-20260621/NullEdgeSpinorNetworkClosure/Finite.lean`.

## Working title

Null Spinor Bundles and the Pluecker Formula for Mass

## One-paragraph abstract

We formalize a finite algebraic mechanism by which massive momentum arises from
a bundle of null spinors. A future null edge is represented by a rank-one
Hermitian two-spinor matrix `psi psi^dagger`; the visible momentum of a finite
bundle is their sum. The determinant of this `2 x 2` momentum matrix is exactly
the sum of squared pairwise Pluecker brackets. Equivalently, in a celestial
Bloch-sphere parametrization, mass is the deficit of the weighted dipole from
saturating the total energy. The result is finite-dimensional linear algebra,
kernel-checked in Lean, and should be read as a theorem about visible null
kinematics rather than as a complete dynamics.

## Claim boundary

What this paper can claim:

- finite theorem: `det (sum_i psi_i psi_i^dagger) =
  sum_{i<j} |psi_i wedge psi_j|^2`;
- zero mass iff all nonzero visible spinors have a common direction;
- mass is missing celestial dipole / angular spread;
- spinor-chart two-twistor mass matches the two-edge Pluecker invariant;
- static Dirac slash of the bundle momentum squares to the same scalar.

What this paper should not claim:

- a continuum Dirac equation from arbitrary null-edge dynamics;
- a Standard Model mass spectrum;
- a cosmological source theorem;
- full projective twistor geometry beyond the checked spinor chart.

## Proposed structure

1. Introduction

   State the narrow problem: if visible microscopic edges are null, how can a
   coarse-grained visible particle be timelike? Answer: non-collinearity of a
   finite null-spinor bundle.

2. Conventions

   Record the metric signature, Pauli matrix convention, spinor wedge
   convention, determinant normalization, and trace-vs-determinant mass
   convention. Include the irrep warning: the Pluecker bracket lives in
   `Lambda^2 S ~= C`, not in the `Sym^2 S` curvature representation.

3. The finite Pluecker mass theorem

   Present the two-edge identity first, then the finite Cauchy-Binet
   generalization. The Lean theorem anchors are:

   ```text
   two_edge_plucker_mass_identity
   fin_bundle_plucker_mass_identity
   fin_bundle_det_re_nonneg
   fin_bundle_mass_zero_iff_common_direction
   ```

4. Celestial moment form

   Rewrite normalized spinors as Bloch directions and state the moment identity:

   ```text
   m^2 = (E^2 - |sum_i w_i n_i|^2) / 4.
   ```

   Use the standalone spinor-network closure artifact as the current checked
   proof source. Emphasize the guardrail: visible closure `sum_i w_i n_i = 0`
   is a rest-frame condition, not source invisibility.

5. Twistor chart check

   Explain the limited but useful twistor wrapper:

   ```text
   two_twistor_mass_invariant_eq_plucker
   multi_twistor_momentum_det_eq_pairwiseMass
   ```

   Keep full twistor incidence and Penrose-transform material out of scope.

6. Static Dirac square root

   Present the finite operator version:

   ```text
   chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass
   ```

   This is the square root of the static mass scalar. It is not yet a dynamical
   propagation theorem.

7. Relation to prior work

   Compare with massive spinor-helicity (`1709.04891`), two-twistor massive
   particle models, Grassmannian/Pluecker geometry, and spinor-network closure.
   The novelty is the finite bundle generalization plus Lean-checked theorem
   packaging for the null-edge program.

8. Discussion and next steps

   Point to P3 causal diamonds, the P7 information-theoretic channel, and P9
   source visibility as downstream uses. Do not let them carry this paper's
   proof burden.

## Figures / tables to make later

- A two-null-edge diagram: collinear edges massless, non-collinear pair
  timelike.
- A Bloch-sphere dipole picture: energy as monopole, momentum as dipole, mass
  as dipole deficit.
- A theorem-to-Lean table with trusted vs draft artifacts.
- A convention table for spinor, twistor, and Dirac-square-root normalizations.

## Immediate writing tasks

- Convert the theorem inventory into a polished theorem table.
- Audit source keys for massive spinor-helicity and two-twistor references.
- Decide whether the standalone spinor-network closure artifact should be
  promoted before submission or cited as an appendix/handoff result.
- Write a two-page proof sketch of the Cauchy-Binet identity in conventional
  mathematical prose.

## Mixedness section and continuum bridge (2026-06-27 lateral analysis)

Two section additions to mirror the corresponding update in
`Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`. Keep the invariant
identity primary and the normalized reading clearly labeled (see the
`docs/NULLSTRAND.md` guardrail).

- **Mixedness reading of the determinant.** After the `det P = m^2` theorem, add
  a short subsection: normalize `rho = P / Tr(P)`; then `det rho` is the
  determinant of a qubit density matrix and, in Bloch form, `det rho =
  (1 - |r|^2)/4`. The massless case is *purity* (projective rank-one); a massive
  finite bundle is a *mixed* celestial spin state, with the celestial-moment
  form `m^2 = (E^2 - |C|^2)/4` as the monopole/dipole statement. Slogan, kept in
  an interpretation paragraph only: mass is the impurity of a null-direction
  density matrix. State `det rho_{p|u} = (m / E_u)^2` as the observer-conditioned
  proxy, not as the invariant.

- **Measure-valued null dust (continuum / P1.5 bridge).** Add a forward-pointing
  subsection: the finite sum `P = sum_i psi_i psi_i^dagger` generalizes to
  `P = integral psi psi^dagger dmu(psi)` over a positive measure `mu` on the
  celestial sphere, with `det P ~ (1/2) integral integral |psi wedge phi|^2
  dmu dmu`. The massless criterion becomes: `mu` is supported on one projective
  spinor direction. This is the cleanest bridge from finite P1 algebra to the
  DEC/continuum scaffold and is the natural "P1.5" theorem (finite bundles, then
  positive measures, then approximation/convergence). It does not claim QCD or
  Higgs dynamics are derived; it says any continuum object built from null
  directions has invariant mass equal to angular second moment.
