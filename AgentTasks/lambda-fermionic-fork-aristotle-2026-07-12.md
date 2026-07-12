# Aristotle task T1: resolve the everpresent-Lambda fork on fermionic states

THE paper-maker for the cosmological-constant manuscript (Section 5), per expert
review. The manuscript's `LambdaCountDichotomy` only shows both branches are
POSSIBLE; T1 makes them COMPUTABLE via the fermionic Wick variance
`Var(N_A) = tr K_A - tr K_A^2`, and exhibits a genuinely sub-extensive,
non-degenerate projection (Fermi-sea) witness -- the hyperuniform kill-branch
witness the paper needs.

Target file: standalone Mathlib-only `LambdaFermionicFork/Fork.lean` (7 sorries;
statements typecheck). Headline: `bondProj_numberVariance` (Var = k/4) +
`fork_subextensive` (region k^2, Var = k/4 => alpha=1/2, sub-extensive & unbounded)
+ `fermionic_fork_verdict` (the dichotomy).

```yaml
aristotle:
  project_id: 9be8f014-9b7a-4713-9f22-de1166cf9aae
  status_submitted: 2026-07-12 ~08:05 PDT
  target_file: AgentTasks/aristotle-standalone/lambda-fermionic-fork-20260712/LambdaFermionicFork/Fork.lean
  expected_module: LambdaFermionicFork.Fork
  submission_project: AgentTasks/aristotle-submit/lambda-fermionic-fork-20260712-project
  status: INTEGRATED 2026-07-12 (all 8 theorems kernel-clean, guard-pinned; fork RESOLVED)
```

Success: all 7 theorems proved, no sorry/admit/axiom/native_decide; footprint
[propext, Classical.choice, Quot.sound].

## Integration plan on harvest (pre-staged 08:46, so harvest is fast)

When 9be8f014 returns:
1. Download + extract; SEMANTIC-REVIEW before touching repo. Check especially:
   - `bondProj_numberVariance` proves Var = k/4 EXACTLY (the crux; not a bound).
   - `bondProj_isProjection` proves K^2 = K (genuine Fermi kernel; if only a weaker
     0<=K<=1 or a sorry here, the "kinematic state" framing weakens -> disclose).
   - `fork_subextensive` region size = k^2 with Var = k/4 (alpha=1/2, non-degenerate).
   - Statements BYTE-IDENTICAL to submitted (no silent weakening).
   - `#print axioms` on the headline theorems = standard-3, no native_decide.
2. If clean: place as `PhysicsSM/Draft/NullEdge/LambdaFermionicFork.lean` (+ provenance
   note); `lake build`; guard-pin `bondProj_numberVariance`, `fork_subextensive`,
   `fermionic_fork_verdict` in LambdaCosmologyAxiomGuard (new Section 5 block); rebuild
   guard green.
3. MANUSCRIPT S5: flip the fermionic-fork paragraph from "\Conj{} ... in progress,
   stated with \Conj{} until landed" to \Kernel{} RESOLVED -- the dichotomy is now
   proved on the framework's own states (extensive diagonal vs sub-extensive projection);
   update the abstract claim (3) to note the dichotomy is realized, not only pre-registered.
   This is the 3->5/6 upgrade the review identified.
4. If PARTIAL (e.g. projection property sorry'd but variance proved): integrate the
   variance + fork corollaries, DISCLOSE the projection gap honestly, keep S5 as
   "sub-extensive witness landed; full Fermi-kernel property pending".
5. Ledger + scorecard + FINAL_REPORT update.
