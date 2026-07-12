# STRATEGY MEMO — Hostile review of Route C against Golterman–Shamir

Aristotle strategy job, 2026-07-11. Review-only. Sources read in full:
`context/MEMO_3PLUS1_ATTACK.md` (program memo), `context/gs_propzeros.md`
(Golterman–Shamir, "Propagator zeros and lattice chiral gauge theories",
arXiv:2311.12790, hereafter **GS-Z**), `context/gs_constraints.md`
(Golterman–Shamir, "Constraints on the symmetric mass generation paradigm...",
arXiv:2505.20436, hereafter **GS-C**).

Claim discipline: **VERBATIM** marks a direct quote from the frozen G-S text.
**RECONSTRUCTED** marks a G-S statement I had to reassemble because the
markdown transcription dropped inline math symbols (both files have their
equation glyphs stripped; the numbered condition list in GS-C is referenced
as "listed in Sec." but never re-typeset as a clean list in the transcription).
**UNCERTAIN** flags any attribution I could not pin to the text. Everything
else is my strategic judgement.

---

## TL;DR (the four answers in one breath)

- **Q1.** The finite reshuffle-and-gap result currently **does not touch**
  either G-S mechanism. GS-Z's ghost mechanism needs a propagator, a gauge
  field, a continuum limit and loop integrals — we have none. GS-C's
  generalized no-go needs conditions (2) [continuum limit = free massless]
  and (3) [infinite-volume complete set of interpolating fields] that are
  undefined on a 4-ring. Our result is a **necessary-not-sufficient**
  mechanism demo for "interaction gaps the mirror" — it counts eigenvalues,
  whereas the G-S obstruction is about *spectral weight sign*, *propagator
  analyticity*, *symmetry-representation content*, and *the continuum limit*.
  The finite incarnation of their kill condition is **the chirality-graded
  spectral weight of the surviving ±1 modes in the *elementary-field*
  interacting two-point function** — net Γ-chirality of the survivor
  eigenspace, plus the *sign* of each survivor's residue. (§Q1.)

- **Q2.** C1–C3 are correctly ordered; **C2 is mis-placed** (a position-space
  z(x) flip is a Wilson term — it gaps by *explicitly breaking* the chiral
  symmetry, so it cannot be the SMG mechanism; keep it only as a labelled
  baseline). **C3 has the best theorem-per-week ratio** and should be promoted
  ahead of C2. **C4 as stated is NOT well-posed** ("low-energy sector" and
  "half the chiral content" are undefined on a finite ring); a well-posed
  replacement is given in §Q2. The plan is **missing** three things: an actual
  two-point-function / propagator-zero computation, a G-representation label on
  the modes, and a ring-size (N=4→6→8) finite-size control.

- **Q3.** Yes — Route C changes Route A's charge design: the A1 per-crossing
  charge should be **Γ-graded (chirality-resolved) from the start**, not
  defined on the full crossing eigenspace and not det/U(1)-based. This is
  forced independently by (i) the finite lab's momentum-hybridization
  ("which chiral content survives, not which momentum label") and (ii) GS-Z's
  result that **propagator zeros carry the same anomaly as poles** — i.e. the
  invariant that matters is the chirality-weighted (anomaly) charge. Add the
  4-ring composed unitary as a fourth M2 validation symbol.

- **Q4.** Best single use of the remaining ~14h: **stand up C3 as three
  finite, kernel-checkable numbers computed on matrices already in hand** —
  (1) χ = Tr(Γ P_{±1}) of the surviving vs gapped eigenspaces before/after the
  kick, (2) [U_full, Γ] (is the chiral symmetry actually preserved?), and
  (3) the residue signs of the survivors in the elementary two-point function —
  plus a cheap N=6 replication of the mode-count trade as a finite-size
  control. These are the numbers that decide evade/instantiate/not-touch.

---

## Q1 — Hostile review of Route C vs GS-Z and GS-C

### Q1.0 What each G-S paper actually proves (so we don't over- or under-claim)

