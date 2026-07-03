# A Treatise on Null-Edge Relativistic Dynamics

## 0. Status and intent

This is not a claim that the theory is complete. It is a synthesis of the strongest version of the NullStrand/null-edge ideas so far:

[
\boxed{
\text{microscopic transport is null; time, mass, phase, and geometry are relational node/composite effects.}
}
]

The best version does **not** try to replace proven lattice-chiral machinery with a novel fragile operator. It uses null-edge geometry for kinematics and path-combinatorics, while using overlap/Ginsparg-Wilson machinery for the chiral fermion release. That distinction is central to the current Gate C1 architecture: (H_{\rm ne}) is the primitive Hermitian sign kernel, and (D_{\rm ov,ne}) is a derived release operator only after Hermiticity and a true spectral gap are proved. 

The speculative leap is to extend this into quantum gravity: the null-edge graph is not merely a regulator laid over spacetime; it may be the pre-geometric substrate from which spacetime, curvature, proper time, gauge fields, and matter emerge.

---

# I. The core physical principle

## 1. Null edges do not age; nodes create clocks

A single null edge has zero proper time:

[
e^2=0.
]

So a primitive null strand does not carry a self-clock. But a composite of null strands can be timelike. If

[
X=\sum_{j=1}^N e_j,
\qquad e_j^2=0,
]

then

[
X^2
===

# \sum_j e_j^2+2\sum_{i<j}e_i\cdot e_j

2\sum_{i<j}e_i\cdot e_j.
]

Thus the effective timelike interval is made entirely from **cross terms** between null edges:

[
\boxed{
\text{proper time is not on an edge; it is in the relation between edges.}
}
]

For the tetrahedral null directions,

[
e_A=a(1,\mathbf v_A),
\qquad
\mathbf v_A\cdot\mathbf v_B=-\frac13\quad(A\ne B),
]

one finds

[
(e_A+e_A)^2=0,
]

but for (A\ne B),

[
(e_A+e_B)^2
===========

# 2e_A\cdot e_B

-\frac83a^2.
]

So a straight null continuation remains null, while a turn creates an effective proper-time increment:

[
\tau_{AB}=a\sqrt{\frac83}.
]

This is the key interpretive principle:

[
\boxed{
\text{massive behavior arises from null transport plus relational node time.}
}
]

This is deeply aligned with the Feynman checkerboard idea: in the (1+1)-dimensional checkerboard, the particle moves along lightlike steps, while mass enters through amplitudes associated with turns; modern summaries of the checkerboard describe the Dirac propagator as emerging from weighted sums over lightlike lattice paths. ([arXiv][1])

---

# II. The corrected stay/move principle

The strongest version of the stay idea is not “allow primitive timelike edges.”

It is:

[
\boxed{
\text{all nontrivial spatial transport is null; local onsite internal evolution is allowed.}
}
]

This matches the current stay-move decision memo: a primitive timelike edge ((\Delta t,\Delta x)=(1,0)) would weaken the null-edge claim, but a local onsite coin/rest/internal operation can encode mass, phase, chirality mixing, Wilson branch mass, internal finite Dirac data, or Higgs/Yukawa-like structure without becoming a new spacetime transport edge. 

So the microscopic update should have two layers:

[
\text{null transport layer}
\quad+\quad
\text{onsite fiber/node layer}.
]

Symbolically,

[
D
=

D_{\rm null}
+
E_{\rm onsite}.
]

For a unitary quantum walk,

[
U=S_{\rm null}C_{\rm local}.
]

For an inverse-propagator/sign-kernel theory,

[
H=\gamma_5(D_{\rm null}+E_{\rm onsite}-\rho/a).
]

Quantum-walk and quantum-cellular-automaton work gives a useful precedent: discrete-time Dirac automata can be formulated in terms of transition matrices and path-integral sums where a mass parameter enters locally rather than as ordinary continuous proper-time aging along a path. ([arXiv][2])

