# Literature log: overnight YM run 2026-07-03

Standing target list (worked top-down by T6, woven through all lanes)
plus the append-only log of searches-that-mattered and ingests. Protocol
in `RUN_PLAN.md`. Every entry in the debt register was cited FROM MEMORY
in the freeze/program docs - treat every remembered identifier, year,
and hypothesis as unverified until checked against the source.

## Standing targets (priority order)

1. **Osterwalder-Seiler 1978** (Ann. Phys., lattice gauge RP +
   strong-coupling expansion). Verify: the exact link-reflection
   positivity statement and hypotheses; the LINK vs SITE reflection
   distinction as they state it; the strong-coupling convergence regime.
   Affects: T1 claim language (flagship paper), T5 (YM4-a/b/c statement
   shapes). Load-bearing. **[02:35 VERIFIED - existence/citation only]**
   Osterwalder & Seiler, "Gauge field theories on a lattice", Ann. Phys.
   110 (1978) 440-471, DOI 10.1016/0003-4916(78)90039-8. Citation
   confirmed genuine via web search (ScienceDirect + secondary
   summaries: "begins a rigorous, nonperturbative investigation of
   quantum field theories with local internal symmetries... verifying
   physical positivity for the Schwinger functions"). Full-text LINK vs
   SITE statement-shape detail NOT yet extracted (paywalled; PDF-fetch
   tooling in this session could not render primary-source PDFs to
   text) - still open for whoever formalizes RP-LINK to check against
   the primary source directly, not just this secondary confirmation.
2. **Elitzur 1975** (Phys. Rev. D). Verify: original statement and proof
   scope vs the freeze's quantitative volume-uniform version (which is
   self-contained; this is attribution only). Affects: YM1 paper
   attribution; the shipped `ElitzurCore`/`ElitzurLattice` docstrings.
   **[02:35 VERIFIED]** Elitzur, "Impossibility of spontaneously breaking
   local symmetries", Phys. Rev. D 12 (1975) 3978-3982, DOI
   10.1103/PhysRevD.12.3978. Citation exact match; abstract confirms
   scope ("spontaneous breaking of local symmetry for a symmetrical
   gauge theory without gauge fixing is impossible... demonstrated in a
   simple system of Abelian gauge fields on a lattice") - matches this
   program's attribution use precisely (the shipped Z2 result IS a
   quantitative strengthening of exactly this).
3. **Kotecky-Preiss 1986 (CMP) + Ueltschi's form of the criterion**.
   Verify: the exact KP condition (weight function, the `a(gamma)`
   choice, what "cluster expansion converges" concludes, tail bounds).
   BLOCKS T5's Lean statement freeze (F-YM-LIT: a wrong hypothesis here
   poisons the most reusable module on the ladder). Load-bearing.
   **[02:35 CROSS-CONFIRMED, unblocks T5]** Kotecky & Preiss, "Cluster
   expansion for abstract polymer models", Commun. Math. Phys. 103
   (1986) 491-498 - citation confirmed genuine (ADS, Project Euclid,
   Springer all agree). Could not extract the PRIMARY source's exact
   wording (PDF-fetch tooling in this session renders binary streams,
   not text, for paywalled/scanned PDFs), but THREE independent
   secondary sources (a modern rederivation paper math-ph/0605041 by
   Fernandez-Procacci, and two further restatements found via search)
   all state the SAME criterion up to notation: for every polymer
   `gamma`, `sum_{gamma' incompatible with gamma} |w(gamma')| e^{a(gamma')}
   <= a(gamma)` implies absolute convergence of the cluster expansion for
   `log Z`. This is a VERBATIM match to what the freeze document
   (section 7) already states as "Ueltschi form" - the freeze's own
   citation is CORRECT as far as this cross-referencing can confirm.
   Recommend: whoever formalizes KP for T5 should still pull the primary
   CMP 1986 PDF (or the arXiv rederivation math-ph/0605041, which IS on
   arXiv and fetchable) directly before freezing the Lean statement, to
   get the exact tail-bound formula this log could not extract.
