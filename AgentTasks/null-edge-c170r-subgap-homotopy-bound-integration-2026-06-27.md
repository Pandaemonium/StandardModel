# Summary of changes for run b3f2a899-7b82-4265-81df-afc2677f1a8d
Completed job C170: "sub-gap norm bound for the reference homotopy", delivered as a verified Lean artifact in `RequestProject/C170.lean` (builds cleanly, no proof placeholders, only the standard kernel dependencies `propext`/`Classical.choice`/`Quot.sound`).

The five requested outputs are realized:

1. **Bound decomposition.** `H_ne - H_ref` is split into five finite operator pieces — `kinetic` (kinetic mismatch), `wbranch` (Adams/Wilson `W_branch` mismatch), `rm0` (`R`/`m₀` mismatch), `gauge` (gauge/admissibility perturbation), and `frame` (branch-frame mismatch, zero when frames agree). These, with the decomposition equation, are fields of the `SubgapHomotopyBound` certificate.

2. **Triangle-inequality bound with named constants.** `SubgapHomotopyBound.total_bound` proves `‖H_ne - H_ref‖ ≤ κ + ω + ρ + α + β`, with `κ,ω,ρ,α,β` the named per-piece operator-norm constants.

3. **Sufficient criterion.** The certificate field `subgap : κ + ω + ρ + α + β < γ` is discharged into `diff_lt_gap : ‖H_ne - H_ref‖ < γ` (genuine operator distance below the reference gap).

4. **Certificate + C164 connection.** The `SubgapHomotopyBound` structure bundles operators (as continuous linear endomorphisms `E →L[ℝ] E`), the decomposition, the named constants, the reference gap encoded as the certificate-friendly lower bound `GapLB H_ref γ := ∀ x, γ‖x‖ ≤ ‖H_ref x‖`, and the sufficient criterion. The standalone C164 lemma `c164_gapped_homotopy` proves that the straight-line homotopy `Hpath = (1-t)•H_ref + t•H_ne` is uniformly gapped with constant `γ - ‖H_ne - H_ref‖` for all `t ∈ [0,1]` (via the analytic core `gapLB_perturb`), and `c164_gap_pos` shows this gap is positive once the sub-gap inequality holds. The certificate's `homotopy_gapped` and `gap_pos` theorems package this for import.

5. **Failure modes and retuning.** Documented in the file's module docstring: tighten the dominant piece via per-sector norm bounds, raise `γ` by choosing a heavier reference, retune `R`/`m₀` to shrink `ρ`, improve admissibility to shrink `α`, align branch frames to zero out `β`, or subdivide the homotopy with an intermediate reference.

Constraints respected: the gapped-homotopy conclusion is derived only from the quantitative bound, never from resemblance; anomaly/index and locality are kept entirely external (no index, determinant line, or locality radius appears); and the operator-norm assumptions are stated explicitly (continuous linear endomorphisms of a real normed space; gap encoded as a Lipschitz-type lower bound, no self-adjointness or finite-dimensionality assumed). Consistent with the round context, this does not claim `GateC1_NU` is closed — it supplies the explicit sub-gap certificate that C164 consumes.
