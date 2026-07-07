# High-impact publication outlines (2026-07-07)

Five Letter-caliber outlines slotted into the stable-ID scheme of
`Null_Edge_Causal_Graph_Publication_Plan.md` (IDs P1-P12 reserved there; new IDs
here start at P13). Two outlines ACTIVATE existing aspirational slots (P2-R,
P4-R); three are new (P13, P14, P15). Per the user's direction, not all five
final papers are fixed today: a "future slots" section lists candidates expected
to crystallize from the Fable parallel-window results and the run's remaining
cruxes.

House rules applied to every outline (inherited from the P1 constitution):
interpretation-free core theorem first; claim calculus T / T|H / M / C with
originality tags; Omega-firewall (no ontology-program language in claims);
adversarial-referee section written BEFORE submission; the Lean artifact ships
as supplemental material with an axiom-audit appendix; no spectral language
where only forms are proved.

Venue realism note. "PRL-caliber" is the bar for tightness and broad interest;
for machine-verified theorem papers the realistic acceptance chain is often
PRL -> PRX/PRX Quantum -> SciPost Physics / PRD (Letters). Each outline names a
primary and a fallback and says honestly which is likelier to stick and why.

---

## Outline 1 (READY NOW). P13: Massless by topology

**Working title.** "Massless by topology: machine-verified index protection for
finite chiral operators"

**Letter sentence.** On any finite chirality-graded complex, the number of
protected massless chiral modes is a topological invariant - equal to the graded
dimension for every rank-symmetric (in particular every Hilbert- or
Krein-self-adjoint) operator - so mass generation can remove chiral zero modes
only in opposite-chirality pairs, and a chirally unbalanced complex can never be
fully gapped; every step is checked by the Lean 4 proof kernel.

**Why it clears the bar.** (i) One crisp mechanism with a broad moral: chiral
masslessness without fine-tuning, in the simplest arena where it is an exact
theorem, speaking to naturalness debates. (ii) The Krein-self-adjoint version is
the novel edge: index protection stated and proved for indefinite
(Lorentzian-signature-shaped) inner products, where the usual Hilbert arguments
do not directly apply. (iii) Methodological first: to our knowledge the first
kernel-checked McKean-Singer-type protection family with explicit two-pole
witnesses. (iv) It is genuinely short - the Letter format fits the content
instead of compressing it.

**Kernel status.** BANKED as of 2026-07-07, axiom-guarded
([propext, Classical.choice, Quot.sound]): `chiralIndex_eq_graded_dimension`,
`chiralIndex_protected`, `chiralIndex_adjoint_pair`, `chiralIndex_krein_pair`
(via `finrank_range_adjoint`, `ker_adjoint_eq_orthogonal_range`,
`finrank_range_conj_equiv`), `exists_protected_massless_mode`,
`chiralWitness_index_one`, `chiralWitness_forced_massless_mode`; the two poles
(balanced kappa=2 witness with strictly positive flat mass form vs unbalanced
(2,1) forced-massless witness). Owed before submission: NOTHING mathematical;
only prose, figures, and the related-work pass.

**Paper contract (one headline).** The protection theorem family + the two-pole
exhibit. The Weitzenboeck decomposition appears ONLY as one motivating example
of "an operator with dynamics in it" - no carrier-program claims ride along.

**Sections (Letter, ~3500 words).**
1. Hook: why are any modes massless? Fine-tuning vs topology; the finite
   question is decidable and we decided it (grade M [comp] for the mechanism,
   [orig] for the Krein form and the machine verification).
2. Setup: graded finite space, odd operators in Weyl block form; chiral index
   defined (interpretation-free).
3. Theorem 1 (protection): index = graded dimension under rank symmetry; proof
   is rank-nullity - stated in full, 6 lines.
4. Theorem 2 (self-adjoint and Krein supply): rank symmetry is automatic for
   D_- = D_+^dagger and for D_- = J D_+^dagger J'; remark on why the Krein case
   matters (Lorentzian-signature state spaces).
5. The two poles (figures): balanced witness - everything gappable, mass form
   strictly positive (cite the kappa=2 model); unbalanced witness - a forced
   massless mode for EVERY dynamics.
6. Physics moral + scope honesty: finite identity; what the continuum
   Atiyah-Singer story adds and what it does not; relation to Nielsen-Ninomiya
   (we protect, they forbid - the two directions of the same bookkeeping);
   pointer to the machine-checked artifact.

