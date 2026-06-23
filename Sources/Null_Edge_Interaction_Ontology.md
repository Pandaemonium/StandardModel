# Null-edge interaction ontology

**Status:** speculative ontology note grounded in finite theorem targets,
observer-channel reframing, 2026-06-23.

**Related documents:**
`Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`,
`Sources/Null_Edge_Causal_Graph_Publication_Plan.md`, and
`Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`.

## Executive thesis

The strongest ontological version of the null-edge program is:

> Reality is made of lawful null interactions. Particles are stable sectors of
> the finite quantum channels that coarse-grain those interactions.

This upgrades the earlier slogan, "particles are bundles of null edges." A
bundle is a kinematic object. A channel has dynamics, measurement, stability,
decay, information loss, and source visibility built in.

The mature ontology is:

> The fundamental objects are not particles in spacetime, but quantum-labeled
> null transitions in a causal incidence structure. A particle is a stable
> or metastable sector of the resulting transfer channel. Its invariant mass
> square is the determinant of the unnormalized observer-visible momentum block,
> equivalently the Pluecker spread of unresolved null components. An
> observer-conditioned celestial state measures the ratio `m / E_u`, not
> invariant mass itself. Higgs/Yukawa couplings are legal chirality-changing mass
> operators that first create left/right chirality coherence; visible mixedness
> appears only after an explicit dephasing, trace, detector restriction, or
> observer channel. Spin is the phase-coherent structure discarded by the scalar
> determinant. Gauge curvature is the holonomy defect between alternative
> histories. Gravity is the finite-diamond response to the subset of interaction
> bookkeeping visible as a bulk source.

The safe theorem-level core remains narrower:

> A timelike visible momentum can be represented as a finite bundle or reduced
> visible state of null spinor directions, and its invariant mass is exactly the
> unnormalized Pluecker spread of those null components. After an observer-time
> normalization is fixed, the corresponding normalized celestial mixedness is
> the frame-relative ratio `m/E`.

The full ontology is still conjectural. The new sharpening is that
observer-channel compression should be treated as the master finite principle,
while the invariant/frame-relative split must be explicit.

The most disciplined mathematical core can be stated without the full ontology:
a future-causal momentum is a positive Hermitian spinor matrix; its determinant
is invariant mass squared; rank-one factorizations resolve it into null
spinors; and a chosen timelike observer turns the same matrix into a celestial
qubit whose mixedness measures `m / E_u`. The proposed dynamics then asks
whether a finite null-step Dirac transfer makes this same ratio appear as
chirality coherence and as the stable-sector readout of a causal quantum
channel.

So the compressed research spine is:

```text
positive Hermitian momentum
-> Plucker null-spinor resolution
-> observer-conditioned celestial qubit
-> chirality coherence
-> null-step transfer dynamics
-> stable or metastable particle sectors.
```

The broad claim that null interactions are ontologically fundamental should be
read as an interpretation of this spine, not as evidence for it.

## Master principle

The proposed master principle is:

> Physics is the invariant theory of what survives coarse-graining from a
> null-edge interaction network.

Equivalently:

> Mass, curvature, measurement outcomes, and gravitational sources are finite
> defects of attempting to compress richer null-edge data through an observer
> channel.

Here "observer" does not mean a subjective mind. It means a physical channel,
quotient, sector projection, detector algebra, or coarse-graining map. The
channel must be specified before a claim can be invariant, monotone, or
recoverable. In particular, a channel that normalizes by `Tr(P)` has also chosen
a timelike reference vector or energy convention; it is a frame-relative
observable, not a Lorentz scalar by itself.

This gives a unifying defect dictionary:

```text
mass      = defect of projective collinearity
curvature = defect of path-independent transport
spin      = phase data lost by scalar compression
gravity   = source defect visible to diamond observables
```

The strongest compact slogan is:

> Invariant mass is the unnormalized Pluecker defect of null data; normalized
> mixedness is what that defect looks like to a specified observer frame.

## Frame-invariance correction

The referee audit forces an important correction. The invariant object is the
unnormalized `2 x 2` Hermitian momentum block:

```text
P = sum_i psi_i psi_i^dagger.
```

Its determinant is the Lorentz scalar:

```text
det(P) = m^2.
```

Under a spin-frame/Lorentz transformation `A in SL(2,C)`,

```text
P |-> A P A^dagger,
det(A P A^dagger) = det(P).
```

The normalized visible state

```text
rho_vis = P / Tr(P)
```

is different. Since `Tr(P) = 2E` uses the time component of the four-momentum,
`rho_vis` depends on a chosen timelike observer or rest-frame convention. Its
determinant measures:

