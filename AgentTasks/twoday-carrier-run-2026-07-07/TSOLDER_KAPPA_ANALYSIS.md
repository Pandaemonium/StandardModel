# The T-SOLDER coefficient: an executor derivation attempt (2026-07-07)

Status: ANALYSIS at working rigor (Claude executor; pencil work, not Lean).
Target: Q07's K2 - derive or refute `kappa = 1` in the T-SOLDER hypothesis
`d_v^2 = kappa * sum_{e at v} |c_e|^2` from carrier structure. Q07 marked this
"the single most valuable next action" for the values layer: `kappa = 1` makes
Koide's `Q = 2/3` a theorem of the mechanism; `kappa != 1` kills the gate
(`Q = (1 + 1/kappa)/3`).

Executive summary: **the coefficient reduces to one corner angle and one
bookkeeping convention, and under the natural bookkeeping, `kappa = 1` is
EXACTLY the statement that adjacent solderings sit at the TETRAHEDRAL angle
(`cos theta = -1/3`)** - the angle of the program's own chirality-regulator
frame. The remaining gap is a single finite computation (P1 below), which is
decidable and pre-registered here before anyone looks at its output.

## 1. Setup

Q07's leg carrier on a V-cycle: `M = d I + H`, `d` = turn (diagonal), `H` =
hops `c_e` on edges. T-SOLDER with coefficient kappa:
`d_v^2 = kappa * sum_{e at v} |c_e|^2`. On the uniform degree-2 cycle:
`d^2 = 2 kappa |c|^2`, and the sum rule gives `Q = (1 + 1/kappa)/V`.

The carrier's per-corner amplitudes are fixed by kernel results: at a corner
where soldering `psi_in` meets `psi_out` (unit spinors, celestial angle
`theta`), the chirality-FLIP amplitude is the wedge (KERNEL at 1+1:
`onshell_wedge_normSq_eq_coin_sq`), magnitude `sin(theta/2)`; the
chirality-PRESERVING (continue) amplitude is the overlap, magnitude
`cos(theta/2)`; and the Lagrange identity (Q07-F0) says
`sin^2(theta/2) + cos^2(theta/2) = 1` - the corner is unitary in the
two-channel sense.

## 2. Route A: the corner-amplitude identification

Identify, per corner `v` of the mass cycle:

- `d_v` = the turn amplitude = `sin(theta_v / 2)` (this is the identification
  the 1+1 kernel bridge licenses: mass insertions ARE flip amplitudes ARE
  wedges);
- `|c_e|` = the continue amplitude `cos(theta_v / 2)` attributed to each of
  the two through-paths at the corner (bookkeeping B2: per incident edge).

Then

```text
kappa = d^2 / (2 |c|^2) = tan^2(theta/2) / 2 ,
```

and the make-or-break condition becomes pure celestial geometry:

```text
kappa = 1   <=>   tan^2(theta/2) = 2   <=>   cos theta = -1/3
            <=>   theta = arccos(-1/3) ~ 109.47 degrees :
```

**the tetrahedral angle** - the pairwise angle of the maximally symmetric
4-direction null frame in 3+1, i.e. exactly the frame the program already
uses as its chirality regulator (the Gate C1 rank-4 tetrahedral kernel; the
Q06-O2 isotropy probe set). Any 3 of the 4 tetrahedral directions are
pairwise at `cos = -1/3`, so a 3-cycle decorated by three tetrahedral
directions satisfies `kappa = 1` at every corner.

### The kappa-to-geometry dictionary (all under identification B2)

| corner geometry | cos theta | kappa | predicted Q (V = 3) |
|---|---|---|---|
| antipodal (1+1 world) | -1 | infinite | 1/3 (all masses equal) |
| trine / 120 deg (2+1-natural) | -1/2 | 3/2 | 5/9 ~ 0.556 |
| **tetrahedral (3+1-natural)** | **-1/3** | **1** | **2/3 ~ 0.667** |
| orthogonal | 0 | 1/2 | 1 (positivity boundary) |
| collinear limit | +1 | 0 | outside domain |

The observed charged-lepton value `Q = 0.666660(7)` sits exactly at the
tetrahedral row. Read either direction, under B2: (i) the tetrahedral
regulator frame FORCES `kappa = 1`, hence Koide; (ii) the lepton data
MEASURE the corner angle and return the tetrahedral value. And the table is
dimension-sensitive: the 2+1-natural trine predicts 5/9, the 1+1 world
predicts total degeneracy - so within this mechanism the Koide value is,
among other things, evidence that lepton corners live in 3+1. (Flagged: this
elegance is exactly the kind that seduces; the caveats below are the point.)

