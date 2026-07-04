# YM0-YM4 + QCD1: analysis and statement freeze (v0.1)

Status: working analysis document, 2026-07-03 (claude). Companion to the
confinement-ladder planning document; this is the first content-bearing
artifact of Track A. It (i) pins the conventions, (ii) freezes the YM0
definition ledger, (iii) gives COMPLETE finite-level proofs of the first
theorems of the ladder (Elitzur quantitative, the 2D exact solutions, the
character-positivity engine behind reflection positivity), (iv) freezes the
YM3/YM4/QCD1 statements with explicit hypotheses and constants, and (v) maps
everything onto Aristotle packages. Claim grades per the Round 8 calculus.

Companion artifacts produced with this document:

- `Scripts/oracle/validate_lgt_core.py` v0.1 - Track C oracle, 30/30 checks
  passing this session (python 3.12.3, numpy 2.4.4). Oracle output pins
  conventions and corroborates formulas; it is never cited as proof.
- `YM0Seed.lean` - DRAFT, NOT kernel-checked this session (no toolchain in
  sandbox); candidate proofs for PKG-YM0-A. Grade: statement file until
  compiled. No [M] claim is made for it anywhere below.

Debt discipline. The finite-group proofs in sections 3-6 are self-contained:
they carry ZERO correctness debt (nothing external is assumed). The names
Elitzur / Wegner / Osterwalder-Seiler etc. remain in the debt register as
ATTRIBUTION debt only (priority and historical claims for the eventual
papers), which is a strictly weaker liability than correctness debt. This
correctness/attribution split is worth preserving in all ladder documents.

## 0. Pinned conventions (normative; oracle-enforced)

- C-1 Lattice: finite, oriented; link variables live on POSITIVELY oriented
  edges (s, mu); reversed traversal uses the group inverse.
- C-2 Plaquette at s in the (mu,nu) plane, based at s, counterclockwise:
  hol(p) = U(s,mu) U(s+mu,nu) U(s+nu,mu)^{-1} U(s,nu)^{-1}.
- C-3 Z2 multiplicative: bit b=1 means -1; group law xor.
- C-4 Weight per plaquette: w(h) = exp(beta * Re chi_f(h)), beta >= 0.
- C-5 Character coefficient: w_hat_R = (1/|G|) sum_h w(h) chi_R(h^{-1}).
- C-6 2D exact constants: Z_open = |G|^(V-1) (|G| w_hat_0)^P and
  <W_R(C_A)> = d_R gamma_R^A with gamma_R = w_hat_R / (d_R w_hat_0).
- C-7 Z2 torus (Lx, Ly >= 2): Z = 2^E cosh(beta)^P (1 + t^P), t = tanh beta;
  contractible loop of area A: <W> = (t^A + t^(P-A)) / (1 + t^P).
- C-8 Transfer matrix in temporal gauge: T = V^(1/2) K V^(1/2) with V the
  diagonal spatial-plaquette weight and K the tensor product of per-link
  temporal kernels K1(s,s') = w(s s'^{-1}); Gauss projector P_G = average
  over local spatial gauge transformations; and the pinned identity
  Z_torus = 2^(L*nt) Tr[(T P_G)^{nt}] (Z2, 1+1D; the 2^(L*nt) is the
  temporal-link sum normalization, oracle section [6]).

Convention note for v0.2 of the oracle: C-5/C-6 were pinned on groups with
REAL characters (Z2, Z16, S3). One fixture on a group with a complex
irreducible character (Z3 gauge weight, or Q8) should be added before the
YM1 finite-G paper freezes, to pin the conjugation placement in C-5. Flagged
as ORACLE-TODO-1; cost ~10 lines.

## 1. YM0 definition ledger

Each entry: definition -> Lean note. Mathlib availability facts below are
the [M]-grade lean-explore results from the planning document (Haar present;
unitary groups present; finite-group character theory present; Peter-Weyl
absent; cluster expansions absent).

- D1 Lattice graph: finite vertex set V, oriented edge set E with src/tgt.
  Lean: structure; done in seed (as link fields on ordered pairs).
- D2 Configuration space: G^E. Finite G: Fintype instance. Compact G:
  product measurable space with product Haar (Mathlib Haar present).
- D3 Gauge group G^V acting by (g.U)_e = g(src e) U_e g(tgt e)^{-1}.
  Lean: seed has the Z2 case with composition (L4a) and involution (L4b).
- D4 Walks and holonomy with orientation; closedness = endpoint condition.
  Lean: seed `hol`, `walkEnd` (Z2, orientation-free); general G threads
  inverses.
- D5 Plaquette = based 4-walk per C-2. Lean: seed `plaq`.
- D6 Class functions and characters; coefficient convention C-5.
  Lean: Mathlib finite character theory (present).
- D7 Wilson action S_beta(U) = beta * sum_p Re chi_f(hol p). Well-defined by
  L1 below (basepoint/orientation independence of Re chi on plaquettes).
- D8 Partition function: finite G, Z = sum over G^E of exp(S); compact G,
  Haar integral. Positivity of Z: trivial (positive summand).
