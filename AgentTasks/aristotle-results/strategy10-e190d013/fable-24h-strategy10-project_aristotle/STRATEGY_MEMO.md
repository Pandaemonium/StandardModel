# STRATEGY MEMO — pre-freeze pass, 03:50 PDT (freeze 08:00, audit 08:00–09:45)

Review-only. Scope: the three null-edge manuscripts and `context/HONEST_SCORECARD.md`.

Paper ↔ file map used throughout:

- **Paper A** = `context/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`
  ("Null-Spinor Area as the Rest Gap …"): rest operator, cube closure, selection,
  8-node charge census, crossing/flow content.
- **Paper C** = `context/Null_Edge_HalfWinding_Defect_Paper_Draft_2026-07-11.tex`
  ("Winding Is Not Enough …"): positional defect law + multiplicity census.
- **Paper E** = `context/Null_Edge_Finite_CAR_Dynamics_Draft_2026-07-12.tex`
  ("Exact Pair-Gate Dynamics …"): generator, cones, interacting spectrum.

Tonight's kernel-checked landings (from the brief), keyed to scorecard IDs:

- A: generalized rest cube (A-RESTGEN family, `B_w^3=\mu^2 B_w` all `n`); selection
  uniqueness RESOLVED + constraint set FORCED, covariance group = chiral phase circle
  (A-SELECT); CAR-to-block reduction; 8-node charge census DERIVED from the walk symbol
  (A-CHGBAL); 1D flow-count theorem from eigenphase geometry (P-1DFLOW).
- C: multiplicity census retrofitted **kernel-clean**, `native_decide` removed (C-CENSUS).
- E: exact spectrum fixture — charpoly = explicit degree-28 product, cubic reduction,
  pinned modes; charpoly identification **closed** (E-SPEC).

---

## Q1 — Single highest-value remaining move per paper (≈4h to freeze)

**Paper A — Harvest the three landings into prose + ledger and delete the now-false hedges.**
The math already landed and is guard-pinned; the risk is now *documentary*, and it is the
kind an auditor's Trap-1 cross-diff (indicative sentence ↔ kernel row) catches immediately —
except inverted: Paper A currently *understates*. Three sentences assert the opposite of what
is now kernel:
- §charge census: "…is the exact run-record layer, computed but **not yet formalized**"
  (now derived from the symbol);
- §open-problems selection: "the reduction from the CAR quartic class to that block is
  definitional packaging, **not a theorem**" (now a landed reduction);
- §cube-coincidence: "that question remains exactly **the pre-registered selection
  conjecture** in the open problems" (that conjecture is resolved elsewhere in the same paper).
Fold A-CHGBAL / A-SELECT / CAR-to-block / P-1DFLOW into the body and the Appendix module
ledger + `OvernightTheoryAxiomGuard` pin list. Low risk, high value, and it removes a
self-inflicted audit finding. (See Q2/Q4 for exact strings.)

**Paper C — Re-grade `CensusMultiplicity` from Kernel+Eval to Kernel-clean, everywhere, and
only there.** The 16-field 2/4/0 multiplicity census is now the paper's one fully-general,
fully-kernel result; removing its "compiled-evaluator certificate products" caveat is the
cheapest genuine grade bump available before freeze. Critical constraint: do **not** blanket
the whole paper — `HalfPeriodInvariant.selfadj_iff_protected` (C-POS) and the other four-site
rational fixtures remain kernel+eval. This is a surgical relabel, not a global one.

**Paper E — Land/harvest the §4 flagship into the paper.** Replace the abstract's "pending
flagship" language and the §4 "[oracle-exact; formalization in flight … nothing in this
section is claimed as kernel]" block with the kernel statement of `PairSpectrumFixture.*`
(degree-28 factorization, cubic reduction `3125w^3-2300w^2-6156w-1440=0`, pinned modes), and
fill the Appendix "[PENDING: module/guard table on freeze.]". This is the one move that
flips a whole paper's status rather than tightening an already-strong one.

**Closest to a genuine impact jump: Paper E.** Its headline — an *exact, kernel-checked
interacting two-particle spectrum* on the four-site ring — was the paper's single PENDING
flagship (E-SPEC, `PENDING-harvest 4d9642bf`) and it just closed. Harvesting it converts
Paper E from "skeleton at freeze pace" with an oracle-tagged §4 into a complete paper whose
central claim is machine-verified. Paper A's landings are strong but incremental additions to
an already-near-ready flagship; Paper C's is a trust-grade tightening. Only E's status
actually leaps.

---

## Q2 — Sentences that now UNDERSTATE, with one-line upgrades

### Paper A
1. Abstract: *"the symbol-to-Jacobian reduction an exact run record, its central-node instance
   in kernel formalization"* →
   **"the full symbol-to-Jacobian reduction and 8-node census are kernel-derived from the
   walk symbol (`SplitStepChargeBalance.*`), not only the central node."**
