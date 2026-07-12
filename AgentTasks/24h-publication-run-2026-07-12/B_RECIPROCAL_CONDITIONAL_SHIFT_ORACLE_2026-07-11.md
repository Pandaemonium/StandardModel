# Reciprocal conditional-shift regulator oracle

Date: 2026-07-11
Status: exact SymPy oracle; Lean target typechecks with proof holes

## Construction

Let

```text
C = [[3/5, 4/5], [-4/5, 3/5]]
D(z) = diag(z, 1)
K(z) = D(z) C D(z^-1) C^-1
S(z) = K(z) K(z^-1).
```

Unlike an involutory phase step, `D(-1)=diag(-1,1)` is noncentral.  The
reciprocal pair is designed to cancel its linear jet while retaining action at
the old `z=-1` alias.

## Exact oracle output

SymPy exact rational simplification gives

```text
S(1) = I
dS/dz |_(z=1) = 0
det S(z) = 1
S(-1) = (1/625) [[-527, 336], [-336, -527]]
det(S(-1)-I) = 2304/625
det(S(-1)+I) = 196/625.
```

It also factors the complete origin defect as

```text
S(z)-I = (z-1)^2 Q(z)
```

with

```text
Q00 = -144(z-1)/(625z)
Q01 =  12(16z+9)/(625z)
Q10 = -12(9z+16)/(625z^2)
Q11 =  144(z-1)/(625z^2).
```

Thus the two-band fixture is exactly determinant-one, quadratically flat at
the intended origin, finite Laurent range, and has neither a zero- nor a
pi-quasienergy crossing at the old corner.

## Scope and next gate

This is not yet a 3+1 Dirac walk.  The required next theorem embeds one or more
such reciprocal conditional-shift blocks into the live four-component symbol,
proves exact unitarity and preservation of the full Dirac first jet, and then
classifies every zero and pi root on the three-torus.  A one-corner fixture is
construction evidence, not alias removal.

## Naive 4x4 embedding negative control

A direct chirality-register embedding was tested externally:

```text
U_cand(q) = (S(e^{iqx}) S(e^{iqy}) S(e^{iqz}) tensor I_2)
            * diag(U_+(q), U_-(q)).
```

It preserves the origin and gaps all sixteen old cube-corner/body-center
fixtures in exact or high-precision arithmetic. It nevertheless creates new
generic eigenvalue-one roots. For example, fixing approximately
`qx=-0.6896178996`, `qy=1.7623568545`, the smallest singular value of
`U_cand-I` falls below `6e-9` near `qz=1.4559461581`, while the determinant
changes sign across that point. This is consistent with a codimension-one
eigenphase-zero sheet after the naive embedding loses the spectral pairing that
made Weyl crossings isolated.

Therefore the next 4x4 embedding must preserve an explicit particle-hole,
chiral, symplectic, or paired-characteristic-polynomial constraint. Gapping
the old sixteen points alone is not a global success criterion.

### Exact family-level sign obstruction

Parameterize the rational rotation coin by

```text
c = (1-r^2)/(1+r^2),   s = 2r/(1+r^2).
```

For the same naive 4x4 embedding, SymPy factors the zero-quasienergy
determinant at the mixed-sign body center `(pi/2,pi/2,-pi/2)` as

```text
-256 r^4 (r-1)^4 (r+1)^4
 * (r^2-2r-1)^8 (r^2+2r-1)^8 / (r^2+1)^24,
```

while at the cube corner `(pi,0,0)` it is

```text
16 (r^2-2r-1)^4 (r^2+2r-1)^4 / (r^2+1)^8.
```

The exact-arithmetic hostile audit `RECIPROCAL_FAMILY_SIGN_AUDIT_REPORT.md`
reproduces both formulas and gives the combined exceptional set

```text
{0, +-1, +-(sqrt(2)-1), +-(sqrt(2)+1)}.
```

Outside that set the first displayed value is strictly negative and the second
strictly positive.  That endpoint calculation is not, by itself, a no-go for
the whole family.  Three hypotheses are load-bearing:

1. the live Dirac blocks `U_+(q)` and `U_-(q)` must be defined explicitly in a
   fixed band/chirality register convention;
2. along the chosen path one must prove
   `det U_+(q) * det U_-(q) = 1`, which makes `det(U_cand(q)-I)` real and hence
   permits a real intermediate-value argument;
3. the path must avoid the origin if the forced root is to be distinct from the
   intended origin crossing.

Under those hypotheses, any explicit origin-avoiding path from the mixed-sign
body center to the cube corner forces an additional zero-quasienergy root.
Without them, the formulas remain exact external-oracle endpoint data rather
than a family-level no-go.  In particular, the reciprocal primitive itself has
determinant one; the endpoint sign is carried by the as-yet-unpinned `U_+` and
`U_-` blocks.  The audit also found a documentation mismatch over whether the
reciprocal word acts on the band or chirality register, which must be resolved
before formalizing the capstone.

Prepared target:
`AgentTasks/aristotle-targets/codex_24h_b_reciprocal_conditional_shift_regulator.lean`.
