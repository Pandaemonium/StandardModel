# Reed-Muller and Barnes-Wall Bridge

This document keeps the code/lattice connection honest.  The current evidence
is a Reed-Muller parity geometry, not yet a Barnes-Wall lattice construction.

## Reed-Muller Core

`RM(2,4)` is the binary length-16 code obtained by evaluating Boolean
polynomials of degree at most 2 on `F_2^4`.

The proposed sedenion-derived code is:

```text
C_ZD = { c in RM(2,4) : c_0 = 0 and c_8 = 0 }.
```

This is best described as a doubly shortened subcode while coordinates 0 and 8
remain present as forced zeros.  If those coordinates are removed, one obtains
a punctured length-14 version.

## Why Barnes-Wall Is Nearby

The Barnes-Wall family is classically connected to Reed-Muller and Kerdock-type
structures.  The low-dimensional sequence includes:

```text
Z^2, D_4, E_8, Lambda_16, ...
```

and the 16-dimensional Barnes-Wall lattice is part of the same coding/lattice
ecosystem as `RM(2,4)`.

Thus the honest pipeline is:

```text
sedenion zero-divisor supports
  -> doubly shortened RM(2,4) parity geometry
  -> signed / Z_4 / quadratic refinement
  -> Barnes-Wall-adjacent structure
```

## What Is Not Yet Proved

The following stronger pipeline is not yet justified:

```text
sedenion zero divisors -> explicit construction of Lambda_16.
```

To prove this, we would need an actual lattice construction:

1. specify a lattice from support and sign data;
2. compute or prove its Gram form;
3. prove evenness and determinant;
4. compare it with a standard Barnes-Wall model;
5. identify the relevant short vectors or stabilizer states.

Until this is done, the safe phrase is:

```text
Barnes-Wall parity shadow
```

not:

```text
Barnes-Wall construction.
```

## Candidate Lattice Experiments

### Experiment 1: Construction A from the Doubly Shortened Code

Build:

```text
Lambda(C_ZD) = { z in Z^16 : z mod 2 in C_ZD } / scale.
```

Questions:

- Is the lattice even?
- What is its determinant?
- What is its minimum?
- Does puncturing forced-zero coordinates give a cleaner length-14 object?
- Does adding the missing coordinates/glue reconstruct a known 16-dimensional
  lattice?

### Experiment 2: Signed Construction

Use the Cayley-Dickson signs as extra glue data:

```text
C_ZD + phase refinement -> Z_4 code or Construction A/B/D variant.
```

Questions:

- Is the sign refinement a `Z_4` code under the Gray map?
- Does the resulting lattice land near Kerdock or Barnes-Wall data?
- Are the 168 primitive zero divisors visible as first-shell vectors, signed
  minimal vectors, or stabilizer states?

### Experiment 3: Compare to Known Barnes-Wall Bases

Use a concrete Barnes-Wall `Lambda_16` model and test:

- membership of signed plaquette vectors;
- orbit under the Clifford/Barnes-Wall automorphism group;
- whether the sedenion `S_3` action preserves the lattice.

## Paper-Level Claim Discipline

Allowed now:

```text
The sedenion support geometry appears to be a canonical subgeometry of
RM(2,4), and therefore lies adjacent to the Barnes-Wall/Reed-Muller ecosystem.
```

Not allowed yet:

```text
The sedenions construct Lambda_16.
```
