# Job: the never-antipodal threshold - when does a perturbed endpoint map keep its winding?

Mathlib-only, self-contained. This replaces a vanishing-limit gate with a THRESHOLD gate.

## Why
A topological invariant (the winding/degree of a periodic endpoint map into `SU(2) ~ S^3`)
is currently defended only for an EXACTLY closed spectral sector. Relaxing to an
approximately closed sector perturbs the endpoint map, and a separate no-go shows the
natural leakage bound converges to a positive constant rather than to zero. But a degree
does not need a vanishing perturbation - it only needs one below a threshold, because
degree is locally constant. This job makes that threshold explicit and elementary.

## Targets
Work with maps into the unit sphere of a real inner-product space, or concretely
`S^3` realized as unit quaternions / `SU(2)`. Let `X` be a topological space (the
three-torus in the application; keep it general).

1. **Never-antipodal implies homotopic (the threshold lemma).** For continuous
   `f g : X -> S` into a sphere `S` (unit vectors in a real inner-product space), suppose
   for all `x`, `f x <> - g x` (equivalently `‖f x - g x‖ < 2`, equivalently
   `f x + g x <> 0`). Prove `f` and `g` are homotopic, via the explicit normalized
   geodesic/straight-line homotopy
   `H t x = (1 - t) • f x + t • g x` normalized by its norm - and prove the normalization
   is legitimate, i.e. `(1 - t) • f x + t • g x <> 0` for `t` in `[0,1]` exactly under the
   never-antipodal hypothesis. Continuity of `H` must be proved, not assumed.
2. **The explicit sup-norm form.** Deduce: if `‖f x - g x‖ < 2` for all `x`, then
   `f` and `g` are homotopic. State the threshold `2` explicitly and note it is SHARP:
   exhibit antipodal maps at distance exactly `2` that are NOT homotopic (for instance
   `f = id` and `g = -id` on `S^1` or `S^3` when the degree differs - if a full degree
   argument is heavy, at least exhibit the pair and state which classical fact separates
   them, without claiming to prove it).
3. **Uniform version for a family.** If `f_n -> f` uniformly and `f` is continuous into
   the sphere, then for all large `n`, `f_n` is homotopic to `f`. (Immediate from 2, but
   state it - this is the form the application uses.)
4. **The application-shaped corollary, stated abstractly.** If a perturbation of an
   endpoint map has uniform size `< 2` in the sphere metric, then any homotopy-invariant
   quantity of the map is unchanged. Do NOT formalize degree theory; state the corollary
   as: homotopy class is preserved, hence every homotopy invariant is preserved.

## Constraints
- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only; report `#print axioms` per main theorem.
- Prefer Mathlib's existing sphere/homotopy API (`ContinuousMap.Homotopy`, `Metric.sphere`,
  normalization lemmas) over rebuilding it.
- A KERNEL REFUTATION - e.g. the geodesic homotopy failing to be continuous at the poles,
  or the threshold being smaller than `2` - is a first-class result.
- Docstring scope: this is elementary homotopy theory. It says nothing about whether any
  particular physical perturbation is below the threshold.
