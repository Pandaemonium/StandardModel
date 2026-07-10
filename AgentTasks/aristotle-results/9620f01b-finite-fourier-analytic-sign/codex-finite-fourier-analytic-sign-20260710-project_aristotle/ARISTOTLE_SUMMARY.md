# Summary of changes for run df8b67c2-4a03-4cb4-8fb3-12967918b09b
Proved all six targets in `FiniteFourierAnalyticSign/Core.lean` without changing any statement. The file builds cleanly and every target uses only the standard axioms (`propext`, `Classical.choice`, `Quot.sound`); no `sorry`/`admit` remain.

Proof outline (conventions preserved throughout — positive-exponential character, negative lattice momentum, ordered axis0·axis1·axis2·mass product, and the quarter-zone −i sign):

- Target 1 `stdAddChar_val_formula`: rewrite via `ZMod.stdAddChar_apply` and `ZMod.toCircle_apply`, giving the exact `exp(2πi·q.val/L)` character.
- Target 2 `shiftPhase_eq_analytic_neg`: with `θ = -(latticeAngle (k axis))`, Euler's formula (`Complex.exp_mul_I`) plus Target 1 give the forward channel `stdAddChar (k axis) = cos θ − sin θ·i` and, via `AddChar.map_neg_eq_inv`, the backward channel `stdAddChar (-(k axis)) = cos θ + sin θ·i`. A case split on `velocity axis a` matches these to `analyticPhase`, so the backward source shift carries the sign flip.
- Target 3 `finitePhaseDiag_eq_analytic_neg`: `funext` on the diagonal entries reduces to Target 2.
- Target 4 `finiteAxisSymbol_eq_analytic_neg`: rewrite the conjugated block `U · diag · Uᴴ` using Target 3.
- Target 5 `finiteLocalSymbol_eq_analytic_neg`: rewrite each of the three ordered axis factors (axis 0, 1, 2) with Target 4; the mass coin is untouched.
- Target 6 `quarter_zone_sign_control`: `(1 : ZMod 4).val = 1` gives `latticeAngle 1 = π/2`; the analytic phase at `-(π/2)` evaluates to `-i` via `cos_pi_div_two`/`sin_pi_div_two`; and the finite backward shift at quarter momentum equals it through Target 2, confirming the shared `-i` sign.

All statements are unchanged from the original file; no target was weakened or found malformed.
