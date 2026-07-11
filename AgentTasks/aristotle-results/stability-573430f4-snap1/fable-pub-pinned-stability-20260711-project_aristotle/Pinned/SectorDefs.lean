/-
# Deliverable 2 (part 3, shared defs) — spectral projectors and parity projector

Definitions only (fast to build); the certifying theorems live in the
`Pinned.SpecProj*` and `Pinned.Nu*` files.  Builds on the landed context and
`Pinned.MirrorChart`.
-/
import Mathlib
import context.HalfPeriodInvariant
import Pinned.MirrorChart

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PinnedSymmetryResolved

open Matrix
open PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding
open PhysicsSM.Draft.NullEdge.HalfPeriodInvariant

/-- Sign of a `Bool`: `true ↦ +1`, `false ↦ -1` (encodes `ε, r ∈ {±1}`). -/
def sgn (s : Bool) : ℚ := if s then 1 else -1

/-- Chart-`{1,3}` spectral projector `B·(1 + ε M)/2·Bᵀ` (full projection onto
`ker(W-ε)` for protected singletons). -/
def eigProj13 (b : Fin 4 → Bool) (eps : ℚ) : Matrix V8 V8 ℚ :=
  (1/2 : ℚ) • (Bfix * (1 + eps • Mfix b) * Bfixᵀ)

/-- Chart-`{0,2}` spectral projector (full projection for blind singletons). -/
def eigProj02 (b : Fin 4 → Bool) (eps : ℚ) : Matrix V8 V8 ℚ :=
  (1/2 : ℚ) • (Bfix0 * (1 + eps • Mfix0 b) * Bfix0ᵀ)

/-- Block spectral projector `(1 + ε W)/2` (full rank-`4` projection; the block
walk `W` is itself the involution). -/
def eigProjW (b : Fin 4 → Bool) (eps : ℚ) : Matrix V8 V8 ℚ :=
  (1/2 : ℚ) • ((1 : Matrix V8 V8 ℚ) + eps • Wof b)

/-- Reflection parity projector `P_r = (1 + r R)/2`. -/
def parityProj (R : Matrix V8 V8 ℚ) (r : ℚ) : Matrix V8 V8 ℚ :=
  (1/2 : ℚ) • ((1 : Matrix V8 V8 ℚ) + r • R)

end PhysicsSM.Draft.NullEdge.PinnedSymmetryResolved
