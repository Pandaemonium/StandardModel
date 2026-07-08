# Fable handoff: attack plans for the twelve hardest open pieces

Date: 2026-07-07 (late).
From: Fable 5, synthesis seat, final hours of availability this run.
To: Codex 5.5 (executor, repo-native) and Opus (external reviewer, called
through `Scripts/autonomous_loop/send_claude_review.py` with standalone
prompts and verbatim source per AGENTS.md).

Scope: the twelve open pieces Codex ranked hardest (numbering below follows
Codex's list). For each: the sharpened target, the recommended route, the
pitfalls, and pre-registered outcomes. No Lean in this document - it is
strategy for whoever builds the packages. Claim calculus: everything here is
`C` (plan/conjecture with gates) unless explicitly marked as landed (`M`).

Ground rules this document assumes (do not relitigate): kernel is truth;
flagship landings need guard pins; the four over-claim modes get reviewed
before any headline; spectral language stays forbidden until the positivity
crux closes; `J` (Krein) and `J_R` (real structure) never collide; Hilbert
adjoint and Krein `#` never blur.

---

## 0. Triage

| # | Piece | Cost | Payoff | First action |
|---|-------|------|--------|--------------|
| 11 | RG-Schur mass witness | hours | thesis-level | build the 2x2 light-cone witness below |
| 10 | Q08 literal radical | days | infra | adapted-basis package (skip the tensor iso) |
| 7 | KP fixed-forest injection | days | unblocks YM lane | ship the file's own sketch to Aristotle |
| 2 | Q11 RC0 group level | days | unblocks I1 lane | re-base on `exteriorPower.map` |
| 1 | Carrier physical sector | staged | program-central | Stage-3 Gauss interface (below) |
| 3 | Nonabelian Q_C | med, oracle-first | Move-2 crux | two-face SU(2) oracle computation |
| 12 | Koide / kappa gate | probe + analysis | mass values | run probe P1; then SUB-NAT |
| 4 | E-slot trinity split | definition-bound | gravity slot | draft T/S definitions, cross-review |
| 5 | Octonion -> Lambda(C^3) | med, finite | SM-selection bridge | intertwiner dictionary |
| 6 | Q12 KO/sector gates | convention-bound | NCG contact | pin the KO sign table as fixture |
| 8 | Q09 Reeh-screen gate | short + witness | entropy lane | Schmidt-rank cyclicity theorem |
| 9 | Q10 d=4 corner | short | dimension story | epsilon-pairing uniqueness, concrete |

One deliberate change to Codex's ordering: I elevate the RG-Schur witness
(#11) to first position. It is hours of work, I have already done the algebra
(section 11 below, including the predicted coefficient), and if it lands the
program gains its strongest single sentence: kinematically, mass is pairwise
null disagreement (the trusted `det P` theorem); RG-dynamically, decimation
converts the same pairwise disagreement invariant into non-null effective
terms. One invariant, two theorems, two independent derivations.

Codex's payoff/skill split (conceptual: 1,3,4,5,6; Lean-native: 2,7,10,11)
is right. The Opus seat is most valuable on the definition-bound pieces
(4, 8-gate formulation, 6-sign-table provenance, 12-SUB-NAT analysis) where
the risk is stating the wrong thing, not proving it.

---

## 1. Carrier physical-sector theorem (dim(V'/N) = ind(D))

Anchors (all landed, guard-pinned):
`PhysicsSM/Draft/NullEdge/Carrier/KreinPositiveSectorWitness.lean`
(`KugoOjima.nonvacuous_positive_sector` on the (2,1) model;
`nondegenerate_but_indefinite_no_go` on (1,2));
`CarrierWardDescentWitness.lean` (`quotient_ward_action` - the
representative-vs-quotient gap is closed for the finite (2,1) witness);
`CarrierIndexProtection.lean` (chiral index = graded dimension under
rank-symmetry). Paper-level proof map: `AgentTasks/fable_parallel/Q01_answer.md`
Theorem A and hypotheses (H*).

Sharpened target, in three stages:

- Stage A (abstract quotient theorem, standalone Aristotle). Finite
  complex vector space V with Hermitian form of inertia (p,q); a subspace
  Gamma' with hypotheses (i) Gamma' isotropic, (ii) D Gamma' <= Gamma'
  (finite Ward), (iii) dim Gamma' = q realized by an explicitly given
  adapted basis. Conclusions: N = Gamma' inside V' = Gamma'-perp, the
  quotient form on V'/N is positive definite, and dim(V'/N) = p - q.
  Then compose with the index layer: p - q = ind(D) under the
  rank-symmetry hypotheses `CarrierIndexProtection` already uses.
- Stage B (vacuity guard). Re-derive `nonvacuous_positive_sector` as a
  corollary of Stage A instantiated on the (2,1) model. If the abstract
  hypotheses cannot reproduce the landed witness, the abstraction is wrong;
  fix the hypotheses, not the witness.
- Stage C (the real content). Define Gamma' on the actual carrier from
  Gauss/closure covectors of the finite 2-complex; prove isotropy from
  null-ness of the covectors; prove the Ward inclusion from the structure
  of D = sum_e c(alpha_e) nabla_e + Gamma phi. This is the only stage that
  can fail for a mathematical reason, and per the lane docket it is the
  declared next HSTAR/Q01 blocker (the "Gauss/closure/index-completeness
  interface").

Key strategic move: do NOT formalize Witt decomposition. Mathlib has no
usable Krein/Witt theory; chasing it is a month of infrastructure. Instead
take the adapted basis (positive block / negative block / isotropic
constraint block) as an interface HYPOTHESIS of Stage A - the project's
definitional-interface Aristotle pattern - and make Stage C's job to
construct that basis on the concrete carrier. Concrete models supply the
basis by construction; the abstract theorem never needs existence.

Pitfalls: vacuity (Stage A without Stage B is not landable as flagship);
hypothesis creep (each (H*) clause must be checkable on the two-triangle
complex); the completeness question "are the Gauss covectors ALL of the
constraints" is a physics convention - state it as a named hypothesis, do
not smuggle it.

Pre-registered outcomes: if the Ward inclusion D Gamma' <= Gamma' fails on
the two-triangle carrier, that is a discovery, not a defeat - it means the
physical constraint set is D-generated rather than Gauss-generated;
document and re-run Stage C with the D-orbit completion of the Gauss set.

---

## 2. Q11 RC0 / unimodularity at group level

Anchors: `PhysicsSM/Draft/NullEdge/GateI1/Q11GroupAction.lean` -
`lambdaAction`, `lambdaLinearMap`, identity action, support lemmas landed;
the claim boundary (lines 21-25) names exactly what is missing: finite
Cauchy-Binet functor law, Jacobi complementary minors, determinant cocycle,
group-level RC0; plus the separate `gl_fiber` interleaving-sign lemma.

Route (this is the main value-add): do NOT prove matrix Cauchy-Binet by
minor combinatorics. Re-base the compound-matrix layer on Mathlib's
exterior-power functoriality, which I verified exists in the pinned
snapshot: `exteriorPower.map`, `exteriorPower.map_comp` (the functor law,
essentially free), `exteriorPower.linearMap_ext` (uniqueness). Then the
only genuinely new lemma is basis-level: the matrix of `exteriorPower.map f`
in the induced basis has k-minors as entries. Cauchy-Binet becomes
"matrix of a composition = product of matrices". Check what induced-basis
API the snapshot has before packaging (search lean-explore for the exterior
power basis; do not trust memory for the name).

For the determinant cocycle / Sylvester-Franke
(det(Lambda^k A) = (det A)^binom(n-1,k-1)): two routes, verify names first -
(a) triangularization over C (if a Schur-triangulation exists in the pinned
Mathlib) making eigenvalues of Lambda^k A the k-fold products, or
(b) the generic-matrix transfer idiom (prove the identity for the universal
matrix over a polynomial ring, then specialize - the pattern Mathlib's
Cayley-Hamilton proof uses). Route (b) is self-contained if (a) is missing.

Descope question to answer BEFORE spending: is Jacobi complementary minors
actually load-bearing for RC0, or is the determinant cocycle plus
integrality enough for the unimodularity transfer? If the latter, park
Jacobi. If Jacobi is needed, route it through the perfect pairing
Lambda^k V x Lambda^(n-k) V -> Lambda^n V rather than index-set signs.

Pitfall: the interleaving-sign lemma is pure sorted-index bookkeeping -
freeze the index-sort convention once via a definitional interface and
never re-derive signs inline.

---

## 3. Nonabelian Q_C factorization (THE Move-2 crux)

Anchors: `PhysicsSM/Draft/NullEdge/GateYM/QCClosureGramCheck.lean`
(`matrix_unitaryDefectGram_eq_laplacian`, `matrix_defectGram_posSemidef`,
the Z2 instances); the abstract `Q_C` slot in the Weitzenboeck identity
(`CarrierSquareAssembly.lean`).

Sharpened target: on a concrete nonabelian finite model, either exhibit a
rectangular operator L with Q_C = L^# L (positivity manifest at operator
level), or compute the obstruction remainder R in Q_C = sum_f J_f^# J_f + R
and classify its sign.

Route - a witness ladder, oracle-first:

1. One square face, SU(2) transports: compute Q_C explicitly (numeric
   oracle under `Scripts/oracle/` first, then Lean). Expect exact Gram
   structure here (single face - no interference).
2. Two faces sharing an edge: the first place cross-face operator ordering
   can bite. Compute R on this witness.
3. Classify R: (a) R = 0 - exact factorization, closure positivity is an
   operator theorem; (b) R positive semidefinite - factorization fails but
   positivity survives, document the corrected object; (c) R indefinite -
   leading-order closure positivity FAILS in the nonabelian case, and the
   honest statement becomes positivity of the COMBINED aperture+closure
   channel on the physical sector - which is piece 1's quotient. All three
   outcomes are publishable content; (c) is a genuine discovery about where
   mass positivity lives and must not be spun as failure.

Pitfalls: state everything in the Hilbert adjoint first (where positivity
means something), Krein-twist second; never blur (charter). The unitary
Gram normalization already landed is the abelian shadow - do not let the
nonabelian statement silently degrade to it (hollow-telescoping mode).

---

## 4. E-slot torsion / teleparallel split

Anchors: `PhysicsSM/Draft/NullEdge/Carrier/CarrierESlot.lean` (defect named,
constant-soldering vanishing proved). Standing kills from Q02: the naive
"Tr E = torsion" conjecture is DEAD (P-probe); Lemma 0 says only the total
trace is redecoration-invariant. Prior art: Pereira-Vargas, Zubkov; the
geometric-trinity literature (curvature / torsion / non-metricity).

Sharpened target: define discrete torsion T as the ANTISYMMETRIZED
soldering difference along edges and a symmetric remainder S (the
non-metricity-shaped piece), then prove the split
`2 E = Contract(T) + Contract(S)` as a pure multilinear identity.

The framing that makes this valuable: this is the geometric trinity of
gravity at finite level. If S is generically nonzero, the honest claim is
"the E-slot realizes a teleparallel PLUS symmetric-teleparallel mix", which
is more interesting than pure TEGR and - crucially - EXPLAINS the P-probe
kill (the probe configuration should turn out to have S != 0). That turns
last week's dead conjecture into this week's decomposition theorem.

Route: definitions are the hard part, not the proof. (1) Draft T and S in
prose with index conventions pinned; (2) cross-review the definitions
(Opus seat - this is exactly a statement-risk piece); (3) regression-test
the split numerically on BOTH fixtures before Lean: the constant-soldering
configuration (must give T = S = 0 contributions consistent with the landed
vanishing) and the exact P-probe configuration (must reproduce the kill);
(4) only then submit the multilinear identity to Aristotle - it should be
mechanical once the definitions are frozen.

Kill: if no (T,S) split reproduces both fixtures, the teleparallel reading
fails at finite level; write the charter amendment rather than bending
definitions until something fits (false-shape mode).

---

## 5. Octonion -> Lambda(C^3) operator bridge

Anchors: sign-gauge and Baez/XOR-Fano convention gates (kernel-checked);
the existing Furey layer (Cl(6) ladder operators, minimal left ideal for
the left-action algebra) under `PhysicsSM/Algebra/Octonion/`;
`ConventionBridge` is mandatory for any Baez/Furey formula. Q04's Chevalley
statement: C tensor O with a fixed unit is Lambda(C^3) as a module, XOR-Fano
basis labels = strand monomials.

Sharpened target: an explicit linear isomorphism
`phi : C tensor O ~= Lambda(C^3)` (both 8-dimensional: 1+3+3+1) that
INTERTWINES left-multiplication operators with wedge/contraction ladder
operators: `phi . L_x = (ladder op of x) . phi` for the six ladder
generators. Everything is 8x8 complex matrices; the theorem family is
finite and decidable-friendly. No octonion product ever appears raw - only
`L` operators compose (nonassociativity rule from AGENTS.md).

Route: (1) fix the strand dictionary XOR-label -> subset of {1,2,3} (the
Q04 table); (2) phi is diagonal-with-signs in that dictionary; the 8 signs
are the residual gauge - pin them by REQUIRING exact intertwining on the
generators, and the landed sign-gauge gate says this determines phi up to
an overall phase; (3) state and prove entrywise. Build on the existing
ladder-operator layer rather than re-deriving Cl(6).

Pitfalls: convention drift is the whole risk. Anchor products
(`e011 * e111 = e100` etc.) must be respected via `ConventionBridge`;
the phrase "minimal left ideal of the complex octonions" stays banned
(module for the left-action algebra); any Furey/Baez-copied formula
without the bridge is an automatic reject in review.

Payoff: this is the load-bearing bridge for the internal null-strand
principle (fiber = Lambda(C^3 + C^2)) - color SU(3) as strand permutations
becomes an operator statement, and piece 6's sector projections get real
targets.

---

## 6. Q12 C8 / chirality-solder sector gates

Anchors: G2 parity, finite triality witness, Hadamard non-permutation
bridge, quotient-healing algebra (all landed in the Q12 lane); `J_R` from
the Q11 lane.

Sharpened target: the finite KO-sign table. With `J_R` and the carrier
grading Gamma on the concrete internal space, compute the three signs
eps (J^2 = eps), eps' (J D = eps' D J), eps'' (J Gamma = eps'' Gamma J),
and compare against the KO-dimension table. The NCG Standard Model sits at
KO-dimension 6; if the carrier internal space reproduces that column, it is
a headline contact with noncommutative geometry; if it mismatches, the
documented mismatch is equally real content. Then: sector-projection
equivariance (P_s J = J P_sbar), and the PSA-2/3 determinant-line phase
gates.

