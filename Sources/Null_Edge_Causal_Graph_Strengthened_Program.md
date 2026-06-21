# Strengthened null-edge causal graph research program

**Status:** theorem-inventory and celestial-moment update, 2026-06-21.
**Related drafts:**
`Sources/Toward_a_Null-Edge_Causal_Graph_Formulation.md`,
`Sources/Luminal_Motion_Checkerboard_Research_Program.md`, and
`Sources/Luminal_Motion_Checkerboard_Publication_Advance_2026-06-11.md`.
**Lean anchors:**
trusted modules `PhysicsSM.Spinor.Checkerboard`,
`PhysicsSM.Spinor.CheckerboardDynamics`,
`PhysicsSM.Spinor.PluckerMass`, and
`PhysicsSM.Gauge.CausalDiamondHolonomy`;
no-sorry draft wrappers
`PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle`,
`PhysicsSM.Draft.TwistorPluckerMass`, and
`PhysicsSM.Draft.NullEdgeYukawaGaugeAristotle`;
active draft handoff `PhysicsSM.Draft.CausalDiamondHigherGaugeAristotle`.

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
mixedness of this reduced celestial qubit. After normalization
\(\rho=P_{\rm vis}/\operatorname{Tr}P_{\rm vis}\),
\[
2\sqrt{\det\rho}=m/E=d\tau/dt
\]
in units \(c=1\), with the usual momentum normalization conventions. This
turns "many null pieces" into a purification statement: a massive visible
particle can be a pure null process whose internal sector carries
which-null-direction information.

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

The complementary bivector synthesis is to regard the mass and gauge layers as
two finite uses of one bivector vocabulary. A null-spinor fan supplies a
`Lambda^2`/Plucker defect whose squared norm is mass; a causal diamond supplies
a surface bivector paired with a holonomy-curvature defect. The conjectural
continuum reading is Plebanski/BF-like: a `B` field paired with curvature,
with simplicity and reality conditions controlling any gravity interpretation.
This should be pursued first as a finite `B`-cochain wrapper, not as an
immediate claim that the continuum unification problem is solved.

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
  no-sorry dynamics theorems: history counts, corner-weight powers, last-step
  recursion, evolution by iterated transfer operator, and a finite
  Klein-Gordon-style recurrence. The no-sorry draft
  `PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle` proves endpoint
  closed forms for the right-starting right/right and right/left kernels.

- **Pluecker mass from null spinor bundles.**
  `PhysicsSM.Spinor.PluckerMass` is now the trusted algebraic keystone. It
  proves the two-edge determinant identity, the general finite bundle identity
  \(\det(\sum_i \psi_i\psi_i^\dagger)=\sum_{i<j}|\psi_i\wedge\psi_j|^2\),
  real nonnegativity, and the zero-mass/common-direction criterion.

- **Twistor/Pluecker matching wrapper.**
  `PhysicsSM.Draft.TwistorPluckerMass` is a no-sorry draft-facing convention
  wrapper. It shows that the spinor-chart two-twistor mass invariant reduces
  to the Pluecker wedge term, records the determinant-vs-trace normalization
  bridge, proves rescaling behavior, and extends the pairwise mass formula to
  finite multi-twistor charts.

- **Higgs/Yukawa permission for chirality flips.**
  `PhysicsSM.Draft.NullEdgeYukawaGaugeAristotle` proves the finite bookkeeping
  layer: the Higgs insertion carries the needed hypercharge, left and right
  multiplets have the expected chiralities, and the finite Yukawa flip patterns
  satisfy weak, color, electroweak, and combined gauge-legality predicates.

- **Causal-diamond holonomy.**
  `PhysicsSM.Gauge.CausalDiamondHolonomy` is trusted and no-sorry. It proves
  Abelian gauge invariance of the diamond defect, non-Abelian endpoint
  covariance, gauge invariance of class functions of the defect, and vertical
  and horizontal composition laws for path-pair defects.

- **Order-complex cochain seed.**
  `PhysicsSM.Draft.NullEdgeCochainDiamond` provides the finite cochain seed:
  the cochain coboundary dual to the order-complex boundary squares to zero.
  This is still a draft theorem island, not yet a full Kähler-Dirac graph
  operator.