---

# III. The matter sector: null-edge overlap fermions

## 1. The primitive kernel

On a fixed null-edge background, define gauge-covariant shifts

[
(T_A[U]\psi)(x)=U_A(x)\psi(x+e_A).
]

The centered null-edge Dirac seed is

[
D_{\rm ne}^0[U]
===============

\sum_A B_A
\frac{T_A[U]-T_A[U]^\dagger}{2a}.
]

The Wilson branch-mass term is

[
W_{\rm ne}[U]
=============

\frac{r}{2a}
\sum_A
\left(2-T_A[U]-T_A[U]^\dagger\right).
]

The Hermitian sign kernel is

[
\boxed{
H_{\rm ne}[U]
=============

\gamma_5
\left[
D_{\rm ne}^0[U]
+
W_{\rm ne}[U]
+
M_{\rm br}[U]
-------------

\rho/a
\right].
}
]

Here (M_{\rm br}) is a fallback branch/flavored mass term, initially set to zero.

The overlap release is derived only after (H_{\rm ne}) is self-adjoint and gapped:

[
\boxed{
D_{\rm ov,ne}
=============

\frac{\rho}{a}
\left(1+\gamma_5,{\rm sign}(H_{\rm ne})\right).
}
]

This is the safe bridge to known chiral lattice fermion theory. Lüscher showed that the Ginsparg-Wilson relation gives an exact lattice form of chiral symmetry and avoids the usual Nielsen-Ninomiya contradiction because chiral symmetry is realized differently on the lattice. ([arXiv][3]) Neuberger’s overlap construction and the locality theorem of Hernández-Jansen-Lüscher supply the template for a chiral, doubler-safe, exponentially local sign-kernel architecture under suitable gauge smoothness assumptions. ([arXiv][4])

## 2. The tetrahedral free kernel

The current first free model uses four future null directions

[
n_A=(1,\mathbf v_A),
]

where the (\mathbf v_A) are tetrahedral vertices. The soldering matrices are

[
B_A
===

\frac14\gamma_4+\frac34 v_A^i\gamma_i.
]

The free symbol is

[
H_{\rm tet}(k)
==============

\gamma_5
\left[
\frac{i}{a}\sum_A B_A\sin k_A
+
\frac1a
\left(
r\sum_A(1-\cos k_A)-\rho
\right)
\right].
]

The branch window is

[
\boxed{
r>0,\qquad 0<\rho<2r.
}
]

At a branch corner with (n) of the (k_A) equal to (\pi),

[
m_n=2rn-\rho.
]

Thus

[
m_0=-\rho<0,
]

while

[
m_n>0\qquad(n=1,\dots,4).
]

This is the overlap branch-selection condition: the physical branch is selected; the doubler branches are lifted by inverse-propagator gaps, not by propagator zeros.

## 3. The key free gap theorem

Define

[
Q(k)=\sum_A B_A\sin k_A,
]

[
M(k)=r\sum_A(1-\cos k_A)-\rho.
]

The Euclidean Clifford/coframe identity is

[
Q(k)^2
======

\left[
\frac34\sum_A\sin^2 k_A
-----------------------

\frac18
\left(\sum_A\sin k_A\right)^2
\right]I.
]

Hence

[
Q(k)^2
\ge
\frac14
\sum_A\sin^2 k_A,I.
]

The squared sign kernel has the scalar lower-bound structure

[
H_{\rm tet}(k)^\dagger H_{\rm tet}(k)
=====================================

\frac1{a^2}
\left[
q(k)+M(k)^2
\right]I.
]

In the first Wilson band (0<\rho<2r), this coefficient is uniformly positive over the tetrahedral Brillouin torus. Your Lean stack is now moving from this symbol-level statement to the finite/free operator gap through a unitary Fourier block diagonalization. That is exactly the right next C1 path.

---

# IV. Why overlap/GW is essential

