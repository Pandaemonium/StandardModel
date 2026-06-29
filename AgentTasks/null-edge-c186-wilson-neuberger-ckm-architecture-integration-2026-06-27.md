# Summary of changes for run 7e8ae29b-ba3d-4650-aea6-afb44ce8d153
Delivered the concrete operator architecture for the first physical Gate C1 (`GateC1_NU`) reference: Wilson/Neuberger overlap dressed by a CKM **texture**, with a machine-checked nucleus.

**Files added**
- `RequestProject/GateC1Architecture.lean` — the formal architecture (builds clean, no proof placeholders, kernel dependencies only `propext`/`Classical.choice`/`Quot.sound`), imported by `RequestProject/Main.lean`.
- `GateC1_Architecture.md` — the full design note answering all six requested points.

**Verdict on the conceptual question.** Wilson/Neuberger + CKM-texture is correct *provided CKM enters as a flavor-factor unitary conjugation, not as an additive naive Dirac operator.* The naive additive route is exactly the 8+8 product/parity trap; the texture reading avoids it.

**1. Schematic operators (Lean: `Hne`, `Ht`, `Href`, `Arch.Dov`, `Arch.DovTex`).**
- `H_ne = γ5·D_W(-m0)`; `H_t = γ5·M_tex`; `H_ref = H_ne + κ·H_t`;
- `D_ov,ne = (ρ/a)(1 + γ5·sign(H_ref))` with `S := sign(H_ref)`, `S²=1`;
- texture-dressed `D_ov^tex = V·D_ov,ne·V⁻¹`.

**2. Where CKM lives.** In the finite branch/flavor tensor factor, as a unitary `V = 1⊗U_CKM` that commutes with `γ5` (field `V_comm`). It appears equivalently as the off-diagonal structure of `M_tex` in `H_t` (table/texture) and as the conjugation of the overlap (dressing). It is not a projector, boundary coupling, or additive Dirac operator.

**3. Avoiding the 8+8 trap (proved).** `parity_eight_eight_nogo`: any operator with a chirality-flipping parity involution `P` has vanishing sector signature `tr(γ5·D)=0`. `eight_eight_avoided`: a nonzero overlap signature is logically incompatible with such a `P`. `Arch.index_texture_invariant`: CKM conjugation preserves the signature, so the texture cannot reintroduce the trap.

**4. Null-edge-native after import.** Branch table, CKM texture `V`, sub-gap homotopy, path-shell control, and sector signatures stay native; only the Wilson kernel `D_W` and the Neuberger sign `S=sign(H_ref)` are imported.

**5. Certificate plug-in status.** Plug in directly and machine-proved: anomaly/index (Ginsparg–Wilson for both bare and dressed overlap, `Arch.ginspargWilson`, `Arch.ginspargWilson_tex`) and sector-signature stability (`Arch.index_texture_invariant`); determinant/ghost (Krein) and SM-internality plug in and are carried as certificate fields. Remaining open and carried as explicit named hypotheses: sub-gap homotopy for `H_ref=H_ne+κ·H_t` (the texture coupling can close the gap) and non-ultralocal/exponential-locality control of `sign(H_ref)`.

**6. Closure API.** `GateC1_NU` bundles the five derived conclusions plus the four certificates; `WilsonNeuberger_CKM_closes_GateC1_NU` proves that the architecture, the realized sector signature, and the four certificates yield `GateC1_NU` — discharging anomaly/index, texture-stability, and 8+8 exclusion internally. Upgrading the two open fields requires only replacing the `SubGapHomotopy`/`NonUltralocal` propositions with concrete spectral-gap and locality statements and discharging them; the rest of the closure is unchanged.
