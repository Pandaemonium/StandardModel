# Summary of changes for run aac827f3-ceef-4271-a290-5ce7a2a7370c
HOSTILE PUBLICATION-ARTIFACT AUDIT — Null-Edge Paper A (review-only; no files modified)

Scope note / three-way distinction used throughout:
- EXECUTABLE MATHEMATICAL CHECK = what `verify_null_edge_paper_a.py` (the authoritative command) and `OvernightTheoryAxiomGuard.lean` actually force the Lean kernel / scripts to verify.
- MANUSCRIPT SEMANTICS = whether the prose claim matches the pinned declaration's true statement/scope.
- ENVIRONMENT PROVISIONING = whether CI/toolchain pins make a run repeatable elsewhere.
The guard mechanism itself is genuine: `#guard_msgs (whitespace := lax) in #print axioms X` (246 pins) does fail the build on axiom-footprint drift, and `lake build <module>` returns nonzero on a missing/broken target, which propagates (`SystemExit(1)`). That core is sound. The defects below are in coverage, determinism, and provisioning.

======================================================================
FATAL (block the label "independently reproducible")
======================================================================
F1. summary.json cannot identify the checked source state. `git_status_porcelain` records a heavily dirty tree: the headline module files themselves are UNTRACKED (`?? PhysicsSM/Draft/NullEdge/FullBlochZeroClassification.lean`, `...PlueckerWindingDerived.lean`, `...PlueckerPhaseObservable.lean`, `...ChangingModeEmbedding.lean`, `...SobolevTailRate.lean`, `...ChannelShearModuli/RefinementTorsor/SelectorUniqueness.lean`, `...ChiralFlipMode.lean`, `...SignWallDefectRouteB.lean`, `...Finite3Plus1ProductDFTCore.lean`, `...LiveDFTComposition.lean`, etc.) and others are `M`. The recorded `git_commit` e4e5274 therefore points to a tree that does not even contain the verified sources. The manifest honestly labels the archival identifier "PENDING AFTER CLAIM FREEZE", but until a clean commit/tag exists the bundle is not reproducible from the recorded state.

F2. summary.json is non-deterministic yet its hash is pinned. It embeds wall-clock `duration_seconds` for every check and absolute machine paths (`C:\\Users\\Owner\\AppData\\Local\\Programs\\Python\\Python312\\python.exe`, `C:\\Projects\\StandardModel\\artifact\\...`). Two honest runs cannot produce byte-identical output, so the manifest's pinned `summary.json` SHA-256 (`29421807…`) is unreproducible by construction — pinning a hash for a file that encodes timing and host paths is self-defeating.

F3. Numerical-fixture change is NOT caught by the verifier. `verify_null_edge_paper_a.py` records `benchmark_sha256` and `dynamics_sha256` but never compares them to the golden values the manifest pins (`DD44F1…`, `79CFF2…`). Detection relies entirely on the sub-scripts' internal tolerances; a silently altered input/expected fixture that still returns 0 passes the authoritative check. "changed numerical fixture ⇒ fail" is unmet at the verifier level.

======================================================================
MAJOR
======================================================================
M1. Headline "machine-checked" claims with neither a direct verifier target nor a guard pin.
 - A-H2 "Exact unitary dynamics" (manifest status PASS) is anchored on `PluckerMassDynamics.massCoin_unitary_group` and `Pluecker3Plus1ComplexMass.massCoin4_unitary_group`. Neither module is in HEADLINE_MODULES, neither is imported by the guard, and neither `*_unitary_group` theorem is `#print axioms`-pinned (grep: 0 hits). Only the third anchor `variableComplexLocalStep_preserves_norm` is guarded. The group-law half of the dynamics headline is unverified by the authoritative command.
 - Paper F (F-H0): the manifest claims "Per-module pins + consolidated pins for F1/F2" and lists `CarrierRigidity.lean` and `FourChannelRigidityCapstone.lean`, but the guard imports zero `CarrierRigidity`/`FourChannel` modules and pins none of `parity_decomposition_unique`, `square_oddPart`, `square_evenPart`, `Concrete.shared_type_but_distinct`, `four_channels_linearIndependent`, `carrier_square_coefficients_recovered` (grep: 0 hits each). These are neither built nor axiom-pinned by the executable path. (The F1/F2 torsor/shear/selector theorems — `refinementEquivZeroSumShift`, `mixed_shear_injective`, `two_sign_gradings_decomposition_unique` — ARE pinned; only the Carrier/FourChannel anchors are missing.)
 - A-H1 duplicate cross-check: the "duplicate APIs agree" audit note relies on `PlueckerMassOperator.{Bz_sq,hero_identity,hermitian_uniqueness}` (spelled "Pluecker"), but only `PluckerMassOperator` (no 'e') is imported/pinned; the duplicate module is neither imported nor guarded, so the agreement is not machine-enforced.

