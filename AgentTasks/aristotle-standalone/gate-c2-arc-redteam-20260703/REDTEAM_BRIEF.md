# Gate C2 arc: adversarial faithfulness red-team

You (Aristotle) are a co-equal red-team partner. This is an ADVERSARIAL REVIEW
request, not a proof request. Your job is to find overclaiming, hidden
assumptions, semantic mismatches between the intended math and the kernel-checked
Lean statements, and any place a docstring claim outruns what is actually proved.
Assume you are blind to the wider repo; all context is here and in the 8 attached
Lean files (they compile under Lean 4 `v4.28.0` + Mathlib, draft-trust, all with
axiom footprint `[propext, Classical.choice, Quot.sound]`).

## What the arc claims

A finite, kernel-checked "Gate C2" layer for a lattice overlap / Ginsparg-Wilson
chiral index. The overlap Dirac matrix is `Dov gamma5 eps = 1 + gamma5 * eps`
(`OverlapGinspargWilson`), and the lattice chiral index is
`overlapIndex gamma5 eps = trace(Luscher modified chirality) = (1/2)(Tr gamma5 -
Tr eps)` (`OverlapIndexToy`). The six new files:

1. `OverlapIndexIntegrality.overlapIndex_isInteger`: for ANY involutions
   `gamma5, eps` (`M*M=1`), `overlapIndex` is an integer - it equals
   `Tr(specProj gamma5) - Tr(specProj eps)`, a difference of eigenprojector ranks
   (trace-of-idempotent = `finrank` of range via `LinearMap.IsProj.trace` +
   `Matrix.trace_toLin'_eq`). Needs only the involution property, not Hermiticity.
2. `TetraFreeIndexZero.tetraFreeOverlapIndex_eq_zero` and
   `tetraOverlapIndex_isInteger`: for the concrete free tetrahedral sign symbol,
   the index is a certified integer, and it is 0 under traceless chirality.
3. `OverlapIndexWindingWitness.overlapIndex_gamma5WQ_epsWQ_eq`: a block-stacked
   graded involution family with `overlapIndex = Q` for any winding charge `Q`
   (unit: 2-site Wilson line `gamma5 = 1(x)sigma3` on `Fin 4`, one-site signature
   defect). Docstring caveat: `eps` is CONSTRUCTED with the target signature, not
   derived as `sign(H_U)`.
4. `OverlapSignCertificate.certifiedSign_unique`: for a gapped (invertible)
   Hermitian `H`, a self-adjoint involution `eps` with `[eps,H]=0` and `eps*H`
   positive semidefinite is UNIQUE (the finite positivity-certificate
   characterization of `sign(H)`). Docstring claims this pins `sign(H)` WITHOUT a
   functional calculus. Proof: `(eps*H)^2 = H^2` and `eps*H` PSD, so `eps*H` is the
   unique PSD square root of `H^2` (Mathlib `Matrix.PosSemidef.sqrt_eq_iff_eq_sq`);
   `H` invertible cancels.
5. `OverlapWindingSignJoin.signCertificate_HU_epsW` / `signCertificate_HU_unique`:
   the winding `epsW` is a certified sign of an explicit gapped diagonal
   mass-defect operator `HU = diag(-2,-3,-1,5)`, and every certified sign of `HU`
   equals `epsW`. Docstring caveat: `HU` is diagonal (domain wall), not a
   hopping/link operator with gauge holonomy.
6. `OverlapIndexGaugeInvariance.overlapIndex_conj` / `SignCertificate.conj`: the
   index is invariant under unitary conjugation, and the certificate transports
   covariantly - the guardrail that a nonzero index cannot come from a gauge/basis
   conjugation, only a signature change.

## Adversarial questions (be skeptical and specific)

For EACH, answer FAITHFUL / OVERCLAIM / MISMATCH and justify from the Lean source:

1. **`certifiedSign_unique` "no functional calculus" claim.** The STATEMENT uses
   only involution + commutation + `Matrix.PosSemidef`. Is the claim "this pins
   `sign(H)` without functional calculus" honest, or does `PosSemidef` / the
   Loewner order secretly smuggle in spectral/functional-calculus content? Is the
   theorem's HYPOTHESES-to-conclusion content genuinely elementary, even though the
   PROOF invokes Mathlib's CFC-based PSD sqrt? Would a physicist accept this as a
   functional-calculus-free characterization of the overlap sign?

2. **Winding witness + join: genuine index or sleight-of-hand?** In (3) the `eps`
   is built with the target signature, and in (5) `HU` is diagonal. Is the caveat
   sufficient, or does the phrase "realizes every winding charge" / "genuine
   sign-of-operator index" overclaim? Concretely: does the diagonal `HU` join
   actually demonstrate anything beyond "a diagonal sign matrix is the sign of a
   diagonal matrix", given gauge invariance (6) says conjugation cannot change the
   index? Is the domain-wall framing legitimate, or is it circular?

3. **Integrality faithfulness.** Is `overlapIndex_isInteger` genuinely the
   statement that the index is an integer, and is the `Tr(idempotent) = finrank`
   step correctly applied (no off-by-one, correct field char-0 usage)?

4. **Is `overlapIndex` itself the right object?** Check against
   `OverlapIndexToy.overlapIndex_eq`: is `(1/2)(Tr gamma5 - Tr eps)` the correct
   Luscher/HLN lattice index, and does the whole arc silently assume traceless
   chirality anywhere it should not?

5. **Gauge invariance notion.** Is unitary conjugation the correct notion of a
   "gauge transformation" here, and does `SignCertificate.conj` correctly require
   `Uᴴ U = 1` (is `U Uᴴ = 1` used and is the finite-square-matrix inference sound)?

6. **The biggest gap.** State the single most important thing the arc does NOT
   prove but a reader might wrongly assume it does. (We believe it is: no genuine
   gauge-flux/holonomy operator is exhibited - only a mass defect - and no anomaly/
   index-density. Confirm or correct.)

## Output format

For each of the 6 questions: a verdict (FAITHFUL / OVERCLAIM / MISMATCH) and a
2-4 sentence justification citing the specific Lean declaration. Then a short
prioritized list of docstring/statement fixes (if any) to remove overclaiming.
Be as adversarial as the C1 GW-release red-team was - if a caveat is inadequate,
say exactly which word overclaims and what it should say instead.
