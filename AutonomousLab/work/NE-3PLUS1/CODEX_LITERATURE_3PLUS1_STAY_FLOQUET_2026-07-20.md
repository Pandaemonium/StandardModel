# Literature map: 3+1 stay sectors, Floquet topology, and null support

Date: 2026-07-20
Role: Codex / Archivist + Research Scientist
Status: primary-source literature pass and theorem recommendations

## Search question

Given the live HNU reconstruction, what does the literature say we should
relax in a local, exactly unitary `3+1` walk? In particular:

1. Is a nonzero one-substep stay amplitude physically or mathematically
   acceptable?
2. Can periodic driving evade the static single-Weyl obstruction?
3. Can an apparent stay be represented as genuine motion on a larger graph?
4. Which results provide a credible route to a position-space continuum
   theorem and a many-particle completion?

The search used direct arXiv records, primary full text where available,
Neo4j exact/semantic retrieval, and the live repository theorem map. A later
same-day archive pass used the revised Gupta--Short full text (22 Neo4j chunks)
after Zotero and Neo4j became reachable again.

## Executive conclusion

The literature strongly supports the current change of architecture.

- **Relax zero stay per substep.** Gupta and Short show that a nonzero stay
  amplitude is a real spectral resource. Their family removes ordinary
  doublers and high-quasienergy pseudo-doublers while retaining a Dirac
  continuum limit. It still has two additional low-energy solutions in
  `3+1`, so stay is not by itself a complete answer.
- **Relax static-Hamiltonian topology.** Higashikawa, Nakagawa, and Ueda
  realize a single Weyl fermion in a periodically driven three-dimensional
  lattice. Bessho and Sato explain why dynamical bulk topology changes the
  Nielsen-Ninomiya ledger. This directly validates the HNU/Floquet route.
- **Relax separability, not locality.** BCC/tetrahedral and QCA work derives
  relativistic walks from locality, homogeneity, unitarity, and isotropy
  without privileging the live one-factor-per-Cartesian-axis ansatz. The
  cubic separable schedule should be treated as a control, not an ontology.
- **Relax minimal internal dimension.** Published QCA and many-particle
  constructions use internal registers or invariant sectors. The physical
  Dirac spinor need not be the complete microscopic register.
- **Keep the hard gates.** Exact unitarity, finite propagation, a full-zone
  zero/pi census, the correct Weyl/Dirac tangent, a positive physical sector,
  a changing-lattice continuum theorem, and an honest anomaly/mirror ledger
  must not be relaxed.

The live HNU schedule is consequently the strongest current `3+1` regulator
candidate. Its stay sectors are not an accidental defect: each conditioned
shift moves one rank-one spin sector and fixes its complement, while the
complete eight-step schedule has no nonzero state fixed by every substep and
has movement budget `4 I`. That is a coherent microscopic update, but it is
not literally an all-moving null-edge update.

## Source map

### 1. Stay amplitudes as a doubling resource

**C. Gupta and A. J. Short, "Fermion Doubling in Dirac Quantum Walks,"
arXiv:2601.15885 (2026), revised version checked 2026-07-16.**

Primary source: <https://arxiv.org/abs/2601.15885>

What the paper establishes:

- a family of exact discrete-time Dirac walks with nonzero probability to
  remain at the same spatial site during a step;
- an exact local-unitary projector construction of the form
  `K_j = alpha_+ S_j + alpha_0 + alpha_- S_j^dagger`, where `alpha_0` is the
  stay amplitude selected by two internal subspace projectors rather than an
  external stochastic decision;
- analytic removal/control of the conventional listed doublers and
  high-quasienergy pseudo-doublers for suitable nonzero parameter choices,
  supplemented in `3+1` by a numerical search for further zero-energy points;
- retention of the desired Dirac continuum behavior;
- in `3+1`, two additional isolated low-energy solutions that are not ordinary
  Dirac particles;
