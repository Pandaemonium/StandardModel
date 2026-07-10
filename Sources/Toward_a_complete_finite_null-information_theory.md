# Toward a complete finite null-information theory

The present framework already has a nontrivial finite core: invariant mass as Plücker disagreement, mass–entropy and mass–concurrence identities, positive physical sectors, signed closure binding, index-protected zero modes, Schur-generated effective mass, finite Fock-space gaps, confinement-shaped positivity, and an exact four-**type** decomposition of the carrier square. It also clearly records what it does not yet possess: a full continuum QFT, an absolute mass scale, a derived Born rule, a selected initial state, or a derivation of the number of null events.   

The missing physics can be incorporated without changing the ontology. The carrier must be promoted from a finite mass model to a **local, scale-dependent, operational process theory**.

The completed object should have the form

[
\mathfrak T=
\left(
\mathbf{NullHist},
\mathcal Z,
\mathcal A,
\mathcal K,
Q,J,\Gamma,D,
\omega,
{\mathcal R_\ell},
{\mathcal M_a},
\widehat N
\right).
]

Here:

* (\mathbf{NullHist}) is the category of finite causal null histories.
* (\mathcal Z) assigns amplitudes or quantum channels to histories.
* (\mathcal A(R)) is the algebra of questions that can be asked in region (R).
* (Q) removes gauge redundancy.
* (J) provides the indefinite prephysical ledger.
* (\Gamma) supplies chirality and orientation.
* (D) supplies propagation, constraint, and spectral cost.
* (\omega) is the state.
* (\mathcal R_\ell) is coarse-graining at scale (\ell).
* (\mathcal M_a) are measurement instruments and record-producing channels.
* (\widehat N) counts elementary spacetime-information events.

Physicalization remains

[
\mathcal H_{\rm phys}(R)
========================

\left(
\ker Q_R/\operatorname{im}Q_R
\right)_{J>0}.
]

But the final theory is not just a Hilbert space and an operator. It is the entire compatible family

[
R\longmapsto
\left(
\mathcal A(R),
\mathcal H_{\rm phys}(R),
\omega_R,
D_R
\right),
]

together with gluing, refinement, and measurement.

The corresponding master amplitude is schematically

[
\mathcal Z(B_+,B_-)
===================

\sum_{\substack{K,h\
\partial K=B_-\sqcup B_+}}
e^{,i\left[
S_{\rm rel}[K,h]
+\Lambda N(K)
+\sum_\alpha\theta_\alpha W_\alpha(K)
+\sum_I\phi_I Q_I(h)
\right]}
,
\mathsf{Phys}!\left(A[K,h]\right).
]

This formula already contains geometry, matter, topological sectors, charges, and the cosmological term. The rest of physics is the systematic interpretation of its algebraic structures.

---

# I. Quantum mechanics itself

## 1. Probability must be attached to the positive sector

The existing theory explains why positivity must be earned, but it still uses quantum probability. The proper completion is to treat a state as a positive normalized functional

[
\omega_R:\mathcal A(R)\to\mathbb C,
\qquad
\omega_R(I)=1,
\qquad
\omega_R(A^\dagger A)\geq0.
]

A measurement with effects

[
E_a\geq0,
\qquad
\sum_a E_a=I
]

has probabilities

[
p(a)=\omega(E_a).
]

For a finite matrix algebra this becomes

[
p(a)=\operatorname{Tr}(\rho E_a).
]

The information-theoretic interpretation is:

> **The Born rule assigns probability according to positive distinguishability weight in the physically decoded sector.**

This is still an axiom unless the program proves a reconstruction theorem. The natural theorem target is:

[
\boxed{
\text{positivity}
+
\text{noncontextuality}
+
\text{additivity}
+
\text{tensor composition}
\Longrightarrow
p(E)=\operatorname{Tr}(\rho E).
}
]

The framework should not claim that mass, nullness, or path superposition alone derives this rule.

## 2. Contextuality is failure of global decoding

A measurement context is a commuting subalgebra

[
C\subset\mathcal A.
]

A classical hidden-variable description would assign compatible values on every context and glue them into one global valuation

[
v:\mathcal A\to\mathbb R.
]

Quantum contextuality means that the local valuations cannot be glued.

Information-theoretically:

[
\boxed{
\text{contextuality}
====================

\text{an obstruction to constructing one context-independent decoder
for all possible questions}.
}
]

This is structurally close to gauge patching. Local descriptions exist; a global consistent section does not. Contextuality can therefore be treated cohomologically, as a different kind of global obstruction from gauge curvature.

## 3. Bell nonlocality and no-signaling separate naturally

For two causally separated regions (A) and (B), the global state may fail to factor:

[
\rho_{AB}\neq\rho_A\otimes\rho_B.
]

That is entanglement: the global codeword cannot be represented as two independent local codewords.

But causal factorization requires that local choices cannot transmit information outside the null cone:

[
\sum_b p(a,b|x,y)
]

must be independent of (y), and similarly on the other side.

Thus:

[
\boxed{
\text{Bell nonlocality}
=======================

\text{failure of separable encoding},
}
]

while

[
\boxed{
\text{no-signaling}
===================

\text{zero channel capacity outside the causal null relation}.
}
]

The theory can therefore be nonclassically correlated without violating its finite causal cone.

## 4. Observers become internal decoders

An observer is not external to the theory. It is a stable positive-sector subsystem with:

