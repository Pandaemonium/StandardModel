# Claude cross-family review: ChannelInformationSelectorClassification (686f31b0)

- Reviewer: interactive Claude Code (claude family)
- Builder: Codex (Aristotle 686f31b0)
- Source: `.../ChannelInformationSelectorClassification.lean` (331 lines),
  sha256 4a0f8aa3... verified
- Date: 2026-07-13

## Verdict: ACCEPT

An exemplary honest module: it proves the positive selector AND rigorously
prevents the overclaim. The intended reading (entropy/KL selects equal thirds
only relative to a NAMED prior; no prior-free absolute selector; equal thirds is
symmetry+uniqueness, not information; skew prior matches the asymmetric quadratic
selector) is matched declaration-for-declaration.

## Statement / prose alignment (exact declarations)

- **Positive prior-relative selector:** `entropy_maximizer_iff_equalThirds`
  (`H(p)=log 3 <-> p = 1/3`), `kl_uniform_zero_iff_equalThirds`
  (`KL(p||uniform)=0 <-> p=1/3`), `kl_uniform_eq_logCard_sub_entropy`
  (`KL(p||uniform)=log 3 - H(p)`, so min-KL-to-uniform and max-entropy are the
  SAME variational problem), `entropy_selector_eq_symmetric_quadratic` (coincides
  with every strictly-transverse symmetric quadratic selector).
- **Prior is load-bearing (honesty kill):** `skew_kl_minimizer_is_skew`
  (`KL(skew||skew)=0`), `equalThirds_not_kl_min_of_skew`
  (`0 < KL(uniform||skew)`, so equal thirds is NOT the minimizer for the skew
  prior), `skewPrior_eq_quadratic_selector` (the same `(6/11,3/11,2/11)` is BOTH a
  KL reference measure AND the `(1,2,3)`-weighted quadratic selector value -
  prior and metric are the same kind of extra structure), `skewPrior_ne_uniformThree`.
- **Deepest kill (separation from information):**
  `symmetric_unique_maximizer_is_equalThirds` - ANY permutation-invariant `f`
  with a unique fibre-maximizer selects the barycenter, with NO appeal to
  entropy/KL/concavity (proof: perm-invariance + uniqueness => `p o sigma = p`
  for all `sigma` => `p` constant => equal thirds). So the equal-thirds OUTPUT is
  not information-theoretic content; only the choice of prior is.
  `entropy_and_symmetric_quadratic_agree_at_barycenter` records the coincidence.
- **Escapes the translation no-go by breaking it:**
  `shannonEntropy_not_constant_on_fibre` (+ `skewShares_entropy_lt_uniform`
  strict-drop witness) - entropy is not zero-sum-shift-invariant, so it is not
  the constant selector `ChannelNaturalityNoGo.invariant_selector_constant`
  forbids; it selects only by using the affine/prior structure.

## Overclaim tests

- Vacuity: none. Nondegenerate witnesses are genuine: `skewShares = (1/2,1/4,1/4)`
  has strictly smaller entropy than uniform (`skewShares_entropy_lt_uniform`);
  `skewPrior != uniformThree`; `0 < KL(uniform||skew)`.
- Hollow telescoping: none. The module's core is the SEPARATION result
  (`symmetric_unique_maximizer_is_equalThirds`), a sharp anti-overclaim theorem,
  not a dressed triviality.
- Hidden assumptions: none. Nonnegativity / normalization / prior-positivity are
  explicit hypotheses on every rung.
- Prose-outruns-kernel: the reverse - the prose is scrupulous (prior-relative,
  not absolute; "information theory supplies no canonical decomposition on its
  own"). Kernel supports every clause.
- All advertised witnesses genuinely nondegenerate: yes.

## Independent verification

- Clean-path `lake env lean` replay: exit 0. The seven in-file `#guard_msgs`
  blocks fired; the guarded declarations pin `[propext, Classical.choice,
  Quot.sound]`. Only two cosmetic `unusedSimpArgs` lints (lines 101, 180) in
  machine-generated proofs; no errors, no `sorry`.

## Minor notes (non-blocking, optional at bank)

1. **Guard coverage.** Seven theorems are guarded, but a few
   (`entropy_selector_eq_symmetric_quadratic`, `skew_kl_minimizer_is_skew`,
   `entropy_and_symmetric_quadratic_agree_at_barycenter`, `skewPrior_ne_uniformThree`)
   are not. The guarded set covers the load-bearing claims; consider adding guards
   on the remainder for uniformity.
2. **Registry cross-check (forward-looking, not a defect here).** The
   CLASSIFICATION is the project's own (channel-selector program) and is not a
   QuantumInfo duplicate. But the underlying primitives it imports -
   `FiniteUniformMaxEntropy` (Shannon max-entropy) and `FiniteGibbsInequality`
   (classical Gibbs/KL) - should be audited against Mathlib and PhysLean's
   `QuantumInfo.Entropy.*` per `docs/EXTERNAL_LEAN_SOURCES.md` before further
   entropy primitives are banked. Classical finite Shannon entropy / KL may
   already exist upstream.

## Narrowest defensible claim

On the three-channel fixed-total fibre, maximum Shannon entropy (equivalently
minimum KL divergence to the NAMED uniform prior) has equal thirds as its unique
selected point; but this selection is prior-relative, not absolute (the skew
prior `(6/11,3/11,2/11)` selects itself, matching the `(1,2,3)`-weighted quadratic
selector), and the equal-thirds output follows from permutation symmetry plus
uniqueness alone - the only information-theoretic input is the choice of
reference measure. No prior-free / absolute information selector exists.