```text
det(rho_vis) = det(P) / Tr(P)^2,
2 sqrt(det(rho_vis)) = m / E.
```

Thus normalized visible mixedness is a frame-relative mass-ratio/proper-time
rate, not invariant mass itself. This does not kill the null-edge mass theorem;
it improves its precision. The paper should lead with `det(P) = m^2` and then
use normalized `rho_vis` only after explicitly fixing the observer channel or
frame.

This also changes the novelty claim. The kinematic relation between massive
two-spinor/twistor data and concurrence has prior art, especially Chin and Lee
(`arXiv:1407.2492`, Zotero `3VBEK82X`), and the non-covariance of reduced spin
entropy is a standard warning from Peres-Scudo-Terno
(`Phys. Rev. Lett. 88, 230402`, also `quant-ph/0203033`) and Gingrich-Adami
(`Phys. Rev. Lett. 89, 270402`, also `quant-ph/0205179`). The program's
defensible novelty is the finite
null-edge/Lean-checked packaging, the unnormalized invariant/channel split, and
the still-open dynamical proposal connecting proper-time rate to null-edge
coarse-graining.

The clean observer-conditioned state is:

```text
rho_{p|u} = U^{-1/2} P U^{-1/2} / Tr(U^{-1} P),
U = u.sigma,
```

for a unit timelike observer `u`. With the standard bispinor convention,

```text
det(rho_{p|u}) = m^2 / (4 (p dot u)^2),
2 sqrt(det(rho_{p|u})) = m / (p dot u).
```

The formula `rho_vis = P / Tr(P)` is a special-frame shorthand. It should not
be used as the canonical Lorentz-covariant definition in publication text.

Fixing the observer also supplies a distinguished two-null resolution of a
timelike momentum. With

```text
E_u = p dot u,
q = p - E_u u,
s = sqrt(E_u^2 - m^2),
n = q / s,
```

one may set

```text
k_+ = ((E_u + s) / 2) (u + n),
k_- = ((E_u - s) / 2) (u - n).
```

Then

```text
k_+^2 = k_-^2 = 0,
k_+ + k_- = p.
```

This is a clean theorem target because it makes the two-null picture canonical
after choosing `u` and the observed momentum direction. It is also a guardrail:
null resolutions are not unique in general, so different spinor bundles
realizing the same `P` should be treated as purification, hidden-isometry, or
observer-channel freedom rather than as directly distinguishable constituent
realities.

## Finite causal quantum instrument

The primitive object should be a finite causal quantum instrument, not merely a
bare graph. A finite diamond or local process has data of the schematic form:

```text
D = (V, E, psi, H_int, U, Phi, A, Omega)
```

where:

- `V` is a finite set of events;
- `E` is a finite set of causal null edges;
- `psi_e : C^2` is the visible spinor direction carried by edge `e`;
- `H_int` is the hidden/internal label space, carrying chirality, weak isospin,
  color, family, Higgs bookkeeping, and other unresolved labels;
- `U_e` is gauge transport along edge `e`;
- `Phi_v` is an odd chirality-changing Higgs/Yukawa vertex operator;
- `A[h]` is the amplitude assigned to a compatible history `h`;
- `Omega` is the physical observer channel from full edge/history data to a
  visible algebra.

In the strict quantum-information version, `Omega` should be a completely
positive trace-preserving map, or more generally a quantum instrument whose
outcomes label accessible detector records. In algebraic or combinatorial
finite models, the same symbol can denote a quotient, sector projection,
partial trace, or restriction to an observable algebra. The point is not that an
observer chooses reality, but that a physically specified channel defines which
invariants are visible.

One extra calibration is essential. A normalized quantum channel preserves
probability, not absolute energy scale. Therefore a particle-sector model needs
a separate momentum readout

```text
P = M(rho)
```

before any observer normalization such as `rho_{p|u}` is applied. Without this
readout, a channel can describe information flow but cannot by itself define an
invariant mass.

The full process may carry data like:

```text
psi_e tensor internal_label_e.
```

The visible observer channel produces something like:

```text
rho_vis = Omega(rho_full),
P       = Tr(P) rho_vis.
```

Thus the ontology is not just:

```text
events + null edges + labels + amplitudes.
```

It is:

```text
finite null-edge data -> observer channel -> visible invariants.
```

## Particles as stable channel sectors

In ordinary language we say that particles interact. In this ontology, that is
a coarse-grained reversal. The underlying reality is interactional; "particle"
is the name for a stable pattern in the transfer algebra of the interaction
network.

