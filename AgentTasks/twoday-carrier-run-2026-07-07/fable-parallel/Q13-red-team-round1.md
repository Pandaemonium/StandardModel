# Q13 (round 2). Red team: attack the round-1 verdicts

Section 5 of the briefing is now the program's working spine. It was produced
by consultations of your own caliber and spot-verified by the executors - which
is precisely why it deserves a dedicated adversary before we spend months of
kernel work on it. Your ONLY goal in this window: find what is WRONG, weakest,
or silently load-bearing in section 5. A confirmed error is worth more to us
than any new theorem; a clean bill of health is acceptable only with the audit
trail that earns it.

## Rules of engagement

- Attack the MATHEMATICS first (false or gappy claims), the FRAMING second
  (claims that are true but graded too strongly, or whose hypotheses do more
  work than advertised), the STRATEGY third (places where the recommended
  route is inferior to an alternative).
- Every attack: state the target verdict verbatim, the precise flaw, and the
  smallest explicit counterexample or the missing lemma. Failed attacks are
  worth reporting in one line each (what you tried, why it bounced).
- Do not re-derive section 5 sympathetically. You are not a co-author here.

## Priority target list (our own doubt-ranking; feel free to reorder)

1. **Theorem A's canonicity clause (5a).** The positivity iff (b + r = q) is
   interlacing-solid; the CANONICITY claim (N = gauge directions iff Gamma'
   isotropic, under "first-class self-generation") leans on the finite
   Gauss-law structure being exactly "shift generated through the form along
   the covector". Is that the right finite formalization of first-class-ness?
   Construct a finite gauge system whose honest gauge directions are NOT the
   form-shifts of its constraint covectors, if one exists.
2. **The trichotomy kill (5a).** "Real-split constraint planes = no
   first-class positive sector, full stop." Is there an escape via ENLARGING
   the constraint set (second-class pairs, Dirac brackets) that rescues a
   physical sector at acceptable cost, making the kill softer than stated?
3. **dim(V'/N) = ind(D) (5a headline).** The identity needs (p, q) =
   (dim M_+, dim M_-) - i.e., the fundamental symmetry IS the chirality. For
   carriers where J and Gamma differ (are there physically forced cases?),
   what replaces the identity? Is the headline secretly a convention?
4. **Lemma 0's scope (5b).** Exact invariance of Tr f(D^#D) under vertex-local
   Krein-unitary redecorations - check the claimed generality: does it survive
   redecorations that act on the SOLDERING (alpha-rotations) as stated, given
   that c(alpha) changes? Is the invariance group as large as claimed, or is
   the correct statement unitary-conjugation-invariance only (making the
   block-trace critique weaker)?
5. **The P-probe (5b).** We hand-verified T = 0 and positive drift. The
   CONCLUSION ("the S-sector carries non-torsion content, so pure-torsion
   telescoping is dead in all conventions") quantifies over conventions - is
   there a stencil/convention we and the memo both missed in which the drift
   is itself a total difference (making the kill convention-relative)?
6. **Axiom (B) of the pentad selection (5d).** "Anomaly identities robust in
   the weights iff n >= 4; n = 3 fails via (a, a, -2a) giving +/-12a^3." Check
   the quantifier structure: the SM-relevant condition is anomaly cancellation
   AT the physical weights, not identity-in-weights robustness. Is
   identity-robustness the right axiom, or is it doing hidden selection work
   that a weaker, more honest axiom would not do (opening n = 3 or n = 4
   fibers with tuned weights)?
7. **The B-L twist counterexample (5d).** It claims the twisted decoration has
   the same kappa and the same Weitzenboeck inertia. Verify: does twisting the
   U(1) leave the KREIN data (not just the abstract commutant) invariant, or
   does the twist move the turn census in a way that a sufficiently refined
   invariant (short of the full census) already detects?
8. **The {1,3} menu (5e).** The no-two clause rests on "an order-2 outer
   monodromy has orbit type 1+2 with non-isomorphic families". Attack via
   composite monodromy groups (S3 itself rather than Z/3; or Z/3 acting with
   a twist), via disconnected-cover loopholes, and via the simplicity clause's
   exact statement. Is {1, 3} really exhaustive for CHARGE-IDENTICAL protected
   families under the stated hypotheses?
9. **Cross-memo composition (5d + 5e).** The composed claim "strand pentad
   (x) triality monodromy = 3 x one SM generation" was OUR synthesis, not any
   single memo's. Audit the composition seams: does the family factor's
   monodromy commute with the strand architecture's Krein/J_R structure
   (cf. Q11/Q12)? Does the equivariant-index prerequisite (L0) suffice for
   the composed object, or does it need a further two-group refinement?
10. **Executor verification gaps.** We hand-checked: O2/O3, the 2x2
    trichotomy, perp-signature arithmetic, the P-probe computations, the
    dispersion identity, the bidegree/hypercharge table, Witten evenness, the
    Koide algebra, the PMNS Sym^2 normal form. We did NOT independently
    verify: the O1/O4/O5 details, the 2+1 torus mode computation, the
    corrected-telescoping Phi decomposition's exact shape, the (4,1)
    competitor's THREE-channel Yukawa census, the cover lemma (we flagged its
    hypothesis), and all literature attributions. Prioritize those.

## Output format

Findings ranked by severity: BROKEN (with counterexample/proof) /
DOWNGRADED (true but weaker than graded; give the honest regrade) /
LOAD-BEARING GAP (unproved step doing real work; give the missing lemma) /
BOUNCED (attack attempted, verdict survived; one line). End with the
one-paragraph "what I would fix in section 5 before any further kernel spend".
