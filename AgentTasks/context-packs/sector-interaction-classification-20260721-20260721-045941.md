# Aristotle semantic context pack

Generated: 2026-07-21T04:59:50
Query: `finite interaction Hamiltonian commutes with selected sector projector block diagonal exponential preserves sector Pluecker pair transfer`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/GateYM.lean` [in]

Score: `0.844`

```text
ansfer matrix, Hamiltonian, or spectral-gap theorem);
`TransferHilbertZ2Electric` (YM3/Q2-Q3 concrete adapter: the base Z2 electric
center-shift generators from `FluxSectorZ2` form the `ShiftSystem` used by
`TransferHilbertBlockShift`; any block weight depending on positive, cut, and
mirror configurations only through their full plaquette-bit fields is invariant
under simultaneous base shifts, so its `rpBlockMatrix` commutes with the block
shifts and the finite OS range is preserved. The file also defines the
four-term block electric-sector projection, proves that it lands in the
requested block electric sector, fixes exactly the vectors in that sector, is
idempotent, is mutually orthogonal on distinct sectors, sums to the identity
over the four Z2 block electric sectors, and preserves the finite OS range for
plaquette-field block weights. It also names the sectorized finite OS range
submodule `rpBlockElectricSector` and proves that the block electric projection
lands in it for vectors already in the plaquette-field OS range, packaged as
the onto linear map `rpBlockElectricSectorProjection`, with explicit
linear inclusion/retraction data and an idempotent endomorphism of the finite
OS range; the sector endomorphisms annihilate across distinct Z2 sectors and
sum to the identity on the finite OS range, and each endomorphism range is
characterized as the matching sectorized finite OS submodule; distinct
sectorized finite OS submodules are disjoint; and their supremum is the whole
plaquette-field finite OS range. It also packages the four-sector product,
the linear decomposition/reconstruction maps, the two inverse identities
between that product and the finite OS range, and the resulting named
`LinearEquiv`; the equivalence gives the corresponding finrank additivity
formul
```

### 2. `AgentTasks/aristotle-downloads/f0d38cd0-cdec-46ef-800b-b588e3e07740/output-final_aristotle/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex` [Formal verification and negative controls]

Score: `0.835`

```text
},
\texttt{witnessPairKick\_preserves\_fockInner},
\texttt{witnessPairKickLinearEquiv}
 & \NewResult{} \Kernel{} & the normalized Pluecker-phase pair kick is a complex-linear automorphism, exactly reversible, and preserves the finite Fock inner product\\
\texttt{quarticPairTransfer\_isHermitian},
\texttt{pairKick\_eq\_quartic\_add\_offPair}
 & \NewResult{} \Kernel{} & the rank-two quartic transfer is Hermitian and is exactly the kick on the pair sector, with identity action off it\\
\texttt{pairKick\_singleton},
\texttt{witnessPairKick\_two\_particle\_nontrivial}
 & \NewResult{} \Kernel{} & the kick fixes every one-particle basis state but acts nontrivially on the explicit two-particle state\\
\texttt{quarticPairTransfer\_sq\_eq\_project}
 & \NewResult{} \Kernel{} & at unit phase the Hermitian quartic squares exactly to its rank-two pair-sector projector\\
\texttt{bKickL\_CARSupported},
\texttt{heisenStep\_CARSupported},
\texttt{heisenFoldBlocks\_CARSupported}
 & \NewResult{} \Kernel{} & the placed even quartic pair gate is strongly CAR-supported on its declared four-mode set, and every finite unit-phase schedule enlarges support only by the union of acted sets; no metric cone is claimed\\
\texttt{bKickL\_commute\_disjoint},
\texttt{witBlock\_forward\_amplitude},
\texttt{witBlocks\_commute}
 & \NewResult{} \Kernel{} & disjoint placed pair gates commute exactly, while the normalized $3+4\ii$ phase gives a nonzero transfer amplitude inside the acted block\\
\texttt{witness\_conjugate\_restOperators},
\texttt{doubleKick\_return\_amplitude}
 & \NewResult{} \Kernel{} & equal-modulus fields $3+4\ii$ and $5$ have exactly conjugate rest operators, while the two-kick loop returns the pair with amplitude $u_2\overline{u_1}$\\
\texttt{doubleKick\_interference\_amplitude},
\texttt{
```

### 3. `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex` [Formal verification and negative controls]

Score: `0.835`

```text
},
\texttt{witnessPairKick\_preserves\_fockInner},
\texttt{witnessPairKickLinearEquiv}
 & \NewResult{} \Kernel{} & the normalized Pluecker-phase pair kick is a complex-linear automorphism, exactly reversible, and preserves the finite Fock inner product\\
