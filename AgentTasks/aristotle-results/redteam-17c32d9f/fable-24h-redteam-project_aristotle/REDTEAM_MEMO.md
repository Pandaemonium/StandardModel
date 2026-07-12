# Hostile-referee red-team memo

**Posture:** reading for rejection. Strengths are not restated. Every quotation is verbatim
from the `.tex` sources in `context/`; line numbers are from those files. Three manuscripts:

- **Paper A** = `Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`
- **Paper E** = `Null_Edge_Finite_CAR_Dynamics_Draft_2026-07-12.tex`
- **Paper F** = `Furey_Baez_Octonion_SM_Formalization_Manuscript_2026-07-11.tex`

Each paper is graded on the four requested axes, then a single portfolio-level
highest-payoff edit is named at the end.

---

## Paper A — "Null-Spinor Area as the Rest Gap of an Exactly Unitary Dirac Walk"

### (1) The one sentence most likely to trigger "this overclaims"

> "and every odd Hermitian rest operator is $B_w$ for a unique $w\in\C$: the rest
> gap is the null-spinor area, with no independent mass parameter." (abstract, lines 71–72)

Why it detonates: the phrase "**with no independent mass parameter**" is the load-bearing
selling point of the whole paper (it is echoed in the title's word "Rest Gap" and in the
boxed synthesis theorem), but the paper's *own* body concedes it is a reparametrization,
not a derivation: "A constant $|z|$ alone would only reparametrize an assigned Dirac mass"
(abstract, lines 111–112) and "Nor does the theorem compute an absolute mass scale:
rescaling the input spinors rescales $z$ and hence $\mu$" (§"What is forced…", lines
~2400). A referee reads "no independent mass parameter" as "we derived mass from geometry";
the body then says the magnitude is a free input after all. That is the textbook overclaim
gap.

**Minimal fix:** change to "…: the rest gap is *re-expressed as* the null-spinor area
(equivalently $\mu=\sqrt{\det P}$), trading the scalar mass input for the spinor input
rather than eliminating a free scale." One clause; keeps the true content (the operator
packaging $B_z$), kills the "derived-mass" reading.

### (2) Where a \Kernel tag outruns the finite formal statement

The abstract's crossing-classification clause is parenthetically honest but then
contradicted two sentences later. Verbatim, the parenthetical (lines ~140–143):

> "(the Jacobian and census arithmetic machine-checked; the symbol-to-Jacobian reduction
> **an exact run record**, its central-node instance in kernel formalization)."

i.e. the "complete crossing classification … at every momentum" is *not* fully kernel-checked
— the symbol→Jacobian reduction is a computer-algebra "run record," and only the
central-node instance is in the kernel. Yet the same abstract closes with:

> "**Every finite statement above is checked in Lean~4**; the novelty is the derived rest
> operator and its verified dynamical chain…" (lines 154–155)

The closing sentence asserts blanket kernel coverage that the paper's own parenthetical
already exempted ("run record", "central-node instance"). This is the manuscript-level
"docstring outruns kernel": the global verification adjective is broader than the itemized
trust marks the paper itself assigns. A hostile referee quotes both lines side by side.

**Minimal fix:** soften the closer to "Every statement above carries the trust mark stated
at its point of use; unmarked prose is interpretation." Do not say "Every finite statement …
is checked in Lean 4" while an "exact run record" item sits above it.

### (3) Weakest link in the logical spine

The spine is: *null-spinor geometry DERIVES a mass operator, not merely a mass number.*
Pull on it and it reduces to the classical identity $\det P=|\psi\wedge\phi|^2$ (two null
momenta pair to a timelike one). The genuinely new object is the packaging
$B_z=\bigl(\begin{smallmatrix}0&z\\\bar z&0\end{smallmatrix}\bigr)$; the classification
theorem (Thm, lines 690–703) shows odd-Hermitian rest operators are *exactly* the $B_w$ —
but "odd Hermitian" was **chosen** so that it anticommutes with $\Gamma$, so the theorem
says: *if you demand the rest term anticommute with the grading, it is a complex number.*
That complex number is then **identified with the spinor area by construction**, and its
modulus has no absolute scale. So "derivation" collapses to "renaming + a $2\times2$ normal
form." Everything downstream (split-step walk, $O(1/n)$ Trotter convergence) is a standard
Dirac-QW computation with a complex coin. A referee who presses "what is derived that a
scalar mass could not supply?" gets the paper's own answer — only the **orientation phase**
("the construction escapes through its oriented data," line 113) — which is a much smaller
claim than the title.

