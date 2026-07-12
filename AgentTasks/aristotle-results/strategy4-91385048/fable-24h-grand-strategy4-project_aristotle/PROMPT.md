# Grand strategy 4 (Fable lanes, 24h run, T+5h)

REVIEW-ONLY. Deliverable: STRATEGY_MEMO.md. This packet contains TWO
manuscripts: the Paper E dynamics skeleton and the Furey-Baez (FB)
formalization manuscript. Audit the actual prose. You have no Lean
sources here; check internal calibration (prose vs its own status
marks), not kernel truth.

## State since strategy 3

- Papers A and C reached freeze-grade: all five A wording fixes (R1-R5)
  and the C existence-vs-multiplicity split landed and double-compiled.
  C's split was CORRECTED against a fresh oracle: the true law is
  dim ker(W-+1) = 2 for the eight singleton fields, 4 for the four
  domain-block fields (kernels = unions of the two constituent
  singleton kernels), 0 for zero-/four-wall controls; a census
  formalization job with complete certificates (kernel vectors +
  invertible minors + rank-nullity) is in flight.
- E momentum companion decided by gated oracle and submitted: blocks
  (6,8,6,8); K=0 carries 4 (+1) / 2 (-1); K=2 carries 2/2/2 with the
  doubled-phase pair; K=1,3 the quadruples; kick breaks translation
  ((T2K2-K2T2)_00 = 3i/5) but is momentum-neutral (|P_K e01|^2 = 1/4);
  charpoly(U2) = monic block product. E's spectrum section now carries
  this table with an oracle-exact tag.
- Still in flight: boundstate (28x28 interacting factorization + cubic,
  ~4h, 33% but actively proving), halfcharge2 (~5h), census, momentum.
- E fixture-scope fix landed (the 4/5-vs-1 discriminator now names
  z=3+4i vs z=5 in abstract and body).

## Q1 - E PAPER referee read (primary)

Read `context/Null_Edge_Finite_CAR_Dynamics_Draft_2026-07-12.tex` as a
hostile referee in the interacting-quantum-cellular-automaton
literature (Bisio-D'Ariano-Perinotti-Tosini Thirring QCA; Mlodinow-Brun).
(a) The five highest-risk sentences, verbatim, with one-line fixes -
    same format as your strategy-3 Paper A audit.
(b) Is the PENDING-slot architecture honest as a submission skeleton if
    boundstate lands (spectrum slot fills) but halfcharge2 does not?
(c) Does the momentum-table paragraph overclaim anywhere? In particular
    "the interaction can, and does, recruit levels from every sector" -
    is the "and does" licensed by a momentum-neutral support fact plus
    a factor-multiset trade, or does it need eigenvector tracking that
    nobody has proved? Suggest exact replacement wording if not.
(d) Venue fit and the single most valuable missing theorem.

## Q2 - FB MANUSCRIPT hostile read (secondary)

Read `context/Furey_Baez_Octonion_SM_Formalization_Manuscript_2026-07-11.tex`.
It was recast from a correspondence-collection into a master-question
architecture (Jordan-Clifford bridge program section, graded rungs,
kill conditions). As a referee from the octonions/division-algebra
particle-physics community (Furey, Baez-Schwahn, Boyle readers):
(a) The five highest-risk sentences, verbatim, with one-line fixes.
(b) Does the Jordan-Clifford bridge section keep the mandatory semantic
    boundaries (rep conjugacy is not particle-antiparticle; idempotent
    is not QFT vacuum; degree is not compositeness; empty/full is not a
    weak doublet; EW operators = consistent construction, not
    derivation)? Quote any sentence that slips.
(c) Is the Baez-Schwahn boundary remark (identity-component subscript
    load-bearing; coordinate avatar mapping) stated accurately per the
    2026 paper's actual theorem statements as summarized in the
    manuscript's own source-audit quotes?
(d) Venue fit (candidate: J. Phys. A / Adv. Appl. Clifford Algebras /
    arXiv-first) and the one structural change with best value.

## Q3 - endgame ordering (remaining ~16h, landing freeze 08:00)

Given: A and C frozen; E waiting on 2-4 harvests; FB prose-complete but
unaudited; audit phase 08:00-09:45 needs HONEST_SCORECARD.md +
FINAL_REPORT.md with a verifier run twice.
(a) Rank the remaining moves by expected referee-facing value per hour.
(b) Design the HONEST_SCORECARD.md skeleton: what columns/rows make the
    morning audit fast and un-gameable (claim, kernel status, guard
    pin, oracle tag, manuscript anchor, known gaps)?
(c) Name the two most likely "manufactured completion" traps in the
    final 16h of a run like this, and the concrete check that defeats
    each.

Do not propose new Lean jobs unless they beat the in-flight four on
value per hour. Be specific and quote verbatim.
