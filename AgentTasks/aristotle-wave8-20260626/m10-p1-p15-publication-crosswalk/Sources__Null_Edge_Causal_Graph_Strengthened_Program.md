# Strengthened null-edge causal graph research program

**Status:** theorem-inventory, celestial-moment, and Dirac square-root update,
2026-06-21.
**Related drafts:**
`Sources/Toward_a_Null-Edge_Causal_Graph_Formulation.md`,
`Sources/Luminal_Motion_Checkerboard_Research_Program.md`, and
`Sources/Luminal_Motion_Checkerboard_Publication_Advance_2026-06-11.md`.
**Lean anchors:**
trusted modules `PhysicsSM.Spinor.Checkerboard`,
`PhysicsSM.Spinor.CheckerboardDynamics`,
`PhysicsSM.Spinor.PluckerMass`,
`PhysicsSM.Spinor.TwistorPluckerMass`, and
`PhysicsSM.Gauge.CausalDiamondHolonomy`;
kernel-clean draft wrappers
`PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle`,
`PhysicsSM.Draft.NullEdgeYukawaGaugeAristotle`;
active higher-gauge draft wrappers
`PhysicsSM.Draft.CausalDiamondHigherGaugeAristotle` and
`PhysicsSM.Draft.NullEdgeP3CrossedModule`.

## Executive conclusion

The null-edge causal graph idea is strongest when it is framed as a
theorem-driven research program, not as a finished replacement for quantum
field theory or general relativity.

The clean version is:

> Fundamental histories are quantum amplitudes or decoherence functionals over
> causal incidence structures. Their visible edges carry null spinor/twistor
> data. Massive particles are coarse-grained bundles of non-collinear null
> momenta. Fermion masses arise from Higgs-permitted chirality flips. Gauge
> curvature is measured by holonomy defects across causal diamonds. Gravity is
> approached through null-horizon entropy and momentum flux. Octonionic and
> exceptional structures belong primarily to the internal transition algebra,
> not to observed spacetime coordinates.

The program has now advanced from a target list to a finite theorem spine.
The best-supported results are algebraic and combinatorial: checkerboard
recursions, a finite Pluecker mass theorem, a spinor-chart twistor matching
wrapper, finite Yukawa gauge-bookkeeping theorems, and causal-diamond holonomy
invariance/composition laws. The remaining research risk is mostly in the
bridges from these finite theorems to continuum dynamics: Dirac universality,
full twistor incidence, higher gauge geometry, Kähler-Dirac graph fermions,
and null-horizon gravity.

The falsification-aware map now gives the program a sharper priority order.
The cosmological-constant/source-visibility branch is the highest-risk,
highest-leverage physics target, because it collides directly with
everpresent-Lambda causal-set cosmology: if finite diamond observables make
coherent/internal vacuum bookkeeping boundary-like or mean-zero while visible
Pluecker excitations source bulk defects, the program offers a structural
reason for a mean-zero fluctuating source. If not, this branch should be
demoted. The origin-of-mass/operator branch is the strongest mathematical
target and is already partly banked by the Dirac square-root modules. The
bivector/BF and generation-blindness branches are the next cheap decisive
finite tests. Measurement, black-hole information, strong CP, confinement, and
hierarchy should stay interpretive watch-list items until they force a new
finite constraint or prediction.

A Dirac-style correction now sharpens the program further. Nearly every
trusted keystone is a square: determinant mass, squared Pluecker modulus,
Bloch mixedness, reduced-density impurity, and Laplacian-type propagation.
That means the next central object should not be another quadratic invariant,
but the finite first-order operator whose square produces these invariants.
The short slogan is:

> The Pluecker mass theorem is the square of a theorem we have not yet fully
> written.

At the static spinor-bundle level, the square root is ordinary finite algebra.
Write

```text
P = sum_i psi_i psi_i^dagger = P_mu sigma^mu.
```

Then a Clifford/Dirac slash satisfies

```text
(gamma . P)^2 = (P_mu P^mu) I = det(P) I.
```

Composed with the trusted Pluecker theorem, this gives the near-term Lean
target:

```lean
diracSlash_bundleMomentum_sq_eq_pluckerMass
```

under explicit signature, gamma-matrix, and Pauli-matrix conventions. This is
still finite algebra, not a continuum Dirac equation. The larger conjectural
target is a causal super-Dirac operator on the order complex,

```text
D_{U,Phi} = d_U + delta_U + Phi + Phi^dagger,
```

whose square decomposes into a covariant graph Laplacian, diamond curvature,
Higgs/Yukawa chirality-flip blocks, and the visible Plucker scalar block. If
such an operator cannot be made natural and finite, the program remains a
collection of related quadratic analogies rather than a unified theory.

The operator criterion has four immediate consequences.

First, the visible `2 x 2` Hermitian momentum block naturally carries
\(m^2\), not \(m\). A genuine mass term belongs in the doubled
left/right space as an off-diagonal block. The Higgs/Yukawa chirality-flip
vertex is therefore not an auxiliary explanation added after the Pluecker
mass theorem; it is the finite mass entry of the first-order operator whose
square returns the determinant-level mass.

Second, the square root is two-sheeted. The sign choice
\(\sqrt{\det P}=\pm m\) should be treated as an algebraic constraint on any
CPT, particle/antiparticle, or in/out-sheet proposal. This does not by itself
prove a physical two-sheet scattering construction, but it makes the branch
structure a required part of the operator story rather than optional
decoration.

Third, the complex Pluecker amplitude should be kept before taking modulus.
For a pair of spinors,

```text
psi_i wedge psi_j = |psi_i wedge psi_j| exp(i Phi_ij).
```

The squared modulus is the mass-spread theorem. The phase is the natural
Pancharatnam/Berry companion to test against the graph holonomy layer. The
right finite object is therefore a complex first-order bivector amplitude,
whose modulus and phase give two real shadows.

Fourth, the flip-rate/l=1 relaxation conjecture should be stated at first
order. The autocorrelation decay of celestial directions is a square-level
diagnostic. The Dirac target is a transfer operator on a doubled
\(L\oplus R\) celestial space whose off-diagonal block is the flip generator
and whose eigenvalue is \(m\) directly. The 1+1 checkerboard is the base
case: the corner-flip amplitude is already the first-order mass entry, while
the Klein-Gordon-style recurrence is what appears after squaring.

A new sharpening is to rewrite the Pluecker mass theorem as a celestial moment
theorem. Normalized visible null spinors determine directions on
`CP^1 ~= S^2`; the summed Hermitian momentum decomposes into a monopole
(energy) and a dipole (spatial momentum). The determinant mass is exactly the
deficit of this dipole from saturation. This makes the static theorem read:
mass is missing celestial l=1 coherence. It also suggests the right dynamical
form of the flip-rate conjecture: not "mass is a generic flip count", but
"mass is calibrated by the l=1 spectral gap of the direction process", with
the 1+1 checkerboard as the base case where the factor can be audited exactly.

The same algebra has a reduced-state reading. A pure microscopic null process
may entangle the visible spinor with unresolved internal, chiral, or Higgs
bookkeeping. After tracing out those labels, the visible observer sees a
`2 x 2` positive matrix \(P_{\rm vis}\). The determinant mass is then the
unnormalized reduced determinant of this visible celestial block. This is the
Lorentz-invariant statement:

\[
m^2=\det P_{\rm vis}.
\]

The word "observer" should now be split into two operations. A resolution
observer chooses which internal labels are unresolved and takes the partial
trace; this produces \(P_{\rm vis}\). A kinematic observer chooses a timelike
frame/energy normalization and produces a normalized density matrix. These
steps have different covariance properties. If a visible boost acts as
`A tensor I_int`, then

```text
Tr_int[(A tensor I) |Psi><Psi| (A^dagger tensor I)]
  = A (Tr_int |Psi><Psi|) A^dagger,
```

so \(P_{\rm vis}\) transforms by congruence and
`det(A P_vis A^dagger)=det(P_vis)` for `A in SL(2,C)`. By contrast, the
normalized state is obtained only after the kinematic normalization and changes
by filtering and renormalization under frame changes.

After choosing a timelike observer convention and normalizing
\(\rho=P_{\rm vis}/\operatorname{Tr}P_{\rm vis}\),
\[
2\sqrt{\det\rho}=m/E=d\tau/dt
\]
in units \(c=1\), with the usual momentum normalization conventions. This
normalized quantity is frame-relative because \(\operatorname{Tr}P_{\rm vis}=2E\)
uses the time component of the four-momentum. The invariant is `det(P)`, not
`det(rho)`. The normalized determinant is still important, but it measures the
mass ratio/proper-time rate in a specified observer frame. This
turns "many null pieces" into a purification statement: a massive visible
particle can be a pure null process whose internal sector carries
which-null-direction information. For a pure state on
`visible celestial qubit tensor internal labels`, this same quantity is exactly
the bipartite concurrence of the visible/internal cut. The safe theorem target
is therefore not merely "mixedness-style"; it is
`normalized_mass_ratio_eq_concurrence`.

The resolution channel is concrete in the nonorthogonal-label case. If visible
spinors are columns of a `2 x n` matrix `V` and the hidden labels have Gram
matrix `G`, then

```text
P_vis = V G V^dagger,
det(P_vis) = w^dagger (Lambda^2 G) w,
w_ij = v_i wedge v_j.
```

For two labels, `det(P_vis)=|v_1 wedge v_2|^2 det(G)`. Thus orthogonal or
decohered labels recover the Plucker sum, rank-one coherent labels collapse the
exterior square and give zero visible mass, and dephasing the internal overlap
increases the visible determinant toward the orthogonal Plucker value. This is
the cleanest finite mechanism currently available for turning hidden coherence
into visible mass.

This concurrence reading also gives the monotonicity boundary. The static
identity \(m/E=d\tau/dt\) is time dilation rewritten in qubit language; it is
valuable vocabulary but not by itself a new dynamical principle. A genuine
monotonicity theorem requires a named channel class. For unital CPTP channels
on the normalized visible celestial qubit, data processing relative to the
fixed point `I/2` contracts the Bloch vector and makes `m/E` non-decreasing.
Hidden dynamics that entangle the visible celestial qubit with the internal
layer are not channels on `rho_vis` alone and can violate that monotonicity, so
they should be listed as the explicit failure class.

This is the same mathematical spine as the null-energy/source-visibility audit,
not a separate principle. The concurrence branch uses data processing for
relative entropy or entanglement monotones under a specified observer/channel
class; the ANEC/QNEC branch uses relative-entropy monotonicity for modular
Hamiltonians and null deformations. The finite program should therefore define
the observer map or coarse-graining first, then ask which null observable is
monotone under it. Without that map, both "proper time increases" and "visible
null flux is positive" are underspecified slogans.

The useful information-theoretic upgrade is recoverability. Petz recovery and
the Fawzi-Renner approximate-Markov-chain theorem turn "invisible to the
observer" into a finite diagnostic: the relative-entropy loss under the
observer channel should be zero or small exactly when the hidden bookkeeping is
exactly or approximately recoverable from what the observer retains. This gives
the source-visibility branch a sharper target than a bare zero-source slogan.
On the mass side, the off-diagonal internal Gram data play the role of the
recoverable coherence. If the Petz-style recovery reconstructs those overlaps,
the attribution of visible mass to lost hidden coherence is ambiguous; if the
coherence is not recoverable, the observer-channel mass is locked in by the
resolution map.

For the causal-diamond branch, the Sorkin-Johnston entropy literature supplies
a native discrete reference-state candidate. A finite diamond can be equipped
with an SJ-style correlation state and a modular surrogate
`K_disc = -log sigma_diamond`; the proposed ANEC/QNEC analogue then becomes a
second-difference or convexity test for relative entropy along nested diamonds.
The caveat is essential: causal-set entropy examples recover area-law behavior
only after a Pauli-Jordan spectral truncation, so any SJ-based pilot must state
that truncation before making horizon-entropy claims.

The QGT/QFI, resource-theory, and Renyi-alpha extensions should remain gated.
They are promising because the celestial `CP^1` layer already has a real
Fubini-Study metric and imaginary Berry curvature, and because only some
divergence families obey data processing. They become theorem branches only
after the resource theory, free operations, or admissible parameter region is
fixed.

The frame-invariance audit adds a new mandatory theorem layer. Under
`SL(2,C)` spin-frame changes,

```text
P_vis |-> A P_vis A^dagger,
det(A P_vis A^dagger) = det(P_vis),
```

so `det(P_vis) = m^2` is the Lorentz scalar. By contrast,
`rho = P_vis / Tr(P_vis)` depends on the observer's timelike normalization, and
`det(rho) = det(P_vis) / Tr(P_vis)^2` computes `(m/E)^2`. The finite program
should therefore add explicit wrappers:

```lean
visibleReduced_boost_eq_congruence
det_visibleReduced_boost_invariant
normalizedVisible_boost_is_filtering
normalizedVisible_det_eq_massRatio_sq
restFrame_iff_normalizedMomentum_maximallyMixed
```

The kinematic mass/concurrence correspondence also has direct prior art,
notably Chin-Lee `arXiv:1407.2492`, and the non-covariance of reduced spin
entropy under boosts is a standard relativistic-quantum-information warning
from Peres-Scudo-Terno `quant-ph/0203033` / PRL 88, 230402 and
Gingrich-Adami `quant-ph/0205179` / PRL 89, 270402. The program's novelty
should be claimed in the finite null-edge packaging, Lean-checked bundle
generalization, and dynamical/channel use of the mass ratio, not in the bare
two-qubit concurrence analogy.

The dynamical version should be a finite qubit-channel statement. A CPTP
channel on the visible celestial density matrix acts affinely on the Bloch
ball,

```text
r |-> T r + t,
```

while the mass ratio is `sqrt(1 - |r|^2)`. Thus the l=1 relaxation conjecture
should be stated as a spectral property of a channel or generator, not as a
raw flip-count slogan. Visible unitaries preserve `|r|`; depolarizing or
unital visible channels can increase the mass ratio by contracting `|r|`;
entangling hidden dynamics are not visible channels and can reverse the
monotonicity. Broad LOCC/local language should be replaced by the explicit
channel class being used.

The new big-physics development note
`Sources/Null_Edge_Big_Physics_Inquiry_Development.md` sharpens this into
three concrete inquiry lines. First, nonorthogonal internal labels replace the
orthogonal Pluecker sum by an exterior-square Gram formula
`det(M G M^dagger) = w^dagger (Lambda^2 G) w`; this is now isolated as the
draft Lean handoff `PhysicsSM.Draft.NullEdgeGramWeightedMassAristotle` and is
the finite spine for the flavor-overlap/Yukawa-hierarchy proposal. Second,
the normalized determinant identity makes `2 sqrt(det rho_vis) = m/E` a
proper-time-rate/concurrence wrapper, with monotonicity claims restricted first
to explicit unital visible-channel classes and with entangling hidden dynamics
kept as the failure case. Third, the cosmological-constant route
is phrased as a finite causal-diamond source-visibility problem: define screen flux,
entropy change, and curvature pairing, then test whether coherent/internal
vacuum bookkeeping is invisible or boundary-like while visible Pluecker-mass
excitations source a diamond Clausius defect.

The falsification-aware feedback makes the third line the flagship
big-physics test. The relevant external collision is Sorkin's everpresent
Lambda program, especially Das-Nasiri-Yazdi `K5CFI3HI` and `IHVSDGUC`: a
causal-set/unimodular picture naturally gives sign-changing fluctuations of
order `1 / sqrt(V)`, but it needs a structural reason why the mean target is
zero and faces observational amplitude constraints. The null-edge version is
worth pursuing only if it can prove a finite visibility lemma:

```text
coherent/internal vacuum bookkeeping -> boundary or mean-zero diamond source
visible Plucker excitation           -> bulk diamond source
residual source noise                 -> sqrt(N)-type fluctuation pilot
```

The mechanism to test is closure. In the BF/spin-foam language,
`sum_f B_f = 0` is a Gauss-law constraint. Coherent/internal vacuum
bookkeeping that satisfies closure should contribute only boundary-like or
mean-zero data, while a visible Pluecker excitation should appear as a local
closure violation or diamond defect. Until this closure-to-source theorem is
proved in a finite model, the cosmological branch remains a high-risk lead.

The sharper version is a finite Hodge/conservation conjecture. Diamond
bookkeeping should be modeled as a cochain on the finite diamond order complex,
with the inner product fixed by a Sorkin-Johnston-style correlation metric. Then
boundary-exact bookkeeping lies in `im d`, visible matter/closure defects are
detected by the codifferential/source map, and the only plausible finite
Lambda-channel is the harmonic sector `ker d cap ker delta`. This does not
solve the cosmological-constant problem; it localizes it. The decisive questions
become the Betti-number scaling of the harmonic sector and the scaling of the
harmonic noise trace under the same SJ truncation/window used for the entropy
reference state. Constant or area-law scaling would be real leverage. Volume-law
scaling, or a response law that imports the everpresent-Lambda amplitude tension
unchanged, would demote the branch.

The area-law possibility must also be interpreted carefully. In four spacetime
dimensions, everpresent-Lambda volume fluctuations give
`sqrt(V) / V ~ L^(-2)`, the right Hubble-scale order. If P9 suppresses local
vacuum residuals to a codimension-two screen law, the scaling becomes
`sqrt(A) / V ~ L^(-3)`; if the relevant support is a null hypersurface, it is
roughly `L^(-5/2)`. These are valuable vacuum-filtering laws, but they are
probably too suppressed to be the observed dark energy by themselves. The
sharp model is therefore two-component: local UV vacuum bookkeeping should live
in exact/projected/screen-supported sectors, while any observed Lambda-scale
residual must live in a surviving global, harmonic, or unimodular quotient.

