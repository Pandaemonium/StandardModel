# Adversarial over-claim audit — all-mass landed results, batch 2

**Scope note.** The four files import `SectorGroundMassWitness`, `MassGapWitness`
and `src.S1CCBalancedInertia`, none of which are present in this project, so the
files cannot be rebuilt here. They were audited as source; imported lemmas
(`SectorGroundMassWitness.HAC/.Jmet`, `MassGapWitness.B`, `.B_least_eigenvalue`,
`S1CCBalancedInertia.anticonj_charpoly_eq`,
`.hermitian_balanced_count_of_neg_charpoly`) are taken as the kernel-checked facts
the prompt says they are. Verdicts about *those* externals are noted as
dependency-gaps, not as defects of the four files' own proofs.

Four modes used: **V** = vacuity, **HT** = hollow telescoping, **DK** =
docstring-outruns-kernel, **FS** = false shape.

---

## `CliffordAssembly.lean`

| Theorem | Statement (Lean) | Mode | Verdict | Mismatch / remedy |
|---|---|---|---|---|
| `Js_eq` | `Js = !![-1,0,0,0; 0,1,0,0; 0,0,-1,0; 0,0,0,1]` | — | CLEAN | Pure computation of a defined matrix. |
| `omega_eq` | `omega = diag(I,I,-I,-I)` | — | CLEAN | Computation. |
| `QAC_eq` | `Q_A + Q_C = QAC` (explicit 12×12) | — | CLEAN | Computation. |
| `Jmet_eq_clifford` | `J_cl = Jmet` | DK | MINOR | Genuine forced identity `Js⊗I3 = Jmet` (the metric/signature part *is* Clifford-canonical). The docstring word "verbatim, no convention change" is earned for this equality. |
| `HAC_eq_clifford` | `J_cl * (Q_A + Q_C) = HAC` | DK | **LOAD-BEARING** | See headline below. The equality is true, but `Q_C = omega ⊗ K` with `K = !![0,1,0;-1,0,0;0,0,0]` a **freely chosen input**, and `Q_A = I4⊗2I3`. The kernel certifies *one* Kronecker order + one hand-chosen closure kernel reproduces `HAC`; it does **not** certify canonicity/uniqueness of the order, nor that `K` is derived from closure geometry. So "the provenance gap is closed in the kernel / physically intended tensor order" over-reads a per-instance matrix equality. |

---

## `BindingDefect.lean`

| Theorem | Statement (Lean) | Mode | Verdict | Mismatch / remedy |
|---|---|---|---|---|
| `blockGroundMass_eq` | `0≤κ≤λ → blockGroundMass λ κ = λ − κ` | — | CLEAN | Rests on external `B_least_eigenvalue` (dependency-gap, assumed sound). |
| `blockGroundMass_free` | `0≤λ → blockGroundMass λ 0 = λ` | DK | MINOR | What is proved is **trivial**: `B(λ,0) = λ·1`, least eigenvalue `= λ`. The docstring's "equals the kinematic Plücker mass `det P`" is **not** proved here; it is a cross-reference to `FreeMassBridge.free_mass_operator_eq_plucker` (not imported, not verified). Remedy: reword to "equals `λ`; identification with `det P` is external (`FreeMassBridge`), not certified in this file." |
| `blockBindingDefect_eq_neg_kappa` | `0≤κ≤λ → blockBindingDefect λ κ = −κ` | HT? | MINOR | Genuine: `(λ−κ) − λ` via the two lemmas above; the `λ−κ` value is a real spectral fact, so not a tautology. "Binding energy" reading is a name; the physical reading is self-disclosed as grade **C** in the header. Fine. |
| `blockBindingDefect_nonpos` / `_neg` | `Δ ≤ 0` / `Δ < 0` (κ>0) | — | CLEAN | Immediate from the identity. |
| `blockBindingDefect_closure_controlled` | `Δ(κ₂) − Δ(κ₁) = −(κ₂−κ₁)` | — | CLEAN | Linearity of `−κ`. "Unit slope" earned. |
| `blockBindingDefect_pos_imp_neg_kappa` | `0 < Δ → κ < 0` | — | CLEAN | Contrapositive of `nonpos`; genuine, not vacuous. |
| `closurePerturbation_offDiagonal` | `(B λ κ − B λ 0) i i = 0` | — | CLEAN | Real diagonal-vanishing fact ("off-diagonal binding"). |
| `blockGroundMass_massless_line` | `blockGroundMass λ κ = 0 ↔ κ = λ` | — | CLEAN | From the identity. |

