# LIT D: Gate D - Strong L2 convergence of normalized cell-average projections (2026-07-12)

## Search status
- Date: 2026-07-12 (Pacific Time)
- Local Neo4j query attempted with `Scripts/lit/neo4j_paper_search.py` in both modes:
  - abstract mode
  - `--chunks` mode
- Result: both attempts failed with `ConnectionRefusedError` on `127.0.0.1:7687` (`NEO4J` unavailable in this environment).
- Per AGENT instruction, I proceeded with Lean-reference and web/paper search only.

## Ranked sources (highest relevance first)

1. **Mathlib core (reusable directly):** `Mathlib.Probability.Martingale.Convergence`
   - Source: https://leanprover-community.github.io/mathlib4_docs/Mathlib/Probability/Martingale/Convergence.html
   - Exact items:
     - `MeasureTheory.Integrable.tendsto_eLpNorm_condExp`
     - `MeasureTheory.Integrable.tendsto_ae_condExp`
     - `MeasureTheory.tendsto_eLpNorm_condExp`
     - `MeasureTheory.tendsto_ae_condExp`
     - `MeasureTheory.Submartingale.tendsto_eLpNorm_one_limitProcess`
     - `MeasureTheory.Martingale.ae_eq_condExp_limitProcess`
   - Relevance: directly states L^1 convergence of conditional expectations for a filtration; includes Lévy upward theorem.
   - Reusable in Lean as-is for filtration-based projections.

2. **Mathlib core (reusable directly):** `Mathlib.MeasureTheory.Function.ConditionalExpectation.Basic`
   - Source: https://leanprover-community.github.io/mathlib4_docs/Mathlib/MeasureTheory/Function/ConditionalExpectation/Basic.html
   - Relevant lemmas:
     - `MeasureTheory.condExp_condExp_of_le` (tower property)
     - `MeasureTheory.condExp_indicator`
     - `MeasureTheory.condExpInd_disjoint_union`
     - `MeasureTheory.condExpL2` and `MeasureTheory.MemLp.condExpL2_ae_eq_condExp'`
   - Relevance: these are the machinery to identify finite-cell averages as conditional expectation/orthogonal projection steps and prove L^2-norm contractivity.
   - Reusable with minimal scaffolding.

3. **Mathlib core (conditionally reusable; needs domain-specific reduction):** `Mathlib.MeasureTheory.Integral.Average`
   - Source: https://leanprover-community.github.io/mathlib4_docs/Mathlib/MeasureTheory/Integral/Average.html
   - Relevant lemmas:
     - `MeasureTheory.average`, `MeasureTheory.setAverage`, and algebraic identities around averages.
     - `MeasureTheory.setIntegral_setAverage`, `MeasureTheory.setAverage_eq`, `MeasureTheory.laverage` counterparts.
   - Relevance: exact notation and simplification lemmas for normalized averages on sets (cell averages), but no ready-made theorem for convergence of refining-cell averages.
   - **Clean-room needed** for convergence layer.

4. **Mathlib core (conditionally reusable):** `Mathlib.MeasureTheory.Covering.DensityTheorem`
   - Source: https://leanprover-community.github.io/mathlib4_docs/Mathlib/MeasureTheory/Covering/DensityTheorem.html
   - Relevant lemmas:
     - `IsUnifLocDoublingMeasure.ae_tendsto_average`
     - `IsUnifLocDoublingMeasure.ae_tendsto_average_norm_sub`
   - Relevance: gives Lp/Lebesgue differentiation-style convergence for moving balls in doubling spaces; not directly finite-boxs in filtration context but useful for alternate proof architecture.
   - Needs additional geometry assumptions.

5. **Mathlib core (reusable depending on setup):** `Mathlib.Analysis.InnerProductSpace.MeanErgodic`
   - Source: direct Lean declarations for:
     - `LinearMap.tendsto_birkhoffAverage_of_ker_subset_closure`
     - `ContinuousLinearMap.tendsto_birkhoffAverage_orthogonalProjection`
   - Relevance: von Neumann mean-ergodic template in Hilbert spaces; good for finite-box/group averaging when a linear contraction/averaging operator can be built.
   - Useful for clean-room bridge if Gate D is recast as amenable-group/cell-shift averaging.