The null-edge idea alone does not solve chiral doubling. In fact, the bare retarded seed is chirality-balanced. Scalar Wilson shifts cannot directly turn a balanced origin kernel into a one-handed Weyl release. The safe architecture is:

[
\text{null-edge seed}
\to
\text{Hermitian Wilson-like sign kernel}
\to
\text{overlap/GW release}
\to
\text{Weyl projectors}.
]

This is not a retreat from null-edge physics. It is the way to make the null-edge program inherit the part of lattice chiral fermion theory that already works.

The Ginsparg-Wilson relation is

[
D\gamma_5+\gamma_5D
===================

\frac{a}{\rho}D\gamma_5D.
]

The associated chiral involution is

[
\widehat\gamma_5
================

# \gamma_5\left(1-\frac{a}{\rho}D_{\rm ov}\right)

-{\rm sign}(H).
]

The Weyl projectors are then

[
\widehat P_\pm=\frac{1\pm\widehat\gamma_5}{2}.
]

This is the mathematical release mechanism. The null-edge structure supplies the geometric/path-combinatorial kernel; the overlap sign function supplies the chiral release.

---

# V. Gauge fields and internal structure

Gauge fields live most naturally as edge holonomies:

[
U_e\in G_{\rm gauge}.
]

A matter field is a section over nodes:

[
\psi_v\in S_v\otimes R_v,
]

where (S_v) is a spinor/fiber space and (R_v) is an internal representation.

Gauge-covariant null transport is

[
\psi_v
\mapsto
U_e\psi_{t(e)}.
]

Curvature is encoded by holonomy around loops:

[
U_{\partial f}=\prod_{e\in\partial f}U_e.
]

The gauge action is a sum over plaquette/loop terms or, more generally, over elementary cycles in the null-edge complex.

The internal finite geometry can enter onsite:

[
E_{\rm onsite}
==============

D_F
+
Y(\phi)
+
M_{\rm regulator}.
]

This is where Higgs/Yukawa structure, finite Dirac operators, flavor texture, and possible division-algebra structure belong. They should **not** be used to solve spacetime doubling. CKM/flavor structure may decorate the internal sector, but C1 doubler removal remains an overlap/GW spacetime-kernel problem.

---

# VI. The octonionic and E8 envelope

The best version of the octonionic idea is not to immediately make spacetime eight-dimensional. It is:

[
\boxed{
\text{visible }3+1\text{ spacetime is a quaternionic projection of a larger internal/null envelope.}
}
]

Let the full microscopic displacement be

[
\Delta X=(\Delta t,\Delta\mathbf x,\Delta\mathbf y),
]

where

[
\mathbf x\in{\rm Im},\mathbb H,
\qquad
\mathbf y\in\mathbb H^\perp\subset\mathbb O.
]

The full null condition is

[
-\Delta t^2+|\Delta\mathbf x|^2+|\Delta\mathbf y|^2=0.
]

The visible projection has interval

[
-\Delta t^2+|\Delta\mathbf x|^2
===============================

-|\Delta\mathbf y|^2\le0.
]

Thus:

[
\Delta\mathbf y=0
\Rightarrow
\text{visible null step},
]

[
\Delta\mathbf y\ne0
\Rightarrow
\text{visible timelike step},
]

[
\Delta\mathbf x=0,\ |\Delta\mathbf y|=\Delta t
\Rightarrow
\text{visible stay/rest from hidden null motion}.
]

This gives a beautiful interpretation of mass: a particle that is null in the full internal-envelope space can appear massive in (3+1) dimensions because internal momentum contributes to the visible mass shell:

[
0=-E^2+|\mathbf p|^2+|\mathbf p_{\rm int}|^2
]

becomes

[
E^2-|\mathbf p|^2
=================

# |\mathbf p_{\rm int}|^2

m^2.
]