M2. The manifest's per-anchor "Verification command" column lists many standalone `lake env lean PhysicsSM/Draft/NullEdge/<file>.lean` invocations that are NOT part of the authoritative verifier and NOT run by CI. The verifier only does `lake build` over the 16 HEADLINE_MODULES + guard. Coverage of anchors outside that set exists only insofar as the guard transitively imports+pins them; where it does not (M1), the "PASS" rows overstate automated coverage.

M3. Environment provisioning in the CI workflow is not adequate for reproducibility. `runs-on: ubuntu-latest` (moving target); no `actions/setup-python` pin (Python version floats); `pip install numpy` is unpinned — the "floating oracle" result and therefore the pinned fixture SHA-256s depend on the numpy/BLAS build, so an unpinned numpy can flip F3's would-be hash check. `leanprover/lean-action@v1` with `auto-config: false` and no `lake exe cache get` means Mathlib is built from source under a 60-minute `timeout-minutes` — almost certainly a timeout, i.e. the "same authoritative command" likely never completes green as configured. CI also never runs `--full-build`, so the complete repository build (the archival gate) is unexercised.

======================================================================
MINOR
======================================================================
m1. Manifest "Latest consolidated verification" pins a 6-module `lake build ...` (8,134 jobs) that differs from the 16-module authoritative HEADLINE_MODULES; the headline job-count evidence comes from a non-authoritative command.
m2. If a numerical script file is absent, `subprocess.run` raises `FileNotFoundError` and the verifier crashes with a traceback instead of writing a clean failing summary (missing-module is handled cleanly; missing-script is not).
m3. Path drift: the verifier writes to `artifact/paper-a-verification/summary.json`, but the reviewed `summary.json` sits at repo root; `ROOT = parents[2]` assumes the script lives at `Scripts/publication/…` (correct in the full repo, but the bundle copy at repo root would compute the wrong ROOT if run in place).
m4. summary.json is not fully self-describing: it omits the numpy version (required by the manifest checklist), the expected fixture hashes, and the expected HEADLINE_MODULES list, so it cannot self-verify coverage.
m5. Gate matrix marks F1/F2 and the Paper-D cores "CLOSED"; for the Carrier/FourChannel F-anchors this outpaces the executable checks (M1).

======================================================================
CLEAR (genuinely adequate)
======================================================================
C1. The axiom guard is a real aggregate guard: 246 `#print axioms` pins under `#guard_msgs`; no `sorry`/`sorryAx`, no `Lean.ofReduceBool`/`native_decide` appears in any expected message, so every pinned declaration is confined to `[propext, Classical.choice, Quot.sound]`. Axiom drift on a pinned decl breaks the build and fails the verifier.
C2. Building a missing or broken module fails the verifier and exit code (nonzero) propagates to CI.
C3. Manifest honesty: archival identifier flagged PENDING, dirty working tree disclosed, SPL/E8 full-build blocker disclosed, license gap disclosed, clean-Linux-checkout left unchecked. Prose does not overuse "reproducible/complete" — the gate matrix even states "A paper is not ready because its prose is complete."
C4. Fixture SHA-256s in the manifest match those recorded in summary.json (`dd44f1…`, `79cff2…`); benchmarks are exact/negative-control-bearing as described.

======================================================================
FILE-BY-FILE VERDICT
======================================================================
| File | Verdict | Basis |
| --- | --- | --- |
| verify_null_edge_paper_a.py | FAIL | records but never asserts fixture hashes (F3); emits non-deterministic timing+abs-path summary (F2); coverage limited to 16 modules, missing M1 anchors |
| OvernightTheoryAxiomGuard.lean | PASS WITH PATCHES | sound guard for 246 decls (C1) but omits massCoin*_unitary_group, all CarrierRigidity/FourChannel F-anchors, and PlueckerMassOperator duplicate (M1) |
| ARTIFACT_MANIFEST.md | PASS WITH PATCHES | honest about PENDING/blockers (C3) but claims F1/F2 "pins" not present (M1), lists non-authoritative per-anchor commands (M2), 6-vs-16 module inconsistency (m1) |
| MANUSCRIPT_CLAIM_MATRIX.md | PASS WITH PATCHES | scoping careful, but A-H2/F-H0 "machine-verified/guards" rows exceed executable coverage (M1) |
| PAPER_GATE_MATRIX.md | PASS WITH PATCHES | "CLOSED" outpaces executable checks for F Carrier/FourChannel anchors (m5) |
| null_edge_publication_ci.yml | FAIL | unpinned OS/Python/numpy, no Mathlib cache under 60-min timeout, no --full-build (M3) |
| summary.json | FAIL | dirty porcelain ⇒ no source identity (F1); non-deterministic + host paths (F2); not self-describing (m4) |
| lakefile.toml / lean-toolchain / lake-manifest.json | CLEAR | toolchain v4.28.0 and Mathlib rev pinned and internally consistent |