**Figures.** F1: block-form schematic with the pairing mechanism (nonzero modes
gapped in +/- pairs, surplus pinned). F2: the two-pole table/cartoon (2,2) vs
(2,1) with computed indices. F3 (optional): axiom-audit screenshot-style summary
of the Lean artifact.

**Referee attacks anticipated.** "This is textbook rank-nullity" -> yes, and
that is the point: the protection moral rests on nothing else; the Krein version
and the kernel-checked packaging are the contributions; we cite the folklore
honestly and claim only [comp]+[orig] as stated. "Why PRL and not a math
journal" -> the naturalness moral and the two-pole exhibit are physics content;
fallback venues ready. "Finite dimensions trivialize everything" -> finite is
the honest arena for the mechanism; we make no continuum claim.

**Venue.** PRL first (short, broad moral); fallbacks PRX Quantum-adjacent or
SciPost Physics Core; the Lean artifact note could also seed a separate CPP/ITP
methods paper (see future slots).

---

## Outline 2 (FLAGSHIP; one gate owed). P2-R activation: the carrier paper

**Working title.** "Unification is decomposition: a machine-verified
Weitzenboeck identity separating the four mass channels of a finite null-edge
Dirac operator"

**Letter sentence.** For the operator D = sum_e c(alpha_e) nabla_e + Gamma phi
on a finite 2-complex with null soldering (c(alpha_e)^2 = 0), the square
decomposes exactly - 4 D^#D = Q_A + Q_C + 4 Q_T + 4 E - into aperture
(kinematic), closure (gauge-curvature), turn (potential/Higgs-shaped), and
soldering-gradient (torsion/gravity-shaped) blocks, each with a kernel-checked
identification theorem; mass unification here is a theorem about one operator's
square, not a symmetry postulate.

**Why it clears the bar.** The Lichnerowicz/Weitzenboeck square is how mass
terms are organized across relativity, gauge theory, and NCG; an exact finite
version with all four channels separated, each identified against an
independent invariant (Q_A = the Pluecker/aperture mass of P1; Q_C = plaquette
curvature on the torus model; Q_T = phi^2; E = the covariant soldering
gradient), and everything kernel-checked, is a genuinely new kind of result -
and the "unification is decomposition, not identification" framing is a clean,
quotable thesis with NCG/spectral-action resonance.

**Kernel status.** BANKED: null nilpotency; lone-edge masslessness; the master
identities (`weitzenbock_master`, `weitzenbock_master_pair`,
`carrier_square_assembly`, `carrier_krein_square` + self-adjointness); torus
Q_C realization (`nabla_commutator_path_difference`, `mZero_iff_commute`);
Q_T slot (`dirac_square_with_potential`); E-slot (`soldered_square_defect`,
`weitzenbock_master_varying`); Move-2 `Q_A_eq_totalSq` (+ zero-iff); flat-sector
positivity; the kappa=2 Pontryagin witness (certified fundamental symmetry;
strict flat positivity). OWED BEFORE SUBMISSION (hard gate): the M4 GLUE WITNESS
- one model satisfying all Move-1 hypotheses with Q_A, Q_C, Q_T simultaneously
nonzero (mathematics verified by hand; Lean transcription open; both reviewers
flagged "true but unwitnessed" and the paper must not ship without it). Soft
gates: the torsion-contraction identity for E (2E = C(T) + C(S)) would upgrade
the E-slot section from "gravity-shaped" to "discrete-teleparallel"; Codex
review sign-offs current. NEW GATE (Q02 memo, 2026-07-07): the E-slot section
must carry the Lemma-0 correction - individual block traces are not
redecoration-invariant, so no "gravity action = E-slot trace" language; the
teleparallel paragraph cites Pereira-Vargas/Zubkov (discrete teleparallelism
EXISTS; the claimed gap is only the Dirac-square/null-co-frame route) and the
witness state-sector caveat (balanced inertia hosts no nonvacuous physical
sector) appears in the honesty map.

**Paper contract.** The decomposition + slot identifications + the two
witnesses (glue witness for non-vacuity; kappa=2 witness for the Krein
non-triviality). NO positivity-beyond-flat claim, NO spectral claim, NO
continuum claim; the teleparallel reading is one clearly-labeled paragraph with
Nester/Maluf/Witten anchors (T [import], lit-verified).