The finite pilot should be judged by a geometry-discriminating statistic, not by
generic projector algebra. A flat-vs-de Sitter-like diamond comparison should
track harmonic dimension, projected-noise trace, smallest positive projected
eigenvalue, or projected condition number. A useful working threshold is that
the flat/de Sitter separation exceed ten times the within-family sprinkling
spread and vary monotonically with the expansion parameter, while surviving
boundary-exact perturbations and either refinement or a named coarse-graining /
renormalization step. Fine-scale ill-conditioning is not by itself fatal in a
fundamentally discrete model; it is fatal only if no stable large-scale readout
remains. If every such statistic is geometry-blind, unstable after the stated
coarse-graining, boundary-artifactual, dependent on hand-tuned metric weights,
or lacks a response law to curvature/expansion, the branch should be demoted to
finite Hodge theory on causal diamonds.

The source basis for this corrected gate is no longer only FEEC and finite Hodge
theory. Recent Laplacian renormalization work (`RA8QNNKW`, `AN5RZGJZ`,
`UR5ADCBP`) directly supports asking for stable higher-order or graph-Laplacian
observables after coarse-graining. FEEC (`DM6NREPA`, `8JFSI9CS`) and the DEC
stability bridge `WB8WBSBX` supply the corresponding finite-Hodge stability
guardrail. P9 should use that literature as permission to be discrete-first,
while still demanding a geometry-discriminating large-scale readout.
Eichhorn-Mack-Le-Wagner's causal-set observable survey (`RC5XF8RD`) adds an
intrinsic-observable testbed: link-degree distributions, symmetrized-Hasse graph
Laplacian spectra, and causal-interval abundance distinguish causal-set classes
with comparatively small fluctuations. P9's next coarse-map pilot should test
those observables, or derive `R` from them, before treating block averages as
source-visibility evidence.
The current strongest strategy gate is iso-histogram separation: find two
finite causal sets with the same out-degree and interval-abundance histograms
that are separated by a frozen projected observer readout, and prove that the
separation is invariant under order isomorphism and stable under a
pre-specified Alexandrov or spectral coarse map with a scale-uniform bound. If
the readout collapses under offset sweeps, weight scrambles, boundary-stripped
controls, or fixed-histogram null models, P9 is still generic finite Hodge
linear algebra rather than cosmological leverage.
The stronger version should be diamond-local. The cheap witness is now banked
in `PhysicsSM.Draft.NullEdgeP9IsohistogramSeparation`: it shows that separate
degree and interval-abundance histograms do not determine a frozen joint
readout. This is useful bookkeeping, but not publication-grade source
visibility. The T1 target is now banked in
`PhysicsSM.Draft.NullEdgeP9DiamondLocalSeparation`: matched joint
in/out-degree and global interval-abundance signatures, equal diamond
cardinality, and a different local interval-size signature inside the fixed
diamond. The negative T2 guardrail is also banked in
`PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail`: a natural
critical-collapse map erases the T1 separator. Positive T2 preservation should
therefore be claimed only for a pre-specified admissible coarse-map class. T3 is
now banked in `PhysicsSM.Draft.NullEdgeP9DiamondLocalityNoiseInvariance`: once
the closed diamond and all internal relation entries agree, external relation
noise cannot change the local interval-size readout. The current best positive
T2 target is now banked in
`PhysicsSM.Draft.NullEdgeP9SubdiamondRestrictionPreservesLocalReadout`:
Alexandrov/subdiamond restriction preserves the local interval-size readout
under transitivity. Interval-rank threshold and spectral/Laplacian no-go routes
remain lower-priority backups.
For causal-response kernels, Aslanbeigi-Saravani-Sorkin's generalized causal-set
d'Alembertians (`DQ9CF6I2`) provide the right comparison class: retarded and
Lorentz-invariant but nonlocal operators with infrared recovery conditions and
stability caveats. The finite causal-support lemmas are therefore guardrails for
response locality, not replacements for a stability or scaling theorem.
Boguna-Krioukov's local causal-set d'Alembertian (`I72KXVQA`) sharpens the
opposite side: intrinsic causal-set distance data may support a local operator
with continuum convergence. That makes `edgeNeighbor_N` a genuine finite
effective-locality hypothesis to test, rather than a naive bounded-valency
assumption.

This gives a crisp decision threshold. If coherent hidden bookkeeping sources
a volume term, the program has not improved the cosmological-constant problem.
If the residual source inherits the everpresent-Lambda CMB-era amplitude
tension without a suppression or correlation mechanism, the flagship branch is
phenomenologically weak even if the finite algebra is beautiful.

The generation question should be sharpened by the same separation. The visible
null geometry does not distinguish an electron from a muon or tau; it only sees
the Pluecker/celestial mass geometry. Generations should therefore live in the
internal label and Yukawa/flip-amplitude layer. A promising sourced hypothesis
is that the visible sector is the rank-2 Jordan algebra `H_2(C)` of Hermitian
complex matrices, while the internal generation sector is controlled by the
rank-3 exceptional Jordan algebra `H_3(O)`. This does not yet explain mass
ratios or mixing matrices, but it gives a disciplined reason to look for
"three" in the internal octonionic/Jordan layer rather than in spacetime null
kinematics.

The complementary bivector synthesis must now be stated more carefully. The
program should not collapse every object written with a wedge symbol into one
representation. The Pluecker mass uses the antisymmetric invariant
`Lambda^2 S ~= C`; self-dual curvature and Plebanski fields use
`Sym^2 S ~= Lambda^2_+`; visible momentum lives in `S tensor Sbar`. The
genuine common arena is the four-dimensional bivector/Klein-quadric geometry:
decomposable bivectors obey the Pluecker relation, lie on the Klein quadric,
and model the finite pairwise simplicity condition. This is a handle, not just
vocabulary, but it is strongest for two-edge or pairwise statements. For
larger bundles, the assembly principle should be closure/Gauss law, not a
claim that one simple bivector explains all data.

The next higher-gauge target is equally concrete. The path-pair composition
laws now pass the finite interchange/fake-flatness test in a crossed-module
wrapper: fake-flatness is preserved by vertical and horizontal 2-cell
composition, and the 2-cell labels satisfy the double-category interchange law.
The remaining question is whether the `H`-valued 2-cell labels, endpoint
actions, and fake-flatness law are forced by the causal-diamond geometry rather
than being optional packaging.

A complementary graph-theoretic cleanup is to make "null" observable-relative:
an edge or chain is null only with respect to a chosen invariant or quotient.
This is not a new physical mechanism, but it prevents ambiguity. The same
finite edge can be invisible to connectivity, visible to spectrum, removable by
gauge, or homologically trivial only as part of a boundary chain. The useful
near-term target is a small diagnostics API for quotient, gauge, homology, and
spectral nullity around the existing Plucker and diamond observables.

## Current theorem inventory and remaining challenges

### Already proved or kernel-checked

- **Finite checkerboard skeleton.**
  `PhysicsSM.Spinor.Checkerboard` defines finite lightlike histories, corner
  weights, endpoints, terminal directions, finite path sums, and first-step
  decomposition. `PhysicsSM.Spinor.CheckerboardDynamics` adds trusted
  kernel-clean dynamics theorems: history counts, corner-weight powers,
  last-step recursion, evolution by iterated transfer operator, and a finite
  Klein-Gordon-style recurrence. The kernel-clean draft
  `PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle` proves endpoint
  closed forms for the right-starting right/right and right/left kernels.

- **Pluecker mass from null spinor bundles.**
  `PhysicsSM.Spinor.PluckerMass` is now the trusted algebraic keystone. It
  proves the two-edge determinant identity, the general finite bundle identity
  \(\det(\sum_i \psi_i\psi_i^\dagger)=\sum_{i<j}|\psi_i\wedge\psi_j|^2\),
  real nonnegativity, and the zero-mass/common-direction criterion.

- **Twistor/Pluecker matching wrapper.**
  `PhysicsSM.Spinor.TwistorPluckerMass` is now a trusted convention wrapper,
  promoted from the earlier draft. It shows that the spinor-chart two-twistor
  mass invariant reduces to the Pluecker wedge term, records the
  determinant-vs-trace normalization bridge, proves rescaling behavior, and
  extends the pairwise mass formula to finite multi-twistor charts. The draft
  module remains useful as provenance, but the theorem inventory should cite
  the trusted `PhysicsSM.Spinor` module.

- **Higgs/Yukawa permission for chirality flips.**
  `PhysicsSM.Draft.NullEdgeYukawaGaugeAristotle` proves the finite bookkeeping
  layer: the Higgs insertion carries the needed hypercharge, left and right
  multiplets have the expected chiralities, and the finite Yukawa flip patterns
  satisfy weak, color, electroweak, and combined gauge-legality predicates.

- **Causal-diamond holonomy.**
  `PhysicsSM.Gauge.CausalDiamondHolonomy` is trusted and kernel-clean. It proves
  Abelian gauge invariance of the diamond defect, non-Abelian endpoint
  covariance, gauge invariance of class functions of the defect, and vertical
  and horizontal composition laws for path-pair defects.

- **Crossed-module fake-flatness wrapper.**
  `PhysicsSM.Draft.NullEdgeP3CrossedModule` is a kernel-clean draft wrapper for
  the higher-gauge diamond layer. It proves that fake-flatness is preserved
  under vertical and horizontal 2-cell composition, and that crossed-module
  2-cell labels satisfy the interchange law. This supports the double-category /
  2-group reading of finite causal diamonds, while leaving the geometric
  meaning of the `H`-valued surface labels as the next physics-facing task.

- **Order-complex cochain seed.**
  `PhysicsSM.Draft.NullEdgeCochainDiamond` provides the finite cochain seed:
  the cochain coboundary dual to the order-complex boundary squares to zero.
  This is still a draft theorem island, not yet a full Kähler-Dirac graph
  operator.

- **Gram-weighted hidden-label mass.**
  `PhysicsSM.Draft.NullEdgeGramWeightedMassAristotle` now proves the finite
  Cauchy-Binet exterior-square formula
  `det(M G M^dagger) = w^dagger (Lambda^2 G) w`, together with the
  orthonormal-Gram reduction to the trusted Pluecker theorem, the rank-one
  internal coherence massless limit, and the two-state partial-coherence
  bridge. This is the strongest finite algebra currently supporting the
  flavor-overlap/Yukawa-hierarchy line.

- **Finite hidden-isometry invariance.**
  `PhysicsSM.Draft.NullEdgeTwoTwistorHiddenChannelAristotle` now proves that a
  finite column-isometric hidden-basis change preserves the visible reduced
  density of a hidden-labeled spinor family, and therefore preserves the
  twistor/Pluecker determinant-mass wrappers downstream.

- **Finite quantum-measure core.**
  `PhysicsSM.Draft.NullEdgeQuantumMeasureFiniteAristotle` now proves finite
  event-amplitude additivity, decoherence-functional additivity, the
  grade-2 quantum-measure sum rule for three disjoint events, strong
  positivity of the rank-one decoherence Gram form, and tensor-product
  closure on rectangular events.

- **Finite Dirac square-root core.**
  `PhysicsSM.Draft.NullEdgeDiracSlashCore` now proves the explicit static
  `(+---)` Weyl-block calculation: `det(p.sigma)` is the Minkowski scalar,
  `sigma(p) barSigma(p)` and `barSigma(p) sigma(p)` are that scalar times the
  identity, and the chiral `4 x 4` Dirac slash squares to the same scalar.
  This is the first kernel-checked operator-level square root of the program's
  determinant-mass spine.

- **Finite bundle Dirac-Pluecker bridge.**
  `PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore` now composes the trusted
  `PhysicsSM.Spinor.PluckerMass.fin_bundle_plucker_mass_identity` with the
  static chiral Dirac slash. It extracts Weyl coordinates from the finite
  bundle momentum and proves
  `chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass`: the slash built from
  the bundle momentum squares to the trusted pairwise Pluecker mass. This is
  the strongest current finite bridge from the mass theorem to a first-order
  operator.

- **Finite Pluecker/Bargmann phase core.**
  `PhysicsSM.Draft.NullEdgePluckerBargmannPhaseCore` now proves the complex
  phase companion to the mass theorem: the two-spinor Lagrange identity,
  ket-bra trace and product laws, projector multiplication with overlap
  amplitude, the Bargmann/Pancharatnam triple trace, and the normalized
  Pluecker/overlap complement identity. This preserves first-order phase data
  that the squared Pluecker modulus discards.

- **Finite super-Dirac block-square core.**
  `PhysicsSM.Draft.NullEdgeSuperDiracBlockCore` now proves the abstract
  finite block algebra behind the causal super-Dirac proposal: an off-diagonal
  first-order operator squares to diagonal `psi * phi` and `phi * psi` blocks,
  chirality anticommutes with the odd operator, the `d + delta` Hodge-Dirac
  block square gives the two finite Laplacians, and a scalar Higgs/Yukawa flip
  squares to `m^2` on both chiralities.

- **Finite superconnection expansion core.**
  `PhysicsSM.Draft.NullEdgeSuperconnectionExpansionCore` now proves the next
  block-level expansion: the square of an abstract
  `d + delta + Phi + Phi^dagger` operator decomposes into Laplacian,
  cross/curvature, and Higgs-mass blocks, with clean no-cross corollaries.
  This is the finite Quillen/Lichnerowicz-style algebra needed before putting
  the operator on an actual causal order complex.

- **Finite covariant-differential curvature core.**
  `PhysicsSM.Draft.NullEdgeCovariantDifferentialCore` now proves the scalar
  transport seed for a graph curvature block: applying the twisted
  differential twice on an oriented triangle gives
  `(U i j * U j k - U i k) * f k`, with flat-triangle vanishing and finite
  gauge-covariance laws for zero-cochains, one-cochains, and triangle
  curvature. This is the first integrated finite `d_U^2 = curvature` theorem
  for the super-Dirac operator spine.

- **Finite two-sheet projector core.**
  `PhysicsSM.Draft.NullEdgeDiracTwoSheetCore` now proves that any finite
  operator satisfying `D^2 = m^2 I` with `m != 0` forces complementary plus and
  minus projectors `(1/2)(I plus/minus m^{-1}D)`, with orthogonality and
  eigenvalue equations `D P_+ = m P_+` and `D P_- = -m P_-`. This is the
  algebraic two-sheet branch structure implied by the Dirac square root. The
  interpretation must still be constrained by the standard Dirac branch and
  localization literature: Foldy-Wouthuysen `NFMI3A99`,
  Newton-Wigner `74NU4C33`, and Thaller's *The Dirac Equation* `UI9343SX`.

- **Finite chiral mass-shell projectors.**
  `PhysicsSM.Draft.NullEdgeDiracMassShellProjectorsCore` specializes the
  abstract two-sheet algebra to the concrete chiral Dirac slash. On a mass
  shell `minkowskiNorm p = m*m`, it proves idempotence, orthogonality, and
  the `+m`/`-m` eigenvalue equations for the slash branch projectors.

- **Finite observer-channel mass core.**
  `PhysicsSM.Draft.NullEdgeObserverChannelCore` packages the sharpened
  observer-channel conjecture into finite theorem surfaces. It distinguishes
  the unnormalized resolution output from the kinematic normalization, proves
  `SL(2,C)` determinant invariance for the resolution output, records scalar
  filtering of normalized visible data, factors the two-label internal Gram
  channel as visible Plucker spread times the hidden Gram determinant, proves
  dephasing monotonicity of that factor, proves the unital visible-channel
  mass-ratio-square monotone, and records a toy counterexample showing why
  entangling hidden dynamics cannot be covered by an unrestricted monotonicity
  slogan.

- **Finite Schmidt determinant bridge.**
  `PhysicsSM.Draft.NullEdgeSchmidtDeterminantCore` proves that, for a real
  two-qubit pure-state coefficient matrix, the visible reduced determinant and
  chirality/internal reduced determinant are equal, and both equal the square
  of the coefficient determinant. This banks the determinant part of the
  mixedness/coherence duality while leaving the boosted chirality-coherence
  interpretation behind an explicit balance/frame convention.

- **Finite super-Dirac Krein core.**
  `PhysicsSM.Draft.NullEdgeSuperDiracKreinCore` formalizes the Lorentzian
  refinement of the super-Dirac conjecture. It defines finite
  `J`-self-adjointness, the mass-shell branch symmetry `J = (1 / m) D`, proves
  that `J^2 = 1` when `D^2 = m^2 I`, identifies this `J` with the difference of
  the plus and minus branch projectors, and introduces a `MassShellConstraint`
  predicate to record equality of the kinetic Pluecker symbol and Yukawa square
  rather than adding them as two mass blocks.

- **Finite null-step quantum-walk norm core.**
  `PhysicsSM.Draft.NullEdgeQWNormPreservation` proves that the closed-form
  `Rz`, `Rx`, and one-step `Ua` gates preserve the two-component spinor
  norm-square. This is a small but useful P4 check: the finite null-step
  transfer is norm-preserving before any continuum or fixed-point claim.

- **Finite P4 null-step fixed-point guardrails.**
  `PhysicsSM.Draft.NullEdgeP4PauliNo2x2Mass` proves that a single `2 x 2`
  Weyl space cannot host an invertible mass matrix anticommuting with all three
  Pauli matrices, so the mass term forces `L plus R` doubling. The companion
  `PhysicsSM.Draft.NullEdgeP4VisibleDetInvariant` proves determinant-one
  visible congruence invariance of the unnormalized visible determinant and
  records the trace-normalized determinant formulas for the observer-conditioned
  `m / E` readout. `PhysicsSM.Draft.NullEdgeP4ScalarFlipIsotropy` proves that
  Pauli isotropy forces the chirality-flip generator to be scalar, so vector
  flip components are anisotropic couplings rather than mass.

