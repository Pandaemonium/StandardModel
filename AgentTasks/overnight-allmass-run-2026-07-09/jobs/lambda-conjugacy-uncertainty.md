# claude-lambda-conjugacy-uncertainty — Lambda conjugate to the count, natively: a finite Fourier uncertainty theorem

## Context (blind to any repo; self-contained finite algebra, Mathlib only)

Make "Lambda is conjugate to the volume/count" NATIVE to the finite information theory instead
of imported from unimodular gravity. Finite form: the volume register and the Lambda register
are related by the discrete Fourier transform on `ZMod n`, and a state cannot make both sharp —
the Donoho-Stark support-uncertainty theorem `|supp f| * |supp (DFT f)| >= n`. Then "sharp
count => maximally noisy conjugate phase" is a THEOREM, and the everpresent reading (a large
sharp-count universe has residual conjugate-phase noise `~ 1/sqrt(count)`) has a native finite
backbone.

## The model (ZMod n; explicit finite Fourier pair)

Work over `ZMod n` (n a concrete small number AND general n where Mathlib supports it).
"Volume register" = functions `f : ZMod n -> C` supported on count values; "Lambda register" =
the DFT `F f (k) = sum_j f j * omega^(j*k)` with `omega` a primitive n-th root of unity. If
Mathlib's `ZMod.dft` / discrete Fourier machinery is available use it; else define the DFT
explicitly with `omega : C` a concrete root for a fixed small `n` (e.g. n = 4 with omega = i,
keeping all arithmetic in explicit Gaussian rationals — NO transcendental analysis).

## Targets

1. `delta_maps_to_uniform` (the conjugacy, finite form): the sharp-count state `f = delta_{N0}`
   (supported on one count value) maps under DFT to a function of CONSTANT modulus (uniform over
   the Lambda register) — sharp volume => completely unsharp Lambda. Prove `|F delta (k)| = 1`
   for all k (squared form: `normSq = 1`).
2. `uniform_maps_to_delta` (dual): the uniform state maps to a delta — sharp Lambda => completely
   unsharp count. (DFT inversion on the witness; explicit for the chosen n.)
3. `support_uncertainty` (payload — Donoho-Stark): for nonzero `f : ZMod n -> C`,
   `|supp f| * |supp (F f)| >= n`. If the general theorem is heavy, prove it for the concrete
   small `n` (n = 4: check all support-size pairs by the linear-algebra argument or finite case
   analysis), PLUS the general delta/uniform extremal pair from targets 1-2 saturating it
   (`1 * n = n`). State honestly which form landed.
4. `conjugacy_verdict`: package — the count and Lambda registers form a finite Fourier-conjugate
   pair; sharpness trades off exactly (Donoho-Stark); the extremal states are sharp-count/
   uniform-Lambda and vice versa. So "Lambda is the phase conjugate of the null-edge count" is
   native finite mathematics; the everpresent mechanism reads as: a universe with a large,
   nearly-sharp count retains conjugate-phase noise, and (imported scaling) its RMS is
   `1/sqrt(count)`. Honest scope: the conjugacy + uncertainty are M; the IDENTIFICATION of the
   conjugate variable with the physical cosmological constant stays [C]/imported.

MANDATORY non-degeneracy: all witnesses explicit and nonzero — the delta and uniform states on
`ZMod 4` with their DFTs computed entrywise (Gaussian-rational values stated in-theorem), the
uncertainty product `1 * 4 = 4 >= 4` saturating, and one middle witness (support 2) with
`|supp f| * |supp F f| >= 4` checked concretely.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print
axioms <thm>` on every headline. Explicit Gaussian-rational arithmetic on a fixed small n (use
omega = i on ZMod 4 so every value is in Z[i]; NO transcendental roots of unity, NO symbolic
Complex analysis beyond concrete entries); Finset/support + ring/norm_num/decide/fin_cases.
Build under 3 min. Deliver RequestProject/Main.lean (namespace LambdaConjugacy) +
ARISTOTLE_SUMMARY.md.
