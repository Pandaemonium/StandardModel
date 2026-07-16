# Aristotle semantic context pack

Generated: 2026-07-15T05:08:47
Query: `finite ZMod 2 spin lift sign correction face edge incidence closed cycle pairing annihilator range obstruction w2 graph Lorentz`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/GateYM/QCTwoStateCycleReadout.lean`

Score: `0.754`

```text
import PhysicsSM.Draft.NullEdge.GateYM.QCLeading
import PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferZ2L1

/-!
# Gate YM: exact two-step Z2 transfer readout for the QC scalar

This module records the smallest finite-cycle calculation behind Fable call 03's
suggestion that the `Q_C` scalar should next be upgraded from a one-plaquette
normalization contract to an exact `Z2` transfer theorem with a finite-volume
correction term.

We use the already-landed one-link `Z2` slab weights from
`TwoStateTransferZ2L1`.  On a two-step periodic cycle, the partition sum is

`sum_{u,v} T(u,v) T(v,u)`,

and the plaquette insertion numerator is

`sum_{u,v} sign(u) sign(v) T(u,v) T(v,u)`.

The normalized readout is exactly `tanh (2 * beta)`, equivalently the
QC-leading scalar evaluated at doubled coupling.  We also name a finite-cycle
correction relative to the one-plaquette scalar, but the corresponding
"leading plus correction" theorem is only definitional bookkeeping because the
correction is defined as the difference.  The non-bookkeeping correction theorem
is `twoStepFiniteCycleCorrection_eq_explicit`, which identifies that difference
with a closed form in the one-step contraction scalar.  This is a finite
transfer-matrix identity only.  It is not a carrier `Q_C` expectation theorem,
not a gauge-measure theorem, not a nonabelian result, and not an infinite-volume
/ beyond-leading positivity theorem.

Provenance: clean-room finite calculation from the existing `Z2` slab transfer
weights in `TwoStateTransferZ2L1`, themselves part of the Osterwalder-Seiler /
Tomboulis-Yaffe scalar chain documented in `QCLeading`.
-/
```

### 2. `PhysicsSM/Draft/NullEdge/GateYM/ClosureObstruction.lean`

Score: `0.752`

```text
namespace ClosureObstruction

open PhysicsSM.Draft.NullEdge.GateYM.ElitzurLattice
open PhysicsSM.Draft.NullEdge.GateYM.Z2GaugeCore (LinkField plaqSpins)

variable {V : Type} [Fintype V] [DecidableEq V]

/-- **NE-U3 (closure obstruction / no single-edge order parameter).** At zero
external source, the UNNORMALIZED expectation of any single-link, one-site-flip-
odd, bounded observable in the Z2 Wilson ensemble vanishes EXACTLY. Elitzur's
quantitative bound at `h = 0` gives `|<f>| <= c * tanh(0) * Z = 0`. There is no
gauge-invariant single-edge state: an open gauge edge carries no physical
expectation, so any gauge-sector mass must be a closed-composite (relational)
property, not a primitive edge quantity. -/
```

### 3. `PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferZ2Sector.lean`

Score: `0.751`

```text
import PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferZ2L1

/-!
# Gate YM: honest center-sector flux-gap witness for the one-link Z2 slab

This draft module sharpens the finite-gap witness pathway for the one-link Z2
Wilson slab (`TwoStateTransferZ2L1`).  The existing
`TwoStateTransferZ2L1.spectralWitness` fills the abstract
`FiniteGapAssembly.FiniteGapSpectralWitness` interface, but it does so through
`TwoStateTransferSpectrum.topCyclicityPrereq`: the *whole* two-state space as
the sector and the *full* endomorphism algebra as the local algebra.  That is a
toy filler.  It also silently labels the resulting gap `localGap`
(`FluxSectorZ2.localGlueballGap`), the *within-trivial-flux-sector*
local/glueball gap.

The physical content of the one-link Z2 model is different and is made explicit
here:

* the transfer vacuum `(1, 1)` lives in the `+1` center sector
  (`centerPlusProjector` fixes it);
* the flux excitation `(1, -1)` lives in the `-1` center sector
  (`centerMinusProjector` fixes it);
* the two sectors are genuinely distinct one-dimensional eigenspaces of the
  transfer operator, both preserved by it, and their intersection is trivial;
* the separation between them is therefore a **center-flux gap**
  (`FluxSectorZ2.fluxGap`), not a local/glueball gap
  (`FluxSectorZ2.localGlueballGap`).

We package this as an honest `FiniteFluxGapWitness` structure in which sector
preservation and sector membership are *explicit hypothesis fields*, and we
instantiate it from the exact one-link Z2 slab kernel.  This does **not**
construct the full Wilson slab transfer operator, Gauss projection, OS/GNS
Hilbert space, Hamiltonian, infinite-volume state, cyclicity of a genuine local
plaquette algebra, or a physical mass-gap theorem.

