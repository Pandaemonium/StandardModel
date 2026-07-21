# Adversarial docstring audit, wave 2: the remaining brick claims

Mathlib-only adversarial audit. A first wave audited five prose claims from a set of
support bricks and found ALL FIVE overclaimed relative to their statements. Audit the
REMAINING claims with the same severity. For each: SOUND or PROSE-OUTRUNS-STATEMENT,
with a Mathlib witness for the latter.

Claims:
1. "the coin closed form holds unconditionally in the mass" - it is stated under
   `M^2 = m^2 . 1`, `0 <= m`, and `(m = 0 -> M = 0)`. Is 'unconditionally' fair, or
   does the third hypothesis do real work? (A prior job showed square-zero alone
   fails.) Verdict on the PROSE.
2. "telescoping gives ||U^n - V^n|| <= n ||U - V|| for unitaries" - does this need
   unitarity, or only that both have norm <= 1 (contractions)? If contractions
   suffice, the prose naming unitarity is stronger than needed - say so.
3. "the sharp commutator bound reproduces zero for commuting generators" - verify the
   bound's RHS really vanishes exactly when [A,B] = 0, and check whether the stated
   `0 <= eps` restriction is load-bearing (what happens for eps < 0?).
4. "uniformity on a mass ball" - is the sup over the ball actually ATTAINED/finite,
   or could the sup be infinite for a monotone-but-unbounded profile even on a
   BOUNDED ball? Check the hypothesis that makes the sup finite.
5. "the end-to-end claim is local-on-compact" - is 'local' being used consistently,
   i.e. does a family of compact-box statements with box-dependent constants actually
   assemble to anything on all of momentum space? State precisely what it does give.
Be adversarial, not charitable. No new axioms/native_decide; standard axioms.
