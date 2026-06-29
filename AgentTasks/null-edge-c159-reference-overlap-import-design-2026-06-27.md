# C159 — NullEdgeReferenceOverlapImport theorem package (design)

Companion kernel-checkable skeleton: `RequestProject/C159_ReferenceImport.lean`
(builds clean under Mathlib v4.28.0; all theorems are a x i o m-free).

---

## Executive verdict

The import from a known overlap / flavored-overlap / domain-wall reference kernel to a
`GateC1_NU` release is a **certificate-composition theorem**, not a single deep proof. The
finite null-edge seed (C145) is an *input*, never the output. The theorem's job is to state
the contract under which (sector-signature match) + (uniformly gapped homotopy) + (a small,
fixed list of separately-audited certificates) compose into the non-ultralocal release.

The structural backbone of that contract is **machine-checkable today** and is checked in the
companion Lean module: the import theorem composes correctly; the finite seed alone does not
entail the release; `GateC1_NU` is strictly weaker than `GateC1_local`; and the
anomaly/index, ghost/determinant-line, and control/locality conclusions are each unreachable
without their explicit certificate (no homotopy-only shortcut). What is **not** yet checkable
is the analytic content of the transport lemmas (functional calculus of `sign(H_ne)`, GW
algebra of `D_ov_ne`, the gap-continuity argument). Those are the genuine open work and are
deliberately isolated as the `Transport` fields, so the surrounding architecture is final
even before they land.

---

## 1. Precise theorem statement (prose)