- persistence of the doubling issue into second quantization and potential
  interaction/vacuum problems.

Implication for Null-Edge:

The zero-stay axiom was too strong. A stay coefficient may be a controlled
internal channel of an exactly local unitary. "Stay or move" is not chosen by
a hidden classical switch: the internal state is coherently decomposed into
forward, onsite, and backward amplitudes, and their interference is fixed by
the projector geometry. The physical continuum speed constrains the resulting
first-order coefficient and the space/time lattice-spacing ratio. However, the
paper is also the best warning against declaring victory from a corner census:
residual modes can occur away from the conventional zero/pi corners, and the
paper's nonzero-parameter global search is not a substitute for our exact
full-zone determinant theorem.

### 2. Periodic dynamics as the single-Weyl escape

**S. Higashikawa, M. Nakagawa, and M. Ueda, "Floquet chiral magnetic effect,"
arXiv:1806.06868, Phys. Rev. Lett. 123, 066403 (2019).**

Primary source: <https://arxiv.org/abs/1806.06868>

The paper gives the exact architecture reconstructed in the live HNU modules:
eight spin-selective pumps, half-cell transport in the third direction, a
two-band one-period block `U(k)` that maps every Brillouin boundary face to
`-I`, one Weyl point at the origin, and a three-dimensional endpoint winding
`W = 1`. The topological object used for the single-Weyl claim is the periodic
restricted two-band Floquet endpoint, not merely a static effective Hamiltonian
and not an unspecified micromotion invariant.

**T. Bessho and M. Sato, "Nielsen-Ninomiya Theorem with Bulk Topology:
Duality in Floquet and Non-Hermitian Systems," arXiv:2006.04204,
Phys. Rev. Lett. 127, 196404 (2021).**

Primary source: <https://arxiv.org/abs/2006.04204>

The paper extends the Nielsen-Ninomiya analysis to dynamical systems and
identifies intrinsic bulk topology as the additional term that permits bulk
chiral fermions.

Implication for Null-Edge:

The live HNU reconstruction is not an ad hoc workaround. It is a clean-room
formal reconstruction of this published single-Weyl endpoint. Any final charge
theorem must retain the zero sector, pi sector, the restricted endpoint degree,
and the complementary full-system block. A low-energy tangent by itself is not
sufficient, but neither should the degree-one endpoint be mislabeled as an
unknown micromotion invariant.

The route is also experimentally active rather than purely formal. Lin,
Zhang, and Zhang propose tunable unpaired Weyl points in a periodically driven
three-dimensional optical Raman lattice:
<https://arxiv.org/abs/2602.11935>. This does not validate the Null-Edge
ontology, but it shows that unpaired Floquet-Weyl kinematics is a serious
experimental target.

### 3. Existing all-null or alternative-lattice controls

**B. Z. Foster and T. Jacobson, "Spin on a 4D Feynman Checkerboard,"
arXiv:1610.01142.**

Primary source: <https://arxiv.org/abs/1610.01142>

This is the closest published path-sum control. It discretizes the Weyl
equation on a time-diagonal hypercubic lattice with null faces, assigns spin
projectors to steps, reports no fermion doubling in the retarded propagator,
and introduces Dirac mass through chirality flips.

Boundary of the comparison:

- it is a retarded path-sum construction, not the same object as an exactly
  unitary one-step QCA on the complete Hilbert space;
- the source's tetrahedral propagation normalization gives microscopic step
  speed `3c` in the chosen coordinates rather than the literal unit-speed
  condition sought here;
- the interacting Lorentzian continuum theory remains open.

It therefore proves that a useful `3+1` null checkerboard exists, but it does
not close our exact-unitary/all-null/full-spectrum gate.

**U. Nzongani et al., "Dirac quantum walk on tetrahedra,"
arXiv:2404.09840.**

Primary source: <https://arxiv.org/abs/2404.09840>

