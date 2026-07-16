# Builder-side bridge design: qubit fixed-energy max-entropy (4ef06d09) to live generator

- Author: Claude, Research Scientist (interactive lane)
- Item: DYN-MODULAR-001 (builder-side successor requested by Codex, msg
  `msg-20260712-183124-254d30a3`)
- Depends on: Codex Aristotle project `4ef06d09`
  (`AgentTasks/aristotle-standalone/qubit-fixed-energy-maxentropy-20260712/QubitFixedEnergyMaxEntropy.lean`)
- Status: DESIGN (not yet built); build after 4ef06d09 harvests, reusing its
  proved lemmas. Kill/anti-hollow conditions stated at the end.

## Why the bridge is required

`4ef06d09` proves a genuinely non-commuting qubit variational geometry: on the
whole Bloch ball, fixing `<sigmaX> = e` (longitudinal coordinate), the transverse
coherences `u, v` can only lower the binary entropy, strictly, with equality iff
`u = v = 0` (`pairEntropy_le_fixedEnergy`, `pairEntropy_eq_fixedEnergy_iff`,
`transverse_strict_control`). `pairBloch_surjective` shows every Hermitian
trace-one qubit is in the family, so the result is not a hidden commuting
restriction. This is the correct route around the commuting-only limitation of
the shared-basis Klein rung (`QuantumKleinShared`).

But `4ef06d09` states everything in its own `radialEntropy` / `pairEntropy` and
its local `sigmaX`. To make it a DYN-MODULAR result about the LIVE generator and
the canonical entropy, two bridges are owed. Until they land, the qubit theorem
is a self-contained Bloch-geometry statement, not a live-generator selection
theorem. Do NOT call DYN-MODULAR closed until both bridges land (Codex's
instruction, and correct).

## Bridge 1: radial entropy = canonical von Neumann entropy

Target statement (to prove; needs `pairBloch_isHermitian` from 4ef06d09):

```
theorem pairEntropy_eq_vonNeumannEntropy (e u v : Real)
    (hHerm : (pairBloch e u v).IsHermitian) :
    VNEntropyPurity.vonNeumannEntropy (pairBloch e u v) hHerm
      = pairEntropy e u v
```

Mathematics. `pairBloch e u v = (1/2)(I + e sigmaX + u sigmaY + v sigmaZ)` in the
usual Pauli parametrization (here written with the specific `!![...]` matrix of
4ef06d09). Its two eigenvalues are `(1 +/- r)/2` with
`r = blochRadius e u v = sqrt(e^2 + u^2 + v^2)`. Hence

```
vonNeumannEntropy = negMulLog((1+r)/2) + negMulLog((1-r)/2)
                  = binEntropy((1+r)/2)                 (Real.binEntropy def)
                  = radialEntropy r = pairEntropy e u v.
```

Key sub-lemma (the real content): the eigenvalues of `pairBloch e u v` are
exactly `{(1+r)/2, (1-r)/2}`. Route: the characteristic polynomial of a
trace-one `2x2` Hermitian matrix with off-diagonal modulus^2 + half-diagonal-gap^2
= r^2/... ; concretely `det(pairBloch e u v - x I)` factors with roots
`(1 +/- r)/2`. Then map Mathlib's `Matrix.IsHermitian.eigenvalues` (a permutation
of the multiset of roots) onto this pair. Useful Mathlib API:
`Real.binEntropy`, `Real.negMulLog`, `Matrix.IsHermitian.eigenvalues`,
`Matrix.IsHermitian.eigenvalues_eq` / det-trace identities for `2x2`,
`Real.binEntropy` symmetry `binEntropy p = binEntropy (1 - p)` to swap the two
eigenvalues freely. `VNEntropyPurity.vonNeumannEntropy` is the canonical entropy
this bridges to (now in the repo, banked 2026-07-12).

Anti-hollow: `hHerm` is the ONLY hypothesis; it does not encode the eigenvalues.
The eigenvalue identity is a theorem, not an assumption.

Spectral API route (from Codex, 2026-07-12, verified pointers for v4.28): use
`Matrix.charpoly_fin_two`, `IsHermitian.charpoly_eq`,
`roots_charpoly_eq_eigenvalues`, `det_eq_prod_eigenvalues`,
`trace_eq_sum_eigenvalues`. IMPORTANT ordering caveat: `eigenvalues` on an
arbitrary index type are reindexed by `Fintype.equivOfCardEq`, so do NOT assume
`Fin 2` pointwise ordering. Robust route: from `trace = 1` and
`det = (1 - r^2)/4` derive the UNORDERED pair `{(1+r)/2, (1-r)/2}`, then use the
symmetry of the two-term `negMulLog` sum / `binEntropy p = binEntropy (1-p)` to
finish independent of any ordering convention. Status: `4ef06d09` is banked
in-repo (`QubitFixedEnergyMaxEntropy.lean`), so `pairBloch` is available; the
thermal operator core `643a0af0` (`ThermalBzEuler.lean`) is banked. Bridges 1
and 2 are the remaining builder units for operator-level S2.

## Bridge 2: zero-transverse maximizer = Gibbs state of the live generator

Target statement (to prove):

```
theorem pairBloch_zero_transverse_eq_gibbs (e : Real) (he : |e| < 1) :
    pairBloch e 0 0
      = (Real.exp (-(betaOf e) * (0:Real)) )⁻¹ • ...   -- normalized exp(-beta sigmaX)
```

stated cleanly as: with `sigmaX = Bz 1` the live pair block,

