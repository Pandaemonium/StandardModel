# Adversarial over-claim audit — S1-CC witness→general reduction (batch 5)

Scope: statements/docstrings only (kernel guarantees the proofs). One real `sorry`
exists: `physical_sector_b_eigenbasis_exists` (line 77). Everything else compiles.
Two vacuity claims below were mechanically confirmed in Lean.

---

## Per-theorem verdicts

### `S1CCGeneralReduction.compression_balanced` — CLEAN
Claim: "`J.submatrix r r` is balanced (`#pos = #neg`) for any Hermitian `J`,
any ±1 anticonjugating grading `d`, any `r : κ → ι`; no `Q_G` hypothesis."
- Not vacuous. The hypothesis `diagonal d * J * diagonal d = -J` forces, entrywise,
  `d_i d_j J_ij = -J_ij`, i.e. `J_ij = 0` on same-sign blocks and free on
  opposite-sign blocks — a genuinely nonempty class (the `6×6` witness is a
  nonzero member, see `witness_balanced_via_general`). The zero matrix also
  satisfies it (giving `0=0`), but the theorem holds for the whole class including
  nonzero `J`, so it is not "satisfiable only by the empty/zero matrix".
- `Q_G`-irrelevance is genuine: `Q_G` literally does not occur; `r` is arbitrary.
- Conclusion `card(pos)=card(neg)` is the real symmetric-spectrum statement.