**GS-Z (arXiv:2311.12790).** Euclidean/Minkowski *continuum-effective*
lagrangian argument. Assume the SMG phase replaces a mirror pole by a
propagator zero, phenomenologically `P_{R,L} ip/(p²+m²)` near the zero.
Gauge the resulting nonlocal effective lagrangian minimally and compute loops.
Results, VERBATIM from the abstract:

> "In four dimensions, a propagator zero makes an opposite-sign contribution
> to the one-loop beta function as compared to a normal fermion. In two
> dimensional abelian theories, a propagator zero makes a negative
> contribution to the photon mass squared. In addition, propagator zeros
> generate the same anomaly as propagator poles. Thus, gauge invariance will
> always be maintained in an SMG phase, in fact, even if the target chiral
> gauge theory is anomalous, but unitarity of the gauge theory is lost."

and VERBATIM:

> "The propagator zero thus acts as a ghost state, which ruins the unitarity
> of the gauge theory in the SMG phase."

Two load-bearing *assumptions* for this mechanism, both VERBATIM:

> "This effective lagrangian is nonlocal." (the zero ⇒ a pole in H_eff ⇒ nonlocality)

> "We assume that the (euclidean) lattice theory regains full rotational
> invariance at large distances, and thus that the zeros of the propagator are
> relativistic. Relaxing this assumption is likely to lead to yet worse
> problems than those we find in this Letter."

**GS-C (arXiv:2505.20436).** Argues the GS-Z ghost is usually *avoidable*
because the zeros are "kinematical": VERBATIM from the abstract,

> "we argue that the zeros that often replace the mirror poles of fermion
> two-point functions in an SMG phase should be ``kinematical'' singularities.
> We conjecture that the SMG interactions generate opposite-chirality bound
> states, which combine with the gapped elementary mirror states to form
> massive Dirac fermions. The propagator zeros can then be avoided by choosing
> an appropriate set of interpolating fields that contains both elementary and
> composite fields."

and then the sting, VERBATIM:

> "Using a suitably constructed one-particle lattice hamiltonian describing the
> fermion spectrum, we formulate a generalized no-go theorem which establishes
> the conditions for the applicability of the Nielsen-Ninomiya theorem to this
> hamiltonian. If these conditions are satisfied, the massless fermion spectrum
> must be vector-like."

The three conditions (RECONSTRUCTED — the transcription only invokes them by
number in the "road map" section, never re-typesets the list; I read them off
the sentences that check each one for the ZZWY model):

- **(1) Locality/field content.** VERBATIM check: "Condition (1) is satisfied by
  construction for the ZZWY model: the model depends on fermion fields only,
  and has a finite-range hamiltonian." → the underlying theory is local /
  finite-range and built from fermions (and possibly scalars).
- **(2) Continuum limit = free massless fermions.** VERBATIM: "The remaining
  condition of the theorem is condition (2), which asserts that the continuum
  limit is a theory of free massless fermions."
- **(3) Complete set of interpolating fields exists (no propagator zeros).**
  VERBATIM: "we expect condition (3) to be satisfied because of our conjecture:
  there exists a complete set of interpolating fields at every point in the
  phase diagram and in every charge sector which admits single-particle
  massless fermion states." "Complete set" defined (RECONSTRUCTED, symbols
  dropped) by two requirements: `G(p)` is free of propagator zeros, and the
  poles of `G(p)` (zeros of `H_eff = G^{-1}`) are in one-to-one correspondence
  with the massless fermion asymptotic states in the channel.

The engine underneath: build `H_eff(p) = G^{-1}(p)` from the retarded
anti-commutator of a *complete* set of fields; GS-C prove (App.) it is
hermitian except at degeneracy points and (edge-of-the-wedge) VERBATIM
"an analytic function of `p` everywhere in the Brillouin zone except at the
degeneracy points" — and VERBATIM "The results of App. are sufficient for the
no-go theorem, which only requires a continuous first derivative." A local,
analytic, hermitian one-particle H_eff on a torus is exactly NN's hypothesis
⇒ vector-like. The ghost escape is blocked by the local→no-ghost conjecture,
VERBATIM: "if the effective low-energy theory contains poles in (the bilinear
part of) its hamiltonian, this implies the existence of ghost states which make
the model inconsistent."

