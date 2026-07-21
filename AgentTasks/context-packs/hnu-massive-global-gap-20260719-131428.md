# Aristotle semantic context pack

Generated: 2026-07-19T13:14:38
Query: `HNU massive Floquet walk global zero pi quasienergy gap momentum reversal SU2 determinant Brillouin cube`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/HNUTransversePiComposite.lean`

Score: `0.818`

```text
import PhysicsSM.Draft.NullEdge.FloquetTransverseComposite
import PhysicsSM.Draft.NullEdge.HNUSU2FixedVectorCensus

/-!
# HNU selected sector with an explicit quasienergy-pi complement

This module instantiates `FloquetTransverseComposite.controlled` with the exact
HNU endpoint on the selected transverse line and `Vpi = -1` on its orthogonal
complement. It proves full finite-matrix unitarity and a state-level spectral
census: the selected sector has a nonzero `+1` eigenvector only at the origin,
while the complement supplies an explicit `-1` eigensector and no nonzero
`+1` eigenvector.

Provenance: clean-room integration of Aristotle project
`d82ea36b-490a-4e78-bc17-29e1aa3c96e9`, independently reviewed by
interactive Claude/Opus. The SU(2) rigidity step is reused from
`HNUSU2FixedVectorCensus` rather than duplicated.

Hard boundary: `Vpi = -1` is a momentum-space spectral control. It is not an
all-moving local update and does not prove primitive-null support, winding,
bulk-edge correspondence, anomaly inflow, or a physical domain wall.
-/
```

### 2. `PhysicsSM/Draft/NullEdge/FermionDoublingAudit.lean` [zero_mode]

Score: `0.814`

```text
theorem zero_mode : walkU 0 0 = 1 := by
  unfold walkU
  norm_num [← Matrix.one_fin_two]

/-- Target 2: the Floquet partner at zone-edge quasienergy `pi`. -/
```

### 3. `AutonomousLab/reviews/CLAUDE_REVIEW_Strict3Plus1Frontier_2026-07-13.md` [The single hole - and a REQUIRED STATEMENT REPAIR (the key finding)]

Score: `0.807`

```text
## The single hole - and a REQUIRED STATEMENT REPAIR (the key finding)

`admissible_doubling` (line 290, the only `sorry`): every `AdmissibleWalk` has a
second nonzero momentum with `det (U q - 1) = 0`.

Beyond being unproved, the statement as written is likely TOO STRONG / permits a
counterexample, exactly the risk to check: it demands the second crossing at
ZERO quasienergy (`det(U-1)=0`). But for a DISCRETE-TIME (Floquet/QCA) walk, the
Nielsen-Ninomiya balance runs over BOTH `0` and `pi` quasienergy sectors - the
doubler may appear at `pi` (`det(U+1)=0`), not `0`. The module's own
`body_center_persistent_crossings` (both `det(U-1)=0` and `det(U+1)=0` at the
body center) is direct evidence that `pi` crossings are physical here. An
admissible walk that routes its doubler entirely to `pi` quasienergy would then
FALSIFY `admissible_doubling` as stated while satisfying every `AdmissibleWalk`
hypothesis. (The `splitStepWalk` witness happens to double at `0` corners, so the
statement is not vacuous, but that does not make it universal.)

REQUIRED before any discharge attempt: broaden the conclusion to a Floquet
crossing at `0` OR `pi`:

```text
exists q != 0,  det (U q - 1) = 0  \/  det (U q + 1) = 0.
```

This is the honest discrete-time NN statement and is what `doubling_from_balance`
+ a chirality functional summed over the full (0-and-pi) crossing set can hope to
discharge. `AdmissibleWalk`'s hypotheses (unitary, periodic, continuous,
`U(0)=1`, `alpha`-tangents) are plausibly sufficient for the BROADENED statement
(standard NN), but are NOT sufficient for the current `0`-only statement.
```

### 4. `AutonomousLab/work/NE-3PLUS1/CODEX_ANOMALOUS_FLOQUET_3PLUS1_ROUTE_2026-07-13.md` [Why it fits null-edge physics]

Score: `0.806`

```text
## Why it fits null-edge physics

1. The fundamental object is already a discrete-time unitary update, not a
   static Hamiltonian.
