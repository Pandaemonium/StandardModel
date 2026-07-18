# Independent semantic review: rank-four carrier probe-sector correction

Date: 2026-07-16

Work item: `GRAV-GROWING-ATLAS-001`

## Project context

The NullStrand/null-edge program is attempting a conservative gate-by-gate
reconstruction of continuum Lorentzian geometry from finite causal order and
null-edge data. The current finite operator architecture uses zero-sum scalar
probe fields on closed Alexandrov carriers. A prior Lean module packaged a
`Fin 4` basis of the entire zero-sum carrier space as a four-probe frame and
proved conditional Gram-congruence and Lorentz-gauge results.

A semantic audit found that the whole zero-sum space has dimension
`|carrier| - 1`; therefore a `Fin 4` basis of that whole space is possible only
on five-event carriers. The prior algebra is correct, but its frame interface
cannot scale to physical refinement carriers.

The proposed successor module proves the obstruction and introduces a supplied
rank-four subspace of the whole zero-sum sector. It re-establishes the finite
Gram/Lorentz algebra and order-isomorphism covariance on that subspace. It also
proves arbitrary rank-four subspaces exist whenever the carrier has at least
five events, while explicitly withholding any claim that the arbitrary choice
is intrinsic or physical.

## Intended reading

1. `carrierProbeFrame_forces_card_five` is an exact semantic-domain audit of
   the old interface.
2. `RankFourCarrierProbeSector` is a supplied candidate subspace, not a graph
   derivation.
3. `rankFourCarrierProbeSector_nonempty_of_five_le_card` establishes only
   algebraic nonvacuity. It does not solve natural selection, overlap
   compatibility, Lorentzian inertia, or convergence.
4. The physically meaningful open gate is a bare-order construction of a
   rank-four subspace family `P_A` that is relabeling-natural, retarded-visible,
   overlap-compatible, Lorentzian under the corrected pairing, and stable in a
   refinement limit.
5. No preferred basis is sought; frames inside `P_A` are Lorentz gauge choices.

## Review questions

Please audit the embedded Lean source and report:

1. Is the cardinality obstruction mathematically and semantically exact?
2. Does the selected-sector successor genuinely remove the old physical
   vacuity, or merely hide it in a supplied structure?
3. Are any theorem names, docstrings, or claim grades stronger than the kernel
   statements warrant?
4. Is `mapOrderIso` only transport of an already selected sector, as intended,
   rather than a proof that an independently selected target sector is natural?
5. Does the arbitrary subspace existence theorem risk being mistaken for a
   graph-native selector, despite its docstring and surrounding note?
6. Is the proposed next gate scientifically well posed: derive the subspace and
   transition class, but retain basis freedom as local Lorentz gauge?
7. Identify any hidden assumptions, false-shape theorem, vacuity, or missing
   explicit witness that should block integration.

## Requested verdict format

Return exactly these sections:

1. `Verdict`: APPROVE, REVISE, or REJECT.
2. `Kernel/statement alignment`.
3. `Physical claim boundary`.
4. `Required changes before integration`.
5. `Recommended next reconstruction gate`.

Treat a theorem that is true but physically false-shaped as a blocking issue.
Do not credit prose intentions that the embedded declarations fail to encode.