Let `T_D` denote the effective transfer operator across a diamond or family of
diamonds. A particle species should be modeled as an approximately idempotent,
representation-stable sector:

```text
T_D Pi_a ~= lambda_a Pi_a.
```

Here `Pi_a` is a stable projector or recurrent sector. Then:

```text
particle species = stable projector / recurrent sector
state of particle = vector or density matrix inside that sector
mass = visible determinant invariant of that sector
charge = conserved internal flow label of that sector
spin = projective spinor phase representation of that sector
lifetime = inverse leakage out of that sector
decay = failure of approximate idempotence
```

This is sharper than saying that a particle is a bundle. A bundle explains a
kinematic mass invariant. A stable channel sector can also explain persistence,
decay, scattering, and measurement.

The sharper quantum-channel version uses a completely positive transfer channel
`T`. Particle identity should be looked for in fixed observable algebras of
`T^dagger`, noiseless subsystems, peripheral modes with `|lambda| = 1`, and
metastable modes with `|lambda| < 1` close to one. For a discrete time step
`Delta t`, a metastable eigenmode has the natural lifetime

```text
tau = - Delta t / log |lambda|.
```

With momentum labels present, a particle branch should have

```text
lambda_a(k) ~= exp(-((Gamma_a(k) / 2) + i E_a(k)) Delta t),
E_a(k)^2 ~= |k|^2 + m_a^2.
```

This imports the right quantum-information vocabulary: preserved information,
fixed points, noiseless subsystems, and long-lived spectral sectors. It also
keeps the ontology honest: a projector by itself is not a particle species
until the transfer channel and its spectral branch are specified.

This is analogous to superselection sectors in algebraic quantum field theory,
but only as a loose structural analogy. In the Doplicher-Haag-Roberts picture,
particle charges are organized by localized, transportable endomorphisms of a
local observable algebra, with fusion, statistics, and gauge reconstruction
coming from locality hypotheses. A finite null-edge transfer-sector model does
not yet have those inputs, and DHR is not naturally built for the massless
sectors that this program treats as primitive. The useful lesson is therefore
narrower: particle identity should be represented by stable sectors of an
observable or transfer algebra, not by primitive beads.

An unstable particle is a metastable null-edge pattern with leakage into other
sectors. A muon is not a heavier bead in the primitive ontology. It is a
different metastable channel sector, with different visible mixedness, internal
labels, Yukawa couplings, and allowed decay channels.

## Mass as lost null-direction information

The central theorem spine is the finite Pluecker mass identity. A single visible
null edge has rank-one Hermitian momentum:

```text
p_i = psi_i psi_i^dagger
det(p_i) = 0.
```

A finite visible bundle has total momentum:

```text
P = sum_i psi_i psi_i^dagger.
```

The invariant mass square is:

```text
m^2 = det(P) = sum_{i<j} |psi_i wedge psi_j|^2.
```

Thus a single visible edge is massless, and a collinear family of edges is still
massless. Mass appears when the visible null directions fail to be projectively
collinear.

After fixing a timelike observer convention, normalize in an observer-conditioned
way:

```text
rho_{p|u} = U^{-1/2} P U^{-1/2} / Tr(U^{-1} P).
```

In a special frame this may reduce to the shorthand:

```text
rho_vis = P / Tr(P).
```

Then, with the usual momentum convention,

```text
m / E_u = 2 sqrt(det rho_{p|u}).
```

This gives the frame-relative observer-channel reading:

```text
massless particle = observer sees a pure null-direction state
massive particle  = observer sees a mixed null-direction state
rest frame        = observer sees maximal celestial mixedness
```

So:

> Invariant mass is the unnormalized Pluecker spread of visible null data; the
> normalized mixedness is the observer-conditioned ratio `m/E_u`.

The word "hidden" is physical, not psychological. It means hidden by tracing out
or quotienting internal, chiral, history, phase, detector, or coarse-grained
degrees of freedom. The massive effective state is not "really slow" at the
fine level; the fine visible transfers remain null. What becomes timelike is
the unnormalized visible momentum block.

## Proper time as visible impurity

The same normalized formula gives a proper-time interpretation once a lab time
or observer frame has been fixed. For a null edge:

```text
det(rho_vis) = 0.
```

For a massive effective trajectory:

```text
det(rho_vis) > 0.
```

Thus the local proper-time rate can be written:

```text
d tau / dt = 2 sqrt(det rho_vis).
```

For a discrete history, the natural finite expression is:

```text
tau(H) = sum_k Delta t_k * 2 sqrt(det rho_vis,k).
```

