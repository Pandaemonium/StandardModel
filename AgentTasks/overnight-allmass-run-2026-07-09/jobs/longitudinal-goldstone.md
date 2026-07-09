# claude-longitudinal-goldstone — the massive vector's third polarization IS the mass: explicit longitudinal mode, singular as m->0

## Context (blind to any repo; self-contained finite Minkowski linear algebra, Mathlib only)

Sharpen the gauge-boson side of "mass from massless": a massless vector (photon) has 2 transverse
polarizations; a massive vector (W/Z) has 3 -- the extra LONGITUDINAL mode is the eaten would-be-
Goldstone, and it IS the mass. Make this explicit and rational: exhibit the longitudinal polarization
4-vector, prove it is correctly normalized and physical under the Minkowski metric, that it is
orthogonal to the momentum, and that it is SINGULAR as m -> 0 (diverges like p/m) -- so the third
polarization cannot survive the massless limit, which is exactly why the photon has only 2.

## The model (finite, rational; (+,-,-,-) Minkowski)

Metric `eta = diag(1,-1,-1,-1)` on `Fin 4 -> Q`. Minkowski product `mdot u v = u0 v0 - u1 v1 - u2 v2 -
u3 v3`. On-shell momentum `p = ![E, 0, 0, k]` with `E^2 - k^2 = m^2` (so `mdot p p = m^2`). Longitudinal
polarization `epsL = ![k/m, 0, 0, E/m]`. Transverse polarizations `epsT1 = ![0,1,0,0]`, `epsT2 =
![0,0,1,0]`. Use the explicit rational on-shell point `E=5, k=3, m=4` (`5^2-3^2=16=4^2`) for witnesses.

## Targets (rational; ring/norm_num/decide/fin_cases; NO Real transcendental, NO Complex, NO nlinarith deg>=3)

1. `epsL_normalized`: `mdot epsL epsL = -1` (spacelike, unit-normalized like a physical polarization):
   `(k/m)^2 - (E/m)^2 = (k^2 - E^2)/m^2 = -m^2/m^2 = -1`, using `E^2 - k^2 = m^2`. By `field_simp`/`ring`
   with `m != 0`.
2. `epsL_orthogonal_p`: `mdot epsL p = 0` (the longitudinal polarization is orthogonal to the momentum,
   as a physical polarization must be): `(k/m)E - (E/m)k = 0`. By `ring`.
3. `transverse_normalized_orthogonal`: `mdot epsT1 epsT1 = -1`, `mdot epsT2 epsT2 = -1`, `mdot epsT1 p =
   0`, `mdot epsT2 p = 0`, and the three polarizations are mutually `mdot`-orthogonal -- a valid
   3-polarization spacelike frame for the massive vector.
4. `longitudinal_singular` (payload): as `m -> 0` the longitudinal mode diverges -- `epsL` scaled by `m`
   tends to the null momentum direction: `m . epsL = ![k, 0, 0, E]`, and in the massless limit `E = k`
   (from `m=0`) this is `k . ![1,0,0,1]`, PROPORTIONAL to the null momentum `![k,0,0,k]`. So `epsL`
   itself (unscaled) blows up like `1/m` and its direction collapses onto the momentum -- it is not an
   independent physical polarization at `m=0`. State the finite facts: `m . epsL = ![k,0,0,E]` (by
   `field_simp`), and at `m=0` (`E=k`) the momentum `![E,0,0,k] = ![k,0,0,k]` is NULL (`mdot p p = 0`)
   with only the 2 transverse polarizations surviving.
5. `longitudinal_is_mass_verdict`: package -- a massive vector carries 3 mutually-orthogonal spacelike
   polarizations (2 transverse + 1 longitudinal), the longitudinal one normalized `mdot = -1` and
   orthogonal to `p`; it is singular as `m -> 0` (scales as `1/m`, direction collapses onto the null
   momentum), so the massless limit keeps only 2 transverse modes. The third polarization is the mass:
   `pol = 2 (massless) + [m != 0] = 3`. Honest scope: a single on-shell momentum, finite rational
   avatar of the Goldstone-equivalence / longitudinal-enhancement fact; not the full field theory.

MANDATORY non-degeneracy: the explicit witness `E=5,k=3,m=4`: `epsL=![3/4,0,0,5/4]`, `mdot epsL epsL =
-1`, `mdot epsL p = 0`, `4 . epsL = ![3,0,0,5]`; and the massless contrast `E=k=1,m=0`: `p=![1,0,0,1]`
null (`mdot p p = 0`). All in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. Rational `Fin 4 -> Q` vectors + explicit mdot; field_simp/ring/norm_num/
decide/fin_cases (carry `m != 0` where needed); NO Real.sqrt/cos/sin, NO Complex, NO nlinarith deg>=3.
Build under 3 min. Deliver RequestProject/Main.lean (namespace LongitudinalGoldstone) +
ARISTOTLE_SUMMARY.md.
