# NullSolderFrame foundations report (Gate B: B0 → B1 → B3 → B2)

Type: Lean proof/formalization job (kernel-checked).

Deliverable: `PhysicsSM/Draft/NullSolderFrameFoundations.lean`.

Toolchain: Lean `v4.28.0`, Mathlib `v4.28.0` (the project pin in `lakefile.toml`).

Build/verification run (only the created module, per the job instructions):

```text
lake build PhysicsSM.Draft.NullSolderFrameFoundations   -- succeeds, no warnings
```

The file contains **no `sorry`**, and every theorem below was checked with
`#print axioms`-equivalent verification: each depends only on the standard
axioms `propext`, `Classical.choice`, `Quot.sound`.

## Sources consulted

- `PROMPT.md` (the exact B0 → B1 → B3 → B2 target package and guardrails).
- `AgentTasks/null-edge-job-dependency-dag.md` (Gate-B ordering
  `B0 → B1 → B3 → B2 → B4`; B0/B1/B3 as prerequisites of B2/B4).
- `AgentTasks/null-edge-conventions-integration-audit.md` (the NullSolderFrame
  data list, the general-`d` simplex normalization, the inverse-Gram form
  `G⁻¹ = -((d-1)/d) I + (1/d) J`, and the overlock guardrails).
- `docs/CONVENTIONS.md` (mostly-minus signature, dual-soldered architecture, the
  diagonal trace/symbol obstruction as a *documented negative comparison only*).
- `docs/NULLSTRAND.md` (simplex null-solder frame `ℓ_A = (1, n_A)`,
  `α^A = (1/d) dt + ((d-1)/d) n_A·dx`, reconstruction `ξ = ∑ ξ(ℓ_a) α^a`, and the
  diagonal trace obstruction: `∑_a b_a ℓ_a^♭ ⊗ ℓ_a` has trace `0` while the
  cotangent identity has trace `d`).

## What was formalized

This is **finite linear algebra over ℝ**. Nothing here claims a continuum limit,
and nothing derives spacetime dimension: the tetrahedral case is exactly `d = 4`
of a simplex family valid for every `d = n ≥ 2`.

### B0 — `NullSolderFrame` data package

`structure NullSolderFrame (V) (n)` bundles the null edge basis `ell`, the Gram
form `g` (with symmetry `g_symm`), the inverse-Gram matrix `invGram`, and the
inverse identity `gram_inv : ∑_b g(ℓ_a, ℓ_b) · G^{bc} = δ_a^c`.

Derived API:

- `NullSolderFrame.alpha` — the dual covectors `α^a := (ℓ_a).dualBasis`.
- `NullSolderFrame.alpha_apply_ell` — duality `α^a(ℓ_b) = δ^a_b`.
- `NullSolderFrame.reconstruction` — the reconstruction identity
  `ξ = ∑_a ξ(ℓ_a) · α^a`.
- `NullSolderFrame.gram` and `NullSolderFrame.gram_invGram` — Gram entries and
  the inverse-Gram identity restated on them.
- `NullSolderFrame.cliffordCoeff` — the Clifford coefficient placeholder
  `C_a = c(α^a)` for an abstract symbol map `c : Dual ℝ V →ₗ[ℝ] A`.

This realizes the entire B0 list from `PROMPT.md` (`ell_a`, `alpha^a`, Gram data,
inverse-Gram data, reconstruction identity, Clifford coefficient placeholder).

### B1 — simplex / tetrahedral null-solder frame (general `d = n`)

- `simplexGram n = (n/(n-1)) • (J - I)` and
  `simplexInvGram n = -((n-1)/n) • I + (1/n) • J`, with `allOnes n = J`.
- `simplexGram_diag` : diagonal entries are `0` — the edges are **null**.
- `simplexGram_offDiag` : off-diagonal entries are `d/(d-1)`, matching
  `ℓ_A · ℓ_B = d/(d-1)`.
