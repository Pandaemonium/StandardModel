# C164 — Gapped homotopy route: point-split null-edge kernel → reference overlap kernel

Job: design the concrete homotopy needed by C159 once `W_branch` is the point-split / flavored /
species mass of C155. Output below; the analytic and topological cores are formalized and built
s o r r y-free in `RequestProject/C164_GappedHomotopy.lean`
(namespace `PhysicsSM.C164`, a x i o ms: `propext`, `Classical.choice`, `Quot.sound`).

Operator architecture (from ROUND_CONTEXT):
`H_ne = Γ_K (D_ne + W_branch − m₀ R)`, `T_br = sign(H_ne)`, `D_ov_ne = ρ (1 + Γ_K T_br)`.

---

## 1. Reference kernel `H_ref` — recommendation

**Recommendation: the direct flavored-overlap reference, with the abstract block reference as a
proof scaffold — not as the primary target.**

Candidates considered:

| Candidate | Sector match to point-split `W_branch` | Risk |
|---|---|---|
| naive / **flavored-overlap** | direct: BZ-corner → branch grading is exactly the flavored-overlap species map (C155) | small sub-gap distance ⇒ cheap gap criterion |
| Adams staggered-overlap | needs a spin-taste reshuffle before corners line up | extra basis change inflates `‖H_ne − H_ref‖` |
| **abstract block reference** | tautological (define blocks = branches) | proves the *method*, defers the physics; cannot certify the species map alone |
| domain-wall boundary | matches index, but on a 5D enlarged space | dimension/identification mismatch; reserve as fallback |

Rationale: C155 already shows the point-split mass *is* a flavored mass mapping BZ corners to
null-edge branches and corner parity to branch grading. The flavored-overlap kernel is built from
exactly that species/flavor data, so `H_ne` and `H_ref` differ only by the sub-leading
point-splitting remainder — precisely the regime where the sub-gap criterion (§3) is cheap and
*honest* (a norm bound, not resemblance). Use the abstract block reference (§Lean, parametric `sig`)
only to validate the bridge mechanics; do the load-bearing certificate against the flavored-overlap
kernel.

## 2. Homotopy `H_t`

Straight-line (convex) homotopy:

```
H_t = H_ref + t · (H_ne − H_ref),   t ∈ [0,1],   H_0 = H_ref,  H_1 = H_ne.
```

Formalized as `PhysicsSM.C164.homotopy`, with `homotopy_zero`, `homotopy_one`,
`homotopy_continuous`. Continuity in `t` is what later transports a *discrete* invariant.

Why straight-line and not a fancier path: the gap criterion below needs only
`‖H_t − H_ref‖ ≤ t·‖H_ne − H_ref‖`, which the convex path satisfies with the tightest constant.
A curved path can only enlarge the excursion and the required gap margin.

## 3. Gap criterion (sufficient, uniform)

**Criterion.** If `H_ref` is uniformly gapped with gap `γ` (i.e. `γ·‖x‖ ≤ ‖H_ref x‖` for all `x`,
`γ > 0`) and the kernels are **sub-gap close in operator norm**

```
‖H_ne − H_ref‖ < γ,
```

then every `H_t`, `t ∈ [0,1]`, is uniformly gapped with the explicit residual gap

```
γ_t  ≥  γ − ‖H_ne − H_ref‖  >  0.
```

This is `PhysicsSM.C164.homotopy_uniformlyGapped` (proved). The bound is the elementary chain
`‖H_t x‖ ≥ ‖H_ref x‖ − |t|·‖(H_ne−H_ref) x‖ ≥ (γ − ‖H_ne−H_ref‖)‖x‖`. No spectral theory, no
self-adjointness, no resemblance — just the reverse triangle inequality and `|t| ≤ 1`.

`UniformlyGapped` is stated metrically (`γ·‖x‖ ≤ ‖T x‖`); for self-adjoint `T` this is exactly
"spectrum avoids `(−γ, γ)`", i.e. a gap at `0`. `gap_injective` records the no-zero-crossing
consequence used to keep the path inside the admissible (gapped) set.

## 4. Sector-signature preservation along the homotopy

**Statement.** Let `sig : (E →L[ℝ] E) → ℤ` be a sector signature that is **locally constant on the
gapped set** `GappedOp E` (this is the *imported* index/anomaly certificate, deliberately kept
separate). Then along any continuous path of gapped operators, `sig` is constant; in particular,
under the §3 hypotheses,

```
sig H_ref = sig H_ne.
```

Formalized as `sector_signature_preserved` (abstract path) and `homotopy_sector_preserved`
(the C164 bridge corollary). Proof is purely topological: `sig ∘ p` is locally constant on the
preconnected interval `[0,1]`, hence constant. The gap criterion supplies the membership
`H_t ∈ GappedOp E` that makes the path land in the domain where `sig` is locally constant.

