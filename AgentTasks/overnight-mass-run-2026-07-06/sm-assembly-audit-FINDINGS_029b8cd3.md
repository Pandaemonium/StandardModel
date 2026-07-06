# Adversarial audit — lane-C gap assembly + TY area-law tie-back

Scope: `SlabGapAssembly.lean`, `SlabClustering.lean`, `TYAreaLaw.lean`,
`TwoStateTransferZ2Sector.lean`. Deps `OSReconstruction`, `SlabTransferGap`,
`SlabSignRepGap`, `TwoStateTransferZ2L1` are NOT attached; claims about their
internals are flagged as unverifiable from here.

## Per-target verdicts

### 1. `TYAreaLaw.partitionRatio_eq_exp_neg_osSpectralGap` — SOUND (needs caveat)
The Lean statement `partitionRatio β = exp(-osSpectralGap β)` is a TRUE finite
identity (both sides `= tanh β`), so it is not a false claim. But it is a
*coincidental, essentially definitional* identity on the exactly-solvable
one-link Z2 slab:
- `partitionRatio β = Zminus β / Zplus β` where `Zplus`/`Zminus` are the
  *defined* one-plaquette Boltzmann sums `e^β ± e^{-β}` (see `Zplus`, `Zminus`).
  It is not derived from an actual lattice partition function; it is built to be
  `tanh β` (`partitionRatio_eq_tanh`).
- `osSpectralGap β = -log(tanh β)` (via `slabSpectralGap_eq_osSpectralGap`), so
  the RHS is `exp(-(-log tanh β)) = tanh β` by construction.
Both a vortex/'t Hooft free-energy object and a transfer-Hamiltonian gap reduce
to the same scalar *only because* this abelian one-plaquette model collapses
them. A reader could wrongly infer "area law = spectral gap" in general.

**Honest caveat to attach:** *"Coincidental scalar identity special to the
exactly-solvable one-link Z2 slab. It does NOT assert that the area-law string
tension equals the transfer-Hamiltonian spectral gap in general; the two are
physically distinct and coincide here only because both reduce to the same
one-plaquette Boltzmann ratio `tanh β`. `Zplus`/`Zminus` are modeled Boltzmann
sums, not a derived lattice partition ratio, so this identity is largely
definitional."*

### 2. `TYAreaLaw.tyAreaLaw_slab_exp` — SOUND but REPACKAGES (mild over-claim in tag)
- `hW : |W| ≤ 2·(tyBase β)^r` is satisfiable non-trivially (`tyBase β ∈ (0,1/2)`,
  so the RHS is a concrete positive real; `W = 0` and all small `W` satisfy it).
  Not vacuous.
- The theorem does NOT prove an area law. Its second conjunct is a pure rewrite
  of `hW` through `tyBaseOf_rpow_eq_exp` (`(tyBase β)^r = exp(-(r·tyStringTension β))`).
  The genuine RP/Cauchy–Schwarz content that would *produce* `|W| ≤ 2·q^r` is
  taken as the hypothesis `hW`/`hq` in `tyAreaLaw`/`tyAreaLaw_slab`. So it
  REPACKAGES an assumed area law; only the first conjunct
  (`tyStringTension_pos`, a strictly positive rate) is unconditional content.
- Module-level honesty: EXCELLENT. The module docstring's "What is fully proved
  vs modeled" list explicitly says `hW`, `hq`, and the `Z`/`Z⁻` identification
  are *modeled, not proved*, and that the file "never smuggles the area-law bound
  in as an axiom." That is accurate.
- Local nit: the one-line docstring tag "**Positive-rate corollary … (non-vacuous)**"
  plus "the Wilson loop decays as …" reads as if decay is *derived*; the decay
  conjunct is only a re-expression of the hypothesis. The "(non-vacuous)" label
  fairly applies to the positivity conjunct only.

### 3. `SlabGapAssembly.SlabGapChain.clustering` — WEAKER-THAN-NAMED (per-`m` `∃C` is vacuous)
Field shape: `∀ (m) (v w), ∃ C, ‖connected β m v w‖ ≤ C · exp(-(m·gap))`.
Because `C` is chosen *after*, and may depend on, `m` (and `v,w`), for each fixed
`m` the factor `exp(-(m·gap))` is a fixed positive constant, so any finite
`‖connected‖` satisfies the bound for large enough `C`. As a *decay in `m`*
statement it is VACUOUS: genuine clustering needs `C` INDEPENDENT of `m`.

This is strictly WEAKER than what is actually proved. The bundle under-states its
own input (and, read as "clustering," is misleadingly empty).

### 3b. `slab_exponential_clustering` / `slab_connected_correlation_eq` — constant IS uniform in `m`. CONFIRMED.
`slab_exponential_clustering` proves
`‖connected β n v w‖ ≤ ‖(star v ⬝ᵥ localVec)·(star localVec ⬝ᵥ w)/2‖ · exp(-(n·gap))`.
The constant `‖(star v ⬝ᵥ localVec)·(star localVec ⬝ᵥ w)/2‖` depends on `v,w`
only — it contains no `n`. Likewise `slab_connected_correlation_eq` gives the
exact `connected = ratio^n · (⟪v,flux⟫⟪flux,w⟫/2)` with an `n`-free coefficient.
So the underlying result is genuine uniform-in-`m` exponential clustering.

