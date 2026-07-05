# Aristotle proof job: Wilson-Dirac operator, gamma5-hermiticity, paired-flavor positivity (QMF4b)

Prove the three `s o r r y`s in `Qmf4bWilson/WilsonDirac.lean`. This is the
QMF4b rung of a lattice-QCD mass-formalism program, but the task is pure finite
linear algebra over Mathlib - a concrete finite matrix on a finite index type,
no analysis, no continuum. The proved Euclidean gamma matrices it builds on are
in `Qmf4bWilson/EuclideanGamma.lean` (all six Clifford/gamma5 lemmas already
kernel-checked - USE them, do not reprove).

Formatting: ASCII only, LF. Spaced escape-hatch tokens in prose.

BUILD: run `lake env lean Qmf4bWilson/WilsonDirac.lean` first (the file already
raises `maxHeartbeats`).

## The three targets

On the finite index `Idx L nc = (Fin 4 → Fin L) × Fin 4 × Fin nc` with the
concrete Wilson-Dirac matrix `wilsonDirac m U` and the lifted chirality `Γ5`
(both DEFINED in the file), for a UNITARY link field (`hU : ∀ mu x, (U mu x)ᴴ *
(U mu x) = 1`):

1. `gamma5_hermiticity : Γ5 L nc * wilsonDirac m U * Γ5 L nc = (wilsonDirac m U)ᴴ`
   - THE structural theorem, and the only genuinely hard one.
2. `det_wilsonDirac_real : (wilsonDirac m U).det.im = 0` - follows from (1):
   `Γ5^2 = 1` (needs a lemma `Γ5 * Γ5 = 1`, provable from `EuclideanGamma.γ5_sq`),
   so `det (Dᴴ) = det (Γ5 D Γ5) = det Γ5 * det D * det Γ5 = det D` (as
   `det Γ5 * det Γ5 = det (Γ5*Γ5) = 1`), while `det (Dᴴ) = star (det D)`
   (`Matrix.det_conjTranspose`); hence `star (det D) = det D`, i.e. `det D` real.
3. `pairedFlavor_det_nonneg : 0 ≤ ((det D)^2).re ∧ ((det D)^2).im = 0` - immediate
   from (2): a real complex number squared is real and `≥ 0`.

If proving (1) in full generality is too costly, it is acceptable to prove (2)
and (3) FROM (1) (leaving (1)'s `s o r r y`) and return (1) with maximal partial
progress - but (1) is the prize; try hard for it.

## How to prove gamma5-hermiticity (1)

Entrywise. Both sides are matrices on `Idx`; use `Matrix.ext` and expand
`(Γ5 * D * Γ5) I J` and `Dᴴ J I = star (D I J)` via `Matrix.mul_apply`,
`Matrix.conjTranspose_apply`, and the definitions. `Γ5` is diagonal in
site+colour and acts as `γ5` on the Dirac spin index, so `Γ5 * D * Γ5` at
`(x,s,c),(y,t,d)` equals `∑_{s',t'} γ5 s s' * D (x,s',c) (y,t',d) * γ5 t' t`
(site/colour deltas collapse the other sums). The mass term: diagonal, real,
commutes through `γ5` (use `γ5_sq`). The hop terms: use
`γ5 * (1 - γ_mu) * γ5 = 1 + γ_mu` and `γ5 * (1 + γ_mu) * γ5 = 1 - γ_mu`
(both from `EuclideanGamma.γ5_anticomm` + `γ5_sq`; note each `γ_mu` and `γ5` is
Hermitian, `EuclideanGamma.γ_herm`/`γ5_herm`), and the fact that `star` of the
forward-hop entry `(1-γ_mu) s' t' * (U mu x) c d` is the backward-hop entry seen
from the transposed index - the `star`/`conjTranspose` on the link matrix
supplies `(U mu x)ᴴ`, and the periodic shift `shiftUp`/`shiftDn` are mutual
inverses (`shiftDn mu (shiftUp mu x) = x`), which lines up the two hop
directions. The unitarity hypothesis `hU` may be needed to simplify a
`U * Uᴴ` if your expansion produces one; if not, it is a harmless extra
hypothesis (keep it in the signature regardless - the physical statement carries
it).

Helpful Mathlib: `Matrix.det_conjTranspose`, `Matrix.det_mul`,
`Complex.conj_eq_iff_im` (or `Complex.ext`/`Complex.conj_re`,`conj_im`), `star`
on `ℂ`, `Function.update` lemmas (`Function.update_same`, `update_noteq`,
`update_idem`) for the periodic-shift bookkeeping, `Finset.sum_comm`.

## Guardrails

- Keep the `wilsonDirac`/`Γ5` DEFINITIONS and the three theorem SHAPES
  unchanged (you may add helper lemmas/defs, e.g. `Γ5_sq : Γ5 * Γ5 = 1`,
  `shift` inverse lemmas). If you must adjust the operator definition to match
  the oracle, JUSTIFY it and confirm the oracle check (`L=2, nc=1, m=0.3`:
  gamma5-hermitian, det real) still holds.
- Do NOT weaken to a special case (fixed `L`, `nc=1`, abelian links) to make it
  provable. The theorems are for arbitrary `L` (with `[NeZero L]`), `nc`,
  unitary `U`.
- No `a x i o m`/`n a t i v e _ d e c i d e`/`s o r r y` in the final proof
  (one documented `s o r r y` on (1) allowed ONLY if you genuinely cannot close
  it after real effort, with (2)/(3) proved from it and the partial progress on
  (1) left in place).

## Output

1. Verdict: all three proved / (2)+(3) proved with (1) partial / blocked.
2. The complete `Qmf4bWilson/WilsonDirac.lean`.
3. If proved: `#print axioms` on the three is `[propext, Classical.choice,
   Quot.sound]`; `lake env lean` clean.
4. A short prose account of the gamma5-hermiticity computation (the hop
   forward/backward pairing) so a reviewer can check it independently.
