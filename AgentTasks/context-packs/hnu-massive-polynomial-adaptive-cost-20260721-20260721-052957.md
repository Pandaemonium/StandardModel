# Aristotle semantic context pack

Generated: 2026-07-21T05:30:05
Query: `live massive HNU doubled chiral endpoint exact skew-Hermitian product formula Pluecker mass polynomial one-step error`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/HNUMassiveGlobalGap.lean`

Score: `0.847`

```text
import PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay

/-!
# Global zero/pi gap target for the massive HNU walk

This draft isolates the strongest immediate consequence suggested by the exact
HNU census and the newly integrated Pluecker mass composition. The headline
claim is deliberately global over the closed Brillouin cube. It is not implied
by exact unitarity or by the infrared Dirac tangent alone.

The parity-census lemma is the expected hard trigonometric core. Numerical and
symbolic oracles suggest the statements below, but those calculations are not
proof. This file is an Aristotle handoff and remains draft while its proof holes
are present.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay
```

### 2. `PhysicsSM/Draft/NullEdge/PlueckerHNUIntertwiner.lean`

Score: `0.832`

```text
import PhysicsSM.Draft.NullEdge.HNUInfraredTangent
import PhysicsSM.Draft.NullEdge.PluckerMassOperator
import PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass

/-!
# An explicit HNU--Pluecker bridge after four-component doubling

This module composes three existing finite results without reproducing their
definitions.  The HNU endpoint has the infrared tangent `-i q.sigma`; the live
four-component Pluecker operator has the usual massless Dirac kinetic block;
and the two Pluecker rest operators are related by one explicit rectangular
intertwiner `W`.

The scope boundary is essential.  The theorem does **not** derive the Pluecker
coordinate from the HNU endpoint, and it does not make one two-component HNU
Weyl point massive.  Indeed, `singleWeyl_mass_noGo` proves that no nonzero
`2 x 2` matrix anticommutes with all three Pauli velocity generators.  The
compatible mass appears only after passing to the live four-component
Clifford representation.  The displayed `W` is an explicit compatible
embedding; no uniqueness or canonicity claim is made.

Conventions: the Pauli matrices are those of `HNUExactCore`; the four-component
Dirac matrices are those of `Pluecker3Plus1ComplexMass`; and the complex rest
operator is `PluckerMassOperator.massOperator`.  These imported modules already
record their metric, basis, and Pluecker conventions.

Provenance: clean-room integration of the mathematically valid subset of
Aristotle project `f0d38cd0-cdec-46ef-800b-b588e3e07740`, task
`c9f31d7f-a8ae-4ade-9d36-e03b2db004a9`.  The returned file duplicated the live
APIs and described `W` as forced; this integration instead reuses the live APIs
and retains only the proved explicit-existence statement.
-/
```

### 3. `AutonomousLab/work/NE-3PLUS1/CODEX_CONTINUUM_3PLUS1_SYNTHESIS_2026-07-13.md` [Gate O: Pluecker mass and the regulator]

Score: `0.820`

```text
## Gate O: Pluecker mass and the regulator

`PlueckerHNUIntertwiner` now proves an exact compatibility result:

- the HNU tangent is the massless Weyl kinetic block;
- an explicit `4 x 2` embedding intertwines the two-component Pluecker rest
  operator with the live four-component complex mass operator;
- the rest operator is the normalized compression along that embedding;
- no nonzero `2 x 2` matrix anticommutes with all three HNU Pauli velocities.

Thus a single HNU Weyl point is necessarily massless in its two-component
representation, while a doubled four-component extension can carry the same
complex Pluecker coordinate.  This is a real theorem-level bridge and a useful
no-go.

It is not yet a derivation of mass from the regulator.  The embedding is one
explicit choice and `z` remains supplied by Pluecker data.  The active
classification job asks whether every compatible embedding lies in a
nontrivial normalized moduli space.  If so, a physical selector must come from
locality, phase transport, information cost, boundary response, or dynamics.
```

### 4. `Sources/Null_Edge_Stay_Update_Literature_and_Proof_Agenda_2026-07-19.md` [A. Massive global zero/pi gap]

Score: `0.820`

```text
### A. Massive global zero/pi gap