Octonions and division algebras have real links to Standard Model algebra programs. Furey’s work studies (\mathbb R\otimes\mathbb C\otimes\mathbb H\otimes\mathbb O) as a possible source of Standard Model particle structure, and later division-algebraic work analyzes symmetry-breaking cascades related to octonionic/quaternionic/complex structures. ([arXiv][5])

But the warning is severe: octonions are nonassociative. The overlap sign function requires an associative Hilbert-space operator algebra. So octonions should enter through represented left/right multiplication operators, Clifford algebras, matrix algebras, or carefully controlled Jordan structures — not as raw nonassociative “operators” inside ({\rm sign}(H)).

---

# VII. Geometry from null data

A Lorentzian metric is strongly tied to causal/null structure. Causal structure determines the conformal metric under suitable causality conditions, while an additional volume/conformal-factor datum fixes the full metric. ([McGill School of Computer Science][6])

This suggests the geometric reconstruction rule:

[
\boxed{
\text{null cones give the conformal metric; node density/volume data give the scale.}
}
]

In the null-edge theory, each node carries a local null frame:

[
{n_A(v)}.
]

The null directions reconstruct a local conformal Lorentzian structure. The density of nodes, cell volume, or determinant of a discrete tetrad reconstructs the conformal factor.

So the geometric variables should be:

[
\mathcal G
==========

(\text{nodes},\text{oriented null edges}, n_e^a, \ell_e, \omega_e, V_v).
]

Here (n_e^a) is a null direction, (\ell_e) a scale/weight, (\omega_e) a spin connection/parallel transport datum, and (V_v) a local volume density.

The continuum tetrad emerges from coarse moments:

[
\sum_A w_A B_A n_A^\mu
\sim
\gamma^\mu,
]

or geometrically,

[
g^{\mu\nu}
\sim
\sum_{A,B}C^{AB}n_A^\mu n_B^\nu.
]

The current tetrahedral model is the flat, fixed-background version of this reconstruction.

---

# VIII. Gravity as dynamics of null-edge geometry

To unify with general relativity, the null-edge graph must eventually become dynamical.

The gravitational path integral should sum over:

[
\sum_{\mathcal G}
\int D\omega,DU,D\psi,D\bar\psi,
e^{iS[\mathcal G,\omega,U,\psi]}.
]

The action should split schematically as

[
S
=

S_{\rm grav}[\mathcal G,\omega]
+
S_{\rm gauge}[\mathcal G,U]
+
S_{\rm fermion}[\mathcal G,\omega,U,\psi]
+
S_{\rm node}[\mathcal G,\psi].
]

The gravitational term may be Regge-like or spin-foam-like:

[
S_{\rm grav}
\sim
\sum_{\text{hinges }h}
A_h,\epsilon_h,
]

where curvature is encoded in deficit angles or connection holonomies. Regge calculus is the standard discretization of classical general relativity on piecewise-flat complexes; spin-foam models and group-field-theory developments build quantum-gravity amplitudes from related discrete geometric data. ([arXiv][7])

A causal version should preserve oriented null/causal structure, more like causal dynamical triangulations or causal-set theory than Euclidean random triangulations. CDT is a nonperturbative lattice regularization of the gravitational sum over histories that keeps causal structure in the construction. ([arXiv][8]) Causal set theory similarly treats discreteness and causality as primitive by replacing the continuum with locally finite partial orders; Surya’s review emphasizes that causal sets encode both causality and discreteness and are rooted in Lorentzian structure. ([arXiv][9])

The null-edge proposal differs from causal sets by retaining explicit edge-local transport and spin/gauge/path amplitudes. It differs from Regge/CDT by making **null transport** and **node phase** primitive. It differs from conventional lattice QFT by allowing the graph itself to become dynamical.

---

# IX. The unification mechanism

The proposed unification has three limits.

## 1. Fixed flat graph limit: lattice QFT

On a fixed tetrahedral null-edge crystal:

[
\mathcal G=\Lambda_H,
]

the theory reduces to a null-edge overlap lattice fermion theory plus gauge holonomies.