**Sections (Letter + long companion).** Letter: 1 setup + null nilpotency
("mass is relational": lone edges are massless, grade M); 2 the master identity
with the bidegree table; 3 slot identifications (one paragraph + one equation
each, Q_A tied explicitly to P1's det-P mass); 4 the two witnesses; 5 honesty
map (what is form-level, what is open: physical-sector positivity flagged as
the successor paper P15) + artifact note. Companion (PRD/SciPost, unlimited):
full proofs, the Krein square with the # involution spelled out, the E-slot
varying-soldering treatment, axiom audit, and the failure modes we guarded
against (vacuity, telescoping, docstring-overreach) as a methods section -
referees respond well to visible discipline.

**Figures.** F1: the 2-complex with soldering/transport/turn decorations. F2:
the decomposition as a labeled bidegree square (the four slots). F3: witness
table (which hypotheses, which slots nonzero, kappa).

**Referee attacks.** "Vacuous hypotheses" -> glue witness (the gate). "The #
involution is arbitrary" -> kappa=2 witness pins the intended fundamental
symmetry and the flat-sector positivity gives it teeth; language kept to forms.
"Just the standard Lichnerowicz computation" -> on a nonstandard object (null
soldering, edge transports, chirality-dressed potential) with exact finite
identifications and kernel-checking; the related-work section says precisely
what is standard ([comp]) and what is not ([orig]).

**Venue.** PRX or PRL with immediate PRD companion; SciPost Physics fallback.
Realistically PRX (length pressure) unless the Letter cut is ruthless.

---

## Outline 3 (READY PENDING LANE SIGN-OFF). P14: machine-verified confinement

**Working title.** "Confinement at strong coupling, machine-verified: a
kernel-checked Wilson-loop area law"

**Letter sentence.** The strong-coupling area law for Wilson loops in lattice
gauge theory - the textbook signature of confinement - is now a machine-checked
theorem: for the finite lattice models treated, the Wilson-loop expectation
obeys W(C) <= exp(-sigma Area(C)) with explicit constants, verified end-to-end
by the Lean 4 proof kernel with a pinned axiom audit.

**Why it clears the bar.** Confinement is a Clay-problem-adjacent topic where
wrong proofs have circulated for decades; a kernel-checked exact result - even
in the strong-coupling regime where the physics argument is classical - is a
methodological landmark ("the era of machine-checked lattice gauge theory") and
a foundation stone the community can build on without re-auditing. Broad
interest is the METHOD as much as the theorem.

**Kernel status.** Theorem-2-level concrete-lattice area law banked in the
GateYM lane (character expansion, transfer-gap machinery, TY twist ratios;
lasso layer queued) - THIS IS CODEX'S LANE: the outline is a proposal, and
scope/authorship/final theorem selection belong to a joint sign-off. Owed:
Codex's confirmation of exactly which statements are headline-ready; the
"what is NOT proved" map (no continuum limit, no weak coupling, no
deconfinement transition claims); possibly the Z2 two-torus exact Q_C theorem
as a bonus exhibit connecting to the carrier program (optional - keep the
paper standalone).

**Paper contract.** One theorem (the sharpest banked area law) + the honest
regime map + the artifact. The carrier/mass program is at most one outlook
sentence - this paper must stand on lattice gauge theory alone.

**Sections.** 1 why confinement proofs need auditing (brief history of
retracted or disputed claims - handled respectfully); 2 the model and the exact
statement; 3 proof architecture (character expansion -> transfer gap -> area
bound) with the kernel-checking discipline; 4 what is and is not proved
(regime honesty as a virtue); 5 artifact + how to extend (the open
volume-uniform/KP and small-beta rungs as community targets).

**Figures.** F1: loop + spanning surface on the lattice. F2: proof-architecture
DAG with kernel-checked nodes marked. F3: regime map (proved region in the
(beta, volume) plane).

**Referee attacks.** "Strong coupling is easy/old" -> yes (Wilson 1974,
Osterwalder-Seiler): the claim is exactness + verification + reusable formal
infrastructure, graded [comp] for the physics and [orig] for the formalization;
we say so in the abstract. "Lean details do not belong in PRL" -> they live in
supplemental; the Letter carries the theorem and the regime map.

**Venue.** PRL attempt justified by the methods-landmark angle; PRD/SciPost
fallback near-certain accept. Joint authorship with the Codex lane's history.

---

## Outline 4 (GATED ON ONE THEOREM). P4-R activation: mass is the amplitude to turn

**Working title.** "Mass is the amplitude to turn: the Feynman checkerboard as
a null-edge Dirac carrier"

**Letter sentence.** The 1+1 Feynman checkerboard and the null-edge carrier are
the same finite object under a kernel-checked dictionary - zigzag segments are
null edges, corners are chirality flips, and the corner weight IS the turn
potential phi - so the checkerboard's classical continuum limit (the massive
Dirac propagator) becomes an exact benchmark for null-edge mass, and the
kernel-checked identity M^2 = 4 E^2 sin^2(theta/2) = |<12>|^2 is one theorem
seen from both sides.

