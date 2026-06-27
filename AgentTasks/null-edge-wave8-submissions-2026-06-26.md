# Null-edge Aristotle Wave 8 submissions

Date: 2026-06-26.

Purpose: launch the finite-track Wave 8 recommended by returned Wave 7 jobs: Gate A closeout, internal anomaly inheritance, Plucker promotion/covariance, Gate C flavored-chirality classification, forbidden-counterterm prediction audit, and P1/P1.5 publication crosswalk.

| Job | Aristotle project | Focus | Package |
| --- | --- | --- | --- |
| a1-gate-a-super-dirac-square-closeout | `fab1a03f-6a38-4768-a914-2fc786063704` | A1 Gate A super-Dirac square closeout | `AgentTasks/aristotle-wave8-20260626/a1-gate-a-super-dirac-square-closeout` |
| h1-h3-internal-spectrum-anomaly-inheritance | `3274e4b3-ce9b-4905-b758-bc15fd044a92` | H1/H3 internal spectrum API and anomaly inheritance | `AgentTasks/aristotle-wave8-20260626/h1-h3-internal-spectrum-anomaly-inheritance` |
| b6-b9-plucker-obstruction-covariance | `e511d397-06f4-4044-811e-e4bc4614925a` | B6/B9 Plucker obstruction and SL2C covariance | `AgentTasks/aristotle-wave8-20260626/b6-b9-plucker-obstruction-covariance` |
| c16-gamma-f-flavored-chirality-index | `496ddd69-0fbb-4037-9c4f-f2e1d7f1521c` | C16 Gamma_f flavored-chirality index for high-momentum branches | `AgentTasks/aristotle-wave8-20260626/c16-gamma-f-flavored-chirality-index` |
| f13-forbidden-counterterm-codimension | `f9fb5847-6eb4-4291-a87d-417f958e3082` | F13 forbidden-counterterm codimension theorem | `AgentTasks/aristotle-wave8-20260626/f13-forbidden-counterterm-codimension` |
| m10-p1-p15-publication-crosswalk | `10e11e67-3216-4f1a-b655-3a67bccd9118` | M10 P1 to P1.5 publication crosswalk | `AgentTasks/aristotle-wave8-20260626/m10-p1-p15-publication-crosswalk` |

Notes:
- Wave 8 is proof-heavy on the finite track and intentionally does not launch continuum convergence proofs.
- Track CONT should remain gated on nonfatal Gate C flavored-chirality/Krein classification.
- Packages include copied context snapshots. Review returned patches semantically before integration.

## Integration (2026-06-26)

All six jobs integrated. Five shipped new kernel-checked Lean modules (all `sorry`-free,
`native_decide`-free, axioms `propext, Classical.choice, Quot.sound`); m10 is audit-only.
Aristotle's flat `PhysicsSM__X__Y` package imports were remapped to the repo's dotted
`PhysicsSM.X.Y`. Verified: trusted `lake build PhysicsSM` exit 0 (8294 jobs) and
`lake build PhysicsSMDraft` exit 0 (8681 jobs); `#print axioms` clean on all headline
theorems (all 9 trusted Spinor theorems checked individually). The many other `PhysicsSM__*`
files in each package are uploaded context (existing repo copies / broken flat-layout
duplicates), not deliverables, and were not integrated.

| Job | New module(s) | Report | Headline |
| --- | --- | --- | --- |
| a1 gate-a-square-closeout | `PhysicsSM/Draft/NullEdgeSuperDiracSignBridge.lean` | `null-edge-gate-a-square-sign-bridge-report.md` | **Gate A bridge**: `super_dirac_sign_bridge` (`(Gs Phi)^2=+Phi^2` for the commuting grading, `-Phi^2` for the anticommuting one), `super_dirac_square_sum_safe` (full sum square with explicit chi_E-odd/Gamma_s-even hyps), concrete `productGrading` realization proving `gammaS_ne_chiE` and a nonzero `+1` vs `-1` witness (sign flip is genuine, not `0=-0`). |
| h1-h3 internal-spectrum | `PhysicsSM/Draft/NullEdgeInternalSpectrum.lean` (ns `PhysicsSM.NullEdge.NullEdgeInternalSpectrum`) | (in module docstring) | Internal-spectrum API over the existing `standardModelOneGeneration`; anomaly-inheritance wrappers (`anomalyFree_of_realizesOneGeneration`, `nGenerations_localAnomalyFree`); Furey as one realization, not an assumption. No kinetic/Phi_H dependence. |
| b6-b9 plucker-covariance | `PhysicsSM/Spinor/PluckerObstruction.lean`, `PhysicsSM/Spinor/PluckerMassCovariance.lean` (**trusted tree**) | `null-edge-p1-plucker-obstruction-crosswalk.md` | B6: `MasslessObstruction` interface; `B_Pl = Re(det mass)`, vanishes exactly on the collinear locus. B9: full SL(2,C) invariance of the wedge / `B_Pl` / determinant mass / massless locus. Only gap: explicit SL(2,C)->SO+(1,3) covering map. |
| c16 gamma-f-flavored-chirality | `PhysicsSM/Draft/NullEdgeFlavoredChirality.lean` | (in module docstring) | **Gate C flavored chirality**: `Gamma_f = Gamma_s . T` (`GammaF_eq_GammaS_mul_tasteT`), involutive, distinct from chi_E / kdParity / Krein J; the release witness `gateC_naive_blind_flavored_sees`: `tr(Gamma_s P_null)=0` but `tr(Gamma_f P_null)=4`, tied to the proven `threePi_null` branches. Gate C remains a kill switch; this commits the finite index machinery, not a release. |
| f13 forbidden-counterterm | `PhysicsSM/Draft/NullEdgeForbiddenCountertermCodim.lean` | `null-edge-f13-forbidden-counterterm-codimension-audit.md` | A chirality-odd operator has vanishing diagonal blocks (`odd_diag_left_zero`), so a same-Weyl bare-mass counterterm is unrepresentable; admissible odd ops are exactly the off-diagonal Yukawas; `forbidden_counterterm_codimension` = codim `(card L)^2+(card R)^2`. Audit verdict: genuine codimension candidate but the generic NCG odd-operator constraint -- too weak to be a stand-alone prediction until composed with the internal-moduli gap; keep prediction language off. |
| m10 publication-crosswalk | (none -- audit only) | `null-edge-wave8-m10-p1-p1.5-crosswalk.md` | P1/P1.5 claim-to-Lean crosswalk. **Audit finding:** the P1 manuscript marks twistor rows `trusted` but those modules are absent here -- must be re-vendored or downgraded before submission; the P1.5 spine is present and kernel-backed. |

Notable: a1 and c16 deliver the two highest-leverage Wave 8 targets. **Gate A is now bridged**
(the `super_dirac_square_named`-style closeout exists and is kernel-clean), and **Gate C now has
a committed flavored-chirality index** `tr(Gamma_f P_null)` -- the first finite mechanism that
*sees* the species imbalance the naive `Gamma_s` index misses. Two trusted-tree modules
(`Spinor/PluckerObstruction`, `Spinor/PluckerMassCovariance`) were added and verified clean, but
per the wave6 promotion-bridge they still need the machine-checkable convention banner before
being cited as Trusted in a manuscript.
