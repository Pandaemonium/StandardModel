# The null-edge mass program: status and hardest challenges

A standalone brief for external collaborators, 2026-07-08. No access to
our repository is assumed; everything needed is defined here. We are
asking for guidance on the seven challenges in section 5. Please read
section 6 (pitfalls and closed routes) before proposing approaches -
several natural ideas are already dead by proof or measurement.

## 1. What this project is

A machine-verified physics program: we formalize, in Lean 4 (Mathlib,
pinned toolchain), the thesis that **mass is the obstruction to coherent
null transport** - matter is trapped, mutually disagreeing light. The
Lean kernel is our source of truth. Every claim carries a grade:
**T** (source-verified theorem), **M** (machine/kernel-verified),
**MEMO** (expert-verified prose, kernel transcription pending),
**C** (pre-registered conjecture with explicit kill conditions),
**[import]** (external input). We pre-register tests before running
them, and we report kills as loudly as wins - two long-standing
conjectures died this week by their own pre-registered criteria, and we
count that as the system working.

## 2. The trusted core (kernel-checked, no caveats)

For 2-component Weyl spinors `psi_1..psi_n` (null momenta
`psi_i psi_i^dag`), with `P = sum_i psi_i psi_i^dag`:

```text
det P = sum_{i<j} |psi_i wedge psi_j|^2
```

Invariant mass squared IS total pairwise null-direction disagreement;
zero iff all directions collinear. Machine-checked, no axioms beyond
the standard three. Everything else orbits this.

## 3. The formal architecture (one paragraph each)

**Carrier.** A finite 2-complex (vertices, edges, faces) carrying a
Dirac-type operator `D = sum_e c(alpha_e) nabla_e + Gamma phi`: null
covector solderings `alpha_e` (Clifford coefficients `c(alpha)^2 = 0`),
covariant edge transports `nabla_e`, and a vertex "turn" term (the
Higgs-shaped channel). A kernel-checked Weitzenboeck identity splits
`4 D^#D` into four channels: aperture `Q_A` (kinetic, ties to det P),
closure `Q_C` (gauge/QCD-shaped: commutators of transports), turn `Q_T`
(Yukawa-shaped), soldering-gradient `E` (gravity-shaped). Slogan:
unification is decomposition. `#` is a Krein-space adjoint - the
geometry is indefinite by construction, and positivity holds (at best)
only on a constrained physical sector, Gupta-Bleuler style.

**Protection.** Finite McKean-Singer index theorems (kernel-checked):
an unbalanced chirality count forces exact massless modes immune to
every potential and transport.

**Dynamics.** Kernel-checked this week: one decimation (Schur
complement) step converts per-edge null structure into non-null
effective terms with coefficient exactly the pairwise Clifford pairing
(`(ab)^2 = k(ab)` for square-zero a, b with anticommutator k); the
effective coupling vanishes identically for collinear pairs. So the
SAME disagreement invariant that is mass kinematically becomes mass
dynamically under coarse-graining.

**QCD lane.** Kernel-checked at strong coupling on concrete finite
lattices: Wilson-loop area law, slab reflection positivity, a
transfer/OS spectral gap, exponential clustering, character-expansion
bounds. Also: the Wilson plaquette action is EXACTLY the squared
Hilbert-Schmidt norm of the closure defect `1 - holonomy` (one-line
identity, now pinned). This week's sharpest structural result (verified
analytically + by two independent numerical oracles, Lean transcription
in progress): the nonabelian closure channel is an EXACT Krein square,
`Q_C = L^# L`, with an explicit gauge-covariant current
`L = c(alpha_1) (x) 1 + c(alpha_2) (x) (-K/2)`, `K = [nabla_1,nabla_2]`,
for ANY compact group - but Krein squares carry no positivity by
themselves, which relocates the whole positivity question (challenge
C2).

## 4. Status snapshot (end of 2026-07-07)

