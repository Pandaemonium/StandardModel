# Adversarial over-claim audit — all-mass landed results, batch 3

**Scope of verification.** This is an audit (no proofs added). I read all four
`src/` files verbatim, tried to build them, and independently re-checked the two
probe-critical identities in a scratch Lean session.

**Build reality (meta-finding, read first).** Only two of the four files are
self-contained and actually compile in the delivered project:
`ContinuumLimit.lean` and `FockMassGap.lean` (both `import Mathlib` only;
`FockMassGap` even carries its own `#print axioms` guard pinning
`[propext, Classical.choice, Quot.sound]`). The other two —
`SectorMassGap.lean` and `MassSpacingPrediction.lean` — **fail to build here**:
they `import PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness`, and that module
(carrying `B`, `B_spectrum`, `B_least_eigenvalue`, `M6_topBlock_eq_B`) is **not
present anywhere in this repository**. So their "kernel-checked + axiom-pinned"
status is **not reproducible in this deliverable**; my verdicts for those two are
therefore *conditional* on the absent dependency supplying `B` / `B_spectrum`
exactly as their docstrings state.

Modes: **V** = vacuity, **H** = hollow telescoping, **D** = docstring-outruns-kernel,
**F** = false shape.

---

## `SectorMassGap.lean`  (does NOT build here — dep `MassGapWitness` absent)

`Msec lam kappa := reindex finSumFinEquiv finSumFinEquiv (fromBlocks (B λ κ) 0 0 (B λ (-κ)))`.
The `reindex finSumFinEquiv` **is** faithful: it relabels rows and columns by the
same bijection, i.e. conjugation by a permutation, hence a genuine similarity —
spectrum, determinant, Hermitian-ness and positive-definiteness are all preserved.
So `Msec` genuinely *is* the block diagonal `B(λ,κ) ⊕ B(λ,-κ)` up to index
relabeling. That part is earned.

| Theorem | Statement (paraphrase) | Mode | Verdict |
|---|---|---|---|
| `Msec_isHermitian` | `(Msec λ κ).IsHermitian` | — | CLEAN |
| `Msec_det_char` | `det(μ·1 − Msec) = det(μ·1 − B κ)·det(μ·1 − B(−κ))` | — | CLEAN |
| `Msec_spectrum_union` | `spectrum(Msec) = spectrum(B κ) ∪ spectrum(B(−κ))` | — | CLEAN |
| `Msec_spectrum` | `spectrum(Msec) = {λ−κ, λ, λ+κ}` | — | CLEAN (cond. on `B_spectrum`) |
| `Msec_least_eigenvalue` | `0≤κ≤λ → IsLeast (range eigenvalues) (λ−κ)` | D + H (prose) | **see headline** |
| `Msec_posDef_iff` | `Msec.PosDef ↔ |κ| < λ` | — | CLEAN |

Every theorem is *literally true about the object `Msec`*. The problem is the
**prose headline**, not the Lean: the docstring sells this as "the honest
'physical sector' mass gap — of the **actual 6-dimensional form, not just the 3×3
half-block**." That headline is the single most load-bearing over-claim in the
batch (details below).

---

## `MassSpacingPrediction.lean`  (does NOT build here — dep `MassGapWitness` absent)

`specLo := λ−κ`, `specMid := λ`, `specHi := λ+κ` — the three levels are **defined**
as a symmetric arithmetic progression, not derived.

| Theorem | Statement (paraphrase) | Mode | Verdict |
|---|---|---|---|
| `levels_eq_spectrum` | `{specLo,specMid,specHi} = spectrum(B λ κ)` (set) | D (decorative) | MINOR |
| `specMid_eq_mean` | `specMid = (specLo+specHi)/2` | H | MINOR |
| `spec_equal_spacing` | `specMid−specLo = specHi−specMid` | H | MINOR |
| `spec_spacing_ratio` | `κ≠0 → (specMid−specLo)/(specHi−specMid) = 1` | H | MINOR |
| `spec_spacing_ratio_scale_invariant` | same, with `s·λ, s·κ`, `s≠0` | H | MINOR |

Probe answers, blunt:
- **Genuine prediction, or trivial identity dressed as physics?** It is a trivial
  arithmetic identity. `specMid_eq_mean`, `spec_equal_spacing`, `spec_spacing_ratio`
  are all closed by `ring`/`div_eq_one_iff` **on the definitions alone** — they
  never touch the spectrum. The "prediction ratio = 1" is forced the instant you
  *define* the levels as `λ∓κ` symmetric about `λ`. It is a tautology of the
  assumed symmetric spectral form.
