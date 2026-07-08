# Adversarial over-claim audit — carrier dynamics/spectral flagships, batch 6

AUDIT job (no proof required). `src/` has four verbatim Lean files (real project
source, with their real imports) from a finite mathematical-physics program
("mass = obstruction to null transport" on a finite Krein-Dirac carrier). All are
kernel-checked + axiom-pinned. The kernel guarantees the proofs; it does NOT
guarantee the statements/docstrings are the intended mathematics. You are blind to
the wider repo — judge only what is here. For EACH theorem: name it, one-line
quote of what it claims, classify (vacuity / hollow-telescoping /
docstring-outruns-kernel / false-shape / CLEAN), verdict CLEAN / MINOR /
LOAD-BEARING, and for anything not CLEAN the exact mismatch + a concrete remedy.

The carrier "mass block" is `B(λ,κ) = λ·I + i·κ·K` (a `3×3` Hermitian matrix, `K`
the closure curvature); its spectrum is claimed to be `{λ−κ, λ, λ+κ}`, gap
`λ−κ = aperture − closure`. The `6×6` physical-sector form is `M6 = B(2,1) ⊕
B(2,−1)`.

## Files and specific probes

- `MassGapWitness.lean` — `B_spectrum` (`{λ−κ,λ,λ+κ}`), `B_least_eigenvalue`,
  `B_posDef_iff` (massive iff `|κ|<λ`), `B_massless_iff_of_pos`,
  `M6_topBlock_eq_B`/`M6_botBlock_eq_B` (the carrier tie at `(2,1)`). Probe: is
  `B_spectrum` the genuine eigenvalue set (with multiplicity / as a Finset — any
  hollow encoding?)? Is the "carrier tie" (`M6 = B(2,1)⊕B(2,−1)`) a real
  identification of the physical carrier, or does the docstring claim canonicity
  the kernel doesn't (i.e. is `(2,1)` a *chosen* point dressed as the carrier's
  actual `(λ,κ)`)?
- `CarrierUnitaryFlow.lean` — `hermitian_flow_mem_unitaryGroup`, `B_flow_unitary`,
  `hermitian_flow_isometry`, `carrier_orbit_norm_conserved`,
  `carrier_orbit_energy_conserved`, `carrier6_orbit_norm_conserved`. Probe the
  physics dressing HARD: (a) is "energy conservation" genuine, or is it
  conservation of a *commuting observable* trivially preserved by its own
  generated flow (i.e. `⟨ψ_t, H ψ_t⟩ = ⟨ψ_0, H ψ_0⟩` because `[H, e^{−itH}]=0`)?
  Is that dressed as more than it is? (b) The "generator-as-Hamiltonian" reading:
  is it flagged as a posit (grade C), or asserted? (c) Is the flow's unitarity the
  real `∈ unitaryGroup` fact or a weaker statement?
- `SectorGroundMassWitness.lean` — `T2_positive_mass`, `M6`, `sector_krein_form_eq_one`
  (`Pisoᴴ·Jmet·Piso = 1`). Probe: is `T2_positive_mass` a genuine positive-definite
  sector form (aperture dominance), or engineered? Does `sector_krein_form_eq_one`
  actually show the sector's Krein form is the identity (Euclidean=Krein on the
  sector), or is `Piso` chosen to force it? Is the Clifford provenance of the
  carrier claimed as canonical or as a recipe-match?
- `MassSpacingPrediction.lean` — `spec_spacing_ratio` (=1), `levels_eq_spectrum`,
  `spec_spacing_ratio_scale_invariant`. Probe: is "the three levels are equally
  spaced" a genuine prediction of the construction, or a tautology of the chosen
  `B(λ,κ)` ansatz (i.e. equal spacing is forced by the `{λ−κ,λ,λ+κ}` form, so the
  "prediction" is just arithmetic)? Is that honestly scoped (within-carrier,
  killable) or inflated to a physical mass-spectrum claim?

## Output

Per-file per-theorem table, then THE single most load-bearing over-claim (if any)
with exact remedy; else say all clean + what you verified. The one I most want
ruled on: is `CarrierUnitaryFlow`'s "energy conservation" a genuine dynamical fact
or a commuting-observable triviality dressed as physics? One correct load-bearing
finding beats ten generic cautions.
