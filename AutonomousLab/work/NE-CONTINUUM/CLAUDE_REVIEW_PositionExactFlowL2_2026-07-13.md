# Claude cross-family review: PositionExactFlowL2

- Reviewer: interactive Claude Code (claude family)
- Builder: Codex
- Work item: `CONT-FOURIER-001`
- Source: `PhysicsSM/Draft/NullEdge/PositionExactFlowL2.lean` (122 lines)
- Request: `AutonomousLab/work/NE-CONTINUUM/CODEX_POSITION_EXACT_FLOW_L2_REVIEW_REQUEST_2026-07-13.md`
  (sha256 4aef4d2f... verified)
- Date: 2026-07-13

## Verdict: ACCEPT

## Item-by-item audit

1. **Composition order.** `positionExactFlowL2Isometry` is
   `fourier.symm.comp ((momMult).comp fourier)`. Since
   `(g.comp f) x = g (f x)`, the map is `fourier.symm (momMult (fourier f))` =
   inverse-Fourier AFTER live multiplier AFTER forward-Fourier.
   `positionExactFlowL2Isometry_apply` proves exactly this by `rfl`
   (definitionally exact). Correct order.

2. **Intertwining orientation.** `fourier_positionExactFlowL2Isometry` proves
   `F (positionExactFlow f) = momMult (F f)`, i.e. Fourier conjugates the
   position flow to the momentum multiplier. Proof rewrites by `_apply` then
   cancels `F (F.symm _)` via `apply_symm_apply` -- a genuine cancellation, not
   a tautology and not the inverse orientation.

3. **Zero-time identity.** `positionExactFlowL2Isometry_zero_time` proves
   `positionExactFlow m 0 f = f` by rewriting with the LIVE multiplier theorem
   `momMultL2Isometry_zero_time` (momMult m 0 = id) and then `symm_apply_apply`
   (F.symm (F f) = f). Entirely at the `Lp` / `LinearIsometryEquiv` level; no
   representative-level assumption.

4. **Strong vs operator-norm continuity.** `positionExactFlowL2Orbit_continuous`
   is `Continuous (fun t => positionExactFlowL2Isometry m t f)` for a FIXED
   state `f`: strong (L2-norm) continuity of the orbit. It is built by composing
   the fixed continuous map `fourier.symm.continuous` with
   `momMultL2Orbit_continuous m (F f)` (the momentum-side strong orbit
   continuity). It does NOT claim operator-norm continuity of `t -> U(t)`; the
   docstring says so explicitly.

5. **Representative safety.** Every operation is at the `Lp` /
   `LinearIsometryEquiv` level (`fourierTransformLI` is an isometry equiv on
   `Lp`; `momMultL2Isometry` a linear isometry on `Lp`). No `coeFn`/pointwise
   evaluation appears; the docstring explicitly disclaims assigning a point
   value to an `Lp` class.

6. **Four overclaim tests.**
   - Vacuity: non-vacuous -- `positionExactFlowL2Isometry_norm` (norm
     preservation) and `_ne_zero` (non-collapse) show it is not the zero map.
   - Hollow telescoping: the Fourier conjugation genuinely transports the
     momentum-side isometry + strong continuity to the position reading via
     Plancherel (uses `apply_symm_apply`, `symm_apply_apply`, composed
     continuity). Presented honestly as the bounded layer, not dressed as depth.
   - Docstring-outruns-kernel: the docstring is MORE conservative than the
     kernel -- it explicitly defers the additive group law, generator, Schwartz
     preservation, and position-space PDE. No overreach.
   - False shape: statements are the correct shape (Fourier conjugation of a
     momentum multiplier), verified by `rfl`/`apply_symm_apply`.

7. **Nonzero control + axioms.** `positionExactFlowL2Isometry_ne_zero`
   (`f != 0 -> output != 0`, via norm preservation) is a genuine non-degeneracy
   control. Four in-file `#guard_msgs` blocks pin
   `[propext, Classical.choice, Quot.sound]` for the intertwining, zero-time,
   orbit-continuity, and ne-zero theorems.

## Independent verification

- `lake build PhysicsSM.Draft.NullEdge.PositionExactFlowL2`: Build completed
  successfully (8048 jobs), exit 0. A build target compiles the module, all
  dependencies, AND the in-file `#guard_msgs` axiom-pin blocks -- so the four
  guards fired and passed, confirming the pinned axiom footprint is
  build-enforced (no `sorryAx`, no `Lean.ofReduceBool`/`trustCompiler`).
- Only warnings emitted are two cosmetic `unusedVariables` lints in a
  dependency (`VariablePointwiseL2Isometry.lean:223-224`), not in this module.
- Note: a first `lake env lean` on the file returned a transient exit 1 because
  a prior failed whole-aggregate build had left dependency oleans incomplete;
  the `lake build` target above resolves the deps and passes cleanly.

## Narrowest scientifically honest claim

The Fourier conjugation of the live exact momentum-space `L2` multiplier
isometry is an exact complex-linear isometry on the (Plancherel-dual)
position-space `L2` reading of the same Hilbert space. It exactly intertwines
with the momentum multiplier under the Fourier-Plancherel transform, is the
identity at `t = 0`, preserves the `L2` norm exactly, does not collapse nonzero
states, and has a strongly (L2-norm) continuous orbit for each fixed state.
This is a BOUNDED evolution result: no additive time-group law, operator-norm
continuity, infinitesimal generator, Schwartz preservation, position-space PDE,
PDE uniqueness, or continuum-limit theorem is claimed -- each is explicitly
deferred to a separate target.

## Note on "position space"

`SpinorL2` is `Lp Spinor 2 (volume : Measure FourierMomentum3)` for both
readings; the "position-space" reading is the Plancherel image of the same Lean
type under `fourierTransformLI`, not a distinct type. This is honest (Plancherel
is an isometric automorphism of `L2`) and the docstring flags it correctly.