2. Body (charge census): *"…is the exact run-record layer, computed but not yet formalized.
   The doublers of this walk are not merely present: at run-record grade they are exactly the
   charge partners the sum rule demands"* →
   **"…is now kernel-checked: the doublers are exactly the charge partners the sum rule
   demands, as a kernel theorem, not a run-record."**
3. Open-problems (selection): *"the reduction from the CAR quartic class to that block is
   definitional packaging, not a theorem"* →
   **"the CAR-quartic → pair-block reduction is now a kernel theorem, so the FORCED
   uniqueness statement carries to the CAR class."**
4. Cube-coincidence §: *"that question remains exactly the pre-registered selection conjecture
   in the open problems"* →
   **"the free-carrier→interaction derivation remains open; it is distinct from the
   selection-uniqueness conjecture, which is now RESOLVED (`PairKickSelection`)."**
   (Also a Q4 consistency fix — see below.)
5. Wherever the general-`n` cube is framed two-spinor-only: ensure the body matches the
   abstract's *"for any number of null constituents … `B_w^3=\mu^2 B_w` … for every `n`"* →
   **state the general-`n` cube (A-RESTGEN) as the theorem, with the two-spinor law as its
   corollary, and cite the non-decomposable control.**

### Paper C
1. Census abstract sentence: *"now machine-checked by explicit rank and kernel certificates
   closed through rank–nullity (compiled-evaluator certificate products, documented)"* →
   **"now kernel-clean: rank/kernel certificates closed through rank–nullity, `native_decide`
   removed (`CensusMultiplicity.*`, Kernel)."**
2. Theorem multiplicity line and appendix module entry marked `\DraftTrust{}` for
   `CensusMultiplicity` →
   **relabel to `\Kernel{}`** (the 2/4/0 singleton/block/control census is now kernel-clean).
3. Boundary sentence "the four-site instantiations carry the documented compiled-evaluator
   trust footprint" →
   **qualify: this now excludes `CensusMultiplicity` (kernel-clean); the eval footprint
   remains only on `HalfPeriodInvariant`/`PinnedMirrorChart`/etc.**

### Paper E
1. Abstract: *"the kernel formalization of this factorization is the paper's pending flagship
   (Section 4)"* →
   **"the factorization is kernel-checked (`PairSpectrumFixture.*`): the degree-28 product,
   the cubic reduction, and the pinned modes."**
2. Abstract §4 clause "computed exactly (oracle-exact) … solving a rational cubic" →
   **drop "oracle-exact"; it is now kernel.**
3. §4 body block *"[oracle-exact; formalization in flight … until it lands every constant in
   this section carries the oracle-exact tag and nothing in this section is claimed as
   kernel]"* →
   **replace with the kernel statement; the charpoly identification is closed, so §4's
   constants are kernel-checked at the `L=4`, 3-4-5-kick fixture.**
4. Title-line *"draft v0 (skeleton; 24h run)"* and Appendix *"[PENDING: module/guard table on
   freeze.]"* →
   **de-skeleton the flagship section and fill the module/guard table with
   `PairSpectrumFixture` + `PairMomentumBlocks` rows.**

---

## Q3 — FINAL_REPORT.md structure for the 08:00 audit

Design goal: a reader trusts the run **without re-running Lean**. That requires every headline
sentence to terminate at a named decl, an axiom list, and a byte-stable guard — nothing
resting on prose.

Recommended structure:

1. **Freeze header.** Freeze commit SHA; `lean-toolchain` + Mathlib pin; "build green" line;
   the two independent verifier sign-offs (Run 1 / Run 2 must agree, per scorecard §Mechanical
   layer).
2. **Per-paper claim ledger (one row per indicative headline).** Columns:
   claim sentence → Lean decl(s) → module → trust grade (Kernel / Kernel+Eval with eval token
   disclosed) → `#print axioms` result. This is the spine; it directly discharges the
   checklist item "every abstract sentence has an exact anchor."
3. **Axiom appendix.** `#print axioms` output for **every** kernel-clean decl (not only guarded
   flagships — scorecard Trap-2 rule 4), showing only `propext / Classical.choice / Quot.sound`
   (+ `Lean.ofReduceBool` **only** where Kernel+Eval is explicitly disclosed).
4. **Guard enforcement.** Name `OvernightTheoryAxiomGuard` (+ Paper E in-file guards); confirm
   the guard build passes and every `#guard_msgs` block is byte-unchanged vs freeze commit.
5. **Statement-integrity diff.** Theorem-statement diff vs the freeze commit demonstrating no
   post-freeze weakening; repo-wide `sorry`/placeholder scan = empty.
6. **Trust legend + explicit NOT-DONE list.** Enumerate every `oracle-exact` / `PENDING-harvest`
   / `HONEST-PENDING` row (C-WIND2; E-COMM commutator prose; E-HALF; P-C3; A benchmark) so no
   subjunctive item can be mistaken for done (rule 3).
7. **Reproduction stanza.** Exact `lake env lean …` invocations per module + benchmark manifest
   SHA-256, explicitly labeled *regression, not verified chain* (A-BENCH).