6. **Mathlib core (reusable as support):** `Mathlib.MeasureTheory.Group.FoelnerFilter`
   - Source: https://leanprover-community.github.io/mathlib4_docs/Mathlib/MeasureTheory/Group/FoelnerFilter.html
   - Relevant lemmas:
     - `isFoelner_iff_tendsto` (`to_additive` form also present)
     - `isFoelner_maxFoelner`, `isAddFoelner_maxAddFoelner`
   - Relevance: formalizes Følner language and mean-limit notions but does not itself prove the Gate-D convergence statement; useful if proving finite-box expansion gives a Følner family.

7. **Mathlib reference (support for Lp mode transfer):** `Mathlib.MeasureTheory.Function.MemLp`
   - Source: declaration IDs indicate (`MeasureTheory.tendsto_Lp_of_tendstoInMeasure`, `tendstoInMeasure_of_tendsto_eLpNorm`, Vitali variants).
   - Relevance: converts a.e./in-measure convergence plus UI/UT assumptions to L^p norm convergence; needed if Gate D is stated as Bochner L^2 from conditional-expectation a.e. convergence.

8. **Physics/math publication (authoritative external):** A formalism note in arXiv
   - Source: https://arxiv.org/abs/2212.05578
   - Relevance: documents that Doob/levy/martingale convergence results are now in mathlib; this is strong provenance for using martingale route and matching Gate-D style hypotheses.

9. **External ergodic-theory references for finite-box/Følner averaging (context only):**
   - `archive.ymsc.tsinghua.edu.cn/.../MeanErgodicTheorem-revised.pdf` (Theorem 1.1, measure-space von Neumann mean ergodic theorem for right Følner sequences.)
   - `mat.univie.ac.at/.../Hochman_Ergodic_Notes.pdf` (Theorem: Følner sequence in amenable group gives L² mean ergodic theorem).
   - `ScienceDirect: Recurrence and the minimal center of attraction with respect to a Følner sequence` (Theorem 2.3 mean ergodic form and tempered Følner conditions for pointwise versions).
   - These are relevant for translating finite expanding boxes into a Følner-sequence averaging theorem, then mapping back to Lean APIs.

## Reusable Lean API vs clean-room split for Gate D

### Reusable with direct import
- Treat projections as `condExp` along an increasing filtration (`ℱ n`): use `condExp`, `condExp_condExp_of_le`, tower arguments, then apply `MeasureTheory.Integrable.tendsto_eLpNorm_condExp` (currently stated for L^1; then use `condExpL2`/`MemLp.condExpL2_ae_eq_condExp'` + `tendsto_Lp_of_tendstoInMeasure` where Bochner-valued L² is needed).
- Use finite-set identities (`condExp_indicator`, `condExpInd_disjoint_union`, `condExpIndL1_*`) for piecewise-constant cell formulas.
- Use `setAverage`/`laverage` notation and integral lemmas from `Integral.Average` for normalized cell formulas.

### Needs clean-room proof work
- No current source gives a theorem exactly matching **“normalized finite-cell averages under expanding finite boxes converge strongly in L²”**.
- Need a task-specific theorem that identifies your cell projections with either:
  1) martingale/filtration conditional expectations, or
  2) a Følner averaging operator on L²,
  and then applies mean-ergodic machinery.
- Must also explicitly prove the assumptions for your project’s convention (finite-volume truncation semantics, boundary-normalization convention, Bochner target space).

## PhysLean
- Search in `Physlib` for the above was mostly limited to inner-product-space aliases; no immediate theorem for the Gate D conditional-expectation/finite-box statement was surfaced.

## Suggested next proof design
1. Encode box-cell projections as expectations on the sigma-algebra generated by the partition cells.
2. Prove they form an increasing filtration.
3. Use `MeasureTheory.Integrable.tendsto_eLpNorm_condExp` plus `MemLp.condExpL2_ae_eq_condExp'` + Vitali bridge lemmas to upgrade to Bochner-valued L² if needed.
4. If boxes are presented as group translates/averages, prove Følner property and use amenable mean-ergodic transport (`LinearMap.tendsto_birkhoffAverage...`/`ContinuousLinearMap.tendsto_birkhoffAverage_orthogonalProjection`) for clean-room extension.