The paper recovers the `3+1` Dirac equation from a causal, local, unitary walk
on tetrahedral space. It is strong evidence that the cubic Cartesian cell is
not fundamental. Its continuum result and geometric flexibility make it a
valuable comparison architecture, but the paper does not automatically supply
our full-zone alias census or an all-null microscopic interpretation.

**G. M. D'Ariano, P. Perinotti, and collaborators, free-field QCA series.**

Primary sources:

- <https://arxiv.org/abs/1601.04832>
- <https://arxiv.org/abs/1601.04842>
- <https://arxiv.org/abs/1707.08455>

These works derive Weyl/Dirac/Maxwell automata on Cayley/BCC structures from
unitarity, locality, homogeneity, isotropy, and minimal internal dimension,
and recover ordinary relativistic symmetry in the small-momentum regime.

Implication for Null-Edge:

The more principled classification problem is not "which cubic checkerboard
formula do we prefer?" It is "which finite local unitary architectures satisfy
the physical axioms, and what register/range/topology do those axioms force?"

### 4. Continuum-limit template

**P. Arrighi, M. Forets, and V. Nesme, "The Dirac equation as a quantum walk:
higher dimensions, observational convergence," arXiv:1307.3524.**

Primary source: <https://arxiv.org/abs/1307.3524>

The paper constructs causal homogeneous walks in higher dimensions and proves
finite-time convergence to the continuum Dirac evolution, with an
`O(epsilon^2)` observational discrepancy under its hypotheses. Its proof uses
consistency, stability, low-pass sampling/interpolation, and Sobolev control.

Implication for Null-Edge:

This is the closest proof architecture for the missing HNU position-space
theorem. The live fixed-momentum `O(1/n)` result should be lifted by explicitly
defining sampling and interpolation, proving a uniform compact-momentum bound,
splitting the Fourier integral into infrared bulk and ultraviolet tail, and
controlling the tail by Sobolev regularity. The published walk is not HNU and
does not transfer the theorem automatically; it supplies the analytic ladder.

### 5. Many-particle completion

**L. Mlodinow and T. A. Brun, "Quantum field theory from a quantum cellular
automaton in one spatial dimension and a no-go theorem in higher dimensions,"
arXiv:2006.08927.**

Primary source: <https://arxiv.org/abs/2006.08927>

**L. Mlodinow and T. A. Brun, "Fermionic and bosonic quantum field theories
from quantum cellular automata in three spatial dimensions,"
arXiv:2011.05597.**

Primary source: <https://arxiv.org/abs/2011.05597>

The first paper gives a scoped obstruction to the usual one-dimensional
fermionization construction in higher dimensions. The second evades that
specific obstruction by beginning with distinguishable-particle QCAs and
restricting to antisymmetric or symmetric sectors, recovering free Dirac and
Maxwell field theory in the long-wavelength limit.

Implication for Null-Edge:

An invariant/code sector is legitimate only when its invariance, locality,
norm preservation, and observable algebra are proved. Projection after every
step or deletion of unwanted modes is not a completion. This is the correct
standard for any transverse-sector or enlarged-register HNU construction.

### 6. Can a stay downstairs be motion upstairs?

**H. Krovi and T. A. Brun, "Quantum walks on quotient graphs,"
arXiv:quant-ph/0701173.**

Primary source: <https://arxiv.org/abs/quant-ph/0701173>

The paper proves that a walk confined to a symmetry-invariant subspace of a
larger graph can be represented as a walk on a smaller quotient graph.

**T. J. Osborne and D. E. Severini, "Quantum Algorithms and Covering Spaces,"
arXiv:quant-ph/0403127.**

Primary source: <https://arxiv.org/abs/quant-ph/0403127>

The paper relates quantum dynamics on a covering graph to dynamics on the base
for states with the appropriate fibre symmetry.

Direct literature consequence:

An edge that moves between distinct vertices upstairs can project to a loop or
stay operation downstairs. Thus "stay in the effective walk" does not imply
"nothing happened in the microscopic walk."