**Recommended honest field** (matches what is already proved; pull `C` out of
`∀ m`, or inline the explicit constant):
```
clustering : ∀ (v w : Fin 2 → ℂ) (m : ℕ),
  ‖SlabClustering.slabConnectedCorrelation beta m v w‖
    ≤ ‖(star v ⬝ᵥ TwoStateTransferZ2L1.localVec) *
        (star TwoStateTransferZ2L1.localVec ⬝ᵥ w) / 2‖
      * Real.exp (-(m * OSReconstruction.osSpectralGap beta hbeta))
```
or, if an existential is preferred, quantify it uniformly:
`∀ v w, ∃ C, ∀ m, ‖…‖ ≤ C · exp(-(m·gap))`. Both are discharged verbatim by
`SlabClustering.slab_exponential_clustering`.

### 4. `SlabGapAssembly.slabGapAssembly` — OVER-CLAIM (mild): honest per-field, unified framing not exhibited in-file
The six fields are NOT all about one object:
- `rp_posSemidef`, `transfer_isHermitian`: about `SlabTransferGap.slabTransferBlock
  beta signRho` (an RP Gram/transfer block, dimension unseen).
- `gap_pos`, `gap_value`: about `OSReconstruction.osSpectralGap` (an OS/GNS-
  reconstructed Hamiltonian gap).
- `vacuum_separated`: about `TwoStateTransferZ2Sector.lambdaFlux/lambda0` (2×2
  two-state transfer eigenvalues).
- `clustering`: about `SlabClustering.slabNormTransfer` (`lam0`-normalized 2×2
  `slabTransfer`).
Fields 3–4–5–6 ARE mutually consistent (all pinned to `tanh β`:
`osSpectralGap = -log tanh β`, `lambdaFlux/lambda0 = tanh β = exp(-fluxGap)`).
The UNVERIFIED bridge is 1–2 ↔ 3–6: nothing in the attached files shows that
`osSpectralGap` is the spectral gap OF the PSD/Hermitian `slabTransferBlock
signRho` — it is linked only by naming and by the shared `tanh β` value. So
"single gap chain" conjoins the RP of one operator with the spectral gap of
another without an in-file identification. This is exactly the three-gaps
equivocation the strategic review warned about, at the seam between (2)/(3)
[area-law/vortex object and transfer-Hamiltonian gap] and the RP block.
The module docstring is honestly worded ("each already kernel-checked
*elsewhere*", conjunction "only makes the CONJUNCTION citable"), and it correctly
disclaims SU(N)/continuum scope — so the over-claim is in the "chain" *framing*,
not in a false Lean statement.

### 5. Trust surface — SOUND for attached files; unverifiable deps flagged
- No `sorry` / `axiom` / `native_decide` / `admit` in any attached file (the grep
  hits are all inside prose/docstrings that deliberately spell the words out).
- The four attached files' proofs are ordinary term/tactic proofs.
- CANNOT verify from here: `OSReconstruction` (`osSpectralGap`, `osSpectralGap_pos`,
  `osSpectralGap_eq_neg_log_tanh`, `osVacuum_separated`, `slabOsTransfer_*`),
  `SlabTransferGap` (`slabTransferBlock_posSemidef`, `_isHermitian`,
  `neU4ClosureGap`), `SlabSignRepGap`, `TwoStateTransferZ2L1`. The docstring claim
  "Axiom-guarded in `SlabAxiomGuard`" is likewise unverifiable from the attached
  set. The whole assembly's trust rests on these.
- Secretly-weaker-than-named: the `clustering` field (target 3) — name/docstring
  promise exponential decay "at exactly the gap rate," the statement delivers a
  vacuous per-`m` bound.

## Single most misleading item + exact fix
**`SlabGapAssembly.SlabGapChain.clustering`.** Its docstring says the connected
two-point function "decays as `exp(-(n·gap))` … at exactly the gap rate," but the
`∀ m, ∃ C, …` shape lets `C` depend on `m`, which makes the bound trivially true
for every fixed `m` and asserts no decay at all. Replace with the `m`-uniform
statement already proved by `SlabClustering.slab_exponential_clustering` (see the
recommended field in §3), i.e. move `∃ C` outside `∀ m` or inline the explicit
`m`-free constant `‖(star v ⬝ᵥ localVec)·(star localVec ⬝ᵥ w)/2‖`.

## Does this invalidate "the finite Z2 closure gap chain"?
No. The core numeric facts are genuine, finite, kernel-checked results on the
exactly-solvable Z2 slab: RP-PSD and Hermitian transfer block; strictly positive
gap; `gap = -log(tanh β)`; `lambdaFlux < lambda0`; and — crucially — the
UNDERLYING clustering lemma is real uniform-in-`m` exponential decay. The defects
are (a) the assembly's `clustering` field understates that lemma (trivial fix),
and (b) framing that could be over-read as "area law = spectral gap" or as
SU(N)/continuum results — both already disclaimed in the docstrings and should
also carry the §1 caveat. With the clustering field strengthened and the caveats
attached, the bundle stands as an honest finite Z2 closure gap chain. It neither
establishes nor claims the SU(N) Yang–Mills mass gap, and the area-law theorem
`tyAreaLaw_slab_exp` repackages (does not prove) the RP area-law input.
