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

## 4a. P1 RUN RESULTS (2026-07-07, numeric oracle; verdict per sec 4)

Probe implemented and run: `Scripts/oracle/p1_tsolder_koide_probe.py`
(numpy; NOT a Lean result). Construction: three tetrahedral unit spinors;
corner amplitudes computed from actual spinor overlaps/wedges; synchronous
corner-scattering transfer W on the 6 directed legs with SU(2) corner
blocks; both tetrahedral triples checked (results identical).

**Construction correction discovered en route (methodological finding).**
The registered construction was underspecified: raw spinor phases leak
into the naive transfer spectrum (probe's own gauge check, run 1). The
physical data of a decorated cycle are ONLY `|t|`, `|f|`, the continue
cycle holonomy `h = arg(t_1 t_2 t_3)` (= the Berry phase, half the solid
angle; measured EXACTLY +/-90 deg for the tetrahedral triple, sign =
triple orientation), and the flip-phase DIFFERENCES (measured: exact
+/-120 deg winding for the tetrahedral triple). The probe gauge-fixes to
the Z_3-symmetric parallel-transport gauge; after the fix the spectrum is
exactly rephasing-invariant (defect 4e-16).

**Measured results (tetrahedral, gauge-fixed, exact to float precision):**

- Raw eigenphases: `pi/6 * {-6, -2, -1, 0, 4, 5}` - rational multiples of
  pi/6, with an EXACT zero mode, pairing into exactly 3 doubly-degenerate
  mod-pi classes (an even/odd sublattice symmetry; not present in the
  orthogonal or near-collinear controls - it is special to the tetrahedral
  decoration).
- Mass classes: `{0, pi/6, pi/3}` - one exactly massless generation and
  two masses in ratio 1:2.
- R1 shape readout: hops exactly `|t|/2`, uniform; diagonal (turn slot)
  NON-uniform and exactly traceless (values `|f| cos` of 120-deg-spaced
  phases). The `d I + H` ansatz with UNIFORM d is NOT what the dynamical
  reduction produces.
- R2' measurement: `kappa_measured = 1.500000` (exact), predicting
  `Q = (1 + 1/kappa)/3 = 5/9 = 0.5556`. Direct Q on the class spectrum:
  5/9 under sqrt(m) = E; 0.5147 under m = E. Observed lepton value:
  0.66666. Both dictionaries fail.

**VERDICT (per the pre-registered kill table, no reinterpretation):**

- The registered TEST `d^2 = 2|c|^2` (B2, kappa = 1): FAILS.
  `d^2 = |c|^2`-family (B1, kappa = 2): FAILS.
  "Neither" branch fires: the measured kappa = 3/2 predicts Q = 5/9,
  contradicted by data with no further freedom. **Route A (the
  corner-amplitude identification) with tetrahedral decoration does NOT
  yield Koide.** The sec-2 elegance (tetrahedral <=> kappa = 1) does not
  survive the dynamical reduction; it was a transcription-level identity
  (R0 confirms kappa_B2 = 1 exactly), not a carrier theorem.
- Kill (a) also fires in its shape half: the reduction does not have the
  uniform-d `d I + H` form (traceless 120-deg diagonal instead). Per K3,
  gate M-KOIDE's Route-A operationalization is VOID; the gate survives
  only if the running SUB-NAT strategy packet (Aristotle 7f7c1ea6)
  produces a principled DIFFERENT reduction, which must then be
  re-registered before running. The equipartition sum-rule identity
  (kernel job, separate) is pure algebra and unaffected.
- Curious exact fact, recorded without interpretation: the tetrahedral
  dynamical kappa (3/2) equals the TRINE row's transcription kappa, and
  the predicted Q (5/9) is the trine-row prediction - the dynamics
  demotes the corner angle by one dictionary row.

**Unexpected findings worth their own thread (grade C, gated):**

1. The tetrahedral decoration is spectrally distinguished by its exact
   RATIONAL spectrum (pi/6 multiples) and mod-pi double degeneracy - the
   controls show neither. (CORRECTION, same day, from the locus scan in
   sec 4b: the exact ZERO mode itself is NOT tetrahedral-specific - every
   symmetric cone decoration has it; the first draft of this section
   over-attributed it. The correct protection statement is
   symmetry-forced, not Berry-phase-forced; see sec 4b.)
2. The spectrum {0, 1, 2} x pi/6 with one massless member reads as a
   neutrino-sector-shaped toy, not a charged-lepton one. If the mechanism
   ever returns to mass values, the natural target has MOVED.

## 4b. ZERO-MODE LOCUS SCAN (2026-07-07, follow-up; numeric oracle)

Script: `Scripts/oracle/p1_zero_mode_locus_scan.py` (+ a random-decoration
check run inline). Question: when does the decorated-cycle transfer have
an exact zero quasi-energy mode? Findings, exact to float precision:

1. **Symmetry-forced masslessness (the corrected discovery).** EVERY
   Z_V-symmetric decoration (symmetric V-gon on a cone, ANY half-angle
   chi, V = 3,4,5,6 tested) carries an exact zero mode - roughly 400
   crossings per V in the chi sweep is the detector firing along an
   identically-zero curve. Random NON-symmetric spinor decorations do
   NOT have exact zeros (min |E| between 1e-4 and 7e-2 across 12 trials)
   - but they sit close to zero, i.e. generic decorations have a SOFT
   near-massless mode and the cyclic symmetry pins it exactly.
2. **Geometric decorations self-lock onto the massless locus.** In the
   abstract data (|t|, holonomy h, flip winding w) WITHOUT the geometric
   chaining, zero modes require a codim-1 locus: for V = 3, w = +/-1,
   a curve h*(|t|) existing only for |t| >= 1/2, passing through the
   trine endpoint (|t| = 1/2, h = 180 deg) and the tetrahedral point
   (|t| = 1/sqrt3, h = -/+90 deg), running to (|t| = 1, h = 0 mod 360).
   Spinor-geometric cone families trace (|t|(chi), h(chi)) EXACTLY along
   this curve - the celestial geometry enforces the spectral condition.
3. **One genuinely |t|-independent (topological) abstract case:** V = 4
   with half-winding w = 2 (alternating flip phases) has the zero mode
   at h = 0 for ALL |t| tested (spread 3e-12 deg). Even-V half-winding
   is the properly "topological" corner of the abstract parameter space.
4. Prior art now in the paper graph for the eventual writeup: protected
   0- and pi-quasienergy modes in discrete-time quantum walks (Kitagawa,
   arXiv:1112.1882 [3TAWUGB4]; Tarasinski-Asboth-Dahlhaus,
   arXiv:1401.2673 [DEK4EJME]). Novelty must be claimed ONLY for the
   decoration/celestial-geometry origin and the self-locking (finding 2),
   not for 0/pi-mode protection as such.

**Theorem targets handed to the HOLONOMY-ZERO-MODE thread (in order):**

- T1 (REDIRECTED 2026-07-08 by the K6 probe): the forcing symmetry is
  NOT the cyclic shift (abstract winding-1 data is unpinned) but a CHIRAL
  involution Gamma with Gamma W Gamma = W^dagger (= orientation-swap =
  edge-reversal grading), present for the even-V half-winding case, which
  pins BOTH +-1 for all |t|. Kernel core LANDED in
  `PhysicsSM/Draft/NullEdge/Carrier/ChiralZeroModeParity.lean`
  (det W = +-1 dichotomy); the |t|-independent double pinning needs the
  chiral winding invariant (Asboth-Obuse, 1303.1199), oracle-grade.
- T2 (tetrahedral rationality): the V = 3 tetrahedral transfer has
  spectrum pi/6 * {-6, -2, -1, 0, 4, 5} exactly (entries live in a
  cyclotomic field; exact linear algebra is feasible).
- T3 (abstract locus): for V = 3, w = 1 uniform data, 1 in spec(W) iff a
  closed-form relation p(|t|, h) = 0 (evaluate the characteristic
  polynomial at 1); then finding 2 becomes "spinor chaining implies p = 0".

Claim boundary: all numeric-oracle grade; T1-T3 are pre-registered
targets, not results; "masslessness" here means zero quasi-energy of the
finite leg transfer, with no continuum claim.

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
