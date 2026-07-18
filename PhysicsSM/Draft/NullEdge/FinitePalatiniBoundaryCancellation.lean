import PhysicsSM.Draft.NullEdge.FinitePalatiniEinsteinHilbertVariation

/-!
# Finite null-edge Palatini boundary cancellation

The previous Palatini bridge isolates the integrated identity

```text
sum_x volume(x) delta R(x)
  = sum_x volume(x) <Ric(x), h(x)> + boundary.
```

This module derives the zero-boundary case from a graph-local residual. On a
finite directed carrier, define the incidence divergence of an edge flux as
incoming minus outgoing flux. Every edge appears once at its target and once
at its source, so the total divergence vanishes exactly. More generally, the
same incidence operator obeys an exact summation-by-parts identity.

Consequently, if the local scalar-curvature response satisfies

```text
volume(x) delta R(x)
  = volume(x) <Ric(x), h(x)> + div(flux)(x),
```

then the finite integrated Palatini identity holds with zero boundary response
on the closed carrier. This removes the global boundary premise from the
action-to-Einstein theorem. The local Ricci-plus-divergence identity itself is
still a curvature-variation obligation for the null-edge connection.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FinitePalatiniBoundaryCancellation

open scoped BigOperators
open EinsteinEquationVariation
open StressEnergyPhysicalControls
open LocalEinsteinEquationVariation
open FiniteEinsteinHilbertActionResponse
open FinitePalatiniEinsteinHilbertVariation

variable {Vertex Edge : Type*} [Fintype Vertex] [Fintype Edge]
  [DecidableEq Vertex]

/-- Directed finite-edge gradient of a scalar vertex field. -/
def edgeGradient
    (source target : Edge -> Vertex)
    (field : Vertex -> Real) (edge : Edge) : Real :=
  field (target edge) - field (source edge)

/-- Incidence divergence: total incoming flux minus total outgoing flux at a
vertex. Edge weights, orientations, and connection factors may be absorbed
into `flux`. -/
def incidenceDivergence
    (source target : Edge -> Vertex)
    (flux : Edge -> Real) (vertex : Vertex) : Real :=
  ∑ edge : Edge,
    ((if target edge = vertex then flux edge else 0) -
      (if source edge = vertex then flux edge else 0))

/-- **Closed-carrier divergence theorem.** Total incidence divergence vanishes
on every finite directed carrier. -/
theorem sum_incidenceDivergence_eq_zero
    (source target : Edge -> Vertex) (flux : Edge -> Real) :
    (∑ vertex : Vertex,
      incidenceDivergence source target flux vertex) = 0 := by
  classical
  unfold incidenceDivergence
  rw [Finset.sum_comm]
  apply Finset.sum_eq_zero
  intro edge _
  rw [Finset.sum_sub_distrib]
  simp

/-- Exact finite summation by parts for the incidence gradient and divergence.
-/
theorem sum_field_mul_incidenceDivergence
    (source target : Edge -> Vertex)
    (field : Vertex -> Real) (flux : Edge -> Real) :
    (∑ vertex : Vertex,
      field vertex * incidenceDivergence source target flux vertex) =
      ∑ edge : Edge, edgeGradient source target field edge * flux edge := by
  classical
  calc
    (∑ vertex : Vertex,
        field vertex * incidenceDivergence source target flux vertex) =
        ∑ vertex : Vertex, ∑ edge : Edge,
          field vertex *
            ((if target edge = vertex then flux edge else 0) -
              (if source edge = vertex then flux edge else 0)) := by
          simp only [incidenceDivergence, Finset.mul_sum]
    _ = ∑ edge : Edge, ∑ vertex : Vertex,
          field vertex *
            ((if target edge = vertex then flux edge else 0) -
              (if source edge = vertex then flux edge else 0)) := by
          rw [Finset.sum_comm]
    _ = ∑ edge : Edge,
          (field (target edge) * flux edge -
            field (source edge) * flux edge) := by
          apply Finset.sum_congr rfl
          intro edge _
          simp only [mul_sub]
          simp
    _ = ∑ edge : Edge,
          edgeGradient source target field edge * flux edge := by
          apply Finset.sum_congr rfl
          intro edge _
          unfold edgeGradient
          ring

/-- Local Palatini residual represented as the incidence divergence of an edge
flux. -/
def HasPointwisePalatiniDivergence
    (source target : Edge -> Vertex)
    (volume curvatureResponse : Vertex -> Real)
    (ricci variation : LocalTensor (Site := Vertex))
    (flux : Edge -> Real) : Prop :=
  forall vertex,
    volume vertex * curvatureResponse vertex =
      volume vertex *
          metricVariationPairing (ricci vertex) (variation vertex) +
        incidenceDivergence source target flux vertex