- **Finite observer-channel purity contraction.**
  `PhysicsSM.Draft.NullEdgeP7BlochContractionPurity` proves that a unital
  Bloch contraction cannot increase purity and strictly decreases it for a
  nonzero radius under a genuine contraction. This is the purity-side
  companion to the observer-channel mixedness and relative-entropy lane.

- **Finite P9 noise-response tests.**
  `PhysicsSM.Draft.NullEdgeP9DeltaPairTestBasis`,
  `PhysicsSM.Draft.NullEdgeP9NoiseBilinearCauchy`, and
  `PhysicsSM.Draft.NullEdgeP9NoiseResponseAmplitudeZero` prove a small finite
  noise API: delta/pair tests detect entries of the symmetric noise kernel,
  the induced bilinear form obeys Cauchy-Schwarz under nonnegative weights,
  and under positive weights zero quadratic response is equivalent to all
  centered test amplitudes vanishing. This supports the source-visibility/noise
  conjecture without yet proving a cosmological response law.

- **Finite P9 harmonic/projector source-visibility tests.**
  `PhysicsSM.Draft.NullEdgeP9ClosedWitness`,
  `PhysicsSM.Draft.NullEdgeP9BoundaryVisibleDecomp`,
  `PhysicsSM.Draft.NullEdgeP9WeightedNoiseBound`,
  `PhysicsSM.Draft.NullEdgeP9HarmonicProjectorResponse`, and
  `PhysicsSM.Draft.NullEdgeP9ProjectedNoiseKernel`, and
  `PhysicsSM.Draft.NullEdgeP9OrthogonalProjectorCore`,
  `PhysicsSM.Draft.NullEdgeP9StrictProjectedKernel`, and
  `PhysicsSM.Draft.NullEdgeP9ConditionedResponseBound`,
  `PhysicsSM.Draft.NullEdgeP9CoarseResidualVariance`,
  `PhysicsSM.Draft.NullEdgeP9RankOneHarmonicTrace`,
  `PhysicsSM.Draft.NullEdgeP9WeightedAdjointCore`, and
  `PhysicsSM.Draft.NullEdgeP9WeightedLaplacianEnergy`, and
  `PhysicsSM.Draft.NullEdgeP9HarmonicKernelCore`,
  `PhysicsSM.Draft.NullEdgeP9HodgeProjectorInstantiation`,
  `PhysicsSM.Draft.NullEdgeP9CoarseKernelPSD`,
  `PhysicsSM.Draft.NullEdgeP9CoarseBoundaryInvariance`, and
  `PhysicsSM.Draft.NullEdgeP9TwoCellTraceSeparation`, and
  `PhysicsSM.Draft.NullEdgeP9CausalSupportBound`, and
  `PhysicsSM.Draft.NullEdgeP9RetardedNilpotentReach`, and
  `PhysicsSM.Draft.NullEdgeP9EdgeNeighborReach`, and
  `PhysicsSM.Draft.NullEdgeP9RetardedGreenSeries`, and
  `PhysicsSM.Draft.NullEdgeP9SelectedSectorTraceDensity`,
  `PhysicsSM.Draft.NullEdgeP9BlockAliasingGuardrail`,
  `PhysicsSM.Draft.NullEdgeP9OffsetWindowGuardrail`, and
  `PhysicsSM.Draft.NullEdgeP9BoundaryVolumeScaling`, and
  `PhysicsSM.Draft.NullEdgeP9WeightedProjectorPythagorean`,
  `PhysicsSM.Draft.NullEdgeP9DefectSensitivityBenchmark`,
  `PhysicsSM.Draft.NullEdgeP9IsohistogramSeparation`,
  `PhysicsSM.Draft.NullEdgeP9DiamondLocalSeparation`, and
  `PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail`, and
  `PhysicsSM.Draft.NullEdgeP9DiamondLocalityNoiseInvariance`, and
  `PhysicsSM.Draft.NullEdgeP9SubdiamondRestrictionPreservesLocalReadout` prove
  the next finite source-visibility layer: closed tests ignore boundary-exact sources,
  nonzero
  closed-test pairing witnesses visible residual source content, bounded
  weighted cells give a finite response bound, harmonic/projected tests see
  only projected sources under a self-adjoint projector, residuals are
  orthogonal to harmonic tests for self-adjoint idempotent projectors,
  projection preserves positive-semidefinite noise response, strict positivity
  rules out hidden projected null modes, and two-sided response bounds control
  the response-to-projected-norm ratio. The new explicit metric/Hodge spine
  proves that coarse block variances preserve total fine variance, the rank-one
  mean projector has trace density `1/n`, the codifferential is the weighted
  adjoint of the coboundary, the weighted 1-Laplacian pairing splits into
  down-energy and up-energy square terms, and the weighted finite 1-Laplacian
  is self-adjoint with kernel exactly `closed and coclosed`; a self-adjoint
  idempotent projector onto that harmonic sector annihilates exact boundary
  bookkeeping and preserves
  projected responses/pairings under exact boundary perturbations; a weighted
  self-adjoint idempotent projector makes projected observer-channel tests see
  only the projected source, with the residual weighted-orthogonal to all
  projected tests, and the weighted source energy splits exactly into
  projected/coarse energy plus residual energy. The minimal two-triangle
  defect-sensitivity benchmark shows that common-mode curvature bookkeeping is
  invisible to the linearized diamond-defect readout, while differential
  curvature perturbations are visible and create nonzero defect from a flat
  baseline. The iso-histogram guardrails show first that separate marginal
  histograms do not determine a frozen joint readout, then the stronger T1 fact
  that matched joint degree and global interval signatures can still differ on
  a same-size diamond-local interval readout. The coarse-map erasure guardrail
  proves the negative T2 control: collapsing the critical swapped vertices
  erases that T1 signal, so positive coarse stability must be proved for a
  pre-specified admissible class. The latest C4 guardrails show
  that fixed coarse maps preserve
  PSD noise kernels and nonnegative trace readouts, are invariant under
  annihilated boundary
  perturbations, and can detect movement in diagonal kernel weights in a
  two-cell toy readout; the causal-support guardrail shows that a response
  kernel supported inside a finite causal relation cannot propagate localized
  source data outside the source's discrete causal reach; the
  acyclic-retarded guardrail shows that if support strictly decreases a finite
  rank, exact reach is empty beyond the rank height and the iterated response
  kernel vanishes; the `edgeNeighbor_N` scaffold formalizes effective
  link-locality as a bounded endpoint-diamond relation stable under induced
  subdiamonds, with iterated response confined to exact finite step reach; the
  finite retarded Green-series scaffold proves that when a retarded kernel is
  nilpotent on a vector, the terminating series `sum_{m < H} K^m x` solves
  `(I - K) y = x` exactly; the selected-sector trace-density scaffold proves
  the finite area-vs-volume algebra `k/n` for a Boolean-selected visible sector.
  The block-aliasing guardrail proves the matching negative fact: a size-4 block
  average can make a rank-one mode invisible solely because the within-block
  sum is zero, so coarse trace zeros need an intrinsic-map or offset-invariance
  audit. The offset-window guardrail strengthens that negative control: one
  aligned block-window zero need not survive a shift, and even all shifted
  four-cell window traces can annihilate a nonzero high-frequency mode. The
  boundary-volume scaling scaffold adds the toy four-dimensional law that
  boundary-over-volume density is `C / L`, crosses any positive threshold at
  large enough scale, and halves under scale doubling. The intrinsic-order
  observable scaffold proves that interval abundance and out-degree histograms
  are invariant under finite relabeling, giving the P9 coarse-map program a
  first Lean-facing order-intrinsic alternative to offset-sensitive block
  statistics.
  The matched P9 ensemble pilot
  `AgentTasks/p9-pilot-matched-diamond-ensemble-2026-06-23.json`, generated by
  `Scripts/p9/pilot_ensemble.py`, adds an important guardrail: boundary and PSD
  checks pass, but the main fine trace-density statistic does not yet clear the
  proposed `10x` within-family-spread threshold on the larger tested toy
  diamonds. The block-size `4` coarse statistic clears the threshold but should
  be treated as a possible coarse-map alignment artifact until a
  geometry-forced coarse map is specified. The offset sweep
  `AgentTasks/p9-pilot-matched-diamond-offset-sweep-2026-06-23.json` sharpens
  this warning: shifting the block grid makes the flat block readout nonzero
  and can erase the separation, so the next numerical gate is offset
  invariance or an intrinsic causal/diamond coarse map.
  The missing physics step is still a
  geometry-dependent finite diamond metric, coarse-graining map, and response
  law.

- **Finite P11 lifetime threshold.**
  `PhysicsSM.Draft.NullEdgeP11LifetimeThreshold` proves the logarithmic
  inequality turning "eigenvalue close to one" into a finite lifetime
  threshold bound. This is a modest but concrete stable-sector readout lemma.

### Remaining high-value challenges

- **Promote kernel-clean drafts after semantic review.**
  Several draft modules are kernel-checked but still need API cleanup,
  provenance tightening, naming review, and convention audits before they
  should be treated as trusted public surfaces.

- **Prove dynamics, not just algebra.**
  The largest physics gap is still the continuum or scaling theorem saying
  that null-edge histories with a chirality-flip intensity flow to a Dirac
  operator with effective mass. The finite checkerboard theorems are strong,
  but they do not yet prove higher-dimensional universality.

- **Specify the operator before adding invariants.**
  The Dirac critique should now be treated as a gate on new ambitious targets.
  A proposed result is not mature until it names the finite state space, the
  grading, the inner product or adjoint, the first-order operator, the symmetry
  or covariance law, and the exact square-level observable it recovers. Without
  these data, another beautiful determinant, norm, or curvature defect is only
  supporting evidence, not the main structure.

- **Use forcing-vs-restating as the promotion test.**
  A branch advances only when the finite geometry forces a constraint,
  scaling law, no-go, or measurable pilot. It is demoted when it merely
  translates an existing physics problem into null-edge vocabulary. Under this
  rule, source visibility, the super-Dirac square, simplicity defect, and
  generation blindness are high-value; black-hole information, strong CP,
  confinement, and generic hierarchy language remain watch-list items.

- **Move beyond the spinor chart in twistor theory.**
  The current twistor result is a valuable chart-level wrapper. It does not
  yet formalize full twistor incidence, projective twistor geometry, real
  structures, or Penrose-transform/cohomological statements.

- **Give the higher-gauge diamond layer geometric content.**
  The trusted diamond module handles ordinary group-valued holonomy defects,
  and `PhysicsSM.Draft.NullEdgeP3CrossedModule` now supplies a kernel-clean
  crossed-module/fake-flatness wrapper. The remaining work is to connect the
  abstract `H`-valued 2-cell labels to finite causal-diamond surface data,
  endpoint covariance, and a physically meaningful fake-flatness or curvature
  response law.

- **Formalize the bivector/BF wrapper.**
  The new synthesis asks for a finite `B`-cochain interface connecting
  Plucker mass defects and diamond curvature pairings. The near-term theorem
  should identify the `B` simplicity/Gram defect with the trusted Plucker mass
  and prove compatibility of `B`-weighted diamond pairings with existing
  vertical/horizontal composition laws. Plebanski, Urbantke, and
  Higgs-from-enlarged-connection interpretations remain sourced continuum
  motivation.

- **Take the Dirac square root of the Plucker theorem.**
  The trusted Plucker theorem is a determinant/squared-modulus statement. The
  next finite target is a Clifford wrapper showing that the slash of the
  bundle momentum squares to the Plucker scalar times the identity. This is
  the analysis-free bridge from the static mass theorem to a first-order
  operator language.

- **Unify Plucker mass, Higgs flips, and diamond curvature as blocks of one
  finite super-Dirac square.**
  The ambitious operator target is not merely \(D=d+\delta\), but a covariant
  graded operator \(D_{U,\Phi}=d_U+\delta_U+\Phi+\Phi^\dagger\) whose square
  contains the graph Laplacian, diamond curvature, Higgs/Yukawa mass block,
  and visible Plucker scalar. This should be treated as the master
  falsification criterion for the finite synthesis.

- **Turn the order-complex seed into a fermion operator.**
  The cochain \(d^2=0\) theorem is only the start. A Kähler-Dirac route needs
  a graded Hilbert structure, adjoint/codifferential, Hodge-star or metric
  data, and a careful treatment of doubling and chirality. The cleanest
  concrete targets are Bianconi's topological Dirac operator \(D=d+\delta\)
  with \(D^2\) the Hodge Laplacian, \(\{\gamma,D\}=0\), and gapped spectrum
  \(E=\pm\sqrt{\lambda^2+m^2}\); the causal poset's lack of translation
  symmetry voids the Nielsen-Ninomiya doubling obstruction.

- **Add observable-relative nullity diagnostics.**
  The graph-theory extraction is useful as a finite API: quotient-internal
  edges vanish under quotient incidence, exact Abelian 1-cochains have trivial
  cycle holonomy, tree-supported phases are gauge-removable, boundary chains
  are homology-null, and low-mode spectral nullity is measured by endpoint
  eigenfunction differences. This should remain a support layer for the main
  Plucker/diamond observables, not a replacement for them.

- **Keep gravity and quantum-measure claims conjectural.**
  The null-horizon entropy/flux route and Bell/decoherence-functional layer
  remain research directions. They need finite observables and falsifiable
  pilots before they should be elevated to theorem targets.

## Main corrections

### Do not lead with ontology

"All motion is luminal" is a powerful slogan, but the trusted content should
be stated at the level of propagators, finite path sums, spinor identities,
and graph amplitudes. The ontology can be discussed, but it should not carry
the proof burden.

The safe claim is:

> Certain relativistic propagators and finite path sums have exact
> descriptions in terms of null or lightlike microscopic steps, with mass
> appearing as a chirality-mixing or corner amplitude.

This is supported by the 1+1-dimensional Feynman checkerboard, by
projector-weighted 3+1-dimensional checkerboard constructions, and by
Dirac/Weyl quantum walks. It is not yet a universal theorem for arbitrary
random null-edge ensembles.

### Drop the octonionic equality-gap selection principle

The long draft contains an earlier conjecture that the octonionic case might
break the equivalence:

```text
sum of future null momenta is null iff all summands are parallel
```

The later correction is the one to keep. In Lorentzian geometry, for future
null momenta \(p_i\),

\[
\left(\sum_i p_i\right)^2 = 2 \sum_{i<j} p_i \cdot p_j,
\]

and \(p_i \cdot p_j \ge 0\), with equality only for parallel future null
vectors. Therefore a sum of future null momenta is null exactly when the
summands are all parallel. This argument is independent of octonionic
associativity.

The reason to use complex spinors for visible spacetime should instead be:

- observed spacetime is 3+1-dimensional;
- ordinary Weyl spinors are complex two-spinors;
- twistor theory is naturally complex;
- octonions are better suited to internal/triality/gauge data.

So the strengthened program should not try to prove an octonionic equality
gap. It should use the proven complex mass-collinearity theorem cleanly, then
place the octonionic layer in the internal transition sector.

### Separate visible geometry from internal labels

The most stable two-layer architecture is:

```text
visible null geometry: complex spinors / twistors
internal transition algebra: octonions, triality, E8-like labels
```

An edge has visible null momentum

\[
p_e^{AA'} = \psi_e^A \bar\psi_e^{A'}
\]

with \(\psi_e \in \mathbb C^2\). It may also carry an internal label
\(\lambda_e\) from an octonionic, Furey-Hughes, Spin(10), or E8-adjacent
structure. The visible spinor says how the edge contributes to spacetime
momentum. The internal label says which particle/gauge/Higgs transition is
allowed at vertices.

This avoids forcing octonions to do the wrong job.

### Three generations belong to the internal Jordan layer

The celestial/Pluecker theorem makes an important negative statement: the
visible null geometry is generation-blind. Its determinant mass only sees the
rank-one spinor bundle through the monopole/dipole data, or equivalently
through pairwise Pluecker spread. It has no natural slot for "electron versus
muon versus tau." Therefore generation structure should not be sought in the
visible null direction distribution; it belongs to the internal labels
\(\lambda_e\), Yukawa amplitudes, and allowed transition algebra.

The useful algebraic lens is Jordan-theoretic. The visible momentum space is
`H_2(C)`, the Jordan algebra of `2 x 2` complex Hermitian matrices: rank-one
idempotents are celestial null directions and the determinant is the
Lorentzian norm. The Pluecker mass theorem is then the finite statement that
the norm of a sum of rank-one visible idempotents equals the total pairwise
spread.

The internal layer has a different natural Jordan candidate: the Albert
algebra `H_3(O)`, the exceptional Jordan algebra of `3 x 3` Hermitian
octonionic matrices. Dubois-Violette, Todorov, and Boyle use this algebraic
neighborhood to model Standard Model internal structure and three generations.
For this program, the conservative claim is not that the fermion spectrum is
explained, but that the place where "three" can be structural is the internal
exceptional Jordan layer. The fact that the octonionic Jordan matrix
construction has an exceptional rank-3 endpoint is exactly the kind of
nonassociative constraint that belongs internally, not in visible spacetime
collinearity.

The substrate side is not merely aspirational: the repo already contains
trusted `H_3(O)`/Albert-algebra Lean infrastructure, including the concrete
coordinate model, Jordan product, trace form, and related projective-geometry
building blocks. The real open gap is therefore not "define the Albert
algebra"; it is to connect that trusted substrate to representation data,
Yukawa freedom, and CKM/PMNS-style mixing without adding ad hoc states.

This gives a clean hypothesis:

```text
visible mass geometry: H_2(C), determinant norm, CP^1 celestial directions
internal generation geometry: H_3(O), Albert algebra, rank-three family slot
```

