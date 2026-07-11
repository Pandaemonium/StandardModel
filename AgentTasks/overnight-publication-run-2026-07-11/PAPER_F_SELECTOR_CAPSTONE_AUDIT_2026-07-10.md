# Hostile review-only audit — Paper F selector capstone

Scope: `ChannelRefinementTorsor.lean`, `ChannelNaturalityNoGo.lean`,
`ChannelSelectorRigidity.lean`, `ChannelSelectorUniqueness.lean`,
`FOUR_CHANNEL_CLASSIFICATION_PROGRAM.md`, `MANUSCRIPT_CLAIM_MATRIX.md`.
No audited file was modified. All verdicts below were reproduced with the live
toolchain (Lean v4.28.0 + Mathlib v4.28.0).

## Verdict: **FAIL** (as delivered) / **PASS WITH WORDING** (after packaging repair)

The mathematics of the four surviving torsor/selector theorems is correct and
honestly scoped. The submission nevertheless **FAILs** as delivered because it
does not build and because a core capstone theorem depends on a module that is
absent from the project; the manuscript matrix also advertises numerous results
that are not present here.

---

## FATAL

- **F-1 (build integrity). Three of four Lean files do not compile in this
  project.** `lake build` fails:
  - `ChannelNaturalityNoGo.lean:1` — `unknown module prefix 'PhysicsSM'`
  - `ChannelSelectorRigidity.lean:1` — `unknown module prefix 'PhysicsSM'`
  - `ChannelSelectorUniqueness.lean:1` — `unknown module prefix 'PhysicsSM'`

  The files `import PhysicsSM.Draft.NullEdge.ChannelRefinementTorsor` /
  `...GradedDecompUniqueness`, but the project ships the modules at the repo root
  under the names `ChannelRefinementTorsor`, … (see `lakefile.toml`
  `defaultTargets`/`lean_lib` globs). No `PhysicsSM/` directory or olean exists
  in the search path. Consequence: the entire "naturality no-go", "selector
  rigidity", and "two-grading uniqueness" layer is **unverified in the delivered
  artifact**, and every `#print axioms` / `#guard_msgs` "assumption-footprint
  pin" in those three files **never executes**. Only `ChannelRefinementTorsor`
  builds (confirmed: 8027 jobs, clean).

- **F-2 (missing dependency, not a rename).**
  `ChannelSelectorUniqueness.two_sign_gradings_decomposition_unique` is a wrapper
  whose proof calls `NullEdgeCloser.decomposition_unique`, imported from
  `PhysicsSM.Draft.NullEdge.GradedDecompUniqueness`. **That module does not exist
  anywhere in the project** (`find` returns nothing). This is not fixable by
  correcting a prefix: the load-bearing eigenspace/direct-sum uniqueness theorem
  is simply not in the submission. The "conditional two-grading uniqueness"
  headline is therefore **unsubstantiated as delivered** — only its wrapper
  bookkeeping (`sgn`, `sgn_grade_injective`, the `P + 2•Q` combination) can be
  checked; the mathematical content it claims to reuse cannot.

## MAJOR

- **M-1 (prose ≫ artifact). `MANUSCRIPT_CLAIM_MATRIX.md` and
  `FOUR_CHANNEL_CLASSIFICATION_PROGRAM.md` assert as "landed and guarded" /
  "kernel-checked" a large set of declarations that are absent from this
  project:** `CarrierRigidity.square_decomposition`,
  `parity_decomposition_unique`, `square_oddPart/evenPart`,
  `Concrete.shared_type_but_distinct`, `NullEdgeCloser.split_not_forced`,
  `FourChannelRigidity.four_channels_linearIndependent`,
  `carrier_square_coefficients_recovered`, the whole `ChannelShearModuli`
  module (`shear_add`, `sum_mix_shear`, `mixed_shear_injective`), and the report
  `FOUR_CHANNEL_CLASSIFICATION_REVIEW.md`. Row `F-H0` and the F1/F2/F4 "Status:
  CLOSED" lines are therefore **not backed by the delivered artifact**. Any
  paper drawing on this matrix would cite theorems reviewers cannot run.