8. **Scope box.** Finite/fixture bounds stated up front: `L=4`, four-site and eight-site
   registers, 3-4-5 kick, 16 rational fields; **no continuum / thermodynamic / scattering
   claim**; eigenvector-participation explicitly open (E-MOM).

**The 3 "looks stronger than it is" traps a hostile morning auditor probes first:**

- **Trap 1 — Eval / oracle laundering.** A Kernel+Eval or oracle result narrated as if kernel.
  First probes: Paper A's charge census (is the symbol→Jacobian reduction *genuinely* kernel
  now, or still run-record?); Paper E's two "disclosed twin-layer native tokens" in
  `PairMomentumBlocks` and any §4 constant that did **not** actually land in
  `PairSpectrumFixture`; Paper C's `C-POS` (`selfadj_iff_protected`) which stays kernel+eval —
  the auditor will check the paper did *not* blanket-upgrade Paper C when only
  `CensusMultiplicity` went clean. Defense: `#print axioms` on each; flag any
  `Lean.ofReduceBool`/extra token against the disclosed list.
- **Trap 2 — Fixture generality overreach.** Exact-at-a-fixture results dressed in universal
  language. Probes: Paper E "the interacting spectrum" is `L=4` / 3-4-5 only, and
  participation is open; Paper A "every field" / "complete family" claims are the 16 rational
  four-site fields; the θ-family (`ThetaFamilyCompletion`) *is* genuinely all-θ, so the
  auditor will test whether prose distinguishes the truly-universal (all-θ) from the
  fixture-scoped (L=4). Defense: each ledger row states its quantifier explicitly.
- **Trap 3 — Resolved-vs-open / definitional-boundary smuggling.** Claims where a
  "definitional reduction" silently carries the mathematical weight, or where "resolved" and
  "open" coexist. Probes: Paper A's CAR-to-block ("definitional packaging" vs now-a-theorem —
  pick one, be consistent); the selection result is FORCED **on the 2×2 block under the
  site-local chiral action** — the auditor will ask whether "unique phase-reading quartic" is
  claimed beyond the block; and the §777 contradiction (abstract says selection conjecture
  resolved, §777 says it "remains open"). Defense: consistent scope language + the Q4 fixes.

---

## Q4 — Claims invalidated or needing a correction notice

No **mathematical** result is invalidated: every tonight landing is a positive proof, so
nothing in the manuscripts is shown false and no result-level retraction is warranted. The
corrections below are (a) status/trust-grade statements that tonight's landings make
literally false, and (b) one internal contradiction. All should be fixed before freeze.

1. **Paper A, charge census — factually false now.** *"…is the exact run-record layer,
   computed but not yet formalized."* Tonight's A-CHGBAL landing (8-node census derived from
   the walk symbol) makes "not yet formalized" false. **Correction: "…is now kernel-derived
   from the walk symbol (`SplitStepChargeBalance.*`)."**
2. **Paper A, selection open-problem — factually false now.** *"the reduction from the CAR
   quartic class to that block is definitional packaging, not a theorem."* The CAR-to-block
   reduction landed kernel-checked tonight. **Correction: state it as the landed reduction and
   carry FORCED-uniqueness to the CAR class.**
3. **Paper A, internal contradiction — must reconcile.** §open-problems and the abstract state
   the selection conjecture is *RESOLVED*, but the cube-coincidence § says *"that question
   remains exactly the pre-registered selection conjecture in the open problems."* These
   cannot both stand. **Correction: the still-open item is the free-carrier→interaction
   derivation; rename it and stop calling it "the selection conjecture," which is resolved.**
   (This is the contradiction Trap 3 will surface first.)
4. **Paper E, §4 disclaimer — false after landing.** *"…until it lands every constant in this
   section carries the oracle-exact tag and nothing in this section is claimed as kernel"* and
   abstract *"the paper's pending flagship."* E-SPEC landed. **Correction: retract the
   disclaimer; state §4 as kernel at the `L=4` 3-4-5 fixture.**
5. **Paper C, trust-label correction (not a math error).** Labeling `CensusMultiplicity` as
   Kernel+Eval / *"compiled-evaluator certificate products"* is now inaccurate (C-CENSUS is
   kernel-clean, `native_decide` removed). **Correction: relabel to Kernel-clean; do not touch
   the still-eval C-POS.**

**Scorecard rows also now stale (fix before the 08:00 audit reads from it):**
- `A-CHGBAL` "Schur-reduction layer = run-record" → kernel-derived.
- `A-SELECT` "CAR-to-block reduction = definitional boundary" → landed reduction.
- `C-CENSUS` "kernel+eval (disclosed)" → kernel-clean.
- `E-SPEC` "PENDING-harvest 4d9642bf; prose oracle-tagged" → landed/kernel.
- `E-MOM`/`E-COMM` commutator: confirm whether the ring-level witness
  (`PairMomentumBlocks.kick_breaks_translation`) supersedes the "oracle-exact" four-mode
  prose; if so, upgrade the note.
