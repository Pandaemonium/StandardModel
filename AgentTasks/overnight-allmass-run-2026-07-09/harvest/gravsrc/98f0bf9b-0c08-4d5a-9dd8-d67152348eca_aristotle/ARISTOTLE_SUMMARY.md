# Summary of changes for run 98f0bf9b-0c08-4d5a-9dd8-d67152348eca
Delivered `RequestProject/Main.lean` (namespace `GravitySourceMatter`) and `ARISTOTLE_SUMMARY.md`, a finite, kernel-checked rational avatar of `G = κ T` in which the soldering (gravity) channel of a single Dirac square is sourced by its matter channels, channel-blind.

**Model (explicit `ℚ` matrices).** `dirac_square_decomp`: `4·DsqD = Q_A + Q_C + Q_T + E_sold` with `Q_A=!![2,0;0,0]`, `Q_C=!![0,0;0,2]`, `Q_T=!![0,1;1,0]` (matter channels) and `E_sold=!![2,1;1,2]` (soldering geometry). `matterBudget ψ = ⟨ψ,(Q_A+Q_C+Q_T)ψ⟩`, per-channel `qA/qC/qT`, `solderingCurv γ = ⟨E_soldVec γ, E_soldVec γ⟩ = 18γ²`, coupling `kappa = 9`, action `(18/3)γ³ − κ·b·γ`. The `HasDerivAt` layer uses `ℝ` with rational data cast at the boundary.

**Targets proved.**
1. `matter_stress_decomp`: `matterBudget ψ = qA ψ + qC ψ + qT ψ` (the source IS the matter channels).
2. `field_equation_sourced` (payload): via `HasDerivAt`/`HasDerivAt.unique`, soldering stationarity ⇔ `solderingCurv γ = κ·matterBudget ψ`, both directions.
3. `channel_blind_universal` (WEP): equal total budget ⇒ identical sourced geometry regardless of split, plus `wep_witness` (`![1,0]` vs `![0,1]`: same total 2, differing `qA` 2≠0).
4. `unification_verdict`: packages 1–3 with the non-degeneracy data.

**Non-degeneracy.** `nondegenerate_witness` (ψ*=`![1,0]`, γ*=1: all quantities nonzero, both sides = 18) and `control_failure` (γ=0 gives 0≠18, so not a tautology).

**Constraints honored.** No `sorry`/`admit`/`native_decide`/new axiom; footprint is exactly `[propext, Classical.choice, Quot.sound]`, certified in-file by `#guard_msgs (whitespace := lax) in #print axioms` on all four headlines. Proofs use `ring`/`norm_num`/`simp`/`fin_cases` + `HasDerivAt`; no Complex, no Real trig/sqrt, no high-degree nlinarith. Builds well under 3 minutes.

Honest scope (stated in code/summary): a finite one-edge/one-frame avatar of `G = κ T`, not continuum Einstein equations; the overlap with the Goal-IV stationarity line is flagged for reconciliation.

# claude-gravity-source-matter — the finite field equation

A finite, kernel-checked rational avatar of the unification coupling `G = κ T`: the
null-edge **soldering** (gravity) channel of a single Dirac square is *sourced* by the
**matter** channels (aperture / closure / turn) of the *same* Dirac square, with a
**channel-blind** (universal) coupling — the finite weak equivalence principle.

All content lives in `RequestProject/Main.lean`, namespace `GravitySourceMatter`.

## The model (explicit rational matrices over `ℚ`)

The carrier Dirac square `D#D` decomposes into four explicit symmetric rational
matrices (`dirac_square_decomp`):

```
4 · DsqD = Q_A + Q_C + Q_T + E_sold
```

- `Q_A = !![2,0;0,0]`, `Q_C = !![0,0;0,2]`, `Q_T = !![0,1;1,0]` — matter channels
  (aperture / closure / turn);
- `E_sold = !![2,1;1,2]` — soldering geometry channel;
- `DsqD = !![1,½;½,1]`.

Definitions:
- `matterBudget ψ = ⟨ψ, (Q_A+Q_C+Q_T) ψ⟩`, with per-channel budgets `qA`, `qC`, `qT`.
- `E_soldVec γ` = the soldering matrix applied to a fixed rational `frame = ![1,1]`,
  scaled by a real decoration `γ`; `solderingCurv γ = ⟨E_soldVec γ, E_soldVec γ⟩`
  (equals `18·γ²`, `solderingCurv_eq`).
- `kappa = 9` (fixed rational coupling), and the soldering `action b γ = (18/3)γ³ − κ·b·γ`.

The dynamical layer uses `ℝ` only so `HasDerivAt` is available; the rational matrix
data is cast in at the boundary.

## Targets delivered

1. **`matter_stress_decomp`** — the gravitational source is the sum of the matter
   channels: `matterBudget ψ = qA ψ + qC ψ + qT ψ` (a `ring` identity).
2. **`field_equation_sourced`** (payload) — via `HasDerivAt`, soldering stationarity
   `HasDerivAt (action (matterBudget ψ)) 0 γ` is *equivalent* to the finite field
   equation `solderingCurv γ = κ · matterBudget ψ`. Both directions proved
   (`hasDerivAt_action` + `HasDerivAt.unique`).
3. **`channel_blind_universal`** (WEP) — states with equal total `matterBudget` source
   identical geometry regardless of channel split; `wep_witness` gives the concrete
   two-state, same-total (`= 2`), different-split (`qA` differs `2 ≠ 0`) pair
   `![1,0]` vs `![0,1]`.
4. **`unification_verdict`** — packages 1–3 with the non-degeneracy data.

## Non-degeneracy

- `nondegenerate_witness`: at `ψ* = ![1,0]`, `γ* = 1` all quantities are nonzero
  (`matterBudget ≠ 0`, `solderingCurv 1 ≠ 0`, `κ ≠ 0`), the field equation holds, and
  **both sides equal the specific nonzero rational `18`** — not `0 = 0`.
- `control_failure`: at `γ = 0` the equation FAILS (`0 ≠ 18`), so the payload is a
  genuine constraint, not a tautology.

## Constraints honored

- Kernel-checked only: no `sorry`/`admit`/`native_decide`/new axiom.
- Footprint exactly `[propext, Classical.choice, Quot.sound]`, certified in-file by
  `#guard_msgs (whitespace := lax) in #print axioms <thm>` on every headline
  (`matter_stress_decomp`, `field_equation_sourced`, `channel_blind_universal`,
  `unification_verdict`).
- Real rational (`ℚ`) matrices; proofs by `ring`/`norm_num`/`simp`/`fin_cases` +
  `HasDerivAt`. No `Complex`, no `Real.cos/sin/sqrt`, no high-degree `nlinarith`.
- Builds in well under 3 minutes.

## Honest scope

This is a finite one-edge / one-frame avatar of `G = κ T`, **not** the continuum
Einstein equations. It extends the Goal-IV field-equation line in the UNIFICATION
direction (source = matter channels); the overlap with a bare stationarity statement
is flagged here for reconciliation — the distinguishing content is that the SOURCE is
exhibited as the matter channels specifically.