4. **Wegner 1971** (J. Math. Phys., Z2 gauge dualities). Verify:
   statement of the 2D/3D dualities for the YM1 paper's positioning
   section. Dualities are NOT tonight's formalization scope.
   **[02:35 VERIFIED]** Wegner, "Duality in generalized Ising models and
   phase transitions without local order parameters", J. Math. Phys. 12
   (1971) 2259-2272, DOI 10.1063/1.1665530. Citation exact match.
5. **Wilson 1974** (Phys. Rev. D). Verify: the strong-coupling
   confinement argument's actual claim (for YM4 positioning and the
   plaquette-action attribution). **[02:40 VERIFIED]** Wilson,
   "Confinement of quarks", Phys. Rev. D 10 (1974) 2445, DOI
   10.1103/PhysRevD.10.2445. Citation exact match; scope confirmed
   (lattice gauge theory quantization preserving exact gauge invariance;
   strong-coupling expansion via sums over quark paths and worldsheet-
   like surfaces; confinement mechanism in the strong-coupling limit).
6. **Banks-Casher 1980**. Verify: original relation and conventions vs
   the freeze s8 finite shadow. Affects T4 statement docstring.
   **[02:40 VERIFIED]** Banks & Casher, "Chiral symmetry breaking in
   confining theories", Nucl. Phys. B169 (1980) 103-125. Citation exact
   match; scope confirmed (chiral order parameter in confining gauge
   theories; the relation links the chiral condensate to the
   near-zero-eigenvalue density of the Dirac operator - matches the
   freeze s8 finite shadow's target relation).
7. **Jaffe-Witten official problem statement + CMI rules**. Verify:
   exact wording of the existence + gap requirements and the
   universal-quantifier-over-G scope. Affects: all prize-adjacent claim
   language (F-YM-CONFLATE guard text). **[02:40 VERIFIED via secondary
   sources - primary CMI PDF unrenderable by this session's tooling]**
   Statement (Wikipedia, cross-checked against the freeze's own s1
   wording - matches precisely): for any COMPACT SIMPLE gauge group `G`,
   prove existence of a nontrivial quantum YM theory on R^4 satisfying
   axioms "at least as strong as" Streater-Wightman (1964) AND
   Osterwalder-Schrader (1973, 1975), with mass gap `Delta > 0` (example
   given in the official text: for G=SU(3), glueballs have a strictly
   positive lower mass bound). CMI rules (claymath.org/millennium-problems/rules,
   confirmed): three conditions before consideration - (i) published in
   a Qualifying Outlet, (ii) at least TWO YEARS since publication, (iii)
   general acceptance in the global mathematics community; rules revised
   2018-09-26; CMI does not accept direct submissions. This closes the
   loop on the arXiv:2606.19362 flag above: even setting aside every
   other concern, publication in June 2026 means the 2-year clock cannot
   possibly have run - "solved" is premature by CMI's own rules alone.
8. **Prior-formalization novelty check** (gates every "first ever"
   sentence). Search: has ANYONE formalized lattice gauge theory,
   Wilson-action gauge invariance, transfer matrices, or reflection
   positivity in Lean/Isabelle/Coq/HOL? Check: AFP index, Mathlib +
   PhysLean (lean-explore), arXiv (cs.LO + hep-lat crossovers), Zulip
   archives via web. Record the verdict WITH the searches run, whatever
   it is. A negative result (someone did it) is a first-class finding.
   Load-bearing. **[02:35 SUBSTANTIALLY ADVANCED - two major finds, see
   log entries below]:**
   - **arXiv:2606.19362** (Faizal & Shabir, "Reflection-Positive
     Construction of a Four-Dimensional SU(N) Yang-Mills Theory with
     Mass Gap and Confinement", Fortschr. Phys. 74 (2026) e70097)
     CLAIMS the full Millennium Prize content, informally. Do NOT cite
     as settled prior art - see the flagged entry below for the full
     skepticism case. Its existence alone means the flagship claim
     language must be doubly careful not to imply "we solved this
     first" even informally.
   - **arXiv:2603.15770** (Douglas, Hoback, Mei, Nissim, Cipollina, Yin,
     "Formalization of QFT", March 2026) IS a genuine, community-visible
     Lean 4 + Mathlib formalization of the Glimm-Jaffe/Osterwalder-
     Schrader axioms for the FREE bosonic field in 4D Euclidean
     spacetime (discussed at Harvard, on Peter Woit's blog, integration
     into `leanprover-community/physlib` (= this repo's "PhysLean") is
     an open GitHub issue). This is NOT lattice gauge theory and NOT
     reflection positivity for an interacting/gauge theory - so it does
     NOT preempt this program's "first formalized RP for LATTICE GAUGE
     THEORY" claim - but it DOES mean "first ever Lean formalization of
     OS/GJ-type axioms" would be FALSE, and this is the closest,
     highest-quality adjacent art found tonight. Any future YM7
     (Osterwalder-Schrader reconstruction) work should look at their
     approach and possibly reuse `physlib` infrastructure once merged.
   - **github.com/lean-dojo/LeanMillenniumPrizeProblems**: formalizes the
     Clay problems' STATEMENTS only (no solutions, explicitly), including
     `MillenniumYangMills.YangMillsExistenceAndMassGap` as a "Lean-level
     proxy" using BOUNDED operator spectra (not the true unbounded
     spectral theory the real problem needs) - worth citing/comparing
     against whenever this program's own YM8 (the prize-statement rung)
     is ever drafted, and itself a useful data point that even STATING
     the problem faithfully in Lean is nontrivial.
   - Verdict so far: no prior formalization of lattice gauge theory,
     Wilson-action gauge invariance, or reflection positivity for an
     interacting gauge theory was found. The "first ever" claim for
     THAT specific scope still stands as far as tonight's search
     reached, but it must be phrased narrowly (lattice GAUGE theory RP,
     not RP/OS-axioms in general) given the Douglas et al. precedent.
     Not yet checked: AFP (Isabelle) index directly, Coq/Rocq
     MathComp/UniMath ecosystems directly, Zulip archive search. Still
     open for a future T6 pass.
9. **2D YM rigorous constructions** (Driver, Sengupta, Levy; Migdal 1975
   heuristic). Verify: which continuum 2D results exist rigorously, for
   YM2 positioning. Low urgency tonight (YM2 is not in scope) but cheap
   to resolve while in the literature. **[03:40 VERIFIED]** The first
   complete rigorous constructions of the continuum 2D Yang-Mills path
   integral are due to Gross-King-Sengupta and (independently) Driver,
   via stochastic analysis / gauge-fixing to a Gaussian measure on the
   plane; the "Driver-Sengupta formula" (Sengupta, Levy) is the key
   object; Levy proved the Makeenko-Migdal-type equations for Wilson
   loops and later master-field results; Driver-Hall-Kemp gave shorter,
   local proofs extending to all compact surfaces. Matches the freeze's
   citation pattern exactly.
10. **Modern probabilistic school** (Chatterjee surveys; Cao-Chatterjee
    master-loop equations; related recent work through 2025-2026 - the
    training-data horizon means RECENT work is exactly what the graph
    and web must supply). Verify: current state of the art on
    strong-coupling Wilson loops and any YM6-relevant partial progress.
    Affects: program doc s11 corrections and the strategy partner job's
    context. **[VERIFIED, planning session]** arXiv:1803.01950
    (Chatterjee, "Yang-Mills for probabilists"), 2204.12737 (stochastic
    analysis approach to strong coupling), 2309.07399 (finite-N master
    loop equation) all confirmed genuine and on-topic.
11. **Balaban UV-stability series** (mid/late 1980s). Verify: paper
    list, scope (finite volume, per-scale bounds, NOT a full
    construction), and the community's current assessment of
    Magnen-Rivasseau-Seneor 1993. Affects: YM5 audit planning only; do
    not formalize anything from it tonight. **[03:40 VERIFIED]** Paper
    list confirmed: Balaban, Commun. Math. Phys. 85 (1982) 603, 86
    (1982) 555, 88 (1983) 411, 89 (1983) 571, 95 (1984) 17, 96 (1984)
    223, 102 (1985) 255, 109 (1987) 249, 116 (1988) 1 - spanning Higgs
    finite-volume fields, lattice Green's function regularity,
    propagators/renormalization transformations, UV stability (3D pure
    gauge), and the RG approach to lattice gauge theories. Community
    assessment CONFIRMED matching the freeze's characterization: a
    secondary source notes the results were "scattered over many
    publications, making consistency checks difficult" due to lattice-
    regularization technical complications - exactly "not a full
    construction," corroborating the freeze's framing. Magnen-Rivasseau-
    Seneor confirmed: "Construction of YM4 with an infrared cutoff",
    Commun. Math. Phys. 155 (1993) 325-383 - SU(2), FIXED infrared
    cutoff, NO ultraviolet cutoff, regularized axial gauge; matches the
    freeze's "finite volume, per-scale bounds, NOT a full construction"
    characterization precisely.

## Standing rules

- Prior-art check before EVERY new theorem statement drafted tonight
  (one `--query` pass minimum; log only if it changed something).
- `--chunks` full-text search whenever a claim depends on a paper's
  internals; never trust the abstract for a hypothesis.
- Ingest anything load-bearing via `Scripts/lit/lit_ingest.py` with the
  pre-add existence check (arxiv_id/doi, not title); collection scoping
  needs the IN_COLLECTION edge to `9W59V3K9`.
- Corrections to the freeze or program doc discovered here go through a
  `corrections:` thread (claim-language edits need cross-review).

## Log (append only)

Format per entry:

```text
### [HH:MM] <agent> - <target item or ad-hoc search>
Searches run: ...
Verdict: ...
Ingested: <paper_key(s) or none>
Affects: <claim / statement / decision>
```

### [planning session, pre-run] claude - graph state + seed identifiers
Searches run: neo4j_paper_search --query on RP/Osterwalder-Seiler,
strong-coupling mass gap, cluster expansion/KP (all < 0.76, off-topic);
web search for Chatterjee survey and prior formalizations.
Verdict: the graph contains NO YM-ladder literature - all T6 items are
discovery + ingest. Neo4j was down and was restarted headlessly (see
PREP_NOTES.md section 4; re-verify at T0). Verified IDs to ingest:
arXiv:1803.01950 (Chatterjee survey), 2204.12737, 2309.07399; Nature
Rev. Phys. 2025 s42254-025-00909-2 (community assessment, verify
content). Pre-arXiv classics still unverified-from-memory.
Novelty check (item 8) preliminary: arXiv:2606.07922 + repo
github.com/jonwashburn/shape-of-logic is the closest adjacent art
(Lean + RP language, but RP is text-proof there, and not LGT) - scope
the flagship claim against it BEFORE any "first" sentence ships.
Also observed: 1709.04891 duplicated in graph (5J5XDKMN + malformed
key `zotero:SZJE69PE`) - dup-key pathology, log-only for tonight.
Ingested: none (left to T6 with the pre-add existence check).
Affects: T6 workload estimate; item 8 scoping; flagship claim language.

### [01:50] claude - Aristotle ladder-strategy report attributions (project ac230cc8)
Searches run: none yet (attributions below are the AUDITOR's citations,
themselves cited FROM MEMORY by that model - still need T6 verification,
not upgraded to [M] grade by merely being repeated here).
Verdict: the strategy report names precise attributions worth adding to
the standing register alongside items 1-2 (Osterwalder-Seiler, Elitzur):
Osterwalder-Seiler, "Gauge field theories on a lattice", Ann. Phys. 110
(1978) 440 (lattice gauge RP itself); Luscher, "Construction of a
self-adjoint, strictly positive transfer matrix for Euclidean lattice
gauge theories", Commun. Math. Phys. 54 (1977) 283 (the H = -log T
reconstruction and strict positivity - EXPLICITLY NOT
Osterwalder-Schrader, a common misattribution risk per the report's
section 5.5); Osterwalder-Schrader, Commun. Math. Phys. 31 (1973) / 42
(1975) (continuum RP postulates only, the template, not the lattice
result); 't Hooft, Nucl. Phys. B153 (1979) 141 (flux/twist definitions
for the D12 sector qualifier); Kogut, Rev. Mod. Phys. 51 (1979) 659 and
Fradkin-Shenker, Phys. Rev. D 19 (1979) 3682 (finite-G lattice gauge
theory is a real studied subject, relevant to the "finite-G honestly
separable as a publication" question in section 2). Also flagged:
arXiv:2606.07922 (independently found by the planning session too) is
noted by the auditor as "future-dated (June 2026) and I cannot verify
it" - corroborates treating it as UNVERIFIED, not citable art, until
someone actually confirms the identifier resolves.
Ingested: none yet.
Affects: T6 priority list (add Luscher 1977 and the
Osterwalder-Schrader-vs-Luscher misattribution risk as a NEW
load-bearing item); flagship claim-language attribution correctness.

### [02:25] claude - MAJOR FLAG: arXiv:2606.19362 claims to solve the Clay problem
Searches run: web search for KP criterion incidentally surfaced
arXiv:2606.19362, "Reflection-Positive Construction of a Four-Dimensional
SU(N) Yang-Mills Theory with Mass Gap and Confinement" (Mir Faizal,
Arshid Shabir; submitted 2026-06-09; journal-ref Fortschr. Phys. 74
(2026) 4, e70097; hep-lat/hep-th). Fetched the full abstract directly.
Followed up with a web search on the first author's publication record.
Verdict (READ CAREFULLY, this is the single most important item in
tonight's lit sprint): the abstract's own words claim essentially the
FULL Millennium Prize content - reflection-positive lattice
construction, transfer operator with uniform gap, convergent
character/polymer expansions giving the area law, a finite-range
multiscale/RG argument carrying the gap and clustering to the
CONTINUUM, Osterwalder-Schrader reconstruction to a Minkowski theory
with self-adjoint Hamiltonian and spectral gap, AND a claimed
strong-weak-coupling universality argument (exactly this program's YM6,
the rung registered everywhere as "the actual open problem, no route
known"). If this claim is correct and accepted, it would mean the
summit of Track A already exists in the literature.
STRONG REASONS FOR SKEPTICISM, not dismissal but real caution: (i) the
venue is Fortschritte der Physik, not a venue where Millennium-Prize-
grade results are normally first vetted (Annals of Math, Acta Math,
CMP, Invent. Math.); (ii) the abstract's prose is informal/essayistic
("in my view this is how mathematical clarity and physical insight
cooperate..."), atypical for a landmark result of this magnitude;
(iii) first author Mir Faizal has an extremely prolific record (339
works, ~5600 citations per Google Scholar, averaging ~17 cites/paper),
adjunct (not core faculty) position, and I found no evidence of the
extraordinary community reaction (Clay Institute statement, Peter
Woit/Tao-blog-level discussion, mainstream science press) that a
genuine solution to a Millennium Prize problem would immediately
generate; (iv) the CMI's own process requires a 2-year community
acceptance waiting period post-publication before award consideration -
this paper (June 2026) cannot possibly have cleared that regardless of
correctness. NONE of this proves the paper is wrong - it may contain
real partial results even if the headline claim does not hold up, and
it must not be dismissed unread. But it should NOT be treated as
"solved" by this program, must not be cited as blocking prior art
without the paper being read in full and its actual proof scrutinized,
and its existence changes NOTHING about tonight's kernel-checked
deliverables (find a bug or not, this program's value is the
machine-checked route, not a race to the informal claim first).
Ingested: NOT YET - deliberately holding off on Zotero/Neo4j ingestion
until a human (the user) has seen this flag and decided how the program
should treat it; ingesting it silently as "just another paper" would
bury the most consequential lit finding of the night.
Affects: EVERYTHING - the whole ladder's strategic framing, the "no
route known for YM6" claims throughout the freeze document and program
plan, and item 8's novelty check. Recommend the user personally reviews
this paper before the program's YM6/summit language is touched again.
