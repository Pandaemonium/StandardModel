# Summary of changes for run 8e231d08-6e19-4dc3-a44d-1039f6532a1c
Delivered `RequestProject/Main.lean` (namespace `LeanQuantumDPIMass`) plus `ARISTOTLE_SUMMARY.md`, building cleanly under Mathlib with no `sorry`/`admit`/`native_decide`/new axioms.

## Model (real rational 2×2, no Complex/log/sqrt/trig)
- `rho p x = !![p, x; x, 1 - p]` — real symmetric rational density operator.
- `Slin M = 1 - tr(M²)` — linear entropy (`mass²`); on `rho p x` equals `2(p(1-p) - x²) = 2 det ρ`.
- `Phi t M` — pinching/coarse-graining channel damping off-diagonal coherence by `(1 - t)`.
- `IsDensity M := M.PosSemidef ∧ M.trace = 1`.

## Targets (all proved)
1. `channel_is_state` — for valid `rho p x` (`0 ≤ p ≤ 1`, `0 ≤ p(1-p) - x²`) and `t ∈ [0,1]`, `Phi t (rho p x)` is again a density operator (Hermitian + PSD + unit trace). PSD uses a reusable helper `posSemidef_two`.
2. `linear_entropy_monotone` (DPI core) — `Slin (rho p x) ≤ Slin (Phi t (rho p x))` for `t ∈ [0,1]`, via the closed form `entropy_gain`: `Slin(Phi t ρ) - Slin ρ = 2 t (2 - t) x² ≥ 0`. Decoherence can only create mass².
3. `signed_closure_exception` — with the rational 3-4-5 rotation `U345 = !![3/5,-4/5;4/5,3/5]` and `t = 1`, `Slin(Phi 1 (U ρ Uᵀ)) < Slin(Phi 1 ρ)` (explicit witness `481/1250 < 1/2`): a coherent move can lower mass².
4. `dpi_verdict` — packages (1)–(3) plus the mandatory non-degeneracy witness.

Non-degeneracy (`mass_created`, also inside `dpi_verdict`): massless pure state `rho (1/2)(1/2) = !![1/2,1/2;1/2,1/2]` has `Slin = 0`; fully pinching gives `Phi 1 (…) = !![1/2,0;0,1/2]` with `Slin = 1/2 > 0` — coarse-graining created mass.

## Verification
- `lake build` of `RequestProject.Main` succeeds.
- Every headline (`channel_is_state`, `linear_entropy_monotone`, `signed_closure_exception`, `dpi_verdict`) carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` check; footprint is exactly `[propext, Classical.choice, Quot.sound]`.

## Provenance
Reference (not an import): the **lean-quantum** package (`github.com/Hayata-Yamasaki-Group/lean-quantum`), whose DPI is for the von Neumann relative entropy; this file proves the linear-entropy (`Slin = 1 − tr ρ²`) avatar. Version gap: lean-quantum is version-pinned and used only as a mathematical reference — this file depends on Mathlib only.

All changes committed and pushed to `origin`.

# claude-leanquantum-dpi-mass — summary

A finite, rational, **linear-entropy** avatar of the data-processing inequality (DPI) for the
"visible direction register" of the mass dictionary, in `RequestProject/Main.lean`
(namespace `LeanQuantumDPIMass`). Everything is real rational `2 × 2` linear algebra — no `Complex`,
no `Real.log`/`sqrt`/`cos`/`sin`, no `nlinarith` with degree ≥ 3 config — and kernel-checked.

## Provenance (reference, NOT an import)

Ported from the **lean-quantum** package
(`github.com/Hayata-Yamasaki-Group/lean-quantum`: density operators, channels, partial trace,
entropy, DPI). There the DPI is proved for the **von Neumann relative entropy**; this file proves
the **linear-entropy** (`Slin = 1 − tr ρ²`) avatar needed by the mass dictionary
(`mass² = Slin` of the visible register). **Version gap:** lean-quantum is version-pinned and used
only as a mathematical reference — this file depends on **Mathlib only**.

## Model

- `rho p x = !![p, x; x, 1 - p]` — real symmetric rational density operator.
- `Slin M = 1 - tr(M²)` — linear entropy; on `rho p x` equals `2(p(1-p) - x²) = 2 det ρ`.
- `Phi t M` — pinching / coarse-graining channel damping the off-diagonal coherence by `(1 - t)`.
- `IsDensity M := M.PosSemidef ∧ M.trace = 1`.

## Results (all proved, no `sorry`)

1. `channel_is_state` — for a valid `rho p x` (`0 ≤ p ≤ 1`, `0 ≤ p(1-p) - x²`) and `t ∈ [0,1]`,
   `Phi t (rho p x)` is again a density operator (Hermitian + PSD + unit trace).
2. `linear_entropy_monotone` (DPI core) — `Slin (rho p x) ≤ Slin (Phi t (rho p x))` for
   `t ∈ [0,1]`, via the closed form `entropy_gain`:
   `Slin (Phi t ρ) - Slin ρ = 2 t (2 - t) x² ≥ 0`. Decoherence can only create `mass²`.
3. `signed_closure_exception` — with the rational `3-4-5` rotation `U345 = !![3/5,-4/5;4/5,3/5]`
   and `t = 1`, `Slin (Phi 1 (U ρ Uᵀ)) < Slin (Phi 1 ρ)` (explicit witness `481/1250 < 1/2`):
   a coherent move can lower `mass²`.
4. `dpi_verdict` — packages (1)–(3) plus the non-degeneracy witness.

Non-degeneracy (`mass_created`, and inside `dpi_verdict`): the massless pure state
`rho (1/2) (1/2) = !![1/2,1/2;1/2,1/2]` has `Slin = 0`; fully pinching it gives
`Phi 1 (…) = !![1/2,0;0,1/2]` with `Slin = 1/2 > 0` — coarse-graining created mass.

## Verification

- `lake build` succeeds (`RequestProject.Main`).
- Each headline (`channel_is_state`, `linear_entropy_monotone`, `signed_closure_exception`,
  `dpi_verdict`) carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` check;
  the footprint is exactly `[propext, Classical.choice, Quot.sound]`.
- No `sorry`/`admit`/`native_decide`/new `axiom`.
