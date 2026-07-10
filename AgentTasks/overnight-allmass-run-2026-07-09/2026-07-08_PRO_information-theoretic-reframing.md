Here is the clean information-theoretic reframing:

> **The primitive is not matter, force, spacetime, or mass.
> The primitive is finite quantum information: pure directional messages, finite registers, coherent path sums, and the loss or protection of distinguishability.
> Mass is the amount of hidden which-direction information that remains visible as mixedness after null alternatives are coarse-grained.**

In this language, the whole theory becomes a finite quantum information theory of **coherence, compression, and obstruction**. The uploaded framework’s kernel-checked pieces already point this way: Plücker mass is null-direction disagreement; mass is also visible entropy and concurrence; the carrier square decomposes into channels; Schur decimation creates effective mass by integrating out hidden null structure; and path/evolution/ensemble scaffolds are finite rather than continuum-first. 

## 1. Replace “particle” with “information pattern”

The fundamental object is a finite information system:

[
\mathcal I
==========

(K,\mathcal H_{\mathrm{dir}},\mathcal H_{\mathrm{int}},
\mathcal A,\mathcal G,\mathcal P).
]

Here:

[
K
]

is a finite graph or 2-complex of possible information flow.

[
\mathcal H_{\mathrm{dir}}\cong \mathbb C^2
]

is the **direction register**. A null edge is a pure qubit-like ray

[
[\psi]\in \mathbb{CP}^1.
]

[
\mathcal H_{\mathrm{int}}
]

contains internal bookkeeping: chirality, color, weak charge, generation labels, path labels, constraint labels.

[
\mathcal A
]

is the finite amplitude rule: it assigns a complex amplitude or operator to every elementary move.

[
\mathcal G
]

is gauge redundancy: different internal descriptions may encode the same physical message.

[
\mathcal P
]

is the positive physical code subspace: the sector where Born probabilities and mass eigenvalues become meaningful.

So a particle is not a point object. It is a **stable codeword** in this finite information system.

A massless particle is a codeword whose visible direction register remains pure.

A massive particle is a codeword whose hidden information cannot be compressed into a single visible null direction.

## 2. Null edges are pure directional messages

A null edge is a pure message:

[
\rho_\psi
=========

\frac{|\psi\rangle\langle \psi|}
{\langle \psi|\psi\rangle}.
]

It has rank one. It carries one projective direction. Information-theoretically, it is maximally coherent in the visible direction register.

A bundle of null alternatives gives an unnormalized visible density matrix

[
P
=

\sum_i w_i |\psi_i\rangle\langle\psi_i|.
]

After normalization,

[
\rho
====

\frac{P}{\mathrm{Tr}(P)}.
]

Now the entire mass story becomes a statement about the mixedness of (\rho).

If all (\psi_i) point in the same projective direction, then

[
\rho
]

is still rank one. The bundle is massless.

If the (\psi_i) do not agree, then (\rho) has rank two. The visible observer sees a mixed directional state. That mixedness is mass.

The Plücker identity becomes:

[
\det P
======

\sum_{i<j} w_iw_j |\psi_i\wedge\psi_j|^2.
]

So:

[
\boxed{
\text{mass}^2
=============

\text{total pairwise distinguishability of null messages}
}
]

or, in density-language,

[
\boxed{
\text{mass}
===========

\text{visible mixedness caused by hidden null-direction information}.
}
]

For a two-level visible system,

[
\det \rho
=========

\frac{1-\mathrm{Tr}(\rho^2)}{2}.
]

Thus mass is equivalent to linear entropy, and the framework’s stronger two-edge result says it is also concurrence squared. That means mass is not merely “like” information. In the finite two-edge case, it is an entanglement monotone in disguise.

## 3. “Speed of light” becomes “rank-one information flow”

In the information version, “lightlike” means:

[
\rho_{\mathrm{dir}}
\text{ remains pure under propagation.}
]

Nothing fundamental is slow. Every elementary message is pure and rank one. Subluminal motion appears only after a visible observer compresses several incompatible rank-one messages into one effective state.

