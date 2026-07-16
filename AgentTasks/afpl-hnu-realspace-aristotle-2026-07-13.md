# Aristotle task: exact real-space HNU conditioned-shift bridge

## Objective

Starting from the supplied exact HNU momentum-space core, construct the finite
periodic real-space schedule whose Fourier symbol is exactly each
projector-conditioned substep and hence the depth-eight endpoint.  This is the
missing bridge from a noncommutative topological symbol to an actual local
microscopic update.

## Required theorem ladder

1. Define a finite periodic `L x L x L` site register with a two-component spin
   register and exact discrete Fourier characters.
2. Define each real-space substep as a spin-projector-conditioned nearest-
   neighbor shift along one coordinate, with the complementary spin sector held
   fixed.  Prove exact unitarity and strict range-one locality.
3. Prove, on every Fourier mode, that the substep symbol is exactly the supplied
   `Uplus` or `Uminus`, including the exponent/sign convention.
4. Compose all eight substeps and prove the full real-space schedule has symbol
   exactly `HNUExactCore.endpoint`.
5. Give a nontrivial finite witness and prove no spin-blind scalar-shift/fixed-
   coin factorization can represent the conditioned substep.
6. Audit primitive-null support carefully.  A spatial nearest-neighbor shift per
   tick is a candidate null link only after a declared time/spacing
   normalization; stationary complementary sectors are not null propagation.
   Either refine the schedule so every primitive branch moves or state this as
   the exact remaining obstruction.
7. Do not infer W=1, continuum Weyl behavior, anomaly cancellation, or bulk-edge
   correspondence from the symbol bridge.  Those are separate jobs.
8. No proof placeholders, compiled evaluation, or new assumptions.  Add
   standard-axiom guards.

Use exact finite sums where possible.  If the full Fourier package is too
large, land the one-axis substep-symbol theorem and a composition theorem under
an explicit Fourier-intertwining hypothesis; do not replace the bridge with a
definition.