Prove that the nontrivial Pluecker mass coin gaps both `+1` and `-1`
quasienergies over the entire closed Brillouin cube. The key intermediate
statement is a parity census for the HNU endpoint:

```text
endpoint(k) = endpoint(-k)
iff k is the origin or lies on the Brillouin boundary.
```

An exact SU(2) block-determinant reduction then appears to force any massive
zero/pi crossing onto those two loci, where a mass angle strictly between zero
and pi excludes it. This is currently oracle-supported and must not be cited as
a theorem until the Lean proof lands.
```

### 5. `PhysicsSM/Draft/NullEdge/OvernightTheoryAxiomGuard.lean` [without]

Score: `0.818`

```text
fo: 'PhysicsSM.Draft.NullEdge.WeylSphereChargeBridge.chirality_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeylSphereChargeBridge.chirality_mul

/-! ## Explicit HNU--Pluecker bridge after four-component doubling -/

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.endpoint_kinetic_block_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.endpoint_kinetic_block_hasDerivAt

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.mass_intertwiner' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.mass_intertwiner

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.massOperator_is_compression' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.massOperator_is_compression

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.singleWeyl_mass_noGo' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.singleWeyl_mass_noGo

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.three_four_I_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PlueckerHNUIntertwiner.three_four_I_control

/-! ## HNU zero/pi crossing ledger and endpoint-value insufficiency -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUGlobalZeroPiChargeLedger.hnu_both_
```

### 6. `AgentTasks/afpl-hnu-many-step-continuum-aristotle-2026-07-13.md` [2026-07-13 harvest and live-port successor]

Score: `0.818`

```text
## 2026-07-13 harvest and live-port successor

Task `5780bc23-454d-4d27-b6a4-809498b454fa` completed the full quantitative
ladder on its self-contained HNU exact core:

- an explicit operator-norm `O(eps^2)` one-step estimate for the exact HNU
  endpoint at fixed momentum;
- an exact-unitarity telescope with `O(t^2 / n)` finite-time error;
- convergence of the `n`-step endpoint word to the Weyl exponential for every
  fixed `q` and `t`;
- nonzero axis controls and standard-three guards.

The returned theorem uses the task's standalone `HNUExactCore.Core` API.  Its
endpoint formula appears algebraically identical to the live endpoint after the
Pauli/projector name map, but headline integration requires a kernel-checked
bridge rather than visual comparison.  Independent Claude review was requested
in mailbox message `msg-20260713-205603-2e149b00`.

Successor task `c7a35679-00c4-4406-a7e1-e54558ed0c52` now targets a direct
live-import port.  It must prove the rotation factorization or explicit endpoint
equality against `PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint`, preserve all
quantitative statements, and expose no second physical endpoint in the public
API.  Until that port replays, the result is harvested but not integrated.
```

### 7. `AgentTasks/aristotle-downloads/f0d38cd0-cdec-46ef-800b-b588e3e07740/output-final_aristotle/ARISTOTLE_SUMMARY.md` [Summary of changes for run c9f31d7f-a8ae-4ade-9d36-e03b2db004a9]

Score: `0.812`

```text
# Summary of changes for run c9f31d7f-a8ae-4ade-9d36-e03b2db004a9
Delivered the Plücker–HNU intertwiner as a kernel-checked Lean module and a semantic report.

**New file `PlueckerHNUIntertwiner.lean`** (module `PlueckerHNUIntertwiner`, added to `lakefile.toml`; builds clean with `lake build PlueckerHNUIntertwiner`, no `sorry`, every headline theorem certified by build-enforced `#guard_msgs` on `#print axioms` to use only `propext`/`Classical.choice`/`Quot.sound`).

