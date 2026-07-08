import Mathlib

/-!
# P12 — Koide / T-SOLDER `kappa` gate: probe P1 and SUB-NAT witnesses

This file is the **exact finite witness layer** for the strategy packet
`AgentTasks/twoday-carrier-run-2026-07-07/ARISTOTLE_P12_KOIDE_SUBNAT_PACKET_2026-07-07.md`,
which executes the P12 task
(`AgentTasks/twoday-carrier-run-2026-07-07/ARISTOTLE_P12_KOIDE_SUBNAT_2026-07-07.md`).

Claim boundary (kept explicit, per the task and Pro's patch note): everything
here is a **gate for mass-value hypotheses, not a mass-value prediction**.  No
physical mass value is asserted.  All statements are exact rational facts about
a bookkeeping convention; nothing here depends on floating-point data.

## Corner convention (pinned, not re-chosen)

The corner amplitudes are read off the *stated* normalization of the corner
rotation `Cm` in
`PhysicsSM/Draft/NullEdge/Carrier/GWRetardedTransfer.lean`
(`GWTransfer.rotMat`), which is the block-diagonal
`Cm = [[c, -s], [s, c]]` per spatial site.  There:

* `c` is the **continue** (chirality-preserving) amplitude,
* `s` is the **flip** (chirality-changing / turn) amplitude,

and the palindromic / midpoint transfer `T = S · Cm · S` is the pinned corner
convention (`GWTransfer.transferMat`; its unitarity `GWTransfer.rot_mul_inv`
uses exactly the Pythagorean constraint `c² + s² = 1`).  We use **only** this
stated normalization; we do not import any un-normalized retarded-Green object.

At half-angle `theta/2` the amplitudes are `c = cos(theta/2)`, `s = sin(theta/2)`,
so the **powers** are rational functions of `x := cos theta`:

* continue power `c² = cos²(theta/2) = (1 + x)/2`,
* flip / turn power `s² = sin²(theta/2) = (1 - x)/2`.

Because the identification `kappa = d² / (hop power)` involves only these
*squared* amplitudes, the whole gate is decidable over `ℚ`, even though `c` and
`s` are individually irrational at the tetrahedral angle.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.KoideSubNat

/-! ## 1. Corner powers and the tetrahedral angle -/

/-- Continue power `c² = cos²(theta/2) = (1 + cos theta)/2`, `x = cos theta`. -/
def contPow (x : ℚ) : ℚ := (1 + x) / 2

/-- Flip / turn power `s² = sin²(theta/2) = (1 - cos theta)/2`, `x = cos theta`. -/
def flipPow (x : ℚ) : ℚ := (1 - x) / 2

/-- Corner unitarity (Q07-F0 / Lagrange identity), rational form: the two
channel powers sum to one.  This is the rational avatar of the Pythagorean
constraint `c² + s² = 1` used by `GWTransfer.rot_mul_inv`. -/
theorem contPow_add_flipPow (x : ℚ) : contPow x + flipPow x = 1 := by
  unfold contPow flipPow; ring

/-- The tetrahedral celestial angle: `cos theta = -1/3`
(`theta = arccos(-1/3) ≈ 109.47°`), the pairwise angle of the maximally
symmetric 4-direction null frame in 3+1. -/
def tetX : ℚ := -1/3

/-- At the tetrahedral angle the continue power is `1/3`. -/
theorem tet_contPow : contPow tetX = 1/3 := by unfold contPow tetX; norm_num

/-- At the tetrahedral angle the flip / turn power is `2/3`. -/
theorem tet_flipPow : flipPow tetX = 2/3 := by unfold flipPow tetX; norm_num

/-! ## 2. Probe P1 — the `kappa` decider

`d_v = ` turn amplitude `= sin(theta/2)`, so the mass-amplitude-squared
(turn power) at a corner is `d_v² = flipPow x`.

T-SOLDER: `d_v² = kappa · Σ_{e at v} |c_e|²`.  On the uniform degree-2 cycle the
vertex sum has two incident edges; the two pre-registered bookkeepings are:

* **B1** (per-corner attribution, no doubling): `hop = contPow x`;
* **B2** (per-incident-edge attribution, doubling): `hop = 2 · contPow x`.

`kappa = d² / hop`.  This is exactly Fable/Pro's registered `factor-2` question.
-/

/-- Turn power `d² = sin²(theta/2)`. -/
def turnPow (x : ℚ) : ℚ := flipPow x

/-- Bookkeeping **B1** hop power at a degree-2 corner (single count). -/
def hopB1 (x : ℚ) : ℚ := contPow x

/-- Bookkeeping **B2** hop power at a degree-2 corner (each incident edge). -/
def hopB2 (x : ℚ) : ℚ := 2 * contPow x

/-- T-SOLDER coefficient `kappa = d² / (hop power)`. -/
def kappaOf (turn hop : ℚ) : ℚ := turn / hop

/-- General B1 value: `kappa_B1 = tan²(theta/2)`. -/
theorem kappaB1_eq (x : ℚ) (_hx : contPow x ≠ 0) :
    kappaOf (turnPow x) (hopB1 x) = flipPow x / contPow x := by
  unfold kappaOf turnPow hopB1; rfl

/-- General B2 value: `kappa_B2 = tan²(theta/2) / 2`. -/
theorem kappaB2_eq (x : ℚ) (_hx : contPow x ≠ 0) :
    kappaOf (turnPow x) (hopB2 x) = flipPow x / (2 * contPow x) := by
  unfold kappaOf turnPow hopB2; rfl

/-- **P1, B1 outcome (exact):** at the tetrahedral angle, `kappa_B1 = 2`. -/
theorem kappaB1_tet : kappaOf (turnPow tetX) (hopB1 tetX) = 2 := by
  unfold kappaOf turnPow hopB1 flipPow contPow tetX; norm_num

/-- **P1, B2 outcome (exact):** at the tetrahedral angle, `kappa_B2 = 1`.
This is the pre-registered positive result: under B2 the tetrahedral corner
forces `kappa = 1`. -/
theorem kappaB2_tet : kappaOf (turnPow tetX) (hopB2 tetX) = 1 := by
  unfold kappaOf turnPow hopB2 flipPow contPow tetX; norm_num

/-- The bookkeepings are genuinely different at the tetrahedral angle
(`kappa_B1 = 2 ≠ 1 = kappa_B2`): the factor-2 ambiguity is real and is not
washed out by the tetrahedral choice. -/
theorem kappa_bookkeepings_differ :
    kappaOf (turnPow tetX) (hopB1 tetX) ≠ kappaOf (turnPow tetX) (hopB2 tetX) := by
  rw [kappaB1_tet, kappaB2_tet]; norm_num

/-! ## 3. Mechanism sum-rule `Q` (definition-level, not a mass prediction)

The mechanism's sum rule on a `V`-cycle is `Q = (1 + 1/kappa)/V`.  We record the
two exact values it takes at the tetrahedral corner under B2 and B1.  These are
*conditional* readouts of the convention, not asserted physical values. -/

/-- Mechanism sum-rule readout `Q = (1 + 1/kappa)/V`. -/
def Qmech (kappa V : ℚ) : ℚ := (1 + 1/kappa) / V

/-- Under B2 (`kappa = 1`) on the 3-cycle the readout is `Q = 2/3` (the Koide
value).  Stated as a conditional identity of the convention, not a prediction. -/
theorem Qmech_B2_tet : Qmech 1 3 = 2/3 := by unfold Qmech; norm_num

/-- Under B1 (`kappa = 2`) on the 3-cycle the readout is `Q = 1/2`. -/
theorem Qmech_B1_tet : Qmech 2 3 = 1/2 := by unfold Qmech; norm_num

/-! ## 4. SUB-NAT — subdivision naturality of the mass form

**Subdivision map.**  A decorated cycle is the list of its corner cosines
(`x = cos theta` at each corner).  Edge subdivision `e → e' e''` inserts one new
vertex on a *straight* edge; by the pinned palindromic-transfer convention the
induced corner is a **pass-through**: `theta = 0`, i.e. `cos theta = 1`, hence
turn power `0` and full continue power `1`.  This is Gap 3 of the analysis: a
pass-through vertex has `d = 0` with full hop power, so it can never be a
T-SOLDER corner.

We pre-register three equality notions for "subdivision does not change the mass
form", each as a separate claim with an explicit kill condition. -/

/-- A decorated cycle: the list of corner cosines `x = cos theta`. -/
abbrev Cycle := List ℚ

/-- The corner inserted by one edge subdivision: a pass-through, `cos theta = 1`. -/
def passThrough : ℚ := 1

/-- Subdivision map: insert one pass-through vertex. -/
def subdivide (C : Cycle) : Cycle := passThrough :: C

/-- The raw mass form: the list of turn powers (`∝` masses) over all vertices. -/
def massSpectrum (C : Cycle) : List ℚ := C.map turnPow

/-- The genuine-corner mass form: the turn powers of vertices that actually
turn (nonzero turn power). -/
def cornerSpectrum (C : Cycle) : List ℚ := (C.map turnPow).filter (· ≠ 0)

/-- A pass-through carries zero turn power. -/
theorem turnPow_passThrough : turnPow passThrough = 0 := by
  unfold turnPow flipPow passThrough; norm_num

/-! ### 4a. SUB-NAT-STRICT — pre-registered claim + kill

Claim: `massSpectrum (subdivide C) = massSpectrum C`.
Kill condition: any subdivision changes the raw mass form (e.g. the length
changes).  **Result: FALSE** — falsifying certificate below (general, for every
cycle: subdivision lengthens the raw spectrum by one). -/

/-- The raw mass form gains exactly one entry under subdivision. -/
theorem massSpectrum_length_subdivide (C : Cycle) :
    (massSpectrum (subdivide C)).length = (massSpectrum C).length + 1 := by
  simp [massSpectrum, subdivide]

/-- **SUB-NAT-STRICT is FALSE (general falsifying certificate).**  For every
cycle, the raw mass form is *not* invariant under subdivision: the inserted
pass-through appends a spurious zero mode, changing the length. -/
theorem subNat_strict_fails (C : Cycle) :
    massSpectrum (subdivide C) ≠ massSpectrum C := by
  intro h
  have := congrArg List.length h
  rw [massSpectrum_length_subdivide] at this
  omega

/-! ### 4b. SUB-NAT-PROJECTIVE — pre-registered claim + kill

Claim: the *genuine-corner* mass form is invariant (ratios of the nonzero
masses are preserved, i.e. equality up to the appended zero mode).
Kill condition: subdivision changes the nonzero mass multiset.
**Result: TRUE** — general exact witness below. -/

/-- **SUB-NAT-PROJECTIVE holds (general).**  Filtering out the zero mode, the
genuine-corner mass form is exactly invariant under subdivision. -/
theorem subNat_projective (C : Cycle) :
    cornerSpectrum (subdivide C) = cornerSpectrum C := by
  simp [cornerSpectrum, subdivide, turnPow, flipPow, passThrough]

/-! ### 4c. SUB-NAT-RENORMALIZED — pre-registered claim + kill

We must fix *which* renormalization before computing (Pro's patch).  Two
candidates, pre-registered:

* **corner-count** renormalization: average turn power over genuine corners;
* **vertex-count** renormalization: average turn power over all vertices
  (pass-throughs included).

Claim: the renormalized mass form is invariant.
Kill condition: the chosen average changes under subdivision.
**Result: the corner-count renormalization is invariant (TRUE); the naive
vertex-count renormalization is NOT (FALSE).**  Hence subdivision covariance
selects the "count only genuine corners as modes" rule — the load-bearing
outcome flagged in Gap 3. -/

/-- Vertex-count renormalized mass form: mean turn power over *all* vertices. -/
def avgAllVertices (C : Cycle) : ℚ := (massSpectrum C).sum / C.length

/-- Corner-count renormalized mass form: mean turn power over *genuine corners*. -/
def avgCorners (C : Cycle) : ℚ :=
  (cornerSpectrum C).sum / (cornerSpectrum C).length

/-- **SUB-NAT-RENORMALIZED (corner-count) holds (general).**  Because the
genuine-corner spectrum is subdivision-invariant, so is its mean. -/
theorem subNat_renorm_corners (C : Cycle) :
    avgCorners (subdivide C) = avgCorners C := by
  unfold avgCorners; rw [subNat_projective]

/-- The tetrahedral 3-cycle: three corners at pairwise tetrahedral angle. -/
def tet3 : Cycle := [tetX, tetX, tetX]

/-- **SUB-NAT-RENORMALIZED (vertex-count) is FALSE — falsifying certificate.**
On the tetrahedral 3-cycle the naive vertex-count average drops from `2/3` to
`1/2` under a single subdivision (the pass-through dilutes the mean). -/
theorem subNat_renorm_allVertices_fails :
    avgAllVertices (subdivide tet3) ≠ avgAllVertices tet3 := by
  simp only [avgAllVertices, massSpectrum, subdivide, tet3, turnPow, flipPow,
    passThrough, tetX, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    List.length_cons, List.length_nil]
  norm_num

/-- Concrete corner-count value on the tetrahedral 3-cycle, before and after
subdivision: both equal `2/3`. -/
theorem avgCorners_tet3 : avgCorners tet3 = 2/3 := by
  simp only [avgCorners, cornerSpectrum, tet3, turnPow, flipPow,
    tetX, List.map_cons, List.map_nil]
  norm_num [List.filter, List.sum_cons, List.sum_nil]

/-- Concrete vertex-count values on the tetrahedral 3-cycle: `2/3` before,
`1/2` after subdivision. -/
theorem avgAllVertices_tet3 :
    avgAllVertices tet3 = 2/3 ∧ avgAllVertices (subdivide tet3) = 1/2 := by
  constructor <;>
  · simp only [avgAllVertices, massSpectrum, subdivide, tet3, turnPow, flipPow,
      passThrough, tetX, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
      List.length_cons, List.length_nil]
    norm_num

/-! ## 5. Outcome table (the pre-registered three-way SUB-NAT result)

Encapsulated as one theorem so the packet can cite a single fact.

| notion            | claim                                   | result | witness / kill                     |
|-------------------|-----------------------------------------|--------|------------------------------------|
| SUB-NAT-STRICT    | raw mass form invariant                 | FALSE  | `subNat_strict_fails`              |
| SUB-NAT-PROJECTIVE| genuine-corner mass form invariant      | TRUE   | `subNat_projective`                |
| SUB-NAT-RENORM    | corner-count mean invariant             | TRUE   | `subNat_renorm_corners`            |
| SUB-NAT-RENORM    | vertex-count mean invariant             | FALSE  | `subNat_renorm_allVertices_fails`  |

Interpretation (Fable's outcome table): under **strict** equality *neither*
bookkeeping is subdivision-natural (the zero mode appears regardless of B1/B2),
so naive subdivision is not a carrier assumption; the surviving invariant is the
genuine-corner (projective / corner-renormalized) mass form.  This is
bookkeeping-independent, so SUB-NAT does **not** by itself decide B1 vs B2 — the
`kappa` decider stays with probe P1 (`kappaB2_tet` / `kappaB1_tet`).  The
continuum limit is therefore owned by the refinement category that counts only
genuine corners, not by naive edge subdivision. -/

/-- The full pre-registered SUB-NAT outcome, bundled. -/
theorem subNat_outcome_table :
    (∀ C : Cycle, massSpectrum (subdivide C) ≠ massSpectrum C) ∧
    (∀ C : Cycle, cornerSpectrum (subdivide C) = cornerSpectrum C) ∧
    (∀ C : Cycle, avgCorners (subdivide C) = avgCorners C) ∧
    (avgAllVertices (subdivide tet3) ≠ avgAllVertices tet3) :=
  ⟨subNat_strict_fails, subNat_projective, subNat_renorm_corners,
    subNat_renorm_allVertices_fails⟩

end PhysicsSM.Draft.NullEdge.Carrier.KoideSubNat
