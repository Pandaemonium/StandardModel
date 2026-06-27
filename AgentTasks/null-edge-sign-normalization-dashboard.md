# Null-edge sign and normalization dashboard (job G2)

**No-build audit deliverable. Generated 2026-06-26.**

No Lean, Lake, pre-commit, or build/check command was run. This is a written
dashboard only. It implements job **G2** ("sign and normalization dashboard
across returned files") from `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
§21.6, supporting the integration freeze of §21 and the Gate A convention freeze
of §20.3. Convention statements below are transcribed from the cited files; any
"proved"/"Lean status" note is read from the report text and must still be
re-verified by the kernel before promotion.

Sources audited:

- Core docs: `docs/CONVENTIONS.md`, `docs/NULLSTRAND.md`.
- Working Plan §20-21 (gates, integration invariant `§21.8`).
- Returned jobs under `AgentTasks/` (audits, strategies, protocols, and the
  Lean-backed `*-report.md` files).

Legend for the **Status** column:

- **aligned** - matches the locked convention with no notational drift.
- **alias-only** - mathematically aligned, but uses a different *name* for an
  object that already has a canonical name (a normalization-notation drift, not
  a sign/value conflict).
- **conflict** - a genuine sign, value, or convention disagreement with the
  locked convention or another file.
- **unresolved** - the file explicitly leaves a sign/normalization choice open
  or pending (not yet frozen).

A dash `-` means the file does not address that column.

---

## 1. Dashboard table

Because each row has 11 fields, the table is split into two panels sharing the
`file/report` key. Panel 1 = sign/operator conventions; Panel 2 = normalization
conventions + status.

### Panel 1: metric, d'Alembertian, kinetic symbol, super-Dirac square

| file/report | metric signature | analytic d'Alembertian symbol | `K_null` symbol (name used) | `D = iD_N + Gamma Phi` convention | `Phi` grading rel. `Gamma_s` | `chi_E` status | final square sign |
|---|---|---|---|---|---|---|---|
| `docs/CONVENTIONS.md` (canonical) | mostly-minus `+t^2 - x^2`; `p^2=0` null, `p^2=m^2` massive | - (not restated) | name **`K_null`** (no-double-counting `K_null = Phi_H^2`); also **`Box_null`** in square block | `D = iD_N + Gamma_s Phi_H` | `+Phi_H^2` iff `[Gamma_s, Phi]=0`; `-Phi_H^2` iff `{Gamma_s, Phi}=0` | distinct from `Gamma_s`; `Phi` may be `chi_E`-odd but must commute with `Gamma_s` | `D^2 = -K_null - C_diamond - T_frame + Phi_H^2 - i Gamma_s sum_a C_a [nabla_a, Phi_H]` |
| `docs/NULLSTRAND.md` (canonical) | mostly-minus; simplex `ell_A=(1,n_A)` future-null | **`-p^2`** (analytic box symbol stated) | name **`Box_null`** ("use Box_null as the kinetic mass-shell operator") | `D = i D_N + Gamma_s Phi` | `[Gamma_s,Phi]=0` for `+Phi^2`; if `Phi` anticommutes with `Gamma_s` the sign flips | `Gamma_s`/`chi_E`/`epsilon_form` kept distinct; mass block internally `chi_E`-odd | `D_N^2 = Box_null + C_diamond + T_frame`; `-Box_null + Phi^2 = 0` gives `p^2=m^2` |
| `null-edge-super-dirac-sign-double-counting-audit` | mostly-minus (`-Box_null+Phi^2=0` -> `p^2=m^2`) | - (uses `-p^2` normalization implicitly) | **`Box_null`** in square; **`K_h`** in mass-shell reading `K_h(xi)=eig(Phi_H^2)` | `D = i D_N + Gamma_s Phi`, `Phi=Phi_H` | full derivation: `+Phi^2` iff `[Gamma_s,Phi]=0`; explicit `-Phi^2` companion for `{Gamma_s,Phi}=0` | F1/M2 guardrail: `chi_E` must NOT be read as `Gamma_s`; internal oddness uses `chi_E` only | `D^2 = -D_N^2 + Phi^2 - i Gamma_s sum_a C_a [nabla_a, Phi]`; expanded `-Box_null - C_diamond - T_frame + Phi^2` |
| `null-edge-continuum-square-limit-strategy` | mostly-minus `(+,-,-,-)`; `p^2=0`/`p^2=m^2` | **`-p^2`** (stated) | name **`K_h`** (primary); `-Box_null+Phi^2=0` -> `p^2=m^2` | `D = i D_N + Gamma_s Phi_H` | `+Phi_H^2` forced by `[Gamma_s,Phi]=0`; sign trap if odd | three gradings separate | `D^2 = -D_N^2 + Phi_H^2 - i Gamma_s sum_a C_a [nabla_a, Phi_H]`, `D_N^2 = K_h + C_diamond + T_frame` |
| `null-edge-unified-mass-proof-chain` | mostly-minus `(+,-,-,-)` | - | name **`K`** (T7: `D^2 = -K + Phi^2` so `K = Phi^2`) | `D_h = i sum_a c(alpha^a) nabla_a^A + Gamma_s Phi_H` | sign trap noted: `Phi` odd under same `Gamma_s` flips `Phi^2` | `Gamma_s`/`chi_E`/`epsilon_form` separate | `D^2 = -K + Phi^2` (on-shell `K = Phi^2`) |
| `null-edge-finite-tetrad-postulate-report` (Lean) | - (bare `Ring R`, finite algebra) | - | **`Boxnull`** = `1/4 sum {C_a,C_b}{nab_a,nab_b}`; **`Kplus`** = `sum C_a C_b nab_a nab_b` (kinetic+curvature) | - (`D_N = sum_a C_a nab_a` only; no `Phi` block) | - | - (ring-level, no grading) | `D_N^2 = Kplus + Tframe = Boxnull + Cdiamond + Tframe`; under tetrad postulate `Tframe=0` |
| `null-edge-scalar-kinetic-reconstruction-report` (Lean) | mostly-minus (Lorentzian inverse metric `g^{-1}`) | - | - (scalar kinetic, not Dirac square) | - | - | - | - |
| `null-edge-flat-branch-count-protocol` | mostly-minus; `c(p)=gamma^mu p_mu` | - | - (uses `p(q)^2`, mass-shell) | branch test `det(i D_+(q) + Gamma_s Phi)=0`; `Phi=m`, `Gamma_s=gamma_5` | `Gamma_s Phi = m gamma_5` shifts null cone to mass shell | chirality decomposed under `Gamma_s` | `det(...) = (m^2 - p(q)^2)^2 = 0` <=> `p(q)^2 = m^2` |
| `null-edge-krein-stability-audit` | indefinite metric via `J=J^dagger=J^{-1}`, signature `(p,q)` | - | - | - (audits `D_+`/`D_-` double, no mass block) | - | - | `D_dbl` is `J_dbl`-self-adjoint (hygiene, not stability) |
| `null-edge-chiral-mechanism-strategy` | - | - | - | reuses `D = i D_N + Gamma_s Phi_H`, graded `+Phi_H^2` | keeps `[Gamma_s,Phi]=0`; SSH pilot uses `{H_SSH,Gamma_s}=0` (sublattice chirality) | `Gamma_s`/`chi_E`/`epsilon_form` separation preserved | - (pilot is index/zero-mode, not the square) |
| `null-edge-ew-stabilizer-report` (Lean) | - (EW sector) | - | - | - | - | - | - |
| `null-edge-sm-anomaly-audit-report` (Lean) | - (EW sector) | - | - | - | - | - | - |
| `null-edge-fms-wz-composite-audit` | - (EW sector) | - | - | - | - | - | - |
| `null-edge-moduli-rank-prediction-ledger` | - | - | - | - | - | - | - |
| `null-edge-mass-prior-art-citation-audit` | - | - | references `K_null = Phi_H^2` no-double-counting | - | - | - | references `-K + Phi^2` square |
| `null-edge-qcd-obstruction-scope` | - | - | - | - | - | - | - |

### Panel 2: frame/soldering normalization, inverse-Gram, status

| file/report | frame/soldering normalization | inverse-Gram convention | Status |
|---|---|---|---|
| `docs/CONVENTIONS.md` (canonical) | dual-soldered `D_N = sum_a c(alpha^a) nabla_{ell_a}`; never diagonal `c(ell_a^flat)` | - (referenced via no-double-counting, not formulated) | **aligned** (canonical reference) |
| `docs/NULLSTRAND.md` (canonical) | simplex `alpha^A = (1/d) dt + ((d-1)/d) n_A.dx`, `d=4`: `1/4 dt + 3/4 n_A.dx`, `alpha^A(ell_B)=delta`; "scale duals consistently if `ell` scaled" | reconstruction `xi = sum_A xi(ell_A) alpha^A`; diagonal trace obstruction recorded | **aligned** (canonical reference) |
| `null-edge-super-dirac-sign-double-counting-audit` | `C_a = c(alpha^a)`, dual-soldered; warns against diagonal `c(ell_a^flat)` (M9) | - (defers to scalar-kinetic job) | **alias-only** (`Box_null`/`K_h` for `K_null`); square sign aligned |
| `null-edge-continuum-square-limit-strategy` | simplex `alpha^A = (1/d) dt + ((d-1)/d) n_A.dx`; `C_a=c(alpha^a)`; `df = sum_a df(ell_a) alpha^a` | `G^{ab} = g^{-1}(alpha^a, alpha^b)`, Lorentzian; Euclidean positive-sum collapse forbidden | **alias-only** (`K_h` primary name for `K_null`); otherwise aligned |
| `null-edge-unified-mass-proof-chain` | dual-covector soldering `c(alpha^a)`; not `c(ell_a^flat)` | - | **alias-only** (`K` for `K_null`); otherwise aligned |
| `null-edge-finite-tetrad-postulate-report` (Lean) | abstract `C_a = c(alpha^a)` as ring elements; `Boxnull`/`Cdiamond` need `[Invertible (4:R)]` | - | **alias-only** (`Boxnull` for `Box_null`/`K_null`; new `Kplus = K_null + C_diamond` combined block - document to avoid clash) |
| `null-edge-scalar-kinetic-reconstruction-report` (Lean) | dual covectors `alpha^a`, `alpha^a(ell_b)=delta`; simplex `d=4` frame is a special case; never diagonal flats | `G^{ab} = g^{-1}(alpha^a,alpha^b)` certified = matrix inverse of Gram `g_{ab}=g(ell_a,ell_b)`; Lorentzian cross terms essential (`euclidean_collapse_guardrail`) | **aligned** (canonical inverse-Gram realization) |
| `null-edge-flat-branch-count-protocol` | tetrahedral `alpha^A = 1/4 dt + 3/4 n_A.dx`, `alpha^A(ell_B)=delta`; `C_a=c(alpha^a)` | tetrahedral `G^{-1} = -3/4 I + 1/4 J`, `= alpha^A.alpha^B` (mostly-minus); `p(q)^2 = h^{-2} u^T G^{-1} u` | **aligned** |
| `null-edge-krein-stability-audit` | - (operator-level; `J` fundamental symmetry) | - | **aligned** (Krein hygiene; explicitly not a stability/sign claim) |
| `null-edge-chiral-mechanism-strategy` | active operator `D_+^h = sum_a c(alpha^a)(T_a-I)/h`; local frame `ell_a(x), alpha^a(x)` | - | **aligned** (note: `Gamma_s` reused for SSH sublattice chirality - naming overload) |
| `null-edge-ew-stabilizer-report` (Lean) | EW: Hermitian `T_i=sigma_i/2`, `Y(H)=1`, `Q=T_3+Y/2=diag(1,0)`, `H_0=(0,v/sqrt2)`, `kappa=v/(2 sqrt2)`; `B_EW(x)=rho(x)H_0` | - | **unresolved** (coefficient normalization `v^2/8`, `m_W=gv/2` vs `gv/sqrt2` left to stage 2; kernel/rank part aligned) |
| `null-edge-sm-anomaly-audit-report` (Lean) | EW: `Q=T_3+Y/2`, `Y(Q_L)=1/6`, left-Weyl convention | - | **aligned** (EW hypercharge convention) |
| `null-edge-fms-wz-composite-audit` | EW: `tau^a=sigma^a/2` (physics-Hermitian), `Y(H)=1`, `Q=T_3+Y/2`, `H_0=(0,v/sqrt2)`, `U_e=exp(i eps A_e)` | - | **aligned** (EW block; `O_e^a` correction is a separate target) |
| `null-edge-moduli-rank-prediction-ledger` | flags **F3 dual-soldering normalization** (`c(alpha^a)` determinant-vs-trace scale) as an open continuous parameter | inverse-Gram normalization listed among continuum/convention params | **unresolved** (explicitly an unfrozen normalization parameter) |
| `null-edge-mass-prior-art-citation-audit` | - | - | **alias-only** (cites `K_null = Phi_H^2`; consistent) |
| `null-edge-qcd-obstruction-scope` | - (no `B_QCD` defined) | - | **aligned** (no sign/normalization commitments) |

---

## 2. Conflicts to fix before trusted promotion

No file carries a genuine **sign conflict**: every file that states the super-Dirac
square agrees on `D^2 = -D_N^2 + Phi^2 - i Gamma_s sum_a C_a [nabla_a, Phi]` with
`+Phi^2` gated by `[Gamma_s, Phi] = 0`, and every soldering statement uses the dual
covector `c(alpha^a)` (never the diagonal `c(ell_a^flat)`). The corpus is
sign-consistent. The outstanding items are notation-alias and unfrozen-normalization
issues, which §21.8's integration invariant requires resolved before promotion.

1. **C-1 Kinetic-operator name proliferation (alias-only, highest priority).**
   The single symmetric kinetic mass-shell operator
   `1/4 sum_{a,b} {C_a,C_b}{nabla_a,nabla_b}` appears under **four** names:
   - `K_null` (`docs/CONVENTIONS.md`, no-double-counting; mass-prior-art),
   - `Box_null` (`docs/NULLSTRAND.md`; super-dirac audit; finite-tetrad `Boxnull`),
   - `K_h` (continuum-square-limit; super-dirac mass-shell reading; Working Plan B4),
   - `K` (proof-chain T7).

   Even the two **core docs disagree** (`CONVENTIONS.md` says `K_null`,
   `NULLSTRAND.md` says `Box_null`). This must be unified at Gate A before any
   finite-square theorem is promoted.

2. **C-2 `Kplus` vs `K_null` collision risk (alias-only).**
   `null-edge-finite-tetrad-postulate-report` defines `Kplus = sum C_a C_b nab_a nab_b
   = Box_null + C_diamond` (kinetic **plus** curvature). This is a *different*
   object from `K_null`/`Box_null` (kinetic only). The near-identical name
   invites a silent kinetic/curvature double-count (Working Plan §20.4 failure
   mode). Rename before promotion.

3. **C-3 d'Alembertian symbol-sign not restated where `K_null` is used.**
   Only `NULLSTRAND.md` and `continuum-square-limit` record that the analytic
   d'Alembertian has plane-wave symbol `-p^2`, while the program's `K_null`/`Box_null`
   is normalized with symbol `+p^2` so that `-K_null + Phi^2 = 0` yields `p^2 = m^2`
   (i.e. `K_null = -Box_analytic` at the symbol level). Files that use `Box_null`
   without restating this (super-dirac audit, finite-tetrad, proof-chain) risk the
   mass-shell sign error flagged as super-dirac failure modes **M7/F4**. Each
   trusted file that uses the kinetic operator should state its symbol normalization.

4. **C-4 `Gamma_s` overloaded between spacetime chirality and SSH sublattice
   chirality.** In the super-Dirac convention `Gamma_s` is spacetime chirality with
   `[Gamma_s, Phi]=0`, `{Gamma_s, C_a}=0`. In `chiral-mechanism-strategy`'s SSH/
   Jackiw-Rebbi pilot, `Gamma_s = diag(+I,-I)` is the **sublattice** chirality with
   `{H_SSH, Gamma_s}=0`. Both legitimate, but reusing the symbol `Gamma_s` across
   two distinct operators violates the §18.6/§20.3 grading-separation discipline in
   spirit. Disambiguate the pilot's symbol before its theorem is promoted.

5. **C-5 EW coefficient normalization unresolved (pending, not contradictory).**
   `CONVENTIONS.md` locks the *target* `q = v^2/8 [...]`, `m_W = g v/2`,
   `m_Z = sqrt(g^2+g'^2) v/2`, but `ew-stabilizer-report` proves only the kernel/rank
   stage and explicitly defers the coefficient normalization (`v^2/8`, `m_W = g v/2`
   vs `g v/sqrt2`) to stage 2. No conflict yet; flag as a pending normalization that
   must land before the EW mass coefficients are cited as theorems.

6. **C-6 Dual-soldering normalization parameter unfrozen.**
   `moduli-rank-prediction-ledger` F3 lists the `c(alpha^a)` determinant-vs-trace
   scale (and the inverse-Gram normalization) as an open continuous parameter. The
   simplex frame fixes the *covectors* `alpha^A`, but the overall Clifford-symbol
   normalization is not yet locked. Freeze it at Gate A (Working Plan §20.3) so
   downstream square and branch-count results share one scale.

---

## 3. Recommended canonical notation replacements

Adopt the following at Gate A (`§20.3` / `§21.8` integration invariant), then
sweep the corpus:

| concept | canonical name | definition | deprecate / map from |
|---|---|---|---|
| kinetic mass-shell operator (symmetric block) | **`K_null`** | `1/4 sum_{a,b} {C_a,C_b}{nabla_a,nabla_b}`, symbol `+p^2` | `Box_null`, `Box_null`-as-`Boxnull`, `K_h`, `K` -> all aliases of `K_null` |
| curvature/diamond block | **`C_diamond`** | `1/4 sum_{a,b} [C_a,C_b][nabla_a,nabla_b]` | `Cdiamond` (Lean spelling) - keep as the ASCII form of the same name |
| frame/tetrad defect | **`T_frame`** | `sum_{a,b} C_a [nabla_a,C_b] nabla_b` | `Tframe` (Lean) - same name |
| kinetic+curvature combined block | **`K_full`** (or `K_null_plus_diamond`) | `K_null + C_diamond = sum C_a C_b nabla_a nabla_b` | `Kplus` -> rename to avoid `K_null` clash (C-2) |
| internal mass block | **`Phi_H`** | the Higgs/internal zero-order block; shorthand `Phi` only when unambiguous | `Phi` |
| spacetime chirality | **`Gamma_s`** | `Gamma_s^2=1`, `{Gamma_s,C_a}=0`, `[Gamma_s,Phi_H]=0`; reserved for spacetime | do not reuse for sublattice/lattice chirality |
| sublattice / lattice (overlap, SSH) chirality | **`Gamma_lat`** (or `gamma_5lat`) | the SSH/Ginsparg-Wilson sublattice grading with `{H,Gamma_lat}=0` | `Gamma_s` in `chiral-mechanism-strategy` -> rename (C-4) |
| analytic d'Alembertian | **`Box_analytic`** | symbol `-p^2`; relation `K_null = -Box_analytic` at the symbol level | informal "Box_null" used loosely for the analytic box |
| dual-soldered Dirac symbol | **`C_a = c(alpha^a)`** | dual-covector soldering; `alpha^A(ell_B)=delta` | never `c(ell_a^flat)` (diagonal trace obstruction) |
| inverse-Gram weights | **`G^{ab} = g^{-1}(alpha^a, alpha^b)`** | matrix inverse of Gram `g_{ab}=g(ell_a,ell_b)`; tetrahedral `G^{-1} = -3/4 I + 1/4 J` | "edge weights", bare positive edge sums (Euclidean collapse) |

Additional standing notes for trusted promotion (per §21.8 integration invariant,
each trusted theorem must declare metric signature, grading conventions,
kinetic-sign convention, and frame/soldering normalization imports):

- State `K_null` symbol normalization (`+p^2`) and the mass-shell reading
  `-K_null + Phi_H^2 = 0 => p^2 = m^2` in every file that uses the kinetic block
  (closes C-3).
- Keep `Gamma_s` (spacetime), `chi_E` (internal), `epsilon_form` (form degree)
  as three distinct symbols; the internal mass block is `chi_E`-odd and
  `Gamma_s`-even (closes the M1/M2 sign trap).
- EW sector: keep `Q = T_3 + Y/2`, `Y(H)=1`, `H_0 = (0, v/sqrt2)`,
  Hermitian `T_i = sigma_i/2`; record the `v^2/8` and `m_W = g v/2` normalization
  explicitly once stage 2 lands (C-5).
- Freeze the dual-soldering scale (`c(alpha^a)` determinant-vs-trace) at Gate A
  and import it rather than re-choosing it per file (C-6).
