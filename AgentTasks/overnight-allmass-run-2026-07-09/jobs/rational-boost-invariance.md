# claude-rational-boost-invariance — mass is boost-invariant: an explicit rational Lorentz boost preserves eta and det P = m^2

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

An adversarial audit stressed that "mass = det P" is frame-independent ONLY because `det P` is the
little-group SPINOR determinant, not an arbitrary 4-vector minor. Kernel-check the frame-independence
directly: exhibit an EXPLICIT RATIONAL Lorentz boost (a genuine element of SO(1,1) with rational
entries, thanks to the Pythagorean rapidity beta=3/5 => gamma=5/4), show it preserves the Minkowski
metric `eta`, and show the invariant mass squared is UNCHANGED under it. This grounds the boost-
invariance of the Plucker mass -- the property the audit flagged as load-bearing -- in a finite rational
avatar tied to the (+,-,-,-) convention.

## The model (finite, rational; 1+1D boost, then the 2x2 spinor det)

`eta2 = !![1, 0; 0, -1]` (the (t,x) Minkowski metric). The rational boost with beta = 3/5, gamma = 5/4,
gamma*beta = 3/4: `L = !![5/4, 3/4; 3/4, 5/4]` (symmetric boost in the (t,x) plane; `gamma^2 - (gamma
beta)^2 = 25/16 - 9/16 = 1`). A 2-momentum `p = ![E, k]` boosts as `L.mulVec p`. For the SPINOR side:
the little-group Hermitian `P(E,k) = !![E+k, 0; 0, E-k]` (the (t,z)-restricted `p.sigma`, real), with
`det P = E^2 - k^2 = m^2`.

## Targets (rational; ring/norm_num/fin_cases + Matrix.det_mul; NO Real, NO Complex, NO nlinarith deg>=3)

1. `boost_on_shell`: `L` is a Lorentz boost -- `Lᵀ * eta2 * L = eta2` (preserves the metric). By
   `fin_cases`/`Matrix.mul` + `norm_num`/`ring`. Hence `det L = 1` (`Matrix.det_fin_two`, `= 1`).
2. `boost_preserves_interval`: for any 2-momentum `p = ![E,k]`, the Minkowski square is invariant:
   `mdot2 (L.mulVec p) (L.mulVec p) = mdot2 p p` where `mdot2 u v = u 0*v 0 - u 1*v 1` (`= E^2-k^2`).
   By explicit computation + `ring`.
3. `mass_boost_invariant` (payload): the spinor determinant (mass^2) is boost-invariant. Boosting
   `p=(E,k)` to `p'=(E',k') = L.mulVec p`, then `det P(E',k') = det P(E,k) = E^2-k^2 = m^2`. Prove
   `(E'^2 - k'^2) = (E^2 - k^2)` for `E' = (5E+3k)/4, k' = (3E+5k)/4` by `ring`. So `mass^2` is the same
   in the boosted frame -- frame-independent.
4. `frame_dependence_control` (the audit's point): a SINGLE off-diagonal 4-vector minor is NOT boost-
   invariant -- exhibit a component (e.g. `E` itself, or a naive minor) that CHANGES under `L`
   (`(L.mulVec p) 0 != p 0` for an explicit `p`, e.g. `p=(1,0) -> (5/4, 3/4)`), contrasting with the
   invariant `det`. So only the determinant (not an arbitrary component/minor) is the mass.
5. `boost_invariance_verdict`: package -- an explicit rational Lorentz boost `L` (beta=3/5) preserves
   `eta`, preserves the interval, and leaves `mass^2 = det P = E^2-k^2` invariant, while individual
   momentum components change. So "mass = det P" is genuinely frame-independent BECAUSE it is the
   determinant (the little-group invariant), confirming the audit's convention point. Honest scope: a
   1+1D rational boost avatar (SO(1,1)), tied to the (+,-,-,-) convention; not the full SO(1,3).

MANDATORY non-degeneracy: the explicit boost `L` (beta=3/5, gamma=5/4); a massive `p=(5,3)` (m^2=16)
whose boost `p'` still has `E'^2-k'^2=16`; a null `p=(1,1)` staying null (`E'^2-k'^2=0`); the changed
component `p=(1,0) -> (5/4,3/4)`. All in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. Rational 2x2 + mulVec; Matrix.det_fin_two/det_mul + fin_cases + ring/norm_num;
NO Real.sqrt/cos/sin/cosh/sinh, NO Complex, NO nlinarith deg>=3. Build under 3 min. Deliver
RequestProject/Main.lean (namespace RationalBoostInvariance) + ARISTOTLE_SUMMARY.md.
