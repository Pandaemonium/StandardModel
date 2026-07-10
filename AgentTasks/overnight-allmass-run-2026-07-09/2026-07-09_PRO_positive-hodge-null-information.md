# Pro synthesis: positive Hodge theory of finite null information

Source: Pro analysis supplied by the user on 2026-07-09.

## Core proposal

Organize the program around a finite spectral-information object
`(A, K, J, Gamma, Q, D, Nhat, omega)`. First form cohomology and its descended
indefinite form under `Q#=Q`; physical states require an additional chosen
`D`-invariant positive subspace. A separate spectral decoder assigns mass.
Geometry, interactions, and cosmological volume would ultimately be
reconstructed from the same object.

## Audit verdict

The synthesis correctly unifies several landed finite results, but its claims
occupy three different grades:

1. **Landed finite anchors:** Pluecker mass, entropy and concurrence identities,
   Kugo-Ojima nondegenerate cohomology, an explicit positive-sector witness, signed
   closure binding, protected modes, four square-block types, spectral distance
   witnesses, and the arithmetic Poisson-to-`1/sqrt(N)` implication.
2. **New finite theorem layer:** `GenericFiniteHodge.lean` proves the generic
   finite Hilbert-Hodge representative theorem; `PositiveHodgeDecoder.lean`
   exhibits a positive non-exact harmonic class with a separate nonzero
   spectral mass; and `KreinHodgeNoGo.lean` proves that the analogous
   Krein-adjoint Laplacian can vanish while cohomology is trivial. A
   sign-flipped control separately proves positivity is not supplied by
   cohomology alone.
3. **Reconstruction conjecture:** the universal tuple, sum over geometries,
   decoder-valued state/geometry fixed point, native event-count/four-volume
   identification, volume statistics, continuum universality, radiatively
   stable vacuum sequestering, and Born-rule derivation remain open. A scalar
   Gibbs feedback fixed point has landed in `SelfConsistentDecoder`.

## Essential correction

The constraint differential `Q`, its Hodge Laplacian
`Delta_Q = Q^*Q + QQ^*`, and the spectral mass operator `D#D` are distinct.
The first defines redundancy, the second selects harmonic representatives, and
the third assigns spectral cost. Identifying them would force all physical
cohomology classes to have zero spectral mass.

The notation `(ker Q / range Q)_{J>0}` is not a definition: `Q#=Q` is needed
for the form to descend, and an indefinite quotient has no canonical positive
part. A physical space must include a chosen invariant positive subspace as
additional data. The positive and negative finite witnesses show that its
existence is contingent.

## Landed theorem target

Aristotle project `090b19dc-685b-4be7-95cb-d3305d6e5b9d` returned the generic
finite Hilbert-Hodge theorem. Although the service marked the run
`COMPLETE_WITH_ERRORS`, its returned source was placeholder-free and passed the
pinned local Lean check before landing as `GenericFiniteHodge.lean`.
