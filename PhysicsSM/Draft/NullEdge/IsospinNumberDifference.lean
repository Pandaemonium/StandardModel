import PhysicsSM.Draft.NullEdge.IsospinGradingSearch

/-!
# The number-difference candidate: KERNEL NO-GO RECORD (isospin thread close)

**Status: FINDINGS RECORD (P1/eq-36 isospin thread, 2026-07-18).** The
grading atlas (`IsospinGradingSearch`) showed `X1`/`X2` grade-degenerate
under every diagonal `tau_3`/`R3`-family candidate. The Fock-designed
number-difference candidate `G_num = N_1 - N_2` (both composition orders)
was probed in three kernel cycles with these verdicts:

1. Predicted `(0, +1, -1, 0)`: REFUTED - scalar-comparison residues show a
   uniform `1/4` scale on `X1`, `X2`, `X3` (both orders).
2. Predicted uniform `(1/4) . id`: ALSO REFUTED - the true adjoint carries
   NON-scalar rank-one residuals; kernel-displayed shape (after
   `I^3 = -I`, `I^6 = -1`, `I^9 = I`):
   `0 = (I/8) psi(d.x0) + (1/8) psi(d.x3)`-type terms per coordinate, i.e.
   a psi-functional slot rotation coupling `x0 <-> x3`, `x1 <-> x2` with
   signs - the rank-one collapse leaking through the number operators.

**Structural conclusion (with the atlas):** on the current single-ideal
packaging, NO probed operator - `tau_3`-family, `R3`-family, half-sum, or
number-difference in either order - separates the `X1`/`X2` doublet. The
realized `betaHat` families carry proportional weak content (rank-one
collapse), so the doublet separation cannot come from the weak omega-mode
sector at all; it must live in the H-SLOT packaging (the `R1`/`R2` slot
structure), which is exactly what the in-flight sixteen-slot census
(e0376e38) probes. The isospin-grading thread is CLOSED at operator level
pending the census; next attack is packaging-level, per the plan's
kill-condition discipline.

`Gnum` is kept as the definition of record; the false candidate statements
are intentionally NOT stated as theorems.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.IsospinNumberDifference

open PhysicsSM.Draft.NullEdge.DixonAlgebra
open PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon
open PhysicsSM.Draft.NullEdge.CompositionWeakCAR
open PhysicsSM.Draft.NullEdge.CompositionIdealRepContent

/-- The weak number-difference operator (creation-first order; the
annihilation-first variant behaves identically up to the same residuals). -/
def Gnum (d : Dixon) : Dixon :=
  betaHat1 (betaHat1dag d) - betaHat2 (betaHat2dag d)

end PhysicsSM.Draft.NullEdge.IsospinNumberDifference
