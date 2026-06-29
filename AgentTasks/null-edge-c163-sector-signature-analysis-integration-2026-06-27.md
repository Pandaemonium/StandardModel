# C163 — Sector-signature table for point-split `W_branch`

Gate C1 point-split import round. Companion to the verified Lean artifact
`RequestProject/C163_PointSplitSectorSignature.lean` (builds with no `s o r r y`; counting
facts are `decide`-checked). Scope is the **C155 point-split / flavored / species-mass
`W_branch`** family only — this does *not* re-do the broad C154 sector-signature audit.

Conventions follow ROUND_CONTEXT.md:
`H_ne = Γ_K (D_ne + W_branch − m0 R)`, `T_br = sign(H_ne)`,
`D_ov_ne = ρ (1 + Γ_K T_br)`. A **branch corner** is a Brillouin-zone / null-edge corner
`c ∈ {0, π}^d`, modeled in Lean as `c : Fin d → Bool` (`true` ↔ active "π"/doubler
component). The **level** `k = #{μ : c μ = π}` and its parity is the C155 branch grading
`J`.

---

## 1. Sector-signature table (point-split `W_branch`, `d = 4`)

The point-split mass sign is the **product of one-edge Pauli signs**
`s(c) = ∏_μ edgeSign(c_μ)`, with `edgeSign(0) = +1`, `edgeSign(π) = −1`. Verified in Lean
(`pointSplitMassSign_eq_pow`, `pointSplitMassSign_depends_only_on_parity`):

> `s(c) = (−1)^level(c)`, and therefore `s(c)` depends **only on the parity** of the
> level (the `J` grading), not on the level itself.

Compressed level-indexed table (one row per level; this is exactly the `#eval` output of
`signatureOf 1 (repCorner 4 k)` in the Lean file, i.e. the level-linear model with the
`m0 ∈ (0,2)` window). The `massSign` column is the *naive product mass*; the
`light` column is the physical/light label under the level-linear (Wilson/Adams) split.

| level k | corner ex. | J parity | product massSign `(−1)^k` | rank `C(4,k)` | light (m0∈(0,2)) | index contrib. |
|--------:|:-----------|:--------:|:-------------------------:|:-------------:|:----------------:|:--------------:|
| 0 | `(0,0,0,0)` | even (`false`) | `+1` | 1 | **yes** (physical) | `[placeholder]` |
| 1 | `(π,0,0,0)` | odd  (`true`)  | `−1` | 4 | no | `[placeholder]` |
| 2 | `(π,π,0,0)` | even (`false`) | `+1` | 6 | no | `[placeholder]` |
| 3 | `(π,π,π,0)` | odd  (`true`)  | `−1` | 4 | no | `[placeholder]` |
| 4 | `(π,π,π,π)` | even (`false`) | `+1` | 1 | no | `[placeholder]` |

Total corners `∑_k C(4,k) = 16 = 2^d` (full naive doubling). Index/anomaly entries are
deliberate placeholders (`indexContribution := 0` in Lean) — to be filled only by a
justified C159 reference import.

**Signature vector (naive product mass), grouped by sign of `s(c)`:**
`s = +1` on the even-parity class (levels 0,2,4 → `1 + 6 + 1 = 8` corners);
`s = −1` on the odd-parity class (levels 1,3 → `4 + 4 = 8` corners). Verified:
`negativeProductCount 4 = 8` (`decide`).

---

## 2. Mass-window analysis

We must compare *what determines the sign of `H_ne`* under the two W_branch families.

### 2a. Naive point-split product mass: a parity multiplet, not one Weyl sector

The naive product mass contributes `W_branch ∝ s(c) = (−1)^k`, taking only the two
values `±1`. After the constant subtraction `− m0 R` the corner effective mass is
`M·(−1)^k − m0`, which takes only **two** distinct values across all corners:

* even levels (0,2,4): `+M − m0`,
* odd levels (1,3):    `−M − m0`.

So **no choice of `m0` isolates a single corner**. Any `m0` that makes one parity class
negative makes that *entire* class negative:

* `−M < m0 < M` ⟹ the odd-parity class is negative → **8 negative sectors**;
* `m0 < −M`      ⟹ all 16 negative;
* `m0 > M`        ⟹ all 16 positive (no light sector).

This is the honest finding the round asked for: **the point-split product mass naturally
gives a `2^{d−1} = 8` taste multiplet of negative sectors, not one Weyl sector.** It
sign-straddles (C155), but the straddle is parity-resolved only.

### 2b. Fix: a level-linear (Wilson / Adams) term resolves levels

To single out one Weyl sector you need a term whose corner value is **monotone in the
level `k`**, not just in its parity. The standard Wilson term gives corner mass `2k`
(lattice units, `r = 1`); the effective mass is `2k − m0`, and a corner is light iff
`2k < m0`. This yields the clean, classic window structure (all `decide`-verified in
Lean for `d = 4`):

| `m0` window | light corners (cumulative `∑_{2k<m0} C(4,k)`) | Lean theorem |
|:-----------:|:---------------------------------------------:|:-------------|
| `(0, 2)`  | `1`  (k=0 only) → **single physical sector** | `lightCountWilson_four_window01` |
| `(2, 4)`  | `1 + 4 = 5`                                   | `lightCountWilson_four_window23` |
| `(4, 6)`  | `1 + 4 + 6 = 11`                              | `lightCountWilson_four_window45` |
| `(6, 8)`  | `1 + 4 + 6 + 4 = 15`                          | `lightCountWilson_four_window67` |
| `(8, ∞)`  | `16` (all)                                    | `lightCountWilson_four_window89` |