Route - convention-first, computation-second:

1. Pin the KO sign table AS AN ORACLE FIXTURE with provenance (pull the
   table from Connes/Chamseddine-Connes via the lit-chunk pipeline; do NOT
   write the signs from memory - sign tables from memory are how convention
   corruption starts, and this includes MY memory and yours).
2. Compute the three signs on the concrete finite model numerically.
3. Lean-ify: each gate is a finite matrix identity; the equivariance and
   determinant-line gates are small once J_R and the projections are in
   scope.

Pitfalls: eps' conventions differ across sources (some tables use JD = eps'
DJ with D the full Dirac, some state it for the fluctuated operator); the
fixture must record WHICH convention, or the comparison is meaningless.
Keep `J_R` strictly separate from Krein `J` in every statement (charter).

---

## 7. Strong-coupling / KP fixed-forest injection

Anchors: `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` -
`fiber_card_mul_le_factorial` (line ~1442) is a LANDED interface consuming
an injection `F`; the single documented handoff hole (line ~1564) carries a
complete proof sketch in comments (lines ~1539-1563): classification map
Phi, MapsTo, fiber constancy, and the injection
`((p,T), sigma, (rho_j)) -> ordering of Fin n` (root-first, then blocks in
sigma-order, internally reordered by rho_j).