Null-Edge-specific inference, not a claim of either paper:

One could seek a covering graph, deck-symmetry sector, and local unitary
`U_cover` with an isometric encoding `E` such that

```text
U_cover E = E U_HNU,
```

while every nonzero primitive transition of `U_cover` moves along a supplied
null edge. A character-twisted deck sector, rather than only the constant
fibre sector, may encode the HNU stay phase.

The live compact out-and-back dilation is the decisive control. It already
proves that a coarse stay can be factored into all-moving fine ticks, but its
full-spectrum audit finds the trivial auxiliary-momentum sector and additional
bands. Quotient/cover language therefore clarifies the construction; it does
not erase the spectral debt. A valid successor must prove how the chosen deck
sector is physically selected and where all complementary charge and modes go.

### 7. A current QCA cover theorem: copies become flavors, not nothing

**D. Bakircioglu, P. Arnault, and P. Arrighi, "Fermion Doubling in Quantum
Cellular Automata," arXiv:2505.07900v3 (2026).**

Primary source: <https://arxiv.org/abs/2505.07900>

Archive status: Zotero/Neo4j key `6XT3VQSE`. The revised 46-page PDF was read
directly on 2026-07-20, and 85 full-text chunks are now indexed. The first
ingestion command timed out only after the graph write had completed; a second
idempotent pass confirmed the paper was already chunked. Section-level
conclusions below come from the primary text, not from the abstract.

The paper is unusually close to the present decision point. For its `3+1`
Dirac QCA it:

- detects seven additional discrete-time solutions by analyzing the full
  characteristic polynomial in energy-momentum Brillouin space;
- replaces the original zone by an eight-sheeted cover, formalized as a
  product of three two-sheet coverings after the authors' projection step;
- identifies the sheets with a `Z2 x Z2 x Z2` flavor register;
- makes each spatial shift flip the corresponding flavor qubit and makes one
  full time translation flip all three;
- obtains eight correct continuum solutions, one per flavor, rather than one
  desired solution plus seven solutions declared spurious;
- retains massless chiral symmetry because the chiral projectors do not act on
  flavor.

The crucial accounting statement is explicit in Sections 4.2 and 7: the
number of solutions is preserved. The cover changes their physical
interpretation and direct-space organization; it does not delete states. This
is an important correction to any loose phrase such as "the cover removes the
doublers."

The paper's neutrino example also supplies our needed caution. A single
observed flavor is obtained by initial-state and coupling choices. The authors
note that more general extensions may populate the extra left-handed flavor.
Therefore a one-flavor claim owes an invariance/nonpopulation theorem for the
actual interacting dynamics. The static flavor projector is not enough,
especially because the free translations themselves act nontrivially on the
flavor register.

Implication for Null-Edge:

1. A full-zone residual HNU sector need not automatically kill the program if
   it admits an exact local flavor-cover interpretation with the right
   continuum copies and interactions.
2. Such a result is a **flavored regulator**, not a single microscopic Weyl
   degree of freedom. Complementary sheets remain part of the Hilbert space.
3. The exact target is an isometric code/deck decomposition intertwining the
   local walk, plus a proof that the intended observable or interacting sector
   is invariant. A projection performed only after evolution does not count.
4. The paper's cover lives in its own spacetime energy-momentum and lattice
   conventions. It does not prove the corresponding HNU endpoint/micromotion
   theorem, so a clean reconstruction and convention audit are still owed.

This produces a useful fork for the HNU full-zone audit: either prove genuine
Floquet charge balance with no unwanted low-energy complement, or classify the
entire complement as a local flavor cover and carry every flavor through the
continuum and interaction ledgers. What is no longer acceptable is to find a
mode and simply call it unphysical.

### Formal consequence now checked

