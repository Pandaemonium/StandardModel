# Literature pass: the physical sector should be quasi-local and asymptotically invariant

Date: 2026-07-21
Owner: Codex / Archivist and Visionary pass
Work item: `QCA-3PLUS1-001`

## Finding

The strongest literature-supported interpretation of the HNU construction is
not an exactly invariant coordinate block at every finite lattice spacing. It
is a low-energy band bundle separated from its compensating high-energy sector
by a gap and transported by a local protocol, with mixing controlled by an
adiabatic or changing-regulator estimate.

This relaxes the right assumption. It does not relax locality, unitarity, the
full-register topological accounting, or convergence to the intended continuum
flow.

## Primary-source anchors

1. Sun, Xiao, Bzdusek, Zhang, and Fan, *Three-dimensional Chiral Lattice
   Fermion in Floquet Systems*, Phys. Rev. Lett. 121, 196401 (2018),
   arXiv:1806.09296. The full lattice still has balanced chirality, but an
   adiabatically decoupled low-energy block can carry nonzero net Weyl
   chirality. The compensating chirality remains in the high-energy block.
   The paper explicitly requires a finite instantaneous gap and evolution slow
   relative to that gap. This is very close to the semantic role needed by the
   live HNU companion sector.

2. Hastings and Wen, *Quasiadiabatic continuation of quantum states: The
   stability of topological ground-state degeneracy and emergent gauge
   invariance*, Phys. Rev. B 72, 045141 (2005),
   DOI:10.1103/PhysRevB.72.045141. A gapped spectral sector is transported by a
   quasi-adiabatic continuation with locality inherited in a controlled
   quasi-local form. Zotero key: `UAFBVV8V`.

3. Nachtergaele, Sims, and Young, *Quasi-Locality Bounds for Quantum Lattice
   Systems. Part I. Lieb-Robinson Bounds, Quasi-Local Maps, and Spectral Flow
   Automorphisms*, J. Math. Phys. 60, 061101 (2019), arXiv:1810.02428.
   Lieb-Robinson and spectral-flow methods make precise why the correct
   interacting low-energy encoding is generally quasi-local rather than a
   finite-range coordinate projector. Zotero key: `IPSPMUJG`.

4. Sadel and Schulz-Baldes, *Topological boundary invariants for Floquet
   systems and quantum walks*, Math. Phys. Anal. Geom. 20 (2017),
   arXiv:1708.01173. A spectral gap of the Floquet unitary supports band and
   time-dependent bulk invariants; endpoint-band data and full micromotion are
   distinct inputs.

## Consequence for the null-edge gate

The exact result in `SectorInteractionClassification.lean` remains valuable:
for a fixed coordinate projector `P`, exact invariance is equivalent to zero
cross blocks. But it should be treated as the zero-leakage endpoint of a
hierarchy, not as the only acceptable physical-sector definition.

The proposed hierarchy is:

1. **Full-register truth.** Keep the complete four-band HNU/Floquet evolution.
   Its opposite-chirality companion is part of the microscopic accounting and
   must never be deleted from the full spectrum.
2. **Band definition.** Define a low-energy projector `P_a(q,t)` from an
   isolated spectral cluster of an instantaneous finite Hamiltonian or a
   gapped Floquet branch. Record the gap `Delta_a` explicitly.
3. **Moving-sector transport.** For substeps `U_{a,k}`, bound
   `||(1-P_{a,k+1}) U_{a,k} P_{a,k}|| <= delta_{a,k}`.
4. **Finite-time accumulation.** Prove a moving-projector telescope
   `leakage <= sum_k delta_{a,k}`. Exact intertwining is the special case
   `delta_{a,k}=0`.
5. **Continuum gate.** Under the actual depth schedule `N(a)`, require
   `sum_{k < N(a)} delta_{a,k} -> 0`. A sufficient uniform condition is
   `N(a) * delta(a) -> 0`.
6. **Quasi-locality gate.** Show that the band encoding or spectral flow has
   tails controlled uniformly enough that truncation range can increase while
   physical leakage and truncation error both vanish.
7. **Interaction gate.** For an admissible local interaction, prove either
   exact cross-block cancellation by symmetry or a gap-dependent leakage bound
   that survives the changing-lattice limit.

## New theorem ladder

The next finite targets should be attacked in this order:

1. Moving-projector product identity and norm telescope.
2. A gap-to-projector perturbation bound for finite Hermitian matrices.
3. An explicit two-block witness with nonzero finite-step leakage that tends
   to zero under a displayed slow schedule.
4. Instantiate the bound on the doubled HNU kinetic-plus-Pluecker family.
5. Add one finite local interaction and calculate its selected/complement
   cross block.
6. Either prove the cross block is symmetry-forbidden or choose an interaction
   scaling and locality range for which total finite-time leakage vanishes.

## Scientific claim enabled if the ladder closes

> The complete local unitary retains the compensating microscopic sector
> required by lattice topology, while a gapped quasi-local low-energy encoding
> becomes dynamically autonomous in the continuum limit. The physical Weyl or
> Dirac field is that asymptotically invariant band, not a coordinate block
> obtained by deleting the companion sector.

This would be stronger and more physical than demanding a strictly local sharp
projection. It would also align the program with the literature's accepted way
of reconciling an effectively chiral sector with complete lattice accounting.

## Kill conditions

- The live HNU family admits no uniformly isolated band over the region used
  in the continuum theorem.
- The required spectral projector has tails that cannot be controlled under
  any admissible locality-range schedule.
- Interaction-induced leakage accumulates to a nonzero finite-time limit.
- The low/high split closes its gap under the intended Pluecker or gauge
  perturbation.
- The proposed low-energy block is selected only by a nonlocal projection with
  no quasi-local approximation or operational preparation.

## Provenance notes

The arXiv:1806.09296 full text was searched in the local Neo4j paper graph, not
only by abstract. Hastings-Wen and Nachtergaele-Sims-Young were checked against
publisher/arXiv metadata and added to Zotero after a title-level duplicate
check. No external Lean code was imported.