Route: this is now a self-contained combinatorics problem - the file's own
comment sketch is better than the literature (Penrose partition scheme /
Fernandez-Procacci are the anchors, but the sketch is already specialized).
Package the relevant section standalone for Aristotle with the sketch as
the proof plan. The one mathematical subtlety to make explicit in the
prompt: injectivity should be proved by an explicit LEFT INVERSE - parse
the ordering back into (root, blocks, internal orders). Parsing is
well-defined because the block sizes m_j are given data, and where equal
sizes could collide, the canonical-least-root / increasing-children
constraints are the tie-break; force Aristotle to state the tie-break as a
lemma rather than waving at it. Constraints only REMOVE fiber elements, so
the bound direction is safe.

Pitfall: the ordering conventions (derived ordering on blocks) are the
known pain point of this lane - reuse the sum-type-split and
definitional-interface patterns that already worked for the lasso layer
rather than inventing a third ordering.

---

## 8. Q09 horizon/screen well-posedness gate

Anchors: finite screen-area identities, degeneracy iff, SL2 invariance,
modular no-go, BW-cut scoring algebra (all landed, Q09 lane).

Sharpened target - the honest finite Reeh-Schlieder: for a factorized
finite space V = V_S tensor V_E with screen algebra A_S = End(V_S) tensor 1,
a vector Omega is cyclic for A_S iff its Schmidt rank is maximal (and
cyclic-and-separating iff additionally dim V_S = dim V_E). That biconditional
IS the well-posedness gate: it converts "Reeh-Schlieder-like" from an
analogy into a checkable finite hypothesis.

