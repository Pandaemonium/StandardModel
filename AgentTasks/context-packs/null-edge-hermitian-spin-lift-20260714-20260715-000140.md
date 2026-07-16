# Aristotle semantic context pack

Generated: 2026-07-15T00:01:47
Query: `Hermitian Pauli SL2C sign pair local spin lift Minkowski determinant null-edge tetrad spin structure boundary`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/HermitianSpinLiftBoundary.lean`

Score: `0.876`

```text
import PhysicsSM.NullStrand.Conventions
import PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary

/-!
# Hermitian local spin-lift boundary

This module closes the interpretation gap identified in the first local sign
witness. The trusted `PhysicsSM.NullStrand.Conventions` module already supplies
the `(+---)` Pauli/Hermitian lift, its determinant/Minkowski-norm identity, and
determinant preservation under `SL(2, C)` congruence.

Here the actual Hermitian action is

```text
X |-> A X A^dagger.
```

It preserves Hermitian matrices. The matrices `A` and `-A` have the same action,
and in dimension two they have the same determinant. On spinors their actions
differ by a sign, hence differ whenever the transformed spinor is nonzero.

This is the local algebra underlying the kernel `{+1,-1}` of the standard
spin-to-Lorentz map. It does not prove that every proper orthochronous Lorentz
transformation has a lift, identify the full kernel as a group theorem,
construct compatible lifts on graph edges and faces, or establish a global spin
```

### 2. `PhysicsSM/Draft/NullEdge/HermitianSpinLiftBoundary.lean` [localHermitianSpinSignBoundary]

Score: `0.855`

```text
theorem localHermitianSpinSignBoundary
    (A : Matrix (Fin 2) (Fin 2) ℂ) (hA : A.det = 1)
    (p : Minkowski4) (psi : Fin 2 -> ℂ)
    (hpsi : spinorAction A psi ≠ 0) :
    (-A).det = 1 ∧
    hermitianLorentzAction (-A) (pauliHermitianEquiv p) =
      hermitianLorentzAction A (pauliHermitianEquiv p) ∧
    (hermitianLorentzAction A (pauliHermitianEquiv p)).IsHermitian ∧
    (hermitianLorentzAction A (pauliHermitianEquiv p)).det =
      (minkowskiSq p : ℂ) ∧
    spinorAction (-A) psi ≠ spinorAction A psi := by
  obtain ⟨hnegDet, hsame, hHermitian, hnorm⟩ :=
    sl2_sign_pair_minkowski_action A hA p
  exact ⟨hnegDet, hsame, hHermitian, hnorm,
    sl2_sign_pair_spinor_actions_ne A psi hpsi⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HermitianSpinLiftBoundary.sl2_sign_pair_minkowski_action' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HermitianSpinLiftBoundary.sl2_sign_pair_minkowski_action

/-- info: 'PhysicsSM.Draft.NullEdge.HermitianSpinLiftBoundary.localHermitianSpinSignBoundary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HermitianSpinLiftBoundary.localHermitianSpinSignBoundary

end PhysicsSM.Draft.NullEdge.HermitianSpinLiftBoundary
```

### 3. `PhysicsSM/Draft/NullEdge/TetradSpinReconstructionBoundary.lean`

Score: `0.842`

```text
import PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry

/-!
# Tetrad and spin reconstruction boundary

This module records two local nonuniqueness facts that a graph-to-GR
reconstruction must respect.

First, a metric does not select a unique coframe.  An explicit nonidentity
rational transformation preserves the four-dimensional mostly-minus form
`diag(1, -1, -1, -1)`.  Acting on the identity coframe therefore produces a
distinct nondegenerate coframe with exactly the same induced metric.  A
reconstruction can at most select a Lorentz-gauge class unless it supplies a
gauge choice or additional structure.

