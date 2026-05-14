# Hamming E8 final strengthening Aristotle jobs - 2026-05-07

Status: submitted 2026-05-07.

Purpose: strengthen the Hamming -> Construction A -> E8 manuscript after the
FB1/FB2 Sphere-Packing-Lean bridge integration.

The two jobs below are deliberately different in risk profile:

1. `L1` is the highest-priority focused manuscript bridge: turn the existing
   matrix/span/density provenance theorem into an explicit lattice map or
   equivalence statement.
2. `T1` is a moonshot: attempt a full theta-series formalization, but return
   finite shell-count theorems if the analytic/formal-power-series target is
   too large.

## Submission projects

```text
AgentTasks/aristotle-submit/hamming-e8-final-linear-bridge-20260507-v2-project
AgentTasks/aristotle-submit/hamming-e8-theta-moonshot-20260507-v2-project
```

## Submitted jobs

| Job | Output directory | Aristotle ID | Status |
|-----|------------------|--------------|--------|
| L1: explicit SPL linear bridge / isometry | `AgentTasks/aristotle-output/hamming-e8-spl-linear-bridge` | `b5fb49ef-e7ae-4954-93ae-5e74c19ceb83` | in progress |
| T1: full theta-series moonshot with shell-count fallback | `AgentTasks/aristotle-output/hamming-e8-theta-series-moonshot` | `1ac6693d-bc78-4435-ae08-6dabc4b95665` | queued |

Submission notes:

- The first attempted staging copy timed out after accidentally copying local
  nested `AgentTasks` output. The submitted projects are the `-v2-project`
  copies, which exclude `AgentTasks`, `.git`, `.lake`, and local cache
  directories.
- The L1 project has the upstream `SpherePacking` `[[require]]` block enabled
  in `lakefile.toml` for Aristotle's Linux environment.
- The T1 project keeps Sphere-Packing-Lean disabled so the theta job is
  independent of the platform-sensitive SPL dependency.

## Shared constraints

- Lean toolchain: `leanprover/lean4:v4.28.0`.
- Do not introduce `axiom`, `opaque`, `unsafe def`, `admit`, or trusted
  `sorry`.
- Trusted modules must be sorry-free.
- Draft modules may contain documented handoff statements only if the target is
  genuinely blocked.
- Do not weaken theorem statements silently.
- Keep convention choices explicit: Construction A integer norm has short
  squared norm `4`; scaled E8 norm divides the form by `2`; SPL uses the
  standard half-integer E8 model.

## L1: explicit SPL linear bridge / isometry

Write scope:

- Primary: `PhysicsSM/Draft/E8SpherePackingImported.lean`
- Optional helper under `PhysicsSM/Draft/`
- Do not modify trusted local files unless the helper is SPL-free and
  obviously reusable.

Context:

`PhysicsSM/Draft/E8SpherePackingImported.lean` already imports
`SpherePacking.Dim8.E8.Basic`, `SpherePacking.Dim8.E8.Packing`, and
`PhysicsSM.Coding.E8SpherePackingMatrixBridge`.

The file currently proves:

```lean
local_splE8BasisQ_eq_imported_E8Matrix_Q
local_splE8BasisQ_span_eq_imported_E8_Q
splE8GramQ_eq_imported
constructionA_to_E8_full_bridge
e8_packing_density_from_spl
e8_density_with_bridge_documentation
```

The remaining documented gap is:

```text
Construction A basis
  ->[e8BasisChangeMatrix]      E8 simple roots / Cartan basis
  ->[splToCartanTransition^-1] SPL basis rows (= E8Matrix Q rows)
  ->[span_E8Matrix]            Submodule.E8 Q or Submodule.E8 R
```

Task:

Build the strongest explicit bridge you can from the Construction A lattice
model to imported `Submodule.E8`.

Preferred endpoint:

```lean
-- Names may be adjusted if the exact type needs to differ.
noncomputable def constructionAToImportedE8LinearMap :
    (Fin 8 -> Z) ->ₗ[Z] (Fin 8 -> R)

theorem constructionAToImportedE8LinearMap_mem
    (z : Fin 8 -> Z) (hz : z ∈ e8IntLattice) :
    constructionAToImportedE8LinearMap z ∈ Submodule.E8 R

theorem constructionAToImportedE8LinearMap_preserves_scaled_norm
    (z : Fin 8 -> Z) :
    -- express that the Euclidean norm of the image equals sqNorm z / 2
```

