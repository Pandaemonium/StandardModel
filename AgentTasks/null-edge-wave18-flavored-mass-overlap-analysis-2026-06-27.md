# Wave 18 analysis: flavored mass / overlap as the Gate C center

Date: 2026-06-27.

Input: Claude analysis supplied in attachment `00c6e2d8-7310-4c63-8e9b-2e8641d2af24/pasted-text.txt`.

## Codex read

Claude's main correction is right: the null-Wilson scalar regulator is useful, but it should not become the whole story. The stronger literature-aligned construction is:

```text
flavored mass / point-splitting term
  -> Hermitian spectral-flow kernel
  -> overlap or projected physical operator D_phys
```

The scalar Wilson function

```text
W(q) = sum_a (1 - cos q_a)
```

should be treated as a global positivity/lifting lemma, not the central chiral object. Its value is that it can prove all non-origin real-torus zeros are lifted. But the Gate C release target needs the flavored-mass structure because that is what carries modified chirality, branch index, and the natural bridge to overlap/Ginsparg-Wilson constructions.

## Operating conclusion

The active Gate C target should be revised from:

```text
bare D_+ releases Gate C
```

to:

```text
bare D_+ is the null kinetic seed and is FATAL-FOR-NAIVE-FLAT;
Gate C can release only for a specified regulated/projected operator D_phys,
preferably built from a flavored mass / point-splitting / spectral-flow kernel,
with Wilson positivity as a supporting branch-lifting lemma.
```

## Wave 18 purpose

Wave 17 is already testing the null-Wilson regulator, placement, release API, gauge covariance, and ghost-safety clauses. Wave 18 should not duplicate those jobs. It should answer the next layer:

```text
What exact flavored-mass / spectral-flow / overlap construction should sit on top of the null-edge kinetic seed?
```

## Clauses to preserve

- Regulator coefficient `r` remains a modulus unless fixed by a later theorem.
- Overlap/locality requires a gap theorem; it is not automatic.
- Ghost-zero safety remains a hard release predicate.
- Gate A sign/grading audit remains binding for any `Gamma_s R`, `Gamma_f`, or flavored-mass placement.
- Furey/Baez remains Gate H/internal-sector support, not the main Gate C branch-control solution.
