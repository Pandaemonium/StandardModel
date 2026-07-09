import Mathlib

/-!
# A finite Levinson theorem: bound states = scattering-phase winding

This file delivers two results from the "null-edge mass" program (Conjecture L):

1. `finite_optical_theorem` — the **finite optical theorem** (companion M-target).
   For a finite unitary walk S-matrix `S = !![r, t'; t, r']`, unitarity `Sᴴ * S = 1`
   forces probability conservation `|r|² + |t|² = 1` (and `|t'|² + |r'|² = 1`) together
   with the phase relation `conj r * t' + conj t * r' = 0`.  This is fully general (any
   complex `2 × 2` unitary) and faithful.

2. `finite_levinson` — the **finite Levinson equality** on an explicit rational fixture.
   On a concrete barrier fixture we prove
   `#{bound states} = winding of arg(det S(θ)) = reflection-sector index`,
   with every quantity a finite, kernel-checked computation.

## The Levinson fixture (mathematical content)

For a finite unitary scattering system the scattering determinant `det S(θ)`, viewed on
the quasi-energy circle `θ ↦ e^{iθ} =: z`, is (up to a positive real factor) a finite
**Blaschke product**
`B(z) = ∏_i (z - a_i) / (1 - conj(a_i) · z)`, `|a_i| < 1`,
which is the ratio of Jost functions.  Its zeros `a_i` inside the unit disk are exactly
the **bound states** of the barrier, and the argument principle says the winding number
of `θ ↦ B(e^{iθ})` around `0` equals the number of such zeros.  This is the discrete
Levinson correspondence: *scattering-phase winding = bound-state count*.

We make this a finite, `decide`-checkable computation by:

* sampling the quasi-energy circle at `12` explicit points (`zs`), scaled to radius `10`
  so all coordinates are Gaussian integers (the winding number is scale-invariant);
* representing each Blaschke center `a_i` by the Gaussian integer `A_i = 10 · a_i`
  (`bfCenters`), so `|a_i| < 1 ↔ |A_i|² < 100`;
* computing `det S(θ_j)` up to a positive real factor via `blaschkeProd` (Gaussian-integer
  arithmetic — positive real normalizing factors do not change the winding);
* computing the winding number as a genuine **discrete phase-increment sum**: the signed
  count of crossings of a reference ray by the sampled polygonal loop
  (`windingPos` for the `+x` ray, `windingNeg` for the `−x` / reflection reference ray).

The three quantities are defined by *genuinely different* formulas:

* `levWindingDet` — winding of `det S` via crossings of the `+x` ray (analytic/topological);
* `levBoundCount` — number of Blaschke zeros inside the disk (spectral);
* `levReflIndex` — winding via crossings of the `−x` (reflection) ray (the reflection sector).

`finite_levinson` proves all three coincide on the fixture.  See `ARISTOTLE_SUMMARY.md`
for an honest account of what generalizes and what stays fixture-specific.
-/

open scoped BigOperators
open Matrix

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

/-! ## 1. The finite optical theorem (general `2 × 2` unitary) -/

/-- **Finite optical theorem.**  For any complex `2 × 2` scattering matrix
`S = !![r, t'; t, r']` that is unitary (`Sᴴ * S = 1`), one has probability conservation
in both channels and the reflection/transmission phase relation. -/
theorem finite_optical_theorem (r t t' r' : ℂ)
    (S : Matrix (Fin 2) (Fin 2) ℂ) (hS : S = !![r, t'; t, r'])
    (hU : Sᴴ * S = 1) :
    Complex.normSq r + Complex.normSq t = 1 ∧
    Complex.normSq t' + Complex.normSq r' = 1 ∧
    (starRingEnd ℂ) r * t' + (starRingEnd ℂ) t * r' = 0 := by
  subst hS
  have h00 := congrFun (congrFun hU 0) 0
  have h11 := congrFun (congrFun hU 1) 1
  have h01 := congrFun (congrFun hU 0) 1
  simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.conjTranspose_apply] at h00 h11 h01
  refine ⟨?_, ?_, h01⟩
  · have h : ((Complex.normSq r : ℂ) + (Complex.normSq t : ℂ)) = 1 := by
      rw [Complex.normSq_eq_conj_mul_self, Complex.normSq_eq_conj_mul_self]
      exact_mod_cast h00
    exact_mod_cast h
  · have h : ((Complex.normSq t' : ℂ) + (Complex.normSq r' : ℂ)) = 1 := by
      rw [Complex.normSq_eq_conj_mul_self, Complex.normSq_eq_conj_mul_self]
      exact_mod_cast h11
    exact_mod_cast h

/-! ## 2. Finite winding numbers over Gaussian-integer samples

Complex numbers are represented as pairs of integers (`GZ`), i.e. Gaussian integers, so
that all scattering data are exact and every winding number is a kernel-checkable finite
computation. -/

/-- Gaussian integers `ℤ[i]`, used to hold scattering data exactly. -/
abbrev GZ := ℤ × ℤ

/-- Complex multiplication on Gaussian integers. -/
def gmul (p q : GZ) : GZ := (p.1 * q.1 - p.2 * q.2, p.1 * q.2 + p.2 * q.1)

/-- Complex conjugation on Gaussian integers. -/
def gconj (p : GZ) : GZ := (p.1, -p.2)

/-- Complex subtraction on Gaussian integers. -/
def gsub (p q : GZ) : GZ := (p.1 - q.1, p.2 - q.2)

/-- The `12` quasi-energy samples `e^{iθ_j}` on the circle, scaled to radius `10` so that
the coordinates are Gaussian integers.  They run counter-clockwise once around the circle
(each consecutive pair subtends roughly `30°`, small enough to resolve the winding of the
degree-`≤ 4` scattering determinants considered here). -/
def zs : List GZ :=
  [(10, 0), (8, 6), (6, 8), (0, 10), (-6, 8), (-8, 6),
   (-10, 0), (-8, -6), (-6, -8), (0, -10), (6, -8), (8, -6)]

