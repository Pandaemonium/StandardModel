# Summary of changes for run 3f9ac568-c4c1-4ad2-8b6e-d3db3d8ed571
Delivered a finite, rational, Mathlib-only Kraft bound reading "mass as compression cost" in `RequestProject/Main.lean` (namespace `KraftCompressionMass`), plus `ARISTOTLE_SUMMARY.md` with the required `kraft`-package (github: elazarg/kraft) provenance line. The package is a reference for provenance only and is not imported.

Model (all rational, no logs/transcendentals):
- `K l = ∑ᵢ (1/2)^{lᵢ}`, `codeK c = ∑ᵢ (1/2)^{|cᵢ|}`, `Hlin p = 1 - ∑ᵢ pᵢ²` (linear entropy = normalized mass²), and `PrefixFree c`.

Proved targets:
1. `kraft_inequality` — general forward direction: every prefix code satisfies `codeK c ≤ 1`, via the complete-tree leaf-packing argument (each length-ℓ codeword claims `2^{L-ℓ}` of the `2^L` leaves at the common length `L`; prefix-freeness ⇒ disjointness ⇒ `∑2^{L-ℓᵢ} ≤ 2^L`). The converse is referenced from the kraft package and shown concretely (`converse_construction`, `mixedCode`).
2. `expected_length_bound` — Shannon–Fano lower bracket `(1/2)^{lᵢ} ≤ pᵢ` gives `K l ≤ 1`; `shannon_fano_bracket` — two-sided dyadic bracketing gives the rational log-analogue `1 ≤ pᵢ·2^{lᵢ}` and `pᵢ·2^{lᵢ-1} < 1` (i.e. `lᵢ = ⌈log₂(1/pᵢ)⌉`, no `Real.log`).
3. `mass_is_compressibility` — for a distribution, `Hlin p = 0 ↔ ∃ i, pᵢ = 1` (pure/massless ⇔ zero linear entropy; mixed/massive ⇔ positive).
4. `compression_verdict` — packages the massless verdict `(1,0,0)` with the massive verdict `(1/2,1/4,1/4)` (Hlin = 5/8 > 0) coded by `mixedCode = (0,10,11)`, lengths `(1,2,2)`, `K = 1 ≤ 1`.

Non-degeneracy witnesses are all in-theorem rationals: `pure_witness_massless`, `mixed_witness_Hlin` (= 5/8), `mixed_witness_massive`, `mixedCode_prefixFree`, `mixed_kraft_eq`, `mixed_kraft_le`.

Constraints verified: builds successfully in well under 3 minutes; no `sorry`/`admit`/`native_decide`, no new axioms; every headline is guarded in-file by `#guard_msgs (whitespace := lax) in #print axioms _` showing exactly `[propext, Classical.choice, Quot.sound]`. Honest scope (linear entropy rather than Shannon entropy; general forward Kraft with a referenced/concrete converse) is documented in the file and summary. All work committed and pushed.

# claude-kraft-compression-mass — mass is a compression cost

A finite, rational, Mathlib-only formalization of a Kraft bound on the
null-direction message, reading **mass as compression cost**.

**Provenance.** This is a clean-room port in the *style* of the `kraft` Lean
package (github: elazarg/kraft), which is cited only as the reference /
provenance for the general Kraft inequality. It is **not** imported: the entire
development depends on Mathlib only.

All content lives in `RequestProject/Main.lean`, namespace `KraftCompressionMass`.

## Model (finite, rational — no logs/transcendentals)

- `K l = ∑ᵢ (1/2)^{lᵢ}` — Kraft sum of a length assignment `l : Fin n → ℕ` (ℚ).
- `codeK c = ∑ᵢ (1/2)^{|cᵢ|}` — Kraft sum of a concrete binary code `c : Fin n → List Bool`.
- `Hlin p = 1 - ∑ᵢ pᵢ²` — linear entropy = the (normalized) `mass²` invariant (ℚ),
  **not** the log/Shannon entropy.
- `PrefixFree c` — distinct symbols get codewords, neither a prefix of the other.

## Results

1. **`kraft_inequality`** (Target 1, general forward direction): every prefix code
   satisfies `codeK c ≤ 1`. Proof by the complete-tree *leaf-packing* argument: each
   codeword of length `ℓ` claims `2^{L-ℓ}` leaves among the `2^L` binary strings of
   the common length `L = maxᵢ|cᵢ|`; prefix-freeness makes these leaf sets disjoint,
   so `∑ 2^{L-ℓᵢ} ≤ 2^L`, i.e. `codeK c ≤ 1`. The converse (realizability of any
   `K ≤ 1` length assignment) is referenced from the `kraft` package and exhibited
   concretely in `converse_construction` / `mixedCode`.

2. **`expected_length_bound`** (Target 2): for a Shannon–Fano dyadic code with the
   lower bracket `(1/2)^{lᵢ} ≤ pᵢ`, the Kraft bound holds automatically
   (`K l ≤ ∑ pᵢ = 1`). **`shannon_fano_bracket`**: the two-sided bracketing
   `(1/2)^{lᵢ} ≤ pᵢ < (1/2)^{lᵢ-1}` gives the rational log-analogue
   `1 ≤ pᵢ·2^{lᵢ}` and `pᵢ·2^{lᵢ-1} < 1`, i.e. `lᵢ = ⌈log₂(1/pᵢ)⌉` with no `Real.log`.

3. **`mass_is_compressibility`** (Target 3, payload): for a distribution
   (`pᵢ ≥ 0`, `∑ pᵢ = 1`), `Hlin p = 0 ↔ ∃ i, pᵢ = 1`. Zero linear entropy ⇔ a single
   pure direction (massless, trivially compressible); positive ⇔ mixed (massive,
   needing genuine code length). So `mass²` = the irreducible mixedness = the
   compression-cost floor of the null-direction message.

4. **`compression_verdict`** (Target 4, package): bundles the massless verdict
   (`Hlin (1,0,0) = 0`, one full-weight symbol) with the massive verdict
   (`Hlin (1/2,1/4,1/4) > 0`, a prefix code `mixedCode` with `codeK ≤ 1`).

## Non-degeneracy witnesses (all rational, in-theorem)

- Pure: `p = (1,0,0)` → `Hlin = 0` (massless).
- Mixed: `p = (1/2,1/4,1/4)` → `Hlin = 1 - (1/4+1/16+1/16) = 5/8 > 0` (massive),
  with prefix code `mixedCode = (0, 10, 11)`, lengths `(1,2,2)`,
  `K = 1/2+1/4+1/4 = 1 ≤ 1` (`mixedCode_prefixFree`, `mixed_kraft_eq`, `mixed_kraft_le`).

## Honest scope

- Compression cost is measured by **linear entropy** (rational), not Shannon entropy.
- Target 1 proves the finite **forward** Kraft bound in full generality; the general
  converse construction is referenced from the `kraft` package and demonstrated
  concretely (`converse_construction`).

## Constraints met

- Kernel-checked only: no `sorry`/`admit`/`native_decide`, no new axioms.
- Footprint of every headline is exactly `[propext, Classical.choice, Quot.sound]`,
  verified in-file by `#guard_msgs (whitespace := lax) in #print axioms _`.
- Mathlib only (`kraft` package is reference-only, not imported).
- Rational + Nat + `Finset.sum`; builds in well under 3 minutes.
