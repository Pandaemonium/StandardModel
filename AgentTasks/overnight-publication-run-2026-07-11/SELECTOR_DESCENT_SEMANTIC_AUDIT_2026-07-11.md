# Selector-descent semantic audit

Aristotle project: `42092589-e223-45d8-a522-dadf651835ca`.

Verdict: **the theorem shape is correct, but it is an enabling quotient lemma,
not a carrier classification theorem**.

## Findings

- No fatal issue: `Q.comp eval = eval.comp P` has the correct orientation, and
  the `mapQ` side condition is exactly preservation of `ker eval`.
- Kernel preservation is necessary for every evaluation. Its sufficiency for
  an endomorphism on the whole codomain, and uniqueness of that endomorphism,
  use surjectivity. Without surjectivity, extension from `range eval` can fail
  over a general ring.
- The result is a specialization of the quotient universal property. It is a
  useful intrinsicality checker, but contains no carrier-specific selector,
  positivity, locality, edge exchange, or information monotonicity by itself.
- A killed relation `eval x = 0` with `eval (P x) != 0` is the exact
  presentation-dependence certificate.

## Safe interpretation

After proof completion, Paper F may say: along a surjective carrier evaluation,
a source selector induces a unique represented selector exactly when it
preserves the evaluation kernel. The theorem reduces intrinsicality to a check
on defining relations; it does not construct an intrinsic selector.

## Highest-value successor

Construct a source word module and surjective evaluation for the live carrier.
Define solder-degree parity without naming the four channels, prove every
defining relation is homogeneous so the evaluation kernel is preserved, and
obtain the descended selector. Then prove it commutes with chirality and has
the separated joint spectrum required by
`ChannelSelectorUniqueness.two_sign_gradings_decomposition_unique`.
