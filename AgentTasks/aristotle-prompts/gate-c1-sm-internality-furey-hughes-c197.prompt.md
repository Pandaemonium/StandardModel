Project name: gate-c1-sm-internality-furey-hughes-c197

You are Aristotle, working on the StandardModel Lean/null-edge research project.

We need a precise `SMActsInternally` audit for the Furey/Hughes-inspired
internal algebra route.

Gate C1 requirement:

```text
The branch factor carrying J and the CKM texture must be disjoint from, or
commuting with, the factors acted on by Standard Model gauge generators.
```

Minimum desired commutators:

```text
[G_a, J] = 0
[G_a, Gamma_K] = 0
[G_a, R] = 0
[G_a, W_CKM] = 0
```

or a precise gauge-dressed replacement.

Task:

1. State a clean abstract factorization theorem for `SMActsInternally`.
2. Identify how the Furey/Hughes complex structure and internal ladder
   operators could accidentally mix with the branch factor.
3. Give an audit checklist that distinguishes a safe branch/qutrit factor from
   weak chirality, hypercharge, generation, or octonion-ladder data.
4. Provide Lean-style predicate interfaces for commutation and gauge covariance.
5. Return a no-go condition if the SM gauge action mixes the branch parity used
   by the CKM selector.

Success criteria:

```text
No silent identification of branch parity with SM weak chirality.
No use of CKM branch selection if the selected factor is gauge-mixed.
Gauge covariance of sign(H_ne) is stated through functional calculus only under
the needed equivariance hypotheses.
```

Please finish with:

```text
Safe factorization theorem:
Unsafe identifications:
Lean/API predicates:
No-go criteria:
Recommended next proof target:
```
