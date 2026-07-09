# claude-lambda-unimodular — the finite unimodular trade: Lambda is the count-constraint multiplier; the mean is gauge

## Context (blind to any repo; self-contained finite rational algebra, Mathlib only)

In unimodular gravity the cosmological constant is not a coupling but a Lagrange MULTIPLIER
conjugate to the spacetime volume: constrain the volume, and the field equation acquires a
`+Lambda * 1` term with Lambda undetermined by the local dynamics (Jacobson's integration
constant); shifting the vacuum term is GAUGE on the constraint surface (unobservable), and only
fluctuations of the count are physical. Prove the finite avatar. A landed sibling exists for the
null-cone constraint (stationarity <=> `M(psi) gamma = mu eta gamma`); this is the same
multiplier pattern with the VOLUME/trace functional as the constraint.

## The model (explicit rational; small dimension)

State space `R^n` (n = 3 or 4). An action `S(x) = <x, A x> + c * <x, x>` with `A` an explicit
rational symmetric matrix (the dynamical part) and `c * <x,x>` the "vacuum/order-0" term
(`c` rational — the analogue of `a0 tr(1)` per unit state norm). The volume/count constraint:
`Vol(x) = <x, x> = v0` (a fixed positive rational).

## Targets

1. `multiplier_field_equation` (payload 1): constrained stationarity of `S` on `Vol = v0` <=>
   there exists `Lambda : R` with `A x + c*x = Lambda * x` — the field equation acquires the
   `+Lambda * 1` (identity-proportional) term, with `Lambda` the multiplier. Both directions via
   HasDerivAt (the pattern that built cleanly before).
2. `vacuum_shift_is_gauge` (payload 2): shifting the vacuum term `c -> c + delta` changes the
   action ON THE CONSTRAINT SURFACE by the constant `delta * v0` (state-independent), and maps
   solutions to solutions with `Lambda -> Lambda + delta`: the (mean) vacuum coefficient is pure
   gauge under the count constraint — only the constraint-relative data is physical. Exhibit the
   explicit solution map.
3. `trace_channel_blind` (the structural magnitude-dissolution lemma): `tr(1)` (the order-0
   functional `x |-> dim` or `D |-> Fintype.card`) is INVARIANT under every deformation of the
   dynamical operator: for ALL rational symmetric `A, A'` (any gauge move, channel coupling,
   soldering decoration), `tr (1 : Matrix n n R) = n` is unchanged — there is NO channel pathway
   into the order-0 coefficient; only count statistics can touch Lambda. (Trivial arithmetic with
   a non-trivial reading — state it as the invariance of the order-0 term of the finite spectral
   action under `D -> D + any perturbation`, i.e. the a0-term of `a0*tr(1) + a2*tr(D^2)` does not
   depend on `D`.)
4. `unimodular_verdict`: package 1-3 — Lambda enters ONLY as the count-constraint multiplier
   (integration constant); the vacuum mean is gauge; the order-0 coefficient is blind to all
   dynamics. So in the finite theory the only physics that can touch Lambda is count statistics.
   Honest scope: a finite n-dim avatar of the unimodular trade, not continuum unimodular gravity.

MANDATORY non-degeneracy: explicit rational witness — `A = diag(1,2,3)`-type, `v0 = 1`,
an explicit constrained stationary point with `Lambda` a specific nonzero rational; the gauge
shift exhibited with `delta = 5` mapping it to `Lambda + 5`; plus a control point that is NOT
stationary (the equation genuinely selects). All values stated in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print
axioms <thm>` on every headline. REAL rational matrices/vectors; ring/norm_num/decide/fin_cases +
HasDerivAt; NO Complex, NO Real.sqrt/cos/sin, NO nlinarith deg>=3. Build under 3 min. Deliver
RequestProject/Main.lean (namespace LambdaUnimodular) + ARISTOTLE_SUMMARY.md.
