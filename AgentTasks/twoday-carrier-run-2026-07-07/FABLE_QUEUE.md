# Fable queue (two-day carrier run) - the standing escalation channel

Both agents append conceptual blockers, design forks, suspected-false statements,
and red flags the moment they occur. Claude triages this queue into every
2-hourly call (`FABLE_CALL_PROTOCOL.md` sec 5). Mark answered items
`[ANSWERED call-NN] <one-line decision>` - do not delete them.

Format:
```
- [QUEUE HH:MM agent] problem (one line); statement/file:line; tried; what kind
  of answer unblocks (decision / decomposition / verdict-false / reference)
```

## Seeded items (run start)

- [QUEUE T+0 setup] OS1 route fork: character/polymer expansion (stands on landed
  CharacterExpansion + StrongCouplingAreaLaw + the Z2 SlabGapAssembly template)
  vs Shen-Zhu-Zhu functional-inequality route (2204.12737; explicit
  |beta| < 1/(16(d-1)) but imports Langevin/log-Sobolev machinery with thin
  Mathlib support). Codex prepares the comparison; unblock = DECISION at call 01.
- [QUEUE T+0 setup] Move-1 2-complex design: minimal viable 2-complex for the
  Weitzenbock assembly - reuse NSBB causal-diamond cells verbatim, or a purpose-
  built 2-plaquette complex mirroring WilsonSlabConnected? Tension: NSBB reuse
  buys the Krein structure but drags imports; purpose-built is standalone but
  duplicates `#`-structure lemmas. Unblock = DECISION at call 01 (affects every
  W1 brick statement).
- [QUEUE T+0 setup] The Krein positivity domain [CRUX, standing]: on which
  physical-sector does `D^#D` restrict to a genuine nonneg form? NSBB's
  <lambda, lambda-tilde> pairing is the prior infrastructure. NOT blocking W1
  (forms, not spectra) - queued so Fable can chip at it across calls; any partial
  characterization upgrades W2c. Unblock = decomposition.
- [QUEUE T+0 setup] The closure statistical-positivity [CRUX, standing]: beyond
  leading order, `<Q_C> >= 0` in the gauge measure. Not this run's target (QC is
  leading-order-only) - queued for horizon guidance: what is the weakest
  beyond-leading statement worth attempting next run? Unblock = reference /
  decomposition.

## Live entries (append below)

- [QUEUE 21:34 Codex QC] Leading-order `Q_C` identification statement shape.
  Candidate: in the finite Z2/one-link strong-coupling shadow, identify the
  leading closure-flux coefficient with the already-landed contraction factor
  `exp(-gap) = tanh beta` (`SlabTransferGap.neU4_exp_neg_closure_gap_eq_tanh`,
  `TYAreaLaw.partitionRatio_eq_tanh`, `SlabGapAssembly.gap_value`), and state
  the `Q_C` expectation only as a leading-order/character-coefficient read-off.
  Trap: do NOT claim beyond-leading `<Q_C> >= 0`, and do NOT conflate the three
  objects in `SlabGapAssembly` (transfer matrix, OS Hamiltonian gap, normalized
  two-state transfer). Unblock = ratify exact object/normalization and whether
  the first Lean theorem should live in `GateYM/QCLeading.lean`,
  `TYAreaLaw.lean`, or a Carrier/GateYM bridge after Claude lands torus `Q_C`.
- [QUEUE 22:18 Codex QC/Aristotle] Focused Aristotle strategy says the landed
  `QCLeading` file should remain a scalar normalization layer; the next bridge
  should be a parameterized `QCCarrierBridge.LeadingQCCarrierContract`, with the
  carrier observable supplied as a parameter and no measure/expectation claim.
  Unblock at call 03 = RATIFY the contract fields, normalization direction, and
  whether it waits for Claude's Carrier theorem
  `nabla_commute_of_plaquetteCurvature_zero` before any proof spend.

## Answered by call 01
- [ANSWERED call-01] OS1 route fork -> character/polymer on a FINITE gauge group is far
  more Mathlib-formalizable than Shen-Zhu-Zhu (no log-Sobolev in Mathlib). Codex: finite
  group first, before SU(2) Haar. Revisit at call 03 with Codex gate status.
- [ANSWERED call-01] 2-complex design fork -> purpose-built Z2xZ2 gauge torus (commuting
  shifts = add_comm, no boundary partiality); prose bridge to WilsonSlabConnected, not a
  bridge theorem. Beats causal-diamond reuse and the raw slab.