This is the Gate C1 domain.

The target theorem is:

[
H_{\rm tet}
\text{ is self-adjoint and gapped}
\Rightarrow
D_{\rm ov,tet}
\text{ satisfies GW and has no mirror poles.}
]

## 2. Fixed curved graph limit: QFT in curved spacetime

On a slowly varying null-edge background:

[
n_A(v),\quad V_v,\quad \omega_e
]

define an approximate tetrad and spin connection.

Then the fermion kernel becomes a lattice Dirac operator on a curved background:

[
D_{\rm ne}[\mathcal G,\omega,U]
\to
\gamma^a e_a^\mu(\nabla_\mu+A_\mu).
]

The overlap sign still controls chirality if the curved/background kernel remains gapped and local.

## 3. Dynamical graph limit: quantum gravity

When (\mathcal G) is summed over, QFT no longer lives on a fixed background. It is part of the same sum as geometry:

[
Z
=

\sum_{\mathcal G}
\int
D\omega,DU,D\psi,
e^{i(S_{\rm grav}+S_{\rm matter})}.
]

Classical general relativity should emerge as the saddle point or coarse-grained hydrodynamic limit:

[
\delta S_{\rm eff}/\delta g_{\mu\nu}=0
\Rightarrow
G_{\mu\nu}=8\pi G,T_{\mu\nu}.
]

Quantum field theory emerges as fluctuations of matter on a semiclassical geometric phase. Gravity is not quantized on top of QFT; both are phases of the same null-edge amplitude system.

That is the unification claim.

---

# X. Node phase, energy, and mass

At a node where null momenta (p_i) meet, define total momentum

[
P=\sum_i p_i.
]

If (P) is timelike, it defines a local node frame:

[
u_{\rm node}=\frac{P}{\sqrt{-P^2}}.
]

Then the energy of edge (p_i) relative to the node is

[
E_i=-p_i\cdot u_{\rm node}.
]

So energy is not “proper-time frequency along a null edge.” It is **node-relative phase frequency**.

A node amplitude can therefore be written as

[
C_{BA}
======

\exp[-iS_{BA}],\mathcal C_{BA},
]

with

[
S_{BA}=m,\tau_{BA}
]

or more generally

[
S_{BA}=f(e_A\cdot e_B,\text{spin},\text{internal data}).
]

For tetrahedral turns,

[
\tau_{BA}=0\quad(A=B),
]

[
\tau_{BA}=a\sqrt{\frac83}\quad(A\ne B).
]

Thus mass and phase are attached to turns/nodes/onsite fibers, not to null-edge aging.

This provides a path-combinatorial explanation of massive propagation:

[
\boxed{
\text{massive particles are statistical/quantum envelopes of null-edge histories with node phases.}
}
]

---

# XI. Locality and non-ultralocality

The primitive seed may be finite-range, but the overlap release is not ultralocal. That is acceptable.

The correct locality requirement is exponential or controlled quasi-local decay:

[
|D_{\rm ov}(x,y)|
\le
C e^{-\alpha d(x,y)}.
]

Hernández-Jansen-Lüscher proved locality for Neuberger’s operator under sufficiently smooth gauge fields; the null-edge version should eventually imitate that theorem with the graph distance defined by null-edge paths. ([arXiv][4])

This is conceptually natural: the sign function has a path-sum expansion,

[
{\rm sign}(H)
=============

H(H^2)^{-1/2},
]

which can be represented through rational, Chebyshev, resolvent, or domain-wall transfer expansions. Since (H) is built from null-edge shifts and onsite node terms, powers of (H) expand into weighted sums over null-edge histories. The spectral gap controls convergence and decay.

Thus:

[
\boxed{
\text{overlap non-ultralocality becomes a controlled null-edge path sum.}
}
]

---

# XII. The Standard Model sector

The Standard Model target requires:

1. (3+1)-dimensional Weyl fermions.
2. Gauge group representations.
3. Anomaly cancellation.
4. Higgs/Yukawa structure.
5. No mirror leakage.
6. Positive Hilbert-space unitarity.
7. A continuum limit.

The safest route is:

[
\text{null-edge overlap Dirac operator}
\to
\text{GW chiral projectors}
\to
\text{anomaly-free Weyl multiplet}.
]

The free theorem may have zero global index. That is fine. The free C1 goal is not “nonzero index in vacuum.” It is:

[
\text{one physical branch, no mirror branch, valid GW Weyl projectors.}
]

The nonzero index appears in nontrivial gauge/topological backgrounds:

[
{\rm index}(D_{\rm ov})
=======================

\frac12{\rm Tr},\widehat\gamma_5.
]

The Standard Model measure/anomaly problem is a later gate. Lüscher’s work gives the framework for exact lattice chiral symmetry and lattice chiral gauge theory construction, but the null-edge Standard Model must still pass its own anomaly and determinant-line audits. ([arXiv][3])

---

# XIII. How general relativity enters the fermion operator

The Dirac operator contains geometry. In the continuum,

[
D=\gamma^a e_a^\mu(\partial_\mu+\omega_\mu+A_\mu).
]

In the null-edge theory, the corresponding data are:

[
B_A(v)
\quad
\text{and}
\quad
T_A[\omega,U].
]

The (B_A(v)) encode the local soldering of null directions to spinors. The shifts (T_A) encode parallel transport through spin and gauge connections. Thus geometry enters not as a background metric first, but through the **transport operator**.

This suggests a spectral-geometric principle:

[
\boxed{
\text{geometry is what the null-edge Dirac operator knows how to transport.}
}
]

The gravitational action could then be reconstructed from the spectral behavior of the null-edge Dirac operator, from Regge/spin-connection curvature, or from both.

A possible discrete Einstein-Hilbert analogue is:

[
S_{\rm grav}
============

\sum_h A_h\epsilon_h
+
\Lambda\sum_v V_v
+
\text{torsion/null-frame constraints}.
]

A possible spectral action analogue is:

[
S_{\rm spec}
============

{\rm Tr},f(H_{\rm ne}^2/\Lambda^2),
]

with null-edge locality and GW chirality built in. This is speculative but structurally attractive: the same operator that releases fermions also measures geometry.

---

# XIV. The best current architecture

Putting everything together:

[
\boxed{
\begin{array}{c}
\text{null-edge causal graph} \
\Downarrow \
\text{local null frames + spin/gauge holonomies} \
\Downarrow \
H_{\rm ne}=\gamma_5(D_{\rm null}+W+E_{\rm onsite}-\rho/a) \
\Downarrow \
{\rm sign}(H_{\rm ne}) \
\Downarrow \
D_{\rm ov,ne}=\frac{\rho}{a}(1+\gamma_5{\rm sign}(H_{\rm ne})) \
\Downarrow \
\text{GW Weyl projectors + anomaly-free Standard Model multiplet} \
\Downarrow \
\text{path-sum expansion over null histories with node phases} \
\Downarrow \
\text{dynamical graph/geometric sum giving quantum gravity}.
\end{array}
}
]

The fixed-background limit gives QFT. The dynamical-background limit gives quantum geometry. The semiclassical limit gives general relativity.

---

# XV. Relation to known approaches

## 1. Feynman checkerboard and quantum walks

NullStrand inherits the intuition that massive relativistic propagation can arise from sums over lightlike paths with local turn/coin amplitudes. The (1+1) checkerboard and quantum-walk/Dirac-automaton literature support this as a real mechanism, although they do not solve the Standard Model chiral-gauge problem by themselves. ([arXiv][1])

## 2. Wilson/overlap/Ginsparg-Wilson lattice fermions

NullStrand should not reinvent chiral release. It should reinterpret overlap/GW in null-edge language. This is the least-risk path to chiral fermions. ([arXiv][3])

