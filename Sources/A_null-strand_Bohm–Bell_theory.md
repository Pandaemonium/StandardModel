# A null-strand Bohm–Bell theory

A coherent research program can be constructed in which the **primitive material trajectories are lightlike at the regulated one-particle and finite-graph levels**, while ordinary massive, subluminal motion appears only after one ignores microscopic direction and internal-state information. The fully interacting continuum theory is not yet a completed model; it requires additional selection and synchronization principles.

The cleaned construction has three layers:

1. An established one-particle Dirac zig-zag model.
2. A corrected null-current representation using scaled null vectors or null spinors, with flux weighting on observer hypersurfaces.
3. Bell-type quantum-field-theory machinery for chirality changes, particle creation, and annihilation, treated as finite or conditional until the continuum hypotheses are supplied.

I will call the combined research program **Null-Strand Bohm–Bell Theory**, or NSBB.

The one-particle core is established physics. The many-particle and QFT extensions below are proposed completions and should be regarded as mathematically explicit research hypotheses rather than accepted theory.

Throughout most of the discussion I use (c=\hbar=1).

---

## 1. The ontology

A complete instantaneous state consists of

[
\bigl(\Psi_\Sigma,;Q_\Sigma,;A_\Sigma,;\Omega_\Sigma\bigr).
]

Here:

* (\Psi_\Sigma) is the quantum state on a spacelike hypersurface (\Sigma).
* (Q_\Sigma={X_1,\ldots,X_N}) is the actual particle configuration.
* (A_\Sigma) contains discrete labels such as chirality, flavor, particle type, and Fock sector.
* (\Omega_\Sigma={\omega_1,\ldots,\omega_N}) assigns each existing particle an actual spatial direction of unit magnitude.

The primitive trajectories satisfy

[
\frac{dX_k^\mu}{ds}
\propto
\ell_k^\mu,
\qquad
\ell_k^\mu\ell_{k\mu}=0.
]

Thus every existing strand is null between interaction events.

In a foliation-adapted frame,

[
\frac{d\mathbf X_k}{dt}=c,\boldsymbol\omega_k,
\qquad
|\boldsymbol\omega_k|=1.
]

A massive particle is not a slower microscopic object. It is a coarse-grained pattern in a null strand whose direction and internal label vary.

The wavefunction should preferably be interpreted nomologically—as part of the law governing the strands—rather than as another material object moving through space. Otherwise the statement “everything moves at (c)” would immediately become ambiguous, because a configuration-space wavefunction has no ordinary three-velocity.

---

# 2. Exact one-particle Dirac zig-zag dynamics

Write the Dirac spinor in chiral form,

[
\psi=
\begin{pmatrix}
\phi_R\
\phi_L
\end{pmatrix}.
]

The Dirac equation becomes

[
i\sigma^\mu D_\mu\phi_R=m\phi_L,
\qquad
i\bar\sigma^\mu D_\mu\phi_L=m\phi_R,
]

with

[
\sigma^\mu=(I,\boldsymbol\sigma),
\qquad
\bar\sigma^\mu=(I,-\boldsymbol\sigma).
]

Define the two chiral currents

[
j_R^\mu=\phi_R^\dagger\sigma^\mu\phi_R,
\qquad
j_L^\mu=\phi_L^\dagger\bar\sigma^\mu\phi_L.
]

For any nonzero two-spinor (\chi),

[
\left(\chi^\dagger\chi\right)^2
-------------------------------

\left|\chi^\dagger\boldsymbol\sigma\chi\right|^2
=0.
]

Consequently,

[
j_R^\mu j_{R\mu}=0,
\qquad
j_L^\mu j_{L\mu}=0.
]

Each chiral current is future-directed and null.

Let

[
\rho_R=j_R^0,
\qquad
\rho_L=j_L^0,
]

and

[
\mathbf v_R=\frac{\mathbf j_R}{j_R^0},
\qquad
\mathbf v_L=\frac{\mathbf j_L}{j_L^0}.
]

Then

[
|\mathbf v_R|=|\mathbf v_L|=1.
]

The mass term transfers probability between the two currents:

[
\partial_\mu j_R^\mu=F,
\qquad
\partial_\mu j_L^\mu=-F,
]

where, with the displayed conventions,

[
F=2m,\operatorname{Im}!\left(\phi_R^\dagger\phi_L\right).
]

This leads directly to a piecewise-deterministic Markov process. The actual configuration is

[
(\mathbf X_t,C_t),
\qquad
C_t\in{R,L}.
]

Between jumps,

[
\frac{d\mathbf X_t}{dt}=\mathbf v_{C_t}(\mathbf X_t,t).
]

The minimal chirality-jump rates are

[
\lambda_{L\rightarrow R}
========================

\frac{F^+}{\rho_L},
\qquad
\lambda_{R\rightarrow L}
========================

\frac{(-F)^+}{\rho_R},
]

where (x^+=\max(x,0)).

Thus, over a short time interval (dt),

[
\Pr(C_{t+dt}=R\mid C_t=L,\mathbf X_t=\mathbf x)
===============================================

\lambda_{L\rightarrow R}(\mathbf x,t),dt+o(dt),
]

and similarly for (R\rightarrow L).

The distribution

[
\Pr(\mathbf X_t\in d^3x,C_t=c)
==============================

\rho_c(\mathbf x,t),d^3x
]

is equivariant. Indeed,

[
\partial_t\rho_R+\nabla\cdot(\rho_R\mathbf v_R)
===============================================

# \lambda_{L\to R}\rho_L-\lambda_{R\to L}\rho_R

F,
]

and the analogous equation holds for (L). Summing gives

[
\rho_R+\rho_L
=============

\psi^\dagger\psi.
]

So the position marginal is exactly the ordinary Dirac Born density.

This is not merely a suggestive analogy: it is the established zig-zag pilot-wave model. Its one-particle trajectories are exactly luminal, including in its nonrelativistic regime. ([arXiv][1])

Restoring units, the transfer term contains

[
\frac{2mc^2}{\hbar},
]

so the Compton frequency sets the natural microscopic rate scale.

---

## 3. An important qualification: mass is not automatically a literal flip frequency

The continuity equations determine only the **net** chiral transfer:

[
\lambda_{L\to R}\rho_L-\lambda_{R\to L}\rho_R=F.
]

The most general rates with the same net current can be written

[
\lambda_{L\to R}\rho_L=F^++S,
]

[
\lambda_{R\to L}\rho_R=(-F)^++S,
]

for any nonnegative symmetric traffic (S(\mathbf x,t)).

The minimal theory chooses

[
S=0.
]

That choice has the fewest possible jumps. Bell-type process theory makes this nonuniqueness explicit: equivariance fixes the antisymmetric probability current, but an additional symmetric flow can always be added.

This matters for a momentum eigenstate. For a positive-energy plane wave, the relative phase of (\phi_R) and (\phi_L) can be chosen so that

[
F=0.
]

The two branches nevertheless move in opposite null directions with unequal weights proportional to quantities of the form

[
E\pm|\mathbf p|.
]

Their weighted mean is

[
\frac{\mathbf p}{E},
]

but in the minimal model an individual plane-wave trajectory remains on whichever null branch it initially occupies.

Therefore:

[
\boxed{\text{mass term causes chiral coupling}}
]

is exact, whereas

[
\boxed{\text{mass equals an actual count of trajectory reversals}}
]

is not exact without an additional, nonminimal jump law.

One could deliberately choose (S) so that a plane-wave particle continues to switch with a rate of order (mc^2/\hbar). That would be consistent with quantum equilibrium, but it would be extra ontology rather than something forced by the Dirac equation.

---

# 4. Why the established model is not yet universally luminal

For several particles, decompose the wavefunction into chiral sectors,

[
\Psi=\sum_c\Psi_c,
\qquad
c=(c_1,\ldots,c_N),
\qquad
c_k\in{R,L}.
]

A natural branch density and velocity are

[
\rho_c=\Psi_c^\dagger\Psi_c,
]

[
\mathbf u_{k,c}
===============

\frac{\Psi_c^\dagger\boldsymbol\alpha_k\Psi_c}
{\Psi_c^\dagger\Psi_c}.
]

Mass terms generate jumps (c\rightarrow \pi_kc), where (\pi_k) reverses the (k)-th chirality.

But even after all the chiralities are specified,

[
|\mathbf u_{k,c}|
]

need not equal one. Entanglement with the remaining spin indices makes the effective two-component state of particle (k) mixed. Its current can therefore be timelike rather than null.

This is a known limitation of the published many-particle zig-zag model: one-particle motion is always luminal, whereas many-particle motion is generally only causal and may be subluminal.

That is the exact point where a stronger theory needs another hidden variable.

---

# 5. Surviving null-lift statement

The earlier Euclidean Poisson-kernel lift on an unscaled unit sphere has been removed from this cleaned note. It was a useful kinematic unravelling, but it was not the right Lorentz-covariant primitive and it did not by itself select a physical dynamics.

The safe statement retained here is narrower:

[
\boxed{
\text{A causal current can be represented, with extra hidden data, by null microscopic directions.}
}
]

For a covariant version, the primitive direction variable should be a scaled future null vector or null spinor, not merely an unweighted point of an observer's celestial sphere. Given a future timelike current

[
j^\mu=\varrho U^\mu,
\qquad
U^2=1,
]

the corrected fiber is

[
\mathcal N_U=\{k:k^2=0,\;k\text{ future},\;U\cdot k=1\}.
]

The little-group-invariant measure on this fiber has mean (U). Probabilities on an observer hypersurface must then be flux weighted by (n\cdot k)/(n\cdot U). This is the version developed in the revised sections below.

The finite formalization should therefore start from finite null resolutions and flux weights, then add equivariant angular or graph dynamics only under explicit selection principles. In particular, the static null decomposition alone is an interpretation or representation theorem; it becomes a dynamics only after choosing a direction law, symmetric traffic, and synchronization or foliation rule.

---

# 6. Higgs and Yukawa interactions as chirality-changing jumps

Let (a,b) label chirality, flavor, and any other internal sectors. Suppose the internal Hamiltonian contains off-diagonal blocks

[
H_{\rm int}
===========

\sum_{a,b} H_{ba},
]

with

[
H_{ba}^\dagger=H_{ab}.
]

For branch wavefunctions (\Psi_a), define the antisymmetric quantum probability current

[
\mathcal J_{b\leftarrow a}(q)
=============================

\frac{2}{\hbar}
\operatorname{Im}
\left[
\Psi_b^\dagger(q)
H_{ba}(q)
\Psi_a(q)
\right].
]

Then

[
\mathcal J_{b\leftarrow a}
==========================

-\mathcal J_{a\leftarrow b}.
]

The minimal Bell rate is

[
\sigma(a\rightarrow b\mid q)
============================

\frac{
[\mathcal J_{b\leftarrow a}(q)]^+
}{
\rho_a(q)
}.
]

For a Dirac mass,

[
H_m
===

\begin{pmatrix}
0&M^\dagger\
M&0
\end{pmatrix},
]

where (M=m) for a single species.

For Standard-Model-like Yukawa couplings,

[
M(x)=Y,H(x)
]

or the appropriate conjugated Higgs multiplet. After symmetry breaking,

[
M\longrightarrow\frac{Yv}{\sqrt2}.
]

The Bohmian reading is then:

