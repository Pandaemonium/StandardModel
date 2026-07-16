# Gate A reduced to one ontological decision (2026-07-14)

- Author: interactive Claude (claude family), Research Scientist / Visionary, solo
- Follows the fully-kernel-checked Gate-1 no-go (HNU half-space doubles because
  chirality-balanced). This note shows Gate A - "is a single-Weyl null-edge
  realization possible?" - reduces cleanly to ONE decision, not more mathematics.

## The reduction

The Gate-1 determination proved the boundary window charge of a projector-
conditioned half-space step is

>   `Qwindow = 2 * (tr p - tr q)`

where `p`, `q` are the moving/stationary conditioning projectors on the internal
space. For a single-generator projector-conditioned shift with conditioning
projector `P` on a `d`-dimensional internal space, `q = 1 - p`, so

>   `tr p = tr P`,  `tr q = d - tr P`,  and  `Qwindow = 2 * (2 tr P - d)`.

Therefore:

- **`Qwindow = 0` (doubling) IFF `tr P = d/2`** - the conditioning projector is
  BALANCED (rank exactly half the internal dimension).
- **`Qwindow != 0` (single unpaired defect) IFF `tr P != d/2`** - an UNBALANCED
  conditioning projector.

The HNU walk uses a rank-1 spin projector in `d = 2` (`tr P = 1 = d/2`), so it is
balanced and doubles - this is the Gate-1 result. But the MATH of the single-Weyl
case is ALREADY confirmed: the Gate-1 report exhibits a deliberately unbalanced
projector (rank 1 vs rank 3 in `d = 4`) giving `Qwindow = -/+4 = 2(2 tr P - d)`, a
nonzero single-signed boundary defect - exactly a single unpaired edge charge.

## What this means

There is nothing more to compute for existence. A projector-conditioned null-edge
step with an UNBALANCED conditioning projector (`rank P != d/2`) DOES carry a single
unpaired chiral boundary defect. The only open question is whether such a primitive
is an admissible NULL-EDGE object - a question about the ontology, not the algebra.

So Gate A collapses to a single decision (see the Director queue entry):

> **Is a projector-conditioned null shift with an unbalanced conditioning
> projector (`rank P != d/2` on the internal space) an admissible null-edge
> primitive?**

- **If YES:** the null-edge program CAN host a single 3+1 Weyl at a half-space
  boundary - via internal-dimension imbalance - and the Gate-1 doubling is only the
  special (balanced, `d=2`) HNU choice. This becomes a positive construction lane.
- **If NO (only balanced/`d=2` primitives are admissible):** the null-edge
  single-Weyl realization is DEFINITIVELY IMPOSSIBLE - balance is forced, so the
  boundary always doubles. This completes the mapped-impossibility theorem.

Either way the frontier is fully mapped by this one decision. This is exactly the
"decide whether projector-conditioned null shifts are admissible primitives"
question from the program's standing fork, now sharpened to the precise
rank-vs-half-dimension criterion.

## Why this is a Director decision, not an agent one

Admissibility of a primitive is an ontological choice about what the null-edge
theory IS - it changes the mission-level definition, which the charter reserves to
the Research Director (Sec 5: "supplies scientific judgment where agents lack
context"; changes to the core hypothesis are human authority). Agents can (and did)
settle the mathematics; the admissibility verdict is the human's. Surfaced to the
Director queue; NOT acted on.

## Cheap agent-side follow-ons (independent of the decision)

1. Kernel-check the general formula `Qwindow = 2(2 tr P - d)` for a single-generator
   conditioned shift (generalize the Gate-1 `Qwindow_formula`) - a tightly scoped
   Aristotle/manual target that makes the reduction itself kernel-checked.
2. If the Director rules YES: build the smallest unbalanced (`d=3`, rank-1)
   null-edge half-space step and kernel-check its `Qwindow != 0` single defect
   (the positive single-Weyl construction).
3. If NO: package the balanced-forced impossibility as the completed frontier.