The sharper triality version of this lead is: the three off-diagonal
octonionic entries of `H_3(O)` carry the three inequivalent Spin(8)
eight-dimensional representations, cyclically permuted by triality. If the
Albert layer is physically useful, generations should appear as a broken
triality orbit after choosing a complex structure or Standard Model gauge
embedding. This is a lead, not a handle: exact triality lives at the Spin(8)
level, and the Standard Model embedding breaks it. The branch should be
demoted if the breaking does not naturally single out three families with
usable Yukawa and mixing data.

Caveat: this is a counting and representation-organization lead, not a mass
spectrum theorem. The charged-lepton/quark hierarchies and CKM/PMNS mixing
would have to come from eigenvalue/off-diagonal structure or dynamics in the
internal algebra. They are not produced by the Pluecker mass theorem.

The Barnum-Graydon-Wilce composite obstruction is a useful guardrail here.
Under reasonable composite-system axioms for Euclidean Jordan algebras, an
exceptional Jordan summand cannot be freely combined with another nonclassical
factor in the way ordinary complex quantum systems can. This supports the
idea that `H_3(O)` is an internally rigid substrate rather than just another
associative state space in disguise. It does not by itself derive the Standard
Model. The promotable target is a source-backed prose/formal note: state the
precise composite axioms, show where the Albert algebra is the exceptional
obstruction, and then keep the physics claim conditional on a separate
representation/Yukawa construction.

The quantum-marginal / entanglement-polytope literature gives this branch a
more disciplined hierarchy target. If the internal `H_3(O)` or triality layer
really constrains global states, it should restrict the possible spectra of
visible reduced density matrices. Then mass ratios become allowed-spectrum
data, not free prose. The finite target is to compute or bound the visible
mass spectra admitted by the proposed internal state space before claiming
anything about observed Yukawa hierarchies.

### Treat finite valency as effective, not fundamental

Lorentz-invariant causal discreteness is not compatible with a fundamental
fixed finite-valency graph in the naive lattice sense. The program should
therefore distinguish:

```text
fundamental structure: Lorentz/conformal invariant incidence measure,
                       generally infinite-valency or nonlocal;
effective histories: finite particle-like paths after coarse-graining,
                     decoherence, or conditioning on boundary data.
```

This is not a retreat. It is the natural form of the theory if the basic data
are null rays or projective twistors rather than sites on a rigid lattice.

The energetic-causal-set locality lesson should be stated at the same level.
Point-neighborhoods in a Lorentz-invariant sprinkling can be badly nonlocal,
but an edge-based theory may still have finite effective locality if the
observer restricts attention to links whose endpoint diamonds contain at most
`N` intermediate events. The useful finite definition is therefore not a
fundamental bounded-valency a x i o m, but an `edgeNeighbor_N` relation on causal
links. The first theorem target is small: in a finite causal set,
`edgeNeighbor_N` is finite by construction and stable under induced
sub-diamonds; only later should it be used as a locality hypothesis for
action sums or propagation kernels.

## Core mathematical spine

### 0. Dirac square-root criterion

The strongest operator-level sharpening is:

> Quadratic invariants are not primitive. They should be the square of a
> finite first-order causal operator.

The trusted program currently has many second-order outputs:

```text
det(P)                                      -- Plucker mass
sum_{i<j} |psi_i wedge psi_j|^2             -- pairwise spread
(N^2/4) * (1 - |nbar|^2)                    -- celestial dipole deficit
4 det(rho_vis)                              -- reduced visible mixedness
D^2                                         -- order-complex Laplacian seed
diamond holonomy defect                     -- curvature-like square data
```

The Dirac audit for any proposed extension is therefore:

```text
state space / bundle        -- what vectors the operator acts on
grading                     -- what "odd" or chirality means
inner product and adjoint   -- what self-adjointness means
first-order operator        -- the actual D, not just D^2
covariance law              -- gauge, causal, or basis-change behavior
square identity             -- which proved invariant appears in D^2
branch/phase data           -- what is lost when taking the square
```

This turns the program into an operator problem. A square identity is valuable
when it is a certificate for such a `D`; by itself it is only a quadratic
shadow. This is the most useful reading of the Dirac feedback: do not add a
new algebraic ornament until it has a place in the first-order operator.

The first finite square-root target is purely static. For a bundle of visible
null spinors, form

```text
P = sum_i psi_i psi_i^dagger = P_mu sigma^mu.
```

With gamma matrices satisfying

```text
gamma_mu gamma_nu + gamma_nu gamma_mu = 2 eta_{mu,nu} I,
```

the Dirac slash obeys

```text
(gamma . P)^2 = (P_mu P^mu) I = det(P) I.
```

The trusted Plucker theorem then identifies the scalar:

```text
(gamma . P)^2 = finPairwisePluckerMass(psi) I.
```

Near-term Lean targets:

```lean
hermitianTwoByTwo_det_eq_minkowski_norm
diracSlash_sq_eq_minkowski_norm
diracSlash_bundleMomentum_sq_eq_pluckerMass
leftRightDiracBlock_sq_eq_pluckerMass
higgsFlipBlock_sq_eq_yukawaMass
complexPluckerAmplitude_modSq_eq_pairMass
complexPluckerTriangle_phase_eq_pancharatnam
checkerboardFlipTransfer_sq_eq_kgRecurrence
diracSlash_massless_iff_common_spinor_direction
```

This does not yet prove dynamics. It factors the number already proved by
`PluckerMass` and gives the correct first-order object to connect to
checkerboard dynamics, chirality flips, and order-complex fermions.

The branch projectors are not optional decoration. Once a finite operator
satisfies `D^2 = m^2 I`, the plus and minus spectral projectors carry the data
discarded by the scalar square. The integrated
`PhysicsSM.Draft.NullEdgeDiracTwoSheetCore` theorem proves this algebraically;
the physics reading must then be checked against the Foldy-Wouthuysen
diagonalization, Newton-Wigner localization, and standard Dirac spectral
projector literature before claiming a particle/antiparticle or in/out
interpretation.

The full finite synthesis asks for a graded operator

```text
D_{U,Phi} = d_U + delta_U + Phi + Phi^dagger
```

on a finite causal order complex with visible spinor and internal label
fibers. Here \(U\) is edge/gauge transport and \(\Phi:E_L\to E_R\) is the
odd Higgs/Yukawa zero-form. This should be read as the finite
almost-commutative/spectral-triple pattern: the order-complex operator is the
external Dirac piece, while \(\Phi\) is the internal finite Dirac/Yukawa block
`D_F`. A useful correction is that the Pluecker determinant should not be
listed as an extra additive mass block. It is the kinetic symbol or
momentum-eigenvalue of the external block, while `Phi^dagger Phi` is the
internal/Yukawa mass block. The on-shell constraint is that these agree:

```text
kinetic symbol on bundle momentum P = det(P)
Yukawa mass block                    = Phi^dagger Phi
mass shell constraint                = det(P) = Phi^dagger Phi.
```

The desired square has the schematic form

```text
D_{U,Phi}^2 =
  covariant graph Laplacian
  + diamond curvature block
  + [D_U, Phi]
  + Phi^dagger Phi.
```

Here the graph Laplacian has symbol `det(P)` on a bundle-momentum eigenstate;
it is not a second mass term to be added to `Phi^dagger Phi`. The cross term
`[D_U, Phi]` should be interpreted as the finite gauged Higgs kinetic block,
not as noise to be discarded.

The newest super-Dirac audit sharpens this further. The missing theorem is not
another abstract expansion of `D^2`; it is the soldering or symbol theorem
showing that the first-order causal operator has local symbol equal to the
Dirac slash of the null-edge momentum bundle:

```text
[D, M_f]_x
  -> sum_y a_xy (f(y)-f(x)) gamma.p_xy
  -> weighted Pluecker mass after squaring.
```

This is the theorem that would make the static Dirac-Pluecker square root and
the order-complex Hodge/superconnection operator the same object. Without it,
the program has adjacent square-root theorems, not yet a unified causal
operator.

The correct product grading should also be explicit. There is a form/cochain
grading `Gamma_K` on the order complex and a left/right chirality grading
`Gamma_F` on the internal finite space. The clean product operator is better
written schematically as

```text
D_total = D_U + Gamma_K M_Phi,
Gamma_total = Gamma_K Gamma_F.
```

This keeps `Phi` degree-zero on the causal complex and odd only in chirality,
so the cross term is the gauged Higgs derivative rather than an uncontrolled
degree-mixing artifact.

The Lorentzian notation must distinguish three structures:

```text
eta      -- linear fundamental symmetry for the Krein product
JReal/C  -- antilinear real structure / charge conjugation
Sigma_m  -- mass-shell sheet involution D / m
```

The branch-projector theorem concerns `Sigma_m`. It should not be conflated
with the Krein fundamental symmetry or the antilinear real structure.

The program's theorem islands then become blocks of one square:

```text
checkerboard transfer       -> first-order propagation seed
Plucker determinant         -> kinetic symbol / mass-shell eigenvalue
Yukawa legality             -> allowed off-diagonal finite Dirac/Yukawa block
diamond holonomy            -> curvature block
order-complex d^2 = 0       -> cochain seed for d_U + delta_U
```

The exceptional-algebra extension should attach here, not in the visible mass
theorem. Replacing the usual Standard Model finite algebra by an
`H_3(O)`/Albert-algebra candidate is a hypothesis about the internal
`D_F`/Yukawa block. It must reproduce representation data without ad hoc
states before it can be promoted beyond a lead.

Noncommutative geometry now becomes an audit, not just inspiration. The finite
`D_{U,Phi}` candidate should be checked against the pieces of an almost-
commutative spectral triple that make sense on a finite causal order complex:
grading, real structure, first-order condition, inner fluctuation behavior,
orientability or volume-cycle surrogate, and low-order spectral-action terms.
If the audit fails, that is useful: it tells us exactly where causal incidence
differs from the Connes-Chamseddine template.

The closest graph-level prior art is Marcolli-van Suijlekom gauge networks
(arXiv:1301.3480), so the novelty claim must be narrower than "graph spectral
triple with Higgs." The null-edge contribution is the causal-directed,
Lorentzian/Krein, Pluecker-kinetic version. Perez-Sanchez's 2025 comment on
gauge networks is a useful failure mode: if the Higgs/Yukawa block becomes
constant or disappears under the relevant coarse-graining, then the finite
operator has not produced a dynamical Higgs sector.

Prize targets:

```lean
superDirac_productGrading_def
superDirac_kreinForm_def
superDirac_is_odd
superDirac_total_grading_def
superDirac_etaKreinAdjoint_def
superDirac_is_etaSelfAdjoint_or_antiSelfAdjoint
realStructure_chargeConjugation_def
massShellSign_eq_plusProjector_sub_minusProjector
covariantOrderDifferential_sq_eq_diamondCurvature
diamond_pathDefect_eq_holonomySubOne_mul_reference
higgsBlock_sq_eq_yukawaMassMatrix
nullGraphDirac_commutator_eq_localSymbol
localNullSymbol_sq_eq_weightedPluckerMass
massShellConstraint_iff_kernel_on_bundleMode
superDiracSq_crossTerm_eq_gaugedHiggsKinetic
firstOrderFlipGenerator_eigenvalue_eq_mass
causalSuperDirac_has_realStructure
firstOrderCondition_fails_or_forces_YukawaLegality
higgsPhi_is_innerFluctuation_of_finiteDirac
spectralAction_lowOrderTerms_eq_plucker_plus_diamond
```

This is also the clean falsification test. If no natural finite odd
Krein/J-self-adjoint first-order operator exists whose square simultaneously
produces the kinetic Pluecker symbol, causal-diamond curvature, Higgs kinetic
cross term, and Higgs/Yukawa chirality-flip block, then the synthesis is not
yet a unified Lorentzian theory. If the only self-adjoint construction is
positive-definite, the result is Euclidean or Wick-rotated and the honest
Lorentzian object may be a two-sheet/Krein pair rather than a single Hilbert
self-adjoint operator.

### 0a. Spinor irrep table and Bivector/BF wrapper

The finite theorem spine can use a bivector vocabulary only after the spinor
representations are separated. The old slogan "one `Lambda^2` object for mass
and gauge" is too coarse. The required Stage-0 irrep table is:

| object | spinor home | symmetry | role |
|---|---|---|---|
| Pluecker bracket `<ij> = epsilon_AB psi_i^A psi_j^B` | `Lambda^2 S ~= C` | antisymmetric, invariant scalar | mass/spread amplitude |
| Maxwell/Weyl/self-dual curvature spinor `phi_AB` | `Sym^2 S ~= Lambda^2_+` | symmetric, `(1,0)` rep | gauge/self-dual curvature and Plebanski chiral `B` |
| visible momentum `P_A dot A` | `S tensor Sbar` | Hermitian vector rep `(1/2,1/2)` | energy-momentum block |
| four-dimensional bivector `B in Lambda^2 C^4` | `Lambda^2` twistor/spacetime arena | Pluecker coordinates | Klein quadric, simplicity, incidence |

The finite wrapper should therefore distinguish a scalar Pluecker fan from a
four-dimensional bivector or chiral curvature field. This is a correction, not
a retreat: it tells the program exactly which functor each theorem belongs to.

With that convention table in place, the finite theorem spine can still be
organized by a bivector/Klein-quadric object `B`. This is a wrapper idea, not
yet a new trusted module.

```text
mass fan:
  B_ij = psi_i wedge psi_j
  mass defect = sum_{i<j} |B_ij|^2

diamond:
  B_D = finite surface/area label for a path-pair
  curvature pairing = <B_D, defect_D>
```

In this language, the Pluecker theorem says the scalar mass defect of the
spinor fan is exactly `det(sum_i psi_i psi_i^dagger)`. The diamond theorem
says the curvature carrier composes correctly under vertical and horizontal
gluing. The next target is to put these in one finite API only after the
representation labels above are attached, and then prove that the
`B`-weighted diamond pairing respects those gluing laws.

The Plebanski/BF interpretation is valuable motivation: continuum gravity can
be phrased using a two-form `B` paired with curvature, with simplicity
constraints and Urbantke metric reconstruction. But in this project that
belongs behind an explicit claim boundary, especially because Lorentzian
self-dual two-forms require complexification and reality conditions (the
area-metric reality constraint, Maran, arXiv:gr-qc/0504091).

The Klein quadric is the honest geometric meeting point. In
`Lambda^2 C^4`, a bivector is decomposable exactly when its Pluecker
coordinates obey the quadratic Klein relation. In twistor language this is the
quadric of 2-planes; in spin-foam language the nearby condition is simplicity;
in the two-edge null-spinor chart the discriminant/repeated-principal-spinor
condition reduces to the same scalar Pluecker invariant that controls
`det(P)`. Thus the finite slogan should be:

```text
decomposable bivector <-> Pluecker relation <-> Klein quadric <-> simplicity
```

This is strongest as a pairwise theorem. For a bundle with more than two null
edges, `P = sum_i psi_i psi_i^dagger` is a sum of rank-one momenta, not one
simple bivector. The multi-edge reconciliation should therefore pass through a
closure/Gauss-law statement such as `sum_f B_f = 0`, plus simplicity of the
individual faces, rather than pretending the whole bundle is one simple
bivector.

A clean finite target sits inside this picture: a 2-form `B` is simple (a
single wedge `u wedge v`) iff `B wedge B = 0` iff the associated Gram
determinant vanishes. For a two-edge spinor fan this is exactly the zero-mass /
common-direction criterion already proved in `PluckerMass`, so the spin-foam
simplicity constraint and the pairwise masslessness criterion become one finite
statement: mass is the simplicity defect. For more than two edges, the theorem
must be stated as a pairwise or closure-constrained assembly result.

