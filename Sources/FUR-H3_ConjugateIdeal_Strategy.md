# FUR-H3 — Conjugate ideal `J*` and the right-handed singlet sector

Companion document to `PhysicsSM/Algebra/Furey/ConjugateIdeal.lean`.

## 1. Audit conclusion

The provided project ships eight `Furey` files but **none of their
foundational dependencies**.  The following imported modules are absent, so
the project does not build as delivered:

```
PhysicsSM.Algebra.Octonion.ComplexOctonion
PhysicsSM.Algebra.Furey.LadderOperators
PhysicsSM.Algebra.Furey.AnomalyBridge
PhysicsSM.Algebra.Furey.OperatorRepresentations
PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity
PhysicsSM.Algebra.Furey.T3OpJbar
PhysicsSM.Algebra.Furey.ElectroweakBridge
PhysicsSM.Algebra.Furey.ElectroweakAnomalyBridge
PhysicsSM.Algebra.Furey.ElectroweakCompletePackage
PhysicsSM.Algebra.Furey.OneGenerationPackage
PhysicsSM.Algebra.Furey.QopElectroweakConsistency
PhysicsSM.StandardModel.AnomalyPackage
PhysicsSM.StandardModel.OneGenerationTable
```

Because of this, the right-handed sector could not be closed *inside* the
octonion algebra in this workspace.  Instead, `ConjugateIdeal.lean` is a
**self-contained** module (imports only `Mathlib`) that builds independently
and proves the conjugate-ideal right-handed singlet content at the coordinate
/ charge-table level — exactly the granularity of the project's existing
anomaly-bridge files (`JbarElectroweakAnomaly`, `QopJEigenBridge`,
`FureyRealizesOneGeneration`).

## 2. What `ConjugateIdeal.lean` proves (all kernel-checked, no `sorry`)

Main theorem: `fureyRightHandedSectorRealized : FureyRightHandedSectorRealized`.
It bundles:

* **Conjugate-ideal basis** — `JstarBasis : Fin 8 → (Fin 8 → ℂ)` is linearly
  independent over `ℂ` (`JstarBasis_linearIndependent`), each vector is
  nonzero (`JstarBasis_ne_zero`), and `Module.finrank ℂ Jstar = 8`
  (`Jstar_finrank_eq_eight`).
* **Charge conjugation** — `Cconj : (Fin 8 → ℂ) → (Fin 8 → ℂ)` is an
  involutive (`Cconj_involutive`), antilinear (`Cconj_smul`), bijective
  (`Cconj_bijective`) map: the coordinate shadow of complex conjugation on
  `ℂ⊗𝕆` exchanging `J` and `J*`.
* **Charges by conjugation** — `qJstar i = - qJ i` (`qJstar_eq_neg_qJ`), where
  `qJ` reproduces `QopJEigenBridge.rawQopJ`; spectrum
  `[1, 2/3, 2/3, 2/3, 1/3, 1/3, 1/3, 0]` (`qJstar_values`).
* **Right-handed singlet quantum numbers** — `u_Rc`, `d_Rc`, `e_Rc` with
  `(Q, T₃, Y)` of `(-2/3, 0, -4/3)`, `(1/3, 0, 2/3)`, `(1, 0, 2)`; each is the
  charge conjugate of the physical `u_R, d_R, e_R` charge
  (`u_Rc_charge_conjugate`, …) and satisfies Gell-Mann–Nishijima
  `Q = T₃ + Y/2` (`rhSinglets_gellMannNishijima`).
* **Full anomaly cancellation in the all-left convention** for the 15-state
  table `allLeftTable` *including* the right-handed singlets:
  gravitational/linear `U(1)` (`grav_anomaly_cancels`), cubic `U(1)³`
  (`cubic_anomaly_cancels`), `SU(2)²·U(1)` (`su2u1_anomaly_cancels`),
  `SU(3)²·U(1)` (`su3u1_anomaly_cancels`), and Witten global `SU(2)`
  (`witten_anomaly_even`).  The singlet sub-table contributes exactly the
  complement of the doublet sub-table (`singletSub_grav_complement`,
  `singletSub_cubic_complement`), and supplies the missing 7 Weyl states
  (`singletSub_weyl_count`).