So the G-S pincer is: **either** a real propagator zero survives (GS-Z: ghost,
unitarity lost) **or** it is kinematical and removed by bound-state composite
fields (GS-C: complete set ⇒ local analytic H_eff ⇒ NN ⇒ vector-like). Both
horns kill "embrace-the-doublers-and-get-a-chiral-spectrum."

### Q1.1 The translation table — every gap between their setting and ours

Our setting: a **finite**, **exactly unitary**, **discrete-time** (Floquet)
translation-invariant update `U(k)` with finite internal dimension;
**quasienergy** spectrum on the zone torus; ±1-quasienergy crossings at
quasienergy **0 and π**; the finite lab is a fixed 4-site ring, two-particle
sector, exact eigenmodes. Their setting: **infinite-volume Euclidean/Hamiltonian
lattice QFT** with a **transfer matrix / propagator**, **continuous** (real)
energy, a **continuum limit**, **dynamical gauge fields**, **loop integrals**,
**second-quantized asymptotic states**.

| # | G-S ingredient | Our finite unitary setting | Gap verdict |
|---|---|---|---|
| G1 | Continuous energy E∈ℝ; dispersion E(p); poles/zeros of G(p) | Quasienergy mod 2π; **two** crossing floors (0 **and π**); object is unitary, not Hermitian | **Hard gap.** Their H_eff is a static Hermitian operator; ours is unitary. The Floquet π-sector is an extra doubler home with no static analogue. Building their H_eff = (i/T)logU introduces a branch cut / the π-modes exactly where their edge-of-the-wedge analyticity is assumed. |
| G2 | Relativistic zeros; "full rotational invariance at large distances" (VERBATIM assumption in GS-Z) | Strictly finite 4-ring; no continuum, no rotational invariance | **Hard gap.** GS-Z's `P_{R,L} ip/(p²+m²)` form and every loop that follows *require* the relativistic continuum. None of GS-Z's quantitative results (beta function, photon mass², optical theorem) are even defined on the ring. |
| G3 | Dynamical gauge field turned back on; unitarity/anomaly/β of the **gauge** theory | Reduced model only: free update ∘ non-gauge kick; no gauge field | **Hard gap.** GS-Z's kill ("unitarity of the gauge theory is lost") lives one level *above* us. Our finite operator is trivially unitary as a finite matrix — a *different* notion of unitarity than the gauge-theory S-matrix unitarity they violate. |
| G4 | The central object is the **two-point function** G(p) and its zeros | We computed **eigenmode multisets** of U and U∘V, never a Green's function | **Missing bridge.** "Zero vs pole" and H_eff = G^{-1} are QFT constructs we have not built. Our "6 modes survive" is consistent with *either* a genuine gap (pole removed) *or* a propagator zero (mirror hidden as a ghost). The eigenvalue count cannot distinguish them. |
| G5 | Statements about a **phase** of an infinite-volume theory; arbitrary-strength interactions; SMG phase; phase diagram | One finite operator at a fixed kick strength (α-dial) | **Hard gap.** No thermodynamic limit, no "mass gap of order the cutoff", no phase boundary, no SSB-vs-SMG distinction. |
| G6 | SMG def: (a) mirror gapped, (b) target massless, (c) symmetry G unbroken | We have (a) as a mechanism demo; (b),(c) untracked | **Partial.** We touch premise (a) only. (b) and (c) — the substance — are untested because no G-representation label exists on our modes. |
| G7 | Anomaly (triangle/bubble, dim reg): "same anomaly as poles" | No perturbative anomaly on a finite unitary | **Gap, but with a bridge to Route A.** The finite analogue of their anomaly is precisely the discrete per-crossing charge Route A is chasing — and it must be **chirality-graded** to match "same anomaly for zeros and poles". |
| G8 | Bound-state / composite interpolating fields remove the zero | We have a genuine two-particle sector (the `boundstate` job) | **Instantiation opportunity.** Our two-particle bound states are the finite version of GS-C's "opposite-chirality bound state that pairs with the gapped mirror." This can *confirm* their scenario — which is the *pessimistic* horn (NN then applies). |
| G9 | Second-quantized asymptotic states; zeros ↔ massless asymptotic states | Finite Hilbert space, discrete spectrum, no asymptotic states | **Hard gap.** "Complete set of interpolating fields" and "one-to-one with asymptotic states" have no finite-volume meaning. |

