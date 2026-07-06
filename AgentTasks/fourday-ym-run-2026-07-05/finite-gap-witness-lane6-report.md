# Lane 6 finite-gap witness: sharpening report

Status date: 2026-07-05
Scope: one-link Z2 finite-gap witness pathway toward a physical-sector transfer.
Constraint honored: no claim of a Wilson slab transfer, Hamiltonian,
infinite-volume theorem, or physical mass gap.

## Patch or no-patch verdict

**Patch.** A new kernel-checked module was added:

`PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferZ2Sector.lean`

It builds cleanly under the pinned toolchain (`lake build
PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferZ2Sector` succeeds), contains no
`s o r r y`, no `a d m i t`, and no `n a t i v e _ d e c i d e`. It is registered in the
`PhysicsSM/Draft/NullEdge/GateYM.lean` aggregator (import plus module docstring
entry).

This delivers preference tier 1 (a kernel-checked helper connecting the one-link
Z2 transfer bridge more tightly to the finite-gap witness API) together with
tier 2 (a precise honest witness structure with cyclicity/sector-preservation
separated as hypotheses) and tier 3 (the exact obstruction to a physical
single-sector instantiation, stated as kernel-checked lemmas).

## Semantic alignment

The pre-existing pathway is:

- `TwoStateTransferZ2L1` — the exact one-link (`L = 1`) Z2 Wilson slab kernel
  `slabTransfer beta`, proved equal to the two-state payload `!![a,b;b,a]` with
  `a = 2 e^beta`, `b = 2 e^{-beta}`. It already carries genuine physics:
  center-flip involution, `+1/-1` center-sector projectors, flux insertion,
  and finite-time trace/correlation identities with contraction factor
  `tanh beta`.
- `TwoStateTransferWitness` / `FiniteGapAssembly` — the abstract
  `FiniteGapSpectralWitness`, instantiated for the descriptor via
  `topCyclicityPrereq`: **whole** two-state space as the sector, **full**
  endomorphism algebra as the local algebra, rank-one cyclic map.

The semantic gap this exposed: `FiniteGapSpectralWitness` requires the vacuum
and the excitation to lie in **one** sector (`vacuum_mem_sector` and
`localExcitation_mem_sector` both reference `prereq.sector`), and it labels the
resulting quantity `localGap = FluxSectorZ2.localGlueballGap`, i.e. the
*within-trivial-flux-sector* local/glueball gap. But in the one-link Z2 model
the physical facts are:

- the vacuum `(1,1)` lives in the `+1` center sector,
- the flux excitation `(1,-1)` lives in the `-1` center sector,
- these are **distinct** one-dimensional eigenspaces.