- **Is `levels_eq_spectrum` doing real work?** For the *spacing* theorems, no —
  they don't use it. It is the only bridge to `B`, but it is a **set** equality
  (loses ordering / multiplicity), so it also doesn't by itself certify that
  `specLo` is the least level. It is essentially decorative relative to the
  ratio claim.
- **Is "falsifiable prediction" honest?** Generous, but **not dishonest**,
  because the file's "Scope (the neutrino-ratio boundary, honest)" section
  pre-empts exactly this: it states plainly this is within-carrier, is *not* the
  neutrino ratio, and that a naive 3-generation reading would predict an
  arithmetic `Δm²` ratio of 1 that *contradicts* observed hierarchy. That honest
  disclaimer keeps the whole file at MINOR rather than load-bearing.

---

## `ContinuumLimit.lean`  (builds; Mathlib-only)

| Theorem | Statement (paraphrase) | Mode | Verdict |
|---|---|---|---|
| `Ustep_trace` | `tr(Ushift k · Ucoin θ) = 2 cos k cos θ` | — | CLEAN |
| `Ushift_det` | `det(Ushift k) = 1` | — | CLEAN |
| `Ucoin_det` | `det(Ucoin θ) = 1` | — | CLEAN |
| `Ustep_det` | `det(Ustep k θ) = 1` (∈ SU(2)) | — | CLEAN |
| `Ushift_eq_exp` | shift entries `= e^{∓ik}` | — | CLEAN |
| `sigmax_sq`,`sigmaz_sq`,`sigma_anticomm` | `σx²=σz²=1`, `{σz,σx}=0` | — | CLEAN |
| `dirac_mass_shell` | `(k•σz + m•σx)² = (k²+m²)•1` | — | CLEAN |
| `Ustep_hasDerivAt_generator` | `d/dε[Ushift(kε)·Ucoin(mε)]|₀ = −i(k•σz+m•σx)` | — | CLEAN |

Probe answers:
- **Is `Ustep_hasDerivAt_generator` the leading-order match, or less?** It is
  exactly the genuine leading-order (first-order Taylor) match:
  `Ustep = 1 − iε(kσz+mσx) + O(ε²)`, recovering the Dirac symbol
  `H(k)=kσz+mσx`. It correctly says *first order* and no more — it does **not**
  masquerade as the convergence theorem.
- **False shape in `dirac_mass_shell`?** None. I re-derived it independently:
  `σz²=σx²=1`, `σzσx+σxσz=0` ⇒ `(kσz+mσx)² = (k²+m²)·1`. Faithful to `E²=k²+m²`.
- **Adequate disclaimer?** Yes — the header states outright that the continuum
  theorem (strong / Trotter–Kato convergence) "is *not* a finite statement and
  lives outside the kernel program; here we prove only the finite symbol facts."

**File verdict: CLEAN and well-disclosed.**

---

## `FockMassGap.lean`  (builds; Mathlib-only; `#print axioms` guarded)

| Theorem | Statement (paraphrase) | Mode | Verdict |
|---|---|---|---|
| `fockEnergy_vacuum` | `fockEnergy d vacuum = 0` | — | CLEAN |
| `fockEnergy_singleParticle` | `fockEnergy d (single i₀) = d i₀` | — | CLEAN |
| `fockEnergy_twoParticle` | `i≠j → fockEnergy d (two i j) = d i + d j` | — | CLEAN |
| `fockEnergy_nonneg` | `(∀i,0≤d i) → 0 ≤ fockEnergy d occ` | — | CLEAN |
| `fockEnergy_excited_lb` | `(∀i,g≤d i)∧occupied → g ≤ fockEnergy d occ` | — | CLEAN |
| `ground_isLeast` | `IsLeast (range fockEnergy) 0` | — | CLEAN |
| `excited_isLeast` | `IsLeast (excitedSpectrum d) g`, `d i₀ = g` | — | CLEAN |
| `secondQuantized_massGap` | `massGap d = λ−κ` (ground 0, first excited λ−κ) | — | CLEAN |
| `twoBody_bound_below_threshold` | `fockEnergy(two i j) + (−κ) < fockEnergy(two i j)`, `0<κ` | H + D | **MINOR (self-disclosed)** |

