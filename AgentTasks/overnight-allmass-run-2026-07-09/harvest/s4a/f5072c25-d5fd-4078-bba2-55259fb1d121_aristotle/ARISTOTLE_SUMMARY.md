# Summary of changes for run f5072c25-d5fd-4078-bba2-55259fb1d121
Delivered `RequestProject/Main.lean` (namespace `Goal3ChannelRG`) and `ARISTOTLE_SUMMARY.md`. Everything builds in-project (~15–17 s), kernel-checked, no `sorry`/`admit`/`native_decide`/new axiom, entirely over ℚ/ℝ with rational-entry matrices (no `Complex`, no trig/sqrt). Each of the four headline theorems has an in-file `#guard_msgs (whitespace := lax) in #print axioms …` pinning the footprint to exactly `[propext, Classical.choice, Quot.sound]` (independently re-verified).

Model: adding a chiral turn coupling `tau` via the two-site Schur complement (on-site block `lam·I`, coupling block `kap·I + tau·J`, `J²=-I`) yields the closed exact rational 3-coupling decimation
`R3(lam,kap,tau) = (lam - 2(kap²+tau²)/lam, -(kap²-tau²)/lam, -2·kap·tau/lam)` — equivalently the free-Dirac chiral square `z' = -z²/lam` for `z = kap + i·tau`.

Results:
1. `R3_closed_form`: `R3(lam,kap,0) = (R2(lam,kap), 0)` — the turn-free subspace is invariant.
2. `critical_fixed_data`: at the critical point `(1,1,0)` (on the invariant critical line `|kap|=|lam|`, R2 relevant eigenvalue 2), the exact 3×3 Jacobian is `DR3 = !![3,-4,0; 1,-2,0; 0,0,-2]`, with every entry proved as the corresponding partial derivative via `HasDerivAt` (over ℝ), column by column.
3. `rg_eigenvalues`: characteristic polynomial `det(x·I - DR3) = x³ + x² - 4x - 4 = (x-2)(x+1)(x+2)`, so eigenvalues are exactly 2, -1, -2 (each root verified).
4. `kill_test` (payload): eigenvalue 2 = RELEVANT, eigenvector `(4,1,0)` in the aperture–closure plane; eigenvalue -1 = MARGINAL, eigenvector `(1,1,0)` in that plane; eigenvalue -2 = RELEVANT (`|-2|>1`), eigenvector the pure turn axis `(0,0,1)`.

Verdict (theorem-backed): the turn coupling is a NEW RELEVANT direction (eigenvalue -2). Since `(lam,kap,tau)` is the named channel basis by construction, this relevant direction lies inside the channel-coupling span — so basin-membership as stated is NOT killed. It is a sharpened result: on this concrete rational model the turn coupling is relevant, not irrelevant/marginal.

All changes are committed and pushed to `origin` (branch `main`).

# Goal III / Suite B — S4a kill-test (turn coupling)

All results live in `RequestProject/Main.lean`, namespace `Goal3ChannelRG`, kernel-checked
over ℚ / ℝ with rational-entry matrices (no `Complex`, no `Real.cos/sin/sqrt`,
no `sorry`/`admit`/`native_decide`/new axiom). Every headline theorem carries an in-file
`#guard_msgs (whitespace := lax) in #print axioms …` pinning the footprint to exactly
`[propext, Classical.choice, Quot.sound]`. Build time ≈ 15–17 s.

## The 3-coupling model

Each site is promoted to a 2-component (chiral) object. The two-site Schur complement of the
chiral 2×2-block chain — on-site block `A = lam·I`, nearest-neighbour block
`B = kap·I + tau·J` with `J = [[0,1],[-1,0]]`, `J² = -I`, both neighbours contributing —
gives the closed **exact rational 3-coupling decimation**

```
R3(lam, kap, tau) = ( lam - 2(kap² + tau²)/lam ,  -(kap² - tau²)/lam ,  -2·kap·tau/lam ).
```

Equivalently, with the complex closure/turn coupling `z = kap + i·tau`, this is the
free-Dirac chiral square `z' = -z²/lam`, `lam' = lam - 2|z|²/lam`. On `tau = 0` it reduces to
`R2(lam,kap) = (lam - 2 kap²/lam, -kap²/lam)`.

## Results

1. **`R3_closed_form`** — `R3(lam,kap,0) = (R2(lam,kap), 0)`: the turn-free subspace is
   invariant.

2. **`critical_fixed_data`** — critical point `(lam,kap,tau) = (1,1,0)`, on the invariant
   critical line `|kap| = |lam|` (where R2's relevant eigenvalue is `2`). The exact rational
   3×3 Jacobian is

   ```
   DR3 = |  3  -4   0 |
         |  1  -2   0 |
         |  0   0  -2 |
   ```

   Each entry is proved as the corresponding partial derivative of `R3` via `HasDerivAt`
   (over ℝ), column by column (∂/∂lam, ∂/∂kap, ∂/∂tau).

3. **`rg_eigenvalues`** — characteristic polynomial

   ```
   det(x·I - DR3) = x³ + x² - 4x - 4 = (x - 2)(x + 1)(x + 2),
   ```

   so the RG eigenvalues are exactly **2, -1, -2** (each root verified).

4. **`kill_test`** — classification of the eigendirections:

   | eigenvalue | class      | eigenvector | location                         |
   |-----------:|------------|-------------|----------------------------------|
   | `2`        | RELEVANT   | `(4,1,0)`   | aperture–closure plane (`turn=0`)|
   | `-1`       | MARGINAL   | `(1,1,0)`   | aperture–closure plane (`turn=0`)|
   | `-2`       | RELEVANT   | `(0,0,1)`   | **pure turn axis**               |

## Verdict

The turn coupling introduces a **new relevant direction**: eigenvalue `-2` with `|-2| > 1`,
whose eigenvector is the pure turn axis `(0,0,1)` (aperture and closure components zero, turn
component one). Because `(lam,kap,tau)` is the named channel basis by construction, this
relevant direction lies **inside** the span of the named channel couplings — so
basin-membership as stated is **NOT killed**. It is a sharpened result: on this concrete
rational model the turn coupling is *relevant*, not irrelevant/marginal, alongside the
existing relevant aperture–closure direction (eigenvalue `2`) and the marginal one
(eigenvalue `-1`).