Route: (1) the gate theorem is short finite linear algebra (A_S Omega spans
iff the reduced Gram matrix is invertible) - a clean standalone Aristotle
package; (2) then compute the Schmidt rank of the carrier ground state on
the torus witness and feed the result into the BW-cut rubric; (3) where the
gate holds, the finite modular objects (Delta, J of the cyclic-separating
pair) are explicitly computable matrices - but make NO thermality claims;
the landed modular no-go is the boundary and should be cited in the
docstring as such.

Pre-registered outcome: if the torus ground state has non-maximal Schmidt
rank, every entropy/Jacobson/ANEC claim stays MEMO-grade, and the
interesting question becomes WHICH decorations restore maximal rank -
that is a new, sharp question, not a loss.

---

## 9. Q10 dimension selection - the positive d=4 corner

Anchors: Lorentzian stable-order side and multi-time obstructions (strong);
d = 6, 10 scalar-amplitude obstructions (proved). The trusted Plucker-mass
theorem (`PhysicsSM/Spinor/PluckerMass.lean`) is secretly the d=4 positive
statement already - the new content is UNIQUENESS in the same formal shape
as the obstructions.

Sharpened target: in d=4, the same-chirality pairing S x S -> C (the
epsilon-symplectic form on 2-component spinors) exists, is unique up to
scale (the invariant space is 1-dimensional), and reconstructs
`det P = sum |psi_i wedge psi_j|^2`. State it as concrete SL(2,C) / 2x2
matrix algebra. Together with the landed d = 6, 10 obstructions this gives
the dimension-selection story its positive corner in matching format.