`PhysicsSM/Draft/NullEdge/FlavorCoverSingleSheetNoGo.lean` turns the paper's
translation rule into an exact finite obstruction. For every bare flavor sheet
and every one of the three deck generators, pointwise projection onto that
sheet fails to commute with the generator. The proof uses an explicit delta
state and is guarded to the standard draft axiom footprint.

This closes one tempting but invalid escape: one cannot retain the published
local translations and then discard seven sheets with a static bare-sheet
projector. The statement is deliberately narrower than a universal selection
no-go. A spacetime-parity-correlated code, cocycle-twisted decoder,
interaction-selected superselection rule, or different Floquet architecture
could still work, but each must supply an exact intertwining theorem and a
full-spectrum/nonpopulation audit.

## Recommended theorem program

### Priority A: finish the HNU regulator theorem

1. Complete the global zero/pi gap and homotopy statements now in the
   Aristotle fleet.
2. State one capstone collecting exact locality, exact unitarity, complete
   zero/pi census, origin Weyl tangent and charge, and the Pluecker massive
   doubled gap.
3. Keep the claim scoped as an exact Floquet regulator. Do not call it an
   all-null microscopic theory.

### Priority B: changing-lattice HNU convergence

Follow the Arrighi-Forets-Nesme ladder:

1. define HNU sampling and interpolation maps;
2. prove stability from exact unitarity;
3. upgrade the one-step compact-momentum estimate to the sampled lattice;
4. split the norm into compact bulk and ultraviolet tail;
5. control the tail by a stated Sobolev hypothesis;
6. conclude finite-time position-space convergence to the Weyl flow;
7. compose opposite chiral sectors and the Pluecker rest operator for Dirac.

This is the most valuable theorem still missing from the regulator story.

### Priority C: classify stays as quotients of moving covers

Define a finite `NullCoverDilation` structure containing:

- a covering map from microscopic sites to physical sites;
- a local unitary microscopic schedule;
- a deck-group representation and invariant encoded sector;
- an isometric intertwiner with the physical HNU schedule;
- decorated primitive edges with a proved null interval;
- a full-spectrum zero/pi census, not merely a compressed-sector census.

Then prove one of two publishable outcomes:

1. an exact finite cover with a local superselection/constraint mechanism that
   isolates the target sector and gaps every complement; or
2. a no-go theorem showing that a translation-invariant finite cover with the
   stated range necessarily retains a trivial-fibre mode or compensating
   low-energy sector.

The second outcome would explain, rather than merely observe, why the compact
dilation failed.

### Priority D: interaction and sector stability

After the free continuum theorem:

1. second-quantize the exact HNU real-space update;
2. prove locality and invariance of the selected fermionic sector;
3. introduce one gauge-covariant local interaction;
4. prove that it does not mix the target sector with residual/mirror sectors;
5. compute one held-out scattering, response, or anomaly observable.

## 2026-07-20 full-zone topology follow-up

The full-text pass changes Priority A's topology wording. The relevant object
is not only the endpoint crossing census. It is the homotopy class of the full
Floquet unitary, or of a dynamically invariant low-energy block when such a
block is physically justified.

### Primary sources ingested

