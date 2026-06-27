# Null-edge next-wave strategy after the Gate A/B/C wave

**Type: no-build strategy job. Generated 2026-06-26.**

No Lean, Lake, pre-commit, or build/check command was run to produce this
report. It is a planning artifact only and changes no Lean source. All job
statuses, gate orderings, and kill-switch rules are read from the program's own
documents and must be re-verified against the live repo before any promotion.

Sources consulted:

- `AgentTasks/null-edge-wave4-results-review-2026-06-26.md` (next-wave scope).
- `AgentTasks/null-edge-job-dependency-dag.md` (job IDs, edges, kill switches).
- `AgentTasks/aristotle-wave-integration-triage.md` (per-job verdicts,
  hard-stop list, convention conflicts §3-A..E).
- `AgentTasks/null-edge-aristotle-ambitious-job-backlog-2026-06-26.md`
  (job universe `R`/`S`/`A`-`G`/`Q`/`L`/`M`/`I`).
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` §20-21 (gates,
  kill switches, ordering, integration freeze, stop rules).
- `Sources/Null_Edge_P1_Formal_Revision_Plan.md` (P1 standalone path).
- `docs/CONVENTIONS.md` (locked/working/unlocked convention status).

## 0. The wave this plan reacts to (no assumption it passes)

The just-submitted focused wave, mapped to backlog job IDs:

| Submitted wave item | Job ID(s) | Gate it serves |
| --- | --- | --- |
| live proof verification | verification job + `G1` (uses `I1`) | promotion prerequisite |
| super-Dirac sign theorem + wrong-grading counterexamples | `A1` + `A2` | Gate A |
| kinetic normalization package | `A6` (`NullEdgeKineticNormalization`) | Gate A |
| NullSolderFrame foundations | `B0 -> B1 -> B3 -> B2` | Gate B (pre-`B4`) |
| branch-count interpretation | `C2a`/`C2b` (uses `G3` criteria) | Gate C kill switch |
| high-momentum branch proof | `C1` (and `C3`) | Gate C kill switch |
| Krein double + counterexamples | `C5` + `C7` (-> `C6`) | Gate C addendum |

This plan is written so that **no scenario below assumes any of these pass.**
Each branch is conditioned on the actual return verdict. The two precondition /
kill-switch nodes govern everything downstream:

- **Gate A** (`A1`/`A2`/`A3`, supported by `A6`) is a *hard promotion
  prerequisite*. Until it clears in Lean, **no finite-square theorem
  (`B4`/`T14`/`B5`/`D7`/`M5`) may be promoted** (Working Plan §21.2). This rule
  is preserved as a hard gate throughout this plan.
- **Gate C branch count** (`C1`/`C2`) is a *kill switch*. Until it returns and
  is interpreted as non-fatal, **no heavy Gate-D continuum work and no chirality
  work (`C8`-`C12`, `E8`) may launch** (Working Plan §21.4). This rule is
  preserved as a kill switch throughout this plan.

---

## 1. Decision tree for the next wave (all important pass/fail branches)

Read each node as a verdict on a returned job, with the next-wave consequence.
"Promote" always means "promote only after the live verification job confirms
the file exists, is sorry-free, axiom-clean, and that the statement matches the
claim" (triage §0 caveat).

```text
ROOT: did the live proof-verification job promote, reject, or find missing files?