### `S1CCGeneralReduction.compression_balanced_eigbasis` — CLEAN (one MINOR caveat)
Claim: "compression by an arbitrary `b`-eigenvector family `P` (`diagonal d * P =
P * diagonal e`) is balanced."
- Genuine strengthening, NOT secretly coordinate-restricted. The proof uses only
  the intertwining `hP` and `hB`; it never assumes `P` is a submatrix, never uses
  injectivity, and does not even require `Pᴴ P = 1`. The coordinate case is
  `P = (1).submatrix id r`, as the docstring says.
- Sign/transpose chain checked: `hLeft : diagonal e * Pᴴ = Pᴴ * diagonal d` is the
  correct conjugate-transpose of `hP` via `diagonal_pm1_conjTranspose` (a `±1`
  real diagonal is `ᴴ`-invariant); the `hAnti` calc is correct. No slip.
- MINOR (not a defect of this lemma, but load-bearing downstream): because it
  imposes NO rank / orthonormality / complement condition on `P`, it certifies
  nothing about *which* space is being compressed. All the "this is really the
  physical sector" burden is pushed onto the existence lemma. With `P = 0` it
  gives `0=0`. Fine as a general lemma; dangerous as the sole support of the prize.

### `S1CCGeneralReduction.compression_has_neg_eigenvalue` — CLEAN
Claim: "nondegenerate (`IsUnit det`) nonempty compression ⇒ a negative eigenvalue."
- Not circular. Contrapositive: no negative eigenvalue ⇒ (by `compression_balanced`)
  no positive either ⇒ all eigenvalues `0` ⇒ `det = ∏ eig = 0`, contradicting
  `IsUnit det`. Balance is used soundly, not assumed.

### `S1CCBalancedInertia.*` (engine) — CLEAN
`anticonj_charpoly_eq`, `hermitian_balanced_count_of_neg_charpoly` and helpers are
sound and carrier-agnostic (charpoly invariance under conjugation; a Hermitian
spectrum invariant under negation is balanced). Not the focus, but no over-claim.

### `S1CCWitnessAsInstance.witness_balanced_via_general` — CLEAN
Claim: "the `6×6` `(2,2,·)` witness count is a literal instance of
`compression_balanced`."
- Genuine instance. `bg_eq_diagonal` is an honest identity `σz⊗1 = diagonal dWitness`
  (checked entrywise), NOT a hand re-derivation of the count. The instance feeds
  the witness's OWN `bg_anticonj` (through `bg_eq_diagonal`) and never touches the
  specific `Q_G`. So the witness is genuinely not special to its coordinates.
  (Typechecks because `B := JQc.submatrix r r` and `IsHermitian.eigenvalues` is
  proof-irrelevant in its hermiticity witness.)

### `S1CCPresentationExistence.physical_sector_b_eigenbasis_exists` — LOAD-BEARING
Claim (docstring): "an orthonormal `b`-eigenbasis of a complement of `range Q_G`
in `ker Q_G` exists." Statement asks only: `∃ κ P e`, `e` is `±1`,
`diagonal d * P = P * diagonal e`, `Pᴴ P = 1`, `QG * P = 0`.
- **Vacuous as stated (verified in Lean).** Take `κ = Empty`, `P` the empty
  `ι×0` matrix: `Pᴴ P = 1` (empty identity), `QG * P = 0`, intertwining and the
  `±1` condition hold vacuously. The `sorry` is therefore unnecessary for the
  *stated* goal, and NONE of `hQGherm`, `hQGnil`, `hbQG`, `hd` is used.
- **Wrong (too weak) content.** The statement pins the columns of `P` only to
  `ker Q_G` (`QG*P=0`). It does NOT pin `range P` to a *complement of `range Q_G`
  in `ker Q_G`*, and does NOT pin `card κ = dim(V'/N)`. So the docstring's
  "complementary to `range Q_G` there" and "the physical sector `V'/N`" outrun the
  kernel: what is actually asked is "some orthonormal `b`-eigenfamily inside
  `ker Q_G`", which is strictly weaker.
- Remedy: (i) pin the dimension `Fintype.card κ = finrank(ker Q_G) − finrank(range Q_G)`
  (excludes `κ = Empty`); (ii) add complementarity, e.g. `range P ⊕ range Q_G =
  ker Q_G` (or an explicit `Pᴴ * QG = 0` plus a rank condition). Only then does `P`
  present `V'/N` rather than an arbitrary sub-family of `ker Q_G`.

### `S1CCPresentationExistence.physical_sector_balanced` — LOAD-BEARING
Claim (docstring): "the induced closure form on the physical Gauss sector `V'/N`
is balanced, for every scalar-metric `Q_G` — upgrading the crux to general **M**."
- **Vacuous as stated (verified in Lean), independent of the `sorry`.** The
  conclusion `∃ κ P hB, QG*P=0 ∧ PᴴP=1 ∧ #pos=#neg` is satisfied by `κ = Empty`
  (both filters empty ⇒ `0 = 0`). So even a fully honest discharge of the `sorry`
  does not make the *stated* prize non-vacuous.
- **Glue is sound, statement is not.** The reduction itself does not smuggle the
  conclusion: `(Pᴴ M P).IsHermitian` is derived correctly from `hM`, and balance is
  forwarded verbatim to `compression_balanced_eigbasis`. The defect is entirely in
  the under-specified `P` inherited from the existence lemma.
- **`ker Q_G` vs `V'/N`.** Even granting a genuine, correctly-dimensioned `P`, the
  statement pins `P` to `ker Q_G` (`QG*P=0`), NOT to a complement of `range Q_G`.
  So at best it certifies balance of `M` restricted to a `b`-eigen-subspace of
  `ker Q_G` — not balance on the quotient `V'/N = ker Q_G / range Q_G`.
- Remedy: same dimension+complementarity pin as above; and if the intended object
  is the quotient, either restate on `V'/N` directly, or add the descent fact that
  `range Q_G` lies in the `M`-radical of `ker Q_G` (`Pᴴ M applied to range QG = 0`)
  so that ker-inertia and quotient-inertia provably coincide.

---

## Sharp ruling: is "balanced on `ker Q_G`" the same as "balanced on `V'/N`"?

**No — they are distinct statements, and the Lean captures (at most) the `ker Q_G`
one while the docstrings assert the `V'/N` one.** Hermitian inertia is not additive
across a subspace-quotient in general: for a form on `W = ker Q_G` with subspace
`R = range Q_G`, `n±(W) = n±(W/R)` holds only when `R` contributes zero net
signature. `R` directions are `b`-invariant (because `b` commutes with `Q_G`), so
they too come in `±` pairs and removing them removes matched `±` — hence balance
*does* in fact hold on both `ker Q_G` and `V'/N`. So the manuscript's result is
mathematically **true**; the problem is that the Lean nowhere establishes the
descent (`range Q_G ⊆ M`-radical, or its balanced-pairing), never quotients, and
never even forces `span P = ker Q_G`. The identification "balance on `ker Q_G` =
balance on `V'/N`" is therefore *asserted in prose, not proved in the kernel*.

Consequently the manuscript claim — "the central crux closes to general **M** once
the existence `sorry` is filled" — is an **over-claim on two counts**:
1. As written, both the existence lemma and the prize are vacuous (`κ = Empty`), so
   filling the `sorry` is neither necessary nor sufficient to make the *stated*
   theorems say anything.
2. The honest remaining gap is the **stronger** "existence of a correctly-
   dimensioned orthonormal `b`-eigenbasis of a *complement of `range Q_G` in
   `ker Q_G`* (i.e. of `V'/N`)", plus the descent identifying ker-inertia with
   quotient-inertia — NOT the **weaker** "existence of some `b`-eigenfamily in
   `ker Q_G`" that the Lean actually asks for. The manuscript should say so.

---

## THE single most load-bearing finding

`physical_sector_balanced` (the "prize", grade-M claim) is **vacuous as stated**:
its conclusion is satisfiable by `κ = Empty` giving `0 = 0`, independently of the
`sorry`. Even after an honest `sorry`-fill it would certify balance only on a
`b`-eigen-subspace of `ker Q_G`, because `P` is pinned to `ker Q_G` but neither to
the dimension of `V'/N` nor to a complement of `range Q_G`. Hence the upgrade
"witness → general **M** once existence is transcribed" is over-claimed: the true
outstanding obligation is the stronger *dimension-pinned, `range Q_G`-complement*
`b`-eigenbasis existence (plus the ker→quotient descent), not the weaker ker-only
existence the statement currently encodes. (The underlying mathematics is
nonetheless correct — this is a statement/docstring defect, not a false theorem.)