**Certificate separation (constraint compliance).** The analytic content lives entirely in
`homotopy_uniformlyGapped`. The index content enters *only* through the hypothesis `hsig`
(local constancy of `sig` on the gapped set). They are never conflated: removing `hsig` leaves the
gap theorem intact, and removing the gap leaves `hsig` unusable because the path escapes the domain.
Locality/control is not touched here at all.

## 5. Finite checks / inequalities to make the Lean proof tractable

For the concrete flavored-overlap instantiation, the remaining obligations reduce to finite,
checkable data on the (finite-dimensional) branch ⊗ spinor ⊗ flavor space:

1. **Reference gap constant.** Produce `γ > 0` and prove `γ·‖x‖ ≤ ‖H_ref x‖`. On the finite space
   this is `γ ≤ s_min(H_ref)` (smallest singular value); a single `decide`/`norm_num` bound on the
   minimal eigenvalue of `H_refᵀ H_ref` suffices.
2. **Sub-gap distance.** A numeric bound `‖H_ne − H_ref‖ < γ`, i.e. `s_max(H_ne − H_ref) < γ`.
   This is the *only* place the point-splitting remainder size enters; it is one scalar inequality.
3. **Corner/branch dictionary (from C155).** Finite table: BZ corner ↦ branch, corner parity ↦
   branch grading, one-edge Pauli product ↦ `W_branch` sign. Checked by enumeration (`decide`).
4. **Index certificate `hsig`.** Either (a) reuse C161's bad-sector inverse-gap data to show the
   `J`-graded selection invariant is locally constant on the gapped set, or (b) supply the signature
   as a spectral-flow/η-invariant import and discharge local constancy on the gapped open set.
   This is the one genuinely external input.
5. **Self-adjointness of the path (optional strengthening).** If `H_ref`, `H_ne` are self-adjoint,
   `H_t` is too (convex combination), upgrading the metric gap to a spectral gap at `0`. A finite
   `Hermitian` check on the two endpoint matrices.

Items 1–3, 5 are finite/`decide`-able once the matrices are fixed; item 4 is the imported
certificate.

## 6. Direct flavored-overlap vs abstract block reference — first move

**Do the abstract block reference first as scaffolding, then commit to the direct flavored-overlap
reference for the load-bearing certificate.** Concretely:

- The abstract block layer is already proved here: `homotopy_sector_preserved` is parametric in
  `H_ref`, `H_ne`, `sig`. Nothing more is needed to validate the *bridge mechanism*.
- Instantiate it against the flavored-overlap kernel by discharging the five finite checks of §5.
  Keep `sig` and its local constancy (`hsig`) as a separate imported lemma so the anomaly/index
  certificate stays modular and reusable by C159.

---

## Failure cases and fallback path

- **`‖H_ne − H_ref‖ ≥ γ` (criterion fails).** The straight line may cross a gap closure. Fallbacks,
  in order: (i) tighten `H_ref` (better flavored-overlap fit) to shrink the difference;
  (ii) replace the single segment by a finite polyline `H_ref = K_0, K_1, …, K_n = H_ne` with each
  hop sub-gap, and chain `homotopy_sector_preserved` across hops; (iii) reweight (precondition) by a
  fixed invertible `M` so `M H_ne M⁻¹` is closer to `H_ref`, gap rescaled by `‖M‖‖M⁻¹‖`.
- **Gauge mixes branch `J` (C157).** Native gauge safety fails; the species map underlying
  `H_ref` is ill-defined. Fallback: domain-wall boundary reference (matches index in 5D) — at the
  cost of a dimension-identification certificate. Do not paper over with the abstract block
  reference, which would hide the failure.
- **`hsig` unavailable (no local-constancy of the signature).** The topological transport step is
  void even though the gap holds. Fallback: switch the imported invariant to a spectral-flow count
  and prove local constancy directly on the gapped open set; or restrict to the self-adjoint
  finite-dimensional case where the negative-eigenvalue count is provably locally constant on
  invertibles.
- **Endpoints not self-adjoint.** The metric gap still gives invertibility and injectivity
  (`gap_injective`), but "signature at 0" needs the spectral reading; fall back to the metric/
  index-only statement (`sig H_ref = sig H_ne`) without the eigenvalue-counting interpretation.

## Artifacts

- `RequestProject/C164_GappedHomotopy.lean` — `UniformlyGapped`, `homotopy`, `GappedOp`,
  `homotopy_uniformlyGapped` (gap criterion), `gap_injective`, `sector_signature_preserved`,
  `homotopy_sector_preserved` (bridge). Built s o r r y-free.
