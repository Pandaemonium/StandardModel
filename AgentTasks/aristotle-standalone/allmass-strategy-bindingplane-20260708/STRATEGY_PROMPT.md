# Strategy + proof: does the carrier's OWN closure curvature land in the binding plane? (F5)

## Context (blind to the wider repo)

`src/` has two verbatim files from a finite null-edge program. `DerivedInteraction.lean`
proves a **conditional** binding result: the second-quantized closure interaction
`Vderived = dΓ(i·κ·K)` binds a two-body state below the constituent threshold **iff**
the closure curvature `K` acts among the *excited* modes (not the ground plane):
`derived_boundState_below_threshold` (binds, for the excited-plane `closureCurvature`)
vs `derived_wrongPlane_no_binding` (no binding, for the ground-plane
`closureCurvature2`). The one grade-**C** gap is: *which plane does the carrier's
actual `K` occupy?*

The carrier's one-particle mass block is `B(λ,κ) = λ·I + i·κ·K` on three modes, where
`K` is the (real, antisymmetric) closure curvature — the SAME `K` whose second
quantization is `Vderived`. So the decisive question is a finite, concrete one:

**Is the carrier's `K` (the antisymmetric closure generator of `B`) the excited-mode
curvature `closureCurvature` (⇒ the carrier binds) or the ground-plane
`closureCurvature2` (⇒ no binding)?**

## Your targets

1. **Identify the carrier `K`.** From the mass block `B(λ,κ) = λ·I + i·κ·K` on
   `Fin 3` (aperture `λ` on the diagonal, closure `κ` off-diagonal), extract the
   real antisymmetric `K` (the closure part), as an explicit `3×3` matrix. State it.
2. **Prove which plane it occupies.** Compare the carrier's `K` to
   `closureCurvature` (excited-mode, binding) and `closureCurvature2` (ground-plane,
   no binding) in `DerivedInteraction.lean`. Prove `K = closureCurvature` (up to
   basis/sign) — OR prove it equals `closureCurvature2` / a third curvature, and say
   which. This is a finite matrix identity.
3. **Discharge the C→M step, or sharpen the obstruction.** If the carrier's `K` is
   the binding-plane curvature, prove the carrier binds **unconditionally** (fire
   `derived_boundState_below_threshold` with the carrier's own `K`, removing the
   "if the closure acts among excited modes" hypothesis for the carrier). If it is
   the ground-plane curvature, prove `derived_wrongPlane_no_binding` applies to the
   carrier (so this carrier does NOT bind, an equally important finding), and state
   precisely what a binding carrier would require.

The prize is turning "closure *can* bind" into "*this* carrier's closure binds
(or provably does not)" — the decisive upgrade the program flags.

## Constraints

Kernel-checked only: no `sorry`/`admit`/`native_decide`/new `axiom`; footprint
`[propext, Classical.choice, Quot.sound]`, guarded with in-file `#print axioms`.
Build on the given `DerivedInteraction`/`InteractingTwoBody` definitions; do not
weaken them. Deliver the new file + axiom prints + `ARISTOTLE_SUMMARY.md` stating:
the carrier's `K`, which plane it occupies (with the proof), and whether the carrier
binds — the honest verdict either way.