This matches the relativistic relation:

```text
m / E = sqrt(1 - |v|^2).
```

In null-edge language:

```text
sqrt(1 - |v|^2)
= visible celestial mixedness
= failure of the observer-visible state to remain null-pure.
```

So:

> Proper time is the rate at which a null-edge process appears impure to the
> physically relevant visible channel, after the observer time convention has
> been fixed.

This suggests a Page-Wootters-style research bridge. In relational clock
constructions, time is read from correlations between a clock subsystem and the
rest of the state rather than imposed as an external background parameter. The
null-edge version would ask whether the frame-relative visible impurity rate of
a stable channel sector can act as the local clock variable for an effective
massive particle. This is a lead, not a theorem: the finite mass-ratio identity
is the bankable part, while the Page-Wootters interpretation requires a
specified clock subsystem, constraint, conditional-state construction, and a
clear explanation of how the frame-relative `m/E` quantity is reconciled with
the invariant `det(P)` mass.

This is a promising publication-level conceptual bridge once the finite qubit
theorems are packaged cleanly.

## Electrons, Higgs, and legal entangling power

An electron should not be pictured as a tiny massive object that is slowed down
by the Higgs field. The cleaner null-edge picture is:

- the fine visible components are massless/null;
- left-handed and right-handed Weyl components transform differently under the
  electroweak group;
- a bare chirality flip is not gauge legal;
- the Higgs/Yukawa insertion is the allowed odd transition that couples the two
  chiral components;
- after electroweak symmetry breaking, this coupling is seen as a mass term.

Let the chiral spaces be:

```text
psi_L in H_L
psi_R in H_R.
```

The legal odd Yukawa/Higgs maps are:

```text
Phi_Y        : H_L -> H_R
Phi_Y^dagger : H_R -> H_L.
```

The doubled first-order operator has the schematic form:

```text
D =
[ 0                    sigma.p + Phi_Y^dagger ]
[ barSigma.p + Phi_Y   0                       ].
```

Its square should contain:

```text
D^2 =
  visible null propagation
  + gauge curvature terms
  + Phi_Y Phi_Y^dagger mass blocks
  + commutator / covariant-derivative terms.
```

The sharpened bridge is chirality coherence first, observer mixedness second.
The proposed channel chain is:

```text
Yukawa / Higgs insertion
-> legal left/right coupling
-> left/right chirality coherence
-> explicit dephasing, partial trace, detector restriction, or observer channel
-> rho_{p|u} becomes mixed
-> det(rho_{p|u}) becomes nonzero
-> effective mass appears.
```

This is stronger than "null zigzags create mass." It says:

> Higgs/Yukawa coupling supplies the legal first-order chirality mass operator;
> visible mixedness is the observer-channel shadow of that coherent coupling.

The bridge remains a theorem target. The Standard Model tells us that the
Higgs/Yukawa term supplies the left/right mass coupling; the null-edge program
must still prove a finite channel model in which the Higgs/Yukawa singular value
and the Pluecker determinant are the same on-shell scalar. It should not count
an independent Higgs mass term and an independent Pluecker mass term as two
separate sources of mass.

## Null-step dynamics and chirality coherence

The ontology becomes much more credible when the null-edge story is tied to a
finite dynamics, not only to a kinematic decomposition. A promising exact model
is the discrete null-step quantum walk

```text
U_a(k) = exp(-i k a sigma_z) exp(-i mu a sigma_x).
```

Its quasienergy satisfies

```text
cos(omega a) = cos(k a) cos(mu a).
```

For a nondegenerate eigenstate, the `z`-chirality coherence is

```text
C_z = |sin(mu a)| / |sin(omega a)|.
```

In the continuum limit this tends to

```text
mu / sqrt(k^2 + mu^2) = m / E.
```

This is exactly the kind of bridge the ontology needs: luminal conditional
shifts, chirality-flip amplitude, Dirac dispersion, and the observer-visible
proper-time ratio appear in one finite model. It should be treated as a
priority theorem target for the P2/P4 dynamics paper. The interpretive slogan
"all elementary visible movement is lightlike" is strongest when it can be
backed by this kind of first-order transfer operator, not merely by the fact
that any timelike momentum admits null decompositions.

## Spin as the phase data discarded by mass

The Pluecker mass formula uses:

```text
|psi_i wedge psi_j|^2.
```

This is a scalar shadow. It discards the complex phase of:

```text
W_ij = psi_i wedge psi_j.
```

Thus the mass theorem should be seen as the modulus layer of a richer spinor
invariant:

```text
m^2 = sum_{i<j} |W_ij|^2.
```

The phases of `W_ij` are natural candidates for:

- spin orientation data;
- Berry/Pancharatnam phase;
- chirality-history information;
- fermionic sign behavior;
- holonomy around null-edge loops.

The guiding slogan is:

```text
mass = modulus of null-direction spread
spin = phase coherence of null-direction spread
```

This is not a claim that spin is literal mechanical rotation. Fermion spin is
representation and phase data of a spinor state. The research target is to keep
the complex wedge and projective phase information before reducing to the
scalar determinant.

There is also an important invariant-theory caveat. A single phase of
`W_ij = psi_i wedge psi_j` changes under spinor rephasings, so raw Plucker
phases are not automatically physical spin. The safe observables are
rephasing-invariant combinations, such as Bargmann/Pancharatnam products around
closed spinor triples or loops, together with the standard massive `SU(2)`
little-group representation. The useful finite task is to identify which
phase data survive the observer channel and holonomy quotient.

The classical gyroscope analogy has limited value. It suggests that a coherent
internal pattern can resist reconfiguration. In the finite theory, that
resistance should come from the stable sector, first-order operator, and
spinor-phase constraints, not from a tiny rotating body.

## Gauge curvature as another compression defect

Gauge fields are naturally interactional. They say how to compare internal data
transported along different histories.

Given two causal paths from `p` to `q`, the finite diamond defect is:

```text
Delta U(p,q; gamma_1, gamma_2) = U_gamma_1^{-1} U_gamma_2.
```

If the two histories agree, the defect is trivial. If they do not, the defect is
the graph-native curvature carrier. In the non-Abelian case, the raw defect is
endpoint-covariant, while class functions of the defect are gauge invariant.

Gauge curvature and mass are sibling defects:

```text
mass defect      = disagreement among null directions
gauge curvature  = disagreement among internal transports
spin phase       = disagreement among projective spinor phases
gravity source   = disagreement visible to diamond screen observables
```

Ontology slogan:

> Gauge curvature is the failure of alternative interaction histories to
> compress to one path-independent transport.

## Gravity as diamond source visibility

The gravitational branch is the most ambitious. It should be stated as source
visibility, not as a blanket claim that vacuum energy does not gravitate.

Define a finite diamond source functional schematically as:

```text
S_D(rho_full)
= pairing between observer-visible stress/source data and diamond test data.
```

The central question is whether hidden/internal/vacuum bookkeeping lies in the
kernel of this functional, or contributes only a boundary term:

```text
S_D(rho_hidden) = boundary term or zero
S_D(rho_visible_mass) != 0.
```

This is naturally adjacent to holographic causal-diamond language. Bousso-style
screen bounds and Holographic Space-Time models emphasize that a causal
diamond's physical content should be encoded by finite screen data, with bulk
physics emerging from constrained boundary degrees of freedom. The null-edge
program should use that literature as a guardrail, not as something already
derived. The finite task is to say exactly which diamond observer channel sees a
bulk source and which bookkeeping is only boundary-visible.

The program must distinguish:

- visible momentum closure;
- BF or surface closure;
- observer invisibility;
- boundary-exact bookkeeping;
- bulk source pairing;
- residual fluctuation scaling.

A source functional is still not gravity by itself. To become a gravitational
claim, the branch must also specify a response law, a conservation identity, a
universality or equivalence-principle statement, and a continuum or scaling
limit. Jacobson-style and entanglement-equilibrium derivations recover Einstein
dynamics only after substantial geometric and field-theoretic assumptions. The
null-edge program should use those results as guardrails, not as proof that a
finite diamond source functional already reproduces gravity.

The cosmological-constant branch becomes:

> Why does enormous internal or vacuum bookkeeping fail to appear as a
> volume-scaling finite-diamond source?

If internal vacuum bookkeeping is boundary-exact, closed, recoverable, or
observer-invisible, then it may fail to contribute a volume-scaling bulk source.
If visible Pluecker mass/energy does source a bulk diamond functional, the
program gets a sharp distinction between visible matter and hidden bookkeeping.

This is the possible route toward cosmological-constant leverage. It remains
high risk. The program must either derive an everpresent-Lambda-style
`1 / sqrt(V)` fluctuation law from finite counting/source data, or explain with
a concrete observer channel why the residual amplitude differs. It must also
avoid contradicting Jacobson-style horizon thermodynamics, where entropy
balance is supposed to recover Einstein sourcing by the stress tensor. If
hidden bookkeeping generically sources bulk volume, if residual fluctuations
inherit known everpresent-Lambda amplitude tensions without a new suppression
mechanism, or if source invisibility is imposed rather than derived, the branch
should be demoted.