[
\text{Yukawa matrix element}
\quad\longrightarrow\quad
\text{quantum probability current between chiral sectors}
]

and

[
\text{chiral probability current}
\quad\longrightarrow\quad
\text{actual stochastic chirality-changing events}.
]

This is more exact than saying that every mass is simply a classical turning frequency. The mass/Yukawa operator defines the off-diagonal transfer current; the actual number of jumps depends additionally on the chosen minimal or nonminimal unravelling. The connection between Higgs-generated mass and zig-zag motion motivated the original fermionic pilot-wave proposals. ([arXiv][2])

For flavor mixing, (a) and (b) can include generation indices. A single jump may then change both chirality and flavor. The CKM or PMNS matrix would enter the corresponding Hamiltonian block.

For a Majorana mass, the off-diagonal block connects a Weyl sector to its charge-conjugate sector. The beable jump would consequently change the particle/antiparticle or fermion-number bookkeeping rather than merely an (L/R) label.

---

# 7. Particle creation and annihilation

The natural configuration space is a disjoint union,

[
\mathcal Q
==========

\bigsqcup_{N=0}^{\infty}
\mathcal Q^{(N)}.
]

The wavefunction belongs to Fock space, and the actual configuration has a variable number of positions.

Let (P(dq)) be the position POVM or PVM. The quantum equilibrium measure is

[
\rho^\Psi(dq)
=============

\langle\Psi|P(dq)|\Psi\rangle.
]

For an interaction Hamiltonian (H_I), Bell's minimal jump rate is

