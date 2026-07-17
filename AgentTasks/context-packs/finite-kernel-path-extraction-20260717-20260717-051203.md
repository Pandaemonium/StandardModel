# Aristotle semantic context pack

Generated: 2026-07-17T05:12:22
Query: `nonzero finite matrix power entry extracts explicit primitive kernel path strict transitive past null link chain`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/overnight-null-information-run-2026-07-10/ARISTOTLE_PROMPT_codex_checkerboard_pathsum_transfer_power_01.md` [Codex proof job: exact path-sum equals transfer-matrix power]

Score: `0.796`

```text
# Codex proof job: exact path-sum equals transfer-matrix power

Close every proof in `PathTransfer/Core.lean` without changing definitions,
matrix orientation, theorem statements, coefficients, or assumptions. The main
theorem must derive the finite direction-history sum as the corresponding
matrix element of the `n`th transfer power. Preserve the outgoing-step phase
convention and the exact nonzero value `85` in the two-step fixture.

This is the missing derived arrow from scalar checkerboard history composition
to operator evolution. It is finite and exact. Do not claim the Fourier
momentum dictionary, the existing complex unitary split-step walk, a continuum
propagator, or a path integral measure until those are separately composed.

Run `lake env lean PathTransfer/Core.lean`. Return the complete file, helper
lemmas used, and any orientation/convention issue discovered.

Context pack:
`AgentTasks/context-packs/checkerboard-pathsum-transfer-power-20260710-20260710-000458.md`.

Project: `18f119a4-7469-4e93-a592-d3342605e5d4`
Status at launch: RUNNING
Submission: `AgentTasks/aristotle-submit/codex-checkerboard-pathsum-transfer-power-20260710-01-project`
```

### 2. `PhysicsSM/NullStrand/Histories/ExteriorMassMeasure.lean` [massCapacity_i3_eq_zero]

Score: `0.784`

```text
]; ring

/-- **Finite strong-positivity obstruction kernel.** A positive-semidefinite
`2×2` Hermitian matrix whose `(0,0)` entry is zero must have its `(0,1)` entry
zero.  This is the linear-algebra heart of the no-go: with vanishing singleton
diagonals, strong positivity forces all off-diagonal singleton entries (hence,
by additivity, the whole functional) to vanish. -/
```

### 3. `AgentTasks/null-edge-graph-plaquette-curvature-aristotle-2026-07-15.md` [Harvested result]

Score: `0.782`

```text
## Harvested result

Aristotle independently confirmed the nilpotent inverse formulas, the
later-edges-on-the-left `transportFrom` multiplication order, closure of
`0 -> 1 -> 2 -> 3 -> 0`, and the exact matrix

```text
[[1-h^2, -h^3],
 [h^3, 1+h^2+h^4]].
```

For that orientation, the genuine group loop is
`U_B^-1 U_A^-1 U_B U_A`, so its coefficient is exactly `-[A,B]`; the positive
`[A,B]` coefficient belongs to the separate additive two-path difference.
Area positivity holds at every refinement index, the residual converges
componentwise in the finite matrix topology, and the target is genuinely
nonzero. The audit found no vacuity, hollow telescoping, false shape, theorem
statement change, or remaining proof hole.

Two docstrings were narrowed in the live file. The helper reported an apparent
signature change only because the returned copy line-wrapped and shortened
fully qualified `#print axioms` commands; inspection of the exact diff and
audit report confirmed that no declaration signature changed, so the returned
source was not applied wholesale.

Full audit report:

```text
AgentTasks/aristotle-output/fa964306-2870-4d92-a789-9ffc1e53761d/extracted/project-files.tar/null-edge-graph-plaquette-curvature-20260715-project_aristotle/AgentTasks/null-edge-graph-plaquette-curvature-audit-report-2026-07-15.md
```
```

### 4. `PhysicsSM/Draft/NullEdge/Carrier/CarrierPontryaginWitness.lean` [Gamma]

Score: `0.780`

```text
noncomputable def Gamma : V →ₗ[ℂ] V := Matrix.toEuclideanLin GammaMat

