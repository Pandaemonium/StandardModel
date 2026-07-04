# Four-day YM run: prep notes (verified 2026-07-04 by the planning session)

Everything here was checked against the pinned toolchain
(leanprover/lean4:v4.28.0) and the live repo on 2026-07-04. Do NOT
re-derive it. If something contradicts the live tree, the tree wins -
post a note.

## 1. Module inventory (GateYM draft tree, all kernel-checked, standard axiom footprint unless noted)

State as of commit `71afec2`-era plus the RP-KER and queue commits.
Aggregate `lake build PhysicsSM.Draft.NullEdge.GateYM` = 8060 jobs green;
full `lake build` green same day.

- `Z2GaugeCore`, `ElitzurCore`, `ElitzurLattice` - YM0/YM1 Elitzur chain
  (volume-uniform, quantitative).
- `TorusEvenCover` - Z2 torus even-cover combinatorics + `ratio_rectInside`
  (Theorem 2' exact formula, geometric rectangle).
- `FusionConvolution` - Lemma 2a (`lemma2a_fusion_convolution`,
  oracle-pinned `h^{-1} * A` order), division-free iteration, `iterConv`.
- `Theorem2AreaLaw` - Wilson specialization: `wilsonLocalWeightC`,
  `wilsonPlaquetteSumC`, `wilson_gamma`, `wilsonNormalizedGamma`,
  normalized/cross-multiplied iteration forms.
- `IndependentPlaquetteEnsemble` - Lemma 2b: `orderedProd` (List.ofFn
  based), tuple-sum = `iterConv`, `loopNumerator_factor` (sum-type
  transport), `wilson_loop_expectation_area_law`,
  `norm_wilson_loop_expectation`.
- `TreeGaugeBridge` - `PlaquetteCoordinatization` interface +
  `linkPartition/linkNumerator/linkExpectation` (complex) +
  `wilson_link_loop_expectation_area_law`.
- `RectTreeGauge` - concrete `Lx x Ly` rectangle (`rectLattice`,
  `rectPlaquette` with `rfl`-pinned `rectPlaquette_hol_formula`,
  comb-tree `rectCoordinatization` from Aristotle `1d9b5b19`) +
  `rect_wilson_loop_expectation_area_law`.
- `FusionTransferSpectrum` - `convLeftLinear`, vacuum eigenvector
  (constant function, eigenvalue = one-plaquette sum), character
  eigenvectors (`Module.End.HasEigenvector`), `wilsonStringTension`,
  `norm_wilson_loop_expectation_exp`.
- `WilsonVacuumDominance` - `|tr M| <= n` for unitary M (unit-column
  argument, no diagonalization), `norm_wilsonNormalizedGamma_le_one` and
  `wilsonStringTension_nonneg` UNDER the explicit matrix-model hypothesis
  (T4 removes it).
- `EnsembleComplexBridge` - real T3 ensemble = cast of complex link
  ensemble; `linkPartition_wilson_ne_zero`.
- `ReflectionPositivityKernel` (RP-KER) - Mathlib-only. Mirror
  coordinates `(A, C, A)`; `reflectionForm`, `cutKernel`,
  `IsReflectionPositive`; master `reflectionForm_nonneg` (per-cut
  `Matrix.PosSemidef` => RP); `cutKernel_posSemidef_of_factorized` /
  `_of_mixture` + end-to-end corollaries. THE T1/T2 substrate.
- T3-lane stack (Codex, overnight): `GaugeCoreGeneral` (typed walks,
  `hol_gauge`), `PlaquetteCore`, `LatticeEnsemble`, `PlaquetteEnsemble`,
  `WilsonLocalWeight`, `WilsonWeightPositivity` (Route B:
  `wilsonKernel_posSemidef`, `reCharGram_posSemidef`,
  `hadamard_posSemidef` - the Schur-product lemma Mathlib lacks),
  `ReflectionCore`/`ReflectionCutExample`/`ReflectionWalk`/
  `ReflectionEnsemble`/`PlaquetteReflection`/`PlaquetteReflectionEnsemble`/
  `WilsonReflectionCompatibility` (opposite-group bridge, mirror-stable +
  paired families), `TransferPositivity` (compression PSD atoms),
  `TransferGapDefinition` (D12 shell + `finiteMassGap` definition),
  `BanksCasherShadow`, `PolymerKPCriterion` (KP CONDITION only).

## 2. Aristotle registry snapshot (2026-07-04 ~03:50 local)

- `d4a9bd1f` ym-gap-unitarizability: RUNNING at planning time. Task note
  + harvest checklist: `AgentTasks/ym-gap-unitarizability-aristotle-2026-07-04.md`.
- `1d9b5b19` ym1-treegauge-rect: COMPLETE + HARVESTED + INTEGRATED
  (`RectTreeGauge.lean`). Done - do not resubmit.
- `3435c7a3` (Lemma 2a v2): COMPLETE + INTEGRATED. `9627f7ea` (v1):
  CANCELED (normalization bug, documented). Historical.
- `bf525f23` at-m4-closure-audit, `8c4d10be` door2-handoff-audit: NOT YM
  jobs, not this run's business - leave them alone.
- Deep IDLE backlog of older audit/C2 jobs: reconciled during the
  overnight run; do not touch.

## 3. Verified Mathlib API facts (pinned commit; grep-verified, not semantic-search)

- `Matrix.PosSemidef` is Finsupp-quadratic-form-based; USE
  `Matrix.posSemidef_iff_dotProduct_mulVec`,
  `PosSemidef.dotProduct_mulVec_nonneg`,
  `PosSemidef.of_dotProduct_mulVec_nonneg` (LinearAlgebra/Matrix/PosDef.lean).
  `open scoped ComplexOrder` for `0 <= (z : C)`; `star_mul_self_nonneg`
  closes Gram squares; `Finset.sum_mul_sum` aligns double-sum binders.
- Matrix square root: `CFC.sqrt` with `CFC.sqrt_mul_sqrt_self`,
  `CFC.sqrt_nonneg`, `CFC.isUnit_sqrt_iff` (Analysis/Matrix/Order.lean);
  the `Matrix.PosSemidef.sqrt` names are deprecated aliases to these.
- `Module.End.HasEigenvector` / `mem_eigenspace_iff` /
  `hasEigenvalue_of_hasEigenvector` exist and work on `(G -> C) ->l[C] _`.
- Representation theory: `FDRep k G`, `FDRep.character`, `FDRep.char_one`,
  `char_conj`, `char_dual`, `char_orthonormal`,
  `FDRep.finrank_hom_simple_simple`,
  `Representation.linHom.invariantsEquivFDRepHom` exist. There is NO
  `Representation.character`, NO character norm bound
  (`|chi(g)| <= chi(1)`), NO Peter-Weyl, NO cluster expansions - verified
  absent.
- Pi/sum plumbing: `Fin.consEquiv`, `Fintype.sum_prod_type`,
  `Equiv.sum_comp`, `Equiv.prod_comp`, `Finset.prod_univ_sum` +
  `Fintype.piFinset_univ`, `Equiv.sumArrowEquivProdArrow` (+
  `_symm_apply_inl/inr`), `Finset.prod_disjSum` +
  `Finset.univ_disjSum_univ`, `Equiv.Set.sumCompl` (+ `_apply_inl/inr`),
  `Fintype.card_compl_set`, `Set.card_range_of_injective`,
  `Fintype.card_fun`, `List.ofFn_succ`/`ofFn_succ'`, `List.prod_concat`,
  `Fin.rev_succ`/`rev_zero`/`rev_rev`, `Function.Involutive.toPerm`.
  There is NO `List.ofFn_rev` - prove reversal by induction
  (see `IndependentPlaquetteEnsemble.orderedProd_revInv`).

## 4. Gotchas that cost real time (do not rediscover)

1. **Subtype-split instance mismatch.** Splitting `∑ over (nu -> G)` with
   `Equiv.piEquivPiSubtypeProd` + `Set.range` predicates makes `calc`
   blocks fail on `Set.fintypeRange` vs `Subtype.fintype` instance
   mismatch. State split lemmas over ABSTRACT sum types
   (`kappa1 + kappa2`) so instances UNIFY against the goal. Pattern:
   `IndependentPlaquetteEnsemble.sum_pi_sumType_split`.
2. **`omit [Inst] in` placement.** `omit ... in` comes FIRST, then the
   docstring, then the declaration. Docstring before `omit` = parse error
   reported at the docstring's end.
3. **Concrete `OrientedLattice` construction.** Use
   `Sum.elim (fun h => ...) (fun v => ...)` with `.1/.2` projections for
   src/tgt (pattern `match` reduces poorly in unification), and pass
   `(Λ := myLattice)` EXPLICITLY to `Step.fwd`/`Step.rev` in structure
   literals - otherwise elaboration tries to invert `src`/`tgt` on a
   metavariable and fails. Pattern: `RectTreeGauge.rectPlaquette`.
4. **Definitional-interface Aristotle trick.** Design packages so the
   interface equation is DEFINITIONAL (forward map = the quantities
   themselves) and only the hard content (bijectivity, an inequality)
   remains; pin every convention with a `rfl` lemma the prompt forbids
   breaking. `1d9b5b19` closed the general 2D coordinatization in 16
   minutes this way.
5. **`aristotle download`** takes `--destination <file>`; the artifact is
   a GZIP TAR regardless of extension - `tar -xzf`, not Expand-Archive.
6. **Focused-package helper** is invoked
   `pwsh Scripts/prepare_aristotle_focused_submission.ps1 -JobName ...
   -RootModule ... -SourceRoot ... -LeanPath ...`; the "no .lake folder"
   warning at `aristotle submit` is expected and harmless.
7. **File writing on Windows:** UTF-8 no BOM
   (`Set-Content -Encoding utf8NoBOM` or Python `encoding="utf-8"`),
   never PS5 redirection. Pre-commit's end-of-file fixer will mutate
   files DURING a `pre-commit run`; re-add after it runs, and treat a
   "Failed" from a fixer as "it fixed something - check and re-stage".
8. **`lean_local_search` (lean-lsp MCP) is broken** (no system rg).
   Grep `.lake/packages/mathlib/Mathlib/` directly for API verification -
   it is fast and exact. lean-explore semantic search is a LEAD, not a
   fact: it has surfaced APIs that do not exist in the pinned commit
   (the `Representation.character` trap, twice).
9. **Complex order:** `open scoped ComplexOrder` is required for
   `0 <= (z : C)` statements; `Finset.sum_nonneg` then works.
10. **`ᴴ` and `⬝ᵥ`/`*ᵥ` need `open scoped Matrix`** in every file using
    them.
11. **Equation-lemma unfolding:** other-module defs unfold in proofs via
    `simp only [Namespace.defName]` (equation lemma) or `unfold`; `rw`
    does not unfold defs.
12. **Two-failure rule:** two failed Aristotle attempts on one statement
    = park with a failure note. The v1 Lemma 2a bug was caught by a
    trivial-representation sanity check - ALWAYS sanity-check statements
    on the trivial rep / trivial group / smallest case before submitting.

## 5. Oracle state

`Scripts/oracle/validate_lgt_core.py` v0.2, 36/36 green as of the
overnight run. T14 wants v0.3 fixtures (RP small-case, fusion spectrum
numerics, KP constant). Convention anchors: fusion convolution order
`sum_h w(h) chi(h^{-1} A)` is oracle-pinned and load-bearing (naive
`chi(A h)` order is FALSE for non-inversion-symmetric weights).

## 6. Derived-but-unformalized facts (free to use, cite this note)

- **Lasso ordering (T11/Q11):** at tree-links = 1 on `rectLattice`,
  per-row reversed products telescope:
  `P(i,j)|_{t=1} = v(i+1,j) * v(i,j)^{-1}`, so row-major-with-reversed-i
  ordered product over ALL plaquettes = product up the rightmost vertical
  column = boundary holonomy at the slice. General tree values reduce by
  a rooted gauge transformation (componentwise conjugation of plaquette
  coordinates; class function kills it). The naive pointwise identity at
  general tree values is expected FALSE.
- **Cut-plaquette RP reduction (T1/Q1):** cutKernel of a pointwise
  product of weights = Hadamard product of cutKernels; PSD closed under
  Hadamard (`hadamard_posSemidef`); any PSD kernel is a nonnegative
  mixture of rank-one squares (spectral theorem), i.e. exactly
  `cutKernel_posSemidef_of_mixture`'s input.
- **Eigenvalue reality route (T5/Q5):** unitary model => `chi(g^{-1}) =
  conj(chi(g))` => raw fusion scalar self-conjugate under `g -> g^{-1}`
  reindex + weight inversion symmetry => `wilsonNormalizedGamma` real.

## 7. Infrastructure

Neo4j: if lit scripts report connection refused, use the headless start
(memory note `neo4j-headless-start`; do not assume Desktop is running).
MCP servers load at session start; `lean-lsp` goal tools cold-start
`lake serve` (slow first call), its search tools are instant. Gemini/
Claude external reviews only via the `Scripts/autonomous_loop/` wrappers
with full-prompt logging. `git commit` messages end with the agent's
Co-Authored-By trailer per repo convention.
