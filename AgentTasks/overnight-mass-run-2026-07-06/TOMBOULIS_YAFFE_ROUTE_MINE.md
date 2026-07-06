# Mine: the Tomboulis-Yaffe RP mass-gap inequality (alternative to the KP crux)

**Source (added this cycle):** Kanazawa, *Generalizing the Tomboulis-Yaffe
Inequality to SU(N) Lattice Gauge Theories and General Classical Spin Systems*,
arXiv:0808.3442, Ann. Phys. 2009 (Zotero `K9FIBTZC`, in null-edge collection
`9W59V3K9`, tags mass-gap / reflection-positivity / strong-coupling). Chases the
original Tomboulis-Yaffe (1985) reflection-positivity mass-gap bound and extends
it from SU(2) to SU(N) and to general classical spin systems.

**Abstract core (verbatim intent):** by reflection positivity, "a system in a box
that is sufficiently insensitive to boundary conditions has a non-zero mass gap."
Strong-coupling expansion is then used to VERIFY the boundary-insensitivity
hypothesis. Illustrated in solvable models.

## Why this matters for lane C (the mine)

Our current end-to-end lane-C chain routes the gap through the
Kotecky-Preiss / Fernandez-Procacci **cluster-expansion convergence bound**
(`pairSum_le_expBound`, the Q6 crux) which has been PARKED after repeated
attempts (the labeled-tree exponential bound is genuinely hard in Lean). The
Tomboulis-Yaffe (TY) inequality is a **structurally different, cluster-expansion-
FREE route to the same conclusion** (positive finite-lattice gap for nonabelian
G), and its algebraic core looks closer to what we ALREADY have kernel-checked:

- We already have connected-slab **reflection positivity**
  (`WilsonSlabConnected.wilsonSlabConnected_reflectionPositive`).
- We already have the **RP -> Cauchy-Schwarz -> gap = -log(lambda_flux/lambda_0)**
  step abstractly, in `OSReconstruction` (`osSpectralGap`, `osSpectralGap_pos`)
  and the sector gaps (`SlabTransferGap`, `SlabSignRepGap`).

The TY inequality is exactly a reflection-positivity (Cauchy-Schwarz on the
reflected doubling) bound: it lower-bounds the gap by a **boundary-overlap /
boundary-condition-sensitivity** quantity, rather than by the convergence of an
infinite polymer sum. So the missing analytic input is NOT the KP tree bound; it
is a finite-box **boundary-insensitivity estimate**, which strong coupling
supplies and which (crucially) is a FINITE quantity on our finite slab.

## Concrete formalization target (candidate Aristotle job, lane C, KP-free)

Statement shape to attempt on the connected Z2 slab we already built:

> Given connected-slab RP and a boundary-overlap bound
> `|<reflected boundary state | interior state>| <= 1 - delta` with `delta > 0`
> (the finite-box "insensitivity to boundary conditions" input, itself a
> strong-coupling estimate), the reflected transfer form has a spectral gap
> `>= f(delta) > 0`, by the RP Cauchy-Schwarz doubling inequality alone.

This is independent of the parked KP crux (Codex's lane), does not collide with
the clustering jobs (`sm-clustering-slab`, `sm-clustering-to-gap`), and reuses
the RP + OS machinery already landed. The `charCoeff_abs_le_trivCoeff` /
`z2_trivCoeff_dominates` strong-coupling domination just committed in
`CharacterExpansion.lean` is a natural supplier of the `delta` bound in the
abelian/Z2 case (and, once the nonabelian dominance from the `sm-charexp-audit`
job lands, in the SU(2) case).

**Honesty caveat:** the precise TY inequality (constants, exact boundary
functional) is taken from the abstract + prior knowledge; the paper's full-text
body chunks are not yet in the chunk index (only the abstract embedded). Before
packaging the Aristotle job, pull the exact inequality either by chunk-indexing
0808.3442's body or by asking the `sm-charexp-audit` / next grand-strategy job to
surface the exact TY statement. Do NOT hard-code a constant from memory into a
Lean statement.

## Also surfaced this cycle (recorded, not yet ingested - DOI-only, no arXiv)

- Faizal-Shabir, *Reflection Positivity and a Finite-a Strong-Coupling Gap in
  Lattice SU(N) Yang-Mills: Part(1)*, DOI 10.1142/s0219887826501148 (Int. J.
  Geom. Methods Mod. Phys., 2026). Journal companion to the blueprint
  arXiv:2606.19362 (already in graph, DOI 10.1002/prop.70097).
- Faizal-Shabir, *Reflection-Positive Renormalization and the Persistence of the
  Mass Gap in Lattice SU(N) Yang-Mills: Part(2)*, DOI 10.1142/s0219887826501136.
  The step-scaling / gap-persistence-under-renormalization companion (NEW angle:
  the continuum-limit persistence argument). Worth reading for the lane-C
  "does the finite-a gap survive renormalization" question, which our finite
  theorem deliberately does NOT claim.