/-- Signed crossing of the **positive** `x`-axis by the directed edge `p → q`
(`+1` for a counter-clockwise crossing, `−1` for clockwise, `0` for none).  The
`x`-intercept sign is read off from the cross product `p.1*q.2 - q.1*p.2`. -/
def edgeCrossPos (p q : GZ) : ℤ :=
  let cross := p.1 * q.2 - q.1 * p.2
  if p.2 < 0 ∧ 0 ≤ q.2 ∧ cross > 0 then 1
  else if q.2 < 0 ∧ 0 ≤ p.2 ∧ cross < 0 then -1 else 0

/-- Signed crossing of the **negative** `x`-axis (the reflection reference ray) by the
directed edge `p → q`, with the orientation convention chosen so that a counter-clockwise
loop is counted `+1`. -/
def edgeCrossNeg (p q : GZ) : ℤ :=
  let cross := p.1 * q.2 - q.1 * p.2
  if p.2 < 0 ∧ 0 ≤ q.2 ∧ cross < 0 then -1
  else if q.2 < 0 ∧ 0 ≤ p.2 ∧ cross > 0 then 1 else 0

/-- Winding number of the closed sampled loop `ps` around the origin, computed as the
discrete phase-increment sum of signed crossings of the `+x` ray. -/
def windingPos (ps : List GZ) : ℤ :=
  ((ps.zip (ps.rotateLeft 1)).map (fun pq => edgeCrossPos pq.1 pq.2)).sum

/-- Winding number of the closed sampled loop `ps` around the origin, computed via the
`−x` (reflection) reference ray.  Equals `windingPos ps` for genuine loops; used as the
reflection-sector index. -/
def windingNeg (ps : List GZ) : ℤ :=
  ((ps.zip (ps.rotateLeft 1)).map (fun pq => edgeCrossNeg pq.1 pq.2)).sum

/-! ## 3. The Blaschke / Jost scattering determinant

For a center `a = A / 10` with Gaussian-integer numerator `A` (so `|a| < 1 ↔ |A|² < 100`),
the Blaschke factor `(z - a)/(1 - conj(a)·z)` has, on the unit circle, the same argument as
`(z' - A) · conj(100 - conj(A)·z')` where `z' = 10 z` (positive real factors are dropped, as
they do not affect the winding).  `blaschkeProd` multiplies these factor directions. -/

/-- Direction of the Blaschke factor with center `A/10`, evaluated at the scaled sample `z`
(coordinates are `10 ×` the true point).  Positive real normalizations are dropped. -/
def blaschkeFactor (A z : GZ) : GZ :=
  gmul (gsub z A) (gsub (100, 0) (gmul A (gconj z)))

/-- Direction of the finite Blaschke product with the given centers, i.e. the scattering
determinant `det S(θ)` up to a positive real factor. -/
def blaschkeProd (cs : List GZ) (z : GZ) : GZ :=
  cs.foldl (fun acc A => gmul acc (blaschkeFactor A z)) (1, 0)

/-! ## 4. The concrete Levinson fixture -/

/-- The barrier fixture: three Blaschke centers `a_i = A_i / 10`, namely
`0.5`, `0.3 i`, and `-0.2 + 0.2 i`, all strictly inside the unit disk — hence three bound
states. -/
def bfCenters : List GZ := [(5, 0), (0, 3), (-2, 2)]

/-- The sampled scattering determinant `det S(θ_j)` (up to positive real factor). -/
def detSamples : List GZ := zs.map (blaschkeProd bfCenters)

/-- Winding of the scattering phase `arg(det S(θ))`, via the `+x` ray. -/
def levWindingDet : ℤ := windingPos detSamples

/-- Number of bound states = Blaschke zeros strictly inside the unit disk. -/
def levBoundCount : ℕ := (bfCenters.filter (fun A => A.1 ^ 2 + A.2 ^ 2 < 100)).length

/-- Reflection-sector index: winding of the scattering phase via the `−x` (reflection)
reference ray. -/
def levReflIndex : ℤ := windingNeg detSamples

/-- **Finite Levinson theorem (fixture).**  On the concrete barrier fixture `bfCenters`,
the number of bound states equals the winding of the scattering phase `arg(det S(θ))` over
the quasi-energy circle, which in turn equals the reflection-sector index.  All three are
finite, kernel-checked computations. -/
theorem finite_levinson :
    levWindingDet = (levBoundCount : ℤ) ∧
    levWindingDet = levReflIndex ∧
    levBoundCount = 3 := by
  refine ⟨?_, ?_, ?_⟩ <;> decide

/-- Sanity/robustness check: the same correspondence on a *different* fixture with two
inside centers gives winding = bound count = reflection index = `2`. -/
theorem finite_levinson_two :
    let cs : List GZ := [(4, 0), (0, -5)]
    let ds : List GZ := zs.map (blaschkeProd cs)
    windingPos ds = ((cs.filter (fun A => A.1 ^ 2 + A.2 ^ 2 < 100)).length : ℤ) ∧
    windingPos ds = windingNeg ds ∧
    (cs.filter (fun A => A.1 ^ 2 + A.2 ^ 2 < 100)).length = 2 := by
  refine ⟨?_, ?_, ?_⟩ <;> decide

/-! ## 5. Axiom-footprint guards -/

-- Kernel-checked footprint guards (expected: [propext, Classical.choice, Quot.sound]).
#print axioms finite_optical_theorem
#print axioms finite_levinson
#print axioms finite_levinson_two