### (4) Abstract's strongest claim vs. body

Two different "strongest" claims, opposite verdicts:

- **Convergence claim** — "converge to the corresponding Dirac flow uniformly on bounded
  momentum boxes at rate $O(1/n)$, for the $1+1$ walk and for an ordered $3+1$
  successive-axis walk" (lines 76–78): **delivered.** Thm `thm:rate` (1+1, §"Uniform many-step",
  \Kernel) and Thm `thm:3plus1rate` (3+1, eqns (1.?)/`eq:3plus1ratebound`,
  `eq:complex3plus1rate`, \Kernel) both land, including the complex-phase transfer.
- **Derivation/continuum claim** — the title-level "Rest Gap … Dirac Walk" and any
  continuum reading: **hedged in body.** The body explicitly disowns the PDE limit
  ("We do not yet claim that final PDE theorem," line ~1243; "position-space PDE
  convergence … remain open," abstract lines 156–158). So the abstract is honest *there*,
  but the "no independent mass parameter" framing (axis 1) is the strongest-sounding claim
  and it is the one the body quietly reduces to a reparametrization.

**Net:** the analysis chain is delivered; the *headline* ("mass from geometry, no mass
parameter") is softer in the body than in the abstract.

---

## Paper E — "Exact Pair-Gate Dynamics on a Fermionic Walk"

Context the referee will weaponize: the title page says "**draft v0 (skeleton; 24h run)**"
and the appendix is "[PENDING: module/guard table on freeze.]" A top venue rejects a
self-described skeleton on sight; but the substantive defects are worse.

### (1) The one sentence most likely to trigger "this overclaims"

> "We assemble a machine-checked account of the interacting layer of a finite fermionic
> quantum walk." (abstract, line 41)

Why it detonates: the paper's *flagship* interacting result — the exact two-particle
spectrum of §4, the degree-12 palindromic factor and the cubic
$3125w^3-2300w^2-6156w-1440=0$ — is by the paper's own words **not** machine-checked:

> "[oracle-exact; formalization in flight … until it lands every constant in this section
> carries the oracle-exact tag and **nothing in this section is claimed as kernel**]." (§4,
> lines 155–158)

So the abstract advertises "a machine-checked account of the interacting layer," while the
one section that *is* the interacting layer's payoff explicitly claims nothing as kernel.
Abstract and body contradict on the single most important word.

**Minimal fix:** "We assemble a **partly** machine-checked account …, with the interacting
two-particle spectrum (§4) still **oracle-exact and not yet kernel-checked**." 10 minutes.

### (2) Where a \Kernel-family tag outruns the finite formal statement

The structural companion to §4 is tagged `\DraftTrust` — defined on the title page as
`\textsc{Kernel+Eval}` — and its provenance is:

> "(\texttt{PairMomentumBlocks}, \DraftTrust{}: kernel statements transported from **two
> disclosed compiled-evaluator identities on a Gaussian-rational twin**)." (§4, lines
> 159–161)