## 3. Causal set theory

Causal set theory shows that causal order plus discreteness is a plausible route to Lorentzian quantum gravity. NullStrand adds explicit null-edge transport, spinor/gauge holonomy, and chiral overlap structure. ([arXiv][9])

## 4. CDT and Regge/spinfoam gravity

Regge calculus, CDT, and spin foams show how discrete geometric histories can approximate or quantize gravity. NullStrand should borrow their lessons: causal structure matters, curvature can live on hinges/loops, and the continuum limit is the central problem. ([arXiv][8])

## 5. D4/E8/octonionic envelopes

D4 and E8 are useful as symmetry envelopes, internal-fiber organizers, and null-lift structures. They should not replace the active tetrahedral C1 lattice until they have their own branch/gap/no-mirror proofs. The octonionic idea is strongest as hidden/internal null motion explaining visible mass/rest behavior, not as an immediate uncontrolled expansion of spacetime dimensions.

---

# XVI. The theorem ladder for the full program

## Gate C1: fixed-background chiral release

1. Define the tetrahedral rank-4 Brillouin torus.
2. Prove Euclidean Clifford/coframe identity.
3. Prove scalar Wilson first-band uniform gap.
4. Prove finite Fourier block diagonalization.
5. Prove finite/free operator gap.
6. Prove (H_{\rm tet}) self-adjoint.
7. Define ({\rm sign}(H_{\rm tet})).
8. Prove GW relation.
9. Prove free no-mirror-pole theorem.
10. Define Weyl projectors.

## Gate C2: gauge backgrounds

1. Gauge-covariant shifts.
2. (H[U]) self-adjoint.
3. Admissibility/smoothness gap condition.
4. Exponential locality/quasi-locality.
5. Index theorem.
6. Anomaly and determinant-line construction.

## Gate C3: path-sum interpretation

1. Rational/Chebyshev/domain-wall expansion of ({\rm sign}(H)).
2. Path expansion over null shifts and onsite node operations.
3. Node-time phase interpretation.
4. Retarded/Hilbert dilation connection.
5. Positivity/Krein audit.

## Gate G1: emergent geometry

1. Null-frame reconstruction of conformal metric.
2. Volume/density reconstruction of conformal factor.
3. Spin connection from edge holonomies.
4. Curvature from loop holonomies or Regge deficits.
5. Coarse-grained Einstein-Hilbert action.

## Gate G2: quantum gravity

1. Define sum over null-edge geometries.
2. Define gravitational amplitude.
3. Couple overlap matter to dynamical geometry.
4. Prove semiclassical saddle approximates Einstein equations.
5. Prove fixed-background limit recovers QFT.
6. Prove continuum universality class.

---

# XVII. Failure modes

The theory fails if any of the following happen:

1. The tetrahedral free operator is not genuinely gapped.
2. Mirror branches are removed by propagator zeros rather than inverse-propagator gaps.
3. The overlap sign kernel is not Hilbert-self-adjoint.
4. Lorentzian/Krein structures are confused with Hilbert spectral calculus.
5. Onsite terms become arbitrary branch-fitting matrices.
6. The dynamic graph has no continuum Lorentzian phase.
7. Gauge anomalies cannot be canceled in the Weyl measure.
8. Nonlocality becomes uncontrolled.
9. Octonionic/E8 structures are used symbolically without an associative operator realization.
10. The theory cannot reproduce Einstein gravity in a semiclassical limit.

These are not cosmetic risks. They are the actual gates.

---

# XVIII. The central unification claim

The strongest version of the theory can be summarized in one sentence:

[
\boxed{
\text{Quantum fields and spacetime geometry are two coarse-grained faces of a causal null-edge amplitude system.}
}
]

Matter is the behavior of spinor/internal amplitudes transported along null edges and transformed at nodes.

Gauge fields are internal holonomies on those edges.

Mass is node-time phase from relational null-edge composites.