### Q1.2 Evade / instantiate / not-touch — the verdict

- **Against GS-Z's propagator-zero → ghost mechanism: NOT TOUCHED (today).**
  We have no propagator (G4), no gauge field (G3), no continuum (G2), no loops.
  The finite result cannot exhibit "zero vs pole" because the object that
  carries that distinction has not been built. It neither evades nor
  instantiates GS-Z until C3 constructs the elementary two-point function and
  measures **residue signs**. *If* a surviving mode then shows the wrong-sign
  spectral weight, we would **instantiate** GS-Z's ghost in finite form; if
  every survivor has positive residue and there is no zero, we **evade** GS-Z —
  but only in finite volume, which is not the arena GS-Z cares about.

- **Against GS-C's generalized no-go: NOT TOUCHED — and at risk of
  instantiating the pessimistic horn.** Conditions (2) [continuum = free
  massless] and (3) [infinite-volume complete set] are simply undefined on the
  4-ring (G2, G5, G9), so our result neither satisfies nor violates the
  theorem. Worse: the finite lab is a *natural testbed for GS-C's bound-state
  escape* (G8). If the surviving/gapped structure matches "elementary mirror +
  composite bound state = massive Dirac", then by GS-C's own logic the zeros
  are kinematical, a complete set exists, H_eff is local+analytic, and NN
  applies ⇒ **vector-like** ⇒ embracing-the-doublers fails to yield a chiral
  spectrum. So confirming our own bound-state picture would land us on the
  losing side of their dichotomy, not the winning one.

**Headline for any manuscript sentence:** the reshuffle-and-gap eigenvalue
result is *orthogonal* to the G-S constraints. It counts eigenvalues; their
obstruction is about spectral-weight sign, propagator analyticity,
symmetry-representation content, and the continuum limit. The mode-count trade
("K=2 quartet removed") is **necessary but nowhere near sufficient** for an
SMG-style mirror-decoupling claim. The memo's own eigenvector caveat ("the
naive 'the kick deletes the π-sector modes' is FALSE... the right bookkeeping is
which CHIRAL content survives") is exactly right and must be the load-bearing
framing.

### Q1.3 The precise finite observable for C3's kill condition

For the C3 kill condition to be the *finite incarnation* of the G-S
obstruction, C3 must measure — on the finite interacting unitary — the two
things that G-S's obstruction actually keys on, **not** the eigenvalue count:

**Observable A — chirality-graded survivor weight (the NN-sting detector).**
Fix the would-be chiral action: a unitary involution Γ (Γ²=1) on the internal
+ ring Hilbert space playing the role of γ₅ / the chiral projector `P_{R,L} =
(1±Γ)/2`. Compute, on the ±1-quasienergy eigenspace projector P_{±1}:

  χ_survive := Tr(Γ · P_{±1}[U∘V])   and   χ_free := Tr(Γ · P_{±1}[U]),

and the graded dimensions of the **gapped** subspace. Kill condition (finite
NN sting): if the surviving low-energy sector has the **same net chirality as
free** (χ_survive = χ_free), the interaction vectorized the spectrum — the
mirror was not chirally decoupled; equivalently, every gapped multiplet was
Γ-vector-like (χ=0), so no *chiral* content was removed. This is the finite
version of GS-C's "the massless fermion spectrum must be vector-like."
Companion check: **[U∘V, Γ]** — the whole SMG premise is gapping *without*
breaking the chiral symmetry, so a nonzero commutator means the kick cheated by
explicitly breaking Γ (the Wilson route), disqualifying it as SMG.

