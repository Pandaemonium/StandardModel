# Suite D rung D5 — a finite Compton bound: the mass gap is a length floor

## Context (blind to the wider repo; seeds in `seeds/`, Mathlib only)

A finite "null-edge" program reads mass as a resource. Two seed results make the
"mass = 1/length" reading concrete on the 2-point Krein carrier:

- `seeds/SuiteAOp2Geom.lean` (namespace `SuiteA_Op2Geom`): the causal spectral
  distance `dCausal m 0 1 = 1/m` (`dCausal_01`) — the Connes/Franco–Eckstein
  distance between the two carrier points is exactly the inverse mass. So `1/m`
  is already the carrier's intrinsic length scale (a finite Compton wavelength).
- `seeds/SpectralDistance.lean` (namespace `NullEdge`): the Euclidean version
  (`spectralDist`, `fwit_sep = 1/m`) and the Lipschitz-ball machinery.

**Target reading (D5).** No `J`-positive one-particle codeword can be localized
below the scale `1/gap`: the mass gap is a hard floor on localization length.
Make this a finite theorem, not a slogan.

## Targets (prove; each kernel-checked)

Work on the 2-point (and, if clean, `C^2`-mode) carrier with mass `m > 0` and its
Dirac `D m` from the seeds. Define a **localization width** `width(psi)` of a
normalized state `psi` — e.g. the spread of the position observable `X = diag(x)`
(with `x 0 = 0`, `x 1 = 1` the two points), `width(psi)^2 = <psi|X^2|psi> -
<psi|X|psi>^2`, or the Connes-distance-weighted spread — chosen so it is a genuine
finite quadratic form.

1. `compton_floor` : for every normalized `psi` in the `J`-positive sector,
   `width(psi) >= c / m` for an explicit constant `c > 0` (an uncertainty-type
   lower bound: a state sharply localized at one point costs energy `>= m` via the
   Dirac operator `‖[D m, X]‖`-type commutator bound). State `c` explicitly.
2. `compton_floor_tight` : the bound is SATURATED — exhibit an explicit optimizer
   `psi*` with `width(psi*) = c/m`, so the floor is achieved, not merely a bound.
   **MANDATORY non-degeneracy fixture:** give the optimizer and the width value
   at an explicit rational `m = 3` (width `= c/3`, a specific nonzero rational or
   algebraic number) — so "floor" is not vacuous.
3. `compton_scale_eq_spectral_distance` : identify the floor `c/m` with the causal
   spectral distance `dCausal m 0 1 = 1/m` (up to the explicit constant `c`) — the
   localization length floor IS the Connes distance, so "mass gap = length floor"
   and "mass = 1/distance" are the same statement.

## Kills (state as theorems)

- An explicit `J`-positive normalized state with `width < c/m` (sub-Compton
  localization) — kills the floor.
- The floor is `0` or `m`-independent — the gap does not set a length.

## Constraints (hard)

Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only.
Footprint exactly `[propext, Classical.choice, Quot.sound]`, verified in-file with
`#guard_msgs (whitespace := lax) in #print axioms <thm>` on every headline theorem.
Deliver `RequestProject/Main.lean` (namespace `SuiteD_Compton`) +
`ARISTOTLE_SUMMARY.md`: the definition of `width` you used, the constant `c`, the
non-degeneracy optimizer at `m = 3`, and an honest note on whether target 3's
identification is exact or up to the constant.
