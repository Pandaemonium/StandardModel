Project name: gate-c1-gamma-free-sign-stability-c201

You are Aristotle, working on the StandardModel Lean/null-edge research project.

C193 proves a free reference margin:

```text
gamma_free = min(m0, 2 r_W - m0, 16 r_b - m0) > 0.
```

The next theorem needed for the C170/C181 homotopy budget is a stability lemma:
if every non-physical sector has shifted mass at least `gamma_free` and the
physical sector is at most `-gamma_free`, then any perturbation smaller than
`gamma_free` cannot flip the sign pattern.

Task:

1. State a clean abstract Lean theorem for sign-pattern stability over a finite
   sector type.
2. Include both scalar and operator-norm variants if feasible.
3. The scalar theorem should say:

```text
if m(phys) <= -gamma;
if m(s) >= gamma for all s != phys;
if |delta(s)| < gamma for all s;
then m(phys)+delta(phys) < 0 and m(s)+delta(s) > 0 for s != phys.
```

4. The operator theorem can be stated as a certificate interface if a full proof
   is too heavy:

```text
if ||E|| < gamma and each sector block is isolated by margin gamma,
then no sector crosses zero along H_t = H_0 + t E.
```

5. Explain exactly how this consumes C193 and feeds the kappa/alpha/beta
   homotopy budget.

Success criteria:

```text
The scalar theorem should be Lean-provable with Mathlib.
The operator theorem should be precise enough to hand off to a future proof job.
No full GateC1_NU claim.
```

Please finish with:

```text
Lean scalar theorem:
Proof:
Operator certificate theorem:
How it consumes gamma_free:
Failure modes:
```
