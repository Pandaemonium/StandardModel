# General-audience manuscript sync delta (prepared 22:15, execute post-freeze)

Target: `Sources/Null_Edge_General_Audience_Manuscript_2026-07-09.tex`.
Principle: plain language in the text, boundaries in footnotes, no new
jargon. Each item lists tonight's landing and the GA location to touch.

## 1. Full-Bloch determinant criterion (Codex, FullBlochSplit*)

- Section "Why 3+1 dimensions are harder", after the alias/no-go discussion:
  add one sentence: the project now has an exact algebraic criterion valid
  at every momentum - two explicit polynomials whose zeros are exactly the
  walk's zero- and pi-frequency modes - so the hunt for a clean regulator
  is now a precise algebra problem, not a plotting exercise. Footnote: the
  criterion is det(U -+ 1) = 4 P_{0,pi}; classifying all zero sets is open.
- "What the machine has checked" bullet list: add the determinant bullet.
- Appendix module table: add FullBlochSplitDeterminants.lean row.

## 2. Derived winding (Fable, PlueckerWindingDerived)

- Phase section currently: "Nonzero winding requires patches or genuine
  link transition data..." and footnote "The missing theorem is the
  reduction from patched local Pluecker data to the existing finite index
  operator and a stable localized eigenmode." UPDATE: the patched link data
  is now DERIVED from the local field (integer winding, spinor-generated
  winding-one example); the missing theorem shrinks to index reduction +
  localized mode.
- Checked list: add "The link data of any nowhere-vanishing mass field has
  an exact whole-number winding, and an explicit winding-one field is built
  from primitive spinors."
- Module table: add PlueckerWindingDerived.lean row.

## 3. Interference discriminator (Fable, PlueckerPhaseObservable)

- Phase section ("The number hidden inside mass") bullet list: add the
  operational punchline in plain language: two mass fields with the same
  magnitude but different phases are provably indistinguishable by any
  one-particle measurement, yet an explicit two-particle interference
  experiment tells them apart - survival probability exactly 4/5 versus 1.
  This is the strongest general-audience line of the night: concrete
  numbers, no jargon.
- "When one particle is not enough": append the same result where the pair
  kick is discussed.
- Checked list + module table rows.

## 4. Creation covariance (Codex, FiniteCARSecondQuantization)

- "When one particle is not enough" says: "Full compatibility with adding a
  particle, probability preservation, and inherited spatial locality are
  the remaining gates." UPDATE: compatibility with adding a particle
  (creation covariance) is now proved; probability preservation and
  locality remain.

## 5. Gupta-Short framing (Fable, manuscript positioning)

- Kill-condition item 3 (strict 3+1 successor) is unchanged, but the
  "Research program ahead" item 1 could gain a clause: the field's newest
  doubler-free walks (stay-put constructions) provably give up the exact
  unit-speed tangent, so the design tension is now theorem-shaped on both
  sides. Keep to one sentence + footnote citing Gupta-Short.

## Do NOT

- Do not add the C index/mode claim unless ecbe0d8b/b407e2d5/pillar-3
  actually land before freeze.
- Do not renumber kill conditions; only sharpen wording.
- Preserve the hook, analogies, and register restored in the earlier
  session (user-approved).