Route: keep it concrete. The uniqueness statement at d=4 is essentially
Lambda^2(C^2) ~= C plus Schur - a small package. Do NOT import general
spinor representation theory or Bott periodicity (Mathlib has neither;
the cost is prohibitive and the payoff is prose, not kernel).

The representation-theoretic clarification Codex asked for should be a
PROSE + fixture note, not Lean: pin Spin(1,3) = SL(2,C) conventions,
group-vs-Lie-algebra explicitly flagged (AGENTS red flag), and record the
organizing pattern - the same-chirality pairing exists exactly in the
division-algebra dimensions (d - 2 = 1, 2, 4, 8 for R, C, H, O), which is
why d=4 (complex numbers) carries the celestial CP^1. That remark guides;
the kernel work stays at d=4.

---

## 10. Q08 literal graded radical = ideal(N)

Anchors: componentwise graded radical assembly (landed, Q08 lane).

Sharpened target: `rad(Lambda h) = ideal(N)` literally, where N is the
radical of the (possibly degenerate) Hermitian form on h.

Route (main value-add - avoid the standard-proof trap): the textbook proof
uses `Lambda(N + P) ~= Lambda(N) tensor Lambda(P)` as SUPER-algebras.
Mathlib does not have the graded tensor decomposition with its Koszul
signs, and building it is a large detour. Use the adapted-basis route
instead: pick a basis n_1..n_r of N extended by p_1..p_s with P
nondegenerate; in the induced monomial basis of Lambda h,

1. the Gram matrix is block-structured: (e_S, e_T) = 0 whenever S touches
   an N-index (each factor pairing against an n gives a zero row/column in
   the pairing-determinant expansion);
2. hence rad = span of N-touching monomials (kernel of an explicit block
   matrix);