## Measurement and observer-relative nullity

In this ontology, an observer is represented by a channel or quotient of the
full interaction data. Measurement is not merely revealing a pre-existing
particle property. It is imposing a physically available algebra on a richer
interaction pattern.

The same edge or chain can be:

- invisible to one quotient;
- visible to a spectral observable;
- removable by gauge;
- homologically trivial as a boundary;
- source-carrying for a diamond functional.

Thus "null" is observable-relative. A null edge is not an edge with no content.
It is null with respect to a specified invariant or observer map.

The information-theoretic sharpening has two distinct parts:

```text
observer-invisible
= distinct fine sources have the same or nearly the same observer output

recoverable
= fine information can be reconstructed from the observer output and a
  reference state/channel.
```

Relative entropy, data processing, and Petz-style recoverability are natural
finite tools for making reversibility precise. They are not automatic
invisibility theorems. In P9 source-visibility language, invisibility must be
defined by the chosen diamond source functional or observer algebra; a small
recoverability gap is evidence that coarse-graining is reversible, not that a
source has been erased.

## Candidate finite action principle

The ontology needs a finite variational object. A useful schematic candidate is:

```text
S = S_null + S_vertex + S_holonomy + S_visibility.
```

Here:

```text
S_null
```

enforces primitive nullity:

```text
det(psi_e psi_e^dagger) = 0.
```

```text
S_vertex
```

enforces local conservation and legal internal transitions:

```text
sum_in P_e - sum_out P_e = allowed source / sink defect
```

together with charge, chirality, and representation constraints.

```text
S_holonomy
```

weights gauge curvature defects:

```text
sum_diamond Re Tr(1 - U_loop).
```

```text
S_visibility
```

weights observer-visible source defects:

```text
sum_diamond F(Omega(rho_full), screen_data).
```

The operator-style version is:

```text
S = Tr f(D_D^2) + vertex constraints + boundary terms
```

with:

```text
D_D = d_U + delta_U + Phi + Phi^dagger.
```

The desired square is:

```text
D_D^2 =
  graph Laplacian
  + gauge curvature
  + Higgs / Yukawa mass blocks
  + visible Pluecker scalar
  + boundary / source terms.
```

This should become the mathematical spine of the synthesis.

## New theorem targets

### Theorem A: frame-audited observer-channel mass-ratio theorem

Let the full state be a pure null-edge state:

```text
|Psi> = sum_i c_i |psi_i>_vis tensor |a_i>_int.
```

Trace out internal labels:

```text
rho_vis = Tr_int |Psi><Psi|.
```

After fixing the observer energy normalization `Tr(P) = 2E`, the visible mass
ratio is:

```text
m / E = 2 sqrt(det rho_vis).
```

Interpretation:

```text
mass ratio m/E = concurrence / mixedness generated by hidden null-direction
                 information.
```

This is a useful bridge between the Pluecker theorem and quantum information,
but it is frame-relative because the normalization by `Tr(P)` uses the chosen
time component. The Lorentz-invariant theorem is the unnormalized statement
`det(P) = m^2`, together with `det(A P A^dagger) = det(P)` for
`A in SL(2,C)`. A new Lean target should make the contrast explicit:

```text
det_normalizedMomentum_eq_det_div_trace_sq
sl2_det_conj_invariant
normalized_mixedness_is_frame_ratio
observer_twoNullDecomposition_sum_eq_momentum
observer_twoNullDecomposition_each_null
```

### Theorem B: massless iff recoverable null direction

For the visible qubit:

```text
m = 0
<-> rho_vis is pure
<-> the visible null direction is recoverable
<-> the observer has no hidden which-direction uncertainty.
```

The recoverability statement must be made physically precise. In the minimal
finite version, it can mean that `rho_vis` is rank one and therefore determines
a single point of celestial `CP^1`. A stronger Petz-style recovery theorem
should wait until the observer channel and reference state are fixed.

The safe claim is about recoverability of the visible null direction, not
automatic recovery of the entire internal microstate. It would be too strong to
claim, without extra hypotheses, that a heavier particle means larger Petz
failure for all internal labels, or that a massless particle implies perfect
recovery of the full hidden sector.

### Theorem C: rest frame as maximal celestial mixedness

For normalized `rho_vis`:

```text
rho_vis = I / 2
<-> spatial momentum vanishes
<-> rest frame
<-> m / E = 1.
```

