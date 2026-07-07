# Aristotle semantic context pack

Generated: 2026-07-06T22:55:58
Query: `one-form center symmetry finite center twist H2 K ZG Tomboulis Yaffe FluxSectorGeneral CenterFluxSector TYAreaLawSUN Generalized Global Symmetries`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/StandardModel/SpinorFockHypercharge.lean` [hypercharge6_cube_sum_zero]

Score: `0.755`

```text
theorem hypercharge6_cube_sum_zero :
    (∑ S ∈ (Finset.univ : Finset (Finset (Fin 5))).filter
      (fun S => S.card % 2 = 0), (fockHypercharge6 S) ^ 3) = 0 := by decide

/-- The hypercharge trace over the sixteen states vanishes
(gravitational-`U(1)_Y` anomaly). -/
```

### 2. `PhysicsSM/StandardModel/AnomalyCancellation.lean` [numberOfWeakDoublets]

Score: `0.754`

```text
def numberOfWeakDoublets : Nat := 4

/--
The Witten `SU(2)` global anomaly is absent because the number of weak
doublets is even.
-/
```

### 3. `AgentTasks/standardmodel-family-orbit-naturality-aristotle-2026-05-31.md` [Goal]

Score: `0.751`

```text
## Goal

Extend the generic family-symmetry naturality API with orbit-level helper
theorems: invariant functions and invariant charge tables have the same values
after one or two formal family transformations, and the GMN relation is stable
under these transformations.

This gives the paper a clean abstract theorem to cite before specializing to
triality or relabeled generation copies.
```

### 4. `PhysicsSM/Draft/NullEdgeYukawaMassOperator.lean` [higgsHypercharge]

Score: `0.751`

```text
def higgsHypercharge : HiggsInsertion -> Rat
  | .higgs => 1
  | .conjugateHiggs => -1

/-- The four one-generation Yukawa flip channels. -/
```

### 5. `PhysicsSM/Draft/NullEdgeYukawaFlip.lean` [hyperchargeDefect_eq_zero]

Score: `0.750`

```text
theorem hyperchargeDefect_eq_zero (v : YukawaFlip) :
    hyperchargeDefect v = 0 := by
  cases v <;>
    norm_num [hyperchargeDefect, leftMultiplet, rightMultiplet,
      higgsInsertionHypercharge, PhysicalMultiplet.hypercharge]

/--
Machine-readable claim boundary: this file checks only the `U(1)_Y` part of
Yukawa gauge legality.
-/
```

### 6. `PhysicsSM/Draft/SpinorTenfoldHyperchargeOpAristotle.lean` [hyperchargeCoeff]

Score: `0.745`

```text
def hyperchargeCoeff (i : Fin 5) : ℂ := ((indexHypercharge6 i : ℤ) : ℂ) / 6

/-- **The hypercharge generator** `Y = Σᵢ yᵢ ρ(eᵢ ∧ fᵢ)`: the explicit
element of the infinitesimal `so(10)` action realizing the physical
hypercharge on the `16`. It lies in the span of the `ρ` bivectors by
construction. -/
```

### 7. `PhysicsSM/Algebra/Furey/ElectroweakAnomalyBridge.lean` [completed_table_localAnomalyFree]

Score: `0.744`

```text
theorem completed_table_localAnomalyFree :
    LocalAnomalyFree (fureyDoubletTable ++ rightHandedSingletCompletion) := by
  rw [fureyDoubletTable_append_completion]
  exact standardModelOneGeneration_localAnomalyFree

/--
The completed table satisfies Witten's global SU(2) anomaly condition.
-/
```

### 8. `PhysicsSM/Draft/NullEdgeOvernightSynthesisAristotle.lean` [multiTwistorMassSqTraceConvention_eq_zero_iff_common_pi_direction]

Score: `0.744`

```text
theorem multiTwistorMassSqTraceConvention_eq_zero_iff_common_pi_direction
    {n : Nat} (Z : MultiTwistorChart n) (base : Fin n)
    (hbase : (Z.twistor base).pi 0 ≠ 0 ∨ (Z.twistor base).pi 1 ≠ 0) :
    multiTwistorMassSqTraceConvention Z = 0 ↔
      ∃ c : Fin n -> ℂ,
        ∀ i : Fin n, (Z.twistor i).pi = c i • (Z.twistor base).pi := by
  convert multiTwistorPairwiseMass_eq_zero_iff_common_pi_direction Z base hbase using 1;
  unfold multiTwistorMassSqTraceConvention; simp +decide [ mul_eq_zero ] ;
  rw [ multi_twistor_momentum_det_eq_pairwiseMass ]

/-! ## 4. Finite classifier for Standard-Model-like Yukawa legality -/

/-- A candidate finite Yukawa vertex before imposing legality. -/
```

## Scoped paper hits

### 1. Generalized Global Symmetries

Score: `0.789`
Zotero key: `AXAWAGGB`
arXiv: `1412.5148`
DOI: `10.1007/JHEP02(2015)172`
URL: http://arxiv.org/abs/1412.5148

Abstract:

A $q$-form global symmetry is a global symmetry for which the charged operators are of space-time dimension $q$; e.g. Wilson lines, surface defects, etc., and the charged excitations have $q$ spatial dimensions; e.g. strings, membranes, etc. Many of the properties of ordinary global symmetries ($q$=0) apply here. They lead to Ward identities and hence to selection rules on amplitudes. Such global symmetries can be coupled to classical background fields and they can be gauged by summing over these classical fields. These generalized global symmetries can be spontaneously broken (either completely or to a subgroup). They can also have 't Hooft anomalies, which prevent us from gauging them, but lead to 't Hooft anomaly matching conditions. Such anomalies can also lead to anomaly inflow on various defects and exotic Symmetry Protected Topological phases. Our analysis of these symmetries gives a new unified perspective of many known phenomena and uncovers new results.

### 2. Twisted geometries: A geometric parametrisation of SU(2) phase space

Score: `0.767`
Zotero key: `63MQ6KC3`
arXiv: `1001.2748v3`
URL: http://arxiv.org/abs/1001.2748v3

Abstract:

Twisted-geometry parametrization of SU(2) loop-gravity phase space, including face areas, normals, extrinsic angle, gauge-invariant reduced phase space, and connection to closure/geometricity constraints.

### 3. Hierarchies without symmetries from extra dimensions

Score: `0.757`
Zotero key: `M9KJ7UCN`
arXiv: `hep-ph/9903417`
DOI: `10.1103/PhysRevD.61.033005`
URL: https://doi.org/10.1103/physrevd.61.033005

### 4. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.745`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 5. CPT-Symmetric Universe

Score: `0.743`
Zotero key: `68R6TZ6X`
arXiv: `1803.08928`
DOI: `10.1103/PhysRevLett.121.251301`
URL: http://arxiv.org/abs/1803.08928