> **NullEdgeReferenceOverlapImport.** Fix a null-edge overlap construction
> `H_ne = Γ_K (D_ne + W_branch − m₀ R)`, `T_br = sign(H_ne)`,
> `D_ov_ne = ρ (1 + Γ_K T_br)`, together with a known reference overlap (or
> flavored-overlap / domain-wall) kernel `D_ref` whose GW algebra, one-Weyl light content,
> and bad-sector inverse gap are already established.
>
> Suppose:
> 1. **(finite seed)** the finite branch × flavor × qutrit kernel `D_ne` carries the C145
>    kernel-only witness;
> 2. **(sector-signature match)** the seed and the reference agree on their sector signature
>    (the J-graded / flavor-graded sign data that the reference's overlap class depends on);
> 3. **(uniform gap homotopy)** there is a homotopy of Hermitian (or Hilbertized–Krein)
>    operators from `H_ne` to the reference Hamiltonian that is **uniformly gapped away from
>    0** along the whole path;
> 4. **(mass window)** the C160 mass-window / sign-straddling certificate holds (so the
>    relevant sector of `sign(H_ne)` is in the anticommuting / sign-straddling regime, not a
>    J-even-dominated regime — cf. the C138 caution);
> 5. **(separate certificates)** explicit anomaly/index, ghost/determinant-line, and
>    control/locality certificates are supplied.
>
> Then `D_ov_ne` inherits, from the reference along the gapped homotopy and the supplied
> certificates: the GW algebra, one physical Weyl per generation in the light sector, an
> inverse-propagator gap on the bad sector, healthy anomaly/index data, the ghost rule, and
> non-ultralocal control. That conjunction **is** the `GateC1_NU` release.
>
> If in addition an exponential-locality certificate is supplied, `GateC1_NU` promotes to
> `GateC1_local`.

Two scope clauses are part of the statement, not afterthoughts:
- the conclusion is about `D_ov_ne`, **not** about `D_ne` (the seed is not the release);
- locality is **excluded** from `GateC1_NU` and is only reachable via the extra certificate.

---

## 2. Lean / API sketch

See `RequestProject/C159_ReferenceImport.lean` for the compiling version. Shape:

```text
structure Data                       -- all propositional content (seed*, ref*, bridge, *Cert)
structure Transport (D : Data)       -- the load-bearing transport/import implications
structure InputsNU  (D : Data)       -- supplied inputs (NU; no locality cert)
structure GateC1_NU    (D : Data)    -- the non-ultralocal release (conjunction of seed*)
structure GateC1_local (D : Data)    -- GateC1_NU + seedUltralocal  (strictly stronger)

theorem nullEdgeReferenceOverlapImport (D) (T : Transport D) (I : InputsNU D) : GateC1_NU D
theorem promoteToLocal  (D) (rel : GateC1_NU D) (T : Transport D) (h : D.ultralocalCert)
                                                                 : GateC1_local D
theorem local_implies_NU (D) : GateC1_local D → GateC1_NU D
```

Each physical statement is an abstract `Prop` field. When the analytic layer is built, the
`Prop` fields of `Data` become operator statements (`IsGinspargWilson D_ov_ne`, etc.) and the
`Transport` fields become real lemmas; the theorem and all structural checks keep their shape.

The names requested by other jobs map in as follows: C160's
`NullEdgeMassWindow` / `SignStraddlingKernel` / `SectorSignatureStability` populate the
`massWindow` / `sectorMatch` inputs and the `gw`/`oneWeyl` transport; C161's
`UniformBadSectorInverseGap` / `OverlapLinearizesToWeylSymbol` populate `badGap` /
`oneWeyl` transport.

---

## 3. Minimal load-bearing hypotheses

These genuinely drive the conclusion and belong inside the import theorem:

1. `sectorMatch` — sector-signature match (carries GW + one-Weyl content).
2. `uniformGap` — uniformly gapped homotopy (the engine that transports reference health;
   gap-continuity of `sign`).
3. `massWindow` — mass-window / sign-straddling (gates the bad-sector inverse gap and rules
   out the C138 J-even-dominated failure).
4. `refGW`, `refOneWeyl`, `refBadGap` — the reference kernel's known-good data being imported.
5. The transport implications themselves (`Transport.gw/oneWeyl/badGap`).

`finiteSeed` is required as an **input** but is explicitly *not sufficient*; it is load-bearing
only in the sense that the whole construction begins from it.

---

## 4. Hypotheses that must stay separate certificates

These should be passed in explicitly and audited on their own, never manufactured inside the
import theorem (in the skeleton they are the `*Cert` fields, each reachable only through its
own `Transport` arrow):

1. `anomalyCert` — anomaly / index import or audit (C142/C146/C147/C153). The gapped
   homotopy does **not** by itself certify determinant-line / anomaly health.
2. `ghostCert` — ghost / determinant-line rule.
3. `controlCert` — control / locality-or-controlled-nonlocality (C151/C156 path-shell,
   resolvent, finite-volume). Required even for `GateC1_NU`'s *non-ultralocal* control claim.
4. `ultralocalCert` — exponential-locality upgrade; needed only for `GateC1_local`, and kept
   out of `InputsNU` so the NU release cannot silently depend on locality.

The companion module proves each of these is load-bearing (`anomaly_load_bearing`,
`control_load_bearing`, `NU_not_local`).

---

## 5. Proof decomposition (how each conclusion flows)

| Conclusion (`seed*`)        | Flows from                                              | Transport field |
|-----------------------------|--------------------------------------------------------|-----------------|
| GW algebra                  | `sectorMatch` + `uniformGap` + `refGW`                 | `Transport.gw`  |
| one-Weyl content            | `sectorMatch` + `refOneWeyl`                           | `Transport.oneWeyl` |
| bad-sector inverse gap      | `massWindow` + `refBadGap` (inverse gap, **no** propagator-zero) | `Transport.badGap` |
| anomaly / index             | `anomalyCert` (separate import)                        | `Transport.anomaly` |
| ghost / determinant-line    | `ghostCert` (separate import)                          | `Transport.ghost` |
| non-ultralocal control      | `controlCert` (path-shell/resolvent)                  | `Transport.control` |
| (optional) ultralocality    | `ultralocalCert`                                       | `Transport.ultralocal` |

Reading: GW and one-Weyl are *transported from the reference* by the signature match plus the
gapped homotopy; the bad-sector gap is *derived from the mass window* (C161 linearization),
strictly as an inverse-propagator gap; anomaly, ghost, and control are *not* transportable
from the homotopy and must arrive as their own certificates. The top-level theorem is exactly
the assembly of these seven arrows.

---

## 6. No-overclaim checklist (what this theorem does NOT prove)

- It does **not** prove the finite seed is the physical release (`finiteSeed_not_release`).
- It does **not** prove locality / ultralocality of `GateC1_NU` (`NU_not_local`); that needs
  `ultralocalCert` via `promoteToLocal`.
- It does **not** remove the bad sector by a propagator zero; the only bad-sector mechanism in
  the interface is the inverse-propagator gap from the mass window.
- It does **not** certify anomaly/index or determinant-line health from the homotopy alone
  (`anomaly_load_bearing`); those require explicit certificates.
- It does **not** establish nonzero `Odd_J(sign(H))` from a nonzero odd seed (C138); that is
  precisely what the `massWindow` certificate, not the import theorem, is responsible for.
- It does **not** prove the analytic transport lemmas themselves — they are assumed
  (`Transport`) and are the real follow-up work.
- It does **not** collapse `GateC1_NU` into `GateC1_local`; they are distinct structures and
  only the downward implication (`local_implies_NU`) is free.

---

## 7. Kernel-checkable artifact + handoff plan

**Checked now** (`RequestProject/C159_ReferenceImport.lean`, a x i o m-free):
- `nullEdgeReferenceOverlapImport` composes the certificates into `GateC1_NU`.
- `promoteToLocal`, `local_implies_NU` — the NU ↔ local relationship.
- `goodData_release` — the interface is inhabited (not vacuously contradictory).
- `finiteSeed_not_release`, `anomaly_load_bearing`, `NU_not_local`, `control_load_bearing` —
  the four no-overclaim guards, each a kernel-verified independence/distinctness witness.

**Handoff for the analytic layer (recommended next Lean files / Aristotle jobs):**
- Replace each `Data` `Prop` field with the operator statement and each `Transport` field with
  a proved lemma. Suggested split:
  - `C159a_SignFunctionalCalculus.lean` — `sign(H)` for finite/gapped Hermitian operators and
    gap-continuity (`Transport.gw`, `Transport.oneWeyl` backbone). Coordinate with C160.
  - `C159b_BadSectorGap.lean` — mass-window ⇒ inverse-propagator gap (`Transport.badGap`).
    This is C161's deliverable; import its `UniformBadSectorInverseGap`.
  - `C159c_CertificateImports.lean` — typed wrappers for `anomalyCert`/`ghostCert`/
    `controlCert`/`ultralocalCert` referencing C153 (anomaly/index), C156 (path-shell
    locality), and the ghost-rule audit.
- Keep `nullEdgeReferenceOverlapImport` as the single assembly point so that landing any one
  analytic lemma immediately strengthens the release without touching the architecture.
- Do **not** duplicate C148/C154/C155/C156/C157/C158 — this package consumes their outputs as
  the certificates listed in §4.