**Observable B — residue sign in the elementary two-point function (the
ghost/propagator-zero detector).** Build the *elementary-field* interacting
two-point function on the ring — the discrete-time retarded anti-commutator
`G_elm(k, z)` restricted to the elementary (pre-kick) field operators, `z` on
the unit circle — and its inverse `H_eff,elm = G_elm^{-1}`. For each surviving
±1 mode, measure the **sign of its residue / spectral weight** in `G_elm`
(discrete analogue: the jump of the resolvent of the interacting unitary across
the unit circle at the mode's quasienergy). A survivor with **wrong-sign
(negative) spectral weight** *is* a finite propagator zero masquerading as a
mode — the finite incarnation of GS-Z's ghost ("opposite-sign contribution to
the one-loop beta function", "negative contribution to the photon mass
squared", violation of the optical theorem). A **missing pole replaced by a
zero** in `G_elm` at a gapped momentum, with the pole only reappearing once the
two-particle *composite* interpolating field is added, is the finite
incarnation of GS-C's kinematical zero + bound-state completion — i.e. we would
have *instantiated* their scenario.

**The single crisp deliverable for C3:** the pair
**(χ_survive, {sign of each survivor residue in G_elm})**, together with
[U∘V, Γ]. Kill = *either* χ_survive equals the free (vector-like) value
[vectorization] *or* any survivor residue is wrong-signed [ghost] *or*
[U∘V,Γ]≠0 [chiral symmetry secretly broken]. Success (worth a sharp paper) =
χ_survive is chiral (≠ free), [U∘V,Γ]=0, and all survivor residues positive
with no propagator zero — a finite object that would sit *outside* both G-S
horns and therefore demand explanation.

**Companion observable, straight from GS-C (VERBATIM, their own direct test):**
"one considers the two-point function of the conserved current of the global
U(1) symmetry to be gauged, and calculates (numerically, if necessary) its
zero-momentum discontinuity. ... the magnitude of this discontinuity provides a
direct test whether or not the massless fermion spectrum can coincide with the
chiral spectrum of the target ... chiral gauge theory." A finite-ring
current–current correlator discontinuity is a second, independent finite
kill-observable and is arguably closer to what a referee from this camp would
ask for. Recommend C3 emit both A/B *and* the current-correlator discontinuity.

---

## Q2 — Route C plan audit (C1–C4)

### Q2.1 Are C1–C4 well-ordered?

Mostly, with one swap and one gap-fill:

- **C1 (eigenvector ID + α-sweep exact curve): correct as step 1.** Cheap,
  in-flight, already partly done. Keep. One addition: C1 should *already*
  emit Observable A's χ (it's the same eigenvectors), turning "how much Higgs
  to gap" into "how much Higgs to change the net chirality" — the physically
  meaningful curve.

- **C2 (position-space z(x) chirality-flip, `VariablePlueckerLocalWalk`):
  MIS-PLACED.** A one-particle, position-dependent chirality flip driven by
  z(x) is, in the hopping expansion, a **Wilson term** — the memo itself notes
  "it is the Wilson mechanism read as a path sum". A Wilson term gaps the
  doublers by **explicitly breaking the chiral symmetry** (that is what Wilson
  fermions do). So C2 *cannot* realize the SMG mechanism (gap *without*
  breaking G); at best it is a **baseline/control** showing the easy, chiral-
  symmetry-breaking way to gap, to contrast with the hard chiral-preserving
  way. Recommendation: relabel C2 "Wilson baseline (chiral-symmetry-breaking
  control)" and demote it below C3. Running it before C3 risks a headline that
  a referee instantly dismisses as "just a Wilson mass".

- **C3 (chirality bookkeeping / honest kill): PROMOTE to step 2, ahead of
  C2.** This is the only step that engages the G-S obstruction at all (§Q1.3).

- **C4 (finite SMG-style theorem): keep last, but re-pose (§Q2.3).**