* a clock register;
* a memory register;
* a pointer algebra;
* a family of admissible instruments;
* a record-recovery channel.

A measurement is a process

[
\rho_S
\longmapsto
\sum_a
\mathcal M_a(\rho_S)
\otimes
|a\rangle\langle a|_{\rm record}.
]

A classical fact exists when the same record is redundantly recoverable from many environmental fragments.

So:

[
\boxed{
\text{observer}
===============

\text{a persistent codeword capable of producing and recovering records}.
}
]

This removes the need for a classical observer at the fundamental level, though it still does not solve the interpretive question of why one experienced outcome is selected.

---

# II. Local quantum field theory

## 5. Locality requires a net of observable algebras

The finite path-sum picture must be upgraded to a local net:

[
R\longmapsto\mathcal A(R).
]

It should satisfy:

[
R_1\subseteq R_2
\quad\Longrightarrow\quad
\mathcal A(R_1)\subseteq\mathcal A(R_2),
]

and

[
R_1\perp R_2
\quad\Longrightarrow\quad
[\mathcal A(R_1),\mathcal A(R_2)]=0.
]

The first condition says that every question available in a smaller region remains available in a larger one.

The second says that spacelike-separated questions do not interfere operationally.

This is the missing bridge from “finite carrier” to “local quantum field theory.”

A field is then not a substance. It is a local observable-valued query:

[
\Phi(f)\in\mathcal A(\operatorname{supp}f).
]

A particle is a stable spectral response of the local field net.

## 6. Particles should become poles of boundary response

The finite spectral definition

[
D^#D,|\psi\rangle=m^2|\psi\rangle
]

must become the refined QFT statement that stable particles appear as isolated poles in correlation functions or boundary transfer amplitudes.

Information-theoretically:

[
\boxed{
\text{particle pole}
====================

\text{a logical excitation that propagates over arbitrary distance
without losing decoding fidelity}.
}
]

A resonance has a complex pole

[
z_\star=M-\frac{i}{2}\Gamma.
]

Then:

* (M) is spectral cost;
* (\Gamma) is leakage rate into other code sectors;
* (\Gamma^{-1}) is the recovery lifetime of the approximate codeword.

This extends the existing finite bound-state and Feshbach/Schur picture into a full scattering theory.

## 7. The S-matrix needs analyticity, crossing, and clustering

The finite theory already has unitary scattering witnesses. A complete S-matrix sector must also satisfy:

### Unitarity

[
S^\dagger S=I.
]

Globally, no information disappears.

### Crossing

An outgoing particle is equivalent to an incoming antiparticle under orientation reversal and dualization.

Information meaning:

[
\boxed{
\text{crossing}
===============

\text{the same boundary channel viewed with one codeword dualized
and moved across the boundary}.
}
]

### Cluster decomposition

For widely separated experiments,

[
S_{A\sqcup B}
\longrightarrow
S_A\otimes S_B.
]

Information meaning:

> Independent remote decoders become independent channels when no long-range record connects them.

### Analyticity and dispersion relations

Causal support and the positive spectral condition should constrain amplitudes to analytic functions of energy-momentum invariants.

Information meaning:

> A channel that cannot respond before receiving information cannot have arbitrary frequency dependence.

Forward-scattering positivity bounds would then follow from unitarity, analyticity, and positive decoding. They would become consistency conditions on allowable finite channel couplings.

## 8. The operator-product expansion is local compression

When two local queries approach each other, their product should be representable by a basis of effective queries:

[
\mathcal O_i(x)\mathcal O_j(0)
\sim
\sum_k
C_{ij}^{\ \ k}(x)\mathcal O_k(0).
]

Information-theoretically:

[
\boxed{
\text{OPE}
==========

\text{the optimal compression dictionary for nearby local questions}.
}
]

Scaling dimensions measure how long the information carried by an operator survives under repeated coarse-graining.

A conformal field theory is a decoder fixed point with no intrinsic recovery scale.

Its central charges measure anomaly content and, in suitable dimensions, the effective number of information channels.

---

# III. Renormalization, effective field theory, and the absolute scale

## 9. Wilsonian RG is optimal channel compression

A coarse-graining map

[
\mathcal R_\ell:
\mathfrak T_{\rm fine}
\longrightarrow
\mathfrak T_\ell
]

should preserve the boundary channel as accurately as possible while discarding hidden microscopic registers.

Relevant perturbations are those whose decoding effect grows:

[
g_a(\ell)\uparrow.
]

Irrelevant perturbations are details that repeated compression erases:

[
g_a(\ell)\downarrow.
]

Marginal perturbations require higher-order analysis.

Thus:

[
\boxed{
\text{effective field theory}
=============================

\text{the smallest decoder that reproduces all boundary experiments
below a chosen resolution}.
}
]

The current project already has finite Schur and RG scaffolding, but explicitly stops before a full continuum flow or fixed-point theorem. 

## 10. Renormalizability is finite-dimensional recoverability

A continuum theory is renormalizable when all microscopic details that survive coarse-graining lie in a finite-dimensional manifold of couplings.

Information-theoretically:

[
\boxed{
\text{renormalizability}
========================

\text{large-scale recoverability from finitely many information coordinates}.
}
]

A nonrenormalizable theory is not meaningless. It simply needs increasingly many coordinates as one asks for finer reconstruction.

## 11. Asymptotic freedom is ultraviolet loss of loop memory

