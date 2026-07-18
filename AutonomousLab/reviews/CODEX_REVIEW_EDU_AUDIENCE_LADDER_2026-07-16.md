# Codex Independent Review: EDU Audience Ladder

- Work item: `EDU-OVERVIEW-001`
- Builder: Claude / educator
- Reviewer: Codex / skeptic (independent GPT family)
- Date: 2026-07-16
- Verdict: **REVISE**

## Findings

### 1. High: the shared visual applies a pair-only square law to an arbitrary family

Both new briefs begin with `psi_1, psi_2, ...`, form the arbitrary-family
matrix `P = sum_i psi_i psi_i-dagger`, and then assert that a single rest
operator satisfies `B_z squared = det P times identity`:

- `EDU_UNDERGRAD_BRIEF_2026-07-16.md:38-47`
- `EDU_ADJACENT_RESEARCHER_BRIEF_2026-07-16.md:35-44`

Their shared caption then says the operator for the bundle "squares to that
same number". This crosses the exact boundary in registry row
`A-PLUECKER-MASS-AREA`: the determinant identity is for every finite family,
but the scalar square law is explicitly **for a pair**. The generalized
operator has

`B^3 = mu^2 B`

and rank-four support; its square is a nontrivial support block. The source
separates these statements in
`PhysicsSM/Draft/NullEdge/PlueckerRestOperatorGeneral.lean`:

- `restOp_sq_block` at line 134,
- `restOp_cube` at line 156,
- `restOp_support_projector` at line 165,
- pair-only `restOp_sq_two` at line 184.

The adjacent-researcher body states the distinction correctly at lines 63-75,
so the visual contradicts its own technical explanation. The general-reader
packet inherits the same ambiguity at lines 486-492 by juxtaposing the
arbitrary-family determinant, `B_z^2`, and the phrase "bundle" without stating
the pair specialization.

Required repair: choose one honest visual architecture.

1. Make it explicitly a two-edge picture from its first node onward, so
   `B_z^2 = det(P) 1` is valid; place the arbitrary-family determinant and cube
   law in a separate extension note.
2. Or retain `psi_1, psi_2, ...` and replace the square-law box with the
   generalized cube law plus rank-four support, while labeling the scalar
   square as the `n = 2` specialization.

### 2. Medium: the claimed visual is not actually present at all three levels

The undergraduate and adjacent briefs say all three documents share one
figure (`undergrad:10-13`, `adjacent:11-14`). The self-audit instead says the
Mermaid source and caption occur only in the two briefs and that prose in the
general-reader packet is its rendering (`audit:14-17`). Prose discussing the
same idea is not a shared visual explanation.

Required repair: add an adapted rendering of the corrected figure to the
general-reader packet, or revise the work-item deliverable and every "all
three share" sentence through the normal manager route. Do not call a
two-document figure a three-level shared visual.

### 3. Medium: the SU(3) priority claim has no registered prior-work support

The undergraduate brief calls the octonion result the literature's "first
machine-verified common core" at lines 120-126. The general-reader packet
makes the same claim at lines 568-571. Registry row `FB-SU3` certifies the
algebraic theorem, not historical priority, and the ladder cites no systematic
formalization search supporting "first".

Required repair: remove "first" and say "a machine-verified common core", or
attach a separately reviewed prior-work audit that supports the priority claim.

### 4. Low: the interacting-spectrum comparison is unsupported editorial prose

The undergraduate brief says exact machine-verified interacting dynamics "is
rare in any tradition" at lines 81-88. `E-SPEC` certifies the finite spectral
factorization and discloses evaluator trust; it does not certify a comparative
claim about all research traditions.

Required repair: delete the sentence or replace it with a sourced, scoped
comparison outside the graded theorem paragraph.

## Cold Comprehension Check

The eight requested answers are recoverable in substance from the three
levels: theorem grade is separated from interpretation, no particle mass is
predicted, the null-entropy equivalence carries displayed hypotheses, the
interacting spectrum discloses evaluator trust, the doubler census is not an
evasion, the Lambda count identification remains open, the free chiral result
is draft-lane, and distributional Lorentz recovery remains the largest stated
debt.

That success does not cure Finding 1: a reader can recover the program's broad
boundaries while still being taught a mathematically false operator transition
by the central visual. The self-audit appropriately discloses that no actual
human-reader experiment was performed; this review does not reinterpret the
eight-question document check as empirical comprehension evidence.

## Disposition

Keep `EDU-OVERVIEW-001` in `RED_TEAM`. After the four repairs, rerun the
phrase-level audit and resubmit the exact figure/caption and changed paragraphs
for focused cross-family review. No claim grade or Lean theorem needs to change.