- **M-2 (capstone gate not met).** The program's own "Publication gate"
  (explicit category/decomposition object/equivalence relation; moduli
  *classified* not merely *witnessed*; a selector theorem with necessary &
  sufficient conditions for a unique orbit or a sharp no-go; two inequivalent
  nonzero examples + one control; physical vs information selector comparison)
  is **not met by the four present files**. What is present is a moduli +
  obstruction package, not a classification theorem (see Q6 below).

## MINOR

- **m-1.** `ChannelNaturalityNoGo.no_unique_invariant_preferred` (and hence
  `no_unique_type_invariant_refinement`) hypothesizes invariance under **every**
  group element (`hinv : ∀ h p, preferred (h +ᵥ p) ↔ preferred p`), but the
  proof only uses invariance under the single chosen nonzero `g`. The theorem is
  therefore provable from a strictly weaker hypothesis. This is sound and fits
  the intended "maximal/full symmetry" framing, but the stated hypothesis is
  stronger than load-bearing; the abstract should say "full translation
  invariance is *assumed*", not "*required*".

- **m-2.** `selector_rigid_iff_injective` is substantive but lightweight: the
  non-trivial direction is exactly the surjectivity of `difference` onto
  `ZeroSumShift V` (guaranteed by inhabitedness of the fibre + torsor structure).
  Do not sell it as a deep rigidity theorem; it is an exact restatement of
  fibre-separation as group-injectivity, riding on the torsor.

- **m-3.** `invariant_selector_constant` needs no nontriviality and asserts
  none — correct, but the prose should not imply it is a no-go; it is the
  positive "all-invariant scores are constant" lemma feeding the no-go.

- **m-4.** `MANUSCRIPT_CLAIM_MATRIX.md` header describes "Paper A" and lists
  A-/D-rows; the Paper F material is a single overloaded row `F-H0` bundling ~15
  declarations. Split per-theorem before using in Paper F prose.

## CLEAR (verified sound, honestly scoped)

- `ChannelRefinementTorsor` builds clean; `AddTorsor` instance, freeness,
  transitivity (`existsUnique_translate`), and `refinement_not_unique_of_nonzero`
  are correct. Docstrings honestly disclaim cross-channel relations, quotient,
  gauge, locality, positivity.
- The math of `ChannelNaturalityNoGo` and `ChannelSelectorRigidity` was
  re-verified independently in a scratch module with the import prefix corrected
  to the actual module name: **all declarations elaborate with no errors**
  (`invariant_selector_constant`, `no_unique_invariant_preferred`,
  `no_unique_type_invariant_refinement`, `selector_rigid_iff_injective`,
  `rationalShift`, `rationalShift_injective`, `no_finite_selector_rigidifies`).
  `sgn_grade_injective` also elaborates independently.

---

## Answers to the seven audit questions

1. **Fixed-total fibre = complete type-only fibre?** Yes, at the stated scope.
   `Refinement S := {b : Fin 3 → V // ∑ b = S}` is genuinely the full set of
   ordered triples in the ambient constraint space `V` satisfying the single
   fixed-total relation, and its torsor group `ZeroSumShift V` is the full
   zero-sum subgroup (a copy of `V²`). Completeness is *relative to*: (a) each
   channel independently ranging over the *same* `V`, and (b) only the total
   constraint. The docstring correctly disclaims any further cross-channel
   relation or quotient. Accurate. **CLEAR.**

2. **`invariant_selector_constant` / `no_unique_type_invariant_refinement` say
   what the prose claims, and use nontriviality essentially?** Yes.
   `invariant_selector_constant` is the exact "torsor-invariant ⇒ constant"
   statement (axiom-free) and correctly needs no nontriviality.
   `no_unique_type_invariant_refinement` uses `v ≠ 0` essentially via
   `nontrivial_shift_of_nonzero` to produce a nonzero `g`; with `g = 0` the
   argument collapses. Matches "if the ambiguity group has a nonzero direction,
   no fully translation-invariant predicate can uniquely select". **CLEAR**
   (see m-1: full invariance assumed, stronger than used).

