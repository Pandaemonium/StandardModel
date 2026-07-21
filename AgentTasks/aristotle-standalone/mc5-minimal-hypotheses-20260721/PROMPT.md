# Lemma job: which MC5 hypotheses are actually independent?

Mathlib-only, abstract. A parallel analysis of a many-step ladder found that 3 of 6
bundled hypotheses were DERIVABLE, shrinking the integrator's obligation from six to
three. Do the same for the four-component L2 lift.

Bundle the MC5-style hypotheses for the composite
`f |-> U . (componentwiseLift S f)` on `E`-valued lattice data:
- `hS` : `S` has scalar bound `K`;
- `hcw` : `S` acts componentwise (commutes with every coordinate embedding);
- `hU` : `U` is a FIXED linear isometry on the `E` index;
- `hmeas` : the relevant a.e.-strong measurability hypotheses;
- `hK` : `0 <= K`.
Prove the composite bound `<= K` from the bundle, then determine for EACH field
whether it is independent or derivable:
1. Is `hK` derivable from `hS` (specialize at a nonzero input)?
2. Is `hcw` genuinely needed, or does `hS` alone suffice? (Prior work says a mixing
   operator breaks it - confirm with a counterexample and state it as independence.)
3. Is `hU` needed, or does boundedness of `U` suffice with a worse constant? Prove the
   sharp version: with `||U|| <= 1` the bound is `K`; with general bounded `U` it is
   `||U|| * K` - so isometry is needed only for the CONSTANT to be exactly `K`.
4. Is any part of `hmeas` derivable from the others?
Report the MINIMAL independent set. No new axioms/native_decide; standard axioms.
