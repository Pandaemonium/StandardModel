# Strategy / no-go: are generations a REPRESENTATION problem? (a finite family index) (P-F)

## Context (blind to the wider repo)

A finite null-edge Dirac program formalizes mass as null-direction disagreement on
finite carriers. It is careful NOT to fit lepton/neutrino mass values: a Koide-style
numeric route was killed, and cross-generation mass ratios are a *category error*
without a **family-replication index** and a **cross-carrier scale map**, neither of
which is derived.

The deep reframing to test: a "generation" is **not** a repeated particle with a
larger scalar mass. It is a *different irreducible way the same strand/charge data
sits inside the carrier category* — an inequivalent **null-coherence module**. In this
picture: electron/muon/tau share external charges (same strand occupancy) but differ
in mass because their null-direction bundles occupy different projective-coherence
modules; mixing matrices are overlap maps between modules; neutrino lightness is
natural if its modules sit near index-protected / reflection-pinned loci.

## Your task (the family index — the deepest and hardest frontier)

**Determine whether the finite carrier category forces a fixed number — ideally
exactly THREE — of inequivalent positive-sector completions for a given charge/strand
pattern.** Concretely:

1. **Define "module" and "inequivalence" precisely.** Fix a small charge/strand
   pattern (a fixed occupancy of the internal/Clifford data). Define the positive-
   sector completions of a carrier with that fixed external data, and the equivalence
   (unitary/similarity/gauge) under which two count as "the same generation."
2. **Count them.** Prove how many inequivalent positive-sector completions exist for
   the chosen pattern — is it forced to be a specific finite number? If a natural
   small carrier gives **exactly three**, that is the prize (a finite *why three
   generations* mechanism, not a fit). If it gives some other number, that is an
   equally important **[finding]** — it tells you the replication index is not yet
   forced and what extra data would fix it.
3. **Structural ratios, not values.** If multiple modules exist, characterize the
   *dimensionless* structural invariant distinguishing them (a within-category ratio),
   explicitly NOT an absolute mass. State what a cross-carrier scale map would have to
   supply to turn it into a physical ratio.

This is genuinely open and may be underdetermined; a rigorous "the framework does NOT
force three (here is why / here is the missing axiom)" is a valuable outcome, not a
failure. Do not fit any physical numbers.

## Constraints

Kernel-checked only for proofs: no `sorry`/`admit`/`native_decide`/new `axiom`;
footprint `[propext, Classical.choice, Quot.sound]`, guarded with in-file
`#print axioms`. Mathlib only. Deliver Lean file(s) + `ARISTOTLE_SUMMARY.md` with: the
precise module/inequivalence definitions, the count (with proof or a precise
obstruction), the distinguishing structural invariant, and an honest verdict on
whether "three generations" is forced, and if not, exactly what is missing.
