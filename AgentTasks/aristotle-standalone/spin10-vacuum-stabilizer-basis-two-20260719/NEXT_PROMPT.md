# Vacuum-stabilizer transitivity on every basis-two affine chart

Prove `exists_vacuumStabilizer_affine_basisTwo_to_weak` in
`PhysicsSM/Draft/Spin10VacuumStabilizerBasisTwo.lean`.

The previous return proves the result only for `T = {3,4}` by an explicit
two-contraction root. Extend it to every two-element `T`. The essential new
content is a mode permutation or `GL(5)`-type basis change realized inside the
algebraic even Clifford group that fixes `vacuumSpinor` exactly and carries
`basisSpinor T` to a nonzero multiple of `weakSpinor`. Then compose with the
proved annihilation-root affine-line theorem. Do not invoke the full open
vacuum-fiber transitivity theorem. Preserve exact Fock signs and the project
Spin(10) conventions. A kernel counterexample is first-class; otherwise remove
the proof hole, add an axiom guard, and run the target directly. Read
`CONTEXT.md`.