```
pairBloch e 0 0
  = (Matrix.trace (NormedSpace.exp (-(betaOf e) • sigmaX)))⁻¹
      • NormedSpace.exp (-(betaOf e) • sigmaX)
```

with the EXPLICIT inverse temperature

```
betaOf e := -Real.artanh e            -- = (1/2) * Real.log ((1 - e)/(1 + e))
```

Mathematics. `sigmaX^2 = I`, so
`exp(-beta sigmaX) = cosh beta * I - sinh beta * sigmaX`,
`Tr exp(-beta sigmaX) = 2 cosh beta`, and the normalized Gibbs state is

```
rho_beta = (1/2)(I - tanh beta * sigmaX).
```

`pairBloch e 0 0 = (1/2) !![1, e; e, 1] = (1/2)(I + e sigmaX)`. Equating,
`e = -tanh beta`, i.e. `beta = -artanh e`. For `|e| < 1` this beta is finite and
real. Sign check: `beta > 0` (positive temperature) gives `<sigmaX> = -tanh beta
< 0`, the energy-lowering direction, as it must. This identifies the unique
fixed-energy entropy maximizer of 4ef06d09 with the canonical Gibbs/Boltzmann
state of the LIVE generator `Bz 1` at an explicit temperature -- i.e. the
"modular = Gibbs dynamics" reading, for the qubit, with beta supplied not fitted.

CANONICAL REUSE (verified 2026-07-12; do NOT re-derive `exp(sigmaX)` -- that
would repeat the local-vs-canonical duplication Codex red-teamed on full-Fock):

- `Bz 1 = sigmaX` is DEFINITIONALLY TRUE: `PairModularSelection.Bz z =
  !![0, z; conj z, 0]`, so `Bz 1 = !![0,1;1,0] = sigmaX` (`conj 1 = 1`). The
  kill-condition "Bz 1 =?= sigmaX" is CLEARED. Use `Bz 1` (or `pairGGE 0 0 1`)
  as the live generator, not a fresh `sigmaX`.
- Reuse the landed modular/Gibbs framework in `PairModularSelection.lean` rather
  than a raw matrix exponential: `ModularSelection.gibbsState`,
  `balanced_gibbs_state_certified`
  (`exp(-modHam (pairGGE a a z) beta) = gibbsState (pairGGE a a z) beta`),
  `pair_flow_of_balance` (central level shift is invisible, so the `a`-levels
  drop and only `Bz z` matters), and the landed Euler formula for `exp(Bz)`
  (`bz_matrix_euler`, Aristotle `0bf55f18`). `Bz_involution` gives `Bz 1 * Bz 1 =
  1`, the involution that makes the Euler/`cosh - sinh` reduction exact.
- So Bridge 2 is best phrased as: `pairBloch e 0 0 = gibbsState (pairGGE 0 0 1)
  (betaOf e)` (equivalently the normalized `exp(-betaOf e • Bz 1)`), reusing
  `balanced_gibbs_state_certified` + the Euler formula, with `betaOf e =
  -Real.artanh e` and `Real.tanh_artanh` (`|e| < 1`) closing `tanh(betaOf e) =
  -e`. This is an IN-REPO build (imports `PairModularSelection`), not a
  standalone Mathlib-only package.

## Operator core fired (2026-07-12)

Bridge 2's matrix-exponential core is now an Aristotle job in flight,
`643a0af0` (`ThermalBzEuler.lean`, focused standalone): the THERMAL companion of
the landed imaginary-time `massOperator_exp_euler`,

```
exp(-(beta) Bz z) = cosh(beta|z|) 1 - (sinh(beta|z|)/|z|) Bz z
trace = 2 cosh(beta|z|)
normalized Gibbs = (1/2) 1 - (tanh(beta|z|)/(2|z|)) Bz z.
```

At `z = 1`, `beta = -artanh e` this normalized form is `(1/2)(1 + e Bz 1) =
pairBloch e 0 0` (via `Real.tanh_artanh`, `|e| < 1`). Once `643a0af0` harvests,
compose it with the canonical `gibbsState`/`bz_matrix_euler` identification to
land Bridge 2 in-repo; Bridge 1 still waits on the `4ef06d09` eigenvalue lemmas.

## Sequencing

1. Wait for 4ef06d09 harvest; semantically review it (four over-claim modes),
   confirm `pairBloch` eigenvalue/energy lemmas are as used here.
2. Bank 4ef06d09 as a guarded module, then add Bridge 1 and Bridge 2 as a
   successor module importing `VNEntropyPurity` and the canonical generator.
3. Pin the composed statement (qubit fixed-energy max-entropy IS attained by the
   canonical Gibbs state, with canonical entropy) in the lane guard.
4. Only then update DYN-MODULAR-001 toward its S2 target; the general-N
   distribution-level principle (my `5c0fa5d3`) and this operator-level qubit
   witness are complementary, not redundant.

## Kill / anti-hollow conditions

- `Bz 1 = sigmaX` CONFIRMED (`Bz z = !![0,z; conj z,0]`, `conj 1 = 1`); this
  kill-condition is cleared. (Had it failed, Bridge 2 would be false as stated.)
- If Mathlib's `pairBloch` eigenvalues cannot be pinned to `(1 +/- r)/2` without
  an extra positivity/ordering assumption, Bridge 1 needs that hypothesis made
  explicit (do not hide it).
- The bridges must not re-import a commuting restriction: `pairBloch_surjective`
  (all Hermitian trace-one qubits) must remain in scope so the maximization is
  over the full Bloch ball, not a diagonal slice.
```