Because the four live modules are not in this build graph (their `PhysicsSM.Draft.NullEdge.*` import roots don't resolve, one imports an absent `SuccessiveAxisDiracWalk`, and root-level files carry mismatched module paths), their definitions are reproduced verbatim and tagged `-- IMPORTED (reproduced)`; all new content is isolated in `section DerivedBridge`. Crucially, the HNU depth-eight `endpoint` and its exact infrared derivative `endpoint_ray_hasDerivAt` (`-i(q·σ)`) are reproduced *with proof*, so the HNU generator is a genuine `HasDerivAt` tangent, not an assertion.

Results answering the six requests:
1. Source/target spaces, chirality grading (`γ₅`), Pauli basis, phase `z↦e^{iθ}z`, and `t=0` tangent normalization are fixed; `Bz_pauli` locates `Bz z = z.re·σ1 − z.im·σ2` in the HNU basis.
2/3. **Mass intertwiner built from Clifford data**: `W` (columns spanning `ker(β₅+iβ)`) with base identities `beta_W` (`β·W=W·σ1`), `beta5_W` (`β₅·W=−W·σ2`) yields `mass_intertwiner` (`mass4 z·W = W·Bz z` for all `z`), `W_isometry` (`WᴴW=2•1`), and `Bz_is_compression` (`(1/2)·Wᴴ·mass4 z·W = Bz z`) — so `Bz` is literally a compressed block of the massive `4×4` extension `H4`. The **kinetic** side: `topRight_Kin`/`endpoint_block_bridge` show the HNU generator is `−i` times the off-diagonal block of the massless `3+1` kin
```

### 8. `PhysicsSM/Draft/NullEdge/PluckerMassOperator.lean` [phaseBasis]

Score: `0.812`

```text
def phaseBasis (u : ℂ) : Mat := !![u, 0; 0, 1]

/-- The Pluecker mass operator is Hermitian. -/
```

## Scoped paper hits

### 1. Massive Helicity-Chirality Spinor Formalism from Massless Amplitudes with On-shell Mass Insertion

Score: `0.754`
Zotero key: `UVEFM4UK`
arXiv: `2501.09062`
URL: https://www.zotero.org/19894138/items/UVEFM4UK

Abstract:

We introduce a helicity-chirality spinor formalism to describe scattering amplitudes for particles of any masses and spins. The massive spin-spinors introduced by Arkani-hamed-Huang-Huang have been extended to the spin/helicity-transversality spinors, in which a new quantum number transversality, closely related to chirality, is introduced by extending the Poincare symmetry. The massive helicity-chirality amplitudes can be written by the large and small components of massless spinors $\lambda$ and $\eta$ following the $\lambda \sim \sqrt{E}, \eta \sim \mathbf{m}/\sqrt{E}$ expansion order by order, which formulate the power counting rules of a large energy effective theory. Diagrammatically the mass expansion in amplitudes originates from the on-shell mass insertion: the helicity flip and chirality flip, which completely determines the three-point massive amplitudes. From the chirality-helicity unification at the UV, any massive helicity-chirality amplitude can be one-to-one corresponded to massless helicity amplitudes with (without) additional Higgs insertion. This UV-IR correspondence explains the mass enhancement in the weak decay processes $\pi^+ \to \mu^+ \nu$ and $t \to W^+ b$, and isolates the correct UV of the three-point massive QED $F\bar{F}\gamma$ amplitudes in Arkani-hamed-Huang-Huang formalism. From massless-massive correspondence, the massless on-shell techniques can be utilized to construct higher-point massive amplitudes.

### 2. Scattering Amplitudes For All Masses and Spins

Score: `0.738`
Zotero key: `5J5XDKMN`
arXiv: `1709.04891`
DOI: `10.1007/JHEP11(2021)070`
URL: https://www.zotero.org/19894138/items/5J5XDKMN

### 3. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.737`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 4. From Twistor-Particle Models to Massive Amplitudes

Score: `0.736`
Zotero key: `zotero:J5GA3CQ8`
arXiv: `2203.08087`
DOI: `10.3842/SIGMA.2022.045`
URL: http://arxiv.org/abs/2203.08087

### 5. Exactly massless quarks on the lattice

Score: `0.733`
Zotero key: `9H7HA39S`
arXiv: `hep-lat/9707022`
URL: https://arxiv.org/abs/hep-lat/9707022