Three separate stretches here: (a) the trust is "Kernel+**Eval**", i.e. it rides on a
compiled evaluator (a `native_decide`-class step), not the kernel alone; (b) the identities
are "**transported**," not proved directly on the object of interest; (c) they hold on a
"**Gaussian-rational twin**" — a *surrogate* object, not the stated momentum-block operator.
A `\Kernel`-adjacent green tag sitting next to "compiled-evaluator … on a twin" is the
manuscript-level docstring-outruns-kernel: the prose ("the structural companion is now
machine-checked") reads as kernel certainty; the fine print is eval-trusted, transported,
and about a stand-in. Same issue in the Remark: `kick_breaks_translation` carries
`\DraftTrust`, not `\Kernel`, while the surrounding prose says "The ring-level witness is
**now machine-checked**" (§3 Remark).

**Minimal fix:** in §4 and §3, replace "machine-checked" with "checked up to a compiled
evaluator on a Gaussian-rational surrogate (\DraftTrust)"; state explicitly that no kernel
proof of the actual-field statement exists yet.

### (3) Weakest link in the logical spine

The title promises "**an exact interacting spectrum**." The entire content that would make
the paper more than a restatement of the generator algebra — §4, the spectrum factorization
— is a promissory note ("formalization in flight," "the paper's pending flagship,"
Appendix "[PENDING]"). Remove §4 and what remains (generator cube-closure $K^3=|z|^2K$,
disjoint-support commutation, causal cones) is genuine but is the *free/kick-algebra layer*,
already the substance of Paper A's many-body section. A referee pushes once — "where is the
exact interacting spectrum the title sells?" — and the narrative has no kernel-backed answer.

### (4) Abstract's strongest claim vs. body

Strongest claim = "the composed step's two-particle spectrum is computed exactly" +
"machine-checked account of the interacting layer." **The body openly retracts it**: §4,
"nothing in this section is claimed as kernel." This is not a hedge — it is a withdrawal.
The abstract's centerpiece is the body's explicit non-result.

---

## Paper F — "Verified Octonionic Algebra for Standard Model Gauge Structure"

This is the best-defended of the three (a "Claim boundary, stated first" paragraph, a
non-results list). The attack surface is narrower but real.

### (1) The one sentence most likely to trigger "this overclaims"

> "we prove that the group of octonion algebra automorphisms fixing the distinguished
> imaginary unit is multiplicatively equivalent to $SU(3)$ --- with the target literally
> Mathlib's $\leanname{Matrix.specialUnitaryGroup}$." (abstract, lines 53–56)

Why it detonates: unqualified, "the group of octonion algebra automorphisms" reads as
$\mathrm{Stab}_{G_2}(e_{111})\cong SU(3)$ — a statement about the *Lie group* $G_2=\mathrm{Aut}(\mathbb{O})$
that octonion-SM papers actually invoke. What is proved is about the **algebraically defined**
automorphism group of one **explicit finite octonion model**; the body's own Remark (Boundary,
lines ~325–333) admits "It does not formalize the topological or smooth Lie group $G_2$, its
connectedness, or the statement '$\mathrm{Stab}_{G_2}(e_{111}) \cong SU(3)$' as a theorem about
manifolds." The abstract omits exactly the qualifier the body insists on.

**Minimal fix:** insert two words in the abstract — "the group of **algebraically defined**
octonion-model automorphisms fixing …". Removes the Lie-group reading at the point of first
contact.

### (2) Where a \Kernel tag outruns the finite formal statement

Theorem "Stabilizer equivalence" (thm:su3): the prose upgrades a monoid/`MulEquiv` to a
group isomorphism in words the kernel does not carry:

> "**this is a group isomorphism**; the packaged Lean object is the multiplicative
> equivalence, and the inverse-preservation transport is the standard one-line consequence,
> **not a separately formalized theorem**." (lines 306–308)

The `\Kernel` object is a *multiplicative equivalence onto a submonoid* proved equal to
`Matrix.specialUnitaryGroup`; the "group isomorphism" is asserted in prose and explicitly
flagged as *not formalized*. The docstring ("group isomorphism") outruns the kernel object
(`MulEquiv` onto a submonoid). Also relevant: the abstract's blanket "with **every theorem**
kernel-checked at the standard axiom footprint" (line 51) is narrowed by §3 to "checked, **at
the time of writing** … but **only the flagships** have that footprint enforced on every
build" (lines 202–210) — "every theorem, enforced" in the abstract vs. "flagships enforced,
the rest checked once by hand" in the body.

**Minimal fix:** in thm:su3, state "the formalized object is a `MulEquiv` onto the
submonoid `= specialUnitaryGroup`; group-isomorphism is the immediate unformalized
corollary." In the abstract, "with the flagship theorems kernel-checked under build-enforced
axiom guards and the remainder checked by reproducible `#print axioms` queries."

