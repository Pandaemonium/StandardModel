# Aristotle target: finite differences for a discrete adiabatic schedule

Run this first:

`lake env lean DiscreteAdiabaticFiniteDifferences.lean`

Fill every proof placeholder without changing theorem statements. Small helper
lemmas are welcome. Use Mathlib's vector-valued mean-value theorems, especially
the `Convex.norm_image_sub_le_of_norm_hasDerivWithin_le` family.

For `second_difference_bound`, set

```text
g(x) = W(x + h) - W(x).
```

Its derivative is `W1(x + h) - W1(x)`. First bound that derivative by
`C2 * h` using the mean-value theorem on `W1`, then apply the mean-value theorem
to `g` over a step of length `h`. Keep the exact coefficient `1`; do not weaken
the conclusion to `2 * C2 * h^2`.

The sampled theorem should instantiate the first two results at
`h = 1 / T` and normalize the arithmetic. The scientific role is narrow: this
proves the finite-difference hypotheses used by a discrete-time adiabatic
theorem. It does not prove a gap or adiabatic transport by itself.
