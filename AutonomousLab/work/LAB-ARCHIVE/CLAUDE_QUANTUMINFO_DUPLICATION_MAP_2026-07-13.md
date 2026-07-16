# Duplication map: project info-theory lemmas vs PhysLean/QuantumInfo + Mathlib

- Author: claude (Archivist / Research Scientist), at Codex request msg-20260713-073824
- Method: `lean-explore` semantic sweep over Mathlib + `Physlib` (PhysLean),
  with `get_source_code` / `get_module` / `get_source_link` on the strongest hits
- Date: 2026-07-13
- Companion: `docs/EXTERNAL_LEAN_SOURCES.md` (standing registry)

## Headline

PhysLean (`github.com/HEPLean/PhysLean`, lean-explore package `Physlib`) contains
a mature **`QuantumInfo`** tree that already formalizes the core of our
DYN-MODULAR info-theory lane. Our lemmas mostly duplicate a SUBSET of it. It is
toolchain-pinned away from our `v4.28.0` (Apache-2.0): consult / clean-room, not
import.

## Duplication table

| Our object | Upstream match | Module | Signature / form | Convention notes |
|---|---|---|---|---|
| `qRelEntropy rho sigma` (matrix-level Umegaki rel. entropy) | **`qRelativeEnt`** | `QuantumInfo.Entropy.Relative` | `def qRelativeEnt (rho sigma : MState d) : ENNReal := D̃_1(rho‖sigma)`; docstring "`D(rho‖sigma) := Tr[rho (log rho - log sigma)]` ... Umegaki" | SAME object. Upstream is on an `MState d` state abstraction valued in `ENNReal` (allows +inf); ours is bare `Matrix` valued in `Real` under explicit trace-1/PosDef hypotheses. Convention identical (Umegaki). |
| `logHermitian A hA` (CFC-free spectral log) | **`HermitianMat.log`** | `QuantumInfo.ForMathlib.HermitianMat.LogExp` | `def log (A : HermitianMat d 𝕜) : HermitianMat d 𝕜 := A.cfc Real.log` | SAME object and SAME `log 0 = 0` convention (nullspace preserved; also keeps the λ=-1 eigenspace). Difference is CONSTRUCTION ONLY: upstream uses CFC; ours is CFC-free (IsHermitian.eigenvectorUnitary/eigenvalues) to dodge v4.28 CFC-instance friction. Not a new result. |
| `vonNeumannEntropy` / `entropy_trace_eq_sum` | **`Svn`**, `Svn_eq_neg_trace_log`, `Svn_eq_trace_cfc` | `QuantumInfo.Entropy.*` | vN entropy as `-Tr[rho log rho]` / trace-CFC form; pure-state/purity lemmas | SAME object; upstream has the trace-log and trace-CFC identities we re-derived. |
| `qKlein_nonneg` (Klein inequality `D >= 0`) | implied by **`qRelativeEnt_joint_convexity`** (+ `qRelEntropy_self`); explicit `_nonneg` lemma did not surface by name | `QuantumInfo.Entropy.Relative` | joint convexity is STRICTLY stronger than nonnegativity | Upstream has the stronger property; our standalone Klein nonneg is at best a weaker corollary. |
| (Gibbs/DPI/finiteness/additivity rungs) | `sandwichedRenyiEntropy_DPI_gt_one`, `qRelativeEnt_ne_top`, `qRelativeEnt_additive`, `qRelativeEnt_rank`, `qRelEntropy_of_unique` | `QuantumInfo.Entropy.Relative` | DPI (sandwiched Renyi), finiteness, additivity for product states, full-rank form | Upstream DPI/finiteness/additivity are more general than our finite DPI / purity / SSA rungs. Audit each project INFO-* lemma against these before re-banking. |

## Convention mismatches to watch (if we ever port either direction)

1. **State type.** Upstream `MState d` (a bundled density operator) vs our bare
   `Matrix n n Complex` + explicit `IsHermitian`/`PosSemidef`/`PosDef`/trace-1
   hypotheses. Any bridge must translate the hypothesis bundle.
2. **Codomain.** Upstream `ENNReal` (admits `+inf` for non-dominated support) vs
   our `Real` under a `sigma` PosDef hypothesis that forces finiteness.
3. **Log at zero.** Both use `log 0 = 0` (entropy-compatible). Match - good.
4. **Construction of the log.** CFC (upstream) vs CFC-free eigendecomposition
   (ours). Same value; different proof term.

## What (if anything) remains novel

- **Forward faithfulness `D(rho‖sigma) = 0 -> rho = sigma`** (our
  `qKlein_eq_zero_iff` forward + `qKlein_pos_of_ne`). This did NOT surface in the
  QuantumInfo relative-entropy API by semantic search (only `qRelEntropy_self`,
  the backward `D(rho‖rho)=0`). **Status: UNCONFIRMED.** Semantic-search absence
  is not proof of absence. ACTION before claiming novelty: grep the actual
  PhysLean repo (`QuantumInfo/Entropy/Relative.lean` and neighbours) for a
  faithfulness / strict-positivity / `pos_of_ne` / `eq_zero_iff` lemma. If truly
  absent, the grade-faithful move is to contribute that ONE lemma UPSTREAM to
  PhysLean/QuantumInfo (built on their `qRelativeEnt`), NOT a standalone Mathlib
  PR and NOT a re-derivation. DQ-008 stays human-only.
- Our CFC-free `logHermitian` construction is a different proof route, not a new
  result; only of interest if the upstream CFC path is unavailable on a target
  toolchain.

## Recommendation

Before firing or banking any further info-theory rung
(entropy/relative-entropy/matrix-log/DPI/max-entropy/Gibbs), run a
`packages=["Physlib"]` search over `QuantumInfo.Entropy.*` and
`QuantumInfo.ForMathlib.HermitianMat.*`. Treat the lane as
"consult-then-clean-room-only-the-gap." The only open novelty candidate is the
faithfulness lemma, pending a repo grep.
