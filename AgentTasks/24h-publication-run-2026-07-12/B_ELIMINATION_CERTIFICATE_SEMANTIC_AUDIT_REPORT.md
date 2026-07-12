# Summary of changes for run 246527ab-a1b6-4d7d-8aeb-74ad4c899f55
## Adversarial semantic audit — stationary-Weyl B-elimination certificate

**Target:** `PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylEliminationCertificate.lean`
**Sources cross-checked:** the exact generator `Scripts/oracle/certify_stationary_weyl_tangent_elimination.py`; the CAS/ideal memo `AgentTasks/24h-publication-run-2026-07-12/B_STATIONARY_WEYL_EXACT_IDEAL_CERTIFICATE_2026-07-12.md`; the elimination memo `.../B_STATIONARY_WEYL_TANGENT_ELIMINATION_2026-07-12.md`; the root-classification source `PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylRootClassification.lean`; and the live matrix in `PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylTangent.lean`.

### Verdict: SOUND WITH SCOPE CORRECTION
Every polynomial, sign, and integer scale is exactly faithful, the mandatory chart factor is present, the cancellation logic is correct, and the kernel accepts the identity (build succeeds; both theorems depend only on `[propext, Classical.choice, Quot.sound]`). The single correction is one of *scope*, not correctness: this certificate is a polynomial identity plus a one-directional real-root necessary condition — it is **not** the full four-root census and it is **not** connected to the live `weylStep` matrix. It makes no false claim, but must not be read/cited as the completed census.

### Findings, ordered by severity

**1 (Medium — scope, must accompany any citation).** The file is a self-contained polynomial artifact. `certFx/certFy/certFz` are transcribed from the memo's displayed numerator system; nothing in the file derives them from the imported live `weylStep` (defined in `StationaryAmplitudeWeylTangent.lean`, lines ~166–202), which never mentions these polynomials. **Owed bridge:** an entrywise-normalization proof that the three Pauli-coefficient numerators of `weylStep zx zy zz` — after substituting `z_j = (1−t_j²+2i t_j)/(1+t_j²)` and clearing the positive real denominators `(1+tx²)(1+ty²)(1+tz²)` — equal `±certFx, ±certFy, ±certFz` as `ℝ[tx,ty,tz]` elements. This is exactly step 3 of the tangent memo's proof program ("Aristotle project 5c45a7f6") and its remark that the numerators "should be reproved by entrywise normalization before being used in a kernel census." Until that is a kernel theorem, the certificate certifies an *asserted* system, not the matrix's system.

**2 (Low — naming/scope).** `realRootCensusOfNumeratorsZero` is a necessary condition only: `Fx=Fy=Fz=0 → tz=0 ∨ rootPoly=0 ∨ excludedPoly=0`. It is genuinely true and correctly proved, but the word "census" overreaches — it asserts neither sufficiency, nor solution existence, nor emptiness of the sextic branch (that emptiness is proved separately as `excludedPoly_pos` in the root-classification file). Additional census gaps flagged by the memos remain outside this file: the `tz=0` branch classification (memo step 5) and the omitted `q_j=π` tangent-chart boundaries (memo step 6).

**3 (Informational — cosmetic).** `certRootPoly`/`certExcludedPoly` are declared `(tx ty tz : Real)` but use only `tz`, producing four unused-variable linter warnings (lines 61, 68). Harmless; matches the generator's uniform signature convention.

### Item-by-item results (all pass)

1. **Numerators match displayed system:** ✓ All 39 coefficients of `certFx/Fy/Fz` (and all signs/scales) are byte-for-byte identical to the Python `FX/FY/FZ` and the memo's displayed `F_x/F_y/F_z`. The memo's "primitive normalization prints the negatives of F_x and F_z" caveat concerns the *numerical analyzer*, not this certificate; the certified file and its own Q-lift consistently use the displayed signs, and overall sign is ideal-immaterial.

2. **Root/excluded polynomials:** ✓ `certRootPoly` = `480tz⁵−575tz⁴−1026tz²+1440tz−575` and `certExcludedPoly` (all-positive sextic) match the Python constants, both memos, and — critically — the *independent* `rootPoly`/`excludedPoly` in `StationaryAmplitudeWeylRootClassification.lean`, where the quintic is proved to have exactly one real root (`rootPoly_existsUnique_real`) and the sextic to be strictly positive (`excludedPoly_pos`). (A combined diff of all 51 integer coefficients of Fx,Fy,Fz,rootPoly,excludedPoly against the sources returned no differences.)

3. **Quotients — no truncation/drift:** ✓ `certQx/certQy/certQz` reproduce the generator's exact shape: term counts 174 / 170 / 178 and total degrees 18 / 17 / 18, matching the memo's hash table row-for-row. Decisively, the proof closes by exact `ring` over ℝ, so any single-coefficient drift in the ~522 huge rational quotient terms would break the identity; the successful kernel build therefore validates every quotient coefficient simultaneously (a stronger guarantee than the SHA-256 table). The build was rebuilt from scratch here and passed.

4. **Mandatory factor / no false membership:** ✓ The theorem states `(1+tz²)² · tz · certRootPoly · certExcludedPoly = certQx·certFx + certQy·certFy + certQz·certFz`. The `(1+tz²)²` chart factor is present exactly as required. The file never states the *bare* product as an ideal membership; consistent with the memo's exact non-membership result and its instruction "The bare identity must not be stated as a Lean theorem."

5. **Real cancellation logic:** ✓ `realRootCensusOfNumeratorsZero` cancels only `(1+tz²)²`, discharged by `positivity` (`hchart`), and never cancels `tz` or the sextic. It then draws exactly the three permitted alternatives `tz=0 ∨ certRootPoly=0 ∨ certExcludedPoly=0` via two `mul_eq_zero` splits — no spurious or missing branch.

6. **Bridge to live matrix:** As stated in Finding 1, this certificate does not connect the numerator equations to `weylStep`; the owed bridge is the entrywise numerator-normalization identity (memo step 3).

No project files were modified.