---

## `S1CCPhysicalSectorWitness.lean`

| Theorem | Statement (Lean) | Mode | Verdict | Mismatch / remedy |
|---|---|---|---|---|
| `GK_comm`, `QG_nilpotent` | `Gc*Kc=Kc*Gc`, `QG*QG=0` | — | CLEAN | Constraint is genuinely nilpotent (BRST/Gupta–Bleuler shape). |
| `JQc_hermitian`, `bg_sq`, `bg_anticonj` | skew⊗skew Hermitian; `b²=1`; `b JQc b = −JQc` | — | CLEAN | Real structural facts. |
| `N_in_radical` | `JQc (0,2) p = 0 ∧ JQc p (0,2) = 0` | — | CLEAN | **Key justification.** `N = range Q_G = span e_{(0,2)} ⊆ ker Q_G = V'`, and `N` pairs trivially with all of `H`, so it is in the radical. Since `V' = span{reps} ⊕ N` (the 5-dim `ker Q_G` = the 4 reps + `e_{(0,2)}`), the induced form on `V'/N` genuinely **equals** the submatrix `JQc.submatrix r r`. The compression is real, not a convenient sub-block. |
| `B_eq_Bexpl` | `B = !![0,0,0,-1;0,0,1,0;0,1,0,0;-1,0,0,0]` | — | CLEAN | Computation. |
| `B_isHermitian`, `B_sq`, `B_trace`, `bg4_sq`, `bg4_anticonj` | Hermitian; `B²=1`; `tr B=0`; ... | — | CLEAN | Involution + traceless ⇒ eigenvalues `±1` in equal number independently corroborates `(2,2,0)`. |
| `JQc_not_positive_on_sector` | `∃v (…).re<0 ∧ ∃w 0<(…).re` | — | CLEAN | Explicit witnesses; genuine indefiniteness. |
| `B_isUnit_det`, `B_charpoly_symm`, `B_balanced`, `B_no_zero_eig` | invertible; `(−B).charpoly = B.charpoly`; `#pos=#neg`; `#zero=0` | — | CLEAN | Uses external balance engine (dependency-gap, assumed sound). |
| `balanced_on_physical_sector` | `#pos=2 ∧ #neg=2 ∧ #zero=0` | — | CLEAN (with caveat) | Inertia `(2,2,0)` of the **true** compressed Hermitian form. Real inertia, not dressed up. Caveat is **not** in this file: it lives in the toy 2×3 carrier `JQc=(σx σz)⊗Kc`; the relation of this 6×6 to the full §6 closure form is by construction, outside the kernel. Header still says "kernel-clean *once the sorries below are discharged*" — stale, there are **no** sorries; reword to "kernel-clean." |

---

## `EquivariantGradedIndex.lean`

| Theorem | Statement (Lean) | Mode | Verdict | Mismatch / remedy |
|---|---|---|---|---|
| `chiralProduct_involution` | `Γ*W*Γ = Wᴴ, Wᴴ*W=1 → (Γ*W)² = 1` | — | CLEAN | Genuine algebra. |
| `sector_pins_W_fixed` | common `s`-eigenvector of `Γ`,`ΓW` ⇒ `W v = v` | — | CLEAN | `mulVec` algebra; honest. |
| `graded_trace_odd_vanishes` | `Γ X = −(X Γ), gX=Xg → tr(Γ g X)=0` | DK | MINOR | True finite fact. "supertrace sees only the kernel" is hedged as "the finite algebraic heart of"; the kernel/index identification is a handed-off target. OK. |
| `gamma_pow_comm` | `Γ Dᵐ = (−1)ᵐ•(Dᵐ Γ)` | — | CLEAN | Induction. |
| `graded_trace_odd_power_vanishes` | `tr(Γ D^{2k+1}) = 0` | DK | MINOR | True. "localizes to `D#D`/heat kernel" hedged as "finite face." No heat kernel is present; wording honest. |
| `graded_trace_sum` | `tr(Γ g ΣQᵢ) = Σ tr(Γ g Qᵢ)` | — | CLEAN | Trace additivity; "unification is decomposition" = additivity, disclosed. |
| `graded_budget_decomposition` | `4•(D#D)=QA+QC+4•QT+4•E ⇒ 4•tr(Γg D#D)=Σ tr(Γg ·)` | HT | MINOR | This **is** trace-linearity applied to the *assumed* budget `hbudget`. The physical content (the budget) is a hypothesis, not proved. Honestly disclosed ("Given the budget… NOT a topological invariant"), but the grand name `graded_budget_decomposition` invites reading it as establishing the budget. Remedy: rename/clarify to `graded_trace_of_budget` and keep the disclaimer. |
| `graded_trace_sector_split` | `tr(ΓA)=tr(Γ P₊ A)+tr(Γ P₋ A)` | — | CLEAN | Uses only `P₊+P₋=1`; honest. |
| intro docstring | mentions `chiralIndex_eq_graded_dimension` as a "use" | DK | MINOR | **No such theorem exists in this file** (only the trace-algebra half is here); the actual index=dimension result is a handed-off M-target. The parenthetical in the intro reads as if landed; the "Claim boundary" later correctly demotes it. Remedy: mark it "(handed off)" in the intro too. |

