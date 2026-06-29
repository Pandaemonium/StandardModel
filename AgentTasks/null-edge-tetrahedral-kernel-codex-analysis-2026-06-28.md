# Codex analysis: tetrahedral null-edge overlap kernel while awaiting C240

Date: 2026-06-28

Status: informal analysis, not Lean-checked.

## Question

Can we say anything ourselves about the proposed tetrahedral kernel while the
C240 Aristotle branch-window job is still running?

Proposed free kernel:

```text
H_C1(k) =
  gamma5 [
    (i/a) sum_A B_A sin(k_A)
    + (r/a) sum_A (1 - cos(k_A))
    - rho/a
  ],
```

with:

```text
B_A = (1/4) gamma4 + (3/4) v_A^i gamma_i,
```

where the four spatial `v_A` are regular tetrahedron vertices:

```text
sum_A v_A = 0,
sum_A v_A^i v_A^j = (4/3) delta_ij,
v_A . v_B = 1 if A = B, and -1/3 if A != B.
```

## 1. Coframe identities look correct

Compute:

```text
sum_A B_A
  = sum_A [(1/4) gamma4 + (3/4) v_A^i gamma_i]
  = gamma4 + (3/4)(sum_A v_A^i) gamma_i
  = gamma4.
```

Also:

```text
sum_A B_A v_A^j
  = (1/4)(sum_A v_A^j) gamma4
    + (3/4)(sum_A v_A^i v_A^j) gamma_i
  = 0 + (3/4)(4/3 delta_ij) gamma_i
  = gamma_j.
```

So the proposed `B_A` are the dual Clifford soldering matrices for the
tetrahedral null frame.

## 2. The `B_A` should be linearly independent

Suppose:

```text
sum_A x_A B_A = 0.
```

The `gamma4` coefficient gives:

```text
sum_A x_A = 0.
```

The spatial coefficients give:

```text
sum_A x_A v_A = 0.
```

For a regular tetrahedron, the only linear relation among the four `v_A` is:

```text
sum_A v_A = 0.
```

Thus `x_A` must be constant in `A`; the first equation forces that constant to
be zero. Therefore all `x_A = 0`.

Consequence:

```text
sum_A B_A sin(k_A) = 0
```

should imply:

```text
sin(k_A) = 0 for every A.
```

This is the key algebraic step behind the `2^4 = 16` branch count.

## 3. The branch count is plausible, conditional on the lattice model

If the four null edge vectors `n_A = (1, v_A)` generate a rank-4 oblique lattice
and `k_A` are the independent reciprocal coordinates, then:

```text
sin(k_A) = 0 for all A
```

gives:

```text
k_A in {0, pi}
```

for each `A`, hence:

```text
16 branch points.
```

Important caveat:

```text
This is not just a Clifford-algebra statement.
It also assumes the null-edge shifts define a rank-4 lattice whose reciprocal
torus coordinates are independent modulo 2*pi.
```

This is the exact place where hypercubic intuition can be wrong. C240 should
confirm or correct the Brillouin-zone/dual-lattice assumptions.

## 4. Scalar Wilson branch masses have the expected sign pattern

At a branch point with `n` of the `k_A` equal to `pi`:

```text
sum_A (1 - cos(k_A)) = 2n.
```

Therefore the shifted scalar mass is:

```text
m_n = (2 r n - rho) / a.
```

If:

```text
0 < rho < 2r,
```

then:

```text
m_0 = -rho/a < 0,
m_n = (2rn - rho)/a > 0 for n = 1,2,3,4.
```

So scalar Wilson should be enough at the exact branch points, provided the
branch classification above is correct.

This does not contradict the old scalar-Wilson no-go:

```text
Old no-go:
  scalar Wilson cannot directly polarize a chirality-balanced origin kernel.

Current role:
  scalar Wilson supplies branch mass signs inside an overlap kernel.
```

## 5. A useful explicit norm identity

