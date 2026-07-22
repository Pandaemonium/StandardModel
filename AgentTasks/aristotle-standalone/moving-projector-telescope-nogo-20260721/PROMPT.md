# Job: the moving-projector telescope CANNOT certify vanishing sector leakage

Mathlib-only, self-contained. This is a targeted NO-GO against a proposed proof route.
A kernel refutation of my claim is a first-class result and I want to know if I am wrong.

## The route under test
A collaborator proposes this hierarchy for a moving low-energy sector:
- define instantaneous band projectors `P_k` from an isolated spectral cluster of `H_k`;
- for substeps `U_k`, bound `||(1 - P_(k+1)) U_k P_k|| <= delta_k`;
- conclude `total leakage <= sum_(k<N) delta_k`;
- **gate: require `sum_(k<N) delta_k -> 0` as the depth `N -> infinity`.**

## My claim: that gate is unreachable whenever the band actually moves
Key observation: `U_k = exp(-i H_k dt)` is a function of `H_k`, so it **commutes with its
own spectral projector `P_k`**. Hence
`(1 - P_(k+1)) U_k P_k = (1 - P_(k+1)) P_k U_k`, and since `U_k` is unitary,
`delta_k = ||(1 - P_(k+1)) P_k||` **exactly** - the pure geometric misalignment of
successive bands, with the dynamics dropping out entirely.

For a band rotating through a fixed total angle `Theta` in `N` equal steps, that
misalignment is `sin (Theta / N)` per step, so
`sum_(k<N) delta_k = N * sin (Theta / N) -> Theta`, **not** `0`.
The sum is also monotone in `N`, so refining the discretization never helps.

## Targets

1. **Concrete rotating band.** For `theta : R`, let
   `u theta : EuclideanSpace R (Fin 2) := ![cos theta, sin theta]` and let `P theta` be
   the orthogonal projection onto `span {u theta}` (equivalently the `2 x 2` matrix
   `!![cos^2, cos*sin; cos*sin, sin^2]`). Prove
   `||(1 - P (theta + phi)) * P theta|| = |sin phi|`
   (operator norm; rank-one, so this is an exact computation).
2. **The dynamics drop out.** Prove: if `U` is unitary and `U * P theta = P theta * U`,
   then `||(1 - P (theta + phi)) * U * P theta|| = |sin phi|` - **the same value**,
   independent of `U`. This is the heart of the objection: the per-step leakage bound is
   purely geometric and cannot be improved by choosing better dynamics, because the
   spectral projector commutes with its own evolution.
3. **The telescope sum.** With `phi = Theta / N` and `N` steps, prove
   `sum_(k < N) |sin (Theta / N)| = N * |sin (Theta / N)|`.
4. **IT DOES NOT VANISH - the no-go.** Prove that for `0 < Theta <= pi/2` and every
   `N >= 1`, `N * sin (Theta / N) >= (2 / pi) * Theta > 0`.
   (Jordan's inequality `sin x >= (2/pi) x` on `[0, pi/2]` gives it immediately; prove or
   locate that inequality in Mathlib.) **Conclude: the telescope bound is bounded below
   by a positive constant independent of `N`, so the gate `sum delta_k -> 0` can never be
   met by this route for a band with nonzero total rotation.**
5. **Sharp limit.** Prove `N * sin (Theta / N) -> Theta` as `N -> infinity` (i.e.
   `Filter.Tendsto (fun N => N * sin (Theta / N)) atTop (nhds Theta)`). So the bound does
   not merely fail to vanish - it converges to the total rotation angle.
6. **Where the real smallness must come from (state, do not prove).** The genuine
   adiabatic theorem gets its `O(1 / (T * gap))` smallness from oscillatory CANCELLATION
   between steps (integration by parts / resolvent commutator identities), which the
   triangle inequality discards. Record in the docstring that this module refutes the
   TELESCOPE ROUTE, not adiabaticity itself, and that a genuine adiabatic estimate
   (Kato / Nenciu / Hastings quasi-adiabatic generator) is the correct replacement.

## Constraints
- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only; report `#print axioms` per main theorem.
- If target 2 is FALSE as stated (e.g. the operator norm differs when `U` is a nontrivial
  phase on the band), report the correct identity - that would weaken my objection and I
  need to know.
- Docstring scope: this is a statement about a PROOF TECHNIQUE. Do not claim it says
  anything about whether physical sector leakage vanishes.
