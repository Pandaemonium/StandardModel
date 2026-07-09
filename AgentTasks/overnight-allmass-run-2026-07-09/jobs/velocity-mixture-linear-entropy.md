# claude-velocity-mixture-linear-entropy — mass^2 = 2E^2 * (linear entropy of the +/-c velocity mixture)

## Context (blind to any repo; self-contained finite RATIONAL algebra, Mathlib only)

The program has two kernel-checked finite facts about a massive Dirac fermion's internal motion:
its instantaneous velocity operator has spectrum exactly `{+1,-1}` (`= +/-c`, the luminal "zigzag"),
and for a stationary mode the observable mean velocity is `vbar` with `vbar^2 = 1 - m^2/E^2 = (p/E)^2`
(the mass-weighted average of the `+/-c` motion; `p` = momentum, `E` = energy, on shell `m^2 = E^2 - p^2`).

This job adds the INFORMATION-THEORETIC entry of that mass-drift dictionary, using a RATIONAL entropy
(the LINEAR entropy / impurity `S_L = 1 - Tr rho^2`, the standard rational proxy used when the Shannon
entropy `-sum p log p` is intractable -- here it keeps everything rational, NO logs/transcendentals).

Model the `+/-c` motion as a 2-outcome classical distribution over the velocity eigenvalues `{+1,-1}`
with the correct mean `vbar = p/E`:

  `pplus = (E + p)/(2E)`,   `pminus = (E - p)/(2E)`     (valid: `pplus + pminus = 1`, both `>= 0` for `|p| <= E`).

Its linear entropy (impurity) is

  `S_L = 1 - (pplus^2 + pminus^2) = 2 * pplus * pminus = (E^2 - p^2)/(2 E^2) = m^2/(2 E^2)`.

So `mass^2 = 2 E^2 * S_L`: the mass squared is exactly `2E^2` times the linear entropy of the luminal
velocity mixture. Massless (`p = +/- E`) => `S_L = 0` (a PURE single luminal channel, zero impurity);
rest (`p = 0`, `m = E`) => `S_L = 1/2` (MAXIMAL impurity for a 2-outcome mixture, the 50/50 zigzag).
Mass is the impurity/spread of the `+/-c` velocity mixture. (All identities verified exactly over the
rationals for several witnesses before this handoff.)

## HONEST framing (state this in the module docstring and ARISTOTLE_SUMMARY.md)

This is the LINEAR entropy (a rational `1 - Tr rho^2` proxy), NOT the Shannon entropy. The result is a
corollary-level RESTATEMENT of the drift relation `vbar^2 = 1 - m^2/E^2` in information-theoretic
language: `S_L = (1 - vbar^2)/2`. The VALUE is the interpretation / connection (mass^2 = velocity-mixture
impurity), not proof depth. Do NOT call it Shannon entropy or claim more than a rational-entropy proxy.

## The model (rational; parametrize by E, p : Q with E > 0)

`Q := ℚ`. `pplus E p := (E + p)/(2*E)`, `pminus E p := (E - p)/(2*E)`, `SL E p := 1 - (pplus E p ^2 +
pminus E p ^2)`, and the mass via `msq E p := E^2 - p^2` (on-shell `m^2`).

## Targets (rational; field_simp/ring/norm_num, carry E != 0; NO Real.log, NO transcendental, NO Complex, NO nlinarith)

1. `dist_normalized`: `pplus E p + pminus E p = 1` (for `E != 0`). `field_simp; ring`.
2. `dist_nonneg`: for `0 < E` and `|p| <= E` (i.e. `-E <= p` and `p <= E`), `0 <= pplus E p` and
   `0 <= pminus E p` (a valid probability distribution). Use `div_nonneg`, `by linarith`.
3. `mean_is_drift`: `pplus E p * 1 + pminus E p * (-1) = p / E` (for `E != 0`): the drift `vbar = p/E`
   is the mean of the `+/-c` velocity eigenvalues. `field_simp; ring`.
4. `linear_entropy_closed` (PAYLOAD): `SL E p = (E^2 - p^2)/(2 * E^2)` (for `E != 0`), i.e.
   `SL E p = msq E p / (2 * E^2)`. So `msq E p = 2 * E^2 * SL E p`. `field_simp; ring`.
5. `mass_sq_eq_two_Esq_SL` (PAYLOAD): `msq E p = 2 * E^2 * SL E p` (for `E != 0`) -- mass^2 = 2E^2 times
   the linear entropy. From target 4 by `field_simp`/`ring`.
6. `massless_pure`: at `p = E` (and `p = -E`), `SL E E = 0` and `SL E (-E) = 0` (for `E != 0`): the
   massless mixture is PURE (one luminal channel, zero impurity); correspondingly `msq E E = 0`.
7. `rest_maximal`: at `p = 0`, `SL E 0 = 1/2` (for `E != 0`): the rest mixture is MAXIMALLY impure
   (50/50 zigzag), and `msq E 0 = E^2` (`m = E` at rest).
8. `velocity_linear_entropy_verdict` (VERDICT): package -- `pplus,pminus` are a valid 2-outcome
   distribution with mean `p/E`; its linear entropy is `SL = (E^2-p^2)/(2E^2) = m^2/(2E^2)`, so
   `m^2 = 2 E^2 * S_L`; `S_L = 0` exactly at masslessness (`p^2 = E^2`, pure single channel) and
   `S_L = 1/2` at rest (`p = 0`, maximal mixing). The rational-linear-entropy face of the mass-drift
   dictionary: mass = the impurity of the `+/-c` velocity mixture.

MANDATORY non-degeneracy (all in-theorem, explicit, by `norm_num`): massive witness `E=5, p=3`
(`msq=16`, `pplus=4/5`, `pminus=1/5`, `SL=8/25`, and `16 = 2*25*(8/25)`); rest witness `E=5, p=0`
(`SL=1/2`, `msq=25`); massless witness `E=5, p=5` (`SL=0`, `msq=0`). Also exhibit `SL 5 3 != 0` and
`SL 5 3 != 1/2` (a genuine intermediate impurity).

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on EVERY headline. Purely rational (Q = ℚ); field_simp/ring/norm_num carrying `E != 0`; NO
Real.log/sqrt/cos/sin, NO Complex, NO nlinarith. Build under 3 min. Deliver RequestProject/Main.lean
(namespace `VelocityMixtureLinearEntropy`) + ARISTOTLE_SUMMARY.md WITH the HONEST framing paragraph
(linear entropy = rational proxy, corollary-level restatement of the drift relation; provenance = the
linear entropy / purity `1 - Tr rho^2` notion, standard quantum information, clean-room, not imported).
