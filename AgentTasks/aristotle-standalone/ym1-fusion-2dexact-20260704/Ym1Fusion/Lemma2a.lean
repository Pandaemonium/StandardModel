import Mathlib

/-!
# Target: Lemma 2a (finite-group character fusion identity), standalone

Standalone Mathlib-only statement file for an Aristotle proof submission.
Not part of the `PhysicsSM` project tree; no project imports.

## Informal statement (freeze document, section 4, Lemma 2a)

For a class function `w` on a finite group `G`, an irreducible complex
representation `R` of `G`, and any `A : G`:

    sum_{h in G} w(h) * chi_R(h^{-1} * A) = |G| * w_hat_R * chi_R(A) / d_R

where `chi_R` is `R`'s character, `d_R = chi_R(1) = dim R`, and
`w_hat_R = (1/|G|) * sum_{g in G} w(g) * chi_R(g^{-1})` is `w`'s Fourier
coefficient at `R`.

Informal proof sketch (from the freeze document): expand `w` in irreducible
characters, `w = sum_S w_hat_S * chi_S`, then apply Schur orthogonality in
convolution form (`chi_S * chi_R = delta_{S,R} * (|G| / d_R) * chi_R`) term by
term; every term with `S != R` vanishes, leaving the `R` term.

The convolution ARGUMENT ORDER `chi_R(h^{-1} * A)` (not `chi_R(A * h)`) is
load-bearing: this project's oracle fixture (`Scripts/oracle`, v0.2, section
[9]) found the naive order `chi_R(A * h)` only agrees with the convolution
order for inversion-symmetric weights, and general class functions are not
inversion-symmetric. Do not silently switch the argument order to make the
proof easier - if the convolution order turns out to be unprovable but the
`A * h` order is provable, STOP and report the discrepancy rather than
substituting one for the other.

## Corrected Mathlib API (verified against this project's pinned Mathlib
commit by direct source grep, NOT semantic search - a previous semantic-search
pass surfaced a `Representation.character` / `Representation.char_orthonormal`
/ `Representation.IsIrreducible` API that does NOT exist in this pinned
snapshot; do not use it)

`Mathlib/RepresentationTheory/Character.lean` defines, in `namespace FDRep`,
on the CATEGORICAL type `FDRep k G` (finite-dimensional representations as
objects of a category; irreducibility via `CategoryTheory.Simple`, not
`Representation.IsIrreducible` - the two notions do not currently compose via
a ready-made bridge lemma in this pinned snapshot):

- `FDRep.character (V : FDRep k G) (g : G) : k` - `trace k V (V.ρ g)`.
- `FDRep.char_one (V : FDRep k G) : V.character 1 = Module.finrank k V`.
- `FDRep.char_conj (V : FDRep k G) (g h : G) : V.character (h*g*h⁻¹) = V.character g`
  (class-function property).
- `FDRep.char_orthonormal (V W : FDRep k G) [Simple V] [Simple W]
    [Fintype G] [Invertible (Fintype.card G : k)] [IsAlgClosed k] :
    ⅟(Fintype.card G : k) • ∑ g : G, V.character g * W.character g⁻¹ =
      if Nonempty (V ≅ W) then (1:k) else (0:k)`.

`k := ℂ` satisfies `IsAlgClosed` and `Invertible (Fintype.card G : ℂ)` (char 0,
`Fintype.card G ≠ 0`) unconditionally for any finite `G`; both instances should
be derivable/assumed freely.

## What is NOT known to be available (the real content of this job)

Whether this pinned Mathlib packages "every class function on a finite group
is a linear combination of irreducible characters" (character-basis
completeness/expansion) is NOT verified - a search for it did not surface a
direct hit. If it exists, USE it (cite the exact name found). If it does not,
either:

(a) prove the two-character convolution identity directly
    (`sum_h chi_S(h) * chi_R(h^{-1} * A) = (if S = R then (card G / d_R) *
    chi_R(A) else 0)`) via a route that does not require the full expansion
    fact - e.g. via matrix-coefficient orthogonality if Mathlib has it, or via
    `Representation.Semisimple`/Maschke's theorem machinery
    (`Mathlib/RepresentationTheory/Semisimple.lean`,
    `Mathlib/RepresentationTheory/Maschke.lean` both exist in this pinned
    snapshot - not yet checked for a usable decomposition lemma), then
    specialize to a genuine class function `w` by treating `w` itself as
    (the character of) an appropriate representation, OR

(b) report precisely what IS available and what the remaining gap is, rather
    than forcing a proof through a shortcut that weakens the hypotheses
    (e.g. do NOT silently assume `w` already IS a finite sum of characters
    unless that is flagged clearly as an added hypothesis, not a consequence).

A "this needs more infrastructure than a single-file proof; here is what is
missing" report is a fully acceptable, valuable outcome for this job - this
project's convention (`AGENTS.md`) treats an honest no-go as more valuable
than a silently weakened statement.

## Target theorem (cross-multiplied to avoid a division side condition;
logically equivalent to the freeze's ratio form since `Fintype.card G != 0`
and `R.character 1 != 0` for a nonzero simple representation - state and prove
THIS form, then the ratio form follows by an elementary division the
submitting project will do afterward if needed)
-/

open scoped Classical
open CategoryTheory

/-- A class function on a group: constant on conjugacy classes. -/
def IsClassFunction {G : Type} [Group G] (w : G → ℂ) : Prop :=
  ∀ a g : G, w (a * g * a⁻¹) = w g

/-- Lemma 2a, cross-multiplied form. `R.character 1` is `d_R` (the dimension
of `R`, via `FDRep.char_one`); `Fintype.card G` is `|G|`. The left side is
`d_R` times the raw convolution `sum_h w(h) chi_R(h^{-1} A)`; the right side
is `|G|` times `w`'s un-normalized Fourier coefficient at `R`
(`sum_g w(g) chi_R(g^{-1})`) times `chi_R(A)`. -/
theorem lemma2a_fusion_convolution {G : Type} [Group G] [Fintype G]
    (R : FDRep ℂ G) [Simple R] (w : G → ℂ) (hw : IsClassFunction w) (A : G) :
    R.character 1 * (∑ h : G, w h * R.character (h⁻¹ * A))
      = (Fintype.card G : ℂ) * (∑ g : G, w g * R.character g⁻¹) * R.character A := by
  sorry