\texttt{quarticPairTransfer\_isHermitian},
\texttt{pairKick\_eq\_quartic\_add\_offPair}
 & \NewResult{} \Kernel{} & the rank-two quartic transfer is Hermitian and is exactly the kick on the pair sector, with identity action off it\\
\texttt{pairKick\_singleton},
\texttt{witnessPairKick\_two\_particle\_nontrivial}
 & \NewResult{} \Kernel{} & the kick fixes every one-particle basis state but acts nontrivially on the explicit two-particle state\\
\texttt{quarticPairTransfer\_sq\_eq\_project}
 & \NewResult{} \Kernel{} & at unit phase the Hermitian quartic squares exactly to its rank-two pair-sector projector\\
\texttt{bKickL\_CARSupported},
\texttt{heisenStep\_CARSupported},
\texttt{heisenFoldBlocks\_CARSupported}
 & \NewResult{} \Kernel{} & the placed even quartic pair gate is strongly CAR-supported on its declared four-mode set, and every finite unit-phase schedule enlarges support only by the union of acted sets; no metric cone is claimed\\
\texttt{bKickL\_commute\_disjoint},
\texttt{witBlock\_forward\_amplitude},
\texttt{witBlocks\_commute}
 & \NewResult{} \Kernel{} & disjoint placed pair gates commute exactly, while the normalized $3+4\ii$ phase gives a nonzero transfer amplitude inside the acted block\\
\texttt{witness\_conjugate\_restOperators},
\texttt{doubleKick\_return\_amplitude}
 & \NewResult{} \Kernel{} & equal-modulus fields $3+4\ii$ and $5$ have exactly conjugate rest operators, while the two-kick loop returns the pair with amplitude $u_2\overline{u_1}$\\