**Why it clears the bar.** It fuses two storied threads - Feynman's checkerboard
(a famous curiosity) and the origin-of-mass question - into one exact statement
with a machine-checked core, and it hands the community a concrete, solvable
bridge between "mass from turning" and "mass from null-direction disagreement".
High pedagogical charisma; genuine content in the identification theorem.

**Kernel status.** BANKED: the A=T bridge (`compositeMassSq_eq_sin_half`,
PluckerSpinorBridge; the 1+1 chirality-flip-amplitude = wedge theorem from the
P1 layer); checkerboard corner conventions + luminal walk machinery (P4-F
lane). OWED (the gate): the corner-identification theorem - the generating
function of corner-weighted checkerboard paths equals the corresponding
carrier transfer/expansion object on the two-edge 1+1 complex (thread proposed;
my A/T lane). Soft: a Destri-de Vega outlook paragraph (interacting upgrade,
[import], lit-verified).

**Paper contract.** The dictionary + the identification theorem + the two-sided
reading of M^2 = 4E^2 sin^2(theta/2). Continuum-limit statements only as
CITATIONS of classical checkerboard results, never as our claims.

**Sections.** 1 the checkerboard, recalled; 2 the carrier in 1+1; 3 the
dictionary table + identification theorem (the gate result); 4 the A=T identity
both ways (turn amplitude = aperture wedge); 5 what the classical limit then
buys (benchmark, doubling discussion pointer) + artifact.

**Figures.** F1: zigzag path with corners marked = the same picture labeled
both ways (the dictionary as ONE figure). F2: sin^2(theta/2) mass identity
geometry. F3: transfer-object equality schematic.

**Referee attacks.** "The checkerboard correspondence is folklore" -> the exact
finite dictionary with a kernel-checked identification is not; we cite
Gersch/Jacobson-Schulman/Kauffman-Noyes carefully and grade [comp]/[orig] per
claim. "1+1 only" -> stated scope; the 3+1 aperture side is P1/P2's business.

**Venue.** PRL plausible (charisma + brevity); AJP explicitly NOT the target
(this is a theorem paper, not pedagogy); SciPost fallback.

---

## Outline 5 (FUTURE-SHAPED; two branches). P15: the physical sector

**Working title (theorem branch).** "A physical Hilbert sector for indefinite
finite Dirac operators" / (counterexample branch) "Why finite Krein positivity
requires [the hypothesis]: exact obstructions and the repaired construction"

**Letter sentence (branch A).** For Krein-self-adjoint finite Dirac operators of
null-edge type, the Gupta-Bleuler quotient - constraint kernel modulo the
radical of the restricted Krein form - carries a positive-definite induced form
on which the mass form is nonnegative, with the gauge directions exactly the
quotiented null subspace; kappa counts what is removed. (Branch B states the
sharp counterexample + minimal repair hypothesis instead.)

**Why it clears the bar.** This is the missing keystone between indefinite
(Lorentzian) operator algebra and physical mass spectra - the finite, exact
version of the Gupta-Bleuler/BRST state-space construction, machine-checked.
Either branch is publishable: the theorem legalizes spectral mass language for
the whole program; the counterexample branch would be a sharp cautionary
result for indefinite-metric constructions generally (and those are rarer and
often more cited).