Second, the two matrices `S` and `-S`, paired with inverse candidates `SInv`
and `-SInv`, induce the same matrix-conjugation action but opposite actions on
spinors. The explicit determinant-one identity witness shows that this central
sign algebra is nonvacuous. Interpreting it as the local sign ambiguity of a
Lorentz spin lift additionally requires the Hermitian-matrix realization of
Minkowski vectors and the standard `SL(2, C)` covering action; neither is
constructed here.

These are finite local algebraic boundary theorems.  They do not establish the
existence of a tetrad, derive a tetrad from a bare graph, construct a global
spin structure, or discharge the topological obstruction to a spin lift.
-/

open Matrix
```

### 4. `PhysicsSM/Draft/NullEdge/HermitianSpinLiftBoundary.lean` [sl2_sign_pair_spinor_actions_ne]

Score: `0.830`

```text
theorem sl2_sign_pair_spinor_actions_ne
    (A : Matrix (Fin 2) (Fin 2) ℂ) (psi : Fin 2 -> ℂ)
    (hpsi : spinorAction A psi ≠ 0) :
    spinorAction (-A) psi ≠ spinorAction A psi := by
  rw [spinorAction_neg]
  exact neg_ne_self.mpr hpsi

/-- **Local Hermitian spin-sign boundary.** The sign pair is invisible on the
Pauli/Hermitian Minkowski action, preserves the Minkowski determinant, and is
visible on every spinor with nonzero transformed image. -/
```

### 5. `PhysicsSM/Draft/NullEdge/TetradSpinReconstructionBoundary.lean` [spinLift_sign_witness]

Score: `0.816`

```text
theorem spinLift_sign_witness :
    ∃ (S SInv : Matrix (Fin 2) (Fin 2) ℂ) (psi : Fin 2 -> ℂ),
      S.det = 1 ∧
      (-S).det = 1 ∧
      SInv * S = 1 ∧
      S * SInv = 1 ∧
      (-SInv) * (-S) = 1 ∧
      (-S) * (-SInv) = 1 ∧
      (∀ X, vectorConjugation (-S) (-SInv) X =
        vectorConjugation S SInv X) ∧
      spinorAction (-S) psi ≠ spinorAction S psi := by
  exact ⟨spinIdentity, spinIdentity, up,
    spinIdentity_and_neg_det.1, spinIdentity_and_neg_det.2,
    spinIdentity_inverse, spinIdentity_inverse,
    negSpinIdentity_inverse, negSpinIdentity_inverse,
    fun X => vectorConjugation_neg spinIdentity spinIdentity X,
    spinIdentity_actions_ne⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.metric_does_not_fix_coframe_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.metric_does_not_fix_coframe_witness

/-- info: 'PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.vectorConjugation_neg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.vectorConjugation_neg

/-- info: 'PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.spinorAction_neg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.spinorAction_neg

/-- info: 'PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.spinLift_sign_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Physics
```

### 6. `PhysicsSM/Draft/NullEdge/HermitianSpinLiftBoundary.lean` [sl2_sign_pair_minkowski_action]

Score: `0.814`

```text
theorem sl2_sign_pair_minkowski_action
    (A : Matrix (Fin 2) (Fin 2) ℂ) (hA : A.det = 1)
    (p : Minkowski4) :
    (-A).det = 1 ∧
    hermitianLorentzAction (-A) (pauliHermitianEquiv p) =
      hermitianLorentzAction A (pauliHermitianEquiv p) ∧
    (hermitianLorentzAction A (pauliHermitianEquiv p)).IsHermitian ∧
    (hermitianLorentzAction A (pauliHermitianEquiv p)).det =
      (minkowskiSq p : ℂ) := by
  refine ⟨?_, hermitianLorentzAction_neg A _, ?_, ?_⟩
  · rw [neg_det_eq_det, hA]
  · exact hermitianLorentzAction_isHermitian A _
      (pauliHermitianEquiv_isHermitian p)
  · rw [hermitianLorentzAction]
    exact (sl2_congruence_preserves_det A (pauliHermitianEquiv p) hA).trans
      (hermitian_det_eq_minkowskiSq p)