**Recommended order: C1 → C3 → (C2 as baseline) → C4.**

### Q2.2 What is missing

1. **No two-point-function / propagator-zero computation anywhere.** This is
   the single biggest omission — it is *the* object G-S argue about, and the
   plan never builds it. Add **C3a**: construct `G_elm(k,z)` on the ring,
   exhibit the pole/zero structure at the gapped momenta, measure residue signs
   (Observable B). Without this, no Route C sentence can honestly reference
   either G-S paper.
2. **No G-representation / would-be gauge-charge label on the modes.** The SMG
   clause is "without breaking G". We never assign G-charges, so clause (c) is
   untestable. Add the Γ and the U(1)-charge grading to every eigenmode.
3. **No finite-size (ring-size) control.** A gap on a 4-ring can be a
   finite-size artifact (K=2=π is the *only* nonzero momentum on a 4-ring;
   the "quartet" may be a small-N coincidence). Add a cheap **N=6, N=8**
   replication of the mode-count trade and of χ_survive; if the trade does not
   persist, the whole result is a 4-ring artifact. This is the cheapest
   possible way to falsify the result and must be done early.
4. **No explicit link of C's chirality charge to Route A's per-crossing
   charge** (see Q3). The graded charge should be defined once and shared.

### Q2.3 Is C4 well-posed? (No — here is a well-posed version.)

C4 as stated — "conditions on a z-driven interaction under which the composed
walk's low-energy sector has HALF the free chiral content with the chiral
symmetry intact" — is **not well-posed** on a finite ring for three reasons:

- **"low-energy sector"** is undefined: a finite ring has no scale separation
  and no continuum limit. Fix: replace by the **±1-quasienergy eigenspace**
  (the would-be massless sector), a precise finite object.
- **"chiral content"** is undefined: fix by **χ = Tr(Γ P_{±1})**, the
  Γ-graded dimension of that eigenspace.
- **"HALF"** is ambiguous: a vector-like free theory has χ_free = 0, so
  "half of zero" is meaningless. The intended content is "remove one
  chirality's worth of *mirror* and leave a net-chiral survivor."

**Well-posed C4 (recommended replacement).** *A finite discrete-time SMG /
no-go dichotomy.* Let `U` be a finite-range, exactly-unitary,
translation-invariant free update with a Γ-vector-like ±1 eigenspace
(χ_free = 0), and let Γ be a fixed chiral involution. Question: does there
exist a finite-range unitary interaction `V` with **[U∘V, Γ] = 0** (chiral
symmetry exactly preserved) such that the ±1 eigenspace of `U∘V` is **net
chiral**, χ = Tr(Γ P_{±1}[U∘V]) ≠ 0, **while every gapped multiplet is
Γ-vector-like and every survivor has positive spectral weight in the
elementary two-point function `G_elm` (no propagator zero)**?

- **Expected answer (from the NN heuristic + G-S): NO.** Then the well-posed
  C4 is a *finite discrete-time no-go*: no Γ-commuting finite-range unitary
  interaction can convert a vector-like free ±1 spectrum into a net-chiral one
  without introducing a wrong-sign (ghost) residue / propagator zero in the
  elementary two-point function. **This is the finite, kernel-checkable
  incarnation of the G-S constraint** and is a genuinely publishable statement
  regardless of which way it resolves. It is also strictly stronger and
  cleaner than "half the chiral content".
- If instead a *counterexample* is found (chiral survivor, Γ preserved, all
  residues positive), that is a finite object outside both G-S horns and is
  the prize — but note it would have to reconcile with the fact that on a
  finite ring conditions (2)/(3) of GS-C don't apply, so it would be a
  *finite-volume* statement whose continuum fate is a separate question.

### Q2.4 Best theorem-per-week ratio

**C3 (specifically Observable A on the already-computed 4-ring eigenvectors).**
The eigenvectors are in hand; adding Γ and computing χ_survive, χ_gapped,
[U_full, Γ] is finite linear algebra on existing matrices — days, not weeks —
and it converts a physically weak eigenvalue-count into a statement that
actually engages G-S and de-risks C4. C3a (the two-point function / residue
signs) is a bit more work but is the part that unlocks any G-S-facing sentence;
do A first (near-free), then B.

