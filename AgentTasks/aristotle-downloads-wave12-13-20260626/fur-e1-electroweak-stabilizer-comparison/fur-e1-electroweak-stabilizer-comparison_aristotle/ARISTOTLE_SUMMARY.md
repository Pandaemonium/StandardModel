# Summary of changes for run a8352886-a846-4609-afe9-b403659c96ae
Implemented the requested Lean bridge in `PhysicsSM/Draft/NullEdgeFureyEWStabilizerComparison.lean`, relating the Furey/Hughes electromagnetic generator to the null-edge FMS photon stabilizer. The file builds cleanly (no `sorry`/`axiom`/`admit`; the main theorem uses only `propext`, `Classical.choice`, `Quot.sound`).

What I found on inspection:
- The null-edge modules (`NullEdgeElectroweakStabilizer`, `NullEdgeFMSFiniteComposite`, `NullEdgeFMSCompositeObservableNext`) build on Mathlib alone. They isolate the photon direction as `span ℝ {Qgen}` (with `Qgen = ![0,0,1,1]` encoding `Q = T₃ + Y/2`), the one-dimensional kernel of the orbit-obstruction map `B_EW` that stabilises the Higgs reference section `H₀`.
- The Furey electroweak modules (`Algebra/Furey/ElectroweakBridge`, `OperatorElectroweakIdentity`, `QopElectroweakConsistency`, `ElectroweakCompletePackage`) cannot be imported in this snapshot: their upstream dependencies (`AnomalyBridge`, `OneGenerationTable`, `QopJbarEigenBridge`, `MinimalLeftIdeal`, `ElectroweakPaperPackage`, `T3OpJbar`, `WeakIsospinDoublets`, `WeakIsospinLadder`) are absent, so those files do not compile. Their shared electromagnetic content, however, is the Gell-Mann–Nishijima relation `Q = T₃ + Y/2` (`ElectroweakBridge.gellMannNishijima_all`, `OperatorElectroweakIdentity.physicalQEnd_eq_targetT3End_add_half_targetYEnd`).

Because the Furey modules are not importable, I made the bridge self-contained: the small dependency-free Furey content actually used — the finite electroweak charge table (`fPhysicalQ`, `fTargetT3`, `fTargetY`) and GMN (`furey_gellMannNishijima`) — is reproduced verbatim with provenance comments pointing to the originals, so the local copies can be swapped back to imports once the upstream files are restored.

The bridge then proves that the Furey electromagnetic generator `Q = T₃ + Y/2` and the null-edge FMS photon stabilizer `span ℝ {Q}` are the same unbroken one-dimensional direction:
- `fureyEMgen_eq_T3_plus_Yhalf` / `Qmat_eq_T3_add_Yhalf`: GMN at the coordinate and matrix level (`Q = T₃ + Y/2 = diag(1,0)`).
- `fureyEMgen_eq_Qgen` / `rho_fureyEMgen`: the Furey EM generator equals the null-edge `Qgen`, with representation `ρ(Q) = Q`.
- `fureyEMgen_stabilizes_vacuum`: `ρ(Q) H₀ = 0`.
- `fureyEMgen_massless`: zero orbit-stiffness mass (massless photon).
- `fureyEMgen_span_eq_photon_stabilizer` / `fureyEMgen_span_eq_massForm_kernel`: `span ℝ {Q} = ker B_EW = {x | massForm v x = 0}`.
- `furey_EM_generator_is_null_edge_photon_stabilizer`: the assembled bridge.

Scope was preserved: this is a stabilizer / orbit-stiffness compatibility result only — no W/Z pole theorem and no mass prediction. Since the Lean bridge was feasible, no markdown fallback was produced.