3. **Is `selector_rigid_iff_injective` substantive?** Yes, not a definitional
   restatement: the forward direction requires that every group element is a
   `difference` of two refinements (torsor surjectivity + inhabited fibre). It is
   a genuine, if lightweight, translation between fibre-rigidity and
   group-injectivity. **CLEAR** (see m-2 on how much weight to put on it).

4. **ℚ-module hypothesis + nonzero witness sufficient and essential?** Yes to
   both, in both theorems. Sufficient: `Module ℚ V` gives `NoZeroSMulDivisors`,
   so `t • v = 0 ∧ v ≠ 0 ⇒ t = 0`, hence `rationalShift v` injects ℚ; composing
   with an injective finite-valued `sigma` contradicts
   `not_injective_infinite_finite`. Essential: without a torsion-free/ℚ-module
   direction a nonzero `v` can have finite orbit, and a finite target *can*
   rigidify — the docstring states this correctly. The explicit nonzero witness
   `v ≠ 0` is load-bearing (a zero direction gives the trivial shift). **CLEAR.**

5. **Any overgeneralized finite-target / full-invariance / physical-selector /
   quotient / canonicity claim?** Inside the Lean docstrings: **no** — they are
   unusually disciplined (naturality file explicitly denies ruling out physical
   selectors; uniqueness file flags itself conditional; torsor file disclaims
   quotient/gauge/locality/positivity). In the **markdown**: **yes** — see M-1;
   the matrix/program advertise absent results as verified and mark F1/F2/F4
   "CLOSED" on the strength of modules not in the artifact.

6. **Do the combined results earn a standalone classification theorem section?**
   **No, not yet.** As delivered (and even with imports repaired) the four files
   give a *moduli-and-obstruction* section: the type-only fibre is a torsor, all
   fully-invariant scores are constant, additive rigidity = group-injectivity,
   and no finite additive label can rigidify a ℚ-direction. Every result is a
   no-go or a conditional. The exact mathematical object still **necessary** for
   a paper is a *constructed intrinsic physical second selector/grading* (an
   existence theorem — e.g. solder/word degree or edge exchange proven intrinsic,
   commuting with chirality, with separated joint spectrum) **plus** an explicit
   selector-preserving equivalence relation and forgetful map whose fibres are
   the moduli — together with the carrier-square decomposition results
   (`CarrierRigidity.*`) that are currently only referenced. Until an existence /
   selection theorem accompanies the obstructions, the honest section title is
   "residual underdetermination of channel refinements", not "classification".

7. **Strongest safe abstract / conclusion sentences** (see next section).

---

## Theorem-by-theorem table

| Declaration | File | Builds here? | Claim vs statement | Verdict |
| --- | --- | --- | --- | --- |
| `Refinement`, `ZeroSumShift`, `translate`, `difference` | Torsor | ✅ | Faithful; full fixed-total fibre + full zero-sum group | CLEAR |
| `refinementAddTorsor` | Torsor | ✅ | Genuine `AddTorsor`; free+transitive | CLEAR |
| `existsUnique_translate` | Torsor | ✅ | Transitivity/freeness, exact | CLEAR |
| `refinementEquivZeroSumShift` | Torsor | ✅ | Fibre ≃ group after base choice | CLEAR |
| `refinement_not_unique_of_nonzero` | Torsor | ✅ | Nonzero direction ⇒ non-singleton | CLEAR |
| `invariant_selector_constant` | NaturalityNoGo | ❌ build | Torsor-invariant ⇒ constant; correct (verified in scratch) | CLEAR / m-3 |
| `no_unique_invariant_preferred` | NaturalityNoGo | ❌ build | Correct; full-invariance assumed but only single-g used | MINOR (m-1) |
| `no_unique_type_invariant_refinement` | NaturalityNoGo | ❌ build | Correct; `v≠0` essential | CLEAR / m-1 |
| `selector_rigid_iff_injective` | SelectorRigidity | ❌ build | Substantive iff (torsor surjectivity), lightweight | CLEAR / m-2 |
| `rationalShift`, `rationalShift_injective` | SelectorRigidity | ❌ build | ℚ-module + `v≠0` sufficient & essential; correct | CLEAR |
| `no_finite_selector_rigidifies` | SelectorRigidity | ❌ build | Correct; ℚ-hypothesis essential | CLEAR |
| `sgn`, `sgn_grade_injective` | SelectorUniqueness | ❌ build | Correct (verified in scratch) | CLEAR |
| `two_sign_gradings_decomposition_unique` | SelectorUniqueness | ❌ build | Depends on **absent** `NullEdgeCloser.decomposition_unique` | FATAL (F-2) |

