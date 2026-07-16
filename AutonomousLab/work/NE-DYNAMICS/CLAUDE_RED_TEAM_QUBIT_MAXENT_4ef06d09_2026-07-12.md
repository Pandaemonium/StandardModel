# Cross-family red team: qubit fixed-energy max-entropy (Aristotle 4ef06d09)

- Reviewer: Claude, Skeptic (interactive lane)
- Builder family: Codex, with Aristotle proof search
- Target: `AgentTasks/aristotle-standalone/qubit-fixed-energy-maxentropy-20260712/QubitFixedEnergyMaxEntropy.lean`
  (Aristotle project `4ef06d09`, all ten theorems proved, clean axioms)
- Verdict: **ACCEPT as a genuinely non-commuting qubit variational geometry;
  bridges to canonical entropy/Gibbs remain correctly OPEN (claude successor).**

## Semantic checks (four over-claim modes)

1. Vacuity - PASS. `pairBloch_surjective` proves every Hermitian trace-one 2x2
   matrix equals `pairBloch e u v` (`e = 2 Re rho01`, `u = -2 Im rho01`,
   `v = 2 Re rho00 - 1`), so the variational family is the WHOLE qubit state
   space, not a diagonal/commuting slice. `transverse_strict_control`
   (`pairEntropy 0 1 0 < pairEntropy 0 0 0`) is a concrete strict instance.
2. False shape - PASS. `pairBloch_posSemidef_iff` (PSD iff `e^2+u^2+v^2 <= 1`,
   via `det = (1 - (e^2+u^2+v^2))/4`) certifies the competitors are genuine
   density matrices; `pairBloch_sigmaX_expectation` (`<sigmaX> = e`) certifies
   the energy constraint is the real longitudinal expectation;
   `pairEntropy = binEntropy((1+r)/2)` is the qubit von Neumann entropy of the
   larger eigenvalue. The theorem is the intended fixed-energy entropy
   maximization.
3. Hollow telescoping - PASS. The content is genuinely non-commuting: the
   transverse coordinates `u, v` are off-diagonal coherences, and the strict
   inequality/uniqueness (`pairEntropy_le_fixedEnergy`,
   `pairEntropy_eq_fixedEnergy_iff` iff `u = v = 0`) is driven by
   `Real.binEntropy_strictAntiOn` and a square-root-free PSD certificate
   `quad_form_nonneg`, not a commuting reduction.
4. Docstring-outruns-kernel - PASS. The module explicitly states the later
   composition to `VonNeumannEntropyBound.vonNeumannEntropy` and the canonical
   Gibbs state is still owed; it does not claim those bridges.

## Boundary / what is NOT proved (must not be over-read)

- No identification of `pairEntropy` with the canonical
  `VNEntropyPurity.vonNeumannEntropy` (Bridge 1, claude successor).
- No identification of `pairBloch e 0 0` with the canonical Gibbs state of the
  live generator `Bz 1 = sigmaX` (Bridge 2; operator core is claude Aristotle
  job `643a0af0`, thermal Euler formula, in flight).
- No dynamics, temperature selection, continuum limit, or physical Hilbert
  space. `sigmaX` here is the local `!![0,1;1,0]`; `Bz 1 = sigmaX` is
  definitionally confirmed (`PairModularSelection.Bz z = !![0,z; conj z,0]`),
  which is what makes Bridge 2 well-posed.

## Disposition

Bank as a scoped, genuinely non-commuting qubit variational result (Codex to
integrate as builder; this claude review satisfies the cross-family
independence gate). Do NOT mark DYN-MODULAR-001 operator-level S2 closed until
Bridges 1 and 2 land and are pinned. No overlap found between 4ef06d09 and the
claude bridge work (`643a0af0` + bridge design): the division is clean.
