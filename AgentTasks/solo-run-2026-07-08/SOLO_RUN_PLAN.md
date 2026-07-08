# Solo autonomous run — plan (2026-07-08)

**Mode.** Single agent (Claude/Opus), autonomous, self-paced, for the day. No
co-equal Codex lane this run: I own the whole tree — verify and commit in-flight
green work, keep the build clean, and build on it.

**Two focuses (equal weight):**
1. **Completely finish the manuscript** (`Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`)
   — as a self-contained **Markdown** draft to publication quality. Includes a
   **complete, verified references** section (no LaTeX conversion this run).
2. **Flesh out the dynamics layer as much as possible**, with the goal of
   **setting up the Lean code to inform Python simulations**, across all three
   physics directions the user chose: **(A) spectra & mass budgets, (B)
   time-evolution & scattering, (C) RG flow & thermodynamic limit.**

**Standing directives.**
- **Frequent, comprehensive literature reviews** (see cadence below) — sweep
  before major manuscript or dynamics work, and log every sweep.
- **Borrow liberally from public Lean repositories to establish pieces, with
  proper attribution.** (See the dedicated section below.) PhysLean (`Physlib`)
  first; scout other public Lean physics/math repos where they would help.
- **Aristotle: use liberally** for Lean proofs (dynamics theorems +
  manuscript-supporting results). Harvest promptly; verify + guard-pin locally
  before claiming M.
- **Fable: comprehensive review roughly every 2 hours** (`send_claude_review.py
  --model claude-fable-5`), each with full standalone context; log under
  `AgentTasks/model-calls/claude/`.
- Grade discipline throughout (T/M/MEMO/C); every numeric result quarantined
  from the verified core; kills reported at theorem prominence.

## Borrowing from public Lean repositories (liberal, with attribution)

**Directive (user, 2026-07-08): borrow liberally to establish pieces — from
PhysLean, and from any other public Lean repository that helps — always with
proper attribution and license compliance.**

- **PhysLean (`Physlib`) — primary.** Access + version constraint + what to mine
  are in [`docs/PHYSLEAN.md`](../../docs/PHYSLEAN.md): semantic search
  (`lean-explore packages=["Physlib"]`) + source clone
  (`AgentTasks/external/PhysLean`). We are version-pinned (they are v4.31.0, we
  are v4.28.0), so **consult + convention-cross-check + clean-room port**, not
  `import`. Use it for spinors/Weyl/SL(2,C), Pauli/Clifford/Dirac algebra,
  Minkowski metric, variational/Lagrangian/Hamiltonian dynamics, canonical
  ensemble, Wick/second-quantization, SM/anomaly/Spin(10). Cite the exact module.
- **Mathlib** — already a build dependency; use directly (it is the base of every
  M result).
- **Other public Lean repos — scout and borrow when helpful.** Check
  permissively-licensed Lean 4 projects (e.g. other formalized-physics or
  relevant math efforts) via `lean-explore`, GitHub, or the scholarly search when
  a needed structure (a spectral/variational/lattice/operator API) may already
  exist. Before borrowing: (i) check the licence — Apache/MIT/BSD are OK to
  consult + reuse-with-attribution + clean-room; **GPL/AGPL/unclear must NOT be
  copied into trusted Lean** (consult only, then clean-room from the math per
  `AGENTS.md`); (ii) record the source repo, commit, licence, and the exact
  declaration in the module docstring / `Sources/Null_Edge_References.md`; (iii)
  translate the *mathematics*, not the implementation text, and re-verify under
  our pinned toolchain. When a borrow becomes a genuine build dependency, follow
  the optional-root pattern (`docs/PHYSLEAN.md`), never bump the pin.
- **Log** each borrow (repo + declaration + licence + how used) in the run
  ledger and the references map, so provenance is auditable.

---

## Focus 1 — finish the manuscript (checklist)

Current state: strong (positivity crux resolved via T2; free §3↔§4 bridge proved;
worked example added; §11 mostly current). Remaining to be "completely finished":

- [ ] **References — complete + verify.** Confirm every arXiv/DOI/INSPIRE id in
      the §References section and `Sources/Null_Edge_References.md`; fill the
      draft classic citations (Zwanziger 1991, Nielsen–Ninomiya 1981, OS 1978,
      Banks–Casher 1980, Koide, Regge, etc.) with checked volume/page; Zotero/
      Neo4j-key the ID-ONLY entries (existence-check first). This is the
      user-flagged priority.
