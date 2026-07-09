# Summary of changes for run 557127e1-10fb-46f6-b903-248452639fe1
Delivered `RequestProject/Main.lean` (namespace `VelocityMixtureLinearEntropy`) and `ARISTOTLE_SUMMARY.md`.

The module formalizes the linear-entropy (rational `1 - Tr ρ²` impurity) entry of the mass-drift dictionary for the ±c "zigzag" velocity mixture, purely over ℚ with `field_simp`/`ring`/`norm_num` carrying `E ≠ 0` — no `Real`/`Complex`/logs/transcendentals, no `nlinarith`.

Definitions: `pplus`, `pminus`, `SL`, `msq`. Theorems:
- `dist_normalized`: `pplus + pminus = 1`.
- `dist_nonneg`: valid (nonnegative) distribution for `0 < E`, `|p| ≤ E`.
- `mean_is_drift`: mean of ±c eigenvalues is `p/E`.
- `linear_entropy_closed` (payload): `SL E p = (E²-p²)/(2E²) = m²/(2E²)`.
- `mass_sq_eq_two_Esq_SL` (payload): `msq E p = 2E²·SL E p`.
- `massless_pure`: `SL = 0` at `p = ±E` (pure), `msq E E = 0`.
- `rest_maximal`: `SL = 1/2` at `p = 0` (maximal), `msq E 0 = E²`.
- `velocity_linear_entropy_verdict`: packages the whole result.
- Non-degeneracy witnesses `witness_massive` (E=5,p=3), `witness_rest`, `witness_massless`, `witness_intermediate` (`SL 5 3 ≠ 0` and `≠ 1/2`).

Every headline has an in-file `#guard_msgs (whitespace := lax) in #print axioms …` confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`. No `sorry`/`admit`/`native_decide`/new axioms. The project builds successfully (verified via a full build of `RequestProject.Main`).

The summary and module docstring state the honest framing: this is the rational linear entropy (a `1 - Tr ρ²` proxy), NOT Shannon entropy — a corollary-level restatement of the drift relation `vbar² = 1 - m²/E²` as `S_L = (1 - vbar²)/2`; the value is the interpretation (mass² = velocity-mixture impurity). The purity notion is standard quantum information, reconstructed clean-room. All work is committed and pushed.

# mass² = 2E² · (linear entropy of the ±c velocity mixture)

## What this delivers

`RequestProject/Main.lean` (namespace `VelocityMixtureLinearEntropy`) adds the
information-theoretic entry of the "mass-drift dictionary" for a massive Dirac fermion's
internal `±c` ("zigzag") motion, using a **rational** entropy — the **linear entropy**
(impurity) `S_L = 1 - Tr ρ²`.

The `±c` motion is modelled as a 2-outcome classical distribution over the velocity
eigenvalues `{+1, -1}` with the correct drift mean `vbar = p/E`:

* `pplus  E p = (E + p)/(2E)`
* `pminus E p = (E - p)/(2E)`
* `SL  E p = 1 - (pplus² + pminus²)`
* `msq E p = E² - p²`  (on-shell `m²`)

All identities are purely rational (`Q = ℚ`) and proved by `field_simp`/`ring`/`norm_num`
carrying `E ≠ 0`. No `Real.log`/`sqrt`/`cos`/`sin`, no `Complex`, no `nlinarith`.

### Theorems

1. `dist_normalized` — `pplus + pminus = 1`.
2. `dist_nonneg` — for `0 < E`, `|p| ≤ E`, both `pplus, pminus ≥ 0` (valid distribution).
3. `mean_is_drift` — `pplus·1 + pminus·(-1) = p/E` (mean = drift `vbar`).
4. `linear_entropy_closed` (PAYLOAD) — `SL E p = (E² - p²)/(2E²) = m²/(2E²)`.
5. `mass_sq_eq_two_Esq_SL` (PAYLOAD) — `msq E p = 2E²·SL E p`.
6. `massless_pure` — at `p = ±E`, `SL = 0` (pure single channel) and `msq E E = 0`.
7. `rest_maximal` — at `p = 0`, `SL = 1/2` (maximal 50/50 mixing) and `msq E 0 = E²`.
8. `velocity_linear_entropy_verdict` (VERDICT) — packages the whole face of the dictionary.

Non-degeneracy witnesses (`norm_num`): `witness_massive` (`E=5, p=3`: `msq=16`,
`pplus=4/5`, `pminus=1/5`, `SL=8/25`, `16 = 2·25·(8/25)`), `witness_rest` (`E=5, p=0`:
`SL=1/2`, `msq=25`), `witness_massless` (`E=5, p=5`: `SL=0`, `msq=0`), and
`witness_intermediate` (`SL 5 3 ≠ 0` and `≠ 1/2`, a genuine intermediate impurity).

Every headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …`
check confirming the axiom footprint is exactly `[propext, Classical.choice, Quot.sound]`.
No `sorry`/`admit`/`native_decide`/new axiom. The file builds under the toolchain in well
under 3 minutes.

## HONEST framing

This is the **linear entropy** — a rational `1 - Tr ρ²` proxy — **not** the Shannon entropy
`-Σ p log p`. The result is a **corollary-level restatement** of the drift relation
`vbar² = 1 - m²/E²` in information-theoretic language: `S_L = (1 - vbar²)/2`. The value here
is the *interpretation / connection* (mass² = velocity-mixture impurity), not proof depth.
Nothing here is Shannon entropy and no claim beyond a rational-entropy proxy is made.

Provenance: the linear entropy / purity `1 - Tr ρ²` notion is standard quantum information;
it is reconstructed clean-room here (rational, no logs/transcendentals), not imported from
any external development.