[
\sigma^\Psi(dq'\mid q)
======================

\frac{
\left[
\frac{2}{\hbar}
\operatorname{Im}
\langle\Psi|
P(dq')H_I P(dq)
|\Psi\rangle
\right]^+
}{
\langle\Psi|P(dq)|\Psi\rangle
}.
]

This gives literal creation and annihilation events:

* A worldline begins at a creation vertex.
* A worldline ends at an annihilation vertex.
* Between vertices, the null lift makes its trajectory lightlike.
* The configuration jump itself should not be interpreted as a particle travelling instantaneously from (q) to (q').

Bell-type QFTs were designed precisely so that creation and annihilation appear as objective configuration changes while the (|\Psi|^2) measure remains equivariant.

For a genuinely null-edge theory, one should impose a locality condition on the interaction Hamiltonian: newly created worldlines should originate at the same spacetime event as the incoming strands, or within an explicitly stated ultraviolet regulator. Otherwise a smeared creation operator may introduce nonlocal worldline endpoints.

---

# 8. The relativistic foliation

For one particle, the chiral null currents are local spacetime objects, and the guidance law can be expressed without a preferred simultaneity convention.

For several entangled particles, the guidance law depends on the simultaneous configuration of all particles. A clean Bohmian formulation therefore uses a foliation

[
\mathcal F={\Sigma_s}
]

of spacetime by spacelike hypersurfaces.

For a multi-time Dirac wavefunction,

[
\Psi(x_1,\ldots,x_N),
]

define

[
J^{\mu_1\cdots\mu_N}
====================

\overline\Psi
\gamma_1^{\mu_1}\cdots\gamma_N^{\mu_N}
\Psi.
]

Let (n^\mu(x)) be the future unit normal to the foliation. The equilibrium density on (\Sigma^N) is

[
\rho_\Sigma
===========

J^{\mu_1\cdots\mu_N}
n_{\mu_1}(x_1)\cdots n_{\mu_N}(x_N).
]

The effective current for particle (k) is

[
j_{k,\Sigma}^{\mu_k}
====================

J^{\mu_1\cdots\mu_N}
\prod_{r\neq k}n_{\mu_r}(x_r).
]

It obeys

[
n_{\mu_k}j_{k,\Sigma}^{\mu_k}
=============================

\rho_\Sigma.
]

Decompose it as

[
j_{k,\Sigma}^\mu
================

\rho_\Sigma
\left(
n^\mu+u_{k,\Sigma}^\mu
\right),
]

where

[
n_\mu u_{k,\Sigma}^\mu=0,
\qquad
|u_{k,\Sigma}|\leq1.
]

A foliation-adapted null lift replaces this causal tangent by

[
\ell_k^\mu=n^\mu+\omega_k^\mu,
]

with

[
n_\mu\omega_k^\mu=0,
\qquad
\omega_k^\mu\omega_{k\mu}=-1.
]

Therefore

[
\ell_k^\mu\ell_{k\mu}=0.
]

The corrected covariant version should instead be phrased on the scaled null fiber (\mathcal N_U) and then flux weighted on (\Sigma), as described in the revised null-fiber sections below.

Hypersurface Bohm–Dirac models provide the established base for this construction. They preserve an equivariant density on the leaves but use a foliation to define the simultaneous configuration.

There are two main choices:

### Fixed foliation

A preferred foliation is an additional structure of the theory. It may be empirically undetectable in quantum equilibrium, but it is fundamentally present.

### Wavefunction-generated foliation

One can try to derive (n^\mu) covariantly from the universal state—for example, from a timelike eigenvector of an expectation-value stress tensor or another covariantly defined state-dependent tensor.

Under a Lorentz transformation, the state, foliation, and trajectories all transform together. This can make the law covariant, although whether that counts as fully satisfactory “serious” Lorentz invariance remains conceptually disputed. ([arXiv][3])

The important point is:

[
\boxed{
\text{Null particle motion does not remove Bohmian nonlocality.}
}
]

A remote change in the entangled conditional state may immediately change the distribution or direction of another strand relative to the chosen foliation. Matter still travels on null paths, but the pilot law is nonlocal.

That is unavoidable for any hidden-variable theory reproducing Bell correlations.

---

# 9. A fully explicit lattice version

Your original lattice intuition can be implemented particularly cleanly in (1+1) dimensions.

Let

[
a=c\tau,
]

where (a) is the spatial spacing and (\tau) the time step.

At each site, the wavefunction has two components,

[
\psi_n(x)=
\begin{pmatrix}
R_n(x)\
L_n(x)
\end{pmatrix}.
]

Apply a local mass coin

[
C_\theta
========

# e^{-i\theta\sigma_x}

\begin{pmatrix}
\cos\theta&-i\sin\theta\
-i\sin\theta&\cos\theta
\end{pmatrix},
]

where

[
\theta=\frac{mc^2\tau}{\hbar}.
]

Thus

[
\widetilde R
============

\cos\theta,R-i\sin\theta,L,
]

[
\widetilde L
============

-i\sin\theta,R+\cos\theta,L.
]

Then shift conditionally:

[
R_{n+1}(x+a)=\widetilde R_n(x),
]

[
L_{n+1}(x-a)=\widetilde L_n(x).
]

Every (R) strand moves one site right. Every (L) strand moves one site left.

The actual beable is

[
(X_n,C_n),
\qquad
C_n\in{R,L}.
]

## 9.1 Exact equivariant coin update

At a fixed site, let

[
p_R=|R|^2,
\qquad
p_L=|L|^2,
]

and

[
p'_R=|\widetilde R|^2,
\qquad
p'_L=|\widetilde L|^2.
]

Unitarity gives

[
p_R+p_L=p'_R+p'_L.
]

Define

[
\Delta=p'_R-p_R=-(p'_L-p_L).
]

If (\Delta\geq0), transfer only from (L) to (R):

[
P(R\mid L)=\frac{\Delta}{p_L},
]

[
P(L\mid L)=1-\frac{\Delta}{p_L},
]

[
P(R\mid R)=1.
]

If (\Delta<0), transfer only from (R) to (L):

[
P(L\mid R)=\frac{-\Delta}{p_R},
]

[
P(R\mid R)=1-\frac{-\Delta}{p_R},
]

[
P(L\mid L)=1.
]

After this coin-label update, shift the actual position:

[
X_{n+1}
=======

\begin{cases}
X_n+a,&C_{n+1}=R,[4pt]
X_n-a,&C_{n+1}=L.
\end{cases}
]

If

[
P(X_n=x,C_n=c)=|\psi_{n,c}(x)|^2,
]

then after the coin update,

[
P(X_n=x,C_{n+1}=c)=|\widetilde\psi_{n,c}(x)|^2,
]

and after shifting,

[
P(X_{n+1}=x,C_{n+1}=c)=|\psi_{n+1,c}(x)|^2.
]

So equivariance is exact at every tick.

And every completed spacetime step obeys

[
\frac{|X_{n+1}-X_n|}{\tau}
==========================

# \frac{a}{\tau}

c.
]

## 9.2 Continuum limit of the beable law

For small (\theta),

[
\Delta
======

2\theta\operatorname{Im}(R^*L)
+O(\theta^2).
]

Therefore

[
\frac{P(L\rightarrow R)}{\tau}
\longrightarrow
\frac{
\left[
\frac{2mc^2}{\hbar}
\operatorname{Im}(R^*L)
\right]^+
}{
|L|^2
},
]

and similarly for (R\rightarrow L).

This is precisely the continuum minimal zig-zag rate.

Thus the lattice model is not merely suggestive. It supplies an exact discrete Bohmian process whose continuum limit is the one-particle chiral zig-zag theory.

Discrete-time quantum walks and quantum cellular automata are known to possess Dirac continuum limits, including higher-dimensional constructions that couple Weyl sectors through a local mass operator. ([arXiv][4])

---

# 10. General null-edge causal graph version

Replace the regular lattice by a layered causal graph.

Each directed edge

[
e:v\rightarrow w
]

is declared null. At a vertex, the wave amplitudes on incoming edges are mixed by a local unitary or isometry,

[
\widetilde\psi_{e_{\rm out}}
============================

\sum_{e_{\rm in}}
C_v(e_{\rm out},e_{\rm in})
\psi_{e_{\rm in}}.
]

The actual history contains one actual outgoing edge for each continuing strand.

At a finite vertex, construct a nonnegative transport matrix

[
\Gamma_v(e_{\rm out},e_{\rm in})
]

whose incoming and outgoing marginals are the Born weights:

[
\sum_{e_{\rm out}}\Gamma_v(e_{\rm out},e_{\rm in})
==================================================

|\psi_{e_{\rm in}}|^2,
]

[
\sum_{e_{\rm in}}\Gamma_v(e_{\rm out},e_{\rm in})
=================================================

|\widetilde\psi_{e_{\rm out}}|^2.
]

Then the actual transition probability is

[
P(e_{\rm out}\mid e_{\rm in})
=============================

\frac{
\Gamma_v(e_{\rm out},e_{\rm in})
}{
|\psi_{e_{\rm in}}|^2
}.
]

Every actual strand advances along exactly one null edge. Different choices of (\Gamma_v) are different Bohmian unravellings of the same quantum amplitude evolution.

A minimal transport choice moves only the amount of probability required to turn the incoming marginal into the outgoing one. A maximum-entropy choice would spread transitions more broadly.

For an entangled many-body state, (\Gamma_v) generally depends on the complete actual configuration, not merely on local amplitudes. The graph history is locally null but nonlocally guided.

This is the most direct graph realization of your thesis:

[
\boxed{
\text{The actual history is one labeled null-edge subgraph selected by the pilot state.}
}
]

Particles are persistent patterns in this history rather than fundamental objects separate from the edges.

---

# 11. Gauge fields and bosons

This is where the theory becomes substantially less complete.

## Fermions in external gauge fields

For a classical background (A_\mu), replace derivatives by covariant derivatives. The chiral currents remain null. Gauge fields alter their directions and phases but do not alter the unit magnitude of the branch velocities.

Gauge covariance of the jump rates follows when the transfer terms are built from gauge-invariant or gauge-covariant bilinears.

## Quantized gauge fields

Three broad primitive-ontology choices are possible.

### Particle ontology

Photons and other gauge quanta are particles with worldlines. Massless bosons follow null strands directly. Creation and annihilation use Bell rates.

This best preserves the literal null-strand picture, but gauge-invariant localization of photons and gluons is mathematically subtle.

### Field ontology

The electromagnetic or gauge field configuration is a beable guided by a wavefunctional.

This is technically closer to several existing Bohmian QFT models, but a field configuration does not consist simply of objects “moving at (c).” The original slogan would have to be restricted to matter trajectories or causal propagation.

### Event-and-edge ontology

Only spacetime events, null links, and conserved labels are beables. Bosonic and fermionic particles are emergent classifications of edge patterns.

This is the most faithful to the null-edge hypothesis, but it is the furthest from an already completed continuum QFT.

The third option is conceptually the cleanest for your program.

---

# 12. Proper time

An actual null segment satisfies

[
d\tau_{\rm micro}=0.
]

Therefore ordinary massive proper time cannot be obtained by adding microscopic edge proper times:

[
\sum_e d\tau_e=0.
]

Effective proper time must instead belong to the coarse-grained timelike history.

For a narrow wavepacket,

[
\mathbf v_{\rm eff}
===================

\frac{\mathbf p c^2}{E},
]

and

[
\frac{d\tau_{\rm eff}}{dt}
==========================

\sqrt{
1-\frac{|\mathbf v_{\rm eff}|^2}{c^2}
}
=

\frac{mc^2}{E}.
]

In the null-strand theory, this quantity can be interpreted as a measure of directional nonpurity:

[
\frac{d\tau_{\rm eff}}{dt}
==========================

\sqrt{1-|\mathbb E\boldsymbol\omega|^2}.
]

But an actual microscopic clock cannot use path proper time. It must use something such as

* wavefunction phase accumulation;
* internal chiral phase;
* a periodic internal label process;
* a Higgs/Yukawa phase;
* a coarse-grained event count calibrated by the quantum dynamics.

A phase or internal holonomy may contribute to an eventual clock model. For a positive-energy rest state, the Compton phase evolves as

[
e^{-imc^2t/\hbar}.
]

But a passive phase beable alone is not yet an operational clock theorem. A raw number of chirality jumps is also not a universal clock in the minimal model, because some massive stationary states can have zero minimal jump rate.

---

# 13. Measurement and effective collapse

A measurement apparatus is itself made from actual configurations and null strands.

Suppose the universal state develops macroscopically disjoint branches,

[
\Psi
====

\Psi_1+\Psi_2,
]

with supports in disjoint regions of apparatus configuration space.

The actual configuration lies in one support. The empty branch no longer affects the effective conditional state of the occupied branch. This gives effective collapse without adding a measurement postulate.

The hidden direction and chirality variables need not be directly observable. Position records in the apparatus have the usual Born statistics because

[
\int d\Omega\sum_A\widetilde\rho(Q,A,\Omega)
============================================

\langle\Psi|P(dQ)|\Psi\rangle.
]

Thus the additional null-direction ontology changes the microscopic history while preserving quantum-equilibrium measurement statistics.

---

# 14. What the theory predicts

In exact quantum equilibrium and with unchanged wave evolution, NSBB is an interpretation or unravelling of ordinary quantum theory. It does not generically predict different detector probabilities.

Empirical differences require at least one additional hypothesis:

[
\widetilde\rho\neq\widetilde\rho_{\rm eq},
]

a finite graph spacing,

[
a>0,
]

modified jump traffic,

[
S\neq0
]

combined with direct access to trajectory observables, or modified pilot-state dynamics.

The most plausible observable deviations would come from:

* ultraviolet lattice dispersion;
* Lorentz-violating anisotropies;
* nonequilibrium hidden-direction distributions;
* excess momentum diffusion from stochastic direction changes;
* departures from standard Yukawa or Bell jump currents.

A mere change in primitive ontology, while maintaining equivariance, is empirically silent.

---

# 15. Major unresolved problems

## 15.1 Selection problem

The target null-direction measure is not uniquely forced by equivariance. A deeper theory should derive it from the spinor, twistor, graph, or first-order operator structure rather than choosing it merely because it reproduces the same first moment.

## 15.2 Rigorous continuum existence

The continuum angular rates can diverge at wavefunction nodes or where the equilibrium density becomes small. One needs existence and nonexplosion theorems.

The finite lattice model avoids most of these difficulties.

## 15.3 Lorentz structure

The many-body theory needs either a preferred foliation or another synchronization structure. A state-generated foliation is possible, but its uniqueness and behavior in superpositions are unresolved.

## 15.4 Interacting relativistic dynamics

Arbitrary instantaneous many-particle potentials are generally incompatible with consistent multi-time Dirac evolution. A serious interacting theory should use local quantum-field interactions, creation and annihilation, boundary conditions, or a Tomonaga–Schwinger formulation rather than inserting a relativistic analogue of a Newtonian potential. ([arXiv][5])

## 15.5 Bosonic localization

A fully satisfactory particle ontology for gauge bosons is not currently as clean as the fermionic position ontology.

## 15.6 Renormalization

Bell-type formulas are straightforward with an ultraviolet cutoff. Obtaining a mathematically controlled renormalized Standard Model remains a much larger problem.

## 15.7 Microscopic proper time

The theory needs a precise account of clocks and aging that does not secretly treat the null strand as possessing ordinary timelike proper time.

---

# 16. My assessment

The cleaned construction supports a conditional conclusion:

> At the one-particle and finite-regulated levels, a Bohmian model can have primitive null strands while reproducing the relevant Born statistics. In the many-particle and QFT settings, the same idea remains a disciplined research program whose physical status depends on selection, synchronization, and operator-support principles.

The key addition is a hidden null-direction or null-spinor variable. A timelike Bohmian current is then not the motion of a slower fundamental object; it is the marginal current obtained after the actual null direction has been ignored.

My confidence is approximately:

| Proposition                                                                                                     | Confidence |
| --------------------------------------------------------------------------------------------------------------- | ---------: |
| The one-particle chiral zig-zag process is an exact equivariant Bohmian model with speed (c)                    |   **>99%** |
| The explicit (1+1) lattice beable process above is exactly equivariant and moves one site per tick              |   **>99%** |
| A finite-dimensional null-strand model can be made mathematically complete                                      | **90-98%** |
| The continuum angular process can be given satisfactory global existence theorems                               | **60-80%** |
| The hidden-direction measure is physically selected rather than merely convenient                               | **15-30%** |
| A full interacting Standard-Model Bohmian theory can retain literal null trajectories for every particle sector | **25-45%** |
| It can do so without a preferred or state-generated foliation                                                   |  **5-15%** |
| Existing evidence favors this ontology over empirically equivalent Bohmian alternatives                         |    **<5%** |

The most defensible formulation is therefore:

[
\boxed{
\begin{gathered}
\text{The primitive material history consists of null strands and interaction vertices.}\
\text{The pilot state nonlocally guides their directions and labels.}\
\text{Massive subluminal motion is the reduced drift of the null-strand process.}
\end{gathered}
}
]

At the regulated one-particle and finite-graph levels, that is already a genuine theory. At the level of a Lorentz-covariant interacting continuum QFT, it is a well-defined research program rather than a finished fundamental model.

[1]: https://arxiv.org/abs/1201.4169?utm_source=chatgpt.com "On the zig-zag pilot-wave approach for fermions"
[2]: https://arxiv.org/abs/1107.4909?utm_source=chatgpt.com "The zig-zag road to reality"
[3]: https://arxiv.org/pdf/1307.1714 "arXiv:1307.1714v2  [quant-ph]  24 Dec 2013"
[4]: https://arxiv.org/abs/1307.3524?utm_source=chatgpt.com "[1307.3524] The Dirac equation as a quantum walk"
[5]: https://arxiv.org/abs/1603.02538?utm_source=chatgpt.com "Consistency of multi-time Dirac equations with general interaction potentials"


# Verdict

Yes. Claude’s main criticism is useful and should materially change the Bohmian branch of the program. The central point—that the previous construction was a valid **unravelling of an existing quantum current**, rather than yet a new physical dynamics—is exactly right. The attached proposed repairs are more mixed: the weighted least-action idea is strong, the regulator idea is only partly satisfactory, the Lorentz/barycenter diagnosis contains an important insight but reaches the wrong conclusion, and the phase beable is not enough by itself.

The broader program’s existing insistence on deriving the ontology from a first-order operator, rather than accumulating further quadratic identities, remains the right strategic principle.

My assessment:

| Feedback item                                        | Judgment                                          |
| ---------------------------------------------------- | ------------------------------------------------- |
| “This is currently an unravelling, not a new theory” | **Correct and important**                         |
| “The microscopic dynamics is underdetermined”        | **Correct**                                       |
| “The many-particle theory pays a foliation cost”     | **Correct**                                       |
| “A passive phase beable fixes proper time”           | **Not established**                               |
| Weighted least-action angular drift                  | **Mathematically sound, conditionally canonical** |
| Radius-(r) regulator                                 | **Not acceptable as an exact solution**           |
| Hyperbolic/conformal kernel is the right direction   | **Yes**                                           |
| Kernel choice and foliation are the same obstruction | **No; they are distinct**                         |
| Node singularities are the main obstruction          | **One obstruction, but not the deepest one**      |

The deepest obstruction is probably **entanglement and synchronization**, not nodes.

# 1. What Claude got especially right

The published zig-zag theories already show the basic situation clearly: one Dirac particle can be given an exactly luminal zig-zag ontology, while the straightforward many-particle extension generally becomes subluminal because entanglement makes the relevant reduced current timelike. ([arXiv][1])

Your previous null lift repaired that by adding a hidden direction variable. But it did so in a way that could be applied to essentially any causal Bohmian current. Consequently, its existence alone cannot explain mass or distinguish the theory empirically.

That does not make it worthless. It means its proper status is:

> A representation theorem and primitive-ontology construction whose physical significance depends on an additional selection law and, ultimately, on the underlying wave operator.

Claude is also right that equivariance leaves several independent freedoms:

[
\begin{aligned}
&\text{choice of direction distribution},\
&\text{continuous turning versus jumps},\
&\text{symmetric jump traffic},\
&\text{coupling of direction to chirality},\
&\text{choice of foliation or synchronization rule}.
\end{aligned}
]

Those freedoms should be reduced by explicit principles rather than hidden.

# 2. The weighted least-action proposal is a real improvement

Suppose an extended density (f(q,\omega,t)) is prescribed, with (\omega) on a sphere or product of spheres, and null streaming creates the residual

[
G
=

\partial_t f
+
\operatorname{div}_q(f,\omega).
]

To preserve (f), an angular drift (b) must satisfy

[
\operatorname{div}_{\omega}(f b)=-G.
]

Among all such drifts, minimize

[
\mathcal E[b]
=============

\frac12\int f|b|^2,d\omega.
]

Introducing a multiplier (\psi) gives

[
\boxed{
b=\nabla_\omega\psi,
\qquad
\operatorname{div}*\omega
\left(f\nabla*\omega\psi\right)
=-G.
}
]

This is indeed the correct weighted Laplace–Beltrami problem. When (f) is smooth and bounded away from zero on the compact angular fiber, it has a unique zero-mean solution for (\psi), up to an additive constant, provided

[
\int G,d\omega=0.
]

It is better than the earlier prescription

[
b=-\frac{\nabla\Phi}{f},
\qquad
\Delta\Phi=G,
]

because it minimizes the kinetic energy of the velocity rather than the (L^2)-norm of the probability flux.

Two qualifications matter.

First, it selects a unique law only **among continuous deterministic angular flows**, after the fiber metric and target density have already been chosen. It does not prove that a flow is preferable to a jump process.

Second, it does not magically remove singularities. If (f) approaches zero, the weighted operator becomes degenerate even though no explicit (1/f) appears.

So I would adopt this as the canonical continuous law, but phrase it as:

> Given a target null-direction measure, a fiber metric, and the postulate of continuous turning, choose the unique minimum-kinetic-energy equivariant drift.

That is a defensible selection principle.

# 3. The proposed radius regulator cannot be exact

There is a simple obstruction.

Suppose a probability density on (S^2) has a uniform positive floor,

[
\pi(\omega)\geq \frac{\varepsilon}{4\pi}.
]

Then it can be written

[
\pi
===

\frac{\varepsilon}{4\pi}
+
(1-\varepsilon)q
]

for another probability density (q). Therefore

[
\left|
\int_{S^2}\omega,\pi(\omega),d\Omega
\right|
\leq 1-\varepsilon.
]

Thus a uniformly nondegenerate angular distribution cannot exactly represent currents with

[
|\mathbf u|>1-\varepsilon.
]

In particular, no regulator can simultaneously provide:

[
\text{uniform ellipticity},\qquad
\mathbb E[\omega]=\mathbf u,\qquad
\text{all }|\mathbf u|<1.
]

The massless limit necessarily becomes singular in any representation whose hidden variable is only a unit spatial direction. That is not a defect of the particular Poisson kernel; it follows from strict convexity of the unit ball.

The better solution is not to truncate the ball. It is to use a covariant null-vector fiber in which an arbitrarily boosted massive current remains regular. Only a genuinely null current lies on the boundary.

# 4. A better Lorentz-covariant null lift

This is the most important development.

Claude correctly noticed that the Euclidean Poisson kernel is not the natural Lorentz-equivariant object. But the proposed conclusion—that one must choose between Lorentz covariance and reproducing the ordinary position current—is incorrect.

The apparent conflict results from discarding the **scale of the null vector** and retaining only its projective direction.

Work in units (c=1) with signature (+---).

Let (j^\mu) be a future timelike current,

[
\nabla_\mu j^\mu=0,
\qquad
j^\mu j_\mu>0.
]

Define

[
\varrho=\sqrt{j^\mu j_\mu},
\qquad
U^\mu=\frac{j^\mu}{\varrho},
\qquad
U^2=1.
]

At every spacetime point define the normalized null fiber

[
\mathcal N_U
============

\left{
k^\mu:
k^2=0,\quad
k\text{ future-directed},\quad
U\cdot k=1
\right}.
]

Every element can be written uniquely as

[
k^\mu=U^\mu+\xi^\mu,
]

where

[
U\cdot\xi=0,
\qquad
\xi^2=-1.
]

Thus (\mathcal N_U) is the unit two-sphere in the rest space of (U).

There is a unique normalized measure (d\nu_U) satisfying:

1. invariance under the (SO(3)) little group fixing (U);
2. Lorentz covariance,
   [
   \nu_{\Lambda U}=\Lambda_*\nu_U.
   ]

At rest, it is simply the uniform measure on (S^2). Its first moment is

[
\int_{\mathcal N_U} k^\mu,d\nu_U(k)
===================================

U^\mu,
]

because the average of (\xi) vanishes. Consequently,

[
\boxed{
j^\mu
=====

\varrho
\int_{\mathcal N_U}
k^\mu,d\nu_U(k).
}
]

This is a Lorentz-covariant decomposition of any timelike current into null currents.

It is also canonical under the stated assumptions. At (U=(1,\mathbf0)), rotational invariance forces the uniform measure. Lorentz covariance then determines the measure for every other (U).

## Spinor form

This construction lives naturally in your (H_2(\mathbb C)) and celestial-(\mathbb{CP}^1) language.

Represent a future four-vector by a positive Hermitian matrix. Let

[
U=AA^\dagger,
\qquad
A\in SL(2,\mathbb C),
\qquad
\det U=1.
]

At rest, define the null rank-one matrix

[
K_0(\omega)
===========

I+\omega\cdot\sigma,
\qquad
|\omega|=1.
]

Then

[
\det K_0(\omega)=0,
\qquad
\int_{S^2}K_0(\omega)\frac{d\Omega}{4\pi}=I.
]

Define

[
K_U(\omega)
===========

A K_0(\omega)A^\dagger.
]

It follows immediately that

[
\int K_U(\omega)\frac{d\Omega}{4\pi}=U.
]

The ambiguity (A\mapsto AR), (R\in SU(2)), does not matter because the rest-frame measure is (SU(2))-invariant.

So the kernel is not an arbitrary distribution placed on the celestial sphere. It is the pushforward of the Fubini–Study/Haar measure selected by the timelike Hermitian form (U).

That is the clean twistor/idempotent derivation Claude was looking for.

# 5. Why this reproduces the ordinary velocity without breaking covariance

Let (n^\mu) be the four-velocity of an observer, or equivalently the normal of a spacelike hypersurface.

Write each null vector as

[
k^\mu
=====

(n\cdot k)
\left(n^\mu+\omega^\mu\right),
]

where

[
n\cdot\omega=0,
\qquad
\omega^2=-1.
]

The probability distribution of strands **crossing that hypersurface** is not (d\nu_U) by itself. It is flux weighted:

[
\boxed{
d\pi_{U,n}(k)
=============

\frac{n\cdot k}{n\cdot U},d\nu_U(k).
}
]

Its normalization follows from

[
\int n\cdot k,d\nu_U=n\cdot U.
]

Its mean direction is

[
\begin{aligned}
\int\omega^\mu,d\pi_{U,n}
&=
\frac{
\int[k^\mu-(n\cdot k)n^\mu],d\nu_U
}{
n\cdot U
}
\
&=
\frac{U^\mu}{n\cdot U}-n^\mu.
\end{aligned}
]

The right-hand side is precisely the ordinary three-velocity of (U) in the (n)-frame.

Therefore:

[
\boxed{
\text{every realized tangent is null, while its hypersurface-flux mean is the usual subluminal velocity.}
}
]

No conflict between covariance and current matching remains.

## Explicit laboratory-frame formulas

Let

[
n^\mu=(1,\mathbf0),
\qquad
U^\mu=\gamma(1,\boldsymbol\beta).
]

A normalized null vector is

[
k^\mu=\delta(1,\boldsymbol\omega),
\qquad
\delta=
\frac{1}{\gamma(1-\boldsymbol\beta\cdot\boldsymbol\omega)}.
]

The Lorentz-covariant direction-label measure is

[
d\nu_U(\boldsymbol\omega)
=========================

\frac{1-\beta^2}
{4\pi(1-\boldsymbol\beta\cdot\boldsymbol\omega)^2}
,d\Omega.
]

This is the aberrated image of a uniform rest-frame distribution. In Poincaré-ball coordinates it is the hyperbolic Poisson kernel discussed in the feedback.

But the distribution among crossings of the laboratory time slice is

[
\boxed{
d\pi_{\boldsymbol\beta}(\boldsymbol\omega)
==========================================

\frac{(1-\beta^2)^2}
{4\pi(1-\boldsymbol\beta\cdot\boldsymbol\omega)^3}
,d\Omega.
}
]

It satisfies

[
\int d\pi_{\boldsymbol\beta}=1,
\qquad
\int\boldsymbol\omega,d\pi_{\boldsymbol\beta}
=============================================

\boldsymbol\beta.
]

The extra power in the denominator is the missing flux factor.

This shows exactly what was wrong with the proposed “synchronization defect.” Comparing the unweighted Euclidean barycenter to the conformal barycenter compares two different quantities. The physical position current is a hypersurface-crossing flux and must contain (n\cdot k).

Douady–Earle barycenters remain mathematically relevant because they supply conformally natural bulk points from boundary measures, but conformal barycentricity alone does not reproduce a spacetime probability current. ([Project Euclid][2])

## Consequence for Claude’s Lorentz criticism

The one-particle kernel problem and the many-particle foliation problem are **not the same problem**.

The kernel problem can be solved covariantly as above.

The many-particle problem remains because entangled conditional currents require a rule specifying which events on the other worldlines enter the guidance law.

# 6. Directional variance becomes the mass-ratio observable

For the flux distribution,

[
\mathbb E[\boldsymbol\omega]=\boldsymbol\beta,
\qquad
|\boldsymbol\omega|=1.
]

Therefore

[
\mathbb E
\left[
|\boldsymbol\omega-\boldsymbol\beta|^2
\right]
=======

1-\beta^2.
]

For a sharp massive momentum,

[
\beta=\frac{|\mathbf p|}{E},
\qquad
1-\beta^2=\frac{m^2}{E^2}.
]

Hence

[
\boxed{
\frac{m}{E}
===========

\sqrt{
\mathbb E
\left[
|\boldsymbol\omega-\boldsymbol\beta|^2
\right]
}.
}
]

If

[
\rho_{\rm vis}
==============

\frac12
\left(I+\boldsymbol\beta\cdot\sigma\right),
]

then

[
4\det\rho_{\rm vis}=1-\beta^2,
]

and therefore

[
\boxed{
2\sqrt{\det\rho_{\rm vis}}
==========================

# \sqrt{\operatorname{Var}(\boldsymbol\omega)}

\frac{m}{E}.
}
]

This is stronger than the earlier ensemble metaphor. It says that, under the canonical flux measure, the normalized determinant is exactly the RMS spread of actual null directions around the coarse velocity.

It remains frame-relative, as it must.

# 7. A canonical dynamical completion

The covariant measure fixes the one-time distribution, not how an actual direction changes. Claude’s underdetermination criticism therefore remains.

A natural completion has two ingredients:

1. minimum-action drift required for equivariance;
2. an invariant angular mixing process whose scale is set by the mass.

## 7.1 The covariant rest-sphere bundle

Let

[
S_U={\xi:U\cdot\xi=0,\ \xi^2=-1}.
]

When (U(x)) varies, fibers at neighboring points must be compared. A natural no-rotation boost connection is

[
\Omega_\mu{}^\alpha{}_\beta
===========================

## U^\alpha\nabla_\mu U_\beta

(\nabla_\mu U^\alpha)U_\beta.
]

It is antisymmetric and satisfies

[
(\nabla_\mu+\Omega_\mu)U=0.
]

Thus it parallel-transports the rest sphere without introducing an arbitrary local spatial rotation.

Let (\nabla^H) denote the resulting horizontal derivative.

## 7.2 Covariant null diffusion

Let (s) parameterize the strand and set

[
\frac{dX^\mu}{ds}=k^\mu=U^\mu+\xi^\mu.
]

The angular process may be written schematically as the Stratonovich SDE

[
D^H\xi
======

b,ds
+
\sqrt{2D_m}\circ dW_{S_U},
]

where (W_{S_U}) is Brownian motion on the rest sphere.

Because (\xi) remains on (S_U),

[
k^2=(U+\xi)^2=0
]

at every instant.

Let (f(x,\xi)) be the desired extended equilibrium density. Its phase-space equation is

[
\operatorname{Div}*H(fk)
+
\operatorname{div}*{S_U}(fb)
----------------------------

# D_m\Delta_{S_U}f

0.

]

Define

[
G
=

## \operatorname{Div}_H(fk)

D_m\Delta_{S_U}f.
]

Then

[
\operatorname{div}_{S_U}(fb)=-G.
]

The minimum-kinetic-energy solution is

[
\boxed{
b=\nabla_{S_U}\psi,
\qquad
\operatorname{div}*{S_U}
\left(f\nabla*{S_U}\psi\right)
=-G.
}
]

This combines Claude’s best suggestion with a genuinely Lorentz-covariant fiber.

## 7.3 Why include diffusion?

If (D_m=0), a homogeneous plane-wave state has (G=0), so the minimum-action drift is zero. An individual strand then keeps one null direction forever. The ensemble current is correct, but one actual history does not repeatedly coarse-grain to the massive rest trajectory.

Angular mixing repairs that.

For rotational Brownian motion on (S^2),

[
\Delta_{S^2}\omega_i=-2\omega_i.
]

Consequently,

[
\mathbb E[\boldsymbol\omega(s)\mid\boldsymbol\omega(0)]
=======================================================

e^{-2D_ms}\boldsymbol\omega(0),
]

and

[
\mathbb E[
\boldsymbol\omega(s)\cdot\boldsymbol\omega(0)
]
=

e^{-2D_ms}
]

in the homogeneous rest state.

A natural—though genuinely additional—postulate is

[
\boxed{
D_m
===

\alpha,\frac{mc^2}{\hbar}.
}
]

Then the (l=1) directional relaxation gap is

[
\gamma_1
========

2\alpha,\frac{mc^2}{\hbar}.
]

The choice (\alpha=1) gives the standard Compton/zitterbewegung scale and agrees with the natural flip-rate normalization in the (1+1) telegraph model. It is not forced by equivariance, so (\alpha) should remain explicit until it is derived from the first-order operator.

I would call this the **Compton-locking postulate**:

> The same mass operator that mixes chirality fixes the invariant relaxation scale of the null-direction beable.

This does not explain the numerical value of a Yukawa eigenvalue. It turns that eigenvalue into an ontic dynamical scale rather than leaving it merely in the wave equation.

## 7.4 A single realized path becomes timelike after coarse-graining

If the angular process is stationary and ergodic with

[
\mathbb E[k^\mu]=U^\mu,
]

then the ergodic theorem gives

[
\frac{X^\mu(s)-X^\mu(0)}{s}
===========================

\frac1s\int_0^s k^\mu(r),dr
\longrightarrow
U^\mu
]

almost surely.

Thus:

[
\boxed{
\text{each infinitesimal tangent is null, but one actual long history has a timelike coarse tangent.}
}
]

This addresses the strongest version of Claude’s “ensemble only” concern. It requires genuine mixing; it does not follow from the static decomposition alone.

# 8. The (1+1) clock-bearing zig-zag law

For two directions (+) and (-), let the quantum continuity equations imply a net transfer current (J):

[
a-b=J,
]

where

[
a=\text{probability flow }-\rightarrow+,
\qquad
b=\text{probability flow }+\rightarrow-.
]

The minimal Bell process sets

[
a=J^+,
\qquad
b=(-J)^+.
]

This is the standard least-jump choice; Bell-type QFT formalizes such minimal rates and their equivariance for regularized quantum field theories. ([arXiv][3])

It produces no jumps when (J=0), even if the mass is nonzero.

A canonical nonminimal alternative can be derived by choosing a symmetric reference traffic (s_0>0) and minimizing

[
\begin{aligned}
\mathcal C(a,b)
={}&
a\log\frac{a}{s_0}-a+s_0\
&+
b\log\frac{b}{s_0}-b+s_0
\end{aligned}
]

subject to (a-b=J).

The solution satisfies

[
ab=s_0^2
]

and is

[
\boxed{
a
=

\frac{J+\sqrt{J^2+4s_0^2}}2,
\qquad
b
=

\frac{-J+\sqrt{J^2+4s_0^2}}2.
}
]

As (s_0\to0), this reduces to the minimal Bell rates.

A natural clock-bearing choice is

[
s_0
===

\frac{mc^2}{\hbar}
\sqrt{\rho_+\rho_-}.
]

When (J=0) and (\rho_+=\rho_-), both actual flip rates equal

[
\nu=\frac{mc^2}{\hbar}.
]

Then

[
\langle\omega(0)\omega(t)\rangle
================================

e^{-2\nu t}.
]

This is the discrete (S^0) version of the (S^2) Compton-locked diffusion.

It is a respectable candidate law because:

* it preserves the exact quantum continuity equations;
* it is symmetric under (+\leftrightarrow-);
* it reduces to the minimal process when the reference traffic vanishes;
* mass becomes actual trajectory activity even for a stationary plane wave.

But it remains an additional unravelling principle. Standard Dirac theory does not force the symmetric traffic.

# 9. Proper time and the clock problem

Claude is right that simply declaring a phase beable does not automatically solve the clock problem.

There are three distinct issues.

## 9.1 Fundamental metric proper time

Every strand satisfies

[
dX^\mu dX_\mu=0.
]

So the strand’s metric proper time is exactly zero.

That need not be fatal. A light clock is built from null propagation but measures the timelike proper time of the apparatus. Composite clocks can emerge from relations among null constituents.

## 9.2 A covariant strand parameter

The normalized null fiber supplies a scalar parameter (s):

[
U\cdot k=1,
\qquad
dX^\mu=k^\mu ds.
]

Therefore

[
\boxed{
ds=U_\mu,dX^\mu.
}
]

Restoring (c),

[
ds=\frac1cU_\mu dX^\mu
]

when (s) is measured in seconds.

This is not metric proper time along the null strand. It is a pilot-current clock one-form.

For an observer (n),

[
dt=n\cdot dX=(n\cdot k)ds.
]

Using the flux distribution,

[
\begin{aligned}
\mathbb E\left[\frac{ds}{dt}\right]
&=
\int
\frac{1}{n\cdot k}
\frac{n\cdot k}{n\cdot U}
,d\nu_U
\
&=
\frac1{n\cdot U}.
\end{aligned}
]

For (p^\mu=mU^\mu),

[
n\cdot U=\frac{E}{m},
]

so

[
\boxed{
\mathbb E\left[\frac{ds}{dt}\right]
===================================

# \frac{m}{E}

\frac{d\tau_{\rm coarse}}{dt}.
}
]

Thus the ordinary time-dilation factor is recovered from the actual null-strand parameter, not merely inserted as an ensemble identity.

## 9.3 An internal phase

One may now define

[
d\varphi
========

\frac{mc^2}{\hbar},ds.
]

This avoids the circularity of defining (\dot\varphi) directly using an already-assumed (d\tau_{\rm eff}).

However, an absolute (U(1)) phase that never affects anything is gauge-like surplus structure. It is not an operational clock. To be physically meaningful, it must be:

* a relative phase;
* part of an internal rotor;
* coupled to chirality, flavor, decay, or outgoing-edge selection.

For a general mass/Yukawa matrix, the natural object is not a torus of independent phases. It is a non-Abelian internal holonomy,

[
\boxed{
G(s)
====

\mathcal P
\exp\left[
-\frac{i c^2}{\hbar}
\int^s
\mathcal M(X_r),dr
\right],
}
]

where

[
\mathcal M
==========

\begin{pmatrix}
0&M^\dagger\
M&0
\end{pmatrix}
]

acts on the left/right and flavor space.

When the mass matrices at different points do not commute, path ordering is essential. CKM or PMNS mixing cannot generally be represented by several independent circle clocks.

So I would retain the phase-beable proposal only in this stronger form:

> A strand carries an internal frame whose gauge-invariant relative holonomy is driven by the Yukawa/mass operator and may influence its chirality and direction transitions.

My confidence that a passive phase alone solves the issue is below (40%). My confidence that an internal holonomy can be made mathematically consistent is around (70%).

# 10. The fundamental many-particle obstruction is entanglement

There is a precise theorem hiding here.

For a unit vector (\omega), write the pure qubit projector

[
\Pi(\omega)
===========

\frac12
\left(I+\omega\cdot\sigma\right).
]

Suppose an (N)-qubit state admits a positive joint direction measure such that

[
\rho
====

\int_{(S^2)^N}
\Pi(\omega_1)\otimes\cdots\otimes\Pi(\omega_N)
,d\mu(\omega_1,\ldots,\omega_N).
]

Then (\rho) is separable, by definition.

Conversely, every separable state admits such a measure.

Therefore:

[
\boxed{
\text{positive joint product-null representation}
\iff
\text{separable quantum state}.
}
]

An entangled Bell state cannot be represented as an ordinary positive distribution of pre-existing local null spinors whose product moments reproduce the full state.

This does **not** rule out Bohmian null directions. Bohmian directions can be contextual and nonlocally guided by the universal wavefunction.

It does show that:

> The hidden null directions cannot replace the entangled wavefunction with a local classical probability distribution.

That is why the many-particle problem is qualitatively harder than decomposing one timelike vector into null vectors.

It also explains the published result that the simple many-particle chiral zig-zag model is generally not luminal, even though the one-particle model is. ([arXiv][1])

# 11. A definite many-particle null theory with a foliation

The safest complete version retains a foliation (\mathcal F).

On a leaf (\Sigma), decompose the wavefunction into chirality sectors (c). For particle (k), define the conditional (2\times2) positive matrix

[
P_{k,c}^{AA'}(Q)
================

\sum_{\alpha}
\Psi_c^{A\alpha}(Q)
\overline{\Psi_c^{A'\alpha}(Q)},
]

where (\alpha) denotes all remaining spin and internal indices.

If

[
\det P_{k,c}>0,
]

set

[
\mu_{k,c}
=========

\sqrt{\det P_{k,c}},
\qquad
U_{k,c}
=======

\frac{P_{k,c}}{\mu_{k,c}},
\qquad
\det U_{k,c}=1.
]

Then use the canonical Lorentz-covariant null measure (\nu_{U_{k,c}}).

If

[
\det P_{k,c}=0,
]

the matrix is rank one and already determines a single null direction.

This gives a precise refinement principle:

> A pure conditional Weyl state has one actual null direction. A mixed conditional Weyl state is resolved using the unique little-group-invariant null measure determined by its timelike Hermitian matrix.

On the leaf, the extended equilibrium density is

[
\widetilde\rho_{\Sigma,c}
(Q,k_1,\ldots,k_N)
==================

\rho_{\Sigma,c}(Q)
\prod_k
\pi_{U_{k,c},n}(dk_k),
]

where (n) is the leaf normal and (\pi) is the flux-weighted kernel.

Each particle follows

[
\frac{dX_k^\mu}{ds}
===================

k_k^\mu,
\qquad
k_k^2=0.
]

Angular drifts are selected by the weighted least-action equation. Mass/Yukawa chirality changes use Bell currents. At a chirality jump, the outgoing direction can be coupled to the incoming direction using the Wasserstein-optimal coupling between the source and destination angular measures, minimizing the squared turning angle.

This gives a regulated, mathematically definite model.

Its nonlocality appears through

[
U_{k,c}
=======

U_{k,c}
\left(
X_1,\ldots,X_N,\Psi_\Sigma
\right).
]

The foliation remains part of the law.

Hypersurface Bohm–Dirac theories explicitly use such a foliation; one option is to treat it as extra structure, and another is to derive it covariantly from the universal quantum state. ([arXiv][4])

A proposal to regard all foliations as empirically equivalent rather than selecting one also exists, but that is not the same as providing one unique foliation-free microscopic history. ([arXiv][5])

# 12. The right “synchronization defect”

The difference between Euclidean and conformal barycenters is not the best measure of foliation dependence.

A better object lives on the space of hypersurfaces or, in the finite theory, on causal diamonds of update orders.

Suppose (A) and (B) are spacelike-separated local quantum updates. Their quantum operators commute:

[
U_AU_B=U_BU_A.
]

Let (K_A^\Psi) and (K_B^\Psi) be the corresponding hidden-variable transition kernels.

Updating (A) and then (B) produces

[
K_B^{U_A\Psi}K_A^\Psi.
]

Updating (B) and then (A) produces

[
K_A^{U_B\Psi}K_B^\Psi.
]

Define the stochastic diamond defect

[
\boxed{
\Delta_{AB}^\Psi
================

## K_B^{U_A\Psi}K_A^\Psi

K_A^{U_B\Psi}K_B^\Psi.
}
]

Then:

[
\Delta_{AB}^\Psi=0
]

means the hidden history is independent of the order in which that spacelike diamond is crossed.

In the continuum, the analogous curvature is

[
\mathcal F_{xy}
===============

## \frac{\delta\mathcal K_y}{\delta\Sigma(x)}

\frac{\delta\mathcal K_x}{\delta\Sigma(y)}
+
[\mathcal K_x,\mathcal K_y],
]

for spacelike-separated (x,y).

This is a genuine synchronization curvature:

* zero curvature means foliation-independent hidden transport;
* nonzero curvature localizes the foliation dependence;
* its norm can be minimized over all equivariant null kernels.

This is a much stronger research target than comparing two velocity barycenters.

Bell’s theorem does not by itself prove that every conceivable nonlocal synchronization connection must have nonzero curvature. It rules out local hidden-variable explanations. Whether a nonlocal, positive, flat hidden connection exists is a sharper mathematical question.

The first decisive calculation should be a two-qubit Bell state with two commuting local gates.

# 13. From an interpretation to a new theory: derive the beables from the first-order graph operator

The canonical null lift remains empirically equivalent to the base wave theory. The theory becomes physically new only when the wave operator itself is new.

That aligns with the operator criterion already emphasized in your larger program.

Let a finite causal graph have:

* null directed edges;
* internal chirality/flavor fibers;
* gauge transport on edges;
* a first-order operator (\mathcal D_{A,\Phi});
* configurations (q) of occupied edge germs.

Let

[
i\hbar\frac{d\Psi}{dt}
======================

\mathcal D_{A,\Phi}\Psi.
]

For configuration projectors (P_q), define the antisymmetric quantum current

[
J_\Psi(q,q')
============

\frac{2}{\hbar}
\operatorname{Im}
\langle\Psi|
P_q\mathcal D_{A,\Phi}P_{q'}
|\Psi\rangle.
]

The minimal Bell rate is

[
\boxed{
\sigma_\Psi(q\mid q')
=====================

\frac{[J_\Psi(q,q')]^+}
{\langle\Psi|P_{q'}|\Psi\rangle}.
}
]

If the operator has the support property

[
P_q\mathcal D_{A,\Phi}P_{q'}=0
]

unless (q) and (q') differ by:

* traversal of an allowed null edge;
* a local chirality/flavor vertex;
* creation or annihilation at a vertex,

then every actual material continuation is null between vertices.

This is an exact finite theorem:

> First-order operator support on null continuations implies Bell histories supported on null continuations.

Bell-type QFT already provides the general minimal-current construction for particle creation, annihilation, and configuration jumps. ([arXiv][3])

In your theory:

[
\mathcal D_{A,\Phi}
===================

d_A+\delta_A+\Gamma\Phi
]

should supply:

[
\begin{aligned}
d_A+\delta_A
&\longrightarrow
\text{null causal propagation},\
\Phi
&\longrightarrow
\text{Higgs/Yukawa chirality transfer},\
\mathcal D_{A,\Phi}^2
&\longrightarrow
\text{Laplacian + curvature + Yukawa mass}.
\end{aligned}
]

The Bohmian process should be derived from this operator’s current. It should not be constructed independently and then merely compared to the operator afterward.

# 14. A concrete finite (1+1) model and its prediction

Take

[
a=c\tau,
\qquad
\theta=\frac{mc^2\tau}{\hbar}.
]

Let the one-step unitary in momentum space be

[
U(p)
====

e^{-ipa\sigma_z/\hbar}
e^{-i\theta\sigma_x}.
]

The first factor moves each component exactly one site per tick. The second mixes chirality at the vertex.

The quasienergy obeys

[
\boxed{
\cos\left(\frac{E\tau}{\hbar}\right)
====================================

\cos\left(\frac{pc\tau}{\hbar}\right)
\cos\left(\frac{mc^2\tau}{\hbar}\right).
}
]

At small (\tau),

[
E^2
===

## p^2c^2+m^2c^4

\frac{\tau^2}{3\hbar^2}
p^2m^2c^6
+
O(\tau^4).
]

The continuum Dirac dispersion appears at leading order. Finite (\tau) produces a real correction.

This illustrates the dividing line:

* If (\tau\to0) and all equilibrium statistics equal ordinary Dirac theory, the null trajectories are an interpretation.
* If (\tau) is fundamental and finite, the model predicts modified dispersion and becomes experimentally distinguishable.

In (3+1) dimensions, a useful finite pilot is a rest-frame spherical design. For example, four tetrahedral unit vectors (\xi_a) satisfy

[
\sum_{a=1}^4\xi_a=0,
\qquad
\frac14\sum_{a=1}^4
\xi_a^i\xi_a^j
==============

\frac13\delta^{ij}.
]

Then

[
k_a=U+\xi_a
]

are four null directions with

[
\frac14\sum_a k_a=U.
]

This gives a finite-valency null fan reproducing the timelike current and isotropic second moment. It cannot possess exact continuous rotational invariance at one vertex; exact covariance can only be statistical, dynamically averaged, or recovered in a limit.

# 15. Revised core postulates

A sharpened theory would have the following structure.

### Pilot law

A first-order quantum operator governs the wave state:

[
i\hbar,d\Psi
============

\mathcal D_{A,\Phi}\Psi.
]

### Primitive ontology

Matter consists of continuous chains of null spinor-labelled edges,

[
k^{AA'}=\lambda^A\bar\lambda^{A'},
\qquad
k^2=0,
]

joined at local interaction vertices.

### Covariant equilibrium lift

Every positive conditional (2\times2) current matrix is resolved using its unique little-group-invariant null measure, with hypersurface probabilities obtained by flux weighting.

### Direction dynamics

Continuous turning is the minimum-kinetic-energy equivariant flow, supplemented—if the Compton-locking postulate is adopted—by covariant angular diffusion

[
D_m=\alpha mc^2/\hbar.
]

### Internal dynamics

The Higgs/Yukawa matrix governs chirality and flavor holonomy, Bell transfer currents, and possibly the symmetric direction-mixing activity.

### Nonlocal synchronization

For the exact many-particle theory, either:

[
\text{a preferred/state-generated foliation is accepted},
]

or the hidden transfer kernels must satisfy a flat synchronization-connection condition. This cannot be assumed.

### Quantum equilibrium

The joint distribution of positions, labels, and null directions is the equivariant extended density. Marginalizing hidden variables reproduces the ordinary Born distribution.

# 16. Highest-value theorem and simulation targets

I would prioritize these results.

[
\boxed{
\texttt{covariantNullMoment_eq_timelikeCurrent}
}
]

Formalize

[
\int_{\mathcal N_U}k,d\nu_U=U
]

and its (SL(2,\mathbb C))/(\mathbb{CP}^1) form.

[
\boxed{
\texttt{fluxWeightedNullMean_eq_observerVelocity}
}
]

Prove

[
\int\omega,d\pi_{U,n}
=====================

\frac{U}{n\cdot U}-n.
]

[
\boxed{
\texttt{fluxDirectionVariance_eq_massRatioSq}
}
]

Prove

[
\operatorname{Var}(\omega)
==========================

# 4\det\rho_{\rm vis}

\frac{m^2}{E^2}.
]

[
\boxed{
\texttt{uniformAngularFloor_bounds_meanNorm}
}
]

Formalize the regulator obstruction

[
\pi\geq\varepsilon/(4\pi)
\Longrightarrow
|\mathbb E\omega|\leq1-\varepsilon.
]

[
\boxed{
\texttt{weightedAngularDrift_uniqueMinimizer}
}
]

Establish the weighted Poisson minimizer under explicit positivity assumptions.

[
\boxed{
\texttt{productNullMeasure_iff_separable}
}
]

Make the many-particle entanglement obstruction precise.

[
\boxed{
\texttt{spacelikeUpdateDiamondDefect}
}
]

Define

[
\Delta_{AB}
===========

## K_B^{U_A\Psi}K_A^\Psi

K_A^{U_B\Psi}K_B^\Psi
]

and compute it for a Bell pair.

[
\boxed{
\texttt{comptonLockedDirectionCorrelation}
}
]

For the homogeneous regulated process, prove

[
\langle\omega(s)\cdot\omega(0)\rangle
=====================================

e^{-2mc^2s/\hbar}.
]

The Bell-pair synchronization calculation is probably the most informative physics test. The covariant null-moment and flux theorems are the cleanest mathematical publication targets.

# Confidence assessment

| Claim                                                                    | Confidence |
| ------------------------------------------------------------------------ | ---------: |
| Claude’s main feedback is useful and substantially correct               |    **95%** |
| Weighted least-action drift is the right canonical continuous choice     | **85–95%** |
| The radius-(r) regulator is not an exact solution                        |   **>99%** |
| The original Euclidean Poisson kernel should be replaced                 |   **>99%** |
| The covariant null-vector plus flux construction above is correct        |   **>99%** |
| It removes the one-particle Lorentz/kernel conflict                      | **95–99%** |
| Kernel selection and many-particle foliation are the same problem        |   **<15%** |
| Compton-locked angular diffusion is physically preferred                 | **30–45%** |
| A passive phase beable solves the clock problem                          | **20–40%** |
| A non-Abelian internal holonomy is a viable clock/transition structure   | **55–75%** |
| A regulated multi-particle null theory with a foliation can be completed | **80–95%** |
| A unique foliation-free version reproducing interacting QFT exists       | **10–25%** |
| A finite first-order null graph can produce genuine predictions          | **40–65%** |
| The complete construction currently explains observed particle masses    |   **<10%** |

The strongest revised conclusion is:

> A Lorentz-covariant microscopic null ontology is possible at the level of one-particle currents and can be extended, with nonlocal synchronization, to many-particle Bohmian dynamics. The correct primitive variable is a scaled null spinor or null four-vector, not merely an unweighted point on the celestial sphere. Mass can consistently govern the mixing, angular-relaxation, and internal-holonomy scales of those strands. But until those laws are forced by the causal super-Dirac operator—or a finite graph produces measurable deviations—the construction remains a disciplined and increasingly canonical interpretation rather than a new fundamental dynamics.

[1]: https://arxiv.org/abs/1201.4169?utm_source=chatgpt.com "On the zig-zag pilot-wave approach for fermions"
[2]: https://projecteuclid.org/journalArticle/Download?urlId=10.1007%2FBF02392590&utm_source=chatgpt.com "Conformally natural extension of homeomorphisms of the ..."
[3]: https://arxiv.org/abs/quant-ph/0407116?utm_source=chatgpt.com "[quant-ph/0407116] Bell-Type Quantum Field Theories"
[4]: https://arxiv.org/abs/1307.1714?utm_source=chatgpt.com "Can Bohmian mechanics be made relativistic?"
[5]: https://arxiv.org/abs/1509.03463?utm_source=chatgpt.com "Relativistic Bohmian mechanics without a preferred foliation"



# Recommendation

Formalize the theory as three increasingly strong packages, not one enormous theorem:

1. **Exact finite null-strand model:** fully provable now.
2. **Continuum Bohmian realization:** conditional on explicit analytic hypotheses.
3. **Graph-derived physical theory:** open until a concrete first-order operator passes the support and scaling gates.

The supplied inventory reports that much of the finite algebra is already banked: checkerboard dynamics, Plücker mass, twistor matching, diamond holonomy, Dirac-square-root, superconnection, two-sheet, and observer-channel modules. I have not compiled the repository itself, so I am treating that inventory as accurate rather than independently certifying each module.  

## The four proof statuses

| Status          | Meaning                                                          |
| --------------- | ---------------------------------------------------------------- |
| **Banked**      | Reported as trusted or kernel-checked in the current inventory   |
| **Ready**       | Correct finite theorem with no unresolved physics                |
| **Conditional** | Correct theorem shape, but requires explicit analytic hypotheses |
| **Open**        | The correct physical theorem or construction is not yet known    |
| **Guardrail**   | A negative theorem ruling out an attractive but invalid shortcut |

The first realistic endpoint is:

```lean
theorem finiteNullStrand_master :
  EveryPrimitiveStepIsNull M ∧
  BornDistributionIsEquivariant M ∧
  EmpiricalVelocityConvergesToTimelikeCurrent M
```

That theorem can be unconditional for a finite checkerboard or finite-direction model. The analogous continuum and graph-derived master theorems must retain hypotheses in their signatures.

# Dependency-ordered roadmap

## 0. Conventions and a representation firewall

Create one canonical API for:

```lean
Minkowski4
minkowskiInner
IsFutureCausal
IsFutureNull
IsUnitFutureTimelike
WeylSpinor
Hermitian2
pauliMap
chiralDiracSlash
```

The formalization must keep these representations distinct:

| Object                             | Representation              |
| ---------------------------------- | --------------------------- |
| Plücker amplitude (\psi\wedge\chi) | (\Lambda^2S\simeq\mathbb C) |
| Four-momentum (P_{AA'})            | (S\otimes\bar S)            |
| Self-dual curvature                | (\operatorname{Sym}^2S)     |
| Spacetime bivector                 | (\Lambda^2\mathbb C^4)      |

This prevents the program from silently identifying Plücker scalars, curvature spinors, and four-dimensional bivectors.

The supplied inventory already reports trusted checkerboard, Plücker, twistor, and diamond-holonomy anchors, together with draft Dirac and super-Dirac bridges.  

## 1. Covariant null fiber

For a unit future-timelike (U), define

[
\mathcal N_U={k:k^2=0,;k\text{ future},;U\cdot k=1}.
]

The first major finite theorem is the equivalence

[
k\in\mathcal N_U
\quad\longleftrightarrow\quad
k=U+\xi,\qquad
U\cdot\xi=0,\quad \xi^2=-1.
]

Suggested declarations:

```lean
structure NullFiber (U : Minkowski4) where
  k : Minkowski4
  future : IsFutureCausal k
  null : minkowskiSq k = 0
  normalized : minkowskiInner U k = 1

structure RestSphere (U : Minkowski4) where
  ξ : Minkowski4
  orthogonal : minkowskiInner U ξ = 0
  unitSpacelike : minkowskiSq ξ = -1
```

Ready theorems:

```lean
nullFiber_equiv_restSphere
restToNull_isFutureNull
nullToRest_isUnitSpacelike
lorentzMap_nullFiber
```

### Finite exact resolution

Before developing sphere measure theory, use the six octahedral rest directions

[
\pm e_1,\quad\pm e_2,\quad\pm e_3.
]

They satisfy

[
\sum_a\xi_a=0,\qquad
\frac16\sum_a\xi_a^i\xi_a^j=\frac13\delta^{ij}.
]

Consequently,

[
U=\frac16\sum_a(U+\xi_a)
]

is an exact finite decomposition into null vectors.

Ready targets:

```lean
octaDirection_sum_eq_zero
octaDirection_secondMoment_eq_oneThird
octaNull_mean_eq_timelike
lorentzMap_octaNullResolution
```

This gives a complete (3+1)-dimensional finite ontology without integration or stochastic differential geometry.

## 2. Flux weighting and the observer velocity

Define a finite resolution first:

```lean
structure FiniteNullResolution
    (Ω : Type*) [Fintype Ω] (U : Minkowski4) where
  weight : Ω → ℝ
  k : Ω → Minkowski4
  weight_nonneg : ∀ ω, 0 ≤ weight ω
  weight_sum : ∑ ω, weight ω = 1
  futureNull : ∀ ω, IsFutureNull (k ω)
  normalized : ∀ ω, minkowskiInner U (k ω) = 1
  mean_eq : ∑ ω, weight ω • k ω = U
```

For observer (n), define

[
\pi_{U,n}(\omega)
=================

w_\omega\frac{n\cdot k_\omega}{n\cdot U}
]

and

[
d_{n}(k)
========

\frac{k}{n\cdot k}-n.
]

Then prove:

```lean
fluxWeight_nonneg
fluxWeight_sum_eq_one
observerDirection_orthogonal
observerDirection_normSq_eq_one

fluxDirectionMean_eq_relativeVelocity :
  ∑ ω, fluxWeight R n ω • observerDirection n (R.k ω)
    = U / minkowskiInner n U - n
```

This finite theorem contains the essential flux-weighting correction. No explicit Poisson-kernel formula is needed.

The variance theorem is then elementary:

[
\operatorname{Var}_{\pi}(\omega)
================================

# 1-\lVert\beta\rVert^2

\frac1{(n\cdot U)^2}.
]

For (p=mU) and (E=n\cdot p),

[
\operatorname{Var}_{\pi}(\omega)=\frac{m^2}{E^2}.
]

Targets:

```lean
fluxDirectionVariance_eq_invGammaSq
fluxDirectionVariance_eq_massRatioSq
fluxDirectionStdDev_eq_twoSqrtDetNormalizedVisible
```

This should connect directly to the existing observer-channel determinant modules.

### Continuum measure

Only after the finite theorem is stable should you define the normalized measure (\nu_U) on (\mathcal N_U), prove

[
\int k,d\nu_U=U,
]

and derive the laboratory density formulas.

Mathlib already has analytic manifold structure on finite-dimensional spheres, and its probability-kernel framework includes Ionescu–Tulcea trajectory construction. ([Lean Community][1]) The difficult missing work is the weighted Laplace–Beltrami and diffusion layer, not basic measurable trajectories.

## 3. Boundary and regulator guardrails

Formalize the regulator obstruction early.

For a finite isotropic baseline (u) with zero mean, if

[
\pi=\varepsilon u+(1-\varepsilon)q,
]

then

[
\left|\mathbb E_\pi\omega\right|\leq1-\varepsilon.
]

Targets:

```lean
uniformComponent_bounds_meanNorm
uniformAngularFloor_bounds_meanNorm
meanNorm_eq_one_iff_positiveSupport_collinear
```

This establishes that exact near-massless currents cannot be represented by a uniformly nondegenerate angular distribution. The massless boundary must be singular or have collapsed support.

## 4. One-particle chiral zig-zag

Reuse the Weyl/Pauli infrastructure to define the chiral currents.

A technical correction: for a zero spinor, the current is zero, so the unconditional theorem should say **future causal and null**; strict future-directedness requires a nonzero spinor.

```lean
rightCurrent_futureCausal
leftCurrent_futureCausal
rightCurrent_null
leftCurrent_null
rightCurrent_futureNull_of_ne_zero
leftCurrent_futureNull_of_ne_zero
```

Package the continuity equations abstractly:

```lean
structure ChiralTransferData where
  ρR ρL : X → ℝ
  jR jL : X → V
  F : X → ℝ
  continuityR : ...
  continuityL : ...
  transfer_zero_of_rhoR_zero : ...
  transfer_zero_of_rhoL_zero : ...
```

Then define minimal rates with safe zero-density behavior:

```lean
rateLtoR = F⁺ / ρL
rateRtoL = (-F)⁺ / ρR
```

Ready algebra:

```lean
minimalRates_nonneg
minimalRates_netTransfer
minimalRates_masterEquation
```

Conditional Dirac instantiation:

```lean
dirac_chiralContinuity
dirac_massTransfer_eq_two_m_im_inner
```

The PDE theorem should not block the finite stochastic API.

## 5. Exact checkerboard beable process

This should be the first closed theorem package.

Use the existing two-component checkerboard/quantum-walk evolution and add a stochastic transport through the local coin whose source and target marginals are the pre- and post-coin Born weights.

Ready targets:

```lean
coinBornTransport_isStochastic
coinBornTransport_sourceMarginal
coinBornTransport_targetMarginal
actualShift_speed_eq_c
latticeBeable_oneStep_equivariant
latticeBeable_nStep_equivariant
```

The capstone is:

```lean
theorem checkerboardBohmModel_consistent :
  EveryStepHasSpeedC M ∧
  IsUnitaryWaveEvolution M ∧
  IsBornEquivariant M
```

Then separately prove:

```lean
coinTransfer_firstOrderExpansion
quantumWalk_quasienergy_relation
quantumWalk_diracDispersion_secondOrder
```

The expansion is not yet a full continuum-limit theorem.

## 6. Generic finite null lift

For a finite base configuration (z), define conditional direction weights with mean equal to the base causal velocity. Set

[
\widetilde\rho(z,\omega)=\rho(z)\pi_z(\omega).
]

Null streaming generally produces a residual (G(z,\omega)) satisfying

[
\sum_\omega G(z,\omega)=0.
]

The explicit surplus/deficit current can then be formalized:

```lean
residualCurrent_antisymm
residualCurrent_divergence_eq
minimalAngularRates_nonneg
minimalAngularRates_masterEquation
finiteNullLift_equivariant
```

This gives a fully rigorous finite version of the universal null lift.

## 7. Canonical finite least-action dynamics

Before attempting

[
\nabla_\omega\cdot(f\nabla_\omega\psi)=-G
]

on (S^2), prove it on a finite connected direction graph.

Define:

```lean
angularGradient
weightedAngularFlux
angularDivergence
weightedAngularLaplacian
angularKineticEnergy
```

Then prove:

```lean
weightedAngularLaplacian_selfAdjoint
weightedAngularLaplacian_nonneg
weightedAngularLaplacian_kernel_eq_constants
zeroSum_iff_mem_weightedLaplacian_range
weightedPotential_exists_unique_mod_constants
leastActionDrift_unique
leastActionDrift_equivariant
```

Existing weighted-Hodge and Laplacian work in the program may shorten this stage.

This theorem canonicalizes the flow only after three choices have already been made:

* the angular graph or metric;
* continuous flow rather than jumps;
* the target direction distribution.

It does not derive those choices.

## 8. Spectral gap and single-history coarse motion

Claude is right that this is load-bearing for the claim about one realized history. But two statements must be separated:

[
\mathbb E_\pi!\left[\frac{ds}{dt}\right]
=\frac1{n\cdot U}
]

is a one-time flux identity and needs no ergodicity.

By contrast,

[
\frac{X_N-X_0}{N}\longrightarrow U
]

for one realized history does require mixing.

### Exactly solvable finite kernel

Start with

[
P=(1-r)I+r\Pi,
]

where (\Pi) redraws from the target distribution.

Ready targets:

```lean
refreshKernel_invariant
refreshKernel_reversible
refreshKernel_onMeanZero_eq_smul
refreshKernel_spectralGap_eq_r
refreshKernel_correlation_eq_pow
```

Then prove coarse motion first in (L^2) or probability, followed by the pathwise theorem:

```lean
refreshNullTrajectory_meanSqError_bound
refreshNullTrajectory_coarseVelocity_tendstoInProbability
refreshNullTrajectory_coarseVelocity_tendsto_ae
```

For general finite chains, distinguish:

* a positive Poincaré gap;
* an **absolute** spectral gap or laziness/aperiodicity.

An irreducible period-two chain has a positive Poincaré gap but (P^n) need not converge.

### Continuum spectral gap

Do not state an unconditional theorem named

```lean
comptonLockedGenerator_spectralGap
```

for the full model. The correct interface is closer to:

```lean
structure HasSpectralGap (L : Generator Ω) (μ : Measure Ω) (γ : ℝ) : Prop where
  positive : 0 < γ
  contractsMeanZero : ...
```

Then construct it for:

1. homogeneous rest diffusion;
2. uniformly elliptic stationary perturbations;
3. eventually, restricted regions away from spatial nodes.

For a general state-dependent, time-dependent, nonreversible generator, a spectral gap is not automatic.

## 9. Proper time and internal holonomy

The kinematic strand parameter can be formalized now:

[
U\cdot k=1,\qquad dX=k,ds.
]

Targets:

```lean
strandParameter_lorentzScalar
observerTimeDerivative_eq_inner
fluxMean_strandRate_eq_invGamma
```

The pathwise long-run clock theorem depends on Stage 8:

```lean
strandClock_longRunRate_eq_coarseProperTimeRate
```

For internal dynamics, start with finite ordered products:

[
G_N
===

\prod_{j=0}^{N-1}
\exp(-i,\Delta s_j,\mathcal M_j).
]

Ready targets:

```lean
internalHolonomy_concat
internalHolonomy_unitary_of_hermitian
internalHolonomy_endpointGaugeCovariant
commutingMass_internalHolonomy_eq_exp_sum
```

The open physical theorem is:

```lean
internalHolonomy_controls_recordedClockOrTransition
```

Without such a coupling, holonomy is internal structure but not yet an operational clock.

## 10. Entanglement obstruction

Define a positive product-null representation as a finite convex combination

[
\rho=
\sum_\lambda p_\lambda
\bigotimes_k
\Pi(\omega_{k,\lambda}).
]

Ready finite theorem:

```lean
productDirectionRepresentation_iff_separable
```

Immediate guardrail:

```lean
entangledState_has_no_localPositiveProductNullRepresentation
```

This is a real no-go theorem: the local null directions cannot replace the entangled wavefunction with an ordinary positive local distribution.

## 11. Synchronization curvature

Work first on a finite causal poset or two commuting local updates.

Define hidden kernels (K_A^\Psi), (K_B^\Psi) and the signed finite-kernel defect

[
\Delta_{AB}^{\Psi}
==================

## K_B^{U_A\Psi}K_A^\Psi

K_A^{U_B\Psi}K_B^\Psi.
]

Ready definitions and elementary theorems:

```lean
synchronizationDiamondDefect
synchronizationDiamondDefect_eq_zero_iff_orderIndependent
synchronizationDiamondDefect_vanishes_of_kernelCommute
synchronizationDiamondDefect_endpointCovariant
```

Then construct one explicit Bell-pair pilot:

```lean
bellPair_state
bellPair_localUpdateA
bellPair_localUpdateB
bellPair_selectedHiddenKernel
bellPair_synchronizationDefect
```

The result may be zero or nonzero; it must be computed before choosing the theorem name.

Do **not** yet state

```lean
separabilityObstruction_iff_synchCurvatureNonzero
```

as a universal theorem. Curvature depends on the selected hidden connection. The safe research questions are whether flatness implies separability under specified locality and positivity axioms, and whether any positive, flat but explicitly nonlocal connection exists.

## 12. Finite Bell-type QFT

At a finite Fock cutoff, take finite configuration projectors (P_q), self-adjoint (H), and state (\Psi). Define

[
J(q,q')
=======

2,\operatorname{Im}
\langle\Psi,P_qHP_{q'}\Psi\rangle.
]

Ready finite algebra:

```lean
quantumCurrent_antisymm
minimalBellRate_nonneg
minimalBellRate_masterEquation
operatorBlockZero_implies_currentZero
```

The derivative identification is conditional on the Schrödinger equation:

```lean
schrodingerBornDerivative_eq_currentSum
```

Then add finite creation/annihilation and destination-direction sampling:

```lean
creationLift_targetDirectionMarginal
annihilationLift_forgetsDirection
finiteFockNullLift_equivariant
```

Renormalized infinite-dimensional QFT belongs far beyond the first target.

## 13. Operator-derived graph theory

Define a relation of allowed primitive events:

```lean
IsNullContinuation q q'
```

covering:

* propagation along a null edge;
* a local chirality/flavor change;
* local creation or annihilation.

Then define operator support:

```lean
def SupportedOn (D) (R : Q → Q → Prop) : Prop :=
  ∀ q q', ¬ R q q' → P q * D * P q' = 0
```

Ready support-transfer theorems:

```lean
operatorSupport_implies_bellCurrentSupport
operatorSupport_implies_minimalRateSupport
support_Dsq_subset_relationComp
```

The last theorem should say

[
\operatorname{supp}(D^2)\subseteq R\circ R,
]

not that (D^2) remains nearest-neighbor local.

### The true operator gate

For one concrete

[
D_{\mathrm{total}}
==================

D_U+\Gamma_KM_\Phi,
]

prove:

```lean
superDirac_isOdd
superDirac_kreinSelfAdjoint
superDirac_sq_decomposition
superDirac_commutator_eq_localSymbol
localSymbol_eq_nullSlash
localSymbol_sq_eq_weightedPluckerMass
superDirac_supportedOnNullContinuations
```

The inventory already identifies the symbol/soldering theorem as the missing bridge between the static Dirac–Plücker square root and a graph-native causal operator.

## 14. Locality versus covariance

Claude’s proposed blanket causal-set no-go is too strong for the roadmap.

The established generalized causal-set d’Alembertians of Aslanbeigi, Saravani, and Sorkin are manifestly Lorentz invariant, retarded, and nonlocal. ([arXiv][2]) But a 2025 preprint by Boguñá and Krioukov proposes an intrinsic local causal-set d’Alembertian and proves a continuum-convergence result in sprinkled Minkowski spacetime. ([arXiv][3])

Lean should therefore formalize an **operator audit**, not assume an impossibility theorem:

```lean
Retarded
NullEdgeSupported
IntrinsicLocal
LorentzNaturalInLaw
Stable
ContinuumCorrect
```

A particularly useful open interface is a null-local dilation:

```lean
structure NullDilation (L : Matrix Q Q ℂ) where
  Hidden : Type
  liftD : Matrix (Q × Hidden) (Q × Hidden) ℂ
  nullSupport : SupportedOn liftD IsNullContinuation
  embed : ...
  project : ...
  realizes : project ∘ liftD^2 ∘ embed = L
```

A nonlocal effective operator might be the marginal or square of a local null process on an enlarged state space. Existence or impossibility of such a dilation is a sharper theorem target than the simple lattice-versus-causal-set dichotomy.

# Suggested first ten pull requests

| PR | Deliverable                                                          |
| -- | -------------------------------------------------------------------- |
| 1  | `NullStrand.Conventions` and the representation firewall             |
| 2  | `NullFiber ↔ RestSphere` plus Lorentz pushforward                    |
| 3  | Exact octahedral finite null resolution                              |
| 4  | Abstract finite flux mean, variance, and mass-ratio theorems         |
| 5  | Uniform-floor and massless-concentration guardrails                  |
| 6  | Exact checkerboard Bohm transition and one-step equivariance         |
| 7  | Finite Bell current, minimal rates, and support lemmas               |
| 8  | Finite residual-current null lift and exact equivariance             |
| 9  | Finite weighted least-action theorem plus refresh-chain spectral gap |
| 10 | Finite pathwise coarse-motion theorem and finite master model        |

After those, proceed to separability/synchronization, finite Fock space, internal holonomy, and the graph symbol theorem.

# The genuinely unresolved theorem registry

| Open item                                                                     | Honest status                                                             |
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| General covariant angular generator has a Compton spectral gap                | False without additional hypotheses; correct assumptions must be selected |
| Uniform continuum nonexplosion near nodes and (m\to0)                         | Open analytic problem                                                     |
| Entanglement iff synchronization curvature                                    | Currently too strong and connection-dependent                             |
| Positive foliation-free flat nonlocal connection                              | Open                                                                      |
| Mass/Yukawa operator uniquely selects symmetric traffic                       | Open selection principle                                                  |
| Internal holonomy produces an operational clock                               | Needs a coupling/readout theorem                                          |
| Null-supported, Lorentz-natural, continuum-correct first-order graph operator | Central open gate                                                         |
| Nonlocal causal operator admits a null-local dilation                         | Open and worth testing                                                    |
| Full interacting renormalized Bohmian QFT                                     | Long-horizon                                                              |
| Observed mass spectrum follows rather than being inserted                     | Unsolved physics                                                          |

# Deliverables

I prepared two project files:

* [Comprehensive Lean roadmap](sandbox:/mnt/data/NullStrand_Lean_Roadmap.md)
* [Theorem manifest with dependencies and statuses](sandbox:/mnt/data/NullStrand_Lean_Theorem_Manifest.csv)

The critical strategic choice is to finish **Gate A**, the exact finite model, before depending on continuum stochastic geometry. That will produce a genuine Lean-certified null-strand Bohm–Bell theory even while the continuum spectral-gap, synchronization, and causal-operator questions remain explicit research gates.

[1]: https://leanprover-community.github.io/mathlib4_docs/Mathlib/Probability/Kernel/IonescuTulcea/Traj.html?utm_source=chatgpt.com "Mathlib.Probability.Kernel.IonescuTulcea.Traj"
[2]: https://arxiv.org/abs/1403.1622?utm_source=chatgpt.com "Generalized Causal Set d'Alembertians"
[3]: https://arxiv.org/abs/2506.18745?utm_source=chatgpt.com "Local d'Alembertian for causal sets"