### Remaining high-value challenges

- **Promote no-sorry drafts after semantic review.**
  Several draft modules are kernel-checked but still need API cleanup,
  provenance tightening, naming review, and convention audits before they
  should be treated as trusted public surfaces.

- **Prove dynamics, not just algebra.**
  The largest physics gap is still the continuum or scaling theorem saying
  that null-edge histories with a chirality-flip intensity flow to a Dirac
  operator with effective mass. The finite checkerboard theorems are strong,
  but they do not yet prove higher-dimensional universality.

- **Move beyond the spinor chart in twistor theory.**
  The current twistor result is a valuable chart-level wrapper. It does not
  yet formalize full twistor incidence, projective twistor geometry, real
  structures, or Penrose-transform/cohomological statements.

- **Complete the higher-gauge diamond layer.**
  The trusted diamond module handles ordinary group-valued holonomy defects.
  The active Aristotle handoff
  `PhysicsSM.Draft.CausalDiamondHigherGaugeAristotle` asks for transport,
  associativity, and interchange laws needed for a 2-categorical/higher-gauge
  version.

- **Formalize the bivector/BF wrapper.**
  The new synthesis asks for a finite `B`-cochain interface connecting
  Plucker mass defects and diamond curvature pairings. The near-term theorem
  should identify the `B` simplicity/Gram defect with the trusted Plucker mass
  and prove compatibility of `B`-weighted diamond pairings with existing
  vertical/horizontal composition laws. Plebanski, Urbantke, and
  Higgs-from-enlarged-connection interpretations remain sourced continuum
  motivation.

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

> Certain relativistic propagators and finite path sums admit exact
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

This gives a clean hypothesis:

```text
visible mass geometry: H_2(C), determinant norm, CP^1 celestial directions
internal generation geometry: H_3(O), Albert algebra, rank-three family slot
```

Caveat: this is a counting and representation-organization lead, not a mass
spectrum theorem. The charged-lepton/quark hierarchies and CKM/PMNS mixing
would have to come from eigenvalue/off-diagonal structure or dynamics in the
internal algebra. They are not produced by the Pluecker mass theorem.

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

## Core mathematical spine

### 0. Bivector/BF wrapper

The finite theorem spine can be organized by a `Lambda^2`-valued object `B`.
This is a wrapper idea, not yet a new trusted module.

```text
mass fan:
  B_ij = psi_i wedge psi_j
  mass defect = sum_{i<j} |B_ij|^2

diamond:
  B_D = finite surface/area label for a path-pair
  curvature pairing = <B_D, defect_D>
```

In this language, the Plucker theorem says the mass defect of the spinor fan
is exactly `det(sum_i psi_i psi_i^dagger)`. The diamond theorem says the
curvature carrier composes correctly under vertical and horizontal gluing.
The next target is to put these in one finite API and prove that the
`B`-weighted diamond pairing respects those gluing laws.

The Plebanski/BF interpretation is valuable motivation: continuum gravity can
be phrased using a two-form `B` paired with curvature, with simplicity
constraints and Urbantke metric reconstruction. But in this project that
belongs behind an explicit claim boundary, especially because Lorentzian
self-dual two-forms require complexification and reality conditions (the
area-metric reality constraint, Maran, arXiv:gr-qc/0504091).

Why one object can carry both roles: in four dimensions the self-dual
2-forms, the chiral \(su(2)_L\) algebra, and the symmetric 2-spinors
\(\mathrm{Sym}^2 S\) are the same three-complex-dimensional space,
\(\Lambda^2_+ \cong su(2)_L \cong \mathrm{Sym}^2 S\). The Maxwell spinor
factor \(\phi_{AB} = \psi_{(A}\chi_{B)}\) (Penrose), the Plebanski \(B^i\),
and the Pluecker minor \(\psi_i\wedge\psi_j\) are all valued there. Mass is
the wedge-square valuation of this object; gauge curvature is its pairing with
the connection. Assembling this in exactly the causal-graph / Pluecker form is
the part not found in the sourced continuum literature.

