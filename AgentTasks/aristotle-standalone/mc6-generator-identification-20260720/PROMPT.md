# Lemma job: Fourier multiplier <-> derivative generator identification (MC6 rung)

Mathlib-only, abstract. The last rung of a continuum ladder identifies a
Fourier-conjugated multiplier generator with a differential operator plus a constant
matrix term. Formalize the identification cleanly, and mark exactly what it is NOT.

On Schwartz functions `f : SchwartzMap (EuclideanSpace R (Fin d)) C` (scalar first;
vector-valued by componentwise extension), with Mathlib's Fourier transform and its
`2 * pi` convention, prove:
1. **Multiplier-derivative correspondence**: the Fourier transform intertwines
   partial differentiation with multiplication by the momentum coordinate, in the
   exact form Mathlib provides - state the constant and the `2 * pi` placement
   EXPLICITLY (do not paper over the convention).
2. **Constant-matrix term**: pointwise multiplication by a constant matrix commutes
   with the Fourier transform (it acts on the target, not the variable), so a mass
   term transfers unchanged.
3. **Combined generator**: conclude that the multiplier `q -> (sum_j alpha_j q_j + M)`
   corresponds to the operator `-i sum_j alpha_j partial_j + M` (or with whatever
   sign/constant the convention in (1) forces - report the ACTUAL constant you get,
   do not force the expected one).
4. **Anti-overclaim statement**: state explicitly, as a docstring remark, that this
   is an IDENTIFICATION OF GENERATORS on a dense domain, NOT a convergence theorem
   and NOT a statement about any discrete walk.
Success: (1)-(3) proved with the convention constants exactly as Mathlib gives them,
plus (4) recorded. If the constant differs from `-i`, say so plainly - that is the
useful finding. No new axioms/native_decide; standard axioms; report axioms.
