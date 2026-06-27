# Wave 6: native-decision structuralization and performance audit

**Generated 2026-06-26. Lean-backed where marked "done".**

This report discharges the Wave 6 job
(`AgentTasks/context-packs/null-edge-wave6-gates-native-20260626-20260626-105818.md`,
and the job spec in `PROMPT.md`): locate every use of the native decision
tactic, classify each, structurally replace the newly integrated null-edge use
that motivated the job, scan for slow `decide`/`+decide` candidates, and set a
repo policy.

Throughout, the spaced form `n a t i v e _ d e c i d e` is used in prose so the
placeholder/escape-hatch scan stays focused on kernel-relevant code (per
`AGENTS.md` "Text encoding and formatting"). The raw token appears only in
executable Lean.

## 0. Headline result

The newly integrated null-edge file
`PhysicsSM/Draft/NullEdgeSuperDiracSignAudit.lean` had four native-evaluation
proofs, all on tiny `Matrix (Fin 2) (Fin 2) ℤ` fixtures. **All four are now
replaced by structural, kernel-checked proofs** (entrywise expansion via
`Matrix.mul_apply` + `Fin.sum_univ_two`). After the change the whole file
depends only on `propext`, `Classical.choice`, `Quot.sound` - no
`Lean.ofReduceBool` / `Lean.trustCompiler`. This is the ideal outcome named in
the job: a structural proof that avoids both slow kernel `decide` and native
evaluation, with no statement weakening.

Verification:

- `lake build materials.PhysicsSM.Draft.NullEdgeSuperDiracSignAudit` - built
  (the rest of the repo has pre-existing unrelated failures; see §5).
- `#print axioms` on the four edited theorems and on
  `example_anticommuting_minus` / `example_extra_term_when_CPh_fails`:
  `[propext, Classical.choice, Quot.sound]`.

## 1. Inventory of native-decision tactic uses

After the conversion above there are **354 native-decision tactic uses across 40
Lean files** (prose mentions in `PhysicsSM/NullStrand/Audit*.lean`, which only
*audit against* the tactic, are excluded). Split:

- **Draft layer** (`PhysicsSM/Draft/**`): 213 uses, 14 files.
- **Trusted-tree fixtures** (`PhysicsSM/Coding/**`, `PhysicsSM/Algebra/**`,
  `PhysicsSM/Lie/**`): 141 uses, 26 files.

Top files by count:

| file | uses |
|---|---|
| `Coding/ConstructionAThetaWeightBridge.lean` | 45 |
| `Draft/Sedenions/ReedMullerCode.lean` | 26 |
| `Draft/Sedenions/AnomalyCancellationAnalogue.lean` | 26 |
| `Draft/Sedenions/CocycleQuadraticPhase.lean` | 25 |
| `Draft/Sedenions/GenerationCancellationGeometry.lean` | 24 |
| `Draft/Sedenions/BarnesWallFirstShell.lean` | 21 |
| `Draft/Sedenions/S3PsiAction.lean` | 18 |
| `Draft/Sedenions/FanoComplementGeneration.lean` | 17 |
| `Coding/E8SpherePackingMatrixBridge.lean` | 15 |
| `Coding/E8ThetaSeries.lean` | 14 |
| `Draft/Sedenions/GL32Action.lean` | 13 |
| `Algebra/Octonion/IntegralOctonion.lean` | 12 |
| `Draft/Sedenions/CayleyDicksonSignTable.lean` | 10 |
| (… 27 further files, 1-9 each) | |

Every trusted-tree file carries a "Finite-computation trust note" docstring and
`set_option linter.style.nativeDecide false`, and explicitly records that the
tactic introduces `Lean.trustCompiler` / `Lean.ofReduceBool`. So the repo is
already honest about these being draft-trust, not kernel-trust, exactly per
`AGENTS.md` "Trusted vs draft code".

## 2. Classification

Using the four job categories:

### (a) Draft-only finite computation - temporary native evaluation acceptable
All of `PhysicsSM/Draft/Sedenions/**` (Reed-Muller, anomaly-cancellation
analogue, cocycle quadratic phase, generation/cancellation geometry, Barnes-Wall
first shell, S3/ψ action, Fano complement, GL(3,2) action, Cayley-Dickson sign
table, PSL(2,7), stabilizer plaquettes/moonshot) plus
`Draft/ConstructionAThetaBoundedShellAristotle.lean` and
`Draft/E8SpherePackingImported.lean`. These are exploratory finite checks over
combinatorial fixtures; native evaluation is acceptable as a draft speed measure
and is already documented as draft-trust.

### (b) Trusted / publication-facing - structural proof needed before publishing
`PhysicsSM/Lie/Exceptional/E8.lean` (Cartan-matrix facts incl. determinant one)
and the `Coding/**` + `Algebra/Octonion/**` "Status: trusted" modules. These sit
in the trusted directory tree but currently rely on native evaluation, so by the
repo's own definition they are **draft-trust, not kernel-trust**, and must not be
promoted to fully-trusted/published until the native tactic is replaced. They are
the genuine structuralization backlog.

### (c) Coding/E8/Hamming fixture - native eval as an oracle-like finite check
`Coding/ConstructionAThetaWeightBridge.lean` (theta/weight coefficient counts),
`Coding/E8ThetaSeries*.lean`, `Coding/E8SpherePackingMatrixBridge.lean`,
`Coding/E8RootBridge*.lean`, `Coding/HammingE8*.lean`,
`Coding/Hamming844*.lean`, `Coding/HammingSelfDual.lean`,
`Coding/HammingWeightEnumerator.lean`, `Algebra/Octonion/IntegralOctonion.lean`
(root counts 240 = 112 + 128, `Nodup`, `IsE8RootD` membership),
`Algebra/Octonion/E8Weyl*.lean`. Here native evaluation functions as an
oracle-grade finite check (large enumerations: the 240 E8 roots, the [8,4,4]
Hamming code and its 16 codewords, weight enumerators). Structural replacement is
possible but expensive; leaving them on native eval in the interim is acceptable
*because they are explicitly labelled draft-trust*.

### (d) Candidate for immediate structural replacement
`PhysicsSM/Draft/NullEdgeSuperDiracSignAudit.lean` - the motivating null-edge
file. **Done** (§0, §3). It is the only file whose native uses were small enough
(2×2 integer matrices) to make a fast structural proof unambiguously the right
call, and it is the file the Wave 6 context pack points at.

## 3. The structural replacement (motivating use), in detail

File: `PhysicsSM/Draft/NullEdgeSuperDiracSignAudit.lean`, section
`MatrixExamples`. Statements are **unchanged**; only the proof terms changed.

| declaration | before | after |
|---|---|---|
| `σz_sq` | `native_decide +revert` | `ext i j; fin_cases i <;> fin_cases j <;> simp [σz, Matrix.mul_apply, Fin.sum_univ_two]` |
| `example_commuting_plus` | `native_decide` | `refine ⟨?_, ?_⟩ <;> ext i j <;> fin_cases i <;> fin_cases j <;> simp [σz, Phdiag, Matrix.mul_apply, Fin.sum_univ_two]` |
| `example_anticommuting_minus` | `native_decide` | `refine ⟨?_, ?_⟩ <;> ext i j <;> fin_cases i <;> fin_cases j <;> simp [σz, σx, Matrix.mul_apply, Fin.sum_univ_two]` |
| `example_extra_term_when_CPh_fails` | `native_decide` | witness the `(0,1)` entry of each side via `congrFun … ; simp [σz, σx, Matrix.mul_apply, …] at this` |