In a nonabelian gauge sector, asymptotic freedom would mean that at sufficiently short resolution the effective closure coupling tends toward zero:

[
g_{\rm closure}(\ell)\to0
\qquad
(\ell\to0).
]

Information-theoretically:

> **At short distances, internal frame-comparison loops store progressively less memory, and the null messages propagate almost freely.**

At larger scales, closure memory accumulates and the simple colored codeword ceases to decode independently.

This links asymptotic freedom and confinement as opposite ends of one information flow.

## 12. Dimensional transmutation must generate the missing absolute scale

The current framework naturally gives dimensionless angles, signs, ratios, indices, and phase boundaries. It does not yet derive a MeV or GeV scale.

The proper route is an RG invariant:

[
\Lambda_{\rm dyn}
=================

\mu
\exp\left(
-\int^g
\frac{dg'}{\beta(g')}
\right).
]

Information-theoretically:

[
\boxed{
\Lambda_{\rm dyn}^{-1}
======================

\text{the scale at which a nominally scale-free information defect
becomes unrecoverably large}.
}
]

This is the missing bridge from finite dimensionless carrier structure to physical mass units.

Without it, absolute masses remain outside the theory.

## 13. Renormalization schemes are decoder coordinates

The nonuniqueness of channel shares should be interpreted partly as coordinate freedom on decoder moduli space.

The total spectrum and total mass are invariant.

Individual aperture, closure, and turn shares may depend on:

* blocking rule;
* basis choice;
* subtraction prescription;
* scale;
* section of the channel bundle.

Thus scheme dependence is not an embarrassment. It is the statement that the same physical boundary channel can be represented by different compressed internal ledgers.

---

# IV. Gauge groups, generalized symmetries, and the Standard Model alphabet

## 14. The gauge group should be derived as a decoder automorphism group

The internal gauge group should ultimately be

