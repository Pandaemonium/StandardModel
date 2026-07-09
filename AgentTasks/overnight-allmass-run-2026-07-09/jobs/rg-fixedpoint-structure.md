# claude-rg-fixedpoint-structure — the fixed-point set of the null-edge RG map (is the Dirac point special?)

## Context (blind to any repo; self-contained rational algebra, Mathlib only)

A landed result gives the exact rational RG map `R2(lam,kap) = (lam - 2 kap^2/lam, -kap^2/lam)`
(and its 3/4-channel extensions), with the critical LINE `|kap|=|lam|` invariant and relevant
eigenvalue 2 at criticality. Characterize the FIXED-POINT SET of R2 (points with R2(x)=x) and the
structure of the flow, to see whether the free-Dirac / Gaussian structure is special.

## Targets (exact rational algebra on R2)

1. `fixed_points`: solve `R2(lam,kap) = (lam,kap)` exactly over the rationals/reals: prove the
   fixed points are exactly the DECOUPLED line `kap = 0` (any lam) — i.e. `R2(lam,0)=(lam,0)` — plus
   any additional solutions you find (show `-kap^2/lam = kap` forces `kap=0` or `kap=-lam`, and check
   which are genuine fixed points vs period-2). State the complete fixed-point set precisely.
2. `critical_line_period2`: on the critical line `kap = lam`, R2 acts as the sign-flip
   `(lam,lam) -> (-lam,-lam)` (period-2 orbit), NOT a fixed point — so the massless line is an
   invariant SET on which R flows, with the genuine fixed line being `kap=0` (decoupled/massive).
3. `flow_toward_decoupled` (payload): prove the decoupled line `kap=0` is the attractor of the
   massive region in the closure direction — e.g. `|kap'| = kap^2/|lam| < |kap|` when `|kap| < |lam|`
   (massive phase): under decimation the closure coupling SHRINKS, flowing toward the free/decoupled
   `kap=0` fixed line. So massive theories flow to free (Gaussian) — the Dirac/Gaussian point is the
   IR attractor of the massive basin.
4. `basin_verdict`: package — the fixed-point set is the free line `kap=0`; the critical line is a
   period-2 invariant set (the boundary); the massive region flows to the free point (closure
   irrelevant in the massive phase), the critical region is the separatrix with the relevant
   eigenvalue 2. This is the finite-rational skeleton of "the Dirac fixed point governs the flow."

MANDATORY non-degeneracy: exhibit the shrinking explicitly at a rational massive point, e.g.
`R2(1, 1/2) = (1/2, -1/4)`: `|kap|` goes `1/2 -> 1/4` (shrinks), stated in-theorem; and the
period-2 orbit `R2(1,1) = (-1,-1)`, `R2(-1,-1) = (1,1)`.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. Rational/real; ring/norm_num/decide/fin_cases + simple inequalities via
nlinarith on LOW-degree (the shrinking is quadratic); NO Complex, NO Real.cos/sin/sqrt. Handle the
`lam != 0` domain explicitly. Build under 3 min. Deliver RequestProject/Main.lean (namespace
RGFixedPointStructure) + ARISTOTLE_SUMMARY.md.