Why this is the recommended structural form (per the job's preference order):

- It is **finite decomposition over the `Fin 2 × Fin 2` index set**: each goal
  becomes four (or one, for the inequalities) scalar identities in ℤ.
- It uses **`Matrix` structure lemmas** (`Matrix.mul_apply`, `Fin.sum_univ_two`,
  `Matrix.sub_apply`) rather than reducing an opaque `Decidable` instance.
- It avoids a kernel `decide` over `DecidableEq (Matrix (Fin 2) (Fin 2) ℤ)`
  (which would force the kernel through `Fintype`/`Finset.sum` reduction); the
  entrywise `simp` is fast and reviewer-legible.
- For the two inequalities, the proof exhibits an explicit distinguishing entry
  (the `(0,1)` entry), which doubles as documentation of *why* the matrices
  differ - better provenance than an opaque boolean.

Axiom audit after the change (`propext`, `Classical.choice`, `Quot.sound` only)
confirms no `Lean.ofReduceBool` / `Lean.trustCompiler` remains. The companion
report `null-edge-super-dirac-sign-counterexamples-report.md` was updated so its
axiom-footprint claim matches.

## 4. Slow `decide` / `+decide` scan (job task 4)

- **`+decide`**: 67 occurrences, all the `simp +decide` config flag (mostly in
  the Sedenions drafts and the abstract ring proofs of the motivating file). This
  flag only lets `simp` discharge *decidable side goals*; none is a standalone
  long-running `decide`. No draft-iteration win from touching these.
- **Plain `by decide`**: 58 standalone uses across 20 files, all small
  structural side-conditions (finite membership, small `Fin`/`Bool` facts). None
  is an obviously long-running kernel `decide` that would materially slow draft
  iteration.
- The genuinely heavy finite computations (E8 root enumeration, Hamming code
  enumeration, theta/weight counts) are **already** on native evaluation, not
  kernel `decide`. So there is no draft code where a temporary draft-only native
  replacement of a slow `decide` would materially improve iteration speed that is
  not already using native eval.

Conclusion for task 4: **no `decide → native` draft conversions are recommended**
right now; the slow finite work is already native, and the remaining `decide`
uses are cheap. The productive direction is the reverse - native → structural  - 
which §3 demonstrates on the motivating file.

## 5. Build status note

`PhysicsSM/Draft/NullEdgeSuperDiracSignAudit.lean` imports only Mathlib and
builds cleanly. A whole-project `lake build` shows pre-existing failures in many
other modules (`unknown module prefix 'PhysicsSM'` / `'SpherePacking'`): this
repo snapshot ships a subset of `PhysicsSM`, and those files import sibling
modules that are not present in the snapshot. These failures are **unrelated to
this task** and predate it; the edited file is not among them.

## 6. Policy recommendation

### Draft iteration policy
- Native evaluation is allowed in `PhysicsSM/Draft/**` for finite computational
  checks, as a deliberate speed measure. Keep the existing pattern: a
  "Finite-computation trust note" in the module docstring naming the
  `Lean.ofReduceBool` / `Lean.trustCompiler` axioms, plus
  `set_option linter.style.nativeDecide false` scoped to the file.
- Prefer a structural proof whenever it is *as fast or faster* than native
  evaluation (small `Fin`/matrix/`Finset` goals). The 2×2 matrix pattern in §3
  is the template: `ext`/`fin_cases` + `Matrix.mul_apply` + `Fin.sum_univ_two`.
- Never use native evaluation to dodge a *false-looking* statement; that is a
  semantic-alignment red flag, not a performance issue.

### Trusted / publication policy
- A theorem is publication/kernel-trusted only when its `#print axioms` is a
  subset of `{propext, Classical.choice, Quot.sound}`. Native evaluation
  (`Lean.ofReduceBool`, `Lean.trustCompiler`) disqualifies it - it is at most
  draft-trust.
- Do **not** silently convert a trusted-tree fixture from native eval to a slow
  kernel `decide` just to drop the compiler axioms: a `decide` that times out or
  blows up memory is not a publication-grade proof either. Replace with a genuine
  structural proof (cardinality/closed-form/symmetry/`Finset` decomposition or a
  small certified table) before promotion.
- The `NullStrand/Audit/CapstoneAxioms.lean` pattern (`#guard_msgs in
  #print axioms …`) is the right gate: pin the axiom surface of any
  promoted-to-trusted capstone so a later native-eval regression fails the build.

### Comment / TODO wording (avoid polluting placeholder scans)
- In prose, docstrings, Markdown, and task notes, spell escape-hatch tokens
  spaced: `n a t i v e _ d e c i d e`, `s o r r y`, `a x i o m`, `o p a q u e`,
  `a d m i t`, `u n s a f e`. Use the raw token only in executable Lean.
- For a deliberate draft native use, the recommended marker is a docstring line:
  `Draft/performance-only: n a t i v e _ d e c i d e over <finite set>;
  publication replacement: <structural plan>.` This is greppable
  (`performance-only`) without tripping a raw-token placeholder scan.

### Recording future replacements in task notes
- Each native→structural conversion gets a one-row entry in the originating
  task note and in this report's table: file, declaration, before/after method,
  resulting axiom set, and whether the statement was touched (it should not be).
- When promoting a file from draft-trust to trusted, add or extend a
  `#guard_msgs in #print axioms` guard (CapstoneAxioms pattern) so the promotion
  is mechanically protected.

## 7. Final classification table

Status key: **draft** = `PhysicsSM/Draft/**`; **draft-trust** = trusted-tree but
currently native-eval (documented), not yet kernel-trust. Difficulty is for a
*structural* replacement. "Safe to leave temporarily" = acceptable to keep native
eval for now given documentation + draft/draft-trust labelling.

| file | declaration(s) | current proof method | status | replacement recommendation | expected difficulty | safe to leave temporarily |
|---|---|---|---|---|---|---|
| `Draft/NullEdgeSuperDiracSignAudit.lean` | `σz_sq`, `example_commuting_plus`, `example_anticommuting_minus`, `example_extra_term_when_CPh_fails` | **structural now** (was native) | draft | **done** - entrywise `Matrix.mul_apply` + `Fin.sum_univ_two` | n/a (done) | n/a (already kernel-trust) |
| `Lie/Exceptional/E8.lean` | Cartan-matrix facts incl. `det = 1` | native eval | draft-trust | structural: `Matrix.det_fin_eight`/cofactor or entrywise + `norm_num`; small enough to be tractable | medium | yes |
| `Algebra/Octonion/IntegralOctonion.lean` | `type1Roots_length`(112), `type2Roots_length`(128), `rootList_length`(240), `rootList_nodup`, `IsE8RootD` membership | native eval | draft-trust | structural via `List.length`/`Finset.card` closed forms + a certified root table; `Nodup` via sorted-key injectivity | hard | yes |
| `Algebra/Octonion/E8Weyl*.lean` | Weyl-orbit/permutation finite facts | native eval | draft-trust | symmetry + orbit-cardinality lemmas | hard | yes |
| `Coding/ConstructionAThetaWeightBridge.lean` | 45 theta/weight coefficient counts | native eval | draft-trust (oracle-like) | closed-form weight-enumerator combinatorics; or a `decide`-checked small table per coefficient | hard | yes |
| `Coding/E8ThetaSeries*.lean`, `Coding/E8SpherePackingMatrixBridge.lean` | theta-series / Gram-matrix finite facts | native eval | draft-trust (oracle-like) | structural Gram/`Finset.sum` decomposition | hard | yes |
| `Coding/E8RootBridge*.lean` | E8 root ↔ coordinate bridges | native eval | draft-trust (oracle-like) | per-root certified table + injectivity | hard | yes |
| `Coding/HammingE8*.lean`, `Coding/Hamming844*.lean`, `Coding/HammingSelfDual.lean`, `Coding/HammingWeightEnumerator.lean` | [8,4,4] code enumeration, self-duality, weight enumerator | native eval | draft-trust (oracle-like) | enumerate 16 codewords as an explicit `Finset`/`List`; prove closure/weights structurally | hard | yes |
| `Draft/Sedenions/**` (12 files) | combinatorial fixtures (Reed-Muller, anomaly analogue, cocycle phase, generation geometry, Barnes-Wall, S3/ψ, Fano, GL(3,2), Cayley-Dickson signs, PSL(2,7), stabilizers) | native eval | draft | optional later; structural only if/when promoted | hard (varies) | yes |
| `Draft/ConstructionAThetaBoundedShellAristotle.lean`, `Draft/E8SpherePackingImported.lean` | bounded-shell / imported sphere-packing checks | native eval | draft | optional later | medium-hard | yes |

### One-line verdict
The motivating null-edge use is fully structuralized and kernel-trusted with no
statement change. Everything else is correctly labelled draft or draft-trust and
is safe to leave on native evaluation for now; the structuralization backlog
(priority order: `Lie/Exceptional/E8.lean`, then the E8/Hamming oracle fixtures)
should be cleared before any of those files is promoted to full kernel-trust.