- D9 Expectation; Wilson loop W_R(C) = chi_R(hol C) for closed C.
- D10 Center transformation: for z in Z(G) and a fixed time slice tau,
  multiply every temporal link with src-time tau by z. Polyakov loop = the
  winding-1 temporal Wilson loop.
- D11 Transfer matrix per C-8. Physical (Gauss) sector: image of P_G.
- D12 Finite-lattice mass gap: Delta_Lambda = -log(lambda_1 / lambda_0),
  eigenvalues of T restricted to the VACUUM SYMMETRY SECTOR: Gauss-invariant,
  zero spatial momentum, TRIVIAL 't Hooft flux (winding-flux-even). The
  flux-sector qualifier is load-bearing and was discovered by the oracle:
  on the 2x2 spatial torus the naive Gauss-sector gap is saturated by the
  WINDING electric flux line, gap ~ 2(-log t) at strong coupling (measured
  3.159 at beta=0.2 vs 2(-log tanh 0.2) = 3.25), not by a glueball. A gap
  definition that omits the flux quantum numbers measures the wrong
  excitation on small tori. [M: oracle section 7] [orig, minor but real]

## 2. Lemma chain L1-L5 (finite G; proofs complete)

- L1 (well-definedness). Changing the basepoint of a closed walk conjugates
  its holonomy; reversing orientation inverts it. Hence Re chi_R(hol C) is
  basepoint-free and orientation-free (chi(h^{-1}) = conj chi(h)). Proof:
  trace cyclicity; one-line induction for the basepoint shift. [T]
- L2 (gauge invariance). For a closed walk C, hol(g.U, C) = g_x hol(U, C)
  g_x^{-1} (basepoint x); hence any class function of any closed-walk
  holonomy, in particular S_beta and every W_R(C), is gauge invariant.
  Proof: telescoping induction (the seed's `hol_gauge` is the Z2 case;
  the general case is identical with inverses). [T; oracle sections 2, 5]
- L3 (measure invariance). g |-> (U |-> g.U) is a bijection of G^E (finite)
  and Haar-measure-preserving (compact; translation invariance link by
  link). Hence Z and all gauge-invariant expectations are invariant, and
  expectations of gauge-VARIANT observables equal their gauge-orbit
  averages. Proof: change of variables. [T]
- L4 (action structure). Composition and inverse laws for the gauge action;
  orbit-stabilizer bookkeeping. For Z2 on a connected graph the stabilizer
  of every configuration is the global flip, so every orbit has size
  2^(V-1) - consistent with C-6's |G|^(V-1). [T]
- L5 (center symmetry). The slice twist of D10 fixes every plaquette
  holonomy up to conjugation - each plaquette crossing the slice contains
  exactly two twisted temporal links, contributing z and z^{-1}, which
  cancel through the centrality of z - while multiplying the Polyakov loop
  by z. Consequence (finite volume, exact): <P> is invariant under
  multiplication by every z in the image of the fundamental character, so
  <P_f> = 0 whenever chi_f carries the center nontrivially. The Polyakov
  loop is an order parameter only in infinite volume; at finite volume its
  vanishing is a symmetry identity, not confinement. Keeping this straight
  is an F-YM-CONFLATE guard. [T]

## 3. Theorem 1 (Elitzur, Z2, quantitative and volume-uniform)

Setting: any finite lattice (any d, any b.c.), Wilson action, plus a
symmetry-breaking source h * sum_l sigma_l, h >= 0.

THEOREM. Let f be any observable that is ODD under the flip of all links
incident to some fixed site x (example: f = sigma_l with l incident to x).
Then, uniformly in the lattice, in beta, and in the couplings of any
additional gauge-invariant terms in the action:

    |<f>_{beta,h}| <= ||f||_inf * tanh(q_x h),

where q_x = #links incident to x (= 2d on the hypercubic bulk). In
particular <f> -> 0 as h -> 0 uniformly in volume: the local symmetry
cannot break spontaneously.

PROOF. Let phi_x be the involution of configuration space flipping the q_x
links at x. The Wilson term W and every gauge-invariant term are invariant
under phi_x (each plaquette contains 0 or 2 links at x); the source term
transforms as M(phi_x sigma) = M(sigma) - 2 K_x(sigma) with
K_x = sum_{l at x} sigma_l, |K_x| <= q_x; and f(phi_x sigma) = -f(sigma).
Pairing each configuration with its image:

    N := sum f e^{beta W + h M} = (1/2) sum f e^{beta W + h M} (1 - e^{-2 h K_x}),
    Z  = (1/2) sum   e^{beta W + h M} (1 + e^{-2 h K_x}).

Pointwise, |1 - e^{-2hK}| = (1 + e^{-2hK}) |tanh(hK)| <= (1 + e^{-2hK})
tanh(q_x h) by monotonicity of tanh and |K_x| <= q_x. Hence |N| <=
||f||_inf tanh(q_x h) Z. QED.