\texttt{doubleKick\_interference\_amplitude},
\texttt{
```

### 4. `AgentTasks/fourday-ym-run-2026-07-05/LEDGER.md` [Heartbeat log (append-only: `<day>.<HH:MM> <agent> <task> <next-step>`)]

Score: `0.831`

```text
lected Z2 block electric sector. This is finite algebraic sector bookkeeping only, with no physical transfer matrix, Hamiltonian, Wilson slab-kernel, or gap claim.
2.48:05 codex T2/T3 integrated `mem_rpBlockElectricSector_iff_rpHilbertSpaceBlockElectricProjection_eq_self`; direct TransferHilbertZ2Electric and aggregator checks, targeted T2/T3 build, aggregate GateYM build (8090 jobs), code escape-hatch scan, diff hygiene, and axiom audit `[propext, Classical.choice, Quot.sound]` passed. T2/T3 released; still no physical transfer matrix, Hamiltonian, Wilson slab-kernel, or gap claim.
3.00:02 codex T2/T3 claimed finite OS sector-kernel/complement API in `TransferHilbertZ2Electric.lean`: package the kernel side of the ambient sector endomorphism using the already-proved four-sector decomposition, still as finite algebraic Q2/Q3 infrastructure only.
3.00:30 codex T2/T3 integrated `rpHilbertSpaceOtherBlockElectricProjection`, `rpHilbertSpaceBlockElectricProjection_add_other_eq_id`, the two cross-composition-zero lemmas, and `ker_rpHilbertSpaceBlockElectricProjection_eq_range_other`; direct TransferHilbertZ2Electric check, aggregator check, targeted T2/T3 build, aggregate GateYM build (8090 jobs), code escape-hatch scan, diff hygiene, and axiom audit `[propext, Classical.choice, Quot.sound]` passed. T2/T3 released; still no physical transfer matrix, Hamiltonian, Wilson slab-kernel, or gap claim.
3.10:03 codex T2/T3 claimed complementary finite OS sector projection API: prove the other-sector sum is idempotent and characterize its fixed points/range by the selected sector endomorphism's kernel, with no physical transfer/Hamiltonian/gap claim.
3.10:42 codex T2/T3 integrated `mem_range_rpHilbertSpaceOtherBlockElectricProjection_iff`, `rpHilbertSpaceOtherBlockElectricProjection_e
```

### 5. `AgentTasks/fourday-ym-run-2026-07-05/DISCUSSION.md` [note:t2-q3-block-electric-projection]

Score: `0.831`

```text
## note:t2-q3-block-electric-projection

Codex 1.17:07:

Added `TransferHilbertZ2Electric.blockElectricSectorProjection`, the four-term
base-electric projection on the block-index function space
`(cut configuration, positive/mirror configuration) -> Complex`.

The new theorem
`blockElectricSectorProjection_preserves_rpHilbertSpace_z2PlaquetteBlock`
proves that this projection preserves
`rpHilbertSpace (rpBlockMatrix (plaquetteTripleWeight F))`. The proof uses the
already-landed preservation of the OS range by each base x/y block shift and
closes under finite linear combinations inside the submodule.

Scope boundary: this is the Q2/Q3 finite OS-range sector infrastructure for
plaquette-field block weights. It does not construct the physical Wilson
transfer matrix and does not assert a spectral or mass-gap result.
```

### 6. `PhysicsSM/Draft/NullEdge/GateYM/TransferHilbertZ2Electric.lean` [blockElectricSectorProjection_preserves_rpHilbertSpace_z2PlaquetteBlock]

Score: `0.831`

```text
theorem blockElectricSectorProjection_preserves_rpHilbertSpace_z2PlaquetteBlock
    {Lx Ly : Nat} [DecidableEq (FluxSectorZ2.TorusLinkField Lx Ly)]
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (F : (Fin Lx -> Fin Ly -> Bool) ->
      (Fin Lx -> Fin Ly -> Bool) ->
      (Fin Lx -> Fin Ly -> Bool) -> Complex)
    (ex ey : Bool) :
    ∀ v, v ∈
        rpHilbertSpace (rpBlockMatrix (plaquetteTripleWeight F)) ->
      blockElectricSectorProjection hLx hLy ex ey v ∈
        rpHilbertSpace (rpBlockMatrix (plaquetteTripleWeight F)) := by
  classical
  intro v hv
  let S :=
    blockShiftSystem
      (baseElectricShiftSystem hLx hLy)
      (baseElectricShiftSystem hLx hLy)
  let M := rpHilbertSpace (rpBlockMatrix (plaquetteTripleWeight F))
  have hx : shiftOp S BaseElectricShift.x v ∈ M :=
    shiftOp_preserves_rpHilbertSpace_z2PlaquetteBlock
      hLx hLy F BaseElectricShift.x v hv
  have hy : shiftOp S BaseElectricShift.y v ∈ M :=
    shiftOp_preserves_rpHilbertSpace_z2PlaquetteBlock
      hLx hLy F BaseElectricShift.y v hv
  have hxy : shiftOp S BaseElectricShift.y
      (shiftOp S BaseElectricShift.x v) ∈ M :=
    shiftOp_preserves_rpHilbertSpace_z2PlaquetteBlock
      hLx hLy F BaseElectricShift.y (shiftOp S BaseElectricShift.x v) hx
  have hproj :
      blockElectricSectorProjection hLx hLy ex ey v =
        (1 / 4 : Complex) •
          (v +
            FluxSectorZ2.TorusLinkField.z2Character ex •
              shiftOp S BaseElectricShift.x v +
            FluxSectorZ2.TorusLinkField.z2Character ey •
              shiftOp S BaseElectricShift.y v +
            (FluxSectorZ2.TorusLinkField.z2Character ex *
              FluxSectorZ2.TorusLinkField.z2Character ey) •
              shiftOp S BaseElectricShift.y
                (shiftOp S BaseElectricShift.x v)) := by
    funext i
```

### 7. `AgentTasks/fourday-ym-run-2026-07-05/LEDGER.md` [Heartbeat log (append-only: `<day>.<HH:MM> <agent> <task> <next-step>`)]

Score: `0.826`

```text
plaquette-field finite OS range has positive finrank exactly when at least one of the four Z2 block electric sectors has positive finrank; finite bookkeeping only, no physical transfer/gap claim.
2.17:20 codex T2/T3 integrated finite OS sector nontriviality iff: `finrank_rpHilbertSpace_pos_iff_exists_finrank_rpBlockElectricSector_pos`; direct TransferHilbertZ2Electric and aggregator checks, targeted T2/T3 build, aggregate GateYM build (8090 jobs), code escape-hatch scan, and axiom audit `[propext, Classical.choice, Quot.sound]` passed. T2/T3 released; still no physical transfer matrix, Hamiltonian, Wilson slab-kernel, or gap claim.
2.03:05 claude QMF5 DELIVERABLE-1 DOWN-PAYMENT (the RP-F N5 crux foundation): new GateYM/WilsonProjectors.lean - the Wilson spin projectors projPlus/projMinus = (1 -+ gamma_mu)/2 proved to be complementary ORTHOGONAL PROJECTORS: projPlus_idem, projMinus_idem (P^2=P via gamma_sq), projPlus_mul_projMinus + projMinus_mul_projPlus (=0, orthogonal), projPlus_add_projMinus (=1, complete), projPlus_herm + projMinus_herm (P^H=P via gamma_herm). This is the concrete algebraic heart of the fermionic-RP crux (node N5 of the QMF5 design DAG): the projector structure is exactly what turns the reflected cross-mirror Wilson coupling into a Gram (M^H M) form => PSD reflected block. Proved directly (module tactic after gamma_sq rewrite; conjTranspose_smul + gamma_herm + norm_num for hermiticity); tested on scratch first. Kernel-checked, 0 sorry, all 7 theorems axioms [propext, Classical.choice, Quot.sound]; GateYM aggregate green (8090 jobs). Self-contained down-payment; the remaining RP-F nodes (reflection unitary, positive-half selection, Berezin/measure wrap) need finite-lattice scaffolding (next QMF5 cycle). Claim label: finite identity. Next: commit; QMF
```

### 8. `AgentTasks/fourday-ym-run-2026-07-05/LEDGER.md` [Task board]

Score: `0.824`

```text
ultaneous-shift invariance. Codex added `TransferHilbertZ2Electric.lean`, instantiating the block shift system with `FluxSectorZ2` base electric shifts for plaquette-bit-field block weights; Codex then added the four-sector product carrier plus decomposition/reconstruction linear maps, two inverse identities, the packaged sector `LinearEquiv`, finrank additivity over the four sectors, sector-inclusion injectivity, each-sector finrank bound, ambient-positive-dimension iff, ambient-zero-dimension iff, the ambient sector endomorphism fixed-point characterization `mem_rpBlockElectricSector_iff_rpHilbertSpaceBlockElectricProjection_eq_self`, the sector-kernel/complement API `ker_rpHilbertSpaceBlockElectricProjection_eq_range_other`, complementary projection fixed-point/idempotence API `rpHilbertSpaceOtherBlockElectricProjection_eq_self_iff` / `rpHilbertSpaceOtherBlockElectricProjection_idempotent`, selected-vs-other range complement API `disjoint_range_rpHilbertSpaceBlockElectricProjection_other` / `sup_range_rpHilbertSpaceBlockElectricProjection_other_eq_top`, selected/other product linear equivalence `rpHilbertSpaceSelectedOtherLinearEquiv`, selected/other finrank additivity/positive/zero API, and selected-sector range identification/sector-finrank selected-other API. Aristotle audit `ba26fe81` is RUNNING; still no physical transfer matrix or gap claim |
| T3 D12 sector decomposition | Q3 | selected-sector-range-finrank-integrated-codex | - | PhysicsSM/Draft/NullEdge/GateYM/FluxSector*.lean, PhysicsSM/Draft/NullEdge/GateYM/TransferHilbertZ2Electric.lean, AgentTasks/fourday-ym-run-2026-07-05/DISCUSSION.md | magnetic Z2 support/projection layer landed; electric/center-shift spine plus concrete Z2 electric projections and abstract shift-invariant kernel preservation landed; `
```

## Scoped paper hits

### 1. An analysis of completely-positive trace-preserving maps on M2

Score: `0.735`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 2. Momentum bispinor, two-qubit entanglement and twistor space

Score: `0.731`
Zotero key: `3VBEK82X`
arXiv: `1407.2492`
URL: http://arxiv.org/abs/1407.2492

Abstract:

Re-examines massive momentum bispinor symmetry and connects unit-energy future-lightcone geometry with two-qubit entanglement and twistor-space normalization. Important prior-art guardrail for observer-conditioned Pluecker mixedness.

### 3. Von Neumann algebra automorphisms and time-thermodynamics relation in generally covariant quantum theories

Score: `0.728`
Zotero key: `I8XNBREW`
DOI: `10.1088/0264-9381/11/12/007`
URL: https://doi.org/10.1088/0264-9381/11/12/007

### 4. Modular Hamiltonians for Deformed Half-Spaces and the Averaged Null Energy Condition

Score: `0.723`
Zotero key: `B68T629C`
arXiv: `1605.08072`
DOI: `10.1007/JHEP09(2016)038`
URL: http://arxiv.org/abs/1605.08072

Abstract:

Derives a modular Hamiltonian term for deformed half-spaces and uses relative-entropy monotonicity to prove ANEC.

### 5. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.718`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548
