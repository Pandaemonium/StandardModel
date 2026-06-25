# Claude call: 2026-06-24 round 001 adversarial next job retry

## Metadata

- Model/tool: `claude -p --bare --tools "" --model sonnet`
- Role in loop: adversarial critique
- Status: completed
- Usefulness rating: pending

## Query

```text
Adversarial review, concise. Null-edge Lean loop. Latest wins: exact sources
vanish against closed tests; screen noise has screen/volume bound; additive
diamond curvature matches multiplicative holonomy defect. Proposed next job:
prove closed-test source response factors through quotient by exact sources, is
stable under exact perturbations, and can be paired with harmonic/screen
projection as the finite P9 source-visibility observable. Is this the right next
Aristotle proof? Name the main risk and one proof job to avoid.
```

## Response

```text
Verdict: Mostly right, but pitched one notch too high. The
factoring-through-quotient step is essentially a corollary of "exact sources
vanish against closed tests" plus linearity - worth ~1/2 a proof, not a full
Aristotle. The content lives in (a) the finite-dimensionality of the pairing and
(b) the compatibility of screen projection with the harmonic representative. Do
those, and skip the trivial repackaging.

Main risk: smuggling finiteness. "Finite P9 source-visibility observable"
presumes the closed/exact quotient is finite-rank (or that the pairing has
finite operator norm on your screen-bounded class). On a non-compact null edge
with the screen/volume bound you just got, this is plausible but not automatic;
if you state it as a definition you'll discover later that your only examples
are the trivial ones. Make finiteness a hypothesis with a witness, or prove it
as a lemma keyed to the screen/volume bound - don't bury it.

Secondary risk: the harmonic projector depends on an inner product you haven't
canonicalized; "harmonic = screen" is a gauge-fixing claim, not a theorem.

One proof job to avoid: Do not try to prove screen-projection equals
harmonic-projection as an identity. They generically differ off the kernel.
Prove a bound (screen - harmonic is controlled by the same screen/volume
constant) and pair on the quotient via either; equality is a trap that will burn
a week and force a metric choice you don't want to commit to yet.

Order I'd run: (1) finiteness lemma from screen/volume, (2) quotient factoring
as a 3-line corollary, (3) stability under exact perturbation (also a corollary),
(4) screen-harmonic bound, (5) define the P9 observable.
```