Which simplicity constraint matters here is not a free choice. The older
quadratic form \(B^{IJ}\wedge B^{KL} \propto \epsilon^{IJKL} V\) (Barrett-Crane,
arXiv:gr-qc/9709028) over-restricts the state space and gives the wrong
graviton propagator. The modern resolution is the linear simplicity constraint
\(\mathcal N_J B^{IJ} = 0\) for a time-normal \(\mathcal N_I\), which maps the
bivector to the chiral \(su(2)\) subalgebra (EPRL, arXiv:0711.0146; FK,
arXiv:0708.1595), together with the closure constraint \(\sum_f B_f = 0\). The
time-normal is exactly what selects the \(su(2)_L\) of the
\(\Lambda^2_+ \cong su(2)_L \cong \mathrm{Sym}^2 S\) chain above, so the
finite target should match the linear constraint, and should distinguish the
single-bivector condition \(B\wedge B = 0\) (our Pluecker zero-mass criterion)
from the cross-bivector relations. One caveat to formalize honestly: the linear
constraint does not isolate a single Plebanski sector - it also allows the
degenerate sector and both \((II_\pm)\) sectors - so recovering gravity needs an
extra condition (Engle's proper vertex, arXiv:1107.0709, 1111.2865), and the
finite statement should track which sector the simplicity defect lives in. The
BF action also carries a Barbero-Immirzi / Holst weight \(\gamma\); that is a
convention choice and should be recorded in the Stage 0 table.

The useful extra spin-foam guardrail is Hopf-link volume simplicity. Bahr-
Belov and Assanioussi-Bahr show that, beyond linear face-normal simplicity,
extra volume/geometricity conditions associated with Hopf links of the
boundary graph are needed to reconstruct four-dimensional metric geometry in
EPRL-like bivector data. This should sharpen the `B` wrapper but not overstate
it. The finite null-edge target is a boundary-graph theorem: define Hopf-link
bivector volume functionals, prove their invariance under the finite graph
moves we actually use, and compare their vanishing/equality conditions with
the pairwise Pluecker simplicity defect. The continuum claim that these
isolate the physical Plebanski sector remains conditional; the literature
treats them as closely related geometricity conditions, not a completed
one-line sector projector.

Spinor networks and twisted geometries give the better finite phase-space
home for the closure/source branch. A spinor-network node has a moment-map
closure constraint. For a null-edge fan with weights `w_i` and celestial
directions `n_i`, the corresponding closure vector is

```text
C = sum_i w_i n_i.
```

The Pluecker/celestial theorem says

```text
m^2 = (1/4) * ((sum_i w_i)^2 - |C|^2).
```

Thus closure `C = 0` is a rest-frame or polyhedral-closure condition, not a
claim that the fan is massless or source-free. The source-visibility target
must distinguish visible momentum closure from BF face closure
`sum_f B_f = 0` and from internal bookkeeping closure. The useful theorem is
that closure defects are moment-map defects that can pair with a finite
diamond source functional, while closure-satisfying internal bookkeeping is a
candidate for boundary-only contribution.

Aristotle project `f1be6e52-31cc-411b-86b7-a841b1cfd318` has now completed the
focused standalone proof of the finite closure identity, pending local
integration. This strengthens the guardrail: visible closure is a rest-frame
condition, so P9 must prove invisibility for BF/boundary-exact or internal
bookkeeping data, not for visible closed massive fans.

### 0b. Observable-relative nullity wrapper

The term "null edge" should be treated as relative to an observable, not as a
single graph-theoretic species. For a finite graph observable `F`, an edge,
path-pair, or chain is `F`-null when the relevant deletion, quotient,
gauge-normalization, or homology projection has zero effect on `F`.

```text
connectivity/null matroid layer:
  edge deletion does not change the chosen structural invariant

quotient layer:
  endpoints are identified, so the quotient incidence vector vanishes

gauge layer:
  edge phases form an exact 1-cochain, so cycle holonomies vanish

homology layer:
  boundary chains represent zero classes, so nullity is chainwise

spectral layer:
  low-mode visibility is measured by endpoint eigenfunction differences
```

This wrapper is useful because the project's main observables are already
specific: Plucker mass sees angular spread in a null-spinor bundle, while
diamond holonomy sees path-pair curvature defects. The observable-relative
layer should supply reusable lemmas and numerical diagnostics, not a new
ontology.

Concrete finite theorem targets:

```lean
quotient_incidence_internal_edge_eq_zero
exact_one_cochain_has_trivial_cycle_holonomy
tree_phase_assignment_is_gauge_trivial
homology_null_boundary_chain
laplacian_rankOne_modeShift
```

The literature anchors added on 2026-06-21 are Spielman-Srivastava for
effective-resistance sparsification, Schaub et al. and Roddenberry et al. for
Hodge edge flows, Lange-Liu-Peyerimhoff-Post and Fabila-Carrasco-Lledo-Post
for magnetic Laplacians, and Kannan-Kumar-Pragada for gain-graph Laplacians.

### 1. Mass as Pluecker spread of null spinors

In 3+1 dimensions, represent a future null momentum by a rank-one Hermitian
spinor matrix:

\[
p_i^{AA'} = \psi_i^A \bar\psi_i^{A'}.
\]

For a coarse-grained bundle of null edges,

\[
P^{AA'} = \sum_i \psi_i^A \bar\psi_i^{A'},
\qquad
m^2 = \det P.
\]

The key complex identity is:

\[
\det\left(\sum_i \psi_i\psi_i^\dagger\right)
=
\sum_{i<j} |\psi_i \wedge \psi_j|^2.
\]

Thus mass is not a property of a single edge. It is a second-order invariant
of a bundle of null edges: the total pairwise angular spread of their null
directions. A single edge, or any collinear family of edges, is massless.
Non-collinear bundles are timelike.

The useful sharpening is to pass from spinors to their celestial directions.
For a normalized spinor, the rank-one Hermitian matrix has Bloch form

\[
\psi_i\psi_i^\dagger
= \frac{w_i}{2}(I+\vec n_i\cdot\vec\sigma),
\qquad
|\vec n_i|=1.
\]

Therefore the finite Pluecker theorem is equivalently the celestial moment
identity

\[
\det\left(\sum_i \psi_i\psi_i^\dagger\right)
=
\frac14\left[
\left(\sum_i w_i\right)^2
-
\left|\sum_i w_i\vec n_i\right|^2
\right].
\]

For equal unit weights this becomes

\[
m^2 = \frac{N^2}{4}(1-|\bar n|^2),
\qquad
\bar n=\frac1N\sum_i\vec n_i.
\]

Thus the monopole of the celestial distribution is energy, the dipole is
spatial momentum, and mass is the missing dipole. In representation language,
the mass functional only sees the l=1 moment of the direction distribution;
higher celestial multipoles are invisible to the determinant mass, though they
may still carry internal or shape data.

There is an equivalent reduced-density interpretation. Let the microscopic
state be a pure bipartite state

\[
|\Psi\rangle=\sum_a v_a\otimes e_a,
\]

where \(v_a\in\mathbb C^2\) is the visible null spinor and \(e_a\) is an
internal/chiral/Higgs bookkeeping state. If the internal alternatives are
orthonormal, or have decohered in the relevant observable, then tracing out
the internal factor gives

\[
P_{\rm vis}=\operatorname{Tr}_{\rm int}|\Psi\rangle\langle\Psi|
=\sum_a v_a v_a^\dagger,
\]

so the same Pluecker theorem gives

\[
\det P_{\rm vis}=\sum_{a<b}|v_a\wedge v_b|^2.
\]

The invariant statement is the unnormalized determinant. After choosing an
observer time convention and normalizing,

\[
\rho_{\rm vis}=\frac{P_{\rm vis}}{\operatorname{Tr}P_{\rm vis}}
=\frac12(I+\vec r\cdot\vec\sigma),
\qquad
\det\rho_{\rm vis}=\frac14(1-|\vec r|^2).
\]

Thus

\[
\frac{m}{E}=2\sqrt{\det\rho_{\rm vis}}
=\sqrt{2(1-\operatorname{Tr}\rho_{\rm vis}^2)}
\]

up to the chosen convention for \(\operatorname{Tr}P\) versus energy. In
units \(c=1\), \(m/E=d\tau/dt\). This is a frame-relative rate, not a Lorentz
scalar: the trace is the observer's energy component. Proper time is therefore
the visible rate of failure of the normalized celestial qubit to be pure after
a time convention has been fixed. A massless visible particle is a
rank-one/pure celestial state; a rest-frame massive particle is maximally mixed
in visible direction. The rest-frame statement is useful precisely because it
exhibits the frame dependence of normalized mixedness.

The caveat is important. For nonorthogonal internal labels,

\[
P_{\rm vis}=\sum_{a,b}\langle e_b,e_a\rangle\,v_a v_b^\dagger,
\]

so internal coherence can change the visible determinant. The clean pairwise
Pluecker sum is the orthonormal/decohered case; the coherent case is a
separate theorem target, not something to silently identify with a classical
bundle.

This is the best keystone theorem for the program because it converts the
central intuition into a finite-dimensional algebraic statement.

Three connections to existing literature sharpen and bound this. First, the two-edge case
is the Arkani-Hamed-Huang-Huang massive spinor-helicity identity
\(\langle\lambda^I\lambda^J\rangle = m\,\epsilon^{IJ}\) with
\(\det p = m^2\); the finite bundle identity is its Cauchy-Binet
generalization to \(n\) null edges. Second, Chin-Lee `arXiv:1407.2492`
explicitly relate the massive momentum bispinor/two-twistor determinant to
two-qubit concurrence, so the mass-as-concurrence analogy is prior art rather
than a novelty claim. The new claim here must be the finite null-edge bundle
generalization, theorem packaging, and the dynamical/channel interpretation.
Third, the spinors \(\psi_i\) form a
\(2\times n\) matrix whose Pluecker coordinates are the pairwise wedge
amplitudes, placing the construction in the Grassmannian
\(\mathrm{Gr}(2,n)\). The trusted `fin_bundle_det_re_nonneg` proves
nonnegativity of the mass-square after taking squared moduli. Total
positivity is a stronger extra structure available only in a real ordered or
phase-gauge-fixed sector.

The positive-Grassmannian connection should be used as stratification, not as
an automatic amplituhedron claim. For complex spinor bundles the robust finite
data are which Pluecker minors vanish, which real ordered sectors a d m i t a
positive phase gauge, and which closed-loop phases remain. Massless or
collinear limits are boundary strata; scattering/factorization candidates
should be studied as cell-adjacency data only after a real ordered sector is
specified. Near-term targets are
`pluckerMinorVanishingPattern_refines_nullEdgeDegeneration` and
`positiveOrderedFan_has_nonnegative_pairwiseMass`.

The quantum-geometric reading is now sharper but still bounded. The real
part says that the pairwise mass is the chordal Fubini-Study distance on the
celestial \(CP^1\). The imaginary part should be treated as a Berry /
Pancharatnam phase target, not yet as a theorem about spin. The existing
projector identities already prove the finite Bargmann triple trace, so the
next step is to check whether graph-native oriented areas on the celestial
sphere commute with the holonomy and mass layers.

#### Current Lean status

This theorem layer is now trusted in:

```text
PhysicsSM/Spinor/PluckerMass.lean
```

The central declarations are:

```lean
two_edge_plucker_mass_identity
fin_bundle_plucker_mass_identity
fin_bundle_det_re_nonneg
fin_bundle_mass_zero_iff_common_direction
```

Immediate next theorem targets suggested by the celestial-moment rewrite:

```lean
rankOneHermitian_eq_weighted_spinProjector
fin_bundle_det_eq_bloch_minkowski_norm
finPairwisePluckerMassReal_eq_weighted_angular_variance
mass_zero_iff_bloch_dipole_saturates
visibleDensity_from_orthonormal_internal_purification
det_visibleDensity_eq_internal_plucker_sum
normalized_mass_ratio_eq_two_sqrt_det_visibleDensity
mass_ratio_eq_sqrt_linear_entropy
massless_iff_visibleDensity_rank_one
restFrame_iff_visibleDensity_maximallyMixed
```

This is one of the program's cleanest successes. The result is
finite-dimensional linear algebra: no analysis, quantum field theory, causal
sets, or continuum limits are needed. The remaining work is interpretive and
conventional: make sure the determinant normalization is the one used in each
physics-facing layer, and keep the zero-mass/common-direction criterion
separate from any stronger dynamical claim about how massive trajectories are
generated.

### 2. Chirality flips generate non-collinearity

The current draft sometimes says that each chirality flip contributes mass.
The sharper statement is:

> Chirality flips locally generate non-collinearity; mass measures the
> accumulated two-point Pluecker spread of the whole null-edge bundle.

The exact mass formula is pairwise over the bundle:

\[
m^2 = \sum_{i<j} |\psi_i \wedge \psi_j|^2.
\]

Adjacent bends or flips may generate the spread, but the mass is not simply a
sum over adjacent bends unless additional assumptions are imposed.

The reduced-state version is sharper still. Higgs-permitted chirality flips
should be modeled as a unitary dilation of a visible mass channel: the full
visible-plus-internal state may remain pure, while the visible celestial qubit
becomes mixed after the internal/chiral/Higgs label is ignored. In that
language, the Yukawa coupling controls the entangling amplitude of the
internal transition, and the observed determinant mass is a reduced visible
mixedness, not a dissipative loss of probability.

Neutrinos are the sharpest elementary-particle stress test for this language.
The weak-visible channel sees neutrinos almost entirely as left-handed,
nearly-null propagation, while oscillations prove that at least two mass
eigenstates are not exactly massless. In this program's terms, a massive
neutrino should be modeled as an almost pure weak-visible null mode with a tiny
hidden chirality, sterile, or Majorana-sector coupling. This is a motivation for
the observer-channel formalism, not a solved theorem: the program does not yet
decide Dirac versus Majorana mass, PMNS mixing, mass ordering, sterile-sector
content, or the absolute mass scale. Current direct KATRIN bounds and
cosmological mass-sum constraints should be used only as experimental
guardrails for this nearly-null regime.

The strengthened conjecture should be spectral:

> For an isotropic null-direction process, the effective Dirac mass is
> calibrated by the l=1 relaxation gap of the flip generator, not by a raw
> microscopic flip count.

Let \(\gamma_1\) be the first nonzero generator eigenvalue on the spin-1 /
l=1 celestial sector. Then the convention-audited target is

\[
m_{\rm eff} = \frac{\hbar}{2c^2}\gamma_1,
\]

when \(\gamma_1\) is the decay rate of the direction autocorrelation. In the
1+1 telegraph/checkerboard process, \(\langle n(0)n(t)\rangle=e^{-2\nu t}\),
so \(\gamma_1=2\nu\) and \(m=\hbar\nu/c^2\). If a source defines
\(\gamma_1\) as half the autocorrelation decay rate, the factor of `2` moves
accordingly. This factor audit should be explicit in every dynamics note.

This is the right diagnostic sector for the higher-dimensional checkerboard
universality problem, but the operator target should be stated more sharply.
The Dirac mass itself is the scalar off-diagonal flip in the doubled
`L plus R` space. An `l=1` vector part of the flip generator is not a mass; it
is a Lorentz-violating vector/axial coupling unless it is removed by isotropy.
The `l=1` celestial sector remains important as the direction-autocorrelation
and dipole-deficit diagnostic, and the static/dynamical bridge should be
tested first as a fluctuation-dissipation-style identity in decohered or
Markov channel limits.

The finite homogeneous P4 target is therefore:

```text
null-step unitary symbol
-> no 2 x 2 mass term, forcing L plus R doubling
-> scalar flip block gives the Dirac mass
-> small-momentum Dirac dispersion
-> unnormalized visible determinant det(P_vis) = m^2
-> normalized determinant gives the frame-relative m/E readout
```

This is distinct from the harder causal-set frontier: a Lorentz-invariant
spinor hop-stop propagator on a Poisson sprinkling, extending Johnston's scalar
causal-set propagator. The homogeneous fixed-point theorem is a near-term
finite/algebraic package; the causal-set propagator is an open dynamics
problem.

There is also a phenomenological hazard. Causal-set particle models can
produce Lorentz-invariant energy-momentum diffusion ("swerves") from
microscopic discreteness. A stochastic flip-rate model will likely have a
similar diffusion shadow unless the mass-generation mechanism is coherent or
unitary. The pilot targets are
`unitaryFlipProcess_has_zero_swerveDiffusion`,
`decoheredFlipProcess_diffusionConstant_eq_l1Noise`, and
`swerveBound_constrains_hiddenChannelParameters`.

### 3. The Higgs as permission for chirality flips

In the Standard Model, a bare left-right fermion flip is not gauge invariant.
Left-handed and right-handed fermions transform differently under the
electroweak group. The Higgs/Yukawa insertion is exactly what makes the flip
legal.

Graph interpretation:

\[
\Psi_L \otimes H \to \Psi_R,
\qquad
\Psi_R \otimes H^\dagger \to \Psi_L.
\]

After electroweak symmetry breaking,

\[
m_f = y_f \frac{v}{\sqrt 2}.
\]

In null-edge language, \(y_f\) is the species-dependent amplitude for a
Higgs-permitted chirality-flip vertex. More sharply, it is an amplitude for
entangling visible null direction with internal/chiral data; the observed
fermion mass is the determinant of the reduced visible channel after that
bookkeeping is ignored. A coarse-grained flip rate may be an effective
description in checkerboard limits, but it is not the fundamental statement.

There is a precise continuum analogue worth citing as motivation. In the
enlarged-gauge Plebanski unification (Krasnov; Torres-Gomez and Krasnov,
arXiv:0911.3793, 1112.5097; Smolin's E8-relevant version, arXiv:0712.0977),
enlarging the gravitational \(SU(2)\) makes the off-diagonal block of the
unified connection / 2-form transform as a Higgs multiplet, and the fermion
mass scale \(m_f = y_f v/\sqrt 2\) is the off-diagonal simplicity scale. This
is the continuum image of the graph statement that the Higgs insertion is the
off-diagonal piece that makes the enlarged bivector simple, i.e. that makes the
flip legal. It belongs behind the same claim boundary as the rest of the
Plebanski reading.

A particularly sharp realization of this picture is Alexander-Marciano-Smolin
(arXiv:1212.5246, PRD 89, 065017): joining the weak \(SU(2)\) to the
left-handed half of the spacetime connection makes the weak interaction the
chiral half of gravity, and after parity breaking a Dirac fermion appears as a
chiral neutrino paired with a scalar carrying Higgs quantum numbers. That is
the chirality-flip-via-Higgs statement in continuum graviweak form, and it is
the cleanest existing motivation for the graph version.

#### Current Lean status

The first representation-bookkeeping layer exists in:

```text
PhysicsSM/Draft/NullEdgeYukawaFlip.lean
PhysicsSM/Draft/NullEdgeYukawaGaugeAristotle.lean
```

The proved draft-facing statements include:

```lean
higgsInsertion_hypercharge_matches
weakYukawaPattern_all
colorNeutralPattern_all
gaugeLegalPattern_all
```

This is useful but deliberately modest. It proves that the finite flip
patterns have the expected Standard-Model-like gauge bookkeeping. It does not
yet prove a continuum Dirac equation, a mass spectrum, or a dynamical relation
between Yukawa coupling and coarse-grained flip density. The next sharper
target is to connect this bookkeeping to a finite reduced-channel theorem:
Higgs-legal internal transitions purify a visible mixed state whose determinant
is the mass observable.

### 4. Twistor incidence as the continuum target

If the basic visible objects are null rays, then twistor geometry is a more
natural continuum home than a spacetime lattice.

Instead of:

```text
sum over embeddings into spacetime
```

use:

```text
sum over compatible null-twistor incidence structures
```

A spacetime event is then reconstructed from coherent incidence among null
rays. A massless edge is native. A massive particle is represented by a
multi-twistor or multi-null-spinor configuration whose summed momentum is
timelike.

The highest-value finite calculation, now represented in the spinor-chart
wrapper, is:

> Show that the two-twistor mass invariant reduces, in the relevant spinor
> chart, to \(|\psi_1 \wedge \psi_2|^2\).

This makes the Pluecker mass functional not merely a spinor identity, but a
candidate twistor-invariant mass functional in the chosen chart.

The continuum target also has a natural celestial / Carrollian description.
Null momenta are parametrized by points on the celestial \(CP^1\), and a
massive particle decomposes into the principal continuous series - a continuum
of null directions - so "mass = spread of null directions on \(CP^1\)" is the
representation-theoretic shadow of the Pluecker spread. Null hypersurfaces
carry Carrollian (degenerate-metric) geometry, the intrinsic language of light
cones and the right continuum setting for a null-edge structure. Two-twistor
mass models (Fedoruk-Lukierski, arXiv:1403.4127) are the technical anchor for
the finite chart wrapper above.

The complex phase layer has a sharper continuum neighbor: massive ambitwistor
zig-zag theory (Kim-Lee, arXiv:2301.06203). There the massive spinning-
particle phase space carries symplectic data, little-group redundancy, and
background-field coupling. The null-edge phase target should therefore be:

```text
complex Pluecker amplitude + causal diamond holonomy
  -> finite shadow of massive-twistor symplectic data.
```

The quotient warning matters. Hidden `U(1)`/`SU(2)` little-group directions
should be treated as gauge or symplectic-reduction directions, not as physical
observables. The finite targets are
`pluckerBargmannPhase_gaugeCovariant_underDiamondTransport`,
`diamondHolonomy_linearized_acts_on_pluckerPhase`, and
`pluckerMass_descends_to_hiddenQuotient`.

This boundary also has a definite symmetry structure that the program can aim
at. The asymptotic symmetry of null infinity is the BMS group (Lorentz plus
supertranslations, extended by superrotations), and the soft theorems are the
Ward identities of these asymptotic symmetries (Strominger, arXiv:1703.05448).
The appealing bulk-to-boundary line is that energy-momentum conservation at
each event - the defining rule of the energetic-causal-set kinematics - is the
natural discrete image of the supertranslation / BMS conservation law at null
infinity. This is a research-direction anchor, not a theorem target: it tells
the program which continuum symmetry the finite conservation rules should flow
to.

#### Current Lean status

The narrow wrapper exists in:

```text
PhysicsSM/Spinor/TwistorPluckerMass.lean
```

It is trusted, promoted from the earlier draft wrapper. It defines a
spinor-chart twistor fragment, the infinity-twistor pairing, the two-twistor
mass invariant, determinant and trace mass-square conventions, and finite
multi-twistor pairwise mass. The main proved bridges are:

```lean
two_twistor_mass_invariant_eq_plucker
two_twistor_momentum_det_eq_massInvariant
twoTwistorMassSqTraceConvention_eq_two_massInvariant
multi_twistor_momentum_det_eq_pairwiseMass
```

This wrapper is a meaningful match to the Pluecker theorem, but it is not yet
full twistor theory. The remaining challenge is to add incidence, projective
quotients, real structures, and source-level convention checks without
overloading the clean finite spinor theorem.

### 5. Causal-diamond holonomy instead of plaquettes

A causal DAG has no ordinary directed plaquette loops, but gauge curvature in
lattice gauge theory is usually detected by loop holonomy. The replacement
object is a causal diamond.

For two alternative histories \(\gamma_1,\gamma_2:p\to q\), define a holonomy
defect:

\[
\Delta U(p,q;\gamma_1,\gamma_2)
= U_{\gamma_1}^{-1} U_{\gamma_2}.
\]

In the Abelian case,

\[
\arg(\Delta U) = \int_\Sigma F
\]

for a surface \(\Sigma\) spanning the two paths. In a small diamond this
recovers \(F_{\mu\nu}\Sigma^{\mu\nu}\) to leading order.

The key idea:

> Gauge field strength is the obstruction to agreement among competing
> causal/null histories across a causal diamond.

#### Current Lean status

The finite group-algebra layer is now trusted in:

```text
PhysicsSM/Gauge/CausalDiamondHolonomy.lean
```

It proves more than the original Abelian target:

```lean
diamondDefect_gauge_covariant
diamondDefect_gauge_invariant
diamondDefect_classFunction_gauge_invariant
pathPairDefect_verticalCompose
pathPairDefect_verticalCompose_comm
pathPairDefect_horizontalCompose
```

The clean lesson is that the raw non-Abelian defect is endpoint-covariant,
while class functions of it are gauge invariant. The new path-pair API also
proves vertical and horizontal gluing laws, so causal diamonds now have a
finite composition theory.

The continuum Stokes statement remains an interpretation, not a trusted Lean
theorem. The next formal target is the geometric version of the higher-gauge
wrapper now represented algebraically by `PhysicsSM.Draft.NullEdgeP3CrossedModule`.

The sharpened algebraic test is now banked: the vertical and horizontal
`H`-valued 2-cell compositions satisfy the interchange law of a double category,

```text
(a circle_v b) circle_h (c circle_v d)
  =
(a circle_h c) circle_v (b circle_h d).
```

This means the diamond layer has a finite crossed-module 2-group model
`partial : H -> G` at the level of group algebra, with endpoint covariance
encoded by the `G`-action on the `H`-valued 2-cell label. Fake-flatness,

```text
partial(B) = Delta U(p,q; gamma_1, gamma_2),
```

is the finite consistency condition for surface transport. The remaining
physics-facing task is to say what the `H`-valued surface label is for a causal
diamond, what metric or orientation data it depends on, and how it couples to
the trusted path-pair defect.

Immediate Lean targets:

```lean
surfaceLabel_def
surfaceLabel_boundary_eq_pathPairDefect
fakeFlatness_iff_surfaceTransport_welldefined
crossedModule_action_eq_endpoint_covariance
```

### 6. Gravity through null-horizon thermodynamics

The gravity route should begin with Jacobson-style null thermodynamics, not
canonical quantization.

Graph dictionary:

```text
horizon entropy  = count or weighted count of null edges crossing a screen
heat flux        = null momentum flux across the same screen
Einstein equation = continuum equation of state
```

The strongest conjectural bridge is:

> The Benincasa-Dowker causal-set scalar curvature and Jacobson
> null-horizon Clausius balance are two continuum shadows of the same
> causal-diamond entropy-flow identity.

This is not a near-term Lean target. It is a long-horizon research direction,
and a delicate one: the Benincasa-Dowker action converges to Einstein-Hilbert
only slowly, its curvature operator is nonlocal, and the limit is
dimension-dependent, so any "two shadows of one identity" claim must respect
that the continuum limit is subtle. The near-term work should instead define
the finite graph observables:

- edge-crossing count for a cut or screen;
- null momentum flux through that cut;
- coarse-graining rules for nested diamonds.

The modern null-energy literature gives this branch a hard positivity audit.
ANEC/QNEC and modular-Hamiltonian results relate null stress-energy integrals
to relative entropy and entropy variations. The finite diamond source should
therefore be tested against a discrete inequality of the form:

```text
visible null flux >= entropy second difference.
```

Candidate targets are
`diamondRelativeEntropy_secondDifference_nonnegative`,
`visiblePluckerFlux_satisfies_discreteANEC`, and
`sourceVisibility_implies_discreteQNEC`. The new finite-information targets
are `sjDiamondReferenceState_def`,
`petzRecoverabilityGap_controls_sourceVisibility`, and
`relativeEntropyLoss_zero_iff_exactObserverRecovery`. If the finite source
observable violates this kind of positivity, or if hidden bookkeeping is not
recoverable from the observer algebra in the cases advertised as invisible,
the null-horizon gravity route should be demoted before any continuum claims
are made.

This is also the same data-processing question as the proper-time/concurrence
branch. In both cases the hard work is to name a finite observer channel and
prove a monotonicity theorem for a relative-entropy-like quantity. For mass the
observable is the reduced visible celestial qubit; for gravity it is a diamond
screen/source algebra. A successful source-visibility theorem should therefore
say not only that a flux is positive, but that it is positive because the
chosen coarse-graining loses information in a controlled way.

### 7. Fermions through order complexes and Kahler-Dirac structure

Bare causal order does not produce fermions or spin-statistics. One must add
graded structure, spin structure, or a substitute.

An underdeveloped but promising extension is:

> Build a Kahler-Dirac operator on the order complex of a finite causal graph.

A finite causal poset has an order complex. Its simplices give a natural
cochain complex. The combinatorial exterior derivative \(d\), together with a
choice of adjoint \(\delta\), gives a discrete analogue of \(d+\delta\).

Why this matters:

- it gives a graph-native home for graded fermionic data;
- it does not require a fundamental spin structure at the first step;
- it connects naturally to staggered/Kahler-Dirac fermion ideas;
- it may later explain how the Foster-Jacobson null-step Weyl operator arises
  as a chiral projection.

#### Current Lean status

The first finite cochain target exists in:

```text
PhysicsSM/Draft/NullEdgeCochainDiamond.lean
```

The key theorem is:

```lean
cochainCoboundary_comp_self_eq_zero
```

This is a good companion to the checkerboard work because it is finite,
kernel-checkable, and independent of continuum analysis. It is still only the
seed of the Kähler-Dirac route. The missing pieces are an adjoint, grading,
metric/Hodge data, and a careful comparison with staggered or
Kähler-Dirac fermions.

#### Topological Dirac operator and the doubling argument

Bianconi's topological Dirac operator gives the cleanest near-term target on
top of the cochain seed. On a finite complex, with a topological spinor
\(\psi=(\phi,\xi)\) of node 0-cochains and edge 1-cochains, set
\(D = d + \delta\). Then \(D^2\) is the Hodge Laplacian, the chirality operator
\(\gamma=\mathrm{diag}(I,-I)\) anticommutes with \(D\) (so \(\{\gamma,D\}=0\)),
and the gapped operator \(D+m\gamma\) has spectrum
\(E=\pm\sqrt{\lambda^2+m^2}\): a mass term opens a spectral gap with
relativistic dispersion.

Proposed finite Lean targets:

```lean
topological_dirac_sq_eq_laplacian   -- D^2 = Hodge Laplacian
gapped_dirac_spectrum               -- spec(D + m*gamma) = +-sqrt(lambda^2 + m^2)
```

A structural bonus: a causal poset has no lattice translation symmetry, so the
Nielsen-Ninomiya obstruction is void by construction - the symmetry whose
preservation forces fermion doublers is simply absent; this is the discrete
differential-form mechanism that keeps staggered fermions free of doublers
(Catterall-Butt, arXiv:2209.03828). That is itself a small, finite, citable
claim. The source results (Bianconi, topological Dirac
equation of networks, arXiv:2106.02929; mass of simple and higher-order
networks, arXiv:2309.07851) already carry a self-consistent network mass-gap
equation, so this direction must be cited as prior art and differentiated, not
presented as new.

Dirac-Bianconi graph neural networks belong in the simulation layer, not the
theorem spine. They suggest a concrete pilot: compare topological-Dirac
propagation on the order complex against Laplacian/message-passing diffusion,
and measure whether node/edge cochain signals preserve the long-range phase
and mass-spread data that oversmoothed graph Laplacians lose. If this produces
no advantage over a plain Hodge-Laplacian baseline, it should remain a
machine-learning curiosity rather than a physics argument.

#### Speculative: CPT two-sheet and scattering boundary conditions

A more speculative reading, flagged as conjecture rather than target: Lorentzian
Kähler-Dirac fermions carry "wrong-sign" components that look like negative-norm
ghosts, and one proposed cure is a CPT-symmetric two-sheeted structure (forward
and backward sheets related by \(i \leftrightarrow -i\), with a KD-Majorana
reality condition; arXiv:2511.11548). If that structure holds on a causal graph, the appealing but
unproved suggestion is that the two sheets supply incoming and outgoing
scattering states rather than pathologies. This is interesting because it would
give a graph-native origin for in/out boundary data, but it has no derivation
here and should not be elevated above a research direction.

The newly proved finite two-sheet projector theorem is the safe algebraic
piece of this speculation. It says that a square-rooted mass operator has plus
and minus branches. It does not say that those branches are automatically
localized particles, antiparticles, or scattering boundary states. The
interpretation should be compared against Foldy-Wouthuysen diagonalization
`NFMI3A99`, Newton-Wigner localization `74NU4C33`, and Thaller's Dirac-equation
reference `UI9343SX` before any stronger physics claim is made.

## Existing Lean footholds

The repo already contains several theorem islands that should be integrated
before new speculative modules multiply.

### Trusted checkerboard core

`PhysicsSM.Spinor.Checkerboard` formalizes the finite 1+1-dimensional
checkerboard skeleton:

- directions and lightlike steps;
- corner weights;
- endpoints and terminal directions;
- finite histories;
- finite path sums;
- first-step decomposition of the path sum.

`PhysicsSM.Spinor.CheckerboardDynamics` extends this to trusted dynamics:

- history counts and no-duplication;
- corner-weight powers;
- last-step recursion;
- path sums as iterates of a finite transfer operator;
- a finite Klein-Gordon-style recurrence.

`PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle` adds kernel-clean draft
endpoint closed forms for right-starting right/right and right/left kernels.

This is the seed of a publication-grade "finite core of Feynman's
checkerboard" result.

### Spin coherent projector layer

`PhysicsSM.Draft.SpinCoherentProjectorAristotle` contains kernel-checked
projector identities:

- Pauli product identity;
- projector Hermiticity and trace;
- idempotence and determinant on the unit sphere;
- sandwich collapse;
- Bargmann triple trace.

This is the algebraic spin-factor layer for 3+1-dimensional null polygons.
It should be reviewed and promoted out of `Draft` once naming, comments, and
imports are cleaned.

### Weyl/null-step bridge

`PhysicsSM.Draft.WeylCliffordBridgeAristotle` connects the spin coherent
projector layer to the spinor-helicity layer:

- \(\sigma \cdot p\) and \(\bar\sigma \cdot p\);
- Clifford relation;
- Minkowski trace pairing;
- null-step factorization \(\sigma\cdot(r,ra)=2rP(a)\).

This is one of the best bridges between the prose program and actual Lean.

### Spinor-helicity rank-one factorization

`PhysicsSM.Draft.SpinorHelicityRankOneAristotle` proves the complex
rank-one factorization of future null 4-momenta.

`PhysicsSM.Draft.SpinorHelicityQuaternionAristotle` extends the analogous
idea to the quaternionic 6-dimensional case.

These modules remain useful bases for adjacent Pluecker, twistor, and
null-step theorem packages.

### Trusted Pluecker mass layer

`PhysicsSM.Spinor.PluckerMass` proves the finite determinant identity that
turns the null-edge mass slogan into algebra:

- two-edge mass is the squared wedge;
- finite bundle mass is the sum of all pairwise squared wedges;
- the real Pluecker mass functional is nonnegative;
- zero mass is equivalent to a common spinor direction.

This module is trusted and kernel-clean. It should be treated as a central anchor
for future twistor, momentum-bundle, and publication work.

### Twistor and Yukawa draft wrappers

`PhysicsSM.Spinor.TwistorPluckerMass` and
`PhysicsSM.Draft.NullEdgeYukawaGaugeAristotle` are the current physics-facing
wrappers that connect the trusted algebra to physics-facing interpretations:

- the trusted twistor wrapper matches the spinor-chart two-twistor invariant
  to the Pluecker wedge and extends it to finite pairwise mass;
- the Yukawa wrapper proves finite weak/color/hypercharge legality predicates
  for Higgs-permitted chirality flips.

The twistor wrapper has been promoted to the trusted `PhysicsSM.Spinor`
namespace. The Yukawa wrapper remains draft-facing pending representation and
convention review.

### Trusted causal-diamond holonomy layer

`PhysicsSM.Gauge.CausalDiamondHolonomy` gives a trusted finite gauge-curvature
carrier for causal DAGs:

- Abelian diamond defects are gauge invariant;
- non-Abelian defects are endpoint-covariant;
- class functions of non-Abelian defects are gauge invariant;
- path-pair defects compose under vertical and horizontal gluing.

This makes "curvature as disagreement of competing causal histories" a
kernel-checked finite theorem, not just a metaphor.

## Proposed clean work plan

### Stage 0: source and convention cleanup

Deliverable:

- a convention table for metric signature, Pauli matrices, spinor indices,
  twistor incidence, checkerboard corner weight, Higgs hypercharge, and the
  Barbero-Immirzi / Holst weight \(\gamma\) used in any BF/Plebanski reading;
- an irrep table separating `Lambda^2 S ~= C` Pluecker mass scalars,
  `Sym^2 S ~= Lambda^2_+` curvature/self-dual bivectors,
  `S tensor Sbar` Hermitian momentum vectors, and the genuine
  `Lambda^2 C^4` Klein-quadric bivector arena;
- a source table distinguishing primary sources, secondary reviews, and
  AI-generated synthesis.

New physics-facing claims should continue to cite this table so convention
choices stay visible and reviewable.

### Stage 1: finite Lean theorem layer

Completed or substantially completed:

1. trusted checkerboard finite combinatorics and dynamics;
2. draft kernel-clean checkerboard endpoint closed forms;
3. trusted finite Pluecker mass identity and zero-mass criterion;
4. trusted spinor-chart twistor/Pluecker matching;
5. draft kernel-clean Yukawa gauge-bookkeeping predicates;
6. trusted causal-diamond holonomy invariance and composition laws;
7. draft cochain coboundary square-zero theorem;
8. integrated draft proofs for the Gram-weighted Cauchy-Binet,
   hidden-isometry, and quantum-measure finite algebra cores;
9. integrated draft proofs for the finite Dirac-slash square root,
   bundle Dirac-Pluecker bridge, super-Dirac block-square algebra,
   superconnection expansion algebra, abstract two-sheet projector algebra,
   and concrete mass-shell branch projectors.

Near-term cleanup:

1. promote stable kernel-clean draft modules after semantic and convention review;
2. resolve the higher-gauge diamond handoff;
3. package theorem names and source notes for publication;
4. reduce duplicated draft definitions once trusted modules provide the common
   API.
5. write an operator-charter note for each ambitious target, naming the state
   space, grading, adjoint, first-order operator, covariance law, square
   identity, and lost branch/phase data;
6. add a graph-native interpretation layer for the two-sheet projector theorem;
7. package the mass-shell branch projectors with the bundle Pluecker bridge as
   the static operator-spine theorem cluster;
8. add a small `ObservableNullity` diagnostics layer for quotient, exact
   cochain, tree-gauge, homology-boundary, and rank-one spectral nullity.

This stage remains kernel-checkable and does not depend on analytic limits.

### Stage 2: finite-dimensional synthesis

Priority:

1. promote the operator-charter rule to a reusable template for Aristotle
   batches and paper sections: no new high-level theorem target should be
   submitted without an explicit candidate `D` and a stated square identity;
2. extend the trusted twistor/Pluecker wrapper toward incidence, projective
   quotients, and real structures;
3. add the celestial-moment wrapper for the Pluecker theorem: Bloch
   decomposition, angular-variance identity, and dipole-saturation
   masslessness criterion;
4. add the reduced-celestial-density wrapper: visible partial trace,
   determinant as concurrence, two-observer factorization, internal Gram law,
   mass ratio \(m/E=2\sqrt{\det\rho_{\rm vis}}\), unital visible-channel
   monotonicity, entangling-channel counterexamples, and the
   internal-coherence caveat;
5. package the null-step projector theorem with the Pluecker mass theorem;
6. package the static square-root theorem
   `diracSlash_bundleMomentum_sq_eq_pluckerMass` as the operator-level
   version of the finite mass theorem;
7. connect Yukawa flip legality to an internal unitary dilation / reduced
   visible mass channel before specializing to checkerboard-style effective
   corner or flip amplitudes;
8. state the chirality-flip universality conjecture as a homogeneous
   null-step fixed-point package: no `2 x 2` mass term, forced `L plus R`
   doubling, scalar off-diagonal flip as mass, `l=1` vector flip as the
   Lorentz-violation diagnostic, small-momentum Dirac dispersion, and the
   invariant `det(P_vis)=m^2` bridge before the normalized `m/E` readout;
9. separately test the static/dynamical `l=1` bridge as a
   fluctuation-dissipation-style identity for decohered or Markov visible
   channels before claiming it for coherent unitary walks;
10. prove the finite Berry/Pancharatnam triangle identity as the imaginary
   partner of the real Fubini-Study mass-spread identity, while keeping any
   spin interpretation conjectural until the graph-native holonomy layer is
   checked;
11. formalize finite CPTP celestial channels and their affine Bloch action, so
   l=1 relaxation becomes a channel/generator spectral statement rather than
   a raw flip-count claim;
12. classify Pluecker-minor vanishing patterns for null-edge bundles, adding
   positive-Grassmannian/positroid language only after a real ordered or
   phase-gauge-fixed sector is defined;
13. express the celestial-moment theorem as a spinor-network closure /
   moment-map identity, keeping visible closure, BF face closure, and source
   invisibility separate;
14. add a source-backed Jordan split note: visible `H_2(C)` determinant mass
   versus internal `H_3(O)` generation structure, with explicit caveats that
   mass ratios and CKM/PMNS mixing remain unsolved;
15. test whether the internal state-space hypothesis constrains visible
   reduced-density spectra through a quantum-marginal / moment-polytope
   calculation before claiming hierarchy leverage;
16. write a short expository paper tying the Lean results to the known
   checkerboard, Foster-Jacobson, twistor, and higher-gauge literature;
17. prove the topological Dirac targets on the order complex
   (`topological_dirac_sq_eq_laplacian`, `gapped_dirac_spectrum`) together with
   the no-doubling argument;
18. prove the super-Dirac symbol/soldering gate: identify the first-order graph
   commutator with the local slash of the weighted null-edge momentum bundle,
   then square it to the weighted Pluecker mass and null-cone/collinearity
   zero locus;
19. define the finite causal super-Dirac candidate
   `D_{U,Phi}=d_U+delta_U+Phi+Phi^dagger` and prove the first block-square
   formula under explicit anticommutation and covariance hypotheses;
20. audit the finite causal super-Dirac candidate against spectral-triple
   conditions: total grading, Krein fundamental symmetry, antilinear real
   structure, first-order condition, inner fluctuations, and low-order
   spectral-action terms;
21. prove the pairwise Klein-quadric wrapper
   `massless_iff_repeated_principal_spinor` /
   `mass_eq_squared_distance_from_klein_quadric`, keeping the scalar
   `Lambda^2 S` Pluecker bracket separate from `Sym^2 S` curvature;
22. connect the kernel-checked crossed-module/fake-flatness wrapper to a
   geometric causal-diamond surface-label API, including endpoint covariance,
   fake-flatness, and surface transport;
23. prove the simplicity / `B wedge B = 0` form of the zero-mass criterion and
   wire it into the bivector wrapper, matching the modern linear simplicity
   constraint (EPRL/FK) and keeping the single-bivector condition separate from
   the cross-bivector relations;
24. add a Hopf-link volume-simplicity scaffold for finite boundary graphs, as a
   guardrail for any claim that the `B` wrapper reaches spin-foam geometricity
   or Plebanski-sector control;
25. after defining the diamond source observable, test discrete ANEC/QNEC-style
   positivity before promoting the gravity branch;
26. add `edgeNeighbor_N` as the finite energetic-causal-set locality relation,
   explicitly separating effective link locality from fundamental bounded
   valency;
27. keep observable-relative nullity as a support API around the Plucker and
   diamond observables, not as an independent ontology.

### Stage 3: numerical and probabilistic pilots

Priority:

1. simulate isotropic null-edge flip ensembles and measure the dispersion
   relation;
2. test whether an effective Dirac mass depends only on flip intensity or on
   higher distributional data;
3. simulate Abelian diamond holonomy on random null-like diamonds;
4. compare graph observables with expected continuum curvature or flux
   approximations;
5. measure approximate spectral/gauge/homology nullity signatures under
   coarse-graining and compare them with effective-resistance sparsification;
6. compare topological-Dirac / Dirac-Bianconi-style propagation with ordinary
   Laplacian message passing on the same order complexes, using preservation
   of Pluecker phase/mass-spread data as the diagnostic;
7. measure residual energy-momentum diffusion in stochastic flip models and
   compare it with coherent/unitary flip dynamics, using causal-set swerves as
   the phenomenological warning;
8. simulate the `edgeNeighbor_N` cutoff on finite causal sets to see whether
   edge-local action sums stay stable under coarse-graining.

Oracle scripts can justify tests and conjectures, not trusted theorems.

### Stage 4: long-horizon continuum theory

Only after the finite layer is stable:

1. causal-set Dirac propagator or spinor hop-stop construction;
2. continuum limit of diamond holonomy;
3. higher-gauge 2-connection over causal diamonds;
4. null-horizon thermodynamic derivation of Einstein equations;
5. decoherence functional over graph histories and Bell/Tsirelson analysis.

## Falsification ledger

Every major conjecture should have a stated failure mode.

For the discrete branches, especially P9/source visibility, "no fine-grained
continuum interpretation" is not by itself a failure mode. A fundamentally
discrete model may be microscopic, irregular, or ill-conditioned in pointwise
continuum language, with continuum-like behavior emerging only after a chosen
large-scale channel. The real gate is whether a specified observer-scale
readout, coarse-graining, renormalization, or large-scale statistic is stable
without hand-tuned metric weights, boundary artifacts, or geometry-blind
definitions.

| Claim | What would weaken or kill it |
|---|---|
| Diamond source visibility gives real cosmological-constant leverage | Coherent/internal vacuum bookkeeping contributes a bulk volume-scaling diamond source, visible Plucker excitations fail to distinguish bulk from boundary source terms, the residual source lacks a `sqrt(N)` fluctuation pilot, or it inherits the everpresent-Lambda CMB-era amplitude tension without a new suppression/correlation mechanism |
| The Lambda-channel is the harmonic sector of diamond bookkeeping | No stable coarse-grained, renormalized, or continuum-flow readout sends the source channel to a Laplacian zero-mode/harmonic representative, the identification depends unstably on the SJ metric/window, or the relevant diamond cohomology is geometry-blind at the observer scale |
| Hodge acyclicity gives structural source suppression | Betti numbers of sprinkled diamond order complexes grow with volume, physical diamonds are generically topologically nontrivial in the relevant degree, or the finite Hodge metric makes the harmonic sector unstable |
| Area-law harmonic noise improves the P9 branch | Cell-local antisymmetric pairings fail to telescope, boundary terms reintroduce volume scaling, or area-law source noise does not translate into an improved Lambda fluctuation because the response law is nonlocal or absent |
| Finite causal super-Dirac operator is the master structure | No natural odd Krein/J-self-adjoint first-order operator exists on the causal order complex whose square simultaneously yields the kinetic Pluecker symbol, diamond curvature block, Higgs kinetic cross term, and Higgs/Yukawa chirality-flip block; the construction double-counts mass by adding `det(P)` and `Phi^dagger Phi`; or the mass-shell equality cannot be forced as a kernel/spectral condition |
| Super-Dirac symbol/soldering theorem is the missing bridge | The first-order graph commutator cannot be identified with a local slash of the weighted null-edge momentum bundle, or the squared local symbol does not reduce to the weighted Pluecker mass with the expected null-cone/collinearity zero locus |
| Finite spectral-triple audit upgrades the super-Dirac operator | The causal order-complex operator has no coherent grading, Krein fundamental symmetry, antilinear real structure, first-order condition, inner-fluctuation behavior, or low-order spectral action matching the Pluecker/diamond/Higgs blocks; or the Higgs block disappears/becomes constant under the relevant coarse-graining |
| Dirac slash square-root of Plucker mass is the right finite operator bridge | Gamma/Pauli/signature conventions cannot be aligned with the trusted determinant mass, or the square-root theorem factors only a number but cannot be connected to any graph propagation or chirality-flip operator |
| Normalized celestial mixedness is used only frame-relatively | The program treats `det(P_vis / Tr(P_vis))` as a Lorentz scalar, hides the timelike normalization choice, or fails to prove the unnormalized `det(A P_vis A^dagger) = det(P_vis)` invariant wrapper |
| Two-observer factorization is the right mass-channel interface | The visible boost fails to commute with the internal trace in the physical model, the resolution observer cannot be represented by a finite Gram-bearing internal label family, or the kinematic observer cannot be separated cleanly from the irreversible coarse-graining |
| Internal Gram law is the concrete observer channel | The physical hidden labels are not described by a stable Gram matrix, `det(P_vis)=w^dagger (Lambda^2 G) w` is not the relevant determinant, dephasing of `G` is not monotone in the intended dynamics, or the two-label factorization has no operational meaning |
| Higgs/Yukawa flips are the off-diagonal mass block | The legal flip bookkeeping cannot be realized as an odd left/right operator whose square gives the expected Yukawa mass matrix, or the Yukawa block cannot be equated on shell with the kinetic Pluecker determinant without convention drift or double-counting |
| Complex Plucker amplitude is the first-order mass/phase object | The wedge phase cannot be made invariant under the relevant spinor/gauge rephasings, does not match Bargmann/Pancharatnam phase on triangles, or fails to commute with the graph-native holonomy layer |
| Two-sheet structure is forced by the mass square root | The sign branch of the finite Dirac square root cannot be tied to any coherent particle/antiparticle, CPT, or in/out construction without adding extraneous structure |
| CPTP celestial channels give the right dynamics language | The affine Bloch-channel formalism cannot represent the hidden/chiral dynamics, l=1 relaxation is not a channel/generator spectral property, no physically relevant dynamics induce a unital visible channel, or the predicted mass/proper-time change conflicts with the explicit entangling-channel counterexamples |
| Irrep-labeled spinor table stabilizes the program | The program continues to conflate the scalar `Lambda^2 S` Pluecker bracket with `Sym^2 S` curvature or with `S tensor Sbar` momentum, producing theorem statements that change representation under convention audit |
| Klein quadric is the correct pairwise bivector hub | The pairwise Pluecker/Klein/simplicity identities fail under the chosen spinor/twistor conventions, or the `n > 2` assembly cannot be expressed through pairwise simplicity plus closure/Gauss-law data |
| Spinor-network closure is the source-visibility phase space | The closure vector does not match the celestial dipole convention, visible momentum closure and BF face closure cannot be kept separate, or closure-satisfying internal bookkeeping still contributes a bulk diamond source |
| Observer-channel recoverability captures source invisibility | The hidden bookkeeping advertised as invisible is not recoverable from the observer algebra, the relative-entropy loss is large, or the Petz/rotated-Petz recovery diagnostic is not compatible with the finite source functional |
| Bivector/BF wrapper unifies mass and diamond curvature | The `B` simplicity defect cannot be matched to the Plucker mass without convention changes, or `B`-weighted diamond pairings fail to respect the finite composition laws; Lorentzian reality conditions may also block the continuum reading |
| Hopf-link volume simplicity strengthens the spin-foam bridge | The Hopf-link volume functionals cannot be stated on the boundary graphs used by the null-edge program, fail to be invariant under the relevant finite moves, or do not add geometricity information beyond the pairwise Pluecker simplicity defect |
| Mass is Pluecker spread / missing celestial dipole of null edges | Mismatch with physical invariant mass conventions, failure of the Bloch angular-variance rewrite, or misuse outside the positive Hermitian spinor-bundle setting where the theorem applies |
| Positive-Grassmannian/positroid stratification helps classify histories | The complex Pluecker phases cannot be gauge-fixed to a useful real ordered sector, minor-vanishing strata do not match causal or factorization degenerations, or positivity adds no constraint beyond ordinary squared-modulus nonnegativity |
| Mass ratio is reduced celestial concurrence | The normalized determinant fails to match \(m/E\), the resolution partial trace is not the correct observable, boosts do not commute with the actual resolution map, the pure-state visible/internal bipartition does not give concurrence, prior-art/frame-dependence boundaries are hidden, or monotonicity is claimed outside an explicit channel class such as unital visible CPTP maps |
| Quantum marginal constraints give hierarchy leverage | The proposed internal state space imposes no useful constraints on visible reduced spectra, observed Yukawa hierarchies are not near natural polytope faces, or the constraints require ad hoc embedding choices |
| Fubini-Study / QGT reading of pairwise mass and spin phase | The real part fails to match chordal Fubini-Study distance on CP^1, the Berry/Pancharatnam phase does not survive the graph-native holonomy layer, or the proposed spin interpretation has no invariant finite observable |
| Massive ambitwistor symplectic data is the phase target | The Pluecker/Bargmann phase is not compatible with little-group quotienting, does not transform correctly under diamond transport, or cannot be related to known massive-twistor symplectic forms |
| Null-step Dirac fixed point gives effective mass | The homogeneous walk has relevant operators besides the scalar off-diagonal flip, the `L plus R` doubling is not forced by the finite algebra, the small-momentum expansion fails to give Dirac dispersion, the dynamic mass matches only normalized `det(rho_vis)` rather than invariant `det(P_vis)`, or the causal-set frontier has no Lorentz-invariant spinor hop-stop propagator |
| Static/dynamical l=1 bridge is real | The decohered direction autocorrelation does not integrate to the static dipole deficit, the coherent unitary walk only oscillates with no channel gap, or the l=1 component survives as a Lorentz-violating vector coupling rather than a diagnostic of scalar mass generation |
| Stochastic flip dynamics avoids swerve constraints | Decohered or stochastic flip models induce unacceptable energy-momentum diffusion, while coherent/unitary versions fail to generate the intended mass channel |
| Higher-gauge diamond layer is a crossed-module 2-group | Vertical and horizontal path-pair gluing fail the interchange law, fake-flatness cannot be stated without extra path data, or endpoint covariance is not captured by a crossed-module action |
| Three generations arise from a broken internal Albert/triality layer | A fourth generation is observed, generation structure is forced by visible null geometry rather than internal labels, exact Spin(8) triality cannot be broken to the Standard Model embedding in a useful way, or `H_3(O)` cannot reproduce the required family representations, Yukawa freedom, and mixing data without adding ad hoc states |
| BGW tensorial-autonomy obstruction supports the Albert internal layer | The composite-system axioms are too far from the physics being modeled, the obstruction does not single out usable internal dynamics, or the Standard Model representation/Yukawa data still require ad hoc additions |
| Higgs permits graph chirality flips | Representation bookkeeping does not match Standard Model Yukawa quantum numbers |
| Twistor incidence is the right continuum target | Two-twistor mass invariant does not match the Pluecker mass term, or incidence reconstruction requires extra non-null structure |
| Causal diamonds replace plaquettes | Path-comparison defects are not gauge invariant, or their continuum limit fails to reproduce field strength |
| Diamond-source gravity satisfies null-energy positivity | The finite source violates ANEC/QNEC-style positivity, entropy second differences have the wrong sign, or visible Plucker flux cannot be tied to a positive null-energy observable |
| Sorkin-Johnston reference states ground the discrete diamond entropy | No natural finite SJ/correlation reference state exists for the diamond class, the necessary Pauli-Jordan truncation is unstable or ad hoc, or the resulting entropy has volume-law behavior where the P9 argument needs boundary/area behavior |
| Kahler-Dirac order-complex route gives fermions | The graph cochain operator cannot reproduce a Weyl/Dirac continuum sector without reintroducing hidden lattice structure |
| Energetic-causal-set edge locality supports finite propagation | The `edgeNeighbor_N` cutoff is not stable under the coarse-grainings used by the program, fails to produce local action sums, or merely hides Lorentzian nonlocality in a frame-dependent parameter |
| Dirac-Bianconi simulation adds value | Topological-Dirac/DBGNN propagation does not preserve relevant cochain, phase, or Pluecker-spread information better than ordinary Laplacian/message-passing baselines |
| Observable-relative nullity is a useful support API | The proposed nullity notions collapse into tautological restatements of observables, conflict with the Plucker/diamond theorem surfaces, or fail to produce reusable finite lemmas or diagnostics |
| CPT two-sheet supplies in/out scattering states | No consistent CPT two-sheeted structure survives on the causal graph, or the sheets do not separate into well-defined incoming/outgoing data |
| Null-horizon thermodynamics gives gravity | Edge-count entropy and momentum flux do not yield Raychaudhuri/Clausius behavior under coarse-graining |
| Quantum histories avoid Bell hidden-variable failure | The decoherence functional cannot produce quantum correlations while preserving operational no-signalling and strong positivity |
| Watch-list problems become real program branches | Black-hole information, strong CP, confinement, or hierarchy claims do not produce a finite constraint, scaling law, numerical pilot, or falsification test beyond rephrasing existing open problems |

This ledger is important. It keeps the program scientific and prevents the
ontology from becoming unfalsifiable prose.

## Prior art and differentiation

Several mature programs overlap parts of this synthesis. They should be cited
as prior art and explicitly differentiated, not rediscovered. The defensible
novelty here is the finite, causal-graph, Lean-checked layer and a few specific
identifications, not the bare unification slogan.

| Prior work | What it already covers | What this program adds |
|---|---|---|
| Arkani-Hamed-Huang-Huang massive spinor-helicity (arXiv:1709.04891): \(\langle\lambda^I\lambda^J\rangle = m\,\epsilon^{IJ}\), \(\det p = m^2\) | The two-spinor mass-as-determinant identity (the \(n=2\) case) | The Cauchy-Binet / Gr(2,n) generalization to a bundle of \(n\) null edges, kernel-checked |
| Chin-Lee momentum bispinor / two-qubit entanglement (arXiv:1407.2492), Peres-Scudo-Terno reduced spin entropy (quant-ph/0203033), Gingrich-Adami moving-body entanglement (quant-ph/0205179), and Fullwood-Vedral-Guzman-Gonzalez Lorentzian quantum information (arXiv:2604.07471) | Mass/concurrence and Bloch-ball analogies, together with the warning that normalized reduced spin or entanglement data are frame-dependent under boosts; recent work emphasizes unnormalized linear-entropy/Lorentzian invariants | A stricter invariant/frame-relative split: Lean-check `det(P_vis)=m^2` and `det(A P_vis A^dagger)=det(P_vis)` for the unnormalized resolution output, treat `det(P_vis/Tr(P_vis))` only as the frame-relative `m/E` wrapper, and use the internal Gram law `det(V G V^dagger)=w^dagger (Lambda^2 G) w` as the concrete observer-channel mechanism |
| Dupuis-Speziale-Tambornino spinors/twistors in loop gravity (arXiv:1201.2120) | Spinor-network phase space, twisted geometries, holonomy-flux reconstruction, and closure as a node constraint | A corrected finite closure/source bridge: Pluecker mass is the Casimir of energy and closure vector, while closure defects pair with diamond source observables |
| Arkani-Hamed et al. positive Grassmannian (arXiv:1212.5605) | Positroid cells and positive Grassmannian stratification of on-shell diagrams | A cautious finite classification of null-edge bundles by Pluecker-minor vanishing/sign/phase data, with positivity restricted to real ordered sectors |
| Cortes-Smolin energetic causal sets (arXiv:1308.2206; PRD 90, 084007; arXiv:1407.0032) | Energy-momentum on causal links, conserved at events, a twistorial representation, and a spin-foam/BF link; supplies a dynamics | The CP^1 Pluecker/mass geometry and the Lean-checked finite holonomy and mass theorems, which ECS lacks |
| Energetic-causal-set edge-locality refinements | Locality is better attached to causal links/edge neighborhoods than to naive point valency | A finite `edgeNeighbor_N` relation usable as an explicit locality hypothesis in Lean and simulations |
| Krasnov-Torres-Gomez / Smolin enlarged Plebanski (arXiv:0911.3793, 1112.5097, 0712.0977) | Gravity + Yang-Mills + Higgs from one constrained 2-form, with the Higgs as the off-diagonal block and an E8-relevant version | The discrete null-edge realization and the mass = simplicity-defect identification at the finite level |
| Bahr-Belov and Assanioussi-Bahr volume/Hopf-link simplicity (arXiv:1710.06195, 2005.12004) | Extra volume/geometricity constraints for EPRL-like bivector data, including Hopf-link conditions on boundary graphs | A finite boundary-graph scaffold testing whether Pluecker simplicity plus closure can talk to spin-foam geometricity without claiming full sector isolation |
| Alexander-Marciano-Smolin graviweak chirality (arXiv:1212.5246) | Weak \(SU(2)\) as the chiral half of the spacetime connection; a Dirac fermion as a chiral neutrino plus a Higgs-quantum-number scalar | The discrete chirality-flip vertex and its tie to the Pluecker/simplicity mass picture |
| D'Ariano-Mosco-Perinotti-Tosini, Bisio-D'Ariano-Perinotti-Tosini, Arrighi-Nesme-Forets, Farrelly, Sato-Katori, Eon-Di Molfetta-Magnifico-Arrighi, and related Dirac quantum-walk/QCA work (`JZEJ4VXA`, `BVJBTK8J`, `KCQGEDJE`, `4F87TGCN`, `964TN6X7`, `G7NXEZBU`, `VIAIBSRI`) | Homogeneous Weyl/Dirac quantum walks and QCA, small-momentum Dirac limits, discrete covariance issues, ultraviolet cutoff/convergence guardrails, and lightlike-wire discrete QED constructions | The null-edge interface: forced `L plus R` mass doubling, scalar flip as the mass selection rule, invariant `det(P_vis)=m^2` tied to the Pluecker theorem, and a clean separation between the homogeneous fixed-point package and the causal-set spinor-propagator frontier |
| Sorkin / Das-Nasiri-Yazdi everpresent Lambda (`ZP7E648U`, `K5CFI3HI`, `IHVSDGUC`) | Fluctuating sign-changing cosmological constant of order `1 / sqrt(V)` from causal-set discreteness plus unimodular conjugacy, together with observational tests and amplitude tension | A possible finite source-visibility reason for the mean-zero target: coherent/internal vacuum bookkeeping should be boundary-like while visible Plucker excitations source bulk diamond defects |
| Quillen superconnections (`WNATKBT5`), Ackermann-Tolksdorf generalized Lichnerowicz (`BQJAG9TR`), Chamseddine-Connes spectral action (`6WURA7MF`), and Lee superconnection gauge-Higgs (`3Z543SD3`) | The general principle that Dirac-type operators square to Laplacians plus curvature, scalar, and Higgs/gauge terms | The finite causal-order-complex version whose kinetic symbol is the Lean-checked Pluecker determinant, whose Higgs/Yukawa block is equated with it on shell, and whose curvature block is causal-diamond holonomy |
| Marcolli-van Suijlekom gauge networks (arXiv:1301.3480) and Perez-Sanchez's comment on their continuum limit (arXiv:2508.17338) | Graph/quiver Dirac operators in finite spectral-triple language, with lattice gauge/Higgs spectral-action terms; plus the warning that the naive continuum limit can lose the Higgs scalar and become pure Yang-Mills | The causal-directed, Lorentzian/Krein, Pluecker-kinetic specialization: the missing contribution is a symbol/soldering theorem and a check that the `Phi` block survives as a genuine causal/Higgs field rather than finite bookkeeping |
| Foldy-Wouthuysen (`NFMI3A99`), Newton-Wigner (`74NU4C33`), and Thaller's *The Dirac Equation* (`UI9343SX`) | Standard branch diagonalization, positive/negative-energy projectors, and localization caveats for Dirac theory | A finite algebraic two-sheet projector theorem that must be interpreted cautiously before being tied to particle/antiparticle, CPT, or scattering boundary data |
| Kim-Lee massive ambitwistor zig-zag theory (arXiv:2301.06203) and massive twistor particle models | Massive spinning-particle phase spaces, symplectic perturbations, little-group quotient data, and background-field coupling | A continuum target for the finite Pluecker/Bargmann phase and diamond-holonomy phase transport |
| Ruskai-Szarek-Werner CPTP qubit maps (quant-ph/0101003) | Complete positivity constraints and affine Bloch-ball form of qubit channels | A finite dynamics language for reduced celestial mass/proper-time evolution and l=1 channel/generator spectral gaps |
| Bianconi topological Dirac operator and network mass (`8ITHD4PG`; arXiv:2106.02929, 2309.07851) | \(D=d+\delta\) on a complex, \(D^2=\) Laplacian, \(\{\gamma,D\}=0\), gapped dispersion, and a self-consistent network mass-gap equation | The causal-poset / order-complex setting, the no-doubling argument, and the link to the Pluecker mass and chirality-flip Higgs |
| Dirac-Bianconi graph neural networks | Non-diffusive topological-Dirac propagation for node/edge/higher-cochain signals, avoiding ordinary Laplacian oversmoothing | A simulation testbed for whether the finite order-complex operator preserves null-edge phase and mass-spread observables |
| Boyle-Deng CPT-symmetric Kähler-Dirac fermions (`ZZCFUGH8`) and Boyle-Finn-Turok CPT-symmetric universe (`68R6TZ6X`) | Two-sheet/KD-Majorana interpretation for Lorentzian Kähler-Dirac wrong-sign sectors, and a cosmological CPT universe with strong phenomenological claims | A finite branch-projector and causal-order-complex testbed; compatible predictions must be cited as imported unless derived from the null-edge operator |
| Dubois-Violette-Todorov exceptional quantum geometry (arXiv:1806.09450, 1808.08110) and Boyle exceptional Jordan/triality program (arXiv:2006.16265) | The Albert algebra `H_3(O)` as an internal-space candidate for Standard Model structure and three generations | The rank-2/rank-3 split: visible mass geometry is `H_2(C)` and generation structure is kept out of the null geometry, living instead in the internal Jordan/Yukawa label layer |
| Barnum-Graydon-Wilce composites of Euclidean Jordan algebras (arXiv:1606.09331) | Exceptional Jordan summands obstruct the usual non-signaling composite constructions under stated categorical/probabilistic axioms | A cautious tensorial-autonomy guardrail for treating `H_3(O)` as an internally rigid substrate, not a derivation of the Standard Model |
| Klyachko quantum marginal problem (quant-ph/0511102) | Linear/moment-polytope constraints on compatible reduced spectra | A finite hierarchy audit: the internal generation layer should constrain visible mass spectra before it claims Yukawa leverage |
| Faulkner-Leigh-Parrikar-Wang ANEC from modular Hamiltonians (arXiv:1605.08072) | Null-energy positivity from relative entropy and modular Hamiltonians | A discrete ANEC/QNEC-style positivity gate for the diamond-source gravity branch |
| Casini, Ceyhan-Faulkner, Fawzi-Renner, and Sorkin-Johnston entropy (`S9FTNNRU`, `TFGTQQTU`, `BHNTND4W`, `8TA2W3MV`, `G2JGSV9B`) | Relative entropy as Bekenstein/ANEC/QNEC control; recoverability as approximate Markov structure; causal-set entropy from SJ/correlation data with truncation caveats | A finite observer-channel API: source visibility should be measured by relative-entropy loss and recoverability, using SJ-style diamond reference states only with explicit truncation conventions |
| Dowker-Philpott-Sorkin swerves (arXiv:0810.5591; Phys. Rev. D 79, 124047) | Lorentz-invariant energy-momentum diffusion as a phenomenological consequence of causal-set discreteness | A warning/pilot for stochastic flip dynamics: coherent mass generation must be separated from diffusion-producing decoherence |
| Causal fermion systems | Operator-theoretic local correlation operators and a causal action principle | A stress test for whether visible density and super-Dirac data a d m i t an action-principle translation; failure would clarify the difference rather than refute the null-edge program |
| Spielman-Srivastava sparsification, Hodge edge-flow, magnetic-Laplacian, and gain-graph literatures | Effective-resistance edge scores, Hodge decomposition on edge flows, switching/gauge equivalence, magnetic spectra, and graph gain phases | A disciplined observable-relative vocabulary for saying which finite null-edge observables can or cannot see an edge, chain, quotient class, or gauge phase |

The genuinely open contributions this program can claim are: (i) the
Cauchy-Binet / Gr(2,n) bundle generalization of the mass; (ii) the finite
Dirac square-root wrapper of that Pluecker mass; (iii) the identification of
the Pluecker simplicity defect with the spin-foam simplicity constraint as one
finite statement; (iv) the Lean-formalized finite holonomy and Pluecker
theorems; (v) the rank-2/rank-3 Jordan split that keeps spacetime mass in
`H_2(C)` and generations in the internal `H_3(O)` layer; and (vi) the proposal
that Benincasa-Dowker curvature
and Jacobson Clausius balance are two traces of one diamond
\(\langle B, F\rangle\) pairing.

## Proposed publication path

### Paper 1: finite checkerboard and spin-projector algebra

Core contribution:

- Lean-checked finite checkerboard recursion;
- Lean-checked finite checkerboard dynamics and endpoint closed forms;
- Lean-checked coherent projector identities;
- Lean-checked null-step factorization;
- prose connection to Feynman checkerboard and Foster-Jacobson.

Novelty:

- formal verification and convention-clean theorem packaging, not a claim of
  discovering the checkerboard.

### Paper 2: Pluecker mass from null spinor bundles

Core contribution:

- trusted complex Pluecker mass theorem;
- celestial Bloch-sphere rewrite: mass as missing dipole / angular variance;
- reduced-density rewrite: normalized mass ratio as visible celestial
  mixedness;
- equality iff collinearity;
- relation to future null momentum sums;
- spinor-chart two-twistor matching as a convention-checked wrapper;
- optional quaternionic analogue;
- clear separation between finite algebra and continuum dynamics.

Novelty:

- the mass mechanism as a precise organizing theorem for null-edge graph
  programs.

### Paper 3: causal diamonds as gauge-curvature carriers

Core contribution:

- trusted finite diamond holonomy model;
- Abelian gauge invariance of path-comparison defects;
- non-Abelian endpoint covariance and class-function invariance;
- vertical and horizontal composition laws for path-pair defects;
- continuum interpretation as a causal replacement for plaquettes;
- roadmap to higher-gauge versions.

Novelty:

- a clean graph-native gauge-curvature target compatible with causal DAGs.

### Companion note: Jordan split and generations

Core contribution:

- visible momentum space as the rank-2 Jordan algebra `H_2(C)`;
- internal generation hypothesis as the rank-3 Albert algebra `H_3(O)`;
- source-backed comparison with Dubois-Violette, Todorov, and Boyle;
- explicit caveat that generation counting is not a Yukawa spectrum or mixing
  theorem.

Novelty:

- not a new Albert-algebra model, but a clean interface between the existing
  internal-generation literature and the null-edge Pluecker mass layer.

## Short canonical thesis

The strongest version of the program is:

> A null-edge causal graph theory should be built as a quantum measure over
> causal/twistor incidence histories. Visible edges carry complex null spinors,
> whose non-collinear bundles have invariant mass equal to a Pluecker
> determinant, equivalently the missing dipole moment of their celestial
> direction distribution or the mixedness of a reduced visible celestial
> qubit. The Pluecker determinant is a squared quantity: the static square
> root is a finite Dirac-slash operator built from the bundle momentum, while
> the dynamical square root should be a first-order transfer operator on a
> doubled \(L\oplus R\) celestial space. In that operator, Higgs/Yukawa
> chirality flips are the off-diagonal mass block, the complex Pluecker
> amplitude carries the phase information discarded by the squared modulus,
> and the sign of the square root supplies the two-sheet branch data that any
> CPT or scattering interpretation must respect. The larger conjecture is
> that a causal super-Dirac operator on the order complex has the Pluecker
> scalar, Higgs/Yukawa chirality-flip block, and causal-diamond curvature block
> as compatible pieces of its square. Fermion masses arise when Higgs/Yukawa
> insertions permit chirality-changing null continuations, with the dynamical
> mass conjecturally calibrated by the first-order flip generator whose
> square-level diagnostic is the l=1 relaxation gap of the reduced visible
> channel.
> Octonionic and exceptional algebraic structures label internal transition
> rules rather than observed spacetime coordinates; the sourced generation
> hypothesis places the family index in an internal `H_3(O)`/Albert layer, not
> in the visible null geometry. Gauge curvature is measured by
> causal-diamond holonomy defects.
> Gravity is approached as the continuum equation of state of null-edge
> entropy and momentum flux. The current trusted outputs are finite
> Lean-checked algebraic and combinatorial theorems; continuum physics remains
> a later, explicitly conjectural layer.

That is ambitious, but it is disciplined. It keeps the beautiful synthesis
while giving the Lean kernel small, durable mathematical targets.
