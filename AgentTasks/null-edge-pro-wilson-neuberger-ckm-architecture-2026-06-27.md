# Pro guidance: Wilson/Neuberger plus CKM texture architecture

Date: 2026-06-27

Purpose: preserve Pro's concrete recommendation for the first physical Gate C1
operator architecture.

## Verdict

Use:

```text
Wilson/Neuberger overlap reference
  with CKM texture inserted as an internal branch/flavor mass table,
  not as the primary spacetime doubler-resolution operator.
```

Do not use literal naive CKM as the first physical reference.

The architecture is:

```text
CKM table = finite branch/flavor mass texture.
Wilson/Neuberger = first physical doubler-resolved overlap reference.
Domain-wall = cross-check / fallback / inflow model.
Abstract block = scaffold for proving the homotopy.
```

## Reference kernel

Use:

```text
H_ref(U)
  =
  Gamma_ref [
      D_W^0(U) tensor I_CKM
      + I tensor W_CKM
      - m0 R_ref
  ],
```

where:

```text
W_CKM = r_b(15R_CKM - M_CKM).
```

First pass:

```text
R_CKM = I;
R_ref = I.
```

Then:

```text
D_ov,ref(U) = rho_ov [1 + Gamma_ref sign(H_ref(U))].
```

## Null-edge endpoint

Use:

```text
H_ne(U)
  =
  Gamma_K [
      D_ne^cov(U)
      + W_NE,space(U)
      + W_CKM^ne(U)
      - m0 R_ne(U)
  ].
```

Here `W_NE,space` is the null-edge implementation of the ordinary Wilson
spacetime doubler resolver, or else it is explicitly included inside `D_ne`.

## Combined mass window

Let:

```text
n = number of spacetime pi-components;
ell = CKM level;
w_0 = 0;
w_bad = 16 r_b.
```

Then:

```text
mu(n, ell) = 2 r_W n + w_ell - m0.
```

The clean sufficient window is:

```text
0 < m0 < min(2 r_W, 16 r_b).
```

with:

```text
gamma_free = min(m0, 2 r_W - m0, 16 r_b - m0).
```

## C170 constants

After transporting the reference into the null-edge frame:

```text
H_ref^S = S H_ref S^-1,
H_t = (1-t)H_ref^S + tH_ne.
```

Use:

```text
||H_ne - H_ref^S|| <= kappa + omega + rho + alpha + beta < gamma_ref.
```

Ideal first-pass values:

```text
omega = 0;
rho = 0;
beta = 0 in the flat/free branch frame;
alpha = 0 at U = 1;
kappa is the hard kinetic/Wilsonized null-edge mismatch.
```

## Main warning

CKM alone does not resolve spacetime doublers.

The safe kernel is:

```text
Wilson spacetime doubler resolver + CKM branch/flavor texture.
```

not:

```text
CKM texture alone as physical lattice operator.
```

## The null-edge claim

The actual claim must be:

```text
H_ne lies in the same gapped, sector-signature matched overlap component as the
CKM-decorated Wilson/Neuberger reference.
```

It is not enough to show that the imported reference works.
