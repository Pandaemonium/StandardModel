# Aristotle proof job: YM1 Lemma 2a (finite-group character fusion convolution identity)

RESUBMISSION: an earlier submission of this same target (project `9627f7ea`)
had a normalization bug (a spurious extra factor of `Fintype.card G` on the
RHS) and was canceled early, likely during its own sanity-check pass over
the same bug. The bug is fixed in the statement below (verified against the
trivial-representation sanity check: `w=1`, `R` trivial gives `LHS=|G|`,
and the buggy version asserted `RHS=|G|^2`). This resubmission is otherwise
the same target.

Standalone Mathlib-only Lean 4 target. Repo pinned toolchain: leanprover/lean4:v4.28.0.
Project: `AgentTasks/aristotle-submit/ym1-fusion-2dexact-20260704b-project`.
Target file: `Ym1Fusion/Lemma2a.lean`. Run `lake env lean Ym1Fusion/Lemma2a.lean`
first (fast, Mathlib-only); do not attempt a full project build (there isn't one -
this package intentionally has no dependencies beyond Mathlib).

## Context (assume you are blind to the source repository)

This is one lemma in a larger 2D lattice-gauge-theory formalization program.
The target file's own docstring is the full informal spec: the freeze-document
statement of "Lemma 2a" (a finite-group character fusion/convolution
identity), the exact Mathlib API this project's pinned commit actually has
(verified by direct source grep, NOT by semantic search - a prior semantic
search pass surfaced a DIFFERENT, nonexistent `Representation.character` /
`Representation.char_orthonormal` API for this same pinned commit; do not
reintroduce that mistake), and an honest statement of what is NOT yet known to
be available (whether Mathlib has "class functions are spanned by irreducible
characters" for a finite group). Read the file's docstring in full before
starting; it is more precise and more current than this paragraph.

## What to do

1. Attempt to prove `lemma2a_fusion_convolution` exactly as stated. Do not
   weaken the statement (do not add an inversion-symmetry hypothesis on `w`,
   do not restrict to abelian `G`, do not change the convolution argument
   order from `h⁻¹ * A` to `A * h`) to make progress - if the stated form
   resists, report exactly where and why rather than substituting an easier
   statement.
2. If the direct route needs "characters span the class functions" and that
   fact is not in Mathlib, you may prove it as a lemma within this file
   (finite group representation theory - via semisimplicity of the group
   algebra, `Mathlib/RepresentationTheory/Semisimple.lean` and
   `Mathlib/RepresentationTheory/Maschke.lean` both exist in this pinned
   commit and may help) rather than treating it as a missing primitive. This
   may be the bulk of the real work; that is expected and acceptable.
3. If, after genuine effort, the statement needs more infrastructure than is
   reasonable for one file, STOP and report precisely: which sub-lemma you
   established, which sub-lemma resisted, the exact blocking Lean error or
   missing API, and your best assessment of whether the statement is true
   (it should be - this is standard finite representation theory - but flag
   clearly if you find reason to doubt it). A precise no-go report is a fully
   valuable outcome; a proof of a silently-weakened statement is not.
4. Small helper lemmas, additional hypotheses that are consequences of
   `[Simple R]`/`[Fintype G]`/complex field structure (not silent weakenings
   of the class-function or convolution-order requirements), and reasonable
   auxiliary definitions are all fine to add within the file.

## Verification requested

- `lake env lean Ym1Fusion/Lemma2a.lean` with zero errors and zero
  `s o r r y` if you complete the proof.
- Report the full axiom footprint of `lemma2a_fusion_convolution` (expect
  `[propext, Classical.choice, Quot.sound]`; flag anything beyond that,
  especially `Lean.ofReduceBool`/`Lean.trustCompiler` from
  `n a t i v e _ d e c i d e`, which is not acceptable here).
- If you add auxiliary lemmas, give a one-line English statement of what each
  means, not just its Lean type.

## Format

ASCII only, LF line endings. In prose (not code), write Lean escape-hatch
tokens in spaced form (`s o r r y`, `a x i o m`), never raw, so this stays
easy to grep for genuine placeholders later.
