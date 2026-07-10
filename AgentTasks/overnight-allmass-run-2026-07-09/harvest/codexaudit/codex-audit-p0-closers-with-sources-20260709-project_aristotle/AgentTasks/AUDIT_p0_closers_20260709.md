# Audit — P0 closers (with sources), 2026-07-09

Job: `codex-audit-p0-closers-with-sources-20260709`.
Targets (all `import Mathlib`, under `PhysicsSM/Draft/NullEdge/`):
FiniteCPT, RPSelectsLorentzian, BargmannCP, GradedDecompUniqueness, FamilyRankNoGo.

## Build / footprint

All five modules build:

```
lake build PhysicsSM.Draft.NullEdge.FiniteCPT PhysicsSM.Draft.NullEdge.RPSelectsLorentzian \
  PhysicsSM.Draft.NullEdge.BargmannCP PhysicsSM.Draft.NullEdge.GradedDecompUniqueness \
  PhysicsSM.Draft.NullEdge.FamilyRankNoGo
```

Result: success (only style/lint warnings: unscoped `set_option`, long lines, flexible-tactic
hints). No `sorry`/`admit`; no `axiom` declarations (grep hits are docstring text). Every
headline theorem is build-guarded by `#print axioms` to depend only on
`[propext, Classical.choice, Quot.sound]`.

Severity legend: HIGH = false/vacuous claim; MEDIUM = docstring outruns statement or hollow
encoding; LOW = minor (unused hypothesis, definitional-input); INFO = scope caveat to keep.

---

## FiniteCPT.lean — CLEAN

Explicit `ℂ⁴ = spin⊗color` witness with fixed `Gamma`, `Jmet`, `Dop`, Krein `sharp`, antilinear
`Theta v = Rmat *ᵥ star v`.

- `Theta_antiunitary` — genuine: bundles additivity, antilinearity (`Θ(c•v)=conj c • Θv`), and
  Krein-isometry `⟪Θv,Θw⟫_J = conj⟪v,w⟫_J`. "Antiunitary" here is w.r.t. the *indefinite* Krein
  form (`Jmet` has trace 0), and the statement/docstring correctly qualify it as
  Krein-isometric. Not vacuous (form is genuinely indefinite).
- `Theta_conjugates_D_to_sharp` — genuine `Θ D Θ⁻¹ = D^#` (via `Theta_involutive`, so `Θ⁻¹=Θ`).
- `spectrum_conjugate_paired` — genuine: eigenvalue `λ` ⇒ `conj λ` eigenvalue, and it **includes
  `Θ v ≠ 0`** (non-degeneracy fixture present). Eigenvectors genuinely exist (`Dop_sq = -1`,
  spectrum `{i,-i}`), so not vacuous.

No hidden assumptions; no false shape. Scope caveat to keep in docs (already stated): this is the
**explicit `C⁴` witness only**, not an arbitrary-carrier CPT theorem.

---

## RPSelectsLorentzian.lean — CLEAN (with scope caveats)

Two-site (`Fin 2`), single-mode OS toy; `reflGram = C 1 0`.

- `reflGram_eq` — genuine closed form `(a²-1)⁻¹`.
- `oneTime_reflectionPositive` — genuine: proves **both** `ReflectionPositive` **and**
  `Nondegenerate` (strict `0 < reflGram`). Non-degeneracy fixture is present, not missing.
- `twoTime_reflectionPositive_fails` — genuine: exhibits admissible `k` with `reflGram < 0`.
- `oneTime_actionKernel_posDef` / `twoTime_actionKernel_not_posDef` — genuine stability bonus.

Findings:
- **LOW** — `oneTime_reflectionPositive` hypothesis `_h0 : sig 0 = true` is genuinely unused
  (correctly underscore-prefixed; it is a convention/labeling hypothesis for the (1,3)
  signature). Acceptable; keep for signature specification.
- **INFO (scope caveats to keep in docs):**
  (i) The OS reflection Gram is modeled as the single scalar `C 1 0` of a 2-site single-mode
  Gaussian toy — this is **not** full OS reconstruction.
  (ii) Direction `0` is postulated to be a time direction (`sig 0 = true` convention), so the
  "signature selection" distinguishes **exactly-one-time vs ≥2-time**; it does not address the
  all-space (0-time / Euclidean) case.
  (iii) `twoTime_reflectionPositive_fails` in fact does not even use `sig 0 = true` (any time
  direction `j ≠ 0` breaks RP), i.e. the theorem is slightly stronger than its name suggests —
  no defect.

No false shape, no vacuity.

---

## BargmannCP.lean — CLEAN algebra; one docstring-outruns-statement item

Two-component spinors; `ip`, `bargmann`, Bloch components `bx/by'/bz`, `bdot`, `btriple`.

- `bargmann_CP_odd`, `bargmann_CP_genuine_iff` — genuine (conjugation; `Im B ≠ 0` iff not
  CP-invariant).
