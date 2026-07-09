# claude-zitterbewegung-average — drift velocity is the mass-weighted average of +-c luminal motion

## Context (blind to any repo; self-contained finite algebra, Mathlib only)

Reconcile the two landed halves: instantaneous velocity is always +-c (velocity operator
eigenvalues +-1), yet the observable DRIFT is subluminal ||v||^2 = 1 - m^2/E^2. The bridge
is Zitterbewegung: the drift is the TIME-AVERAGE (convex combination) of the +-c luminal
motion, with the mass setting the mixing. Prove the finite averaging identity.

## The model (2-state luminal model; all rational/real)

A single momentum mode has two "luminal channels": a right-mover with velocity +1 and a
left-mover with velocity -1 (the two velocity-operator eigenstates). A stationary state at
momentum p, energy E occupies them with weights w_+ , w_- (w_+ + w_- = 1, w_i >= 0). The
mean velocity is vbar = w_+ (+1) + w_- (-1) = w_+ - w_-.

To stay sqrt-free, PARAMETRIZE by rational p, E on a Pythagorean shell (so m, p, E are a
rational triple, e.g. (m,p,E) = (3,4,5) or (4,3,5)), and DEFINE the occupation imbalance by
the physical Dirac value w_+ - w_- = p/E. Then:

## Targets

1. `mean_velocity_eq_p_over_E`: with w_+ - w_- = p/E (and w_+ + w_- = 1, giving
   w_+ = (1 + p/E)/2, w_- = (1 - p/E)/2, both in [0,1]), the mean velocity vbar = p/E.
   Prove w_+, w_- in [0,1] (valid convex weights) for |p| <= E.
2. `drift_subluminal_from_average` (payload): vbar^2 = (p/E)^2 = 1 - m^2/E^2 on the
   Pythagorean shell p^2 + m^2 = E^2 -- i.e. the drift speed-squared is exactly
   1 - m^2/E^2 (matching the landed mass-entropy dictionary), obtained as the square of a
   convex average of +-1. So the subluminal drift IS averaged luminal motion.
3. `massless_limit`: m = 0 (shell p = E) => w_- = 0, vbar = 1 -- a massless fermion
   is purely one luminal channel, moving at exactly c (no zigzag). m = E (p=0, rest) =>
   w_+ = w_- = 1/2, vbar = 0 -- rest = maximal +-c zigzag averaging to zero drift.
4. `zitterbewegung_verdict`: package 1-3 -- the observable velocity is always a convex
   average of the instantaneous +-c; the mass fraction m/E sets the imbalance; rest is a
   50/50 luminal zigzag; massless is a single luminal channel. Instantaneous-luminal and
   drift-subluminal are the same fact at two timescales.

MANDATORY non-degeneracy: instantiate on (m,p,E) = (3,4,5): w_+ = 9/10, w_- = 1/10,
vbar = 4/5, vbar^2 = 16/25 = 1 - 9/25 -- all explicit rationals stated in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print
axioms <thm>` on every headline. Rational/real; ring/norm_num/decide/fin_cases; parametrize by
rational Pythagorean triples so NO Real.sqrt; NO Complex; NO nlinarith deg>=3. Build in-project
under 3 min. Deliver RequestProject/Main.lean (namespace ZitterbewegungAverage) +
ARISTOTLE_SUMMARY.md with honest scope (a finite 2-channel model tying the landed halves).
