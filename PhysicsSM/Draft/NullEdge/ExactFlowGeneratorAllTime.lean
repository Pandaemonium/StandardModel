import PhysicsSM.Draft.NullEdge.ExactFlowGenerator
import PhysicsSM.Draft.NullEdge.ExactFlowL2GroupCapstone

/-!
# All-time pointwise generator of the exact Dirac momentum flow

This module strengthens `ExactFlowGenerator.momMult_apply_hasDerivAt_zero` from
zero to arbitrary time. It remains pointwise in the momentum fibre and spinor.
It is not a derivative in the Schwartz topology, a derivative of an `L2`
equivalence class, a graph-domain theorem, or a position-space PDE.

The derivative uses the repository's right-multiplication group orientation
`d/dt U(t) v = U(t) (G v)`, with fibre generator
`G = toEuclideanCLM (-i H(k))`.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.ExactFlowGeneratorAllTime

open ChangingCellFourierL2
open ChangingCellFourierPDE
open ChangingCellScaledLiveWalk
open Compact3Plus1DiracRate
open ExactFlowGenerator

/--
At every fixed momentum, mass, time, and spinor, the exact multiplier orbit is
differentiable with the right-oriented generator action.
-/
theorem momMult_apply_hasDerivAt (m t : Real) (k : FourierMomentum3)
    (v : ChangingCellScaledLiveWalk.Spinor) :
    HasDerivAt (fun s : Real => momMult m s k v)
      (momMult m t k
        (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)
          (fibreGenerator (k 0) (k 1) (k 2) m) v)) t := by
  let generatorVector : ChangingCellScaledLiveWalk.Spinor :=
    Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)
      (fibreGenerator (k 0) (k 1) (k 2) m) v
  have hzero : HasDerivAt (fun s : Real => momMult m s k v)
      generatorVector 0 := by
    exact ExactFlowGenerator.momMult_apply_hasDerivAt_zero m k v
  let T : ChangingCellScaledLiveWalk.Spinor →L[Real]
      ChangingCellScaledLiveWalk.Spinor :=
    (momMult m t k).restrictScalars Real
  have hcomposed :
      HasDerivAt (fun s : Real => T (momMult m s k v))
        (T generatorVector) 0 :=
    (T.hasFDerivAt).comp_hasDerivAt 0 hzero
  have hshifted :
      HasDerivAt (fun s : Real => momMult m (t + s) k v)
        (momMult m t k generatorVector) 0 := by
    simpa [T, ExactFlowL2GroupCapstone.momMult_add_time] using hcomposed
  have hshifted' :
      HasDerivAt (fun s : Real => momMult m (t + s) k v)
        (momMult m t k generatorVector) (t - t) := by
    simpa using hshifted
  have htranslated := hshifted'.comp_sub_const t t
  simpa [generatorVector] using htranslated

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowGeneratorAllTime.momMult_apply_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms momMult_apply_hasDerivAt

end PhysicsSM.Draft.NullEdge.ExactFlowGeneratorAllTime
