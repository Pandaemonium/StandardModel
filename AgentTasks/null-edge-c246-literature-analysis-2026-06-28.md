# Literature and analysis after C246

Date: 2026-06-28

Purpose:

```text
Integrate the C246 strategy result with a focused literature review around the
tetrahedral scalar-Wilson overlap path, hyperdiamond/non-orthogonal lattice
warnings, and the D4/A4 envelope question.
```

## C246 integration status

C246 returned a planning artifact, now copied to:

```text
AgentTasks/null-edge-c246-next-wave-queue-aristotle-2026-06-28.md
```

No Lean files were modified by C246.  The theorem ladder is:

```text
C244 lattice/BZ theorem
-> C247 Euclidean Clifford convention
-> C243 global free gap
-> C248 overlap/GW algebra
-> C249 free no-mirror-pole theorem
-> free model complete
-> reference import / BackgroundGauge / Quantum layers.
```

## Literature reviewed

### Neuberger overlap

Source:

```text
Neuberger, "Exactly massless quarks on the lattice", arXiv:hep-lat/9707022.
https://arxiv.org/abs/hep-lat/9707022
```

Role:

```text
Primary source for using a Wilson-Dirac operator with negative mass inside an
overlap sign construction.
```

Project impact:

```text
Supports using scalar Wilson as a branch-mass input to a Hermitian sign kernel.
This does not contradict the earlier scalar-Wilson no-go, because the no-go was
about direct chiral selection on the balanced origin kernel.
```

### Luscher / Ginsparg-Wilson

Source:

```text
Luscher, "Exact chiral symmetry on the lattice and the Ginsparg-Wilson
relation", arXiv:hep-lat/9802011.
https://arxiv.org/abs/hep-lat/9802011
```

Role:

```text
Primary source for exact lattice chiral symmetry from the GW relation.
```

Project impact:

```text
Validates C248 as an essential algebraic layer. The chiral release should be
stated in GW projector language, not as ordinary chirality of the raw finite
seed.
```

### Hernandez-Jansen-Luscher locality

Source:

```text
Hernandez, Jansen, Luscher, "Locality properties of Neuberger's lattice Dirac
operator", arXiv:hep-lat/9808010.
https://arxiv.org/abs/hep-lat/9808010
```

Role:

```text
Source contract for locality/admissibility of overlap kernels.
```

Project impact:

```text
Supports C246's layer split. Free overlap success does not automatically give
BackgroundGauge locality. Locality/admissibility belongs after the free gap and
GW algebra.
```

### Creutz four-dimensional graphene / hyperdiamond warning

Source:

```text
Creutz, "Four-dimensional graphene and chiral fermions", arXiv:0712.1201.
https://arxiv.org/abs/0712.1201
```

Role:

```text
Reference for four-dimensional graphene / hyperdiamond-like chiral lattice
fermions with two species.
```

Project impact:

```text
This is a warning source for non-orthogonal/tetrahedral branch geometry. It
supports C246's recommendation to prove the tetrahedral free theorem directly
rather than importing hypercubic Wilson intuition.
```

### Creutz-Kimura-Misumi flavored masses and overlap

Source:

```text
Creutz, Kimura, Misumi, "Index Theorem and Overlap Formalism with Naive and
Minimally Doubled Fermions", arXiv:1011.0761.
https://arxiv.org/abs/1011.0761
```

Role:

```text
Primary source lane for point splitting, flavored masses, Hermitian kernels,
spectral flow, and overlap built from nonstandard fermion kernels.
```

Project impact:

```text
Supports the C245 fallback concept if scalar Wilson fails, but also supports
the discipline that branch/flavored masses are species-control tools, not SM
flavor-texture knobs.
```

### Hyperdiamond zero-mode analysis

Source:

```text
Drissi and Saidi, "On Dirac Zero Modes in Hyperdiamond Model",
arXiv:1103.1316.
https://arxiv.org/abs/1103.1316
```

Role:

```text
Hyperdiamond / SU(5) analysis of four-dimensional lattice zero modes, with
Boriçi-Creutz and Karsten-Wilczek as special cases.
```

Project impact:

```text
Strengthens the warning that branch-zero locations are geometry-specific. If
we move from Lambda_tet to full D4 or an A4*/hyperdiamond-like lattice, C240
does not automatically transfer.
```

### A4* / exact lattice supersymmetry lane

Source:

```text
Catterall, Kaplan, Unsal, "Exact lattice supersymmetry", arXiv:0903.4881.
https://arxiv.org/abs/0903.4881
```

Role:

```text
Nearby evidence that non-cubic high-symmetry lattices such as A4* can be useful
when exact algebraic symmetries are central.
```

Project impact:

```text
Useful analogy for the D4/A4 envelope lane, not direct evidence for Gate C1.
It suggests high-symmetry lattice choices can be mathematically natural, but
each such choice needs its own branch/gap theorem.
```

