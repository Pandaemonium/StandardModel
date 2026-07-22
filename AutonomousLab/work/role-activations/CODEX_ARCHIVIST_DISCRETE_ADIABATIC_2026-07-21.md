# Archivist delta: discrete adiabatic band transport for HNU

## Search question

Which existing results are closest to the missing HNU theorem: transport of a
gapped spectral band for a slowly varying discrete-time unitary, with enough
control to preserve a finite topological class and eventually discuss
quasi-locality?

## Primary-source anchors already in the graph

- Tanaka (2011), *Adiabatic theorem for discrete time evolution*, Zotero key
  `NJDPNUQ8`: the nearest direct theorem shape for slowly varying unitary
  products.
- Dranov, Kellendonk, and Seiler (1998), *Discrete time adiabatic theorems for
  quantum mechanical systems*, Zotero key `9FE77BVH`: foundational
  discrete-time adiabatic transport.
- Kato, *On the adiabatic theorem of quantum mechanics*, Zotero key
  `QSGUZTTP`: source of the intertwiner viewpoint; continuous time, so only the
  proof mechanism should be transferred.
- Jansen, Ruskai, and Seiler, *Bounds for the adiabatic approximation with
  applications to quantum computation*, Zotero key `RGV8P5X3`: explicit gap
  and derivative dependence in continuous time.
- Costa et al., Zotero key `32E6MCJA`: modern discrete-time adiabatic
  approximation context to compare assumptions and rates.

## Formal consequence of the search

The newly landed rotating-projector control rules out a proof based on
`sum_j ||P_(j+1) - P_j|| -> 0`: for a fixed nonzero path, the exact sum
`N sin(Theta / N)` tends to `Theta`, not zero.  The relevant literature should
therefore be mined for an intertwiner or summation-by-parts argument that keeps
phase cancellation before norms are taken.

## Search-derived theorem ladder

1. Define the HNU Cayley band projector on a compact arc-gapped domain.
2. Bound its first and second discrete differences.
3. Port a finite-dimensional discrete Kato intertwiner identity clean-room.
4. Prove leakage using cancellation and the quasienergy gap.
5. Convert endpoint operator error to the uniform sphere-map error required by
   the never-antipodal homotopy gate.
6. Search the quantum-walk bulk-edge literature for quasi-local functional
   calculus estimates before inventing a local projector API.

## Provenance and service note

The semantic Neo4j search ranked Tanaka and Dranov-Kellendonk-Seiler as the
closest matches.  A later console rendering failure on a Greek character did
not affect those hits.  Zotero's local MCP endpoint refused a connection during
this pass, so no metadata were written; the cited items were already present in
Neo4j/Zotero by stable key.

## Next archive action

Retrieve full-text chunks for the exact intertwiner definitions and error
bounds in Tanaka and Dranov-Kellendonk-Seiler, record theorem hypotheses and
normalizations, and attach a convention table to the HNU selector task before
the discrete adiabatic capstone is stated.
