# Paper F manuscript architecture

## Working title

**Moduli and Selector Obstructions for Channel Decompositions in Finite
Krein--Dirac Carriers**

Alternative, more decisive no-go title:

**No Canonical Four-Channel Split from Retained Krein--Dirac Structure**

The first title is safer for a broad classification paper. The second is earned
only if every theorem is stated relative to the retained structure and never
widened to all possible physical or information selectors.

## Central claim

The displayed aperture/closure/turn/solder expansion of the chosen carrier
square is exact and exhaustive as an expansion, while the named four-way
decomposition is not canonical from chirality and Krein-adjoint type alone.
Chirality canonically isolates the odd soldering channel. The remaining
fixed-total even refinements form a zero-sum additive torsor with explicit
shears. A selector rigidifies that fibre exactly when it is injective on the
shift group, but the first natural candidates fail for distinct exact reasons:

- raw solder degree does not descend through the live representation kernel;
- componentwise trace is intrinsic but misses a nonzero trace-zero shear;
- every commutator-blind rational-linear scalar selector factors through trace;
- positive quadratic minimization is unique only after a metric is supplied,
  and distinct positive metrics choose distinct refinements;
- the live adjoint-induced form has complete signature `(4,2)`, so the retained
  Krein structure does not itself provide the required positive metric.

This is the theorem of the negative-classification paper. A derived physical or
information selector is a stronger successor, not a prerequisite for stating
the underdetermination result.

## Abstract draft

Dirac-type carrier squares often admit physically suggestive decompositions,
but an exact expansion need not determine a canonical interpretation of its
summands. We classify this ambiguity for a finite rational Krein--Dirac carrier
whose square is written in aperture, closure, turn, and soldering channels.
Chirality uniquely fixes the odd/even split, whereas the complete fixed-total
fibre of three even refinements is a zero-sum additive torsor with an explicit
faithful shear action. We prove a necessary-and-sufficient selector criterion,
an exact descent criterion through the carrier representation, and several
carrier-level obstructions. Raw word degree fails to descend because one
nonzero idempotent has representatives of different degree. Trace data leaves
a nonzero shear invisible, and every commutator-blind rational-linear scalar
functional is a trace multiple and hence noninjective. Positive quadratic
selection is unique for each supplied metric but changes when the metric
changes. Finally, the complete live even Krein-self-adjoint sector has signature
`(4,2)`, excluding the adjoint-induced form as a canonical positive metric. The
result separates three questions often conflated in operator decompositions:
exact expansion, uniqueness under declared selectors, and physical canonicity.

Final sentence supported by the landed disk theorem:

> Even after requiring a positive sector to contain all three named even
> channels, a rational open disk of positive complement choices remains.

## Section plan

1. **Exact expansion is not canonical decomposition**
   State the carrier square, convention lock, exact four-term expansion, and
   canonical chirality split. Lead with the distinction the paper resolves.

2. **Decomposition object and equivalence**
   Define the carrier datum, ordered fixed-total even refinement, admissible
   shift, carrier isomorphism, gauge/relabeling action, and selector-preserving
   equivalence. Do not use “moduli space” before this section is explicit.

3. **The complete type-only fibre**
   Present `ChannelRefinementTorsor` and `ChannelShearModuli`: free/transitive
   zero-sum translation, faithful rational shear subgroup, nonzero witness.

4. **What a selector must accomplish**
   Present `ChannelSelectorRigidity`, finite-valued obstruction, conditional
   joint-grading uniqueness, and `ChannelSelectorQuotient`. Emphasize that the
   generic quotient is infrastructure, not a physical quotient.

5. **Representation descent and the degree obstruction**
   Present the kernel-preservation iff theorem, then the live idempotent
   `P = c1*c1# = P^2` as the mixed-degree kill. Compare with universal free
   presentations where degree can remain meaningful.

6. **Intrinsic scalar data collapse to trace**
   Present the trace-profile shear witness and the full commutator
   classification. Scope every headline to rational-linear scalar selectors.

7. **Why positivity does not finish the selection**
   Present the weighted completion identity and exact metric-disagreement
   witness, then the live `(4,2)` Krein normal form, rational boost, and complete
   positive-complement disk as the concrete positive-sector moduli.

8. **Physical and information selectors still owed**
   State locality/support, dynamics, positive physical sector, resource
   monotonicity, and refinement/data-processing as explicit successor axioms.
   Explain how each would induce a quotient or be killed by the current tests.

9. **Discussion: what “four channels” can honestly mean**
   The four names are a useful rigid coordinate presentation once its selectors
   are supplied. They are not selected by the retained type data. Explain which
   further physics could make them natural and what result would falsify that
   hope.

## Mandatory theorem controls

- Every nonuniqueness theorem includes a nonzero zero-sum shift.
- Every descent no-go includes two distinct source representatives of the same
  nonzero represented operator.
- Every selector no-go names the selector class it excludes and a surviving
  class it does not exclude.
- Every positive result includes a strict nonzero witness and a zero/null
  boundary control.
- Every use of “unique,” “exhaustive,” or “canonical” names the retained
  structure and equivalence relation.

## Nearest-work confrontation

- Generalized Lichnerowicz/Weitzenbock and superconnection decompositions are
  established (Ackermann--Tolksdorf `hep-th/9503153`); this paper does not claim
  to invent decomposition of a Dirac square.
- Moduli of finite spectral triples and Dirac operators are established
  (Cacic `0902.2068`; Chamseddine--Connes--Marcolli `hep-th/0610241`), as are
  affine quotients of connections representing one Dirac operator (Tolksdorf
  `hep-th/9612149`). Distinguish those objects from refinements of one fixed
  carrier square.
- Gauge/isomorphism quotients for finite spectral triples and quiver
  representations are established (`1301.3480`, `2401.03705`). The Paper F
  equivalence relation should reuse that discipline without claiming the
  ambient quotient formalism as novel.
- Fundamental symmetries, maximal positive subspaces, and `O(p,q)` Grassmannian
  orbits are standard Krein geometry. Any rational boost/disk theorem is a
  carrier-specific exact realization composed with the selector no-gos.
- Resource-theory monotones and monotone metrics require their own positivity,
  transformation class, and data-processing hypotheses; they are references
  for successor selectors, not evidence that one is already derived here.

## Publication fork

**Negative classification:** target *Journal of Mathematical Physics* or
*Journal of Physics A* after the category/equivalence section, two inequivalent
live examples, one equivalence control, source comparison, complete guards, and
artifact freeze.

**Positive selection:** target a stronger venue only after a noncircular
physical selector and an information selector are derived on the same carriers
and their selected orbits are compared under a displayed stability or
data-processing law.

## Prohibited headline upgrades

- “The four physical channels are canonical.”
- “Positivity selects the decomposition.”
- “Trace/spectrum classifies all refinements.”
- “Commutator blindness captures every intrinsic selector.”
- “The rational positive-sector family is new Krein geometry.”
- “A supplied metric or named-channel span is physically derived.”