## Local Neo4j chunk hits

Query:

```text
tetrahedral hyperdiamond overlap Wilson fermions Brillouin torus doubling
```

Top relevant chunks:

```text
arXiv:1011.0761:
  overlap formalism from naive/minimally doubled kernels; flavored mass terms;
  single-flavor overlap construction.

arXiv:2602.19767:
  minimally doubled fermions; Nielsen-Ninomiya pressure; KW and BC models.

arXiv:1006.2009:
  renormalization of minimally doubled fermions; Wilson-like parameter role.
```

Query:

```text
D4 lattice root lattice Brillouin zone fermions triality hyperdiamond
```

Top relevant chunks:

```text
arXiv:1103.1316:
  hyperdiamond zero-mode model; SU(5) symmetry; BC/KW zero modes.

arXiv:0712.1201:
  four-dimensional graphene and chiral fermions; non-cubic lattice zeros.
```

The local index did not surface a direct "D4 lattice fermion solves our
problem" source. D4 remains a parallel envelope/symmetry audit, not a mainline
proof replacement.

## Analysis

### 1. C246 is literature-aligned

The literature supports the C246 ladder:

```text
direct free tetrahedral theorem first;
overlap/GW algebra second;
gauge/locality/admissibility later;
determinant/anomaly later still.
```

This is not just claim discipline. It matches how the successful overlap
program is structured: a gapped Hermitian kernel first, exact GW symmetry next,
locality under admissibility after that, and anomaly/determinant-line work as
its own layer.

### 2. Hyperdiamond papers warn against shortcutting C244/C243

The hyperdiamond/minimally doubled literature repeatedly shows that branch
structure depends delicately on the reciprocal geometry and on how the Dirac
operator is soldered to lattice directions.

Therefore:

```text
Do not say "this is just Wilson in funny coordinates."
```

Instead:

```text
Prove the rank-4 character torus.
Prove the branch-zero theorem.
Prove the global free gap directly.
```

### 3. D4 is attractive but not mainline yet

D4 may be valuable because:

```text
it is a high-symmetry envelope around the Hadamard/tetrahedral basis;
it connects naturally to triality / Spin(8) / octonionic themes;
it may help later with symmetry completion or finite-volume structure.
```

But D4 probably changes:

```text
the translation lattice;
the dual torus;
the branch count;
the Wilson term;
the allowed shift set.
```

So D4 should remain:

```text
parallel envelope audit, not a replacement for Lambda_tet.
```

until C250 returns and until we are willing to redo C240/C243/C249 on the D4
torus.

### 4. The most important pending theorem is still C243

C244 removes the coordinate caveat, and C247 fixes the Hermitian convention,
but the decisive physics/mathematics test is:

```text
H_tet(k)^2 >= c^2/a^2
```

on the full tetrahedral torus.

If C243 succeeds, we have the first truly credible free C1 kernel. If C243
fails, the exact residual zero tells us whether C245 `M_br` is needed.

## Recommended immediate posture

```text
Wait for C244/C247/C243.
Do not submit more M_br work unless C243 or C249 gives a specific failure.
Let C250 continue as a parallel D4 audit.
Prepare the next prompt only after either:
  C243 succeeds, in which case ask for C248/C249 integration details;
  or C243 fails, in which case ask for the minimal branch-orbit M_br fix.
```

## Bottom line

The project is no longer flailing around C1.  It has a real candidate free
kernel and a literature-supported proof ladder.  The hard unknown is now very
sharp:

```text
Does the tetrahedral scalar-Wilson Hermitian kernel have a global free gap on
the correct rank-4 Brillouin torus?
```

That is exactly what the active C243/C244/C247 wave is designed to answer.

## D4 update from Pro

Pro's D4 response confirms the D4 lane as useful but non-mainline:

```text
L_H subset D4,
[D4 : L_H] = 8,
D4 / L_H ~= (Z/2Z)^3.
```

The dual tori satisfy:

```text
T_D4 -> T_LH
```

as an 8-fold cover, so the tetrahedral phases `k_A` are complete coordinates
only on the tetrahedral `L_H` torus.  On full D4 they have 8 possible
extensions.

Physics consequence:

```text
D4 with only h_A shifts gives 8 disconnected copies.
D4 with root shifts adds timelike/spacelike primitive steps.
Full D4 changes the branch theorem.
```

Therefore:

```text
D4 is an envelope, not the Gate C1 release lattice.
```

## Numbering correction

C246's returned document uses `C250` for the post-free reference-import job.
The live repo has already assigned `C250` to the D4 envelope audit.  To avoid
collision, use:

```text
C250:
  D4 envelope audit.

C251:
  post-free reference-import / transport cross-check.

C252:
  BackgroundGauge layer.

C253:
  Quantum anomaly / determinant-line layer.
```