Chirality is released by overlap/GW spectral projectors.

Geometry is reconstructed from null-cone data plus volume/density.

Gravity is the large-scale dynamics of the null-edge graph and its spin connection.

QFT emerges when the graph is fixed and semiclassical.

GR emerges when the graph geometry is coarse-grained and varied.

Quantum gravity is the path integral over the graph and its transport data.

---

# XIX. Practical next work

The immediate proof work should remain narrow:

[
\boxed{
\text{finish }TetraFreeOperatorGap_\text{equalN}.
}
]

That means:

1. Finish phase-to-trig adapters.
2. Prove full (H_{\rm free}) Fourier diagonalization.
3. Instantiate the unitary block-diagonal gap theorem.
4. Package finite/free operator gap.
5. Prove self-adjointness of (H_{\rm free}).
6. Only then activate the sign/GW/release layer.

Do **not** add stay/coin, (M_{\rm br}), D4, E8, octonions, or dynamical gravity to the active proof until the fixed tetrahedral C1 theorem lands.

Those ideas are valuable, but the first hard victory is still:

[
H_{\rm tet}
\text{ is a genuine gapped Hermitian null-edge overlap kernel.}
]

Once that is proved, the theory has a concrete spine. Without it, the rest remains poetic.

---

# XX. Final formulation

A polished name for the framework might be:

[
\boxed{
\textbf{Null-Edge Relational Quantum Geometry}
}
]

Its axioms would be:

1. **Null transport:** all primitive spatial transport is along null edges.
2. **Node evolution:** local onsite/internal operations are allowed but are not primitive non-null transport.
3. **Relational time:** proper time is generated by composites and cross terms of null edges.
4. **Hilbert sign kernel:** chiral fermions require a self-adjoint, gapped overlap/GW kernel.
5. **Gauge holonomy:** gauge and spin connections live on edges.
6. **Geometry from transport:** metric/tetrad data are reconstructed from null frames and volume density.
7. **Gravity from graph dynamics:** curvature and Einstein dynamics emerge from sums over null-edge geometries.
8. **Path-sum duality:** the spectral sign/release operator admits a convergent expansion over null-edge histories.
9. **Internal envelope:** octonionic/E8/D4 structures may organize internal fibers and hidden null motion, but only through controlled associative operator realizations.
10. **Continuum accountability:** the theory must reduce to Standard Model QFT and classical GR in their tested regimes.

That is the best version of the ideas: conservative where proven machinery exists, radical only where the null-edge interpretation adds something genuinely new.

[1]: https://arxiv.org/abs/1012.1564?utm_source=chatgpt.com "[1012.1564] Notes on The Feynman Checkerboard Problem"
[2]: https://arxiv.org/abs/1406.1021?utm_source=chatgpt.com "Path-integral solution of the one-dimensional Dirac quantum cellular automaton"
[3]: https://arxiv.org/abs/hep-lat/9802011?utm_source=chatgpt.com "Exact chiral symmetry on the lattice and the Ginsparg-Wilson relation"
[4]: https://arxiv.org/abs/hep-lat/9808010?utm_source=chatgpt.com "Locality properties of Neuberger's lattice Dirac operator"
[5]: https://arxiv.org/abs/1611.09182?utm_source=chatgpt.com "[1611.09182] Standard model physics from an algebra?"
[6]: https://www.cs.mcgill.ca/~prakash/Pubs/ams_proc_version.pdf?utm_source=chatgpt.com "Spacetime geometry from causal structure and a measurement"
[7]: https://arxiv.org/abs/1812.06193?utm_source=chatgpt.com "Tullio Regge's legacy: Regge calculus and discrete gravity"
[8]: https://arxiv.org/abs/1302.2173?utm_source=chatgpt.com "Quantum Gravity via Causal Dynamical Triangulations"
[9]: https://arxiv.org/abs/1903.11544?utm_source=chatgpt.com "The causal set approach to quantum gravity"
