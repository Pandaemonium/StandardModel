# Lemma job: ultraviolet tail bound stated against the unitary object (MC5 support)

Mathlib-only, abstract. In a changing-lattice L2 argument the momentum integral is
split into a compact bulk (where a quantitative one-step estimate applies) and an
ultraviolet tail (where only unitarity is available). The tail step is often stated
loosely as "the multiplier error is bounded by 2". Make it exact.

With the L2 operator norm (`open scoped Matrix.Norms.L2Operator`) prove:
1. for `U V` unitary, `||U - V|| <= 2` (so any tail multiplier difference is
   bounded by 2 with NO regularity or mass hypothesis);
2. consequently, for a measurable family `q -> U q, V q` of unitaries and an
   `L2` function `f`, the tail contribution obeys
   `|| (fun q => (U q - V q) . f q) ||_{L2 over the tail set T} <= 2 * ||f||_{L2 over T}`;
3. therefore the tail error tends to 0 as the tail set shrinks (dominated
   convergence / `L2` tail vanishing for a fixed `f`), with the bound INDEPENDENT of
   the mass parameter.
State precisely the measurability hypothesis used. The point is that the tail
bound must be applied to genuinely UNITARY objects (an exponential surrogate need
not be unitary unless proved). No new axioms/native_decide; standard axioms; report axioms.