**Desired window:** `0 < m0 < 2` gives exactly **one** negative (light/physical) sector
at level 0 and `15` positive (heavy/"bad") sectors at levels 1–4. That is the target
"one negative physical sector, positive bad sectors" configuration.

**Conclusion for C160/C162:** the C155 point-split *product* mass must be **augmented by
a level-linear (Wilson-style) or Adams-style flavored term** before the mass-window
seed can produce a single Weyl sector. Pure product mass alone is sufficient for
sign-straddling but produces a multiplet and therefore needs an extra projector/flavor
factor (see §3) to descend from `2^{d−1}` to `1`.

---

## 3. Reference-match recommendation

References below are used **as pointers supplied in the job spec**; per the round
constraint, no specific anomaly/index numbers are imported from them here.

* **Naive / flavored-overlap (arXiv:1110.2482, arXiv:1011.0761).** These naive-fermion
  overlap constructions keep the full `2^d` corner content and use a *flavored* mass
  (taste matrix) to split the spectrum. They match our corner set exactly (`2^d`), and
  their flavored mass is the natural home for the parity-class structure we found: the
  product mass `(−1)^k` is the taste-`ξ5`-like part. Match quality: **good on the corner
  lattice and on the parity grading**, but the *taste-singlet* piece needed to resolve
  individual levels is exactly what the bare product mass lacks.

* **Adams-style flavored mass (staggered → overlap).** The Adams construction adds a
  flavored mass that splits the staggered tastes into resolved chiralities (a
  level/taste-dependent, not merely parity-dependent, splitting). This is precisely the
  level-linear resolving term identified in §2b. **Recommended reference match:** model
  `H_ref` as an **Adams-style flavored-overlap kernel** in which the C155 product mass
  supplies the parity (`ξ5`-type) factor and an added taste-singlet level term supplies
  the level resolution. This routes naturally into the C164 gapped-homotopy job.

* **Domain-wall boundary reference.** Equivalent index content via the 5th-direction
  boundary; viable but heavier than needed for a single-corner seed. Recommend only as a
  fallback if the flavored-overlap match fails to be uniformly gapped (C164).

**Recommendation.** Target the **Adams-style flavored-overlap kernel** as the C159/C164
reference, with the explicit understanding that the C155 product mass = the parity
(`ξ5`) factor and must be supplemented by a level-resolving taste-singlet term. Treat
naive-overlap (1110.2482 / 1011.0761) as the corner-lattice/grading template.

---

## 4. Lean-friendly `SectorSignature` API (specialized to point-split `W_branch`)

Implemented and building in `RequestProject/C163_PointSplitSectorSignature.lean`:

* `Corner d := Fin d → Bool` — branch corner (`true` ↔ active "π" component).
* `level c`, `cornerParity c` (= `J` grading) — branch level and parity.
* `edgeSign b`, `pointSplitMassSign c = ∏ μ, edgeSign (c μ)` — one-edge Pauli sign and
  the point-split product mass sign.
* `pointSplitMassSign_eq_pow`  : `pointSplitMassSign c = (−1)^level c`. **(proved)**
* `pointSplitMassSign_depends_only_on_parity` : it is a function of `cornerParity` only.
  **(proved — the multiplet obstruction)**
* `structure SectorSignature` with fields `level, parity, massSign, light, rank,
  indexContribution` (`indexContribution` is a placeholder `0`).
* `wilsonLevelMass`, `isLightWilson m0`, `lightCountWilson d m0`, `negativeProductCount d`
  — the level-linear model and the corner-count functions.
* `signatureOf m0 c` — builds a table row; `repCorner d k` — representative corner per
  level; `#eval` prints the compressed `d=4` table.
* Verified counts (`decide`): `negativeProductCount 4 = 8`, and the full `m0`-window
  table `lightCountWilson_four_window{01,23,45,67,89} = 1,5,11,15,16`.

All theorems use only `propext, Classical.choice, Quot.sound` (checked via
`#print a x i o ms` / verify).

---

## 5. Open blockers / failure modes

1. **Too many light sectors (confirmed, primary blocker).** The bare point-split product
   mass makes a whole `2^{d−1} = 8` parity class light. A single Weyl sector requires an
   added level-resolving (Wilson/Adams taste-singlet) term and `m0 ∈ (0,2)`. Until that
   extra factor is fixed in C162/C160, the seed is a multiplet, not one fermion.

2. **Wrong chirality / parity.** The product mass realizes the `J`/parity grading as
   `(−1)^k`, but the physical chirality of the surviving sector depends on the *sign
   convention of* `Γ_K` and on which parity class the window selects. Needs an explicit
   `Γ_K`-vs-parity convention check before claiming the level-0 sector is the
   left-handed/physical one.

3. **Gauge representation mismatch (C157 dependency).** The corner/branch factorization
   above assumes `SMActsInternally`: every gauge generator acts as `id_B ⊗ g_i` so it
   does not mix the branch `J` grading. If gauge mixes branch `J`, the parity columns of
   the table are not gauge-invariant and the signature vector is ill-defined.

4. **No clean reference match.** If the Adams-style flavored-overlap kernel cannot be
   put in a uniformly gapped homotopy with `H_ne` (C164), the reference match degrades;
   fallback is the domain-wall boundary reference, at higher cost.

5. **Index/anomaly placeholders unfilled.** All `indexContribution` entries are `0`
   placeholders. No anomaly/index claim is justified until a C159 reference import
   supplies real values; do not read the placeholders as a computed index.

6. **Dimension generality.** Counting facts are `decide`-verified for the physical
   `d = 4` only. General-`d` versions of the count windows (`∑_{2k<m0} C(d,k)`) are
   conjectured by the same argument but not yet proved as Lean theorems.