("Builds here? ❌" = fails only due to F-1/F-2 packaging; the underlying math of
every row except the last was independently re-verified.)

---

## Exact replacement language

- **Manuscript matrix F-H0 / program F1–F4 "Status: CLOSED".** Replace with:
  "In the delivered module set, the type-only fixed-total refinement fibre is
  proved to be an additive torsor over its zero-sum shift group, and three
  selector obstructions are proved (full-invariance ⇒ constant; additive
  rigidity ⇔ injectivity on shifts; no finite additive selector rigidifies a
  rational-module direction). The carrier-square decomposition results, the
  shear-moduli subgroup, and the eigenspace uniqueness theorem
  (`NullEdgeCloser.decomposition_unique`) are **not included in this module set**
  and must be supplied before the F0/F2 rows may be cited."

- **`ChannelSelectorUniqueness` docstring** ("reuses … through
  `NullEdgeCloser.decomposition_unique`"). Add: "This dependency is external and
  must be present for the theorem to compile; it is not part of this file's
  verified footprint."

- **Safe abstract (strongest defensible):** "Once the chirality-even
  carrier-square sector and its per-channel linear type constraints are fixed,
  the ordered three-channel refinements with a prescribed total form an additive
  torsor over the group of zero-sum admissible shifts. We prove three consequent
  selector obstructions: any score invariant under the full residual translation
  is constant; an additive selector distinguishes all refinements iff it is
  injective on the shift group; and when the retained type space contains a
  nonzero rational-module direction no finite-valued additive selector can do so.
  We further record a *conditional* uniqueness result: two internal
  decompositions carrying the same pair of sign gradings coincide. We do not
  construct an intrinsic physical second selector, and we do not claim
  canonicity of the four named channels."

- **Safe conclusion:** "These results delimit rather than resolve the
  classification: the type-only ambiguity is a torsor whose symmetry any
  successful selector must break, and finite invariants provably cannot break it.
  A paper-level classification additionally requires (i) an explicit
  selector-preserving equivalence and forgetful map, and (ii) a constructed
  intrinsic second grading proved to select a unique orbit; both remain open."

- **Never write** "classification", "canonical channels", or "CLOSED" for the
  present artifact; use "moduli/torsor structure and selector obstructions".

---

## Recommendation

**FAIL** as delivered. To reach **PASS WITH WORDING**: (a) fix the three import
prefixes to the actual module names (or add the `PhysicsSM/Draft/NullEdge/`
source layout the imports expect) so `lake build` and the axiom pins run; (b)
include the `GradedDecompUniqueness` / `NullEdgeCloser.decomposition_unique`
dependency (or downgrade `two_sign_gradings_decomposition_unique` to an explicit
hypothesis) ; (c) purge from the matrix/program every "CLOSED"/"kernel-checked"
citation of a declaration not present in the submission; (d) adopt the
abstract/conclusion language above. The core torsor+obstruction mathematics is
sound and honestly scoped, but it is a moduli/obstruction section, not a
classification theorem.