So ordinary massive motion is not primitive motion. It is the coarse-grained behavior of a hidden coherent computation.

A rest state is the extreme case where the visible direction register is maximally mixed:

[
\rho_{\mathrm{rest}}
====================

\frac12 I.
]

So “rest” is not absence of motion. It is maximum hidden directional disagreement after compression.

This gives the information-theoretic reading of proper time:

[
\boxed{
\text{proper time is entropy accumulated by hidden null information.}
}
]

A null edge does not age because its visible direction state is pure. A massive system ages because its visible state has irreducible mixedness.

## 4. Finite path sums are coherent information sums

Now include path sums.

Let (x,y) be boundary vertices. Let

[
\mathrm{Path}(x,y)
]

be the finite set of directed histories from (x) to (y). A history

[
h=(e_1,e_2,\ldots,e_n)
]

has amplitude operator

[
A(h)
====

T_{e_n}\cdots T_{e_2}T_{e_1},
]

where each elementary gate may include:

[
T_e = c(\alpha_e)\nabla_e
]

for a null edge transport, and

[
T_v = \Gamma\phi
]

for a chirality-changing turn.

The total finite propagator is the coherent path sum

[
K(y,x)
======

\sum_{h:x\to y} A(h).
]

This is the information-theoretic path integral. It is a finite tensor contraction, not a continuum measure.

The crucial distinction is:

[
\text{coherent sum:}
\qquad
\rho\mapsto
K\rho K^\dagger,
]

versus

[
\text{incoherent path mixture:}
\qquad
\rho\mapsto
\sum_h A(h)\rho A(h)^\dagger.
]

The first erases path labels before probabilities are formed. The second leaks which-path information to an environment or hidden register.

Mass appears when hidden path information leaves distinguishable traces in the visible direction register.

## 5. The key object: the path-conditioned visible state

A fully information-theoretic version should introduce a path register:

[
|h\rangle_{\mathrm{path}}.
]

A boundary state after all histories is

[
|\Psi\rangle
============

\sum_h a_h
|\psi_h\rangle_{\mathrm{dir}}
\otimes
|\chi_h\rangle_{\mathrm{int}}
\otimes
|h\rangle_{\mathrm{path}}.
]

The observer does not usually see (\chi_h) or (h). So the visible direction state is

[
\rho_{\mathrm{dir}}
===================

\mathrm{Tr}_{\mathrm{int,path}}
|\Psi\rangle\langle\Psi|.
]

Expanding:

[
\rho_{\mathrm{dir}}
===================

\sum_{h,h'}
a_h\overline{a_{h'}}
\langle \chi_{h'}|\chi_h\rangle
\langle h'|h\rangle
|\psi_h\rangle\langle\psi_{h'}|.
]

This formula contains the whole theory.

If the hidden records are fully erased, then

[
\langle h'|h\rangle\approx 1,
]

and histories interfere coherently.

If the hidden records are perfectly distinguishable, then

[
\langle h'|h\rangle=\delta_{hh'},
]

and the visible state becomes

[
\rho_{\mathrm{dir}}
===================

\sum_h |a_h|^2
|\psi_h\rangle\langle\psi_h|.
]

Then mass is exactly the determinant/mixedness of this path-conditioned directional ensemble.

So the core slogan becomes sharper:

[
\boxed{
\text{mass is retained which-direction information after hidden histories are traced out.}
}
]

Not merely which-path information. More specifically: **which-null-direction information**.

## 6. Superposition explains why mass can cancel

Because path sums are coherent, mass is not simply additive.

Two histories may individually carry direction disagreement, but their amplitudes can interfere destructively. Conversely, histories that look individually null may produce a massive effective state after hidden labels are forgotten.

This resolves a major conceptual tension.

An incoherent mixture tends to increase visible entropy:

[
\rho = \sum_h p_h \rho_h.
]

A coherent superposition can reduce or cancel it:

[
|\Psi\rangle=\sum_h a_h|\psi_h\rangle.
]

That is why the closure channel must be signed. It is not a positive entropy term. It is a coherent phase-sensitive contribution. It can raise, lower, or cancel the visible mass gap.

Information-theoretically:

[
\text{positive gauge energy}
\neq
\text{signed coherent mass contribution}.
]

The Wilson/defect norm is an information cost of nonclosure. The chromomagnetic closure channel is an interference term in the mass spectrum.

## 7. The four force-shaped channels become four information defects

The carrier square

[
D^#D
]

is the quadratic information cost of the finite update rule. The four channels are four different failures of information coherence.

### Aperture: distinguishability of outgoing null messages

Aperture measures how much the local information flow opens into more than one visible direction.

[
Q_A
\sim
{\nabla,\nabla}.
]

Information reading:

[
\boxed{
Q_A =
\text{ordinary directional distinguishability cost}.
}
]

It is the finite analogue of kinetic information: how much spread appears in the visible direction register.

### Closure: path memory around loops

Closure measures failure of transport around a loop to return the same internal message.

[
Q_C
\sim
[\gamma,\gamma][\nabla,\nabla].
]

Information reading:

[
\boxed{
Q_C =
\text{loop memory / holonomy / contextual path information}.
}
]

A flat loop erases path memory. A curved loop stores path memory. That memory can change interference signs, so the closure contribution to mass is signed.

This is why binding is possible.

### Turn: chirality-register conversion

The turn field

[
\Gamma\phi
]

is a gate that couples otherwise separated information sectors.

Information reading:

[
\boxed{
Q_T =
\text{cost of converting one protected register into another}.
}
]

Left and right chirality are separate code sectors. A turn is an allowed transition between them. The Higgs/Yukawa interpretation becomes: the Higgs is the background information resource that allows the chirality-changing gate to exist.

Mass from turns is not “stuff added.” It is the spectral consequence of allowing formerly independent null channels to communicate.

### Soldering: drift of the codebook itself

Soldering tells the system how local direction symbols are compared between neighboring sites.

Information reading:

[
\boxed{
E =
\text{failure of neighboring observers to share the same directional codebook}.
}
]

Gauge curvature changes internal labels while preserving the local direction codebook.

Soldering curvature changes the codebook used to compare directions.

So gravity becomes an information-synchronization defect:

[
\boxed{
\text{gravity is failure to globalize the null-direction dictionary}.
}
]

## 8. Krein structure becomes pre-probabilistic bookkeeping

The raw carrier space is not automatically a physical Hilbert space. It is an indefinite information ledger.

That is not a bug. It means the formal amplitude space contains redundant, gauge, ghost, and constraint data before physical decoding.

The physical process is:

[
\text{raw amplitude space}
\longrightarrow
\text{constraint kernel}
\longrightarrow
\text{quotient by null/gauge directions}
\longrightarrow
\text{positive code subspace}.
]

Only after this quotient does the state become a valid probabilistic message.

Thus:

[
\boxed{
\text{a particle is a positive-sector codeword}.
}
]

This gives a purely information-theoretic version of confinement.

A colored algebraic excitation may exist in the raw amplitude space, but it may fail to define an isolated positive codeword. It is not a valid message by itself. A color singlet is a composite codeword that survives the quotient.

So confinement becomes:

[
\boxed{
\text{non-singlets are non-decodable messages; singlets are valid codewords}.
}
]

## 9. Schur decimation is lossy compression

The Schur complement is the information-theoretic operation:

[
\text{hide an internal node and ask what effective channel remains}.
]

If the visible system couples to a hidden block (M), then integrating out the hidden register produces an effective coupling

[
c(\ell)M^{-1}c(n).
]

Information reading:

[
\boxed{
M^{-1}
======

\text{hidden-channel memory kernel}.
}
]

The hidden block transmits information between two visible null directions. If that transmitted information connects non-collinear directions, the effective edge is no longer null.

So coarse-graining creates mass exactly when hidden information preserves non-collinear directional memory.

If the directions are collinear, the effective mass term vanishes.

This gives the cleanest information-theoretic version of mass generation:

[
\boxed{
\text{mass is what appears when lossy compression cannot erase hidden directional disagreement}.
}
]

It also gives a seesaw-like mechanism. If the hidden block is heavy or high-cost, then

[
M^{-1}
]

is small, so the visible mass induced by hidden leakage is suppressed:

[
m_{\mathrm{eff}}
\sim
\frac{\text{visible-hidden coherence overlap}^2}
{\text{hidden information cost}}.
]

That is the natural information-theoretic route to very small masses.

## 10. Binding is compression advantage

A free composite has a naive mass cost:

[
m^2_{\mathrm{free}}
===================

\text{sum of visible constituent disagreement costs}.
]

A bound composite has coherent closure information that lowers the spectral cost:

[
m^2_{\mathrm{bound}}
====================

m^2_{\mathrm{free}}+\Delta,
\qquad
\Delta<0.
]

Information reading:

[
\boxed{
\text{binding is a compression advantage produced by coherent loop information}.
}
]

A bound state is a better code than its separated constituents. It stores the same external information with lower visible mass cost.

This reframes “binding energy”:

It is not extra glue-stuff.

It is the difference between two encodings of the same information: separated codewords versus a joint codeword.

The joint codeword can be cheaper because coherent closure phases cancel some visible directional disagreement.

## 11. Path sums turn particles into finite quantum automata

The whole finite theory can be presented as a quantum automaton.

At each step, the automaton updates registers:

[
|\text{vertex},\text{direction},\text{internal}\rangle
\mapsto
\sum_{\text{next}}
A_{\text{step}}
|\text{next vertex},\text{next direction},\text{next internal}\rangle.
]

The local gates are:

[
\text{null step},
\qquad
\text{turn},
\qquad
\text{internal transport},
\qquad
\text{soldering comparison}.
]

The finite path sum is the sum over all automaton histories.

The Dirac operator (D) is the finite constraint/update rule.

The square (D^#D) is the information-cost operator.

The spectrum of (D^#D) on the positive code sector gives possible stable masses.

Thus the ontology becomes:

[
\boxed{
\text{particle}
===============

\text{stable eigen-code of a finite quantum automaton}.
}
]

## 12. Scattering is information transmission through a mass code

A finite mass barrier is an information-processing region that converts pure directional messages into mixed or rotated ones.

Transmission means the incoming directional information survives.

Reflection means the code redirects it.

Absorption or binding means the information is stored in internal/path registers.

So the finite scattering picture becomes:

[
S:
\mathcal H_{\mathrm{in}}
\to
\mathcal H_{\mathrm{out}}.
]

Unitarity says information is conserved globally.

Mass says information is not conserved in the visible direction register alone.

A massless region is transparent because it preserves projective coherence.

A massive region scatters because it entangles direction with hidden turn/path/internal records.

So:

[
\boxed{
\text{mass is an index of refraction for quantum directional information}.
}
]

## 13. The Standard Model becomes a catalogue of information codes

In this framing, the Standard Model is not primarily a list of particles and forces. It is a classification of stable code sectors.

| Usual language    | Information-theoretic language                                |
| ----------------- | ------------------------------------------------------------- |
| Particle          | Positive-sector stable codeword                               |
| Mass              | Visible mixedness / null-direction distinguishability         |
| Gauge charge      | Internal label preserved by allowed code transformations      |
| Gauge field       | Path-dependent internal relabeling rule                       |
| Curvature         | Loop memory / non-erased path information                     |
| Higgs/Yukawa      | Chirality-register coupling gate                              |
| Gravity/soldering | Drift of the directional codebook                             |
| Confinement       | Failure of non-singlet messages to decode positively          |
| Bound state       | Joint codeword with compression advantage                     |
| Massless particle | Rank-one, protected, or quotient-null codeword                |
| Generation        | Inequivalent positive-sector encoding of same external labels |

This is the cleanest version of “unification is decomposition”:

[
\boxed{
\text{forces are the four canonical information defects in a finite null-code.}
}
]

They are not unified by being identical. They are unified because they are all terms in the same information-cost square.

## 14. The role of superposition: mass is not ignorance alone

A subtle but important point:

Mass is not classical ignorance.

A classical mixture of directions certainly gives visible mass. But the theory is quantum-information-theoretic, so the deeper object is not a probability distribution. It is the **coherence matrix** among histories:

[
\Omega_{hh'}
============

\langle E_{h'}|E_h\rangle.
]

Then

[
\rho_{\mathrm{dir}}
===================

\sum_{h,h'}
a_h\overline{a_{h'}}
\Omega_{hh'}
|\psi_h\rangle\langle\psi_{h'}|.
]

The limits are:

[
\Omega_{hh'}=1
\quad
\Rightarrow
\quad
\text{fully coherent path sum},
]

[
\Omega_{hh'}=\delta_{hh'}
\quad
\Rightarrow
\quad
\text{fully decohered path mixture}.
]

Mass depends on how much of the off-diagonal coherence survives.

Therefore:

[
\boxed{
\text{mass measures failure of coherent compression, not mere lack of knowledge}.
}
]

That is why signed closure can reduce mass. It restores or reorganizes coherence. It is not just adding noise.

## 15. Naturalness becomes protection of low-rank information

Small masses are natural only when the visible direction state is kept nearly rank one by a structural reason.

There are three information-theoretic mechanisms:

### 1. Projective protection

All path-conditioned directions remain nearly collinear:

[
|\psi_h\wedge\psi_{h'}|^2\approx 0.
]

The visible state is nearly pure.

### 2. Index protection

The code has an unpaired chiral sector. No allowed gate can create the missing partner. The massless state is protected by a finite index.

### 3. Critical cancellation

Aperture and closure cancel:

[
\lambda-\kappa\approx 0.
]

The code is not trivially pure, but the spectral information cost is small because signed loop memory cancels directional spread.

Thus:

[
\boxed{
\text{a small mass is a near-rank-one code, an index-protected code, or a critically cancelled code}.
}
]

Anything else is unstable.

## 16. Time, thermodynamics, and RG become data processing

Renormalization is repeated lossy compression:

[
\mathcal I_0
\to
\mathcal I_1
\to
\mathcal I_2
\to
\cdots
]

Each step traces out hidden vertices, path labels, or internal registers.

The data-processing principle says visible information cannot increase under ordinary coarse-graining. But the visible mass can increase because mass is not total information; it is **visible mixedness**.

So coarse-graining can convert hidden pure structure into visible entropy.

That is the information-theoretic statement behind emergent mass.

A massless fixed point is a code stable under compression:

[
\rho_{\mathrm{dir}}
\mapsto
\rho_{\mathrm{dir}}
\quad
\text{rank one}.
]

A massive phase is a compression flow toward a mixed visible direction state.

A bound phase is a compression flow where coherent closure reduces the visible cost.

A critical phase is a flow to the boundary between pure and mixed directional coding.

## 17. The deepest reformulation

The whole theory can be compressed to this:

[
\boxed{
\textbf{Mass is the obstruction to representing a finite quantum history ensemble by one pure null-direction message.}
}
]

Equivalently:

[
\boxed{
m^2
===

# \text{area of the visible direction density matrix}

# \text{entanglement of null alternatives}

\text{entropy created by hiding path information}.
}
]

The path-sum version is:

[
\boxed{
\text{finite physics}
=====================

\sum_{\text{histories}}
\text{amplitude}
\quad
\longrightarrow
\quad
\text{trace hidden records}
\quad
\longrightarrow
\quad
\text{visible rank, entropy, and spectrum}.
}
]

The force-channel version is:

[
\boxed{
D^#D
====

\text{directional distinguishability}
+
\text{loop memory}
+
\text{chirality conversion}
+
\text{codebook drift}.
}
]

The particle version is:

[
\boxed{
\text{particle}
===============

\text{stable positive-sector codeword of this finite information process}.
}
]

And the most compact information-theoretic slogan is:

> **Matter is compressed lightlike information.
> Mass is the mixedness left over when the compression cannot be made coherent.**