So the toy witness silently substitutes a **center-flux gap** for a
**local/glueball gap** — exactly the kill condition flagged in
`GOAL_STATEMENT_ACHIEVABLE_WORK.md` / the program queue Q3
("if the lowest excitation is always a global flux sector, the finiteMassGap
theorem target must be renamed and redefined - no silent substitution").

The new module realigns the honest content: it uses the two genuine center
sectors, names the gap `FluxSectorZ2.fluxGap` (the winding/center-flux gap,
explicitly *not* `localGlueballGap`), and keeps the `tanh beta` contraction
factor tie-back to the oracle.

## Smallest honest witness target

The smallest honest physical-sector consumer is a **two-sector flux-gap
witness**, not a single-sector local-gap witness. It is realized by the new
structure

```
structure FiniteFluxGapWitness (H) [AddCommGroup H] [Module C H] where
  transfer : Module.End C H
  vacuumSector fluxSector : Submodule C H
  lambda0 lambdaFlux : R
  lambda0_pos : 0 < lambda0
  lambdaFlux_pos : 0 < lambdaFlux
  lambdaFlux_lt_lambda0 : lambdaFlux < lambda0
  transfer_preserves_vacuumSector : forall v in vacuumSector, transfer v in vacuumSector
  transfer_preserves_fluxSector   : forall v in fluxSector,   transfer v in fluxSector
  vacuum : H ; vacuum_mem ; vacuum_ne_zero ; vacuum_eigen (lambda0)
  fluxExcitation : H ; fluxExcitation_mem ; fluxExcitation_ne_zero ; fluxExcitation_eigen (lambdaFlux)
  sectors_disjoint : vacuumSector \sqcap fluxSector = bot
```

with `fluxGap := FluxSectorZ2.fluxGap lambda0 lambdaFlux` and the derived facts
`fluxGap_pos`, `exp_neg_fluxGap_eq_ratio`, `fluxExcitation_ne_vacuum`.

It is instantiated honestly from the one-link slab by `fluxGapWitness beta
hbeta` (for `0 < beta`), with:

- `vacuumSector = span{(1,1)}`, `fluxSector = span{(1,-1)}`,
- `transfer = (slabTransfer beta).mulVecLin`,
- `lambda0 = 2(e^beta + e^{-beta})`, `lambdaFlux = 2(e^beta - e^{-beta})`,
- `fluxGapWitness_exp_neg_gap_eq_tanh : exp(-fluxGap) = tanh beta`.

All hypothesis fields (sector preservation, membership, disjointness) are
discharged from the exact slab eigenvector equations
(`slabTransfer_mulVec_vacuum`, `slabTransfer_mulVec_local`), not from a
whole-space shortcut.

## Exact missing fields/hypotheses

A genuine **single-sector** `FiniteGapSpectralWitness` over a *physical* center
sector of this model is impossible, and the obstruction is now pinned down as
kernel-checked lemmas:

- `transfer_scalar_on_vacuumSector` / `transfer_scalar_on_fluxSector`: on each
  one-dimensional center sector the transfer acts as a single scalar
  (`lambda0` resp. `lambdaFlux`).
- `no_local_gap_in_vacuumSector`: any two eigenvalues realized by nonzero
  vectors of the vacuum sector coincide.

Therefore the blocking field is precisely `FiniteGapSpectralWitness`'s
`localExcitation_mem_sector` (the demand that the second eigenvector live in the
*same* `prereq.sector` as the vacuum). In the `L = 1` Z2 model each physical
center sector is 1-dimensional, so it hosts no within-sector excitation and no
second eigenvalue; the only nonzero honest gap is the cross-sector flux gap.

What is still genuinely missing before a physical *local/glueball* witness (as
opposed to this honest flux witness) can be instantiated:

1. **A larger spatial volume (`L >= 2`) or richer local algebra** so that the
   trivial-flux (`+1` center) sector is more than one-dimensional and can carry
   a genuine local/glueball excitation with a strictly sub-vacuum eigenvalue.
2. **Cyclicity of the actual local plaquette algebra** (not the full
   endomorphism algebra) on that trivial-flux sector — the still-`Prop`-level
   `CyclicityPrereq.LocalAlgebraCyclicInSector` for a *physical* algebra, which
   remains uninstantiated for any non-toy sector.
3. **Sector/quantum-number preservation of the transfer** at the honest
   algebra/sector level (`FluxSectorZ2.PreservesQuantumNumbers`), currently
   available as identities on projector matrices but not yet wired into a
   `FiniteGapPrereq` with a non-`top` local algebra.

These three are the honest gates between the current finite witness and a
physical-sector local/glueball witness; none is claimed here.

## Next theorem statement

The next honest increment is an `L = 2` (or general odd-channel) trivial-flux
sector of dimension `>= 2` in which the transfer has two distinct eigenvalues,
feeding a genuine single-sector witness. A concrete target statement:

```
theorem trivialFluxSector_has_local_gap (beta : R) (hbeta : 0 < beta) :
    exists (H : Type) (_ : AddCommGroup H) (_ : Module C H)
      (P : FiniteGapAssembly.FiniteGapPrereq H),
        P.localAlgebra != (top : Subalgebra C (Module.End C H))   -- genuine local algebra
      /\ P.sector.FG /\ 2 <= Module.rank C P.sector               -- non-trivial trivial-flux sector
      /\ 0 < P.localGap                                            -- honest local/glueball gap
```

i.e. exhibit a `FiniteGapPrereq` whose sector is the trivial-flux (`+1` center)
subspace of an `L >= 2` Z2 slab, whose local algebra is the genuine plaquette
algebra (not `top`), and whose `localGap` (a within-sector local/glueball gap)
is positive. Proving it requires discharging obstruction items (2) and (3)
above for the enlarged model; until then the honest deliverable is the
cross-sector `FiniteFluxGapWitness` established in this patch.
```
