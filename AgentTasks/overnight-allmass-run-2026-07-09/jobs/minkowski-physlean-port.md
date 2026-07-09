# claude-minkowski-physlean-port — ground our Minkowski convention in Mathlib's indefiniteDiagonal (PhysLean provenance)

## Context (blind to any repo; Mathlib only; a PROVENANCE port)

Our mass-from-massless modules hand-roll the Minkowski metric `eta = diag(1,-1,-1,-1)`. PhysLean
defines the canonical `minkowskiMatrix {d} : Matrix (Fin 1 (+) Fin d) (Fin 1 (+) Fin d) R :=
LieAlgebra.Orthogonal.indefiniteDiagonal (Fin 1) (Fin d) R` -- the `diag(1,-1,...,-1)`
mostly-minus convention (SAME as ours). The underlying `indefiniteDiagonal` is a MATHLIB
declaration, so we can use it directly (no PhysLean import) and record the convention provenance.
Port: state our `eta` on `Fin 4`, prove it agrees with the reindexed Mathlib `indefiniteDiagonal`
form (= PhysLean's `minkowskiMatrix` convention), and prove the basic null-vector identity our
modules use. Provenance: clean-room port of the PhysLean `minkowskiMatrix` convention
(`Physlib`/`.../Lorentz`, Tooby-Smith), built on the Mathlib `indefiniteDiagonal`.

## Targets (Mathlib only; explicit)

1. `eta_def` / `eta_eq_indefiniteDiagonal`: define `eta : Matrix (Fin 4) (Fin 4) R := !![1,0,0,0;
   0,-1,0,0; 0,0,-1,0; 0,0,0,-1]` and prove it equals the reindexing of
   `LieAlgebra.Orthogonal.indefiniteDiagonal (Fin 1) (Fin 3) R` under the standard
   `Fin 4 ~= Fin 1 (+) Fin 3` equiv (`finSumFinEquiv`/`finCongr`) -- i.e. our hand `eta` IS the
   Mathlib/PhysLean Minkowski matrix, convention-checked. If the reindexing is heavy, at minimum
   prove `eta` is symmetric, `eta * eta = 1` (involutive), `eta.det = -1`, `trace eta = -2`, and
   `indefiniteDiagonal (Fin 1) (Fin 3) R` has the SAME diagonal entries (a diagonal-entry match).
2. `minkowskiForm`: `mink u v := u^T eta v` (the Minkowski inner product); prove bilinearity and
   `mink u u = u0^2 - u1^2 - u2^2 - u3^2` (the signature).
3. `null_iff`: `mink u u = 0 <-> u0^2 = u1^2 + u2^2 + u3^2` -- the null-cone condition our
   photon/boost modules use; instantiate on the null witness `u = (1,1,0,0)` (`mink u u = 0`) and
   the timelike witness `u = (5,3,0,0)` (`mink u u = 16`).
4. `convention_note`: a theorem-let recording the mostly-minus convention `(+,-,-,-)` matches
   PhysLean `minkowskiMatrix` and Mathlib `indefiniteDiagonal` -- e.g. `eta 0 0 = 1 AND eta 1 1 =
   -1` stated explicitly (provenance anchor).

MANDATORY non-degeneracy: the null witness `(1,1,0,0)` and timelike `(5,3,0,0)` with their `mink`
values (0 and 16) explicit in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only (use
`LieAlgebra.Orthogonal.indefiniteDiagonal` from Mathlib; do NOT import PhysLean). Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. REAL rational 4x4/vectors; ring/norm_num/decide/fin_cases; NO Complex, NO
Real.sqrt/cos/sin, NO nlinarith deg>=3. Build under 3 min. Deliver RequestProject/Main.lean
(namespace MinkowskiConvention) + ARISTOTLE_SUMMARY.md WITH the provenance line (PhysLean
minkowskiMatrix + Mathlib indefiniteDiagonal, convention (+,-,-,-)).
