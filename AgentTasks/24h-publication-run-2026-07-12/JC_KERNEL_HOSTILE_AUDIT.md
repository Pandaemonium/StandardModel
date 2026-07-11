# Hostile audit: finite Jordan-Clifford center kernel

Aristotle project: `83a0b810-896e-4166-b997-5f953874d93e`.

## Verdict

The modular arithmetic is correct. Independent enumeration of all 36 center
labels reproduces exactly the six standard powers
`(m mod 3, m mod 2, m)`, and the phase convention agrees with the repository's
covering map. The equality is a genuine finite-set equality, not a cardinality
argument.

## Audit findings

1. High: the original `fermionCentralKernel` was a phase-triviality set, not
   formally the kernel of a homomorphism or the trusted matrix covering map.
2. High: the six bidegrees were listed literally; the file did not prove they
   were exactly the sectors of `exterior_even(W direct_sum V)`.
3. Medium: the even-sector restriction is load-bearing. Odd sectors change the
   kernel.
4. Medium: a mixed near-miss control was more informative than the three pure
   center controls.

## Immediate closure

`JordanCliffordSpinorZ6Bridge` now defines `evenFockCentralKernel` by
quantifying over every actual even five-mode occupation and proves it equals
the literal-bidegree kernel and hence the six standard powers. It adds the
mixed missing-`SU(2)` control and proves every phase-trivial label corresponds
uniquely to one of the repository's six explicit unit-level covering-kernel
elements that maps to identity.

Still open: package the finite phase rule itself as the kernel of a group
homomorphism/diagonal representation, then transport the result to the full
covering-group action on the derived fermion module.