- Kernel-checked: the section-2 theorem; the 4-channel Weitzenboeck
  split; index-protection family; the decimation/mass-generation
  witness with its collinear control; the strong-coupling QCD stack
  above; exact finite Ginsparg-Wilson chirality structure whose grading
  is edge-orientation reversal; a nonvacuous positive Gupta-Bleuler
  quotient witness on a small model; color-fiber structure (particle
  states as exterior-algebra "strand" monomials; hypercharge derived;
  lepton/baryon number = strand-count grading).
- MEMO grade: Standard-Model representation selection (five-strand
  principle); three generations via triality-as-monodromy (multiplicity
  menu {1,3} forced); equipartition trace identity behind the Koide
  combination.
- KILLED this week (pre-registered probes): see section 6.
- DISCOVERED this week: (i) every cyclically symmetric celestial
  decoration of a transport cycle pins an EXACT zero quasi-energy mode
  (generic decorations sit near zero); geometric decorations self-lock
  onto the abstract "massless locus"; (ii) the closure channel is
  chromomagnetic (linear in field strength), NOT energy-shaped - see
  pitfall P2.

## 5. The hardest challenges (the ask)

**C1 - a finite forest-counting injection (pure combinatorics; our
single most-resisted target: five failed expert-prover attempts).**
Setting: cluster/polymer expansion (Penrose-style tree partition
scheme). We need: for a fixed rooted-forest target with given block
sizes `m_j` summing appropriately, an explicit injection from
{fiber element} x Perm(k) x prod_j Perm(m_j) into orderings of n
labeled objects (root-first, blocks in sigma-order, internally
reordered), with fiber constancy - the missing bound is
`|fiber| * k! * prod m_j! <= n!`. The intended proof is a left-inverse
(parse the ordering back), with canonical-least-root and
increasing-children constraints as tie-breaks. GUIDANCE SOUGHT: a
clean certificate/encoding argument, or a reference where exactly this
fiber bound is proved (Penrose 1967 descendants; Fernandez-Procacci),
or a reformulation that avoids the injection entirely.

**C2 - constraint-compatible representatives in a Krein space (the
positivity crux).** The closure channel is an exact Krein square
`Q_C = L^# L` whose representation family is a GL-torsor
{`L_A = c(alpha_1)(x)A + c(alpha_2)(x)(A^dag)^{-1}(-K/2)`}. On the FULL
space the form `[psi, Q_C psi]` is maximally indefinite (necessarily -
null Clifford coefficients are #-isotropic). Positivity can only hold
on a physical sector `V'/N` (Gauss-law kernel modulo null vectors), and
descends IF some torsor member preserves `V'` and its constraint
subspace. QUESTION: for lattice gauge Gauss constraints, is there a
principled construction of a constraint-compatible representative
(e.g. via gauge averaging, BRST-style doublets, or a positive-definite
deformation)? Any literature on "operator squares in Krein spaces
restricted to Pontryagin-positive sectors"? A no-go would also be
valuable: if the restricted form must stay indefinite, chiral symmetry
breaking wants it that way (the curvature term must pull eigenvalues
down), and we need the sharp statement of that trade-off.

**C3 - multi-direction closure representation.** The exact square above
is proved for TWO transport directions. With d >= 3 directions,
`Q_C = -sum_{mu<nu} b_{mu nu} (x) [nabla_mu, nabla_nu]` and per-pair
currents generate cross-pair symmetric contaminations. CONJECTURE
(pre-registered): a compensated form `Q_C + (aperture-shaped
correction) = L^# L`. GUIDANCE: is there a known algebraic identity
(Fierz-like, or from Clifford bimodule theory) organizing
`sum_pairs (bivector) (x) (curvature)` as a single square plus a
canonical symmetric remainder?

**C4 - the right invariant for symmetry-forced zero modes.** Finding:
a length-V cycle of SU(2) frame transports built from V celestial
directions arranged symmetrically on ANY cone pins an exact unit
eigenvalue of the (unitary) transfer; random decorations give only
near-zero modes; in abstract (non-geometric) data the zero mode needs a
codim-1 locus relating amplitude and Berry-phase holonomy - which
geometric decorations satisfy AUTOMATICALLY. Discrete-time quantum-walk
topology (Kitagawa et al.; Asboth et al.: 0- and pi-quasienergy
invariants) is clearly adjacent but is about boundary states of walks,
not decoration-forced spectral pinning on closed loops. QUESTION: what
is the correct invariant/theorem class here - equivariant index on the
circle? spectral flow with a symmetry constraint? Kramers-like pinning
from an antiunitary in the cyclic group's presence?

**C5 - is any honest mass-VALUE route still alive?** Our Koide-relation
mechanism died by its own pre-registered probe: the dynamically
measured soldering coefficient is kappa = 3/2 (predicting Q = 5/9),
not the kappa = 1 (Q = 2/3) the relation needs, and the reduction does
not even produce the uniform-diagonal ansatz. Any surviving route must
ALSO clear Sumino's bar (family symmetry protecting the relation
against QED running). QUESTION: given a finite mechanism that produces
mass RATIOS from cycle geometry (spectra like pi/6 {0,1,2} arise
naturally), what observable targets are honest at finite level -
neutrino mass-squared-difference ratios? Koide-like relations for other
sectors? Or should finite programs stop at structural statements?