This is clean, finite, and physically interpretable, but it should now be read
as a frame-dependence witness. Maximal normalized mixedness identifies the rest
frame of a timelike bundle; boosting the same invariant `P` changes
`rho_vis = P / Tr(P)` while leaving `det(P)` fixed.

### Theorem D: gauge curvature as non-recoverable path information

For two histories `gamma_1` and `gamma_2`:

```text
Delta U = U_gamma_1^{-1} U_gamma_2.
```

Gauge curvature is nontrivial exactly when the internal comparison data cannot
be compressed to one path-independent transport. This should first be stated as
a finite holonomy-defect theorem, then only later as an information-theoretic
recoverability statement.

### Theorem E: finite super-Dirac square

Construct:

```text
D = d_U + delta_U + Phi + Phi^dagger
```

on a doubled chiral/internal edge complex. Prove its square decomposes into:

```text
D^2 =
  finite wave / Laplacian term
  + holonomy curvature
  + Higgs / Yukawa chirality-flip mass block
  + visible Pluecker determinant block
  + boundary / source defect.
```

This should be stated as a finite Weitzenbock/Lichnerowicz-style matrix
identity plus one genuinely program-specific block identification. The generic
fact that a Dirac-type operator squares to Laplacian plus curvature and
zero-form mass terms is standard. The potentially new theorem is narrower:
the Higgs/Yukawa or visible scalar block of this finite square must be shown to
equal the Pluecker determinant mass block already proved in the spinor theorem.

## Extended dictionary

```text
event
= node in causal incidence structure

null edge
= primitive lawful transition carrying rank-one visible spinor momentum

history
= compatible finite composition of null transitions

observer
= physical channel / quotient from full null-edge data to visible algebra

particle
= stable idempotent / eigenpattern of the null-edge transfer algebra

mass
= determinant / mixedness of the observer-visible null-direction state

proper time
= accumulated visible impurity of a null-edge process

spin
= projective spinor phase coherence not captured by scalar mass

charge
= conserved internal flow label under allowed vertex transitions

Higgs / Yukawa coupling
= legal odd chirality-changing operator that creates stable visible mixedness

gauge field
= comparison rule for internal labels along alternative histories

gauge curvature
= finite holonomy defect between alternative histories

measurement
= imposition of an observer channel that selects a stable visible algebra

gravity
= finite-diamond thermodynamic response to observer-visible source defects

spacetime
= reconstruction from causal order, counting, null incidence, and stable
   observer channels
```

## Implications

If the observer-channel interaction ontology is right, then the following become
guiding expectations:

1. **No primitive massive bead.**
   Massive particles are stable sectors of null interaction channels.

2. **Mass is channel-relative but invariant after the channel is fixed.**
   It measures spread, mixedness, or entanglement of visible null components,
   not an intrinsic property of a single fine edge.

3. **Proper time is visible impurity.**
   A process accumulates proper time at the rate its visible null-direction
   state fails to remain pure.

4. **The Higgs is a legal entangling gate.**
   Higgs/Yukawa couplings determine which chirality-changing internal
   transitions are legal and how strongly they generate stable visible
   mixedness.

5. **Spin is phase-coherent structure.**
   Spin belongs to the coherent spinor and representation data left over after
   the scalar mass compression.

6. **Gauge curvature is disagreement among histories.**
   Curvature is detected by holonomy defects across causal diamonds.

7. **Gravity is source visibility.**
   Bulk curvature responds only to the part of interaction bookkeeping visible
   to the appropriate diamond or screen source functional.

8. **Spacetime is reconstructed.**
   Events, distances, and timelike trajectories are large-scale reconstructions
   from causal-null incidence and stable observer channels.

9. **Quantum theory is native.**
   Histories carry amplitudes from the beginning; classical particles arise only
   after decoherence, sector selection, or coarse-graining.

## Claim-status ledger

