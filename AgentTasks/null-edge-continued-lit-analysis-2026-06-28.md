# Continued literature analysis for Gate C1 and D4 envelope

Date: 2026-06-28

Purpose:

```text
Continue analysis after the C246 strategy integration and Pro's D4 feedback,
with emphasis on what the surrounding literature says we should do next.
```

## Executive synthesis

The literature does not suggest replacing the tetrahedral scalar-Wilson overlap
path.  It supports it.

The strongest current reading is:

```text
Use overlap/Ginsparg-Wilson as the chiral-release engine.
Use the tetrahedral rank-4 lattice as the first free sign-kernel geometry.
Use D4/A4*/hyperdiamond literature as warnings, symmetry envelopes, and later
constraint sources.
```

The most important active theorem remains:

```text
H_tet(k)^2 >= c^2/a^2
```

on the rank-4 tetrahedral Brillouin torus.

## Source lanes reviewed

### 1. Overlap / Ginsparg-Wilson lane

Primary sources:

```text
Neuberger, Exactly massless quarks on the lattice, arXiv:hep-lat/9707022.
Luscher, Exact chiral symmetry on the lattice and the Ginsparg-Wilson relation,
  arXiv:hep-lat/9802011.
Hernandez-Jansen-Luscher, Locality properties of Neuberger's lattice Dirac
  operator, arXiv:hep-lat/9808010.
```

Program lesson:

```text
The chiral-release mechanism should be:
  Hermitian gapped kernel -> sign(H) -> GW Dirac operator -> GW projectors.
```

This supports the current C247/C243/C248/C249 ladder.

Important distinction:

```text
The free sign-kernel gap is a prerequisite.
Locality/admissibility is a later source-contract layer.
Determinant/anomaly is later still.
```

### 2. Hyperdiamond / four-dimensional graphene lane

Primary sources:

```text
Creutz, Four-dimensional graphene and chiral fermions, arXiv:0712.1201.
Bedaque-Buchoff-Tiburzi-Walker-Loud, Search for Fermion Actions on
  Hyperdiamond Lattices, arXiv:0804.1145.
Kimura-Misumi, Characters of Lattice Fermions Based on the Hyperdiamond
  Lattice, arXiv:0907.1371.
Drissi-Saidi, On Dirac Zero Modes in Hyperdiamond Model, arXiv:1103.1316.
```

Program lesson:

```text
Non-orthogonal / hyperdiamond geometry is delicate.
Minimal doubling, lattice symmetry, Lorentz-covariant excitations, and
fine-tuning constraints pull against each other.
```

This strongly supports:

```text
Do not import hypercubic intuition.
Do not assume tetrahedral geometry solves doubling by itself.
Do prove C244 and C243 directly.
```

### 3. Flavored mass / point-splitting overlap lane

Primary sources:

```text
Creutz-Kimura-Misumi, Index Theorem and Overlap Formalism with Naive and
Minimally Doubled Fermions, arXiv:1011.0761.
Related local Neo4j chunks on arXiv:1110.2482 and minimally doubled flavored
mass point-splitting.
```

Program lesson:

```text
Flavored/branch mass terms are legitimate overlap-kernel tools.
But they must be tied to species/doubler control, not used as arbitrary
phenomenological texture.
```

This supports:

```text
M_br = 0 by default.
C245 activates only if C243 or C249 gives a named residual branch/pole.
If activated, constrain M_br by symmetry and minimal degree/orbit.
```

### 4. A4* / exact lattice supersymmetry lane

Primary source:

```text
Catterall-Kaplan-Unsal, Exact lattice supersymmetry, arXiv:0903.4881.
```

Program lesson:

```text
High-symmetry non-cubic lattices can be valuable when exact algebraic symmetry
is the goal.
```

But:

```text
A4* is not evidence that D4 or hyperdiamond automatically solves Gate C1.
It is evidence that high-symmetry lattice geometry can be worth preserving in
later exact-structure layers.
```

This supports D4 as:

```text
symmetry/envelope lane;
triality/internal-structure lane;
not the current release lattice.
```

### 5. D4 / triality / 24-cell lane

Sources surfaced:

```text
Pro D4 response:
  L_H subset D4,
  [D4 : L_H] = 8,
  D4/L_H ~= (Z/2Z)^3,
  T_D4 -> T_LH is an 8-fold cover.

Triality sources:
  D4 / Spin(8) triality literature,
  24-cell and F4 root-system sources,
  local project triality/Furey/Baez files.
```

Program lesson:

```text
D4 is structurally real, not decorative.
But full D4 changes the primitive shift set and the Brillouin torus.
```

Therefore:

```text
D4 is an envelope, not the Gate C1 release lattice.
```

## Local Neo4j results

Neo4j chunk search for:

```text
D4 lattice triality root lattice 24-cell F4 octonion fermions
```

returned:

```text
hyperdiamond zero-mode sources;
triality/exceptions/Jordan sources;
Baez octonion survey;
project-local Furey/triality context.
```

Neo4j chunk search for:

```text
A4 star lattice exact supersymmetry Kahler Dirac no fermion doubling
```

returned:

```text
Kahler-Dirac fermion sources;
minimally doubled fermion sources;
hyperdiamond sources;
Nielsen-Ninomiya/minimal-doubling warnings.
```

Neo4j chunk search for:

```text
flavored mass overlap fermions species doublers point splitting Wilson kernel
```

returned:

```text
Creutz-Kimura-Misumi flavored mass / point-splitting / overlap sources;
single-flavor overlap from naive/minimally doubled kernels;
species identification in momentum space as a technical obstacle.
```

Interpretation:

```text
Our local graph already contains the relevant warning and support sources.
It does not contain an obvious "D4 lattice fermion solves Gate C1" source.
```

## Concrete program advances

### A. Mainline theorem pressure

The next Lean/theorem work should not branch further until C244/C247/C243
return.

The correct pressure order remains:

```text
C244:
  prove the rank-4 character torus / independent k_A theorem.

C247:
  prove the Euclidean/Hilbert sign-kernel convention.

C243:
  prove the global free gap.
```

If C243 succeeds:

```text
move immediately to C248/C249 integration and no-mirror-pole proof.
```

If C243 fails:

```text
extract the specific residual zero;
activate C245 only for that named failure.
```

### B. D4 theorem lane

The D4 lane should be mathematical and fenced:

```text
D4-1:
  prove L_H subset D4, index 8, quotient (Z/2Z)^3.

D4-2:
  prove dual/BZ cover T_D4 -> T_LH.

D4-3:
  classify causal type of D4 low shells under eta_phys.

D4-4:
  prove D4 sites plus only h_A shifts gives 8 disconnected copies.

D4-5:
  optional eight-null-vector lattice and branch theorem.

D4-6:
  D4-constrained M_br only if M_br has a proved need.

D4-7:
  triality/internal-sector audit, separate from doubler removal.
```

### C. Literature/source tasks

Recommended targeted source tasks:

```text
Lit-1:
  Full-text extract and source-map Creutz 0712.1201, Bedaque 0804.1145,
  Kimura-Misumi 0907.1371, and Drissi-Saidi 1103.1316 into a
  "non-orthogonal lattice warnings" note.

Lit-2:
  Full-text extract Creutz-Kimura-Misumi 1011.0761 and Adams staggered-overlap
  sources into an "M_br/flavored mass source contract" note.

Lit-3:
  Extract Hernandez-Jansen-Luscher 9808010 assumptions into a precise
  BackgroundGauge locality/admissibility source-contract checklist.

Lit-4:
  Extract D4/triality/F4/24-cell references into a D4 envelope bibliography,
  explicitly separated from the Gate C1 free proof.
```

## Potential new Aristotle jobs

Do not launch all of these immediately.  They are ready once current jobs
return or if queue capacity is intentionally expanded.

```text
C254:
  D4-1 inclusion/index/SNF Lean theorem.

C255:
  finite-volume parity theorem:
    pi corners exist iff lattice lengths in all tetrahedral directions are
    even.

C256:
  hyperdiamond warning audit:
    produce theorem-style stop rules comparing tetrahedral scalar-Wilson to
    Creutz/Bedaque/Kimura-Misumi.

C257:
  Hernandez-Jansen-Luscher source-contract API:
    define admissibility/locality assumptions needed for the BackgroundGauge
    layer.

C258:
  M_br source-contract audit:
    formalize "M_br only on a named proved branch/gap failure" as a project API.
```

## Key analysis conclusions

### 1. The project has a real free-kernel candidate

The combination:

```text
rank-4 tetrahedral lattice,
Euclidean Hermitian sign kernel,
scalar Wilson branch mass,
overlap/GW release,
```

is a credible first free Gate C1 model.

### 2. The risky part is now localized

The decisive open question is not vague:

```text
Does H_tet have a global gap on Hom(L_H,U(1))?
```

This is exactly C243.

### 3. D4 improves the research program but not the immediate proof

D4 gives:

```text
coset bookkeeping;
triality/F4/24-cell structure;
possible later M_br symmetry constraints.
```

But D4 also gives:

```text
extra sectors;
timelike/spacelike root steps;
an 8-fold torus cover;
a changed branch theorem.
```

Therefore D4 is not the active release lattice.

### 4. Hyperdiamond literature is mostly a warning label

Hyperdiamond/minimally doubled literature says:

```text
non-cubic geometry can be elegant,
but symmetry, minimal doubling, locality, and fine-tuning constraints are
subtle.
```

This reinforces the direct proof strategy.

## Recommended next actions

```text
1. Wait for C244/C247/C243 results.
2. Do not submit more M_br work until a failure appears.
3. Let C250 D4 audit complete.
4. Prepare C255 finite-volume parity theorem if C244 succeeds.
5. Prepare C257 BackgroundGauge source-contract API after C248/C249.
```

## Bottom line

The program is in a healthier state than before the overlap pivot:

```text
We are no longer searching for a chiral-release operator in the abstract.
We have a concrete free overlap kernel and a finite theorem ladder.
```

The main theorem stack now has a clear pass/fail point:

```text
C243 global free gap.
```

That is the hill to take next.