Grade [T]; oracle section [3] checks the bound and the volume-uniformity at
beta = 0.6, h in {0.2, 0.1, 0.05} (2D: bound tanh 4h; measured <sigma_l>
values 0.211/0.101/0.050, volume spread < 6e-3 across 2x2, 2x3, 3x3).
Two remarks. (i) The proof used only ONE site's gauge freedom - this is the
formal content of "Elitzur is a local theorem". (ii) The same pairing gives
the general-G statement with tanh replaced by an explicit compact-group
bound; frozen as YM1-E-G [statement only, proof route identical], to be
formalized after the Z2 case ships.

Lean decomposition (PKG-YM1-A): (a) the involution and its three covariance
properties - finite algebra; (b) the pointwise inequality
|1-e^{-2a}| <= (1+e^{-2a}) tanh b for |a| <= b - Mathlib real analysis;
(c) the pairing identity - Finset.sum over an involution. All three are
Aristotle-shaped; (b) is the only analysis.

## 4. Theorem 2 (2D exact solution, finite G) and Theorem 2' (Z2 torus)

LEMMA 2a (fusion). For a class function w on finite G and any A in G:

    sum_h w(h) chi_R(A h) = |G| w_hat_R chi_R(A) / d_R        (convention C-5).

Proof: expand w in irreducible characters and apply Schur orthogonality in
convolution form (chi_S * chi_R = delta_{SR} |G| chi_R / d_R). [T; Mathlib
finite character theory suffices - NO Peter-Weyl needed for finite G.]

LEMMA 2b (tree gauge / independence). On a connected graph, fixing a
spanning tree's links to the identity is a legitimate change of variables
costing |G|^(V-1); on a 2D open rectangle with the comb tree the remaining
free links are in triangular bijection with the plaquette holonomies, which
are therefore INDEPENDENT and Haar/uniform-distributed apart from their own
plaquette weights. Proof: triangular change of variables, induction along
the comb. [T]

THEOREM 2. On the open 2D lattice with P plaquettes, weight per C-4:

    Z_open = |G|^(V-1) (|G| w_hat_0)^P,
    <W_R(C_A)> = d_R gamma_R^A,   gamma_R = w_hat_R / (d_R w_hat_0),

for any contractible rectangular loop C_A of area A. Hence the EXACT area
law with string tension sigma_R = -log gamma_R, for every irreducible R
with w_hat_R > 0. Proof: Lemma 2b reduces <W_R> to an expectation over A
independent plaquette variables (the conjugations relating loop holonomy to
plaquette holonomies drop against L1); Lemma 2a applied A times starting
from chi_R(e) = d_R gives gamma_R^A d_R. QED. [T]

Oracle section [4] verifies both displays for S3 (nonabelian: d = 1,1,2) at
beta = 0.5 to 1e-10 relative, all three irreps, areas 1 and 2 - the fusion
machinery is pinned beyond the abelian case. Z2 special case: gamma_sign =
tanh beta, sigma = -log tanh beta.

THEOREM 2' (Z2 torus, Lx, Ly >= 2). Z = 2^E cosh^P(beta) (1 + t^P) and, for
a contractible loop of area A, <W> = (t^A + t^{P-A}) / (1 + t^P).
Proof: expand each plaquette factor as cosh(beta)(1 + t s_p); a monomial
survives the configuration sum iff every link is covered an even number of
times; on the 2D torus each link lies in exactly two plaquettes, so the
surviving plaquette sets S satisfy "every link borders 0 or 2 elements of
S", i.e. the indicator of S is locally constant on the connected dual
graph: S = empty or S = all. With the loop insertion the condition becomes
boundary(S) = C, whose two solutions are the inside (area A) and the
outside (area P-A). QED. [T; oracle section 1, three volumes, 1e-12]

The finite-size term t^{P-A} is exact torus physics, and the oracle
matching it at 1e-12 is the strongest convention pin in the suite: any
orientation, indexing, or weight slip breaks it.

Lean decomposition: PKG-YM1-B = Theorem 2' (the even-cover argument is a
self-contained finite combinatorics gem: "a subset of the plaquettes of a
2-complex in which every link has even incidence is a dual-component
union"); PKG-YM1-C = Lemmas 2a/2b + Theorem 2 on Mathlib character theory.

## 5. Theorem 3 (the reflection-positivity engine: character positivity)

This section is the analytical core of the YM3 rung; it reduces reflection
positivity and transfer positivity for finite G to five lines of character
theory plus Gram bookkeeping.

THEOREM 3 (character positivity of Wilson weights). Let chi be any
character of a finite group G (any nonnegative-integer combination of
irreducible characters), beta >= 0, and w = exp(beta Re chi). Then EVERY
coefficient w_hat_R >= 0.

PROOF. (i) Re chi = (chi + conj chi)/2, and conj chi is the character of
the conjugate representation, so 2 Re chi is a character. (ii) Products of
characters are characters (tensor products), so (Re chi)^k is, for every k,
a nonnegative rational combination of irreducible characters. (iii) The
exponential series has nonnegative coefficients beta^k / k! (beta >= 0) and
converges absolutely pointwise on the finite set G, so w is a nonnegative
combination of irreducible characters; its coefficients in the chi_R basis
are exactly the w_hat_R. QED. [T]