/-- The null-transport matrix `diag(0,0,1,1)`: kernel = the `Γ = +1` chirality
sector. -/
```

### 5. `PhysicsSM/Draft/NullEdge/Carrier/WardGradedFrameDecoration.lean` [nullFrameAction]

Score: `0.778`

```text
def nullFrameAction (U : Mat3) : Matrix (Fin 2) (Fin 2) Complex :=
  nullP * U * nullI

/-- The nilpotent charge restricted to the ordered two-step flag. -/
```

### 6. `PhysicsSM/Draft/NullEdge/Carrier/RGSchurMassWitness.lean` [nullN]

Score: `0.778`

```text
def nullN : Matrix (Fin 2) (Fin 2) ℂ := !![0, 0; 1, 0]

/-- `nullL` is a null (square-zero) edge term. -/
```

### 7. `PhysicsSM/Draft/NullEdge/ChannelCommutatorSelectorClassification.lean` [selector_factors_through_trace]

Score: `0.776`

```text
theorem selector_factors_through_trace (f : N →ₗ[ℚ] ℚ)
    (hf : CommutatorBlind f) (X : N) :
    f X = (f 1 / 4) * Matrix.trace X := by
  have hdiag (i : Fin 4) : f (matrixUnit i i) = f 1 / 4 := by
    have hsum : f 1 = 4 * f (matrixUnit i i) := by
      calc
        f 1 = f (∑ j : Fin 4, Matrix.single j j (1 : ℚ)) := by
          rw [Matrix.sum_single_one]
        _ = ∑ j : Fin 4, f (matrixUnit j j) := by
          simp [matrixUnit]
        _ = ∑ _j : Fin 4, f (matrixUnit i i) := by
          apply Finset.sum_congr rfl
          intro j _hj
          exact diag_selector_equal f hf j i
        _ = 4 * f (matrixUnit i i) := by norm_num
    linarith
  induction X using Matrix.induction_on' with
  | h_zero => simp
  | h_add A B hA hB =>
      rw [map_add, hA, hB, Matrix.trace_add]
      ring
  | h_std_basis i j x =>
      have hsingle : Matrix.single i j x = x • matrixUnit i j := by
        simp [matrixUnit]
      rw [hsingle, map_smul]
      by_cases hij : i = j
      · subst j
        rw [hdiag]
        simp [matrixUnit]
        ring
      · rw [offDiag_selector_zero f hf hij]
        simp [matrixUnit, hij]

/-- A concrete nonzero direction in the kernel of trace. -/
```

### 8. `PhysicsSM/Draft/NullEdge/CheckerboardPathSumTransferPower.lean`

Score: `0.775`

```text
import Mathlib

/-!
# Exact checkerboard path sum as a transfer-matrix power

This module proves that the finite sum over all two-direction histories, with
one turn weight and one outgoing phase per step, is exactly the corresponding
matrix element of the transfer operator raised to the history length. The
two-step integer fixture is nonzero and order-sensitive enough to exclude a
straight-only or diagonal-transfer collapse.

This is a finite combinatorial identity. It does not yet identify the transfer
with a unitary Dirac walk, perform a Fourier transform, or prove a continuum
PDE limit.

Provenance: clean-room statement prepared after the 2026-07-10 literature pass
on checkerboard and quantum-walk path sums; proof returned by Aristotle project
`18f119a4-7469-4e93-a592-d3342605e5d4` and locally reviewed.
-/
```

## Scoped paper hits

### 1. An analysis of completely-positive trace-preserving maps on M2

Score: `0.730`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 2. Matching number, Hamiltonian graphs and magnetic Laplacian matrices

Score: `0.724`
Zotero key: `GNEARI9Q`
arXiv: `2010.08828`
DOI: `10.1016/j.laa.2022.02.006`
URL: https://doi.org/10.1016/j.laa.2022.02.006

### 3. Locality properties of Neuberger's lattice Dirac operator

Score: `0.717`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 4. Localized States for Elementary Systems

Score: `0.715`
Zotero key: `74NU4C33`
DOI: `10.1103/revmodphys.21.400`
URL: https://doi.org/10.1103/revmodphys.21.400

### 5. Tri-partitions and Bases of an Ordered Complex

Score: `0.706`
Zotero key: `D7352JCI`
DOI: `10.1007/s00454-020-00188-x`
URL: https://doi.org/10.1007/s00454-020-00188-x