======================================================================
EXACT REPLACEMENT LANGUAGE
======================================================================
- Manifest A-H2 "Assumptions/trust"/Guard cells → replace "Per-module pins + consolidated guard" with: "Guarded: VariablePlueckerLocalWalk.variableComplexLocalStep_preserves_norm. NOT YET GUARDED/BUILT by the authoritative verifier: PluckerMassDynamics.massCoin_unitary_group, Pluecker3Plus1ComplexMass.massCoin4_unitary_group (group-law nonzero-z branch)."
- Manifest F-lane Guard cell → replace "Per-module pins + consolidated pins for F1/F2" with: "Guarded: ChannelRefinementTorsor, ChannelShearModuli, ChannelSelectorUniqueness. NOT axiom-pinned or built by the verifier: CarrierRigidity.*, FourChannelRigidity.*."
- Manifest single-command block caption → replace "The latest default run passed; summary.json SHA-256 is 29421807…" with: "summary.json is intentionally non-deterministic (timing, host paths); do not pin its hash. Determinism is asserted instead on the fixture JSONs and the Lean build return codes."
- Verifier docstring line 1 → replace "Reproduce the formal and numerical headline checks" with "Rebuild and axiom-check the headline Lean targets and re-run the numerical oracles, asserting fixture hashes against pinned golden values" (once F3 is implemented).
- CI step names/config → "Set up Lean" step must add a Mathlib cache fetch and drop `auto-config: false`; pin `runs-on: ubuntu-24.04`, add `actions/setup-python@v5` with an explicit `python-version`, and `pip install "numpy==<pinned>"`.

======================================================================
SMALLEST EXACT PATCH LIST BEFORE "INDEPENDENTLY REPRODUCIBLE"
======================================================================
P1 (F1) Commit every untracked/modified headline module, script, guard, and CI file to an immutable tag; replace all PENDING/base-commit fields; make the verifier record `git_status_porcelain` and refuse the "archival" label unless it is empty.
P2 (F2) Remove `duration_seconds` and absolute paths from the hashed summary (store timings in a separate, unhashed log; normalize commands to repo-relative + `python`); record numpy version, expected HEADLINE_MODULES, and expected fixture hashes; then stop pinning summary.json's own hash.
P3 (F3) Have the verifier compare `benchmark_sha256`/`dynamics_sha256` to pinned golden constants and fail on mismatch.
P4 (M1) Add massCoin_unitary_group, massCoin4_unitary_group, CarrierRigidity.{parity_decomposition_unique,square_oddPart,square_evenPart}, FourChannelRigidity.{four_channels_linearIndependent,carrier_square_coefficients_recovered}, and the PlueckerMassOperator duplicate lemmas to the guard's `#print axioms` pins (and their modules to HEADLINE_MODULES) — or delete the "machine-checked/pins" claim for them.
P5 (M3) Pin CI: fixed ubuntu image, pinned Python and numpy, Mathlib cache before build, realistic timeout; add a scheduled/opt-in `--full-build` job (or state the SPL exclusion in-workflow).
P6 (M2/m1) Reconcile the manifest's per-anchor and "latest consolidated" commands to the single 16-module authoritative verifier.
P7 (checklist) Add the root LICENSE, record Python/numpy versions, and complete the "clean Linux checkout verified" item.

======================================================================
FINAL VERDICT: PASS WITH PATCHES
======================================================================
The executable mathematical core (kernel axiom guard + build gating) is genuine and does fail on axiom drift and broken/missing targets. However, as configured the bundle must NOT be called "independently reproducible": source identity (F1), summary determinism (F2), fixture-change enforcement (F3), and CI environment pinning (M3) are unmet, and two headline "machine-checked" lanes (A-H2 group law, Paper F Carrier/FourChannel) lack any executable target or guard pin (M1). Land P1–P7 (P1–P3 and P5 are mandatory for the reproducibility label) and the artifact reaches top-tier-submission grade.