COROLLARY 3a (finite Bochner, both directions Gram). For a class function
w, the kernel K(g,h) = w(g h^{-1}) on G x G is PSD iff all w_hat_R >= 0.
(<=): chi_R(g h^{-1}) = sum_{ij} rho_R(g)_{ij} conj(rho_R(h)_{ij}) for a
unitary realization - a Gram matrix - and a nonnegative combination of
Gram matrices is PSD. (=>): test K against the vectors (chi_R(g))_g.
[T]

Structural remark [orig, cross-track]. This is the SAME move as
`GateMP.SCGGramPositivity` on the measure track: strong positivity of the
SCG decoherence functional and reflection positivity of the Wilson ensemble
are both instances of "exhibit the bilinear form as a Gram matrix". The
planning document's shared-toolbox claim (section 0) is hereby a
lemma-level identity, not an analogy: one formalized Gram/PSD module serves
both tracks.

COROLLARY 3b (transfer positivity). With C-8: K = tensor product of PSD
per-link kernels is PSD; conjugation by the positive diagonal V^(1/2)
preserves PSD; the Gauss projector commutes into a PSD compression. Hence
T is PSD, its physical restriction is PSD, and D12's gap is well-defined
with lambda_0 > 0. [T; oracle sections 6-8: PSD verified numerically for
Z2 (1+1D, 2+1D), and w_hat_R >= 0 verified for Z2, Z16, S3 at
beta in {0.1, 0.5, 1, 2}, including direct PSD of the S3 kernel.]

Note for U(1) and compact G: the analogue of Theorem 3 needs the character
expansion on the compact group (Peter-Weyl) - this is precisely where
YM2-PW gates, and only there. Finite G (hence the Z2/toric-code paper and
the QEC audience) is fully served by the above.

## 6. YM3 statement freeze (link-reflection positivity + reconstruction)

Frozen statement RP-LINK (finite G first). Lattice symmetric under the time
reflection theta through a plane bisecting a layer of temporal links; A_+
the algebra of functions of links strictly on the positive side. For the
Wilson ensemble with weight per C-4 (more generally: any per-plaquette
class-function weight with all w_hat_R >= 0):

    <(theta F)* F> >= 0   for all F in A_+.

Proof route (complete modulo bookkeeping, to be formalized as PKG-YM3-A):
condition on the cut; the Boltzmann factor factorizes across the cut as a
product over cut temporal links of K(g^-, g^+) with K PSD by Theorem 3 +
Corollary 3a; writing K = sum_j lambda_j v_j(g^-) conj(v_j(g^+)) turns
<(theta F)* F> into sum over j-tuples of |integral|^2. The reflected side
contributes the conjugate through theta-covariance of the action. [T-route]

Care flags (normative): (i) LINK reflection is frozen first; SITE reflection
is a separate statement with a different kernel and is NOT interchangeable
- the Osterwalder-Seiler distinction stays in the debt register as
attribution + statement-shape debt for the compact-G paper. (ii) The
reconstruction chain (null space quotient, GNS Hilbert space, T as a
positive contraction after normalization, Hamiltonian H = -log T on the
physical sector) is standard linear algebra at finite volume and belongs to
the same package. (iii) The C-8 identity Z = 2^(L nt) Tr[(T P_G)^{nt}]
(oracle-pinned constant, integer-exact at two sizes) is the finite
consistency check that the reconstruction must reproduce; formalizing that
identity is the acceptance test of PKG-YM3-A.

