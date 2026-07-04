# Gate MP4: Bell causality for quantum growth measures (BC-Q), frozen definition

Status: FROZEN definition note, 2026-07-03 (claude), per Codex review
feedback on the Measure Problem next-steps ordering. This is a DEFINITION
gate, not a computation gate: its deliverable is a precise, checkable axiom,
not a proof or a numerical result. Per Codex's guidance, this prose freeze is
NOT sent to Aristotle in this pass; formalization or an Aristotle audit of
the finite statement is deferred until the definition itself has stood
review. Context:
`Sources/Null_Edge_Measure_Problem.md`, entrance requirement R2 ("Bell
causality of the RULE: no growth step may depend on spacelike-separated
regions of the graph"), and gate MP4 (section 5, item 4 of that document).

## 1. The gap this fills

Bell causality has a settled, decades-old formulation for CLASSICAL
sequential growth (Rideout-Sorkin): informally, the probability of extending
a causal set by one new element depends only on the isomorphism class of
that element's causal PAST within the growing order, not on causally
unrelated ("spectator") structure elsewhere in the same causal set, and not
on the future. [import, debt-flagged: the exact Rideout-Sorkin formal
statement - precursor-set comparability of transition probabilities across
causal sets agreeing on the relevant past - should be re-verified against
the primary source before any paper cites it as "the" classical BC axiom;
this document uses only the informal content above, which is stable across
summaries of the literature.]

No settled analogue exists for QUANTUM growth measures (decoherence
functionals / quantum measure theory on growing causal structures) anywhere
in the literature known to this program - this is a genuine field-frontier
gap, not a defect specific to the SCG candidate
(`Sources/Null_Edge_Measure_Problem.md`, candidate 4(e)). SCG cannot be
graded on entrance requirement R2 until SOME definition is adopted. This
freeze adopts one, states exactly what it does and does not settle, and
checks it against the classical case.

## 2. Setup (shared with the SCG candidate, restated for self-containment)

A decorated growth history is a sequence of steps, each adding one new event
`e_k` to the growing skeleton (a classical causal-set growth move) together
with a decoration LABEL `ell_k` chosen from some finite or continuous
alphabet at that event. Write `pre(e_k)` for the set of PRECURSOR events of
`e_k` already present in the skeleton at step `k` (i.e., the events that are
in the causal past of `e_k` once it is added) and `dec(pre(e_k))` for the
decoration data already fixed at those precursor events by steps
`1, ..., k-1`. A "spectator" event at step `k` is any event already present
in the skeleton that is NOT a precursor of `e_k` (in particular, any event
spacelike-related to `e_k`, but also any event that is simply not yet
causally connected to it in the growing order).

## 3. The frozen definition (BC-Q)

**A decorated growth measure is Bell-causal (satisfies BC-Q) iff both of the
following hold:**

**(i) Skeleton Bell causality (unchanged from the classical case).** The
underlying classical skeleton growth process satisfies the ordinary
Rideout-Sorkin Bell causality condition: skeleton transition probabilities
depend only on the isomorphism class of the new element's precursor
structure, not on spectator structure.

**(ii) Decoration locality (the quantum lift, new).** The single-step
decoration amplitude factors as a PRODUCT of local kernels, each depending
only on the label chosen at that step and the decoration data already fixed
at PRECURSOR events:

```text
A_s(gamma) = prod_{k=1}^{n} w( ell_k | dec(pre(e_k)) ),
```

for some (skeleton-dependent, in general) local kernel `w`, where `gamma`
is a decoration history `(ell_1, ..., ell_n)` compatible with skeleton `s`.
Equivalently: the amplitude assigned to a step's decoration choice is
INDEPENDENT of (a) decoration choices made at spectator events already in
the history, and (b) any decoration choices not yet made (no dependence on
the history's future).

**BC-Q is the conjunction of (i) and (ii).**

## 4. Checks required by this freeze

**4.1 Classical limit (required, and verified here).** If the decoration
alphabet is a single trivial label at every event, `w == 1` identically for
the unique choice, and condition (ii) is vacuous; BC-Q then reduces exactly
to (i), the ordinary classical Rideout-Sorkin condition. PASSES by
construction: BC-Q is a strict generalization, not a replacement, of
classical BC.

**4.2 Non-triviality (required, and verified here).** BC-Q has genuine
content: it explicitly EXCLUDES decoration rules whose amplitude at a step
depends on decorations chosen at spectator events (e.g. a global phase built
from the ENTIRE current history's decoration content, or any rule referencing
decorations at events not causally prior to the new one). So the condition is
not vacuous - it rules out a broad and natural-looking class of "non-local"
decoration rules.

**4.3 The SCG candidate (grading, per this freeze).** The decoration layer of
SCG (`Sources/Null_Edge_Measure_Problem.md`, candidate 4(e)) is constructed
exactly as a product of local coin/step amplitudes along the growing
skeleton - each new event's decoration amplitude (the chirality-coin factor,
`e^{-i mu a sigma_x}` type, per the verified `MassCoinBridge` identities)
depends only on the decoration state carried in from that event's unique
causal precursor in the 1+1D construction, never on spectator data. **SCG
satisfies BC-Q condition (ii) by construction**, PROVIDED its skeleton layer
(inherited classical CSG) is confirmed to satisfy (i) - which is a property
of the imported skeleton class, not of the decoration layer, and is not
re-derived here (debt-flagged along with the rest of the skeleton import).

## 5. What this freeze explicitly does NOT settle

- **Uniqueness.** BC-Q as frozen is a SUFFICIENT, constructively verifiable
  condition satisfied by product-amplitude (factorized) constructions like
  SCG. Whether it is the CORRECT, most general, or unique defensible quantum
  generalization of Bell causality - as opposed to a weaker condition stated
  directly on the decoherence functional `D` rather than on the amplitude
  `A_s` (which could in principle permit some interference between
  spacelike-separated decoration choices while still respecting causal
  factorization of `D` itself) - is NOT settled by this document and remains
  the open field-frontier question. This freeze commits the program's
  OPERATIONAL definition for grading factorized candidates; it does not
  claim to have resolved the general problem.
- **Back-reacting extensions.** The back-reaction criterion
  (`GateMP.SCGGramPositivity`, proved: a decoration-dependent skeleton
  weight `W` preserves quantum-measure positivity iff `W` is a PSD kernel)
  concerns a DIFFERENT axis - whether the skeleton weight may depend on
  decoration pairs - and is orthogonal to BC-Q as stated here, which concerns
  only whether decoration AMPLITUDES are causally local. A future
  back-reacting extension of SCG would need its own Bell-causality check on
  the kernel `W` (does `W(gamma,gamma')` depend only on causally compatible
  geometric/decoration data); that check is NOT performed by this freeze and
  is registered as future work.
- **Formalization.** No Lean statement is proposed in this pass. Per Codex's
  guidance, formalizing BC-Q (e.g. as a finite predicate on decorated growth
  steps, with the classical-limit reduction as a lemma) is appropriate ONLY
  after this prose definition has been reviewed and, if needed, revised -
  premature formalization of an unstable definition wastes Aristotle budget
  on a moving target.

## 6. Disposition

- MP4 is FROZEN as of this document: BC-Q (section 3) is the program's
  adopted operational definition of Bell causality for factorized quantum
  growth measures.
- Grading update for `Sources/Null_Edge_Measure_Problem.md`: candidate 4(e)
  (SCG)'s entrance-requirement grading for R2 upgrades from "pending MP4"
  to **satisfied for the decoration layer under BC-Q (ii), conditional on
  the imported skeleton layer satisfying classical BC (i), debt-flagged**.
  SCG's overall B-1 grading (section 2 of the Measure Problem document)
  should be updated accordingly: no longer "one frozen definition short,"
  but graded against BC-Q with the stated scope limitation (section 5)
  recorded alongside it.
- Next action if this definition survives review: state BC-Q as a finite
  Lean predicate and check the classical-limit reduction (section 4.1) as a
  lemma - a small, well-scoped follow-up gate, not undertaken in this pass.
