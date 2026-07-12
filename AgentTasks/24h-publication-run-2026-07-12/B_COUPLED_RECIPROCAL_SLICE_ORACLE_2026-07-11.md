# Exact oracle: chirality-coupled reciprocal slice no-go

## Verdict

Grand strategy 7's flagship P1 architecture is **killed in its smallest direct
embedding**. The coupled reciprocal coin gaps all seven old cube-corner
fixtures, but it creates additional zero- and pi-quasienergy crossings away
from those fixtures.

This is an exact SymPy oracle result over Gaussian rationals, not yet a Lean
theorem. Reproduce it with:

```powershell
python Scripts/oracle/analyze_chirality_coupled_reciprocal.py
```

## Repository convention

The live Clifford matrices satisfy

```text
alpha_j = sigma_x tensor sigma_j,
Xi      = sigma_x tensor I.
```

The tested coin is therefore

```text
C = (3/5) I_4 + i (4/5) (sigma_z tensor sigma_x),
```

whose nontrivial generator anticommutes with `Xi`. The conditional shift is
`I tensor diag(z,1)`. Thus this is a genuinely chirality-coupled version of
the reciprocal conditional-shift primitive, translated into the repository's
actual tensor convention.

## Exact one-dimensional slice

On the physical slice `q_x=pi`, `q_y=0`, write `z=exp(i q_z)`. The complete
candidate has determinant one, while

```text
det(U(z)-I)
  = (11376 z^4 + 143521 z^3 - 187294 z^2 + 143521 z + 11376)^2
      / (152587890625 z^4),

det(U(z)+I)
  = (11376 z^4 - 637729 z^3 - 187294 z^2 - 637729 z + 11376)^2
      / (152587890625 z^4).
```

Both quartics are reciprocal. Dividing by `z^2` and setting
`x=z+z^-1=2 cos(q_z)` gives

```text
p_+(x) = 11376 x^2 + 143521 x - 210046,
p_-(x) = 11376 x^2 - 637729 x - 210046.
```

Their exact signs are

```text
p_+(1)  = -55149,   p_+(2) = 122500,
p_-(-1) = 439059,   p_-(0) = -210046.
```

By continuity, `p_+` has a root in `(1,2)` and `p_-` has a root in `(-1,0)`.
Both intervals lie inside the unit-circle range `x=2 cos(q_z)`. Hence this
single physical slice contains an additional `U=+I` crossing and an additional
`U=-I` crossing.

## Scientific consequence

Quadratic chirality mixing, exact unitarity, determinant one, and visibility
at the old corners are still insufficient. The reciprocal word can move the
crossing locus without reducing it. P1 should not receive a global torus
certificate job; its exact slice already refutes uniqueness.

The next constructive choices are:

1. test the determinant-paired enlarged-register P2 architecture;
2. land the exact minimally doubled P4 hedge;
3. freeze the bounded global-chiral phase-word no-go at hypothesis-gated scope.

No manuscript alias-removal claim is licensed by this oracle.