Deliverable claim for the YM3 paper: "reflection positivity and the
reconstructed positive transfer operator for lattice gauge theory with
arbitrary finite gauge group, kernel-checked" - flagship-grade per the
planning document, and by section 5 it is now reduced to finite mathematics
end to end. No hard analysis remains in the finite-G YM3 rung. [orig
assessment; this is the session's main strategic finding]

## 7. YM4 pipeline freeze (strong coupling; Z2 in d >= 3 first)

Polymer representation [derivation, T]. Expanding every plaquette factor
(C-7 style) reduces Z / (2^E cosh^P) to the sum over plaquette sets with
every link evenly covered; in d >= 3 these are closed surfaces; connected
components are the polymers, with activity t^{|S|} and incompatibility =
sharing a link. The Wilson loop inserts a boundary condition dS = C, and
the leading surface is the minimal spanning surface of area A.

Frozen import KP (Kotecky-Preiss criterion, Ueltschi form) [import; absent
from Mathlib per today's check; the target of PKG-YM4-A]: for polymer
weights with sum_{gamma' incompatible with gamma} |w(gamma')| e^{a(gamma')}
<= a(gamma), the cluster expansion for log Z converges absolutely,
uniformly in volume, with the standard tail bounds. This module is the
single most reusable object on the ladder (the planning document already
earmarks it for the measure track's quantum-growth estimates).

Quantitative window [T-route, constants deliberately lossy]: plaquette
adjacency degree Delta_d <= 8d - 12 (each of 4 links lies in 2(d-1)
plaquettes, minus self); connected-set counting #(connected S containing a
fixed plaquette, |S| = n) <= (e Delta_d)^{n-1}; with a(gamma) = |gamma| the
KP condition holds whenever

    t < t_0(d) := 1 / (e^2 Delta_d),    i.e. t_0(3) ~ 0.0113, t_0(4) ~ 0.0068.

Frozen deliverable statements, each uniform in volume for t < t_0(d):

- YM4-a (area law): -log <W(R x T)> >= sigma(t) RT - c_d (R + T), with
  sigma(t) >= -log t - delta_d(t) and delta_d(t) -> 0 as t -> 0. The
  precise correction exponent in delta_d is fixed DURING formalization, not
  pre-claimed; the pre-registered content is positivity of sigma and the
  leading -log t.
- YM4-b (exponential clustering): truncated correlations of local
  observables decay as e^{-m(t) dist} with m(t) > 0 uniform in volume.
- YM4-c (transfer gap): Delta_Lambda >= m(t) > 0 uniformly in volume, in
  the D12 sector (with the flux-sector qualifier from the oracle finding).

Scope guard restated from the planning document: t < t_0 is the WRONG side
of the continuum limit; YM4 certifies known physics in a known regime and
claims nothing about the crossover (that is YM6, open, no route known).

## 8. QCD1 statement freeze (finite Banks-Casher shadow)

Setting: overlap operator D on a finite lattice in a fixed background (the
C1/C2 machinery), Ginsparg-Wilson relation, spectrum on the GW circle;
lambda_hat = the standard circle-to-imaginary-axis map; nu = the chiral
index; m > 0 a valence mass.

Frozen statement QCD1-i (exact spectral identity) [T-route on C2 assets]:
the m-regularized condensate admits the exact finite decomposition

    Sigma_Lambda(m) = |nu| / (m V)  +  (2m/V) sum_{lambda_hat_j > 0}
                       1 / (m^2 + lambda_hat_j^2),

zero modes separated, nonzero modes in chiral pairs. Pure finite linear
algebra adjacent to `epsCFC_trace_eq_inertia`; a natural Aristotle package
(PKG-QCD1-A).

Frozen statement QCD1-ii (sandwich): if the positive spectrum has density
bounds rho_- <= rho_Lambda(eps) <= rho_+ on (0, eps_0], then

    pi rho_- - err <= Sigma_Lambda(m) - |nu|/(mV) <= pi rho_+ + err

with err(m, eps_0, V) explicit. The Banks-Casher LIMIT statement (V to
infinity, then m to 0) is commentary, not a claim; the finite theorem is
the identity plus the sandwich. This keeps the F2.0 lesson: no motivated
redefinition - the finite result is labeled as the shadow, not the theorem.

## 9. Aristotle package map (priority order)

1. PKG-YM3-A (Theorem 3 + Cor 3a/3b + RP-LINK): small, finite, and it is
   the flagship's engine. Highest value density on the board.
2. PKG-YM1-A (Elitzur, Theorem 1): three sub-lemmas, one line of real
   analysis; the ladder's first named-theorem publication unit.
3. PKG-YM0-A (compile + extend `YM0Seed.lean`): the seed's five theorems;
   currently UNCHECKED drafts.
4. PKG-YM1-B (Theorem 2', even-cover combinatorics): self-contained.
5. PKG-YM1-C (fusion + Theorem 2 on Mathlib character theory): the
   nonabelian exact solution; needs ORACLE-TODO-1 closed first.
6. PKG-YM0-B (general-G gauge invariance + Z-invariance via Fintype/Haar).
7. PKG-YM4-A (Kotecky-Preiss, standalone): the big reusable module; start
   only after 1-2 ship (budget rule: one active YM job).
8. PKG-QCD1-A (spectral identity + sandwich): cheap, high native synergy;
   schedule opportunistically alongside C2 work.

## 10. Oracle cross-reference

    oracle section  pins / corroborates
    [1]             C-3, C-4, C-7; Theorem 2' (both displays, 1e-12)
    [2]             L2 (Z2)
    [3]             Theorem 1 (bound + volume uniformity)
    [4]             C-5, C-6; Theorem 2 incl. nonabelian fusion (1e-10);
                    Theorem 3 hypothesis for S3
    [5]             L1/L2 (nonabelian, class invariance)
    [6]             C-8 identity, pinned constant c = L*nt; Cor 3b (1+1D)
    [7]             Cor 3b (2+1D); D12 flux-sector qualifier
    [8]             Theorem 3 / Cor 3a across Z2, Z16, S3

## 11. Session claims ledger

- [T] Theorems 1, 2, 2', 3, Corollaries 3a/3b, Lemmas L1-L5, 2a/2b:
  complete finite-level proofs in this document, self-contained, zero
  correctness debt; formalization pending per section 9.
- [T-route] RP-LINK, QCD1-i: proof routes fixed, bookkeeping to Lean.
- [M] Oracle v0.1: 30/30, versions recorded.
- [C -> retired] none opened.
- DRAFT (no grade) `YM0Seed.lean` until compiled.
- [orig] the D12 flux-sector qualifier; the correctness/attribution debt
  split; the Gram identity between SCG strong positivity and RP (strategic:
  the finite-G YM3 flagship is now finite mathematics end to end).
- New external imports introduced: NONE beyond the planning document's
  register (KP restated; attribution names unchanged).

## 12. In-repo verification addendum (2026-07-03, claude)

Executed after this document and its companion artifacts were delivered:

- **`YM0Seed.lean` COMPILED** - the author's "NOT kernel-checked" flag was
  warranted: the nil case of `hol_gauge` failed as written (`cases g x`
  before normalization misses the `g (walkEnd x [])` occurrence, which is
  definitionally but not syntactically `g x`). One-line fix
  (`simp only [hol, walkEnd]` before the case split); everything else
  compiled as delivered. Axiom audit: `hol_gauge`, `hol_gauge_closed`,
  `plaq_gauge`, `plaqSpins_gauge` depend on NO axioms; `gauge_comp`,
  `gauge_invol` on `[Quot.sound]` only (funext). Integrated as
  `PhysicsSM/Draft/NullEdge/GateYM/Z2GaugeCore.lean` with aggregator
  `GateYM.lean` (`lake build PhysicsSM.Draft.NullEdge.GateYM` green).
  **PKG-YM0-A is RETIRED AS DONE** - no Aristotle job was needed.
- **Oracle independently reproduced**: `Scripts/oracle/validate_lgt_core.py`
  rerun in a second environment (python 3.12.10, numpy 2.4.3, Windows, vs
  the delivery log's python 3.12.3 / numpy 2.4.4) - **30/30 PASS**.
  Delivery-run log archived at `AgentTasks/ym-oracle-run-2026-07-03.log`.
  Review nit (non-blocking): section [3]'s "h->0 decay visible" row is a
  hardcoded-True check (cosmetic; the surrounding rows carry the content);
  fold into ORACLE-TODO list as ORACLE-TODO-2 alongside ORACLE-TODO-1
  (complex-character fixture).
- **Independent review of the mathematics** (claude): Theorem 1's pairing
  proof, Theorem 3's character-positivity chain, Corollary 3a's two Gram
  directions, and the KP window constants (t_0(3) = 1/(12 e^2) ~ 0.0113,
  t_0(4) = 1/(20 e^2) ~ 0.0068 from Delta_d = 8d - 12) all check by hand.
  The "0 or 2 incident links per plaquette" step in Theorem 1 was verified
  to survive the L = 2 torus edge case (doubled edges are distinct links).
- **PKG-YM1-A SUBMITTED** as Aristotle job f501f8c8
  (`AgentTasks/aristotle-standalone/ym1-elitzur-core-20260703`): the
  freeze's decomposition items (b) + (c) as two abstract targets
  (`abs_one_sub_exp_le_tanh`, `abstract_elitzur_bound`); statements
  typechecked. Item (a) (the lattice covariance layer) is deliberately kept
  in-repo: the Wilson-term invariance under the one-site flip is already
  the kernel-checked `plaqSpins_gauge` special case, and the source-term
  bookkeeping joins at integration time. This is the ladder's ONE active
  Aristotle job per the budget rule. PKG-YM3-A remains next in queue and
  needs a Mathlib character-theory API exploration session before its
  statement file is authored (noted; not attempted blind).

## 13. PKG-YM1-A harvest (2026-07-03, claude)

Aristotle job f501f8c8 COMPLETE: both `abs_one_sub_exp_le_tanh` and
`abstract_elitzur_bound` proved, NO statement changed, no falsity
encountered (the file's own summary: "Both statements are true as written").
Verified: statement-diff clean, clean `lake env lean` compile, axiom
footprint `[propext, Classical.choice, Quot.sound]` for both. Integrated as
`PhysicsSM/Draft/NullEdge/GateYM/ElitzurCore.lean`, wired into the
`GateYM.lean` aggregator (`lake build PhysicsSM.Draft.NullEdge.GateYM` =
8028 jobs green).

Proof method (for the record): Target 1 via `t = exp(-a)`, the
sinh/cosh expansion of `tanh`, and `nlinarith`; Target 2 via
`Equiv.sum_comp` reindexing through the involution to the paired forms,
termwise bound via Target 1, triangle inequality. One linter-only nit
(unused `hb` in the final proof term - harmless, hypothesis kept since the
statement must not change).

**PKG-YM1-A is RETIRED AS DONE.** Remaining PKG-YM1-lattice bookkeeping
(instantiate the involution as the one-site gauge flip; Wilson-term
invariance is the already-proved `Z2GaugeCore.plaqSpins_gauge`) is
in-repo assembly work, not a fresh Aristotle target - natural next step
whenever the YM1 paper layer is assembled, or folded into PKG-YM3-A's
session. Next queued rung unchanged: PKG-YM3-A, pending the Mathlib
character-theory API exploration.

## 14. PKG-YM1-lattice assembly (2026-07-04, claude)

**PKG-YM1-lattice is CLOSED**, in-repo, no Aristotle job needed. New module
`PhysicsSM/Draft/NullEdge/GateYM/ElitzurLattice.lean`, wired into the
`GateYM.lean` aggregator (`lake build PhysicsSM.Draft.NullEdge.GateYM` =
8029 jobs green). This instantiates `ElitzurCore.abstract_elitzur_bound`
(section 13) at the concrete Z2 lattice, recovering Theorem 1 in full:

- `flipAt x0 := Z2GaugeCore.gauge (fun v => decide (v = x0))` - the one-site
  flip is exactly a `Z2GaugeCore.gauge` transformation at the indicator of
  `x0`.
- `flipAt_involutive` - direct instance of the already-proved `gauge_invol`.
- `plaqSpins_flipAt_invariant` - direct instance of the already-proved
  `plaqSpins_gauge`; covers the Wilson action and any Wilson-loop insertion,
  for any `beta`, since gauge invariance is all that's used (item (a) of the
  freeze's decomposition, section 3).
- `sourceTerm_flipAt` - the new bookkeeping lemma: splitting the edge set `E`
  by incidence to `x0` (`Finset.sum_filter_add_sum_filter_not`) and using
  that `spin` flips sign exactly on incident, non-self-loop links,
  `sourceTerm E (flipAt x0 U) = sourceTerm E U - 2 * K E x0 U` with `K E x0 U`
  the freeze's `K_x`. Requires the natural hypothesis `NoSelfLoopAt E x0`
  (physical: no `(x0,x0)` lattice link).
- `abs_K_le_card` - `|K E x0 U| <= q_x0` (the coordination number
  `(linksAt E x0).card`), termwise from `|spin _| <= 1`.
- `elitzur_bound` - assembles all of the above into
  `abstract_elitzur_bound` with `K := h * (K E x0 ·)` and
  `b := h * q_x0`, giving exactly Theorem 1: `|sum f w| <= c * tanh(q_x0 h)
  * sum w`, volume-uniform, coupling-uniform (any `beta`), and robust to any
  additional gauge-invariant action term.

Verified: `lake env lean` clean (0 errors, 0 `s o r r y`), axiom audit via
`lean-lsp`'s `lean_verify` on all 5 new theorems: `flipAt_involutive` and
`plaqSpins_flipAt_invariant` at `[propext, Quot.sound]`;
`sourceTerm_flipAt`, `abs_K_le_card`, `elitzur_bound` at
`[propext, Classical.choice, Quot.sound]`. No `n a t i v e _ d e c i d e`.
One implementation note for future editors of this file: `LinkField V` is a
plain `def` (`V -> V -> Bool`), so instance search does not unfold it on its
own - a local `instance : Fintype (LinkField V)` (via `inferInstanceAs`) is
required before any `sum over LinkField V` or call into
`abstract_elitzur_bound` typechecks.

**This closes the full quantitative Elitzur theorem for the Z2 ladder**
(Theorem 1, freeze section 3, top to bottom, kernel-checked). Next queued
rung unchanged: PKG-YM3-A, pending the Mathlib character-theory API
exploration session (Schur orthogonality in convolution form, tensor-product
character multiplicativity - see that session's notes for exact lemma
names once run).

## 15. PKG-YM3-A prep: Mathlib character-theory API map (2026-07-04, claude)

Exploration session (via the `lean-explore` MCP tool, offline semantic
search over Mathlib) for Theorem 3 (section 5) and Corollary 3a, run before
authoring any PKG-YM3-A statement file, per section 12's queued next step.
All items live in `Mathlib.RepresentationTheory.Character` unless noted;
`import Mathlib` (this project's existing style) covers everything below.

**Ready to use, directly matches the freeze's Theorem 3 proof sketch:**

- `Representation.character (ρ : Representation k G V) (g : G) : k` -
  `LinearMap.trace k V (ρ g)`. Generic in `k`/`G`; the sum-over-group steps
  below need `[Fintype G]`.
- `Representation.char_tensor : (tprod ρ σ).character = ρ.character *
  σ.character` - **exactly** step (ii) ("products of characters are
  characters", tensor product = pointwise product of characters, as
  functions `G → k`). `FDRep.char_tensor` is the categorical-layer twin.
- `Representation.char_orthonormal [IsIrreducible ρ] [IsIrreducible σ] :
  (Nat.card G : k)⁻¹ * ∑ g, ρ.character g * σ.character g⁻¹ = if
  Nonempty (Equiv σ ρ) then 1 else 0` - the Schur orthogonality relations
  themselves, stated for "algebraically closed field whose characteristic
  doesn't divide the order of the group"; `k = ℂ` (char `0`) satisfies this
  side condition unconditionally for every finite `G`, so this applies
  as-is. Rests on `Representation.card_inv_mul_sum_char_mul_char_eq_finrank`
  (scalar product of two characters = `finrank` of the intertwiner space,
  i.e. `dim Hom_G(V,W)` - the pre-Schur averaging identity) and Schur's
  lemma proper, `Representation.IsIrreducible.bijective_or_eq_zero`.
- `Representation.IsIrreducible` - `abbrev` for `IsSimpleOrder
  (Subrepresentation ρ)` (module `Mathlib.RepresentationTheory.Irreducible`).
  Bridges to `Representation.irreducible_iff_isSimpleModule_asModule` if the
  simple-module route is ever more convenient.
- `Representation.directSum` / `directSum_apply` - direct sum of
  representations (for "nonnegative-integer combination of irreducible
  characters" = character of a direct sum of copies of irreducibles).
- `Representation.char_linHom (linHom ρ σ).character g = ρ.character g⁻¹ *
  σ.character g` and `Representation.linHom` (the `V →ₗ[k] W` conjugation
  representation) - the mechanism behind `char_tensor`/`char_dual` (proved
  via the `Equiv.dualTensorHom` natural iso); useful if a Hom-space
  argument is more convenient than raw tensor/dual bookkeeping.
- `Representation.char_dual (g) : ρ.dual.character g = ρ.character g⁻¹` -
  relates the dual representation's character to `chi(g⁻¹)`, NOT directly
  to the complex conjugate `conj(chi(g))` (see the gap below).

**Naming trap for whoever writes the statement file:** `Representation.char_conj`
/ `FDRep.char_conj` do **NOT** mean "complex-conjugate character". Their
content is `ρ.character (h * g * h⁻¹) = ρ.character g` - the CLASS-FUNCTION
property (conjugation-invariance under the group action), proved from
`char_mul_comm` (`chi(gh) = chi(hg)`, trace cyclicity). Do not cite
`char_conj` for step (i) of Theorem 3's proof; it answers a different
question.

**The one identified gap: step (i) needs unitarity, and Mathlib does not
appear to have it packaged.** Theorem 3's step (i) ("`Re chi = (chi + conj
chi)/2`, and `conj chi` is the character of the conjugate representation")
uses the pointwise COMPLEX conjugate of the character. The searches above
(and further queries for "unitary representation finite group", "averaged
invariant inner product", "matrix of finite order diagonalizable roots of
unity", "isometry group action Hilbert space") turned up
`Representation.averageMap` / `isProj_averageMap` (Maschke's averaged
PROJECTOR for invariant complements - a different construction) and
generic unitary-GROUP api (`Matrix.unitaryGroup`, `Unitary.*`), but no
ready "every finite-dimensional complex representation of a finite group
is (equivalent to) unitary" theorem, and no direct
`conj (ρ.character g) = ρ.character g⁻¹` lemma. That identity is TRUE only
for unitary (or, over `ℝ`/`ℂ`, orthogonal/unitary-equivalent) `ρ`; `char_dual`
alone gives `chi(g⁻¹)`, not `conj(chi(g))`, without a unitarity bridge.

Two ways to close the gap, for the PKG-YM3-A statement-file session to
choose between (not decided here - deliberately left as a design choice,
not attempted blind, per the section 12 note):

1. **Add unitarity as an explicit hypothesis** on the representation used
   in Theorem 3 (e.g. state it for `ρ : G →* Matrix.unitaryGroup n ℂ` or
   carry `∀ g, star (ρ g) = (ρ g)⁻¹`/`(ρ g)ᴴ * ρ g = 1` as a side
   hypothesis, then `conj (ρ.character g) = ρ.character g⁻¹` is a short
   direct computation from `Matrix.trace` and the unitarity equation,
   no new structural theorem needed). Physically free: the Wilson action
   always uses a unitary representation of the (compact or finite) gauge
   group by construction, so this loses no generality for the YM3 use
   case. RECOMMENDED - smallest Lean surface area, matches how the
   existing `GateYM`/`GateMP` modules prefer explicit hypotheses over
   reproving general structure theorems.
2. **Prove unitarizability in-repo**: every `g : G` (`G` finite) has
   `ρ g` of finite order dividing `|G|`; in characteristic `0` a
   finite-order linear map is diagonalizable (semisimple, since `x^n - 1`
   is separable) with eigenvalues that are roots of unity, and
   `conj(lambda) = lambda⁻¹` for `lambda` on the unit circle, giving
   `conj(chi(g)) = chi(g⁻¹)` directly without a full averaged-inner-product
   construction. Self-contained but real new Lean content (diagonalizability
   + eigenvalue argument), not a one-line citation - candidate Aristotle
   target if option 1 is rejected as too restrictive for a future
   compact-`G` generalization.

**Bottom line for the statement-file session:** everything needed for
Theorem 3 steps (ii)-(iii) and Corollary 3a's Gram direction is already in
Mathlib and named above; step (i) needs one upfront design decision
(hypothesis-add vs. prove-unitarizability) before the statement is written,
not a blind proof attempt. Corollary 3b's PSD/Gram bookkeeping reuses the
already-proved local toolbox (`Matrix.PosSemidef`,
`Matrix.PosSemidef.mul_mul_conjTranspose_same`,
`Matrix.PosSemidef.conjTranspose_mul_mul_same` - see
`GateMP/SCGGramPositivity.lean`), not new search.