- Higashikawa, Nakagawa, and Ueda, *Floquet Chiral Magnetic Effect*,
  [arXiv:1806.06868](https://arxiv.org/abs/1806.06868),
  DOI `10.1103/physrevlett.123.066403`, Zotero `JQEKGVB8`, 13 Neo4j chunks.
  The paper constructs a three-dimensional Floquet unitary with a single
  low-energy Weyl point protected by a nonzero three-dimensional winding.
- Sun, Xiao, Bzdusek, Zhang, and Fan, *Three-Dimensional Chiral Lattice
  Fermion in Floquet Systems*,
  [arXiv:1806.09296](https://arxiv.org/abs/1806.09296),
  DOI `10.1103/physrevlett.121.196401`, Zotero `4W89G84K`, 7 Neo4j chunks.
  Their full-system argument retracts a legitimate continuous-time Floquet
  evolution to the identity and hence retains total chirality balance. In an
  adiabatically decoupled two-band block, however, they obtain
  `n_R - n_L = 2 nu_3`, with the complement carrying the global accounting.
- Bessho and Sato, *Nielsen-Ninomiya Theorem with Bulk Topology: Duality in
  Floquet and Non-Hermitian Systems*,
  [arXiv:2006.04204](https://arxiv.org/abs/2006.04204),
  DOI `10.1103/PhysRevLett.127.196404`, Zotero `RCSSD8MZ`, 35 Neo4j chunks.
  In class A and three dimensions, their corollary identifies the bulk winding
  `w_3` with the sum of Chern charges on the quasienergy Fermi surfaces.
- Xu, Zheng, and Zhai, *Topological Micromotion of Floquet Quantum Systems*,
  [arXiv:2106.14628](https://arxiv.org/abs/2106.14628),
  DOI `10.1103/physrevb.105.045139`, Zotero `WEU96K29`, 9 Neo4j chunks.
  It treats micromotion as essential topological data and packages it as an
  extra synthetic dimension; a fixed effective Hamiltonian need not classify
  the drive.
- Sadel and Schulz-Baldes, *Topological boundary invariants for Floquet
  systems and quantum walks*,
  [arXiv:1708.01173](https://arxiv.org/abs/1708.01173), Zotero `TTBJSPCC`,
  16 Neo4j chunks. Their operator-algebraic treatment separates invariants of
  gapped Floquet bands from invariants of the full periodized evolution. It
  also makes a quantum-walk-specific choice explicit: each discrete step must
  be supplied with a natural local interpolation to the identity, and
  different choices can alter the topology.

### Consequence for HNU

The live HNU theorems already prove the finite ingredients used in the source's
degree calculation: `endpoint k = 1` has the unique Brillouin-zone solution
`k = 0`, the derivative there has positive local orientation, and every
boundary face maps to `-I`. Higashikawa et al. additionally give the explicit
winding integral and smash-product construction yielding `W = 1`. The source
therefore fixes the intended theorem unambiguously. The repository still lacks
the global Brouwer-degree or integral theorem composing its exact certificates,
and Mathlib/PhysLean semantic search did not surface a ready-made API, so the
formal evidence grade remains below a kernel-checked winding theorem.

The official HNU source archive has now been retained at
`AgentTasks/literature/hnu-1806.06868/`. Its displayed coordinates write the
endpoint as `U = u4 I + i (u1 sigma1 + u2 sigma2 + u3 sigma3)`, give the
normalized oriented `S3` volume integral, and evaluate it to one. A focused
Aristotle target now asks for that actual integral rather than another local
Jacobian certificate.

The same source fixes the complete four-band bookkeeping:
`V^wh(k) = U(k) direct-sum U^H(k)` with
`U^H(k1,k2,k3) = U(k1,k2,k3-2*pi)`. A numerical exact-pattern oracle strongly
indicates `U^H(k1,k2,k3) = U(k1,-k2,k3)`, which flips the second tangent axis
and hence the local orientation at the origin. That identity, the opposite
Jacobian determinant, the companion crossing census, and the invariant-sector
block equations are now an Aristotle theorem target. Until its return is
kernel-checked, this is a source-grounded candidate, not a landed balance
theorem.

The next formal target should therefore be one of the following, in descending
order of value:

1. Define the HNU map from the momentum three-torus to `SU(2)`, define its
   normalized winding/degree, and prove it is `+1` from the unique regular
   preimage and positive local sign.
2. If the global differential-topology layer is too large for this run, prove
   an abstract regular-preimage degree theorem and instantiate it on HNU.
3. As a finite exact control, package the unique-preimage and orientation
   statements as a `WindingOneCertificate`, explicitly leaving the theorem
   from that certificate to the published winding integral open.

The Sadel--Schulz-Baldes framework still warns that endpoint, gapped-band, and
periodized-loop invariants are different. It does not erase the HNU endpoint
degree, because HNU works with a dynamically closed two-band block over a full
cycle rather than the complete Hamiltonian Floquet operator throughout the
cycle. Sun et al. make the reconciliation explicit: the complete evolution
retracts and has zero total chirality, while an adiabatically or exactly closed
block may have nonzero winding and a complementary block restores the global
accounting. For a discrete quantum walk, the sector closure and periodicity of
every proposed homotopy are therefore theorem data.

Accordingly, the informal phrase "HNU winding" must be split into three
non-interchangeable candidates:

1. the published degree `W = 1` of the restricted translation-invariant
   endpoint map `T^3 -> SU(2)`;
2. a gapped-band invariant of a displayed endpoint spectral projection; or
3. a micromotion invariant of a displayed periodized protocol loop.

The unique regular preimage, positive Jacobian, and collapsed boundary support
candidate 1 but do not yet constitute its kernel-checked global proof. They do
not establish candidates 2 or 3. Conversely, the
noncontractibility of an individual lattice translation within a strict
finite-range periodic-Bloch control space does not by itself identify the
periodized-loop invariant of the complete HNU protocol.

For the massive doubled walk, the correct ledger must then state where the
opposite chirality enters and how the two sectors are coupled. A compressed or
adiabatic physical sector is acceptable only with an invariant projector,
spectral separation from the complement, and a theorem that the intended
interactions preserve it.

There is a concrete reason the continuous-time retraction argument may not
apply verbatim to the discrete HNU/QCA schedule. A unit lattice translation
has Bloch character `exp(-i k)`, but the naive interpolation
`exp(-i t k)` is a function on the Brillouin circle only when `t` is integral.
At an intermediate `0 < t < 1`, it is continuous on the covering momentum
line but fails `2*pi` periodicity. Thus scaling a translation to zero does not
automatically provide a legal periodic Bloch homotopy. The kernel-checked
module `HNUBlochPeriodicity.lean` now proves the exact iff classification,
half-step antiperiodicity, paired-endpoint periodicity, the obstruction for
every strictly intermediate linear displacement, and a nontrivial conditioned
shift control. Aristotle project `4fb1a1d7-b4dc-40fd-966f-d7465e492f81`
supplied the proofs. This does not prove the HNU winding; it identifies the
precise hypothesis that distinguishes a lattice-QCA endpoint from an ordinary
Hamiltonian Floquet retraction.

This distinction has a precise literature precedent, though the complete
higher-dimensional invariant is not imported for free:

- Gross, Nesme, Vogts, and Werner, *Index theory of one dimensional quantum
  walks and cellular automata*, arXiv `0910.3675`, Zotero `6MZT3FBH`, Neo4j
  chunks 20, 31, and 45. In one dimension their index labels connected
  components of locality-preserving walks; shifts have nonzero index, while
  the trivial-index class is locally implementable. The paper explicitly
  warns that local implementation, homotopy, and local-invariant
  classifications need not coincide in higher dimensions.
- Cedzich et al., *Complete homotopy invariants for translation invariant
  symmetric quantum walks on a chain*, arXiv `1804.04520`, Zotero `RS6P7CBT`,
  especially Neo4j chunk 23. It states directly that the bilateral shift
  cannot be contracted to the identity while strict locality is preserved.
- Freedman and Hastings, *Classification of Quantum Cellular Automata*, arXiv
  `1902.10285`, Zotero `FKR7UGA5`, Neo4j chunks 1, 3, 5, and 6. Their path and
  circuit equivalences are distinct; an apparent finite-system deformation
  may require circuit depth diverging with system size. They also identify
  genuinely nontrivial three-dimensional behavior beyond the complete one-
  and two-dimensional index story.
- Freedman, Haah, and Hastings, *The Group Structure of Quantum Cellular
  Automata*, arXiv `1910.07998`, Zotero `2MC6CX6F`, Neo4j chunks 4, 19, 20,
  and 29. It supplies the coherent-family/refinement framework needed before a
  higher-dimensional QCA homotopy claim is regulator-independent.

The scientific consequence is a stricter target, not an automatic victory:
formalize the published degree-one restricted endpoint and reconstruct the
complete compensating block. A broader QCA connected-component theorem remains
valuable, but it is no longer the cheapest missing theorem and must not replace
the source's explicit invariant. The scalar periodicity theorem explains why
the restricted block is not retracted by naively truncating half-cell steps. A
one-dimensional GNVW index is not the three-dimensional HNU winding.

The cheapest decisive next topology artifact is now a typed comparison table
for the actual HNU definitions: endpoint map, spectral projector (with named
zero or pi gap), ordered step protocol, and any proposed local interpolation.
Every claimed integer must declare which row it belongs to and the exact
homotopies under which it is invariant. If no local periodic interpolation of
the HNU steps exists in the chosen control space, that is a publishable QCA
obstruction, but it must not be relabeled as the Floquet micromotion winding.

### Revised kill condition

Do not infer a complete microscopic single-Weyl theory merely from the unique
crossing of the restricted endpoint. The route survives only if the restricted
block has the published degree and exact one-period invariance, while the
complete drive's complementary charge is explicitly identified and controlled.
The endpoint degree is real topology; the remaining debt is physical-sector
selection and full-system accounting, not an unspecified need for micromotion.

## Kill conditions retained after the search

The `3+1` route fails as a physical completion if any of the following holds:

1. the HNU zero/pi census or charge accounting changes under a legitimate
   Floquet timeframe or branch convention;
2. the massive doubled walk cannot retain a uniform full-zone gap;
3. the landed changing-lattice position-space `L2` evolution limit fails its
   independent semantic audit or cannot be upgraded to the displayed Weyl PDE
   generator domain;
4. every all-moving cover introduces ungapped physical mirror sectors;
5. selecting the desired sector requires nonlocal projection or postselection;
6. local interactions mix the selected and compensating sectors;
7. primitive nullity can be obtained only by assigning an unexplained extra
   spacetime dimension or by relabeling an onsite operation as motion.

## Bottom line

The literature does not tell us to abandon the HNU route. It tells us to state
it at the right level:

- **Solved at finite free-regulator level:** a local exact-unitary Floquet
  architecture can carry the desired infrared Weyl behavior without the old
  cubic aliases, and a Pluecker coupling can gap an opposite-chirality double.
- **Solved at free-evolution level:** the live HNU regulator now has a genuine
  changing-lattice, position-space, strong-`L2` limit to exact Weyl evolution
  for arbitrary componentwise `L2` input. The explicit PDE-generator-domain
  identity remains a separate theorem.
- **Not solved:** literal all-null support for every microscopic branch,
  interacting sector stability, the kernel-checked global endpoint degree,
  and the complete compensating-sector ledger. The Schwartz-domain Weyl PDE
  identity is now landed in `HNUWeylSchwartzPDE.lean`.

The most productive relaxation is therefore not causality or unitarity. It is
the demand that every substep look like a spin-blind unit translation in the
same minimal physical cell. The physics literature favors ordered micromotion,
conditioned transport, non-Cartesian cells, and enlarged registers. Our task is
to prove exactly which of those extra structures survives decoding without
hiding unwanted modes.

## Knowledge-system disposition

Neo4j contains the Gupta--Short record under canonical paper key `U58ZFXGR`
and 22 full-text chunks for arXiv `2601.15885`; the restored Zotero item is in
the null-edge collection. A connection-recovery check accidentally created a
second Zotero record `KFKEUCNF`; it is not linked into Neo4j and must be merged
or removed in the next archive-maintenance pass. The HNU, quotient-graph,
covering-space, and 2026 optical-Raman records still require an
identifier-deduplicated ingestion audit.
