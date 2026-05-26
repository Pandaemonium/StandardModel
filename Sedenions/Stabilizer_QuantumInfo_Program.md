# Stabilizer and Quantum-Information Program

The quantum-information direction should start with stabilizer states, not
stabilizer codes.

## Key Distinction

The binary code `C_ZD` is not automatically a quantum stabilizer code.  A
stabilizer code requires:

- a symplectic binary Pauli space;
- commuting Pauli checks;
- a codespace;
- logical operators;
- parameters `[[n,k,d]]`.

The more plausible immediate object is:

```text
signed affine 2-plane -> 4-sparse quadratic-phase state -> stabilizer state.
```

## Plaquette State Ansatz

For each signed affine plane `(P, alpha)`, define:

```text
|psi_P> = (1/2) sum_{x in P} alpha_x |x>,
```

where:

```text
P subset F_2^4,   |P| = 4,
alpha_x in {+1,-1,+i,-i}.
```

Stabilizer states admit descriptions as quadratic-phase sums over affine
subspaces.  Therefore the immediate test is concrete:

```text
Is alpha_x a quadratic phase on P?
```

If yes, `|psi_P>` is a 4-qubit stabilizer state.

## Computations to Run

### 1. Stabilizer Recognition

For each signed plaquette:

1. form the complex vector in `C^16`;
2. enumerate Pauli operators on 4 qubits;
3. find the subgroup fixing the vector;
4. check whether the stabilizer has size `2^4`.

Output:

```text
plaquette_id
support
phase_vector
stabilizer_generators
is_stabilizer
```

### 2. Orbit Decomposition

Compare the plaquette set to the full 4-qubit stabilizer-state set.

Questions:

- Is the sedenion plaquette set a single Clifford orbit?
- Is it a union of smaller orbits?
- What invariants distinguish it?

### 3. CSS Code Failure Check

Test the tempting CSS constructions explicitly:

```text
C_X = C_ZD
C_Z = C_ZD^perp
```

and punctured/shortened variants.  Verify the symplectic commutation condition
before calling anything a stabilizer code.

Expected warning from current notes:

```text
C_ZD itself is probably not a dual-containing CSS code.
```

### 4. Psi-Orbit Magic Test

Represent the order-three sedenion `S_3` automorphism `psi` as a matrix on
`C^16` or `R^16`.  For each stabilizer plaquette:

```text
|phi> = psi |psi_P>.
```

Then test:

- Is `|phi>` still a stabilizer state?
- If not, what is its stabilizer fidelity?
- What is its stabilizer rank for small examples?
- What is its Barnes-Wall norm or related magic monotone?

## Possible Outcomes

### Case 1: `psi` is Clifford-like

The sedenion family symmetry preserves the stabilizer scaffold.  The physics
interpretation is "generation symmetry as Clifford/Barnes-Wall symmetry."

### Case 2: `psi` is lattice-preserving but not stabilizer-preserving

This suggests a basis mismatch or a more subtle Barnes-Wall representation.

### Case 3: `psi` generates magic

This is the most exciting quantum-information outcome:

```text
sedenion S_3 family symmetry = finite non-Clifford deformation of a
Reed-Muller/Barnes-Wall/stabilizer scaffold.
```

This case would connect naturally to modern Barnes-Wall magic monotones.
