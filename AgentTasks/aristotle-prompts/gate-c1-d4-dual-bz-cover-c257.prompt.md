Gate C1 C257: D4 dual lattice and Brillouin torus cover theorem

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

C250/Pro corrected the D4 momentum-torus statement:

```text
T_D4 -> T_LH is an 8-fold cover/unfolding.
```

The D4 momentum torus covers the tetrahedral momentum torus; the tetrahedral
torus is the folded quotient. This matters because the active C240/C244
branch theorem is on `L_H`, not full D4.

Definitions:

```text
L_H = H Z^4,
H^2 = 4 I,
L_H^* = (1/4) L_H,
D4 = {x in Z^4 : sum_i x_i is even},
D4^* subset L_H^*,
[L_H^* : D4^*] = 8.
```

Task:

Formalize the cleanest Lean version of the dual/cover statement.

Priority targets:

```text
1. Prove H^{-1} = (1/4)H over Q or R.
2. Derive L_H^* = (1/4)L_H in a Lean-friendly representation.
3. State/prove dual inclusion reversal: L_H subset D4 implies D4^* subset L_H^*.
4. Formalize the finite cover direction:
     Hom(D4,U(1)) -> Hom(L_H,U(1))
   has kernel Hom(D4/L_H,U(1)).
5. If quotient APIs are too heavy, return a precise theorem skeleton and the
   finite group facts needed from C256.
```

Main semantic correction to preserve:

```text
Do not say "D4 torus folds to L_H" ambiguously.
Say:
  T_D4 covers/unfolds T_LH by degree 8;
  T_LH is the quotient/folded torus.
```

Constraints:

```text
This is a D4 side lane.
Do not change the active L_H scalar-Wilson proof.
Do not run a full lake build.
Do not claim GateC1_NU.
```

Requested output:

```text
1. Lean theorem statements/proofs if feasible.
2. Exact mathematical formulation if Lean quotient APIs block completion.
3. Recommended integration target.
4. Any warning about conventions.
```