**C6 - what continuum statements are realistically provable?** Our
rule: quotient-then-limit (algebraic quotients at finite level, limits
only through a benchmark ladder of refinement maps; the exact GW
structure and a Wilson-term identity are the anchors). QUESTION: for a
program that will NOT attempt constructive Yang-Mills, what is the
strongest continuum-facing theorem class worth targeting - graph/
operator convergence of Dirac spectra under refinement (Laplacian
renormalization-group style), Gromov-Hausdorff-type spectral
convergence, or categorical colimits of transfer data?

**C7 - discrete torsion split of the gravity channel.** The
soldering-gradient channel E is NOT pure discrete torsion (our earlier
conjecture died by probe). Pre-registered target: an exact split
`2E = Contract(T) + Contract(S)` with T the antisymmetrized soldering
difference (torsion-shaped) and S a symmetric remainder
(non-metricity-shaped) - a finite "geometric trinity" statement.
GUIDANCE: pointers to teleparallel/symmetric-teleparallel
decompositions done at simplicial/discrete level (Regge-adjacent),
and the right discrete definition of contorsion.

## 6. Closed routes and pitfalls (do not spend time here)

- P1. "Q_C = sum over faces of (1 - holonomy)^dag (1 - holonomy)"
  (site-diagonal defect Gram) is DEAD structurally: the closure channel
  is purely off-diagonal in the site grading; any site-local Gram is
  exactly Frobenius-orthogonal to it. (The defect Gram is a fine object
  - it is the Wilson ACTION - it is just not this operator.)
- P2. Do not conflate the two closure objects: the defect GRAM is
  |F|^2-shaped (energy); the Weitzenboeck closure CHANNEL is linear in
  F (chromomagnetic, sigma.F). In mass-budget language the channel's
  share is hyperfine-shaped (Delta-N, rho-pi splittings), not "99
  percent of the proton".
- P3. Koide via tetrahedral corner geometry: killed by measurement
  (kappa = 3/2). The equipartition trace identity survives as algebra.
- P4. "Trace of E = discrete torsion": killed by probe.
- P5. Retardedness alone cannot delete fermion doublers (proved:
  determinant-level obstruction); one-sided Ginsparg-Wilson inversion
  is false in nonabelian settings (explicit 2x2 counterexample) -
  palindromic/midpoint transfer ordering is the correct convention.
- P6. Spectral-measure language is embargoed program-wide until the C2
  positivity question resolves; finite eigenvalue-COUNT identities are
  the sanctioned form (e.g. our finite Banks-Casher target
  `m V Sigma_m = N_m`).
- P7. We never claim continuum existence, physical scale (dimensional
  transmutation), or anything Clay-adjacent; ratios and finite
  identities only.

## 7. How to respond

Memo format preferred: numbered findings; explicit claim labels
(theorem / heuristic / reference / conjecture); kill conditions for any
mechanism you propose; references with enough precision to locate the
exact lemma (we verify against full text, not abstracts). Partial
answers to single challenges are very welcome. If you believe a
challenge is malposed, saying WHY is as valuable as solving it - our
best week yet came from two well-aimed kills.
