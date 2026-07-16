# Claude-family skeptic audit verdict: CONT-LIVE-001

- Reviewer: interactive Claude / skeptic (independent of builder Codex).
- Work item: `CONT-LIVE-001`. Request: `CODEX_CONT_LIVE_AUDIT_REQUEST.md`.
- **Verdict: ACCEPT_WITH_SCOPE.** No over-claim in the kernel statements or the
  (already careful) prose. The scope caveats below must be preserved verbatim in
  any manuscript wording.

## Findings first

1. **Non-vacuous.** The headline `embeddedScaledLiveError_tendsto_zero` assumes
   only `hF : ∀ j, MemLp (fun x => F x j) 2 volume` (the field is `L²`) and
   `hm : |m| ≤ (M : ℝ)` (mass within the window). Neither hypothesis assumes any
   convergence; the result holds for *every* four-component `L²` field.
2. **Non-circular / actual objects (checks #5, #6 PASS).** `scaledCellModeError`
   (line 139) is literally `(A - B).mulVec (spinorCellCoefficient N F k)` with
   `A = (splitStep (scaledMomentum …) m (t/scaledSteps M N)) ^ scaledSteps M N`
   (the LIVE quartic split walk at physical cell centers) and
   `B = exactFlow (scaledMomentum …) m t` (the landed exact momentum-space Dirac
   multiplier). The coefficients `spinorCellCoefficient N F k` are DERIVED from
   `F` via `cellCoefficient` — not an assumed convergent sequence.
3. **Convergence is a real operator rate.** The limit is driven by
   `scaledCellRate t M N = 2t²/window² · exp(|t|/window³) → 0` (a Trotter-type
   many-step operator bound `scaled_box_many_step_bound`), squeezed against the
   fixed finite field energy `C = ∑_j ∫‖F_j‖²`. `error_energy ≤ rate² · C → 0`.
4. **Normalization + isometry are exact (checks #1, #2, #3 PASS).**
   `cellCoefficient h k f = (√(h³) : ℂ) · cellAverage h k f` (bridge line 41) —
   exactly the intended `√(h³)·cellAverage`. `embeddedError_energy_eq` is a
   kernel-proved isometry via `embedFinite_isometry`, so the re-embedded error
   energy EQUALS the coefficient error energy (pointwise/energetic identity, not
   an analogy). The wrong-normalization control `bare_average_wrong_energy_two`
   confirms the `√(h³)` factor is load-bearing (bare average energy 1 vs
   represented energy 8 at mesh two).
5. **Scheduled-mode coverage (check #4 PASS).** `mem_scheduledModes_iff_modeBox`
   is a kernel-proved bijection (`mode3Equiv`) between the scheduled functional
   cube and the walk's nested-product mode box; no scheduled mode escapes the
   uniform scaled-box operator estimate used in `scaledCellModeError_norm_le`.
6. **Over-claim modes (check #8).** Vacuity: no. Hollow telescoping: no (the
   chain carries a genuine operator bound + field-energy bound + isometry +
   squeeze). False shape: no — the kernel proves `Tendsto (∑_j ∫‖embedded error‖²)
   atTop (𝓝 0)`, which is exactly "embedded live-vs-exact error energy → 0".
   Prose outrunning kernel: no — the docstring explicitly disclaims continuum
   inverse Fourier, position-space PDE, and Lorentz.

## Declarations inspected

`ChangingCellScaledLiveWalk`: `spinorCellCoefficient`,
`spinorCellCoefficient_norm_sq`, `spinorCellCoefficient_energy_le`,
`scaledCellRate(_nonneg/_tendsto_zero)`, `scaledCellModeError`,
`scaledCellModeError_norm_le`, `scaledCellModeError_energy_le`,
`scaledCellModeError_tendsto_zero`, `embeddedErrorComponent`,
`embeddedError_energy_eq`, `embeddedScaledLiveError_tendsto_zero`,
`mem_scheduledModes_iff_modeBox`, `mode3Equiv`.
`ChangingMomentumCellCoefficientBridge`: `cellCoefficient`, `cellAverage`,
`embedFinite_cellCoefficient`, `coefficient_energy_eq_projectFinite`,
`coefficient_energy_le_input`, `bare_average_wrong_energy_two`.

## Commands run

- `lake env lean PhysicsSM/Draft/NullEdge/ChangingCellScaledLiveWalk.lean` — no
  errors (re-inspected the source directly; builder's build logs corroborate).
- Read + traced the dependency chain and the two guard blocks (kernel-only
  footprint `[propext, Classical.choice, Quot.sound]`).

## Permitted scope (strongest allowed manuscript wording)

> For any fixed four-component `L²(ℝ³)` spinor field `F` and mass `|m| ≤ M`, as
> the scheduled momentum mesh refines (`N → ∞`), the total `L²`-energy of the
> error between the live quartic split-step walk and the exact momentum-space
> Dirac multiplier — evaluated at the physical cell centers and re-embedded
> **isometrically** into the same `√(h³)`-normalized momentum cells — converges
> to zero.

## Remaining gates (must stay explicit; do NOT promote past these)

- **Frozen cell-center multiplier.** `exactFlow` is evaluated at the cell center
  `scaledMomentum N q`, not at the continuum momentum varying within the cell.
  Intra-cell multiplier variation is uncontrolled here.
- **Coupled schedule.** `N → ∞` simultaneously refines the mesh, grows the
  Trotter step count `scaledSteps M N`, and grows the window `scaledWindow M N`.
  This is a scheduled approximation, not a fixed walk under mesh refinement —
  state it as such.
- **No continuum transport / PDE / Lorentz.** No inverse Fourier transform, no
  position-space Dirac PDE identification, no Lorentz restoration. This is
  momentum-cell projection convergence, NOT full position-space convergence.

Do not promote "projection convergence" to "position-space convergence"; the
kernel does not support it and the module correctly does not claim it.