2. A Floquet period naturally decomposes into local null microsteps, matching
   `NullMicrostepHyperdiamond` and the checkerboard ontology.
3. Zero and pi quasienergy are already separated by
   `FloquetTaggedCrossingBalance`.
4. `Strict3Plus1Frontier` identified the exact mistake in a zero-only static
   balance: compensation may live in the pi sector or the full unitary loop.
5. The existing factorized depth-one and symmetric depth-two candidates have
   zero loop winding; their doubling is therefore a control, not evidence
   against the anomalous route.
```

### 5. `AgentTasks/aristotle-downloads/f0d38cd0-cdec-46ef-800b-b588e3e07740/output-final_aristotle/CODEX_ANOMALOUS_FLOQUET_3PLUS1_ROUTE_2026-07-13.md` [Why it fits null-edge physics]

Score: `0.806`

```text
## Why it fits null-edge physics

1. The fundamental object is already a discrete-time unitary update, not a
   static Hamiltonian.
2. A Floquet period naturally decomposes into local null microsteps, matching
   `NullMicrostepHyperdiamond` and the checkerboard ontology.
3. Zero and pi quasienergy are already separated by
   `FloquetTaggedCrossingBalance`.
4. `Strict3Plus1Frontier` identified the exact mistake in a zero-only static
   balance: compensation may live in the pi sector or the full unitary loop.
5. The existing factorized depth-one and symmetric depth-two candidates have
   zero loop winding; their doubling is therefore a control, not evidence
   against the anomalous route.
```

### 6. `PhysicsSM/Draft/NullEdge/HNUExactCore.lean`

Score: `0.804`

```text
/-
# HNU exact single-Weyl Floquet core

Self-contained, Mathlib-only formalization of the field-free
Higashikawa–Nakagawa–Ueda (HNU) single-Weyl Floquet schedule described in
`HNU_SINGLE_WEYL_RECONSTRUCTION.md`.

Everything lives in `Matrix (Fin 2) (Fin 2) ℂ`, built from the explicit Pauli
matrices and the spin projectors `P_j^± = (σ₀ ± σ_j)/2`.

## Corrected sign convention (recorded prominently)

The paper's compact substep symbol `U_j^±(k) := P_j^± e^{-ik} + P_j^∓` is
internally inconsistent when read with a uniform `e^{-ik}` on both `±` labels.
The unique consistent reading ties the exponent sign to the `±` label:

* `U_j^+(k) = P_j^+ · e^{-i k} + P_j^-`
* `U_j^-(k) = P_j^- · e^{+i k} + P_j^+`

and the half-step analogues along axis 3 use `k₃/2`:

* `U_{h,3}^+(k₃) = P_3^+ · e^{-i k₃/2} + P_3^-`
* `U_{h,3}^-(k₃) = P_3^- · e^{+i k₃/2} + P_3^+`.

Here `·` is genuine scalar multiplication of a matrix by a complex number, and
`+` is matrix addition. All results below use these corrected symbols.

Ordering convention: in a matrix product the **rightmost factor acts first**;
`endpoint` writes the eight factors in the paper's Eq. (5) order.

Provenance: clean-room formalization returned by Aristotle job
`510857de-e789-4e2d-89ed-1f58044381dd`, based on the repository's independent
HNU reconstruction and corrected sign convention.  The exact endpoint,
trace, and zero/pi census are proved here.  The momentum-space winding,
continuum Weyl tangent, real-space locality, and primitive-null realization
are separate gates and are not consequences of this module alone.
-/
import Mathlib

open Matrix Complex
```

### 7. `AgentTasks/aristotle-downloads/73a1d386-9910-493b-84b2-1867bdf6ef2e/output-final_aristotle/HNU_SINGLE_WEYL_RECONSTRUCTION.md` [11. Verdict]

Score: `0.803`

```text
## 11. Verdict

- **Construction:** the field-free HNU single-Weyl Floquet model is
  reconstructed exactly (§§1–5), with all decisive properties confirmed: finite
  depth-8 strictly-local unitary schedule; a single `ε=0` Weyl node at `Γ` of
  charge `+1`; a complete `𝕋³` census (no second `ε=0` cone; `ε=π` degeneracy is
  the whole boundary); nonzero loop winding `W = 1`; consistency with the
  Bessho–Sato generalized balance.
