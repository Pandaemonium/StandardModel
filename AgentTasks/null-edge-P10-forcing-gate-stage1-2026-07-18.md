# P10 stage 1: the `H_forcing` gate - what exactly does the causal substrate hand the fiber?

Date: 2026-07-18. Plan: P10 stage 1
(`Sources/Null_Edge_Ten_Priorities_Research_Plan_2026-07-18.md`). Status:
DESIGN / pre-registration - no theorem claimed. Purpose: display the EXACT
hypothesis under which "null-edge substrate forces the division-algebra menu"
would be a theorem, so stage 2 attacks a precise statement (or finds its
counterexample model). Requested reviewer: codex (hostile), per the plan's
stage-gate.

## The chain being gated

```text
null-edge substrate + [H_forcing]
  ==> the fiber carries a finite-dim unital R-algebra with a multiplicative,
      positive-definite norm                      (stage 2 - the new content)
  ==> fiber in {R, C, H, O}                       (P6 Hurwitz, in flight: J2)
  ==> spacetime factor C(x)H in 3+1               (landed DivisionDimensionSelection)
      + internal factor maximal composition = O   (selector to be formalized)
```

Landed inputs (kernel): mass = Plucker area, Lorentz-invariant, = SL(2,C)
soldering determinant coordinate (`NullEdgeSpinorSolderingAristotle` +
`NullEdgeSolderingPluckerBridge`); the item-5 CONSTRAINT row (mass-area behaves
as a multiplicative norm - recorded as a constraint, NOT yet derived);
`DivisionDimensionSelection` (C uniquely selected -> d = 4);
P2's `DixonDiracGamma` (the C(x)H Clifford/signature layer now kernel-real).

## Candidate `H_forcing` hypotheses (displayed exactly)

### H1 (determinant-action form - the preferred candidate)

> The fiber of the null-edge bundle is a finite-dimensional real vector space
> `A` with a distinguished unit process `1`, such that (i) edge concatenation
> induces a bilinear product `A x A -> A` with `1` neutral; (ii) the physical
> mass functional on fiber elements is the SOLDERING DETERMINANT of the induced
> action on the spinor space (the landed Plucker-area functional); and (iii)
> concatenation of independent processes multiplies the soldered action
> (functoriality of soldering).

Under H1, multiplicativity of the norm is NOT an axiom - it is inherited from
`det(M N) = det M det N` through (ii)+(iii). The genuinely new stage-2 theorem
is: **(ii)+(iii) + positive-definiteness of the mass functional make
`(A, product, N)` a composition algebra** - then Hurwitz closes the menu.
The honest exposure: (iii) is where the physics lives. If soldering
functoriality itself smuggles associativity or the algebra structure, H1 is
circular; the stage-2 work must formalize (iii) from the null-edge
concatenation data (the `sum_a c(alpha^a) nabla_ell_a` architecture), not
assume it.

### H2 (abstract composition form - the fallback)

> The fiber carries a positive-definite quadratic mass functional `N` with
> `N(1) = 1` and `N(x . y) = N(x) N(y)` for the concatenation product.

H2 makes stage 2 trivial (it IS the composition axiom) and pushes all content
into justifying H2 causally. Registered only as the comparison point: if
stage 2 under H1 fails, the distance between H1 and H2 measures exactly what
the causal substrate does NOT supply - that gap statement is the mapped
impossibility deliverable.

## Stage-2 statement shape (to be formalized only after this gate passes review)

```text
theorem forcing_stage2
  (A soldered-action data per H1(i)-(iii), N := soldering det, N pos-def) :
  IsCompositionForm N   -- the J2/P6 structure, over the fiber product
```

with the composition-algebra structure literally the one in the J2 Hurwitz
package (`IsCompositionForm`), so P6's toolkit and dimension ladder apply
verbatim downstream.

## Counterexample-model obligations (the impossibility branch, pre-registered)

- M1 (against H1-necessity): a finite null-edge model where a mass functional
  is positive and Lorentz-covariant but NOT any soldering determinant - shows
  (ii) is a real hypothesis, not free.
- M2 (against stage-2 without (iii)): a model satisfying (i)+(ii) where
  concatenation fails functoriality and `N` is NOT multiplicative - locates
  the load-bearing hypothesis.
- If stage 2 FAILS under full H1: the minimal repair axiom is the deliverable
  (proved minimal by exhibiting models with and without it). That outcome is a
  mapped frontier, not a failure.

## Kill conditions

- If (iii) cannot be stated without importing the algebra structure it is
  meant to force, H1 is circular: record, fall back to the H1-H2 gap
  statement.
- No silent weakening: any change to H1's clauses goes back through hostile
  review before a stage-2 attempt.

## Why this is the right gate (fit to landed results)

The landed soldering capstone already proves the MASS = determinant-coordinate
half of (ii) for the spacetime factor; P2's gamma layer gives the Clifford
action it solders into; the item-5 constraint row is exactly stage-2's
conclusion asserted-not-derived. So H1 is not invented - it is the displayed
form of what the program already half-possesses, with (iii) isolated as the
one genuinely open physical clause.

## Requested review (codex, hostile)

1. Is H1(iii) stateable from null-edge concatenation data without circularity?
2. Is the internal-factor selector ("maximal composition algebra = O") an
   acceptable stage-4 selector, or does it need its own physical hypothesis?
3. Do M1/M2 as stated actually separate the hypotheses (non-vacuous
   controls)?
