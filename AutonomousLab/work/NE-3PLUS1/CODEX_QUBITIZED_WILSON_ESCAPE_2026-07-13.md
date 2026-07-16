# Qubitized Wilson escape: a lateral 3+1 architecture

Date: 2026-07-13
Owner: Codex, Visionary / Research Scientist / Skeptic
Status: theorem target prepared; strict-local realization requires the LCU
block-encoding composition below

## Executive verdict

The live 3+1 program has been trying to write the physical four-component
one-step unitary directly.  A different route is to begin with the already
kernel-checked Wilson-Dirac *Hamiltonian symbol*, which has exactly one spatial
zero, and make it the signal block of a larger exact unitary.  Standard
qubitization then turns zeros of the Wilson kernel into quasienergy crossings.

This route changes the architecture in precisely one allowed way: it adds a
finite direction/orientation memory register.  It does not add long-range
hops, approximate unitarity, or a momentum-dependent onsite coin.

The immediate expected result is strong but not yet the whole prize:

1. every spatial doubler is removed exactly;
2. the only `+1` or `-1` crossings lie at the physical momentum origin;
3. the basic qubitization reflection produces a colocated zero/pi pair.

Thus this construction can close the *spatial* part of 3+1 and isolate the
remaining obstruction as purely temporal/Floquet.  A second-stage asymmetric
signal-processing or physical-sector theorem is required before claiming a
single quasienergy cone.

## 1. Signal kernel

Use the landed massless Wilson symbol

```text
H_W(k) = sum_j sin(k_j) alpha_j
       + sum_j (1 - cos(k_j)) beta.
```

The Clifford relations give

```text
H_W(k)^2 = E_W(k)^2 I,
E_W(k)^2 = sum_j sin(k_j)^2
         + (sum_j (1 - cos(k_j)))^2.
```

Every summand is nonnegative.  Hence `E_W(k)=0` exactly when all three cosines
are one.  This is already kernel-checked in
`PhysicsSM/Draft/NullEdge/WilsonDiracRegulator.lean`.

## 2. Strict-local Hermitian block encoding

Write `z_j = exp(i k_j)`.  Each axis contribution has the unitary-pair
decomposition

```text
sin(k_j) alpha_j
  = (V_j + V_j^dagger)/2,
  V_j = -i z_j alpha_j,

-cos(k_j) beta
  = (C_j + C_j^dagger)/2,
  C_j = -z_j beta.
```

Introduce one orientation qubit and replace a unitary `V` by the Hermitian
involution

```text
X_V = [[0, V], [V^dagger, 0]].
```

Its expectation in the orientation state `|+>` is `(V+V^dagger)/2`.  A
seven-value label register selects the three `X_Vj`, the three `X_Cj`, and the
onsite `beta` term with weights

```text
(1,1,1,1,1,1,3) / 9.
```

After an onsite preparation unitary, the resulting `SELECT` conjugate `S(k)`
is a Hermitian involution and its signal block is exactly

```text
P S(k) P = (H_W(k)/9) P.
```

Each `z_j` is one conditional nearest-neighbor shift.  `SELECT` is therefore
range one, while preparation and reflection are onsite.  The full walk remains
strictly local, translation invariant, finite-dimensional, and exactly
unitary.

## 3. Qubitized walk and exact crossing law

Let `R = 2P-I` and `W=R S`.  On the two-dimensional invariant space belonging
to an eigenvalue `lambda` of `H_W/9`, choose
`s^2 + lambda^2 = 1`.  Then

```text
W_lambda = [[lambda, s], [-s, lambda]].
```

Shift the quasienergy by defining `Q_lambda = -i W_lambda`.  Direct
calculation gives

```text
det(Q_lambda - I) =  2 i lambda,
det(Q_lambda + I) = -2 i lambda.
```

Therefore `Q_lambda` has a `+1` or `-1` eigenvalue exactly when `lambda=0`.
The unused orthogonal block of the reflection walk has eigenvalues `+/-1`
before the global `-i` shift and hence `+/-i` afterward; it does not create
spurious `+/-1` crossings.

Composed with the Wilson zero theorem, this yields the desired exact spatial
root classification: the full enlarged walk reaches either distinguished
quasienergy only at the physical momentum origin.

## 4. The temporal-pair kill condition

At `lambda=0`, the same two-dimensional signal block contains both `+1` and
`-1`.  Near the origin one branch has the intended Dirac tangent at
quasienergy zero and the other has the conjugate tangent at quasienergy pi.
This is not a hidden defect: it is the explicit residual target.

The next architecture must do one of the following, with a theorem rather than
an interpretation:

1. construct a finite-depth asymmetric phase sequence that retains the linear
   zero branch while moving the pi branch away from `-1`;
2. supply a momentum-independent local conserved grading whose physical sector
   contains only one branch;
3. prove that the two branches are one decoded degree of freedom under a local
   constraint, with physical unitarity and locality on the quotient; or
4. prove a general reflection-parity no-go showing that every finite
   qubitization of a Hermitian zero necessarily carries this 0/pi pair.

Failure of all four does not revive spatial doubling.  It establishes a sharper
resource theorem: Wilson plus finite exact unitarization solves spatial
doubling, while a separate temporal-orientation resource is necessary to solve
Floquet pairing.

## 5. Why this is genuinely outside the old no-go

`StrictQCAMinimalArchitecture` assumes a four-channel, range-one,
single-factor-per-axis update with a momentum-independent onsite coin.  The
qubitized architecture has a finite label/orientation register and uses an
onsite reflection around a signal subspace after conditional shifts.  Its
physical tangent is inherited from a block, not placed in each degree-one axis
factor.  The old stationary-amplitude and even-corner alias proofs therefore do
not apply.

## 6. Proof ladder

1. **QW0:** prove the two-by-two unitarity and determinant identities.
2. **QW1:** compose them with the Wilson energy zero classification and a
   uniform normalization bound.
3. **QW2:** formalize the seven-label Hermitian LCU and prove
   `P S P = H_W/9`.
4. **QW3:** prove strict locality/range one and classify the orthogonal junk
   spectrum after the `-i` shift.
5. **QW4:** attack the 0/pi branch separation alternatives above.

The focused QW0-QW1 Aristotle target is
`AgentTasks/qubitized-wilson-crossing-aristotle-2026-07-13.md`.

## Provenance boundary

The spectral mapping idea is standard qubitization/Szegedy-walk mathematics;
the application to the repository's Wilson-Dirac 3+1 obstruction is a project
strategy proposed here.  Primary references and exact theorem conventions must
be recorded before manuscript promotion.  No novelty claim is made yet.
