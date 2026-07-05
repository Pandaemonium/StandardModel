# Whole-project grand-strategy audit (2026-07-05)

Claim label: strategic audit / interpretation. This is a big-picture, adversarial
review of the whole repository, written after browsing the actual Lean source and
the program docs, not the prompt summary. Escape-hatch tokens are spaced
(`s o r r y`, `a x i o m`, `n a t i v e _ d e c i d e`) per repo hygiene.

Method: directory census, `s o r r y` / `a x i o m` / `n a t i v e _ d e c i d e`
census by subtree, read of AGENTS.md, README, the octonion/null-edge thesis and
its red-team, the four-day YM RUN_PLAN and LEDGER, the GateYM aggregator, the
KP-conclusion handoffs, and spot reads of the Algebra/Furey, Gauge, Lie, Spinor,
Coding, and NullStrand trees. Where README/AGENTS prose and the Lean disagree, I
trust the Lean and say so.

---

## 0. Ground-truth census (what is actually in the delivered tree)

- ~960 Lean files. Trusted-layer subtrees (Algebra, Clifford, Coding, Gauge,
  Lie, Spinor, StandardModel, Supersymmetry, Publication, NullStrand) contain
  ZERO real `s o r r y` in tactic/term position. Every real `s o r r y` (13
  sites) is under `Draft/`: E8ThetaSeriesMoonshot (2), Spin10Stabilizer{Iso,
  Selector,Transitivity} (3), ExceptionalJordanProjectiveGeometry (3),
  E8EvenUnimodularUniqueness (1), E8ThetaSPLBridgeAristotle (1),
  GateYM/PolymerKPConclusion (3). The draft-vs-trusted `s o r r y` discipline is
  genuinely being honored. Good.
- There are NO real `a x i o m` declarations anywhere. Every grep hit for
  "axiom" is docstring prose ("axiom footprint [propext, Classical.choice,
  Quot.sound]"). The axiom-audit culture is real and pervasive.
- `n a t i v e _ d e c i d e`: 5 files in Algebra, 20 of 31 files in Coding, 1 in
  Lie, 2 in NullStrand. This is the single most important trust nuance; see 4.1.

### 0.1 Two coherence gaps between the prose and the delivered repo (flag first)

1. The prompt's suggested reading list and AGENTS.md both point at `docs/`
   (`docs/NULLSTRAND.md`, `docs/NERD_ROADMAP.md`, `docs/CONVENTIONS.md`,
   `docs/BUILD.md`, `docs/ARISTOTLE.md`). There is NO `docs/` directory in the
   delivered tree. The live orientation actually lives in `Sources/*.md` and
   `PhysicsSM/Docs/{Glossary,Roadmap}.lean`. Either the delivery was pruned or
   the pointers are stale; a reviewer following AGENTS.md hits dead links.
2. README describes `CodeLatticeE8` as "the polished publication artifact" and
   references `CodeLatticeE8.lean`, `CodeLatticeE8/Publication/TheoremIndex.lean`,
   and a `CodeLatticeE8Standalone/` package. None of those roots exist in the
   delivered tree; `lakefile.toml` still declares `lean_lib CodeLatticeE8`,
   `CodeLatticeE8SPL`, `CodeLatticeE8Draft` with no root files present. The E8 /
   Hamming work that README credits to that package actually lives under
   `PhysicsSM/Coding/`. So the flagship "publication artifact" is, in this tree,
   an un-buildable set of library declarations plus its `Sources/` docs.

Neither is a math error, but both mean the repo's own top-level advertising does
not match the delivered contents. Fix before any external reviewer sees it.

---

## 1. CORE THESIS: is there one research vision?

No -- there are two genuinely different bets sharing a repo and a discipline, plus
a large amount of scaffolding around each. Honestly stated:

- BET A (division algebras -> Standard Model structure). "The complex octonions,
  via the associative left-multiplication algebra on the minimal ideal, produce
  Cl(6), SU(3) color, and one anomaly-free generation of charges, kernel-checked
  with derived (not assigned) charges." This is a real, established research
  program (Dixon/Furey/Baez) being carefully formalized. It is the most
  defensible thing in the repo.