---

## Q3 — Cross-route: does C change Route A?

**Yes, and in a specific, actionable way: the A1 charge should be
chirality-resolved (Γ-graded) from the start.**

- **The finite lab forces it.** The surviving eigenspaces are
  momentum-hybridized; the memo's own sharpened conclusion is "the right
  bookkeeping is which CHIRAL content survives, not which momentum label."
  A charge defined on the *full* crossing eigenspace (momentum- or
  determinant-labelled) will be blind in exactly the way Codex's determinant/
  U(1) flow was shown to be blind on the live stationary-amplitude witness.
  Chirality grading is the non-abelian refinement that the abelian shadow lacks.

- **G-S forces it independently.** GS-Z's second main result — VERBATIM
  "propagator zeros generate the same anomaly as propagator poles" — says the
  invariant that survives the pole↔zero swap is the **anomaly**, i.e. the
  **chirality-weighted** charge. The finite analogue of the anomaly is Route
  A's per-crossing charge; to be the right invariant it must be Γ-graded (a
  local degree of the *chiral block* map), not of the full block. A charge
  that is chirality-blind will fail the acceptance test the determinant flow
  failed.

**Concrete design change to A1.** Define the per-crossing charge as the local
degree/residue of the map built from the adjugate of `U(k)∓1` **restricted to
the Γ-graded (chiral) sub-block** of the crossing eigenspace, i.e. compute two
graded degrees (per chirality) whose signed combination is the anomaly-type
charge. This single definition then serves both routes:

- In Route A (free involutory walk) it is the object that A2/A3 need.
- In Route C it is exactly Observable A's χ computed locally per crossing —
  the graded charge should reproduce the net surviving chirality of the C-lab
  composed unitary.

**Priority/hypothesis effect on Route A.** Route A's *free-level* fence is
untouched (the memo is right that C concedes free-level doubling and moves the
burden to the interacting theory). What changes is the **design of A1**: raise
the priority of getting A1 chirality-graded rather than det-based, and **add a
fourth validation symbol to M2** — the 4-ring composed unitary `U∘V` — on which
the graded charge must reproduce χ_survive. The existing three symbols (cubic
walk: expect ±1, total 0; Gupta–Short: non-involutory tangent zeros the forced
charge; Codex zero-flow witness: invariant MUST separate it) plus this fourth
give a stronger acceptance battery, and the fourth is nearly free because the
C-lab matrices already exist.

One caution to record: GS-Z's insight is that in an *interacting* theory a
crossing can be a pole (genuine mode) *or* a zero (ghost). In the *free* unitary
case there are only poles (genuine eigenphases), so this distinction does not
affect Route A's free-level statements — but the graded charge should be
*defined* so that it is computed from the residue-weighted (pole) content, so
that the same definition remains meaningful when C later feeds it an interacting
unitary. Designing it residue-aware now avoids a redefinition later.

---

## Q4 — Best single use of the remaining ~14h to the audit phase

Given A and C papers frozen, census landed, and boundstate/momentum/restop/
halfcharge2/charge-design in flight, the highest-value single move is:

**Redirect the in-flight boundstate + momentum jobs to emit the three C3
finite numbers on the matrices they already build, plus a cheap N=6 finite-size
control.** Concretely, have them additionally output:

1. **χ_survive = Tr(Γ P_{±1}[U∘V]) and χ_free = Tr(Γ P_{±1}[U])**, plus the
   Γ-graded dimensions of the gapped subspace (Observable A). Requires only
   fixing Γ and reusing existing eigenvectors.
2. **[U∘V, Γ]** — a single commutator — to certify whether the chiral symmetry
   is actually preserved or was secretly broken by the kick.