## 3. The honest gaps

**Gap 1 - the bookkeeping (the load-bearing one).** B2 attributes the
corner's continue amplitude to EACH incident edge; the alternative B1
(per-corner attribution, no doubling) gives `kappa = tan^2(theta/2)`, making
`kappa = 1` the orthogonal frame instead. This is precisely the "factor 2
must be pinned" flag from Q07's duality route. The bookkeeping must be
DERIVED, not chosen: the derivation is the explicit one-particle reduction
of the carrier `D` on the cycle to Q07's Hermitian `M` - which entries of
the reduced matrix are `d` and which are `c` is then a computation, not a
convention.

**Gap 2 - which angle.** The corner angle `theta` between CONSECUTIVE edge
solderings is decoration data. The tetrahedral claim needs the cycle's three
solderings pairwise tetrahedral - natural if the decoration is drawn from
the regulator frame, but that is a modeling choice to be stated, not a
theorem.

**Gap 3 - route B kills the naturality shortcut.** Subdivision naturality
(Q07's suggested route) does NOT fix kappa: a pass-through (turn-free)
vertex has `d = 0` with full hop power, violating T-SOLDER maximally - so
T-SOLDER can only ever hold at genuine corners, and subdivision invariance
instead forces the MECHANISM to count only corners as modes. Useful (it
sharpens what the mode space is), but it moves the burden to Route A rather
than discharging it.

**Route C note (flagged as likely numerology).** Corner unitarity + T-SOLDER
at degree 2 give turn-power fraction `sin^2 = 2/3` - the same number as Q,
from a different origin (degree 2, not V = 3). Do not conflate; only the F7
duality could relate them, and it is unproved.

## 4. Pre-registered next steps (decidable; registered before looking)

- **P1 (the decider; numeric-first per methodology).** Construct explicitly:
  the Z_3 cycle; three unit spinors at pairwise tetrahedral angles (three of
  the four regulator directions); the carrier corner transfer (continue +
  flip channels per the checkerboard convention, now PINNED by the
  palindromic-ordering theorem of `GWRetardedTransfer.lean`); reduce to the
  leg-level Hermitian `M`; read off `d` and `c`. TEST: `d^2 = 2 |c|^2`
  (kappa = 1, bookkeeping B2 confirmed) vs `d^2 = |c|^2`-family (B1) vs
  neither (identification wrong; the computed kappa then PREDICTS
  `Q = (1 + 1/kappa)/3`, to be compared against 2/3 with no further
  freedom). KILL-CONDITIONS: (a) reduction does not have the `d I + H` shape
  at all -> the Q07 ansatz is not carrier-native, gate M-KOIDE is VOID per
  its K3 clause; (b) kappa lands off the table -> tetrahedral route dead,
  report the measured kappa.
- **P2 (pencil).** Derive the bookkeeping abstractly: the Hermitian leg
  carrier's Frobenius bookkeeping counts each undirected edge twice
  (`||H||_F^2 = 2 sum_e |c_e|^2`) while the vertex-local sum counts each
  incident edge once - trace the corner amplitude through this accounting
  and determine whether B2's doubling is forced by Hermiticity of the
  reduction.
- **P3 (only if P1 passes).** State the theorem: "uniform tetrahedral-corner
  turn-soldered cycles satisfy Q = 2/V" with the identification proved, and
  upgrade GATE M-KOIDE's grade per its own K2 clause.

## 5. Relation to standing threads

- EQUIPARTITION-GATE (thread): P1 is now that thread's decisive experiment;
  the kernel sum-rule job (43a7f979) is the identity's formal core either way.
- Gate C1 / NERD tetrahedral regulator: if P1 passes, the SAME frame choice
  regulates chirality AND forces the Koide value - one decoration decision,
  two consequences; if P1 fails, the coincidence is exposed cheaply.
- Q06-O2 (celestial point-group probe): runs on the same frame; share the
  construction.
- Charter layer-5 discipline: nothing in this note is a result; it converts
  K2 from an open question into one finite computation plus one accounting
  lemma, with kills registered. The manuscript (v3, layer 5) needs no update
  until P1 runs.