[
G_{\rm phys}
============

\operatorname{Aut}_{\otimes,#}
\left(
\mathcal A,Q,J,\Gamma,D
\right),
]

or an appropriate local version.

Matter representations are then irreducible positive cohomology modules of this automorphism group.

This converts the question

> Why (SU(3)\times SU(2)\times U(1))?

into

> Which compact local automorphism group preserves null composition, chirality, positivity, the turn resource, anomaly cancellation, and the allowed tensor product?

The present theory has color-, weak-, and phase-shaped registers, but it does not yet derive the Standard Model group or its hypercharge assignments. This remains one of the largest missing pieces.

The division-algebra and signature-selection program may eventually help: nullness should force indefiniteness, while composition plus a continuous abelian phase may select complex two-spinor kinematics and four dimensions. Those are explicit theorem targets rather than established results. 

## 15. Maxwell and Yang–Mills equations become consistency equations for comparators

For an abelian comparator,

[
F=dA.
]

For a nonabelian comparator,

[
F=dA+A\wedge A.
]

The Bianchi identity

[
DF=0
]

says that nested frame comparisons are algebraically consistent.

The sourced equation

[
D^\dagger F=j
]

says that local charge information is exactly the failure of flux comparison to close through the boundary.

Thus:

[
\boxed{
\text{Maxwell/Yang--Mills equations}
====================================

\text{consistency and response equations of internal reference-frame transport}.
}
]

Photons and gluons are propagating perturbations of those reference-frame comparators.

A photon is physically visible and massless because the corresponding residual phase symmetry remains unbroken.

A gluon may be kinematically massless while failing to define an isolated positive asymptotic codeword because of confinement.

## 16. Generalized symmetries add strings, fluxes, and branes

Ordinary charges are carried by pointlike sectors. But modern physics also contains (p)-form symmetries whose charges are measured on extended surfaces.

On a finite complex, these fit naturally into cohomology:

[
H^p(K,G).
]

Information-theoretically:

[
\boxed{
p\text{-form charge}
====================

\text{logical information stored on a }p\text{-dimensional extended operator}.
}
]

This naturally introduces:

* Wilson lines;
* ’t Hooft lines;
* flux tubes;
* strings;
* domain walls;
* membranes;
* higher-dimensional defects.

Confinement can then be recast as a phase of a one-form symmetry: isolated endpoints are not decodable, while flux tubes are the physical extended code.

Strings and branes need not be fundamental additions. They can emerge as extended logical defects of the null-information code.

Their tension is spectral cost per unit code length or area.

## 17. Noninvertible symmetries are fusion channels

Not every symmetry-like operation is an automorphism.

Some defects fuse according to

[
X\otimes Y
==========

\bigoplus_Z
N_{XY}^{\ \ Z},Z.
]

Information-theoretically:

> **A noninvertible symmetry is a reproducible transformation of code sectors that cannot be undone by a unique inverse channel.**

This gives a natural home for duality defects and modern generalized symmetry structures.

## 18. Anomaly inflow becomes bulk repair of a boundary decoder

A boundary gauge redundancy may fail to compose consistently:

[
\mathcal Z_{\partial}(g\cdot h)
===============================

e^{i\alpha(g,h)}
\mathcal Z_{\partial}(h).
]

A bulk topological term may contribute the opposite phase.

Then:

[
\alpha_{\partial}
+
\alpha_{\rm bulk}
=================

0.

]

Information-theoretically:

[
\boxed{
\text{anomaly inflow}
=====================

\text{a boundary decoding inconsistency repaired by information stored in the bulk}.
}
]

This unifies chiral anomalies, topological phases, protected boundary modes, and higher-dimensional topological terms.

## 19. No exact global symmetries in quantum gravity

A natural gravitational principle is:

> Every exact conserved logical label must either be gauged, measurable at a boundary, or realized by a dynamical charged codeword.

An exact global label invisible to all boundary and soldering data would be inaccessible information permanently split into disconnected superselection sectors.

A self-decoding gravitational theory may forbid that.

This gives an information-theoretic route to the expectation that quantum gravity admits no exact global symmetries and that its charge spectrum should be complete.

It is a conjecture here, not a result.

---

# V. Vacuum structure, symmetry breaking, and phases of matter

## 20. The vacuum is a decoder fixed point

A vacuum is not empty. It is a state–decoder pair

[
(\omega_0,D_0)
]

satisfying a self-consistency condition:

[
\omega_0=\omega[D_0],
\qquad
D_0=D[\omega_0].
]

It minimizes the relevant information free energy while obeying constraints.

Different vacua are different stable fixed points of the same microscopic laws.

## 21. Spontaneous symmetry breaking requires a refinement limit

For a finite system, the exact ground state can generally remain symmetric. Genuine spontaneous breaking appears only in a thermodynamic or refinement limit where distinct vacua become mutually inaccessible.

If (U_g) is a symmetry of the law,

[
U_g D U_g^{-1}=D,
]

but

[
\omega_0\circ U_g\neq\omega_0,
]

then the state—not the law—breaks the symmetry.

Information-theoretically:

[
\boxed{
\text{spontaneous symmetry breaking}
====================================

\text{selection of one reference-frame codeword from a degenerate family}.
}
]

Goldstone modes are low-cost spatial variations of that reference-frame orientation.

Gauge symmetry differs because it is redundancy, not physical degeneracy. Its orientation register is absorbed into the gauge field, while the radial resource fluctuation remains as the Higgs mode.

## 22. Chiral symmetry breaking is macroscopic left–right code coherence

A chiral condensate

[
\langle\bar\psi\psi\rangle\neq0
]

would mean that the many-body vacuum contains persistent coherence between left and right code sectors.

The finite protected and winding low-mode results are the right one-particle precursors, but a true condensate requires:

* second quantization;
* a many-body or functional-integral state;
* a refinement or thermodynamic limit;
* a nonzero limiting density of near-zero modes.

Information-theoretically:

[
\boxed{
\text{chiral condensate}
========================

\text{macroscopic coherence that makes left/right sector conversion
a property of the vacuum rather than an isolated gate}.
}
]

## 23. Phase transitions are changes in decodability

A phase transition may involve any of the following:

* closure of a spectral gap;
* change in physical cohomology;
* change in positive-sector inertia;
* change in topological order;
* divergence of recovery length;
* change in which reference frame is selected.

The massless line

[
|\kappa|=\lambda
]

is the simplest finite example: a positive massive code loses its gap.

More generally:

[
\boxed{
\text{phase transition}
=======================

\text{a nonanalytic change in which information remains stably decodable at large scale}.
}
]

## 24. Superconductivity and superfluidity fit naturally

A superfluid is a phase-coherent code with a spontaneously selected (U(1)) phase reference. Its phonon is the Goldstone mode of that phase.

A superconductor adds gauge coupling. The phase reference locks to the electromagnetic comparator, giving the gauge field a mass gap.

Information-theoretically:

[
\boxed{
\text{superconductivity}
========================

\text{a paired many-body code whose shared phase reference makes
electromagnetic frame mismatch costly}.
}
]

The Meissner effect is expulsion of low-cost gauge curvature from the phase-locked code.

Cooper pairing is joint-code compression: two fermionic excitations form a collective codeword whose spectral/free-energy cost is lower than that of independent excitations.

## 25. Topological order is globally stored logical information

Topologically ordered states have:

* local indistinguishability;
* global ground-state degeneracy;
* nonlocal logical operators;
* robust braiding holonomy.

Information-theoretically:

[
\boxed{
\text{topological order}
========================

\text{information that no local decoder can read or erase,
but global loop operators can distinguish}.
}
]

Anyons are codewords whose exchange histories carry nontrivial braid holonomy.

Quantum Hall conductance is then a topological response coefficient of the ground-state bundle.

---

# VI. Atomic, nuclear, and chemical physics

These do not require new fundamental ontology. They are hierarchical consequences of the same decoder once QED and QCD are recovered.

## 26. Atomic spectra

An atom is a positive bound codeword in a Coulomb comparator background.

Atomic orbitals are eigenmodes of the corresponding effective decoder.

Angular momentum is null-factorization holonomy.

Shell structure arises from:

* rotational representation theory;
* spin;
* exchange antisymmetry;
* the spectral degeneracies of the Coulomb code.

The periodic table becomes the catalogue of stable many-electron codewords permitted by charge, spin, and Pauli constraints.

## 27. Chemical bonds

A chemical bond is a joint encoding whose total spectral/free-energy cost is lower than that of isolated atoms.

Covalent bonding is shared coherent encoding.

Ionic bonding is charge transfer plus long-range comparator energy.

Metallic bonding is a delocalized many-body code.

Thus:

[
\boxed{
\text{chemical bond}
====================

\text{a stable entanglement-assisted compression advantage
between atomic codewords}.
}
]

## 28. Nuclear physics

A nucleus is a color-singlet many-body code assembled from confined QCD codewords.

Residual nuclear forces are effective channels remaining after color structure is compressed out.

Radioactive decay is resonance leakage.

Alpha decay is tunneling of a preformed composite codeword through an effective spectral barrier.

Beta decay is a weak-reference-assisted re-encoding of charge, chirality, and flavor.

The theory would not need a separate ontology for nuclei; it needs a correct continuum QCD and effective-field-theory limit.

---

# VII. Infrared physics, soft particles, and memory

## 29. Charged particles require soft dressing

In a long-range gauge theory, an isolated charged matter codeword is incomplete. It must be accompanied by a coherent soft-field record of its charge.

The physical asymptotic state is therefore

[
|\Psi_{\rm phys}\rangle
=======================

|\text{matter}\rangle
\otimes
|\text{soft reference-frame dressing}\rangle.
]

Information-theoretically:

[
\boxed{
\text{infrared dressing}
========================

\text{the boundary reference information required to make a charged codeword
gauge-complete}.
}
]

Infrared divergences arise when one tries to calculate probabilities for an incomplete codeword while discarding its compulsory soft register.

## 30. Soft theorems are boundary consistency conditions

A soft photon, gluon, or graviton probes the mismatch between asymptotic reference frames before and after scattering.

Soft theorems become Ward identities for boundary frame redundancy.

The soft factor is fixed because the long-wavelength mode cannot resolve microscopic history; it sees only conserved asymptotic logical data.

## 31. Memory is a persistent boundary record

After radiation passes, the asymptotic comparator may remain shifted.

Electromagnetic or gravitational memory is therefore:

[
\boxed{
\text{a permanent change in the boundary codebook recording the passage
of charge or energy}.
}
]

This connects soft theorems, asymptotic symmetries, and memory as three forms of one boundary-information structure.

---

# VIII. Open systems, nonequilibrium physics, and chaos

## 32. Open-system dynamics arises by tracing hidden edges

When hidden registers are discarded, unitary evolution induces a completely positive channel.

In a Markovian approximation,

[
\dot\rho
========

-i[H,\rho]
+
\sum_\alpha
\left(
L_\alpha\rho L_\alpha^\dagger
-\frac12
{L_\alpha^\dagger L_\alpha,\rho}
\right).
]

Each (L_\alpha) describes a way visible information leaks into unresolved null histories.

Thus:

* decoherence is leakage of phase information;
* dissipation is leakage of spectral energy;
* noise is uncontrolled coupling to hidden code sectors.

## 33. Fluctuation theorems come from path reversal

For a microscopic history (h) and its reversed history (\Theta h), one expects a relation of the form

[
\frac{P[h]}{P[\Theta h]}
========================

e^{\Delta S_{\rm tot}[h]}.
]

Information-theoretically:

> Entropy production is the log-likelihood advantage of a history over its time reverse after hidden records are discarded.

Finite CPT and path-reversal structures would make this a natural theorem target.

## 34. Thermalization is local indistinguishability

The eigenstate thermalization hypothesis can be translated as:

> For simple local query algebras, almost all high-complexity energy eigen-codewords return the same answers as the thermal state.

The full microstate remains pure and distinct, but the restricted decoder cannot tell.

Thermalization is therefore not destruction of information. It is the migration of distinguishing information into highly nonlocal correlations.

## 35. Chaos is rapid operator growth

Let (A(t)) be a local query evolved in time. Chaos means that its support spreads rapidly through the code:

[
[A(t),B]
]

grows for initially remote (B).

Information-theoretically:

[
\boxed{
\text{scrambling}
=================

\text{rapid delocalization of logical information into nonlocal correlations}.
}
]

A black hole would be an extreme fast-scrambling code.

## 36. Complexity is minimal null-gate depth

Define the complexity of a state or decoder as the minimal number of admissible elementary null gates needed to prepare it:

[
\mathcal C(|\psi\rangle)
========================

\min
{
\text{gate depth preparing }|\psi\rangle
}.
]

Complexity is distinct from entropy:

* entropy measures hidden multiplicity or mixedness;
* complexity measures preparation difficulty.

This may eventually connect geometry, interior growth, and computation, but such identifications remain speculative.

---

# IX. Classical physics

## 37. Classical mechanics is the stable stationary-phase sector

The finite path sum

[
\mathcal Z
==========

\sum_h
a_h e^{iS[h]}
]

is dominated in a semiclassical regime by families whose phase is stationary:

[
\delta S=0.
]

Information-theoretically:

> **A classical trajectory is a history family whose neighboring alternatives interfere destructively, leaving a robust, highly compressible path bundle.**

Ehrenfest motion arises when a narrow codeword remains localized under the effective channel.

Hamilton–Jacobi theory is the evolution of the dominant phase function.

Poisson brackets arise as the leading semiclassical approximation to commutators.

## 38. Classical objects are high-distance redundant codes

A macroscopic body is classical because its relevant records are:

* redundantly stored;
* highly stable;
* robust against local errors;
* continually monitored by its environment.

Its center-of-mass trajectory is a compressed effective variable. Internal null histories remain quantum, but almost no realistic local perturbation can recohere the macroscopically distinct record sectors.

---

# X. Relational time and the problem of time

## 39. The universe may be globally constrained and locally dynamical

A closed-universe state may satisfy

[
\mathcal H_{\rm total}
|\Omega\rangle
==============

0.

]

There is then no external time parameter.

Choose a clock subsystem (C) with clock states (|t\rangle). The conditional system state is

[
\rho_S(t)
=========

\frac{
\langle t|
\rho_{CS}
|t\rangle
}{
\operatorname{Tr}
\langle t|
\rho_{CS}
|t\rangle
}.
]

Information-theoretically:

[
\boxed{
\text{time}
===========

\text{correlation between one stable code register and the rest}.
}
]

The theory naturally contains three distinct time notions:

1. **Causal time:** partial order of null-information transmission.
2. **Proper time:** local mixedness/phase accumulation of a massive codeword.
3. **Modular or relational time:** state-dependent flow generated by correlations with a clock or by the modular Hamiltonian.

A complete theory must show how these agree in the semiclassical limit.

---

# XI. Dynamical gravity

## 40. Einstein’s equation should be a decoder stationarity equation

Let (e) denote the soldering or directional codebook.

A natural total functional is

[
\mathfrak F[e,\rho]
===================

\mathfrak F_{\rm geom}[e]
+
\mathfrak F_{\rm matter}[\rho,e]
--------------------------------

T S(\rho)
+
\Lambda N[e].
]

The gravitational equation is

[
\frac{\delta\mathfrak F}{\delta e}
==================================

0.

]

The matter response is

[
T
\sim
\frac{\delta\mathfrak F_{\rm matter}}{\delta e}.
]

Thus:

[
\boxed{
\text{stress-energy}
====================

\text{the information load placed on the null-direction codebook},
}
]

and

[
\boxed{
\text{gravity}
==============

\text{the codebook’s self-consistent response}.
}
]

The existing soldering channel already has a finite torsion-plus-nonmetricity decomposition rather than a pure-torsion form. The continuum geometric identification remains a correspondence problem. 

## 41. Einstein equations may follow from entanglement equilibrium

For small causal diamonds, one can seek a finite relation of the form

[
\delta S_{\rm boundary}
=======================

\delta\langle K_{\rm mod}\rangle,
]

combined with a geometric variation of boundary capacity.

If this must hold for every small causal region, the resulting stationarity condition may reproduce an Einstein-like equation.

Information-theoretically:

> **Spacetime curvature is whatever change in the codebook is required to keep local boundary-information balance consistent with matter modular energy.**

This would connect the Jacobson thermodynamic route to the null-information carrier.

## 42. Energy conditions may be information inequalities

Positivity and monotonicity of relative entropy can imply constraints on energy flow.

The finite analogue would seek implications of the form

[
S(\rho_R|\sigma_R)
\geq
S(\rho_{R'}|\sigma_{R'})
\qquad
(R'\subset R)
]

for soldering responses on nested null cuts.

This could provide information-theoretic versions of averaged null energy conditions and generalized second-law inequalities.

## 43. Singularities become decoder failure

A singularity need not be a literal point where geometric numbers diverge.

It may be a region where:

* positive physical sectors disappear;
* spectral distance degenerates;
* code capacity collapses;
* recovery error reaches one;
* the state–geometry fixed point ceases to exist.

Thus:

[
\boxed{
\text{singularity}
==================

\text{breakdown of the classical geometric decoder,
possibly replaced by another information phase}.
}
]

This does not by itself resolve singularities, but it gives a precise finite criterion for what resolution would mean.

---

# XII. Holography and black holes

## 44. Holography is boundary recoverability

For a causal region (R), the physical interior code should be recoverable from suitable boundary data.

A target bound is

[
\log\dim\mathcal H_{\rm phys}(R)
\leq
c,|\partial_{\rm null}R|.
]

Information-theoretically:

[
\boxed{
\text{holography}
=================

\text{the statement that bulk logical information is encoded
in a boundary channel with area-scaled capacity}.
}
]

The entanglement wedge is the part of the bulk recoverable from a chosen boundary subsystem.

Complementary recovery explains why different boundary regions may reconstruct overlapping bulk information without violating no-cloning: they do not produce independent copies; they access the same logical algebra through different code representations.

## 45. Black-hole entropy counts compatible interior encodings

A black hole is a near-saturated causal code.

Its entropy is

[
S_{\rm BH}
\sim
\log
#{
\text{interior histories compatible with the same exterior boundary data}
}.
]

The area law follows if the independent consistency data linking interior and exterior live on the horizon cut.

## 46. Hawking radiation and the Page curve are recovery transitions

The global state may remain pure while exterior radiation is mixed.

Early radiation lacks enough channel capacity to decode the interior logical state.

As radiation accumulates, the optimal recovery map changes. The Page transition is when the radiation becomes a better decoder of the interior information than the remaining horizon.

An “island” is then the bulk region included in the optimal recovery domain of the radiation algebra.

## 47. Wormholes are possible nonfactorization of codebooks

A connected bulk geometry between two boundaries may encode the fact that the boundary process does not factor:

[
\mathcal H_{L\cup R}
\not\simeq
\mathcal H_L\otimes\mathcal H_R
]

at the level of physical constraints and shared logical operators.

This offers an information-theoretic interpretation of wormhole-like connectivity, but it is optional and not implied by the finite carrier alone.

---

# XIII. Cosmology

## 48. Expansion is growth of causal code capacity

Let (N_{\rm space}(\tau)) count effective spatial code cells on a cosmological slice.

Define

[
H_{\rm info}
============

\frac1d
\frac{d}{d\tau}
\log N_{\rm space}.
]

Expansion is not motion into external space. It is increase in the number and connectivity of available causal comparison registers.

A Friedmann-like equation would become a global capacity balance:

[
H_{\rm info}^2
\sim
\rho_{\rm spectral}
+
\rho_{\rm hidden}
+
\rho_\Lambda
------------

\frac{k_{\rm top}}{a^2}.
]

Here:

* (\rho_{\rm spectral}) is matter/radiation code load;
* (\rho_{\rm hidden}) is hidden-sector load;
* (\rho_\Lambda) is global code-size pressure;
* (k_{\rm top}) represents global spatial closure/topology.

## 49. Inflation is a code-proliferation instability

Inflation would be a phase in which the code-size free energy favors rapid growth:

[
\frac{d^2}{d\tau^2}\log N_{\rm space}>0.
]

A scalar inflaton-like degree of freedom would be a slowly changing control parameter of the decoder ensemble.

Information-theoretically:

> **Inflation is a temporary unstable phase in which the number of causally distinguishable code cells grows quasi-exponentially.**

Scalar perturbations would be fluctuations in local event density, turn-resource amplitude, or code-growth rate.

Tensor perturbations would be fluctuations of soldering itself.

This becomes physical only if the theory derives:

* approximate scale invariance;
* near-Gaussian statistics;
* the scalar/tensor mode structure;
* freeze-out at horizon crossing.

At present it is only a plausible embedding.

## 50. Structure formation is instability of code density

Density perturbations correspond to spatial variations in persistent codeword load and event density.

Gravity amplifies them because regions with greater spectral load deform the codebook so as to increase further information retention.

Galaxies and clusters become stable nonlinear code-density attractors.

## 51. Dark matter is hidden positive-sector information

A dark sector is a positive physical sector with:

[
\text{weak visible gauge overlap},
\qquad
\text{nonzero soldering response}.
]

Its codewords gravitate because they load the directional codebook, even if visible charge queries barely detect them.

The minimal hidden-leakage version tends to produce seesaw-suppressed masses, but a hidden sector with its own aperture and closure dynamics could contain heavy states. Therefore the theory should not yet claim that all dark matter must be light.

Dark radiation would be protected or collinear massless hidden codewords.

## 52. Dark energy is global volume uncertainty

The cosmological constant remains the global conjugate to event count:

[
e^{i\Lambda\widehat N}.
]

The finite everpresent-(\Lambda) core already proves that, assuming

[
\operatorname{Var}(N)=N,
]

one obtains

[
\Lambda_{\rm rms}
\sim
N^{-1/2}.
]

What remains unproved is the native identification of null-edge count with four-volume, the Poisson law, the volume–(\Lambda) conjugacy, and the sequestering of extensive vacuum offsets. 

The completed interpretation is:

[
\boxed{
\text{mass}
===========

\text{local directional compression residue},
}
]

[
\boxed{
\Lambda
=======

\text{global code-size conjugate uncertainty}.
}
]

## 53. Baryogenesis becomes state asymmetry plus index flow

Assuming a finite CPT theorem, matter asymmetry must come from the state.

The ingredients would be:

* charge-conjugation asymmetry in strand occupation;
* CP-odd Bargmann or spectral-bundle holonomy;
* a non-KMS, nonequilibrium state;
* baryon/lepton-number-changing index flow through winding gauge backgrounds.

This is the information-theoretic Sakharov structure.

---

# XIV. Supersymmetry, strings, and duality

These are not forced by the present theory, but they fit naturally.

## 54. Cohomological supersymmetry is already present

The constraint differential has the Hodge form

[
H_Q=Q^#Q+QQ^#.
]

Nonzero states pair across the grading; cohomology remains unpaired.

This is supersymmetric quantum mechanics at the decoder level.

A genuine spacetime supersymmetry would require an odd positive-sector operator (\mathcal Q) satisfying

[
\mathcal Q^2=0,
\qquad
{\mathcal Q,\mathcal Q^#}=H,
]

and exchanging bosonic and fermionic physical codewords.

Broken supersymmetry would mean the pairing fails in the physical positive sector.

Such a symmetry could protect critical lines or small masses, but it is not currently required.

## 55. Strings and branes are extended logical defects

Higher-form charges naturally require extended carriers.

A string is a one-dimensional persistent defect whose endpoints carry point charges or whose closed loop carries topological information.

A brane is a higher-dimensional defect or boundary condition.

Their tensions are:

[
T_p
===

\frac{
\text{spectral information cost}
}{
\text{(p)-volume of the defect}
}.
]

A worldsheet or worldvolume path integral is the sum over histories of the corresponding extended code defect.

The theory therefore accommodates strings and branes without making them the primitive ontology.

## 56. Extra dimensions are hidden codebook directions

An additional dimension may be interpreted as an internal direction of the decoder that is locally available but inaccessible at low energy.

Compactification is coarse-graining over that hidden directional register.

Kaluza–Klein modes are excited harmonics of the hidden codebook.

Whether such dimensions exist must be decided dynamically or spectrally; they do not follow merely from null information.

## 57. Duality is equivalent physical decoding

Two microscopic theories are dual when

[
\mathsf{Phys}\circ\mathcal Z_1
\simeq
\mathsf{Phys}\circ\mathcal Z_2.
]

They may use different particles, fields, couplings, dimensions, or defect variables, while producing the same physical boundary channel.

Thus:

[
\boxed{
\text{duality}
==============

\text{different internal encodings of the same decodable information}.
}
]

Strong–weak, electric–magnetic, particle–vortex, and bulk–boundary dualities become special cases.

---

# XV. The completed information dictionary

| Physics               | Information-theoretic description                              |
| --------------------- | -------------------------------------------------------------- |
| Quantum state         | encoded finite history superposition                           |
| Probability           | positive valuation on the physical query algebra               |
| Contextuality         | failure of local query decoders to glue globally               |
| Entanglement          | nonfactorizability of a global codeword                        |
| No-signaling          | zero channel capacity outside causal order                     |
| Field                 | local query on the decoder                                     |
| Particle              | stable positive spectral response                              |
| Virtual particle      | hidden intermediate factorization of an amplitude              |
| Charge                | conserved logical-sector information                           |
| Gauge field           | quantum reference-frame comparator                             |
| Curvature             | irreducible loop memory                                        |
| Mass                  | irreducible positive null-compression cost                     |
| Spin                  | representation of the hidden null-factorization fiber          |
| Statistics            | exchange-history holonomy                                      |
| Higgs vacuum          | charge-coherent reference resource                             |
| Goldstone mode        | low-cost orientation wave of a selected reference              |
| Bound state           | joint-code compression advantage                               |
| Resonance             | approximate codeword with finite leakage rate                  |
| Confinement           | failure of a non-singlet state to decode independently         |
| Anomaly               | failure of redundancy to compose consistently                  |
| RG                    | repeated channel compression and recovery                      |
| EFT                   | smallest decoder preserving low-resolution experiments         |
| Temperature           | exchange rate between spectral cost and missing information    |
| Thermalization        | local inability to distinguish global micro-codewords          |
| Chaos                 | rapid delocalization of logical information                    |
| Complexity            | minimal null-gate preparation cost                             |
| Classical fact        | redundant, stable, recoverable record                          |
| Proper time           | local phase/mixedness clock of a massive codeword              |
| Gravity               | self-dynamics of the directional codebook                      |
| Stress-energy         | information load on that codebook                              |
| Horizon               | boundary of accessible decoding                                |
| Black-hole entropy    | multiplicity of interiors compatible with one boundary channel |
| Holography            | bulk recoverability from boundary code capacity                |
| Expansion             | growth of causal code capacity                                 |
| Dark matter           | hidden positive-sector load with weak visible overlap          |
| Cosmological constant | chemical potential and uncertainty of total code size          |
| String/brane          | extended logical defect carrying higher-form information       |
| Duality               | equivalent physical decoding                                   |

---

# XVI. What genuinely still requires new principles

After incorporating all of the above, several questions remain outside the current explanatory closure.

## 1. Why quantum probability?

The framework uses positive quantum states. It does not yet derive the Born rule from null information.

## 2. Why this internal gauge group?

The exact emergence of

[
SU(3)\times SU(2)\times U(1)
]

and the observed matter representations remains open.

## 3. Why three generations?

The present finite completion count does not force three; the uploaded research program records an (n+1) structure and identifies a missing rank-fixing principle. 

## 4. Why the observed absolute scales?

A genuine continuum RG and dimensional-transmutation theorem is required.

## 5. Why (3+1) dimensions and one time?

There are plausible signature- and division-algebra-selection routes, but they remain theorem targets. 

## 6. Why this state and these initial conditions?

The state (\omega), low initial gravitational entropy, and cosmological boundary condition remain unexplained.

## 7. Why this number of null events?

The theory can make event count physical and conjugate to (\Lambda), but it does not yet derive the universe’s total code size.

## 8. Why does the continuum exist?

A refining family must be shown to converge to a local, unitary, Lorentzian quantum field theory with the correct universality class.

---

# The most complete form of the theory

The expanded theory can now be stated as:

[
\boxed{
\begin{aligned}
\text{Quantum mechanics}
&=
\text{positive probabilistic decoding of finite history superpositions},[1mm]
\text{quantum field theory}
&=
\text{a local net of such decoders with causal composition},[1mm]
\text{particles}
&=
\text{stable positive spectral codewords},[1mm]
\text{forces}
&=
\text{reference-frame, loop, turn, and soldering defects},[1mm]
\text{mass}
&=
\text{irreducible null-compression cost},[1mm]
\text{renormalization}
&=
\text{scale-dependent optimal recovery},[1mm]
\text{thermodynamics}
&=
\text{physics after incomplete decoding},[1mm]
\text{classicality}
&=
\text{redundantly recorded high-distance information},[1mm]
\text{gravity}
&=
\text{self-consistent dynamics of the decoder’s geometry},[1mm]
\text{cosmology}
&=
\text{the growth, state, and fluctuations of the total causal code}.
\end{aligned}
}
]

The deepest unifying principle is therefore no longer only that mass comes from null disagreement.

It is:

[
\boxed{
\textbf{Every physical structure is a statement about what information
survives composition, redundancy removal, positive decoding,
coarse-graining, and recovery.}
}
]

Charge is what cannot be locally erased.

Mass is what cannot be coherently compressed.

Topology is what cannot be locally changed.

Temperature is what cannot be microscopically recovered.

Gravity is what changes the standard of comparison itself.

And cosmology is what happens when the total capacity of that comparison system becomes dynamical.
