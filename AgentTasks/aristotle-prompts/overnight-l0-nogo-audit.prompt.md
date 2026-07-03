# Aristotle strategy/audit job: L0.1 Lorentz-ensemble no-go argument

You are acting as an adversarial mathematical auditor and proof-strategy
partner, not as a Lean prover. Do NOT attempt a Lean build. Read the attached
argument and return a written report.

## Standalone context (assume you are blind to the repository)

The "null-edge" research program models spacetime as a locally finite,
directed, acyclic causal graph whose edges carry null (lightlike) transport
data. A regular tetrahedral crystal has been used as a computational
regulator, but a preferred crystal frame threatens Lorentz invariance. The
program therefore needs to know whether ANY nontrivial ensemble of
finite-valency null-direction graphs can be Lorentz-invariant in
distribution. The conjectured answer is NO (a self-imposed no-go, "Gate
L0.1"), which would force the ontology to use the link structure of a
Poisson sprinkling instead (infinite valency), mitigated by damped
Benincasa-Dowker-type kernels.

Signature convention: mostly-minus, `+t^2 - x^2`. The relevant symmetry group
is the proper orthochronous Lorentz group, acting on the celestial sphere
`CP^1` by Mobius transformations `PSL(2,C)`.

## The argument under audit (attached file: gate-l0-plan.md)

The attached markdown states the proposed no-go L0.1 and its intended proof
strategy (equivariant measurable map from a Poisson sprinkling into finite
subsets of `CP^1`; no `SL(2,C)`-invariant probability measure on `CP^1`
because the action is noncompact with no invariant mean; upgrade of the
Bombelli-Henson-Sorkin "no equivariant direction field" theorem from a single
direction to a finite direction set). It also states two companion claims,
L0.2 (link relation is exactly Lorentz-invariant, asymptotically null) and
L0.3 (Benincasa-Dowker damped kernels make infinite valency usable).

## Deliverable

Return a report named `GateL0_NoGo_Audit.md` answering:

1. Is the L0.1 proof strategy sound? Identify every gap, hidden assumption,
   or step that silently uses per-realization (rather than distributional)
   equivariance.
2. State the cleanest precise hypotheses under which L0.1 is TRUE. In
   particular, make the "marginalization to a single point's direction set"
   step and the "stabilizer of a finite subset of `CP^1` is virtually
   compact / admits no invariant mean" step rigorous, or show why they fail.
3. Is there a counterexample? Could a clever nontrivial finite-valency
   ensemble evade the argument (e.g. via randomization, a non-measurable
   selection, or a distribution that is invariant without an equivariant
   selection map)? If so, exhibit its shape.
4. What is the exact Bombelli-Henson-Sorkin statement being invoked, and does
   the finite-set upgrade actually follow from it or need a new argument?
5. Recommend the single most efficient rigorous route to either prove L0.1 or
   refute it, and say whether any sub-lemma is finite/discrete enough to be a
   Lean formalization target.

## Rules

- ASCII only in the returned report; use spaced forms `s o r r y` /
  `a d m i t` if you must mention Lean placeholder tokens in prose.
- Do not claim the no-go is proved; the job is to audit and sharpen.
- Be adversarial: the most valuable output is a real hole or a real
  counterexample, not reassurance.