/-- The two sign-related matrices act differently on every spinor whose image
under `A` is nonzero. -/
```

### 7. `AgentTasks/overnight-allmass-run-2026-07-09/jobs/sigmamap-null-edges.md` [Targets (rational; Matrix.det_fin_two/mul + fin_cases/ring/norm_num; NO transcendental, NO nlinarith)]

Score: `0.810`

```text
## Targets (rational; Matrix.det_fin_two/mul + fin_cases/ring/norm_num; NO transcendental, NO nlinarith)

1. `P_closed`: `P E kz = !![E+kz, 0; 0, E-kz]` and `det (P E kz) = E^2 - kz^2` (`= m^2` on shell). By
   `Matrix.det_fin_two` + `ring`.
2. `edge_rank_one`: each `edge v` has `det = 0` (null/rank-1). By `Matrix.det_fin_two`; `ring`.
3. `P_eq_null_edge_sum` (payload): `P E kz = (E+kz) . edge ![1,0] + (E-kz) . edge ![0,1]` -- the sigma-
   map matrix is EXACTLY a nonneg combination of two rank-1 null-edge dyads (the two chirality/light-cone
   directions). `ext i j; fin_cases i <;> fin_cases j <;> simp [...]; ring`. So `P(p)` from PhysLean's
   Pauli convention IS a sum of null edges.
4. `det_is_disagreement` (payload): `det (P E kz) = (E+kz)*(E-kz) = E^2 - kz^2 = m^2`, and this equals
   the "disagreement" of the two null edges (the product of their weights) -- massless (`E = |kz|`, one
   weight 0) gives `det = 0` (rank-1, single null edge), massive gives `det = m^2 > 0` (two edges). State
   `det P = 0 <-> E^2 = kz^2` (one null edge / massless) and `det P > 0 <-> massive`.
5. `sigmamap_null_edge_verdict`: package -- the PhysLean-grounded sigma-map `P(p) = p.sigma` and the
   manuscript's null-edge Gram `M M^H` are the SAME little-group spinor matrix: `P` is a nonneg sum of two
   rank-1 null-edge dyads, its determinant is the null-edge disagreement `m^2`, and it collapses to a
   single null edge (rank 1, `det = 0`) exactly at masslessness. This closes the "which P" loop: the
   det-P mass is frame-independent because `P` is this spinor object, decomposable into null edges.
   Honest scope: the real (t,z)-restricted rational avatar; the general complex case is the same with
   Hermitian dyads.

MANDATORY non-degeneracy: massive witness `E=5, kz=3` (`m^2=16`, `P=!![8
```

### 8. `PhysicsSM/Draft/NullEdge/TetradSpinReconstructionBoundary.lean` [spinLift_sign_witness]

Score: `0.809`

```text
'PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.spinLift_sign_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary.spinLift_sign_witness

end PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary
```

## Scoped paper hits

### 1. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.767`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 2. Two-twistor particle models and free massive higher spin fields

Score: `0.760`
Zotero key: `zotero:MFUJKFEA`
arXiv: `1409.7169`
DOI: `10.1007/JHEP04(2015)010`
URL: https://doi.org/10.1007/JHEP04(2015)010

### 3. Null twisted geometries

Score: `0.752`
Zotero key: `BC9Q4QNG`
arXiv: `1311.3279v2`
URL: http://arxiv.org/abs/1311.3279v2

Abstract:

Extends twisted-geometry/spin-network ideas to null hypersurfaces using twistors and ISO(2) little-group structure. Useful prior art for the null-edge P9 closure and null-horizon geometry lane.

### 4. Massive relativistic particle model with spin from free two-twistor dynamics and its quantization

Score: `0.744`
Zotero key: `zotero:2T3HC5NC`
arXiv: `hep-th/0510161`
DOI: `10.1103/PhysRevD.73.105011`
URL: https://doi.org/10.1103/PhysRevD.73.105011

### 5. Spin on a 4D Feynman Checkerboard

Score: `0.738`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.