[V] live verification
 |
 |-- V.promote  : the four Draft/*.lean files exist, are sorry-free,
 |                axiom-clean, statements match reports.
 |     -> EW stabilizer (structural) + SM anomaly arithmetic become
 |        trusted-promotable WITH banners (see §5). Finite-square files stay
 |        draft-only regardless (Gate A still gates them).
 |
 |-- V.reject   : a file fails statement-matches-claim or has hidden sorry/axiom.
 |     -> do NOT promote that file. Re-run the offending proof job with a
 |        corrected statement BEFORE any dependent wave. Treat as a Wave-4 block.
 |
 |-- V.missing  : referenced Draft/*.lean files are absent from the live repo
 |                (as in the current snapshot, triage §0).
 |     -> highest priority: a recovery job to regenerate/locate the four files.
 |        Nothing in the EW/anomaly promotion line proceeds until they exist.

[A] Gate A (A1 sign theorem, A2 wrong-grading counterexamples; A6 naming)
 |
 |-- A.pass     : A1 (+odd companion) proven; A2 counterexamples proven;
 |                A6 kinetic naming fixed; A3 convention audit folded in.
 |     -> Gate A CLEARS. Finite-square promotion (B4/T14) is UNLOCKED as a
 |        promotion target (still needs B-core + S8/S9/S10 re-audit).
 |
 |-- A.partial  : sign theorem (A1) passes but counterexamples (A2) or A6
 |                naming unresolved (or A3 not yet integrated).
 |     -> Gate A does NOT clear for promotion. B4 may be developed
 |        EXPERIMENTALLY (draft-only); no finite-square theorem promoted.
 |        Re-launch the missing A2/A6/A3 piece as the top Gate-A job.
 |
 |-- A.fail     : sign theorem is false as stated, or a grading "repair" of a
 |                spacetime-chirality sign is found to be unavoidable.
 |     -> STOP all finite-square promotion. Re-open the convention: re-derive
 |        the correct D^2 sign decomposition before any B4/T14 work. This is a
 |        convention-spine event; escalate to a convention re-freeze job.

[B] B-core foundations (B0 NullSolderFrame -> B1 -> B3 -> B2; serial)
 |
 |-- B.pass     : B0/B1/B3/B2 all land; inverse-Gram + diagonal obstruction
 |                proven; S8 scalar kinetic re-audited onto B0.
 |     -> B4 finite-square decomposition becomes the next B-job, BUT only
 |        promotable after Gate A passes (A.pass). Develop B4 now; promote later.
 |
 |-- B.partial  : B0/B1 land, B3 (inverse-Gram) or B2 (diagonal obstruction)
 |                incomplete.
 |     -> hold B4. Re-launch the stuck node (respect serial order
 |        B1->B3->B2). Refactor S8/S9 onto whatever of B0 exists.
 |
 |-- B.fail     : B0/B1/B3 cannot be assembled into a consistent dual-soldered
 |                finite frame (e.g. inverse-Gram degenerate or no reconstruction
 |                identity).
 |     -> downgrade trigger: the finite dual-soldered algebra fails Gate B
 |        ("construction remains graph discretization with null labels",
 |        Working Plan §20.4 failure). Pivot to the P1-only publication path
 |        (§4) and the finite-reconstruction fallback.

[C] Gate C branch interpretation (C1/C3 theorem; C2a raw, C2b interpreted)
 |
 |-- C.pass     : branches near q=0 are exactly the desired continuum branch;
 |                extra branches are gapped/projected/cutoff artifacts and the
 |                +Gamma_s Phi block is shown to lift them OR a removal mechanism
 |                is identified.
 |     -> Gate C kill switch RELEASED. Heavy Gate-D continuum (D1/D7/...) and
 |        chirality (C8/C9/C12) become launchable (still need D2 framework).
 |
 |-- C.pending  : C2a raw data returned but C2b interpretation incomplete, or
 |                G3 acceptance criteria not yet applied.
 |     -> kill switch STAYS ENGAGED. No D-continuum, no chirality. Launch
 |        C2b (interpret against G3 criteria) as the top Gate-C job. Only D2
 |        (framework selection) and D6 (Lichnerowicz target audit) may proceed.
 |
 |-- C.fatal    : persistent high-momentum massless poles in the physical
 |                sector, OR complex growing modes the Phi block cannot remove,
 |                OR a positive-dimensional null variety that survives projection.
 |     -> KILL the heavy continuum + chirality lines. Trigger the downgrade /
 |        publication fallback (§4): no-go / branch-count paper, P1-only paper,
 |        finite-reconstruction paper. Do NOT claim no-doubling or continuum
 |        viability under any wording.

[K] Krein double (C5 self-adjointness) + counterexample (C7) -> C6 verdict
 |
 |-- K.pass-but-nonstable : C5 proves D_dbl is J_dbl-self-adjoint AND C7
 |                confirms a finite counterexample to real spectrum / stability.
 |     -> EXPECTED, IN-SPEC outcome. Krein stays "Lorentzian adjointness
 |        hygiene only" (CONVENTIONS locked rule). Record C6 verdict:
 |        J-self-adjointness != stability. Do NOT promote any
 |        stability/real-spectrum/positivity/unitarity claim. Chirality still
 |        requires an index/domain-wall/overlap mechanism, gated by Gate C.
 |
 |-- K.theorem-only : C5 passes, C7 (counterexample) not yet produced.
 |     -> launch C7 before any Krein language enters a manuscript. The pair
 |        must travel together (Working Plan §21.4).
 |
 |-- K.fail     : C5 self-adjointness is false for the doubled operator as
 |                constructed.
 |     -> the Krein-double construction is mis-specified; re-audit J, sharp,
 |        and D_- before any further Krein work. No effect on Gate A/B/C lines.
```

The Krein branch is deliberately separated: even its best outcome
(`K.pass-but-nonstable`) confirms non-stability and is **not** a green light for
chirality. Chirality remains gated by Gate C.

---

## 2. Ranked next-job list per scenario

Each list is ranked by downstream fan-out (most-unblocking first), restricted to
jobs the scenario actually permits. Promotions are always
post-verification-conditional.

### 2.1 If Gate A passes (A.pass)

1. `B4` finite-square decomposition (`D_N^2 = K_null + C_diamond + T_frame`,
   then graded `D^2 = -D_N^2 + Phi_H^2 - ...`) — now promotable once B-core +
   S8/S9/S10 re-audit are in place.
2. `A4` canonical-obstruction datum schema (feeds every canonical-`B` mass claim).
3. `A6`/`A7` finalize kinetic naming + convention appendix (if not already done).
4. `B5` mass-shell labeling on top of `B4`.
5. `M5` P2 finite-algebra paper scaffold (theorem boundary only; no prediction).

Hold: all Gate-D continuum work (still gated by Gate C), all prediction work.

### 2.2 If Gate A partially passes (A.partial)

1. Re-launch the missing Gate-A piece (`A2` counterexamples, or `A6` naming, or
   `A3` integration) — the serial hinge.
2. `B4` *experimental* draft only (no promotion).
3. `B-core` continuation (`B2` diagonal obstruction) if not done.
4. `A3` convention audit folded into `docs/CONVENTIONS.md`.

### 2.3 If Gate A fails (A.fail)

1. Convention re-freeze job: re-derive the correct `D^2` sign decomposition;
   produce a corrected sign theorem statement.
2. Freeze all finite-square promotion; mark `B4`/`T14`/`M5` blocked.
3. Continue B-core algebra (`B0`-`B3`) only as sign-neutral ring identities.
4. Shift weight to the P1-only path (§6) which does not depend on `D^2`.

### 2.4 If B-foundations pass (B.pass)

1. `B4` finite-square decomposition (promotable only if A.pass too).
2. Re-audit + promote `S8` scalar/gauge kinetic onto `B0 NullSolderFrame`.
3. `B6` P1 canonical-obstruction instance (needs `B1`, `A4`).
4. `D8` null-edge scalar/gauge kinetics (Gate A/B; still wait Gate C for heavy D).
5. `B1`/`B3`-fed `G4` specificity audit for the P1.5 theorems.

### 2.5 If B-foundations partially pass (B.partial)

1. Re-launch the stuck B-node respecting `B1 -> B3 -> B2`.
2. Refactor `S8`/`S9` onto whatever of `B0` exists (reduce definition drift).
3. Keep `B4` and all dependents on hold.

### 2.6 If B-foundations fail (B.fail)

1. Trigger downgrade (§4): finite-reconstruction / P1-only path.
2. `M1` P1 review-safe manuscript (does not depend on B-core).
3. Record the Gate-B failure verdict and the diagonal-obstruction evidence as a
   no-go data point (`M6` branch/no-go paper material).

### 2.7 If Gate C passes (C.pass)

1. `D2` continuum estimate-framework selection (gates every Gate-D proof).
2. `D6` Lichnerowicz-target audit.
3. `D1` smooth local symbol asymptotic (needs `D2`, `B4`).
4. `C8`/`C9` chirality pilot (domain-wall/SSH) — now branch-count-cleared.
5. `D7` flat continuum square prototype (needs `D2`, `B4`).

### 2.8 If Gate C is pending (C.pending)

1. `C2b` interpret raw branch data against `G3` acceptance criteria.
2. `C1`/`C3` determinant branch theorems (if not yet banked).
3. `D2` framework selection + `D6` audit (the ONLY D-jobs allowed to precede).
4. No chirality, no heavy continuum.

### 2.9 If Gate C is fatal (C.fatal)

1. Downgrade publication fallback (§4): no-go / branch-count paper.
2. `M6` P2b branch/Krein paper (explicitly a no-go result).
3. `P1-only` manuscript path (§6) becomes the primary deliverable.
4. Freeze all `D`, `C8`-`C12`, `E8`, and all prediction work.

### 2.10 If Krein double passes but counterexample confirms non-stability (K.pass-but-nonstable)

1. Record `C6` verdict: J-self-adjointness is hygiene, not stability.
2. Keep the Krein theorem + counterexample as a *paired* manuscript unit
   (`M6` honesty pair).
3. Do NOT launch any stability/real-spectrum job; do NOT use Krein to justify
   chirality (still Gate-C gated).

### 2.11 If live verification promotes / rejects / finds missing files

- **Promotes:** launch the §5 promotion plan for EW stabilizer + SM anomaly.
- **Rejects:** re-run the offending proof job with a corrected statement before
  any dependent wave; do not promote.
- **Missing files:** top-priority recovery job to regenerate/locate the four
  `Draft/*.lean` files; nothing in the promotion line proceeds until they exist.

---

## 3. Conservative default next wave (mixed but not fatal results)

Use this when results are the realistic mixed case — some proofs verify, Gate A
is partial or just-passed, B-core is progressing, Gate C is **pending** (not
fatal), and Krein is theorem-plus-counterexample. This default deliberately
avoids both kill-switch-gated lines and assumes nothing optimistic.

Launch concurrently (no intra-wave dependency):

1. **`C2b` branch interpretation** — interpret the returned raw branch data
   against the `G3` acceptance criteria; classify each high-symmetry branch as
   harmless cutoff artifact / physical doubler / complex instability / requires
   redesign. This is the highest-priority risk node; it decides whether the kill
   switch releases.
2. **Gate-A completion** — whichever of `A2` (wrong-grading counterexamples),
   `A6` (kinetic naming normalization), `A3` (convention audit fold-in) did not
   land. Gate A is the hard promotion prerequisite, so closing it has the
   largest promotion fan-out.
3. **`B2` diagonal trace obstruction** — the next serial B-core node after
   `B0/B1/B3`, needed before `B4`. Develop `B4` experimentally alongside but do
   not promote it.
4. **`S8` re-audit onto `B0 NullSolderFrame`** — fold the scalar/gauge kinetic
   reconstruction onto the shared frame to stop definition drift (triage §4).
5. **`C7` Krein counterexample** (if only `C5` returned) — pair it with the
   self-adjointness theorem so Krein language never travels alone.

Plus the always-safe strategy/audit jobs that carry no proof risk and no gate
dependency: `D2` (framework selection), `D6` (Lichnerowicz-target audit), `F1`
(ranking only, no prediction language), `M1` (P1 review-safe rewrite).

Explicitly excluded from the default wave: any `B4` *promotion*, any heavy
Gate-D proof beyond `D2`/`D6`, any chirality job, any prediction job, any QCD
theorem, any FMS Lean job. Those wait on the gates in §7.

---

## 4. Downgrade / publication fallback if Gate C is fatal

If Gate C returns fatal (persistent high-momentum massless poles, complex
growing physical modes, or a surviving positive-dimensional null variety the
mass block cannot lift), the heavy-continuum and chirality program is killed.
The program does **not** collapse — it downgrades to honest finite results. Three
publishable products, in priority order:

### 4.1 No-go / branch-count paper (`M6`)

- **Claim:** the flat tetrahedral retarded dual-soldered operator exhibits
  determinant-level branches (corner null branches + positive-dimensional null
  variety + complex-energy branches) that the `+Gamma_s Phi_H` mass block does
  not remove; therefore the naive flat construction does not yield a
  doubler-free continuum Dirac operator without an added removal mechanism.
- **Label:** structural no-go / audit result. NOT a claim that null-edge is
  impossible — a claim that *this* flat operator fails the branch test.
- **Pairing:** include the Krein honesty pair (`C5`+`C7`/`C6`):
  J-self-adjointness holds but does not give stability.
- **Guardrail:** never phrase as "no-doubling achieved"; the result is the
  opposite — branches survive.

### 4.2 P1-only paper (see §6)

- The finite Plucker kinematic theorem stands entirely independent of Gate C.
  This becomes the primary positive publication regardless of the continuum
  outcome.

### 4.3 Finite-reconstruction paper

- **Claim:** P1 + P1.5 finite algebra (Yukawa checkerboard, Abelian Higgs link
  stiffness, electroweak stabilizer) reconstruct known mass mechanisms from
  null-edge primitives, even though no continuum square limit and no codimension
  prediction is established.
- **Label:** reconstruction (Working Plan §20.12 "keep going under finite
  reconstruction"). Explicitly states prediction remains a later, open problem.
- **Constraint:** every theorem carries its claim label; no continuum, no
  no-doubling, no prediction language.

Fatal-Gate-C stop rules (Working Plan §20.12) to enforce in all three:

- Stop the graph-operator branch's continuum claims (determinant branch count
  revealed surviving branches).
- Keep P1 / P1.5 / finite reconstruction as the surviving valuable core.

---

## 5. Promotion plan if live verification trusts EW stabilizer + SM anomaly

Trigger: live verification returns `V.promote` for
`NullEdgeElectroweakStabilizer.lean` and `StandardModelAnomalyAudit.lean`
(file exists, sorry-free, axiom-clean, statement matches report).

Steps, in order:

1. **Attach the convention-import banner** (`G1` policy, triage §1 gap, §3-E):
   each promoted file must declare metric signature, grading conventions,
   kinetic-sign convention, and frame/soldering normalization (Working Plan
   §21.8 integration invariant). Neither file uses `Gamma_s` square or kinetic
   signs, so their banners are short but mandatory.

2. **EW stabilizer — promote as a STRUCTURAL theorem** with two locked caveats:
   - the **real-coordinate lock** (triage §3-C): `dim ker = 1`, `rank = 3` hold
     only because `B_EW` is treated as an `R`-linear map `R^4 -> C^2`. This
     travels as an explicit import on every downstream use; never "fix" a future
     conflict by switching to `C`-coordinates (that alters the theorem).
   - the **generator-convention bridge** (triage §3-D): physics-Hermitian
     `T_i = sigma_i/2`, `Y(H)=1`, `Q=T_3+Y/2`; record that the anti-Hermitian
     `i`-factor is an overall scalar leaving kernel/rank unchanged.
   - Label: structural theorem given SM electroweak group, Higgs rep, vacuum
     section. The Stage-2 `m_W`/`m_Z` coefficient theorem is NOT done; do not
     imply it is.

3. **SM anomaly arithmetic — promote as anomaly bookkeeping only**, with the
   explicit non-chirality disclaimer (triage §2.1): it shows the one-generation
   anomaly sums vanish; it does NOT show null-edge realizes the chiral SM.
   Label: representation/structural bookkeeping, not a chirality claim.

4. **Keep both in `Draft/` until banners attached**, then move to the trusted
   `PhysicsSM` namespace via `G1`. Do not promote the finite-square / tetrad /
   kinetic files in the same step — those stay draft-only (Gate A and B1/B3
   ordering gate them).

5. **Manuscript use:** EW stabilizer feeds the P1.5 electroweak section as a
   structural theorem; SM anomaly feeds the chirality-bookkeeping co-pilot layer
   only. Neither may be used to claim EW symmetry breaking as an observable or
   to claim chiral SM realization.

What this promotion does NOT unlock: `B11` EW coefficient reconstruction (needs
`A1`), `E1` FMS composite (needs `S11` + CONVENTIONS update), any prediction.

---

## 6. P1 manuscript path independent of P1.5 / P2

Use `Sources/Null_Edge_P1_Formal_Revision_Plan.md` as the controlling document.
Its single load-bearing principle (Working Plan §21.7): **P1 stands entirely on
the trusted finite Plucker theorem and its kernel-checked wrappers; every
sentence whose truth waits on P1.5 or P2 is demoted to labeled outlook.** This
path is launchable now and is independent of every gate above.

Sequenced jobs:

1. **`M1` — P1 review-safe rewrite** (Gate A for language only): apply the
   formal-title recommendation, the claim-boundary box, the abstract rewrite,
   and the four-status theorem table from the revision plan §1-§5.
2. **Promote or quarantine the `artifact*` / `draft**` rows** of the revision
   plan §5 table:
   - `artifact*` rows (celestial moment form, closed-fan rest frame) live in the
     standalone Aristotle package; promote into trusted `PhysicsSM` or cite as a
     clearly-labeled appendix — do not present as trusted.
   - `draft**` rows (`SL(2,C)` invariance, static Dirac slash) need
     convention/semantic review (integration invariant §21.8) before promotion.
3. **`A5`/`A7` convention appendix** for P1 (metric, grading, claim labels).
4. **`M3` theorem-to-Lean crosswalk** for the trusted rows only.
5. **`S5`/`L`-series citation re-resolution** (HARD STOP on typesetting any
   unverified DOI/venue; triage §5).

P1 claim boundary (revision plan §0, enforce verbatim in tone):

- **Proves:** finite kinematic Plucker theorem (invariant mass^2 = total
  pairwise Plucker spread; massless iff projectively collinear null directions)
  plus the kernel-checked wrappers, each with its status label.
- **Does NOT derive (label as future/outlook):** continuum Dirac/square limit
  (P2), super-Dirac operator and graded square (P2), toy mass mechanisms (P1.5),
  SM spectrum/Yukawa textures, QCD confinement/proton mass, neutrino mass
  mechanism, moduli-rank prediction.
- **Language locks (CONVENTIONS):** use "finite invariant mass" /
  "rank-one obstruction" / "quadratic Plucker obstruction", NOT "spectral gap"
  for the P1 invariant; avoid "predicts/derives" for inputs; avoid
  "origin of all mass" and "gauge symmetry breaks" as observable.

This path survives every fatal branch above and is the program's guaranteed
positive deliverable.

---

## 7. Jobs NOT to launch until specific gates pass

Hard lockouts, with the exact unblocking condition:

| Do NOT launch | Blocked until |
| --- | --- |
| `B4`/`T14` finite-square **promotion**, `B5`, `D7`, `M5` | **Gate A passes** (`A1`+`A2`+`A3`, supported by `A6`) — hard promotion prerequisite. `B4` may be developed experimentally, never promoted, before this. |
| `B4` **integration** | `S8`/`S9`/`S10` re-audited against `B1`/`B3` AND B-core (`B0->B1->B3->B2`) complete. |
| Heavy Gate-D continuum (`D1`, `D3`, `D4`, `D5`, `D7`, `D8`, `D10`, `D11`) | **Gate C branch count returns non-fatal** (`C1`/`C2` pass). Only `D2` (framework) and `D6` (audit) may precede. |
| Prediction / codimension jobs (`F3`-`F9`, `F10`, `T17`) | **finite operator (`B4`/`T14`) AND moduli data (`S6`/`F1`) both exist** `[LOCKED]`. `F1` ranking and `F2` template are the only open F-jobs, and neither may use prediction language. |
| QCD theorem (`Q3`/`Q4`/`Q5`, any `B_QCD`) | a genuine finite color-gap statement exists (`Q2` finds a route): a finite `S`, canonical map, and `H_color^finite` restricted to singlets `>= Delta > 0`. None exists; QCD stays boundary/motivation. |
| FMS Lean theorem (`E1`/`E2`/`E3`) | `S11` FMS audit + CONVENTIONS update to the corrected composite. Do NOT formalize the schematic `O_e^a` (it is gauge-covariant, not invariant); the corrected target is the framed triplet `W_e^a = (1/2) tr(sigma^a X_s^dag U_e X_t)` plus singlet `H_s^dag U_e H_t`. Treat as "composite still unsettled" until then. |
| Chiral-sector jobs (`C8`, `C9`, `C10`, `C12`, `E8`) | Gate C branch-count evidence is in hand (non-fatal). |
| Any no-doubling / "retardedness avoids doublers" / continuum-viability claim | Gate C passes. Only "avoids coefficient-zero doublers; determinant-level branches remain to be tested" is sayable now. |
| Any Krein -> stability / real-spectrum / positivity / unitarity claim | never (explicit counterexamples exist); Krein is hygiene only. |
| Manuscript promotions `M4`, `M5`, `M6` | their theorem packages + `G4`/branch-count as marked. |

Guardrail restatement: **Gate A stays a hard promotion prerequisite for finite
square theorems; Gate C stays a kill switch for heavy continuum and chirality
work.** Do not assume no-doubling or continuum viability; do not call
reconstruction "prediction"; do not propose QCD theorem jobs without a genuine
finite color-gap statement.

---

## 8. Prompt sketches for the top five default-scenario jobs

These correspond to the conservative default wave (§3). Each is a sketch for an
Aristotle job; statements are ASCII per repo hygiene. None assumes the submitted
wave passed; each is conditioned on its inputs being present.

### 8.1 `C2b` — branch-count interpretation against acceptance criteria

```text
Type: no-build audit (interpretation).
Inputs: returned raw branch data (C2a / null-edge-branch-script-report.md),
        acceptance criteria (G3 / null-edge-branch-count-acceptance-criteria.md),
        CONVENTIONS branch-count/no-doubling rule.
Task: For the flat retarded dual-soldered operator det(i D_+(q) + Gamma_s Phi)=0,
      classify every returned high-symmetry branch candidate (including the
      q=(pi,pi,pi,0) corner where u^T G^{-1} u = 0 with G^{-1} = -3/4 I + 1/4 J)
      into exactly one of: harmless cutoff artifact / physical doubler /
      complex instability / requires redesign. Produce a machine-readable table
      (branch, q, real|complex, massless|massive|high-momentum, multiplicity
      after Krein doubling, chirality, verdict) plus a narrative classification.
      State explicitly whether the +Gamma_s Phi mass block lifts or preserves
      each branch.
Deliverable: AgentTasks/null-edge-branch-count-interpretation.md, ending in a
      one-line Gate C verdict: RELEASED / PENDING / FATAL.
Guardrails: do not claim no-doubling; "avoids coefficient-zero doublers,
      determinant-level branches remain" is the strongest allowed phrasing.
      This is the kill switch; a FATAL verdict triggers the §4 downgrade.
```

### 8.2 `A2`/`A6`/`A3` — complete Gate A

```text
Type: mixed (A2 Lean proof; A6 Lean naming; A3 no-build convention fold-in).
Inputs: A1 sign theorem (super_dirac_square_single) status; super-Dirac sign +
        double-counting audit; CONVENTIONS super-Dirac/kinetic blocks.
Task A2 (Lean): prove the wrong-grading counterexamples — finite witnesses that
      (Gamma_s Phi)^2 = -Phi^2 when {Gamma_s,Phi}=0, and that the theorem fails
      (extra terms) when [C_a,Phi] != 0. Goal: protect +Phi_H^2 against any
      future "regrading" repair.
Task A6 (Lean): normalize kinetic naming. Fix exactly one symbol for the
      symmetric box (recommend Box_null), one for C_diamond, and reserve K_null
      for one of them, with an alias lemma. Resolve the report's Kplus = Box_null
      + C_diamond vs CONVENTIONS' K_null (box only) collision (triage §3-A).
Task A3 (no-build): fold §3-A..E of the triage into docs/CONVENTIONS.md
      (kinetic naming decision, FMS corrected composite, real-coordinate B_EW
      lock, generator bridge, branch-count + sign verdict as locked Gate A spec).
Guardrail: Gate A is a hard promotion prerequisite; until A1+A2+A3 land, NO
      finite-square theorem is promoted.
```

### 8.3 `B2` — diagonal trace obstruction (next B-core node)

```text
Type: Lean proof.
Inputs: B0 NullSolderFrame, B1 simplex frame, B3 tetrahedral inverse-Gram
        (from the submitted foundations wave); CONVENTIONS dual-soldered
        architecture (diagonal architecture is a negative comparison only).
Task: formalize the diagonal trace/symbol obstruction: the diagonal architecture
      D = sum_a c(ell_a^flat) nabla_{ell_a} fails to reconstruct the intended
      Dirac symbol (trace obstruction), whereas the dual-soldered C_a = c(alpha^a)
      does. This justifies the non-diagonal operator used in B4. Respect the
      serial order B1 -> B3 -> B2; do not jump to B4.
Guardrail: sign-neutral ring algebra; no graded D^2 here (that is gated by
      Gate A). Promotion of B-core still waits on Gate A.
```

### 8.4 `S8` re-audit onto `NullSolderFrame`

```text
Type: Lean proof (refactor) + audit.
Inputs: NullEdgeScalarKineticReconstruction.lean (S8, draft); B0 NullSolderFrame;
        backlog note "S8 must be re-audited against B1/B3 before promotion".
Task: refactor the inverse-Gram reconstruction g^{-1}(xi,eta) = sum G^{ab}
      xi(ell_a) eta(ell_b) onto the shared B0 NullSolderFrame (null directions,
      dual covectors, Gram/inverse-Gram, reconstruction identity, C_a = c(alpha^a))
      instead of the file's local sharp/dualBasis encoding. Confirm the
      Lorentzian inverse-Gram cross terms survive (Euclidean-collapse guardrail),
      and keep the Higgs corollary. Output draft-only; not promoted until B-core
      lands.
Guardrail: mostly-minus signature; do not let a positive edge-sum stand in for
      the Lorentzian cross terms.
```

### 8.5 `C7` — Krein non-stability counterexample (pair with `C5`)

```text
Type: Lean proof (counterexample).
Inputs: C5 finite Krein-double J-self-adjointness theorem (if returned);
        Krein stability audit; CONVENTIONS Krein non-overclaim rule.
Task: construct finite explicit counterexamples showing J_dbl-self-adjointness
      of D_dbl = [[0,D_-],[D_+,0]] does NOT imply (a) real spectrum, (b) absence
      of growing modes, (c) positivity/stability. At least one nonreal-eigenvalue
      witness and one growing-mode witness. Package with C5 as a single paired
      job so theorem and counterexample travel together.
Deliverable: Lean counterexamples + a C6 verdict line: J-self-adjointness is
      Lorentzian hygiene, not stability; chirality still needs an
      index/domain-wall/overlap mechanism (Gate-C gated).
Guardrail: no stability/real-spectrum/positivity/unitarity claim may be promoted.
```

---

## 9. Guardrail compliance summary

- **No-doubling / continuum viability not assumed.** Gate C is treated as a kill
  switch throughout (§1 `[C]`, §3 exclusions, §4 fatal path, §7 lockouts);
  strongest allowed phrasing is "avoids coefficient-zero doublers,
  determinant-level branches remain to be tested".
- **Reconstruction is not called prediction.** All prediction jobs are
  `[LOCKED]` (§7); the finite-reconstruction fallback (§4.3) is explicitly
  labeled reconstruction, not prediction.
- **No QCD theorem proposed.** QCD stays boundary/motivation; a `B_QCD` /
  color-gap theorem is gated on a genuine finite color-gap statement (§7).
- **Gate A kept as a hard promotion prerequisite** for all finite-square
  theorems (§1 `[A]`, §2.1-2.3, §7).
- **Gate C kept as a kill switch** for heavy continuum and chirality work
  (§1 `[C]`, §2.7-2.9, §4, §7).

This is a planning artifact only. Re-verify all statuses and Lean states against
the live repo before promoting any node to a trusted surface.