/-- **Local-to-global finite Palatini theorem.** A pointwise
Ricci-plus-divergence response satisfies the integrated zero-boundary Palatini
identity. -/
theorem pointwisePalatiniDivergence_implies_finitePalatini
    (source target : Edge -> Vertex)
    (volume curvatureResponse : Vertex -> Real)
    (ricci variation : LocalTensor (Site := Vertex))
    (flux : Edge -> Real)
    (hPointwise : HasPointwisePalatiniDivergence source target volume
      curvatureResponse ricci variation flux) :
    HasFinitePalatiniCurvatureResponse volume ricci variation
      curvatureResponse 0 := by
  unfold HasFinitePalatiniCurvatureResponse weightedLocalMetricPairing
  calc
    (∑ vertex : Vertex, volume vertex * curvatureResponse vertex) =
        ∑ vertex : Vertex,
          (volume vertex *
              metricVariationPairing (ricci vertex) (variation vertex) +
            incidenceDivergence source target flux vertex) := by
          apply Finset.sum_congr rfl
          intro vertex _
          exact hPointwise vertex
    _ = (∑ vertex : Vertex,
          volume vertex *
            metricVariationPairing (ricci vertex) (variation vertex)) +
        ∑ vertex : Vertex,
          incidenceDivergence source target flux vertex := by
          rw [Finset.sum_add_distrib]
    _ = (∑ vertex : Vertex,
          volume vertex *
            metricVariationPairing (ricci vertex) (variation vertex)) + 0 := by
          rw [sum_incidenceDivergence_eq_zero]

/-! ## Nonzero closed-carrier witness -/

/-- The unique edge of the two-vertex witness points from `0` to `1`. -/
def witnessSource (_ : Fin 1) : Fin 2 := 0

def witnessTarget (_ : Fin 1) : Fin 2 := 1

def witnessFlux (_ : Fin 1) : Real := 1

/-- The witness incidence divergence is nonzero locally and cancels globally.
-/
theorem witness_incidenceDivergence_values :
    incidenceDivergence witnessSource witnessTarget witnessFlux 0 = -1 ∧
      incidenceDivergence witnessSource witnessTarget witnessFlux 1 = 1 ∧
      (∑ vertex : Fin 2,
        incidenceDivergence witnessSource witnessTarget witnessFlux vertex) =
        0 := by
  constructor
  · norm_num [incidenceDivergence, witnessSource, witnessTarget, witnessFlux,
      Fin.sum_univ_one]
  constructor
  · norm_num [incidenceDivergence, witnessSource, witnessTarget, witnessFlux,
      Fin.sum_univ_one]
  · exact sum_incidenceDivergence_eq_zero witnessSource witnessTarget witnessFlux

/-- A nonzero local Palatini residual satisfying the closed-carrier identity.
The Ricci pairing is zero in this algebraic witness, while the curvature
response is exactly the nonzero incidence divergence. -/
theorem nonzero_pointwisePalatini_witness :
    HasPointwisePalatiniDivergence witnessSource witnessTarget
        (fun _ : Fin 2 => 1)
        (fun vertex =>
          incidenceDivergence witnessSource witnessTarget witnessFlux vertex)
        (fun _ : Fin 2 => (0 : Tensor (I := Fin 4)))
        (fun _ : Fin 2 => (0 : Tensor (I := Fin 4))) witnessFlux ∧
      incidenceDivergence witnessSource witnessTarget witnessFlux 0 = -1 ∧
      incidenceDivergence witnessSource witnessTarget witnessFlux 1 = 1 ∧
      HasFinitePalatiniCurvatureResponse
        (fun _ : Fin 2 => 1)
        (fun _ : Fin 2 => (0 : Tensor (I := Fin 4)))
        (fun _ : Fin 2 => (0 : Tensor (I := Fin 4)))
        (fun vertex =>
          incidenceDivergence witnessSource witnessTarget witnessFlux vertex)
        0 := by
  have hPointwise : HasPointwisePalatiniDivergence witnessSource witnessTarget
      (fun _ : Fin 2 => 1)
      (fun vertex =>
        incidenceDivergence witnessSource witnessTarget witnessFlux vertex)
      (fun _ : Fin 2 => (0 : Tensor (I := Fin 4)))
      (fun _ : Fin 2 => (0 : Tensor (I := Fin 4))) witnessFlux := by
    intro vertex
    unfold StressEnergyPhysicalControls.metricVariationPairing
    simp
  exact ⟨hPointwise, witness_incidenceDivergence_values.1,
    witness_incidenceDivergence_values.2.1,
    pointwisePalatiniDivergence_implies_finitePalatini witnessSource
      witnessTarget (fun _ : Fin 2 => 1)
      (fun vertex =>
        incidenceDivergence witnessSource witnessTarget witnessFlux vertex)
      (fun _ : Fin 2 => (0 : Tensor (I := Fin 4)))
      (fun _ : Fin 2 => (0 : Tensor (I := Fin 4))) witnessFlux hPointwise⟩

