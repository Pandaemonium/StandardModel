import Mathlib

/-!
# K1 root-pinned encoder anti-regression toy

This module freezes the smallest K1 failure mode found by the 2026-07-07
root-hygiene audit. In the `n = 3` toy case, the root is slot `0`, the unique
root child is slot `1`, and the total child block is `{1, 2}`. There are two
internal block orderings, but a root-pinned flat word that records only the
root child collapses both orderings to one image.

The point is intentionally narrow: this file is an anti-regression fixture, not
the K1 fiber theorem. It refutes any future claim that the pinned flat encoder
already carries the full `m_j!` factor in the one-block toy, and it contrasts
that with a structured two-slot word that keeps both orderings.

Draft-trust: finite decidable equalities by `decide`; no compiler-trusted
evaluation is used.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace PolymerKPConclusion
namespace KPAntiRegressionToy

/-- The collapsed root-pinned word for the `n = 3` toy records only the root
child slot. -/
abbrev ToyPinnedWord := Fin 1 -> Fin 3

/-- The structured word keeps the two free block slots. -/
abbrev ToyStructuredWord := Fin 2 -> Fin 3

/-- The two internal orderings of the size-two child block `{1, 2}`. -/
def toyTotalBlockPerms : Finset (Equiv.Perm (Fin 2)) := Finset.univ

/-- Root-pinned flat encoder for the toy: both orderings record the same root
child, so the image has cardinality one. -/
def toyPinnedWordEncoder (_sigma : Equiv.Perm (Fin 2)) : ToyPinnedWord :=
  fun _ => (1 : Fin 3)

/-- Structured encoder for the toy: it records both positions in the size-two
block, so the two internal orderings remain distinct. -/
def toyStructuredBlockEncoder (sigma : Equiv.Perm (Fin 2)) : ToyStructuredWord :=
  fun i => if sigma i = (0 : Fin 2) then (1 : Fin 3) else (2 : Fin 3)

/-- The toy child block has exactly two internal orderings. -/
theorem toyTotalBlockPerms_card : toyTotalBlockPerms.card = 2 := by
  decide

/-- The root-pinned flat-word encoder collapses the two internal orderings to
one image. This is the anti-regression guard against using the pinned encoder
to justify the full `m_j!` factor. -/
theorem pinnedWord_collapses_toy :
    (toyTotalBlockPerms.image toyPinnedWordEncoder).card = 1 := by
  decide

/-- Equivalently, the root-pinned flat-word encoder is not injective on the two
toy internal orderings. -/
theorem pinnedWord_not_injective_toy :
    Not (Set.InjOn toyPinnedWordEncoder
      (↑toyTotalBlockPerms : Set (Equiv.Perm (Fin 2)))) := by
  decide

/-- The structured two-slot encoder separates the two internal orderings. This
is only a toy positive check, not the general structured-block theorem. -/
theorem structuredWord_separates_toy :
    (toyTotalBlockPerms.image toyStructuredBlockEncoder).card = 2 := by
  decide

end KPAntiRegressionToy
end PolymerKPConclusion
end GateYM
end NullEdge
end Draft
end PhysicsSM
