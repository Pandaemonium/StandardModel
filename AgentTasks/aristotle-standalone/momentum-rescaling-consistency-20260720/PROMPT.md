# Lemma job: momentum rescaling consistency across the rungs (follow-up to a 2 pi finding)

Mathlib-only, abstract, scoped L2 operator norm on `Matrix (Fin 4) (Fin 4) C`.

An audit found the Fourier convention forces a differential coefficient
`-I / (2 pi)` rather than `-I`. Two repairs are possible: carry `2 pi` explicitly, or
rescale the momentum variable once. The second is only safe if the OTHER rungs'
momentum-dependent constants transform consistently. Check that.

Let `G q := sum_j (q j) . A j` be a momentum-linear generator (the `A j` fixed
matrices), and let `lam > 0` be a rescaling with `q = lam * q'`.

Prove:
1. **Generator scaling**: `G (lam . q') = lam . G q'`, and `||G (lam . q')|| = lam * ||G q'||`.
2. **One-step constant scaling**: if a one-step estimate has the form
   `||W eps q - exp (eps . (I . G q))|| <= C(||G q||) * eps^2` with `C` monotone, then
   under `q = lam q'` the constant becomes `C(lam * ||G q'||)` - i.e. the estimate
   remains valid with the RESCALED constant, and is NOT invariant unless `lam = 1`.
   State this precisely.
3. **Combined eps-q scaling**: show `exp (eps . (I . G (lam . q'))) = exp ((lam * eps) . (I . G q'))`,
   so a momentum rescaling is equivalent to a step-size rescaling - the exact
   compensation rule.
4. **Consequence**: conclude that rescaling momentum to absorb a `2 pi` is legitimate
   PROVIDED every momentum-dependent constant is rescaled by the same `lam` (and note
   that a bound stated on a compact box `|q_i| <= K` becomes a box `|q'_i| <= K/lam`).
Success: 1-3 proved, 4 stated precisely. No new axioms/native_decide; standard axioms.
