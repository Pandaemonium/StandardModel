# Q9 finite-gap prerequisite package - semantic audit report

Scope: semantic red-team review of the Q9 finite-gap prerequisite package added
in commit `5186598`. No build was run for this pass (per request); findings are
from source inspection of the kernel-checked statements. ASCII only.

## 1. Verdict

ACCEPT WITH CHANGES.

The package is a genuine finite hypothesis bundle. Every derived result is
either definition-level or an elementary consequence of the packaged strict
ordering, and the module makes no transfer-matrix, Hamiltonian, Wilson
slab-kernel, infinite-volume, or physical mass-gap claim. The one substantive
issue is a semantic gap between the two spectral real fields and the algebraic
cyclicity data: the docstrings assert an eigenvalue interpretation that nothing
in Lean enforces. This is a docstring / field-naming honesty fix, not a theorem
weakening.

## 2. Findings (ordered by severity)

### F1 (medium). Spectral reals are disconnected from the algebra/sector data.
`FiniteGapAssembly.FiniteGapPrereq` bundles a `LocalCyclicityPrereq H` (algebra,
vacuum, sector, `vacuum_mem`, `local_preserves_sector`, `cyclic`) together with
two *free* reals `lambda0 lambdaLocal : RealR` plus `lambda0_pos`,
`lambdaLocal_pos`, `lambdaLocal_lt_lambda0`. Nothing in the structure ties
`lambda0` or `lambdaLocal` to the spectrum of any operator in `localAlgebra`, to
membership of an eigenvector in `sector`, or to `vacuum`. Consequently the
cyclicity fields and the spectral fields are logically independent inside the
bundle; `localGap_pos` is proved purely from `lambdaLocal_lt_lambda0` and does
not use the cyclicity package at all.

This is consistent with the stated claim ("a finite hypothesis package that
names the assumptions"), so it is not a hidden overclaim. But it is the exact
place a later assembly could smuggle in a fake gap, so it must be called out and
is the natural next increment (see section 4/5).

### F2 (low). `localGap` / `localGlueballGap` is definitionally identical to `fluxGap`.
In `FluxSectorZ2`, both `fluxGap lambda0 lambdaFlux` and
`localGlueballGap lambda0 lambdaLocal` are defined as
`TransferGapDefinition.finiteMassGap lambda0 _` (they become `irreducible`
afterward). They are the same function; the only difference is the *name* of the
second argument. Using `localGlueballGap` rather than `fluxGap` in `localGap` is
therefore honest only at the naming level - it correctly signals "local/glueball
eigenvalue, not winding-flux eigenvalue" but carries no extra mathematical
content. This matches the claim language ("uses `localGlueballGap` ... not the
winding-flux gap"), so the answer to audit question 2 is: yes, honest, and
`localGap_eq_finiteMassGap` is correctly labeled definition-level (it reduces to
`localGlueballGap_eq_finiteMassGap`, which is `rfl`).

### F3 (low). Docstrings overstate what the reals are.
The field docstrings read "Leading eigenvalue in the selected vacuum/trivial-flux
sector" and "First local/glueball eigenvalue in the same sector," and the
structure docstring says the reals are the "leading vacuum-sector transfer
eigenvalue" and "first local/glueball eigenvalue after all sector restrictions."
Lean enforces none of this: they are arbitrary positive reals with a strict
order. The prose should say these are *named spectral parameters / placeholders*
that a later assembly must instantiate from an actual spectrum, not proven
eigenvalues. (Audit question 4: the names `lambda0`/`lambdaLocal` are fine as
identifiers; it is the docstrings that are too strong.)

### F4 (informational). Run-note artifacts referenced in the prompt are absent.
`AgentTasks/fourday-ym-run-2026-07-05/{LEDGER,RUN_PLAN,TASK_DIRECTIONS}.md` do
not exist in this snapshot (only `AgentTasks/aristotle-prompts/` and
`AgentTasks/context-packs/` are present). Ledger honesty (audit question 5) could
therefore not be checked against those files; the in-source docstrings of
`FiniteGapAssembly.lean` are honest and non-overclaiming.

## 3. Answers to the posed questions

1. Inputs: `FiniteGapPrereq` exposes cyclicity + sector preservation + vacuum
   membership + strict ordered spectral reals. It does NOT hide transfer
   self-adjointness, vacuum uniqueness, an eigenvector-membership fact, or a
   local-operator spectral theorem - it simply does not assert any of them, and
   `localGap_pos` needs none of them. No smuggled-in strong hypothesis found.
2. Yes, honest (see F2). `localGlueballGap` vs `fluxGap` is a nominal
   distinction over the same `finiteMassGap`, and `localGap_eq_finiteMassGap` is
   genuinely definition-level (`rfl`).
3. Bundling `LocalCyclicityPrereq` documents the fake-gap failure point but does
   not by itself prevent it, because the spectral reals are not tied to the
   cyclic sector (F1). A more precise field is warranted next (section 4).
4. The identifiers are acceptable; the docstrings are too strong (F3). Concrete
   fix below - relabel as parameters, or add a spectral-witness field.
5. The in-file docs are honest: doorstep / finite hypothesis package with no
   transfer-matrix, Hamiltonian, infinite-volume, or physical mass-gap claim.
   The external ledger could not be checked (F4).

## 4. Recommended claim-language / docstring corrections

Replace the eigenvalue-asserting docstrings with parameter-level language, e.g.:

- `lambda0`: "Named leading spectral parameter for the selected
  vacuum/trivial-flux sector. This is an input placeholder; nothing here proves
  it is an eigenvalue of `localAlgebra` on `sector`."
- `lambdaLocal`: "Named first local/glueball spectral parameter in the same
  sector; likewise an input placeholder, not a proven eigenvalue."
- Structure docstring: state explicitly that the reals are inputs a later
  assembly must instantiate from an actual spectrum, and that no field currently
  connects them to `localAlgebra`, `vacuum`, or `sector`.

## 5. Suggested next Lean-level structure to advance Q9 (no overclaim)

Add a field (or a successor structure extending `FiniteGapPrereq`) that ties the
spectral reals to the algebraic data, so a later gap claim cannot be vacuous.
Sketch (statements only; to be discharged by proof search, not weakened):

```
-- eigenvector witnesses inside the packaged sector
structure FiniteGapSpectralWitness (H : Type*) [AddCommGroup H] [Module RealC H]
    extends FiniteGapAssembly.FiniteGapPrereq H where
  transfer          : Module.End RealC H
  transfer_preserves : PreservesSubmodule ... sector      -- transfer keeps the sector
  vac_eigen         : transfer vacuum = (lambda0 : RealC) . vacuum
  excited           : H
  excited_mem       : excited in sector
  excited_ne_vac    : ... (excited independent of vacuum)
  excited_eigen     : transfer excited = (lambdaLocal : RealC) . excited
```

with `lambdaLocal < lambda0` then meaning a real spectral separation of two
genuine eigenvectors living in the cyclic sector. The honest next theorem is
that, given such a witness, `localGap` equals `finiteMassGap` of two actual
eigenvalues of a sector-preserving operator - still finite-volume, still no
Hamiltonian/infinite-volume claim, but no longer disconnected from the algebra.

Recommended next Q9 step: implement `FiniteGapSpectralWitness` (or the
equivalent eigenvector-membership fields) so the spectral reals are provably
eigenvalues of a sector-preserving transfer operator, closing the F1 gap before
any self-adjointness / infinite-volume work begins.
