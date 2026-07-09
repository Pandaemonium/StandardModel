# Proof: finite seesaw — small mass from protected leakage through a heavy hidden block (Conjecture E)

## Context (blind to the wider repo)

A finite null-edge program integrates out hidden structure via the **Schur
complement**: coupling a visible block to a hidden block `M` and eliminating the
hidden register gives an effective visible operator `A − B M⁻¹ Bᴴ`. The frontier
conjecture (a candidate mechanism for neutrino lightness): a mode that is *protected*
(exactly massless in isolation) acquires only a **suppressed** mass through weak
leakage into a *heavy* hidden block — `m_eff ~ ‖B‖² / ‖M‖ → 0` as the hidden scale
grows. The smallness is resolvent suppression, not tuning.

## Targets (`src/SchurSeesaw.lean`)

1. `seesaw_suppression`: for a Hermitian visible block `A`, coupling `B` to a
   positive-definite hidden block `M`, and a protected visible mode `v` with
   `A *ᵥ v = 0`, the effective mass induced by integrating out the hidden block is
   `⟨v, (A − B M⁻¹ Bᴴ) v⟩ = −⟨M⁻¹ (Bᴴ v), (Bᴴ v)⟩`, and its magnitude is bounded by
   `‖Bᴴ *ᵥ v‖² / λ_min(M)` — suppressed by the heavy hidden scale, so `→ 0` as
   `λ_min(M) → ∞`. Replace the `True` placeholder with the exact inequality and prove
   it (a Schur-complement / resolvent estimate: `⟨w, M⁻¹ w⟩ ≤ ‖w‖² / λ_min(M)` for
   PosDef `M`, with `w = Bᴴ v`).
2. `seesaw_zero_iff_no_overlap`: the induced effective mass vanishes **iff** the
   protected mode has no overlap with the hidden coupling (`Bᴴ *ᵥ v = 0`) — protection
   is exact iff the leakage channel is closed.

You have latitude to restate cleanly (e.g. use `Matrix.PosDef`, the eigenvalue/
resolvent bound `hM.1.eigenvalues`, or `M.PosDef → ⟨w, M⁻¹ w⟩ ≤ ‖w‖²/λ_min`); keep
the physical content: **effective mass on the protected mode ≤ overlap² / hidden
scale**, vanishing iff no overlap. The `M⁻¹` is well-defined since `M` is PosDef.

## Constraints

Kernel-checked only: no `sorry`/`admit`/`native_decide`/new `axiom`; footprint
`[propext, Classical.choice, Quot.sound]`, guarded with in-file `#print axioms`.
Mathlib only. Deliver the file + axiom prints + `ARISTOTLE_SUMMARY.md`: the exact
suppression bound, the exact-protection iff, the resolvent lemma used, and honestly
whether the bound is the clean `‖Bᴴv‖²/λ_min(M)` or needs a different constant.