- `simplexFrame n (hn : 2 ≤ n) : NullSolderFrame (Fin n → ℝ) n` — a concrete
  realization over `Fin n → ℝ`: edge basis = standard basis, Gram form induced by
  `simplexGram n`, inverse-Gram data = `simplexInvGram n`. The `d = 4` instance
  is the tetrahedral frame.
- `simplexFrame_null` : the realized frame is null (`g(ℓ_a, ℓ_a) = 0`).

General dimension was tractable, so it is done in general `d = n ≥ 2`, with `d = 4`
as a specialization (per the guardrail that `d = 4` is one case of a family).

### B3 — explicit tetrahedral inverse-Gram

- `simplex_gram_mul_invGram (n) (hn : 2 ≤ n) : simplexGram n * simplexInvGram n = 1`
  — the inverse-Gram in general dimension.
- `tetra_inverse_gram : simplexInvGram 4 = -3/4 • I + 1/4 • J` — the explicit
  tetrahedral inverse-Gram requested in `PROMPT.md`.
- `tetra_gram_mul_inv` : the tetrahedral Gram times `-3/4 • I + 1/4 • J` is the
  identity (the inverse property in the requested explicit form).

### B2 — diagonal trace obstruction

- `diagOp g ell b` — the diagonal soldering endomorphism
  `v ↦ ∑_a b_a · g(ℓ_a, v) · ℓ_a` (i.e. `∑_a b_a · ℓ_a^♭ ⊗ ℓ_a`).
- `diagOp_trace` : its trace is `∑_a b_a · g(ℓ_a, ℓ_a)`.
- `diagOp_trace_eq_zero_of_null` : on a null frame the trace is `0`.
- `diag_soldering_ne_id` : on a null frame in positive dimension, **no** choice of
  diagonal coefficients makes `diagOp = id`, because `trace(id) = d = n > 0`
  while the diagonal trace is `0`. This is the precise obstruction proving that
  `∑_a c(ℓ_a^♭) ∇_{ℓ_a}` cannot be the active Dirac symbol; the active
  architecture must instead solder to the dual covectors `α^a` (B0).
- `simplex_diag_soldering_ne_id` : the obstruction applied to the simplex frame.

## Conventions and guardrail compliance

- **Mostly-minus / nullity** is encoded as `g(ℓ_a, ℓ_a) = 0` (diagonal Gram zero),
  consistent with `docs/CONVENTIONS.md`.
- **Dual-soldered architecture** is the active one: `α^a` (the `dualBasis`) is the
  carrier; the diagonal flats `ℓ_a^♭` appear *only* in B2 as the documented
  negative comparison that the trace obstruction rejects.
- **No dimension derivation.** The tetrahedral frame is the `d = 4` member of the
  general `d = n ≥ 2` simplex family; nothing in the file asserts that four null
  directions force four spacetime dimensions.
- **Finite algebra only.** No continuum or scaling claim is made.

## Relationship to existing project code

`PhysicsSM/Draft/NullEdgeScalarKineticReconstruction.lean` proves the
reconstruction/inverse-Gram identities for an abstract metric via the inverse
musical map `sharp`. This file packages that material as a reusable B0 datum
(`NullSolderFrame`) and adds the concrete simplex realization (B1), the explicit
tetrahedral inverse-Gram (B3), and the diagonal trace obstruction (B2). It is
self-contained (`import Mathlib`) and does not modify existing files.

## Status labels (per program conventions)

- B0 data package, reconstruction identity, simplex frame, inverse-Gram, and the
  trace obstruction are **finite identities / structural theorems**, now
  kernel-checked.
- These are draft-surface results. Promotion to a trusted surface still depends on
  the program's Gate A convention freeze (`A1`/`A2`/`A3`) and integration audit
  `I1`/`G1`, exactly as recorded in `null-edge-job-dependency-dag.md`; this report
  does not assert that any gate has been *passed*.