3. separately, span(N-touching monomials) = ideal(N) - one inclusion is
   trivial, the other expands x * n_i * y in the monomial basis.

Everything is Finset combinatorics over Fin(r+s) - squarely in Aristotle's
sweet spot. This also retroactively strengthens the landed Fock/GB-quotient
compatibility (the quotient becomes literally by ideal(N)).

Pitfalls: pin which slot of the Hermitian form is conjugate-linear (project
convention) in the package header; "radical" must be DEFINED as the kernel
of the Gram map, not assumed to coincide with any Mathlib notion without a
bridging lemma.

---

## 11. RG-Schur mass-generation witness (DO THIS FIRST)

Anchors: `PhysicsSM/NullStrand/DualSolder/SpectralSchur.lean`
(`det_fromBlocks_eq_det_hidden_mul_det_schurComplement`,
`schurComplement_isKreinSelfAdjoint_of_blocks`, Gamma-odd stability).
Q08's expectation: per-edge null nilpotency is NOT RG-stable.

I have done the algebra; hand the package the following worked prediction.

The witness: a 3-site chain v1 -e1- h -e2- v2 with the middle site h hidden.
Per-edge Clifford terms c(alpha_1), c(alpha_2) with alpha_i null, so
c(alpha_i)^2 = 0. Give h a scalar invertible on-site block (identity is
fine). Schur-complementing h out produces an effective v1-v2 term
proportional to T = c(alpha_1) c(alpha_2). Now the two-line computation:
from the Clifford relation c(a)c(b) + c(b)c(a) = 2<a,b>,

    T^2 = c(a) (c(b) c(a)) c(b)
        = c(a) (2<a,b> - c(a) c(b)) c(b)
        = 2<a,b> T - c(a)^2 c(b)^2
        = 2<a,b> T.

So the effective term is non-nilpotent EXACTLY when <alpha_1, alpha_2> != 0,
and for null covectors in Lorentzian signature, nonzero pairing means
non-collinear. Decimation converts null microstructure into a non-null
effective term whose obstruction coefficient is the pairwise null
DISAGREEMENT - the same invariant the trusted kinematic theorem
`det P = sum |psi_i wedge psi_j|^2` measures. That is the theorem to state.

Minimal concrete model (2x2): c(l) = [[0,1],[0,0]], c(n) = [[0,0],[1,0]]
(light-cone pair, anticommutator = identity). T = c(l)c(n) = diag(1,0);
T^2 = T, non-nilpotent. Wire it into the landed `fromBlocks` Schur frame.

Pre-registered NEGATIVE CONTROL (this is what makes it a mass theorem and
not an artifact): alpha_1 parallel to alpha_2 (collinear null directions)
gives <alpha_1, alpha_2> = 0, hence T^2 = 0 - nilpotency SURVIVES blocking
exactly on collinear (massless) configurations. Land the witness and the
control in the same file, guard-pin both.

Generalization note (second pass, not first): with a non-scalar hidden
block M, T = c(a) M^{-1} c(b) and the computation acquires M-commutator
terms; the scalar witness is the honest first landing, the M-dependence is
the follow-up question (and plausibly feeds the kappa bookkeeping, piece 12).

Claim boundary to write in the docstring: this is a finite algebra theorem
about one decimation step; it is NOT a continuum RG statement, NOT a flow,
and says nothing about fixed points.

---

## 12. Koide / T-solder kappa gate

Anchors: `AgentTasks/twoday-carrier-run-2026-07-07/TSOLDER_KAPPA_ANALYSIS.md`
- kappa = tan^2(theta/2) / 2 under bookkeeping B2; kappa = 1 iff
cos theta = -1/3 (the tetrahedral angle); probe P1 (the Z_3 tetrahedral
carrier-to-leg reduction) is the registered decider with pre-registered
kills; the equipartition and Kugo-Ojima Aristotle jobs are in flight
(43a7f979, 38eeb1a6 - check for harvest before duplicating anything).

Codex's ask - derive or refute kappa = 1 from carrier axioms via
edge-subdivision naturality - is the right axiom-level question. Name it
SUB-NAT and run it as follows:

1. Define edge subdivision e -> e' e'' with the induced corner at the new
   vertex (the palindromic-transfer convention theorem pins the corner
   convention; use it, do not re-choose).