**Status.** BRANCH A ACTIVE as of 2026-07-07: the Q01 memo
(`AgentTasks/fable_parallel/Q01_answer.md`, executor-verified) delivers the
theorem at working-mathematician rigor - Theorem A (state positivity = Witt
geometry of the constraint span; isotropy + count + finite Ward identity),
the O1-O5 counterexample ladder (O2: the 2-dimensional degenerate obstruction
immune to every spectral hypothesis), the 2x2 trichotomy with the real-split
kill-condition, and the upgraded HEADLINE: `dim(V'/N) = ind(D)` - the chiral
index counts the physical states that survive gauge. Letter sentence updates
accordingly. Gate to submission: the L1-L5 kernel ladder + the 2+1
spatial-torus witness (first nonvacuous physical sector) kernel-checked;
definitizability language struck everywhere (vacuous in finite dimensions);
the counterexample branch survives as the paper's own adversarial section
rather than a separate paper. Remaining open input: the OS/theta-reflection
selector comparison (not adjudicated by Q01) and reconciliation with
Aristotle job 4338f235 on harvest.

**Paper contract.** One construction, one positivity statement (or one
obstruction), the kappa bookkeeping, and the witness instantiation. The
spectral corollary ("m^2 = min spec on the physical sector") appears ONLY if
the theorem branch closes, as its final equation.

**Pre-registered kill-conditions.** If the induced form is positive only under
a hypothesis with no physical reading, the paper reports that as the finding
(branch B) rather than quietly assuming it - this is written down NOW so
results cannot bend the framing later.

**Venue.** PRL/PRX (branch A) - keystone results travel; J. Math. Phys. /
SciPost (branch B) with a physics-letter version if the obstruction has a
crisp moral.

---

## Future slots (expected to crystallize; not outlined yet)

- P8-E upgrade: the program charter that survives the Q3 no-go audit - NOW
  AVAILABLE (`Sources/Null_Edge_Program_Charter_2026-07-07.md`); essay form
  when U1 progress warrants.
- NEW candidate (post-Q04, conjecture-gated): "One generation from five
  internal nulls" - the strand-Fock selection theorem with its honest
  two-point degeneracy, the B-L no-go, the anomaly-as-identity result, and
  derived hypercharge/Z_6; gated on the L1-L3 kernel ladder + the C8 seam
  check + the enumeration kill.
- NEW cheap standalone (post-Q04): the order-condition arbitration - which
  first/second-order NCG identities the vacuum-Majorana turn satisfies on
  Lambda(C^3+C^2); a finite Lean file adjudicating a live NCG dispute
  (Chamseddine-Connes-van Suijlekom vs Boyle-Farnsworth) from outside.
- P10-R ACTIVATION CANDIDATE (post-Q05, conjecture-gated): "Three is a
  theorem" - triality-as-monodromy with the {1,3} multiplicity menu, the
  gauge-outer rail (Fano/E8 kills as adversarial sections), the TOY-A
  certificate over the kernel-checked (2,1) block, and the CKM/PMNS
  representation-theory dichotomy (theta_23 = 45 deg; mu-tau-reflection
  delta_CP = +/- pi/2 as the near-term observational hook). Gates: the
  equivariant McKean-Singer upgrade (L0) + TOY-A (L2) + the cyclicity seed
  (L4a) kernel-checked, and the chirality-solder audit passed.
- P6-R: the Koide-as-angle finite identity (sqrt-mass = native aperture
  variables) + whatever generation mechanism Q5 ranks first - only if a
  mechanism FORCES structure; no numerology paper.
- P13-companion (methods venue, CPP/ITP): "Krein spaces and indefinite spectral
  data in Lean 4/Mathlib" - the infrastructure paper the physics Letters lean
  on.
- Q2/Q9 dependent: discrete teleparallel field equations + boundary
  telescoping (a discrete-gravity paper), and - far-gated - the finite first
  law / Jacobson-upgrade result if it survives honest scrutiny.
- Q10 dependent: dimension/signature selection, only in the (unlikely but
  high-value) event the requirement table yields a genuine selection theorem.

## Cross-cutting submission checklist (applies to all five)

1. Glue/witness non-vacuity gates green; axiom audit quoted in the paper.
2. Claim-calculus table in the appendix (every numbered claim graded).
3. Adversarial-referee section drafted and answered BEFORE submission.
4. Literature anchors pulled through the Neo4j pipeline (no unverified
   citations; the P1 rule).
5. Codex cross-review sign-off recorded in the ledger for every paper drawing
   on shared lanes (mandatory for P14).
6. Lean artifact: pinned toolchain, one-command build, guard file included;
   archived (Zenodo-style DOI) at submission.