- `bargmann_bloch_re`, `bargmann_bloch_im` — genuine exact homogeneous identities.
- `bargmann_bloch_unit` — genuine (unit-ray specialization).
- `bargmann_tan_arg_unit` — genuine: `tan(arg B) = btriple / (1 + dots)` (from
  `Complex.tan_arg`, i.e. `im/re`; identity holds even when `re = 0`, so not vacuous).

Findings:
- **MEDIUM (docstring outruns statement):** `bargmann_tan_arg_unit`'s docstring asserts the RHS
  "is exactly the Van Oosterom–Strackee expression for `tan(Ω/2)`" and that "`arg B` equals
  *half* that solid angle." Only the **algebraic** `tan` identity is formalized. No solid angle,
  geodesic triangle, or `Ω/2` object is defined or related; no branch/`arg`-normalization is
  proven. The solid-angle reading must remain **commentary / scope caveat**, not a claimed
  result. Likewise the file header phrase "celestial solid angle" is interpretation only.
- **INFO:** file omits the `autoImplicit false` / `relaxedAutoImplicit false` header the other
  four use; namespace `Bargmann` is somewhat generic (low collision risk in a Draft file).

---

## GradedDecompUniqueness.lean — CLEAN

- `blocks_eq_eigenspaces` — genuine, fully general (`Field K`, `Module K V`, `DirectSum.IsInternal`,
  injective grades `μ`, grading operator `D`): each block is forced to `D.eigenspace (μ i)`.
- `decomposition_unique` — genuine consequence.
- `split_not_forced` — genuine no-go: two distinct complementary decompositions of `ℝ²`.

The "selecting axiom" is a **hypothesis** (existence of `D` acting as distinct scalars), correctly
NOT an `axiom` declaration. Honest scope caveat (already stated): this is a **generic** graded
direct-sum/eigenspace uniqueness result; it is **not** carrier-specific uniqueness of `2(D#D)` and
carries no formal link to that carrier. No vacuity.

---

## FamilyRankNoGo.lean — genuine core, but hollow candidate encodings

- `completionCount_eq`, `three_generations_iff` — genuine but definitional (see LOW below).
- `forcing_iff_rankfixing` / `rankfixing_forces` — genuine (elementary) logic; this is the real
  load-bearing content and is fully general (independent of the specific encodings). Honest.
- `three_generations_not_forced` — genuine bundle of the above plus the three `not_forces`.

Findings:
- **MEDIUM (hollow predicate / weak encoding):** the candidate-structure predicates are near-
  vacuous, so the corresponding no-go's carry little content about the *actual* structures:
  - `JordanStruct n := jordanDim 3 8 = 27 ∧ n = n` is **independent of `n`** and contains the
    literal tautology `n = n`; it is effectively `True`. `jordan_not_forces` is therefore
    near-vacuous.
  - `TrialityStruct n` is true for **every** `n` (`Module.finrank ℚ (Fin n → ℚ) = n` always holds;
    the other two conjuncts are constant facts). `triality_not_forces` is likewise near-vacuous.
  - `AnomalyStruct n` is the exception: a genuine nontrivial constraint (`∃` nonzero `q` with
    `∑ q = 0` and `∑ q³ = 0`); `anomalyStruct_three` is a real witness.
  The header's "each candidate structure, faithfully formalized" **overstates** the fidelity of
  (a) Jordan and (c) triality — they are numeric proxies, not faithful encodings. The honest
  reading is: the three `*_not_forces` are illustrative; the genuine no-go is
  `forcing_iff_rankfixing` (any forcing predicate is logically equivalent to `n = 2`).
- **LOW (definitional input):** `Completions n := Fin (n+1)`, so `completionCount_eq` ("the
  null-edge count is `n+1`") is true **by definition** — the enumeration law is an input/model,
  not derived from null-edge structure. Honestly flagged in the docstring ("we model it
  directly").

---

## Cross-cutting

- **Namespaces / anchors / provenance:** distinct namespaces per file (`ConjectureR`,
  `NullEdgeRP`, `Bargmann`, `NullEdgeCloser`, `FamilyRankNoGo`); all under
  `PhysicsSM/Draft/NullEdge` ("Draft" signals non-final). No external claim-numbering anchors;
  no cross-file provenance drift observed. `Bargmann` is the only mildly generic namespace.
- **Missing non-degeneracy fixture:** not an issue — where relevant (FiniteCPT
  `spectrum_conjugate_paired`, RP `oneTime_reflectionPositive`) strict non-degeneracy is included.
- **No stronger claims invented.** All intended honest readings in the request are consistent with
  the formalized statements, with the MEDIUM caveats above (BargmannCP solid-angle interpretation;
  FamilyRankNoGo hollow Jordan/triality encodings) kept as documentation-only scope.