- BET B (null-edge geometry -> mass, and a lattice YM/QCD mass ladder). "Mass is
  a relational obstruction to primitively-null transport (turn/closure/aperture),
  and a rung-by-rung finite lattice-gauge stack can pin reflection positivity,
  transfer operators, and sector spectral gaps as honest finite theorems, with
  the continuum (Clay) limit permanently off-ladder." The engineering here (Gate
  YM, QMF) is serious and disciplined; the physical unification story is a
  research thesis, explicitly labeled as such.

- THE UNIFICATION between A and B is the aspirational third bet, and the project
  has ALREADY red-teamed it into honesty: `AgentTasks/octonion-nulledge-
  unification-thesis.md` records the finding that the current bridges are
  "co-location, not coupling" -- the SM factor and the mass factor commute on the
  tensor product (`internal_spacetime_commute` is tensor bifunctoriality, i.e.
  vacuous as a coupling claim), and "generations from omega<->omega*" is refuted
  as numerology (Z2 involution has multiplicity 2, families need 3).

Where is the line between program and numerology? The project draws it in exactly
the right place and mostly stays on the right side: a claim counts only when it is
a kernel-checked Lean statement with documented conventions and a claim label
(finite identity / asymptotic theorem / reconstruction / consistency check /
conjecture). The numerology risk is real and lives specifically in the
INTERPRETIVE glue (B2 chirality<->conjugate-ideal, "SU(3) closure IS octonion
SU(3)", "16 of Spin(10) = one generation as the summit"). The repo's own red-team
is its best defense here and should keep veto power.

Verdict: this is a legitimate research program with unusually strong soundness
hygiene, NOT a numerology project -- but it is TWO programs, and the marketing
("one spinor, two structures") currently outruns the Lean, which proves
independence (co-location), not coupling.

---

## 2. PROGRAM-BY-PROGRAM TRIAGE

### 2.1 Division algebras -> SM structure (Algebra/, Furey/, StandardModel/): PROMISING, strongest lane

- SOLID pieces: the XOR-basis octonion algebra and Cayley-Dickson bridge
  (`Algebra/Octonion`, `Algebra/Division/CayleyDicksonOctonionBridge`); the full
  Cl(6) CAR relations for the complex-octonion ladder operators
  (`Furey/LadderOperators`: nilpotency, `{alpha_i, alpha_j^dag}=delta_ij`, both
  vanishing brackets) -- this is a real, non-trivial, sorry-free result;
  `su3Submonoid` = {M | M^dag M = 1, det M = 1} with the unitary-iff bridge
  (Furey/one-generation packages).
- OVERCLAIM to watch: "anomaly-free generation FROM octonions." Per the thesis's
  own correction, anomaly cancellation is a fact about a HARDCODED numeric SM
  table; the right-handed sector (`J*`) has charges set by fiat to `-qJ`;
  `AnomalyFromQop` ties only the U(1) linear and cubic sums to `Q_op`
  eigenvalues, not the SU(2)^2 / gravitational anomalies and not the RH sector.
  The honest claim is "U(1) anomaly sums are sums of derived Q_op eigenvalues,"
  not "the octonions prove an anomaly-free generation."
- The `1a` gap (`MulEquiv su3Submonoid (specialUnitaryGroup (Fin 3) C)`) and
  `1b` (fundamental rep = color-triplet ACTION, not just matching multiplet DATA)
  are the two nearest real theorems and are correctly identified in the thesis.

### 2.2 E8 / exceptional Lie + Code-Lattice E8 (Lie/, Coding/): SOLID engine, native-trust caveat

- The Hamming [8,4,4] -> Construction A -> E8 route is largely built and
  sorry-free (`Coding/HammingE8`, `E8RootBridge`, `E8ShortVectors`,
  `E8ThetaSeries*`). Root system data, Cartan, Weyl closure, 240 short vectors,
  theta coefficients.
- CAVEAT (see 4.1): the top-line finite facts (`shortHammingE8Vector_count_eq_240`,
  completeness, theta coefficients) are proved by `n a t i v e _ d e c i d e`.
  That is draft-trust (adds `Lean.ofReduceBool` + `Lean.trustCompiler`), not
  kernel-trust, and these files are imported by the DEFAULT `PhysicsSM` library.
  README calls this "the polished publication artifact" that "proves ... the
  short-vector count 240." By the repo's OWN promotion rule that is not yet a
  trusted result. Classify SOLID-but-native-trust; promotion = replace with
  kernel-checked enumeration (NoNative pattern) before publication.
- Drafts `E8EvenUnimodularUniqueness`, `E8ThetaSeriesMoonshot`,
  `E8ThetaSPLBridgeAristotle` carry `s o r r y` and are correctly draft.

### 2.3 Spinors / Clifford (Spinor/, Clifford/): PROMISING

- Cl(6)/CAR, pure spinors, Krasnov Spin(10) two-pure-spinor track,
  `PluckerMass`/`PluckerObstruction`, tenfold Fock/Fierz. Trusted subtree is
  sorry-free. The Spin(10) stabilizer / Selector-Theorem program lives in
  `Draft/Spin10Stabilizer*` and is SPECULATIVE (3 `s o r r y`s, isomorphism +
  transitivity + selector all open).

### 2.4 NullStrand / null-edge core (NullStrand/): PROMISING, but ORPHANED from roots

- Sorry-free and axiom-clean; includes a `NullStrand/Audit` capstone that is
  DESIGNED to fail the build if the transitive axiom set of the audited capstone
  changes -- an excellent regression guard, the best trust idea in the repo.
- Structural note: NullStrand is imported by NONE of the top-level roots
  (`PhysicsSM.lean`, `PhysicsSMDraft.lean`, `PhysicsSMSPL.lean` have zero
  `import PhysicsSM.NullStrand`). It builds only via its own aggregators. It is
  effectively an orphan library relative to the advertised targets; easy to
  forget in a `lake build` of defaults. Wire it into a named target.

### 2.5 Yang-Mills mass-gap ladder (Draft/NullEdge/GateYM, 66 files): PROMISING, best-engineered draft

- Genuinely impressive finite/Z2 stack: Elitzur bound, torus even-cover, fusion
  convolution, reflection-positivity kernel, doubled-lattice weight =
  PlaquetteEnsemble weight identity, transfer positivity/Hilbert/gap definition,
  flux/center-flux sectors, KP criterion, Banks-Casher shadow, Berezin-Matthews-
  Salam, Wilson-Dirac operator, chiral mass structure. Almost all `[Group G]`- or
  Z2-generic and axiom-footprint-clean.
- The remaining `s o r r y`s are exactly the ANALYTICALLY HARD parts and are
  honestly marked: `PolymerKPConclusion` pairSum/tree-sum convergence bounds
  (the actual Kotecky-Preiss estimate). This is the correct place for the wall.
- Discipline F-YM-CONFLATE (never conflate spectral gap vs Wilson area law vs
  entanglement area law) is treated as constitution-grade and is respected in the
  file headers. Continuum/Clay is explicitly OFF-ladder.

### 2.6 QMF (QCD mass formalism) ladder (Draft/NullEdge/QMF, 3 files + plan): SPECULATIVE-by-design (statement layer)

- QMF1-QMF8 is a staged plan; only early rungs / statement freezes exist. The
  crown QMF7 (hadron mass = sector-restricted spectral gap of a positive transfer
  operator) is a STATEMENT-layer target this run, not a proof. Correctly scoped;
  continuum (QMF8) permanently on the kill list. Watch for claim-language drift
  toward "continuum masses" -- the plan itself flags this as a violation.

### 2.7 Octonion/null-edge unification thesis: AT-RISK as a COUPLING claim, SOLID as a co-location statement

- Already triaged by the repo's own red-team to "co-location, not coupling."
  Kernel-verified positive content: color-blind mass (`GateI1/ColorBlindMass*`),
  i.e. the octonion factor can supply at most an SU(3)-invariant overall scale,
  never a color/charge distinction in the mass -- which is the physically correct
  NEGATIVE outcome. The decisive open test (`charge_grading_mass_compatible` /
  colored mass on `J (x) CSpinor` that does NOT factor through spacetime) is the
  one theorem that would upgrade the thesis from independence to coupling. Until
  it is proved non-factoring, the unification is a shared-shape interpretation,
  not a theorem.

### 2.8 Standard Model gauge group (Gauge/, ~45 files): SOLID but OVER-FRAGMENTED

- The G_SM = (SU(3) x SU(2) x U(1))/Z6 structure, covering maps, Z6 kernel, and
  quotient equivalences are built and sorry-free. But this subtree has ~20 files
  named `StandardModel{Z6Kernel,Z6KernelEquiv,Z6KernelMap,Z6QuotientMonoid,
  Z6QuotientMonoidEquiv,Z6QuotientMonoidLaws,...}` -- extreme fragmentation into
  near-duplicate narrow lemmas. This is the clearest instance of the "many
  narrow near-duplicates instead of a few general results" anti-pattern AGENTS.md
  warns against. Consolidation debt, not a soundness problem.

---

## 3. HIGHEST-VALUE DIRECTIONS (ranked top 5)

1. De-native the E8 publication core. Next theorem: a KERNEL-checked (no
   `n a t i v e _ d e c i d e`) proof of `shortHammingE8Vector_count_eq_240` and
   `shortHammingE8VectorList_complete` (NoNative module), plus the theta
   coefficients. Why: it is the ONLY near-publication artifact, it is advertised
   as kernel-proved but is native-trust, and the gap is pure engineering
   (bounded finite enumeration) with no missing mathematics. Highest ratio of
   credibility gained to risk. Also fix the README/lakefile packaging so the
   artifact actually builds as described.

2. Close the two lane-A "identity" theorems. Next theorem:
   `su3_octonion_mulEquiv_specialUnitaryGroup : MulEquiv su3Submonoid
   (Matrix.specialUnitaryGroup (Fin 3) C)` (label: finite identity), then
   `1b` fundamental-rep-as-color-triplet ACTION. Why: turns "SU(3) from
   octonion automorphisms" from a carrier-set match into a group-level theorem
   connecting to Mathlib's SU(3) and the Gauge tree; it is the backbone of BET A
   and is genuinely tractable.

3. Push the KP wall in the YM ladder. Next theorem: `pairSum_le_expBound`
   (PolymerKPConclusion:938), the finite per-cluster tree-sum bound that gates
   `kp_convergence_bound_of_selfIncompatible` and thence exponential clustering.
   Why: it is the true analytic bottleneck of the entire mass-gap track; every
   downstream clustering/gap statement is doorstep-ready behind it. Aristotle-
   heavy; decompose the tree-graph inequality first.

4. Instantiate RP-LINK (Q1) end to end. Next theorem: the Wilson weight on a
   link-reflection lattice satisfies `ReflectionPositivityKernel` unconditionally
   (strip any residual matrix-model hypothesis in `WilsonVacuumDominance`),
   feeding `TransferGapDefinition.finiteMassGap`. Why: "first formalized RP for an
   interacting lattice gauge ensemble" is a defensible, citable milestone that is
   nearly assembled.

5. Settle the unification with the decisive negative (or positive) theorem. Next
   theorem: `charge_grading_mass_compatible` on `ComplexOctonion (x) CSpinor` --
   prove the shared mass form is (or is not) factoring through the spacetime
   projection. Why: it converts the entire A/B unification narrative from prose
   into a kernel verdict. Expected outcome (per the color-blind analysis) is the
   co-location branch; a kernel-verified negative is a real, publishable
   clarification, and a surprise positive would be the project's biggest result.

---

## 4. RISKS AND NO-GO ANALYSIS

### 4.1 The native-decide trust boundary is the top soundness-hygiene risk

The default trusted `PhysicsSM` library imports `Coding` (28 modules), and 20 of
31 Coding files use `n a t i v e _ d e c i d e`, including the top-line E8 facts.
`#print axioms` on those adds `Lean.ofReduceBool` and `Lean.trustCompiler`. By
AGENTS.md's own rule this is draft-trust, not kernel-trust, and must be replaced
before "trusted"/"publication." The embarrassment scenario is presenting "240
short vectors, kernel-proved" externally when the axiom audit shows compiler
trust. Action: either (a) promote via NoNative kernel enumeration, or (b) re-label
every native result as draft-trust in README and the theorem index. Do not leave
the current "publication artifact" language on a native-trust base.

### 4.2 Convention-fragile / category-error risks (mostly already caught)

- Octonion associativity: the XOR-basis convention and ConventionBridge
  discipline is strong; the standing risk is any future formula copied from
  Baez/Furey without going through the bridge (silent sign corruption). Keep the
  validator in CI.
- Group vs Lie algebra vs representation: the SM Gauge tree is at group level;
  the Furey side mixes operator-algebra (Cl(6)) and multiplet DATA. The `1b` gap
  (rep DATA vs rep ACTION) is exactly this confusion and is correctly flagged.
- "generations from omega<->omega*" (B2): refuted as numerology (2 != 3). Keep it
  demoted to at most a covariance-under-reality-condition statement; do not let it
  re-enter as an equality.
- "16 of Spin(10) = one generation" as a summit: fine as motivation, but the
  Spin10 selector/stabilizer track is 3 open `s o r r y`s; do not cite it as
  achieved.

### 4.3 The three summits, honestly

- Clay Yang-Mills mass gap: MIRAGE as a target, correctly treated as a
  NON-claimed off-ladder summit. Nearest defensible claim: "reflection positivity
  and a positive self-adjoint transfer operator with a finite spectral gap for an
  interacting lattice gauge ensemble at fixed coupling and volume." Do not let
  QMF7 language drift toward continuum masses.
- "SM from octonions": GENUINE long-horizon program, partially real. Nearest
  defensible claim today: "Cl(6) CAR relations and SU(3) color arise from the
  complex-octonion left-multiplication algebra, with one generation's U(1)
  charges derived from Q_op eigenvalues." Not "the octonions prove an anomaly-free
  Standard Model generation."
- "all mass from null edges": MOSTLY MIRAGE as a universal claim; SOLID as a
  shared-mechanism SHAPE with per-row theorems. Nearest defensible claim: the
  aperture keystone `det P = m^2` (two-body) plus color-blindness of the octonion
  mass contribution. The universal "no primitive mass" thesis needs the
  non-factoring theorem (4/5 above) to have any coupling content.

---

## 5. BLIND SPOTS

1. The two programs are being marketed as one before the Lean supports it. The
   repo has PROVEN independence (co-location) and is presenting it as incipient
   unification. The honest headline result right now is a negative/clarifying one
   (mass is color-blind; internal and spacetime factors commute). That is
   valuable -- publish it AS a clarification, do not dress it as coupling.
2. The native-decide boundary crossing into the default trusted target (4.1) is
   under-emphasized given how central the E8 artifact is to the repo's public
   face.
3. Redundant effort and fragmentation: the Gauge Z6 quotient subtree (2.8) and
   the sheer file count (543 Draft files, 66 GateYM files) suggest the project
   optimizes for many small named lemmas at the cost of navigability. A few
   general theorems + a curated theorem index would beat dozens of `...Equiv`,
   `...Map`, `...Package` variants.
4. Packaging/advertising drift: README and AGENTS point at a `docs/` tree and a
   `CodeLatticeE8` package that are not in the delivered repo (0.1). A new agent
   or reviewer wastes time on dead links.
5. NullStrand is an orphan relative to the roots (2.4); its excellent axiom-audit
   capstone idea is not applied to the E8/native-decide artifact, which is
   exactly where an axiom-footprint regression guard would catch the trust issue
   automatically.
6. Available tooling not fully exploited: the CapstoneAxioms guard pattern should
   be templated and attached to EVERY flagship theorem (E8-240, RP-LINK, Furey
   one-generation), turning "we checked the axioms once" into a build-enforced
   invariant.

---

## 6. CONCRETE RECOMMENDATIONS

Do next (in order):
1. Fix the advertising/packaging truth: reconcile README + lakefile with the
   delivered tree (either restore the `CodeLatticeE8` roots / `docs/` or rewrite
   README to describe `PhysicsSM/Coding` as the E8 home and drop dead links).
2. De-native the E8 core (3.1) OR re-label it draft-trust everywhere. This is the
   single highest-credibility action.
3. Attach a CapstoneAxioms-style axiom-footprint guard to E8-240, the Furey
   one-generation package, and the top GateYM RP theorem.
4. Close lane-A `1a` MulEquiv and `1b` action theorem (3.2).
5. Wire NullStrand into a named build target so it is not orphaned.

Stop doing:
- Adding new near-duplicate Z6 quotient / `...Equiv` / `...Package` files in
  Gauge; consolidate instead.
- Extending the unification NARRATIVE in docs ahead of the non-factoring theorem.
  Let the Lean lead the prose, not the reverse.
- Treating `n a t i v e _ d e c i d e` results as publication-grade.

Restructure:
- Curate ONE compile-checked theorem index (like the FureyBaez and TheoremIndex
  attempts) listing, for each flagship theorem, its statement, claim label, and
  axiom footprint. Make it the single public face; retire the ad-hoc Sources
  claim tables.

Suggested 3-6 month arc (two agents + Aristotle):
- Month 1 (credibility): packaging fix + de-native E8-240 and completeness +
  axiom guards on all flagships. Checkpoint: `lake build` of a named
  publication target is kernel-trust (audit shows only propext/Choice/Quot.sound).
- Month 2 (lane A backbone): `1a` MulEquiv + `1b` action theorem + honest
  restatement of the anomaly claim. Checkpoint: octonion SU(3) connected to
  Mathlib SU(3) at group level, kernel-checked.
- Month 3-4 (YM analytic wall): prove `pairSum_le_expBound` and
  `kp_convergence_bound_of_selfIncompatible`, then exponential clustering of local
  loop observables. Checkpoint: a sorry-free finite clustering theorem in GateYM.
- Month 4-5 (RP-LINK milestone + QMF statement layer): unconditional RP-LINK
  (Q1) feeding `finiteMassGap`; QMF7 STATEMENT file with the mass taxonomy as
  named defs. Checkpoint: a citable "RP for an interacting lattice gauge
  ensemble" writeup.
- Month 5-6 (the verdict): prove `charge_grading_mass_compatible` (expect the
  co-location branch) and write the clarifying paper "mass is SU(3)-color-blind
  in the octonion/null-edge factorization." Checkpoint: the unification question
  answered by the kernel, either way.

---

## 7. DECISIVE QUESTIONS for the lead

1. Trust standard for "publication": is `n a t i v e _ d e c i d e` acceptable in
   the flagship E8 artifact, or must every published theorem be kernel-trust
   (propext/Choice/Quot.sound only)? Everything in month 1 hinges on this.
2. Is the near-term deliverable the E8/Hamming paper (mature, one trust fix away)
   or the YM RP-LINK milestone (higher prestige, more analytic risk)? Pick the
   flagship; do not split scarce Aristotle budget across both.
3. Do you accept that the honest current unification result is NEGATIVE
   (co-location / color-blind mass), and are you willing to publish it as a
   clarification rather than waiting for a coupling that may not exist?
4. Is the continuum limit (Clay YM, QMF8) truly permanently off-scope, and will
   you enforce F-YM-CONFLATE and no-continuum-drift as veto conditions on QMF7
   language?
5. Consolidation vs volume: will you pay down the Gauge-Z6 / Draft fragmentation
   debt and commit to a single curated theorem index, or keep optimizing for
   file count? This decides whether the repo stays navigable at ~1000 files.

---

Bottom line: the project is sound where it counts (real draft/trusted separation,
no stray `a x i o m`, an axiom-audit culture, and a self-red-teaming habit that
already demoted its own overclaims). Its biggest risks are not false math but
(a) a native-decide trust boundary sitting under its most advertised artifact,
(b) README/packaging that describes a repo that is not the one delivered, and
(c) a unification narrative running ahead of a Lean that so far proves the
opposite (independence). Fix the trust label and the packaging, prove the two
lane-A identities and the KP bound, and let the `charge_grading_mass_compatible`
theorem deliver the unification verdict instead of the prose.