A clean finite target sits inside this picture: a 2-form `B` is simple (a
single wedge `u wedge v`) iff `B wedge B = 0` iff the associated Gram
determinant vanishes. For the spinor fan this is exactly the zero-mass /
common-direction criterion already proved in `PluckerMass`, so the spin-foam
simplicity constraint and the masslessness criterion become one finite
statement: mass is the simplicity defect.

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
constraint does not isolate a single Plebanski sector - it admits the
degenerate sector and both \((II_\pm)\) sectors - so recovering gravity needs an
extra condition (Engle's proper vertex, arXiv:1107.0709, 1111.2865), and the
finite statement should track which sector the simplicity defect lives in. The
BF action also carries a Barbero-Immirzi / Holst weight \(\gamma\); that is a
convention choice and should be recorded in the Stage 0 table.

### 0a. Observable-relative nullity wrapper

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

After normalization,

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
units \(c=1\), \(m/E=d\tau/dt\). Proper time is therefore the visible rate of
failure of the celestial qubit to be pure. A massless visible particle is a
rank-one/pure celestial state; a rest-frame massive particle is maximally
mixed in visible direction.

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

Two connections to existing literature sharpen this. First, the two-edge case
is the Arkani-Hamed-Huang-Huang massive spinor-helicity identity
\(\langle\lambda^I\lambda^J\rangle = m\,\epsilon^{IJ}\) with
\(\det p = m^2\); the finite bundle identity is its Cauchy-Binet
generalization to \(n\) null edges. Second, the spinors \(\psi_i\) form a
\(2\times n\) matrix whose Pluecker coordinates are the pairwise masses,
placing the construction in the Grassmannian \(\mathrm{Gr}(2,n)\); total
nonnegativity (all minors \(\ge 0\)) is exactly the statement that pairwise
masses are nonnegative, i.e. non-tachyonic. The trusted
`fin_bundle_det_re_nonneg` is the first instance of this positivity.

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

This is the right way to state the higher-dimensional checkerboard
universality problem. It remains conjectural until the l=1 block is shown to
reconstruct the full Dirac operator, not merely the scalar dispersion gap.
The fully quantum version should phrase this as a spectral property of the
reduced visible channel obtained from the internal unitary dynamics, rather
than as a literal Markov relaxation of a stable particle.

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
PhysicsSM/Draft/TwistorPluckerMass.lean
```

It defines a spinor-chart twistor fragment, the infinity-twistor pairing, the
two-twistor mass invariant, determinant and trace mass-square conventions,
and finite multi-twistor pairwise mass. The main proved bridges are:

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
theorem. The next formal target is the higher-gauge version in the active
Aristotle handoff `PhysicsSM.Draft.CausalDiamondHigherGaugeAristotle`.

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

`PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle` adds no-sorry draft
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

This module is trusted and no-sorry. It should be treated as a central anchor
for future twistor, momentum-bundle, and publication work.

### Twistor and Yukawa draft wrappers

`PhysicsSM.Draft.TwistorPluckerMass` and
`PhysicsSM.Draft.NullEdgeYukawaGaugeAristotle` are no-sorry draft layers that
connect the trusted algebra to physics-facing interpretations:

- the twistor wrapper matches the spinor-chart two-twistor invariant to the
  Pluecker wedge and extends it to finite pairwise mass;
- the Yukawa wrapper proves finite weak/color/hypercharge legality predicates
  for Higgs-permitted chirality flips.

They are strong enough to guide the research program, but should still be
reviewed before promotion out of `Draft`.

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
- a source table distinguishing primary sources, secondary reviews, and
  AI-generated synthesis.

New physics-facing claims should continue to cite this table so convention
choices stay visible and reviewable.

### Stage 1: finite Lean theorem layer

Completed or substantially completed:

1. trusted checkerboard finite combinatorics and dynamics;
2. draft no-sorry checkerboard endpoint closed forms;
3. trusted finite Pluecker mass identity and zero-mass criterion;
4. draft no-sorry spinor-chart twistor/Pluecker matching;
5. draft no-sorry Yukawa gauge-bookkeeping predicates;
6. trusted causal-diamond holonomy invariance and composition laws;
7. draft cochain coboundary square-zero theorem.

Near-term cleanup:

1. promote stable no-sorry draft modules after semantic and convention review;
2. resolve the higher-gauge diamond handoff;
3. package theorem names and source notes for publication;
4. reduce duplicated draft definitions once trusted modules provide the common
   API.
5. add a small `ObservableNullity` diagnostics layer for quotient, exact
   cochain, tree-gauge, homology-boundary, and rank-one spectral nullity.

This stage remains kernel-checkable and does not depend on analytic limits.

### Stage 2: finite-dimensional synthesis

Priority:

1. promote the twistor/Pluecker wrapper or replace it with a trusted minimal
   twistor chart module;
2. add the celestial-moment wrapper for the Pluecker theorem: Bloch
   decomposition, angular-variance identity, and dipole-saturation
   masslessness criterion;
3. add the reduced-celestial-density wrapper: visible partial trace,
   determinant as mixedness/concurrence-style invariant, mass ratio
   \(m/E=2\sqrt{\det\rho_{\rm vis}}\), and the internal-coherence caveat;
4. package the null-step projector theorem with the Pluecker mass theorem;
5. connect Yukawa flip legality to an internal unitary dilation / reduced
   visible mass channel before specializing to checkerboard-style effective
   corner or flip amplitudes;
6. state the chirality-flip universality conjecture as an l=1 spectral-gap
   statement for the celestial direction process, with the 1+1 telegraph
   factor audit carried explicitly;
7. prove the finite Berry/Pancharatnam triangle identity as the imaginary
   partner of the real Fubini-Study mass-spread identity, while keeping any
   spin interpretation conjectural until the graph-native holonomy layer is
   checked;
8. add a source-backed Jordan split note: visible `H_2(C)` determinant mass
   versus internal `H_3(O)` generation structure, with explicit caveats that
   mass ratios and CKM/PMNS mixing remain unsolved;
9. write a short expository paper tying the Lean results to the known
   checkerboard, Foster-Jacobson, twistor, and higher-gauge literature;
10. prove the topological Dirac targets on the order complex
   (`topological_dirac_sq_eq_laplacian`, `gapped_dirac_spectrum`) together with
   the no-doubling argument;
11. prove the simplicity / `B wedge B = 0` form of the zero-mass criterion and
   wire it into the bivector wrapper, matching the modern linear simplicity
   constraint (EPRL/FK) and keeping the single-bivector condition separate from
   the cross-bivector relations;
12. keep observable-relative nullity as a support API around the Plucker and
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
   coarse-graining and compare them with effective-resistance sparsification.

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

| Claim | What would weaken or kill it |
|---|---|
| Bivector/BF wrapper unifies mass and diamond curvature | The `B` simplicity defect cannot be matched to the Plucker mass without convention changes, or `B`-weighted diamond pairings fail to respect the finite composition laws; Lorentzian reality conditions may also block the continuum reading |
| Mass is Pluecker spread / missing celestial dipole of null edges | Mismatch with physical invariant mass conventions, failure of the Bloch angular-variance rewrite, or misuse outside the positive Hermitian spinor-bundle setting where the theorem applies |
| Mass is reduced celestial mixedness | The normalized determinant fails to match \(m/E\), the visible partial trace is not the correct observable, internal coherences invalidate the Pluecker-sum reduction in physically relevant cases, or proper-time rate cannot be tied to the reduced visible purity |
| Fubini-Study / QGT reading of pairwise mass and spin phase | The real part fails to match chordal Fubini-Study distance on CP^1, the Berry/Pancharatnam phase does not survive the graph-native holonomy layer, or the proposed spin interpretation has no invariant finite observable |
| Chirality-flip l=1 relaxation gap gives effective mass | Random isotropic flip ensembles do not flow to a Dirac dispersion, the l=1 block does not reconstruct the Dirac operator, the factor-of-two normalization cannot be made consistent, or anisotropic generators couple the l=1 sector to higher multipoles |
| Three generations arise from the internal Albert/Jordan layer | A fourth generation is observed, generation structure is forced by visible null geometry rather than internal labels, or `H_3(O)` cannot reproduce the required Standard Model family representations, Yukawa freedom, and mixing data without adding ad hoc states |
| Higgs permits graph chirality flips | Representation bookkeeping does not match Standard Model Yukawa quantum numbers |
| Twistor incidence is the right continuum target | Two-twistor mass invariant does not match the Pluecker mass term, or incidence reconstruction requires extra non-null structure |
| Causal diamonds replace plaquettes | Path-comparison defects are not gauge invariant, or their continuum limit fails to reproduce field strength |
| Kahler-Dirac order-complex route gives fermions | The graph cochain operator cannot reproduce a Weyl/Dirac continuum sector without reintroducing hidden lattice structure |
| Observable-relative nullity is a useful support API | The proposed nullity notions collapse into tautological restatements of observables, conflict with the Plucker/diamond theorem surfaces, or fail to produce reusable finite lemmas or diagnostics |
| CPT two-sheet supplies in/out scattering states | No consistent CPT two-sheeted structure survives on the causal graph, or the sheets do not separate into well-defined incoming/outgoing data |
| Null-horizon thermodynamics gives gravity | Edge-count entropy and momentum flux do not yield Raychaudhuri/Clausius behavior under coarse-graining |
| Quantum histories avoid Bell hidden-variable failure | The decoherence functional cannot produce quantum correlations while preserving operational no-signalling and strong positivity |

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
| Cortes-Smolin energetic causal sets (arXiv:1308.2206; PRD 90, 084007; arXiv:1407.0032) | Energy-momentum on causal links, conserved at events, a twistorial representation, and a spin-foam/BF link; supplies a dynamics | The CP^1 Pluecker/mass geometry and the Lean-checked finite holonomy and mass theorems, which ECS lacks |
| Krasnov-Torres-Gomez / Smolin enlarged Plebanski (arXiv:0911.3793, 1112.5097, 0712.0977) | Gravity + Yang-Mills + Higgs from one constrained 2-form, with the Higgs as the off-diagonal block and an E8-relevant version | The discrete null-edge realization and the mass = simplicity-defect identification at the finite level |
| Alexander-Marciano-Smolin graviweak chirality (arXiv:1212.5246) | Weak \(SU(2)\) as the chiral half of the spacetime connection; a Dirac fermion as a chiral neutrino plus a Higgs-quantum-number scalar | The discrete chirality-flip vertex and its tie to the Pluecker/simplicity mass picture |
| Bianconi topological Dirac operator (arXiv:2106.02929, 2309.07851) | \(D=d+\delta\) on a complex, \(D^2=\) Laplacian, \(\{\gamma,D\}=0\), gapped dispersion, and a self-consistent network mass-gap equation | The causal-poset / order-complex setting, the no-doubling argument, and the link to the Pluecker mass and chirality-flip Higgs |
| Dubois-Violette-Todorov exceptional quantum geometry (arXiv:1806.09450, 1808.08110) and Boyle exceptional Jordan/triality program (arXiv:2006.16265) | The Albert algebra `H_3(O)` as an internal-space candidate for Standard Model structure and three generations | The rank-2/rank-3 split: visible mass geometry is `H_2(C)` and generation structure is kept out of the null geometry, living instead in the internal Jordan/Yukawa label layer |
| Spielman-Srivastava sparsification, Hodge edge-flow, magnetic-Laplacian, and gain-graph literatures | Effective-resistance edge scores, Hodge decomposition on edge flows, switching/gauge equivalence, magnetic spectra, and graph gain phases | A disciplined observable-relative vocabulary for saying which finite null-edge observables can or cannot see an edge, chain, quotient class, or gauge phase |

The genuinely open contributions this program can claim are: (i) the
Cauchy-Binet / Gr(2,n) bundle generalization of the mass; (ii) the
identification of the Pluecker simplicity defect with the spin-foam simplicity
constraint as one finite statement; (iii) the Lean-formalized finite holonomy
and Pluecker theorems; (iv) the rank-2/rank-3 Jordan split that keeps
spacetime mass in `H_2(C)` and generations in the internal `H_3(O)` layer; and
(v) the proposal that Benincasa-Dowker curvature
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
> qubit. Fermion masses arise when Higgs/Yukawa insertions permit
> chirality-changing null continuations, with the dynamical mass conjecturally
> calibrated by the l=1 relaxation gap of the reduced visible channel.
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