- [ ] **Reproducibility appendix** (Review B ask): how to rebuild every M claim —
      toolchain pin, `lake build`, the guard files, the axiom-audit, the oracle
      probes and what each validates.
- [ ] **§11 anchor-table sweep**: re-grep every theorem name/file/guard status;
      add any newly-landed M results (dynamics, Codex's Fock/checkerboard).
- [ ] **Comparison table** (Review B): the program vs its neighbours (Bizi et al
      Krein triples, Foster–Jacobson checkerboard, NCG-SM, QCA-Dirac,
      constructive QFT) — what each has/lacks, sharpening the narrowed novelty.
- [ ] **Consistency pass**: grades vs claims, cross-references, no dangling
      "next-target" wording now that T2/free-bridge landed; abstract/intro
      reflect the current state.
- [ ] **A dynamics section/paragraph** reflecting Focus 2 (action → EOM →
      conservation → ensemble; what is M vs C).
- [ ] Final Fable + Aristotle audit pass on the whole manuscript before "done".

## Focus 2 — dynamics layer (Lean-informing Python sims)

Roadmap `DYNAMICS_GROUNDWORK.md` (D1–D5). Status: D1 action+EOM
(`FiniteCarrierAction`) and D5 ensemble (`FiniteCanonicalEnsemble`) landed
(Codex, to verify/commit); D-conservation (D2/D3) Aristotle job in flight;
`carrier_dynamics_harness.py` validates 5 blocks. Build the Lean → Python bridge
for the three directions:

- **(A) Spectra & mass budgets.** Lean: the budget/keystone/T2 identities
  (landed). Python: a spectrum+budget simulator over parametrized carriers,
  each output validated against a landed M-identity. Extend the harness.
- **(B) Time-evolution & scattering.** Lean: D-conservation (norm+energy under
  `exp(-iHt)`) + a transfer-operator / checkerboard step. Python: evolve states,
  compute conserved quantities and (checkerboard) amplitudes. Harvest
  D-conservation; then a transfer-operator theorem.
- **(C) RG flow & thermodynamic limit.** Lean: iterate the Schur decimation
  (RGSchurMassWitness) into a flow lemma; the canonical ensemble
  (FiniteCanonicalEnsemble). Python: RG-flow of the budget/`N_m`, and the
  ensemble/condensate in the large-complex limit.
- **The bridge principle:** every Python simulation output is checked against a
  kernel-checked Lean identity (the harness pattern). The Lean *is* the sim's
  spec + validation oracle.

## Literature-review cadence

Run a comprehensive sweep (scholarly MCP: arXiv/INSPIRE/Semantic Scholar; short
queries) at least at the start of each focus block and before each Fable call.
Log to `AgentTasks/solo-run-2026-07-08/LIT_LOG.md`. Topic rota:
- dynamics/variational lattice Dirac; discrete-time evolution / quantum walks;
  transfer-operator continuum limits; Krein/indefinite dynamics.
- finite/lattice mass spectra; Banks–Casher / spectral density; RG / block-spin
  decimation; constructive-QFT cluster expansions.
- anything sharpening the manuscript's novelty / prior-art (refresh the
  2026-07-08 review as results land).
Feed findings into `docs/PHYSLEAN.md` cross-checks and the references map.

## Cadence (self-paced loop)

Rough hour-scale rhythm: (1) lit sweep → (2) advance manuscript OR dynamics →
(3) prep + submit Aristotle jobs; harvest completed ones (verify, guard-pin,
commit) → (4) commit + ledger → repeat; Fable review ~every 2h; end-of-day
finalize the manuscript + a MORNING/EOD report. Commit frequently with
`allmass-202607:` / `solo-202607:` prefixes.

## Coordination / tree hygiene (solo)

- Reconcile in-flight uncommitted work (FiniteCarrierAction, FiniteCanonicalEnsemble,
  the extended CarrierAxiomGuard): verify each builds under the pin, wire
  `FreeMassBridge` into the guard, then commit. Keep the tree green.
- Aristotle jobs in flight: D-conservation (5cb0e51b). Cancelled: D1 (redundant).