If possible, package the map as a `LinearEquiv` or isometry-shaped theorem
between the `Z`-span of the Construction A basis and the imported SPL row span.

Acceptable fallback endpoints, in order:

1. A checked matrix theorem giving the explicit composite transition matrix
   from the Construction A scaled Gram matrix to the imported SPL Gram matrix.
2. A checked theorem that each of the eight Construction A basis vectors maps
   to an element of `Submodule.E8 R` under the intended composite.
3. A checked theorem that the composite transition matrix is unimodular and has
   the correct Gram-congruence identity.
4. A precise draft theorem statement with all blockers documented, but only if
   the proof is genuinely blocked by missing API.

Constraints:

- Keep all SPL-dependent code in `PhysicsSM/Draft`.
- Do not claim full density transfer to the Construction A packing unless the
  map/equivalence and scaling statement are actually proved.
- Prefer explicit finite matrix identities over abstract classification of E8.
- Use existing matrices:
  `e8BasisChangeMatrix`, `splToCartanTransition`, `e8ScaledGramQ`,
  `splE8GramQ`, and theorem `spl_gram_congruent_to_scaled_constructionA`.

Minimum useful result:

- A sorry-free theorem that materially narrows the remaining linear bridge gap
  and can be cited in the manuscript.

## T1: full theta-series moonshot with shell-count fallback

Write scope:

- Preferred new trusted file: `PhysicsSM/Coding/E8ThetaSeries.lean`
- Optional draft file: `PhysicsSM/Draft/E8ThetaSeriesMoonshot.lean`
- Update `PhysicsSM.lean` only if the new file is trusted and SPL-free.

Context:

The project already proves:

```lean
shortHammingE8Vector_count_eq_240
scaledE8_minSqNorm_two
extendedHamming8WeightEnumerator
extendedHamming8_macwilliams_selfdual_general
```

The manuscript currently treats theta-series work as future work. A strong
result here would make the paper more ambitious. The full target is likely
hard; finite shell counts are an excellent fallback.

Moonshot target:

Define a formal theta-series object for the Hamming Construction A E8 lattice,
using whatever representation is most tractable in the current project:

- a formal power series;
- a coefficient function `thetaCoeff : N -> N`;
- or a bounded-shell enumerator that is later compatible with a formal power
  series.

Then prove the E8 theta-series identity as far as the available infrastructure
allows:

```text
Theta_E8(q) = E4(q) = 1 + 240 * sum_{n >= 1} sigma_3(n) q^n
```

If the full analytic/formal-power-series statement is too much, do not churn.
Return the strongest finite theorem package you can prove.

Fallback targets, in order:

1. Define `thetaCoeffE8Scaled : N -> N` for the scaled E8 lattice and prove:
   - `thetaCoeffE8Scaled 0 = 1`
   - `thetaCoeffE8Scaled 1 = 240`
   - `thetaCoeffE8Scaled 2 = 2160`, if feasible
   - `thetaCoeffE8Scaled 3 = 6720`, if feasible
2. If the scaled indexing is awkward, use unscaled Construction A norm:
   - norm `0` count is `1`
   - norm `4` count is `240`
   - norm `8` count is `2160`, if feasible
   - norm `12` count is `6720`, if feasible
3. Prove a clean finite enumeration API:
   - coordinate bounds for each shell;
   - membership predicate for shell vectors;
   - list length/nodup/membership/completeness theorems for the first shells.
4. Prove the coefficient formula for the first few shells:
   `240 * sigma_3(1) = 240`,
   `240 * sigma_3(2) = 2160`,
   `240 * sigma_3(3) = 6720`.

Constraints:

- Do not import Sphere-Packing-Lean for this job.
- Do not add analytic convergence assumptions unless they are fully formalized.
- It is acceptable to use `native_decide` for finite shell enumeration, but
  document the trust boundary.
- If full formal power series are attempted, prefer mathlib's existing APIs.
- Keep all theorem statements honest about the chosen indexing convention.

Minimum useful result:

- A trusted sorry-free file proving at least the first nontrivial theta
  coefficient beyond the already known kissing number, or a documented draft
  explaining exactly why the coefficient enumeration needs more infrastructure.