3. **The residue signs of the surviving ±1 modes in the elementary two-point
   function `G_elm`** (Observable B) — the finite ghost detector — and whether
   the missing poles reappear only after adding the two-particle composite
   interpolating field (the finite GS-C bound-state test).
4. **N=6 (and if trivial, N=8) replication of the mode-count trade and of χ.**
   This is the cheapest possible falsification: it tells us whether the 4-ring
   result is a genuine mechanism or a small-N artifact (recall K=π is the only
   nonzero momentum on N=4).

Why this over anything else: these are the *only* numbers that decide the
evade/instantiate/not-touch verdict against G-S; they are finite linear algebra
on matrices already in memory (fit comfortably in the window); they
simultaneously de-risk C4 (they *are* the well-posed C4 inputs) and Route A
(item 1 = the graded charge on the C-lab symbol, item 3 = the residue-aware
design check). Everything else in flight (restop, halfcharge2, charge-design)
is either free-level (A, untouched by C) or subsumed by getting the graded
charge design right, which items 1 and 3 directly serve.

If forced to pick a *single* deliverable within the window: **item 1 + item 2**
(χ and the commutator) — because together they answer the one question that
makes or breaks Route C's premise: *did the kick remove chiral content without
breaking the chiral symmetry, or did it merely vectorize / cheat?* — and they
are essentially free given the eigenvectors already computed.

---

## Appendix — verbatim G-S anchors for future manuscript sentences

Use these exact strings when a Route C paragraph must cite the constraint; do
not paraphrase the beta-function/anomaly/ghost claims.

- GS-Z, ghost: "The propagator zero thus acts as a ghost state, which ruins the
  unitarity of the gauge theory in the SMG phase."
- GS-Z, beta function: "a propagator zero makes an opposite-sign contribution
  to the one-loop beta function as compared to a normal fermion."
- GS-Z, anomaly: "propagator zeros generate the same anomaly as propagator
  poles."
- GS-Z, gauge invariance vs unitarity: "gauge invariance will always be
  maintained in an SMG phase, in fact, even if the target chiral gauge theory
  is anomalous, but unitarity of the gauge theory is lost."
- GS-Z, the assumption that *fails* for us: "We assume that the (euclidean)
  lattice theory regains full rotational invariance at large distances, and
  thus that the zeros of the propagator are relativistic."
- GS-C, kinematical-zero conjecture: "the zeros that often replace the mirror
  poles of fermion two-point functions in an SMG phase should be
  ``kinematical'' singularities."
- GS-C, bound-state escape: "We conjecture that the SMG interactions generate
  opposite-chirality bound states, which combine with the gapped elementary
  mirror states to form massive Dirac fermions."
- GS-C, the no-go: "If these conditions are satisfied, the massless fermion
  spectrum must be vector-like."
- GS-C, local⇒no-ghost: "if the effective low-energy theory contains poles in
  (the bilinear part of) its hamiltonian, this implies the existence of ghost
  states which make the model inconsistent."
- GS-C, analyticity for NN: "$G(p)$ is an analytic function of $p$ everywhere
  in the Brillouin zone except at the degeneracy points" and "The results of
  App. are sufficient for the no-go theorem, which only requires a continuous
  first derivative."
- GS-C, direct current test: "one considers the two-point function of the
  conserved current of the global U(1) symmetry to be gauged, and calculates
  ... its zero-momentum discontinuity."

**Uncertain attributions flagged for full-text re-check before any manuscript
use:** (i) the numbered condition list (1)/(2)/(3) of the GS-C generalized
no-go is RECONSTRUCTED from the "road map" checks, not from a typeset list in
the transcription — re-read GS-C §"conditions for the applicability" in the
source PDF before quoting the conditions as a numbered theorem. (ii) The
symbol-stripped equations in both transcriptions (chiral projectors, the
χ/ψ strong-coupling decoupling sectors, the G/H_eff relation) had their math
glyphs dropped; verify sign conventions and which sector is the spectator
before citing the decoupling theorem. (iii) The GNVW-flow scope invoked in the
program memo (M3) is independently marked VERIFY there and is not addressed by
either G-S paper.