The final section records, as kernel-checked lem
```

### 4. `PhysicsSM/Draft/NullEdge/GateC1/OverlapIndex.lean`

Score: `0.744`

```text
namespace OverlapIndex

open OverlapGinspargWilson
open LinearMap Module
open scoped Matrix

variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- Luescher modified chirality, re-exported under the production C1 namespace. -/
```

### 5. `PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferZ2L1.lean`

Score: `0.744`

```text
import PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferWitness

/-!
# Gate YM: one-link Z2 slab bridge to the two-state payload

This module formalizes the smallest exact Wilson-slab transfer kernel used by
the executable Z2 oracle: one spatial Z2 link (`L = 1`) and one gauge-summed
temporal link.  In this case the slab kernel is exactly the two-state matrix

`!![2 * exp beta, 2 * exp (-beta);
    2 * exp (-beta), 2 * exp beta]`.

The result is a Lean/oracle bridge for the smallest descriptor shape.  It does
not construct the full Wilson slab transfer operator, Gauss projection,
OS/GNS Hilbert space, Hamiltonian, infinite-volume state, or physical mass-gap
```

### 6. `PhysicsSM/Draft/NullEdge/GateYM/ElitzurLattice.lean` [plaqSpins_flipAt_invariant]

Score: `0.743`

```text
theorem plaqSpins_flipAt_invariant (x0 : V) (U : LinkField V)
    (ps : List (V × V × V × V)) :
    plaqSpins (flipAt x0 U) ps = plaqSpins U ps :=
  plaqSpins_gauge (fun v => decide (v = x0)) U ps

/-- The Z2 spin of a link value: `false ↦ +1`, `true ↦ -1`. -/
```

### 7. `AgentTasks/context-packs/structured-holonomy-binding-20260709-20260709-142201.md` [Gate 1: closure identity banked]

Score: `0.742`

```text
### Gate 1: closure identity banked

The completed spinor-network closure proof gives:

```text
pairwise angular mass = ((sum_i w_i)^2 - |C|^2) / 4.
```

Integrate this, but state the lesson correctly: `C = 0` is rest-frame visible
closure, not no source.
```
```

### 8. `PhysicsSM/Draft/NullEdge/SignWallDefectRouteB.lean`

Score: `0.739`

```text
namespace SignWallDefect

/-! ## 1.  The walk `W(z)` (general, site-dependent, exactly unitary)

Register: `Car L = ZMod L × Fin 2` (ring of `L` sites × 2 chirality
channels).  Factor ordering is the **symmetric / palindromic** transfer
`W = S · C(z) · S`, the *only* ordering that admits an exact chiral
conjugation to the inverse with the edge-reversal grading
(see `GWRetardedTransfer`).  The coin `C(z)` is a per-site rotation whose
angle is a fixed function of the field **value** `z p` — no branch data. -/

variable {L : ℕ} [NeZero L]

/-- Carrier: spatial site on the ring `ZMod L`, times a 2-valued chirality. -/
```

## Scoped paper hits

### 1. LQG vertex with finite Immirzi parameter

Score: `0.697`
Zotero key: `MQRXNUIX`
arXiv: `0711.0146`
DOI: `10.1016/j.nuclphysb.2008.02.018`
URL: http://arxiv.org/abs/0711.0146

Abstract:

Finite-Immirzi spin-foam vertex connecting canonical loop quantum gravity and four-dimensional spin-foam dynamics; source guardrail for linear simplicity and constrained BF-theory language in the null-edge simplicity-defect branch.

### 2. Massive relativistic particle model with spin from free two-twistor dynamics and its quantization

Score: `0.694`
Zotero key: `zotero:2T3HC5NC`
arXiv: `hep-th/0510161`
DOI: `10.1103/PhysRevD.73.105011`
URL: https://doi.org/10.1103/PhysRevD.73.105011

### 3. Massive twistor particle with spin generated by Souriau-Wess-Zumino term and its quantization

Score: `0.693`
Zotero key: `arxiv:1403.4127`
arXiv: `1403.4127`
DOI: `10.1016/j.physletb.2014.04.059`
URL: http://arxiv.org/abs/1403.4127

Abstract:

Two-twistor action for a massive spinning particle with Souriau-Wess-Zumino spin term; includes spin-dependent twistor shift modifying standard Penrose incidence relations.

### 4. Normalized Laplacians for gain graphs

Score: `0.691`
Zotero key: `S78BASEN`
DOI: `10.63151/amjc.v1i.3`
URL: https://doi.org/10.63151/amjc.v1i.3

### 5. An analysis of completely-positive trace-preserving maps on M2

Score: `0.687`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`