- **No-go / scoped incompatibility:** the winding is carried by spin-conditioned
  shifts and **vanishes** for any spin-blind (unconditional null shift +
  on-site turn) factorization. Whether HNU counts as "primitive-null" hinges
  entirely on whether projector-conditioned nearest-neighbour shifts are
  admitted as primitives (§7).
- **Missing formula:** one sign-convention correction (§1.3, §10).
```

### 8. `PhysicsSM/Draft/NullEdge/HNUSU2MinusEigenvectorCensus.lean` [su2_neg_one_eigenvector_iff]

Score: `0.803`

```text
theorem su2_neg_one_eigenvector_iff {M : M2}
    (hU : M ∈ unitary M2) (hdet : M.det = 1) :
    (∃ v : Fin 2 → ℂ, v ≠ 0 ∧ M *ᵥ v = -v) ↔ M = -1 := by
  constructor
  · exact su2_neg_one_eigenvector_eq_neg_one hU hdet
  · intro hM
    refine ⟨![1, 0], e0_ne_zero, ?_⟩
    rw [hM]
    simp [Matrix.neg_mulVec, Matrix.one_mulVec]

/-! ## HNU quasienergy-pi census -/

/-- On the closed momentum cube, the HNU endpoint has a nonzero `-1`
eigenvector exactly on a boundary face `k_i = pi` or `k_i = -pi`. -/
```

## Scoped paper hits

### 1. Dirac quantum walk on tetrahedra

Score: `0.741`
Zotero key: `8RZQA73D`
arXiv: `2404.09840`
DOI: `10.1103/physreva.110.042418`
URL: http://arxiv.org/abs/2404.09840

### 2. Dirac equation with an ultraviolet cutoff and a quantum walk

Score: `0.740`
Zotero key: `G7NXEZBU`
DOI: `10.1103/physreva.81.012314`

### 3. Twisted geometries: A geometric parametrisation of SU(2) phase space

Score: `0.733`
Zotero key: `63MQ6KC3`
arXiv: `1001.2748v3`
URL: http://arxiv.org/abs/1001.2748v3

Abstract:

Twisted-geometry parametrization of SU(2) loop-gravity phase space, including face areas, normals, extrinsic angle, gauge-invariant reduced phase space, and connection to closure/geometricity constraints.

### 4. On Dirac Zero Modes in Hyperdiamond Model

Score: `0.730`
Zotero key: `PRQ4QRZZ`
arXiv: `1103.1316`
URL: https://www.zotero.org/19894138/items/PRQ4QRZZ

Abstract:

Using the SU(5) symmetry of the 4D hyperdiamond and results on 4D graphene, engineers a class of 4D lattice QCD fermions whose Dirac operators have two zero modes. The zero modes are captured by a tensor Omega_mu^l with 4x5 complex components linking the Euclidean SO(4) vector index and the 5-dimensional representation of SU(5). The Borici-Creutz and Karsten-Wilczek models and their Dirac zero modes are rederived as particular realizations of Omega_mu^l.

### 5. Fermion confinement via Quantum Walks in 2D+1 and 3D+1 spacetime

Score: `0.730`
Zotero key: `E6B5QHJE`
arXiv: `1612.08027`
DOI: `10.1103/PhysRevA.95.042112`
URL: https://www.zotero.org/19894138/items/E6B5QHJE

Abstract:

We analyze the properties of a two- and three-dimensional quantum walk that are inspired by the idea of a brane-world model put forward by Rubakov and Shaposhnikov [Phys. Lett. B 125, 136 (1983)PYLBAJ0370-269310.1016/0370-2693(83)91253-4]. In that model, particles are dynamically confined on the brane due to the interaction with a scalar field. We translated this model into an alternate quantum walk with a coin that depends on the external field, with a dependence which mimics a domain wall solution. As in the original model, fermions (in our case, the walker) become localized in one of the dimensions, not from the action of a random noise on the lattice (as in the case of Anderson localization) but from a regular dependence in space. On the other hand, the resulting quantum walk can move freely along the “ordinary” dimensions.