This narrows the trivial `FureyRightHandedSectorOpen := True` marker: the
right-handed singlet gauge data is now *produced* by the conjugate ideal and
*certified* anomaly-compatible, rather than merely appended by convention.

## 3. Existing `Jbar` facts reusable once the foundations are restored

| Existing fact | Reuse in the `J*` route |
|---|---|
| `MinimalLeftIdeal.omega = (1 - i·e₇)/2`, `J = (ℂ⊗𝕆)·omega` | Conjugate idempotent `ω* = (1 + i·e₇)/2`, `J* = (ℂ⊗𝕆)·ω*` is the complex conjugate; reuse the idempotent/minimality proofs verbatim under conjugation. |
| `JbarLinearIndependence.JbarBasisState'_linearIndependent`, `Jbar_finrank_eq_eight` | Same 8-dim coordinate computation for the conjugate basis `α_k^† … ω*`. `ConjugateIdeal.JstarBasis_linearIndependent` is the self-contained analog. |
| `QopJEigenBridge.rawQopJ`, `Q_op_JBasisState_eigen` | `qJ` here equals `rawQopJ`; the conjugate eigenvalues are `-rawQopJ` (`qJstar`). Need `Q_op (Cconj x) = - Cconj (Q_op x)` from the octonion conjugation. |
| `JbarElectroweakAnomaly.JbarLeftDoublet_su2SquaredU1Anomaly` | Doublet sub-table; `ConjugateIdeal.su2u1_anomaly_cancels` extends it to the full table. |
| `FureyRealizesOneGeneration.standardModelOneGeneration_localAnomalyFree` | `ConjugateIdeal.{grav,cubic,su2u1,su3u1}_anomaly_cancels` re-derive the same content self-contained, with explicit singlet contributions. |
| `OneGenerationTable.hypercharge_conversion` (charge-conjugation `Y ↦ -Y`) | Exactly `qJstar = -qJ` and the all-left `Y` entries for `u_R^c, d_R^c, e_R^c`. |

## 4. Minimum missing definitions to fully algebraicize the `J*` route

To replace the coordinate model with the genuine octonion construction,
restore `ComplexOctonion` and `LadderOperators`, then add to a future
`ConjugateIdeal` octonion layer:

1. `omega_star : ComplexOctonion := (1 + Complex.I • e₇)/2` and
   `omega_star_idempotent : omega_star * omega_star = omega_star`.
2. `Jstar : Submodule ℂ ComplexOctonion := (⊤ : Submodule …).map (· * omega_star)`
   with `Jstar_finrank_eq_eight`.
3. The eight conjugate basis vectors `ωstar, α_k^†·ωstar, …` and their
   `LinearIndependent ℂ` proof (mirror `JbarBasisState'_linearIndependent`).
4. The conjugation map `conj_octonion : ComplexOctonion → ComplexOctonion`
   (complex-conjugate the `ℂ` coefficients) and
   `conj_octonion_antilinear`, `conj_octonion_involutive`,
   `conj_octonion_maps_J_to_Jstar`.
5. The eigenvalue intertwiner
   `Q_op (conj_octonion x) = - conj_octonion (Q_op x)`, giving
   `Q_op`-eigenvalues `-rawQopJ` on `J*` and hence the right-handed singlet
   charges from §2.
6. `ChiralMultiplet` records for `u_R^c, d_R^c, e_R^c` (reusing
   `AnomalyPackage`) and `fureyDoubletTable ++ rightHandedSingletCompletion =
   standardModelOneGeneration` with the completion *derived from* `J*` rather
   than supplied conventionally.

Once 1–6 exist, `fureyRightHandedSectorRealized` upgrades from a coordinate
model to a statement about the octonion ideal, closing
`FureyRightHandedSectorOpen` outright.

## 5. Scope guard

No mass values and no three-generation claim are made.  The handedness
convention is all-left throughout; physical right-handed fermions enter as
charge conjugates with negated electric charge and hypercharge.
