# Claude adversarial review: PhaseCovariantS2Capstone (65c69022)

- Reviewer: interactive Claude Code (claude family), adversarial
- Work item: `DYN-MODULAR-001`; Source sha256 20755ab9... verified (184 lines)
- Date: 2026-07-13

## Verdict: ACCEPT

Transports the `z = 1` qubit max-entropy/modular capstone to every nonzero
complex Pluecker coupling by phase-gauge conjugation, honestly scoped as
phase-COVARIANT (not phase-observable) with anti-decorative controls.

## Checks

- **phaseGauge conjugation orientation.** `gaugedBloch z e u v =
  (phaseGauge z)ᴴ * pairBloch e u v * phaseGauge z` -- pulls the canonical Bloch
  state back through the phase-removing unitary (the phase-decorated version).
  Consistent with `PhaseCovariantModularSelection` where `phaseGauge z` removes
  the phase from `Bz z`.
- **Trace/determinant route for 2x2 entropy invariance.**
  `vonNeumannEntropy_eq_of_trace_det_eq`: for 2x2 Hermitian `A, B`, equal trace
  AND equal det force equal entropy (in dimension two those two symmetric
  functions determine the unordered eigenvalue pair; entropy is symmetric in
  eigenvalues). `gaugedBloch_entropy_eq` then shows the unitary conjugation
  preserves both trace (`trace_mul_comm` + `phaseGauge_unitary`) and det
  (`det_fin_two` + explicit `phaseGauge`), hence entropy. Sound.
- **betaZ scaling and sign.** `betaZ z e = -artanh e / ||z||`: the canonical
  `z = 1` inverse temperature `-artanh e` divided by the modulus (the rescaling),
  so `betaZ * ||z|| = -artanh e`. Correct.
- **Gibbs-state transport.** `gaugedBloch_zero_eq_gibbsState`:
  `gaugedBloch z e 0 0 = gibbsState (Bz z) (betaZ z e)` via `gibbsState_conj` +
  `pairBloch_zero_eq_gibbsState`. Correct.
- **Normalized-energy identity.** `gaugedBloch_normalized_energy`:
  `(gaugedBloch * (||z||⁻¹ • Bz z)).trace.re = e` via `phaseGauge_conj`
  (`phaseGauge z * Bz z * ᴴ = ||z|| • Bz 1`). Prevents a decorative wrapper: the
  transported family genuinely has normalized energy `e` w.r.t. the `z`-coupling.
- **Modular-flow covariance.** `gaugedBloch_modFlow_covariant`: the modular flow
  of `Bz z` at `betaZ` conjugates to the modular flow of `Bz 1` at `-artanh e`,
  via `modFlow_conj`. Ties transported modular dynamics to the canonical one.
- **Strict equality iff `u = v = 0`.** The capstone's second conjunct
  (`entropy(gaugedBloch e u v) = entropy(gaugedBloch e 0 0) <-> u = 0 and v = 0`)
  is transported from the `z = 1` `dyn2` via `gaugedBloch_entropy_eq`. Strict
  maximizer at the zero-transverse state.
- **Load-bearing hypotheses.** `hz : z != 0` is required throughout (phaseGauge,
  its unitarity, gibbsState_conj all divide by `||z||`); `he : |e| < 1` and
  `hball : e^2+u^2+v^2 <= 1` are the valid-Bloch-state / artanh-defined interior
  conditions inherited from the `z = 1` capstone. All genuinely used.

## Overclaim tests

Vacuity: none -- the normalized-energy and modular-flow conjuncts are explicitly
included to "prevent a merely decorative phase wrapper." Hollow: none (real
transport via entropy-invariance + z=1 capstone + phase-covariance lemmas).
Docstring overreach: none -- "finite 2x2 algebra. It does not claim that a
constant single-site phase is observable, that a spatial connection has been
built, or that the state has been derived from continuum dynamics." Consistent
with the earlier `PhaseCovariantModularSelection` gauge/operational separation.
False shape: none.

## Verification

- `lake build ...PhaseCovariantS2Capstone`: exit 0 (8040 jobs). Four `#guard_msgs`
  fired; `[propext, Classical.choice, Quot.sound]`, build-enforced.

## Narrowest claim

For every nonzero complex coupling `z` and every interior normalized energy
`e` (`|e| < 1`, `e^2+u^2+v^2 <= 1`), the phase-gauge-transported `2x2` Bloch
family has the same strict entropy maximizer as the canonical real family --
the zero-transverse state (`u = v = 0`), which equals the Gibbs state of `Bz z`
at `betaZ z e = -artanh e / ||z||` -- with the transported family carrying the
correct normalized energy `e` and modular-flow covariance. This is a finite
supplied-coupling phase-COVARIANT max-entropy/Gibbs theorem; it asserts no
observable constant phase, derived temperature, spatial connection, continuum
dynamics, or experiment.
