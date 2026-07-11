# Design+oracle job: CGGSVWZ index dictionary for the positional certificate (Paper C, rank-4)

DESIGN job with exact-computation obligations; typechecking statements
welcome, no big builds. The referee-facing goal: state the PRECISE
relation between our finite positional certificate (context modules) and
the real-space symmetry indices of Cedzich-Geib-Gruenbaum-Stahl-
Velazquez-Werner-Werner, "The topological classification of
one-dimensional symmetric quantum walks", arXiv:1611.04439 (Ann. Henri
Poincare 2018). We may claim NO finite-volume Fredholm/topological
index; the deliverable is a closed-form DICTIONARY or an honest
comparison-only verdict.

## Our objects (kernel-checked, in context modules)

Four-site palindromic register walk W(b) = S*C*S over Q (real
orthogonal), per-site SO(2) coins with cos = 4/5, sin = sign(b x)*3/5;
chiral grading Gamma = I tensor sigma_x, Gamma W Gamma = W^T = W^{-1};
16 sign fields b. Landed: fixed-leg compression self-adjointness iff
two-wall and not fixedSingleton (chart {1,3}), mirror law for chart
{0,2}; every two-wall field's complete walk has exact +-1 modes; the
sector-resolved chirality indices are ALL ZERO (balanced) for every
field; the discriminator is the certificate boundary (which chart
applies), NOT any chirality index.

## Source material (verbatim full-text chunks; VERIFY faithfulness at
harvest against arXiv:1611.04439 - flag any transcription doubt)

[chunk 32, chiral types] "we have a chiral symmetry gamma with
gamma^2 = 1. We can write W(k) in block matrix form with respect to the
eigenspaces of gamma. Since each cell is to be balanced, tr gamma = 0.
Hence the eigenspaces have the same dimension, and the off-diagonal
block W_12(k) is a square matrix. It turns out that W has gaps at +-1
if and only if W_12(k) is invertible for all k."
[chunk 34, reality type] flat-band walk W_flat(k) = 2iB(k) - i,
antisymmetric-real at k = 0, pi in a basis where the symmetry is complex
conjugation; Pfaffian-sign invariants there.
[chunk 35, combined type] block decompositions with K = complex
conjugation, off-diagonal Z(k) unitary; chiral symmetry guaranteed by
the form.
[chunk 39, non-TI] "the symmetry indices si_pm provide an invariant to
classify the GENTLENESS of perturbations... an index criterion to decide
the gentleness of any compact perturbation."

## Tasks (ranked)

1. CLASSIFY our register walk in their tenfold scheme: W real
   orthogonal, chiral gamma = sigma_x per cell (balanced), so plausibly
   a real chiral class (BDI-type) with integer indices - derive this
   carefully from the stated symmetry data and say EXACTLY which of
   their symmetry types applies and what the index group is.
2. TRANSCRIBE their translation-invariant index formula for that type
   (winding of det W_12(k) or the appropriate Pfaffian data) and
   EVALUATE it exactly (sympy) for the two constant bulks (sign +1, -1)
   of the infinite periodic extension, and the relative index across a
   single wall.
3. THE DECISIVE COMPUTATION: over the 16-field classified set (or its
   distinct wall-configurations), does ANY of their indices - bulk,
   relative, or the compact-perturbation/gentleness index si_pm of the
   defect region - reproduce our certificate discriminator
   (protected-vs-blind, i.e. WHICH chart certifies)? Expected from our
   landed results: bulk/relative indices are position-blind (equal
   windings) and chirality-imbalance indices vanish; if their
   gentleness index is also blind, the honest verdict is "our
   discriminator is strictly finer than the CGGSVWZ indices of the
   periodic extension" - state it as the theorem-shaped negative with
   the exact table.
4. Give the referee-facing dictionary sentence(s) verbatim, in both
   outcomes (match found / strictly finer), following: "On the finite
   register we claim no Fredholm invariant; ..." and a Lean-ready
   decidable statement IF a closed-form match exists
   (discriminator B = index formula B over the classified set).
5. Scope guards: no finite-volume index claims; convention/sign
   transcription flagged for source re-verification at harvest.

Deliverable: CGGSVWZ_DICTIONARY_DESIGN.md + optional statements file.
