Construction job (the deliverable is a new OBJECT, not proof golf). Build the
smallest CONNECTED cut-bearing Wilson slab lattice and prove its mirror-
coordinate holonomy factorization, so it can feed the existing reflection-
positivity ensemble bridge. This is the single highest-leverage missing object
in the Yang-Mills mass-gap program (per two independent strategy audits): it
gates genuine RP-LINK and the first PHYSICAL (non-toy) transfer operator.

START: read
`PhysicsSM/Draft/NullEdge/GateYM/WilsonCutPlaquetteEnsemble.lean`,
`PhysicsSM/Draft/NullEdge/GateYM/ReflectionCutPlaquetteFamily.lean`,
`PhysicsSM/Draft/NullEdge/GateYM/ReflectionCutPlaquetteExample.lean`,
`PhysicsSM/Draft/NullEdge/GateYM/WilsonCutPlaquettePositivity.lean`,
`PhysicsSM/Draft/NullEdge/GateYM/PlaquetteEnsemble.lean`, and the
`OrientedLattice` / `Plaquette` / `Reflection` core in the GaugeCore modules.
Check your module with `lake env lean <yourfile>`. If a broader `lake build`
stalls, SKIP it and return your best result as source + notes.

## The gap (exact)

`WilsonCutPlaquetteEnsemble.reflectionPositive_of_hol_factorization` already
proves: any finite plaquette family `P : K -> Plaquette L` whose mirror-
coordinate holonomies factor as

  `(P k).hol (config a c b) = e k c a * (e k c b)^-1`   (the `hhol` hypothesis)

has a reflection-positive genuine Wilson `PlaquetteEnsemble.weight`. The
existing `ReflectionCutPlaquetteFamily` feeds this, but ONLY with a
geometrically DISCONNECTED `K`-indexed disjoint union of the minimal 4-edge cut
plaquette. The audits identify the connected slab as the empty center of
gravity.

## Deliverable

A NEW module `PhysicsSM/Draft/NullEdge/GateYM/WilsonSlabConnected.lean` (or
similarly named) that:

1. **Defines the smallest CONNECTED cut-bearing lattice** - a `2x1` or `2x2`
   temporal slab across a reflection cut: two (or four) plaquettes SHARING at
   least one link across the cut, so the underlying graph is connected (unlike
   the disjoint family). Give its `OrientedLattice` (V, E, src, tgt), its
   `Reflection` (reflectV, reflectE, involutivity, the cut/positive-side
   predicate), and the mirror-coordinate parametrization `config a c b` where
   `c` is the cut-link data and `a`, `b` are the two mirror halves.
2. **Proves the connected slab's Wilson holonomies have the symmetric
   read-off form** `hol (config a c b) = e c a * (e c b)^-1` for an explicit
   `e : (cut-link) -> (half) -> G` (the M1/M3 holonomy factorization lemma).
   This is the one genuinely new proof: the shared cross-cut link must appear
   with opposite orientation in the two mirror halves so the `c`-dependence
   factors symmetrically.
3. **Instantiates `reflectionPositive_of_hol_factorization`** on this connected
   slab to obtain reflection positivity for its genuine Wilson
   `PlaquetteEnsemble.weight`, for arbitrary finite group `G` and unitary rep
   `rho`. State it as a named theorem `wilsonSlabConnected_reflectionPositive`.

## Constraints

- Keep the lattice genuinely CONNECTED - state and prove (or make evident by
  construction) that the plaquettes share a cross-cut link. If you can only
  achieve the shared-link connected geometry for the abelian `Z2`/`Fin 2` case
  first, do that and clearly mark the general-`G` version as the follow-on;
  a kernel-checked CONNECTED `Z2` slab with the factorization is already a major
  advance over the disconnected family.
- No new `a x i o m`, `s o r r y` (except a clearly-marked handoff on a residual
  sub-lemma if you cannot fully close the factorization), `n a t i v e _ decide`,
  or statement weakening. Reuse the existing `Plaquette`, `OrientedLattice`,
  `Reflection`, `wilsonKernel`, `PlaquetteEnsemble.weight` API - do not redefine
  them.
- Claim-label the module honestly: "finite identity / connected cut slab RP",
  draft-trust, and note in the docstring that RP for this connected ensemble is
  a LINK-symmetry / OS-ingredient result, NOT yet a transfer operator or a mass
  gap (that is the follow-on consumer).
- If `lake build` stalls, SKIP it and return the module source plus a note on
  what is proved vs residual. Do NOT spend the session on build latency.
