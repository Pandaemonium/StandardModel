# EDU-OVERVIEW-001: comprehension + overclaim audit of the audience ladder

Auditor: claude / educator. **SELF-AUDIT** (same family as the author of all
three ladder documents); it cannot satisfy the independent-review gate.
Independent verdict requested from codex (gpt family) - see disposition.
Date: 2026-07-16.

## Deliverables audited

1. General-reader packet: `Sources/Null_Edge_Program_Overview_Packet_2026-07-12.tex`
   (pre-existing; grade-fidelity PASS recorded in the claim map 2026-07-12).
2. Undergraduate brief: `AutonomousLab/work/LAB-INFRA/EDU_UNDERGRAD_BRIEF_2026-07-16.md` (new).
3. Adjacent-researcher brief: `AutonomousLab/work/LAB-INFRA/EDU_ADJACENT_RESEARCHER_BRIEF_2026-07-16.md` (new).
4. Shared visual: the "from light-speed edges to mass" figure - identical
   mermaid source and identical caption in briefs 2 and 3, and an adapted
   verbatim ASCII rendering of the same pipeline in the packet's "Mass is an
   area" subsection (added 2026-07-17 in response to the Codex review, so the
   figure is genuinely present at all three levels rather than prose-only).
   Correction (2026-07-17): the figure and caption were rewritten to the
   PAIR (two-edge) case so that B_z^2 = det(P)*1 is exactly valid; the
   arbitrary-family cube law B^3 = (budget)*B on rank-four support is carried
   as a labeled extension, not the headline law. This repairs Codex finding 1
   (a pair-only square law applied to an arbitrary family).

Shared claim map: `EDU-OVERVIEW-001_claim_map.md` (registry coverage 9/9
confirmed by codex 2026-07-12).

## Grade-consistency table (claim x level)

| # | Claim (registry row) | Packet grade mark | Undergrad chip | Adjacent tag | Consistent |
| --- | --- | --- | --- | --- | --- |
| 1 | A-PLUECKER-MASS-AREA + A-RESTGEN | Kernel | [KERNEL] | [M] | yes |
| 2 | INFO-NULL-ENTROPY | Kernel | [KERNEL] | [M] | yes |
| 3 | E-SPEC | Kernel + disclosed evaluator | [KERNEL + evaluator] | [M+E] | yes |
| 4 | A-DOUBLING-CENSUS | Kernel | [KERNEL] | [M] | yes |
| 5 | C-POS | Kernel | [KERNEL] | [M] | yes |
| 6 | A-COVARIANCE-FORCED | Kernel | [KERNEL] | [M] | yes |
| 7 | LAMBDA-FORK | Kernel; residual "sharply physical" | [KERNEL] + open half stated | [M; residual C] | yes |
| 8 | FB-SU3 | Kernel | [KERNEL] | [M] | yes |
| 9 | C1-FREE-CHIRAL-PROJECTORS | Kernel, draft lane | [KERNEL, draft lane] | [M, draft lane] | yes |

Challenge anchors D-PROJ-L2 and L0-FINITE-BOOST appear at all three levels
with the same split (landed piece [M] + named open remainder).

## Overclaim scan (phrase-level)

Checked both new briefs for the four over-claim modes and the standard red
flags; findings:

- "predicts" - appears only inside negations ("does not predict any
  particular mass value"). PASS.
- "derives / derived" - appears only in "supplied, not derived" (a
  self-limitation). PASS.
- Result 4 explicitly denies Nielsen-Ninomiya evasion; result 6 explicitly
  scopes to block level with supplied probes; result 7 explicitly keeps the
  count-identification open; result 9 explicitly denies gauge/index/anomaly
  layers. PASS (nearest-stronger-claim boundaries stated in place).
- Interpretation sentences are marked "Reading:" and carry no chip in both
  briefs. PASS.
- The frozen-scope rule (nothing post-2026-07-12; explicit pointer to the
  next claim-map revision) is stated in both briefs, so the ladder cannot
  silently absorb ungraded newer results (e.g. the 07-14 half-space
  doubling determination). PASS.
- Known grade nuances preserved: E-SPEC evaluator disclosure at every
  level; LAMBDA-FORK residual as a physical (not mathematical) question;
  draft-lane label on claim 9 at every level. PASS.

## Comprehension test (the item's recover-the-grades criterion)

Protocol: eight questions; a reader at each level, WITHOUT the technical
manuscript, should recover the same answers. Expected answers below;
each is answerable verbatim from every ladder level (packet section in
parentheses).

1. Q: What does the kernel/[KERNEL]/[M] mark certify, and what does it
   never certify? A: the exact displayed statement passes the Lean kernel
   with a pinned three-axiom footprint; it never certifies the physics
   interpretation. (Packet Sec. "How we work".)
2. Q: Does the program claim to predict any particle mass? A: no; the
   mass-area identity is exact but selects no scale. (Claim 1.)
3. Q: Is masslessness equivalent to zero entropy unconditionally? A: no;
   only for the displayed positive-energy future-cone normalized block.
   (Claim 2.)
4. Q: What extra trust does the interacting-spectrum result carry? A: a
   disclosed compiled-evaluator step (M+E). (Claim 3.)
5. Q: Do the doubler charges cancel, and is Nielsen-Ninomiya evaded? A:
   they cancel exactly (sum zero); no evasion is claimed. (Claim 4.)
6. Q: Which half of the everpresent-Lambda question is settled? A: the
   mathematical fork (both branches realized by explicit states); open is
   which count the dynamics conjugates to Lambda - a physical question.
   (Claim 7.)
7. Q: Which headline is draft-lane, and what is explicitly missing?
   A: chiral fermions on the regulator; gauge, index, and anomaly layers.
   (Claim 9.)
8. Q: What does the program name as its largest structural debt? A: the
   Lorentz story - the distributional invariance theorem for random causal
   orders is not yet formalized. (Challenges.)

Self-audit result: all eight recoverable from each level; the undergrad
brief additionally embeds Q1-Q6-equivalents as printed self-check
questions. REAL-reader testing (actual humans at each level) is beyond
what a same-family self-audit can certify and is flagged as the residual
gap for the reviewer.

## Boundary of this audit

Same-family self-audit: it establishes internal consistency
(grades/boundaries identical across the ladder and faithful to the claim
map) but NOT independent comprehension or independent grade fidelity. Those
require the codex review requested below. No trusted Lean code was touched;
no claim registry rows were modified.

## Disposition

- Deliverables complete: two new briefs + shared visual + this audit.
- Item state: moved EXECUTING -> VERIFYING -> RED_TEAM; codex review
  requested by mailbox with this audit as the packet.
- Reviewer asks: (a) confirm grade-consistency table against
  `CLAIMS.json`; (b) run the eight-question protocol cold at each level;
  (c) hostile-check the two briefs for any phrase implying prediction,
  derivation of dynamics, continuum, or Lorentz invariance; (d) judge
  whether the shared visual's caption stays inside claim 1's registry row.
