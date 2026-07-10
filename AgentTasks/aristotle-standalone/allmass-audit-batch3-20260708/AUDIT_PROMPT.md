# Adversarial over-claim audit — all-mass landed results, batch 3

AUDIT job (no proof). `src/` has four verbatim Lean files from a finite
mathematical-physics program (mass = obstruction to null transport), all
kernel-checked + axiom-pinned `[propext, Classical.choice, Quot.sound]`. The kernel
guarantees the proofs; NOT that the statements/docstrings are the intended
mathematics. For EACH theorem: name it, quote the statement, classify against the
four modes (vacuity / hollow telescoping / docstring-outruns-kernel / false shape),
verdict CLEAN/MINOR/LOAD-BEARING, and for anything not CLEAN the exact mismatch +
remedy.

- `SectorMassGap.lean` — claims the full `6×6` sector form `Msec = B(λ,κ)⊕B(λ,-κ)`
  has least eigenvalue `λ-κ`. Probe: is `Msec` genuinely the block diagonal (is the
  `reindex finSumFinEquiv` faithful)? Is "the actual sector, not just the block"
  earned, given the carrier tie is only kernel at `(2,1)`?
- `MassSpacingPrediction.lean` — claims a "dimensionless prediction P-spacing":
  the three levels are equally spaced, ratio `=1`. Probe HARD: is this a genuine
  *prediction* or a trivial arithmetic identity of `{λ-κ,λ,λ+κ}` dressed as physics?
  Is `levels_eq_spectrum` (levels = `B_spectrum`) doing real work, or decorative?
  Is calling the ratio a falsifiable prediction honest given it is forced by the
  spectrum's arithmetic form?
- `ContinuumLimit.lean` — claims "finite symbol facts of the QW→Dirac limit"
  (mass shell, generator match). Probe: is `Ustep_hasDerivAt_generator` genuinely
  the leading-order match, or a derivative that says less than "continuum limit"?
  Does the file adequately disclaim that the continuum THEOREM is not proved (only
  finite symbol facts)? Any false-shape in `dirac_mass_shell`?
- `FockMassGap.lean` — claims the "free second-quantized mass gap". Probe: is
  `secondQuantized_massGap` genuinely a Fock-space many-body gap, or a relabeled
  one-particle fact? Is `twoBody_bound_below_threshold` a real below-threshold
  bound state, or does `Δ` enter by hand (self-disclosed)?

Output: per-file per-theorem table; THE single most load-bearing over-claim across
all four (if any) with exact remedy; else say all clean + what you verified. One
correct load-bearing finding beats ten generic cautions.