Let:

```text
s_A = sin(k_A),
S = sum_A s_A,
Q = sum_A s_A^2.
```

The gamma-vector coefficient of:

```text
sum_A B_A s_A
```

has Euclidean squared norm:

```text
|b(s)|^2 =
  (1/16) S^2 + (9/16) |sum_A s_A v_A|^2.
```

Using the tetrahedral Gram relation:

```text
|sum_A s_A v_A|^2
  = (4/3) Q - (1/3) S^2,
```

we get:

```text
|b(s)|^2
  = (3/4) Q - (1/8) S^2.
```

This is positive definite. In fact:

```text
|b(s)|^2 >= (1/4) sum_A sin(k_A)^2.
```

The constant direction has ratio `1/4`; the subspace `S = 0` has ratio `3/4`.

This identity may be useful for proving a quantitative lower bound for the
Hermitian kernel.

## 6. Candidate global gap function

Ignoring factors of `1/a`, the squared free Hermitian-kernel eigenvalue should
be controlled by:

```text
F(k) =
  |sum_A B_A sin(k_A)|^2
  + [r sum_A (1 - cos(k_A)) - rho]^2.
```

Using the bound above:

```text
F(k) >=
  (1/4) sum_A sin(k_A)^2
  + [r sum_A (1 - cos(k_A)) - rho]^2.
```

This lower bound is strictly positive if the two terms cannot vanish together.

The first term vanishes exactly when:

```text
sin(k_A) = 0 for all A.
```

At those branch points:

```text
r sum_A (1 - cos(k_A)) - rho = 2rn - rho,
```

which is nonzero for `0 < rho < 2r`.

Therefore the free kernel should be invertible on the full torus under the
same mass-window condition, at least by compactness. A quantitative minimum
would require a more careful optimization over:

```text
x_A = 1 - cos(k_A) in [0,2].
```

This is a good target for a follow-up proof job if C240 confirms the branch
geometry.

## 7. Where the proof can still fail

The scalar Wilson story can still fail if:

```text
1. the actual null-edge reciprocal torus does not have independent k_A;
2. the edge shifts have extra identifications beyond k_A modulo 2*pi;
3. the `B_A` used in the project differ by convention/sign from the proposed
   Euclidean tetrahedral coframe;
4. the actual C21 branch geometry has additional zeros not captured by the
   centered tetrahedral free symbol;
5. gauge-covariant noncommutativity changes the branch-mass realization before
   the background-gauge layer.
```

This is why C240 remains decisive.

## 8. My current expectation

Conditional on the rank-4 oblique-lattice interpretation, scalar Wilson should
work for the clean free tetrahedral overlap kernel:

```text
M_br = 0
```

should be enough for the first free overlap branch theorem.

But if the actual null-edge graph imposes nontrivial branch identifications or
has extra branch zeros, C241 tells us the next move:

```text
add the sparsest symmetry-compatible gamma5-even Hermitian M_br that separates
the residual branches.
```

## 9. Suggested next local theorem targets

```text
tetrahedral_B_sum:
  sum_A B_A = gamma4.

tetrahedral_B_weighted_sum:
  sum_A B_A v_A^i = gamma_i.

tetrahedral_B_linearIndependent:
  sum_A x_A B_A = 0 -> forall A, x_A = 0.

tetrahedral_naive_zero_iff:
  sum_A B_A sin(k_A) = 0 <-> forall A, sin(k_A) = 0.

tetrahedral_scalar_wilson_branch_mass:
  at a branch with n flipped coordinates, shifted mass is (2rn - rho)/a.

tetrahedral_scalar_wilson_window:
  0 < rho < 2r -> physical branch negative and all exact doubler branches
  positive.

tetrahedral_gap_no_zero:
  under the same hypotheses, the free H_C1(k) has no zero on the torus.
```

The last theorem is the first one that really starts to look like Gate C1 free
progress rather than just algebraic scaffolding.