The word **"index"** is only ever `sdim_g(A) := tr(Γ g A)` (supertrace), which is the
correct honest usage; no theorem here calls a supertrace a topological/K-theory
index. Good.

---

## THE single most load-bearing over-claim

**`CliffordAssembly.lean` — `HAC_eq_clifford` + the file's headline
("the one gap flagged by the flagship audit is closed in the kernel /
physically intended tensor order / no convention change").**

- **What the kernel earns:** `J_cl * (Q_A + Q_C) = HAC` and `J_cl = Jmet`, i.e.
  `HAC` *admits* the explicit factorization `(Js⊗I3)·(I4⊗2I3 + omega⊗K)` under the
  `finProdFinEquiv` row-major order, with `K = !![0,1,0;-1,0,0;0,0,0]`.
- **The mismatch (DK):** `K` (and the aperture scale in `Q_A`) are **free inputs**
  fed in by hand. The closure kernel `K` — the physically meaningful piece — is not
  derived from Clifford/closure geometry; it is chosen so the product hits `HAC`.
  The theorem therefore establishes an **existence** of a Clifford Kronecker
  presentation, not the **canonicity/uniqueness** that "IS the Cl(4) carrier /
  physically intended tensor order / provenance gap closed" connotes. This is
  exactly the probe's worry ("could a different order also match by coincidence?"):
  the kernel offers **no exclusion** of other orders, because the free `K` absorbs
  reindexing freedom. And, unlike `BindingDefect`'s grade-C self-disclosure or
  `EquivariantGradedIndex`'s explicit "NOT a topological index" caveat, this file
  gives **no caveat** that `K` is tuned or that uniqueness is uncertified — the
  over-claim is undisclosed and it *is the entire stated purpose of the file*.
- **Exact remedy (either):**
  1. **Downgrade the wording.** Replace "the Clifford provenance is kernel-certified
     / no convention change / physically intended tensor order / provenance gap
     closed" with: *"`HAC` admits an explicit Cl(4) Kronecker factorization
     `J_cl·(Q_A+Q_C)` in the `finProdFinEquiv` order, with closure kernel `K` a
     chosen input; canonicity of the tensor order and a derivation of `K` from
     closure geometry are not certified here."* The metric identity
     `Jmet = Js⊗I3` may keep its strong wording — it is forced.
  2. **Or earn the strong claim.** Add a rigidity lemma: prove that the gamma set
     satisfies the Clifford relations (`gᵢgⱼ + gⱼgᵢ = 2δᵢⱼ`) — pinning the order up
     to Clifford equivalence — **and** that `K` is the unique color operator making
     `omega⊗K` the closure sector (e.g. `K` = the closure commutator forced by an
     independently defined closure form), so that no other order+canonical-closure
     reproduces `HAC`. Only then is "IS the Cl(4) carrier / provenance closed"
     kernel-earned.

Everything else across the four files is CLEAN or MINOR (mostly honest,
well-disclosed hedges); no vacuous statements and no false-shape statements were
found. The `S1CC` physical-sector compression is genuinely the true induced form
(justified by `N_in_radical`), and its `(2,2,0)` inertia is the real inertia.
