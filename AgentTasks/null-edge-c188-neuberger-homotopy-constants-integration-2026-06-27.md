# Summary of changes for run ae7b99e6-5403-41f8-af69-c3ff8c9d60c9
Specialized the C170/C181 sub-gap criterion to the C186 Wilson/Neuberger-overlap-plus-CKM-texture architecture in a new file `RequestProject/C186.lean` (namespace `GateC1.C186`). It builds cleanly, contains no proof placeholders, and every theorem depends only on the standard kernel dependencies (`propext`, `Classical.choice`, `Quot.sound`).

The development models the operator algebra abstractly as any `SeminormedAddCommGroup 𝓞` (e.g. bounded operators with the operator norm, or matrices with the spectral norm), so the results apply verbatim to the concrete overlap construction.

How each requested output is delivered:

1. Defining H_ref / H_ne and assigning the constants — `OverlapArch` is a five-channel decomposition: each of `H_ref` (`Href`) and `H_ne` (`Hne`) is assembled from a kinetic (K), branch-frame (B), R/m₀-mass (M), gauge-admissibility (G), and CKM-texture (C) block. The budgets are assigned as the channel mismatch norms: `kappa := ‖Kne-Kref‖`, `omega := ‖Bne-Bref‖`, `rho := ‖Mne-Mref‖`, `alpha := ‖Gne-Gref‖`, `beta := ‖Cne-Cref‖`. `norm_diff_le_total` proves the left half of the criterion `‖H_ne−H_ref‖ ≤ κ+ω+ρ+α+β`.

2. Which constants vanish in the ideal build — `kappa_eq_zero_of_kinetic_eq` (same kinetic reference ⇒ κ=0), `omega_eq_zero_of_branch_eq` (same branch frame ⇒ ω=0), `rho_eq_zero_of_mass_eq` (same R/m₀ ⇒ ρ=0), `alpha_eq_zero_of_gauge_eq` (same gauge admissibility class ⇒ α=0). `total_eq_beta_of_ideal` shows that under all four reuses the budget collapses to the CKM channel `β`; `subgap_of_ideal` reduces the criterion to `β < γ_ref`. The CKM texture `β` is the one budget that does not vanish by reuse, since H_ne genuinely carries the flavour texture.

3. Bounds for the nonzero constants — `subgap_of_bounds` closes the criterion from explicit finite/operator-norm upper bounds on each channel whose sum is below the gap; `kappa_le_of_norm_le`, …, `beta_le_of_norm_le` package operator-norm estimates as channel bounds. No smallness is assumed; bounds are carried explicitly.

4. Retuning strategies — `subgap_of_le` (monotone tightening: reducing channels via m₀, Wilson r, or the admissibility bound can only help), `homotopy_triangle` / `subgap_of_homotopy` (insert an intermediate-homotopy waypoint H_mid and bound the two legs independently), and the `headroom` bookkeeping (`headroom := γ_ref − (κ+ω+ρ+α)`; `total_lt_iff_beta_lt_headroom` shows the criterion is exactly `β < headroom`, so enlarging the reference gap or realigning the branch frame widens the room for β).

5. C170R/C181-compatible API theorem — `SubGap A := ‖H_ne−H_ref‖ < γ_ref`, with `subgap` (`total < γ_ref ⇒ SubGap`) and `subgap_of_total_lt` stated in the exact `κ+ω+ρ+α+β < γ_ref ⇒ ‖H_ne−H_ref‖ < γ_ref` shape of the criterion.

6. Shifted CKM window vs. the reference gap — `CKMWindow` (center = texture shift, half-width) with `contains`/`top`; `subgap_of_ckm_window` proves sub-gap holds iff the whole shifted window sits below the head-room, and `subgap_of_ckm_window_gap` restates this directly against the Wilson/Neuberger gap: the window's upper edge plus the non-flavour budget must stay below γ_ref. Thus shifting the CKM window trades directly against the reference gap and the non-flavour channels.

The file's module docstring records the full audit plan and the conceptual answers; `RequestProject/Main.lean` is unchanged.