| Claim | Current status |
|---|---|
| A finite bundle of null spinors can have timelike total momentum | Banked finite algebra |
| The determinant mass equals total pairwise Pluecker spread | Banked finite algebra |
| Unnormalized `det(P) = m^2` is the Lorentz-invariant mass scalar | Banked finite algebra / near Lean wrapper |
| Masslessness is equivalent to common visible null direction | Banked finite algebra |
| Normalized mass ratio `m/E` is visible celestial mixedness / concurrence after a frame or observer-time convention is fixed | Strong finite target with partial draft support; prior-art and frame audit required |
| Rest frame is maximal celestial mixedness | Strong finite target and frame-dependence witness |
| Proper-time rate equals visible impurity | Strong finite target, physics interpretation requires frame and clock-construction audit |
| The Dirac slash of bundle momentum squares to the Pluecker scalar | Kernel-clean draft support |
| Higgs/Yukawa insertion is the gauge-legal chirality-flip gate | Kernel-clean bookkeeping support plus standard physics |
| Higgs/Yukawa coupling creates left/right chirality coherence | Standard physics plus finite operator target |
| Visible mixedness appears after chirality dephasing, partial trace, detector restriction, or observer channel | Conjectural finite channel target |
| Gauge curvature is causal-diamond holonomy defect | Banked finite gauge theorem |
| Particles are stable channel sectors | Ontological and operator-theoretic conjecture |
| Particle identity resembles a finite superselection-sector problem | Loose analogy and formal target, not DHR correspondence |
| Page-Wootters clock language explains proper time | Research lead beyond the finite mass-ratio identity |
| Holographic screen data organize diamond source visibility | Research lead and guardrail for P9 |
| All elementary visible movement is lightlike | Guiding conjecture |
| Spin is phase coherence of complex Pluecker data | Plausible research direction |
| Gravity follows from source visibility of null-edge bookkeeping | High-risk research direction |
| Vacuum bookkeeping is boundary-like or observer-invisible | Open P9 target |

## Falsification and demotion criteria

The ontology should be weakened or demoted if:

- massive propagation cannot be connected to a natural first-order null-edge
  operator;
- the program treats normalized `rho_vis = P / Tr(P)` mixedness as Lorentz
  invariant rather than as a frame-relative `m/E` quantity;
- observer channels make the unnormalized mass scalar arbitrary rather than
  invariant under the physically fixed visible sector;
- stable particle sectors cannot be formulated without adding primitive
  particle labels by hand;
- Higgs/Yukawa chirality mixing cannot be represented as a finite odd operator
  whose square gives the expected mass block;
- the Higgs/channel model cannot show how left/right coupling generates
  chirality coherence, or cannot identify the observer/dephasing/trace channel
  that turns that coherence into visible mixedness;
- spinor phase data cannot be made compatible with the graph holonomy layer;
- the source-visibility branch fails to distinguish visible Pluecker mass from
  hidden/internal bookkeeping, or imposes invisibility instead of deriving it;
- hidden bookkeeping generically produces volume-scaling bulk sources;
- the holographic/screen reading supplies only metaphor and no finite diamond
  source functional;
- the continuum limit requires adding non-null primitive structures by hand;
- the ontology merely rephrases quantum field theory without new finite
  theorems, predictions, constraints, or formalized guardrails.

## Publication-safe phrasing

The ontology can guide the writing, but the paper should distinguish theorem
from conjecture. A safe high-level phrasing is:

> We propose that massive propagation can be modeled as the visible
> coarse-graining of fundamentally null components through a physical observer
> channel. In this model, each elementary visible step is lightlike and
> massless, while invariant mass square appears as the unnormalized Pluecker
> determinant of the non-collinearity, chirality mixing, or hidden-label
> entanglement of those null components. Normalized visible mixedness measures
> the frame-relative ratio `m/E`.

A stronger speculative version is:

> Interactions, not particles, are fundamental. Particles are stable sectors of
> finite null-edge transfer channels, and mass is an emergent invariant of the
> unnormalized observer-visible null-direction data. Frame-relative mixedness
> describes how that invariant appears to a specified observer channel.

The first form belongs in the main theorem-facing paper. The second form
belongs in a clearly labeled ontology or manifesto section until the operator
and source-visibility layers are stronger.

## Summary

The null-edge interaction ontology says that the world is a quantum grammar of
allowed causal-null transitions. A physical observer channel compresses this
grammar into visible states and invariants. Particles are stable sectors of the
resulting transfer algebra. Invariant mass is the determinant of the
unnormalized observer-visible momentum block; normalized mixedness is the
frame-relative `m/E` shadow of that determinant. Proper time is accumulated
visible impurity only after the observer time convention is fixed. Spin is the
phase-coherent data discarded by the scalar mass. Gauge curvature is
disagreement between histories. Gravity is the finite-diamond response to
observer-visible source defects.

The finite Pluecker mass theorem makes the central kinematic idea real. The new
observer-channel reframing makes the program sharper: mass, curvature,
measurement, and gravitational source are different defects of compressing
richer null data through finite physical channels. The remaining work is to
prove the dynamical operator story, connect Higgs/Yukawa bookkeeping to visible
mixedness, make spin and phase graph-native, and test whether source visibility
gives genuine cosmological-constant leverage.
