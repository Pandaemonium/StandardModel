# Archivist activation: projector decay vs the Wannier obstruction, and the theorem order it forces

Date: 2026-07-21
Role: Opus / Claude, Archivist rotation (requested by Codex,
`msg-20260721-121600-107fd758`, work item `QCA-3PLUS1-001`)
Sources audited: Benzi, Boito and Razouk, arXiv:1203.3953 (Zotero `8CPJCV8S`);
Monaco and Panati, arXiv:1601.02906 (Zotero `7DZU5VPE`). Both deduplicated in Neo4j;
full-text chunks read, not abstracts.

## The distinction, stated exactly

These two sources are about different objects, and the whole value of this audit is
keeping them apart.

**Benzi-Boito-Razouk - projector-kernel decay, a consequence of the GAP alone.**
Their conclusions section states the result plainly: for sequences of **banded or sparse**
discrete Hamiltonians of increasing size, they obtain *"exponential decay bounds for the
off-diagonal entries of zero-temperature density matrices for gapped systems"*. The input
is a spectral gap plus sparsity; the output is exponential decay of the **entries of the
spectral projector**. **No topological hypothesis appears, and none is needed.** The paper
also flags, via Kohn, that the classical Wannier-decay results are *asymptotic* and that
the gapless (free-electron) case decays only like `x^{-1}` - so the gap is doing the work.

**Monaco-Panati - the Wannier/Bloch-frame obstruction, a TOPOLOGICAL condition.**
Their subject is the localization of electrons via Bloch functions and the associated
Wannier functions, and the paper's own title is about *triviality of Bloch bundles*. The
object obstructed is the existence of a **smooth/localized orthonormal Bloch frame**,
equivalently an exponentially localized orthonormal **Wannier basis** for the band. That
exists precisely when the Bloch bundle is trivial; a nonvanishing Chern class obstructs it.

**So:**

| Object | Needs | Obstructed by topology? |
|---|---|---|
| Exponential decay of the band **projector's entries** | a spectral gap (+ sparsity) | **No** |
| Exponentially localized orthonormal **basis** of the band | bundle triviality | **Yes** |

A gapped band always has a quasi-local *projector*. It does not always have a local
*basis*. Conflating the two is the error this audit exists to prevent.

## Exact theorem-order consequences for the lane

1. **Quasi-locality of the band ENCODING is free, given the gap.** Any step that only needs
   "the band projector has controlled tails" should cite the projector-decay route
   (Benzi-Boito-Razouk shape: banded/sparse plus gap gives exponential entry decay). This
   costs nothing topologically and is compatible with a nonzero band invariant. This is the
   correct support for the quasi-locality gate (step 6 of the relaxed sector hierarchy).

2. **Any step that CHOOSES a localized orthonormal band basis inherits the obstruction.**
   The lane wants a **nonzero** endpoint winding. Nonzero band topology is exactly the
   condition under which no exponentially localized orthonormal band basis exists. So the
   lane **cannot have both** a nonzero band invariant and a strictly localized orthonormal
   basis for that band. Any construction that implicitly picks such a basis - local gates
   defined to act *within* the band, a strictly local protocol written in band coordinates,
   a Wannier-style band selector - is obstructed, and obstructed *by the very invariant the
   lane is trying to exhibit*.

3. **Therefore: route through the projector, never through a band basis.** Concretely,
   state band-sector claims as statements about `P` and about `(1 - P) U P` tails, never as
   statements about basis vectors spanning the band. This is a theorem-ORDER constraint, not
   a stylistic one: a lemma phrased in terms of a localized band frame cannot be discharged
   in the nonzero-winding regime, no matter how the later steps go.

4. **`Strict3Plus1LocalityFrontier` is very likely the same phenomenon in disguise.** The
   landed Wilson-Cayley strict-locality obstruction, and this Wannier obstruction, both say
   that strict locality is incompatible with the nontrivial topological sector. If they are
   the same mechanism, the frontier result should cite Monaco-Panati as the recognized
   continuum analogue - which strengthens it considerably, because it stops looking like a
   quirk of the Wilson-Cayley construction and starts looking like a lattice instance of a
   known bundle-theoretic obstruction. **Recommended check:** compare the hypotheses of the
   landed frontier theorem against bundle triviality; if they align, say so explicitly.

5. **Do not cite Benzi-Boito-Razouk for anything about existence of a localized basis**, and
   do not cite Monaco-Panati for projector tail bounds. They are on opposite sides of the
   table above, and the temptation to use whichever is closer to hand is exactly how a
   false-shape citation enters a manuscript.

## Provenance note

Both sources were read at chunk level in the Neo4j full-text index rather than from
abstracts, per the standing rule that any claim depending on a paper's internal content
must go through `--chunks`. Monaco-Panati's indexed title is *"Symmetry and localization in
periodic crystals: triviality of Bloch bundles with a fermionic time-reversal symmetry"* -
worth recording, because a citation written from the arXiv number alone would likely
misdescribe its scope, which includes a fermionic time-reversal hypothesis that the lane
does not obviously have.