2. Compute how the corner amplitude and the mass form transform under
   subdivision under bookkeeping B1 and under B2.
3. Demand physics invariance (subdivision must not change the mass form).
   Outcome table, pre-registered:
   - exactly one bookkeeping is subdivision-natural: the B1/B2 ambiguity is
     DERIVED away - the biggest possible win; kappa = 1 then reduces to the
     tetrahedral-frame question in that bookkeeping;
   - both natural: subdivision does not decide; fall back to probe P1 as
     the decider (already registered);
   - neither natural: subdivision covariance is NOT a carrier axiom -
     document it, and the Q06 quotient-then-limit rule becomes load-bearing
     for the continuum story (the refinement category, not naive
     subdivision, owns the limit).

Order of operations: run probe P1 FIRST regardless (it is cheap and
already the registered decider); SUB-NAT is the axiom-level explanation of
whatever P1 finds. The M-KOIDE gate and the K3 void clause stand; do not
relitigate them in new packages.

---

## Synergy map (exploit these, do not duplicate)

- 11 <-> 1: both live on small chain/witness models; build the RG-Schur
  witness so its blocks reuse the (2,1)-family conventions - the effective
  operator's Krein self-adjointness is already covered by the landed
  `schurComplement_isKreinSelfAdjoint_of_blocks`.
- 11 <-> 12: the effective-coefficient bookkeeping in the M-dependent
  generalization is corner bookkeeping; a SUB-NAT result constrains both.
- 3 <-> 1: if the Q_C remainder is indefinite (outcome c), positivity
  relocates to the physical-sector quotient - so Stage-C hypotheses in
  piece 1 should anticipate closure constraints in Gamma', not just Gauss.
- 4 <-> Q02 landed layer: the P-probe configuration is the shared
  regression fixture; any T/S split must reproduce it.
- 5 <-> 6: the Lambda(C^3) bridge supplies concrete sector projections for
  the Q12 equivariance gates; 6 can proceed abstractly, but lands harder
  after 5.
- 2 <-> 6: determinant-line / cocycle machinery is shared; whoever lands
  the Sylvester-Franke layer should hand the other lane the lemma names.

## Packaging notes

- Standalone Aristotle (Mathlib + copied defs; cheap, fast): 11 (tiny),
  10 (basis route), 7 (ship the file's sketch), 2 (exteriorPower re-base),
  8 (gate theorem), 9 (d=4 corner), 1-Stage-A.
- Context-pack / full-repo submissions: 1-Stage-C (needs the carrier
  complex), 3 (needs Q_C definitions), 5 (needs Octonion core +
  ConventionBridge), 6 (needs J_R + triality files).
- Oracle-first (numeric fixture BEFORE Lean): 3, 4, 6 (sign table), 12.
- Prose/definition cross-review BEFORE any Lean (Opus seat): 4 (T/S
  definitions), 8 (gate formulation), 9 (rep-theory note), 6 (sign-table
  provenance), 12 (SUB-NAT outcome analysis).
- Verify-before-package (names I checked vs names I did not): verified in
  the pinned snapshot via lean-explore - `exteriorPower.map`,
  `exteriorPower.map_comp`, `exteriorPower.linearMap_ext`. NOT verified -
  any Schur-triangulation, the exterior-power induced-basis API, and the
  MvPolynomial function-extensionality name; check each with lean-explore
  before writing it into a prompt.
- Opus call mechanics (AGENTS.md): standalone prompts (Opus is blind to
  this repo), embed verbatim source with `--source-file` for every
  declaration under review, state the intended reading separately, budget
  `--max-budget-usd 1.50`+.

## What NOT to do

- Do not build Krein/Witt or super-tensor infrastructure in Mathlib
  generality (pieces 1 and 10 route around both deliberately).
- Do not write KO signs, Fano signs, or Baez/Furey formulas from memory -
  fixture + provenance first, every time.
- Do not let piece 3's nonabelian statement quietly degrade to the landed
  abelian Gram normalization (hollow telescoping).
- Do not claim any continuum/RG-flow reading of piece 11 - one decimation
  step, finite, that is the theorem.
- Do not relitigate registered kills: Tr E = torsion (dead), M-KOIDE gates,
  the modular no-go boundary, retardedness-deletes-doublers (dead).
