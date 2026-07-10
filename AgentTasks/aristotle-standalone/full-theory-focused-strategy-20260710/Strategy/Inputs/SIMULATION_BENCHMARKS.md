# Null-information laboratory benchmark matrix

Validation tiers:

- V0 exact arithmetic fixture;
- V1 numerical regression against a landed Lean theorem;
- V2 reproduction of accepted physics with explicit imported dictionary/inputs;
- V3 calibrated fit with disclosed training and held-out data;
- V4 genuine pre-registered prediction.

No V2/V3 row may be called a prediction.

| ID | Tier target | Physics/model target | Lean/source anchor | Inputs and units | Observable/invariant | Pass metric | Negative control | Artifact | Owner | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| S01 | V0/V1 | null-bundle determinant and Lorentz invariance | GateI1/Pluecker modules | rational spinors, c=1 | `det P`, wedge sum, rank | exact | collinear bundle | Scripts/sim/results/20260709-231850/results.json | Claude | LANDED exact |
| S02 | V0/V1 | entropy/concurrence mass dictionary | VelocityMixtureLinearEntropy, KraftCompressionMass, TwoEdgeMassConcurrence | normalized 2-level state | purity deficit, concurrence, mass ratio | exact fixtures | pure endpoint | Scripts/sim/results/20260709-231850/results.json | Claude | LANDED exact |
| S03 | V1 | positive Hodge decoder | DecoderChainHomotopy, KreinChainEquivalence, PositiveHodgeDecoder | explicit `Q,J,D` matrices | homotopy invariance on cohomology, Krein sector signs | exact matrix identities | negative-Krein ghost direction | Scripts/sim/results/20260709-231850/results.json | Claude | LANDED v1 (Rayleigh matrices next) |
| S04 | V1 | four-channel carrier square | carrier rigidity/action modules | rational carrier fixture | block sum and coefficient readers | exact | alternate unsupported split | TBD | unclaimed | queued |
| S05 | V0/V1/V2 | 1+1 checkerboard Dirac walk | ExactCheckerboardPathSum, HistoryLocalFourChannelAction | eps*m = 1/4, t <= 8, c=1 | kernel = recursion (exact), cone support, massless straight-only | exact finite | wrong corner phase differs | Scripts/sim/results/20260709-231850/results.json | Claude | LANDED V0/V1 (dispersion/V2 next) |
| S06 | V0/V1 | tetrahedral 3+1 lift | tetrahedral modules | rational tetra frame | endpoint norm, projector sum, bend, orientation phase | exact | unit-scale/unit-speed 1/3 obstruction | TBD | unclaimed | queued |
| S07 | V1/V2 | relativistic mass shell and speed | SubluminalBound, RapidityInformationDistance | 3-4-5 shell, rational rapidity k, c=1 | mass shell, subluminal drift, exact velocity addition, boost-invariant det | exact | superluminal control | Scripts/sim/results/20260709-231850/results.json | Claude | LANDED V1 |
| S08 | V1 | closure binding and Schur effective mass | BindingDefect, CarrierClosurePlane, SchurSeesaw | lam=3, kap=2; seesaw b=1, M=10..1000 | ground lowering, phase boundaries, 1/M suppression, exact b^4/M^2 residual | exact fixtures | wrong-sign closure raises | Scripts/sim/results/20260709-231850/results.json | Claude | LANDED V1 |
| S09 | V1/V2 | gauge-mass Gram and Higgs DOF | gauge/Higgs modules; imported representation | supplied generators/couplings/VEV | Gram spectrum, stabilizer, DOF count | exact finite | unbroken generator | TBD | unclaimed | queued |
| S10 | V0/V1 | CP phase and family no-go | KM/family modules | explicit rational unitary/witness | Jarlskog, phase count, permutation symmetry | exact | N=2/rephasing control | TBD | unclaimed | queued |
| S11 | V1 | soldering geometry and action response | soldering/variation modules | rational coframes/boost | metric, volume, defect covariance, stationarity | exact | singular coframe/zero variation | TBD | unclaimed | queued |
| S12 | V0/V1 | event-count/Lambda phase and fluctuations | GeometryRegisterLambda, LambdaUnimodular | counts (1,3), quarter-turn Lambda units | pi-periodicity, coherent observability, decohered constancy | exact Gaussian-rational | decohered records hide Lambda | Scripts/sim/results/20260709-231850/results.json | Claude | LANDED V1 (variance scaling next) |
| S13 | V1 | local Kraus no-signaling and microcausality | FiniteNoSignaling, TwoRegionTensorMicrocausality | exact Bell density, reset Kraus family, Pauli tensor factors | remote marginal, joint-state change, separated/local commutators | exact | non-TP channel changes marginal; overlapping Pauli observables do not commute | Scripts/sim/results/20260709-235100-all-codex/results.json | Codex | LANDED V1 |
| S14 | V1/V2 | self-consistent decoder and RG scale | self-consistency/transmutation modules | coupling, beta-law input, scale | fixed point, contraction, invariant Lambda | exact plus iteration convergence | strong-coupling multi-fixed control | TBD | unclaimed | queued |

## Benchmark record template

For each executed row append:

```text
Benchmark ID:
Command:
Commit/worktree note:
Seed:
Software versions:
Conventions and units:
Theorem/source anchors:
Imported constants:
Fitted parameters and training data:
Held-out data:
Expected result and tolerance:
Observed result:
Negative-control result:
Tier earned:
Scientific interpretation:
```
