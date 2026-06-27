# Wave 19 analysis: Gate C v4 regulator legality

Date: 2026-06-27.

Purpose: convert ChatGPT Pro's answer to hard problem 1 into focused Aristotle jobs.

## Pro verdict incorporated

A scalar Wilson factor

```text
W(q) = sum_a (1 - cos q_a)
```

is useful as a real-torus zero-lifting lemma, but it is not a Gate C release. If
`R(q)=O(q^2)` at the origin, then `D_+(q)+R(q)` has the same origin
linearization as `D_+`. Since C21 says the unprojected full four-component
origin/null branch is `Gamma_s`-balanced, such a regulator cannot turn the
surviving origin sector into a `Gamma_s`-pure Weyl sector.

The correct Gate C release object is therefore not:

```text
Wilson lifts all non-origin zeros, therefore Gate C is solved.
```

It is:

```text
A specified (R, G, Pin, Pout) construction lifts unwanted zeros and the remaining
origin tangent branch is G-pure.
```

Recommended grading:

```text
G_f = Gamma_s T
```

where `T` is a finite, Hermitian, local taste/branch involution. The later SM
internal grading may enter as:

```text
G_phys = Gamma_s T tensor chi_E.
```

But `Gamma_s tensor chi_E` alone cannot repair a kinetic spinor balance if the
kinetic operator factors as `D_+(q) tensor 1_E`.

## Wave 19 job purpose

Wave 17/18 already submitted Wilson positivity, flavored-mass strategy, spectral
flow API, locality/gap audit, and gauge-covariant point-splitting plans. Wave 19
adds the missing legal/failure layer:

```text
1. define RegulatorLegal / OriginWeylPure;
2. prove irrelevant regulators cannot repair balanced origin chirality;
3. prove internal grading alone cannot polarize external kinetic balance;
4. prove the finite Krein counterexample to non-circular overlap sign use;
5. search for or refute a concrete taste involution T that can polarize the
   C21 origin branch.
```

No Wave 19 job should claim Gate C release.