### (3) Weakest link in the logical spine

The spine that makes this more than "three known finite computations re-verified in one
convention" is the **unification** thesis — one complex structure $e_{111}$ *selects* the
whole package across Baez / Furey / DVT. §8 concedes this is not proved:

> "these are **parallel uses of a common choice**, not corollaries of one master theorem."
> (line 662)

and the "master question" (does the Jordan flag *force* the gauge group, the fermion module,
the $\mathbb{Z}_6$?) is left as open rungs (i)–(iv), §"Jordan–Clifford bridge." Likewise the
DVT flagship (Thm `thm:dvt`) is a *coordinate* $M_3(\mathbb{C})$ two-sided-action
characterization; its link to the actual $F_4$/Baez–Schwahn intersection theorem is
"**External (source-verified, not formalized)**" and "**Open:** a kernel-checked composition
joining these layers." So the paper's cohesion claim — its reason to exist beyond an audit of
finite lemmas — is exactly the part that is unproven. A referee: "granting every kernel line,
what is established that the four source papers did not already assert? The convention bridge
and finite re-checks; the unification is future work."

### (4) Abstract's strongest claim vs. body

Strongest claim = the $SU(3)$ equivalence "with the target **literally** Mathlib's
`Matrix.specialUnitaryGroup`." **Delivered** at the algebraic level (guard-pinned
`su3Submonoid_eq_specialUnitaryGroup`). But the body attaches two hedges the abstract omits:
(a) it is the algebraic, not Lie, automorphism group (Boundary remark); (b) the Lean object
is a `MulEquiv`, group-isomorphism unformalized (thm:su3 prose). So the claim is *substantially*
delivered, with two silent narrowings — the honest verdict, and the least damaging of the three
papers on this axis.

---

## Cross-paper: the ONE change with highest accept-probability payoff (<2 h)

**Make each abstract's single global verification adjective match the body's own boundary
text — and do Paper E's first, because there the abstract and body flatly contradict each
other.**

All three papers share one failure mode: an abstract-level blanket verification word that the
body's fine print already exempts.

- Paper E: "a **machine-checked** account of the interacting layer" (line 41) vs. §4
  "**nothing in this section is claimed as kernel**" (line 157).
- Paper A: "**Every finite statement above is checked in Lean~4**" (line 154) vs. its own
  "**exact run record**" item (line 143).
- Paper F: "with **every theorem kernel-checked**" (line 51) vs. §3 "**only the flagships**
  have that footprint enforced" (line 209).

A hostile referee needs only to place the abstract line next to the body line to justify
rejection for "verification claims not supported by the paper's own text" — the single most
damaging charge against a formalization paper, because it undercuts the one thing these papers
sell (trust). Fixing it is pure editing: replace each blanket adjective with the scoped version
already present in the body (≈4 sentences per paper, well under two hours total). Highest-leverage
instance is **Paper E line 41**: change "a machine-checked account of the interacting layer" to
"a partly machine-checked account, with the interacting two-particle spectrum (§4) still
oracle-exact," which removes a direct self-contradiction with §4 and costs ~15 minutes.

This single, uniform edit converts the dominant referee reaction from "the verification claims
are inflated" (fatal for a formal-methods venue) to "scoped and auditable," at essentially zero
mathematical cost and no new proofs.

---

### One-line severity ranking (most to least reject-prone, hostile view)

1. **Paper E** — self-described skeleton; abstract's "machine-checked … interacting layer"
   retracted by its own §4; flagship is a promissory note. Reject as premature.
2. **Paper A** — strong verified analysis core, but the headline "no independent mass
   parameter / derived mass" is a reparametrization the body concedes, and the abstract's
   "Every finite statement … checked in Lean 4" is contradicted by its own "run record" item.
3. **Paper F** — best defended; real exposure is the abstract dropping the "algebraic-not-Lie"
   and "MulEquiv-not-group-iso" qualifiers, and the unproven unification thesis being the only
   thing that lifts it above a finite-lemma audit.
