import PhysicsSM.Draft.NullEdge.HNUExactCore

/-!
# Exact HNU endpoint winding integral

This file states the published `T^3 -> SU(2) ~= S^3` coordinate formula and its
normalized three-dimensional winding integral.  Unlike a local Weyl-Jacobian
certificate, the final theorem is the actual global endpoint invariant used in
the Higashikawa-Nakagawa-Ueda single-Weyl construction.

The intended proof has four independently useful rungs:

1. identify the exact matrix endpoint with the published four real coordinates;
2. prove those coordinates lie on the unit three-sphere;
3. prove the cube boundary is sent to the south pole;
4. evaluate the normalized oriented-volume integral as `1`.

Provenance: S. Higashikawa, M. Nakagawa, and M. Ueda, "Floquet chiral magnetic
effect", Phys. Rev. Lett. 123, 066403 (2019), arXiv:1806.06868, Supplemental
Material section "Nontriviality of U(k) as a map from T^3 to SU(2)", equations
for `u_1,...,u_4` and the winding integral.  Formula transcribed from the
official arXiv source archive.  No external code is copied.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.HNUWindingIntegral

open HNUExactCore

noncomputable section

/-- The four real coordinates `(u1,u2,u3,u4)` of the exact HNU endpoint. -/
def hnuCoord (k : Fin 3 -> Real) : Fin 4 -> Real :=
  ![-Real.sin (k 0) * Real.cos (k 1 / 2) ^ 2 * Real.cos (k 2 / 2) ^ 2,
    -(Real.cos (k 0 / 2) ^ 2 * Real.sin (k 1) * Real.cos (k 2 / 2)) +
      (1 / 2 : Real) * Real.sin (k 0) * Real.cos (k 1 / 2) ^ 2 * Real.sin (k 2),
    -((1 / 2 : Real) * Real.sin (k 0) * Real.sin (k 1) * Real.cos (k 2 / 2)) -
      Real.cos (k 0 / 2) ^ 2 * Real.cos (k 1 / 2) ^ 2 * Real.sin (k 2),
    2 * Real.cos (k 0 / 2) ^ 2 * Real.cos (k 1 / 2) ^ 2 *
      Real.cos (k 2 / 2) ^ 2 - 1]

/-- Convert four sphere coordinates to the corresponding `SU(2)` matrix. -/
def coordMatrix (u : Fin 4 -> Real) : M2 :=
  (u 3 : Complex) • (1 : M2) + I •
    ((u 0 : Complex) • HNUExactCore.σ1 +
      (u 1 : Complex) • HNUExactCore.σ2 +
      (u 2 : Complex) • HNUExactCore.σ3)

/-- The source's coordinate formula is exactly the live depth-eight endpoint. -/
theorem endpoint_eq_coordMatrix (k : Fin 3 -> Real) :
    endpoint k = coordMatrix (hnuCoord k) := by
  sorry

/-- The four published coordinate functions land on the unit three-sphere. -/
theorem hnuCoord_sphere (k : Fin 3 -> Real) :
    Finset.univ.sum (fun i : Fin 4 => hnuCoord k i ^ 2) = 1 := by
  sorry

/-- If any momentum coordinate is on a cube face, the coordinate map is the
south pole `(0,0,0,-1)`. -/
theorem hnuCoord_boundary (k : Fin 3 -> Real)
    (hface : ∃ i, k i = Real.pi ∨ k i = -Real.pi) :
    hnuCoord k = ![0, 0, 0, -1] := by
  sorry

/-- Partial derivative in the first momentum coordinate. -/
def partial0 (k : Fin 3 -> Real) : Fin 4 -> Real :=
  deriv (fun x : Real => hnuCoord ![x, k 1, k 2]) (k 0)

/-- Partial derivative in the second momentum coordinate. -/
def partial1 (k : Fin 3 -> Real) : Fin 4 -> Real :=
  deriv (fun y : Real => hnuCoord ![k 0, y, k 2]) (k 1)

/-- Partial derivative in the third momentum coordinate. -/
def partial2 (k : Fin 3 -> Real) : Fin 4 -> Real :=
  deriv (fun z : Real => hnuCoord ![k 0, k 1, z]) (k 2)

/-- Matrix whose columns are `u`, `partial_1 u`, `partial_2 u`, and
`partial_3 u`.  Its determinant is the oriented `S^3` volume density. -/
def orientedFrame (k : Fin 3 -> Real) : Matrix (Fin 4) (Fin 4) Real :=
  fun i => ![hnuCoord k i, partial0 k i, partial1 k i, partial2 k i]

def windingDensity (k : Fin 3 -> Real) : Real := (orientedFrame k).det

/-- The exact nested integral over the Brillouin cube. -/
def windingIntegral : Real :=
  intervalIntegral (fun x : Real =>
    intervalIntegral (fun y : Real =>
      intervalIntegral (fun z : Real => windingDensity ![x, y, z])
        (-Real.pi) Real.pi MeasureTheory.volume)
      (-Real.pi) Real.pi MeasureTheory.volume)
    (-Real.pi) Real.pi MeasureTheory.volume

/-- The normalized HNU three-dimensional endpoint winding. -/
def windingNumber : Real := (1 / (2 * Real.pi ^ 2)) * windingIntegral

/-- **Published global invariant.**  The exact HNU endpoint has winding one. -/
theorem windingNumber_eq_one : windingNumber = 1 := by
  sorry

end

end PhysicsSM.Draft.NullEdge.HNUWindingIntegral