/-! ## Action endpoint with graph-local Palatini data -/

/-- A decomposed finite action whose curvature response satisfies the local
Ricci-plus-incidence-divergence identity in every symmetric metric direction.
-/
def HasIncidencePalatiniEinsteinHilbertMatterFirstVariation
    (source target : Edge -> Vertex)
    (action : LocalTensor (Site := Vertex) -> Real)
    (baseMetric : LocalTensor (Site := Vertex))
    (kappa : Real) (volume scalarCurvature : Vertex -> Real)
    (ricci metric stress : LocalTensor (Site := Vertex))
    (cosmologicalConstant : Real)
    (volumeResponse curvatureResponse :
      LocalTensor (Site := Vertex) -> Vertex -> Real)
    (fluxResponse : LocalTensor (Site := Vertex) -> Edge -> Real) : Prop :=
  forall variation : LocalTensor (Site := Vertex),
    LocalSymmetric variation ->
      HasInverseMetricVolumeResponse volume (volumeResponse variation)
          metric variation ∧
        HasPointwisePalatiniDivergence source target volume
          (curvatureResponse variation) ricci variation
          (fluxResponse variation) ∧
        HasDerivAt
          (fun t : Real => action (baseMetric + t • variation))
          (normalizedEinsteinHilbertMatterResponse kappa
            (finiteEinsteinHilbertBulkResponse volume
              (volumeResponse variation) scalarCurvature
              (curvatureResponse variation) cosmologicalConstant)
            volume stress variation) 0

/-- **Closed null-edge action to Einstein equation.** The graph-local
Ricci-plus-divergence identity discharges the zero-boundary Palatini premise,
so stationarity of the genuine decomposed action is equivalent to the
pointwise finite Einstein equation. -/
theorem incidencePalatiniActionStationary_iff_localFiniteEinsteinEquation
    (source target : Edge -> Vertex)
    (action : LocalTensor (Site := Vertex) -> Real)
    (baseMetric : LocalTensor (Site := Vertex))
    (kappa : Real) (volume scalarCurvature : Vertex -> Real)
    (ricci metric stress : LocalTensor (Site := Vertex))
    (cosmologicalConstant : Real)
    (volumeResponse curvatureResponse :
      LocalTensor (Site := Vertex) -> Vertex -> Real)
    (fluxResponse : LocalTensor (Site := Vertex) -> Edge -> Real)
    (hVolume : forall vertex, volume vertex ≠ 0)
    (hRicci : LocalSymmetric ricci) (hMetric : LocalSymmetric metric)
    (hStress : LocalSymmetric stress) (hKappa : Not (kappa = 0))
    (hFirstVariation :
      HasIncidencePalatiniEinsteinHilbertMatterFirstVariation source target
        action baseMetric kappa volume scalarCurvature ricci metric stress
        cosmologicalConstant volumeResponse curvatureResponse fluxResponse) :
    LocalActionMetricStationary action baseMetric <->
      LocalFiniteEinsteinEquation kappa ricci scalarCurvature metric
        cosmologicalConstant stress := by
  apply decomposedActionStationary_iff_localFiniteEinsteinEquation action
    baseMetric kappa volume scalarCurvature ricci metric stress
    cosmologicalConstant volumeResponse curvatureResponse hVolume hRicci
    hMetric hStress hKappa
  intro variation hVariation
  obtain ⟨hVolumeResponse, hPointwise, hDerivative⟩ :=
    hFirstVariation variation hVariation
  exact ⟨hVolumeResponse,
    pointwisePalatiniDivergence_implies_finitePalatini source target volume
      (curvatureResponse variation) ricci variation (fluxResponse variation)
      hPointwise,
    hDerivative⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePalatiniBoundaryCancellation.sum_field_mul_incidenceDivergence' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sum_field_mul_incidenceDivergence

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePalatiniBoundaryCancellation.pointwisePalatiniDivergence_implies_finitePalatini' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pointwisePalatiniDivergence_implies_finitePalatini

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePalatiniBoundaryCancellation.nonzero_pointwisePalatini_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonzero_pointwisePalatini_witness

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePalatiniBoundaryCancellation.incidencePalatiniActionStationary_iff_localFiniteEinsteinEquation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms incidencePalatiniActionStationary_iff_localFiniteEinsteinEquation

end PhysicsSM.Draft.NullEdge.FinitePalatiniBoundaryCancellation
