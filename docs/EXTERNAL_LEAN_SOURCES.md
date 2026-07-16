# External Lean sources: consult before duplicating

**Principle: borrow liberally, do not reinvent the wheel.** Before formalizing
anything, search the external Lean libraries below. If the object (or a close
relative) already exists, consult it, reuse the mathematics, and clean-room port
only what we actually need - do not re-derive from scratch. A duplicated result
is wasted Aristotle budget and reviewer time.

This registry is append-only and lives here so every agent (Claude, Codex,
Aristotle, future sessions) checks the same list. When you discover a new
external library or a relevant subtree, add it here.

## Discovery workflow

1. `mcp__lean-explore__search_summary query="..."` - hybrid lexical + semantic
   search over Mathlib **and** PhysLean (offline, GPU-backed). Scope with
   `packages=["Physlib"]` for PhysLean-only, `["Mathlib"]` for Mathlib-only.
2. `mcp__lean-explore__get_module <id>` - which library/module a hit lives in.
3. `get_source_code` / `get_docstring` / `get_source_link` / `get_dependencies`
   on the hits worth inspecting.

Absence in semantic search is NOT proof of absence - for a definitive "does X
exist" answer, get the source link and grep the upstream repo.

## Reuse / licensing discipline

All sources below are permissively licensed (Apache-2.0 / Mathlib's Apache-2.0).
Per `AGENTS.md` ("External code and licensing"): we MAY consult, compare, and
reuse with attribution, but the project style is to **translate the mathematics
and clean-room formalize**, not copy implementation text into trusted Lean.
These libraries are also **version-pinned away from our `v4.28.0` toolchain**, so
they are **consult / clean-room, not import** (same rule as PhysLean).

## Sources

### 1. Mathlib (base library) - always search first

Our project depends on it directly (`v4.28.0`). Everything analytic/algebraic
should be checked here first: `Matrix.*`, `LinearAlgebra.*` (incl.
`CliffordAlgebra`, `RootSystem`), `Algebra.Lie.*`, `RepresentationTheory.*`,
`MeasureTheory.*`, `Analysis.*`, `SchwartzMap`, CFC, etc.

### 2. PhysLean / `Physlib` (HEPLean/PhysLean) - physics AND quantum information

- Repo: `https://github.com/HEPLean/PhysLean` - Apache-2.0, ~641 `.lean` files.
- lean-explore package label: **`Physlib`** (NOT `PhysLean`).
- Physics content and full access notes: [`PHYSLEAN.md`](PHYSLEAN.md) (SM,
  anomaly cancellation, Higgs, CKM, Spin(10), Pati-Salam, QFT, Lorentz group,
  classical field theory, statistical mechanics, string theory, ...).

**NEW (2026-07-13): PhysLean also contains a mature quantum-information tree** we
had been unknowingly duplicating in the DYN-MODULAR / info-theory lane. Consult
these BEFORE banking any further entropy / relative-entropy / matrix-log /
quantum-channel rung:

- `QuantumInfo.Entropy.Relative` - **`qRelativeEnt`**, the Umegaki quantum
  relative entropy `D(rho||sigma) = Tr[rho (log rho - log sigma)]` (the SAME
  object as our `qRelEntropy`), with `qRelativeEnt_joint_convexity` (joint
  convexity, STRICTLY stronger than Klein nonnegativity), `qRelEntropy_self`
  (`D(rho||rho)=0`), `qRelativeEnt_ne_top` (finiteness), `qRelativeEnt_additive`,
  `qRelativeEnt_rank`, sandwiched Renyi relative entropy + its data-processing
  inequality (`sandwichedRenyiEntropy_DPI_gt_one`).
  Source: `QuantumInfo/Entropy/Relative.lean`.
- `QuantumInfo.Entropy.*` - **von Neumann entropy `Svn`** (`Svn_eq_neg_trace_log`,
  `Svn_eq_trace_cfc`, purity/pure-state lemmas).
- `QuantumInfo.ForMathlib.HermitianMat.LogExp` - **`HermitianMat.log`**, the
  Hermitian matrix logarithm (the SAME object as our CFC-free `logHermitian`),
  with `HermitianMat.log_mono` (operator monotonicity), `log_kron`,
  `inner_log_smul_of`. The `ForMathlib` namespace means the authors are staging
  these for Mathlib upstream.

Built on an `MState d` quantum-state abstraction; far more developed than our
matrix-level cluster.

**Implication (DQ-008):** our general quantum Klein cluster (`qKlein_nonneg` +
`qKlein_eq_zero_iff` + CFC-free `logHermitian`) reproduces a SUBSET of the above
and is NOT a novel Mathlib contribution. The only plausibly-novel residual is the
forward faithfulness `D(rho||sigma)=0 -> rho=sigma`, which did not surface in
QuantumInfo's API; if genuinely absent it should be contributed UPSTREAM to
PhysLean/QuantumInfo, not re-derived for Mathlib. Verify by grepping the repo
before acting.

## Lane -> check-here-first map

| Work lane | Search these first |
|---|---|
| Info theory / entropy / relative entropy / matrix log / quantum channels / DPI / max-entropy / Gibbs | PhysLean `QuantumInfo.Entropy.*`, `QuantumInfo.ForMathlib.HermitianMat.*`; Mathlib CFC / `Matrix` |
| Standard Model / anomaly / Higgs / CKM / Spin(10) / Lorentz group / gauge | PhysLean physics tree (see `PHYSLEAN.md`); Mathlib `RepresentationTheory`, `RootSystem` |
| Spinors / Clifford / gamma matrices | PhysLean; Mathlib `CliffordAlgebra` |
| Continuum analysis / Fourier / Schwartz / Sobolev | Mathlib `MeasureTheory`, `Analysis`, `SchwartzMap`, `FourierTransform` |
| Octonions / division algebras / E8 | Mathlib `Algebra.*`; project-internal (see `AGENTS.md` octonion convention) |

## How to extend

Add a new `### N. <library>` section with: repo URL + license, lean-explore
package label (if indexed), the subtrees/declarations that matter, and a row in
the lane map. Record the discovery date and the trigger (what we were about to
duplicate).
