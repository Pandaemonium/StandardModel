# Source audit: strict Laurent units and three-dimensional strong winding

Status: primary-source support found; composition theorem not yet landed.

## Read 2017

Primary source: N. Read, "Compactly-supported Wannier functions and algebraic
K-theory," arXiv:1608.04696v3, Phys. Rev. B 95, 115309 (2017).

Notation correction: Read writes

```text
R_1^(d) = C[X_1^+-, ..., X_d^+-]
```

for the complex Laurent ring. The label `R_3` in Read denotes the quaternionic
ring, so the attachment's `R_3` should be read only as "three-variable ring,"
not imported as Read's symbol.

The source explicitly states the Bass-Heller-Swan step

```text
K_1(R[t,t^-1]) ~= K_1(R) + K_0(R)
```

for right regular `R`, applies it iteratively, and obtains

```text
K_1(R_1^(d)) ~= C^* + d Z.
```

It then applies the natural change of rings from Laurent polynomials to
continuous functions on `T^d`. For polynomially generated bundles with an
automorphism, the paper states that the image contributes no nonzero element
of `SK_1(C_i)`; only the zero-dimensional part and one-dimensional windings in
each coordinate survive. Its discussion identifies the missing terms as the
higher-dimensional strong topology.

This strongly supports the proposed statement that an invertible complex
Laurent matrix has no strong three-dimensional `K^1(T^3)` component after
evaluation on the torus. It is stronger than an abstract-only inference: the
paper gives the algebraic `K_1` calculation and the change-of-rings conclusion.

## Remaining composition gates

Before manuscript grade T, verify:

1. Our exactly unitary Laurent symbol is an automorphism of the same free
   complex Laurent module, including the `sharp` involution convention.
2. The stable algebraic `K_1` class controls the particular finite-rank sector
   block used in the crossing theorem; stabilization must not erase a
   finite-rank obstruction relevant to the charge census.
3. The strong `K^1(T^3)` component used by the Floquet theorem agrees in sign
   and normalization with the winding assigned to each global chirality block.
4. Determinant monomials/delays are separated before asserting zero total
   sector charge.

Do not encode the Read result as a new Lean assumption. Kernel-check only the
finite implication from an explicit `totalCharge = 0` hypothesis.

## Floquet charge bookkeeping

Primary source: T. Bessho and M. Sato, "Nielsen-Ninomiya Theorem with Bulk
Topology: Duality in Floquet and Non-Hermitian Systems," arXiv:2006.04204,
Phys. Rev. Lett. 127, 196404 (2021), including the supplement.

The paper relates sums of local gapless-mode charges to a bulk dynamical
topological invariant and records a dimension-dependent sign for the
quasienergy-pi contribution. This supports the charge-sum architecture, but the
exact class-A versus symmetry-protected case and the zero/pi sign convention
must be copied from the displayed theorem before use in Paper B.

Controls:

- Higashikawa, Nakagawa, and Ueda, arXiv:1806.06868, explicitly realize a
  single Weyl fermion with a topologically nontrivial Floquet unitary. This is
  the positive control showing why the bulk invariant cannot simply be omitted.
- Gupta and Short, arXiv:2601.15885v2, explicitly report removal of conventional
  doublers and pseudo-doublers but retain additional low-energy solutions. The
  exact census must determine whether their tangent, global chirality, or
  residual modes supply the compensating structure.

## Verdict

The strict-Laurent no-strong-winding spine is source-supported and worth
pursuing. It is not yet a completed no-doubling theorem. The honest immediate
claim is:

```text
Read's algebraic K-theory excludes a strong stable K1 class for complex
Laurent automorphisms; composing that result with the symmetry-resolved
Floquet crossing-charge theorem is the remaining mathematical gate.
```