Probe answers:
- **Is `secondQuantized_massGap` a genuine many-body gap, or a relabeled
  one-particle fact?** It is a genuine (if elementary) many-body statement: it
  quantifies over the whole Fock occupation lattice `Fin N → Bool`, and
  `excited_isLeast` really does rule out every multi-particle state dipping below
  `λ−κ` (via nonnegativity + `single_le_sum`). Its answer *coincides* with the
  one-particle gap — but that is stated openly: the module title is literally
  "free `dΓ` gap = one-particle gap," and the docstring says the many-body gap
  "**equals** the one-particle gap." So it is honest, not a disguised relabel.
  Non-vacuous (e.g. `N=1`, `d ≡ λ−κ` satisfies all hypotheses).
- **Is `twoBody_bound_below_threshold` a real below-threshold bound state, or
  does `Δ` enter by hand?** It is **not** a bound-state result. I verified the
  statement is `a + (−κ) < a` for an *arbitrary* real `a`: the
  `fockEnergy d (twoParticle i j)` term appears on both sides and cancels, so the
  entire two-body / Fock apparatus is **inert decoration**. `Δ = −κ` is inserted
  by hand. This *is* self-disclosed — the footer says explicitly "`Delta` here is
  inserted by hand rather than derived," "it is NOT yet a hadron," and lists the
  real derivation as open steps 6–8. Because of that disclosure it stays MINOR,
  but the phrase "the honest finite witness of 'bound-state mass ≠ sum of
  constituents'" still overstates a `x−κ<x` triviality.

---

## THE single most load-bearing over-claim

**`SectorMassGap.lean` — the headline "the honest 'physical sector' mass gap —
of the *actual 6-dimensional form, not just the 3×3 half-block*."**

Why it is the load-bearing one (it is the file's entire reason to exist on top of
`MassGapWitness`), and how it fails on two independent counts:

1. **Docstring-outruns-kernel (physical-sector identification).** `Msec` is a
   block-diagonal *ansatz* `B(λ,κ) ⊕ B(λ,−κ)` **defined** by hand. No theorem in
   the file ties the full `6×6` `Msec` to the real physical carrier sector; by the
   file's own admission the carrier tie is "only kernel at `(2,1)`" via
   `M6_topBlock_eq_B`, which pins only the `3×3` **top block**. So "the actual
   6-dimensional physical sector" is asserted, not proved — the parametrized full
   sector `= physical carrier` link is exactly the missing kernel content.

2. **Hollow telescoping (the lift adds no spectral content).** Both mirror blocks
   have the identical spectrum `{λ−κ, λ, λ+κ}`, so the `6×6` spectrum is that same
   set (`Msec_spectrum`) and the `6×6` least eigenvalue `λ−κ` is *definitionally
   identical* to the `3×3` block's least eigenvalue. Going `3×3 → 6×6` only
   doubles multiplicities; it certifies nothing new about mass. Stripped of the
   "actual sector" framing, `Msec_least_eigenvalue` says "`B ⊕ B(−κ)` has the same
   least eigenvalue as `B`," a triviality.

**Exact remedy (either suffices; do both for full honesty):**

- **(a) Earn the identification.** Add and kernel-prove `Msec 2 1 = M6` for the
  *entire* concrete `6×6` carrier `M6` (all 36 entries, not merely the top block),
  so the "actual sector" claim is backed by a theorem rather than by definition.
- **(b) Downgrade the prose.** Replace "the honest 'physical sector' mass gap — of
  the actual 6-dimensional form, not just the 3×3 half-block" with an accurate
  statement, e.g.: "the mirror-doubled block-diagonal `B(λ,κ) ⊕ B(λ,−κ)` has the
  **same** least eigenvalue `λ−κ` as the single block `B`; the `6×6` spectrum is
  the block spectrum with doubled multiplicity, and the identification of this
  block-diagonal form with the concrete physical carrier is *assumed* (only the
  `3×3` top block is tied, at the point `(2,1)`)."

Everything else in the batch is CLEAN or self-disclosed MINOR: `ContinuumLimit`
is clean and correctly disclaims the unproven convergence theorem; `FockMassGap`'s
flagship gap is a genuine (honestly one-particle-equal) many-body statement and
its by-hand `Δ` seed is self-flagged; `MassSpacingPrediction`'s ratio = 1 is a
definitional tautology but its "honest boundary" scope section neutralizes the
over-claim.
